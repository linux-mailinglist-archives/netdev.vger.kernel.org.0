Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4CA260981
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgIHE0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgIHE0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 00:26:05 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90D3C061573;
        Mon,  7 Sep 2020 21:26:04 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id o5so14152486qke.12;
        Mon, 07 Sep 2020 21:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6wIvzc8U9COMkIGKunN+WS3730A3DmsP+jQFwcsoR08=;
        b=XGIgUmdp/WMDIdcOZhT0JMYaODhrVSDvwHBKJv5L4Jckzwu2Nt0vE3loo0Gg7Pwz/E
         XNu3yy+0iasK4VDg5yY9pw4jhxu0fQpYhTzPlyrUsybUI8K0/21cUZoBSjLVFCUeJboO
         cTF1dAOT5YiR6Wr/n3WFUA4PRJGV8t6FVhIYWn7oPsgUowoMz92YSJzXQ9yX8noij2ik
         zz9mdQgufHBnz7mitvUyHxsioNXQtA7szhQWxkvQ4ZsvCcFOPWwKjsBmrKYGeH1tUZiJ
         ebAG24j+2Pq5VChtR/j3CZhcqqhG5igvdfcDuf/SC1xZSYeKzDQOytS2hJJ0HZBQp0dH
         TTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6wIvzc8U9COMkIGKunN+WS3730A3DmsP+jQFwcsoR08=;
        b=k1vtuhUBCq6WzyROYEjVdpY8yIB8JD7heVOk/T48EQcWi+S6+T+ENwbCI28AaOcA09
         j/5kFgoICfCL3ysDV32ldqW9lqnjnxkGDJOeNg3E7KswsjkwTsPlG9v11LbKRdB5jvnS
         OHy3taTEP7ZlGqn1pG74ZJK0xqrPhOqcsApkpvHwXtlPBWp/SkzoGA9sNJTFcHgXKhOb
         /eJUk2zSo/I/egIpPRS0vTP21F/1QbfbJOLceBW+34SS4eTbeV0FDOQZ/QDalWqiqvPH
         g2QKIX32DATHSG9B0yRbcYpr3yt9ZkHZGcn8r3uLgzeCG/mOw1Mmk7kAkM/RSP30aVNa
         DT2w==
X-Gm-Message-State: AOAM532fuKTixQpbdxMA30rv2ZAOlysFW5hCaKol84DWd4sX3KHo9XHn
        N1S9/aqWX25GpohFF/WU0Hnm9o7PaEA=
X-Google-Smtp-Source: ABdhPJxknd7Tzqi8PHGiWn6w9zwv3Wp6f1fXH1+0QYxLjAxL5aSnzlwKisngzsoLVVZzkBWAfRtZ2g==
X-Received: by 2002:a37:a495:: with SMTP id n143mr21941493qke.394.1599539163498;
        Mon, 07 Sep 2020 21:26:03 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id p29sm8096819qtu.68.2020.09.07.21.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 21:26:02 -0700 (PDT)
Date:   Mon, 7 Sep 2020 21:26:01 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     trix@redhat.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ndesaulniers@google.com, mkenna@codeaurora.org,
        vnaralas@codeaurora.org, rmanohar@codeaurora.org, john@phrozen.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ath11k: fix a double free and a memory leak
Message-ID: <20200908042601.GB111690@ubuntu-n2-xlarge-x86>
References: <20200906212625.17059-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906212625.17059-1-trix@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 06, 2020 at 02:26:25PM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analyzer reports this problem
> 
> mac.c:6204:2: warning: Attempt to free released memory
>         kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The channels pointer is allocated in ath11k_mac_setup_channels_rates()
> When it fails midway, it cleans up the memory it has already allocated.
> So the error handling needs to skip freeing the memory.
> 
> There is a second problem.
> ath11k_mac_setup_channels_rates(), allocates 3 channels. err_free
> misses releasing ar->mac.sbands[NL80211_BAND_6GHZ].channels
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/net/wireless/ath/ath11k/mac.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index f4a085baff38..f1a964b01a83 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -6089,7 +6089,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
>  	ret = ath11k_mac_setup_channels_rates(ar,
>  					      cap->supported_bands);
>  	if (ret)
> -		goto err_free;
> +		goto err;
>  
>  	ath11k_mac_setup_ht_vht_cap(ar, cap, &ht_cap);
>  	ath11k_mac_setup_he_cap(ar, cap);
> @@ -6203,7 +6203,8 @@ static int __ath11k_mac_register(struct ath11k *ar)
>  err_free:
>  	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
>  	kfree(ar->mac.sbands[NL80211_BAND_5GHZ].channels);
> -
> +	kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
> +err:
>  	SET_IEEE80211_DEV(ar->hw, NULL);
>  	return ret;
>  }
> -- 
> 2.18.1
> 
