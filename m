Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE7E415266B
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 07:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgBEGuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 01:50:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44881 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725875AbgBEGuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 01:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580885418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wE2vWrZfATx1m0Y7LHRA4jaMP+1sekxlUzJjAOwdAHM=;
        b=FsAdKZTFBUdh4E4OXGXXdmndvHslSEWlpXxB5+6/qv2pcnSTLU4FYG3XfKgR3JRmNqz39z
        HuagAtsB6fBwC4exN/Ik5OLI0/bG6fFYvFYerOrLPW8ctMrVlFKbrxoUo+7AYWQs/KlhkA
        +HzpX+xkuEvrLf1fM+k5yq7XdPL5BMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-_Ob3lLb_MXmy3zWqO6IqAQ-1; Wed, 05 Feb 2020 01:50:16 -0500
X-MC-Unique: _Ob3lLb_MXmy3zWqO6IqAQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FB60DBA5;
        Wed,  5 Feb 2020 06:50:14 +0000 (UTC)
Received: from [10.72.13.188] (ovpn-13-188.pek2.redhat.com [10.72.13.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 394381001B09;
        Wed,  5 Feb 2020 06:49:37 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, shahafs@mellanox.com, jgg@mellanox.com,
        rob.miller@broadcom.com, haotian.wang@sifive.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        rdunlap@infradead.org, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200204005306-mutt-send-email-mst@kernel.org>
 <cf485e7f-46e3-20d3-8452-e3058b885d0a@redhat.com>
 <20200205020555.GA369236@___>
 <798e5644-ca28-ee46-c953-688af9bccd3b@redhat.com>
 <20200205003048-mutt-send-email-mst@kernel.org>
 <eb53d1c2-92ae-febf-f502-2d3e107ee608@redhat.com>
 <20200205011935-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2dd43fb5-6f02-2dcc-5c27-9f7419ef72fc@redhat.com>
Date:   Wed, 5 Feb 2020 14:49:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200205011935-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/5 =E4=B8=8B=E5=8D=882:30, Michael S. Tsirkin wrote:
> On Wed, Feb 05, 2020 at 01:50:28PM +0800, Jason Wang wrote:
>> On 2020/2/5 =E4=B8=8B=E5=8D=881:31, Michael S. Tsirkin wrote:
>>> On Wed, Feb 05, 2020 at 11:12:21AM +0800, Jason Wang wrote:
>>>> On 2020/2/5 =E4=B8=8A=E5=8D=8810:05, Tiwei Bie wrote:
>>>>> On Tue, Feb 04, 2020 at 02:46:16PM +0800, Jason Wang wrote:
>>>>>> On 2020/2/4 =E4=B8=8B=E5=8D=882:01, Michael S. Tsirkin wrote:
>>>>>>> On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
>>>>>>>> 5) generate diffs of memory table and using IOMMU API to setup t=
he dma
>>>>>>>> mapping in this method
>>>>>>> Frankly I think that's a bunch of work. Why not a MAP/UNMAP inter=
face?
>>>>>>>
>>>>>> Sure, so that basically VHOST_IOTLB_UPDATE/INVALIDATE I think?
>>>>> Do you mean we let userspace to only use VHOST_IOTLB_UPDATE/INVALID=
ATE
>>>>> to do the DMA mapping in vhost-vdpa case? When vIOMMU isn't availab=
le,
>>>>> userspace will set msg->iova to GPA, otherwise userspace will set
>>>>> msg->iova to GIOVA, and vhost-vdpa module will get HPA from msg->ua=
ddr?
>>>>>
>>>>> Thanks,
>>>>> Tiwei
>>>> I think so. Michael, do you think this makes sense?
>>>>
>>>> Thanks
>>> to make sure, could you post the suggested argument format for
>>> these ioctls?
>>>
>> It's the existed uapi:
>>
>> /* no alignment requirement */
>> struct vhost_iotlb_msg {
>>  =C2=A0=C2=A0=C2=A0 __u64 iova;
>>  =C2=A0=C2=A0=C2=A0 __u64 size;
>>  =C2=A0=C2=A0=C2=A0 __u64 uaddr;
>> #define VHOST_ACCESS_RO=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1
>> #define VHOST_ACCESS_WO=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x2
>> #define VHOST_ACCESS_RW=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x3
>>  =C2=A0=C2=A0=C2=A0 __u8 perm;
>> #define VHOST_IOTLB_MISS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1
>> #define VHOST_IOTLB_UPDATE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 2
>> #define VHOST_IOTLB_INVALIDATE=C2=A0=C2=A0=C2=A0=C2=A0 3
>> #define VHOST_IOTLB_ACCESS_FAIL=C2=A0=C2=A0=C2=A0 4
>>  =C2=A0=C2=A0=C2=A0 __u8 type;
>> };
>>
>> #define VHOST_IOTLB_MSG 0x1
>> #define VHOST_IOTLB_MSG_V2 0x2
>>
>> struct vhost_msg {
>>  =C2=A0=C2=A0=C2=A0 int type;
>>  =C2=A0=C2=A0=C2=A0 union {
>>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 struct vhost_iotlb_msg iotlb;
>>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 __u8 padding[64];
>>  =C2=A0=C2=A0=C2=A0 };
>> };
>>
>> struct vhost_msg_v2 {
>>  =C2=A0=C2=A0=C2=A0 __u32 type;
>>  =C2=A0=C2=A0=C2=A0 __u32 reserved;
>>  =C2=A0=C2=A0=C2=A0 union {
>>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 struct vhost_iotlb_msg iotlb;
>>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 __u8 padding[64];
>>  =C2=A0=C2=A0=C2=A0 };
>> };
> Oh ok.  So with a real device, I suspect we do not want to wait for eac=
h
> change to be processed by device completely, so we might want an asynch=
ronous variant
> and then some kind of flush that tells device "you better apply these n=
ow".


Let me explain:

There are two types of devices:

1) device without on-chip IOMMU, DMA was done via IOMMU API which only=20
support incremental map/unmap
2) device with on-chip IOMMU, DMA could be done by device driver itself,=20
and we could choose to pass the whole mappings to the driver at one time=20
through vDPA bus operation (set_map)

For vhost-vpda, there're two types of memory mapping:

a) memory table, setup by userspace through VHOST_SET_MEM_TABLE, the=20
whole mapping is updated in this way
b) IOTLB API, incrementally done by userspace through vhost message=20
(IOTLB_UPDATE/IOTLB_INVALIDATE)

The current design is:

- Reuse VHOST_SET_MEM_TABLE, and for type 1), we can choose to send=20
diffs through IOMMU API or flush all the mappings then map new ones. For=20
type 2), just send the whole mapping through set_map()
- Reuse vhost IOTLB, so for type 1), simply forward update/invalidate=20
request via IOMMU API, for type 2), send IOTLB to vDPA device driver via=20
set_map(), device driver may choose to send diffs or rebuild all mapping=20
at their will

Technically we can use vhost IOTLB API (map/umap) for building=20
VHOST_SET_MEM_TABLE, but to avoid device to process the each request, it=20
looks to me we need new UAPI which seems sub optimal.

What's you thought?

Thanks


>

