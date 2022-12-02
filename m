Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77ACC640CBB
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 18:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbiLBR7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 12:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiLBR7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 12:59:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE18E4670
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 09:59:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12D7EB82224
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 17:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50330C433C1;
        Fri,  2 Dec 2022 17:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670003974;
        bh=XKJw+aMFegbsLrFeI/MgPRDGeLpbG4dekMEvsKd437o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JxB4yE33k/9e9gWKPC178EaM5CFUDKL67QJl9UkVZZabBD+cK6HVRmIYvHe7Fjq+h
         /J+vE+X+jD2GVrFz9RcZ/IYpE9r5ajEutQuJdTY3+veAqYkSbx2aF8c7ubd47ljigV
         pW130wP5mB1yJqAqcypTqbCJaxgQjSfECAW975LUgLBYNC2xUqxV9xxOIizNiYwt2g
         0fRFwA+Cp4fPtueA7AYenVYNN9OpTcjSfapI0u4E5H20UNaW/Hg/Z+XdT3ecTa4wiO
         juV9vtfc+8Yk+1zNTwy1Ga9JkWCgLs0zGWt9HtiN6o0cGxVLfBp09LwmuMO9Zh1gdC
         6vRm2mXVkHAHA==
Date:   Fri, 2 Dec 2022 19:59:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v9 4/8] xfrm: add TX datapath support for IPsec
 packet offload mode
Message-ID: <Y4o9As2tt5RxoDgP@unreal>
References: <cover.1669547603.git.leonro@nvidia.com>
 <5bb21e69cff4e720c4f057238902299a3bd15a04.1669547603.git.leonro@nvidia.com>
 <20221202093028.GZ704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202093028.GZ704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 10:30:28AM +0100, Steffen Klassert wrote:
> On Sun, Nov 27, 2022 at 01:18:14PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > In IPsec packet mode, the device is going to encrypt and encapsulate
> > packets that are associated with offloaded policy. After successful
> > policy lookup to indicate if packets should be offloaded or not,
> > the stack forwards packets to the device to do the magic.
> > 
> > Signed-off-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Huy Nguyen <huyn@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  net/xfrm/xfrm_device.c |  15 +++++-
> >  net/xfrm/xfrm_output.c |  12 ++++-
> >  net/xfrm/xfrm_state.c  | 120 +++++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 141 insertions(+), 6 deletions(-)
> ...
> > @@ -1161,7 +1240,31 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> >  			x = NULL;
> >  			goto out;
> >  		}
> > -
> > +#ifdef CONFIG_XFRM_OFFLOAD
> > +		if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
> > +			struct xfrm_dev_offload *xdo = &pol->xdo;
> > +			struct xfrm_dev_offload *xso = &x->xso;
> > +
> > +			xso->type = XFRM_DEV_OFFLOAD_PACKET;
> > +			xso->dir = xdo->dir;
> > +			xso->dev = xdo->dev;
> > +			xso->real_dev = xdo->real_dev;
> > +			netdev_tracker_alloc(xso->dev, &xso->dev_tracker,
> > +					     GFP_ATOMIC);
> > +			error = xso->dev->xfrmdev_ops->xdo_dev_state_add(x);
> > +			if (error) {
> > +				xso->dir = 0;
> > +				netdev_put(xso->dev, &xso->dev_tracker);
> > +				xso->dev = NULL;
> > +				xso->real_dev = NULL;
> > +				xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
> > +				x->km.state = XFRM_STATE_DEAD;
> > +				to_put = x;
> > +				x = NULL;
> > +				goto out;
> > +			}
> > +		}
> > +#endif
> >  		if (km_query(x, tmpl, pol) == 0) {
> >  			spin_lock_bh(&net->xfrm.xfrm_state_lock);
> >  			x->km.state = XFRM_STATE_ACQ;
> > @@ -1185,6 +1288,17 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> >  			xfrm_hash_grow_check(net, x->bydst.next != NULL);
> >  			spin_unlock_bh(&net->xfrm.xfrm_state_lock);
> >  		} else {
> > +#ifdef CONFIG_XFRM_OFFLOAD
> > +			struct xfrm_dev_offload *xso = &x->xso;
> > +
> > +			if (xso->type == XFRM_DEV_OFFLOAD_PACKET) {
> > +				xso->dir = 0;
> > +				netdev_put(xso->dev, &xso->dev_tracker);
> > +				xso->dev = NULL;
> > +				xso->real_dev = NULL;
> > +				xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
> > +			}
> 
> You do a xdo_dev_state_add call to add an acquire state to HW above.
> Maybe we should do a xdo_dev_state_del call here when deleting the
> acquire state.

Absolutely. Thanks

> 
> > +#endif
> >  			x->km.state = XFRM_STATE_DEAD;
> >  			to_put = x;
> >  			x = NULL;
> > -- 
> > 2.38.1
