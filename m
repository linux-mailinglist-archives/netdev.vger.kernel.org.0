Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926CC3902B1
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhEYNqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbhEYNqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 09:46:38 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E122C061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 06:45:07 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l18-20020a1c79120000b0290181c444b2d0so6305412wme.5
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 06:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LOoZ4D09/P1CraxAAqp1wTjfF1mgKpWyIvRgzgawf7I=;
        b=ozXmiq7Lhh60vGZo99qKW2xPFVElGSvTkCERBpaNalMKRKevYxgKEIS0J/Oglz3kMw
         O2LaWEXEDd30dungFYyp+CIml/XlwqZST5T96JiYvv6td6O1qCKIea8K+iK3co/ugz9i
         UMDLOY3w1DLNF165UfTpOq3n+RUm1YBRFm0i0ekLK49H427QAc9AnJNUDjhrRbhxGTJK
         NLrxNHr6/osSI7uPXJUQe5DW/+GVxw+BFTKxRxqtUNkGr4rD/koRvyJLt4Hw3xDpIbFl
         4SCbhO5444eE9mQMk9ove/MATaehU0HIAWs5HhZfUlE3zU/knWHlqU3LGpHp6I+Pp56f
         z0DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LOoZ4D09/P1CraxAAqp1wTjfF1mgKpWyIvRgzgawf7I=;
        b=b0h676SC2px8aemnDlJuxhBu4MeKfy5yT+oVvL/8gOPoP9Ae4QVWM/w+Ev8cuGPDP0
         NDJflF9pFb8vS0+RwRi0kb2mYjilDO5Ci2BCgRnmQw1h6BWa/S7Q6yr6iS9uMAiuV7GD
         Vx/SltYwHXjdNHFxR3guyMvuRKkuG0l0rwlyRtQ5ZaA4Pqj+L229YEUHIUv+0/xFehfF
         qCBu8mVN04hYpKF2EoYgUA46QUHe31WCjjB6rYQTULhfo2XVtauH1f9u64XHdFcSV6Sz
         mcVRuVU3y6+geDcga8KbqPGzusNtcpBa0d1ShGqNhykc1+OepAfn+g8jaSy+kI5wzJwX
         va4w==
X-Gm-Message-State: AOAM530VEV0oSI4Mm1ElFedSy6FW3s8qlvoi8HwYgtClFcADykYI8FXS
        w/egq70lbJe9RWtGcdycYe8=
X-Google-Smtp-Source: ABdhPJwE3nnfAUU5R2t+JbjjBlWGdJd5/JC0Ei7HObmfDRO7VAn7n/BOeNN7py+tzpDxs/uq9sSBgQ==
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr10692985wml.40.1621950305847;
        Tue, 25 May 2021 06:45:05 -0700 (PDT)
Received: from [10.0.0.2] ([37.167.187.243])
        by smtp.gmail.com with ESMTPSA id z188sm11254708wme.38.2021.05.25.06.45.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 06:45:04 -0700 (PDT)
Subject: Re: [PATCH net] skbuff: Release nfct refcount on napi stolen or
 re-used skbs
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <1621934002-16711-1-git-send-email-paulb@nvidia.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <81587f89-df10-004e-6c79-34940fe04c16@gmail.com>
Date:   Tue, 25 May 2021 15:45:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1621934002-16711-1-git-send-email-paulb@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/25/21 11:13 AM, Paul Blakey wrote:
> When multiple SKBs are merged to a new skb under napi GRO,
> or SKB is re-used by napi, if nfct was set for them in the
> driver, it will not be released while freeing their stolen
> head state or on re-use.
> 
> Release nfct on napi's stolen or re-used SKBs.
> 
> Fixes: 5c6b94604744 ("net/mlx5e: CT: Handle misses after executing CT action")
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---
>  net/core/dev.c    | 1 +
>  net/core/skbuff.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index ef8cf7619baf..a5324ca7dc65 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6243,6 +6243,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
>  	skb_shinfo(skb)->gso_type = 0;
>  	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
>  	skb_ext_reset(skb);
> +	nf_reset_ct(skb);
>  
>  	napi->skb = skb;
>  }
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 3ad22870298c..6127bab2fe2f 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -939,6 +939,7 @@ void __kfree_skb_defer(struct sk_buff *skb)
>  
>  void napi_skb_free_stolen_head(struct sk_buff *skb)
>  {
> +	nf_conntrack_put(skb_nfct(skb));
>  	skb_dst_drop(skb);
>  	skb_ext_put(skb);
>  	napi_skb_cache_put(skb);
> 

Sadly we are very consistently making GRO slow as hell.

Why merging SKB with different ct would be allowed ?

If we accept this patch, then you will likely add another check in gro_list_prepare() ?

