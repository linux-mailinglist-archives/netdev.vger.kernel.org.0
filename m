Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30A053306E
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbiEXSaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240340AbiEXSae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:30:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CC47A83C
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 11:30:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42460615AD
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 18:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25705C34100;
        Tue, 24 May 2022 18:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653417032;
        bh=pN7z5+4NWfj+J0RYMiv0dGONarKaZ8Zw5a5GImr61ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X3xn7oaWNO2w5dX6Fa3xWdh6LsZwdCNSc4U290yPRnIKIva5cTo94R3ama2DXL5ki
         zx2sgg+r1uKZR0QuQfL6nbPnyD8d4xyPSt2poS48raFN1XRINgOq/Q7mK8K5kREN3q
         Xe1WARudw7gxS8ePyq67lypAvfSCOIlr3JJzvh5E/Yzb8sGRhUC/h9IlrieOTfFq9b
         CQorn+kGiyNHQU/ONjq91PnbPOSj6JB7EmecDZSUo3MgbzTFGu+NjWWKSDdd4aEDo/
         NIxDKRovpwMJn3UeOdqYHIdiTzIqPMFxq5N+KGfcRjsjefjN6gvTH8o22/HrHFXyzD
         XktWhwzRInVcw==
Date:   Tue, 24 May 2022 21:30:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH ipsec-next 4/6] xfrm: add TX datapath support for IPsec
 full offload mode
Message-ID: <Yo0kRO8xPR7iET20@unreal>
References: <cover.1652176932.git.leonro@nvidia.com>
 <905b8e8032d5cdb48ef63cb153fd86552c8a6a7d.1652176932.git.leonro@nvidia.com>
 <20220513145658.GL680067@gauss3.secunet.de>
 <YoHk2jiostIWIHn5@unreal>
 <20220518074914.GP680067@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518074914.GP680067@gauss3.secunet.de>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 09:49:14AM +0200, Steffen Klassert wrote:
> On Mon, May 16, 2022 at 08:44:58AM +0300, Leon Romanovsky wrote:
> > On Fri, May 13, 2022 at 04:56:58PM +0200, Steffen Klassert wrote:
> > > On Tue, May 10, 2022 at 01:36:55PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > In IPsec full mode, the device is going to encrypt and encapsulate
> > > > packets that are associated with offloaded policy. After successful
> > > > policy lookup to indicate if packets should be offloaded or not,
> > > > the stack forwards packets to the device to do the magic.
> > > > 
> > > > Signed-off-by: Raed Salem <raeds@nvidia.com>
> > > > Signed-off-by: Huy Nguyen <huyn@nvidia.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > ---
> > > >  net/xfrm/xfrm_output.c | 19 +++++++++++++++++++
> > > >  1 file changed, 19 insertions(+)
> > > > 
> > > > diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> > > > index d4935b3b9983..2599f3dbac08 100644
> > > > --- a/net/xfrm/xfrm_output.c
> > > > +++ b/net/xfrm/xfrm_output.c
> > > > @@ -718,6 +718,25 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
> > > >  		break;
> > > >  	}
> > > >  
> > > > +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL) {
> > > > +		struct dst_entry *dst = skb_dst_pop(skb);
> > > > +
> > > > +		if (!dst) {
> > > > +			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
> > > > +			return -EHOSTUNREACH;
> > > > +		}
> > > > +
> > > > +		skb_dst_set(skb, dst);
> > > > +		err = skb_dst(skb)->ops->local_out(net, skb->sk, skb);
> > > > +		if (unlikely(err != 1))
> > > > +			return err;
> > > > +
> > > > +		if (!skb_dst(skb)->xfrm)
> > > > +			return dst_output(net, skb->sk, skb);
> > > > +
> > > > +		return 0;
> > > > +	}
> > > > +
> > > 
> > > How do we know that we send the packet really to a device that
> > > supports this type of offload? For crypto offload, we check that
> > > in xfrm_dev_offload_ok() and I think something similar is required
> > > here too.
> > 
> > I think that function is needed to make sure that we will have SW
> > fallback. It is not needed in full offload, anything that is not
> > supported/wrong should be dropped by HW.
> 
> Yes, but only if the final output device really supports this kind
> of offload. How can we be sure that this is the case? Packets can be
> rerouted etc. We need to make sure that the outgoing device supports
> full offload, and I think this check is missing somewhere.

I think that something like this is missing (on top of the original patch):

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 2599f3dbac08..a41aef3e8903 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -726,6 +726,9 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
                        return -EHOSTUNREACH;
                }

+               if (!xfrm_dev_offload_ok(skb, x))
+                       return -EOPNOTSUPP;
+
                skb_dst_set(skb, dst);
                err = skb_dst(skb)->ops->local_out(net, skb->sk, skb);
                if (unlikely(err != 1))
(END)

