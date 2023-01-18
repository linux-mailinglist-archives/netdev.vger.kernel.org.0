Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0B2671BD4
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjARMTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjARMRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:17:06 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF284582BC;
        Wed, 18 Jan 2023 03:40:53 -0800 (PST)
X-UUID: f39d17ac972411eda06fc9ecc4dadd91-20230118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=vpgMJzpOoEOVmlNj4npECoeFCW5rzmZS1y+wN/5mdVM=;
        b=M+/xTtdrmPuXidnu3LuvfXEnwMlx6LECW/O3MwUf0UGvKxTGapeI4STLBMtUH6BdFU+Eba6NYdJfuvH0Z4Ieqts/wPvcuyHwOScLgkJs0d9pJK6QgveagzT+pwvIBGs9FSyXnn2/YOOZxj0OXjWMCUrWHVr1ZSb4SQKKVo40Km8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:c429c2d3-fd73-4ca0-abfd-2d52eb82cf98,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:3ca2d6b,CLOUDID:5d979e8c-8530-4eff-9f77-222cf6e2895b,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
X-CID-BVR: 0
X-UUID: f39d17ac972411eda06fc9ecc4dadd91-20230118
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1373416093; Wed, 18 Jan 2023 19:40:48 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 18 Jan 2023 19:40:47 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 18 Jan 2023 19:40:45 +0800
From:   Yanchao Yang <yanchao.yang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
CC:     Intel experts <linuxwwan@intel.com>,
        Chetan <m.chetan.kumar@intel.com>,
        MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        Yanchao Yang <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: [PATCH net-next v2 02/12] net: wwan: tmi: Add control plane transaction layer
Date:   Wed, 18 Jan 2023 19:38:49 +0800
Message-ID: <20230118113859.175836-3-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230118113859.175836-1-yanchao.yang@mediatek.com>
References: <20230118113859.175836-1-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The control plane implements TX services that reside in the transaction layer.
The services receive the packets from the port layer and call the corresponding
DMA components to transmit data to the device. Meanwhile, TX services receive
and manage the port control commands from the port layer.

The control plane implements RX services that reside in the transaction layer.
The services receive the downlink packets from the modem and transfer the
packets to the corresponding port layer interfaces.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
Signed-off-by: Mingliang Xu <mingliang.xu@mediatek.com>
---
 drivers/net/wwan/mediatek/Makefile         |  4 +-
 drivers/net/wwan/mediatek/mtk_ctrl_plane.c | 48 ++++++++++++++++++++++
 drivers/net/wwan/mediatek/mtk_ctrl_plane.h | 30 ++++++++++++++
 drivers/net/wwan/mediatek/mtk_dev.c        | 24 +++++++++++
 drivers/net/wwan/mediatek/mtk_dev.h        |  6 +++
 drivers/net/wwan/mediatek/pcie/mtk_pci.c   |  9 ++++
 6 files changed, 120 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wwan/mediatek/mtk_ctrl_plane.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_ctrl_plane.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_dev.c

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index 5ba75d0592d3..192f08e08a33 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -3,7 +3,9 @@
 MODULE_NAME := mtk_tmi
 
 mtk_tmi-y = \
-	pcie/mtk_pci.o
+	pcie/mtk_pci.o	\
+	mtk_dev.o	\
+	mtk_ctrl_plane.o
 
 ccflags-y += -I$(srctree)/$(src)/
 ccflags-y += -I$(srctree)/$(src)/pcie/
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.c b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
new file mode 100644
index 000000000000..2bd0b1c6027a
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/device.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+
+#include "mtk_ctrl_plane.h"
+
+/**
+ * mtk_ctrl_init() - allocate ctrl plane control block and initialize it
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_ctrl_init(struct mtk_md_dev *mdev)
+{
+	struct mtk_ctrl_blk *ctrl_blk;
+
+	ctrl_blk = devm_kzalloc(mdev->dev, sizeof(*ctrl_blk), GFP_KERNEL);
+	if (!ctrl_blk)
+		return -ENOMEM;
+
+	ctrl_blk->mdev = mdev;
+	mdev->ctrl_blk = ctrl_blk;
+
+	return 0;
+}
+
+/**
+ * mtk_ctrl_exit() - free ctrl plane control block
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_ctrl_exit(struct mtk_md_dev *mdev)
+{
+	struct mtk_ctrl_blk *ctrl_blk = mdev->ctrl_blk;
+
+	devm_kfree(mdev->dev, ctrl_blk);
+
+	return 0;
+}
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
new file mode 100644
index 000000000000..77af4248cb74
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_CTRL_PLANE_H__
+#define __MTK_CTRL_PLANE_H__
+
+#include <linux/kref.h>
+#include <linux/skbuff.h>
+
+#include "mtk_dev.h"
+
+#define VQ_MTU_3_5K			(0xE00)
+#define VQ_MTU_63K			(0xFC00)
+
+struct mtk_ctrl_trans {
+	struct mtk_ctrl_blk *ctrl_blk;
+	struct mtk_md_dev *mdev;
+};
+
+struct mtk_ctrl_blk {
+	struct mtk_md_dev *mdev;
+	struct mtk_ctrl_trans *trans;
+};
+
+int mtk_ctrl_init(struct mtk_md_dev *mdev);
+int mtk_ctrl_exit(struct mtk_md_dev *mdev);
+
+#endif /* __MTK_CTRL_PLANE_H__ */
diff --git a/drivers/net/wwan/mediatek/mtk_dev.c b/drivers/net/wwan/mediatek/mtk_dev.c
new file mode 100644
index 000000000000..7c4aac438775
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_dev.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include "mtk_ctrl_plane.h"
+#include "mtk_dev.h"
+
+int mtk_dev_init(struct mtk_md_dev *mdev)
+{
+	int ret;
+
+	ret = mtk_ctrl_init(mdev);
+	if (ret)
+		goto err_ctrl_init;
+
+err_ctrl_init:
+	return ret;
+}
+
+void mtk_dev_exit(struct mtk_md_dev *mdev)
+{
+	mtk_ctrl_exit(mdev);
+}
diff --git a/drivers/net/wwan/mediatek/mtk_dev.h b/drivers/net/wwan/mediatek/mtk_dev.h
index 312fbf66fffa..575c5da00aaf 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.h
+++ b/drivers/net/wwan/mediatek/mtk_dev.h
@@ -128,6 +128,8 @@ struct mtk_hw_ops {
  * @hw_ver:     to keep HW chip ID.
  * @msi_nvecs:  to keep the amount of aollocated irq vectors.
  * @dev_str:    to keep device B-D-F information.
+ * @ctrl_blk:   pointer to the context of control plane submodule.
+ * @bm_ctrl:    pointer to the context of buffer management submodule.
  */
 struct mtk_md_dev {
 	struct device *dev;
@@ -136,8 +138,12 @@ struct mtk_md_dev {
 	u32 hw_ver;
 	int msi_nvecs;
 	char dev_str[MTK_DEV_STR_LEN];
+	void *ctrl_blk;
+	struct mtk_bm_ctrl *bm_ctrl;
 };
 
+int mtk_dev_init(struct mtk_md_dev *mdev);
+void mtk_dev_exit(struct mtk_md_dev *mdev);
 /**
  * mtk_hw_read32() - Read dword from register.
  * @mdev: Device instance.
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.c b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
index 5261cebb61b1..80432f0627e6 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_pci.c
+++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
@@ -1008,6 +1008,12 @@ static int mtk_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto err_request_irq;
 
+	ret = mtk_dev_init(mdev);
+	if (ret) {
+		dev_err(mdev->dev, "Failed to init dev.\n");
+		goto err_dev_init;
+	}
+
 	ret = mtk_rgu_init(mdev);
 	if (ret)
 		goto err_rgu_init;
@@ -1032,6 +1038,8 @@ static int mtk_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_clear_master(pdev);
 	mtk_rgu_exit(mdev);
 err_rgu_init:
+	mtk_dev_exit(mdev);
+err_dev_init:
 	mtk_pci_free_irq(mdev);
 err_request_irq:
 	mtk_mhccif_exit(mdev);
@@ -1061,6 +1069,7 @@ static void mtk_pci_remove(struct pci_dev *pdev)
 	mtk_pci_mask_irq(mdev, priv->rgu_irq_id);
 	mtk_pci_mask_irq(mdev, priv->mhccif_irq_id);
 	pci_disable_pcie_error_reporting(pdev);
+	mtk_dev_exit(mdev);
 
 	ret = mtk_pci_fldr(mdev);
 	if (ret)
-- 
2.32.0

