Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8978A4A383
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfFROLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:11:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19036 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729061AbfFROLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 10:11:04 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7CF0AC2A64A012E13CAF;
        Tue, 18 Jun 2019 22:11:02 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Tue, 18 Jun 2019 22:10:55 +0800
From:   Xue Chaojing <xuechaojing@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoshaokai@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <xuechaojing@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: [PATCH net-next v5 2/3] hinic: move ethtool code into hinic_ethtool
Date:   Tue, 18 Jun 2019 06:20:52 +0000
Message-ID: <20190618062053.7545-3-xuechaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618062053.7545-1-xuechaojing@huawei.com>
References: <20190618062053.7545-1-xuechaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves ethtool code from hinic_main.c to hinic_ethtool.c

Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/Makefile    |   2 +-
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 163 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_main.c    | 134 +-------------
 .../net/ethernet/huawei/hinic/hinic_port.h    |   2 +
 4 files changed, 167 insertions(+), 134 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c

diff --git a/drivers/net/ethernet/huawei/hinic/Makefile b/drivers/net/ethernet/huawei/hinic/Makefile
index 289ce88bb2d0..c592f1a0f54b 100644
--- a/drivers/net/ethernet/huawei/hinic/Makefile
+++ b/drivers/net/ethernet/huawei/hinic/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_HINIC) += hinic.o
 hinic-y := hinic_main.o hinic_tx.o hinic_rx.o hinic_port.o hinic_hw_dev.o \
 	   hinic_hw_io.o hinic_hw_qp.o hinic_hw_cmdq.o hinic_hw_wq.o \
 	   hinic_hw_mgmt.o hinic_hw_api_cmd.o hinic_hw_eqs.o hinic_hw_if.o \
-	   hinic_common.o
+	   hinic_common.o hinic_ethtool.o
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
new file mode 100644
index 000000000000..2cc97bfef0b8
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/etherdevice.h>
+#include <linux/netdevice.h>
+#include <linux/if_vlan.h>
+#include <linux/ethtool.h>
+#include <linux/vmalloc.h>
+
+#include "hinic_hw_qp.h"
+#include "hinic_hw_dev.h"
+#include "hinic_port.h"
+#include "hinic_tx.h"
+#include "hinic_rx.h"
+#include "hinic_dev.h"
+
+static void set_link_speed(struct ethtool_link_ksettings *link_ksettings,
+			   enum hinic_speed speed)
+{
+	switch (speed) {
+	case HINIC_SPEED_10MB_LINK:
+		link_ksettings->base.speed = SPEED_10;
+		break;
+
+	case HINIC_SPEED_100MB_LINK:
+		link_ksettings->base.speed = SPEED_100;
+		break;
+
+	case HINIC_SPEED_1000MB_LINK:
+		link_ksettings->base.speed = SPEED_1000;
+		break;
+
+	case HINIC_SPEED_10GB_LINK:
+		link_ksettings->base.speed = SPEED_10000;
+		break;
+
+	case HINIC_SPEED_25GB_LINK:
+		link_ksettings->base.speed = SPEED_25000;
+		break;
+
+	case HINIC_SPEED_40GB_LINK:
+		link_ksettings->base.speed = SPEED_40000;
+		break;
+
+	case HINIC_SPEED_100GB_LINK:
+		link_ksettings->base.speed = SPEED_100000;
+		break;
+
+	default:
+		link_ksettings->base.speed = SPEED_UNKNOWN;
+		break;
+	}
+}
+
+static int hinic_get_link_ksettings(struct net_device *netdev,
+				    struct ethtool_link_ksettings
+				    *link_ksettings)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	enum hinic_port_link_state link_state;
+	struct hinic_port_cap port_cap;
+	int err;
+
+	ethtool_link_ksettings_zero_link_mode(link_ksettings, advertising);
+	ethtool_link_ksettings_add_link_mode(link_ksettings, supported,
+					     Autoneg);
+
+	link_ksettings->base.speed = SPEED_UNKNOWN;
+	link_ksettings->base.autoneg = AUTONEG_DISABLE;
+	link_ksettings->base.duplex = DUPLEX_UNKNOWN;
+
+	err = hinic_port_get_cap(nic_dev, &port_cap);
+	if (err)
+		return err;
+
+	err = hinic_port_link_state(nic_dev, &link_state);
+	if (err)
+		return err;
+
+	if (link_state != HINIC_LINK_STATE_UP)
+		return err;
+
+	set_link_speed(link_ksettings, port_cap.speed);
+
+	if (!!(port_cap.autoneg_cap & HINIC_AUTONEG_SUPPORTED))
+		ethtool_link_ksettings_add_link_mode(link_ksettings,
+						     advertising, Autoneg);
+
+	if (port_cap.autoneg_state == HINIC_AUTONEG_ACTIVE)
+		link_ksettings->base.autoneg = AUTONEG_ENABLE;
+
+	link_ksettings->base.duplex = (port_cap.duplex == HINIC_DUPLEX_FULL) ?
+					   DUPLEX_FULL : DUPLEX_HALF;
+	return 0;
+}
+
+static void hinic_get_drvinfo(struct net_device *netdev,
+			      struct ethtool_drvinfo *info)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+
+	strlcpy(info->driver, HINIC_DRV_NAME, sizeof(info->driver));
+	strlcpy(info->bus_info, pci_name(hwif->pdev), sizeof(info->bus_info));
+}
+
+static void hinic_get_ringparam(struct net_device *netdev,
+				struct ethtool_ringparam *ring)
+{
+	ring->rx_max_pending = HINIC_RQ_DEPTH;
+	ring->tx_max_pending = HINIC_SQ_DEPTH;
+	ring->rx_pending = HINIC_RQ_DEPTH;
+	ring->tx_pending = HINIC_SQ_DEPTH;
+}
+
+static void hinic_get_channels(struct net_device *netdev,
+			       struct ethtool_channels *channels)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+
+	channels->max_rx = hwdev->nic_cap.max_qps;
+	channels->max_tx = hwdev->nic_cap.max_qps;
+	channels->max_other = 0;
+	channels->max_combined = 0;
+	channels->rx_count = hinic_hwdev_num_qps(hwdev);
+	channels->tx_count = hinic_hwdev_num_qps(hwdev);
+	channels->other_count = 0;
+	channels->combined_count = 0;
+}
+
+static const struct ethtool_ops hinic_ethtool_ops = {
+	.get_link_ksettings = hinic_get_link_ksettings,
+	.get_drvinfo = hinic_get_drvinfo,
+	.get_link = ethtool_op_get_link,
+	.get_ringparam = hinic_get_ringparam,
+	.get_channels = hinic_get_channels,
+};
+
+void hinic_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &hinic_ethtool_ops;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 3020d21ce788..853fc3e7b514 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -80,138 +80,6 @@ static int set_features(struct hinic_dev *nic_dev,
 			netdev_features_t pre_features,
 			netdev_features_t features, bool force_change);
 
-static void set_link_speed(struct ethtool_link_ksettings *link_ksettings,
-			   enum hinic_speed speed)
-{
-	switch (speed) {
-	case HINIC_SPEED_10MB_LINK:
-		link_ksettings->base.speed = SPEED_10;
-		break;
-
-	case HINIC_SPEED_100MB_LINK:
-		link_ksettings->base.speed = SPEED_100;
-		break;
-
-	case HINIC_SPEED_1000MB_LINK:
-		link_ksettings->base.speed = SPEED_1000;
-		break;
-
-	case HINIC_SPEED_10GB_LINK:
-		link_ksettings->base.speed = SPEED_10000;
-		break;
-
-	case HINIC_SPEED_25GB_LINK:
-		link_ksettings->base.speed = SPEED_25000;
-		break;
-
-	case HINIC_SPEED_40GB_LINK:
-		link_ksettings->base.speed = SPEED_40000;
-		break;
-
-	case HINIC_SPEED_100GB_LINK:
-		link_ksettings->base.speed = SPEED_100000;
-		break;
-
-	default:
-		link_ksettings->base.speed = SPEED_UNKNOWN;
-		break;
-	}
-}
-
-static int hinic_get_link_ksettings(struct net_device *netdev,
-				    struct ethtool_link_ksettings
-				    *link_ksettings)
-{
-	struct hinic_dev *nic_dev = netdev_priv(netdev);
-	enum hinic_port_link_state link_state;
-	struct hinic_port_cap port_cap;
-	int err;
-
-	ethtool_link_ksettings_zero_link_mode(link_ksettings, advertising);
-	ethtool_link_ksettings_add_link_mode(link_ksettings, supported,
-					     Autoneg);
-
-	link_ksettings->base.speed   = SPEED_UNKNOWN;
-	link_ksettings->base.autoneg = AUTONEG_DISABLE;
-	link_ksettings->base.duplex  = DUPLEX_UNKNOWN;
-
-	err = hinic_port_get_cap(nic_dev, &port_cap);
-	if (err) {
-		netif_err(nic_dev, drv, netdev,
-			  "Failed to get port capabilities\n");
-		return err;
-	}
-
-	err = hinic_port_link_state(nic_dev, &link_state);
-	if (err) {
-		netif_err(nic_dev, drv, netdev,
-			  "Failed to get port link state\n");
-		return err;
-	}
-
-	if (link_state != HINIC_LINK_STATE_UP) {
-		netif_info(nic_dev, drv, netdev, "No link\n");
-		return err;
-	}
-
-	set_link_speed(link_ksettings, port_cap.speed);
-
-	if (!!(port_cap.autoneg_cap & HINIC_AUTONEG_SUPPORTED))
-		ethtool_link_ksettings_add_link_mode(link_ksettings,
-						     advertising, Autoneg);
-
-	if (port_cap.autoneg_state == HINIC_AUTONEG_ACTIVE)
-		link_ksettings->base.autoneg = AUTONEG_ENABLE;
-
-	link_ksettings->base.duplex = (port_cap.duplex == HINIC_DUPLEX_FULL) ?
-				       DUPLEX_FULL : DUPLEX_HALF;
-	return 0;
-}
-
-static void hinic_get_drvinfo(struct net_device *netdev,
-			      struct ethtool_drvinfo *info)
-{
-	struct hinic_dev *nic_dev = netdev_priv(netdev);
-	struct hinic_hwdev *hwdev = nic_dev->hwdev;
-	struct hinic_hwif *hwif = hwdev->hwif;
-
-	strlcpy(info->driver, HINIC_DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(hwif->pdev), sizeof(info->bus_info));
-}
-
-static void hinic_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
-{
-	ring->rx_max_pending = HINIC_RQ_DEPTH;
-	ring->tx_max_pending = HINIC_SQ_DEPTH;
-	ring->rx_pending = HINIC_RQ_DEPTH;
-	ring->tx_pending = HINIC_SQ_DEPTH;
-}
-
-static void hinic_get_channels(struct net_device *netdev,
-			       struct ethtool_channels *channels)
-{
-	struct hinic_dev *nic_dev = netdev_priv(netdev);
-	struct hinic_hwdev *hwdev = nic_dev->hwdev;
-
-	channels->max_rx = hwdev->nic_cap.max_qps;
-	channels->max_tx = hwdev->nic_cap.max_qps;
-	channels->max_other    = 0;
-	channels->max_combined = 0;
-	channels->rx_count = hinic_hwdev_num_qps(hwdev);
-	channels->tx_count = hinic_hwdev_num_qps(hwdev);
-	channels->other_count    = 0;
-	channels->combined_count = 0;
-}
-
-static const struct ethtool_ops hinic_ethtool_ops = {
-	.get_link_ksettings = hinic_get_link_ksettings,
-	.get_drvinfo = hinic_get_drvinfo,
-	.get_link = ethtool_op_get_link,
-	.get_ringparam = hinic_get_ringparam,
-	.get_channels = hinic_get_channels,
-};
-
 static void update_rx_stats(struct hinic_dev *nic_dev, struct hinic_rxq *rxq)
 {
 	struct hinic_rxq_stats *nic_rx_stats = &nic_dev->rx_stats;
@@ -1092,8 +960,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 		goto err_alloc_etherdev;
 	}
 
+	hinic_set_ethtool_ops(netdev);
 	netdev->netdev_ops = &hinic_netdev_ops;
-	netdev->ethtool_ops = &hinic_ethtool_ops;
 	netdev->max_mtu = ETH_MAX_MTU;
 
 	nic_dev = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 0c9ed17134a7..dafa3ca18af4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -346,4 +346,6 @@ int hinic_rss_cfg(struct hinic_dev *nic_dev, u8 rss_en, u8 template_id);
 int hinic_rss_template_alloc(struct hinic_dev *nic_dev, u8 *tmpl_idx);
 
 int hinic_rss_template_free(struct hinic_dev *nic_dev, u8 tmpl_idx);
+
+void hinic_set_ethtool_ops(struct net_device *netdev);
 #endif
-- 
2.17.1

