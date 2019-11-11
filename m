Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE81F7320
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 12:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfKKLck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 06:32:40 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:38604 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfKKLck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 06:32:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F020B20299;
        Mon, 11 Nov 2019 12:32:38 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rSXo4YXE_vVv; Mon, 11 Nov 2019 12:32:38 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 03438205DB;
        Mon, 11 Nov 2019 12:32:37 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 11 Nov 2019
 12:32:36 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 539D5318009B;
 Mon, 11 Nov 2019 12:32:35 +0100 (CET)
Date:   Mon, 11 Nov 2019 12:32:35 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xiaodong Xu <stid.smth@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <chenborfc@163.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] xfrm: release device reference for invalid state
Message-ID: <20191111113235.GT13225@gauss3.secunet.de>
References: <20191108082059.22515-1-stid.smth@gmail.com>
 <20191111061722.GO13225@gauss3.secunet.de>
 <CANEcBPQ5de-qpYRbYxoMKfwyvm3T=Ddfpn_z03bd40JaO9cDjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANEcBPQ5de-qpYRbYxoMKfwyvm3T=Ddfpn_z03bd40JaO9cDjA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 10:38:41PM -0800, Xiaodong Xu wrote:
> Thanks for reviewing the patch, Steffen. Please check my replies below.
> 
> On Sun, Nov 10, 2019 at 10:17 PM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> > > +++ b/net/xfrm/xfrm_input.c
> > > @@ -474,6 +474,13 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
> > >       if (encap_type < 0) {
> > >               x = xfrm_input_state(skb);
> > >
> > > +             /* An encap_type of -1 indicates async resumption. */
> > > +             if (encap_type == -1) {
> > > +                     async = 1;
> > > +                     seq = XFRM_SKB_CB(skb)->seq.input.low;
> > > +                     goto resume;
> > > +             }
> > > +
> > >               if (unlikely(x->km.state != XFRM_STATE_VALID)) {
> > >                       if (x->km.state == XFRM_STATE_ACQ)
> > >                               XFRM_INC_STATS(net, LINUX_MIB_XFRMACQUIREERROR);
> >
> > Why not just dropping the reference here if the state became invalid
> > after async resumption?
> >
> I was thinking about releasing the device reference immediately after
> checking the state in the async resumption too. However it seems more
> natural to me to simply jump to the 'resume' label in the async case.

If you add the check here, you add it to an error path. If you add the
check to the resume label, it is in the fastpath.
