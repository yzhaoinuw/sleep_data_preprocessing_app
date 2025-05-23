function [eeg, emg] = align_viewpoint_data(viewpointData, eegFrequency)
    emg = viewpointData(1,1:end);
    eeg = viewpointData(2,1:end);
    ttlPulse = viewpointData(3,1:end); % the actual pulse time series

    ttlPulseIndices = find(diff(ttlPulse>1*10^-3)==1);
    if isempty(ttlPulseIndices) % no ttl pulse implies no FP data recorded
        onsetEEGInd = 1;
    else
        ttlPulseTime = ttlPulseIndices/eegFrequency;
        ttlPulseTimeDiff = diff(ttlPulseTime);
        
        ttlPulseTimeGap = ttlPulseTimeDiff > 6;
        if isempty(find(ttlPulseTimeGap, 1))
            onsetEEG = ttlPulseTime(1);
        else 
            % this assumes the "full" setup option for ttl pulse, meaning
            % the ttl pulse was active throughout the fp recording
            onsetEEG = ttlPulseTime(find(ttlPulseTimeGap, 1)+1); 
        end    
        onsetEEGInd = round(onsetEEG*eegFrequency);
    end

    %Cutting EEG/EMG traces leading up to first TTL 
    % Removing first seconds of EEG and EMG raw traces to align with FP trace
    emg = emg(onsetEEGInd:end);
    eeg = eeg(onsetEEGInd:end);
    
end