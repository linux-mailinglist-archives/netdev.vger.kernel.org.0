Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA46A6F0BBA
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 20:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244494AbjD0SD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 14:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244473AbjD0SD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 14:03:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECBB4488
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 11:03:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-552f2f940edso146477717b3.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 11:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682618635; x=1685210635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mqn59kGq3ur6aAOCGUyy0ioYzlO8wdPn14StAYBE2uo=;
        b=VKHZaQPj5SrBlM5uNECqauD5zKoEZKUaeAkYeIjSq8IBu41tS74krOIgUdC24b60Db
         k3/WfJqJFZs26RWJh7laFbkmOqs9E46iJzeGzBb0prONWYbREAmX0WE7IDsQJhr9jhcp
         UrogaF+p0sMxurCgWi7HNregXytZ5Rgsqss7Fz0nqDVHGpyruxkOSwur+8arh10SOlaL
         4zvCo93EFgPjXgKsXsk+xaI2Ofpsc8tWEjY76/fJf2a17+yM+EWtRo0gOpD/qBbSVh0U
         6K5/Cn03oDgEOyqI9Sv51o6XPiJkRmN+VlLuXIaoCvFjcRTNc7tdmmCbx8239QbOKNLJ
         c/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682618635; x=1685210635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mqn59kGq3ur6aAOCGUyy0ioYzlO8wdPn14StAYBE2uo=;
        b=XWDwFmGpN9kqLbrk/C1+e/Usm2DoMPHR014Kqgnb3Be34hjKNTwjUb0iBI/RpgiYm6
         KkoYzTz+/yaFjpTinFNHzBSxEcSvBzM4ad7VV9E2TwWlLHqRYWIlJCfvIIfNJGJeUaTF
         q2Yx68cJ+4tKfQKKAXgsjdy/u+iP4rucOwwu1i+SsWvXs0kKZL73C3i3CVo8bt9Hl3av
         f+d9/VIf7IP9dMHMuuvG7EhYB/1zw7/9O4Y+OlxwENNVu7lyZt2qow5aE0hmVQ3RoQL/
         qbrnTSSatWyDVN12EtXcjVyB7BZZM+5GOKKnmMAich8zLObTiA06GeH6Ymw1yqoGiV96
         QtPA==
X-Gm-Message-State: AC+VfDzB6hLrd0p3CKcgwqbrC1M/liTeE1IQTzSMtj/gGNUwErR/6/Lg
        xPSTJiYI/vx47UNicmXw/eimgoM=
X-Google-Smtp-Source: ACHHUZ4r2NEQ0b344cFM+NxVFjB7lpTS2HwPvT0B6f1EZZqO83k8l6VIhdJXqqPVeq9+7PvEiMfsF9Y=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a81:ec05:0:b0:54c:bdc:ef18 with SMTP id
 j5-20020a81ec05000000b0054c0bdcef18mr1676890ywm.5.1682618635451; Thu, 27 Apr
 2023 11:03:55 -0700 (PDT)
Date:   Thu, 27 Apr 2023 11:03:53 -0700
In-Reply-To: <20230426085122.376768-2-gilad9366@gmail.com>
Mime-Version: 1.0
References: <20230426085122.376768-1-gilad9366@gmail.com> <20230426085122.376768-2-gilad9366@gmail.com>
Message-ID: <ZEq5CV/Yr/KqmufE@google.com>
Subject: Re: [PATCH bpf,v3 1/4] bpf: factor out socket lookup functions for
 the TC hookpoint.
From:   Stanislav Fomichev <sdf@google.com>
To:     Gilad Sever <gilad9366@gmail.com>
Cc:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz,
        eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/26, Gilad Sever wrote:
> Change BPF helper socket lookup functions to use TC specific variants:
> bpf_tc_sk_lookup_tcp() / bpf_tc_sk_lookup_udp() / bpf_tc_skc_lookup_tcp()
> instead of sharing implementation with the cg / sk_skb hooking points.
> This allows introducing a separate logic for the TC flow.
> 
> The tc functions are identical to the original code.
> 
> Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
> Signed-off-by: Gilad Sever <gilad9366@gmail.com>

Acked-by: Stanislav Fomichev <sdf@google.com>

> ---
>  net/core/filter.c | 63 ++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 60 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 1d6f165923bf..5910956f4e0d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6701,6 +6701,63 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
>  	.arg5_type	= ARG_ANYTHING,
>  };
>  
> +BPF_CALL_5(bpf_tc_skc_lookup_tcp, struct sk_buff *, skb,
> +	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
> +{
> +	return (unsigned long)bpf_skc_lookup(skb, tuple, len, IPPROTO_TCP,
> +					     netns_id, flags);
> +}
> +
> +static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
> +	.func		= bpf_tc_skc_lookup_tcp,
> +	.gpl_only	= false,
> +	.pkt_access	= true,
> +	.ret_type	= RET_PTR_TO_SOCK_COMMON_OR_NULL,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
> +	.arg3_type	= ARG_CONST_SIZE,
> +	.arg4_type	= ARG_ANYTHING,
> +	.arg5_type	= ARG_ANYTHING,
> +};
> +
> +BPF_CALL_5(bpf_tc_sk_lookup_tcp, struct sk_buff *, skb,
> +	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
> +{
> +	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_TCP,
> +					    netns_id, flags);
> +}
> +
> +static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
> +	.func		= bpf_tc_sk_lookup_tcp,
> +	.gpl_only	= false,
> +	.pkt_access	= true,
> +	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
> +	.arg3_type	= ARG_CONST_SIZE,
> +	.arg4_type	= ARG_ANYTHING,
> +	.arg5_type	= ARG_ANYTHING,
> +};
> +
> +BPF_CALL_5(bpf_tc_sk_lookup_udp, struct sk_buff *, skb,
> +	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
> +{
> +	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_UDP,
> +					    netns_id, flags);
> +}
> +
> +static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
> +	.func		= bpf_tc_sk_lookup_udp,
> +	.gpl_only	= false,
> +	.pkt_access	= true,
> +	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
> +	.arg3_type	= ARG_CONST_SIZE,
> +	.arg4_type	= ARG_ANYTHING,
> +	.arg5_type	= ARG_ANYTHING,
> +};
> +
>  BPF_CALL_1(bpf_sk_release, struct sock *, sk)
>  {
>  	if (sk && sk_is_refcounted(sk))
> @@ -7954,9 +8011,9 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  #endif
>  #ifdef CONFIG_INET
>  	case BPF_FUNC_sk_lookup_tcp:
> -		return &bpf_sk_lookup_tcp_proto;
> +		return &bpf_tc_sk_lookup_tcp_proto;
>  	case BPF_FUNC_sk_lookup_udp:
> -		return &bpf_sk_lookup_udp_proto;
> +		return &bpf_tc_sk_lookup_udp_proto;
>  	case BPF_FUNC_sk_release:
>  		return &bpf_sk_release_proto;
>  	case BPF_FUNC_tcp_sock:
> @@ -7964,7 +8021,7 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  	case BPF_FUNC_get_listener_sock:
>  		return &bpf_get_listener_sock_proto;
>  	case BPF_FUNC_skc_lookup_tcp:
> -		return &bpf_skc_lookup_tcp_proto;
> +		return &bpf_tc_skc_lookup_tcp_proto;
>  	case BPF_FUNC_tcp_check_syncookie:
>  		return &bpf_tcp_check_syncookie_proto;
>  	case BPF_FUNC_skb_ecn_set_ce:
> -- 
> 2.34.1
> 
