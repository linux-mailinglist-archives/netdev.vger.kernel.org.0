Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D16DBE7A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 09:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393834AbfJRHgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 03:36:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbfJRHgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 03:36:00 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 148FC3071D99;
        Fri, 18 Oct 2019 07:36:00 +0000 (UTC)
Received: from [10.72.12.183] (ovpn-12-183.pek2.redhat.com [10.72.12.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 249DB5D712;
        Fri, 18 Oct 2019 07:35:37 +0000 (UTC)
Subject: Re: [PATCH V4 4/6] mdev: introduce virtio device and its device ops
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
References: <20191017104836.32464-1-jasowang@redhat.com>
 <20191017104836.32464-5-jasowang@redhat.com>
 <20191017115329.47d4a165@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <24a96fca-926d-38ee-4dab-5f3715ef1433@redhat.com>
Date:   Fri, 18 Oct 2019 15:35:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191017115329.47d4a165@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 18 Oct 2019 07:36:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/18 上午1:53, Alex Williamson wrote:
> On Thu, 17 Oct 2019 18:48:34 +0800
> Jason Wang<jasowang@redhat.com>  wrote:
>
>> This patch implements basic support for mdev driver that supports
>> virtio transport for kernel virtio driver.
>>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>> ---
>>   drivers/vfio/mdev/mdev_core.c |  12 +++
>>   include/linux/mdev.h          |   4 +
>>   include/linux/virtio_mdev.h   | 151 ++++++++++++++++++++++++++++++++++
>>   3 files changed, 167 insertions(+)
>>   create mode 100644 include/linux/virtio_mdev.h
>>
>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>> index d0f3113c8071..5834f6b7c7a5 100644
>> --- a/drivers/vfio/mdev/mdev_core.c
>> +++ b/drivers/vfio/mdev/mdev_core.c
>> @@ -57,6 +57,18 @@ void mdev_set_vfio_ops(struct mdev_device *mdev,
>>   }
>>   EXPORT_SYMBOL(mdev_set_vfio_ops);
>>   
>> +/* Specify the virtio device ops for the mdev device, this
>> + * must be called during create() callback for virtio mdev device.
>> + */
>> +void mdev_set_virtio_ops(struct mdev_device *mdev,
>> +			 const struct virtio_mdev_device_ops *virtio_ops)
>> +{
>> +	BUG_ON(mdev->class_id);
> Nit, this one is a BUG_ON, but the vfio one is a WARN_ON.  Thanks,
>
> Alex


Let me fix in next version.

Thanks

