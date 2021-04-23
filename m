Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345F8369734
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhDWQil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:38:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhDWQik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 12:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619195883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=diPVr+widlL41D+Vcx+6umn09bUuroA9P7fw3tKBNkc=;
        b=bQmqRddkrh0S34fJPESvxRy8OGGSbQCrnYvvstFiQRvG9/LqLxDV2u30Vb0XcEF8QBkcBn
        KgemSO1WD2v2/TNJNcVr/zVFUA/rv7L20stXViVBFdNXZ6BM2kZjOBpss3B+1wZuLDhfZJ
        Ene79nhVEE20ooIfonLBBp4QfQpqzT8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-ySlCSfJaP-6g9hqTyfEo3A-1; Fri, 23 Apr 2021 12:37:59 -0400
X-MC-Unique: ySlCSfJaP-6g9hqTyfEo3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79224107ACC7;
        Fri, 23 Apr 2021 16:37:57 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A4C0175BE;
        Fri, 23 Apr 2021 16:37:32 +0000 (UTC)
Date:   Fri, 23 Apr 2021 18:37:31 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Ong, Boon Leong" <boon.leong.ong@intel.com>
Cc:     "Joseph, Jithu" <jithu.joseph@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>, brouer@redhat.com,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        David Ahern <dsahern@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jens Steen Krogh <jskro@vestas.com>,
        Joao Pedro Barros Silva <jopbs@vestas.com>
Subject: Re: PTP RX & TX time-stamp and TX Time in XDP ZC socket
Message-ID: <20210423183731.7279808a@carbon>
In-Reply-To: <DM6PR11MB2780B29F0045B76119AFC388CA469@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <DM6PR11MB27800045D6EE4A69B1A65C45CA479@DM6PR11MB2780.namprd11.prod.outlook.com>
        <20210421103948.5a453e6d@carbon>
        <DM6PR11MB2780B29F0045B76119AFC388CA469@DM6PR11MB2780.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cc, netdev, as I think we get upstream feedback as early as possible.
(Maybe Alexei will be critique my idea of storing btf_id in struct?)


On Thu, 22 Apr 2021 07:34:23 +0000
"Ong, Boon Leong" <boon.leong.ong@intel.com> wrote:

> >> Now that stmmac driver has been added with XDP ZC, we would like
> >> to know if there is any on-going POC or discussion on XDP ZC
> >> socket for adding below:
> >>
> >> 1) PTP RX & TX time-stamp
> >> 2) Per-packet TX transmit time (similar to SO_TXTIME) =20
> >
> > Well, this is actually perfect timing! (pun intended)
> >
> > I'm actually going to work on adding this to XDP.  I was reading igc
> > driver and i225 sw datasheet last night, trying to figure out a design
> > based on what hardware can do. My design ideas obviously involve BTF,
> > but a lot of missing pieces like an XDP TX hook is also missing. =20
>=20
> Currently, we are using a non-standard/not elegant way to provide for=20
> internal real-time KPI measurement purpose as follow=20
>
> 1) TX time stored in a newly introduced 64-bit timestamp in XDP descripto=
r.

Did you create a separate XDP descriptor?
If so what memory is backing that?

My idea[1] is to use the meta-data area (xdp_buff->data_meta), that is
located in-front of the packet headers.  Or the area in top of the
"packet" memory, which is already used by struct xdp_frame, except that
zero-copy AF_XDP don't have the xdp_frame.  Due to AF_XDP limits I'm
leaning towards using xdp_buff->data_meta area.

[1] https://people.netfilter.org/hawk/presentations/KernelRecipes2019/xdp-n=
etstack-concert.pdf

I should mention that I want a generic solution (based on BTF), that can
support many types of hardware hints.  Like existing RX-hash, VLAN,
checksum, mark and timestamps.  And newer HW hints that netstack
doesn't support yet, e.g. I know mlx5 can assign unique (64-bit)
flow-marks.

I should also mention that I also want the solution to work for (struct)
xdp_frame packets that gets redirected from RX to TX.  And work when/if
an xdp_frame gets converted to an SKB (happens for veth and cpumap)
then the RX-hash, VLAN, checksum, mark, timestamp should be transferred
to the SKB.


> 2) RX T/S is stored in the meta-data of the RX frame.

Yes, I also want to store the RX-timestamp the meta-data area.  This
means that RX-timestamp is stored memory-wise just before the packet
header starts.

For AF_XDP how does the userspace program know that info is stored in
this area(?).  As you know, it might only be some packets that contain
the timestamp, e.g. for some NIC is it only the PTP packets.

I've discussed this with OVS VMware people before (they requested
RX-hash), and in that discussion Bj=C3=B8rn came up with the idea, that the
"-32 bit" could contain the BTF-id number.  Meaning the last u32 member
of the metadata is btf_id (example below).

 struct my_metadata {
	u64 rx_timestamp;
	u32 rx_hash32;
	u32 btf_id;
 };

When having the btf_id then the memory layout basically becomes self
describing.  I guess, we still need a single bit in the AF_XDP
RX-descriptor telling us that meta-data area is populated, or perhaps
we should store the btf_id in the AF_XDP RX-descriptor?

Same goes for xdp_frame, should it store btf_id or have a single bit
that says, btf_id is located in data_meta area.

> 3) TX T/S is simply trace_printk out as there is missing XDP TX hook
>    like you pointed out.

Again I want to use BTF to describe that a driver supports of
TX-timestamp features.  Like Saeed did for RX, the driver should export
(a number) of BTF-id's that it support.

E.g when the LaunchTime features is configured;

 struct my_metadata_tx {
	u64 LaunchTime_ktime;
	u32 btf_id;
 };

When AF_XDP (or xdp_frame) want to transmit a frame as a specific time,
e.g. via LaunchTime feature in i210 (igb) and i225 (igc).

I've read up on i210 and i225 capabilities, and I think this will help
us guide our design choices.  We need to support different BTF-desc per
TX queue basis, because the LaunchTime is configured per TX queue, and
further more, i210 only support this on queue 0 and 1.

Currently the LaunchTime config happens via TC config when attaching a
ETF qdisc and doing TC-offloading.  For now, I'm not suggesting
changing that.  Instead we can simply export/expose that the driver now
support LaunchTime BTF-desc, when the config gets enabled.


> So, if there is some ready work that we can evaluate, it will have us
> greatly in extending it to stmmac driver.=20

Saeed have done a number of different implementation attempts on RX
side with BTF.  We might be able to leverage some of that work.  That
said, the kernels BTF API have become more advanced since Saeed worked
on this. Thus, I expect that we might be able to leverage some of this
to simplify the approach.


> >I have a practical project with a wind-turbine producer Vestas (they
> >have even approved we can say this publicly on mailing lists). Thus, I
> >can actually dedicate some time for this.
> >
> >You also have a practical project that needs this? (And I/we can keep it
> >off the mailing lists if you prefer/need-to). =20
>=20
> Yes, we are about to start a a 3-way joint-development project that is
> evaluating the suitability of using preempt-RT + XDP ZC + TSN for
> integrating high level Industrial Ethernet stack on-top of Linux mainline
> interface. So, there is couple of area that we will be looking into and
> above two capabilities are foundational in adding "time-aware" to
> XDP ZC interface.  But, our current focus on getting the Linux mainline
> capability ready, so we can discuss in ML.

It sounds like our projects align very well! :-)))
My customer also want the combination preempt-RT + XDP ZC + TSN.

> >My plans: I will try to understand the hardware and drivers better, and
> >then I will work on a design proposal that I will share with you for
> >review.
> >
> >What are your plans? =20
>=20
> Siang and myself are looking into this area starting next week and
> hopefully our time is aligned and we are hopeful to get this
> capability available in stmmac for next RC cycles. Is the time-line
> aligned to yours?

Yes, this aligns with my time-line.  I want to start prototyping some
things next week, so I can start to run experiments with TSN.  The
TSN capable hardware for our PoC is being shipped to my house and
should arrive next week.

Looking forward to collaborate with all of you.  You can let me know
(offlist) if you prefer not getting Cc'ed on these mails. Some of you
are bcc'ed and you have to opt-in if you are interested in collaborating.
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

