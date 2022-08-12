Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6783590FB9
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiHLKxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237736AbiHLKxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:53:08 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C20AA3C1;
        Fri, 12 Aug 2022 03:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660301587; x=1691837587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GxFwkxS5cRCWWPo/uQ64UKzAaDcsovAfTjCnRoqLw44=;
  b=Xusf1eWaAzjxFsIL/+00Cm6mKoR88vUKe1dOEW4QkZmxN+PKq112XdTi
   ZdnOLoRe6KrDjTLOosoEq9mOoYdfLb6vWzAFI/43jGY/+ZoyQ9+O2jhJo
   xpYDJn0nFV+dQhmixp7HANKCGX7CtglS3Mb97fI5oS4sSlVyOywt8UbzX
   ZaEouxZWVmwAjN68OLhZv5IwswkqtH7rIp4ZLFbSZ9muRmDH5/gQ3aBFI
   CuQQjPqiekTtgWbA4xa6Jm+WnIKzfigB5JjOK4NEmdekJFqJRPgfAZe5T
   G1fGw52NdusBtSVRcxidmgwfR9VOwnBqvI2/xEqFeBs5TV6Hp0X0onYFu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="271956282"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="271956282"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 03:53:07 -0700
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="665780593"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 03:53:04 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 2/6] vDPA/ifcvf: support userspace to query features and MQ of a management device
Date:   Fri, 12 Aug 2022 18:44:56 +0800
Message-Id: <20220812104500.163625-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220812104500.163625-1-lingshan.zhu@intel.com>
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

