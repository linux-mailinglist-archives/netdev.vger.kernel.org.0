Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7968462A45
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 03:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbhK3CVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 21:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhK3CVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 21:21:35 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2024C061574;
        Mon, 29 Nov 2021 18:18:16 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so15819987pjb.4;
        Mon, 29 Nov 2021 18:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=p3lwLECFKpkQnHl0yDOK5yRtgi2ru5vn8Xu2z7FkdbA=;
        b=OLORXifq9khcGYLqzOsL2eSs9jh3TTh91sNvDs3MUiTrsVVP1bA7iyocCZg2rY2YE9
         /w24w8uz+VQ2Igd37iu5EaSf70wQ+W3OOknZMSTqYQxNycI2Xy310Kzudulq9jWCBx8Y
         Dlnp3r94oIVBG2J2xh/RT4qvC7xhk9Zv5aXnYu/Eyh9xGENVX+ni6C469OS44Z/yrZ8q
         rYdVNMEMJ65IRWJdDrhQ14CKQrZQYTg8DIjS+/xJAY4XUafjT2is7QbBaNCIKEgNybPI
         sCKYY8iqxiApKsB0Fwn9N3otN9dlVxmNHQXIpV25VNOFVGTiPKKOl5LvWWMaFly8qyvp
         SxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=p3lwLECFKpkQnHl0yDOK5yRtgi2ru5vn8Xu2z7FkdbA=;
        b=2SBVk7s0D6jjjYkE7jSPvBERdbS+PEMqsvHko8zjqRQEY5gLBo6CklxjW1a/EcqBWo
         +0TM8OU8Mn08OciPg/zJjBjgvaY/4XWYI6x1Sxh97MjfhhF57YAvEtpvSANTgIW65qvC
         xt1EWPFgYRW3ZHPIeRqnHFOpGxyiZShN75dL21nEb2PsHp5LU5nfYW9YjM4f8sLMvma6
         sV+dIzktWm7TqIUu7wkh5NhwJTJcpeMLQiYulaU0dK9xeYLlNaJ5xNDy62aSeoeozMGJ
         Qc6VxwSEABTKdeE1dBO7Cy8a1Uvu+jbYHmj/OEyWpgGdisz8shTOVWti//W7tnpNpLcG
         oZkg==
X-Gm-Message-State: AOAM533+YEyRxhcLBNj5R8M62fyiRhrDsMJLI0FTiYpSL/IW6pD0cUxl
        jqvd9nY3ALmxkCD/ss7NSEA=
X-Google-Smtp-Source: ABdhPJyZE7Zd1DaHBRQXXTOQwX0W2yOazJ2vLTdY2MMuYWI8bqtuXl2sGmo4U0V6l4WAqgrmWogk/A==
X-Received: by 2002:a17:903:1208:b0:143:e4e9:4ce3 with SMTP id l8-20020a170903120800b00143e4e94ce3mr63480729plh.21.1638238696348;
        Mon, 29 Nov 2021 18:18:16 -0800 (PST)
Received: from [10.62.0.6] ([85.203.23.63])
        by smtp.gmail.com with ESMTPSA id bf13sm553999pjb.47.2021.11.29.18.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 18:18:15 -0800 (PST)
Subject: Re: [PATCH] mwifiex: Fix possible ABBA deadlock
To:     Brian Norris <briannorris@chromium.org>
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, David Miller <davem@davemloft.net>,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>
References: <0e495b14-efbb-e0da-37bd-af6bd677ee2c@gmail.com>
 <YaV0pllJ5p/EuUat@google.com>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <9528b94a-7043-132f-c0f3-b45c5e551fa0@gmail.com>
Date:   Tue, 30 Nov 2021 10:18:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <YaV0pllJ5p/EuUat@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Brian,

Thanks for your reply and explanation!
The patch looks good to me :)


Best wishes,
Jia-Ju Bai

On 2021/11/30 8:47, Brian Norris wrote:
> Quoting Jia-Ju Bai <baijiaju1990@gmail.com>:
>
>    mwifiex_dequeue_tx_packet()
>       spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 1432 (Lock A)
>       mwifiex_send_addba()
>         spin_lock_bh(&priv->sta_list_spinlock); --> Line 608 (Lock B)
>
>    mwifiex_process_sta_tx_pause()
>       spin_lock_bh(&priv->sta_list_spinlock); --> Line 398 (Lock B)
>       mwifiex_update_ralist_tx_pause()
>         spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 941 (Lock A)
>
> Similar report for mwifiex_process_uap_tx_pause().
>
> While the locking expectations in this driver are a bit unclear, the
> Fixed commit only intended to protect the sta_ptr, so we can drop the
> lock as soon as we're done with it.
>
> IIUC, this deadlock cannot actually happen, because command event
> processing (which calls mwifiex_process_sta_tx_pause()) is
> sequentialized with TX packet processing (e.g.,
> mwifiex_dequeue_tx_packet()) via the main loop (mwifiex_main_process()).
> But it's good not to leave this potential issue lurking.
>
> Fixes: ("f0f7c2275fb9 mwifiex: minor cleanups w/ sta_list_spinlock in cfg80211.c")
> Cc: Douglas Anderson <dianders@chromium.org>
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Link: https://lore.kernel.org/linux-wireless/0e495b14-efbb-e0da-37bd-af6bd677ee2c@gmail.com/
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>
> On Tue, Nov 23, 2021 at 11:31:34AM +0800, Jia-Ju Bai wrote:
>> I am not quite sure whether these possible deadlocks are real and how to fix
>> them if they are real.
>> Any feedback would be appreciated, thanks :)
> I think these are at least theoretically real, and so we should take
> something like the $subject patch probably. But I don't believe we can
> actually hit this due to the main-loop structure of this driver.
>
> Anyway, see the surrounding patch.
>
> Thanks,
> Brian
>
>
>   drivers/net/wireless/marvell/mwifiex/sta_event.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
> index 80e5d44bad9d..7d42c5d2dbf6 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
> @@ -365,10 +365,12 @@ static void mwifiex_process_uap_tx_pause(struct mwifiex_private *priv,
>   		sta_ptr = mwifiex_get_sta_entry(priv, tp->peermac);
>   		if (sta_ptr && sta_ptr->tx_pause != tp->tx_pause) {
>   			sta_ptr->tx_pause = tp->tx_pause;
> +			spin_unlock_bh(&priv->sta_list_spinlock);
>   			mwifiex_update_ralist_tx_pause(priv, tp->peermac,
>   						       tp->tx_pause);
> +		} else {
> +			spin_unlock_bh(&priv->sta_list_spinlock);
>   		}
> -		spin_unlock_bh(&priv->sta_list_spinlock);
>   	}
>   }
>   
> @@ -400,11 +402,13 @@ static void mwifiex_process_sta_tx_pause(struct mwifiex_private *priv,
>   			sta_ptr = mwifiex_get_sta_entry(priv, tp->peermac);
>   			if (sta_ptr && sta_ptr->tx_pause != tp->tx_pause) {
>   				sta_ptr->tx_pause = tp->tx_pause;
> +				spin_unlock_bh(&priv->sta_list_spinlock);
>   				mwifiex_update_ralist_tx_pause(priv,
>   							       tp->peermac,
>   							       tp->tx_pause);
> +			} else {
> +				spin_unlock_bh(&priv->sta_list_spinlock);
>   			}
> -			spin_unlock_bh(&priv->sta_list_spinlock);
>   		}
>   	}
>   }

