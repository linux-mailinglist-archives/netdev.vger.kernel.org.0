Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFC53FC636
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241111AbhHaKov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 06:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238567AbhHaKou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 06:44:50 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A34EC061575;
        Tue, 31 Aug 2021 03:43:55 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id h1so30917173ljl.9;
        Tue, 31 Aug 2021 03:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NCyZges4LSfBygkjB5WR0itgY49P3E5xevDMIcceVSw=;
        b=TbaAt/f8GhDRt10oNppg6QI3MVQqA/zfWAnJYdBjBHyAthBQ4H3WbjIlWEfo9CeNQT
         GJWGCq8lEv7UTme0Kx/8MitQ+XZuVW+m8BC7ZwVqRmDw9pU64aZMVLZrft0ZyhdUDZRy
         nPHF/BV4MNxm60TtJLMr5uCvrFfgpA92rQP0el+BYhTFe2I1kJmmb2Pef3VXF2J5wK97
         HMkNAsPK1tp/QMZx3DS7NIvsDRdhPEwuje2er89BoyS38Ts7KWBg1h/4tSjpBvJOZVQ2
         h7bdLns+PA3bQIropTOxvbUEHsIb1ytBhNLXd/4umx6Abino9rYKO3KFMM/MbT8Tv+a6
         38Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NCyZges4LSfBygkjB5WR0itgY49P3E5xevDMIcceVSw=;
        b=a94A/dMYEG3SqoLLUbbwGKIy1GPQ1O/zOqTsh/EVB2GOonpvBK4yl1O1HWDniiwKjx
         3QmPwA3nexsym30OqR4uoP/AL3q2GCDVbdJPq/EUT4vD45vhwn2YR7b4ZpG6XahMK4kY
         O6HjI3UNkKhgYnjeLFszJQeI4qjEb/XAUJ4BEd9igCFcjMPq22spfCGRm6E/rdwgpVAs
         aci14Iyz7HKSCQ/p5YRsYEr7EYAMUiTj+ouKps3m1iwKB2EUmK5403BE6EwUnQHA2Ihx
         aElP0Ru1csA7pFegVjBH2qGde1GF8EO1iqanP79opISGQEs0FtWYxAqqULC0/sa7LSpD
         6nsA==
X-Gm-Message-State: AOAM530FY3DuFBuRYka+R8QQF1pDdzgNoIg2UwYM3eN1UTsySw58EItU
        X6QCjVNOpN5OdSs5682eWFYpZQP79k4=
X-Google-Smtp-Source: ABdhPJzqEA7GugBUX4eDLND3dXUloMtXUS1htfAi8jRxzVIAh+95KqQOtrbCJdi3ATwfBMq6KrG0Xw==
X-Received: by 2002:a2e:9915:: with SMTP id v21mr24522204lji.108.1630406633234;
        Tue, 31 Aug 2021 03:43:53 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id k23sm2147066ljg.73.2021.08.31.03.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 03:43:52 -0700 (PDT)
Subject: Re: [PATCH] net: ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, vasanth@atheros.com, senthilkumar@atheros.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org
References: <20210804194841.14544-1-paskripkin@gmail.com>
 <a490dcec-b14f-e8c8-fbb0-a480892c1def@gmail.com>
Message-ID: <4119f4fa-31b0-66bc-a0e2-373b2e1c449e@gmail.com>
Date:   Tue, 31 Aug 2021 13:43:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <a490dcec-b14f-e8c8-fbb0-a480892c1def@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/21 10:57 PM, Pavel Skripkin wrote:
> On 8/4/21 10:48 PM, Pavel Skripkin wrote:
>> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
>> problem was in incorrect htc_handle->drv_priv initialization.
>> 
>> Probable call trace which can trigger use-after-free:
>> 
>> ath9k_htc_probe_device()
>>    /* htc_handle->drv_priv = priv; */
>>    ath9k_htc_wait_for_target()      <--- Failed
>>    ieee80211_free_hw()		   <--- priv pointer is freed
>> 
>> <IRQ>
>> ...
>> ath9k_hif_usb_rx_cb()
>>    ath9k_hif_usb_rx_stream()
>>     RX_STAT_INC()		<--- htc_handle->drv_priv access
>> 
>> In order to not add fancy protection for drv_priv we can move
>> htc_handle->drv_priv initialization at the end of the
>> ath9k_htc_probe_device() and add helper macro to make
>> all *_STAT_* macros NULL save.
>> 
>> Also, I made whitespaces clean ups in *_STAT_* macros definitions
>> to make checkpatch.pl happy.
>> 
>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> ---
>> 
>> Hi, ath9k maintainer/developers!
>> 
>> I know, that you do not like changes, that wasn't tested on real
>> hardware. I really don't access to this one, so I'd like you to test it on
>> real hardware piece, if you have one. At least, this patch was tested by
>> syzbot [1]
>> 
>> [1] https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60
>> 
>> ---
>>   drivers/net/wireless/ath/ath9k/htc.h          | 11 ++++++-----
>>   drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
>>   2 files changed, 8 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
>> index 0a1634238e67..c16b2a482e83 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc.h
>> +++ b/drivers/net/wireless/ath/ath9k/htc.h
>> @@ -326,11 +326,12 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
>>   
>>   #ifdef CONFIG_ATH9K_HTC_DEBUGFS
>>   
>> -#define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
>> -#define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
>> -#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
>> -#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
>> -#define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
>> +#define __STAT_SAVE(expr)	(hif_dev->htc_handle->drv_priv ? (expr) : 0)
>> +#define TX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
>> +#define TX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
>> +#define RX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
>> +#define RX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
>> +#define CAB_STAT_INC		(priv->debug.tx_stats.cab_queued++)
>>   
>>   #define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
>>   
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> index ff61ae34ecdf..07ac88fb1c57 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> @@ -944,7 +944,6 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
>>   	priv->hw = hw;
>>   	priv->htc = htc_handle;
>>   	priv->dev = dev;
>> -	htc_handle->drv_priv = priv;
>>   	SET_IEEE80211_DEV(hw, priv->dev);
>>   
>>   	ret = ath9k_htc_wait_for_target(priv);
>> @@ -965,6 +964,8 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
>>   	if (ret)
>>   		goto err_init;
>>   
>> +	htc_handle->drv_priv = priv;
>> +
>>   	return 0;
>>   
>>   err_init:
>> 
> 
> Added missing LKML in CC. Sorry for confusion.
> 
> 
Any chance to review this patch? Thanks




With regards,
Pavel Skripkin
