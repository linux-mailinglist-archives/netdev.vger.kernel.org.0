Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68B12C1804
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732150AbgKWVvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:51:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731686AbgKWVvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 16:51:55 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9F60206CA;
        Mon, 23 Nov 2020 21:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606168314;
        bh=Xlwr/k2/DrhIr9ZRm+lNiyvIdI4MPAsEyuu0ctX3DTU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iPSplYQ6cBF81ZjPQOiD1qYrh4rNMvMH/fa4iv2jP31H79JiabYvww2Lc8x8PtK8s
         lBsH+5RZEo1o+D3ryY5agomjt9t1I1M1SAwwIc4k590vo4FD/EQOyTX7L8yYw4RJCD
         9IeN0PveXOMV4/lBN5fAxNTK21uXK2IQKEx4Dm0M=
Message-ID: <421951d99a33d28b91f2b2997409d0c97fa5a98a.camel@kernel.org>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
From:   Saeed Mahameed <saeed@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Date:   Mon, 23 Nov 2020 13:51:52 -0800
In-Reply-To: <102d20e1-c78f-09cb-fabb-efdc59f61eb8@intel.com>
References: <20201112192424.2742-1-parav@nvidia.com>
         <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
         <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
         <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <20201117184954.GV917484@nvidia.com>
         <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <96e59cf0-1423-64af-1da9-bd740b393fa8@gmail.com>
         <20201119172930.11ab9e68@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <CAKgT0Uf4i9hrq6Z4dx03sv_ubVpZwKm5Tiz+-UwJp38cTyZg+g@mail.gmail.com>
         <102d20e1-c78f-09cb-fabb-efdc59f61eb8@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-20 at 11:04 -0800, Samudrala, Sridhar wrote:
> 
> On 11/20/2020 9:58 AM, Alexander Duyck wrote:
> > On Thu, Nov 19, 2020 at 5:29 PM Jakub Kicinski <kuba@kernel.org>
> > wrote:
> > > On Wed, 18 Nov 2020 21:35:29 -0700 David Ahern wrote:
> > > > On 11/18/20 7:14 PM, Jakub Kicinski wrote:
> > > > > On Tue, 17 Nov 2020 14:49:54 -0400 Jason Gunthorpe wrote:
> > > > > > On Tue, Nov 17, 2020 at 09:11:20AM -0800, Jakub Kicinski
> > > > > > wrote:
> > > > > > 
> > > > > > > > Just to refresh all our memory, we discussed and
> > > > > > > > settled on the flow
> > > > > > > > in [2]; RFC [1] followed this discussion.
> > > > > > > > 
> > > > > > > > vdpa tool of [3] can add one or more vdpa device(s) on
> > > > > > > > top of already
> > > > > > > > spawned PF, VF, SF device.
> > > > > > > 
> > > > > > > Nack for the networking part of that. It'd basically be
> > > > > > > VMDq.
> > > > > > 
> > > > > > What are you NAK'ing?
> > > > > 
> > > > > Spawning multiple netdevs from one device by slicing up its
> > > > > queues.
> > > > 
> > > > Why do you object to that? Slicing up h/w resources for virtual
> > > > what
> > > > ever has been common practice for a long time.
> > > 
> > > My memory of the VMDq debate is hazy, let me rope in Alex into
> > > this.
> > > I believe the argument was that we should offload software
> > > constructs,
> > > not create HW-specific APIs which depend on HW availability and
> > > implementation. So the path we took was offloading macvlan.
> > 
> > I think it somewhat depends on the type of interface we are talking
> > about. What we were wanting to avoid was drivers spawning their own
> > unique VMDq netdevs and each having a different way of doing it. 

Agreed, but SF netdevs are not a VMDq netdevs, they are avaiable in the
switchdev model where they correspond to a full blown port (HW domain).

> > The
> > approach Intel went with was to use a MACVLAN offload to approach
> > it.
> > Although I would imagine many would argue the approach is somewhat
> > dated and limiting since you cannot do many offloads on a MACVLAN
> > interface.
> 
> Yes. We talked about this at netdev 0x14 and the limitations of
> macvlan 
> based offloads.
> https://netdevconf.info/0x14/session.html?talk-hardware-acceleration-of-container-networking-interfaces
> 
> Subfunction seems to be a good model to expose VMDq VSI or SIOV ADI
> as a 

Exactly, Subfunctions is the most generic model to overcome any SW
model limitations e.g macvtap offload, all HW vendors are already
creating netdevs on a given PF/VF .. all we need is to model the SF and
all the rest is the same! most likely every thing else comes for free
like in the mlx5 model where the netdev/rmda interfaces are abstracted
from the underlying HW, same netdev loads on a PF/VF/SF or even an
embedded function !


> netdev for kernel containers. AF_XDP ZC in a container is one of the 
> usecase this would address. Today we have to pass the entire PF/VF to
> a 
> container to do AF_XDP.
> 

this will be supported out of the box for free with SFs.

> Looks like the current model is to create a subfunction of a
> specific 
> type on auxiliary bus, do some configuration to assign resources and 
> then activate the subfunction.
> 
> > With the VDPA case I believe there is a set of predefined virtio
> > devices that are being emulated and presented so it isn't as if
> > they
> > are creating a totally new interface for this.
> > 
> > What I would be interested in seeing is if there are any other
> > vendors
> > that have reviewed this and sign off on this approach. What we
> > don't
> > want to see is Nivida/Mellanox do this one way, then Broadcom or
> > Intel
> > come along later and have yet another way of doing this. We need an
> > interface and feature set that will work for everyone in terms of
> > how
> > this will look going forward.

Well, the vdpa interface was created by the virtio community and
especially redhat, i am not sure mellanox were even involved in the
initial development stages :-)

anyway historically speaking vDPA was originally created for DPDK, but
same API applies to device drivers who can deliver the same set of
queues and API while bypassing the whole DPDK stack, enters Kernel vDPA
which was created to overcome some of the userspace limitations and
complexity and to leverage some of the kernel great feature such as
eBPF.

https://www.redhat.com/en/blog/introduction-vdpa-kernel-framework





