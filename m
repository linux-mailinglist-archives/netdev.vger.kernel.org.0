Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B87C9C0170
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfI0IsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:48:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfI0IsA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 04:48:00 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 24E34300C72B;
        Fri, 27 Sep 2019 08:48:00 +0000 (UTC)
Received: from [10.72.12.30] (ovpn-12-30.pek2.redhat.com [10.72.12.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1FD85D6A7;
        Fri, 27 Sep 2019 08:47:45 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <1b4b8891-8c14-1c85-1d6a-2eed1c90bcde@redhat.com>
 <20190927045438.GA17152@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <05ab395e-6677-e8c3-becf-57bc1529921f@redhat.com>
Date:   Fri, 27 Sep 2019 16:47:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927045438.GA17152@___>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 27 Sep 2019 08:48:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/27 下午12:54, Tiwei Bie wrote:
> On Fri, Sep 27, 2019 at 11:46:06AM +0800, Jason Wang wrote:
>> On 2019/9/26 下午12:54, Tiwei Bie wrote:
>>> +
>>> +static long vhost_mdev_start(struct vhost_mdev *m)
>>> +{
>>> +	struct mdev_device *mdev = m->mdev;
>>> +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
>>> +	struct virtio_mdev_callback cb;
>>> +	struct vhost_virtqueue *vq;
>>> +	int idx;
>>> +
>>> +	ops->set_features(mdev, m->acked_features);
>>> +
>>> +	mdev_add_status(mdev, VIRTIO_CONFIG_S_FEATURES_OK);
>>> +	if (!(mdev_get_status(mdev) & VIRTIO_CONFIG_S_FEATURES_OK))
>>> +		goto reset;
>>> +
>>> +	for (idx = 0; idx < m->nvqs; idx++) {
>>> +		vq = &m->vqs[idx];
>>> +
>>> +		if (!vq->desc || !vq->avail || !vq->used)
>>> +			break;
>>> +
>>> +		if (ops->set_vq_state(mdev, idx, vq->last_avail_idx))
>>> +			goto reset;
>> If we do set_vq_state() in SET_VRING_BASE, we won't need this step here.
> Yeah, I plan to do it in the next version.
>
>>> +
>>> +		/*
>>> +		 * In vhost-mdev, userspace should pass ring addresses
>>> +		 * in guest physical addresses when IOMMU is disabled or
>>> +		 * IOVAs when IOMMU is enabled.
>>> +		 */
>> A question here, consider we're using noiommu mode. If guest physical
>> address is passed here, how can a device use that?
>>
>> I believe you meant "host physical address" here? And it also have the
>> implication that the HPA should be continuous (e.g using hugetlbfs).
> The comment is talking about the virtual IOMMU (i.e. iotlb in vhost).
> It should be rephrased to cover the noiommu case as well. Thanks for
> spotting this.
>
>
>>> +
>>> +	switch (cmd) {
>>> +	case VHOST_MDEV_SET_STATE:
>>> +		r = vhost_set_state(m, argp);
>>> +		break;
>>> +	case VHOST_GET_FEATURES:
>>> +		r = vhost_get_features(m, argp);
>>> +		break;
>>> +	case VHOST_SET_FEATURES:
>>> +		r = vhost_set_features(m, argp);
>>> +		break;
>>> +	case VHOST_GET_VRING_BASE:
>>> +		r = vhost_get_vring_base(m, argp);
>>> +		break;
>> Does it mean the SET_VRING_BASE may only take affect after
>> VHOST_MEV_SET_STATE?
> Yeah, in this version, SET_VRING_BASE won't set the base to the
> device directly. But I plan to not delay this anymore in the next
> version to support the SET_STATUS.
>
>>> +	default:
>>> +		r = vhost_dev_ioctl(&m->dev, cmd, argp);
>>> +		if (r == -ENOIOCTLCMD)
>>> +			r = vhost_vring_ioctl(&m->dev, cmd, argp);
>>> +	}
>>> +
>>> +	mutex_unlock(&m->mutex);
>>> +	return r;
>>> +}
>>> +
>>> +static const struct vfio_device_ops vfio_vhost_mdev_dev_ops = {
>>> +	.name		= "vfio-vhost-mdev",
>>> +	.open		= vhost_mdev_open,
>>> +	.release	= vhost_mdev_release,
>>> +	.ioctl		= vhost_mdev_unlocked_ioctl,
>>> +};
>>> +
>>> +static int vhost_mdev_probe(struct device *dev)
>>> +{
>>> +	struct mdev_device *mdev = mdev_from_dev(dev);
>>> +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
>>> +	struct vhost_mdev *m;
>>> +	int nvqs, r;
>>> +
>>> +	m = kzalloc(sizeof(*m), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>>> +	if (!m)
>>> +		return -ENOMEM;
>>> +
>>> +	mutex_init(&m->mutex);
>>> +
>>> +	nvqs = ops->get_queue_max(mdev);
>>> +	m->nvqs = nvqs;
>> The name could be confusing, get_queue_max() is to get the maximum number of
>> entries for a virtqueue supported by this device.
> OK. It might be better to rename it to something like:
>
> 	get_vq_num_max()
>
> which is more consistent with the set_vq_num().
>
>> It looks to me that we need another API to query the maximum number of
>> virtqueues supported by the device.
> Yeah.
>
> Thanks,
> Tiwei


One problem here:

Consider if we want to support multiqueue, how did userspace know about 
this? Note this information could be fetched from get_config() via a 
device specific way, do we want ioctl for accessing that area?

Thanks

