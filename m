Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E9B2DE9EC
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 20:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733289AbgLRTsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 14:48:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733261AbgLRTsz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 14:48:55 -0500
Date:   Fri, 18 Dec 2020 11:48:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608320894;
        bh=Qh4llrMn/hHqVQmIdxUlhe+2N4zekdVkoAsd89dOM0s=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LposW1O1LVNeCBAcVnKEPJHfQ1VWNPHV637iCLI218ju7AZPhWS6ZsfWQa4gvJIoR
         eUUHtT8BOhveCJa0nIGR5HLDXN8tAO2k1NJ1QPcKKVxGXZlwp0iSMwQL8fMY/ijmPC
         HelwgMSXicXYgNu3JgKbMBlqNwz+3THEj7Oe6nC52i6Gq9/GbZT7X1gM5UPN3DGrir
         k/1g2MqPii37of7vGGt5n6j5tlFghGc3S8e/9ROhJYof+P+87kzyEKVp7evCMwsW/V
         /Oy1eQ1XyxA+/RkIzlEU3C6keLu7qT+PQWhk6Nf5EPRwZR78yOI8SmXEkx7h7Rbkgk
         9S8DnEpW4eKUw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Parav Pandit <parav@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>
Subject: Re: [net-next v5 03/15] devlink: Introduce PCI SF port flavour and
 port attribute
Message-ID: <20201218114812.28db7084@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ecc117632ffa36ae374fb05ed4806af2d7d55576.camel@kernel.org>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-4-saeed@kernel.org>
        <20201215152740.0b3ed376@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432268C16D118BC435C0EF5CDCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201216155945.63f07c80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ecc117632ffa36ae374fb05ed4806af2d7d55576.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 20:44:21 -0800 Saeed Mahameed wrote:
> On Wed, 2020-12-16 at 15:59 -0800, Jakub Kicinski wrote:
> > On Wed, 16 Dec 2020 03:42:51 +0000 Parav Pandit wrote:  
> > > > From: Jakub Kicinski <kuba@kernel.org>
> > > > So subfunctions don't have a VF id but they may have a
> > > > controller?
> > > >    
> > > Right. SF can be on external controller.
> > >    
> > > > Can you tell us more about the use cases and deployment models
> > > > you're
> > > > intending to support? Let's not add attributes and info which
> > > > will go unused.
> > > >     
> > > External will be used the same way how it is used for PF and VF.
> > >   
> > > > How are SFs supposed to be used with SmartNICs? Are you assuming
> > > > single
> > > > domain of control?    
> > > No. it is not assumed. SF can be deployed from smartnic to external
> > > host.
> > > A user has to pass appropriate controller number, pf number
> > > attributes during creation time.  
> > 
> > My problem with this series is that I've gotten some real life
> > application exposure over the last year, and still I have no idea 
> > who is going to find this feature useful and why.
> > 
> > That's the point of my questions in the previous email - what
> > are the use cases, how are they going to operate.
> >   
> 
> The main focus of this feature is scale-ability we want to run
> thousands of Containers/VMs, this is useful for both smartnic and
> baremetal hypervisor worlds, where security and control is exclusive to
> the eswitch manager may it be the smarnic embedded CPU or the x86
> Hypervisor.
> 
> deployment models is identical to SRIOV, the only difference is the
> instantiation model of SF, which is the main discussion point of this
> series (i hope), which to my taste is very modest and minimal.
> after SF is instantiated from that point nothing is new, the SF is
> exposing standard linux interfaces netdev/rdma identical to what VF
> does, most likely you will assign them a namespace and pass them
> through to a container or assign them (not direct assignment) to a VM
> via the virt stack, or create a vdpa instance and pass it to a virtio
> interface.
> 
> There are endless usecases for the netdev stack, for customers who want

"endless" :)

> high scale virtualized/containerized environments, with thousands of
> network functions that can deliver high speed and full offload
> accelerators, Native XDP, Crypto, encap/decap, and HW filtering and
> processing pipeline capabilities.
> 
> I have a long list of customers with various and different applications
> and i am not even talking about the rdma and vdpa customers ! those
> customers just can't wait to leave sriov behind and scale up !
> 
> this feature has a lot of value to the netdev users only because of the
> minimal foot print to the netdev stack (to be honest there is no change
> in netdev, only a thin API layer in devlink) and the immediate and
> effortless benefits to deploy multiple (accelerated) netdevs at scale.

The acceleration can hopefully be plumbed through the software devices.

I think your HW is capable of doing large queue sets so I'm curious
how this actually performs. We're probably talking 1000+ queues here -
the CPU will have hard time serving so many queues. In my experiments
basically the more queues the more cache trashing, the more interrupts,
etc. and the lower the performance.

> > It's hard to review an API without knowing the use of it. iproute2
> > is low level plumbing.
> 
> I don't know how to put this, let me try:
> A) SRIOV model
> echo 128 > /sys/class/net/eth0/device/sriov_numvfs
> ubind vf
> 
> ip set vf attribute x
> configure representor .. 
> deploy vf/netdev/rdma interface into the container

No, no, my point is that for SR-IOV it's OpenStack, libvirt etc. which
do this. I understand the manual steps. Often problems pop up when real
systems try to string the HW objects together, allocated them, learn
their capabilities, etc.

> B) SF model 
> you do (every thing under the devlink umbrella/switchdev):
> for i in {1..1024} ; do
> devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum $i
> devlink port sf $i set attribute x
> 
> # from here on, it is identical to a VF
> configure representor
> deply sf/netdev/rdma interfaces into a container 
> 
> B is more scale-able and has more visibility and controllability  to
> the user, after you create the SFs deployment and usecases are
> identical to SRIOV VF usecases.
> 
> See the improvement ? :)
> 
> > Here the patch is adding the ability to apparently create a SF on 
> > a remote controller. If you haven't thought that use case through
> > just don't allow it until you know how it will work.
> 
> We have thought the use case through it is not any different from the 
> local controller use case. the code is uniform, we need to work hard to
> block a remote controller :) .. 

So the SF is always created from the eswitch controller side?
How does the host side look?

I really think that for ease of merging this we should leave 
the remote controller out at the beginning - only allow local
creation.

> > > > It seems that the way the industry is moving the major
> > > > use case for SmartNICs is bare metal.
> > > > 
> > > > I always assumed nested eswitches when thinking about SmartNICs,
> > > > what
> > > > are you intending to do?
> > > >    
> > > Mlx5 doesn't support nested eswitch. SF can be deployed on the
> > > external controller PCI function.
> > > But this interface neither limited nor enforcing nested or flat
> > > eswitch.
> > >    
> > > > What are your plans for enabling this feature in user space
> > > > project?    
> > > Do you mean K8s plugin or iproute2? Can you please tell us what
> > > user space project?  
> > 
> > That's my question. For SR-IOV it'd be all the virt stacks out there.
> > But this can't do virt. So what can it do?
> 
> you are thinking VF direct assignment. but don't forget
> virt handles netdev assignment to a vm perfectly fine and SF has a
> netdev.
> 
> And don't get me started on the weird virt handling of SRIOV VF, the
> whole thing is a big mess :) it shouldn't be a de facto standard that
> we need to follow.. 
