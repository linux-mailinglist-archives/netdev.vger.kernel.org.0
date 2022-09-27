Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D578A5EC027
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiI0Kw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiI0Kwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:52:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49A81181D1;
        Tue, 27 Sep 2022 03:52:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9C3DB81AF4;
        Tue, 27 Sep 2022 10:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D10C43470;
        Tue, 27 Sep 2022 10:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664275964;
        bh=V1TaW2oROCwNK3rv/VU134+Cp/5eURuaoMDkbCIgTrE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ViDwanKy4AJR6Y9SER9j+FeVMJGc8JtQfUsByJ+rjVDVECjcnWcVibkjpWu1JZ2of
         1jWQj+jQAXbzpKj0djfkWwmabv/p7RmElfxnc8n0s9K4lFpJluI2zyCjxsZA/OVZ4n
         AMXhdh/9g2SaV2UdIM5uIVaDAFBwLNB4HRNCUByWujOlPf7qfKSch+IMlCds+jJsvZ
         JUntHSCXXyWkfQcfK7MfEIXmW+cDP557GdN4J4wEliuNyGiI8r89ALu3YoFD8RbBGX
         aG9iz4olkv93+VZAdR3kBNnJE4xLdGkWxXzcqOMr//1E/JwOMKQWHDqHooCuXwCiS3
         CJ+IFJK/2SvTg==
Date:   Tue, 27 Sep 2022 13:52:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christian Langrock <christian.langrock@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] xfrm: replay: Fix ESN wrap around for GSO
Message-ID: <YzLV+AntI0xpN6Aq@unreal>
References: <ebe29739-7027-a95f-160f-8f9d6522a09d@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebe29739-7027-a95f-160f-8f9d6522a09d@secunet.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 11:28:08AM +0200, Christian Langrock wrote:
> When using GSO it can happen that the wrong seq_hi is used for the last
> packets before the wrap around. To avoid this, we should serialize this
> last GSO packet.
> 
> Fixes: d7dbefc45cf55 ("xfrm: Add xfrm_replay_overflow functions for
> offloading")
> 

Please remove extra line between Fixes and SOB.

> Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
> ---
>  include/net/xfrm.h     |  1 +
>  net/xfrm/xfrm_output.c |  2 +-
>  net/xfrm/xfrm_replay.c | 36 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index 6e8fa98f786f..49d6d974f493 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -1749,6 +1749,7 @@ void xfrm_replay_advance(struct xfrm_state *x,
> __be32 net_seq);
>  int xfrm_replay_check(struct xfrm_state *x, struct sk_buff *skb, __be32
> net_seq);
>  void xfrm_replay_notify(struct xfrm_state *x, int event);
>  int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb);
> +int xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb);
>  int xfrm_replay_recheck(struct xfrm_state *x, struct sk_buff *skb,
> __be32 net_seq);
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

Maybe it is perfectly fine to call xfrm_output_gso(), but your commit
message doesn't explain what is wrong with standard flow.

>  				return xfrm_output_gso(net, sk, skb);
> 
>  			skb_shinfo(skb)->gso_type |= SKB_GSO_ESP;
> diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
> index 9277d81b344c..6c696b6c0a22 100644
> --- a/net/xfrm/xfrm_replay.c
> +++ b/net/xfrm/xfrm_replay.c
> @@ -750,6 +750,37 @@ int xfrm_replay_overflow(struct xfrm_state *x,
> struct sk_buff *skb)
> 
>  	return xfrm_replay_overflow_offload(x, skb);
>  }
> +
> +static int xfrm_replay_overflow_check_offload_esn(struct xfrm_state *x,
> struct sk_buff *skb)
> +{

The function returns true or false and better to have "static bool ..."
as a prototype.

> +	int ret = 0;
> +	struct xfrm_offload *xo = xfrm_offload(skb);
> +	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
> +	__u32 oseq = replay_esn->oseq;

Reversed Christmas tree.

> +
> +	if (xo && x->type->flags & XFRM_TYPE_REPLAY_PROT) {
> +		if (skb_is_gso(skb)) {

You already checked this. Maybe it is more future proof to write like
this, but it is not optimal from performance POV as you perform same
checks in datapath.

> +			oseq = oseq + 1 + skb_shinfo(skb)->gso_segs;
> +			if (unlikely(oseq < replay_esn->oseq)) {
> +				ret = 1;
> +			}
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +int xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb)

This function doesn't do much except call to another function.

> +{
> +	switch (x->repl_mode) {
> +	case XFRM_REPLAY_MODE_ESN:
> +		return xfrm_replay_overflow_check_offload_esn(x, skb);
> +	}
> +
> +	return 0;
> +
> +}
> +
>  #else
>  int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
>  {
> @@ -764,6 +795,11 @@ int xfrm_replay_overflow(struct xfrm_state *x,
> struct sk_buff *skb)
> 
>  	return __xfrm_replay_overflow(x, skb);
>  }
> +
> +int xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb)
> +{
> +	return 0;
> +}
>  #endif
> 
>  int xfrm_init_replay(struct xfrm_state *x)
> -- 
> 2.37.1.223.g6a475b71f8
