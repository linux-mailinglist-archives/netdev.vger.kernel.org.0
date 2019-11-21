Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6A9F1049B7
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 05:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKUExk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 23:53:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49677 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725819AbfKUExj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 23:53:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574312017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YWaGuKhIhUUGp4UntNvWpirK4fqEFD/lyV9V21q6Pnc=;
        b=HiBmePjmk/JF9ZSEVCXlzXbNcFQq/4kgEO5YJrG0+xfrnZW/u7NyC0R+ZrximyHWbbUybH
        yukuQtQXoCsLIbZCauo7+1odYsWZVDUd128LZPQPp165zorW9W0w7Hj8MQ61YXavVFTgG4
        0CKRZ7NpKcsMOOud/cPwvww1RC1Dx9I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-mGZ8E1fBMgeu24kaYhZvLA-1; Wed, 20 Nov 2019 23:53:36 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5550C1804977;
        Thu, 21 Nov 2019 04:53:34 +0000 (UTC)
Received: from [10.72.12.204] (ovpn-12-204.pek2.redhat.com [10.72.12.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7963C5D717;
        Thu, 21 Nov 2019 04:53:23 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
References: <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <20191120022141-mutt-send-email-mst@kernel.org>
 <20191120130319.GA22515@ziepe.ca>
 <20191120083908-mutt-send-email-mst@kernel.org>
 <20191120143054.GF22515@ziepe.ca>
 <20191120093607-mutt-send-email-mst@kernel.org>
 <20191120164525.GH22515@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c947af55-328e-b79b-5c65-3f5bcf042ba6@redhat.com>
Date:   Thu, 21 Nov 2019 12:53:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120164525.GH22515@ziepe.ca>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: mGZ8E1fBMgeu24kaYhZvLA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/21 =E4=B8=8A=E5=8D=8812:45, Jason Gunthorpe wrote:
> On Wed, Nov 20, 2019 at 09:57:17AM -0500, Michael S. Tsirkin wrote:
>> On Wed, Nov 20, 2019 at 10:30:54AM -0400, Jason Gunthorpe wrote:
>>> On Wed, Nov 20, 2019 at 08:43:20AM -0500, Michael S. Tsirkin wrote:
>>>> On Wed, Nov 20, 2019 at 09:03:19AM -0400, Jason Gunthorpe wrote:
>>>>> On Wed, Nov 20, 2019 at 02:38:08AM -0500, Michael S. Tsirkin wrote:
>>>>>>>> I don't think that extends as far as actively encouraging userspac=
e
>>>>>>>> drivers poking at hardware in a vendor specific way.
>>>>>>> Yes, it does, if you can implement your user space requirements usi=
ng
>>>>>>> vfio then why do you need a kernel driver?
>>>>>> People's requirements differ. You are happy with just pass through a=
 VF
>>>>>> you can already use it. Case closed. There are enough people who hav=
e
>>>>>> a fixed userspace that people have built virtio accelerators,
>>>>>> now there's value in supporting that, and a vendor specific
>>>>>> userspace blob is not supporting that requirement.
>>>>> I have no idea what you are trying to explain here. I'm not advocatin=
g
>>>>> for vfio pass through.
>>>> You seem to come from an RDMA background, used to userspace linking to
>>>> vendor libraries to do basic things like push bits out on the network,
>>>> because users live on the performance edge and rebuild their
>>>> userspace often anyway.
>>>>
>>>> Lots of people are not like that, they would rather have the
>>>> vendor-specific driver live in the kernel, with userspace being
>>>> portable, thank you very much.
>>> You are actually proposing a very RDMA like approach with a split
>>> kernel/user driver design. Maybe the virtio user driver will turn out
>>> to be 'portable'.
>>>
>>> Based on the last 20 years of experience, the kernel component has
>>> proven to be the larger burden and drag than the userspace part. I
>>> think the high interest in DPDK, SPDK and others show this is a common
>>> principle.
>> And I guess the interest in BPF shows the opposite?
> There is room for both, I wouldn't discount either approach entirely
> out of hand.
>
>>> At the very least for new approaches like this it makes alot of sense
>>> to have a user space driver until enough HW is available that a
>>> proper, well thought out kernel side can be built.
>> But hardware is available, driver has been posted by Intel.
>> Have you looked at that?
> I'm not sure pointing at that driver is so helpful, it is very small
> and mostly just reflects virtio ops into some undocumented register
> pokes.


What do you expect to see then? The IFC driver is sufficient for=20
demonstrating the design and implementation of the framework that is a=20
vDPA driver. If you care about a better management API for mdev, we can=20
discuss but it should be another topic which should not block this series.


>
> There is no explanation at all for the large scale architecture
> choices:


Most of the parts have been explained more or less in the cover letter.


>   - Why vfio


In cover letter it explains that userspace driver + vhost mdev is the=20
goal. And VFIO is the most popular interface for developing userspace=20
drivers. Having vendor specific userspace driver framework is possible=20
but would be a pain for management and qemu.


>   - Why mdev without providing a device IOMMU


This is a question for mdev not directly related to the series . Either=20
bus IOMMU or device IOMMU (as vGPU already did) is supported.


>   - Why use GUID lifecycle management for singlton function PF/VF
>     drivers


It was just because it's the only existed interface right now, and=20
management has been taught to use this interface.


>   - Why not use devlink


Technically it's possible. But for explanation, it's just because I=20
don't get any question before start the draft the new version. I can add=20
this in the cover letter of next version.


>   - Why not use vfio-pci with a userspace driver


In cover letter, it explains that the series is for kernel virtio driver.


>
> These are legitimate questions and answers like "because we like it
> this way"


Where are stuffs like this?


>   or "this is how the drivers are written today" isn't very
> satisfying at all.


If you are talking about devlink + mdev. I would say for now, you're=20
welcome to develop devlink based lifecycle for mdev.=C2=A0 But if you want =
to=20
discuss devlink support for each type of devices, it's obvious not the=20
correct place.


>
>>> For instance, this VFIO based approach might be very suitable to the
>>> intel VF based ICF driver, but we don't yet have an example of non-VF
>>> HW that might not be well suited to VFIO.


What's the reason that causes your HW not suited to VFIO? Mdev had=20
already supported device IOMMU partially, let's just improve it if it=20
doesn't meet your requirement. Or are there any fundamental barriers there?


>> I don't think we should keep moving the goalposts like this.
> It is ABI, it should be done as best we can as we have to live with it
> for a long time. Right now HW is just starting to come to market with
> VDPA and it feels rushed to design a whole subsystem style ABI around
> one, quite simplistic, driver example.


Well, I know there could be some special features in your hardware,=20
let's just discuss here to seek a solution instead of keep saying "your=20
framework does not fit our case" without any real details.


>
>> If people write drivers and find some infrastruture useful,
>> and it looks more or less generic on the outset, then I don't
>> see why it's a bad idea to merge it.
> Because it is userspace ABI, caution is always justified when defining
> new ABI.


Well, if you read vhost-mdev patch, you will see it doesn't invent any=20
userspace ABI. VFIO ABI is completely followed there.

Thanks


>
> Jason
>

