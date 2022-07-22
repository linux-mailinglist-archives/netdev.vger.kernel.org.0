Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D2357E131
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiGVMBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234532AbiGVMBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:01:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34664BB228
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658491277; x=1690027277;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GxFwkxS5cRCWWPo/uQ64UKzAaDcsovAfTjCnRoqLw44=;
  b=ZPirlMMqjynGRVg6yIowkyvyW0nSJa9IIyhO9gPITn1bHv7Uz44r0LoA
   xpP+iZHZSw+N61wE25DeHYT9GdAh7dF7eqjLQY45nvjZc9cM99T4oeQIs
   fMDiWnASMCZZjbcIU15fwRAv6vY0r+9tphxFuA0TpXpSqpwYJCvdbBLFv
   oaIOLMqRINHCFlY5Qwbb6ZRBIukw2yA6oeiyyUxo6gty7msLkCea0YlGF
   oX2uklgPFG/wcYgf7ZosKEPYPf2FS/lVkO6B+9Gy3jeM2igkg3VAyKK2E
   0b1soDj3vzrUfG7cP7/0PG2Py4b3KeFCy+xbh8Dkw4vCHyhvTCFnQZd9I
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="284850193"
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="284850193"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 05:01:17 -0700
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="657189825"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 05:01:14 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 2/6] vDPA/ifcvf: support userspace to query features and MQ of a management device
Date:   Fri, 22 Jul 2022 19:53:05 +0800
Message-Id: <20220722115309.82746-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220722115309.82746-1-lingshan.zhu@intel.com>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adapting to current netlink interfaces, this commit allows userspace
to query feature bits and MQ capability of a management device.

Currently both the vDPA device and the management device are the VF itself,
thus this ifcvf should initialize the virtio capabilities in probe() before
setting up the struct vdpa_mgmt_dev.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 142 +++++++++++++++++---------------
 1 file changed, 76 insertions(+), 66 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 0a5670729412..3fd0267873f8 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -752,59 +752,36 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 {
 	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
 	struct ifcvf_adapter *adapter;
+	struct vdpa_device *vdpa_dev;
 	struct pci_dev *pdev;
 	struct ifcvf_hw *vf;
-	struct device *dev;
-	int ret, i;
+	int ret;
 
 	ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
-	if (ifcvf_mgmt_dev->adapter)
+	if (!ifcvf_mgmt_dev->adapter)
 		return -EOPNOTSUPP;
 
-	pdev = ifcvf_mgmt_dev->pdev;
-	dev = &pdev->dev;
-	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
-				    dev, &ifc_vdpa_ops, 1, 1, name, false);
-	if (IS_ERR(adapter)) {
-		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
-		return PTR_ERR(adapter);
-	}
-
-	ifcvf_mgmt_dev->adapter = adapter;
-
+	adapter = ifcvf_mgmt_dev->adapter;
 	vf = &adapter->vf;
-	vf->dev_type = get_dev_type(pdev);
-	vf->base = pcim_iomap_table(pdev);
+	pdev = adapter->pdev;
+	vdpa_dev = &adapter->vdpa;
 
-	adapter->pdev = pdev;
-	adapter->vdpa.dma_dev = &pdev->dev;
-
-	ret = ifcvf_init_hw(vf, pdev);
-	if (ret) {
-		IFCVF_ERR(pdev, "Failed to init IFCVF hw\n");
-		goto err;
-	}
-
-	for (i = 0; i < vf->nr_vring; i++)
-		vf->vring[i].irq = -EINVAL;
-
-	vf->hw_features = ifcvf_get_hw_features(vf);
-	vf->config_size = ifcvf_get_config_size(vf);
+	if (name)
+		ret = dev_set_name(&vdpa_dev->dev, "%s", name);
+	else
+		ret = dev_set_name(&vdpa_dev->dev, "vdpa%u", vdpa_dev->index);
 
-	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
 	ret = _vdpa_register_device(&adapter->vdpa, vf->nr_vring);
 	if (ret) {
+		put_device(&adapter->vdpa.dev);
 		IFCVF_ERR(pdev, "Failed to register to vDPA bus");
-		goto err;
+		return ret;
 	}
 
 	return 0;
-
-err:
-	put_device(&adapter->vdpa.dev);
-	return ret;
 }
 
+
 static void ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
 {
 	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
@@ -823,61 +800,94 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
 	struct device *dev = &pdev->dev;
+	struct ifcvf_adapter *adapter;
+	struct ifcvf_hw *vf;
 	u32 dev_type;
-	int ret;
-
-	ifcvf_mgmt_dev = kzalloc(sizeof(struct ifcvf_vdpa_mgmt_dev), GFP_KERNEL);
-	if (!ifcvf_mgmt_dev) {
-		IFCVF_ERR(pdev, "Failed to alloc memory for the vDPA management device\n");
-		return -ENOMEM;
-	}
-
-	dev_type = get_dev_type(pdev);
-	switch (dev_type) {
-	case VIRTIO_ID_NET:
-		ifcvf_mgmt_dev->mdev.id_table = id_table_net;
-		break;
-	case VIRTIO_ID_BLOCK:
-		ifcvf_mgmt_dev->mdev.id_table = id_table_blk;
-		break;
-	default:
-		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", dev_type);
-		ret = -EOPNOTSUPP;
-		goto err;
-	}
-
-	ifcvf_mgmt_dev->mdev.ops = &ifcvf_vdpa_mgmt_dev_ops;
-	ifcvf_mgmt_dev->mdev.device = dev;
-	ifcvf_mgmt_dev->pdev = pdev;
+	int ret, i;
 
 	ret = pcim_enable_device(pdev);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to enable device\n");
-		goto err;
+		return ret;
 	}
-
 	ret = pcim_iomap_regions(pdev, BIT(0) | BIT(2) | BIT(4),
 				 IFCVF_DRIVER_NAME);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to request MMIO region\n");
-		goto err;
+		return ret;
 	}
 
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (ret) {
 		IFCVF_ERR(pdev, "No usable DMA configuration\n");
-		goto err;
+		return ret;
 	}
 
 	ret = devm_add_action_or_reset(dev, ifcvf_free_irq_vectors, pdev);
 	if (ret) {
 		IFCVF_ERR(pdev,
 			  "Failed for adding devres for freeing irq vectors\n");
-		goto err;
+		return ret;
 	}
 
 	pci_set_master(pdev);
 
+	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
+				    dev, &ifc_vdpa_ops, 1, 1, NULL, false);
+	if (IS_ERR(adapter)) {
+		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
+		return PTR_ERR(adapter);
+	}
+
+	vf = &adapter->vf;
+	vf->dev_type = get_dev_type(pdev);
+	vf->base = pcim_iomap_table(pdev);
+
+	adapter->pdev = pdev;
+	adapter->vdpa.dma_dev = &pdev->dev;
+
+	ret = ifcvf_init_hw(vf, pdev);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to init IFCVF hw\n");
+		return ret;
+	}
+
+	for (i = 0; i < vf->nr_vring; i++)
+		vf->vring[i].irq = -EINVAL;
+
+	vf->hw_features = ifcvf_get_hw_features(vf);
+	vf->config_size = ifcvf_get_config_size(vf);
+
+	ifcvf_mgmt_dev = kzalloc(sizeof(struct ifcvf_vdpa_mgmt_dev), GFP_KERNEL);
+	if (!ifcvf_mgmt_dev) {
+		IFCVF_ERR(pdev, "Failed to alloc memory for the vDPA management device\n");
+		return -ENOMEM;
+	}
+
+	ifcvf_mgmt_dev->mdev.ops = &ifcvf_vdpa_mgmt_dev_ops;
+	ifcvf_mgmt_dev->mdev.device = dev;
+	ifcvf_mgmt_dev->adapter = adapter;
+
+	dev_type = get_dev_type(pdev);
+	switch (dev_type) {
+	case VIRTIO_ID_NET:
+		ifcvf_mgmt_dev->mdev.id_table = id_table_net;
+		break;
+	case VIRTIO_ID_BLOCK:
+		ifcvf_mgmt_dev->mdev.id_table = id_table_blk;
+		break;
+	default:
+		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", dev_type);
+		ret = -EOPNOTSUPP;
+		goto err;
+	}
+
+	ifcvf_mgmt_dev->mdev.max_supported_vqs = vf->nr_vring;
+	ifcvf_mgmt_dev->mdev.supported_features = vf->hw_features;
+
+	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
+
+
 	ret = vdpa_mgmtdev_register(&ifcvf_mgmt_dev->mdev);
 	if (ret) {
 		IFCVF_ERR(pdev,
-- 
2.31.1

