Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9176333FA
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 04:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiKVDdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 22:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKVDda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 22:33:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6318639E
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669087952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IUFhvt6/9+zpnz3THJbjOXg1aWBWfTSzfgVSkrZvoOQ=;
        b=NWGaPRjew9bJ3R7ZscAihwM1FrsWpRXnqaVKL3mfQHyRtZMb9bwLKJdXTtgfSkH+gSjOvY
        3Cb/+GNvnoxbGHkzrG8EhdgE7NeJ2uMWRasOnBrDEe+bIyQ7H/XaR4GoRw4RTjO6I8Gglc
        qLJtXbw+Htu09qCZEjUr5/FOpclwLYk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-556-1CQMrhStPgqBBiKRqt7gEA-1; Mon, 21 Nov 2022 22:32:30 -0500
X-MC-Unique: 1CQMrhStPgqBBiKRqt7gEA-1
Received: by mail-pl1-f199.google.com with SMTP id p5-20020a170902e74500b001884ba979f8so10746341plf.17
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:32:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IUFhvt6/9+zpnz3THJbjOXg1aWBWfTSzfgVSkrZvoOQ=;
        b=f0FP7sv0Enb9cukZGkhf0owyF0q+4qFTsdbnuHXt8Kjrr6E7KLxwvRn6a/n2mjae4L
         v3PTE/iUDznqOxkMM/4WmEfAmeiNJwnpaQEQXls5Tpx3OhVA8VsrVlyvCfQ2HgMSSqwy
         e0PoBJ77zreuYZ1g9BQMNouv8CspNsXwPrbnKrFBR/YMi4V1EtPxJbO14fLsO8ATatbF
         Y/3o3I1Fv4g65tl0t9XYJEysj48r4Fm0aAs9N1Sgnm87h8XKprfvRpaSZTHbz9GdmMp3
         WpYAkgCvj2KJUgOg8uhbMIT2mO+PAOTkwQMWhcRU3oDDJmry5r+k6++NWbrU82GnL8Lw
         2m7Q==
X-Gm-Message-State: ANoB5pnSKhEcA53cKxlwqq6tFPsto/l3MnQg72H+IxlMqo/QmQEEF2Ic
        8YgZcoPu32O1eTRzDkWMBPlsSX052fDEUdVpEVeNkj/SHEf7WafL30MLC50+zl2mrRCFQtL0uTd
        e4jGnH0isKuaKntS5
X-Received: by 2002:a17:903:264c:b0:186:6fde:e9f5 with SMTP id je12-20020a170903264c00b001866fdee9f5mr7646290plb.139.1669087949282;
        Mon, 21 Nov 2022 19:32:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7ducLw9Dgj5BN8q3MsOsPmyQ283bEOjFWUEl0w9IGlLIuWCJW0AWKG3/hYu70VqEs6HCynBw==
X-Received: by 2002:a17:903:264c:b0:186:6fde:e9f5 with SMTP id je12-20020a170903264c00b001866fdee9f5mr7646265plb.139.1669087948817;
        Mon, 21 Nov 2022 19:32:28 -0800 (PST)
Received: from [10.72.13.197] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q15-20020aa7842f000000b0056b9df2a15esm9474227pfn.62.2022.11.21.19.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 19:32:28 -0800 (PST)
Message-ID: <bf06e7f0-48a1-37f7-0793-f68be31958e1@redhat.com>
Date:   Tue, 22 Nov 2022 11:32:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 15/19] pds_vdpa: virtio bar setup for vdpa
Content-Language: en-US
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-16-snelson@pensando.io>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221118225656.48309-16-snelson@pensando.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/19 06:56, Shannon Nelson 写道:
> The PDS vDPA device has a virtio BAR for describing itself, and
> the pds_vdpa driver needs to access it.  Here we copy liberally
> from the existing drivers/virtio/virtio_pci_modern_dev.c as it
> has what we need, but we need to modify it so that it can work
> with our device id and so we can use our own DMA mask.
>
> We suspect there is room for discussion here about making the
> existing code a little more flexible, but we thought we'd at
> least start the discussion here.


Exactly, since the virtio_pci_modern_dev.c is a library, we could tweak 
it to allow the caller to pass the device_id with the DMA mask. Then we 
can avoid code/bug duplication here.

Thanks


>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>   drivers/vdpa/pds/Makefile     |   3 +-
>   drivers/vdpa/pds/pci_drv.c    |  10 ++
>   drivers/vdpa/pds/pci_drv.h    |   2 +
>   drivers/vdpa/pds/virtio_pci.c | 283 ++++++++++++++++++++++++++++++++++
>   4 files changed, 297 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/vdpa/pds/virtio_pci.c
>
> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> index 3ba28a875574..b8376ab165bc 100644
> --- a/drivers/vdpa/pds/Makefile
> +++ b/drivers/vdpa/pds/Makefile
> @@ -4,4 +4,5 @@
>   obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
>   
>   pds_vdpa-y := pci_drv.o	\
> -	      debugfs.o
> +	      debugfs.o \
> +	      virtio_pci.o
> diff --git a/drivers/vdpa/pds/pci_drv.c b/drivers/vdpa/pds/pci_drv.c
> index 369e11153f21..10491e22778c 100644
> --- a/drivers/vdpa/pds/pci_drv.c
> +++ b/drivers/vdpa/pds/pci_drv.c
> @@ -44,6 +44,14 @@ pds_vdpa_pci_probe(struct pci_dev *pdev,
>   		goto err_out_free_mem;
>   	}
>   
> +	vdpa_pdev->vd_mdev.pci_dev = pdev;
> +	err = pds_vdpa_probe_virtio(&vdpa_pdev->vd_mdev);
> +	if (err) {
> +		dev_err(dev, "Unable to probe for virtio configuration: %pe\n",
> +			ERR_PTR(err));
> +		goto err_out_free_mem;
> +	}
> +
>   	pci_enable_pcie_error_reporting(pdev);
>   
>   	/* Use devres management */
> @@ -74,6 +82,7 @@ pds_vdpa_pci_probe(struct pci_dev *pdev,
>   err_out_pci_release_device:
>   	pci_disable_device(pdev);
>   err_out_free_mem:
> +	pds_vdpa_remove_virtio(&vdpa_pdev->vd_mdev);
>   	pci_disable_pcie_error_reporting(pdev);
>   	kfree(vdpa_pdev);
>   	return err;
> @@ -88,6 +97,7 @@ pds_vdpa_pci_remove(struct pci_dev *pdev)
>   	pci_clear_master(pdev);
>   	pci_disable_pcie_error_reporting(pdev);
>   	pci_disable_device(pdev);
> +	pds_vdpa_remove_virtio(&vdpa_pdev->vd_mdev);
>   	kfree(vdpa_pdev);
>   
>   	dev_info(&pdev->dev, "Removed\n");
> diff --git a/drivers/vdpa/pds/pci_drv.h b/drivers/vdpa/pds/pci_drv.h
> index 747809e0df9e..15f3b34fafa9 100644
> --- a/drivers/vdpa/pds/pci_drv.h
> +++ b/drivers/vdpa/pds/pci_drv.h
> @@ -43,4 +43,6 @@ struct pds_vdpa_pci_device {
>   	struct virtio_pci_modern_device vd_mdev;
>   };
>   
> +int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev);
> +void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev);
>   #endif /* _PCI_DRV_H */
> diff --git a/drivers/vdpa/pds/virtio_pci.c b/drivers/vdpa/pds/virtio_pci.c
> new file mode 100644
> index 000000000000..0f4ac9467199
> --- /dev/null
> +++ b/drivers/vdpa/pds/virtio_pci.c
> @@ -0,0 +1,283 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +/*
> + * adapted from drivers/virtio/virtio_pci_modern_dev.c, v6.0-rc1
> + */
> +
> +#include <linux/virtio_pci_modern.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/delay.h>
> +
> +#include "pci_drv.h"
> +
> +/*
> + * pds_vdpa_map_capability - map a part of virtio pci capability
> + * @mdev: the modern virtio-pci device
> + * @off: offset of the capability
> + * @minlen: minimal length of the capability
> + * @align: align requirement
> + * @start: start from the capability
> + * @size: map size
> + * @len: the length that is actually mapped
> + * @pa: physical address of the capability
> + *
> + * Returns the io address of for the part of the capability
> + */
> +static void __iomem *
> +pds_vdpa_map_capability(struct virtio_pci_modern_device *mdev, int off,
> +			 size_t minlen, u32 align, u32 start, u32 size,
> +			 size_t *len, resource_size_t *pa)
> +{
> +	struct pci_dev *dev = mdev->pci_dev;
> +	u8 bar;
> +	u32 offset, length;
> +	void __iomem *p;
> +
> +	pci_read_config_byte(dev, off + offsetof(struct virtio_pci_cap,
> +						 bar),
> +			     &bar);
> +	pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, offset),
> +			     &offset);
> +	pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, length),
> +			      &length);
> +
> +	/* Check if the BAR may have changed since we requested the region. */
> +	if (bar >= PCI_STD_NUM_BARS || !(mdev->modern_bars & (1 << bar))) {
> +		dev_err(&dev->dev,
> +			"virtio_pci: bar unexpectedly changed to %u\n", bar);
> +		return NULL;
> +	}
> +
> +	if (length <= start) {
> +		dev_err(&dev->dev,
> +			"virtio_pci: bad capability len %u (>%u expected)\n",
> +			length, start);
> +		return NULL;
> +	}
> +
> +	if (length - start < minlen) {
> +		dev_err(&dev->dev,
> +			"virtio_pci: bad capability len %u (>=%zu expected)\n",
> +			length, minlen);
> +		return NULL;
> +	}
> +
> +	length -= start;
> +
> +	if (start + offset < offset) {
> +		dev_err(&dev->dev,
> +			"virtio_pci: map wrap-around %u+%u\n",
> +			start, offset);
> +		return NULL;
> +	}
> +
> +	offset += start;
> +
> +	if (offset & (align - 1)) {
> +		dev_err(&dev->dev,
> +			"virtio_pci: offset %u not aligned to %u\n",
> +			offset, align);
> +		return NULL;
> +	}
> +
> +	if (length > size)
> +		length = size;
> +
> +	if (len)
> +		*len = length;
> +
> +	if (minlen + offset < minlen ||
> +	    minlen + offset > pci_resource_len(dev, bar)) {
> +		dev_err(&dev->dev,
> +			"virtio_pci: map virtio %zu@%u out of range on bar %i length %lu\n",
> +			minlen, offset,
> +			bar, (unsigned long)pci_resource_len(dev, bar));
> +		return NULL;
> +	}
> +
> +	p = pci_iomap_range(dev, bar, offset, length);
> +	if (!p)
> +		dev_err(&dev->dev,
> +			"virtio_pci: unable to map virtio %u@%u on bar %i\n",
> +			length, offset, bar);
> +	else if (pa)
> +		*pa = pci_resource_start(dev, bar) + offset;
> +
> +	return p;
> +}
> +
> +/**
> + * virtio_pci_find_capability - walk capabilities to find device info.
> + * @dev: the pci device
> + * @cfg_type: the VIRTIO_PCI_CAP_* value we seek
> + * @ioresource_types: IORESOURCE_MEM and/or IORESOURCE_IO.
> + * @bars: the bitmask of BARs
> + *
> + * Returns offset of the capability, or 0.
> + */
> +static inline int virtio_pci_find_capability(struct pci_dev *dev, u8 cfg_type,
> +					     u32 ioresource_types, int *bars)
> +{
> +	int pos;
> +
> +	for (pos = pci_find_capability(dev, PCI_CAP_ID_VNDR);
> +	     pos > 0;
> +	     pos = pci_find_next_capability(dev, pos, PCI_CAP_ID_VNDR)) {
> +		u8 type, bar;
> +
> +		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
> +							 cfg_type),
> +				     &type);
> +		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
> +							 bar),
> +				     &bar);
> +
> +		/* Ignore structures with reserved BAR values */
> +		if (bar >= PCI_STD_NUM_BARS)
> +			continue;
> +
> +		if (type == cfg_type) {
> +			if (pci_resource_len(dev, bar) &&
> +			    pci_resource_flags(dev, bar) & ioresource_types) {
> +				*bars |= (1 << bar);
> +				return pos;
> +			}
> +		}
> +	}
> +	return 0;
> +}
> +
> +/*
> + * pds_vdpa_probe_virtio: probe the modern virtio pci device, note that the
> + * caller is required to enable PCI device before calling this function.
> + * @mdev: the modern virtio-pci device
> + *
> + * Return 0 on succeed otherwise fail
> + */
> +int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev)
> +{
> +	struct pci_dev *pci_dev = mdev->pci_dev;
> +	int err, common, isr, notify, device;
> +	u32 notify_length;
> +	u32 notify_offset;
> +
> +	/* check for a common config: if not, use legacy mode (bar 0). */
> +	common = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_COMMON_CFG,
> +					    IORESOURCE_IO | IORESOURCE_MEM,
> +					    &mdev->modern_bars);
> +	if (!common) {
> +		dev_info(&pci_dev->dev,
> +			 "virtio_pci: missing common config\n");
> +		return -ENODEV;
> +	}
> +
> +	/* If common is there, these should be too... */
> +	isr = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_ISR_CFG,
> +					 IORESOURCE_IO | IORESOURCE_MEM,
> +					 &mdev->modern_bars);
> +	notify = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_NOTIFY_CFG,
> +					    IORESOURCE_IO | IORESOURCE_MEM,
> +					    &mdev->modern_bars);
> +	if (!isr || !notify) {
> +		dev_err(&pci_dev->dev,
> +			"virtio_pci: missing capabilities %i/%i/%i\n",
> +			common, isr, notify);
> +		return -EINVAL;
> +	}
> +
> +	/* Device capability is only mandatory for devices that have
> +	 * device-specific configuration.
> +	 */
> +	device = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_DEVICE_CFG,
> +					    IORESOURCE_IO | IORESOURCE_MEM,
> +					    &mdev->modern_bars);
> +
> +	err = pci_request_selected_regions(pci_dev, mdev->modern_bars,
> +					   "virtio-pci-modern");
> +	if (err)
> +		return err;
> +
> +	err = -EINVAL;
> +	mdev->common = pds_vdpa_map_capability(mdev, common,
> +				      sizeof(struct virtio_pci_common_cfg), 4,
> +				      0, sizeof(struct virtio_pci_common_cfg),
> +				      NULL, NULL);
> +	if (!mdev->common)
> +		goto err_map_common;
> +	mdev->isr = pds_vdpa_map_capability(mdev, isr, sizeof(u8), 1,
> +					     0, 1,
> +					     NULL, NULL);
> +	if (!mdev->isr)
> +		goto err_map_isr;
> +
> +	/* Read notify_off_multiplier from config space. */
> +	pci_read_config_dword(pci_dev,
> +			      notify + offsetof(struct virtio_pci_notify_cap,
> +						notify_off_multiplier),
> +			      &mdev->notify_offset_multiplier);
> +	/* Read notify length and offset from config space. */
> +	pci_read_config_dword(pci_dev,
> +			      notify + offsetof(struct virtio_pci_notify_cap,
> +						cap.length),
> +			      &notify_length);
> +
> +	pci_read_config_dword(pci_dev,
> +			      notify + offsetof(struct virtio_pci_notify_cap,
> +						cap.offset),
> +			      &notify_offset);
> +
> +	/* We don't know how many VQs we'll map, ahead of the time.
> +	 * If notify length is small, map it all now.
> +	 * Otherwise, map each VQ individually later.
> +	 */
> +	if ((u64)notify_length + (notify_offset % PAGE_SIZE) <= PAGE_SIZE) {
> +		mdev->notify_base = pds_vdpa_map_capability(mdev, notify,
> +							     2, 2,
> +							     0, notify_length,
> +							     &mdev->notify_len,
> +							     &mdev->notify_pa);
> +		if (!mdev->notify_base)
> +			goto err_map_notify;
> +	} else {
> +		mdev->notify_map_cap = notify;
> +	}
> +
> +	/* Again, we don't know how much we should map, but PAGE_SIZE
> +	 * is more than enough for all existing devices.
> +	 */
> +	if (device) {
> +		mdev->device = pds_vdpa_map_capability(mdev, device, 0, 4,
> +							0, PAGE_SIZE,
> +							&mdev->device_len,
> +							NULL);
> +		if (!mdev->device)
> +			goto err_map_device;
> +	}
> +
> +	return 0;
> +
> +err_map_device:
> +	if (mdev->notify_base)
> +		pci_iounmap(pci_dev, mdev->notify_base);
> +err_map_notify:
> +	pci_iounmap(pci_dev, mdev->isr);
> +err_map_isr:
> +	pci_iounmap(pci_dev, mdev->common);
> +err_map_common:
> +	pci_release_selected_regions(pci_dev, mdev->modern_bars);
> +	return err;
> +}
> +
> +void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev)
> +{
> +	struct pci_dev *pci_dev = mdev->pci_dev;
> +
> +	if (mdev->device)
> +		pci_iounmap(pci_dev, mdev->device);
> +	if (mdev->notify_base)
> +		pci_iounmap(pci_dev, mdev->notify_base);
> +	pci_iounmap(pci_dev, mdev->isr);
> +	pci_iounmap(pci_dev, mdev->common);
> +	pci_release_selected_regions(pci_dev, mdev->modern_bars);
> +}

