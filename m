Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF856322FB
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiKUNCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiKUNBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:01:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B586A2B24B
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:01:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CBF06119B
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 13:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D87AC433C1;
        Mon, 21 Nov 2022 13:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669035706;
        bh=qRKlkidoX5h2btWWYCf3stlYm+5gAB2qbUW2LWIt8J0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tPq/1b5sGLIdBIbYV4nQ7eHoISJtcx9eY4KoRz3zeP8W/Mztcc4PfAufgKNJrcEVd
         51TimrGGQY+OegrWEMxB1Egfbtnfp+qaC9yz4YL9BP0Cq5nDAoFNta7dPmwscRchhS
         nyv4OICAxOWZ0i50TBdeh8wYpBjtC4+GoaXqheAilM1GQQj0H3x5bTY4leyLTSU3yS
         mj853lm0M7T0AKCmDozy13U0lcVxc9oW33lewB9DMrNhO62HsYYkVgbcccnoMeqSWi
         uBlsbi4HKCzYvGbKSLd9nYm5w8QIdPQ3br63+DW350zsEri01U7F2tvltE7hB8+yl1
         T1iAJJukDorgw==
Date:   Mon, 21 Nov 2022 15:01:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y3t2tsHDpxjnBAb/@unreal>
References: <20221118104907.GR704954@gauss3.secunet.de>
 <Y3p9LvAEQMAGeaCR@unreal>
 <20221121094404.GU704954@gauss3.secunet.de>
 <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <Y3to7FYBwfkBSZYA@unreal>
 <20221121124349.GZ704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121124349.GZ704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 01:43:49PM +0100, Steffen Klassert wrote:
> On Mon, Nov 21, 2022 at 02:02:52PM +0200, Leon Romanovsky wrote:
> > 
> > I think that something like this will do the trick.
> > 
> > diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> > index 5076f9d7a752..d1c9ef857755 100644
> > --- a/net/xfrm/xfrm_state.c
> > +++ b/net/xfrm/xfrm_state.c
> > @@ -1090,6 +1090,28 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
> >         }
> >  }
> > 
> > +static bool xfrm_state_and_policy_mixed(struct xfrm_state *x,
> > +                                       struct xfrm_policy *p)
> > +{
> > +       /* Packet offload: both policy and SA should be offloaded */
> > +       if (p->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
> > +           x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
> > +               return true;
> > +
> > +       if (p->xdo.type != XFRM_DEV_OFFLOAD_PACKET &&
> > +           x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
> > +               return true;
> > +
> > +       if (p->xdo.type != XFRM_DEV_OFFLOAD_PACKET)
> > +               return false;
> > +
> > +       /* Packet offload: both policy and SA should have same device */
> > +       if (p->xdo.dev != x->xso.dev)
> > +               return true;
> > +
> > +       return false;
> > +}
> > +
> >  struct xfrm_state *
> >  xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> >                 const struct flowi *fl, struct xfrm_tmpl *tmpl,
> > @@ -1147,7 +1169,8 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > 
> >  found:
> >         x = best;
> > -       if (!x && !error && !acquire_in_progress) {
> > +       if (!x && !error && !acquire_in_progress &&
> > +           pol->xdo.type != XFRM_DEV_OFFLOAD_PACKET) {
> >                 if (tmpl->id.spi &&
> >                     (x0 = __xfrm_state_lookup(net, mark, daddr, tmpl->id.spi,
> >                                               tmpl->id.proto, encap_family)) != NULL) {
> > @@ -1228,7 +1251,14 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> >                         *err = -EAGAIN;
> >                         x = NULL;
> >                 }
> > +               if (x && xfrm_state_and_policy_mixed(x, pol)) {
> > +                       *err = -EINVAL;
> > +                       x = NULL;
> 
> If policy and state do not match here, this means the lookup
> returned the wrong state. The correct state might still sit
> in the database. At this point, you should either have found
> a matching state, or no state at all.

I check for "x" because of "x = NULL" above.

Thanks
