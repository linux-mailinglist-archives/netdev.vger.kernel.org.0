Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E6A5E993F
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 08:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiIZGHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 02:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiIZGHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 02:07:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2016B1EC79
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 23:07:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEC83B80D5D
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 06:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DB6C433D6;
        Mon, 26 Sep 2022 06:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664172412;
        bh=tWxbfV3bKgC3n1paqBQYL027hNBHD7l18BpKdyOeoZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=swVKk6qMxOhzKJE8lPlBdShAMrhJ+8NlTUhHUAmgtVUykTwIN62Q3pdI5tgRT7MUN
         0FWiic9hBJAx4vimHOS/yWn5o1BYJtoY34bf52cW/GNPehF639ubBHt0gw4gDm8Pxc
         FMc/oLN/B4dw+5ThYMcD549xdL42TLi5ZHlROz9QlhVvHmGt0g162urisaNntSwcVe
         p0pkSfNxyIUNogZvxf46tmSwlMw5TmUww1jX246n3bbzeWxRjMljtyMshYbw0xbnNF
         XHIKHIcZZqZW0cKkRraMTuoRALlt8Id6G5xilSEA/7BGbkIRT9R2eEsSOePoTtJ6Q9
         D4DJAshxKvbkA==
Date:   Mon, 26 Sep 2022 09:06:48 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 4/8] xfrm: add TX datapath support for
 IPsec full offload mode
Message-ID: <YzFBeC4ltNmQf9DU@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
 <0a44d3b02479e5b19831038f9dc3a99259fa50f3.1662295929.git.leonro@nvidia.com>
 <20220925091603.GS2602992@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220925091603.GS2602992@gauss3.secunet.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 11:16:03AM +0200, Steffen Klassert wrote:
> On Sun, Sep 04, 2022 at 04:15:38PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > In IPsec full mode, the device is going to encrypt and encapsulate
> > packets that are associated with offloaded policy. After successful
> > policy lookup to indicate if packets should be offloaded or not,
> > the stack forwards packets to the device to do the magic.
> > 
> > Signed-off-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Huy Nguyen <huyn@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  net/xfrm/xfrm_device.c | 15 +++++++++++++--
> >  net/xfrm/xfrm_output.c | 12 +++++++++++-
> >  2 files changed, 24 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
> > index 1cc482e9c87d..2d37bb86914a 100644
> > --- a/net/xfrm/xfrm_device.c
> > +++ b/net/xfrm/xfrm_device.c
> > @@ -120,6 +120,16 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
> >  	if (xo->flags & XFRM_GRO || x->xso.dir == XFRM_DEV_OFFLOAD_IN)
> >  		return skb;
> >  
> > +	/* The packet was sent to HW IPsec full offload engine,
> > +	 * but to wrong device. Drop the packet, so it won't skip
> > +	 * XFRM stack.
> > +	 */
> > +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL && x->xso.dev != dev) {
> > +		kfree_skb(skb);
> > +		dev_core_stats_tx_dropped_inc(dev);
> > +		return NULL;
> > +	}
> > +
> >  	/* This skb was already validated on the upper/virtual dev */
> >  	if ((x->xso.dev != dev) && (x->xso.real_dev == dev))
> >  		return skb;
> > @@ -369,8 +379,9 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
> >  	if (!x->type_offload || x->encap)
> >  		return false;
> >  
> > -	if ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
> > -	    (!xdst->child->xfrm)) {
> > +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL ||
> > +	    ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
> > +	     !xdst->child->xfrm)) {
> >  		mtu = xfrm_state_mtu(x, xdst->child_mtu_cached);
> >  		if (skb->len <= mtu)
> >  			goto ok;
> > diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> > index 9a5e79a38c67..dde009be8463 100644
> > --- a/net/xfrm/xfrm_output.c
> > +++ b/net/xfrm/xfrm_output.c
> > @@ -494,7 +494,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
> >  	struct xfrm_state *x = dst->xfrm;
> >  	struct net *net = xs_net(x);
> >  
> > -	if (err <= 0)
> > +	if (err <= 0 || x->xso.type == XFRM_DEV_OFFLOAD_FULL)
> >  		goto resume;
> 
> You check here that the state is marked as 'full offload' before
> you skip the SW xfrm handling, but I don't see where you check
> that the policy that led to this state is offloaded too. Also,
> we have to make sure that both, policy and state is offloaded to
> the same device. Looks like this part is missing.

In SW flow, users are not required to configure policy. If they don't
have policy, the packet will be encrypted and sent anyway.

The full offload follows same semantic. The missing offloaded policy is
equal to no policy at all.

I don't think that extra checks are needed.

Thanks

> 
