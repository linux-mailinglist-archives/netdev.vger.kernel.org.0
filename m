Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F4E104974
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 04:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfKUDws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 22:52:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60555 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726132AbfKUDws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 22:52:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574308367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=65ygqnreLxFHb6Sgokez95OEwNyLjTrZt0mZ7AES6/U=;
        b=hCeIo8yP2CNsAnxbuoJjCPUP0sBLa3s503xghpisjghCJ9HD1cDHRLl+AnGiq5ex54irIS
        bb2Yzq4bkXFQjjCAO8ydZDOHpcDp8i3SE9VTDrOdQ26DXWj3ny5qC9BqSfGzv69zXr8ygH
        cCP773z45TxilbIdZMMeH1HG7bm5h24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-z4pLlIzbPGaCAefK2wMnfg-1; Wed, 20 Nov 2019 22:52:43 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFA341005502;
        Thu, 21 Nov 2019 03:52:41 +0000 (UTC)
Received: from [10.72.12.204] (ovpn-12-204.pek2.redhat.com [10.72.12.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8316A60BC8;
        Thu, 21 Nov 2019 03:52:31 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
References: <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d6cb6bd4-b6d7-2732-27b8-ea4d7f10e4ba@redhat.com>
Date:   Thu, 21 Nov 2019 11:52:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120133835.GC22515@ziepe.ca>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: z4pLlIzbPGaCAefK2wMnfg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/20 =E4=B8=8B=E5=8D=889:38, Jason Gunthorpe wrote:
> On Tue, Nov 19, 2019 at 10:59:20PM -0500, Jason Wang wrote:
>
>>>> The interface between vfio and userspace is
>>>> based on virtio which is IMHO much better than
>>>> a vendor specific one. userspace stays vendor agnostic.
>>> Why is that even a good thing? It is much easier to provide drivers
>>> via qemu/etc in user space then it is to make kernel upgrades. We've
>>> learned this lesson many times.
>> For upgrades, since we had a unified interface. It could be done
>> through:
>>
>> 1) switch the datapath from hardware to software (e.g vhost)
>> 2) unload and load the driver
>> 3) switch teh datapath back
>>
>> Having drivers in user space have other issues, there're a lot of
>> customers want to stick to kernel drivers.
> So you want to support upgrade of kernel modules, but runtime
> upgrading the userspace part is impossible? Seems very strange to me.


Since you're talking about kernel upgrades, so comes such technical=20
possibility.


>
>>> This is why we have had the philosophy that if it doesn't need to be
>>> in the kernel it should be in userspace.
>> Let me clarify again. For this framework, it aims to support both
>> kernel driver and userspce driver. For this series, it only contains
>> the kernel driver part. What it did is to allow kernel virtio driver
>> to control vDPA devices. Then we can provide a unified interface for
>> all of the VM, containers and bare metal. For this use case, I don't
>> see a way to leave the driver in userspace other than injecting
>> traffic back through vhost/TAP which is ugly.
> Binding to the other kernel virtio drivers is a reasonable
> justification, but none of this comes through in the patch cover
> letters or patch commit messages.


In the cover letter it had (of course I'm not native speaker but I will=20
try my best to make it more readable for next version).

"
There are hardwares that can do virtio datapath offloading while
having its own control path. This path tries to implement a mdev based
unified API to support using kernel virtio driver to drive those
devices. This is done by introducing a new mdev transport for virtio
(virtio_mdev) and register itself as a new kind of mdev driver. Then
it provides a unified way for kernel virtio driver to talk with mdev
device implementation.

Though the series only contains kernel driver support, the goal is to
make the transport generic enough to support userspace drivers. This
means vhost-mdev[1] could be built on top as well by reusing the
transport.

"


>
>>>> That has lots of security and portability implications and isn't
>>>> appropriate for everyone.
>>> This is already using vfio. It doesn't make sense to claim that using
>>> vfio properly is somehow less secure or less portable.
>>>
>>> What I find particularly ugly is that this 'IFC VF NIC' driver
>>> pretends to be a mediated vfio device, but actually bypasses all the
>>> mediated device ops for managing dma security and just directly plugs
>>> the system IOMMU for the underlying PCI device into vfio.
>> Well, VFIO have multiple types of API. The design is to stick the VFIO
>> DMA model like container work for making DMA API work for userspace
>> driver.
> Well, it doesn't, that model, for security, is predicated on vfio
> being the exclusive owner of the device. For instance if the kernel
> driver were to perform DMA as well then security would be lost.


It's the responsibility of the kernel mdev driver to preserve the DMA=20
isolation. And it's possible that mdev needs communicate with the master=20
(PF or other) using its own memory, this should be allowed.


> to
>>> I suppose this little hack is what is motivating this abuse of vfio in
>>> the first place?
>>>
>>> Frankly I think a kernel driver touching a PCI function for which vfio
>>> is now controlling the system iommu for is a violation of the security
>>> model, and I'm very surprised AlexW didn't NAK this idea.
>>>
>>> Perhaps it is because none of the patches actually describe how the
>>> DMA security model for this so-called mediated device works? :(
>>>
>>> Or perhaps it is because this submission is split up so much it is
>>> hard to see what is being proposed? (I note this IFC driver is the
>>> first user of the mdev_set_iommu_device() function)
>> Are you objecting the mdev_set_iommu_deivce() stuffs here?
> I'm questioning if it fits the vfio PCI device security model, yes.
>
>>>> It is kernel's job to abstract hardware away and present a unified
>>>> interface as far as possible.
>>> Sure, you could create a virtio accelerator driver framework in our
>>> new drivers/accel I hear was started. That could make some sense, if
>>> we had HW that actually required/benefited from kernel involvement.
>> The framework is not designed specifically for your card. It tries to be
>> generic to support every types of virtio hardware devices, it's not
>> tied to any bus (e.g PCI) and any vendor. So it's not only a question
>> of how to slice a PCIE ethernet device.
> That doesn't explain why this isn't some new driver subsystem


The vhost-mdev is a vfio-mdev device. It sticks to the VFIO programming=20
model. Any reason to reinvent the wheel?


> and
> instead treats vfio as a driver multiplexer.


I fail to understand this. VFIO had already support PCI, AP, mdev, and=20
possible other buses (e.g vmbus) in the future. VFIO is not PCI=20
specific, why requires vfio-mdev to be PCI specific?

Thanks

>
> Jason
>

