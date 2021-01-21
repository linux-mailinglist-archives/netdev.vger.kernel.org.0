Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B4B2FF152
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 18:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388325AbhAUREm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 12:04:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43709 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388238AbhAURDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 12:03:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611248512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iNfX61EaEwTFrOzZAH3QojK3df9O8orRCgUNIXWU7Dk=;
        b=A4gjMIxJvDfgT6BsMPKRF6NET2KPsXuwud/uDLVqK+rilj/uPlVsYu7Fv5mANF5du1po10
        35AWxGOvs+sezmTr6F3KeQcOVkb/y0UImrVa699CJ9+Xk3s1d3X13u5MtqOvUhMRwW/IGO
        IINRNKuyiRcv6wNdWR1cZSsGhl5Dm48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-hs6rCUOEN62DEmayfPxp5g-1; Thu, 21 Jan 2021 12:01:48 -0500
X-MC-Unique: hs6rCUOEN62DEmayfPxp5g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB3FA8145E1;
        Thu, 21 Jan 2021 17:01:45 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC1D271CA2;
        Thu, 21 Jan 2021 17:01:35 +0000 (UTC)
Date:   Thu, 21 Jan 2021 18:01:34 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@gmail.com>, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, kuba@kernel.org,
        jonathan.lemon@gmail.com, davem@davemloft.net,
        john.fastabend@gmail.com, ciara.loftus@intel.com,
        weqaar.a.janjua@intel.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next v2 0/8] Introduce bpf_redirect_xsk() helper
Message-ID: <20210121180134.51070b74@carbon>
In-Reply-To: <20210120161931.GA32916@ranger.igk.intel.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
        <7dcee85b-b3ef-947f-f433-03ad7066c5dd@nvidia.com>
        <20210120165708.243f83cb@carbon>
        <20210120161931.GA32916@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 17:19:31 +0100
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> On Wed, Jan 20, 2021 at 04:57:08PM +0100, Jesper Dangaard Brouer wrote:
> > On Wed, 20 Jan 2021 15:15:22 +0200
> > Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> >  =20
> > > On 2021-01-19 17:50, Bj=C3=B6rn T=C3=B6pel wrote: =20
> > > > This series extends bind() for XDP sockets, so that the bound socket
> > > > is added to the netdev_rx_queue _rx array in the netdevice. We call
> > > > this to register the socket. To redirect packets to the registered
> > > > socket, a new BPF helper is used: bpf_redirect_xsk().
> > > >=20
> > > > For shared XDP sockets, only the first bound socket is
> > > > registered. Users that need more complex setup has to use XSKMAP and
> > > > bpf_redirect_map().
> > > >=20
> > > > Now, why would one use bpf_redirect_xsk() over the regular
> > > > bpf_redirect_map() helper?
> > > >=20
> > > > * Better performance!
> > > > * Convenience; Most user use one socket per queue. This scenario is
> > > >    what registered sockets support. There is no need to create an
> > > >    XSKMAP. This can also reduce complexity from containerized setup=
s,
> > > >    where users might what to use XDP sockets without CAP_SYS_ADMIN
> > > >    capabilities. =20
> >=20
> > I'm buying into the convenience and reduce complexity, and XDP sockets
> > without CAP_SYS_ADMIN into containers.
> >=20
> > People might be surprised that I'm actually NOT buying into the better
> > performance argument here.  At these speeds we are basically comparing
> > how close we are to zero (and have to use nanosec time scale for our
> > comparisons), more below.
> >=20
> >   =20
> > > > The first patch restructures xdp_do_redirect() a bit, to make it
> > > > easier to add the new helper. This restructure also give us a slight
> > > > performance benefit. The following three patches extends bind() and
> > > > adds the new helper. After that, two libbpf patches that selects XDP
> > > > program based on what kernel is running. Finally, selftests for the=
 new
> > > > functionality is added.
> > > >=20
> > > > Note that the libbpf "auto-selection" is based on kernel version, so
> > > > it is hard coded to the "-next" version (5.12). If you would like to
> > > > try this is out, you will need to change the libbpf patch locally!
> > > >=20
> > > > Thanks to Maciej and Magnus for the internal review/comments!
> > > >=20
> > > > Performance (rxdrop, zero-copy)
> > > >=20
> > > > Baseline
> > > > Two cores:                   21.3 Mpps
> > > > One core:                    24.5 Mpps   =20
> > >=20
> > > Two cores is slower? It used to be faster all the time, didn't it?
> > >  =20
> > > > Patched
> > > > Two cores, bpf_redirect_map: 21.7 Mpps + 2%
> > > > One core, bpf_redirect_map:  24.9 Mpps + 2%
> > > >=20
> > > > Two cores, bpf_redirect_xsk: 24.0 Mpps +13%   =20
> > >=20
> > > Nice, impressive improvement! =20
> >=20
> > I do appreciate you work and performance optimizations at this level,
> > because when we are using this few CPU cycles per packet, then it is
> > really hard to find new ways to reduce cycles further.
> >=20
> > Thank for you saying +13% instead of saying +2.7 Mpps.
> > It *is* impressive to basically reduce cycles with 13%.
> >=20
> >  21.3 Mpps =3D 46.94 nanosec per packet
> >  24.0 Mpps =3D 41.66 nanosec per packet
> >=20
> >  21.3 Mpps -> 24.0 Mpps =3D 5.28 nanosec saved
> >=20
> > On my 3.60GHz testlab machine that gives me 19 cycles.
> >=20
> >   =20
> > > > One core, bpf_redirect_xsk:  25.5 Mpps + 4%
> > > > =20
> >=20
> >  24.5 Mpps -> 25.5 Mpps =3D 1.6 nanosec saved
> >=20
> > At this point with saving 1.6 ns this is around the cost of a function =
call 1.3 ns.
> >=20
> >=20
> > We still need these optimization in the kernel, but end-users in
> > userspace are very quickly going to waste the 19 cycles we found.
> > I still support/believe that the OS need to have a little overhead as
> > possible, but for me 42 nanosec overhead is close to zero overhead. For
> > comparison, I just ran a udp_sink[3] test, and it "cost" 625 ns for
> > delivery of UDP packets into socket (almost 15 times slower).
> >=20
> > I guess my point is that with XDP we have already achieved and exceeded
> > (my original) performance goals, making it even faster is just showing =
off ;-P =20
>=20
> Even though I'll let Bjorn elaborating on this, we're talking here about
> AF-XDP which is a bit different pair of shoes to me in terms of
> performance. AFAIK we still have a gap when compared to DPDK's numbers. So

AFAIK the gap on this i40e hardware is DPDK=3D36Mpps, and lets say
AF_XDP=3D25.5 Mpps, that looks large +10.5Mpps, but it is only 11.4
nanosec.

> I'm really not sure why better performance bothers you? :)

Finding those 11.4 nanosec is going to be really difficult and take a
huge effort. My fear is also that some of these optimizations will make
the code harder to maintain and understand.

If you are ready to do this huge effort, then I'm actually ready to
provide ideas on what you can optimize.

E.g. you can get 2-4 nanosec if we prefetch to L2 in driver (assuming
data is DDIO in L3 already).  (CPU supports L2 prefetch, but kernel
have no users of that feature).

The base design of XDP redirect API, that have a number of function
calls per packet, in itself becomes a limiting factor.  Even the cost
of getting the per-CPU pointer to bpf_redirect_info becomes something
to look at.


> Let's rather be more harsh on changes that actually decrease the
> performance, not the other way around. And I suppose you were the one that
> always was bringing up the 'death by a 1000 paper cuts' of XDP. So yeah,
> I'm a bit confused with your statement.

Yes, we really need to protect the existing the performance.

I think I'm mostly demotivated by the 'death by a 1000 paper cuts'.
People with good intentions are adding features, and performance slowly
disappears.  I've been spending weeks/months finding nanosec level
improvements, which I don't have time to "defend". Recently I realized
that the 2nd XDP prog on egress, even when no prog is attached, is
slowing down the performance of base redirect (I don't fully understand
why, maybe it is simply the I-cache increase, I didn't realize when
reviewing the code).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

