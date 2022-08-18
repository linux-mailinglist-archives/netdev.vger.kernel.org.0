Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A37598449
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244484AbiHRNfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243887AbiHRNfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:35:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955463CBE8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:34:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31F8A61668
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 13:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF30C433C1;
        Thu, 18 Aug 2022 13:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660829698;
        bh=nMsl7fkywPW/eTyZ9+lCTnYDd7OjEdzw65s4kXwivcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=URQ8s9Zom2/HHMgkQSMdfoLrlcVewdJqa/18hM2c/ennpcM9r+2B7ARziAS3VOydS
         pch9xFt0vp4Dq0+xf9B0z8I/udIuN4dhPFHxlQ+0cOrSXJ85W1pLdATwLOSVludWdw
         Odzjxu8209/948An6Xw8799+vObEM4vbKMVF308ixHOYidvRzCz6vpSoKp0PxT9ghe
         lcx/svsYTQwgyHvPJBJLYKTVLwif/G2yU0i8zYPeDh8hwf9c5Jt4+nfbVJrn/E0rnA
         A8/HuXslGAtqKSruDO4y4OuHCGfrLwKj27tDo/J1zbWgxI7KHB7EAFsNG1qVjU1sMy
         qmCIVuo8QTBrw==
Date:   Thu, 18 Aug 2022 16:34:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 4/6] xfrm: add TX datapath support for IPsec
 full offload mode
Message-ID: <Yv4//oQssmUDaRwn@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <aa0b418e5bccb0b32625f8615124c8d0e58d9980.1660639789.git.leonro@nvidia.com>
 <20220818102451.GE566407@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818102451.GE566407@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:24:51PM +0200, Steffen Klassert wrote:
> On Tue, Aug 16, 2022 at 11:59:25AM +0300, Leon Romanovsky wrote:
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
> >  net/xfrm/xfrm_device.c | 13 +++++++++++++
> >  net/xfrm/xfrm_output.c | 20 ++++++++++++++++++++
> >  2 files changed, 33 insertions(+)
> > 
> > diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
> > index 1cc482e9c87d..db5ebd36f68c 100644
> > --- a/net/xfrm/xfrm_device.c
> > +++ b/net/xfrm/xfrm_device.c
> 
> > @@ -366,6 +376,9 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
> >  	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
> >  	struct net_device *dev = x->xso.dev;
> >  
> > +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL)
> > +		goto ok;
> 
> You skip the PMTU checks here. I've seen that you check
> the packet length against the device MTU in one of your
> mlx5 patches, but that does not help if the PMTU is below.

If device supports transformation of the packet, this packet
won't be counted as XFRM anymore. I'm not sure that we need
to perform XFRM specific checks.

> 
> >  
> > diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> > index 555ab35cd119..27a8dac9ca7d 100644
> > --- a/net/xfrm/xfrm_output.c
> > +++ b/net/xfrm/xfrm_output.c
> > @@ -719,6 +719,26 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
> >  		break;
> >  	}
> >  
> > +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL) {
> > +		struct dst_entry *dst = skb_dst_pop(skb);
> > +
> > +		if (!dst || !xfrm_dev_offload_ok(skb, x)) {
> > +			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
> > +			kfree_skb(skb);
> > +			return -EHOSTUNREACH;
> > +		}
> > +
> > +		skb_dst_set(skb, dst);
> > +		err = skb_dst(skb)->ops->local_out(net, skb->sk, skb);
> > +		if (unlikely(err != 1))
> > +			return err;
> > +
> > +		if (!skb_dst(skb)->xfrm)
> > +			return dst_output(net, skb->sk, skb);
> > +
> > +		return 0;
> 
> You leak skb here. Also, this skb needs another tfm because
> skb_dst(skb)->xfrm is set.

I will fix, thanks.

> 
