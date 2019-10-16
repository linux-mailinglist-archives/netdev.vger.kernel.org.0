Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 708A3D8DB8
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392331AbfJPKUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 06:20:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40510 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729634AbfJPKUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 06:20:16 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EBE7510CC20C;
        Wed, 16 Oct 2019 10:20:15 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75DE15D6B2;
        Wed, 16 Oct 2019 10:19:33 +0000 (UTC)
Subject: Re: [RFC 2/2] vhost: IFC VF vdpa layer
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016013050.3918-1-lingshan.zhu@intel.com>
 <20191016013050.3918-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9495331d-3c65-6f49-dcd9-bfdb17054cf0@redhat.com>
Date:   Wed, 16 Oct 2019 18:19:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191016013050.3918-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Wed, 16 Oct 2019 10:20:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/16 上午9:30, Zhu Lingshan wrote:
> This commit introduced IFC VF operations for vdpa, which complys to
> vhost_mdev interfaces, handles IFC VF initialization,
> configuration and removal.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vhost/ifcvf/ifcvf_main.c | 541 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 541 insertions(+)
>   create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c
>
> diff --git a/drivers/vhost/ifcvf/ifcvf_main.c b/drivers/vhost/ifcvf/ifcvf_main.c
> new file mode 100644
> index 000000000000..c48a29969a85
> --- /dev/null
> +++ b/drivers/vhost/ifcvf/ifcvf_main.c
> @@ -0,0 +1,541 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2019 Intel Corporation.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/mdev.h>
> +#include <linux/pci.h>
> +#include <linux/sysfs.h>
> +
> +#include "ifcvf_base.h"
> +
> +#define VERSION_STRING	"0.1"
> +#define DRIVER_AUTHOR	"Intel Corporation"
> +#define IFCVF_DRIVER_NAME	"ifcvf"
> +
> +static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
> +{
> +	struct vring_info *vring = arg;
> +
> +	if (vring->cb.callback)
> +		return vring->cb.callback(vring->cb.private);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static u64 ifcvf_mdev_get_features(struct mdev_device *mdev)
> +{
> +	return IFC_SUPPORTED_FEATURES;


I would expect this should be done by querying the hw. Or IFC VF can't 
get any update through its firmware?


> +}
> +
> +static int ifcvf_mdev_set_features(struct mdev_device *mdev, u64 features)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->req_features = features;
> +
> +	return 0;
> +}
> +
> +static u64 ifcvf_mdev_get_vq_state(struct mdev_device *mdev, u16 qid)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	return vf->vring[qid].last_avail_idx;


Does this really work? I'd expect it should be fetched from hw since 
it's an internal state.


> +}
> +
> +static int ifcvf_mdev_set_vq_state(struct mdev_device *mdev, u16 qid, u64 num)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->vring[qid].last_used_idx = num;


I fail to understand why last_used_idx is needed. It looks to me the 
used idx in the used ring is sufficient.


> +	vf->vring[qid].last_avail_idx = num;


Do we need a synchronization with hw immediately here?


> +
> +	return 0;
> +}
> +
> +static int ifcvf_mdev_set_vq_address(struct mdev_device *mdev, u16 idx,
> +				     u64 desc_area, u64 driver_area,
> +				     u64 device_area)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->vring[idx].desc = desc_area;
> +	vf->vring[idx].avail = driver_area;
> +	vf->vring[idx].used = device_area;
> +
> +	return 0;
> +}
> +
> +static void ifcvf_mdev_set_vq_num(struct mdev_device *mdev, u16 qid, u32 num)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->vring[qid].size = num;
> +}
> +
> +static void ifcvf_mdev_set_vq_ready(struct mdev_device *mdev,
> +				u16 qid, bool ready)
> +{
> +
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->vring[qid].ready = ready;
> +}
> +
> +static bool ifcvf_mdev_get_vq_ready(struct mdev_device *mdev, u16 qid)
> +{
> +
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	return vf->vring[qid].ready;
> +}
> +
> +static void ifcvf_mdev_set_vq_cb(struct mdev_device *mdev, u16 idx,
> +				 struct virtio_mdev_callback *cb)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->vring[idx].cb = *cb;
> +}
> +
> +static void ifcvf_mdev_kick_vq(struct mdev_device *mdev, u16 idx)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	ifcvf_notify_queue(vf, idx);
> +}
> +
> +static u8 ifcvf_mdev_get_status(struct mdev_device *mdev)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	return vf->status;
> +}
> +
> +static u32 ifcvf_mdev_get_generation(struct mdev_device *mdev)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	return vf->generation;
> +}
> +
> +static int ifcvf_mdev_get_version(struct mdev_device *mdev)
> +{
> +	return VIRTIO_MDEV_VERSION;
> +}
> +
> +static u32 ifcvf_mdev_get_device_id(struct mdev_device *mdev)
> +{
> +	return IFCVF_DEVICE_ID;
> +}
> +
> +static u32 ifcvf_mdev_get_vendor_id(struct mdev_device *mdev)
> +{
> +	return IFCVF_VENDOR_ID;
> +}
> +
> +static u16 ifcvf_mdev_get_vq_align(struct mdev_device *mdev)
> +{
> +	return IFCVF_QUEUE_ALIGNMENT;
> +}
> +
> +static int ifcvf_start_datapath(void *private)
> +{
> +	int i, ret;
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(private);
> +
> +	for (i = 0; i < (IFCVF_MAX_QUEUE_PAIRS * 2); i++) {
> +		if (!vf->vring[i].ready)
> +			break;


Looks like error should be returned here?


> +
> +		if (!vf->vring[i].size)
> +			break;
> +
> +		if (!vf->vring[i].desc || !vf->vring[i].avail ||
> +			!vf->vring[i].used)
> +			break;
> +	}
> +	vf->nr_vring = i;
> +
> +	ret = ifcvf_start_hw(vf);
> +	return ret;
> +}
> +
> +static int ifcvf_stop_datapath(void *private)
> +{
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(private);
> +	int i;
> +
> +	for (i = 0; i < IFCVF_MAX_QUEUES; i++)
> +		vf->vring[i].cb.callback = NULL;


Any synchronization is needed for the vq irq handler?


> +
> +	ifcvf_stop_hw(vf);
> +
> +	return 0;
> +}
> +
> +static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
> +{
> +	int i;
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +		vf->vring[i].last_used_idx = 0;
> +		vf->vring[i].last_avail_idx = 0;
> +		vf->vring[i].desc = 0;
> +		vf->vring[i].avail = 0;
> +		vf->vring[i].used = 0;
> +		vf->vring[i].ready = 0;
> +		vf->vring->cb.callback = NULL;
> +		vf->vring->cb.private = NULL;
> +	}
> +}
> +
> +static void ifcvf_mdev_set_status(struct mdev_device *mdev, u8 status)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->status = status;
> +
> +	if (status == 0) {
> +		ifcvf_stop_datapath(adapter);
> +		ifcvf_reset_vring(adapter);
> +		return;
> +	}
> +
> +	if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
> +		ifcvf_start_datapath(adapter);
> +		return;
> +	}
> +}
> +
> +static u16 ifcvf_mdev_get_queue_max(struct mdev_device *mdev)
> +{
> +	return IFCVF_MAX_QUEUES;


The name is confusing, it was used to return the maximum queue size. In 
new version of virtio-mdev, the callback was renamed as get_vq_num_max().


> +}
> +
> +static struct virtio_mdev_device_ops ifc_mdev_ops = {
> +	.get_features  = ifcvf_mdev_get_features,
> +	.set_features  = ifcvf_mdev_set_features,
> +	.get_status    = ifcvf_mdev_get_status,
> +	.set_status    = ifcvf_mdev_set_status,
> +	.get_queue_max = ifcvf_mdev_get_queue_max,
> +	.get_vq_state   = ifcvf_mdev_get_vq_state,
> +	.set_vq_state   = ifcvf_mdev_set_vq_state,
> +	.set_vq_cb      = ifcvf_mdev_set_vq_cb,
> +	.set_vq_ready   = ifcvf_mdev_set_vq_ready,
> +	.get_vq_ready	= ifcvf_mdev_get_vq_ready,
> +	.set_vq_num     = ifcvf_mdev_set_vq_num,
> +	.set_vq_address = ifcvf_mdev_set_vq_address,
> +	.kick_vq        = ifcvf_mdev_kick_vq,
> +	.get_generation	= ifcvf_mdev_get_generation,
> +	.get_version	= ifcvf_mdev_get_version,
> +	.get_device_id	= ifcvf_mdev_get_device_id,
> +	.get_vendor_id	= ifcvf_mdev_get_vendor_id,
> +	.get_vq_align	= ifcvf_mdev_get_vq_align,
> +};


set_config/get_config is missing. It looks to me they are not hard, just 
implementing the access to dev_cfg. It's key to make kernel virtio 
driver to work.

And in the new version of virito-mdev, features like _F_LOG_ALL should 
be advertised through get_mdev_features.


> +
> +static int ifcvf_init_msix(struct ifcvf_adapter *adapter)
> +{
> +	int vector, i, ret, irq;
> +	struct pci_dev *pdev = to_pci_dev(adapter->dev);
> +	struct ifcvf_hw *vf = &adapter->vf;
> +
> +	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
> +			IFCVF_MAX_INTR, PCI_IRQ_MSIX);
> +	if (ret < 0) {
> +		IFC_ERR(adapter->dev, "Failed to alloc irq vectors.\n");
> +		return ret;
> +	}
> +
> +	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +		vector = i + IFCVF_MSI_QUEUE_OFF;
> +		irq = pci_irq_vector(pdev, vector);
> +		ret = request_irq(irq, ifcvf_intr_handler, 0,
> +				pci_name(pdev), &vf->vring[i]);
> +		if (ret) {
> +			IFC_ERR(adapter->dev,
> +				"Failed to request irq for vq %d.\n", i);
> +			return ret;
> +		}
> +	}


Do we need to provide fallback when we can't do per vq MSIX?


> +
> +	return 0;
> +}
> +
> +static void ifcvf_destroy_adapter(struct ifcvf_adapter *adapter)
> +{
> +	int i, vector, irq;
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +	struct pci_dev *pdev = to_pci_dev(adapter->dev);
> +
> +	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +		vector = i + IFCVF_MSI_QUEUE_OFF;
> +		irq = pci_irq_vector(pdev, vector);
> +		free_irq(irq, &vf->vring[i]);
> +	}
> +}
> +
> +static ssize_t name_show(struct kobject *kobj, struct device *dev, char *buf)
> +{
> +	const char *name = "vhost accelerator (virtio ring compatible)";
> +
> +	return sprintf(buf, "%s\n", name);
> +}
> +MDEV_TYPE_ATTR_RO(name);
> +
> +static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
> +			       char *buf)
> +{
> +	return sprintf(buf, "%s\n", VIRTIO_MDEV_DEVICE_API_STRING);
> +}
> +MDEV_TYPE_ATTR_RO(device_api);
> +
> +static ssize_t available_instances_show(struct kobject *kobj,
> +					struct device *dev, char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n", adapter->mdev_count);
> +}
> +
> +MDEV_TYPE_ATTR_RO(available_instances);
> +
> +static ssize_t type_show(struct kobject *kobj,
> +			struct device *dev, char *buf)
> +{
> +	return sprintf(buf, "%s\n", "net");
> +}
> +
> +MDEV_TYPE_ATTR_RO(type);
> +
> +
> +static struct attribute *mdev_types_attrs[] = {
> +	&mdev_type_attr_name.attr,
> +	&mdev_type_attr_device_api.attr,
> +	&mdev_type_attr_available_instances.attr,
> +	&mdev_type_attr_type.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group mdev_type_group = {
> +	.name  = "vdpa_virtio",


To be consistent, it should be "vhost" or "virtio".


> +	.attrs = mdev_types_attrs,
> +};
> +
> +static struct attribute_group *mdev_type_groups[] = {
> +	&mdev_type_group,
> +	NULL,
> +};
> +
> +const struct attribute_group *mdev_dev_groups[] = {
> +	NULL,
> +};
> +
> +static int ifcvf_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
> +{
> +	struct device *dev = mdev_parent_dev(mdev);
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
> +	int ret = 0;
> +
> +	mutex_lock(&adapter->mdev_lock);
> +
> +	if (adapter->mdev_count < 1) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	mdev_set_class_id(mdev, MDEV_ID_VHOST);
> +	mdev_set_dev_ops(mdev, &ifc_mdev_ops);
> +
> +	mdev_set_drvdata(mdev, adapter);
> +	mdev_set_iommu_device(mdev_dev(mdev), dev);
> +
> +	INIT_LIST_HEAD(&adapter->dma_maps);
> +	adapter->mdev_count--;
> +
> +out:
> +	mutex_unlock(&adapter->mdev_lock);
> +	return ret;
> +}
> +
> +static int ifcvf_mdev_remove(struct mdev_device *mdev)
> +{
> +	struct device *dev = mdev_parent_dev(mdev);
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
> +
> +	mutex_lock(&adapter->mdev_lock);
> +	adapter->mdev_count++;
> +	mutex_unlock(&adapter->mdev_lock);
> +
> +	return 0;
> +}
> +
> +static struct mdev_parent_ops ifcvf_mdev_fops = {
> +	.owner			= THIS_MODULE,
> +	.supported_type_groups	= mdev_type_groups,
> +	.mdev_attr_groups	= mdev_dev_groups,
> +	.create			= ifcvf_mdev_create,
> +	.remove			= ifcvf_mdev_remove,
> +};
> +
> +static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ifcvf_adapter *adapter;
> +	struct ifcvf_hw *vf;
> +	int ret, i;
> +
> +	adapter = kzalloc(sizeof(struct ifcvf_adapter), GFP_KERNEL);
> +	if (adapter == NULL) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	mutex_init(&adapter->mdev_lock);
> +	adapter->mdev_count = 1;


So this is per VF based vDPA implementation, which seems not convenient 
for management.  Anyhow we can control the creation in PF?

Thanks


> +	adapter->dev = dev;
> +
> +	pci_set_drvdata(pdev, adapter);
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		IFC_ERR(adapter->dev, "Failed to enable device.\n");
> +		goto free_adapter;
> +	}
> +
> +	ret = pci_request_regions(pdev, IFCVF_DRIVER_NAME);
> +	if (ret) {
> +		IFC_ERR(adapter->dev, "Failed to request MMIO region.\n");
> +		goto disable_device;
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	ret = ifcvf_init_msix(adapter);
> +	if (ret) {
> +		IFC_ERR(adapter->dev, "Failed to initialize MSIX.\n");
> +		goto free_msix;
> +	}
> +
> +	vf = &adapter->vf;
> +	for (i = 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
> +		vf->mem_resource[i].phys_addr = pci_resource_start(pdev, i);
> +		vf->mem_resource[i].len = pci_resource_len(pdev, i);
> +		if (!vf->mem_resource[i].len) {
> +			vf->mem_resource[i].addr = NULL;
> +			continue;
> +		}
> +
> +		vf->mem_resource[i].addr = pci_iomap_range(pdev, i, 0,
> +				vf->mem_resource[i].len);
> +		if (!vf->mem_resource[i].addr) {
> +			IFC_ERR(adapter->dev, "Failed to map IO resource %d\n",
> +				i);
> +			return -1;
> +		}
> +	}
> +
> +	if (ifcvf_init_hw(vf, pdev) < 0)
> +		return -1;
> +
> +	ret = mdev_register_device(dev, &ifcvf_mdev_fops);
> +	if (ret) {
> +		IFC_ERR(adapter->dev,  "Failed to register mdev device\n");
> +		goto destroy_adapter;
> +	}
> +
> +	return 0;
> +
> +destroy_adapter:
> +	ifcvf_destroy_adapter(adapter);
> +free_msix:
> +	pci_free_irq_vectors(pdev);
> +	pci_release_regions(pdev);
> +disable_device:
> +	pci_disable_device(pdev);
> +free_adapter:
> +	kfree(adapter);
> +fail:
> +	return ret;
> +}
> +
> +static void ifcvf_remove(struct pci_dev *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
> +	struct ifcvf_hw *vf;
> +	int i;
> +
> +	mdev_unregister_device(dev);
> +
> +	vf = &adapter->vf;
> +	for (i = 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
> +		if (vf->mem_resource[i].addr) {
> +			pci_iounmap(pdev, vf->mem_resource[i].addr);
> +			vf->mem_resource[i].addr = NULL;
> +		}
> +	}
> +
> +	ifcvf_destroy_adapter(adapter);
> +	pci_free_irq_vectors(pdev);
> +
> +	pci_release_regions(pdev);
> +	pci_disable_device(pdev);
> +
> +	kfree(adapter);
> +}
> +
> +static struct pci_device_id ifcvf_pci_ids[] = {
> +	{ PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
> +			IFCVF_DEVICE_ID,
> +			IFCVF_SUBSYS_VENDOR_ID,
> +			IFCVF_SUBSYS_DEVICE_ID) },
> +	{ 0 },
> +};
> +MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);
> +
> +static struct pci_driver ifcvf_driver = {
> +	.name     = IFCVF_DRIVER_NAME,
> +	.id_table = ifcvf_pci_ids,
> +	.probe    = ifcvf_probe,
> +	.remove   = ifcvf_remove,
> +};
> +
> +static int __init ifcvf_init_module(void)
> +{
> +	int ret;
> +
> +	ret = pci_register_driver(&ifcvf_driver);
> +	return ret;
> +}
> +
> +static void __exit ifcvf_exit_module(void)
> +{
> +	pci_unregister_driver(&ifcvf_driver);
> +}
> +
> +module_init(ifcvf_init_module);
> +module_exit(ifcvf_exit_module);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_VERSION(VERSION_STRING);
> +MODULE_AUTHOR(DRIVER_AUTHOR);
