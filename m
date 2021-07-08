Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA16A3BF476
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 06:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhGHEPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 00:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhGHEPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 00:15:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26C5C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 21:12:24 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ie21so2817002pjb.0
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 21:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s9V9RUHkPwIx24JOtFc6MkuzDH2imoICt7uNchOOwe8=;
        b=dJmChocms65ERCLnvhD3eMZ7f+gqDOuFLxdv/DiSoxymtD2GmZ9hMM8Dq5Vwi6zJyc
         p+H/eh69XJPRMlAuOZ+3ejzH8qE1jSlTrXtkFh7//OTDvm2A8DWlvd/VlZTxd6Pe7zg5
         0KPTo4hpJ32gLYwuK3k2wira4UfK9YM/vPRjvVgyb8Lfc0dXy2QKsmnVbvcJc1t56THn
         2iyCYEfBE99FjzlX0gygzT1af0K7mzuzfsUeY+xu8tKdfZHxm9Erkb8dRJy2ylyedDNy
         g27WvLy1rYw6FPD60uYbxQ70t2Bf2G/YC64GZVJLlZCAxzWlpa9l0mLJXkIPj8AuOooz
         Om4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s9V9RUHkPwIx24JOtFc6MkuzDH2imoICt7uNchOOwe8=;
        b=oRMTTf+bTGIHs3P7OHRR5sG0J1aWYQpsThhYuLyoAIapoGx1Y1+40ZMtWGES/gAw+f
         h/miqjztuFNrfazAhxi/TW+C27Hy2icbMHzmGNU6bR/DaAnnX4+wljzDQ5cuCp4Wi85L
         4VpjXoFsQSlNtN1dyEO9nd6H/pkBWO+Mt8qm87dUElxCNcNuP4IlxiZ7KEZaToGX6GW9
         7CPcnmmdB9BPnEz6WwA/3vNaLegyKFwYLwS7cGAluQQ9AZ4MRUTBIfWicM09Fob95Mfo
         la97pt/kFMU22Jj6GeBXeQsK+zrw+NnPDSeGplt+w6zY/X5vfxxkxE+AiCgh2QrRzEaQ
         RQIg==
X-Gm-Message-State: AOAM531ob9BCEyBhZ0dkNQuQrd1brXx3GJOmmNWmdtb5/TmzFylJ8yu6
        raqNZe0wa+GPBo/E5jHvbRA=
X-Google-Smtp-Source: ABdhPJxOXaW6tKjlSs2vHx0J1Wz7zOYema1N+ncZolCpbSY1XqPJm6yhydIiXySluuwDzyu0Ez9zHA==
X-Received: by 2002:a17:902:8ec9:b029:11f:f1dc:6c8d with SMTP id x9-20020a1709028ec9b029011ff1dc6c8dmr24051909plo.34.1625717544495;
        Wed, 07 Jul 2021 21:12:24 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w5sm761605pfu.121.2021.07.07.21.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 21:12:24 -0700 (PDT)
Subject: Re: [PATCH net v3] skbuff: Release nfct refcount on napi stolen or
 re-used skbs
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        mika penttila <mika.penttila@nextfour.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <1625482491-17536-1-git-send-email-paulb@nvidia.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <15cb9c42-3471-2bc3-6f0d-e5fc2a8e682e@gmail.com>
Date:   Wed, 7 Jul 2021 21:12:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1625482491-17536-1-git-send-email-paulb@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2021 3:54 AM, Paul Blakey wrote:
> When multiple SKBs are merged to a new skb under napi GRO,
> or SKB is re-used by napi, if nfct was set for them in the
> driver, it will not be released while freeing their stolen
> head state or on re-use.
> 
> Release nfct on napi's stolen or re-used SKBs, and
> in gro_list_prepare, check conntrack metadata diff.
> 
> Fixes: 5c6b94604744 ("net/mlx5e: CT: Handle misses after executing CT action")
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Paul Blakey <paulb@nvidia.com>

FWIW this change broke builds with CONFIG_SKB_EXTENSIONS disabled and 
also does not guard against CONFIG_NET_TC_SKB_EXT being disabled as well:

   CC      net/core/dev.o
net/core/dev.c: In function 'gro_list_prepare':
net/core/dev.c:6015:33: error: implicit declaration of function 
'skb_ext_find'; did you mean 'skb_ext_copy'? 
[-Werror=implicit-function-declaration]
     struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
                                  ^~~~~~~~~~~~
                                  skb_ext_copy
net/core/dev.c:6015:51: error: 'TC_SKB_EXT' undeclared (first use in 
this function); did you mean 'TC_U32_EAT'?
     struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
                                                    ^~~~~~~~~~
                                                    TC_U32_EAT
net/core/dev.c:6015:51: note: each undeclared identifier is reported 
only once for each function it appears in
net/core/dev.c:6020:19: error: dereferencing pointer to incomplete type 
'struct tc_skb_ext'
      diffs |= p_ext->chain ^ skb_ext->chain;
                    ^~
cc1: some warnings being treated as errors
make[2]: *** [scripts/Makefile.build:273: net/core/dev.o] Error 1
make[1]: *** [scripts/Makefile.build:516: net/core] Error 2
make: *** [Makefile:1847: net] Error 2

Fix: 
https://lore.kernel.org/netdev/20210708041051.17851-1-f.fainelli@gmail.com/

> ---
> Changelog:
> 	v2->v1:
> 	 in napi_skb_free_stolen_head() use nf_reset_ct(skb) instead, so we also zero nfct ptr.
> 	v1->v2:
> 	 Check for different flows based on CT and chain metadata in gro_list_prepare
> 
>   net/core/dev.c    | 13 +++++++++++++
>   net/core/skbuff.c |  1 +
>   2 files changed, 14 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 439faadab0c2..bf62cb2ec6da 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5981,6 +5981,18 @@ static void gro_list_prepare(const struct list_head *head,
>   			diffs = memcmp(skb_mac_header(p),
>   				       skb_mac_header(skb),
>   				       maclen);
> +
> +		diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
> +
> +		if (!diffs) {
> +			struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
> +			struct tc_skb_ext *p_ext = skb_ext_find(p, TC_SKB_EXT);
> +
> +			diffs |= (!!p_ext) ^ (!!skb_ext);
> +			if (!diffs && unlikely(skb_ext))
> +				diffs |= p_ext->chain ^ skb_ext->chain;
> +		}
> +
>   		NAPI_GRO_CB(p)->same_flow = !diffs;
>   	}
>   }
> @@ -6243,6 +6255,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
>   	skb_shinfo(skb)->gso_type = 0;
>   	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
>   	skb_ext_reset(skb);
> +	nf_reset_ct(skb);
>   
>   	napi->skb = skb;
>   }
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index bbc3b4b62032..30ca61d91b69 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -939,6 +939,7 @@ void __kfree_skb_defer(struct sk_buff *skb)
>   
>   void napi_skb_free_stolen_head(struct sk_buff *skb)
>   {
> +	nf_reset_ct(skb);
>   	skb_dst_drop(skb);
>   	skb_ext_put(skb);
>   	napi_skb_cache_put(skb);
> 

-- 
Florian
