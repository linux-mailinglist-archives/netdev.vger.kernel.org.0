Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024D96302B8
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbiKRXOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbiKRXNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:39 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B282EC68AC
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:58 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso6393005pjc.2
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7xu/k0uOmb9bpaVvCTmNaThIKAzwj+vYINShVjXuoGI=;
        b=Z0NTq44M8DwPSL0fUOEU1Hsd9qtP/+1xQwtbFWCWA8Nm7s8Xa3cIWD7e070+elmoat
         JqYxrzl4cxVlZTyHupSM3mbvgKSOYa3Ds2NIYevwJtz1t+5jcNRqvpDStSXoFhziJEN9
         z+9kAvLFUNin33K07kFAav22YZhtsvhFtlrOSkMFEmhpmT2asIn1zDX6rrosW6G7VdcY
         UfgE63yWQi0X38IOc6imCP4I/k0PZBbzyl2fEOZUv6qE/5RhoRPlcMRNzJ7l8qwSm2J6
         Uubdl7tjwei3usbzzmffQyGStzq7/GOi83Qq7vtw8RgCKhQs4eUvP1LRPT61mAq9pHHM
         PBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7xu/k0uOmb9bpaVvCTmNaThIKAzwj+vYINShVjXuoGI=;
        b=v+Am1x5OeUzKvSQDwS7eY9Fs11CWx9mRqA0T/iptlrnZdZ/PuNNWVh84IMsW8iGVPU
         ISmE6vPCNHVc0v8qdycbXkB5RW2CTHGl2vEH/Dz9kCKxTSVc2JJMIRWRdHh/Tqpg579A
         voquP2NCWA9mqyptyOgkCg2XitTuYsVE66H5QkAYuqC0EXNen6kq9KqdID60PbBsipL4
         jYHEYP3rhANEGMjvmGSxdRPywZAaPOkNFlvQrxMiEYLTMUmXqL9Yd0RTnKDLG0gLwiBC
         gyPu5b0ign6m3tMZM44IgK0VLqaVq6G5DjSLX7B9F8K+COcbe3RXGJuuoODQJX2+IU68
         L1uA==
X-Gm-Message-State: ANoB5pnAWUGVmtb3IKlE6Y3DsXV3nVnI5BjYQnrJUzQKusHT879P6ECv
        L1uUJ2tf0I2jodSItD3xzA/Zv6QVt1KTCQ==
X-Google-Smtp-Source: AA0mqf6RxD5ZFl2ixcQF8uzOfMS3KdbZEmH5edZIHp9XaBQWwFGPCYYFkncPNyd+YyEanNsEaoPAaQ==
X-Received: by 2002:a17:90a:4fc1:b0:213:16b5:f45e with SMTP id q59-20020a17090a4fc100b0021316b5f45emr15552016pjh.170.1668812252524;
        Fri, 18 Nov 2022 14:57:32 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:32 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 15/19] pds_vdpa: virtio bar setup for vdpa
Date:   Fri, 18 Nov 2022 14:56:52 -0800
Message-Id: <20221118225656.48309-16-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118225656.48309-1-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PDS vDPA device has a virtio BAR for describing itself, and
the pds_vdpa driver needs to access it.  Here we copy liberally
from the existing drivers/virtio/virtio_pci_modern_dev.c as it
has what we need, but we need to modify it so that it can work
with our device id and so we can use our own DMA mask.

We suspect there is room for discussion here about making the
existing code a little more flexible, but we thought we'd at
least start the discussion here.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/vdpa/pds/Makefile     |   3 +-
 drivers/vdpa/pds/pci_drv.c    |  10 ++
 drivers/vdpa/pds/pci_drv.h    |   2 +
 drivers/vdpa/pds/virtio_pci.c | 283 ++++++++++++++++++++++++++++++++++
 4 files changed, 297 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vdpa/pds/virtio_pci.c

diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
index 3ba28a875574..b8376ab165bc 100644
--- a/drivers/vdpa/pds/Makefile
+++ b/drivers/vdpa/pds/Makefile
@@ -4,4 +4,5 @@
 obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
 
 pds_vdpa-y := pci_drv.o	\
-	      debugfs.o
+	      debugfs.o \
+	      virtio_pci.o
diff --git a/drivers/vdpa/pds/pci_drv.c b/drivers/vdpa/pds/pci_drv.c
index 369e11153f21..10491e22778c 100644
--- a/drivers/vdpa/pds/pci_drv.c
+++ b/drivers/vdpa/pds/pci_drv.c
@@ -44,6 +44,14 @@ pds_vdpa_pci_probe(struct pci_dev *pdev,
 		goto err_out_free_mem;
 	}
 
+	vdpa_pdev->vd_mdev.pci_dev = pdev;
+	err = pds_vdpa_probe_virtio(&vdpa_pdev->vd_mdev);
+	if (err) {
+		dev_err(dev, "Unable to probe for virtio configuration: %pe\n",
+			ERR_PTR(err));
+		goto err_out_free_mem;
+	}
+
 	pci_enable_pcie_error_reporting(pdev);
 
 	/* Use devres management */
@@ -74,6 +82,7 @@ pds_vdpa_pci_probe(struct pci_dev *pdev,
 err_out_pci_release_device:
 	pci_disable_device(pdev);
 err_out_free_mem:
+	pds_vdpa_remove_virtio(&vdpa_pdev->vd_mdev);
 	pci_disable_pcie_error_reporting(pdev);
 	kfree(vdpa_pdev);
 	return err;
@@ -88,6 +97,7 @@ pds_vdpa_pci_remove(struct pci_dev *pdev)
 	pci_clear_master(pdev);
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
+	pds_vdpa_remove_virtio(&vdpa_pdev->vd_mdev);
 	kfree(vdpa_pdev);
 
 	dev_info(&pdev->dev, "Removed\n");
diff --git a/drivers/vdpa/pds/pci_drv.h b/drivers/vdpa/pds/pci_drv.h
index 747809e0df9e..15f3b34fafa9 100644
--- a/drivers/vdpa/pds/pci_drv.h
+++ b/drivers/vdpa/pds/pci_drv.h
@@ -43,4 +43,6 @@ struct pds_vdpa_pci_device {
 	struct virtio_pci_modern_device vd_mdev;
 };
 
+int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev);
+void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev);
 #endif /* _PCI_DRV_H */
diff --git a/drivers/vdpa/pds/virtio_pci.c b/drivers/vdpa/pds/virtio_pci.c
new file mode 100644
index 000000000000..0f4ac9467199
--- /dev/null
+++ b/drivers/vdpa/pds/virtio_pci.c
@@ -0,0 +1,283 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+/*
+ * adapted from drivers/virtio/virtio_pci_modern_dev.c, v6.0-rc1
+ */
+
+#include <linux/virtio_pci_modern.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+
+#include "pci_drv.h"
+
+/*
+ * pds_vdpa_map_capability - map a part of virtio pci capability
+ * @mdev: the modern virtio-pci device
+ * @off: offset of the capability
+ * @minlen: minimal length of the capability
+ * @align: align requirement
+ * @start: start from the capability
+ * @size: map size
+ * @len: the length that is actually mapped
+ * @pa: physical address of the capability
+ *
+ * Returns the io address of for the part of the capability
+ */
+static void __iomem *
+pds_vdpa_map_capability(struct virtio_pci_modern_device *mdev, int off,
+			 size_t minlen, u32 align, u32 start, u32 size,
+			 size_t *len, resource_size_t *pa)
+{
+	struct pci_dev *dev = mdev->pci_dev;
+	u8 bar;
+	u32 offset, length;
+	void __iomem *p;
+
+	pci_read_config_byte(dev, off + offsetof(struct virtio_pci_cap,
+						 bar),
+			     &bar);
+	pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, offset),
+			     &offset);
+	pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, length),
+			      &length);
+
+	/* Check if the BAR may have changed since we requested the region. */
+	if (bar >= PCI_STD_NUM_BARS || !(mdev->modern_bars & (1 << bar))) {
+		dev_err(&dev->dev,
+			"virtio_pci: bar unexpectedly changed to %u\n", bar);
+		return NULL;
+	}
+
+	if (length <= start) {
+		dev_err(&dev->dev,
+			"virtio_pci: bad capability len %u (>%u expected)\n",
+			length, start);
+		return NULL;
+	}
+
+	if (length - start < minlen) {
+		dev_err(&dev->dev,
+			"virtio_pci: bad capability len %u (>=%zu expected)\n",
+			length, minlen);
+		return NULL;
+	}
+
+	length -= start;
+
+	if (start + offset < offset) {
+		dev_err(&dev->dev,
+			"virtio_pci: map wrap-around %u+%u\n",
+			start, offset);
+		return NULL;
+	}
+
+	offset += start;
+
+	if (offset & (align - 1)) {
+		dev_err(&dev->dev,
+			"virtio_pci: offset %u not aligned to %u\n",
+			offset, align);
+		return NULL;
+	}
+
+	if (length > size)
+		length = size;
+
+	if (len)
+		*len = length;
+
+	if (minlen + offset < minlen ||
+	    minlen + offset > pci_resource_len(dev, bar)) {
+		dev_err(&dev->dev,
+			"virtio_pci: map virtio %zu@%u out of range on bar %i length %lu\n",
+			minlen, offset,
+			bar, (unsigned long)pci_resource_len(dev, bar));
+		return NULL;
+	}
+
+	p = pci_iomap_range(dev, bar, offset, length);
+	if (!p)
+		dev_err(&dev->dev,
+			"virtio_pci: unable to map virtio %u@%u on bar %i\n",
+			length, offset, bar);
+	else if (pa)
+		*pa = pci_resource_start(dev, bar) + offset;
+
+	return p;
+}
+
+/**
+ * virtio_pci_find_capability - walk capabilities to find device info.
+ * @dev: the pci device
+ * @cfg_type: the VIRTIO_PCI_CAP_* value we seek
+ * @ioresource_types: IORESOURCE_MEM and/or IORESOURCE_IO.
+ * @bars: the bitmask of BARs
+ *
+ * Returns offset of the capability, or 0.
+ */
+static inline int virtio_pci_find_capability(struct pci_dev *dev, u8 cfg_type,
+					     u32 ioresource_types, int *bars)
+{
+	int pos;
+
+	for (pos = pci_find_capability(dev, PCI_CAP_ID_VNDR);
+	     pos > 0;
+	     pos = pci_find_next_capability(dev, pos, PCI_CAP_ID_VNDR)) {
+		u8 type, bar;
+
+		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
+							 cfg_type),
+				     &type);
+		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
+							 bar),
+				     &bar);
+
+		/* Ignore structures with reserved BAR values */
+		if (bar >= PCI_STD_NUM_BARS)
+			continue;
+
+		if (type == cfg_type) {
+			if (pci_resource_len(dev, bar) &&
+			    pci_resource_flags(dev, bar) & ioresource_types) {
+				*bars |= (1 << bar);
+				return pos;
+			}
+		}
+	}
+	return 0;
+}
+
+/*
+ * pds_vdpa_probe_virtio: probe the modern virtio pci device, note that the
+ * caller is required to enable PCI device before calling this function.
+ * @mdev: the modern virtio-pci device
+ *
+ * Return 0 on succeed otherwise fail
+ */
+int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev)
+{
+	struct pci_dev *pci_dev = mdev->pci_dev;
+	int err, common, isr, notify, device;
+	u32 notify_length;
+	u32 notify_offset;
+
+	/* check for a common config: if not, use legacy mode (bar 0). */
+	common = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_COMMON_CFG,
+					    IORESOURCE_IO | IORESOURCE_MEM,
+					    &mdev->modern_bars);
+	if (!common) {
+		dev_info(&pci_dev->dev,
+			 "virtio_pci: missing common config\n");
+		return -ENODEV;
+	}
+
+	/* If common is there, these should be too... */
+	isr = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_ISR_CFG,
+					 IORESOURCE_IO | IORESOURCE_MEM,
+					 &mdev->modern_bars);
+	notify = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_NOTIFY_CFG,
+					    IORESOURCE_IO | IORESOURCE_MEM,
+					    &mdev->modern_bars);
+	if (!isr || !notify) {
+		dev_err(&pci_dev->dev,
+			"virtio_pci: missing capabilities %i/%i/%i\n",
+			common, isr, notify);
+		return -EINVAL;
+	}
+
+	/* Device capability is only mandatory for devices that have
+	 * device-specific configuration.
+	 */
+	device = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_DEVICE_CFG,
+					    IORESOURCE_IO | IORESOURCE_MEM,
+					    &mdev->modern_bars);
+
+	err = pci_request_selected_regions(pci_dev, mdev->modern_bars,
+					   "virtio-pci-modern");
+	if (err)
+		return err;
+
+	err = -EINVAL;
+	mdev->common = pds_vdpa_map_capability(mdev, common,
+				      sizeof(struct virtio_pci_common_cfg), 4,
+				      0, sizeof(struct virtio_pci_common_cfg),
+				      NULL, NULL);
+	if (!mdev->common)
+		goto err_map_common;
+	mdev->isr = pds_vdpa_map_capability(mdev, isr, sizeof(u8), 1,
+					     0, 1,
+					     NULL, NULL);
+	if (!mdev->isr)
+		goto err_map_isr;
+
+	/* Read notify_off_multiplier from config space. */
+	pci_read_config_dword(pci_dev,
+			      notify + offsetof(struct virtio_pci_notify_cap,
+						notify_off_multiplier),
+			      &mdev->notify_offset_multiplier);
+	/* Read notify length and offset from config space. */
+	pci_read_config_dword(pci_dev,
+			      notify + offsetof(struct virtio_pci_notify_cap,
+						cap.length),
+			      &notify_length);
+
+	pci_read_config_dword(pci_dev,
+			      notify + offsetof(struct virtio_pci_notify_cap,
+						cap.offset),
+			      &notify_offset);
+
+	/* We don't know how many VQs we'll map, ahead of the time.
+	 * If notify length is small, map it all now.
+	 * Otherwise, map each VQ individually later.
+	 */
+	if ((u64)notify_length + (notify_offset % PAGE_SIZE) <= PAGE_SIZE) {
+		mdev->notify_base = pds_vdpa_map_capability(mdev, notify,
+							     2, 2,
+							     0, notify_length,
+							     &mdev->notify_len,
+							     &mdev->notify_pa);
+		if (!mdev->notify_base)
+			goto err_map_notify;
+	} else {
+		mdev->notify_map_cap = notify;
+	}
+
+	/* Again, we don't know how much we should map, but PAGE_SIZE
+	 * is more than enough for all existing devices.
+	 */
+	if (device) {
+		mdev->device = pds_vdpa_map_capability(mdev, device, 0, 4,
+							0, PAGE_SIZE,
+							&mdev->device_len,
+							NULL);
+		if (!mdev->device)
+			goto err_map_device;
+	}
+
+	return 0;
+
+err_map_device:
+	if (mdev->notify_base)
+		pci_iounmap(pci_dev, mdev->notify_base);
+err_map_notify:
+	pci_iounmap(pci_dev, mdev->isr);
+err_map_isr:
+	pci_iounmap(pci_dev, mdev->common);
+err_map_common:
+	pci_release_selected_regions(pci_dev, mdev->modern_bars);
+	return err;
+}
+
+void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev)
+{
+	struct pci_dev *pci_dev = mdev->pci_dev;
+
+	if (mdev->device)
+		pci_iounmap(pci_dev, mdev->device);
+	if (mdev->notify_base)
+		pci_iounmap(pci_dev, mdev->notify_base);
+	pci_iounmap(pci_dev, mdev->isr);
+	pci_iounmap(pci_dev, mdev->common);
+	pci_release_selected_regions(pci_dev, mdev->modern_bars);
+}
-- 
2.17.1

