Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F05D018AE32
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 09:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgCSIPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 04:15:53 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:24386 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726658AbgCSIPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 04:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584605751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TgtDtG3cRVj31mITgFClFTokcEIBD9CXpdML9H7Wb8k=;
        b=OQZKXqXxdyRhU92rEGhd7sJG3gAi4j5gU6xdxv8iZ4VD99LArR56QY+N/pCIwGQBAxx4Z6
        1iTx6grokSq+CHArLU/s2fLFzfO5gWvroP+U3t5RoS6zvvMIHlOdo4tC4Z/h1AflHFP8nH
        GJzY3y1BvqHfAEoVWCg+kMqcG7pa3HI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-1bCvthWzPxO0ZFGWraD_bQ-1; Thu, 19 Mar 2020 04:15:50 -0400
X-MC-Unique: 1bCvthWzPxO0ZFGWraD_bQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49FA9189D6C3;
        Thu, 19 Mar 2020 08:15:47 +0000 (UTC)
Received: from [10.72.12.119] (ovpn-12-119.pek2.redhat.com [10.72.12.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A67B19756;
        Thu, 19 Mar 2020 08:14:40 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <30359bae-d66a-0311-0028-d7d33b8295f2@redhat.com>
Date:   Thu, 19 Mar 2020 16:14:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200318122255.GG13183@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/18 =E4=B8=8B=E5=8D=888:22, Jason Gunthorpe wrote:
> On Wed, Mar 18, 2020 at 04:03:27PM +0800, Jason Wang wrote:
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> +
>> +static int ifcvf_vdpa_attach(struct ifcvf_adapter *adapter)
>> +{
>> +	int ret;
>> +
>> +	adapter->vdpa_dev  =3D vdpa_alloc_device(adapter->dev, adapter->dev,
>> +					       &ifc_vdpa_ops);
>> +	if (IS_ERR(adapter->vdpa_dev)) {
>> +		IFCVF_ERR(adapter->dev, "Failed to init ifcvf on vdpa bus");
>> +		put_device(&adapter->vdpa_dev->dev);
>> +		return -ENODEV;
>> +	}
> The point of having an alloc call is so that the drivers
> ifcvf_adaptor memory could be placed in the same struct - eg use
> container_of to flip between them, and have a kref for both memories.
>
> It seem really weird to have an alloc followed immediately by
> register.


I admit the ifcvf_adapter is not correctly ref-counted. What you suggest=20
should work. But it looks to me the following is more cleaner since the=20
members of ifcvf_adapter are all related to PCI device not vDPA itself.

- keep the current layout of ifcvf_adapter
- merge vdpa_alloc_device() and vdpa_register_device()
- use devres to bind ifcvf_adapter refcnt/lifcycle to the under PCI devic=
e

If we go for the container_of method, we probably need

- accept a size of parent parent structure in vdpa_alloc_device() and=20
mandate vdpa_device to be the first member of ifcvf_adapter
- we need provide a way to free resources of parent structure when we=20
destroy vDPA device

What's your thought?


>> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa=
.c
>> index c30eb55030be..de64b88ee7e4 100644
>> +++ b/drivers/virtio/virtio_vdpa.c
>> @@ -362,6 +362,7 @@ static int virtio_vdpa_probe(struct vdpa_device *v=
dpa)
>>   		goto err;
>>  =20
>>   	vdpa_set_drvdata(vdpa, vd_dev);
>> +	dev_info(vd_dev->vdev.dev.parent, "device attached to VDPA bus\n");
>>  =20
>>   	return 0;
> This hunk seems out of place
>
> Jason


Right, will fix.

Thanks

