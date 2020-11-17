Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FA12B7110
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 22:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgKQVo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 16:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgKQVo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 16:44:58 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A3AC0617A6
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 13:44:58 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id v21so4187413pgi.2
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 13:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CcRxAxp3hd+sjzvNxsLSCjK9z5ct0omQ64BmSp2zT00=;
        b=N+pcT1N4jSOI+Wh+atlsKNV8BTw0ycqtCBZRQlOTTSXFb1zu6IqgXGWZOvrTyGX3gV
         Vc6bV8wp9akYxl8BZkZrijR9TWBurTWwplJVJKx8goslCiasBGb86oYEtLUXkqvioqmd
         St5lsGdtKEKrhJq6bexCd7Amp5bZvdSW7joEU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CcRxAxp3hd+sjzvNxsLSCjK9z5ct0omQ64BmSp2zT00=;
        b=Nom2SjORusI5FRLCplaY1oKdXAvN2TueCHm0S/cjlaNtkXk1Sr9/KS7ZhGC6kERG3C
         wpqUdPdE6EEX2idpKb2A1oiLH1D6bVHZlZ8zpDeCOecWlWgRa0V2ecBg8r6VKOBsFeU7
         Fwl+7L34mRxUmBuPvbNgd9Rblq/FjsecIaz/CHDQb6LpqRMEd8lAVPrlryo6deImom6Q
         Ei5/goflKOV2PqG4CyNYF+SmweAo37B1fJkRHZfxcf45DSnKZGx10LLBmtH5NeHRYIJS
         JZ9vWoB5BqUa+sN9hyTNOV4l3cO+ieZgyUl5LZ/XcTQrMGySuv1dwbImFtItZAfo0NsA
         7Ndg==
X-Gm-Message-State: AOAM530O0V/GpzZUGbMbHwaEC5BQC7QmElOLUu/21M5kZsLR+q2+NpXr
        gDWJsIiScKcuV6oPmOcLS59dDQ==
X-Google-Smtp-Source: ABdhPJybAfAEQ+Y1g6/aNpopnjRBvwkCUJLJhsULugqGRNhJEduijpRmjkjJ7XlKIFY36xSy06/8kw==
X-Received: by 2002:aa7:8759:0:b029:18e:f030:e7a9 with SMTP id g25-20020aa787590000b029018ef030e7a9mr1394842pfo.60.1605649498057;
        Tue, 17 Nov 2020 13:44:58 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a24sm22143511pfl.174.2020.11.17.13.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 13:44:57 -0800 (PST)
Date:   Tue, 17 Nov 2020 13:44:56 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH net] cfg80211: fix callback type mismatches in wext-compat
Message-ID: <202011171338.BB25DBD1E6@keescook>
References: <20201117205902.405316-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117205902.405316-1-samitolvanen@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 12:59:02PM -0800, Sami Tolvanen wrote:
> Instead of casting callback functions to type iw_handler, which trips
> indirect call checking with Clang's Control-Flow Integrity (CFI), add
> stub functions with the correct function type for the callbacks.

Oh, wow. iw_handler with union iwreq_data look like really nasty hacks.
Aren't those just totally bypassing type checking? Where do the
callbacks actually happen? I couldn't find them...

> 
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  net/wireless/wext-compat.c | 103 +++++++++++++++++++++++++------------
>  1 file changed, 71 insertions(+), 32 deletions(-)
> 
> diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
> index 78f2927ead7f..cf54c6e5b397 100644
> --- a/net/wireless/wext-compat.c
> +++ b/net/wireless/wext-compat.c
> @@ -1472,39 +1472,78 @@ static int cfg80211_wext_siwpmksa(struct net_device *dev,
>  	}
>  }
>  
> +#define DEFINE_WEXT_COMPAT_STUB(func, type)			\
> +	static int __ ## func(struct net_device *dev,		\
> +			      struct iw_request_info *info,	\
> +			      union iwreq_data *wrqu,		\
> +			      char *extra)			\
> +	{							\
> +		return func(dev, info, (type *)wrqu, extra);	\
> +	}
> +
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwname, char)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwfreq, struct iw_freq)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwfreq, struct iw_freq)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwmode, u32)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwmode, u32)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwrange, struct iw_point)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwap, struct sockaddr)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwap, struct sockaddr)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwmlme, struct iw_point)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwscan, struct iw_point)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwessid, struct iw_point)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwessid, struct iw_point)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwrate, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwrate, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwrts, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwrts, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwfrag, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwfrag, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwretry, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwretry, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwencode, struct iw_point)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwencode, struct iw_point)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwpower, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwpower, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwgenie, struct iw_point)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwauth, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwauth, struct iw_param)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwencodeext, struct iw_point)
> +DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwpmksa, struct iw_point)
> +
>  static const iw_handler cfg80211_handlers[] = {
> -	[IW_IOCTL_IDX(SIOCGIWNAME)]	= (iw_handler) cfg80211_wext_giwname,
> -	[IW_IOCTL_IDX(SIOCSIWFREQ)]	= (iw_handler) cfg80211_wext_siwfreq,
> -	[IW_IOCTL_IDX(SIOCGIWFREQ)]	= (iw_handler) cfg80211_wext_giwfreq,
> -	[IW_IOCTL_IDX(SIOCSIWMODE)]	= (iw_handler) cfg80211_wext_siwmode,
> -	[IW_IOCTL_IDX(SIOCGIWMODE)]	= (iw_handler) cfg80211_wext_giwmode,
> -	[IW_IOCTL_IDX(SIOCGIWRANGE)]	= (iw_handler) cfg80211_wext_giwrange,
> -	[IW_IOCTL_IDX(SIOCSIWAP)]	= (iw_handler) cfg80211_wext_siwap,
> -	[IW_IOCTL_IDX(SIOCGIWAP)]	= (iw_handler) cfg80211_wext_giwap,
> -	[IW_IOCTL_IDX(SIOCSIWMLME)]	= (iw_handler) cfg80211_wext_siwmlme,
> -	[IW_IOCTL_IDX(SIOCSIWSCAN)]	= (iw_handler) cfg80211_wext_siwscan,
> -	[IW_IOCTL_IDX(SIOCGIWSCAN)]	= (iw_handler) cfg80211_wext_giwscan,
> -	[IW_IOCTL_IDX(SIOCSIWESSID)]	= (iw_handler) cfg80211_wext_siwessid,
> -	[IW_IOCTL_IDX(SIOCGIWESSID)]	= (iw_handler) cfg80211_wext_giwessid,
> -	[IW_IOCTL_IDX(SIOCSIWRATE)]	= (iw_handler) cfg80211_wext_siwrate,
> -	[IW_IOCTL_IDX(SIOCGIWRATE)]	= (iw_handler) cfg80211_wext_giwrate,
> -	[IW_IOCTL_IDX(SIOCSIWRTS)]	= (iw_handler) cfg80211_wext_siwrts,
> -	[IW_IOCTL_IDX(SIOCGIWRTS)]	= (iw_handler) cfg80211_wext_giwrts,
> -	[IW_IOCTL_IDX(SIOCSIWFRAG)]	= (iw_handler) cfg80211_wext_siwfrag,
> -	[IW_IOCTL_IDX(SIOCGIWFRAG)]	= (iw_handler) cfg80211_wext_giwfrag,
> -	[IW_IOCTL_IDX(SIOCSIWTXPOW)]	= (iw_handler) cfg80211_wext_siwtxpower,
> -	[IW_IOCTL_IDX(SIOCGIWTXPOW)]	= (iw_handler) cfg80211_wext_giwtxpower,
> -	[IW_IOCTL_IDX(SIOCSIWRETRY)]	= (iw_handler) cfg80211_wext_siwretry,
> -	[IW_IOCTL_IDX(SIOCGIWRETRY)]	= (iw_handler) cfg80211_wext_giwretry,
> -	[IW_IOCTL_IDX(SIOCSIWENCODE)]	= (iw_handler) cfg80211_wext_siwencode,
> -	[IW_IOCTL_IDX(SIOCGIWENCODE)]	= (iw_handler) cfg80211_wext_giwencode,
> -	[IW_IOCTL_IDX(SIOCSIWPOWER)]	= (iw_handler) cfg80211_wext_siwpower,
> -	[IW_IOCTL_IDX(SIOCGIWPOWER)]	= (iw_handler) cfg80211_wext_giwpower,
> -	[IW_IOCTL_IDX(SIOCSIWGENIE)]	= (iw_handler) cfg80211_wext_siwgenie,
> -	[IW_IOCTL_IDX(SIOCSIWAUTH)]	= (iw_handler) cfg80211_wext_siwauth,
> -	[IW_IOCTL_IDX(SIOCGIWAUTH)]	= (iw_handler) cfg80211_wext_giwauth,
> -	[IW_IOCTL_IDX(SIOCSIWENCODEEXT)]= (iw_handler) cfg80211_wext_siwencodeext,
> -	[IW_IOCTL_IDX(SIOCSIWPMKSA)]	= (iw_handler) cfg80211_wext_siwpmksa,
> +	[IW_IOCTL_IDX(SIOCGIWNAME)]	= __cfg80211_wext_giwname,
> +	[IW_IOCTL_IDX(SIOCSIWFREQ)]	= __cfg80211_wext_siwfreq,
> +	[IW_IOCTL_IDX(SIOCGIWFREQ)]	= __cfg80211_wext_giwfreq,
> +	[IW_IOCTL_IDX(SIOCSIWMODE)]	= __cfg80211_wext_siwmode,
> +	[IW_IOCTL_IDX(SIOCGIWMODE)]	= __cfg80211_wext_giwmode,
> +	[IW_IOCTL_IDX(SIOCGIWRANGE)]	= __cfg80211_wext_giwrange,
> +	[IW_IOCTL_IDX(SIOCSIWAP)]	= __cfg80211_wext_siwap,
> +	[IW_IOCTL_IDX(SIOCGIWAP)]	= __cfg80211_wext_giwap,
> +	[IW_IOCTL_IDX(SIOCSIWMLME)]	= __cfg80211_wext_siwmlme,
> +	[IW_IOCTL_IDX(SIOCSIWSCAN)]	= cfg80211_wext_siwscan,
> +	[IW_IOCTL_IDX(SIOCGIWSCAN)]	= __cfg80211_wext_giwscan,
> +	[IW_IOCTL_IDX(SIOCSIWESSID)]	= __cfg80211_wext_siwessid,
> +	[IW_IOCTL_IDX(SIOCGIWESSID)]	= __cfg80211_wext_giwessid,
> +	[IW_IOCTL_IDX(SIOCSIWRATE)]	= __cfg80211_wext_siwrate,
> +	[IW_IOCTL_IDX(SIOCGIWRATE)]	= __cfg80211_wext_giwrate,
> +	[IW_IOCTL_IDX(SIOCSIWRTS)]	= __cfg80211_wext_siwrts,
> +	[IW_IOCTL_IDX(SIOCGIWRTS)]	= __cfg80211_wext_giwrts,
> +	[IW_IOCTL_IDX(SIOCSIWFRAG)]	= __cfg80211_wext_siwfrag,
> +	[IW_IOCTL_IDX(SIOCGIWFRAG)]	= __cfg80211_wext_giwfrag,
> +	[IW_IOCTL_IDX(SIOCSIWTXPOW)]	= cfg80211_wext_siwtxpower,
> +	[IW_IOCTL_IDX(SIOCGIWTXPOW)]	= cfg80211_wext_giwtxpower,
> +	[IW_IOCTL_IDX(SIOCSIWRETRY)]	= __cfg80211_wext_siwretry,
> +	[IW_IOCTL_IDX(SIOCGIWRETRY)]	= __cfg80211_wext_giwretry,
> +	[IW_IOCTL_IDX(SIOCSIWENCODE)]	= __cfg80211_wext_siwencode,
> +	[IW_IOCTL_IDX(SIOCGIWENCODE)]	= __cfg80211_wext_giwencode,
> +	[IW_IOCTL_IDX(SIOCSIWPOWER)]	= __cfg80211_wext_siwpower,
> +	[IW_IOCTL_IDX(SIOCGIWPOWER)]	= __cfg80211_wext_giwpower,
> +	[IW_IOCTL_IDX(SIOCSIWGENIE)]	= __cfg80211_wext_siwgenie,
> +	[IW_IOCTL_IDX(SIOCSIWAUTH)]	= __cfg80211_wext_siwauth,
> +	[IW_IOCTL_IDX(SIOCGIWAUTH)]	= __cfg80211_wext_giwauth,
> +	[IW_IOCTL_IDX(SIOCSIWENCODEEXT)]= __cfg80211_wext_siwencodeext,
> +	[IW_IOCTL_IDX(SIOCSIWPMKSA)]	= __cfg80211_wext_siwpmksa,
>  };
>  
>  const struct iw_handler_def cfg80211_wext_handler = {
> 
> base-commit: 9c87c9f41245baa3fc4716cf39141439cf405b01
> -- 
> 2.29.2.299.gdc1121823c-goog
> 

-- 
Kees Cook
