Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F0FBFE54
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 06:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbfI0E5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 00:57:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:28040 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbfI0E5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 00:57:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 21:57:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,554,1559545200"; 
   d="scan'208";a="341687563"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.73])
  by orsmga004.jf.intel.com with ESMTP; 26 Sep 2019 21:57:26 -0700
Date:   Fri, 27 Sep 2019 12:54:39 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
Message-ID: <20190927045438.GA17152@___>
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <1b4b8891-8c14-1c85-1d6a-2eed1c90bcde@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b4b8891-8c14-1c85-1d6a-2eed1c90bcde@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 11:46:06AM +0800, Jason Wang wrote:
> On 2019/9/26 下午12:54, Tiwei Bie wrote:
> > +
> > +static long vhost_mdev_start(struct vhost_mdev *m)
> > +{
> > +	struct mdev_device *mdev = m->mdev;
> > +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
> > +	struct virtio_mdev_callback cb;
> > +	struct vhost_virtqueue *vq;
> > +	int idx;
> > +
> > +	ops->set_features(mdev, m->acked_features);
> > +
> > +	mdev_add_status(mdev, VIRTIO_CONFIG_S_FEATURES_OK);
> > +	if (!(mdev_get_status(mdev) & VIRTIO_CONFIG_S_FEATURES_OK))
> > +		goto reset;
> > +
> > +	for (idx = 0; idx < m->nvqs; idx++) {
> > +		vq = &m->vqs[idx];
> > +
> > +		if (!vq->desc || !vq->avail || !vq->used)
> > +			break;
> > +
> > +		if (ops->set_vq_state(mdev, idx, vq->last_avail_idx))
> > +			goto reset;
> 
> 
> If we do set_vq_state() in SET_VRING_BASE, we won't need this step here.

Yeah, I plan to do it in the next version.

> 
> 
> > +
> > +		/*
> > +		 * In vhost-mdev, userspace should pass ring addresses
> > +		 * in guest physical addresses when IOMMU is disabled or
> > +		 * IOVAs when IOMMU is enabled.
> > +		 */
> 
> 
> A question here, consider we're using noiommu mode. If guest physical
> address is passed here, how can a device use that?
> 
> I believe you meant "host physical address" here? And it also have the
> implication that the HPA should be continuous (e.g using hugetlbfs).

The comment is talking about the virtual IOMMU (i.e. iotlb in vhost).
It should be rephrased to cover the noiommu case as well. Thanks for
spotting this.


> > +
> > +	switch (cmd) {
> > +	case VHOST_MDEV_SET_STATE:
> > +		r = vhost_set_state(m, argp);
> > +		break;
> > +	case VHOST_GET_FEATURES:
> > +		r = vhost_get_features(m, argp);
> > +		break;
> > +	case VHOST_SET_FEATURES:
> > +		r = vhost_set_features(m, argp);
> > +		break;
> > +	case VHOST_GET_VRING_BASE:
> > +		r = vhost_get_vring_base(m, argp);
> > +		break;
> 
> 
> Does it mean the SET_VRING_BASE may only take affect after
> VHOST_MEV_SET_STATE?

Yeah, in this version, SET_VRING_BASE won't set the base to the
device directly. But I plan to not delay this anymore in the next
version to support the SET_STATUS.

> 
> 
> > +	default:
> > +		r = vhost_dev_ioctl(&m->dev, cmd, argp);
> > +		if (r == -ENOIOCTLCMD)
> > +			r = vhost_vring_ioctl(&m->dev, cmd, argp);
> > +	}
> > +
> > +	mutex_unlock(&m->mutex);
> > +	return r;
> > +}
> > +
> > +static const struct vfio_device_ops vfio_vhost_mdev_dev_ops = {
> > +	.name		= "vfio-vhost-mdev",
> > +	.open		= vhost_mdev_open,
> > +	.release	= vhost_mdev_release,
> > +	.ioctl		= vhost_mdev_unlocked_ioctl,
> > +};
> > +
> > +static int vhost_mdev_probe(struct device *dev)
> > +{
> > +	struct mdev_device *mdev = mdev_from_dev(dev);
> > +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
> > +	struct vhost_mdev *m;
> > +	int nvqs, r;
> > +
> > +	m = kzalloc(sizeof(*m), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> > +	if (!m)
> > +		return -ENOMEM;
> > +
> > +	mutex_init(&m->mutex);
> > +
> > +	nvqs = ops->get_queue_max(mdev);
> > +	m->nvqs = nvqs;
> 
> 
> The name could be confusing, get_queue_max() is to get the maximum number of
> entries for a virtqueue supported by this device.

OK. It might be better to rename it to something like:

	get_vq_num_max()

which is more consistent with the set_vq_num().

> 
> It looks to me that we need another API to query the maximum number of
> virtqueues supported by the device.

Yeah.

Thanks,
Tiwei


> 
> Thanks
> 
> 
> > +
> > +	m->vqs = kmalloc_array(nvqs, sizeof(struct vhost_virtqueue),
> > +			       GFP_KERNEL);
> > +	if (!m->vqs) {
> > +		r = -ENOMEM;
> > +		goto err;
> > +	}
> > +
> > +	r = vfio_add_group_dev(dev, &vfio_vhost_mdev_dev_ops, m);
> > +	if (r)
> > +		goto err;
> > +
> > +	m->features = ops->get_features(mdev);
> > +	m->mdev = mdev;
> > +	return 0;
> > +
> > +err:
> > +	kfree(m->vqs);
> > +	kfree(m);
> > +	return r;
> > +}
> > +
> > +static void vhost_mdev_remove(struct device *dev)
> > +{
> > +	struct vhost_mdev *m;
> > +
> > +	m = vfio_del_group_dev(dev);
> > +	mutex_destroy(&m->mutex);
> > +	kfree(m->vqs);
> > +	kfree(m);
> > +}
> > +
> > +static struct mdev_class_id id_table[] = {
> > +	{ MDEV_ID_VHOST },
> > +	{ 0 },
> > +};
> > +
> > +static struct mdev_driver vhost_mdev_driver = {
> > +	.name	= "vhost_mdev",
> > +	.probe	= vhost_mdev_probe,
> > +	.remove	= vhost_mdev_remove,
> > +	.id_table = id_table,
> > +};
> > +
> > +static int __init vhost_mdev_init(void)
> > +{
> > +	return mdev_register_driver(&vhost_mdev_driver, THIS_MODULE);
> > +}
> > +module_init(vhost_mdev_init);
> > +
> > +static void __exit vhost_mdev_exit(void)
> > +{
> > +	mdev_unregister_driver(&vhost_mdev_driver);
> > +}
> > +module_exit(vhost_mdev_exit);
> > +
> > +MODULE_VERSION("0.0.1");
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_DESCRIPTION("Mediated device based accelerator for virtio");
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index 40d028eed645..5afbc2f08fa3 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -116,4 +116,12 @@
> >   #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
> >   #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
> > +/* VHOST_MDEV specific defines */
> > +
> > +#define VHOST_MDEV_SET_STATE	_IOW(VHOST_VIRTIO, 0x70, __u64)
> > +
> > +#define VHOST_MDEV_S_STOPPED	0
> > +#define VHOST_MDEV_S_RUNNING	1
> > +#define VHOST_MDEV_S_MAX	2
> > +
> >   #endif
