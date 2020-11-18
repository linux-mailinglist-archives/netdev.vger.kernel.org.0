Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E9B2B73FE
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgKRB4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgKRB4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:56:19 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB16EC061A48;
        Tue, 17 Nov 2020 17:56:19 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id d17so134184plr.5;
        Tue, 17 Nov 2020 17:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ewNH1d//8s37LLtDOmCoW18BcjM3+IXdKM9BEe6crjo=;
        b=XiHEdcyaht/j7tV+haGdC9gNAC0EYFh1WxvJTl4/Le/0KWre2iqBhIC5V90nUAXYyV
         Wh/h62eEjuL3GY+SuvKA/4xCUC9TrrGLrBdFUpLSDyjOVyiJnrVLBJpJiz5aEGq3jdEp
         Di2oMp9b3Bm+64ckmbYYGL5dOZA4c9AMZBBjmJ5Zka6I00tPxKLHwv9mftEI/lURjscq
         dEy71McNr/01CWyDp6Gp7qt5SISCQ5Kdh3r2+9ykERY8ei0GNo9tnbBL/dMipq+FXmYP
         ODjbseXkTwNjBoWphd/oQkdb1TbnpqD8lUeTMW7jfE6c1+NRfOf/OnJzyAFNuddQ4nHT
         AV+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ewNH1d//8s37LLtDOmCoW18BcjM3+IXdKM9BEe6crjo=;
        b=Gyib/EmQV7nULyfsgE6p57/IuBR7D/HdJxznLp8nIIBpoMw7XtKdmnUB2eRZMQhA0s
         YSRA8QcdfKKP+M8GU9X26WUlB8EEtfaqiO/mk8ln0q5FEieOtmqo1kABMb5leLJpOpu5
         J41rUI5iK9yg4CzGmaZErBj9YTPArOEqhBDVk784pnIt1hD58/nCkRwFP0NoDao6kzqp
         YRFvX29dk7EFwGFe1Dn3UoHdKyeaMZnRiGNg2XIUAYX8FsdKZ6+WRZ9Ap5+VJZsUCk1C
         b4QnnWBQqC8Sm20rdW7ey3nWYWmCtCjT9Im6RP8E4zsLeHPSbVMKU1BNkfR14mNYFbLd
         TxPA==
X-Gm-Message-State: AOAM533NZZlHlmGNqzSiJkd9VNh2jIbMyDfjuzRcaF5J12i6dAEvCarU
        TQ4dkzwj8X8yeRoewjFe2+Iu6PImz69NtA==
X-Google-Smtp-Source: ABdhPJz6PJFCFVWh9n++tchfQwuF1EGvrHPc14gxh1n9kovjouFv7PwICIV1jyLROSexda3X9xuLaA==
X-Received: by 2002:a17:902:402:b029:d9:1d4:1c88 with SMTP id 2-20020a1709020402b02900d901d41c88mr2317580ple.16.1605664578982;
        Tue, 17 Nov 2020 17:56:18 -0800 (PST)
Received: from [10.143.0.70] ([45.56.153.64])
        by smtp.gmail.com with ESMTPSA id ha21sm400149pjb.2.2020.11.17.17.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 17:56:18 -0800 (PST)
Subject: Re: [PATCH] rtl8192ce: avoid accessing the data mapped to streaming
 DMA
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        straube.linux@gmail.com, Larry.Finger@lwfinger.net,
        christophe.jaillet@wanadoo.fr, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201019030931.4796-1-baijiaju1990@gmail.com>
 <20201107114412.4BEEAC433C9@smtp.codeaurora.org>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <d6104236-f6e6-b42b-eb83-400bc34f17d6@gmail.com>
Date:   Wed, 18 Nov 2020 09:56:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20201107114412.4BEEAC433C9@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/7 19:44, Kalle Valo wrote:
> Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>
>> In rtl92ce_tx_fill_cmddesc(), skb->data is mapped to streaming DMA on
>> line 530:
>>    dma_addr_t mapping = dma_map_single(..., skb->data, ...);
>>
>> On line 533, skb->data is assigned to hdr after cast:
>>    struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
>>
>> Then hdr->frame_control is accessed on line 534:
>>    __le16 fc = hdr->frame_control;
>>
>> This DMA access may cause data inconsistency between CPU and hardwre.
>>
>> To fix this bug, hdr->frame_control is accessed before the DMA mapping.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Like Ping said, use "rtlwifi:" prefix and have all rtlwifi patches in
> the same patchset.
>
> 4 patches set to Changes Requested.
>
> 11843533 rtl8192ce: avoid accessing the data mapped to streaming DMA
> 11843541 rtl8192de: avoid accessing the data mapped to streaming DMA
> 11843553 rtl8723ae: avoid accessing the data mapped to streaming DMA
> 11843557 rtl8188ee: avoid accessing the data mapped to streaming DMA
>

Okay, I have sent v2 patches just now.
Please have a look, thank :)


Best wishes,
Jia-Ju Bai
