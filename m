Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3652C3907
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 07:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgKYGUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 01:20:13 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6615 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKYGUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 01:20:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbdf79c0000>; Tue, 24 Nov 2020 22:20:12 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 06:20:01 +0000
Date:   Wed, 25 Nov 2020 08:19:57 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "Leon Romanovsky" <leonro@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Eli Cohen <eli@mellanox.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX
 namespace
Message-ID: <20201125061957.GA147410@mtl-vdi-166.wap.labs.mlnx>
References: <20201120230339.651609-1-saeedm@nvidia.com>
 <20201120230339.651609-12-saeedm@nvidia.com>
 <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201122064158.GA9749@mtl-vdi-166.wap.labs.mlnx>
 <20201124091219.5900e7bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201124180210.GJ5487@ziepe.ca>
 <20201124104106.0b1201b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201124194413.GF4800@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201124194413.GF4800@nvidia.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606285212; bh=zDT2kSY+E0RrFDWzVLUHvEOf7sAwa+LipajDaZR4kJ0=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=WwiuHfWDNW2Ij/L707xfGMBNHHVQrSixZZLCW0lzhd8ccXxklj08Mi43M1QcDUzI3
         klfgMVA00UwpV41vZ68THyN2GN5Bho0zB0mSWGZcLu/SWDlHDbuwirI3bODqYSIiKQ
         4BalbAqJHd9ACGZgb1Pf+Pqj2/UtobtQvAGUYW+t1Sr3/Pp1Tvx+XbKGXNnOxsOOQH
         FIhc+rhj49ZQ6nuyXm47+8B3rDWciT9naszxwSTzes95C7ZWsME/WXgGqT1p1P1bEi
         qZHt0SpMY8YPuclD4/f5NzIwuTOZkZM25RnINIriFP85qJKrABbPfRTpADs7ksLbWv
         Miwd3HGvCwwJg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 03:44:13PM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2020 at 10:41:06AM -0800, Jakub Kicinski wrote:
> > On Tue, 24 Nov 2020 14:02:10 -0400 Jason Gunthorpe wrote:
> > > On Tue, Nov 24, 2020 at 09:12:19AM -0800, Jakub Kicinski wrote:
> > > > On Sun, 22 Nov 2020 08:41:58 +0200 Eli Cohen wrote: =20
> > > > > On Sat, Nov 21, 2020 at 04:01:55PM -0800, Jakub Kicinski wrote: =
=20
> > > > > > On Fri, 20 Nov 2020 15:03:34 -0800 Saeed Mahameed wrote:   =20
> > > > > > > From: Eli Cohen <eli@mellanox.com>
> > > > > > >=20
> > > > > > > Add a new namespace type to the NIC RX root namespace to allo=
w for
> > > > > > > inserting VDPA rules before regular NIC but after bypass, thu=
s allowing
> > > > > > > DPDK to have precedence in packet processing.   =20
> > > > > >=20
> > > > > > How does DPDK and VDPA relate in this context?   =20
> > > > >=20
> > > > > mlx5 steering is hierarchical and defines precedence amongst name=
spaces.
> > > > > Up till now, the VDPA implementation would insert a rule into the
> > > > > MLX5_FLOW_NAMESPACE_BYPASS hierarchy which is used by DPDK thus t=
aking
> > > > > all the incoming traffic.
> > > > >=20
> > > > > The MLX5_FLOW_NAMESPACE_VDPA hirerachy comes after
> > > > > MLX5_FLOW_NAMESPACE_BYPASS. =20
> > > >=20
> > > > Our policy was no DPDK driver bifurcation. There's no asterisk sayi=
ng
> > > > "unless you pretend you need flow filters for RDMA, get them upstre=
am
> > > > and then drop the act". =20
> > >=20
> > > Huh?
> > >=20
> > > mlx5 DPDK is an *RDMA* userspace application.=20
> >=20
> > Forgive me for my naivet=E9.=20
> >=20
> > Here I thought the RDMA subsystem is for doing RDMA.
>=20
> RDMA covers a wide range of accelerated networking these days.. Where
> else are you going to put this stuff in the kernel?
>=20
> > I'm sure if you start doing crypto over ibverbs crypto people will want
> > to have a look.
>=20
> Well, RDMA has crypto transforms for a few years now too. Why would
> crypto subsystem people be involved? It isn't using or duplicating
> their APIs.
>=20
> > > libibverbs. It runs on the RDMA stack. It uses RDMA flow filtering an=
d
> > > RDMA raw ethernet QPs.=20
> >=20
> > I'm not saying that's not the case. I'm saying I don't think this was
> > something that netdev developers signed-off on.
>=20
> Part of the point of the subsystem split was to end the fighting that
> started all of it. It was very clear during the whole iWarp and TCP
> Offload Engine buisness in the mid 2000's that netdev wanted nothing
> to do with the accelerator world.
>=20
> So why would netdev need sign off on any accelerator stuff?  Do you
> want to start co-operating now? I'm willing to talk about how to do
> that.
>=20
> > And our policy on DPDK is pretty widely known.
>=20
> I honestly have no idea on the netdev DPDK policy, I'm maintaining the
> RDMA subsystem not DPDK :)
>=20
> > Would you mind pointing us to the introduction of raw Ethernet QPs?
> >=20
> > Is there any production use for that without DPDK?
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
> > > It is long standing uABI that accelerators like RDMA/etc get to take
> > > the traffic before netdev. This cannot be reverted. I don't really
> > > understand what you are expecting here?
> >=20
> > Same. I don't really know what you expect me to do either. I don't
> > think I can sign-off on kernel changes needed for DPDK.
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

I agree, RDMA should have been used here. DPDK is just one, though
widely used, accelerator using RDMA interfaces to flow steering.

I will push submit another patch with a modified change log.

>=20
> Jason
