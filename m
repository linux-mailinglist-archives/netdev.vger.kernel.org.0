Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A879D15A276
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 08:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgBLHzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 02:55:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39292 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728419AbgBLHzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 02:55:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581494153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6lJXyrbl6ehIPLDhdvGx94ceUYOxEq2wFztlRa5WwwQ=;
        b=a65sjySZfWE+uFTgwGTt3UWRH2xxIujiFDkmxzFSJzifUokUXoRzDODK7IaBqwxoOK76UU
        u8cMXcAaIkgK9l36CJ2VtsyIxobwpk604y5E8a6RpSshdS70UNGcE6nNGC09XClbOn5Lfy
        Fu50NaZfmgyrS6/7hZ8cn8V58eDW0FE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-Ai4LYDoyOY2q3q5g_r5Iww-1; Wed, 12 Feb 2020 02:55:51 -0500
X-MC-Unique: Ai4LYDoyOY2q3q5g_r5Iww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CB10107ACC9;
        Wed, 12 Feb 2020 07:55:49 +0000 (UTC)
Received: from [10.72.13.111] (ovpn-13-111.pek2.redhat.com [10.72.13.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29C5960BF1;
        Wed, 12 Feb 2020 07:55:32 +0000 (UTC)
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
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
 <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
Date:   Wed, 12 Feb 2020 15:55:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200211134746.GI4271@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/11 =E4=B8=8B=E5=8D=889:47, Jason Gunthorpe wrote:
> On Mon, Feb 10, 2020 at 11:56:06AM +0800, Jason Wang wrote:
>> +/**
>> + * vdpa_register_device - register a vDPA device
>> + * Callers must have a succeed call of vdpa_init_device() before.
>> + * @vdev: the vdpa device to be registered to vDPA bus
>> + *
>> + * Returns an error when fail to add to vDPA bus
>> + */
>> +int vdpa_register_device(struct vdpa_device *vdev)
>> +{
>> +	int err =3D device_add(&vdev->dev);
>> +
>> +	if (err) {
>> +		put_device(&vdev->dev);
>> +		ida_simple_remove(&vdpa_index_ida, vdev->index);
>> +	}
> This is a very dangerous construction, I've seen it lead to driver
> bugs. Better to require the driver to always do the put_device on
> error unwind


Ok.


>
> The ida_simple_remove should probably be part of the class release
> function to make everything work right


It looks to me bus instead of class is the correct abstraction here=20
since the devices share a set of programming interface but not the=20
semantics.

Or do you actually mean type here?


>
>> +/**
>> + * vdpa_unregister_driver - unregister a vDPA device driver
>> + * @drv: the vdpa device driver to be unregistered
>> + */
>> +void vdpa_unregister_driver(struct vdpa_driver *drv)
>> +{
>> +	driver_unregister(&drv->driver);
>> +}
>> +EXPORT_SYMBOL_GPL(vdpa_unregister_driver);
>> +
>> +static int vdpa_init(void)
>> +{
>> +	if (bus_register(&vdpa_bus) !=3D 0)
>> +		panic("virtio bus registration failed");
>> +	return 0;
>> +}
> Linus will tell you not to kill the kernel - return the error code and
> propagate it up to the module init function.


Yes, will fix.


>
>> +/**
>> + * vDPA device - representation of a vDPA device
>> + * @dev: underlying device
>> + * @dma_dev: the actual device that is performing DMA
>> + * @config: the configuration ops for this device.
>> + * @index: device index
>> + */
>> +struct vdpa_device {
>> +	struct device dev;
>> +	struct device *dma_dev;
>> +	const struct vdpa_config_ops *config;
>> +	int index;
> unsigned values shuld be unsigned int
>
> Jason


Will fix.

Thanks

>

