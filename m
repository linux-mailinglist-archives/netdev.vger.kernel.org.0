Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BF2315D70
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbhBJCig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:38:36 -0500
Received: from so15.mailgun.net ([198.61.254.15]:24532 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234858AbhBJCh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 21:37:27 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612924622; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=KP3hTxbzRxMtj43K3BWRTDhhCWad/fnTc01joBzCoVI=;
 b=H8sHdCaiqn8FnDwS0RBT1Z+MUHspF1fN5X1f1+ziWAZV3GPGuIlQ+h4xZnIAAjCsEEbqjw1C
 A+aqsNexFu7M3533QgQIIRbZx5/+qjBpa8lv0g1pX5MoIm6M5tWs6UbS7k3I8GWBRff9lbZU
 dRP9VpqKZJWOVwd43Gv9f3E6Y+0=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 602346a934db06ef7956bdc3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Feb 2021 02:36:25
 GMT
Sender: wgong=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B2EBEC43466; Wed, 10 Feb 2021 02:36:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: wgong)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D431DC43461;
        Wed, 10 Feb 2021 02:36:23 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Feb 2021 10:36:23 +0800
From:   Wen Gong <wgong@codeaurora.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ath10k: reduce invalid ht params rate message noise
In-Reply-To: <76a816d983e6c4d636311738396f97971b5523fb.1612915444.git.skhan@linuxfoundation.org>
References: <cover.1612915444.git.skhan@linuxfoundation.org>
 <76a816d983e6c4d636311738396f97971b5523fb.1612915444.git.skhan@linuxfoundation.org>
Message-ID: <5c31f6dadbcc3dcb19239ad2b6106773@codeaurora.org>
X-Sender: wgong@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-10 08:42, Shuah Khan wrote:
> ath10k_mac_get_rate_flags_ht() floods dmesg with the following 
> messages,
> when it fails to find a match for mcs=7 and rate=1440.
> 
> supported_ht_mcs_rate_nss2:
> {7,  {1300, 2700, 1444, 3000} }
> 
> ath10k_pci 0000:02:00.0: invalid ht params rate 1440 100kbps nss 2 mcs 
> 7
> 
> dev_warn_ratelimited() isn't helping the noise. Use dev_warn_once()
> instead.
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
> b/drivers/net/wireless/ath/ath10k/mac.c
> index 3545ce7dce0a..276321f0cfdd 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -8970,8 +8970,9 @@ static void ath10k_mac_get_rate_flags_ht(struct
> ath10k *ar, u32 rate, u8 nss, u8
>  		*bw |= RATE_INFO_BW_40;
>  		*flags |= RATE_INFO_FLAGS_SHORT_GI;
>  	} else {
> -		ath10k_warn(ar, "invalid ht params rate %d 100kbps nss %d mcs %d",
> -			    rate, nss, mcs);
> +		dev_warn_once(ar->dev,
> +			      "invalid ht params rate %d 100kbps nss %d mcs %d",
> +			      rate, nss, mcs);
>  	}
>  }
The {7,  {1300, 2700, 1444, 3000} } is a correct value.
The 1440 is report from firmware, its a wrong value, it has fixed in 
firmware.
If change it to dev_warn_once, then it will have no chance to find the 
other wrong values which report by firmware, and it indicate
a wrong value to mac80211/cfg80211 and lead "iw wlan0 station dump" get 
a wrong bitrate.
