Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3DFFBD13
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 01:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfKNAbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 19:31:43 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40468 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfKNAbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 19:31:42 -0500
Received: by mail-pf1-f195.google.com with SMTP id r4so2842952pfl.7
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 16:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9sAWI1/WyVUJMv+/9lzXmr/UTEtbsKqgfoRGVLEnFt8=;
        b=Hlj6rDrliTvU/cepY3VqIv8iG73LNRL7563tZytDrLShqFopNYrRCLMIQdo9EA6jDE
         FInBRd96HhgghlpO3VGkTnv17MaY+PkaVo6Vpr8glXkHGY3k+2KW690kk3LBlh3tLN/K
         QHzIckFi5j/6rdruMb2CNBcJ8fpyccBBCzhrw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9sAWI1/WyVUJMv+/9lzXmr/UTEtbsKqgfoRGVLEnFt8=;
        b=qWlH1wwfV3cexudEegiJd6hV9T6v1iM8tUhLiXBuhOiBH7MCM8ix3yKhA8IGHj7FUp
         qxiM20eP1qCsTyzN/BfjwZzrXbQQHz14i/I9sDSfphWx9744o62rcufNzT+VJZz4y2S9
         aoHWGDWbUownmZ398ZuEN7dR2WFH5FMyqIIhMcP0blv7d5daYDdHDlQvs5gAt3bWyoSy
         hQECmMBdpfytvpbaRBCNsqwp7pAjbpTJNHqAsrytj1Wq5ZBpiK1ehI6mXJzp7ExpI1WI
         ZSxbxbV1q7t+J1k1JQDJhR+u80kQD+DTTMpxSEgE5njTRH5At5ByYoAgJaOjX+AtPM1F
         PDUQ==
X-Gm-Message-State: APjAAAXg+BX6ZgqjBGMRynE/s3mDPOeBNPjsuTpWvSpr0BnoT8I4VUed
        Vtbpgm88iFbIbN6QZ4tTbwuNXw==
X-Google-Smtp-Source: APXvYqy73l8AcMr+AtoYg+/uiIszTaLYGFq4eHui1Ai1uiPyzjRywtbILY5sc/7uW/xNvwGKPlOrWQ==
X-Received: by 2002:a17:90a:a898:: with SMTP id h24mr8777377pjq.48.1573691502087;
        Wed, 13 Nov 2019 16:31:42 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d22sm3672614pjd.2.2019.11.13.16.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 16:31:41 -0800 (PST)
Date:   Wed, 13 Nov 2019 16:31:40 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: print proper warning on dst underflow
Message-ID: <201911131625.8B0F0BAEDE@keescook>
References: <20190924090937.13001-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924090937.13001-1-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 11:09:37AM +0200, Jason A. Donenfeld wrote:
> Proper warnings with stack traces make it much easier to figure out
> what's doing the double free and create more meaningful bug reports from
> users.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  net/core/dst.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/dst.c b/net/core/dst.c
> index 1325316d9eab..193af526e908 100644
> --- a/net/core/dst.c
> +++ b/net/core/dst.c
> @@ -172,7 +172,7 @@ void dst_release(struct dst_entry *dst)
>  		int newrefcnt;
>  
>  		newrefcnt = atomic_dec_return(&dst->__refcnt);
> -		if (unlikely(newrefcnt < 0))
> +		if (WARN_ONCE(newrefcnt < 0, "dst_release underflow"))
>  			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
>  					     __func__, dst, newrefcnt);

Should __refcnt be a refcount_t to gain saturation protection? It seems
like going negative is bad...

-Kees

>  		if (!newrefcnt)
> @@ -187,7 +187,7 @@ void dst_release_immediate(struct dst_entry *dst)
>  		int newrefcnt;
>  
>  		newrefcnt = atomic_dec_return(&dst->__refcnt);
> -		if (unlikely(newrefcnt < 0))
> +		if (WARN_ONCE(newrefcnt < 0, "dst_release_immediate underflow"))
>  			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
>  					     __func__, dst, newrefcnt);
>  		if (!newrefcnt)
> -- 
> 2.21.0
> 

-- 
Kees Cook
