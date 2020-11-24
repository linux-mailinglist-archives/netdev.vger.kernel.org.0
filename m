Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1172C3015
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404250AbgKXSlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:41:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404168AbgKXSlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 13:41:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AFF2206D8;
        Tue, 24 Nov 2020 18:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606243273;
        bh=yVfi6Rus2ygw10iMKFhX/lFhewUdnnSLDtB4juWYiy4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jdS/5hQ7BCLJDwu2/PmHPPsMJcah6FlbFJ3tBgSXoWjbpwLxb06pmGPjNisbxsxK8
         opi6lm9ersrzUU+45Dh91LjMDW88bRaobxY9VbsQK+BqSzoyTmCGX4rY+WE3nsBMM7
         NOq/fnS8xsDU4FGzP+QZXSn2zPa6yU3+6OYfFMTw=
Date:   Tue, 24 Nov 2020 10:41:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX
 namespace
Message-ID: <20201124104106.0b1201b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124180210.GJ5487@ziepe.ca>
References: <20201120230339.651609-1-saeedm@nvidia.com>
        <20201120230339.651609-12-saeedm@nvidia.com>
        <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201122064158.GA9749@mtl-vdi-166.wap.labs.mlnx>
        <20201124091219.5900e7bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201124180210.GJ5487@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 14:02:10 -0400 Jason Gunthorpe wrote:
> On Tue, Nov 24, 2020 at 09:12:19AM -0800, Jakub Kicinski wrote:
> > On Sun, 22 Nov 2020 08:41:58 +0200 Eli Cohen wrote: =20
> > > On Sat, Nov 21, 2020 at 04:01:55PM -0800, Jakub Kicinski wrote: =20
> > > > On Fri, 20 Nov 2020 15:03:34 -0800 Saeed Mahameed wrote:   =20
> > > > > From: Eli Cohen <eli@mellanox.com>
> > > > >=20
> > > > > Add a new namespace type to the NIC RX root namespace to allow for
> > > > > inserting VDPA rules before regular NIC but after bypass, thus al=
lowing
> > > > > DPDK to have precedence in packet processing.   =20
> > > >=20
> > > > How does DPDK and VDPA relate in this context?   =20
> > >=20
> > > mlx5 steering is hierarchical and defines precedence amongst namespac=
es.
> > > Up till now, the VDPA implementation would insert a rule into the
> > > MLX5_FLOW_NAMESPACE_BYPASS hierarchy which is used by DPDK thus taking
> > > all the incoming traffic.
> > >=20
> > > The MLX5_FLOW_NAMESPACE_VDPA hirerachy comes after
> > > MLX5_FLOW_NAMESPACE_BYPASS. =20
> >=20
> > Our policy was no DPDK driver bifurcation. There's no asterisk saying
> > "unless you pretend you need flow filters for RDMA, get them upstream
> > and then drop the act". =20
>=20
> Huh?
>=20
> mlx5 DPDK is an *RDMA* userspace application.=20

Forgive me for my naivet=C3=A9.=20

Here I thought the RDMA subsystem is for doing RDMA.

I'm sure if you start doing crypto over ibverbs crypto people will want
to have a look.

> libibverbs. It runs on the RDMA stack. It uses RDMA flow filtering and
> RDMA raw ethernet QPs.=20

I'm not saying that's not the case. I'm saying I don't think this was
something that netdev developers signed-off on. And our policy on DPDK
is pretty widely known.

Would you mind pointing us to the introduction of raw Ethernet QPs?

Is there any production use for that without DPDK?

> It has been like this for years, it is not some "act".
>=20
> It is long standing uABI that accelerators like RDMA/etc get to take
> the traffic before netdev. This cannot be reverted. I don't really
> understand what you are expecting here?

Same. I don't really know what you expect me to do either. I don't
think I can sign-off on kernel changes needed for DPDK.
