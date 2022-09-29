Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711B95EF775
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbiI2O0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbiI2OZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:25:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6F2B07CA;
        Thu, 29 Sep 2022 07:25:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1A9E613B3;
        Thu, 29 Sep 2022 14:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A10FC433C1;
        Thu, 29 Sep 2022 14:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664461538;
        bh=dbabHMGfEfLEGS3hjsP2RvaXwXtnmcqRdOWhJhnHSRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TyomQpdILBEerbw0vhH5xbo1BouQ0M6mV9uzRxefVwGwM7DpyEaql6PvfaABIfucv
         YbsbbfNQHNK9Kl4aRQ3t7Wd1pr0tXvz7OxlqumKV8AuqSG46XCc+CPYlavIRw4tUDC
         IsDjjA0M0GK+4xdnNd1Tk2TJRx2u1EZVENDrpbgWj3lbSJdDrIsuXtQiCeNmgIrPwU
         aIrZQ2ZUSDGw8TSrwITGqFjSh6UTURBa6/RxRWDhWAt8gl6YuM73i4ybJOT5RU4nxe
         DJnyzWO76CRh13Orojanbu4XXm69YYB6Wo2ieArDL8jeaW9pzkiICbZEv6gLwWamcK
         DHGzRKhxJPwNA==
Date:   Thu, 29 Sep 2022 17:25:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christian Langrock <christian.langrock@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH ipsec v4] xfrm: replay: Fix ESN wrap around for GSO
Message-ID: <YzWq3aENyZe4RksO@unreal>
References: <778339a5-e069-0755-8287-75e39d8050e0@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <778339a5-e069-0755-8287-75e39d8050e0@secunet.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 01:52:07PM +0200, Christian Langrock wrote:
> When using GSO it can happen that the wrong seq_hi is used for the last
> packets before the wrap around. This can lead to double usage of a
> sequence number. To avoid this, we should serialize this last GSO
> packet.
> 
> Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for...")

Sorry that I missed it in previous reviews, but please never truncate
fixes line.

> Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> Changes in v4:
>  - move changelog within comment
>  - add reviewer
> 
> Changes in v3:
> - fix build
> - remove wrapper function
> 
> Changes in v2:
> - switch to bool as return value
> - remove switch case in wrapper function
> ---
>  include/net/xfrm.h     |  1 +
>  net/xfrm/xfrm_output.c |  2 +-
>  net/xfrm/xfrm_replay.c | 26 ++++++++++++++++++++++++++
>  3 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index 6e8fa98f786f..b845f911767c 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -1749,6 +1749,7 @@ void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq);
>  int xfrm_replay_check(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
>  void xfrm_replay_notify(struct xfrm_state *x, int event);
>  int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb);
> +bool xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb);
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
> index 9277d81b344c..23858eb5eab4 100644
> --- a/net/xfrm/xfrm_replay.c
> +++ b/net/xfrm/xfrm_replay.c
> @@ -750,6 +750,27 @@ int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
>  
>  	return xfrm_replay_overflow_offload(x, skb);
>  }
> +
> +static bool xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb)
> +{
> +	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
> +	__u32 oseq = replay_esn->oseq;
> +
> +	/* We assume that this function is called with
> +	 * skb_is_gso(skb) == true
> +	 */
> +
> +	if (x->repl_mode == XFRM_REPLAY_MODE_ESN) {
> +		if (x->type->flags & XFRM_TYPE_REPLAY_PROT) {
> +			oseq = oseq + 1 + skb_shinfo(skb)->gso_segs;
> +			if (unlikely(oseq < replay_esn->oseq))
> +				return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
>  #else
>  int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
>  {
> @@ -764,6 +785,11 @@ int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
>  
>  	return __xfrm_replay_overflow(x, skb);
>  }
> +
> +bool xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb)
> +{
> +	return false;
> +}
>  #endif
>  
>  int xfrm_init_replay(struct xfrm_state *x)
> -- 
> 2.37.1.223.g6a475b71f8
> 
> 
