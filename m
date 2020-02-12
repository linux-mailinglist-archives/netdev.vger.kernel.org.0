Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239BF15A354
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgBLI1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:27:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20112 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728353AbgBLI1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:27:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581496058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0qA1nDcFUvrV3P04ERfz3LJJdXRR+wWSmOw4ogMcuSU=;
        b=OcUyGKkAkz/wplYYA7cgAVr4h1cgVSf2J5eYVNAqMqmtYlF6I3UMCEWk1pM4uHuO5+Sk2Y
        GgIUDL+/9lXvSJDA+5rA+A6mASe2Bgc3fsb350t69wehaAbnOWLiCrJOM/APPmhPE551oE
        Nl7XhQF0PZyRs1LPtjUIGRUz412X5/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-v6ZEW2x5PFuPkYDjaZSrCg-1; Wed, 12 Feb 2020 03:27:36 -0500
X-MC-Unique: v6ZEW2x5PFuPkYDjaZSrCg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E058B1857340;
        Wed, 12 Feb 2020 08:27:33 +0000 (UTC)
Received: from [10.72.13.111] (ovpn-13-111.pek2.redhat.com [10.72.13.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03FA85DA83;
        Wed, 12 Feb 2020 08:27:17 +0000 (UTC)
Subject: Re: [PATCH V2 5/5] vdpasim: vDPA device simulator
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
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-6-jasowang@redhat.com>
 <20200211135254.GJ4271@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3dbadf4e-c4c5-22cc-f970-f25fa42c13d8@redhat.com>
Date:   Wed, 12 Feb 2020 16:27:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200211135254.GJ4271@mellanox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/11 =E4=B8=8B=E5=8D=889:52, Jason Gunthorpe wrote:
> On Mon, Feb 10, 2020 at 11:56:08AM +0800, Jason Wang wrote:
>> +
>> +static struct vdpasim *vdpasim_create(void)
>> +{
>> +	struct vdpasim *vdpasim;
>> +	struct virtio_net_config *config;
>> +	struct vdpa_device *vdpa;
>> +	struct device *dev;
>> +	int ret =3D -ENOMEM;
>> +
>> +	vdpasim =3D kzalloc(sizeof(*vdpasim), GFP_KERNEL);
>> +	if (!vdpasim)
>> +		goto err_vdpa_alloc;
>> +
>> +	vdpasim->buffer =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
>> +	if (!vdpasim->buffer)
>> +		goto err_buffer_alloc;
>> +
>> +	vdpasim->iommu =3D vhost_iotlb_alloc(2048, 0);
>> +	if (!vdpasim->iommu)
>> +		goto err_iotlb;
>> +
>> +	config =3D &vdpasim->config;
>> +	config->mtu =3D 1500;
>> +	config->status =3D VIRTIO_NET_S_LINK_UP;
>> +	eth_random_addr(config->mac);
>> +
>> +	INIT_WORK(&vdpasim->work, vdpasim_work);
>> +	spin_lock_init(&vdpasim->lock);
>> +
>> +	vdpa =3D &vdpasim->vdpa;
>> +	vdpa->dev.release =3D vdpasim_release_dev;
> The driver should not provide the release function.
>
> Again the safest model is 'vdpa_alloc_device' which combines the
> kzalloc and the vdpa_init_device() and returns something that is
> error unwound with put_device()
>
> The subsystem owns the release and does the kfree and other cleanup
> like releasing the IDA.


So I think if we agree bus instead of class is used. vDPA bus can=20
provide a release function in vdpa_alloc_device()?


>
>> +	vringh_set_iotlb(&vdpasim->vqs[0].vring, vdpasim->iommu);
>> +	vringh_set_iotlb(&vdpasim->vqs[1].vring, vdpasim->iommu);
>> +
>> +	dev =3D &vdpa->dev;
>> +	dev->coherent_dma_mask =3D DMA_BIT_MASK(64);
>> +	set_dma_ops(dev, &vdpasim_dma_ops);
>> +
>> +	ret =3D vdpa_init_device(vdpa, &vdpasim_dev->dev, dev,
>> +			       &vdpasim_net_config_ops);
>> +	if (ret)
>> +		goto err_init;
>> +
>> +	ret =3D vdpa_register_device(vdpa);
>> +	if (ret)
>> +		goto err_register;
> See? This error unwind is now all wrong:
>
>> +
>> +	return vdpasim;
>> +
>> +err_register:
>> +	put_device(&vdpa->dev);
> Double put_device


Yes.


>
>> +err_init:
>> +	vhost_iotlb_free(vdpasim->iommu);
>> +err_iotlb:
>> +	kfree(vdpasim->buffer);
>> +err_buffer_alloc:
>> +	kfree(vdpasim);
> kfree after vdpa_init_device() is incorrect, as the put_device now
> does kfree via release


Ok, will fix.


>
>> +static int __init vdpasim_dev_init(void)
>> +{
>> +	struct device *dev;
>> +	int ret =3D 0;
>> +
>> +	vdpasim_dev =3D kzalloc(sizeof(*vdpasim_dev), GFP_KERNEL);
>> +	if (!vdpasim_dev)
>> +		return -ENOMEM;
>> +
>> +	dev =3D &vdpasim_dev->dev;
>> +	dev->release =3D vdpasim_device_release;
>> +	dev_set_name(dev, "%s", VDPASIM_NAME);
>> +
>> +	ret =3D device_register(&vdpasim_dev->dev);
>> +	if (ret)
>> +		goto err_register;
>> +
>> +	if (!vdpasim_create())
>> +		goto err_register;
> Wrong error unwind here too


Will fix.

Thanks


>
>> +	return 0;
>> +
>> +err_register:
>> +	kfree(vdpasim_dev);
>> +	vdpasim_dev =3D NULL;
>> +	return ret;
>> +}
> Jason
>

