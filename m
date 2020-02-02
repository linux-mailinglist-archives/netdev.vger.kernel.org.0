Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044E014FB60
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 05:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgBBEPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 23:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:50882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgBBEPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 23:15:10 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 571032080D;
        Sun,  2 Feb 2020 04:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580616910;
        bh=BM59cPsTLUsisFEd3UnrGT28eNEMqse+p49TkORbJ3I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y9niMbs+IaeH2I/d2YndG7RQRlh3vCt9c8l0qzO88lKcpinF6Ia23mnWlgr5p65fN
         Tywm0mGFq7XBxcZCxX1/kquBYitTYNi3ZF0KoP+rd6TVq9Q5K3x6LrdNG1ke5f08w2
         9iC172XriU3hyV+cUpiJ9Rm5BccjtXcZ224TaM5I=
Date:   Sat, 1 Feb 2020 20:15:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net, jbrouer@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200201201508.63141689@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <87sgjucbuf.fsf@toke.dk>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
        <20200126141141.0b773aba@cakuba>
        <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
        <20200127061623.1cf42cd0@cakuba>
        <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com>
        <20200128055752.617aebc7@cakuba>
        <87ftfue0mw.fsf@toke.dk>
        <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net>
        <87sgjucbuf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 01 Feb 2020 21:05:28 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Sat, 01 Feb 2020 17:24:39 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote: =20
> >> > I'm weary of partially implemented XDP features, EGRESS prog does us
> >> > no good when most drivers didn't yet catch up with the REDIRECTs.   =
=20
> >>=20
> >> I kinda agree with this; but on the other hand, if we have to wait for
> >> all drivers to catch up, that would mean we couldn't add *anything*
> >> new that requires driver changes, which is not ideal either :/ =20
> >
> > If EGRESS is only for XDP frames we could try to hide the handling in
> > the core (with slight changes to XDP_TX handling in the drivers),
> > making drivers smaller and XDP feature velocity higher. =20
>=20
> But if it's only for XDP frames that are REDIRECTed, then one might as
> well perform whatever action the TX hook was doing before REDIRECTing
> (as you yourself argued)... :)

Right, that's why I think the design needs to start from queuing which
can't be done today, and has to be done in context of the destination.
Solving queuing justifies the added complexity if you will :)

> > I think loading the drivers with complexity is hurting us in so many
> > ways.. =20
>=20
> Yeah, but having the low-level details available to the XDP program
> (such as HW queue occupancy for the egress hook) is one of the benefits
> of XDP, isn't it?

I think I glossed over the hope for having access to HW queue occupancy
- what exactly are you after?=20

I don't think one can get anything beyond a BQL type granularity.
Reading over PCIe is out of question, device write back on high
granularity would burn through way too much bus throughput.

> Ultimately, I think Jesper's idea of having drivers operate exclusively
> on XDP frames and have the skb handling entirely in the core is an
> intriguing way to resolve this problem. Though this is obviously a
> long-term thing, and one might reasonably doubt we'll ever get there for
> existing drivers...
>=20
> >> > And we're adding this before we considered the queuing problem.
> >> >
> >> > But if I'm alone in thinking this, and I'm not convincing anyone we
> >> > can move on :)   =20
> >>=20
> >> I do share your concern that this will end up being incompatible with
> >> whatever solution we end up with for queueing. However, I don't
> >> necessarily think it will: I view the XDP egress hook as something
> >> that in any case will run *after* packets are dequeued from whichever
> >> intermediate queueing it has been through (if any). I think such a
> >> hook is missing in any case; for instance, it's currently impossible
> >> to implement something like CoDel (which needs to know how long a
> >> packet spent in the queue) in eBPF. =20
> >
> > Possibly =F0=9F=A4=94 I don't have a good mental image of how the XDP q=
ueuing
> > would work.
> >
> > Maybe once the queuing primitives are defined they can easily be
> > hooked into the Qdisc layer. With Martin's recent work all we need is=20
> > a fifo that can store skb pointers, really...
> >
> > It'd be good if the BPF queuing could replace TC Qdiscs, rather than=20
> > layer underneath. =20
>=20
> Hmm, hooking into the existing qdisc layer is an interesting idea.
> Ultimately, I fear it won't be feasible for performance reasons; but
> it's certainly something to consider. Maybe at least as an option?

For forwarding sure, but for locally generated traffic.. =F0=9F=A4=B7=E2=80=
=8D=E2=99=82=EF=B8=8F
