Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72C8410CA5
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhISR3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhISR3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 13:29:38 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04C7C061574;
        Sun, 19 Sep 2021 10:28:12 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id i25so57389448lfg.6;
        Sun, 19 Sep 2021 10:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=d1V/T6I63dgWID96AdEFBwcnoAH1tDpRE1zhAQhisV8=;
        b=qH4WrDgjsd3o++jLlibvP+gBcyuuaKDRhatsti2JGqbORZw6hSqbDAgq9/joxSPBdV
         PrNw/+BXSB27Vo5w+ZrDx/pgj5GUdR0T5B2IQJK0RuIak0RVKSfDbudTvVdBTe+ngMRJ
         opUtgcI//kEcT47wIuia//BbRNG0KODfhfXolmSXsas9PUeIBsVPf5VkL3Wxi0z1RoLq
         8l81kVXxdYXMOfACq/UKcwQgnNhEE4HoxSXHBsKT5csPbhYTsH/e2OnDvO7DNc00uaQK
         cGhucFzy0r7oOmcKn+IvEtth+FjxDjrKSZRupMJjxs3xH0zuMV8iU1csWiIGLVXavN4w
         taXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=d1V/T6I63dgWID96AdEFBwcnoAH1tDpRE1zhAQhisV8=;
        b=tENeE4gctFIIWLp5GvuNNIT2CMI+4HLjqdHxNbLfE/HtznD5vaWR1toY0W5rMy3uLl
         BqMfhlCEaaBCMc94i/2JqGBMXxF198eJ/Vvh2YjopGWyGv/XJvoNBjoFmvVxHCUhHaHe
         feRrKSSrEjmjohHtzQtDLrqVJ42RQWAc/XRY2RbiDdvvCxzeWOQD4gsJLFbzgXeIUw4X
         qOHPUZzzT75WFT21+pMuikfTPSk+pAjsXU0dlbLzA1iCPoDdSJOkcl3MDBfUCjdSmDiN
         /SJtIRnRjx2rWNQQ97IYPbZjvpxlnRCZI6kd5LCO1ZPdEZRbje6FfoaWU6xRefkEnwWi
         onvA==
X-Gm-Message-State: AOAM533bAHnahVZ9bGeTkWy0YzMii1eO0qE8qGfWvOIx3y6LSCwvEUX1
        w3PFqoigmh+K4Id+R79f6JS+Bu0/N2S/pg==
X-Google-Smtp-Source: ABdhPJwDKpmUGrmvuR1puPmk452poMpo691oITQ2iyaD5Q7/OQGOtjjCWYhNpmhYT7ayScDWl/RffQ==
X-Received: by 2002:a2e:f01:: with SMTP id 1mr13811752ljp.204.1632072490763;
        Sun, 19 Sep 2021 10:28:10 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.49])
        by smtp.gmail.com with ESMTPSA id t6sm306038lji.109.2021.09.19.10.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Sep 2021 10:28:10 -0700 (PDT)
Message-ID: <4e1374b1-74e4-22ea-d5e0-7cf592a0b65b@gmail.com>
Date:   Sun, 19 Sep 2021 20:28:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] net: ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Content-Language: en-US
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, vasanth@atheros.com, senthilkumar@atheros.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org
References: <20210804194841.14544-1-paskripkin@gmail.com>
 <a490dcec-b14f-e8c8-fbb0-a480892c1def@gmail.com>
 <4119f4fa-31b0-66bc-a0e2-373b2e1c449e@gmail.com>
In-Reply-To: <4119f4fa-31b0-66bc-a0e2-373b2e1c449e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/21 13:43, Pavel Skripkin wrote:
> On 8/4/21 10:57 PM, Pavel Skripkin wrote:
>> On 8/4/21 10:48 PM, Pavel Skripkin wrote:
>>> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
>>> problem was in incorrect htc_handle->drv_priv initialization.
>>> 
>>> Probable call trace which can trigger use-after-free:
>>> 
>>> ath9k_htc_probe_device()
>>>    /* htc_handle->drv_priv = priv; */
>>>    ath9k_htc_wait_for_target()      <--- Failed
>>>    ieee80211_free_hw()		   <--- priv pointer is freed
>>> 
>>> <IRQ>
>>> ...
>>> ath9k_hif_usb_rx_cb()
>>>    ath9k_hif_usb_rx_stream()
>>>     RX_STAT_INC()		<--- htc_handle->drv_priv access
>>> 
>>> In order to not add fancy protection for drv_priv we can move
>>> htc_handle->drv_priv initialization at the end of the
>>> ath9k_htc_probe_device() and add helper macro to make
>>> all *_STAT_* macros NULL save.
>>> 
>>> Also, I made whitespaces clean ups in *_STAT_* macros definitions
>>> to make checkpatch.pl happy.
>>> 
>>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>>> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
>>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>>> ---
>>> 
>>> Hi, ath9k maintainer/developers!
>>> 
>>> I know, that you do not like changes, that wasn't tested on real
>>> hardware. I really don't access to this one, so I'd like you to test it on
>>> real hardware piece, if you have one. At least, this patch was tested by
>>> syzbot [1]
>>> 
>>> [1] https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60
>>> 
>>> ---
>>>   drivers/net/wireless/ath/ath9k/htc.h          | 11 ++++++-----
>>>   drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
>>>   2 files changed, 8 insertions(+), 6 deletions(-)
>>> 
>>> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
>>> index 0a1634238e67..c16b2a482e83 100644
>>> --- a/drivers/net/wireless/ath/ath9k/htc.h
>>> +++ b/drivers/net/wireless/ath/ath9k/htc.h
>>> @@ -326,11 +326,12 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
>>>   
>>>   #ifdef CONFIG_ATH9K_HTC_DEBUGFS
>>>   
>>> -#define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
>>> -#define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
>>> -#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
>>> -#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
>>> -#define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
>>> +#define __STAT_SAVE(expr)	(hif_dev->htc_handle->drv_priv ? (expr) : 0)
>>> +#define TX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
>>> +#define TX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
>>> +#define RX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
>>> +#define RX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
>>> +#define CAB_STAT_INC		(priv->debug.tx_stats.cab_queued++)
>>>   
>>>   #define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
>>>   
>>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>>> index ff61ae34ecdf..07ac88fb1c57 100644
>>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>>> @@ -944,7 +944,6 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
>>>   	priv->hw = hw;
>>>   	priv->htc = htc_handle;
>>>   	priv->dev = dev;
>>> -	htc_handle->drv_priv = priv;
>>>   	SET_IEEE80211_DEV(hw, priv->dev);
>>>   
>>>   	ret = ath9k_htc_wait_for_target(priv);
>>> @@ -965,6 +964,8 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
>>>   	if (ret)
>>>   		goto err_init;
>>>   
>>> +	htc_handle->drv_priv = priv;
>>> +
>>>   	return 0;
>>>   
>>>   err_init:
>>> 
>> 
>> Added missing LKML in CC. Sorry for confusion.
>> 
>> 
> Any chance to review this patch? Thanks
> 
> 

gentle ping one more time :) Thanks





With regards,
Pavel Skripkin
