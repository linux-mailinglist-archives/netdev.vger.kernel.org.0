Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247E43DC6C8
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 17:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhGaPz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 11:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbhGaPzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 11:55:24 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F01C0613D5
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 08:55:17 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id a20so14744904plm.0
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 08:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CWAr3/vvX8dR98nIuJoFiA3TzHrbFffRdXMXWBKex/w=;
        b=SfXfxxX2N+/kKWmDWeCG1npjUOirhBLaUYkGuCwcQPwpoN0nwD15k4hMwoiQA+Zeg2
         IKrqFe0+x44S++4Yn4DMg2yE6iTlKGkc+6+5+ks30UF3+KpqzYAwTHKdakIoKNtz0aj0
         81ajOKEdPN0fO1YSVRfKq8GqE3V76OXv/xCy8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CWAr3/vvX8dR98nIuJoFiA3TzHrbFffRdXMXWBKex/w=;
        b=VRBa847fIYgth5uUdnZSQKf8aVDNMOnzS+G7rxxdLA0XaVocSWjTkmxhQraNzKtQbb
         08PW6lTVQiOprUAakUjKIkmW1k8E/EwOzkeGWpaLdfIFL59ggCMo9HDBxxoAt2QDgnEJ
         xscrjLU+vHwi+FhTHAcZTgR/dl6pG0dj26s3cl50u4Ivw54ml6y6U2FpTLRWGVxh9aEh
         wRAs6E2fTbWZcCE5bRNvr1/jde3J2l+sK8QvLkXhnC7g78KlTgBbidaH3du0pahxU6d3
         bLegFRnyg6xJUm0Ce4TRJtFiZ/ZwyefnFRNJxH0uLogQRnf1TQ08QO0cmj0XR2EtgNnV
         Z3Xg==
X-Gm-Message-State: AOAM533DDGTpvT3NO7dEueQ49qfWuAhtB9VJ90PbRaO+QavGBtOheBBs
        BrSYtUuRGQeqlkVjX44zMvPIHg==
X-Google-Smtp-Source: ABdhPJzUOR8h4Qlji5guXgZz2vvMrumJrjQKL2oCCx5MemVrRz6QjCyNPdKOcI8nIcntwFJ9MVNCdw==
X-Received: by 2002:a63:1e57:: with SMTP id p23mr5970986pgm.41.1627746916773;
        Sat, 31 Jul 2021 08:55:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v10sm5574092pjd.29.2021.07.31.08.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 08:55:15 -0700 (PDT)
Date:   Sat, 31 Jul 2021 08:55:14 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 39/64] mac80211: Use memset_after() to clear tx status
Message-ID: <202107310852.551B66EE32@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-40-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-40-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:58:30PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Use memset_after() so memset() doesn't get confused about writing
> beyond the destination member that is intended to be the starting point
> of zeroing through the end of the struct.
> 
> Note that the common helper, ieee80211_tx_info_clear_status(), does NOT
> clear ack_signal, but the open-coded versions do. All three perform
> checks that the ack_signal position hasn't changed, though.

Quick ping on this question: there is a mismatch between the common
helper and the other places that do this. Is there a bug here?

> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> Should these each be clearing the same region? Because they're currently not.
> ---
>  drivers/net/wireless/ath/carl9170/tx.c   | 4 +---
>  drivers/net/wireless/intersil/p54/txrx.c | 4 +---
>  include/net/mac80211.h                   | 4 +---
>  3 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
> index 88444fe6d1c6..6d2115639434 100644
> --- a/drivers/net/wireless/ath/carl9170/tx.c
> +++ b/drivers/net/wireless/ath/carl9170/tx.c
> @@ -278,9 +278,7 @@ static void carl9170_tx_release(struct kref *ref)
>  	BUILD_BUG_ON(
>  	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
>  
> -	memset(&txinfo->status.ack_signal, 0,
> -	       sizeof(struct ieee80211_tx_info) -
> -	       offsetof(struct ieee80211_tx_info, status.ack_signal));
> +	memset_after(&txinfo->status, 0, rates);
>  
>  	if (atomic_read(&ar->tx_total_queued))
>  		ar->tx_schedule = true;
> diff --git a/drivers/net/wireless/intersil/p54/txrx.c b/drivers/net/wireless/intersil/p54/txrx.c
> index 873fea59894f..f71b355f8583 100644
> --- a/drivers/net/wireless/intersil/p54/txrx.c
> +++ b/drivers/net/wireless/intersil/p54/txrx.c
> @@ -431,9 +431,7 @@ static void p54_rx_frame_sent(struct p54_common *priv, struct sk_buff *skb)
>  	 * Clear manually, ieee80211_tx_info_clear_status would
>  	 * clear the counts too and we need them.
>  	 */
> -	memset(&info->status.ack_signal, 0,
> -	       sizeof(struct ieee80211_tx_info) -
> -	       offsetof(struct ieee80211_tx_info, status.ack_signal));
> +	memset_after(&info->status, 0, rates);
>  	BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
>  			      status.ack_signal) != 20);
>  
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index d8a1d09a2141..7abc1427aa8c 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1200,9 +1200,7 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
>  
>  	BUILD_BUG_ON(
>  	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
> -	memset(&info->status.ampdu_ack_len, 0,
> -	       sizeof(struct ieee80211_tx_info) -
> -	       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
> +	memset_after(&info->status, 0, ack_signal);
>  }
>  
>  
> -- 
> 2.30.2
> 

-- 
Kees Cook
