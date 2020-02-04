Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1B6151EEE
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 18:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgBDRJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 12:09:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbgBDRJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 12:09:25 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 484E42084E;
        Tue,  4 Feb 2020 17:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580836164;
        bh=SQC18b6ShbtHzZkjR3+DEaKDqs1Tvb39mcF+szSgoY0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RLqdgNEOmYcMswTNSPRzI9N0CYO3+hdCPOg0R3LMLIE32sQSA2R/uwRHVl4xcQKqG
         mK908dsBsc4U6fGjOLwXTdYG61kjqo5WpbvXP4DLU0+ivBWoa5RPTLn0gWE+0IZKWx
         IeI8dCsg6aoKyOYEbsYLnptDaSBPTdJfa24AlFpU=
Date:   Tue, 4 Feb 2020 09:09:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200204090922.0a346daf@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <87y2ti4nxj.fsf@toke.dk>
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
        <20200201201508.63141689@cakuba.hsd1.ca.comcast.net>
        <87zhdzbfa3.fsf@toke.dk>
        <20200203231503.24eec7f0@carbon>
        <87y2ti4nxj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Feb 2020 12:00:40 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> > On Mon, 03 Feb 2020 21:13:24 +0100
> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> > =20
> >> Oops, I see I forgot to reply to this bit:
> >>  =20
> >> >> Yeah, but having the low-level details available to the XDP program
> >> >> (such as HW queue occupancy for the egress hook) is one of the bene=
fits
> >> >> of XDP, isn't it?   =20
> >> >
> >> > I think I glossed over the hope for having access to HW queue occupa=
ncy
> >> > - what exactly are you after?=20
> >> >
> >> > I don't think one can get anything beyond a BQL type granularity.
> >> > Reading over PCIe is out of question, device write back on high
> >> > granularity would burn through way too much bus throughput.   =20
> >>=20
> >> This was Jesper's idea originally, so maybe he can explain better; but
> >> as I understood it, he basically wanted to expose the same information
> >> that BQL has to eBPF. Making it possible for an eBPF program to either
> >> (re-)implement BQL with its own custom policy, or react to HWQ pressure
> >> in some other way, such as by load balancing to another interface. =20
> >
> > Yes, and I also have plans that goes beyond BQL. But let me start with
> > explaining the BQL part, and answer Toke's question below.
> >
> > On Mon, 03 Feb 2020 20:56:03 +0100 Toke wrote: =20
> >> [...] Hmm, I wonder if a TX driver hook is enough? =20
> >
> > Short answer is no, a TX driver hook is not enough.  The queue state
> > info the TX driver hook have access to, needs to be updated once the
> > hardware have "confirmed" the TX-DMA operation have completed.  For
> > BQL/DQL this update happens during TX-DMA completion/cleanup (code
> > see call sites for netdev_tx_completed_queue()).  (As Jakub wisely
> > point out we cannot query the device directly due to performance
> > implications).  It doesn't need to be a new BPF hook, just something
> > that update the queue state info (we could piggy back on the
> > netdev_tx_completed_queue() call or give TX hook access to
> > dev_queue->dql). =20

Interesting, that model does make sense to me.

> The question is whether this can't simply be done through bpf helpers?
> bpf_get_txq_occupancy(ifindex, txqno)?

Helper vs dev_queue->dql field access seems like a technicality.
The usual flexibility of implementation vs performance and simplicity
consideration applies.. I guess?

> > Regarding "where is the queue": For me the XDP-TX queue is the NIC
> > hardware queue, that this BPF hook have some visibility into and can do
> > filtering on. (Imagine that my TX queue is bandwidth limited, then I
> > can shrink the packet size and still send a "congestion" packet to my
> > receiver). =20
>=20
> I'm not sure the hardware queues will be enough, though. Unless I'm
> misunderstanding something, hardware queues are (1) fairly short and (2)
> FIFO. So, say we wanted to implement fq_codel for XDP forwarding: we'd
> still need a software queueing layer on top of the hardware queue.

Jesper makes a very interesting point tho. If all the implementation
wants is FIFO queues which are services in some simple manner (that is
something that can be offloaded) we should support that.

That means REDIRECT can target multiple TX queues, and we need an API
to control the queue allocation..

> If the hardware is EDT-aware this may change, I suppose, but I'm not
> sure if we can design the XDP queueing primitives with this assumption? :)

But I agree with you as well. I think both HW and SW feeding needs to
be supported. The HW implementations are always necessarily behind
ideas people implemented and tested in SW..

> > The bigger picture is that I envision the XDP-TX/egress hook can
> > open-up for taking advantage of NIC hardware TX queue features. This
> > also ties into the queue abstraction work by Bj=C3=B6rn+Magnus. Today N=
IC
> > hardware can do a million TX-queues, and hardware can also do rate
> > limiting per queue. Thus, I also envision that the XDP-TX/egress hook
> > can choose/change the TX queue the packet is queue/sent on (we can
> > likely just overload the XDP_REDIRECT and have a new bpf map type for
> > this). =20

I wonder what that does to our HW offload model which is based on
TC Qdisc offload today :S Do we use TC API to control configuration=20
of XDP queues? :S

> Yes, I think I mentioned in another email that putting all the queueing
> smarts into the redirect map was also something I'd considered (well, I
> do think we've discussed this in the past, so maybe not so surprising if
> we're thinking along the same lines) :)
>=20
> But the implication of this is also that an actual TX hook in the driver
> need not necessarily incorporate a lot of new functionality, as it can
> control the queueing through a combination of BPF helpers and map
> updates?

True, it's the dequeuing that's on the TX side, so we could go as far
as putting all the enqueuing logic in the RX prog..

To answer your question from the other email Toke, my basic model was
kind of similar to TC Qdiscs. XDP redirect selects a device, then that
device has an enqueue and dequeue programs. Enqueue program can be run
in the XDP_REDIRECT context, dequeue is run every time NAPI cleaned up
some space on the TX descriptor ring. There is a "queue state" but the
FIFOs etc are sort of internal detail that the enqueue and dequeue
programs only share between each other. To be clear this is not a
suggestion of how things should be, it's what sprung to my mind without
thinking.
