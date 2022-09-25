Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EBF5E91C7
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 11:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiIYJQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 05:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiIYJQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 05:16:10 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1D526AC0
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 02:16:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 224EF2052E;
        Sun, 25 Sep 2022 11:16:05 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pvvN5f_I60zr; Sun, 25 Sep 2022 11:16:04 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8643F20504;
        Sun, 25 Sep 2022 11:16:04 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 7557580004A;
        Sun, 25 Sep 2022 11:16:04 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 25 Sep 2022 11:16:04 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 25 Sep
 2022 11:16:03 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 76D943182DAE; Sun, 25 Sep 2022 11:16:03 +0200 (CEST)
Date:   Sun, 25 Sep 2022 11:16:03 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 4/8] xfrm: add TX datapath support for
 IPsec full offload mode
Message-ID: <20220925091603.GS2602992@gauss3.secunet.de>
References: <cover.1662295929.git.leonro@nvidia.com>
 <0a44d3b02479e5b19831038f9dc3a99259fa50f3.1662295929.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0a44d3b02479e5b19831038f9dc3a99259fa50f3.1662295929.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 04, 2022 at 04:15:38PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In IPsec full mode, the device is going to encrypt and encapsulate
> packets that are associated with offloaded policy. After successful
> policy lookup to indicate if packets should be offloaded or not,
> the stack forwards packets to the device to do the magic.
> 
> Signed-off-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Huy Nguyen <huyn@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  net/xfrm/xfrm_device.c | 15 +++++++++++++--
>  net/xfrm/xfrm_output.c | 12 +++++++++++-
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
> index 1cc482e9c87d..2d37bb86914a 100644
> --- a/net/xfrm/xfrm_device.c
> +++ b/net/xfrm/xfrm_device.c
> @@ -120,6 +120,16 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
>  	if (xo->flags & XFRM_GRO || x->xso.dir == XFRM_DEV_OFFLOAD_IN)
>  		return skb;
>  
> +	/* The packet was sent to HW IPsec full offload engine,
> +	 * but to wrong device. Drop the packet, so it won't skip
> +	 * XFRM stack.
> +	 */
> +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL && x->xso.dev != dev) {
> +		kfree_skb(skb);
> +		dev_core_stats_tx_dropped_inc(dev);
> +		return NULL;
> +	}
> +
>  	/* This skb was already validated on the upper/virtual dev */
>  	if ((x->xso.dev != dev) && (x->xso.real_dev == dev))
>  		return skb;
> @@ -369,8 +379,9 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
>  	if (!x->type_offload || x->encap)
>  		return false;
>  
> -	if ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
> -	    (!xdst->child->xfrm)) {
> +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL ||
> +	    ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
> +	     !xdst->child->xfrm)) {
>  		mtu = xfrm_state_mtu(x, xdst->child_mtu_cached);
>  		if (skb->len <= mtu)
>  			goto ok;
> diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> index 9a5e79a38c67..dde009be8463 100644
> --- a/net/xfrm/xfrm_output.c
> +++ b/net/xfrm/xfrm_output.c
> @@ -494,7 +494,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
>  	struct xfrm_state *x = dst->xfrm;
>  	struct net *net = xs_net(x);
>  
> -	if (err <= 0)
> +	if (err <= 0 || x->xso.type == XFRM_DEV_OFFLOAD_FULL)
>  		goto resume;

You check here that the state is marked as 'full offload' before
you skip the SW xfrm handling, but I don't see where you check
that the policy that led to this state is offloaded too. Also,
we have to make sure that both, policy and state is offloaded to
the same device. Looks like this part is missing.

