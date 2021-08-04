Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5346A3E0911
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 21:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240782AbhHDT5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 15:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240707AbhHDT5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 15:57:35 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C95C0613D5;
        Wed,  4 Aug 2021 12:57:22 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id b6so6401184lff.10;
        Wed, 04 Aug 2021 12:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xJMFgRgXpJpT/vtaAvP3090/A5AAs0szhBD8RPLBxs0=;
        b=l7aEb9lETEJ46q8/Za/M1ROJ6TuZhmaPHDgmwucebNCdMH93+BaSoKpR8ARomPiMil
         hy5oGKzgrpT6TUz5lz80hKIbWZ4n7kG/4ljTFI2qbVeg2gcA4GuKi5r38x15ZvG1GJ3j
         hqkJnT0ARUkPQD0TY6yqTejdNvazDqORA8NNxJFxnx9pgO1KJq6LaitwTqnqfEr0eq3b
         nXTyyjzqryRDoyNhiDcbFpAvkYvd72o3ETWEcHo3jVJKaYyoMeO8pj018jizumgVbp14
         vy9VRwWMlfMLPjMssHK7vptqBqf57knvIXt134yRNtXtSxCM0FeKKW1OGvKUkJBYu16j
         pDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xJMFgRgXpJpT/vtaAvP3090/A5AAs0szhBD8RPLBxs0=;
        b=clM9p+NsZU94eIw1c0Kiq5lE5oNLAP5FdE/Zwq54KRvTRZRRUzIZbbG1G3NTlTwi6t
         3lrncmjExgarMONISIosHAm8xSG4CAn7+7GSD6y9h0M59tMzXVx4C5ywMXJQn3JBMDoi
         JbNEkWLCCXBdUUtzSnj7cbJ+QsCzL2YpkEgyJt0kouM53yN6e9E0ajs0grA/ChR5g/xk
         lwcQs6Sl5XSk9EJxiWtfCuCHsbDHjAea/KEQTles7Od82VLEkixAJ4dUmtAz9ptYMIPU
         1JA6crloGttV/GsxTO5c7999yidHx8CddNA/mBJL1yujUP/E9mu3UkZmUy2MVJ9A1f5Y
         7xiQ==
X-Gm-Message-State: AOAM533DEpEyOdchgCxsTk8gWTOyFcLRDXDRh0g4TClVMfr69uDRGk2Z
        nEodpTS2ru6u/8LGprIYcYP8S16leO0=
X-Google-Smtp-Source: ABdhPJxl4zWe0ke3ZsvVhXXat33jEQp3VDS5ZdiIJmLYZIUKKS5JvpfwczN8gR1AsefUINYuPtcHmQ==
X-Received: by 2002:ac2:4105:: with SMTP id b5mr649836lfi.153.1628107040361;
        Wed, 04 Aug 2021 12:57:20 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.226.235])
        by smtp.gmail.com with ESMTPSA id m9sm227593ljo.85.2021.08.04.12.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 12:57:20 -0700 (PDT)
Subject: Re: [PATCH] net: ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, vasanth@atheros.com, senthilkumar@atheros.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org
References: <20210804194841.14544-1-paskripkin@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <a490dcec-b14f-e8c8-fbb0-a480892c1def@gmail.com>
Date:   Wed, 4 Aug 2021 22:57:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804194841.14544-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/21 10:48 PM, Pavel Skripkin wrote:
> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
> problem was in incorrect htc_handle->drv_priv initialization.
> 
> Probable call trace which can trigger use-after-free:
> 
> ath9k_htc_probe_device()
>    /* htc_handle->drv_priv = priv; */
>    ath9k_htc_wait_for_target()      <--- Failed
>    ieee80211_free_hw()		   <--- priv pointer is freed
> 
> <IRQ>
> ...
> ath9k_hif_usb_rx_cb()
>    ath9k_hif_usb_rx_stream()
>     RX_STAT_INC()		<--- htc_handle->drv_priv access
> 
> In order to not add fancy protection for drv_priv we can move
> htc_handle->drv_priv initialization at the end of the
> ath9k_htc_probe_device() and add helper macro to make
> all *_STAT_* macros NULL save.
> 
> Also, I made whitespaces clean ups in *_STAT_* macros definitions
> to make checkpatch.pl happy.
> 
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Hi, ath9k maintainer/developers!
> 
> I know, that you do not like changes, that wasn't tested on real
> hardware. I really don't access to this one, so I'd like you to test it on
> real hardware piece, if you have one. At least, this patch was tested by
> syzbot [1]
> 
> [1] https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60
> 
> ---
>   drivers/net/wireless/ath/ath9k/htc.h          | 11 ++++++-----
>   drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
>   2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
> index 0a1634238e67..c16b2a482e83 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -326,11 +326,12 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
>   
>   #ifdef CONFIG_ATH9K_HTC_DEBUGFS
>   
> -#define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
> -#define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
> -#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
> -#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
> -#define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
> +#define __STAT_SAVE(expr)	(hif_dev->htc_handle->drv_priv ? (expr) : 0)
> +#define TX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
> +#define TX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
> +#define RX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
> +#define RX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
> +#define CAB_STAT_INC		(priv->debug.tx_stats.cab_queued++)
>   
>   #define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
>   
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> index ff61ae34ecdf..07ac88fb1c57 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -944,7 +944,6 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
>   	priv->hw = hw;
>   	priv->htc = htc_handle;
>   	priv->dev = dev;
> -	htc_handle->drv_priv = priv;
>   	SET_IEEE80211_DEV(hw, priv->dev);
>   
>   	ret = ath9k_htc_wait_for_target(priv);
> @@ -965,6 +964,8 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
>   	if (ret)
>   		goto err_init;
>   
> +	htc_handle->drv_priv = priv;
> +
>   	return 0;
>   
>   err_init:
> 

Added missing LKML in CC. Sorry for confusion.


With regards,
Pavel Skripkin
