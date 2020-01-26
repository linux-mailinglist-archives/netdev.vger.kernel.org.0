Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0EF149A96
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 13:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387454AbgAZMt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 07:49:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59244 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387398AbgAZMt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 07:49:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580042997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xoQIoxN+JLBbKgt/dVDcIeKSH7Tz56Y8+obpar4ys0k=;
        b=ZFuKF3OjyMVyldDScMLJYIxP6R4UnCxCMaA3uUkwmVm7aRcK845lZuj8+Ech715/Ly/EOk
        nQrToCYStqLGXFTqivS6s8j9odh+/UgI5j8iZFsbczE2B9aNhuq4h2ohpaL7Y32DV4vMcQ
        xFRHPzBDT+/OlusImPoU3QZ/dZGxUak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-5_u8-OQTNyO5khmRUb4qHw-1; Sun, 26 Jan 2020 07:49:49 -0500
X-MC-Unique: 5_u8-OQTNyO5khmRUb4qHw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C7451882CC0;
        Sun, 26 Jan 2020 12:49:47 +0000 (UTC)
Received: from carbon (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C60984321;
        Sun, 26 Jan 2020 12:49:37 +0000 (UTC)
Date:   Sun, 26 Jan 2020 13:49:33 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200126134933.2514b2ab@carbon>
In-Reply-To: <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jan 2020 18:43:36 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 1/24/20 8:36 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Jakub Kicinski <kuba@kernel.org> writes:
> >  =20
> >> On Thu, 23 Jan 2020 14:33:42 -0700, David Ahern wrote: =20
> >>> On 1/23/20 4:35 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote: =20
> >>>> David Ahern <dsahern@kernel.org> writes: =20
> >>>>> From: David Ahern <dahern@digitalocean.com>
> >>>>>
> >>>>> Add IFLA_XDP_EGRESS to if_link.h uapi to handle an XDP program atta=
ched
> >>>>> to the egress path of a device. Add rtnl_xdp_egress_fill and helper=
s as
> >>>>> the egress counterpart to the existing rtnl_xdp_fill. The expectati=
on
> >>>>> is that going forward egress path will acquire the various levels of
> >>>>> attach - generic, driver and hardware.   =20
> >>>>
> >>>> How would a 'hardware' attach work for this? As I said in my reply to
> >>>> the previous patch, isn't this explicitly for emulating XDP on the o=
ther
> >>>> end of a point-to-point link? How would that work with offloaded
> >>>> programs? =20
> >>>
> >>> Nothing about this patch set is limited to point-to-point links. =20
> >>
> >> I struggle to understand of what the expected semantics of this new
> >> hook are. Is this going to be run on all frames sent to the device
> >> from the stack? All frames from the stack and from XDP_REDIRECT?
> >>
> >> A little hard to figure out the semantics when we start from a funky
> >> device like tun :S =20
> >=20
> > Yes, that is also why I found this a bit weird. We have discussed plans
> > for an XDP TX hook before:
> > https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#=
xdp-hook-at-tx
> >=20
> > That TX hook would run for everything at TX, but it would be a separate
> > program type with its own metadata access. Whereas the idea with this
> > series (seemed to me) to be just to be able to "emulate" run a regular
> > RX-side XDP program on egress for devices where this makes sense.
> >=20
> > If this series is not meant to implement that "emulation", but rather be
> > usable for all devices, I really think we should go straight for the
> > full TX hook as discussed earlier...
> >  =20
>=20
> The first patch set from Jason and Prashant started from the perspective
> of offloading XDP programs for a guest. Independently, I was looking at
> XDP in the TX path (now referred to as egress to avoid confusion with
> the XDP_TX return type). Jason and Prashant were touching some of the
> same code paths in the tun driver that I needed for XDP in the Tx path,
> so we decided to consolidate and have XDP egress done first and then
> offload of VMs as a followup. Offload in virtio_net can be done very
> similar to how it is done in nfp -- the program is passed to the host as
> a hardware level attach mode, and the driver verifies the program can be
> offloaded (e.g., does not contain helpers that expose host specific data
> like the fib lookup helper).
>=20
> At this point, you need to stop thinking solely from the perspective of
> tun or tap and VM offload; think about this from the ability to run an
> XDP program on egress path at an appropriate place in the NIC driver
> that covers both skbs and xdp_frames (e.g., on a REDIRECT).

Yes, please. I want this NIC TX hook to see both SKBs and xdp_frames.


> This has
> been discussed before as a need (e.g, Toke's reference above), and I am
> trying to get this initial support done.
>=20
> I very much wanted to avoid copy-paste-modify for the entire XDP API for
> this. For the most part XDP means ebpf at the NIC driver / hardware
> level (obviously with the exception of generic mode). The goal is
> tempered with the need for the verifier to reject rx entries in the
> xdp_md context. Hence the reason for use of an attach_type - existing
> infrastructure to test and reject the accesses.
>=20
> That said, Martin's comment throws a wrench in the goal: if the existing
> code does not enforce expected_attach_type then that option can not be
> used in which case I guess I have to go with a new program type
> (BPF_PROG_TYPE_XDP_EGRESS) which takes a new context (xdp_egress_md),
> has different return codes, etc.

Taking about return codes.  Does XDP the return codes make sense for
this EGRESS hook? (if thinking about this being egress on the real NIC).

E.g. XDP_REDIRECT would have to be supported, which is interesting, but
also have implications (like looping packets).

E.g. what is the semantics/action of XDP_TX return code?

E.g. I'm considering adding a XDP_CONGESTED return code that can cause
backpressure towards qdisc layer.

Also think about that if this EGRESS hook uses standard prog type for
XDP (BPF_PROG_TYPE_XDP), then we need to convert xdp_frame to xdp_buff
(and also convert SKBs to xdp_buff).

Are we sure that reusing the same bpf prog type is the right choice?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

