Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91901F2A34
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 10:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387805AbfKGJIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 04:08:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387786AbfKGJIx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 04:08:53 -0500
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B222D81F0F
        for <netdev@vger.kernel.org>; Thu,  7 Nov 2019 09:08:52 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id x50so1807522qth.4
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 01:08:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y3kSmNPFNr1syqaEwVgmtYdBZ7wSJEKV0NnWLNNW74g=;
        b=F+wYtvpn5dGsMpVotiMm0NEBlqaprLDbIHoShVGTf97zH88px1eNAswOOETOxPq0a1
         vSh0AOHx7um42ohHFnRXJIgkuRsljQ+UJNGRhSL0m6v0j1UiaYaiVUfsJb8QLa6avjBB
         /0ItLaOePdrzsxjaN3afXGYl5XKLFEuhJdJkVcW1qyF/JHSnujUka1xuEawTKnBjJyLJ
         YxUJwjIG1F4FEkYF3v1PIBPt83Y+KvnrMcoq99LKyQADd3LOv6tHgo0o3yKArVg9R/gq
         xAF81RLHwT9PbXs3URUtR3/tBPdbQq6IaN/4J+s0OxbIoDN8pHSQjPZZTl32gtflA6hr
         WSNA==
X-Gm-Message-State: APjAAAUxsbDt7l+QtU1PK27VCxcUl3rrWszNn2s/m2ljJDn0YNljVy1T
        pOg3pIACHJHuRL3xy6sZDANfTD7wMGGUJDCMwL7d2UyqfZqzxcGEEjc4ALSETZmQeb0fqE3fxTh
        Tp0e5fXKXGLuNGutg
X-Received: by 2002:aed:3762:: with SMTP id i89mr2711565qtb.69.1573117731108;
        Thu, 07 Nov 2019 01:08:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqweC4n74z/ghU3aODI0O03qx4TNMZLpGEG3t2lFq0mpTiNcnn1UrlGFUzbl5VMo/050oDK8bw==
X-Received: by 2002:aed:3762:: with SMTP id i89mr2711543qtb.69.1573117730668;
        Thu, 07 Nov 2019 01:08:50 -0800 (PST)
Received: from redhat.com (bzq-79-178-12-128.red.bezeqint.net. [79.178.12.128])
        by smtp.gmail.com with ESMTPSA id c195sm928750qkg.6.2019.11.07.01.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 01:08:49 -0800 (PST)
Date:   Thu, 7 Nov 2019 04:08:37 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, tiwei.bie@intel.com,
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
Subject: Re: [PATCH V10 6/6] docs: sample driver to demonstrate how to
 implement virtio-mdev framework
Message-ID: <20191107040700-mutt-send-email-mst@kernel.org>
References: <20191106133531.693-1-jasowang@redhat.com>
 <20191106133531.693-7-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106133531.693-7-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 09:35:31PM +0800, Jason Wang wrote:
> This sample driver creates mdev device that simulate virtio net device
> over virtio mdev transport. The device is implemented through vringh
> and workqueue. A device specific dma ops is to make sure HVA is used
> directly as the IOVA. This should be sufficient for kernel virtio
> driver to work.
> 
> Only 'virtio' type is supported right now. I plan to add 'vhost' type
> on top which requires some virtual IOMMU implemented in this sample
> driver.
> 
> Acked-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>


I'd prefer it that we call this something else, e.g.
mvnet-loopback. Just so people don't expect a fully
functional device somehow. Can be renamed when applying?


> ---
>  MAINTAINERS                |   1 +
>  samples/Kconfig            |  10 +
>  samples/vfio-mdev/Makefile |   1 +
>  samples/vfio-mdev/mvnet.c  | 686 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 698 insertions(+)
>  create mode 100644 samples/vfio-mdev/mvnet.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4997957443df..6e9ad105a28f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17249,6 +17249,7 @@ F:	include/uapi/linux/virtio_*.h
>  F:	drivers/crypto/virtio/
>  F:	mm/balloon_compaction.c
>  F:	include/linux/mdev_virtio_ops.h
> +F:	samples/vfio-mdev/mvnet.c
>  
>  VIRTIO BLOCK AND SCSI DRIVERS
>  M:	"Michael S. Tsirkin" <mst@redhat.com>
> diff --git a/samples/Kconfig b/samples/Kconfig
> index c8dacb4dda80..13a2443e18e0 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -131,6 +131,16 @@ config SAMPLE_VFIO_MDEV_MDPY
>  	  mediated device.  It is a simple framebuffer and supports
>  	  the region display interface (VFIO_GFX_PLANE_TYPE_REGION).
>  
> +config SAMPLE_VIRTIO_MDEV_NET
> +	tristate "Build VIRTIO net example mediated device sample code -- loadable modules only"
> +	depends on VIRTIO_MDEV && VHOST_RING && m
> +	help
> +	  Build a networking sample device for use as a virtio
> +	  mediated device. The device coopreates with virtio-mdev bus
> +	  driver to present an virtio ethernet driver for
> +	  kernel. It simply loopbacks all packets from its TX
> +	  virtqueue to its RX virtqueue.
> +
>  config SAMPLE_VFIO_MDEV_MDPY_FB
>  	tristate "Build VFIO mdpy example guest fbdev driver -- loadable module only"
>  	depends on FB && m
> diff --git a/samples/vfio-mdev/Makefile b/samples/vfio-mdev/Makefile
> index 10d179c4fdeb..f34af90ed0a0 100644
> --- a/samples/vfio-mdev/Makefile
> +++ b/samples/vfio-mdev/Makefile
> @@ -3,3 +3,4 @@ obj-$(CONFIG_SAMPLE_VFIO_MDEV_MTTY) += mtty.o
>  obj-$(CONFIG_SAMPLE_VFIO_MDEV_MDPY) += mdpy.o
>  obj-$(CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB) += mdpy-fb.o
>  obj-$(CONFIG_SAMPLE_VFIO_MDEV_MBOCHS) += mbochs.o
> +obj-$(CONFIG_SAMPLE_VIRTIO_MDEV_NET) += mvnet.o
> diff --git a/samples/vfio-mdev/mvnet.c b/samples/vfio-mdev/mvnet.c
> new file mode 100644
> index 000000000000..a89aecfab68a
> --- /dev/null
> +++ b/samples/vfio-mdev/mvnet.c
> @@ -0,0 +1,686 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Mediated virtual virtio-net device driver.
> + *
> + * Copyright (c) 2019, Red Hat Inc. All rights reserved.
> + *     Author: Jason Wang <jasowang@redhat.com>
> + *
> + * Sample driver that creates mdev device that simulates ethernet loopback
> + * device.
> + *
> + * Usage:
> + *
> + * # modprobe virtio_mdev
> + * # modprobe mvnet
> + * # cd /sys/devices/virtual/mvnet/mvnet/mdev_supported_types/mvnet-virtio
> + * # echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1001" > ./create
> + * # cd devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
> + * # ls -d virtio0
> + * virtio0
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/fs.h>
> +#include <linux/poll.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/wait.h>
> +#include <linux/uuid.h>
> +#include <linux/iommu.h>
> +#include <linux/sysfs.h>
> +#include <linux/file.h>
> +#include <linux/etherdevice.h>
> +#include <linux/mdev.h>
> +#include <linux/vringh.h>
> +#include <linux/mdev_virtio_ops.h>
> +#include <uapi/linux/virtio_config.h>
> +#include <uapi/linux/virtio_net.h>
> +
> +#define VERSION_STRING  "0.1"
> +#define DRIVER_AUTHOR   "Red Hat Corporation"
> +
> +#define MVNET_CLASS_NAME "mvnet"
> +#define MVNET_NAME       "mvnet"
> +
> +/*
> + * Global Structures
> + */
> +
> +static struct mvnet_dev {
> +	struct class	*vd_class;
> +	struct idr	vd_idr;
> +	struct device	dev;
> +} mvnet_dev;
> +
> +struct mvnet_virtqueue {
> +	struct vringh vring;
> +	struct vringh_kiov iov;
> +	unsigned short head;
> +	bool ready;
> +	u64 desc_addr;
> +	u64 device_addr;
> +	u64 driver_addr;
> +	u32 num;
> +	void *private;
> +	irqreturn_t (*cb)(void *data);
> +};
> +
> +#define MVNET_QUEUE_ALIGN PAGE_SIZE
> +#define MVNET_QUEUE_MAX 256
> +#define MVNET_DEVICE_ID 0x1
> +#define MVNET_VENDOR_ID 0
> +
> +u64 mvnet_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
> +		     (1ULL << VIRTIO_F_VERSION_1) |
> +		     (1ULL << VIRTIO_F_IOMMU_PLATFORM);
> +
> +/* State of each mdev device */
> +struct mvnet_state {
> +	struct mvnet_virtqueue vqs[2];
> +	struct work_struct work;
> +	/* spinlock to synchronize virtqueue state */
> +	spinlock_t lock;
> +	struct mdev_device *mdev;
> +	struct virtio_net_config config;
> +	void *buffer;
> +	u32 status;
> +	u32 generation;
> +	u64 features;
> +	struct list_head next;
> +};
> +
> +static struct mutex mdev_list_lock;
> +static struct list_head mdev_devices_list;
> +
> +static void mvnet_queue_ready(struct mvnet_state *mvnet, unsigned int idx)
> +{
> +	struct mvnet_virtqueue *vq = &mvnet->vqs[idx];
> +	int ret;
> +
> +	ret = vringh_init_kern(&vq->vring, mvnet_features, MVNET_QUEUE_MAX,
> +			       false, (struct vring_desc *)vq->desc_addr,
> +			       (struct vring_avail *)vq->driver_addr,
> +			       (struct vring_used *)vq->device_addr);
> +}
> +
> +static void mvnet_vq_reset(struct mvnet_virtqueue *vq)
> +{
> +	vq->ready = 0;
> +	vq->desc_addr = 0;
> +	vq->driver_addr = 0;
> +	vq->device_addr = 0;
> +	vq->cb = NULL;
> +	vq->private = NULL;
> +	vringh_init_kern(&vq->vring, mvnet_features, MVNET_QUEUE_MAX,
> +			 false, 0, 0, 0);
> +}
> +
> +static void mvnet_reset(struct mvnet_state *mvnet)
> +{
> +	int i;
> +
> +	for (i = 0; i < 2; i++)
> +		mvnet_vq_reset(&mvnet->vqs[i]);
> +
> +	mvnet->features = 0;
> +	mvnet->status = 0;
> +	++mvnet->generation;
> +}
> +
> +static void mvnet_work(struct work_struct *work)
> +{
> +	struct mvnet_state *mvnet = container_of(work, struct
> +						 mvnet_state, work);
> +	struct mvnet_virtqueue *txq = &mvnet->vqs[1];
> +	struct mvnet_virtqueue *rxq = &mvnet->vqs[0];
> +	size_t read, write, total_write;
> +	int err;
> +	int pkts = 0;
> +
> +	spin_lock(&mvnet->lock);
> +
> +	if (!txq->ready || !rxq->ready)
> +		goto out;
> +
> +	while (true) {
> +		total_write = 0;
> +		err = vringh_getdesc_kern(&txq->vring, &txq->iov, NULL,
> +					  &txq->head, GFP_ATOMIC);
> +		if (err <= 0)
> +			break;
> +
> +		err = vringh_getdesc_kern(&rxq->vring, NULL, &rxq->iov,
> +					  &rxq->head, GFP_ATOMIC);
> +		if (err <= 0) {
> +			vringh_complete_kern(&txq->vring, txq->head, 0);
> +			break;
> +		}
> +
> +		while (true) {
> +			read = vringh_iov_pull_kern(&txq->iov, mvnet->buffer,
> +						    PAGE_SIZE);
> +			if (read <= 0)
> +				break;
> +
> +			write = vringh_iov_push_kern(&rxq->iov, mvnet->buffer,
> +						     read);
> +			if (write <= 0)
> +				break;
> +
> +			total_write += write;
> +		}
> +
> +		/* Make sure data is wrote before advancing index */
> +		smp_wmb();
> +
> +		vringh_complete_kern(&txq->vring, txq->head, 0);
> +		vringh_complete_kern(&rxq->vring, rxq->head, total_write);
> +
> +		/* Make sure used is visible before rasing the interrupt. */
> +		smp_wmb();
> +
> +		local_bh_disable();
> +		if (txq->cb)
> +			txq->cb(txq->private);
> +		if (rxq->cb)
> +			rxq->cb(rxq->private);
> +		local_bh_enable();
> +
> +		if (++pkts > 4) {
> +			schedule_work(&mvnet->work);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	spin_unlock(&mvnet->lock);
> +}
> +
> +static dma_addr_t mvnet_map_page(struct device *dev, struct page *page,
> +				 unsigned long offset, size_t size,
> +				 enum dma_data_direction dir,
> +				 unsigned long attrs)
> +{
> +	/* Vringh can only use HVA */
> +	return (dma_addr_t)(page_address(page) + offset);
> +}
> +
> +static void mvnet_unmap_page(struct device *dev, dma_addr_t dma_addr,
> +			     size_t size, enum dma_data_direction dir,
> +			     unsigned long attrs)
> +{
> +}
> +
> +static void *mvnet_alloc_coherent(struct device *dev, size_t size,
> +				  dma_addr_t *dma_addr, gfp_t flag,
> +				  unsigned long attrs)
> +{
> +	void *addr = kmalloc(size, flag);
> +
> +	if (!addr)
> +		*dma_addr = DMA_MAPPING_ERROR;
> +	else
> +		*dma_addr = (dma_addr_t)addr;
> +
> +	return addr;
> +}
> +
> +static void mvnet_free_coherent(struct device *dev, size_t size,
> +				void *vaddr, dma_addr_t dma_addr,
> +				unsigned long attrs)
> +{
> +	kfree((void *)dma_addr);
> +}
> +
> +static const struct dma_map_ops mvnet_dma_ops = {
> +	.map_page = mvnet_map_page,
> +	.unmap_page = mvnet_unmap_page,
> +	.alloc = mvnet_alloc_coherent,
> +	.free = mvnet_free_coherent,
> +};
> +
> +static const struct mdev_virtio_device_ops mdev_virtio_ops;
> +
> +static int mvnet_create(struct kobject *kobj, struct mdev_device *mdev)
> +{
> +	struct mvnet_state *mvnet;
> +	struct virtio_net_config *config;
> +	struct device *dev = mdev_dev(mdev);
> +
> +	if (!mdev)
> +		return -EINVAL;
> +
> +	mvnet = kzalloc(sizeof(*mvnet), GFP_KERNEL);
> +	if (!mvnet)
> +		return -ENOMEM;
> +
> +	mvnet->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!mvnet->buffer) {
> +		kfree(mvnet);
> +		return -ENOMEM;
> +	}
> +
> +	config = &mvnet->config;
> +	config->mtu = 1500;
> +	config->status = VIRTIO_NET_S_LINK_UP;
> +	eth_random_addr(config->mac);
> +
> +	INIT_WORK(&mvnet->work, mvnet_work);
> +
> +	spin_lock_init(&mvnet->lock);
> +	mvnet->mdev = mdev;
> +	mdev_set_drvdata(mdev, mvnet);
> +
> +	mutex_lock(&mdev_list_lock);
> +	list_add(&mvnet->next, &mdev_devices_list);
> +	mutex_unlock(&mdev_list_lock);
> +
> +	dev->coherent_dma_mask = DMA_BIT_MASK(64);
> +	set_dma_ops(dev, &mvnet_dma_ops);
> +
> +	mdev_set_virtio_ops(mdev, &mdev_virtio_ops);
> +
> +	return 0;
> +}
> +
> +static int mvnet_remove(struct mdev_device *mdev)
> +{
> +	struct mvnet_state *mds, *tmp_mds;
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +	int ret = -EINVAL;
> +
> +	mutex_lock(&mdev_list_lock);
> +	list_for_each_entry_safe(mds, tmp_mds, &mdev_devices_list, next) {
> +		if (mvnet == mds) {
> +			list_del(&mvnet->next);
> +			mdev_set_drvdata(mdev, NULL);
> +			kfree(mvnet->buffer);
> +			kfree(mvnet);
> +			ret = 0;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&mdev_list_lock);
> +
> +	return ret;
> +}
> +
> +static ssize_t
> +sample_mvnet_dev_show(struct device *dev, struct device_attribute *attr,
> +		      char *buf)
> +{
> +	if (mdev_from_dev(dev))
> +		return sprintf(buf, "This is MDEV %s\n", dev_name(dev));
> +
> +	return sprintf(buf, "\n");
> +}
> +
> +static DEVICE_ATTR_RO(sample_mvnet_dev);
> +
> +static struct attribute *mvnet_dev_attrs[] = {
> +	&dev_attr_sample_mvnet_dev.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group mvnet_dev_group = {
> +	.name  = "mvnet_dev",
> +	.attrs = mvnet_dev_attrs,
> +};
> +
> +static const struct attribute_group *mvnet_dev_groups[] = {
> +	&mvnet_dev_group,
> +	NULL,
> +};
> +
> +static ssize_t
> +sample_mdev_dev_show(struct device *dev, struct device_attribute *attr,
> +		     char *buf)
> +{
> +	if (mdev_from_dev(dev))
> +		return sprintf(buf, "This is MDEV %s\n", dev_name(dev));
> +
> +	return sprintf(buf, "\n");
> +}
> +
> +static DEVICE_ATTR_RO(sample_mdev_dev);
> +
> +static struct attribute *mdev_dev_attrs[] = {
> +	&dev_attr_sample_mdev_dev.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group mdev_dev_group = {
> +	.name  = "vendor",
> +	.attrs = mdev_dev_attrs,
> +};
> +
> +static const struct attribute_group *mdev_dev_groups[] = {
> +	&mdev_dev_group,
> +	NULL,
> +};
> +
> +#define MVNET_STRING_LEN 16
> +
> +static ssize_t
> +name_show(struct kobject *kobj, struct device *dev, char *buf)
> +{
> +	char name[MVNET_STRING_LEN];
> +	const char *name_str = "virtio-net";
> +
> +	snprintf(name, MVNET_STRING_LEN, "%s", dev_driver_string(dev));
> +	if (!strcmp(kobj->name, name))
> +		return sprintf(buf, "%s\n", name_str);
> +
> +	return -EINVAL;
> +}
> +
> +static MDEV_TYPE_ATTR_RO(name);
> +
> +static ssize_t
> +available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
> +{
> +	return sprintf(buf, "%d\n", INT_MAX);
> +}
> +
> +static MDEV_TYPE_ATTR_RO(available_instances);
> +
> +static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
> +			       char *buf)
> +{
> +	return sprintf(buf, "%s\n", VIRTIO_MDEV_DEVICE_API_STRING);
> +}
> +
> +static MDEV_TYPE_ATTR_RO(device_api);
> +
> +static struct attribute *mdev_types_attrs[] = {
> +	&mdev_type_attr_name.attr,
> +	&mdev_type_attr_device_api.attr,
> +	&mdev_type_attr_available_instances.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group mdev_type_group = {
> +	.name  = "virtio",
> +	.attrs = mdev_types_attrs,
> +};
> +
> +/* TBD: "vhost" type */
> +
> +static struct attribute_group *mdev_type_groups[] = {
> +	&mdev_type_group,
> +	NULL,
> +};
> +
> +static int mvnet_set_vq_address(struct mdev_device *mdev, u16 idx,
> +				u64 desc_area, u64 driver_area, u64 device_area)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +	struct mvnet_virtqueue *vq = &mvnet->vqs[idx];
> +
> +	vq->desc_addr = desc_area;
> +	vq->driver_addr = driver_area;
> +	vq->device_addr = device_area;
> +
> +	return 0;
> +}
> +
> +static void mvnet_set_vq_num(struct mdev_device *mdev, u16 idx, u32 num)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +	struct mvnet_virtqueue *vq = &mvnet->vqs[idx];
> +
> +	vq->num = num;
> +}
> +
> +static void mvnet_kick_vq(struct mdev_device *mdev, u16 idx)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +	struct mvnet_virtqueue *vq = &mvnet->vqs[idx];
> +
> +	if (vq->ready)
> +		schedule_work(&mvnet->work);
> +}
> +
> +static void mvnet_set_vq_cb(struct mdev_device *mdev, u16 idx,
> +			    struct virtio_mdev_callback *cb)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +	struct mvnet_virtqueue *vq = &mvnet->vqs[idx];
> +
> +	vq->cb = cb->callback;
> +	vq->private = cb->private;
> +}
> +
> +static void mvnet_set_vq_ready(struct mdev_device *mdev, u16 idx, bool ready)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +	struct mvnet_virtqueue *vq = &mvnet->vqs[idx];
> +
> +	spin_lock(&mvnet->lock);
> +	vq->ready = ready;
> +	if (vq->ready)
> +		mvnet_queue_ready(mvnet, idx);
> +	spin_unlock(&mvnet->lock);
> +}
> +
> +static bool mvnet_get_vq_ready(struct mdev_device *mdev, u16 idx)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +	struct mvnet_virtqueue *vq = &mvnet->vqs[idx];
> +
> +	return vq->ready;
> +}
> +
> +static int mvnet_set_vq_state(struct mdev_device *mdev, u16 idx, u64 state)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +	struct mvnet_virtqueue *vq = &mvnet->vqs[idx];
> +	struct vringh *vrh = &vq->vring;
> +
> +	spin_lock(&mvnet->lock);
> +	vrh->last_avail_idx = state;
> +	spin_unlock(&mvnet->lock);
> +
> +	return 0;
> +}
> +
> +static u64 mvnet_get_vq_state(struct mdev_device *mdev, u16 idx)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +	struct mvnet_virtqueue *vq = &mvnet->vqs[idx];
> +	struct vringh *vrh = &vq->vring;
> +
> +	return vrh->last_avail_idx;
> +}
> +
> +static u16 mvnet_get_vq_align(struct mdev_device *mdev)
> +{
> +	return MVNET_QUEUE_ALIGN;
> +}
> +
> +static u64 mvnet_get_features(struct mdev_device *mdev)
> +{
> +	return mvnet_features;
> +}
> +
> +static int mvnet_set_features(struct mdev_device *mdev, u64 features)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +
> +	/* DMA mapping must be done by driver */
> +	if (!(features & (1ULL << VIRTIO_F_IOMMU_PLATFORM)))
> +		return -EINVAL;
> +
> +	mvnet->features = features & mvnet_features;
> +
> +	return 0;
> +}
> +
> +static void mvnet_set_config_cb(struct mdev_device *mdev,
> +				struct virtio_mdev_callback *cb)
> +{
> +	/* We don't support config interrupt */
> +}
> +
> +static u16 mvnet_get_vq_num_max(struct mdev_device *mdev)
> +{
> +	return MVNET_QUEUE_MAX;
> +}
> +
> +static u32 mvnet_get_device_id(struct mdev_device *mdev)
> +{
> +	return MVNET_DEVICE_ID;
> +}
> +
> +static u32 mvnet_get_vendor_id(struct mdev_device *mdev)
> +{
> +	return MVNET_VENDOR_ID;
> +}
> +
> +static u8 mvnet_get_status(struct mdev_device *mdev)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +
> +	return mvnet->status;
> +}
> +
> +static void mvnet_set_status(struct mdev_device *mdev, u8 status)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +
> +	mvnet->status = status;
> +
> +	if (status == 0) {
> +		spin_lock(&mvnet->lock);
> +		mvnet_reset(mvnet);
> +		spin_unlock(&mvnet->lock);
> +	}
> +}
> +
> +static void mvnet_get_config(struct mdev_device *mdev, unsigned int offset,
> +			     void *buf, unsigned int len)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +
> +	if (offset + len < sizeof(struct virtio_net_config))
> +		memcpy(buf, &mvnet->config + offset, len);
> +}
> +
> +static void mvnet_set_config(struct mdev_device *mdev, unsigned int offset,
> +			     const void *buf, unsigned int len)
> +{
> +	/* No writable config supportted by mvnet */
> +}
> +
> +static u32 mvnet_get_generation(struct mdev_device *mdev)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +
> +	return mvnet->generation;
> +}
> +
> +static const struct mdev_virtio_device_ops mdev_virtio_ops = {
> +	.set_vq_address         = mvnet_set_vq_address,
> +	.set_vq_num             = mvnet_set_vq_num,
> +	.kick_vq                = mvnet_kick_vq,
> +	.set_vq_cb              = mvnet_set_vq_cb,
> +	.set_vq_ready           = mvnet_set_vq_ready,
> +	.get_vq_ready           = mvnet_get_vq_ready,
> +	.set_vq_state           = mvnet_set_vq_state,
> +	.get_vq_state           = mvnet_get_vq_state,
> +	.get_vq_align           = mvnet_get_vq_align,
> +	.get_features           = mvnet_get_features,
> +	.set_features           = mvnet_set_features,
> +	.set_config_cb          = mvnet_set_config_cb,
> +	.get_vq_num_max         = mvnet_get_vq_num_max,
> +	.get_device_id          = mvnet_get_device_id,
> +	.get_vendor_id          = mvnet_get_vendor_id,
> +	.get_status             = mvnet_get_status,
> +	.set_status             = mvnet_set_status,
> +	.get_config             = mvnet_get_config,
> +	.set_config             = mvnet_set_config,
> +	.get_generation         = mvnet_get_generation,
> +};
> +
> +static const struct mdev_parent_ops mdev_fops = {
> +	.owner                  = THIS_MODULE,
> +	.dev_attr_groups        = mvnet_dev_groups,
> +	.mdev_attr_groups       = mdev_dev_groups,
> +	.supported_type_groups  = mdev_type_groups,
> +	.create                 = mvnet_create,
> +	.remove			= mvnet_remove,
> +};
> +
> +static void mvnet_device_release(struct device *dev)
> +{
> +	dev_dbg(dev, "mvnet: released\n");
> +}
> +
> +static int __init mvnet_dev_init(void)
> +{
> +	int ret = 0;
> +
> +	pr_info("mvnet_dev: %s\n", __func__);
> +
> +	memset(&mvnet_dev, 0, sizeof(mvnet_dev));
> +
> +	idr_init(&mvnet_dev.vd_idr);
> +
> +	mvnet_dev.vd_class = class_create(THIS_MODULE, MVNET_CLASS_NAME);
> +
> +	if (IS_ERR(mvnet_dev.vd_class)) {
> +		pr_err("Error: failed to register mvnet_dev class\n");
> +		ret = PTR_ERR(mvnet_dev.vd_class);
> +		goto failed1;
> +	}
> +
> +	mvnet_dev.dev.class = mvnet_dev.vd_class;
> +	mvnet_dev.dev.release = mvnet_device_release;
> +	dev_set_name(&mvnet_dev.dev, "%s", MVNET_NAME);
> +
> +	ret = device_register(&mvnet_dev.dev);
> +	if (ret)
> +		goto failed2;
> +
> +	ret = mdev_register_device(&mvnet_dev.dev, &mdev_fops);
> +	if (ret)
> +		goto failed3;
> +
> +	mutex_init(&mdev_list_lock);
> +	INIT_LIST_HEAD(&mdev_devices_list);
> +
> +	goto all_done;
> +
> +failed3:
> +
> +	device_unregister(&mvnet_dev.dev);
> +failed2:
> +	class_destroy(mvnet_dev.vd_class);
> +
> +failed1:
> +all_done:
> +	return ret;
> +}
> +
> +static void __exit mvnet_dev_exit(void)
> +{
> +	mvnet_dev.dev.bus = NULL;
> +	mdev_unregister_device(&mvnet_dev.dev);
> +
> +	device_unregister(&mvnet_dev.dev);
> +	idr_destroy(&mvnet_dev.vd_idr);
> +	class_destroy(mvnet_dev.vd_class);
> +	mvnet_dev.vd_class = NULL;
> +	pr_info("mvnet_dev: Unloaded!\n");
> +}
> +
> +module_init(mvnet_dev_init)
> +module_exit(mvnet_dev_exit)
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_INFO(supported, "Simulate loopback ethernet device over mdev");
> +MODULE_VERSION(VERSION_STRING);
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> -- 
> 2.19.1
