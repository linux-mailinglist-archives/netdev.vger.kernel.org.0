Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9049D633E40
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbiKVN5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiKVN5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:57:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB7623BEE
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:57:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D15F4B81B46
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C25C433D6;
        Tue, 22 Nov 2022 13:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669125466;
        bh=BYS9WSKd//P5EJa1FTZ5uwRwdaNtSlXdGe6uNWgLXcQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fBS+286dJdhvr1rluItD1OSecW99IlMg4G6OuJx9Qarqbmix4yAIplx+EHVSCqnVO
         1uE7/Ft5ihttl8YRxkoZsnOqyWt09SSaiJmAkCeuaK2jQuazCLGyeSW8Pi8BAXzpET
         OgxKc7OzHcF0cgiXYHilnUxYOVSAB8WfNXP1C6pUDpRgxj/ADwyc0yz6VD4N1cJ1Jo
         I0AkaKdjEITPYIL6KdM5MmWInqvmI6b+7vEEpZekbQmDvIdliYhEuUg7LNwVKbJKzq
         keizzBdE8ImenXs5qTeGAyUW60VFeYD7Hk95TRwLCxeQcPCEd/8QOzs4SYESFRjFje
         WTU1Ub0ZDwsIg==
Date:   Tue, 22 Nov 2022 15:57:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y3zVVzfrR1YKL4Xd@unreal>
References: <20221121094404.GU704954@gauss3.secunet.de>
 <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <Y3to7FYBwfkBSZYA@unreal>
 <20221121124349.GZ704954@gauss3.secunet.de>
 <Y3t2tsHDpxjnBAb/@unreal>
 <20221122131002.GN704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122131002.GN704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 02:10:02PM +0100, Steffen Klassert wrote:
> On Mon, Nov 21, 2022 at 03:01:42PM +0200, Leon Romanovsky wrote:
> > On Mon, Nov 21, 2022 at 01:43:49PM +0100, Steffen Klassert wrote:
> > > On Mon, Nov 21, 2022 at 02:02:52PM +0200, Leon Romanovsky wrote:
> > > > 
> > > > I think that something like this will do the trick.
> > > > 
> > > > diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> > > > index 5076f9d7a752..d1c9ef857755 100644
> > > > --- a/net/xfrm/xfrm_state.c
> > > > +++ b/net/xfrm/xfrm_state.c
> > > > @@ -1090,6 +1090,28 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
> > > >         }
> > > >  }
> > > > 
> > > > +static bool xfrm_state_and_policy_mixed(struct xfrm_state *x,
> > > > +                                       struct xfrm_policy *p)
> > > > +{
> > > > +       /* Packet offload: both policy and SA should be offloaded */
> > > > +       if (p->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
> > > > +           x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
> > > > +               return true;
> > > > +
> > > > +       if (p->xdo.type != XFRM_DEV_OFFLOAD_PACKET &&
> > > > +           x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
> > > > +               return true;
> > > > +
> > > > +       if (p->xdo.type != XFRM_DEV_OFFLOAD_PACKET)
> > > > +               return false;
> > > > +
> > > > +       /* Packet offload: both policy and SA should have same device */
> > > > +       if (p->xdo.dev != x->xso.dev)
> > > > +               return true;
> > > > +
> > > > +       return false;
> > > > +}
> > > > +
> > > >  struct xfrm_state *
> > > >  xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > > >                 const struct flowi *fl, struct xfrm_tmpl *tmpl,
> > > > @@ -1147,7 +1169,8 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > > > 
> > > >  found:
> > > >         x = best;
> > > > -       if (!x && !error && !acquire_in_progress) {
> > > > +       if (!x && !error && !acquire_in_progress &&
> > > > +           pol->xdo.type != XFRM_DEV_OFFLOAD_PACKET) {
> > > >                 if (tmpl->id.spi &&
> > > >                     (x0 = __xfrm_state_lookup(net, mark, daddr, tmpl->id.spi,
> > > >                                               tmpl->id.proto, encap_family)) != NULL) {
> > > > @@ -1228,7 +1251,14 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > > >                         *err = -EAGAIN;
> > > >                         x = NULL;
> > > >                 }
> > > > +               if (x && xfrm_state_and_policy_mixed(x, pol)) {
> > > > +                       *err = -EINVAL;
> > > > +                       x = NULL;
> > > 
> > > If policy and state do not match here, this means the lookup
> > > returned the wrong state. The correct state might still sit
> > > in the database. At this point, you should either have found
> > > a matching state, or no state at all.
> > 
> > I check for "x" because of "x = NULL" above.
> 
> This does not change the fact that the lookup returned the wrong state.

Steffen, but this is exactly why we added this check - to catch wrong
states and configurations. 

If lookup was successful, we know that HW handles this packet, if lookup
failed to find SA and we have HW policy, we should drop such packet.

Thanks
