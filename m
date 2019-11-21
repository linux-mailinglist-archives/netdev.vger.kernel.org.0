Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C13104C51
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfKUHVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:21:51 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53833 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726714AbfKUHVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 02:21:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574320908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N3KEHq6mwKx4YxQmZd6AAcMOHc/yrLi7YZ6GFAs0kH0=;
        b=GPCieThV5tT6GiEX4C+wRX1Qtm3YKk/ufM2OzMWjLeITVIheB8K/564iygw5LwVApSpVqF
        4h+gpFm83VVPCbW4zhS9o59S85T5Hb2BrGgcevFdEOodlkEcf7QlMdg/SHHWNXnByVKJTb
        MWeLEImEBoz4VggJi9XyfuOxvFjBhzg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-mzg_JxtINoWQMnUBVpuSyQ-1; Thu, 21 Nov 2019 02:21:45 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A271800054;
        Thu, 21 Nov 2019 07:21:43 +0000 (UTC)
Received: from [10.72.12.204] (ovpn-12-204.pek2.redhat.com [10.72.12.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D896A5E26E;
        Thu, 21 Nov 2019 07:21:30 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Tiwei Bie <tiwei.bie@intel.com>
References: <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca> <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca> <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
Date:   Thu, 21 Nov 2019 15:21:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191121030357.GB16914@ziepe.ca>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: mzg_JxtINoWQMnUBVpuSyQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/21 =E4=B8=8A=E5=8D=8811:03, Jason Gunthorpe wrote:
> On Wed, Nov 20, 2019 at 03:07:32PM -0700, Alex Williamson wrote:
>
>>> On Wed, Nov 20, 2019 at 10:28:56AM -0700, Alex Williamson wrote:
>>>>>> Are you objecting the mdev_set_iommu_deivce() stuffs here?
>>>>> I'm questioning if it fits the vfio PCI device security model, yes.
>>>> The mdev IOMMU backing device model is for when an mdev device has
>>>> IOMMU based isolation, either via the PCI requester ID or via requeste=
r
>>>> ID + PASID.  For example, an SR-IOV VF may be used by a vendor to
>>>> provide IOMMU based translation and isolation, but the VF may not be
>>>> complete otherwise to provide a self contained device.  It might
>>>> require explicit coordination and interaction with the PF driver, ie.
>>>> mediation.
>>> In this case the PF does not look to be involved, the ICF kernel
>>> driver is only manipulating registers in the same VF that the vfio
>>> owns the IOMMU for.
>> The mdev_set_iommu_device() call is probably getting caught up in the
>> confusion of mdev as it exists today being vfio specific.  What I
>> described in my reply is vfio specific.  The vfio iommu backend is
>> currently the only code that calls mdev_get_iommu_device(), JasonW
>> doesn't use it in the virtio-mdev code, so this seems like a stray vfio
>> specific interface that's setup by IFC but never used.
> I couldn't really say, it was the only thing I noticed in IFC that
> seemed to have anything to do with identifying what IOMMU group to use
> for the vfio interface..
>  =20
>>> This is why I keep calling it a "so-called mediated device" because it
>>> is absolutely not clear what the kernel driver is mediating. Nearly
>>> all its work is providing a subsystem-style IOCTL interface under the
>>> existing vfio multiplexer unrelated to vfio requirements for DMA.
>> Names don't always evolve well to what an interface becomes, see for
>> example vfio.  However, even in the vfio sense of mediated devices we
>> have protocol translation.  The mdev vendor driver translates vfio API
>> callbacks into hardware specific interactions.  Is this really much
>> different?
> I think the name was fine if you constrain 'mediated' to mean
> 'mediated IOMMU'


But actually it does much more than just IOMMU.


>
> Broading to be basically any driver interface is starting to overlap
> with the role of the driver core and subsystems in Linux.
>
>>> However, to me it feels wrong that just because a driver wishes to use
>>> PASID or IOMMU features it should go through vfio and mediated
>>> devices.
>> I don't think I said this.  IOMMU backing of an mdev is an acceleration
>> feature as far as vfio-mdev is concerned.  There are clearly other ways
>> to use the IOMMU.
> Sorry, I didn't mean to imply you said this, I was mearly reflecting
> on the mission creep comment below. Often in private converstations
> the use of mdev has been justified by 'because it uses IOMMU'
>
>>> I feel like mdev is suffering from mission creep. I see people
>>> proposing to use mdev for many wild things, the Mellanox SF stuff in
>>> the other thread and this 'virtio subsystem' being the two that have
>>> come up publicly this month.
>> Tell me about it... ;)
>>  =20
>>> Putting some boundaries on mdev usage would really help people know
>>> when to use it. My top two from this discussion would be:
>>>
>>> - mdev devices should only bind to vfio. It is not a general kernel
>>>    driver matcher mechanism. It is not 'virtual-bus'.
>> I think this requires the driver-core knowledge to really appreciate.
>> Otherwise there's apparently a common need to create sub-devices and
>> without closer inspection of the bus:driver API contract, it's too easy
>> to try to abstract the device:driver API via the bus.  mdev already has
>> a notion that the device itself can use any API, but the interface to
>> the bus is the vendor provided, vfio compatible callbacks.
> But now that we are talking about this, I think there is a pretty
> clear opinion forming that if you want to do kernel-kernel drivers
> that is 'virtual bus' as proposed in this threads patch, not mdev.


This looks confused.

1) Virtual bus allows multiple different type of devices to be attached=20
on a single bus, isn't this where you show your concern when I do=20
similar thing for a single mdev-bus?
2) Virtual bus hide the communication through a void *, this is not=20
impossible for mdev.
3) After decoupling vfio out of mdev, there's no fundamental difference=20
between mdev and virtual bus except that mdev is coupled with sysfs=20
interface and can talk to VFIO. And that's really what we want for=20
virtio, not only for having a management interface but also for a=20
unified framework/API between vhost(userspace) and virtio(kernel) driver.
4) In the cover letter of virtual-bus it said:


"
+One use case example is an rdma driver needing to connect with several
+different types of PCI LAN devices to be able to request resources from
+them (queue sets).=C2=A0 Each LAN driver that supports rdma will register =
a
+virtbus_device on the virtual bus for each physical function. The rdma
+driver will register as a virtbus_driver on the virtual bus to be
+matched up with multiple virtbus_devices and receive a pointer to a
+struct containing the callbacks that the PCI LAN drivers support for
+registering with them.

"

It did something like device aggregation. Ok, you might think it could=20
be extended. But why mdev can't be extended?


>
> Adding that knowledge to the mdev documentation would probably help
> future people.
>
>>> - mdev & vfio are not a substitute for a proper kernel subsystem. We
>>>    shouldn't export a complex subsystem-like ioctl API through
>>>    vfio ioctl extensions. Make a proper subsystem, it is not so hard.
>> This is not as clear to me, is "ioctl" used once or twice too often or
>> are you describing a defined structure of callbacks as an ioctl API?
>> The vfio mdev interface is just an extension of the file descriptor
>> based vfio device API.  The device needs to handle actual ioctls, but
>> JasonW's virtio-mdev series had their own set of callbacks.  Maybe a
>> concrete example of this item would be helpful.  Thanks,
> I did not intend it to be a clear opinion, more of a vauge guide for
> documentation. I think as a maintainer you will be asked to make this
> call.
>
> The role of a subsystem in Linux is traditionally to take many
> different kinds of HW devices and bring them to a common programming
> API. Provide management and diagnostics, and expose some user ABI to
> access the HW.
>
> The role of vfio has traditionally been around secure device
> assignment of a HW resource to a VM. I'm not totally clear on what the
> role if mdev is seen to be, but all the mdev drivers in the tree seem
> to make 'and pass it to KVM' a big part of their description.
>
> So, looking at the virtio patches, I see some intended use is to map
> some BAR pages into the VM.


Nope, at least not for the current stage. It still depends on the=20
virtio-net-pci emulatio in qemu to work. In the future, we will allow=20
such mapping only for dorbell.


>   I see an ops struct to take different
> kinds of HW devices to a common internal kernel API. I understand a
> desire to bind kernel drivers that are not vfio to those ops, and I
> see a user ioctl ABI based around those ops.
>
> I also understand the BAR map is not registers, but just a write-only
> doorbell page. So I suppose any interaction the guest will have with
> the device prior to starting DMA is going to be software emulated in
> qemu, and relayed into ioctls. (?) ie this is no longer strictly
> "device assignment" but "accelerated device emulation".
>
> Is virtio more vfio or more subsystem? The biggest thing that points
> toward vfio is the intended use. The other items push away.
>
> Frankly, when I look at what this virtio stuff is doing I see RDMA:
>   - Both have a secure BAR pages for mmaping to userspace (or VM)
>   - Both are prevented from interacting with the device at a register
>     level and must call to the kernel - ie creating resources is a
>     kernel call - for security.
>   - Both create command request/response rings in userspace controlled
>     memory and have HW DMA to read requests and DMA to generate responses
>   - Both allow the work on the rings to DMA outside the ring to
>     addresses controlled by userspace.
>   - Both have to support a mixture of HW that uses on-device security
>     or IOMMU based security.
>
> (I actually gave a talk on how alot of modern HW is following the RDMA
>   design patterns at plumbers, maybe video will come out soon)
>
> We've had the same debate with RDMA. Like VFIO it has an extensible
> file descriptor with a driver-specific path that can serve an
> unlimited range of uses. We have had to come up with some sensability
> and definition for "what is RDMA" and is appropriate for the FD.


If you looking at my V13, after decoupling, you can register your own=20
vhost driver on the mdev_virito bus with your own API if you don't like=20
VFIO.

Thanks


>
> Jason
>

