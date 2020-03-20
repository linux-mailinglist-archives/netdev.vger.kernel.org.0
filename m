Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9708A18CA01
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgCTJSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:18:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:30542 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726527AbgCTJR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:17:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584695877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RA5PQJx7YSzfov+hXIk77JXzaA1GFtyaspVCOD3A7E4=;
        b=cuPLN+gVp+iQr5HEnhjyXe/arLKu7aptkuRpCwT/wo+GikaaKbLSIFTGiQSbrEQeCfC/5v
        K9uhNjznN+oSd8f+0TxMqlCYabba34HTcrGODyHiSc6VlagP7s2bQuHlbZ4UWMdxtCgv+b
        rVH8CvNnXAkkgUsabYHbyqBJhdVsmgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-fCe8-lhaPCenFclKrajMdw-1; Fri, 20 Mar 2020 05:17:54 -0400
X-MC-Unique: fCe8-lhaPCenFclKrajMdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7B6710753FB;
        Fri, 20 Mar 2020 09:17:50 +0000 (UTC)
Received: from [10.72.13.250] (ovpn-13-250.pek2.redhat.com [10.72.13.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A4D210493BD;
        Fri, 20 Mar 2020 09:17:32 +0000 (UTC)
Subject: Re: [PATCH V6 8/8] virtio: Intel IFC VF driver for VDPA
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        Bie Tiwei <tiwei.bie@intel.com>
References: <20200318080327.21958-1-jasowang@redhat.com>
 <20200318080327.21958-9-jasowang@redhat.com>
 <20200318122255.GG13183@mellanox.com>
 <30359bae-d66a-0311-0028-d7d33b8295f2@redhat.com>
 <20200319130239.GW13183@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <055f10a8-0b7d-ec2b-4fd4-d47ba96ddd5f@redhat.com>
Date:   Fri, 20 Mar 2020 17:17:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200319130239.GW13183@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/19 =E4=B8=8B=E5=8D=889:02, Jason Gunthorpe wrote:
> On Thu, Mar 19, 2020 at 04:14:37PM +0800, Jason Wang wrote:
>> On 2020/3/18 =E4=B8=8B=E5=8D=888:22, Jason Gunthorpe wrote:
>>> On Wed, Mar 18, 2020 at 04:03:27PM +0800, Jason Wang wrote:
>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> +
>>>> +static int ifcvf_vdpa_attach(struct ifcvf_adapter *adapter)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	adapter->vdpa_dev  =3D vdpa_alloc_device(adapter->dev, adapter->de=
v,
>>>> +					       &ifc_vdpa_ops);
>>>> +	if (IS_ERR(adapter->vdpa_dev)) {
>>>> +		IFCVF_ERR(adapter->dev, "Failed to init ifcvf on vdpa bus");
>>>> +		put_device(&adapter->vdpa_dev->dev);
>>>> +		return -ENODEV;
>>>> +	}
>>> The point of having an alloc call is so that the drivers
>>> ifcvf_adaptor memory could be placed in the same struct - eg use
>>> container_of to flip between them, and have a kref for both memories.
>>>
>>> It seem really weird to have an alloc followed immediately by
>>> register.
>>
>> I admit the ifcvf_adapter is not correctly ref-counted. What you sugge=
st
>> should work. But it looks to me the following is more cleaner since th=
e
>> members of ifcvf_adapter are all related to PCI device not vDPA itself=
.
> I've done it both ways (eg tpm is as you describe, ib is using alloc).
>
> I tend to prefer the alloc method today, allowing the driver memory to
> have a proper refcount makes the driver structure usable with RCU and
> allows simple solutions to some tricky cases. It is a bit hard to
> switch to this later..
>
>> - keep the current layout of ifcvf_adapter
>> - merge vdpa_alloc_device() and vdpa_register_device()
>> - use devres to bind ifcvf_adapter refcnt/lifcycle to the under PCI de=
vice
> This is almost what tpm does. Keep in mind the lifecycle with devm is
> just slightly past the driver remove call, so remove still
> must revoke all external references to the memory.
>
> The merging alloc and register rarely works out, the register must be
> the very last thing done, and usually you need the subsystem pointer
> to do pre-registration setup in anything but the most trivial of
> subsystems and drivers.
>
>> If we go for the container_of method, we probably need
>>
>> - accept a size of parent parent structure in vdpa_alloc_device() and
>> mandate vdpa_device to be the first member of ifcvf_adapter
>> - we need provide a way to free resources of parent structure when we
>> destroy vDPA device
> Yep. netdev and rdma work this way with a free memory callback in the
> existing ops structures.
>
> Jason


Ok, I get your points now. Will go for way of container_of in next versio=
n.

Thanks


