Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12352DB4DC
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 21:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgLOUGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 15:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729634AbgLOUGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 15:06:38 -0500
Message-ID: <21904b4d4cc8eb572ea9a5c0452ecd78a40b2e67.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608062756;
        bh=YFkk1gQcRh+VP+3uuN7s7qJy4d88SR1k0vSBcqLiR9M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JCLO9tHKEmKH7ClwP6sNXR1CEsScIfnW/ffOsFHld/zRYS2LP1HZ5VP8Cf72oDHIa
         Q9+ssKGjVwG/F9udK9HhA8ND1P7zuNGJ25eTvUP7eYeIrvYoZX2K3XxOCCW2lVc9xW
         T17qk4CRk+AihwuYdJV+PbbHXTyrRt303ycx5txKLbZbZRspYbFbYCdXk5YAf/ZmFQ
         IZEp2vlS36MYzomqjIusKprpCLgtfsqRTsi25gsFXoLCRWVDcctqad4rakzCazxiFP
         9eD4NSyTwQMLrxTk0ljsWVlM91FOhCGq1f0nQkwcX9KVLJ7p+2q+r/7d4PAKGaE+w6
         ztmI56mXHUFAA==
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Parav Pandit <parav@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date:   Tue, 15 Dec 2020 12:05:55 -0800
In-Reply-To: <CAKgT0Uf9C5gwVZ1DnkrGYHMUvxe-bqwwcbTo7A0q-trrULJSUg@mail.gmail.com>
References: <20201214214352.198172-1-saeed@kernel.org>
         <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
         <BY5PR12MB43221CE397D6310F2B04D9B4DCC60@BY5PR12MB4322.namprd12.prod.outlook.com>
         <CAKgT0Uf9C5gwVZ1DnkrGYHMUvxe-bqwwcbTo7A0q-trrULJSUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-15 at 10:47 -0800, Alexander Duyck wrote:
> On Mon, Dec 14, 2020 at 9:48 PM Parav Pandit <parav@nvidia.com>
> wrote:
> > 
> > > From: Alexander Duyck <alexander.duyck@gmail.com>
> > > Sent: Tuesday, December 15, 2020 7:24 AM
> > > 
> > > On Mon, Dec 14, 2020 at 1:49 PM Saeed Mahameed <saeed@kernel.org>
> > > wrote:
> > > > Hi Dave, Jakub, Jason,
> > > > 
> > > 
> > > Just to clarify a few things for myself. You mention
> > > virtualization and SR-IOV
> > > in your patch description but you cannot support direct
> > > assignment with this
> > > correct?
> > Correct. it cannot be directly assigned.
> > 
> > > The idea here is simply logical partitioning of an existing
> > > network
> > > interface, correct?
> > No. Idea is to spawn multiple functions from a single PCI device.
> > These functions are not born in PCI device and in OS until they are
> > created by user.
> 
> That is the definition of logical partitioning. You are essentially
> taking one physical PCIe function and splitting up the resources over
> multiple logical devices. With something like an MFD driver you would
> partition the device as soon as the driver loads, but with this you
> are peeling our resources and defining the devices on demand.
> 

Sure, same for SRIOV and same for VMDQ. they are all logical
partitioning and they are all sharing the same resources of the system.
our point here is that the SF mechanisms are more similar to SRIOV than
VMDQ, other than sharing the MSIX vectors and slicing up the BARs,
everything else works exactly like SRIOV.

> > Jason and Saeed explained this in great detail few weeks back in v0
> > version of the patchset at [1], [2] and [3].
> > I better not repeat all of it here again. Please go through it.
> > If you may want to read precursor to it, RFC from Jiri at [4] is
> > also explains this in great detail.
> 
> I think I have a pretty good idea of how the feature works. My
> concern
> is more the use of marketing speak versus actual functionality. The
> way this is being setup it sounds like it is useful for
> virtualization
> and it is not, at least in its current state. It may be at some point
> in the future but I worry that it is really going to muddy the waters
> as we end up with yet another way to partition devices.
> 

Ok, maybe we have different views on the feature and use cases, this is
useful for visualization for various reasons, take vdpa for an
instance, but anyway, we can improve documentation to address your
concerns and at some point in the future when we add the direct
assignment we can add the necessary documentation.


> > > So this isn't so much a solution for virtualization, but may
> > > work better for containers. I view this as an important
> > > distinction to make as
> > > the first thing that came to mind when I read this was mediated
> > > devices
> > > which is similar, but focused only on the virtualization case:
> > > https://www.kernel.org/doc/html/v5.9/driver-api/vfio-mediated-
> > > device.html
> > > 
> > Managing subfunction using medicated device is already ruled out
> > last year at [5] as it is the abuse of the mdev bus for this
> > purpose + has severe limitations of managing the subfunction
> > device.
> 
> I agree with you on that. My thought was more the fact that the two
> can be easily confused. If we are going to do this we need to define
> that for networking devices perhaps that using the mdev interface
> would be deprecated and we would need to go through devlink. However
> before we do that we need to make sure we have this completely
> standardized.
> 

Then lets keep this discussion for later, when we add the direct
assignment support :)

> > We are not going back to it anymore.
> > It will be duplicating lot of the plumbing which exists in devlink,
> > netlink, auxiliary bus and more.
> 
> That is kind of my point. It is already in the kernel. What you are
> adding is the stuff that is duplicating it. I'm assuming that in
> order
> to be able to virtualize your interfaces in the future you are going
> to have to make use of the same vfio plumbing that the mediated
> devices do.
> 
> > > Rather than calling this a subfunction, would it make more sense
> > > to call it
> > > something such as a queue set?
> > No, queue is just one way to send and receive data/packets.
> > Jason and Saeed explained and discussed  this piece to you and
> > others during v0 few weeks back at [1], [2], [3].
> > Please take a look.
> 
> Yeah, I recall that. However I feel like it is being oversold. It
> isn't "SR-IOV done right" it seems more like "VMDq done better". The

Ok then will improve documentation to not oversell this as "SRIOV done
right".

> fact that interrupts are shared between the subfunctions is telling.
> That is exactly how things work for Intel parts when they do VMDq as
> well. The queues are split up into pools and a block of queues
> belongs
> to a specific queue. From what I can can tell the only difference is
> that there is isolation of the pool into specific pages in the BAR.
> Which is essentially a requirement for mediated devices so that they
> can be direct assigned.
> 

I disagree, this is very dissimilar to VDMQ.
SF is a VF without a unique PCI function and bar, the BAR is split up
to give the "SF" access to its own partition in the HW, and then it
will access the HW exactly like a VF would do, there are no "pools"
involved here or any PF resource/queue management, from our HW
architecture perspective there is no difference between SF and VF..
really.

> > > So in terms of ways to go I would argue this is likely better.
> > > However one
> > > downside is that we are going to end up seeing each subfunction
> > > being
> > > different from driver to driver and vendor to vendor which I
> > > would argue
> > > was also one of the problems with SR-IOV as you end up with a bit
> > > of vendor
> > > lock-in as a result of this feature since each vendor will be
> > > providing a
> > > different interface.
> > > 
> > Each and several vendors provided unified interface for managing
> > VFs. i.e.
> > (a) enable/disable was via vendor neutral sysfs
> > (b) sriov capability exposed via standard pci capability and sysfs
> > (c) sriov vf config (mac, vlan, rss, tx rate, spoof check trust)
> > are using vendor agnostic netlink
> > Even though the driver's internal implementation largely differs on
> > how trust, spoof, mac, vlan rate etc are enforced.
> > 
> > So subfunction feature/attribute/functionality will be implemented
> > differently internally in the driver matching vendor's device, for
> > reasonably abstract concept of 'subfunction'.
> 
> I think you are missing the point. The biggest issue with SR-IOV
> adoption was the fact that the drivers all created different VF
> interfaces and those interfaces didn't support migration. That was
> the
> two biggest drawbacks for SR-IOV. I don't really see this approach
> resolving either of those and so that is one of the reasons why I say
> this is closer to "VMDq done better"  rather than "SR-IOV done
> right".
> Assuming at some point one of the flavours is a virtio-net style
> interface you could eventually get to the point of something similar
> to what seems to have been the goal of mdev which was meant to
> address
> these two points.
> 

Improving documentation will address these concerns ? 
but to be clear it is much easier to solve sriov live migration when
SFs are involved.

> > > > A Subfunction supports eswitch representation through which it
> > > > supports tc offloads. User must configure eswitch to
> > > > send/receive
> > > > packets from/to subfunction port.
> > > > 
> > > > Subfunctions share PCI level resources such as PCI MSI-X IRQs
> > > > with
> > > > their other subfunctions and/or with its parent PCI function.
> > > 
> > > This piece to the architecture for this has me somewhat
> > > concerned. If all your
> > > resources are shared and
> > All resources are not shared.
> 
> Just to clarify, when I say "shared" I mean that they are all coming
> from the same function. So if for example I were to direct-assign the
> PF then all the resources for the subfunctions would go with it.
> 
> > > you are allowing devices to be created
> > > incrementally you either have to pre-partition the entire
> > > function which
> > > usually results in limited resources for your base setup, or free
> > > resources
> > > from existing interfaces and redistribute them as things change.
> > > I would be
> > > curious which approach you are taking here? So for example if you
> > > hit a
> > > certain threshold will you need to reset the port and rebalance
> > > the IRQs
> > > between the various functions?
> > No. Its works bit differently for mlx5 device.
> > When base function is started, it started as if it doesn't have any
> > subfunctions.
> > When subfunction is instantiated, it spawns new resources in device
> > (hw, fw, memory) depending on how much a function wants.
> > 
> > For example, PCI PF uses BAR 0, while subfunctions uses BAR 2.
> 
> In the grand scheme BAR doesn't really matter much. The assumption
> here is that resources are page aligned so that you can map the pages
> into a guest eventually.
> 
> > For IRQs, subfunction instance shares the IRQ with its
> > parent/hosting PCI PF.
> > In future, yes, a dedicated IRQs per SF is likely desired.
> > Sridhar also talked about limiting number of queues to a
> > subfunction.
> > I believe there will be resources/attributes of the function to be
> > controlled.
> > devlink already provides rich interface to achieve that using
> > devlink resources [8].
> > 
> > [..]
> 
> So it sounds like the device firmware is pre-partitioining the
> resources and splitting them up between the PCI PF and your
> subfunctions. Although in your case it sounds like there are
> significantly more resources than you might find in an ixgbe
> interface
> for instance. :)
> 
> The point is that we should probably define some sort of standard
> and/or expectations on what should happen when you spawn a new
> interface. Would it be acceptable for the PF and existing
> subfunctions
> to have to reset if you need to rebalance the IRQ distribution, or
> should they not be disrupted when you spawn a new interface?
> 
> One of the things I prefer about the mediated device setup is the
> fact
> that it has essentially pre-partitioned things beforehand and you
> know
> how many of each type of interface you can spawn. Is there any
> information like that provided by this interface?
> 
> > > > $ ip link show
> > > > 127: ens2f0np0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state
> > > DOWN mode DEFAULT group default qlen 1000
> > > >     link/ether 24:8a:07:b3:d1:12 brd ff:ff:ff:ff:ff:ff
> > > >     altname enp6s0f0np0
> > > > 129: p0sf88: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state
> > > > DOWN
> > > mode DEFAULT group default qlen 1000
> > > >     link/ether 00:00:00:00:88:88 brd ff:ff:ff:ff:ff:ff>
> > > 
> > > I assume that p0sf88 is supposed to be the newly created
> > > subfunction.
> > > However I thought the naming was supposed to be the same as what
> > > you are
> > > referring to in the devlink, or did I miss something?
> > > 
> > I believe you are confused with the representor netdevice of
> > subfuction with devices of subfunction. (netdev, rdma, vdpa etc).
> > I suggest that please refer to the diagram in patch_15 in [7] to
> > see the stack, modules, objects.
> > Hope below description clarifies a bit.
> > There are two netdevices.
> > (a) representor netdevice, attached to the devlink port of the
> > eswitch
> > (b) netdevice of the SF used by the end application (in your
> > example, this is assigned to container).
> 
> Sorry, that wasn't clear from your example. So in this case you
> started in a namespace and the new device you created via devlink was
> spawned in the root namespace?
> 
> > Both netdevice follow obviously a different naming scheme.
> > Representor netdevice follows naming scheme well defined in kernel
> > + systemd/udev v245 and higher.
> > It is based on phys_port_name sysfs attribute.
> > This is same for existing PF and SF representors exist for year+
> > now. Further used by subfunction.
> > 
> > For subfunction netdevice (p0s88), system/udev will be extended. I
> > put example based on my few lines of udev rule that reads
> > phys_port_name and user supplied sfnum, so that user exactly knows
> > which interface to assign to container.
> 
> Admittedly I have been out of the loop for the last couple years
> since
> I had switched over to memory management work for a while. It would
> be
> useful to include something that shows your created network interface
> in the example in addition to your switchdev port.
> 
> > > > After use inactivate the function:
> > > > $ devlink port function set ens2f0npf0sf88 state inactive
> > > > 
> > > > Now delete the subfunction port:
> > > > $ devlink port del ens2f0npf0sf88
> > > 
> > > This seems wrong to me as it breaks the symmetry with the port
> > > add
> > > command and
> > Example of the representor device is only to make life easier for
> > the user.
> > Devlink port del command works based on the devlink port index,
> > just like existing devlink port commands (get,set,split,unsplit).
> > I explained this in a thread with Sridhar at [6].
> > In short devlink port del <bus/device_name/port_index command is
> > just fine.
> > Port index is unique handle for the devlink instance that user
> > refers to delete, get, set port and port function attributes post
> > its creation.
> > I choose the representor netdev example because it is more
> > intuitive to related to, but port index is equally fine and
> > supported.
> 
> Okay then, that addresses my concern. I just wanted to make sure we
> weren't in some situation where you had to have the interface in
> order
> to remove it.
> 
> > > assumes you have ownership of the interface in the host. I
> > > would much prefer to to see the same arguments that were passed
> > > to the
> > > add command being used to do the teardown as that would allow for
> > > the
> > > parent function to create the object, assign it to a container
> > > namespace, and
> > > not need to pull it back in order to destroy it.
> > Parent function will not have same netdevice name as that of
> > representor netdevice, because both devices exist in single system
> > for large part of the use cases.
> > So port delete command works on the port index.
> > Host doesn't need to pull it back to destroy it. It is destroyed
> > via port del command.
> > 
> > [1] 
> > https://lore.kernel.org/netdev/20201112192424.2742-1-parav@nvidia.com/
> > [2] 
> > https://lore.kernel.org/netdev/421951d99a33d28b91f2b2997409d0c97fa5a98a.camel@kernel.org/
> > [3] 
> > https://lore.kernel.org/netdev/20201120161659.GE917484@nvidia.com/
> > [4] 
> > https://lore.kernel.org/netdev/20200501091449.GA25211@nanopsycho.orion/
> > [5] 
> > https://lore.kernel.org/netdev/20191107160448.20962-1-parav@mellanox.com/
> > [6] 
> > https://lore.kernel.org/netdev/BY5PR12MB43227784BB34D929CA64E315DCCA0@BY5PR12MB4322.namprd12.prod.outlook.com/
> > [7] 
> > https://lore.kernel.org/netdev/20201214214352.198172-16-saeed@kernel.org/T/#u
> > [8] https://man7.org/linux/man-pages/man8/devlink-resource.8.html
> > 

