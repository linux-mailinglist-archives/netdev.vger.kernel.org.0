Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCB36F0BB4
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 20:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243708AbjD0SDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 14:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjD0SDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 14:03:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5AD40F0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 11:03:29 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1a6ce2cdb92so93116775ad.3
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 11:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682618609; x=1685210609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQSj4LpooRjB5FoMJ53KaKTza3Ld5W3Dd2MFQvwsKqs=;
        b=6Em1rD8+ZUYGqbgudZ9AbaFrS2lXTd24Q45HzlC9Ixk8jT3rBAkLq4syJHzgos9Iy4
         tAwLjhljhI/cLi5BHwvXGE7fmnwIcDWtP1Dd5VyrxEXyOs0YJtyOnsd7vy8FvEK41zsN
         FnGc4Fmw23qxnTpghLlF1ool5Jlx5/SkcGWsL+1LsrJZEHV4pfiTivA2SvaKv9Q25PYt
         iRO/2SkYMVjsdCqn2uUKXzk3X53/C5amRvVOw0qkZPxrP96NX4BNPc2d6vhOLI4et/rC
         QUUbZhYJUXW+3o7FabTUp+mZttyyNBBdgIHu/jEHXfELtD0CQu5PjtFqvpeOXZPgTv2o
         8ekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682618609; x=1685210609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQSj4LpooRjB5FoMJ53KaKTza3Ld5W3Dd2MFQvwsKqs=;
        b=KirSwky8MdJ9oV+EY+UntqVC8VxY1sEVPLpb64DRiHOEevEsuHh61N7u7vCzFKfWdS
         fp8ybWyhNiSROtG+NQRvPv75KeLbudVFrG3Oc4KEpfZfJxFq9VA3EETV1MKTTrrjxsM3
         Y5ROM4yXB8/cxoRWysyNIL8Zfd8+U/31fG3/s0SNhEUs2Wt5OLOZlH1NbuEdASoWYLzC
         YUQG/F0Pmr6auxlBuMahEZy+EPZDGe3Q0iIyX1Dsu1ATweZIwCga2Gh2M4FFyto9FTnQ
         zM33vZi9tItf0J4wigCI/K7VSX+B62Bc1BRWaeK8PUKsQrWQ1MOhlK2u8zKAGQqolKGV
         hO+Q==
X-Gm-Message-State: AC+VfDxMZRJoproKv/RwUWup2A49ybge7Bn/au6mxYGrsMoClJfMd3M1
        ZM6jF2uelba9p9B0MFYt4Rho/V4=
X-Google-Smtp-Source: ACHHUZ6bh+IXnbdDs8bT9lwb3YLGimmxY1LXDvK/pPXLkw3lh68vOVhrbMJi6Pdu67A8OHodl9FWsTM=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:487:b0:1a6:b221:daa1 with SMTP id
 jj7-20020a170903048700b001a6b221daa1mr781558plb.0.1682618608845; Thu, 27 Apr
 2023 11:03:28 -0700 (PDT)
Date:   Thu, 27 Apr 2023 11:03:27 -0700
In-Reply-To: <20230426085122.376768-4-gilad9366@gmail.com>
Mime-Version: 1.0
References: <20230426085122.376768-1-gilad9366@gmail.com> <20230426085122.376768-4-gilad9366@gmail.com>
Message-ID: <ZEq47yhL58mceV3C@google.com>
Subject: Re: [PATCH bpf,v3 3/4] bpf: fix bpf socket lookup from tc/xdp to
 respect socket VRF bindings
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
> When calling bpf_sk_lookup_tcp(), bpf_sk_lookup_udp() or
> bpf_skc_lookup_tcp() from tc/xdp ingress, VRF socket bindings aren't
> respoected, i.e. unbound sockets are returned, and bound sockets aren't
> found.
> 
> VRF binding is determined by the sdif argument to sk_lookup(), however
> when called from tc the IP SKB control block isn't initialized and thus
> inet{,6}_sdif() always returns 0.
> 
> Fix by calculating sdif for the tc/xdp flows by observing the device's
> l3 enslaved state.
> 
> The cg/sk_skb hooking points which are expected to support
> inet{,6}_sdif() pass sdif=-1 which makes __bpf_skc_lookup() use the
> existing logic.
> 
> Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
> Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
> Signed-off-by: Gilad Sever <gilad9366@gmail.com>

Acked-by: Stanislav Fomichev <sdf@google.com>

with one nit below

> ---
> v3: Rename bpf_l2_sdif() to dev_sdif() as suggested by Stanislav Fomichev
> ---
>  net/core/filter.c | 63 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 42 insertions(+), 21 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index f43f86fc1235..894913aaa29f 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6529,12 +6529,11 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
>  static struct sock *
>  __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>  		 struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
> -		 u64 flags)
> +		 u64 flags, int sdif)
>  {
>  	struct sock *sk = NULL;
>  	struct net *net;
>  	u8 family;
> -	int sdif;
>  
>  	if (len == sizeof(tuple->ipv4))
>  		family = AF_INET;
> @@ -6546,10 +6545,12 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>  	if (unlikely(flags || !((s32)netns_id < 0 || netns_id <= S32_MAX)))
>  		goto out;
>  
> -	if (family == AF_INET)
> -		sdif = inet_sdif(skb);
> -	else
> -		sdif = inet6_sdif(skb);
> +	if (sdif < 0) {
> +		if (family == AF_INET)
> +			sdif = inet_sdif(skb);
> +		else
> +			sdif = inet6_sdif(skb);
> +	}
>  
>  	if ((s32)netns_id < 0) {
>  		net = caller_net;
> @@ -6569,10 +6570,11 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>  static struct sock *
>  __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>  		struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
> -		u64 flags)
> +		u64 flags, int sdif)
>  {
>  	struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
> -					   ifindex, proto, netns_id, flags);
> +					   ifindex, proto, netns_id, flags,
> +					   sdif);
>  
>  	if (sk) {
>  		struct sock *sk2 = sk_to_full_sk(sk);
> @@ -6612,7 +6614,7 @@ bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>  	}
>  
>  	return __bpf_skc_lookup(skb, tuple, len, caller_net, ifindex, proto,
> -				netns_id, flags);
> +				netns_id, flags, -1);
>  }
>  
>  static struct sock *
> @@ -6701,15 +6703,25 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
>  	.arg5_type	= ARG_ANYTHING,
>  };
 

[..]

> +static int dev_sdif(const struct net_device *dev)
> +{
> +#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
> +	if (netif_is_l3_slave(dev))
> +		return dev->ifindex;
> +#endif
> +	return 0;
> +}


nit: should this go into include/linux/netdevice.h?

> +
>  BPF_CALL_5(bpf_tc_skc_lookup_tcp, struct sk_buff *, skb,
>  	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
>  {
>  	struct net *caller_net = dev_net(skb->dev);
> +	int sdif = dev_sdif(skb->dev);
>  	int ifindex = skb->dev->ifindex;
>  
>  	return (unsigned long)__bpf_skc_lookup(skb, tuple, len, caller_net,
>  					       ifindex, IPPROTO_TCP, netns_id,
> -					       flags);
> +					       flags, sdif);
>  }
>  
>  static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
> @@ -6728,11 +6740,12 @@ BPF_CALL_5(bpf_tc_sk_lookup_tcp, struct sk_buff *, skb,
>  	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
>  {
>  	struct net *caller_net = dev_net(skb->dev);
> +	int sdif = dev_sdif(skb->dev);
>  	int ifindex = skb->dev->ifindex;
>  
>  	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
>  					      ifindex, IPPROTO_TCP, netns_id,
> -					      flags);
> +					      flags, sdif);
>  }
>  
>  static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
> @@ -6751,11 +6764,12 @@ BPF_CALL_5(bpf_tc_sk_lookup_udp, struct sk_buff *, skb,
>  	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
>  {
>  	struct net *caller_net = dev_net(skb->dev);
> +	int sdif = dev_sdif(skb->dev);
>  	int ifindex = skb->dev->ifindex;
>  
>  	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
>  					      ifindex, IPPROTO_UDP, netns_id,
> -					      flags);
> +					      flags, sdif);
>  }
>  
>  static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
> @@ -6788,11 +6802,13 @@ BPF_CALL_5(bpf_xdp_sk_lookup_udp, struct xdp_buff *, ctx,
>  	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
>  {
>  	struct net *caller_net = dev_net(ctx->rxq->dev);
> -	int ifindex = ctx->rxq->dev->ifindex;
> +	struct net_device *dev = ctx->rxq->dev;
> +	int sdif = dev_sdif(dev);
> +	int ifindex = dev->ifindex;
>  
>  	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len, caller_net,
>  					      ifindex, IPPROTO_UDP, netns_id,
> -					      flags);
> +					      flags, sdif);
>  }
>  
>  static const struct bpf_func_proto bpf_xdp_sk_lookup_udp_proto = {
> @@ -6811,11 +6827,13 @@ BPF_CALL_5(bpf_xdp_skc_lookup_tcp, struct xdp_buff *, ctx,
>  	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
>  {
>  	struct net *caller_net = dev_net(ctx->rxq->dev);
> -	int ifindex = ctx->rxq->dev->ifindex;
> +	struct net_device *dev = ctx->rxq->dev;
> +	int sdif = dev_sdif(dev);
> +	int ifindex = dev->ifindex;
>  
>  	return (unsigned long)__bpf_skc_lookup(NULL, tuple, len, caller_net,
>  					       ifindex, IPPROTO_TCP, netns_id,
> -					       flags);
> +					       flags, sdif);
>  }
>  
>  static const struct bpf_func_proto bpf_xdp_skc_lookup_tcp_proto = {
> @@ -6834,11 +6852,13 @@ BPF_CALL_5(bpf_xdp_sk_lookup_tcp, struct xdp_buff *, ctx,
>  	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
>  {
>  	struct net *caller_net = dev_net(ctx->rxq->dev);
> -	int ifindex = ctx->rxq->dev->ifindex;
> +	struct net_device *dev = ctx->rxq->dev;
> +	int sdif = dev_sdif(dev);
> +	int ifindex = dev->ifindex;
>  
>  	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len, caller_net,
>  					      ifindex, IPPROTO_TCP, netns_id,
> -					      flags);
> +					      flags, sdif);
>  }
>  
>  static const struct bpf_func_proto bpf_xdp_sk_lookup_tcp_proto = {
> @@ -6858,7 +6878,8 @@ BPF_CALL_5(bpf_sock_addr_skc_lookup_tcp, struct bpf_sock_addr_kern *, ctx,
>  {
>  	return (unsigned long)__bpf_skc_lookup(NULL, tuple, len,
>  					       sock_net(ctx->sk), 0,
> -					       IPPROTO_TCP, netns_id, flags);
> +					       IPPROTO_TCP, netns_id, flags,
> +					       -1);
>  }
>  
>  static const struct bpf_func_proto bpf_sock_addr_skc_lookup_tcp_proto = {
> @@ -6877,7 +6898,7 @@ BPF_CALL_5(bpf_sock_addr_sk_lookup_tcp, struct bpf_sock_addr_kern *, ctx,
>  {
>  	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len,
>  					      sock_net(ctx->sk), 0, IPPROTO_TCP,
> -					      netns_id, flags);
> +					      netns_id, flags, -1);
>  }
>  
>  static const struct bpf_func_proto bpf_sock_addr_sk_lookup_tcp_proto = {
> @@ -6896,7 +6917,7 @@ BPF_CALL_5(bpf_sock_addr_sk_lookup_udp, struct bpf_sock_addr_kern *, ctx,
>  {
>  	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len,
>  					      sock_net(ctx->sk), 0, IPPROTO_UDP,
> -					      netns_id, flags);
> +					      netns_id, flags, -1);
>  }
>  
>  static const struct bpf_func_proto bpf_sock_addr_sk_lookup_udp_proto = {
> -- 
> 2.34.1
> 
