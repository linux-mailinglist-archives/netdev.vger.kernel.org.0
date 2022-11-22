Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFD2633D26
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiKVNKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKVNKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:10:06 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3494EEB7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:10:05 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D01EA2019C;
        Tue, 22 Nov 2022 14:10:03 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 93cOdmw5m0ue; Tue, 22 Nov 2022 14:10:03 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4BBF42053B;
        Tue, 22 Nov 2022 14:10:03 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 460C780004A;
        Tue, 22 Nov 2022 14:10:03 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 14:10:03 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 22 Nov
 2022 14:10:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 610833182F5E; Tue, 22 Nov 2022 14:10:02 +0100 (CET)
Date:   Tue, 22 Nov 2022 14:10:02 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <20221122131002.GN704954@gauss3.secunet.de>
References: <Y3p9LvAEQMAGeaCR@unreal>
 <20221121094404.GU704954@gauss3.secunet.de>
 <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <Y3to7FYBwfkBSZYA@unreal>
 <20221121124349.GZ704954@gauss3.secunet.de>
 <Y3t2tsHDpxjnBAb/@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3t2tsHDpxjnBAb/@unreal>
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

On Mon, Nov 21, 2022 at 03:01:42PM +0200, Leon Romanovsky wrote:
> On Mon, Nov 21, 2022 at 01:43:49PM +0100, Steffen Klassert wrote:
> > On Mon, Nov 21, 2022 at 02:02:52PM +0200, Leon Romanovsky wrote:
> > > 
> > > I think that something like this will do the trick.
> > > 
> > > diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> > > index 5076f9d7a752..d1c9ef857755 100644
> > > --- a/net/xfrm/xfrm_state.c
> > > +++ b/net/xfrm/xfrm_state.c
> > > @@ -1090,6 +1090,28 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
> > >         }
> > >  }
> > > 
> > > +static bool xfrm_state_and_policy_mixed(struct xfrm_state *x,
> > > +                                       struct xfrm_policy *p)
> > > +{
> > > +       /* Packet offload: both policy and SA should be offloaded */
> > > +       if (p->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
> > > +           x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
> > > +               return true;
> > > +
> > > +       if (p->xdo.type != XFRM_DEV_OFFLOAD_PACKET &&
> > > +           x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
> > > +               return true;
> > > +
> > > +       if (p->xdo.type != XFRM_DEV_OFFLOAD_PACKET)
> > > +               return false;
> > > +
> > > +       /* Packet offload: both policy and SA should have same device */
> > > +       if (p->xdo.dev != x->xso.dev)
> > > +               return true;
> > > +
> > > +       return false;
> > > +}
> > > +
> > >  struct xfrm_state *
> > >  xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > >                 const struct flowi *fl, struct xfrm_tmpl *tmpl,
> > > @@ -1147,7 +1169,8 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > > 
> > >  found:
> > >         x = best;
> > > -       if (!x && !error && !acquire_in_progress) {
> > > +       if (!x && !error && !acquire_in_progress &&
> > > +           pol->xdo.type != XFRM_DEV_OFFLOAD_PACKET) {
> > >                 if (tmpl->id.spi &&
> > >                     (x0 = __xfrm_state_lookup(net, mark, daddr, tmpl->id.spi,
> > >                                               tmpl->id.proto, encap_family)) != NULL) {
> > > @@ -1228,7 +1251,14 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > >                         *err = -EAGAIN;
> > >                         x = NULL;
> > >                 }
> > > +               if (x && xfrm_state_and_policy_mixed(x, pol)) {
> > > +                       *err = -EINVAL;
> > > +                       x = NULL;
> > 
> > If policy and state do not match here, this means the lookup
> > returned the wrong state. The correct state might still sit
> > in the database. At this point, you should either have found
> > a matching state, or no state at all.
> 
> I check for "x" because of "x = NULL" above.

This does not change the fact that the lookup returned the wrong state.
