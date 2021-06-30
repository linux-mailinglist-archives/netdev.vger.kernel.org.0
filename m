Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BB53B7EF9
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 10:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhF3Ia2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 04:30:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:52739 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233610AbhF3Ia0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 04:30:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="208131959"
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="208131959"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 01:27:58 -0700
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="419912857"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 01:27:56 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 2/3] vDPA/ifcvf: implement management netlink framework for ifcvf
Date:   Wed, 30 Jun 2021 16:21:44 +0800
Message-Id: <20210630082145.5729-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210630082145.5729-1-lingshan.zhu@intel.com>
References: <20210630082145.5729-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implments the management netlink framework for ifcvf,
including register and add / remove a device

It works with iprouter2:
[root@localhost lszhu]# vdpa mgmtdev show -jp
{
    "mgmtdev": {
        "pci/0000:01:00.5": {
            "supported_classes": [ "net" ]
        },
        "pci/0000:01:00.6": {
            "supported_classes": [ "net" ]
        }
    }
}

[root@localhost lszhu]# vdpa dev add mgmtdev pci/0000:01:00.5 name vdpa0
[root@localhost lszhu]# vdpa dev add mgmtdev pci/0000:01:00.6 name vdpa1

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h |   6 ++
 drivers/vdpa/ifcvf/ifcvf_main.c | 156 ++++++++++++++++++++++++--------
 2 files changed, 126 insertions(+), 36 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index ded1b1b5fb13..e5251fcbb200 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -104,6 +104,12 @@ struct ifcvf_lm_cfg {
 	struct ifcvf_vring_lm_cfg vring_lm_cfg[IFCVF_MAX_QUEUE_PAIRS];
 };
 
+struct ifcvf_vdpa_mgmt_dev {
+	struct vdpa_mgmt_dev mdev;
+	struct ifcvf_adapter *adapter;
+	struct pci_dev *pdev;
+};
+
 int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev);
 int ifcvf_start_hw(struct ifcvf_hw *hw);
 void ifcvf_stop_hw(struct ifcvf_hw *hw);
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 5f70ab1283a0..7c2f64ca2163 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -442,6 +442,16 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.set_config_cb  = ifcvf_vdpa_set_config_cb,
 };
 
+static struct virtio_device_id id_table_net[] = {
+	{VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID},
+	{0},
+};
+
+static struct virtio_device_id id_table_blk[] = {
+	{VIRTIO_ID_BLOCK, VIRTIO_DEV_ANY_ID},
+	{0},
+};
+
 static u32 get_dev_type(struct pci_dev *pdev)
 {
 	u32 dev_type;
@@ -462,48 +472,30 @@ static u32 get_dev_type(struct pci_dev *pdev)
 	return dev_type;
 }
 
-static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
 {
-	struct device *dev = &pdev->dev;
+	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
 	struct ifcvf_adapter *adapter;
+	struct pci_dev *pdev;
 	struct ifcvf_hw *vf;
+	struct device *dev;
 	int ret, i;
 
-	ret = pcim_enable_device(pdev);
-	if (ret) {
-		IFCVF_ERR(pdev, "Failed to enable device\n");
-		return ret;
-	}
-
-	ret = pcim_iomap_regions(pdev, BIT(0) | BIT(2) | BIT(4),
-				 IFCVF_DRIVER_NAME);
-	if (ret) {
-		IFCVF_ERR(pdev, "Failed to request MMIO region\n");
-		return ret;
-	}
-
-	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
-	if (ret) {
-		IFCVF_ERR(pdev, "No usable DMA configuration\n");
-		return ret;
-	}
-
-	ret = devm_add_action_or_reset(dev, ifcvf_free_irq_vectors, pdev);
-	if (ret) {
-		IFCVF_ERR(pdev,
-			  "Failed for adding devres for freeing irq vectors\n");
-		return ret;
-	}
+	ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
+	if (ifcvf_mgmt_dev->adapter)
+		return -EOPNOTSUPP;
 
+	pdev = ifcvf_mgmt_dev->pdev;
+	dev = &pdev->dev;
 	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
-				    dev, &ifc_vdpa_ops, NULL);
-	if (adapter == NULL) {
+				    dev, &ifc_vdpa_ops, name);
+	if (!adapter) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
 		return -ENOMEM;
 	}
 
-	pci_set_master(pdev);
-	pci_set_drvdata(pdev, adapter);
+	ifcvf_mgmt_dev->adapter = adapter;
+	pci_set_drvdata(pdev, ifcvf_mgmt_dev);
 
 	vf = &adapter->vf;
 	vf->dev_type = get_dev_type(pdev);
@@ -515,7 +507,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = ifcvf_init_hw(vf, pdev);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to init IFCVF hw\n");
-		goto err;
+		return ret;
 	}
 
 	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++)
@@ -523,9 +515,94 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	vf->hw_features = ifcvf_get_hw_features(vf);
 
-	ret = vdpa_register_device(&adapter->vdpa, IFCVF_MAX_QUEUE_PAIRS * 2);
+	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
+	ret = _vdpa_register_device(&adapter->vdpa, IFCVF_MAX_QUEUE_PAIRS * 2);
 	if (ret) {
-		IFCVF_ERR(pdev, "Failed to register ifcvf to vdpa bus");
+		IFCVF_ERR(pdev, "Failed to register to vDPA bus");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
+{
+	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
+
+	ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
+	_vdpa_unregister_device(dev);
+	ifcvf_mgmt_dev->adapter = NULL;
+}
+
+static const struct vdpa_mgmtdev_ops ifcvf_vdpa_mgmt_dev_ops = {
+	.dev_add = ifcvf_vdpa_dev_add,
+	.dev_del = ifcvf_vdpa_dev_del
+};
+
+static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
+	struct device *dev = &pdev->dev;
+	struct ifcvf_adapter *adapter;
+	u32 dev_type;
+	int ret;
+
+	ifcvf_mgmt_dev = kzalloc(sizeof(struct ifcvf_vdpa_mgmt_dev), GFP_KERNEL);
+	if (!ifcvf_mgmt_dev) {
+		IFCVF_ERR(pdev, "Failed to alloc memory for the vDPA management device\n");
+		return -ENOMEM;
+	}
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
+	ifcvf_mgmt_dev->mdev.ops = &ifcvf_vdpa_mgmt_dev_ops;
+	ifcvf_mgmt_dev->mdev.device = dev;
+	ifcvf_mgmt_dev->pdev = pdev;
+
+	ret = pcim_enable_device(pdev);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to enable device\n");
+		goto err;
+	}
+
+	ret = pcim_iomap_regions(pdev, BIT(0) | BIT(2) | BIT(4),
+				 IFCVF_DRIVER_NAME);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to request MMIO region\n");
+		goto err;
+	}
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	if (ret) {
+		IFCVF_ERR(pdev, "No usable DMA configuration\n");
+		goto err;
+	}
+
+	ret = devm_add_action_or_reset(dev, ifcvf_free_irq_vectors, pdev);
+	if (ret) {
+		IFCVF_ERR(pdev,
+			  "Failed for adding devres for freeing irq vectors\n");
+		goto err;
+	}
+
+	pci_set_master(pdev);
+
+	ret = vdpa_mgmtdev_register(&ifcvf_mgmt_dev->mdev);
+	if (ret) {
+		IFCVF_ERR(pdev,
+			  "Failed to initialize the management interfaces\n");
 		goto err;
 	}
 
@@ -533,14 +610,21 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err:
 	put_device(&adapter->vdpa.dev);
+	kfree(ifcvf_mgmt_dev);
 	return ret;
 }
 
 static void ifcvf_remove(struct pci_dev *pdev)
 {
-	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
+	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
+	struct ifcvf_adapter *adapter;
+
+	ifcvf_mgmt_dev = pci_get_drvdata(pdev);
+	adapter = ifcvf_mgmt_dev->adapter;
+	if (adapter)
+		vdpa_unregister_device(&adapter->vdpa);
 
-	vdpa_unregister_device(&adapter->vdpa);
+	kfree(ifcvf_mgmt_dev);
 }
 
 static struct pci_device_id ifcvf_pci_ids[] = {
-- 
2.27.0

