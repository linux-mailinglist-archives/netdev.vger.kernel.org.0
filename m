Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87167104AE7
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKUHAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:00:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39008 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725842AbfKUHAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 02:00:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574319610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrA6ZZ9fc0nOiyybZ3qw9GSB/SFjjjnD7WifT7HPzyA=;
        b=chJSycfNxuwoqIJ1Fa+mUiHQM6ysWFO/5LgCSCNyH+Se0mjJmQaE44yiG7BcbtABkfwHir
        /Ztx64yAu8gfKT2QatsRHzfE68r55vOg9kFQ0ez1QYJxiUYRmiwFPyr8+I4cS2m4TcdBSb
        FLi/huX7R83kD4LfGRZ7jy0Tws+Xi5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-af1PrbSGOuee2H3YR5VRLg-1; Thu, 21 Nov 2019 02:00:07 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BC80801E58;
        Thu, 21 Nov 2019 07:00:05 +0000 (UTC)
Received: from [10.72.12.204] (ovpn-12-204.pek2.redhat.com [10.72.12.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D40360BC2;
        Thu, 21 Nov 2019 06:59:53 +0000 (UTC)
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
References: <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca> <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3f20ca5d-29d5-1075-510e-d5193bb6cc14@redhat.com>
Date:   Thu, 21 Nov 2019 14:59:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120181108.GJ22515@ziepe.ca>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: af1PrbSGOuee2H3YR5VRLg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/21 =E4=B8=8A=E5=8D=882:11, Jason Gunthorpe wrote:
> On Wed, Nov 20, 2019 at 10:28:56AM -0700, Alex Williamson wrote:
>>>> Are you objecting the mdev_set_iommu_deivce() stuffs here?
>>> I'm questioning if it fits the vfio PCI device security model, yes.
>> The mdev IOMMU backing device model is for when an mdev device has
>> IOMMU based isolation, either via the PCI requester ID or via requester
>> ID + PASID.  For example, an SR-IOV VF may be used by a vendor to
>> provide IOMMU based translation and isolation, but the VF may not be
>> complete otherwise to provide a self contained device.  It might
>> require explicit coordination and interaction with the PF driver, ie.
>> mediation.
> In this case the PF does not look to be involved, the ICF kernel
> driver is only manipulating registers in the same VF that the vfio
> owns the IOMMU for.
>
> This is why I keep calling it a "so-called mediated device" because it
> is absolutely not clear what the kernel driver is mediating.


It tries to do mediation between virtio commands and real device. It=20
works similar to mdev PCI device that do mediation between PCI commands=20
and real device. This is exact what mediator pattern[1] did, no?

[1] https://en.wikipedia.org/wiki/Mediator_pattern


> Nearly
> all its work is providing a subsystem-style IOCTL interface under the
> existing vfio multiplexer unrelated to vfio requirements for DMA.


What do you mean by "unrelated to vfio", the ioctl() interface belongs=20
its device ops is pretty device specific. And for IFC VF driver, it=20
doesn't see ioctl, it can only see virtio commands.


>
>> The IOMMU backing device is certainly not meant to share an IOMMU
>> address space with host drivers, except as necessary for the
>> mediation of the device.  The vfio model manages the IOMMU domain of
>> the backing device exclusively, any attempt to dual-host the device
>> respective to the IOMMU should fault in the dma/iommu-ops.  Thanks,
> Sounds more reasonable if the kernel dma_ops are prevented while vfio
> is using the device.
>
> However, to me it feels wrong that just because a driver wishes to use
> PASID or IOMMU features it should go through vfio and mediated
> devices.
>
> It is not even necessary as we have several examples already of
> drivers using these features without vfio.


Confused, are you suggesting a new module to support fine grain DMA=20
isolation to userspace driver? How different would it looks compared=20
with exist VFIO then?


>
> I feel like mdev is suffering from mission creep. I see people
> proposing to use mdev for many wild things, the Mellanox SF stuff in
> the other thread and this 'virtio subsystem' being the two that have
> come up publicly this month.
>
> Putting some boundaries on mdev usage would really help people know
> when to use it.


And forbid people to extend it? Do you agree that there are lots of=20
common requirements between:

- mediation between virtio and real device
- mediation between PCI and real device

?


> My top two from this discussion would be:
>
> - mdev devices should only bind to vfio. It is not a general kernel
>    driver matcher mechanism. It is not 'virtual-bus'.


It's still unclear to me why mdev must bind to vfio. Though they are=20
coupled but the pretty loosely. I would argue that any device that is=20
doing mediation between drivers and device could be done through mdev.=20
Bind mdev to vfio means you need invent other things to support kernel=20
driver and your parent need to be prepared for those two different APIs.=20
Mdev devices it self won't be a bus, but it could provide helpers to=20
build a mediated bus.


>
> - mdev & vfio are not a substitute for a proper kernel subsystem. We
>    shouldn't export a complex subsystem-like ioctl API through
>    vfio ioctl extensions.


I would say though e.g the regions based VFIO device API looks generic,=20
it carries device/bus specific information there. It would be rather=20
simple to switch back to region API and build vhost protocol on top. But=20
does it really have a lot of differences?


>   Make a proper subsystem, it is not so hard.


Vhost is the subsystem bu then how to abstract the DMA there? It would=20
be more than 99% similar to VFIO then.

Thanks


>
> Maybe others agree?
>
> Thanks,
> Jason
>

