Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744A32C4852
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgKYT2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:28:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbgKYT2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 14:28:39 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D72A206D9;
        Wed, 25 Nov 2020 19:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606332518;
        bh=S7cLKqUMThvmWL9SOhHBiWWJMLfgLvuvg21Uz7F0790=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mev3bOTYVxzfh5Ta2trG5+4v+KhyLpvTHbkKqmGIfjEIlY1B7YSWpsTY6ZElgM2JF
         m0v51uC5d440canr6l+YViab/Rek1xAdqE/vbV6FHRDqFuEap1NZLM4+ZE+8LMN3e8
         mNG8+YF9jo3qxKK/bGraSG6CwLL9sFl8CCjOszLY=
Message-ID: <5f540832686c4b062ddbc80f20c9d9d80097e813.camel@kernel.org>
Subject: Re: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX
 namespace
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leonro@mellanox.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Date:   Wed, 25 Nov 2020 11:28:37 -0800
In-Reply-To: <20201125105422.7f90184c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
         <20201120230339.651609-12-saeedm@nvidia.com>
         <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201122064158.GA9749@mtl-vdi-166.wap.labs.mlnx>
         <20201124091219.5900e7bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201124180210.GJ5487@ziepe.ca>
         <20201124104106.0b1201b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201124194413.GF4800@nvidia.com>
         <20201125105422.7f90184c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-25 at 10:54 -0800, Jakub Kicinski wrote:
> On Tue, 24 Nov 2020 15:44:13 -0400 Jason Gunthorpe wrote:
> > On Tue, Nov 24, 2020 at 10:41:06AM -0800, Jakub Kicinski wrote:
> > > On Tue, 24 Nov 2020 14:02:10 -0400 Jason Gunthorpe wrote:  

[snip]

> > > > > > 
> > > > It has been like this for years, it is not some "act".
> > > > 
> > > > It is long standing uABI that accelerators like RDMA/etc get to
> > > > take the traffic before netdev. This cannot be reverted. I
> > > > don't
> > > > really understand what you are expecting here?  
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
> I'm not so sure about this.
> 
> The switchdev modeling is supposed to give users control over flow of
> traffic in a sane, well defined way, as opposed to magic flow
> filtering
> of the early SR-IOV implementations which every vendor had their own
> twist on. 
> 
> Now IIUC you're tapping traffic for DPDK/raw QPs _before_ all
> switching
> happens in the NIC? That breaks the switchdev model. We're back to
> per-vendor magic.

No this is after switching, nothing can precede switching!
after switching and forwarding to the correct function/vport, 
The HW deumx rdma to rdma and eth(rest) to netdev.

> 
> And why do you need a separate VDPA table in the first place?
> Forwarding to a VDPA device has different semantics than forwarding
> to
> any other VF/SF?

VDPA is yet another "RDMA" Application, similar to raw qp, it is
different than VF/SF.

switching can only forward to PF/VF/SF, it doesn't know or care about
the end point app (netdev/rdma).

Jakub, this is how rdma works and has been working for the past 20
years :), Jason is well aware of the lack of visibility, and i am sure
rdma folks will improve this, they have been improving a lot lately,
take rdma_tool for example.

Bottom line the switching model is not the answer for rdma, another
model is required, rdma by definition is HW oriented from day one, you
can't think of it as an offloaded SW model. ( also in a real switch you
can't define if a port is rdma or eth :) ) 

Anyway you have very valid points that Jason already raised in the
past, but the challenge is more complicated than the challenges we have
in netdev, simply because RDMA is RDMA, where the leading model is the
HW model and the rdma spec and not the SW .. 


