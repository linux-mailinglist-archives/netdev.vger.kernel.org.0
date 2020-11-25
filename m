Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941742C480A
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgKYTEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgKYTEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 14:04:32 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52BD9206CA;
        Wed, 25 Nov 2020 19:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606331071;
        bh=BG9RtXrLVfIUmhZPYwd7utIU0Z/QV+j5gRlultB+4c8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JmdtvICAK6oeoSdIKFECP6L8EzlYiY22+fsFp6Nfk/WLZF9nzhYdFUsaeO48Sx1fG
         DN/7JZtTc+Ap8bKga3ximmUlE3yOezthHuOD2MWmwO6YtTKCm1nmi8unnrRLsJl14x
         /N+a+B9juHcIstT7XB2WAHW6ue9VBG/b245bxc5g=
Message-ID: <3e425104273c0a979ebd57bb8537e9522fe90fa9.camel@kernel.org>
Subject: Re: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX
 namespace
From:   Saeed Mahameed <saeed@kernel.org>
To:     Eli Cohen <elic@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Date:   Wed, 25 Nov 2020 11:04:30 -0800
In-Reply-To: <20201125061957.GA147410@mtl-vdi-166.wap.labs.mlnx>
References: <20201120230339.651609-1-saeedm@nvidia.com>
         <20201120230339.651609-12-saeedm@nvidia.com>
         <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201122064158.GA9749@mtl-vdi-166.wap.labs.mlnx>
         <20201124091219.5900e7bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201124180210.GJ5487@ziepe.ca>
         <20201124104106.0b1201b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201124194413.GF4800@nvidia.com>
         <20201125061957.GA147410@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-25 at 08:19 +0200, Eli Cohen wrote:
> On Tue, Nov 24, 2020 at 03:44:13PM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 24, 2020 at 10:41:06AM -0800, Jakub Kicinski wrote:
> > > On Tue, 24 Nov 2020 14:02:10 -0400 Jason Gunthorpe wrote:
> > > > On Tue, Nov 24, 2020 at 09:12:19AM -0800, Jakub Kicinski wrote:
> > > > > On Sun, 22 Nov 2020 08:41:58 +0200 Eli Cohen wrote:  
> > > > > > On Sat, Nov 21, 2020 at 04:01:55PM -0800, Jakub Kicinski
> > > > > > wrote:  
> > > > > > > On Fri, 20 Nov 2020 15:03:34 -0800 Saeed Mahameed
> > > > > > > wrote:    
> > > > > > > > From: Eli Cohen <eli@mellanox.com>
> > > > > > > > 
> > > > > > > > Add a new namespace type to the NIC RX root namespace
> > > > > > > > to allow for
> > > > > > > > inserting VDPA rules before regular NIC but after
> > > > > > > > bypass, thus allowing
> > > > > > > > DPDK to have precedence in packet processing.    
> > > > > > > 
> > > > > > > How does DPDK and VDPA relate in this context?    
> > > > > > 
> > > > > > mlx5 steering is hierarchical and defines precedence
> > > > > > amongst namespaces.
> > > > > > Up till now, the VDPA implementation would insert a rule
> > > > > > into the
> > > > > > MLX5_FLOW_NAMESPACE_BYPASS hierarchy which is used by DPDK
> > > > > > thus taking
> > > > > > all the incoming traffic.
> > > > > > 
> > > > > > The MLX5_FLOW_NAMESPACE_VDPA hirerachy comes after
> > > > > > MLX5_FLOW_NAMESPACE_BYPASS.  
> > > > > 
> > > > > Our policy was no DPDK driver bifurcation. There's no
> > > > > asterisk saying
> > > > > "unless you pretend you need flow filters for RDMA, get them
> > > > > upstream
> > > > > and then drop the act".  
> > > > 
> > > > Huh?
> > > > 
> > > > mlx5 DPDK is an *RDMA* userspace application. 
> > > 
> > > Forgive me for my naiveté. 
> > > 
> > > Here I thought the RDMA subsystem is for doing RDMA.
> > 
> > RDMA covers a wide range of accelerated networking these days..
> > Where
> > else are you going to put this stuff in the kernel?
> > 
> > > I'm sure if you start doing crypto over ibverbs crypto people
> > > will want
> > > to have a look.
> > 
> > Well, RDMA has crypto transforms for a few years now too. Why would
> > crypto subsystem people be involved? It isn't using or duplicating
> > their APIs.
> > 
> > > > libibverbs. It runs on the RDMA stack. It uses RDMA flow
> > > > filtering and
> > > > RDMA raw ethernet QPs. 
> > > 
> > > I'm not saying that's not the case. I'm saying I don't think this
> > > was
> > > something that netdev developers signed-off on.
> > 
> > Part of the point of the subsystem split was to end the fighting
> > that
> > started all of it. It was very clear during the whole iWarp and TCP
> > Offload Engine buisness in the mid 2000's that netdev wanted
> > nothing
> > to do with the accelerator world.
> > 
> > So why would netdev need sign off on any accelerator stuff?  Do you
> > want to start co-operating now? I'm willing to talk about how to do
> > that.
> > 
> > > And our policy on DPDK is pretty widely known.
> > 
> > I honestly have no idea on the netdev DPDK policy, I'm maintaining
> > the
> > RDMA subsystem not DPDK :)
> > 
> > > Would you mind pointing us to the introduction of raw Ethernet
> > > QPs?
> > > 
> > > Is there any production use for that without DPDK?
> > 
> > Hmm.. It is very old. RAW (InfiniBand) QPs were part of the
> > original
> > IBA specification cira 2000. When RoCE was defined (around 2010)
> > they
> > were naturally carried forward to Ethernet. The "flow steering"
> > concept to make raw ethernet QP useful was added to verbs around
> > 2012
> > - 2013. It officially made it upstream in commit 436f2ad05a0b
> > ("IB/core: Export ib_create/destroy_flow through uverbs")
> > 
> > If I recall properly the first real application was ultra low
> > latency
> > ethernet processing for financial applications.
> > 
> > dpdk later adopted the first mlx4 PMD using this libibverbs API
> > around
> > 2015. Interestingly the mlx4 PMD was made through an open source
> > process with minimal involvment from Mellanox, based on the
> > pre-existing RDMA work.
> > 
> > Currently there are many projects, and many open source, built on
> > top
> > of the RDMA raw ethernet QP and RDMA flow steering model. It is now
> > long established kernel ABI.
> > 
> > > > It has been like this for years, it is not some "act".
> > > > 
> > > > It is long standing uABI that accelerators like RDMA/etc get to
> > > > take
> > > > the traffic before netdev. This cannot be reverted. I don't
> > > > really
> > > > understand what you are expecting here?
> > > 
> > > Same. I don't really know what you expect me to do either. I
> > > don't
> > > think I can sign-off on kernel changes needed for DPDK.
> > 
> > This patch is fine tuning the shared logic that splits the traffic
> > to
> > accelerator subsystems, I don't think netdev should have a veto
> > here. This needs to be consensus among the various communities and
> > subsystems that rely on this.
> > 
> > Eli did not explain this well in his commit message. When he said
> > DPDK
> > he means RDMA which is the owner of the FLOW_NAMESPACE. Each
> > accelerator subsystem gets hooked into this, so here VPDA is
> > getting
> > its own hook because re-using the the same hook between two kernel
> > subsystems is buggy.
> 
> I agree, RDMA should have been used here. DPDK is just one, though
> widely used, accelerator using RDMA interfaces to flow steering.
> 
> I will push submit another patch with a modified change log.

Hi Jakub, Given that this patch is just defining the HW domain of vDPA
to separate it from the RDMA domain, it has no actual functionality,
just the mlx5_core low level hw definition, can i take this patch to
mlx5-next and move on to my next series ? 

Thanks,
Saeed.


