Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CED6383FB
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 07:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiKYGX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 01:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYGX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 01:23:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103072654A
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 22:23:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8080E622B1
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 06:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79104C433D6;
        Fri, 25 Nov 2022 06:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669357434;
        bh=BUX7fN6yzmgDmJ/X/1gQKb+FxHjdNy712J5/XfIZYc0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I5sZS4MFUdraOt9ysh1XnRDwTp1yOn1cWCNf6Nt26uDLx+kVdEjHsGHmL+GyLsFUQ
         EuNxUeERjhvB7xNsjclGBVjpCo79VIzFYEooNcxjupH1cKrDUIBvPnUs3AX6H2UHWc
         PqtQOHNc0tMSksO7le7zmtl++PF6PL9kiEgtZUXJr5yyIVGKocnVAayhrG7aiNiw3Z
         m9SEZkbHPjRgYkHHGgn3SP+g1iaMKQZOIejkw2GIKDrxRB6Y6G+RBWAZaxt8zgTLOj
         wjIHIDO5I5wA3E3uDv+uFdPgvrM1Hzxh+Nb4qj/Hde8PyvgjRmLtQU2lgmqiUAu6Xs
         iIky+hD0/aahA==
Date:   Fri, 25 Nov 2022 08:23:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y4Bfc/GuJUumvY7V@unreal>
References: <Y3tiRnbfBcaH7bP0@unreal>
 <Y3to7FYBwfkBSZYA@unreal>
 <20221121124349.GZ704954@gauss3.secunet.de>
 <Y3t2tsHDpxjnBAb/@unreal>
 <20221122131002.GN704954@gauss3.secunet.de>
 <Y3zVVzfrR1YKL4Xd@unreal>
 <20221123083720.GM424616@gauss3.secunet.de>
 <Y33pk/3rUxFqbH2h@unreal>
 <Y34Xtqa+F79DCf6S@unreal>
 <20221124110748.GP424616@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124110748.GP424616@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 12:07:48PM +0100, Steffen Klassert wrote:
> On Wed, Nov 23, 2022 at 02:53:10PM +0200, Leon Romanovsky wrote:
> > On Wed, Nov 23, 2022 at 11:36:19AM +0200, Leon Romanovsky wrote:
> > > Thanks for an explanation, trying it now.
> > 
> > Something like that?
> 
> Yes :)

Great, will send proper version on Sunday.

> 
> > 
> > The code is untested yet.
> > 
> > diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> > index 5076f9d7a752..5819023c32ba 100644
> > --- a/net/xfrm/xfrm_state.c
> > +++ b/net/xfrm/xfrm_state.c
> > @@ -1115,6 +1115,19 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> >  	rcu_read_lock();
> >  	h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
> >  	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {
> > +		if (IS_ENABLED(CONFIG_XFRM_OFFLOAD) &&
> > +		    pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
> 
> Please try to avoid that check for every state in the list.
> Maybe enable this code with a static key if packet offload
> is used?

I assumed that it will be optimized by compiled because "pol->xdo.type ==
XFRM_DEV_OFFLOAD_PACKET)" is constant here. I'll take a look for more fancy
solutions, but I have serious doubts if they give any benefits.

> 
> > +			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
> > +				/* HW states are in the head of list, there is no need
> > +				 * to iterate further.
> > +				 */
> > +				break;
> > +
> > +			/* Packet offload: both policy and SA should have same device */
> > +			if (pol->xdo.dev != x->xso.dev)
> > +				continue;
> > +		}
> > +
> >  		if (x->props.family == encap_family &&
> >  		    x->props.reqid == tmpl->reqid &&
> >  		    (mark & x->mark.m) == x->mark.v &&
> > @@ -1132,6 +1145,19 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> >  
> >  	h_wildcard = xfrm_dst_hash(net, daddr, &saddr_wildcard, tmpl->reqid, encap_family);
> >  	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h_wildcard, bydst) {
> > +		if (IS_ENABLED(CONFIG_XFRM_OFFLOAD) &&
> > +		    pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
> > +			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
> > +				/* HW states are in the head of list, there is no need
> > +				 * to iterate further.
> > +				 */
> > +				break;
> > +
> > +			/* Packet offload: both policy and SA should have same device */
> > +			if (pol->xdo.dev != x->xso.dev)
> > +				continue;
> > +		}
> > +
> >  		if (x->props.family == encap_family &&
> >  		    x->props.reqid == tmpl->reqid &&
> >  		    (mark & x->mark.m) == x->mark.v &&
> > @@ -1185,6 +1211,17 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> >  			goto out;
> >  		}
> >  
> > +		if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
> > +			memcpy(&x->xso, &pol->xdo, sizeof(x->xso));
> > +			error = pol->xdo.dev->xfrmdev_ops->xdo_dev_state_add(x);
> > +			if (error) {
> > +				x->km.state = XFRM_STATE_DEAD;
> > +				to_put = x;
> > +				x = NULL;
> > +				goto out;
> > +			}
> > +		}
> 
> I guess that is to handle acquires, right?

Yes

> What is the idea behind that?

In previous patches, I made sure that policy and SA uses same
struct xfrm_dev_offload and set fields exactly the same.

This line sets all properties::
memcpy(&x->xso, &pol->xdo, sizeof(x->xso));

And .xdo_dev_state_add() gets everything pre-configured.

But yes, it will be different in final patch to make sure that
offload_handle is cleared and dev_tracker is valid.

Thanks
