Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A40216645
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 08:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgGGGRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 02:17:23 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:58392 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbgGGGRX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 02:17:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8594120411;
        Tue,  7 Jul 2020 08:17:21 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mVnmsVHkTRbF; Tue,  7 Jul 2020 08:17:21 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 06CC2201A0;
        Tue,  7 Jul 2020 08:17:21 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 7 Jul 2020 08:17:20 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 7 Jul 2020
 08:17:20 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id F3EA231800BE;
 Tue,  7 Jul 2020 08:17:19 +0200 (CEST)
Date:   Tue, 7 Jul 2020 08:17:19 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     Tobias Brunner <tobias@strongswan.org>,
        network dev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        "Sabrina Dubroca" <sd@queasysnail.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, <pwouters@redhat.com>
Subject: Re: [PATCH ipsec] xfrm: state: match with both mark and mask on user
 interfaces
Message-ID: <20200707061719.GV19286@gauss3.secunet.de>
References: <4aaead9f8306859eb652b90582f23295792e9d15.1593497708.git.lucien.xin@gmail.com>
 <d510d172-c605-725d-e6bc-e6462a3718ab@strongswan.org>
 <CADvbK_cQBbFwYj_CYTm69LP8a7R3PsS=nr0MyfRjAcASVz=dhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CADvbK_cQBbFwYj_CYTm69LP8a7R3PsS=nr0MyfRjAcASVz=dhQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 04:33:53PM +0800, Xin Long wrote:
> >
> > > @@ -1051,7 +1061,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > >       int acquire_in_progress = 0;
> > >       int error = 0;
> > >       struct xfrm_state *best = NULL;
> > > -     u32 mark = pol->mark.v & pol->mark.m;
> > >       unsigned short encap_family = tmpl->encap_family;
> > >       unsigned int sequence;
> > >       struct km_event c;
> > > @@ -1065,7 +1074,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > >       hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {
> > >               if (x->props.family == encap_family &&
> > >                   x->props.reqid == tmpl->reqid &&
> > > -                 (mark & x->mark.m) == x->mark.v &&
> > > +                 (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m) &&
> > >                   x->if_id == if_id &&
> > >                   !(x->props.flags & XFRM_STATE_WILDRECV) &&
> > >                   xfrm_state_addr_check(x, daddr, saddr, encap_family) &&
> > > @@ -1082,7 +1091,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > >       hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h_wildcard, bydst) {
> > >               if (x->props.family == encap_family &&
> > >                   x->props.reqid == tmpl->reqid &&
> > > -                 (mark & x->mark.m) == x->mark.v &&
> > > +                 (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m) &&
> > >                   x->if_id == if_id &&
> > >                   !(x->props.flags & XFRM_STATE_WILDRECV) &&
> > >                   xfrm_addr_equal(&x->id.daddr, daddr, encap_family) &&
> >
> > While this should usually not be a problem for strongSwan, as we set the
> > same mark/value on both states and corresponding policies (although the
> > latter can be disabled as users may want to install policies themselves
> > or via another daemon e.g. for MIPv6), it might be a limitation for some
> > use cases.  The current code allows sharing states with multiple
> > policies whose mark/mask doesn't match exactly (i.e. depended on the
> > masks of both).  I wonder if anybody uses it like this, and how others
> > think about it.
> IMHO, the non-exact match "(mark & x->mark.m) == x->mark.v" should be only
> for packet flow. "sharing states with multiple policies" should not be the
> purpose of xfrm_mark. (Add Jamal to the CC list)
> 
> "(((pol->mark.v & pol->mark.m) & x->mark.m) == x->mark.v)" is just strange.
> We could do either:
>  (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m), like this patch.
> Or use fl->flowi_mark in xfrm_state_find():
>  (fl->flowi_mark & x->mark.m) == x->mark.v)
> 
> The 1st one will require userland to configure policy and state with the
> same xfrm_mark, like strongswan.
> 
> The 2nd one will match state with tx packet flow's mark, it's more like
> rx packet flow path.
> 
> But you're right, either of these may cause slight differences, let's see
> how other userland cases use it. (also Add Libreswan's developer, Paul Wouters)

We should care that everything that worked before, will still work after
this change. Otherwise we might break someones usecase, even if the
usecase seems to be odd and nobody complains now.
