Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F53F8B26
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 09:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfKLIyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 03:54:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:3916 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbfKLIyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 03:54:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 00:54:10 -0800
X-IronPort-AV: E=Sophos;i="5.68,295,1569308400"; 
   d="scan'208";a="198008723"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.238.129.48]) ([10.238.129.48])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 12 Nov 2019 00:54:07 -0800
Subject: Re: [PATCH 2/2] IFC VDPA layer
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, alex williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan daly <dan.daly@intel.com>,
        cunming liang <cunming.liang@intel.com>,
        tiwei bie <tiwei.bie@intel.com>,
        jason zeng <jason.zeng@intel.com>
References: <1572946660-26265-1-git-send-email-lingshan.zhu@intel.com>
 <1572946660-26265-3-git-send-email-lingshan.zhu@intel.com>
 <567342941.12778452.1573036792388.JavaMail.zimbra@redhat.com>
 <2715a1af-486b-5b9e-580b-a13de5ee826d@linux.intel.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <bbe3097f-ab19-ed97-72d2-acf01f04118e@linux.intel.com>
Date:   Tue, 12 Nov 2019 16:54:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <2715a1af-486b-5b9e-580b-a13de5ee826d@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/8/2019 8:46 PM, Zhu Lingshan wrote:
>
> On 11/6/2019 6:39 PM, Jason Wang wrote:
>>
>> ----- Original Message -----
>>> This commit introduced IFC operations for vdpa, which complys to
>>> virtio_mdev and vhost_mdev interfaces, handles IFC VF
>>> initialization, configuration and removal.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vhost/ifcvf/ifcvf_main.c | 605
>>>   +++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 605 insertions(+)
>>>   create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c
>>>
>>> diff --git a/drivers/vhost/ifcvf/ifcvf_main.c
>>> b/drivers/vhost/ifcvf/ifcvf_main.c
>>> new file mode 100644
>>> index 0000000..7165457
>>> --- /dev/null
>>> +++ b/drivers/vhost/ifcvf/ifcvf_main.c
>>> @@ -0,0 +1,605 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Copyright (C) 2019 Intel Corporation.
>>> + */
>>> +
>>> +#include <linux/interrupt.h>
>>> +#include <linux/module.h>
>>> +#include <linux/mdev.h>
>>> +#include <linux/pci.h>
>>> +#include <linux/sysfs.h>
>>> +#include "ifcvf_base.h"
>>> +
>>> +#define VERSION_STRING    "0.1"
>>> +#define DRIVER_AUTHOR    "Intel Corporation"
>>> +#define IFCVF_DRIVER_NAME    "ifcvf"
>>> +
>>> +static struct ifcvf_hw *mdev_to_vf(struct mdev_device *mdev)
>>> +{
>>> +    struct ifcvf_asapter *adapter = mdev_get_drvdata(mdev);
>>> +    struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +    return vf;
>>> +}
>>> +
>>> +static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
>>> +{
>>> +    struct vring_info *vring = arg;
>>> +
>>> +    if (vring->cb.callback)
>>> +        return vring->cb.callback(vring->cb.private);
>>> +
>>> +    return IRQ_HANDLED;
>>> +}
>>> +
>>> +static u64 ifcvf_mdev_get_features(struct mdev_device *mdev)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    return ifcvf_get_features(vf);
>>> +}
>>> +
>>> +static int ifcvf_mdev_set_features(struct mdev_device *mdev, u64 
>>> features)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    vf->req_features = features;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static u64 ifcvf_mdev_get_vq_state(struct mdev_device *mdev, u16 qid)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +    u16 last_avail_idx;
>>> +
>>> +    last_avail_idx = *(u16 *)(vf->lm_cfg + 
>>> IFCVF_LM_RING_STATE_OFFSET +
>>> +             (qid / 2) * IFCVF_LM_CFG_SIZE + (qid % 2) * 4);
>>> +
>> Similar to the comment of previous patch, it's better to have a
>> structure for lm_cfg.
>
> Hello Jason,
>
> Thanks for your comments!
>
> Now I use an variable for the address, and iowrite() for portable 
> purpose.
>
>>> +    return last_avail_idx;
>>> +}
>>> +
>>> +static int ifcvf_mdev_set_vq_state(struct mdev_device *mdev, u16 
>>> qid, u64
>>> num)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    vf->vring[qid].last_avail_idx = num;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int ifcvf_mdev_set_vq_address(struct mdev_device *mdev, u16 
>>> idx,
>>> +                     u64 desc_area, u64 driver_area,
>>> +                     u64 device_area)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    vf->vring[idx].desc = desc_area;
>>> +    vf->vring[idx].avail = driver_area;
>>> +    vf->vring[idx].used = device_area;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static void ifcvf_mdev_set_vq_num(struct mdev_device *mdev, u16 
>>> qid, u32
>>> num)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    vf->vring[qid].size = num;
>>> +}
>>> +
>>> +static void ifcvf_mdev_set_vq_ready(struct mdev_device *mdev,
>>> +                    u16 qid, bool ready)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    vf->vring[qid].ready = ready;
>> There should be a "iowrite16(1, &cfg->queue_enable)" here. And there's
>> probably no need to store ready in vring in this case.
> Yes
>>
>>> +}
>>> +
>>> +static bool ifcvf_mdev_get_vq_ready(struct mdev_device *mdev, u16 qid)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    return vf->vring[qid].ready;
>> And the status should be read from cfg->queue_enable.
> Yes
>>
>>> +}
>>> +
>>> +static void ifcvf_mdev_set_vq_cb(struct mdev_device *mdev, u16 idx,
>>> +                 struct virtio_mdev_callback *cb)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    vf->vring[idx].cb = *cb;
>>> +}
>>> +
>>> +static void ifcvf_mdev_kick_vq(struct mdev_device *mdev, u16 idx)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    ifcvf_notify_queue(vf, idx);
>>> +}
>>> +
>>> +static u8 ifcvf_mdev_get_status(struct mdev_device *mdev)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    return ifcvf_get_status(vf);
>>> +}
>>> +
>>> +static u32 ifcvf_mdev_get_generation(struct mdev_device *mdev)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    return ioread8(&vf->common_cfg->config_generation);
>>> +}
>>> +
>>> +static u32 ifcvf_mdev_get_device_id(struct mdev_device *mdev)
>>> +{
>>> +    return VIRTIO_ID_NET;
>>> +}
>>> +
>>> +static u32 ifcvf_mdev_get_vendor_id(struct mdev_device *mdev)
>>> +{
>>> +    return IFCVF_VENDOR_ID;
>>> +}
>>> +
>>> +static u16 ifcvf_mdev_get_vq_align(struct mdev_device *mdev)
>>> +{
>>> +    return IFCVF_QUEUE_ALIGNMENT;
>>> +}
>>> +
>>> +static u64 ifcvf_mdev_get_mdev_features(struct mdev_device *mdev)
>>> +{
>>> +    return VIRTIO_MDEV_F_VERSION_1;
>>> +}
>> We've decide to remove this API.
> Removed.
>>
>>> +
>>> +static int ifcvf_start_datapath(void *private)
>>> +{
>>> +    struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(private);
>>> +    struct ifcvf_adapter *ifcvf;
>>> +    int i, ret = 0;
>>> +
>>> +    ifcvf = container_of(vf, struct ifcvf_adapter, vf);
>>> +
>>> +    for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
>>> +        if (!vf->vring[i].ready) {
>>> +            IFC_ERR(ifcvf->dev,
>>> +                "Failed to start datapath, vring %d not ready.\n", i);
>>> +            return -EINVAL;
>>> +        }
>> This should be not related. Driver can choose to not start a virtqueue.
> removed the codes.
>>
>>> +
>>> +        if (!vf->vring[i].size) {
>>> +            IFC_ERR(ifcvf->dev,
>>> +                "Failed to start datapath, vring %d size is 
>>> zero.\n", i);
>>> +            return -EINVAL;
>>> +        }
>>> +
>>> +        if (!vf->vring[i].desc || !vf->vring[i].avail ||
>>> +            !vf->vring[i].used) {
>>> +            IFC_ERR(ifcvf->dev,
>>> +                "Failed to start datapath, "
>>> +                "invaild value for vring %d desc,"
>>> +                "avail_idx or usex_idx.\n", i);
>>> +            return -EINVAL;
>>> +        }
>>> +    }
>>> +
>>> +    vf->nr_vring = i;
>>> +    ret = ifcvf_start_hw(vf);
>> So basically there's no need for ifcvf_start_hw() to care about vq
>> enablement, virtio core will take care of that through set_vq_ready().
> Agreed, however if we don't enable the queue, I observe the hardware 
> will not allow access to the queue, even reading something.

Hello Jason,

IMHO, I think maybe we can keep using vring.ready. If upper layer want 
to enable the queue, it can call set_vq_ready to mark it as "ready", 
then ifcvf_hw_enable() will enable all queues marked as "ready"(I added 
some code there), this can give control to upper layer as well.

THanks!

>
>>
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int ifcvf_stop_datapath(void *private)
>>> +{
>>> +    struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(private);
>>> +    int i;
>>> +
>>> +    for (i = 0; i < IFCVF_MAX_QUEUES; i++)
>>> +        vf->vring[i].cb.callback = NULL;
>>> +
>>> +    ifcvf_stop_hw(vf);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
>>> +{
>>> +    struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
>>> +    struct virtio_pci_common_cfg *cfg;
>>> +    u8 *lm_cfg;
>>> +    int i;
>>> +
>>> +    cfg = vf->common_cfg;
>>> +    lm_cfg = vf->lm_cfg;
>>> +
>>> +    for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
>>> +        vf->vring[i].last_used_idx = 0;
>>> +        vf->vring[i].last_avail_idx = 0;
>>> +        vf->vring[i].desc = 0;
>>> +        vf->vring[i].avail = 0;
>>> +        vf->vring[i].used = 0;
>>> +        vf->vring[i].ready = 0;
>>> +        vf->vring->cb.callback = NULL;
>>> +        vf->vring->cb.private = NULL;
>>> +
>>> +    }
>>> +
>>> +    ifcvf_reset(vf);
>> So virtio-pci call vp_synchornize_vectors(), do need someting similar
>> here (I mean in ifcvf_reset())?
> Hardware handles most of the reset stuff, when reset the VF, we did 
> not free irqs, the handler still working, so the on-flight irqs can be 
> handled.
>>
>>> +}
>>> +
>>> +static void ifcvf_mdev_set_status(struct mdev_device *mdev, u8 status)
>>> +{
>>> +    struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
>>> +    struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
>>> +    int ret = 0;
>>> +
>>> +    if (status == 0) {
>>> +        ifcvf_stop_datapath(adapter);
>>> +        ifcvf_reset_vring(adapter);
>>> +        return;
>>> +    }
>>> +
>>> +    if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
>>> +        ret = ifcvf_start_datapath(adapter);
>> If device support VIRTIO_CONFIG_S_DRIVER_OK, having something like
>> start_datapath here looks wired.
>>
>> If it just to setup the virtqueue etc, can we simply move them to e.g
>> set_vq_num, set_vq_address, etc?
> IMHO, it does not just setup vqs, it also do some config and enabling 
> works for the whole VF.
>>
>>> +
>>> +        if (ret)
>>> +            IFC_ERR(adapter->dev, "Failed to set mdev status %u.\n",
>>> +                status);
>>> +    }
>>> +
>>> +    ifcvf_set_status(vf, status);
>>> +}
>>> +
>>> +static u16 ifcvf_mdev_get_vq_num_max(struct mdev_device *mdev)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    return vf->vring[0].size;
>> It looks to me the only case that size is set is from
>> ifcvf_mdev_set_vq_num()? So I don't get how is this supposed to
>> work. I belive this should be a query for the hardware or a at least a
>> macro?
> Fixed.
>>
>>> +}
>>> +static void ifcvf_mdev_get_config(struct mdev_device *mdev, 
>>> unsigned int
>>> offset,
>>> +                 void *buf, unsigned int len)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    WARN_ON(offset + len > sizeof(struct ifcvf_net_config));
>>> +    ifcvf_read_net_config(vf, offset, buf, len);
>>> +}
>>> +
>>> +static void ifcvf_mdev_set_config(struct mdev_device *mdev, 
>>> unsigned int
>>> offset,
>>> +                 const void *buf, unsigned int len)
>>> +{
>>> +    struct ifcvf_hw *vf = mdev_to_vf(mdev);
>>> +
>>> +    WARN_ON(offset + len > sizeof(struct ifcvf_net_config));
>>> +    ifcvf_write_net_config(vf, offset, buf, len);
>>> +}
>>> +
>>> +static struct virtio_mdev_device_ops ifc_mdev_ops = {
>>> +    .get_features  = ifcvf_mdev_get_features,
>>> +    .set_features  = ifcvf_mdev_set_features,
>>> +    .get_status    = ifcvf_mdev_get_status,
>>> +    .set_status    = ifcvf_mdev_set_status,
>>> +    .get_vq_num_max = ifcvf_mdev_get_vq_num_max,
>>> +    .get_vq_state   = ifcvf_mdev_get_vq_state,
>>> +    .set_vq_state   = ifcvf_mdev_set_vq_state,
>>> +    .set_vq_cb      = ifcvf_mdev_set_vq_cb,
>>> +    .set_vq_ready   = ifcvf_mdev_set_vq_ready,
>>> +    .get_vq_ready    = ifcvf_mdev_get_vq_ready,
>>> +    .set_vq_num     = ifcvf_mdev_set_vq_num,
>>> +    .set_vq_address = ifcvf_mdev_set_vq_address,
>>> +    .kick_vq        = ifcvf_mdev_kick_vq,
>>> +    .get_generation    = ifcvf_mdev_get_generation,
>>> +    .get_device_id    = ifcvf_mdev_get_device_id,
>>> +    .get_vendor_id    = ifcvf_mdev_get_vendor_id,
>>> +    .get_vq_align    = ifcvf_mdev_get_vq_align,
>>> +    .get_config    = ifcvf_mdev_get_config,
>>> +    .set_config    = ifcvf_mdev_set_config,
>>> +    .get_mdev_features = ifcvf_mdev_get_mdev_features,
>> set_config_cb needs to be implemented since you claim to support 
>> VIRTIO_NET_F_STATUS.
> control_vq feature bit is removed.
>>
>>> +};
>>> +
>>> +static int ifcvf_init_msix(struct ifcvf_adapter *adapter)
>>> +{
>>> +    struct pci_dev *pdev = to_pci_dev(adapter->dev);
>>> +    struct ifcvf_hw *vf = &adapter->vf;
>>> +    int vector, i, ret, irq;
>>> +
>>> +    ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
>>> +                    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
>>> +    if (ret < 0) {
>>> +        IFC_ERR(adapter->dev, "Failed to alloc irq vectors.\n");
>>> +        return ret;
>>> +    }
>>> +
>>> +    for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
>>> +        vector = i + IFCVF_MSI_QUEUE_OFF;
>>> +        irq = pci_irq_vector(pdev, vector);
>>> +        ret = request_irq(irq, ifcvf_intr_handler, 0,
>>> +                pci_name(pdev), &vf->vring[i]);
>>> +        if (ret) {
>>> +            IFC_ERR(adapter->dev,
>>> +                "Failed to request irq for vq %d.\n", i);
>>> +            return ret;
>>> +        }
>>> +    }
>> Need allocate config interrupt here as well.
>>
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static void ifcvf_destroy_adapter(struct ifcvf_adapter *adapter)
>>> +{
>>> +    struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
>>> +    struct pci_dev *pdev = to_pci_dev(adapter->dev);
>>> +    int i, vector, irq;
>>> +
>>> +    for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
>>> +        vector = i + IFCVF_MSI_QUEUE_OFF;
>>> +        irq = pci_irq_vector(pdev, vector);
>>> +        free_irq(irq, &vf->vring[i]);
>>> +    }
>>> +}
>>> +
>>> +static ssize_t name_show(struct kobject *kobj, struct device *dev, 
>>> char
>>> *buf)
>>> +{
>>> +    const char *name = "vhost accelerator (virtio ring compatible)";
>>> +
>> I believe something like "IFCVF vhost/virtio accelerator" is better?
> Agreed.
>>
>>> +    return sprintf(buf, "%s\n", name);
>>> +}
>>> +MDEV_TYPE_ATTR_RO(name);
>>> +
>>> +static ssize_t device_api_show(struct kobject *kobj, struct device 
>>> *dev,
>>> +                   char *buf)
>>> +{
>>> +    return sprintf(buf, "%s\n", VIRTIO_MDEV_DEVICE_API_STRING);
>>> +}
>>> +MDEV_TYPE_ATTR_RO(device_api);
>>> +
>>> +static ssize_t available_instances_show(struct kobject *kobj,
>>> +                    struct device *dev, char *buf)
>>> +{
>>> +    struct pci_dev *pdev;
>>> +    struct ifcvf_adapter *adapter;
>>> +
>>> +    pdev = to_pci_dev(dev);
>>> +    adapter = pci_get_drvdata(pdev);
>>> +
>>> +    return sprintf(buf, "%d\n", adapter->mdev_count);
>>> +}
>>> +
>>> +MDEV_TYPE_ATTR_RO(available_instances);
>>> +
>>> +static ssize_t type_show(struct kobject *kobj,
>>> +            struct device *dev, char *buf)
>>> +{
>>> +    return sprintf(buf, "%s\n", "net");
>>> +}
>>> +
>>> +MDEV_TYPE_ATTR_RO(type);
>>> +
>>> +
>>> +static struct attribute *mdev_types_attrs[] = {
>>> +    &mdev_type_attr_name.attr,
>>> +    &mdev_type_attr_device_api.attr,
>>> +    &mdev_type_attr_available_instances.attr,
>>> +    &mdev_type_attr_type.attr,
>>> +    NULL,
>>> +};
>>> +
>>> +static struct attribute_group mdev_type_group_virtio = {
>>> +    .name  = "virtio_mdev",
>>> +    .attrs = mdev_types_attrs,
>>> +};
>>> +
>>> +static struct attribute_group mdev_type_group_vhost = {
>>> +    .name  = "vhost_mdev",
>>> +    .attrs = mdev_types_attrs,
>>> +};
>>> +
>>> +static struct attribute_group *mdev_type_groups[] = {
>>> +    &mdev_type_group_virtio,
>>> +    &mdev_type_group_vhost,
>>> +    NULL,
>>> +};
>>> +
>>> +const struct attribute_group *mdev_dev_groups[] = {
>>> +    NULL,
>>> +};
>>> +
>>> +static int ifcvf_mdev_create(struct kobject *kobj, struct 
>>> mdev_device *mdev)
>>> +{
>>> +    struct device *dev = mdev_parent_dev(mdev);
>>> +    struct pci_dev *pdev = to_pci_dev(dev);
>>> +    struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
>>> +    int ret = 0;
>>> +
>>> +    mutex_lock(&adapter->mdev_lock);
>>> +
>>> +    if (adapter->mdev_count < IFCVF_MDEV_LIMIT) {
>>> +        IFC_ERR(&pdev->dev,
>>> +            "Can not create mdev, reached limitation %d.\n",
>>> +            IFCVF_MDEV_LIMIT);
>>> +        ret = -EINVAL;
>>> +        goto out;
>>> +    }
>>> +
>>> +    if (!strcmp(kobj->name, "ifcvf-virtio_mdev"))
>>> +        mdev_set_virtio_ops(mdev, &ifc_mdev_ops);
>>> +
>>> +    if (!strcmp(kobj->name, "ifcvf-vhost_mdev"))
>>> +        mdev_set_vhost_ops(mdev, &ifc_mdev_ops);
>>> +
>>> +    mdev_set_drvdata(mdev, adapter);
>>> +    mdev_set_iommu_device(mdev_dev(mdev), dev);
>>> +    adapter->mdev_count--;
>>> +
>>> +out:
>>> +    mutex_unlock(&adapter->mdev_lock);
>>> +    return ret;
>>> +}
>>> +
>>> +static int ifcvf_mdev_remove(struct mdev_device *mdev)
>>> +{
>>> +    struct device *dev = mdev_parent_dev(mdev);
>>> +    struct pci_dev *pdev = to_pci_dev(dev);
>>> +    struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
>>> +
>>> +    mutex_lock(&adapter->mdev_lock);
>>> +    adapter->mdev_count++;
>>> +    mutex_unlock(&adapter->mdev_lock);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static struct mdev_parent_ops ifcvf_mdev_fops = {
>>> +    .owner            = THIS_MODULE,
>>> +    .supported_type_groups    = mdev_type_groups,
>>> +    .mdev_attr_groups    = mdev_dev_groups,
>>> +    .create            = ifcvf_mdev_create,
>>> +    .remove            = ifcvf_mdev_remove,
>>> +};
>>> +
>>> +static int ifcvf_probe(struct pci_dev *pdev, const struct 
>>> pci_device_id *id)
>>> +{
>>> +    struct device *dev = &pdev->dev;
>>> +    struct ifcvf_adapter *adapter;
>>> +    struct ifcvf_hw *vf;
>>> +    int ret, i;
>>> +
>>> +    adapter = kzalloc(sizeof(struct ifcvf_adapter), GFP_KERNEL);
>>> +
>>> +    if (adapter == NULL) {
>>> +        ret = -ENOMEM;
>>> +        goto fail;
>>> +    }
>>> +
>>> +    mutex_init(&adapter->mdev_lock);
>>> +    adapter->mdev_count = IFCVF_MDEV_LIMIT;
>>> +    adapter->dev = dev;
>>> +    pci_set_drvdata(pdev, adapter);
>>> +    ret = pci_enable_device(pdev);
>>> +
>>> +    if (ret) {
>>> +        IFC_ERR(adapter->dev, "Failed to enable device.\n");
>>> +        goto free_adapter;
>>> +    }
>>> +
>>> +    ret = pci_request_regions(pdev, IFCVF_DRIVER_NAME);
>>> +
>>> +    if (ret) {
>>> +        IFC_ERR(adapter->dev, "Failed to request MMIO region.\n");
>>> +        goto disable_device;
>>> +    }
>>> +
>>> +    pci_set_master(pdev);
>>> +    ret = ifcvf_init_msix(adapter);
>>> +
>>> +    if (ret) {
>>> +        IFC_ERR(adapter->dev, "Failed to initialize MSIX.\n");
>>> +        goto free_msix;
>>> +    }
>>> +
>>> +    vf = &adapter->vf;
>>> +
>>> +    for (i = 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
>>> +        vf->mem_resource[i].phys_addr = pci_resource_start(pdev, i);
>>> +        vf->mem_resource[i].len = pci_resource_len(pdev, i);
>>> +        if (!vf->mem_resource[i].len) {
>>> +            vf->mem_resource[i].addr = NULL;
>>> +            continue;
>>> +        }
>>> +
>>> +        vf->mem_resource[i].addr = pci_iomap_range(pdev, i, 0,
>>> +                vf->mem_resource[i].len);
>>> +        if (!vf->mem_resource[i].addr) {
>>> +            IFC_ERR(adapter->dev, "Failed to map IO resource %d\n",
>>> +                i);
>>> +            ret = -1;
>>> +            goto free_msix;
>>> +        }
>>> +    }
>>> +
>>> +    if (ifcvf_init_hw(vf, pdev) < 0) {
>>> +        ret = -1;
>>> +        goto destroy_adapter;
>>> +    }
>>> +
>>> +    ret = mdev_register_device(dev, &ifcvf_mdev_fops);
>>> +
>>> +    if (ret) {
>>> +        IFC_ERR(adapter->dev,  "Failed to register mdev device\n");
>>> +        goto destroy_adapter;
>>> +    }
>>> +
>>> +    return 0;
>>> +
>>> +destroy_adapter:
>>> +    ifcvf_destroy_adapter(adapter);
>>> +free_msix:
>>> +    pci_free_irq_vectors(pdev);
>>> +    pci_release_regions(pdev);
>>> +disable_device:
>>> +    pci_disable_device(pdev);
>>> +free_adapter:
>>> +    kfree(adapter);
>>> +fail:
>>> +    return ret;
>>> +}
>>> +
>>> +static void ifcvf_remove(struct pci_dev *pdev)
>>> +{
>>> +    struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
>>> +    struct device *dev = &pdev->dev;
>>> +    struct ifcvf_hw *vf;
>>> +    int i;
>>> +
>>> +    mdev_unregister_device(dev);
>>> +
>>> +    vf = &adapter->vf;
>>> +    for (i = 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
>>> +        if (vf->mem_resource[i].addr) {
>>> +            pci_iounmap(pdev, vf->mem_resource[i].addr);
>>> +            vf->mem_resource[i].addr = NULL;
>>> +        }
>>> +    }
>>> +
>>> +    ifcvf_destroy_adapter(adapter);
>>> +    pci_free_irq_vectors(pdev);
>>> +    pci_release_regions(pdev);
>>> +    pci_disable_device(pdev);
>>> +    kfree(adapter);
>>> +}
>>> +
>>> +static struct pci_device_id ifcvf_pci_ids[] = {
>>> +    { PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
>>> +            IFCVF_DEVICE_ID,
>>> +            IFCVF_SUBSYS_VENDOR_ID,
>>> +            IFCVF_SUBSYS_DEVICE_ID) },
>>> +    { 0 },
>>> +};
>>> +MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);
>>> +
>>> +static struct pci_driver ifcvf_driver = {
>>> +    .name     = IFCVF_DRIVER_NAME,
>>> +    .id_table = ifcvf_pci_ids,
>>> +    .probe    = ifcvf_probe,
>>> +    .remove   = ifcvf_remove,
>>> +};
>>> +
>>> +static int __init ifcvf_init_module(void)
>>> +{
>>> +    int ret;
>>> +
>>> +    ret = pci_register_driver(&ifcvf_driver);
>>> +    return ret;
>>> +}
>>> +
>>> +static void __exit ifcvf_exit_module(void)
>>> +{
>>> +    pci_unregister_driver(&ifcvf_driver);
>>> +}
>> You probably can do something simpler thorugh module_pci_driver().
>>
>> Thanks
>>
>>> +
>>> +module_init(ifcvf_init_module);
>>> +module_exit(ifcvf_exit_module);
>>> +
>>> +MODULE_LICENSE("GPL v2");
>>> +MODULE_VERSION(VERSION_STRING);
>>> +MODULE_AUTHOR(DRIVER_AUTHOR);
>>> -- 
>>> 1.8.3.1
>>>
>>>
