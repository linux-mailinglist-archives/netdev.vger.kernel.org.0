Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666A4153D29
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 04:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgBFDFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 22:05:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51818 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727307AbgBFDFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 22:05:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580958299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZmilr4tlxmSPvlBFFTM+7GZjr7g54JZ6ybjetf90JQ=;
        b=bBclXKWHqE0FmkFxHVOKEBkvMde4umICaVTEnS4TtKSyTx4Q5Me/DgH8V4l33o8+IWgqyy
        /DmV8YAn/VPxiK+dvQ9QpFtzeETE8Monq6YzFOZaLX3/j5UXSSWQ8JZLEis/U7Yg3VE4Jo
        fiWKJz95vox2rkS2JqqiPDGbNmaZYw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-X0XgH6JIPi2zxsSJw37NDg-1; Wed, 05 Feb 2020 22:04:58 -0500
X-MC-Unique: X0XgH6JIPi2zxsSJw37NDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 784FA2F60;
        Thu,  6 Feb 2020 03:04:55 +0000 (UTC)
Received: from [10.72.13.85] (ovpn-13-85.pek2.redhat.com [10.72.13.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3A4D5C1B2;
        Thu,  6 Feb 2020 03:04:42 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     Shahaf Shuler <shahafs@mellanox.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "dan.daly@intel.com" <dan.daly@intel.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200205020247.GA368700@___>
 <AM0PR0502MB37952015716C1D5E07E390B6C3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
 <AM0PR0502MB3795AD42233D69F350402A8AC3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8af7b9b1-f721-8d1c-dd1c-403424ee20b9@redhat.com>
Date:   Thu, 6 Feb 2020 11:04:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR0502MB3795AD42233D69F350402A8AC3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/5 =E4=B8=8B=E5=8D=885:30, Shahaf Shuler wrote:
> Wednesday, February 5, 2020 9:50 AM, Jason Wang:
>> Subject: Re: [PATCH] vhost: introduce vDPA based backend
>> On 2020/2/5 =E4=B8=8B=E5=8D=883:15, Shahaf Shuler wrote:
>>> Wednesday, February 5, 2020 4:03 AM, Tiwei Bie:
>>>> Subject: Re: [PATCH] vhost: introduce vDPA based backend
>>>>
>>>> On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
>>>>> On 2020/1/31 =E4=B8=8A=E5=8D=8811:36, Tiwei Bie wrote:
>>>>>> This patch introduces a vDPA based vhost backend. This backend is
>>>>>> built on top of the same interface defined in virtio-vDPA and
>>>>>> provides a generic vhost interface for userspace to accelerate the
>>>>>> virtio devices in guest.
>>>>>>
>>>>>> This backend is implemented as a vDPA device driver on top of the
>>>>>> same ops used in virtio-vDPA. It will create char device entry
>>>>>> named vhost-vdpa/$vdpa_device_index for userspace to use.
>> Userspace
>>>>>> can use vhost ioctls on top of this char device to setup the backe=
nd.
>>>>>>
>>>>>> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
>>> [...]
>>>
>>>>>> +static long vhost_vdpa_do_dma_mapping(struct vhost_vdpa *v) {
>>>>>> +	/* TODO: fix this */
>>>>> Before trying to do this it looks to me we need the following durin=
g
>>>>> the probe
>>>>>
>>>>> 1) if set_map() is not supported by the vDPA device probe the IOMMU
>>>>> that is supported by the vDPA device
>>>>> 2) allocate IOMMU domain
>>>>>
>>>>> And then:
>>>>>
>>>>> 3) pin pages through GUP and do proper accounting
>>>>> 4) store GPA->HPA mapping in the umem
>>>>> 5) generate diffs of memory table and using IOMMU API to setup the
>>>>> dma mapping in this method
>>>>>
>>>>> For 1), I'm not sure parent is sufficient for to doing this or need
>>>>> to introduce new API like iommu_device in mdev.
>>>> Agree. We may also need to introduce something like the iommu_device=
.
>>>>
>>> Would it be better for the map/umnap logic to happen inside each devi=
ce ?
>>> Devices that needs the IOMMU will call iommu APIs from inside the dri=
ver
>> callback.
>>
>>
>> Technically, this can work. But if it can be done by vhost-vpda it wil=
l make the
>> vDPA driver more compact and easier to be implemented.
> Need to see the layering of such proposal but am not sure.
> Vhost-vdpa is generic framework, while the DMA mapping is vendor specif=
ic.
> Maybe vhost-vdpa can have some shared code needed to operate on iommu, =
so drivers can re-use it.  to me it seems simpler than exposing a new iom=
mu device.


I think you mean on-chip IOMMU here. For shared code, I guess this only=20
thing that could be shared is the mapping (rbtree) and some helpers. Or=20
is there any other in your mind?


>>
>>> Devices that has other ways to do the DMA mapping will call the
>> proprietary APIs.
>>
>>
>> To confirm, do you prefer:
>>
>> 1) map/unmap
> It is not only that. AFAIR there also flush and invalidate calls, right=
?


unmap will accept a range so it it can do flush and invalidate.


>
>> or
>>
>> 2) pass all maps at one time?
> To me this seems more straight forward.
> It is correct that under hotplug and large number of memory segments th=
e driver will need to understand the diff (or not and just reload the new=
 configuration). However, my assumption here is that memory hotplug is he=
avy flow anyway, and the driver extra cycles will not be that visible


Yes, and vhost can provide helpers to generate the diffs.

Thanks


>
>> Thanks
>>
>>

