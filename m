Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECEC4DC353
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 12:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633329AbfJRK7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 06:59:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392257AbfJRK7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 06:59:21 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3DBB3CA377;
        Fri, 18 Oct 2019 10:59:20 +0000 (UTC)
Received: from [10.72.12.59] (ovpn-12-59.pek2.redhat.com [10.72.12.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87CDC60852;
        Fri, 18 Oct 2019 10:57:30 +0000 (UTC)
Subject: Re: [PATCH V4 4/6] mdev: introduce virtio device and its device ops
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com,
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
 <20191017104836.32464-5-jasowang@redhat.com> <20191018094655.GA4200@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a2a8e447-c778-59db-071a-ffa348a69bb8@redhat.com>
Date:   Fri, 18 Oct 2019 18:57:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191018094655.GA4200@___>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 18 Oct 2019 10:59:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/18 下午5:46, Tiwei Bie wrote:
> On Thu, Oct 17, 2019 at 06:48:34PM +0800, Jason Wang wrote:
>> + * @get_vq_state:		Get the state for a virtqueue
>> + *				@mdev: mediated device
>> + *				@idx: virtqueue index
>> + *				Returns virtqueue state (last_avail_idx)
>> + * @get_vq_align:		Get the virtqueue align requirement
>> + *				for the device
>> + *				@mdev: mediated device
>> + *				Returns virtqueue algin requirement
>> + * @get_features:		Get virtio features supported by the device
>> + *				@mdev: mediated device
>> + *				Returns the virtio features support by the
>> + *				device
>> + * @get_features:		Set virtio features supported by the driver
> s/get_features/set_features/


Will fix.


>
>> + *				configration space
>> + * @get_mdev_features:		Get the feature of virtio mdev device
>> + *				@mdev: mediated device
>> + *				Returns the mdev features (API) support by
>> + *				the device.
>> + * @get_generation:		Get device generaton
>> + *				@mdev: mediated device
>> + *				Returns u32: device generation
>> + */
>> +struct virtio_mdev_device_ops {
>> +	/* Virtqueue ops */
>> +	int (*set_vq_address)(struct mdev_device *mdev,
>> +			      u16 idx, u64 desc_area, u64 driver_area,
>> +			      u64 device_area);
>> +	void (*set_vq_num)(struct mdev_device *mdev, u16 idx, u32 num);
>> +	void (*kick_vq)(struct mdev_device *mdev, u16 idx);
>> +	void (*set_vq_cb)(struct mdev_device *mdev, u16 idx,
>> +			  struct virtio_mdev_callback *cb);
>> +	void (*set_vq_ready)(struct mdev_device *mdev, u16 idx, bool ready);
>> +	bool (*get_vq_ready)(struct mdev_device *mdev, u16 idx);
>> +	int (*set_vq_state)(struct mdev_device *mdev, u16 idx, u64 state);
>> +	u64 (*get_vq_state)(struct mdev_device *mdev, u16 idx);
>> +
>> +	/* Device ops */
>> +	u16 (*get_vq_align)(struct mdev_device *mdev);
>> +	u64 (*get_features)(struct mdev_device *mdev);
>> +	int (*set_features)(struct mdev_device *mdev, u64 features);
>> +	void (*set_config_cb)(struct mdev_device *mdev,
>> +			      struct virtio_mdev_callback *cb);
>> +	u16 (*get_vq_num_max)(struct mdev_device *mdev);
>> +	u32 (*get_device_id)(struct mdev_device *mdev);
>> +	u32 (*get_vendor_id)(struct mdev_device *mdev);
>> +	u8 (*get_status)(struct mdev_device *mdev);
>> +	void (*set_status)(struct mdev_device *mdev, u8 status);
>> +	void (*get_config)(struct mdev_device *mdev, unsigned int offset,
>> +			   void *buf, unsigned int len);
>> +	void (*set_config)(struct mdev_device *mdev, unsigned int offset,
>> +			   const void *buf, unsigned int len);
>> +	u64 (*get_mdev_features)(struct mdev_device *mdev);
> Do we need a .set_mdev_features method as well?


Good question. To me I think we may document that the API provides 
backward compatibility, so there's no need for set_mdev_features. Or is 
there any other chance that we need that?


>
> It's not very clear what does mdev_features mean.
> Does it mean the vhost backend features?
>
> https://github.com/torvalds/linux/blob/0e2adab6cf285c41e825b6c74a3aa61324d1132c/include/uapi/linux/vhost.h#L93-L94


Something like this, it's kind of the version of the API, except for the 
_F_VERSION_1, the first user should be _F_LOG_ALL. I will add more docs 
for this API.

Thanks


>
>
>> +	u32 (*get_generation)(struct mdev_device *mdev);
>> +};
>> +
>> +void mdev_set_virtio_ops(struct mdev_device *mdev,
>> +			 const struct virtio_mdev_device_ops *virtio_ops);
>> +
>> +#endif
>> -- 
>> 2.19.1
>>
