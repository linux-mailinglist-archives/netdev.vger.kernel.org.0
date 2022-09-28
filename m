Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122115ED493
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 08:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiI1GSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 02:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiI1GSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 02:18:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5849D1114FB;
        Tue, 27 Sep 2022 23:18:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B38D361D07;
        Wed, 28 Sep 2022 06:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CC9C433D6;
        Wed, 28 Sep 2022 06:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664345892;
        bh=327RjZBYHhyky/L1MBCPFNUus57bqxAUI74E0Of92qc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oC2syNDx+fISDkRPvz6XKNdMmvKgJiz4/4lpsHZFvPvqDbkbTjPPWrWlI613xfm2V
         bEyGO8tj3IW2S0gGtdDpsP8x6297rRvhJP32UCc6IQ1zDdODqgk59bLXop5tSKwbN5
         ma/FRyGJjW9JQ7csYEdC23I7LiTb56xNGg9rv9fqKJVdu6//RHkoZc4bDawXrcTV1D
         686IFvvV3TH2rz2b5JvTlom4wDAXQTrquYCh0FZpNWir++abJQgBDzjIkN6HoRyPki
         mDrDOI3fKBatxacgLTprnh4QlA6V2ElkqrhKvJa1NiBlJaS5xWJFBj11A03eOsZrd5
         XJd5Xp5L45TmQ==
Date:   Wed, 28 Sep 2022 09:18:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christian Langrock <christian.langrock@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-ipsec v2] xfrm: replay: Fix ESN wrap around for GSO
Message-ID: <YzPnH/JrIFbPteR3@unreal>
References: <fe554921-104e-2365-a09b-812a1cedac65@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe554921-104e-2365-a09b-812a1cedac65@secunet.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 02:59:50PM +0200, Christian Langrock wrote:
> When using GSO it can happen that the wrong seq_hi is used for the last
> packets before the wrap around. This can lead to double usage of a
> sequence number. To avoid this, we should serialize this last GSO
> packet.
> 
> Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for...")
> Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
> ---
>  include/net/xfrm.h     |  1 +
>  net/xfrm/xfrm_output.c |  2 +-
>  net/xfrm/xfrm_replay.c | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index 6e8fa98f786f..49d6d974f493 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -1749,6 +1749,7 @@ void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq);
>  int xfrm_replay_check(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
>  void xfrm_replay_notify(struct xfrm_state *x, int event);
>  int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb);
> +int xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb);
>  int xfrm_replay_recheck(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
>  
>  static inline int xfrm_aevent_is_on(struct net *net)
> diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> index 9a5e79a38c67..c470a68d9c88 100644
> --- a/net/xfrm/xfrm_output.c
> +++ b/net/xfrm/xfrm_output.c
> @@ -738,7 +738,7 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
>  		skb->encapsulation = 1;
>  
>  		if (skb_is_gso(skb)) {
> -			if (skb->inner_protocol)
> +			if (skb->inner_protocol || xfrm_replay_overflow_check(x, skb))
>  				return xfrm_output_gso(net, sk, skb);
>  
>  			skb_shinfo(skb)->gso_type |= SKB_GSO_ESP;
> diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
> index 9277d81b344c..991cfc7a091d 100644
> --- a/net/xfrm/xfrm_replay.c
> +++ b/net/xfrm/xfrm_replay.c
> @@ -750,6 +750,34 @@ int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
>  
>  	return xfrm_replay_overflow_offload(x, skb);
>  }
> +
> +static bool xfrm_replay_overflow_check_offload_esn(struct xfrm_state *x, struct sk_buff *skb)
> +{
> +	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
> +	__u32 oseq = replay_esn->oseq;
> +	bool ret = false;
> +
> +	/* We assume that this function is called with
> +	 * skb_is_gso(skb) == true
> +	 */
> +
> +	if (x->type->flags & XFRM_TYPE_REPLAY_PROT) {
> +		oseq = oseq + 1 + skb_shinfo(skb)->gso_segs;
> +		if (unlikely(oseq < replay_esn->oseq))
> +			ret = true;

return true;

> +	}
> +
> +	return ret;

return false;

> +}
> +
> +bool xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb)
> +{
> +	if (x->repl_mode == XFRM_REPLAY_MODE_ESN)
> +		return xfrm_replay_overflow_check_offload_esn(x, skb);
> +
> +	return false;
> +}

I still think that functions above should be merged into one. This is
called only if xfrm_dev_offload_ok() success -> in crypto offload path.

Thanks

> +
>  #else
>  int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
>  {
> @@ -764,6 +792,11 @@ int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
>  
>  	return __xfrm_replay_overflow(x, skb);
>  }
> +
> +int xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb)

int -> bool

> +{
> +	return 0;
> +}
>  #endif
>  
>  int xfrm_init_replay(struct xfrm_state *x)
> -- 
> 2.37.1.223.g6a475b71f8
> 
