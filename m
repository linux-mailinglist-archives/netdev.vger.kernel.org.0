Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9771F3E3C9E
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 22:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhHHUFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 16:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhHHUFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 16:05:53 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51330C061760;
        Sun,  8 Aug 2021 13:05:33 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id z9-20020a9d62c90000b0290462f0ab0800so6230602otk.11;
        Sun, 08 Aug 2021 13:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y+fsNvcP8dkgO4RaKDxTWoK76a0HM9+fIwumjal/z98=;
        b=e8icHDF1d9r/1SuGSml/MwK5+13gAI/GT9voeI4kYgHxb/5xe2Wh3osnexHqrNQrPU
         0S2yGm0e6k1C0/bYFTI4+DUbPeDAnG3b8MYgKyWegJ9M2sxd8hUQ1Q39epU5cryulsbn
         VZWjzCkrZSKVKDQHCIstYX9e2t2ONJcTlbyJ1luvXNG50n8gtOn1KN7Mch59cPLRBGuo
         bppEvTpWfglhTOm6JFSHieeCby9t407RrYbiiGXOdR/0nYqHGZyLGWQP0nrq4Oubep7i
         LqCYvE834F3w4Igvvio3eyPEZHAfGGeF9HFKWa7PHwIRVZJC9QxjwPlr+LeBb+ujuX0B
         tn+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y+fsNvcP8dkgO4RaKDxTWoK76a0HM9+fIwumjal/z98=;
        b=fqWLxRwxn3QMa7ZrewqSik+chkm5TEr1y0uUrvUl+U6TM2q9POvvTRNAgAXXlE0tu3
         toTv3R7A7g2FevG58mNmJTMgS+h2DlYhvKHofOkX3nk9K1MoZs9n38B10PJSo6zExFWx
         QzBpnCsyEeWoQMuFoWYrStpM6R4dJMEWCgaChFi9M9vh6qW5IxQjYJuvh5hm8YwstJzD
         zxiK+94CFcwbV/EixnTZahfaxZTU9JrWQEgvIYvN5jntNQdWBD1ILbAADE14mKLf1jRJ
         xrFX0uE708xWkw3YealWcpPvPMTdVJJ9nmJPspo26kJf2vTwcnrzOWvNEJbyDvWW8gZw
         cmLw==
X-Gm-Message-State: AOAM532OPYYrKCyPS8/NtfzvMchDQyKeI4JICeabkPDksLtwcjYSdVCE
        rqU1g78z2+B8+EYLNAyalNy/Mf7l8b0=
X-Google-Smtp-Source: ABdhPJyJ5NHyew5awjZJpsqYT54QPoa3HPj/dA72EChby49AbfBfH+pefO2G5I3YGVVOd3Pxz4/NFQ==
X-Received: by 2002:a9d:7556:: with SMTP id b22mr4257721otl.238.1628453132525;
        Sun, 08 Aug 2021 13:05:32 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id f26sm2783023oto.65.2021.08.08.13.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 13:05:32 -0700 (PDT)
Subject: Re: [PATCH v3 net] ipv4: fix error path in fou_create()
To:     Kangmin Park <l4stpr0gr4m@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210808070557.17858-1-l4stpr0gr4m@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <751fe234-21cd-3a56-dff7-6768bbbfaaad@gmail.com>
Date:   Sun, 8 Aug 2021 14:05:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210808070557.17858-1-l4stpr0gr4m@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/21 1:05 AM, Kangmin Park wrote:
> sock is always NULL when udp_sock_create() is failed and fou is
> always NULL when kzalloc() is failed in error label.
> 
> So, add error_sock and error_alloc label and fix the error path
> in those cases.
> 
> Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
> ---
> v3:
>  - change commit message
>  - fix error path
> ---
>  net/ipv4/fou.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
> index e5f69b0bf3df..f1d99e776bb8 100644
> --- a/net/ipv4/fou.c
> +++ b/net/ipv4/fou.c
> @@ -572,13 +572,13 @@ static int fou_create(struct net *net, struct fou_cfg *cfg,
>  	/* Open UDP socket */
>  	err = udp_sock_create(net, &cfg->udp_config, &sock);
>  	if (err < 0)
> -		goto error;
> +		goto error_sock;
>  
>  	/* Allocate FOU port structure */
>  	fou = kzalloc(sizeof(*fou), GFP_KERNEL);
>  	if (!fou) {
>  		err = -ENOMEM;
> -		goto error;
> +		goto error_alloc;
>  	}
>  
>  	sk = sock->sk;
> @@ -627,9 +627,10 @@ static int fou_create(struct net *net, struct fou_cfg *cfg,
>  
>  error:
>  	kfree(fou);
> +error_alloc:
>  	if (sock)
>  		udp_tunnel_sock_release(sock);
> -
> +error_sock:
>  	return err;
>  }
>  
> 

since sock and fou are initialized to NULL, kfree(NULL) is allowed and
there is an 'if (sock)' check before the release, no fix is really needed.
