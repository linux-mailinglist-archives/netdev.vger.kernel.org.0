Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C7A106847
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 09:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfKVIqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 03:46:00 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42688 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726546AbfKVIqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 03:46:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574412358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+h5nOmS/jN5G3mWfH9floI/28lgj7AwmhoLaRC8updA=;
        b=JlFRLuzA8+pzH0TCQWqfwGh4GnqbEp/F7TCM9Db+6nBPSBs2yRwExk60V0kuPzBRSvNbjC
        aBuhT3p5bfeaagiP4haTUI1Gs5WXTzNGxeAA0HY7q+Y291c3iUAEPIGYa+4YtljjWxSgTV
        oLggpHvedp/rxHVHes4V62a+CT/RSPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-PoCk7TIDPsSFfaqZc1usXw-1; Fri, 22 Nov 2019 03:45:57 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B16B107ACC5;
        Fri, 22 Nov 2019 08:45:55 +0000 (UTC)
Received: from [10.72.13.3] (ovpn-13-3.pek2.redhat.com [10.72.13.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57F4360BD4;
        Fri, 22 Nov 2019 08:45:41 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Tiwei Bie <tiwei.bie@intel.com>
References: <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca> <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca> <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
 <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
 <20191121141732.GB7448@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <721e49c2-a2e1-853f-298b-9601c32fcf9e@redhat.com>
Date:   Fri, 22 Nov 2019 16:45:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191121141732.GB7448@ziepe.ca>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: PoCk7TIDPsSFfaqZc1usXw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/21 =E4=B8=8B=E5=8D=8810:17, Jason Gunthorpe wrote:
> On Thu, Nov 21, 2019 at 03:21:29PM +0800, Jason Wang wrote:
>>> The role of vfio has traditionally been around secure device
>>> assignment of a HW resource to a VM. I'm not totally clear on what the
>>> role if mdev is seen to be, but all the mdev drivers in the tree seem
>>> to make 'and pass it to KVM' a big part of their description.
>>>
>>> So, looking at the virtio patches, I see some intended use is to map
>>> some BAR pages into the VM.
>> Nope, at least not for the current stage. It still depends on the
>> virtio-net-pci emulatio in qemu to work. In the future, we will allow su=
ch
>> mapping only for dorbell.
> There has been a lot of emails today, but I think this is the main
> point I want to respond to.
>
> Using vfio when you don't even assign any part of the device BAR to
> the VM is, frankly, a gigantic misuse, IMHO.


That's not a compelling point. If you go through the discussion on=20
vhost-mdev from last year, the direct mapping of doorbell is accounted=20
since that time[1]. It works since its stateless. Having an arbitrary=20
BAR to be mapped directly to VM may cause lots of troubles for migration=20
since it requires a vendor specific way to get the state of the device.=20
I don't think having a vendor specific migration driver is acceptable in=20
qemu. What's more, direct mapping through MMIO is even optional (see=20
CONFIG_VFIO_PCI_MMAP) and vfio support buses without any MMIO region.


>
> Just needing userspace DMA is not, in any way, a justification to use
> vfio.
>
> We have extensive library interfaces in the kernel to do userspace DMA
> and subsystems like GPU and RDMA are full of example uses of this kind
> of stuff.


I'm not sure which library did you mean here. Is any of those library=20
used by qemu? If not, what's the reason?

For virtio, we need a device agnostic API which supports migration. Is=20
that something the library you mention here can provide?


>   Everything from on-device IOMMU to system IOMMU to PASID. If
> you find things missing then we need to improve those library
> interfaces, not further abuse VFIO.
>
> Further, I do not think it is wise to design the userspace ABI around
> a simplistict implementation that can't do BAR assignment,


Again, the vhost-mdev follow the VFIO ABI, no new ABI is invented, and=20
mmap() was kept their for mapping device regions.


> and can't
> support multiple virtio rings on single PCI function.


How do you know multiple virtio rings can't be supported? It should be=20
address at the level of parent devices not virtio-mdev framework, no?


> This stuff is
> clearly too premature.


It depends on how mature you want. All the above two points looks=20
invalid to me.


>
> My advice is to proceed as a proper subsystem with your own chardev,
> own bus type, etc and maybe live in staging for a bit until 2-3
> drivers are implementing the ABI (or at the very least agreeing with),
> as is the typical process for Linux.


I'm open to comments for sure, but looking at all the requirement for=20
vDPA, most of the requirement could be settled through existed modules,=20
that's not only a simplification for developing but also for management=20
layer or userspace drivers.


>
> Building a new kernel ABI is hard (this is why I advised to use a
> userspace driver).


Well, it looks to me my clarification is ignored several times. There's=20
no new ABI invented in the series, no?


> It has to go through the community process at the
> usual pace.


What do you mean by "usual pace"? It has been more than 1.5 year since=20
the first version of vhost-mdev [1] that was posted on the list.

[1] https://lwn.net/Articles/750770/

Thanks

>
> Jason
>

