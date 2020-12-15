Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1312DB53A
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 21:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgLOUgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 15:36:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgLOUgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 15:36:04 -0500
Message-ID: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608064522;
        bh=d+LjAFRJ0J+h/7K+ahSZzYkkl7dyUUO2CmQE+DNH3aE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R7ZxOEUhHIneZsk4OdPZ5DTqnRvZxHQQtXWxvVM2jGv8keo9Q/WM8kwl6RD7L2p8c
         Hv3uW4/wmEW/2Bji0ylM4nGKIpsnapYBSEw+t1Y8ei9xCPdh1qSMZH5mg5zaz9mpWV
         N3dJcfQEewq541cikjWxyOM7/p/+VVgpM0x/932G24TD1uRcAP1+pvJc5mHSuVYzTh
         MF4kHnxL2/Ci2PhX0F2MQ1cPmvbzviEa/JOwAUB5kVGrH2XNcyNuy3ZLyUvzyJnPGt
         OI5DBcxsddTwFU3iw2cMcW+mowrYFSn4eslsgUlBVZANATKOVq5InoUo+hwyNdOBEd
         9rvalHjlMccXA==
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date:   Tue, 15 Dec 2020 12:35:20 -0800
In-Reply-To: <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
References: <20201214214352.198172-1-saeed@kernel.org>
         <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
         <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
         <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-15 at 11:12 -0800, Alexander Duyck wrote:
> On Mon, Dec 14, 2020 at 10:15 PM Saeed Mahameed <saeed@kernel.org>
> wrote:
> > On Mon, 2020-12-14 at 17:53 -0800, Alexander Duyck wrote:
> > > On Mon, Dec 14, 2020 at 1:49 PM Saeed Mahameed <saeed@kernel.org>
> > > wrote:
> > > > Hi Dave, Jakub, Jason,
> > > > 
> > > > This series form Parav was the theme of this mlx5 release
> > > > cycle,
> > > > we've been waiting anxiously for the auxbus infrastructure to
> > > > make
> > > > it into
> > > > the kernel, and now as the auxbus is in and all the stars are
> > > > aligned, I
> > > > can finally submit this V2 of the devlink and mlx5 subfunction
> > > > support.
> > > > 
> > > > Subfunctions came to solve the scaling issue of virtualization
> > > > and switchdev environments, where SRIOV failed to deliver and
> > > > users
> > > > ran
> > > > out of VFs very quickly as SRIOV demands huge amount of
> > > > physical
> > > > resources
> > > > in both of the servers and the NIC.
> > > > 
> > > > Subfunction provide the same functionality as SRIOV but in a
> > > > very
> > > > lightweight manner, please see the thorough and detailed
> > > > documentation from Parav below, in the commit messages and the
> > > > Networking documentation patches at the end of this series.
> > > > 
> > > 
> > > Just to clarify a few things for myself. You mention
> > > virtualization
> > > and SR-IOV in your patch description but you cannot support
> > > direct
> > > assignment with this correct? The idea here is simply logical
> > > partitioning of an existing network interface, correct? So this
> > > isn't
> > > so much a solution for virtualization, but may work better for
> > > containers. I view this as an important distinction to make as
> > > the
> > 
> > at the current state yes, but the SF solution can be extended to
> > support direct assignment, so this is why i think SF solution can
> > do
> > better and eventually replace SRIOV.
> 
> My only real concern is that this and mediated devices are
> essentially
> the same thing. When you start making this work for direct-assignment
> the only real difference becomes the switchdev and devlink
> interfaces.

not just devlink and switchdev, auxbus was also introduced to
standardize some of the interfaces.

> Basically this is netdev specific mdev versus the PCIe specific mdev.
> 

SF is not netdev specific mdev .. :/

> > also many customers are currently using SRIOV with containers to
> > get
> > the performance and isolation features since there was no other
> > options.
> 
> There were, but you hadn't implemented them. The fact is the approach
> Intel had taken for that was offloaded macvlan.
> 

offloaded macvlan is just a macvlan with checksum/tso and gro.

macvlan can't provide RDMA, TC offloads, ethtool steering, PTP, vdpa
...
our SF provides the same set of features a VF can provide


> I think the big thing we really should do if we are going to go this
> route is to look at standardizing what the flavours are that get
> created by the parent netdevice. Otherwise we are just creating the
> same mess we had with SRIOV all over again and muddying the waters of
> mediated devices.
> 

yes in the near future we will be working on auxbus interfaces for
auto-probing and user flavor selection, this is a must have feature for
us.

> > > first thing that came to mind when I read this was mediated
> > > devices
> > > which is similar, but focused only on the virtualization case:
> > > https://www.kernel.org/doc/html/v5.9/driver-api/vfio-mediated-device.html
> > > 
> > > > Parav Pandit Says:
> > > > =================
> > > > 
> > > > This patchset introduces support for mlx5 subfunction (SF).
> > > > 
> > > > A subfunction is a lightweight function that has a parent PCI
> > > > function on
> > > > which it is deployed. mlx5 subfunction has its own function
> > > > capabilities
> > > > and its own resources. This means a subfunction has its own
> > > > dedicated
> > > > queues(txq, rxq, cq, eq). These queues are neither shared nor
> > > > stealed from
> > > > the parent PCI function.
> > > 
> > > Rather than calling this a subfunction, would it make more sense
> > > to
> > > call it something such as a queue set? It seems like this is
> > > exposing
> > > some of the same functionality we did in the Intel drivers such
> > > as
> > > ixgbe and i40e via the macvlan offload interface. However the
> > > ixgbe/i40e hardware was somewhat limited in that we were only
> > > able to
> > > expose Ethernet interfaces via this sort of VMQ/VMDQ feature, and
> > > even
> > > with that we have seen some limitations to the interface. It
> > > sounds
> > > like you are able to break out RDMA capable devices this way as
> > > well.
> > > So in terms of ways to go I would argue this is likely better.
> > 
> > We've discussed this thoroughly on V0, the SF solutions is closer
> > to a
> > VF than a VMDQ, this is not just a set of queues.
> > 
> > https://lore.kernel.org/linux-rdma/421951d99a33d28b91f2b2997409d0c97fa5a98a.camel@kernel.org/
> 
> VMDq is more than just a set of queues. The fact is it is a pool of
> resources that get created to handle the requests for a specific VM.
> The extra bits that are added here are essentially stuff that was
> required to support mediated devices.
> 

VMDq pools are managed by the driver and only logically isolated in the
kernel, SFs has no shared pool for transport resources (queues), SFs
have their own isolated steering domains, processing engines, and HW
objects, exactly like a VF.

> > > However
> > > one downside is that we are going to end up seeing each
> > > subfunction
> > > being different from driver to driver and vendor to vendor which
> > > I
> > > would argue was also one of the problems with SR-IOV as you end
> > > up
> > > with a bit of vendor lock-in as a result of this feature since
> > > each
> > > vendor will be providing a different interface.
> > > 
> > 
> > I disagree, SFs are tightly coupled with switchdev model and
> > devlink
> > functions port, they are backed with the a well defined model, i
> > can
> > say the same about sriov with switchdev mode, this sort of vendor
> > lock-
> > in issues is eliminated when you migrate to switchdev mode.
> 
> What you are talking about is the backend. I am talking about what is
> exposed to the user. The user is going to see a Mellanox device
> having
> to be placed into their container in order to support this. One of
> the
> advantages of the Intel approach was that the macvlan interface was
> generic so you could have an offloaded interface or not and the user
> wouldn't necessarily know. The offload could be disabled and the user
> would be none the wiser as it is moved from one interface to another.
> I see that as a big thing that is missing in this solution.
> 

You are talking about the basic netdev users, Sure there are users who
would want a more generic netdev, so yes. but most of my customers are
not like that, they want vdpa/rdma and heavy netdev offload such as
encap/decap/crypto and driver xdp in their containers, the SF approach
will make more sense to them than sriov and VMDq.

> > > > When subfunction is RDMA capable, it has its own QP1, GID table
> > > > and
> > > > rdma
> > > > resources neither shared nor stealed from the parent PCI
> > > > function.
> > > > 
> > > > A subfunction has dedicated window in PCI BAR space that is not
> > > > shared
> > > > with ther other subfunctions or parent PCI function. This
> > > > ensures
> > > > that all
> > > > class devices of the subfunction accesses only assigned PCI BAR
> > > > space.
> > > > 
> > > > A Subfunction supports eswitch representation through which it
> > > > supports tc
> > > > offloads. User must configure eswitch to send/receive packets
> > > > from/to
> > > > subfunction port.
> > > > 
> > > > Subfunctions share PCI level resources such as PCI MSI-X IRQs
> > > > with
> > > > their other subfunctions and/or with its parent PCI function.
> > > 
> > > This piece to the architecture for this has me somewhat
> > > concerned. If
> > > all your resources are shared and you are allowing devices to be
> > 
> > not all, only PCI MSIX, for now..
> 
> They aren't shared after you partition them but they are coming from
> the same device. Basically you are subdividing the BAR2 in order to
> generate the subfunctions. BAR2 is a shared resource in my point of
> view.
> 

Sure, but it doesn't host any actual resources, only the communication
channel with the HW partition, so other than the BAR and the msix the
actual HW resources, steering pipelines, offloads and queues are totlay
isolated and separated. 


> > > created incrementally you either have to pre-partition the entire
> > > function which usually results in limited resources for your base
> > > setup, or free resources from existing interfaces and
> > > redistribute
> > > them as things change. I would be curious which approach you are
> > > taking here? So for example if you hit a certain threshold will
> > > you
> > > need to reset the port and rebalance the IRQs between the various
> > > functions?
> > > 
> > 
> > Currently SFs will use whatever IRQs the PF has pre-allocated for
> > itself, so there is no IRQ limit issue at the moment, we are
> > considering a dynamic IRQ pool with dynamic balancing, or even
> > better
> > us the IMS approach, which perfectly fits the SF architecture.
> > https://patchwork.kernel.org/project/linux-pci/cover/1568338328-22458-1-git-send-email-megha.dey@linux.intel.com/
> 
> When you say you are using the PF's interrupts are you just using
> that
> as a pool of resources or having the interrupt process interrupts for
> both the PF and SFs? Without IMS you are limited to 2048 interrupts.
> Moving over to that would make sense since SF is similar to mdev in
> the way it partitions up the device and resources.
> 

Yes moving to IMS is on the top of our priorities.

> > for internal resources the are fully isolated (not shared) and
> > they are internally managed by FW exactly like a VF internal
> > resources.
> 
> I assume by isolated you mean they are contained within page aligned
> blocks like what was required for mdev?

I mean they are isolated and abstracted in the FW, we don't really
expose any resource directly to the BAR. the BAR is only used for
communicating with the device, so VF and SF will work exactly the same
the only difference is where they get their BAR  and offsets from,
everything else is just similar.

