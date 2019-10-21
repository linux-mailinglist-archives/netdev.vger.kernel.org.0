Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF56DE8BA
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 11:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfJUJzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 05:55:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:4594 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbfJUJzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 05:55:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 02:55:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,323,1566889200"; 
   d="scan'208";a="196065494"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.238.129.136]) ([10.238.129.136])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 02:55:34 -0700
Subject: Re: [RFC 1/2] vhost: IFC VF hardware operation layer
To:     Simon Horman <simon.horman@netronome.com>
Cc:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016011041.3441-1-lingshan.zhu@intel.com>
 <20191016011041.3441-2-lingshan.zhu@intel.com>
 <20191016095347.5sb43knc7eq44ivo@netronome.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <075be045-3a02-e7d8-672f-4a207c410ee8@intel.com>
Date:   Mon, 21 Oct 2019 17:55:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <20191016095347.5sb43knc7eq44ivo@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/16/2019 5:53 PM, Simon Horman wrote:
> Hi Zhu,
>
> thanks for your patch.
>
> On Wed, Oct 16, 2019 at 09:10:40AM +0800, Zhu Lingshan wrote:
>> This commit introduced ifcvf_base layer, which handles IFC VF NIC
>> hardware operations and configurations.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vhost/ifcvf/ifcvf_base.c | 390 +++++++++++++++++++++++++++++++++++++++
>>   drivers/vhost/ifcvf/ifcvf_base.h | 137 ++++++++++++++
>>   2 files changed, 527 insertions(+)
>>   create mode 100644 drivers/vhost/ifcvf/ifcvf_base.c
>>   create mode 100644 drivers/vhost/ifcvf/ifcvf_base.h
>>
>> diff --git a/drivers/vhost/ifcvf/ifcvf_base.c b/drivers/vhost/ifcvf/ifcvf_base.c
>> new file mode 100644
>> index 000000000000..b85e14c9bdcf
>> --- /dev/null
>> +++ b/drivers/vhost/ifcvf/ifcvf_base.c
>> @@ -0,0 +1,390 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2019 Intel Corporation.
>> + */
>> +
>> +#include "ifcvf_base.h"
>> +
>> +static void *get_cap_addr(struct ifcvf_hw *hw, struct virtio_pci_cap *cap)
>> +{
>> +	u8 bar = cap->bar;
>> +	u32 length = cap->length;
>> +	u32 offset = cap->offset;
> The type of the length and offset fields of virtio_pci_cap is __le32.
> A conversion, such as le32_to_cpu(), is required in order to access
> these fields in host byte order.
Hi Simon, Thanks for your comments, will do this.
>
>> +	struct ifcvf_adapter *ifcvf =
>> +		container_of(hw, struct ifcvf_adapter, vf);
> As mentioned elsewhere, please use reverse Christmas tree to order local
> variables throughout the patch.
>
> Please consider declaring and assigning ifcvf on separate lines
> if combining these stretches over more than one line.
sure, will do.
>
>> +
>> +	if (bar >= IFCVF_PCI_MAX_RESOURCE) {
>> +		IFC_ERR(ifcvf->dev,
>> +			"Invalid bar number %u to get capabilities.\n", bar);
>> +		return NULL;
>> +	}
>> +
>> +	if (offset + length < offset) {
>> +		IFC_ERR(ifcvf->dev, "offset(%u) + length(%u) overflows\n",
>> +			offset, length);
>> +		return NULL;
>> +	}
>> +
>> +	if (offset + length > hw->mem_resource[cap->bar].len) {
>> +		IFC_ERR(ifcvf->dev,
>> +			"offset(%u) + len(%u) overflows bar%u to get capabilities.\n",
>> +			offset, length, bar);
>> +		return NULL;
>> +	}
>> +
>> +	return hw->mem_resource[bar].addr + offset;
>> +}
>> +
>> +int ifcvf_read_config_range(struct pci_dev *dev,
>> +			uint32_t *val, int size, int where)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < size; i += 4) {
>> +		if (pci_read_config_dword(dev, where + i, val + i / 4) < 0)
>> +			return -1;
>> +	}
> I don't think the {} is needed here.
>
> An error code, such as -EINVAL, should be returned rather than -1.
> Likewise elsewhere.
sure, will do
>
>> +	return 0;
>> +}
>> +
>> +int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev)
>> +{
>> +	int ret;
>> +	u8 pos;
>> +	struct virtio_pci_cap cap;
>> +	u32 i;
>> +	u16 notify_off;
>> +
>> +	ret = pci_read_config_byte(dev, PCI_CAPABILITY_LIST, &pos);
>> +
>> +	if (ret < 0) {
>> +		IFC_ERR(&dev->dev, "failed to read PCI capability list.\n");
>> +		return -EIO;
>> +	}
>> +
>> +	while (pos) {
>> +		ret = ifcvf_read_config_range(dev, (u32 *)&cap,
>> +				sizeof(cap), pos);
> sizeof should be white-space aligned vertically with dev.
> Likewise elsewhere.
this is to avoid 80 chars limitation, I will try a better indent for 
this and the followings.
>
>> +
>> +		if (ret < 0) {
>> +			IFC_ERR(&dev->dev, "failed to get PCI capability at %x",
>> +					pos);
>> +			break;
>> +		}
>> +
>> +		if (cap.cap_vndr != PCI_CAP_ID_VNDR)
>> +			goto next;
>> +
>> +		IFC_INFO(&dev->dev, "read PCI config:\n"
>> +					"config type: %u.\n"
>> +					"PCI bar: %u.\n"
>> +					"PCI bar offset: %u.\n"
>> +					"PCI config len: %u.\n",
>> +					cap.cfg_type, cap.bar,
>> +					cap.offset, cap.length);
>> +
>> +		switch (cap.cfg_type) {
>> +		case VIRTIO_PCI_CAP_COMMON_CFG:
>> +			hw->common_cfg = get_cap_addr(hw, &cap);
>> +			IFC_INFO(&dev->dev, "hw->common_cfg = %p.\n",
>> +					hw->common_cfg);
>> +			break;
>> +		case VIRTIO_PCI_CAP_NOTIFY_CFG:
>> +			pci_read_config_dword(dev, pos + sizeof(cap),
>> +				&hw->notify_off_multiplier);
>> +			hw->notify_bar = cap.bar;
>> +			hw->notify_base = get_cap_addr(hw, &cap);
>> +			IFC_INFO(&dev->dev, "hw->notify_base = %p.\n",
>> +					hw->notify_base);
>> +			break;
>> +		case VIRTIO_PCI_CAP_ISR_CFG:
>> +			hw->isr = get_cap_addr(hw, &cap);
>> +			IFC_INFO(&dev->dev, "hw->isr = %p.\n", hw->isr);
>> +			break;
>> +		case VIRTIO_PCI_CAP_DEVICE_CFG:
>> +			hw->dev_cfg = get_cap_addr(hw, &cap);
>> +			IFC_INFO(&dev->dev, "hw->dev_cfg = %p.\n", hw->dev_cfg);
>> +			break;
>> +		}
>> +next:
>> +		pos = cap.cap_next;
>> +	}
>> +
>> +	if (hw->common_cfg == NULL || hw->notify_base == NULL ||
>> +		hw->isr == NULL || hw->dev_cfg == NULL) {
> hw->isr should be vertically whitespace-alligned with hw->common_cfg.
>
>> +		IFC_ERR(&dev->dev, "Incomplete PCI capabilities.\n");
>> +		return -1;
>> +	}
>> +
>> +	for (i = 0; i < (IFCVF_MAX_QUEUE_PAIRS * 2); i++) {
> The inner () seem unnecessary here.
sure, thanks
>
>> +		iowrite16(i, &hw->common_cfg->queue_select);
> Perhaps u16 would be a more appropriate type for i than u32.
> Likewise elsewhere.
agreed!
>
>> +		notify_off = ioread16(&hw->common_cfg->queue_notify_off);
>> +		hw->notify_addr[i] = (void *)((u8 *)hw->notify_base +
>> +				notify_off * hw->notify_off_multiplier);
>> +	}
>> +
>> +	hw->lm_cfg = hw->mem_resource[4].addr;
> A #define rather than directly using 4 may improve readability here.
sure
>
>> +
>> +	IFC_INFO(&dev->dev, "PCI capability mapping:\n"
>> +				"common cfg: %p\n"
>> +				"notify base: %p\n"
>> +				"isr cfg: %p\n"
>> +				"device cfg: %p\n"
>> +				"multiplier: %u\n",
>> +				hw->common_cfg,
>> +				hw->notify_base,
>> +				hw->isr,
>> +				hw->dev_cfg,
>> +				hw->notify_off_multiplier);
>> +
>> +	return 0;
>> +}
>> +
>> +static u8 ifcvf_get_status(struct ifcvf_hw *hw)
>> +{
>> +	return ioread8(&hw->common_cfg->device_status);
>> +}
>> +
>> +static void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
>> +{
>> +	iowrite8(status, &hw->common_cfg->device_status);
>> +}
>> +
>> +static void ifcvf_reset(struct ifcvf_hw *hw)
>> +{
>> +	ifcvf_set_status(hw, 0);
>> +
>> +	/* flush status write */
>> +	ifcvf_get_status(hw);
>> +	hw->generation++;
>> +}
>> +
>> +static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
>> +{
>> +	if (status != 0)
>> +		status |= ifcvf_get_status(hw);
>> +
>> +	ifcvf_set_status(hw, status);
>> +	ifcvf_get_status(hw);
>> +}
>> +
>> +u64 ifcvf_get_features(struct ifcvf_hw *hw)
> ifcvf_get_features only appears to be used in this file in this patchset.
> Perhaps it could be made static.
Yes
>
>> +{
>> +	u32 features_lo, features_hi;
>> +	struct virtio_pci_common_cfg *cfg = hw->common_cfg;
>> +
>> +	iowrite32(0, &cfg->device_feature_select);
>> +	features_lo = ioread32(&cfg->device_feature);
>> +
>> +	iowrite32(1, &cfg->device_feature_select);
>> +	features_hi = ioread32(&cfg->device_feature);
>> +
>> +	return ((u64)features_hi << 32) | features_lo;
>> +}
> Blank line is needed here.
will do
>
>> +static int ifcvf_with_feature(struct ifcvf_hw *hw, u64 bit)
>> +{
>> +	return (hw->req_features & (1ULL << bit)) != 0;
> I think it would be appropriate to use the BIT_ULL() macro here.
> Likewise elsewhere.
agreed
>
>> +}
>> +
>> +static void ifcvf_read_dev_config(struct ifcvf_hw *hw, u64 offset,
>> +		       void *dst, int length)
>> +{
>> +	int i;
>> +	u8 *p;
>> +	u8 old_gen, new_gen;
>> +
>> +	do {
>> +		old_gen = ioread8(&hw->common_cfg->config_generation);
>> +
>> +		p = dst;
>> +		for (i = 0; i < length; i++)
>> +			*p++ = ioread8((u8 *)hw->dev_cfg + offset + i);
>> +
>> +		new_gen = ioread8(&hw->common_cfg->config_generation);
>> +	} while (old_gen != new_gen);
> Would it be wise to limit the number of iterations of the loop above?
Thanks but I don't quite get it. This is used to make sure the function 
would get the latest config.
>
>> +}
>> +
>> +void ifcvf_get_linkstatus(struct ifcvf_hw *hw, u8 *is_linkup)
> This function does not appear to be used in this patchset.
> Perhaps it should be removed for now.
>
> Likewise for ifcvf_enable_logging_vf(), ifcvf_disable_logging(),
> ifcvf_get_notify_region() and ifcvf_get_queue_notify_off().
Yes, I will split these "big" patches into small commits in v1 patchset, 
sorry for the inconvenience in this RFC patch.
>> +{
>> +	u16 status;
>> +	u64 host_features;
>> +
>> +	host_features = ifcvf_get_features(hw);
>> +	if (ifcvf_with_feature(hw, VIRTIO_NET_F_STATUS)) {
>> +		ifcvf_read_dev_config(hw,
>> +				offsetof(struct ifcvf_net_config, status),
>> +				&status, sizeof(status));
>> +		if ((status & VIRTIO_NET_S_LINK_UP) == 0)
>> +			(*is_linkup) = 1;
>> +		else
>> +			(*is_linkup) = 0;
> The parentheses around *islinkup seem unnecessary.
> And perhaps this could be more simply written as:
>
> 		*is_linkup = !(status & VIRTIO_NET_S_LINK_UP);
thanks, I may just return a bool as Jason suggested.
>> +	} else
>> +		(*is_linkup) = 0;
> If one arm of a conditional uses {} then all arms should use {}.
> You need to add {} to the else clause.
>
>> +}
>> +
>> +static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
>> +{
>> +	struct virtio_pci_common_cfg *cfg = hw->common_cfg;
>> +
>> +	iowrite32(0, &cfg->guest_feature_select);
>> +	iowrite32(features & ((1ULL << 32) - 1), &cfg->guest_feature);
> Perhaps U32_MAX can be used here.
> Likewise elsewhere.
agreed. Thanks!
>
>> +
>> +	iowrite32(1, &cfg->guest_feature_select);
>> +	iowrite32(features >> 32, &cfg->guest_feature);
>> +}
>> +
>> +static int ifcvf_config_features(struct ifcvf_hw *hw)
>> +{
>> +	u64 host_features;
>> +	struct ifcvf_adapter *ifcvf =
>> +		container_of(hw, struct ifcvf_adapter, vf);
>> +
>> +	host_features = ifcvf_get_features(hw);
>> +	hw->req_features &= host_features;
>> +
>> +	ifcvf_set_features(hw, hw->req_features);
>> +	ifcvf_add_status(hw, VIRTIO_CONFIG_S_FEATURES_OK);
>> +
>> +	if (!(ifcvf_get_status(hw) & VIRTIO_CONFIG_S_FEATURES_OK)) {
>> +		IFC_ERR(ifcvf->dev, "Failed to set FEATURES_OK status\n");
>> +		return -EIO;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void io_write64_twopart(u64 val, u32 *lo, u32 *hi)
>> +{
>> +	iowrite32(val & ((1ULL << 32) - 1), lo);
>> +	iowrite32(val >> 32, hi);
>> +}
> I see this macro is also in virtio_pci_modern.c
>
> Assuming lo and hi aren't guaranteed to be sequential
> and thus iowrite64_hi_lo() cannot be used perhaps
> it would be good to add a common helper somewhere.
Thanks, I will try after this IFC patchwork, I will cc you.
>
>> +
>> +static int ifcvf_hw_enable(struct ifcvf_hw *hw)
>> +{
>> +	struct virtio_pci_common_cfg *cfg;
>> +	u8 *lm_cfg;
>> +	u32 i;
>> +	struct ifcvf_adapter *ifcvf =
>> +		container_of(hw, struct ifcvf_adapter, vf);
>> +
>> +	cfg = hw->common_cfg;
>> +	lm_cfg = hw->lm_cfg;
>> +
>> +	iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
>> +	if (ioread16(&cfg->msix_config) == VIRTIO_MSI_NO_VECTOR) {
>> +		IFC_ERR(ifcvf->dev, "No msix vector for device config.\n");
>> +		return -1;
>> +	}
>> +
>> +	for (i = 0; i < hw->nr_vring; i++) {
>> +		iowrite16(i, &cfg->queue_select);
>> +		io_write64_twopart(hw->vring[i].desc, &cfg->queue_desc_lo,
>> +				&cfg->queue_desc_hi);
>> +		io_write64_twopart(hw->vring[i].avail, &cfg->queue_avail_lo,
>> +				&cfg->queue_avail_hi);
>> +		io_write64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
>> +				&cfg->queue_used_hi);
>> +		iowrite16(hw->vring[i].size, &cfg->queue_size);
>> +
>> +		*(u32 *)(lm_cfg + IFCVF_LM_RING_STATE_OFFSET +
>> +				(i / 2) * IFCVF_LM_CFG_SIZE + (i % 2) * 4) =
>> +			(u32)hw->vring[i].last_avail_idx |
>> +			((u32)hw->vring[i].last_used_idx << 16);
>> +
>> +		iowrite16(i + IFCVF_MSI_QUEUE_OFF, &cfg->queue_msix_vector);
>> +		if (ioread16(&cfg->queue_msix_vector) ==
>> +				VIRTIO_MSI_NO_VECTOR) {
>> +			IFC_ERR(ifcvf->dev,
>> +				"No msix vector for queue %u.\n", i);
>> +			return -1;
>> +		}
>> +
>> +		iowrite16(1, &cfg->queue_enable);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void ifcvf_hw_disable(struct ifcvf_hw *hw)
>> +{
>> +	u32 i;
>> +	struct virtio_pci_common_cfg *cfg;
>> +
>> +	cfg = hw->common_cfg;
>> +
>> +	iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->msix_config);
>> +	for (i = 0; i < hw->nr_vring; i++) {
>> +		iowrite16(i, &cfg->queue_select);
>> +		iowrite16(0, &cfg->queue_enable);
>> +		iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->queue_msix_vector);
>> +	}
>> +}
>> +
>> +int ifcvf_start_hw(struct ifcvf_hw *hw)
>> +{
>> +	ifcvf_reset(hw);
>> +	ifcvf_add_status(hw, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>> +	ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER);
>> +
>> +	if (ifcvf_config_features(hw) < 0)
>> +		return -1;
>> +
>> +	if (ifcvf_hw_enable(hw) < 0)
>> +		return -1;
>> +
>> +	ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER_OK);
>> +
>> +	return 0;
>> +}
>> +
>> +void ifcvf_stop_hw(struct ifcvf_hw *hw)
>> +{
>> +	ifcvf_hw_disable(hw);
>> +	ifcvf_reset(hw);
>> +}
>> +
>> +void ifcvf_enable_logging_vf(struct ifcvf_hw *hw, u64 log_base, u64 log_size)
>> +{
>> +	u8 *lm_cfg;
>> +
>> +	lm_cfg = hw->lm_cfg;
>> +
>> +	*(u32 *)(lm_cfg + IFCVF_LM_BASE_ADDR_LOW) =
>> +		log_base & IFCVF_32_BIT_MASK;
>> +
>> +	*(u32 *)(lm_cfg + IFCVF_LM_BASE_ADDR_HIGH) =
>> +		(log_base >> 32) & IFCVF_32_BIT_MASK;
>> +
>> +	*(u32 *)(lm_cfg + IFCVF_LM_END_ADDR_LOW) =
>> +		(log_base + log_size) & IFCVF_32_BIT_MASK;
>> +
>> +	*(u32 *)(lm_cfg + IFCVF_LM_END_ADDR_HIGH) =
>> +		((log_base + log_size) >> 32) & IFCVF_32_BIT_MASK;
>> +
>> +	*(u32 *)(lm_cfg + IFCVF_LM_LOGGING_CTRL) = IFCVF_LM_ENABLE_VF;
>> +}
>> +
>> +void ifcvf_disable_logging(struct ifcvf_hw *hw)
>> +{
>> +	u8 *lm_cfg;
>> +
>> +	lm_cfg = hw->lm_cfg;
>> +	*(u32 *)(lm_cfg + IFCVF_LM_LOGGING_CTRL) = IFCVF_LM_DISABLE;
>> +}
>> +
>> +void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid)
>> +{
>> +
> There is an extra blank line above.
agree
>
>> +	iowrite16(qid, hw->notify_addr[qid]);
>> +}
>> +
>> +u8 ifcvf_get_notify_region(struct ifcvf_hw *hw)
>> +{
>> +	return hw->notify_bar;
>> +}
>> +
>> +u64 ifcvf_get_queue_notify_off(struct ifcvf_hw *hw, int qid)
>> +{
>> +	return (u8 *)hw->notify_addr[qid] -
>> +		(u8 *)hw->mem_resource[hw->notify_bar].addr;
>> +}
>> diff --git a/drivers/vhost/ifcvf/ifcvf_base.h b/drivers/vhost/ifcvf/ifcvf_base.h
>> new file mode 100644
>> index 000000000000..1ab1a1c40f24
>> --- /dev/null
>> +++ b/drivers/vhost/ifcvf/ifcvf_base.h
>> @@ -0,0 +1,137 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/*
>> + * Copyright (C) 2019 Intel Corporation.
>> + */
>> +
>> +#ifndef _IFCVF_H_
>> +#define _IFCVF_H_
>> +
>> +#include <linux/virtio_mdev.h>
>> +#include <linux/pci.h>
>> +#include <linux/pci_regs.h>
>> +#include <uapi/linux/virtio_net.h>
>> +#include <uapi/linux/virtio_config.h>
>> +#include <uapi/linux/virtio_pci.h>
> Are you sure you need all these includes in this header?
> It feels that a more minimal set could be found.
yeah, I tried, I already removed some.
>
>> +
>> +#define IFCVF_VENDOR_ID         0x1AF4
>> +#define IFCVF_DEVICE_ID         0x1041
>> +#define IFCVF_SUBSYS_VENDOR_ID  0x8086
>> +#define IFCVF_SUBSYS_DEVICE_ID  0x001A
>> +
>> +/*
>> + * Some ifcvf feature bits (currently bits 28 through 31) are
>> + * reserved for the transport being used (eg. ifcvf_ring), the
>> + * rest are per-device feature bits.
>> + */
>> +#define IFCVF_TRANSPORT_F_START 28
>> +#define IFCVF_TRANSPORT_F_END   34
>> +
>> +#define IFC_SUPPORTED_FEATURES \
>> +		((1ULL << VIRTIO_NET_F_MAC)			| \
>> +		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
>> +		 (1ULL << VIRTIO_F_VERSION_1)			| \
>> +		 (1ULL << VHOST_F_LOG_ALL)			| \
>> +		 (1ULL << VIRTIO_NET_F_GUEST_ANNOUNCE)		| \
>> +		 (1ULL << VIRTIO_NET_F_CTRL_VQ)			| \
>> +		 (1ULL << VIRTIO_NET_F_STATUS)			| \
>> +		 (1ULL << VIRTIO_NET_F_MRG_RXBUF)) /* not fully supported */
>> +
>> +#define IFCVF_MAX_QUEUE_PAIRS		1
>> +#define IFCVF_MAX_QUEUES		2
>> +
>> +#define IFCVF_QUEUE_ALIGNMENT		PAGE_SIZE
>> +
>> +#define IFCVF_MSI_CONFIG_OFF	0
>> +#define IFCVF_MSI_QUEUE_OFF	1
>> +#define IFCVF_PCI_MAX_RESOURCE	6
>> +
>> +/* 46 bit CPU physical address, avoid overlap */
>> +#define LM_IOVA 0x400000000000
>> +
>> +#define IFCVF_LM_CFG_SIZE		0x40
>> +#define IFCVF_LM_RING_STATE_OFFSET	0x20
>> +
>> +#define IFCVF_LM_LOGGING_CTRL		0x0
>> +
>> +#define IFCVF_LM_BASE_ADDR_LOW		0x10
>> +#define IFCVF_LM_BASE_ADDR_HIGH		0x14
>> +#define IFCVF_LM_END_ADDR_LOW		0x18
>> +#define IFCVF_LM_END_ADDR_HIGH		0x1c
>> +
>> +#define IFCVF_LM_DISABLE		0x0
>> +#define IFCVF_LM_ENABLE_VF		0x1
>> +#define IFCVF_LM_ENABLE_PF		0x3
>> +
>> +#define IFCVF_32_BIT_MASK		0xffffffff
>> +
>> +#define IFC_ERR(dev, fmt, ...)	dev_err(dev, fmt, ##__VA_ARGS__)
>> +#define IFC_INFO(dev, fmt, ...)	dev_info(dev, fmt, ##__VA_ARGS__)
> Its not clear to me what the value is of the above two macros.
> Why not use dev_err() and dev_info() directly?
they are just warps of dev_err and dev_info, I use them to (1) follow 
intel code style. (2)we can ad __func__ if needed.
>
>> +
>> +struct ifcvf_net_config {
>> +	u8    mac[6];
>> +	u16   status;
>> +	u16   max_virtqueue_pairs;
>> +} __packed;
>> +
>> +struct ifcvf_pci_mem_resource {
>> +	u64      phys_addr; /**< Physical address, 0 if not resource. */
>> +	u64      len;       /**< Length of the resource. */
>> +	u8       *addr;     /**< Virtual address, NULL when not mapped. */
>> +};
> I think it would be best to use kernel doc format for the comments above.
agreed
>
>> +
>> +struct vring_info {
>> +	u64 desc;
>> +	u64 avail;
>> +	u64 used;
>> +	u16 size;
>> +	u16 last_avail_idx;
>> +	u16 last_used_idx;
>> +	bool ready;
>> +	char msix_name[256];
>> +	struct virtio_mdev_callback cb;
>> +};
>> +
>> +struct ifcvf_hw {
>> +	u8	*isr;
>> +	u8	notify_bar;
>> +	u8	*lm_cfg;
>> +	u8	status;
>> +	u8	nr_vring;
> The field arrangement above seems to leave quote a few holes.
> Is that intentional?
I tried to place them to meet at least 32bits alignment, any suggestions?
>
>> +	u16	*notify_base;
>> +	u16	*notify_addr[IFCVF_MAX_QUEUE_PAIRS * 2];
>> +	u32	generation;
>> +	u32	notify_off_multiplier;
>> +	u64	req_features;
>> +	struct	virtio_pci_common_cfg *common_cfg;
>> +	struct	ifcvf_net_config *dev_cfg;
>> +	struct	vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
>> +	struct	ifcvf_pci_mem_resource mem_resource[IFCVF_PCI_MAX_RESOURCE];
>> +};
>> +
>> +#define IFC_PRIVATE_TO_VF(adapter) \
>> +	(&((struct ifcvf_adapter *)adapter)->vf)
>> +
>> +#define IFCVF_MAX_INTR (IFCVF_MAX_QUEUE_PAIRS * 2 + 1)
>> +
>> +struct ifcvf_adapter {
>> +	struct	device *dev;
>> +	struct	mutex mdev_lock;
>> +	int	mdev_count;
>> +	struct	list_head dma_maps;
>> +	int	vectors;
> Are dma_maps and vectors field used in this patchset?
I will split them into small commits, thx!
>
>> +	struct	ifcvf_hw vf;
>> +};
>> +
>> +int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev);
>> +u64 ifcvf_get_features(struct ifcvf_hw *hw);
>> +int ifcvf_start_hw(struct ifcvf_hw *hw);
>> +void ifcvf_stop_hw(struct ifcvf_hw *hw);
>> +void ifcvf_enable_logging(struct ifcvf_hw *hw, u64 log_base, u64 log_size);
> ifcvf_enable_logging_vf does not seem to be defined in this patch.
I will remove it since we intend to support LM in next release of driver.
>
>> +void ifcvf_enable_logging_vf(struct ifcvf_hw *hw, u64 log_base, u64 log_size);
>> +void ifcvf_disable_logging(struct ifcvf_hw *hw);
>> +void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid);
>> +void ifcvf_get_linkstatus(struct ifcvf_hw *hw, u8 *is_linkup);
>> +u8 ifcvf_get_notify_region(struct ifcvf_hw *hw);
>> +u64 ifcvf_get_queue_notify_off(struct ifcvf_hw *hw, int qid);
>> +
>> +#endif /* _IFCVF_H_ */
>> -- 
>> 2.16.4
>>
