Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B3E2C47F7
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbgKYSyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:54:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729679AbgKYSyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 13:54:25 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70ED320674;
        Wed, 25 Nov 2020 18:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606330464;
        bh=50UrEOhOSzC7WOltqnKxUjFXUCfM27wAeiXzbvuJr/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fwybIGGfUzx91rybT+pPkd+OM/Fq/DXTYwXsf3+FI9HAiWq5o1P/dMz8N3Tl28Z+E
         i4lBGc56e1A+G2i7TIAO4kXdVkL8jNyaTVizff7ama8Mv0vxQ4JDiOUrfnVUSca5zk
         NH1EUvWs7JbtcKnhNrO0zlzG+kia5FFLIjZOAATA=
Date:   Wed, 25 Nov 2020 10:54:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX
 namespace
Message-ID: <20201125105422.7f90184c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124194413.GF4800@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
 <20201120230339.651609-12-saeedm@nvidia.com>
 <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201122064158.GA9749@mtl-vdi-166.wap.labs.mlnx>
 <20201124091219.5900e7bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201124180210.GJ5487@ziepe.ca>
 <20201124104106.0b1201b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201124194413.GF4800@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 15:44:13 -0400 Jason Gunthorpe wrote:
> On Tue, Nov 24, 2020 at 10:41:06AM -0800, Jakub Kicinski wrote:
> > On Tue, 24 Nov 2020 14:02:10 -0400 Jason Gunthorpe wrote: =20
> > > On Tue, Nov 24, 2020 at 09:12:19AM -0800, Jakub Kicinski wrote: =20
> > > > On Sun, 22 Nov 2020 08:41:58 +0200 Eli Cohen wrote:   =20
> > > > > On Sat, Nov 21, 2020 at 04:01:55PM -0800, Jakub Kicinski wrote:  =
 =20
> > > > > > On Fri, 20 Nov 2020 15:03:34 -0800 Saeed Mahameed wrote:     =20
> > > > > > > From: Eli Cohen <eli@mellanox.com>
> > > > > > >=20
> > > > > > > Add a new namespace type to the NIC RX root namespace to allo=
w for
> > > > > > > inserting VDPA rules before regular NIC but after bypass, thu=
s allowing
> > > > > > > DPDK to have precedence in packet processing.     =20
> > > > > >=20
> > > > > > How does DPDK and VDPA relate in this context?     =20
> > > > >=20
> > > > > mlx5 steering is hierarchical and defines precedence amongst name=
spaces.
> > > > > Up till now, the VDPA implementation would insert a rule into the
> > > > > MLX5_FLOW_NAMESPACE_BYPASS hierarchy which is used by DPDK thus t=
aking
> > > > > all the incoming traffic.
> > > > >=20
> > > > > The MLX5_FLOW_NAMESPACE_VDPA hirerachy comes after
> > > > > MLX5_FLOW_NAMESPACE_BYPASS.   =20
> > > >=20
> > > > Our policy was no DPDK driver bifurcation. There's no asterisk sayi=
ng
> > > > "unless you pretend you need flow filters for RDMA, get them upstre=
am
> > > > and then drop the act".   =20
> > >=20
> > > Huh?
> > >=20
> > > mlx5 DPDK is an *RDMA* userspace application.  =20
> >=20
> > Forgive me for my naivet=C3=A9.=20
> >=20
> > Here I thought the RDMA subsystem is for doing RDMA. =20
>=20
> RDMA covers a wide range of accelerated networking these days.. Where
> else are you going to put this stuff in the kernel?

IDK what else you got in there :) It's probably a case by case answer.

IMHO even using libibverbs is no strong reason for things to fall under
RDMA exclusively. Client drivers of virtio don't get silently funneled
through a separate tree just because they use a certain spec.

> > I'm sure if you start doing crypto over ibverbs crypto people will want
> > to have a look. =20
>=20
> Well, RDMA has crypto transforms for a few years now too.=20

Are you talking about RDMA traffic being encrypted? That's a different
case.

My example was alluding to access to a generic crypto accelerator=20
over ibverbs. I hope you'd let crypto people know when merging such=20
a thing...

> Why would crypto subsystem people be involved? It isn't using or
> duplicating their APIs.
>=20
> > > libibverbs. It runs on the RDMA stack. It uses RDMA flow
> > > filtering and RDMA raw ethernet QPs.  =20
> >=20
> > I'm not saying that's not the case. I'm saying I don't think this
> > was something that netdev developers signed-off on. =20
>=20
> Part of the point of the subsystem split was to end the fighting that
> started all of it. It was very clear during the whole iWarp and TCP
> Offload Engine buisness in the mid 2000's that netdev wanted nothing
> to do with the accelerator world.

I was in middle school at the time, not sure what exactly went down :)
But I'm going by common sense here. Perhaps there was an agreement I'm
not aware of?

> So why would netdev need sign off on any accelerator stuff?

I'm not sure why you keep saying accelerators!

What is accelerated in raw Ethernet frame access??

> Do you want to start co-operating now? I'm willing to talk about how
> to do that.

IDK how that's even in question. I always try to bump all RDMA-looking
stuff to linux-rdma when it's not CCed there. That's the bare minimum
of cooperation I'd expect from anyone.

> > And our policy on DPDK is pretty widely known. =20
>=20
> I honestly have no idea on the netdev DPDK policy,
>=20
> I'm maintaining the RDMA subsystem not DPDK :)

That's what I thought, but turns out DPDK is your important user.

> > Would you mind pointing us to the introduction of raw Ethernet QPs?
> >=20
> > Is there any production use for that without DPDK? =20
>=20
> Hmm.. It is very old. RAW (InfiniBand) QPs were part of the original
> IBA specification cira 2000. When RoCE was defined (around 2010) they
> were naturally carried forward to Ethernet. The "flow steering"
> concept to make raw ethernet QP useful was added to verbs around 2012
> - 2013. It officially made it upstream in commit 436f2ad05a0b
> ("IB/core: Export ib_create/destroy_flow through uverbs")
>=20
> If I recall properly the first real application was ultra low latency
> ethernet processing for financial applications.
>=20
> dpdk later adopted the first mlx4 PMD using this libibverbs API around
> 2015. Interestingly the mlx4 PMD was made through an open source
> process with minimal involvment from Mellanox, based on the
> pre-existing RDMA work.
>=20
> Currently there are many projects, and many open source, built on top
> of the RDMA raw ethernet QP and RDMA flow steering model. It is now
> long established kernel ABI.
>=20
> > > It has been like this for years, it is not some "act".
> > >=20
> > > It is long standing uABI that accelerators like RDMA/etc get to
> > > take the traffic before netdev. This cannot be reverted. I don't
> > > really understand what you are expecting here? =20
> >=20
> > Same. I don't really know what you expect me to do either. I don't
> > think I can sign-off on kernel changes needed for DPDK. =20
>=20
> This patch is fine tuning the shared logic that splits the traffic to
> accelerator subsystems, I don't think netdev should have a veto
> here. This needs to be consensus among the various communities and
> subsystems that rely on this.
>=20
> Eli did not explain this well in his commit message. When he said DPDK
> he means RDMA which is the owner of the FLOW_NAMESPACE. Each
> accelerator subsystem gets hooked into this, so here VPDA is getting
> its own hook because re-using the the same hook between two kernel
> subsystems is buggy.

I'm not so sure about this.

The switchdev modeling is supposed to give users control over flow of
traffic in a sane, well defined way, as opposed to magic flow filtering
of the early SR-IOV implementations which every vendor had their own
twist on.=20

Now IIUC you're tapping traffic for DPDK/raw QPs _before_ all switching
happens in the NIC? That breaks the switchdev model. We're back to
per-vendor magic.

And why do you need a separate VDPA table in the first place?
Forwarding to a VDPA device has different semantics than forwarding to
any other VF/SF?
