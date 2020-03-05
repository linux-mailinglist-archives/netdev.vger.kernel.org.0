Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24ECF179E14
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 04:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgCEDCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 22:02:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34510 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725810AbgCEDCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 22:02:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583377331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XEOVbJdaYFn4+qqGun9jyaGeacVOn7m9fMHJ/ZdAsls=;
        b=FBeQ8ahgRURBxdIN72YINx42ugBSKP4RVXdw8iueMEeLYmOgUJT1rXKggGzp5/dfYAV/d6
        4Tq+NMhhKX71/g3hMOTevF9j2UH+v+qopdB/37yRbxhDuhKqqaZ0ZOjmYZXJ0LvkoM29X+
        sLQ/SnRIOqdS5qTbkBJuwdB9lbi1ELw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-FzLP2esYM_GWbIRzFJf6Xg-1; Wed, 04 Mar 2020 22:02:10 -0500
X-MC-Unique: FzLP2esYM_GWbIRzFJf6Xg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32BB4800D48;
        Thu,  5 Mar 2020 03:02:07 +0000 (UTC)
Received: from [10.72.13.242] (ovpn-13-242.pek2.redhat.com [10.72.13.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB2E360BE0;
        Thu,  5 Mar 2020 03:01:44 +0000 (UTC)
Subject: Re: [PATCH V5 3/5] vDPA: introduce vDPA bus
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com,
        gdawar@xilinx.com, saugatm@xilinx.com, vmireyno@marvell.com
References: <20200226060456.27275-1-jasowang@redhat.com>
 <20200226060456.27275-4-jasowang@redhat.com>
 <20200304192949.GR26318@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2842e634-bb92-a901-0a64-35a4dcde22da@redhat.com>
Date:   Thu, 5 Mar 2020 11:01:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200304192949.GR26318@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/5 =E4=B8=8A=E5=8D=883:29, Jason Gunthorpe wrote:
> On Wed, Feb 26, 2020 at 02:04:54PM +0800, Jason Wang wrote:
>> +struct vdpa_device *vdpa_alloc_device(struct device *parent,
>> +				      struct device *dma_dev,
>> +				      const struct vdpa_config_ops *config)
>> +{
>> +	struct vdpa_device *vdev;
>> +	int err =3D -ENOMEM;
>> +
>> +	if (!parent || !dma_dev || !config)
>> +		goto err;
>> +
>> +	vdev =3D kzalloc(sizeof(*vdev), GFP_KERNEL);
>> +	if (!vdev)
>> +		goto err;
>> +
>> +	err =3D ida_simple_get(&vdpa_index_ida, 0, 0, GFP_KERNEL);
>> +	if (err < 0)
>> +		goto err_ida;
>> +
>> +	vdev->dev.bus =3D &vdpa_bus;
>> +	vdev->dev.parent =3D parent;
>> +	vdev->dev.release =3D vdpa_release_dev;
>> +
>> +	device_initialize(&vdev->dev);
>> +
>> +	vdev->index =3D err;
>> +	vdev->dma_dev =3D dma_dev;
>> +	vdev->config =3D config;
>> +
>> +	dev_set_name(&vdev->dev, "vdpa%u", vdev->index);
> Probably shouldn't ignore the error for dev_set_name ?
>
> err =3D dev_set_name()
> if (err) {
>     put_device(&vdev->dev);
>     return ERR_PTR(err);
> }
>
> Jason
>

Right, will fix.

Thanks

