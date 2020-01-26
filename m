Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137AF149D45
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgAZWLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:11:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgAZWLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 17:11:43 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A89B206F0;
        Sun, 26 Jan 2020 22:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580076702;
        bh=kvXprYKhwKQ6DKK462OJfYCocLr22EfI3A9UfMeA0WM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xc6OT1y96mmeK8YjYLjN79vITDnaOuD3/28HlOdB2gcKjh1e/13oup//FZPrXdeOG
         WMecobHZmp8qGxAlhfZ4wwRCd1JtnkGe4HY1EcDrFcIxslNeiD3Nx/3RScSWI+4SE4
         kdUmjg9xT+Jitz95SCZU+tkmXY5NqyrvxLlETngc=
Date:   Sun, 26 Jan 2020 14:11:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200126141141.0b773aba@cakuba>
In-Reply-To: <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jan 2020 18:43:36 -0700, David Ahern wrote:
> On 1/24/20 8:36 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Jakub Kicinski <kuba@kernel.org> writes:
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
>=20
> The first patch set from Jason and Prashant started from the perspective
> of offloading XDP programs for a guest. Independently, I was looking at
> XDP in the TX path (now referred to as egress to avoid confusion with
> the XDP_TX return type).=20

I looked through the commit message and the cover letter again, and you
never explain why you need the egress hook. Could you please clarify
your needs? If it's container-related maybe what Daniel talked about at
last netconf could be a better solution?

I can't quite square the concept of XDP which started as close to the
metal BPF hook for HW drivers, and this heavily SW-focused addition.

> Jason and Prashant were touching some of the
> same code paths in the tun driver that I needed for XDP in the Tx path,
> so we decided to consolidate and have XDP egress done first and then
> offload of VMs as a followup. Offload in virtio_net can be done very
> similar to how it is done in nfp -- the program is passed to the host as
> a hardware level attach mode, and the driver verifies the program can be
> offloaded (e.g., does not contain helpers that expose host specific data
> like the fib lookup helper).

<rant>

I'd ask to please never compare this work to the nfp offload. Netronome
was able to open up their NIC down to the instruction set level, with
the JIT in tree and rest of the FW open source:

https://github.com/Netronome/nic-firmware/

and that work is now used as precedent for something that risks turning
the kernel into a damn control plane for proprietary clouds?

I can see how they may seem similar in operational terms, but for
people who care about open source they couldn't be more different.

</rant>

> At this point, you need to stop thinking solely from the perspective of
> tun or tap and VM offload; think about this from the ability to run an
> XDP program on egress path at an appropriate place in the NIC driver
> that covers both skbs and xdp_frames (e.g., on a REDIRECT). This has
> been discussed before as a need (e.g, Toke's reference above), and I am
> trying to get this initial support done.

TX hook related to queuing is a very different beast than just a RX
hook flipped. The queuing is a problem that indeed needs work, but just
adding a mirror RX hook does not solve that, and establishes semantics
which may be counter productive. That's why I was asking for clear
semantics.

> I very much wanted to avoid copy-paste-modify for the entire XDP API for
> this. For the most part XDP means ebpf at the NIC driver / hardware
> level (obviously with the exception of generic mode). The goal is
> tempered with the need for the verifier to reject rx entries in the
> xdp_md context. Hence the reason for use of an attach_type - existing
> infrastructure to test and reject the accesses.

For the offload host rx queue =3D=3D dev PCI tx queue and vice versa.
So other than the name the rejection makes no sense. Just add a union
to xdp_md so both tx and rx names can be used.
