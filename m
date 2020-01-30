Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F36314D887
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 11:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgA3KCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 05:02:01 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:52248 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbgA3KCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 05:02:01 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 35DD02049A;
        Thu, 30 Jan 2020 11:02:00 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fhJz6hgFyUAh; Thu, 30 Jan 2020 11:01:59 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B5DA320322;
        Thu, 30 Jan 2020 11:01:59 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 30 Jan 2020
 11:01:59 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 593983180220;
 Thu, 30 Jan 2020 11:01:59 +0100 (CET)
Date:   Thu, 30 Jan 2020 11:01:59 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RFC] net: add gro frag support to udp tunnel api
Message-ID: <20200130100159.GI27973@gauss3.secunet.de>
References: <20200127152411.15914-1-Jason@zx2c4.com>
 <CA+FuTSecc8ZzNL+8RvYUj4n_iTWCy4-vV46eCWtsHenT9u96QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSecc8ZzNL+8RvYUj4n_iTWCy4-vV46eCWtsHenT9u96QQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 10:40:55AM -0500, Willem de Bruijn wrote:
> On Mon, Jan 27, 2020 at 10:25 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Hi Steffen,
> >
> > This is very much a "RFC", in that the code here is fodder for
> > discussion more than something I'm seriously proposing at the moment.
> > I'm writing to you specifically because I recall us having discussed
> > something like this a while ago and you being interested.
> >
> > WireGuard would benefit from getting lists of SKBs all together in a
> > bunch on the receive side. At the moment, encap_rcv splits them apart
> > one by one before giving them to the API. This patch proposes a way to
> > opt-in to receiving them before they've been split. The solution
> > involves adding an encap_type flag that enables calling the encap_rcv
> > function earlier before the skbs have been split apart.
> >
> > I worry that it's not this straight forward, however, because of this
> > function below called, "udp_unexpected_gso". It looks like there's a
> > fast path for the case when it doesn't need to be split apart, and that
> > if it is already split apart, that's expected, whereas splitting it
> > apart would be "unexpected." I'm not too familiar with this code. Do you
> > know off hand why this would be unexpected?
> 
> This is for delivery to local sockets.
> 
> UDP GRO packets need to be split back up before delivery, unless the
> socket has set socket option UDP_GRO.
> 
> This is checked in the GRO layer by checking udp_sk(sk)->gro_enabled.
> 
> There is a race condition between this check and the packet arriving
> at the socket. Hence the unexpected.

Actually, if fraglist GRO is enabled this codepath is not that
unexpected anymore. Maybe we should remove the branch predictor
on !udp_unexpected_gso.

> 
> Note that UDP GSO can take two forms, the fraglist approach by Steffen
> or the earlier implementation that builds a single skb with frags.
> 
> >  static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> >  {
> > +       int (*encap_rcv_gro)(struct sock *sk, struct sk_buff *skb);
> >         struct sk_buff *next, *segs;
> >         int ret;
> >
> > +       if (static_branch_unlikely(&udp_encap_needed_key) &&
> > +           up->encap_type & UDP_ENCAP_SUPPORT_GRO_FRAGS &&
> > +           (encap_rcv_gro = READ_ONCE(up->encap_rcv))) {
> > +               //XXX: deal with checksum?
> > +               ret = encap_rcv(sk, skb);
> > +               if (ret <= 0) //XXX: deal with incrementing udp error stats?
> > +                       return -ret;
> > +       }
> 
> I think it'll be sufficient to just set optionally
> udp_sk(sk)->gro_enabled on encap sockets and let it takes the default
> path, below?

I think Jason wants to have the fraglist GRO version.
Just setting udp_sk(sk)->gro_enabled would generate
standard GRO packets. The UDP payload from wireguard
is encrypted, so merging into a single datagram does
not work that well here.

> 
> > +
> >         if (likely(!udp_unexpected_gso(sk, skb)))
> >                 return udp_queue_rcv_one_skb(sk, skb);
> >
