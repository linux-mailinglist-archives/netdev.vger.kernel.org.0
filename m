Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1FDA43D92
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731845AbfFMPmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:42:55 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731844AbfFMJsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 05:48:25 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 94377E61FDE62515F05F;
        Thu, 13 Jun 2019 17:48:22 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Jun 2019 17:48:16 +0800
From:   Xue Chaojing <xuechaojing@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoshaokai@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <xuechaojing@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: [PATCH net-next v3 2/2] hinic: add support for rss parameters with ethtool
Date:   Thu, 13 Jun 2019 01:58:02 +0000
Message-ID: <20190613015802.3916-3-xuechaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190613015802.3916-1-xuechaojing@huawei.com>
References: <20190613015802.3916-1-xuechaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support rss parameters with ethtool,
user can change hash key, hash indirection table, hash
function by ethtool -X, and show rss parameters by ethtool -x.

Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/Makefile    |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |   2 +
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 508 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  12 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    | 134 +----
 .../net/ethernet/huawei/hinic/hinic_port.c    | 126 +++++
 .../net/ethernet/huawei/hinic/hinic_port.h    |  47 ++
 7 files changed, 696 insertions(+), 135 deletions(-)
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
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index 8926768280f2..5c9bc3319880 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -85,6 +85,8 @@ struct hinic_dev {
 	u16				num_rss;
 	u16				rss_limit;
 	struct hinic_rss_type		rss_type;
+	u8				*rss_hkey_user;
+	s32				*rss_indir_user;
 };
 
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
new file mode 100644
index 000000000000..53c73060210e
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -0,0 +1,508 @@
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
+	if (err) {
+		netif_err(nic_dev, drv, netdev,
+			  "Failed to get port capabilities\n");
+		return err;
+	}
+
+	err = hinic_port_link_state(nic_dev, &link_state);
+	if (err) {
+		netif_err(nic_dev, drv, netdev,
+			  "Failed to get port link state\n");
+		return err;
+	}
+
+	if (link_state != HINIC_LINK_STATE_UP) {
+		netif_info(nic_dev, drv, netdev, "No link\n");
+		return err;
+	}
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
+static int hinic_get_rss_hash_opts(struct hinic_dev *nic_dev,
+				   struct ethtool_rxnfc *cmd)
+{
+	struct hinic_rss_type rss_type = { 0 };
+	int err;
+
+	cmd->data = 0;
+
+	if (!(nic_dev->flags & HINIC_RSS_ENABLE))
+		return 0;
+
+	err = hinic_get_rss_type(nic_dev, nic_dev->rss_tmpl_idx,
+				 &rss_type);
+	if (err) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Failed to get rss type\n");
+		return err;
+	}
+
+	cmd->data = RXH_IP_SRC | RXH_IP_DST;
+	switch (cmd->flow_type) {
+	case TCP_V4_FLOW:
+		if (rss_type.tcp_ipv4)
+			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
+	case TCP_V6_FLOW:
+		if (rss_type.tcp_ipv6)
+			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
+	case UDP_V4_FLOW:
+		if (rss_type.udp_ipv4)
+			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
+	case UDP_V6_FLOW:
+		if (rss_type.udp_ipv6)
+			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
+	case IPV4_FLOW:
+	case IPV6_FLOW:
+		break;
+	default:
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Unsupported flow type\n");
+		cmd->data = 0;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int set_l4_rss_hash_ops(struct ethtool_rxnfc *cmd,
+			       struct hinic_rss_type *rss_type)
+{
+	u8 rss_l4_en = 0;
+
+	switch (cmd->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
+	case 0:
+		rss_l4_en = 0;
+		break;
+	case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+		rss_l4_en = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (cmd->flow_type) {
+	case TCP_V4_FLOW:
+		rss_type->tcp_ipv4 = rss_l4_en;
+		break;
+	case TCP_V6_FLOW:
+		rss_type->tcp_ipv6 = rss_l4_en;
+		break;
+	case UDP_V4_FLOW:
+		rss_type->udp_ipv4 = rss_l4_en;
+		break;
+	case UDP_V6_FLOW:
+		rss_type->udp_ipv6 = rss_l4_en;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hinic_set_rss_hash_opts(struct hinic_dev *nic_dev,
+				   struct ethtool_rxnfc *cmd)
+{
+	struct hinic_rss_type *rss_type = &nic_dev->rss_type;
+	int err;
+
+	if (!(nic_dev->flags & HINIC_RSS_ENABLE)) {
+		cmd->data = 0;
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "RSS is disable, not support to set flow-hash\n");
+		return -EOPNOTSUPP;
+	}
+
+	/* RSS does not support anything other than hashing
+	 * to queues on src and dst IPs and ports
+	 */
+	if (cmd->data & ~(RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 |
+		RXH_L4_B_2_3))
+		return -EINVAL;
+
+	/* We need at least the IP SRC and DEST fields for hashing */
+	if (!(cmd->data & RXH_IP_SRC) || !(cmd->data & RXH_IP_DST))
+		return -EINVAL;
+
+	err = hinic_get_rss_type(nic_dev,
+				 nic_dev->rss_tmpl_idx, rss_type);
+	if (err) {
+		netif_err(nic_dev, drv, nic_dev->netdev, "Failed to get rss type\n");
+		return -EFAULT;
+	}
+
+	switch (cmd->flow_type) {
+	case TCP_V4_FLOW:
+	case TCP_V6_FLOW:
+	case UDP_V4_FLOW:
+	case UDP_V6_FLOW:
+		err = set_l4_rss_hash_ops(cmd, rss_type);
+		if (err)
+			return err;
+		break;
+	case IPV4_FLOW:
+		rss_type->ipv4 = 1;
+		break;
+	case IPV6_FLOW:
+		rss_type->ipv6 = 1;
+		break;
+	default:
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Unsupported flow type\n");
+		return -EINVAL;
+	}
+
+	err = hinic_set_rss_type(nic_dev, nic_dev->rss_tmpl_idx,
+				 *rss_type);
+	if (err) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Failed to set rss type\n");
+		return -EFAULT;
+	}
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Set rss hash options success\n");
+
+	return 0;
+}
+
+static int __set_rss_rxfh(struct net_device *netdev,
+			  const u32 *indir, const u8 *key)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	int err;
+
+	if (indir) {
+		if (!nic_dev->rss_indir_user) {
+			nic_dev->rss_indir_user =
+				kzalloc(sizeof(u32) * HINIC_RSS_INDIR_SIZE,
+					GFP_KERNEL);
+			if (!nic_dev->rss_indir_user) {
+				netif_err(nic_dev, drv, netdev,
+					  "Failed to alloc memory for rss_indir_usr\n");
+				return -ENOMEM;
+			}
+		}
+
+		memcpy(nic_dev->rss_indir_user, indir,
+		       sizeof(u32) * HINIC_RSS_INDIR_SIZE);
+
+		err = hinic_rss_set_indir_tbl(nic_dev,
+					      nic_dev->rss_tmpl_idx, indir);
+		if (err) {
+			netif_err(nic_dev, drv, netdev,
+				  "Failed to set rss indir table\n");
+			return -EFAULT;
+		}
+
+		netif_info(nic_dev, drv, netdev, "Change rss indir success\n");
+	}
+
+	if (key) {
+		if (!nic_dev->rss_hkey_user) {
+			nic_dev->rss_hkey_user =
+				kzalloc(HINIC_RSS_KEY_SIZE * 2, GFP_KERNEL);
+
+			if (!nic_dev->rss_hkey_user) {
+				netif_err(nic_dev, drv, netdev,
+					  "Failed to alloc memory for rss_hkey_user\n");
+				return -ENOMEM;
+			}
+		}
+
+		memcpy(nic_dev->rss_hkey_user, key, HINIC_RSS_KEY_SIZE);
+
+		err = hinic_rss_set_template_tbl(nic_dev,
+						 nic_dev->rss_tmpl_idx, key);
+		if (err) {
+			netif_err(nic_dev, drv, netdev, "Failed to set rss key\n");
+			return -EFAULT;
+		}
+
+		netif_info(nic_dev, drv, netdev, "Change rss key success\n");
+	}
+
+	return 0;
+}
+
+static int hinic_get_rxnfc(struct net_device *netdev,
+			   struct ethtool_rxnfc *cmd, u32 *rule_locs)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	int err = 0;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_GRXRINGS:
+		cmd->data = nic_dev->num_qps;
+		break;
+	case ETHTOOL_GRXFH:
+		err = hinic_get_rss_hash_opts(nic_dev, cmd);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int hinic_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	int err = 0;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_SRXFH:
+		err = hinic_set_rss_hash_opts(nic_dev, cmd);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int hinic_get_rxfh(struct net_device *netdev,
+			  u32 *indir, u8 *key, u8 *hfunc)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	u8 hash_engine_type = 0;
+	int err = 0;
+
+	if (!(nic_dev->flags & HINIC_RSS_ENABLE))
+		return -EOPNOTSUPP;
+
+	if (hfunc) {
+		err = hinic_rss_get_hash_engine(nic_dev,
+						nic_dev->rss_tmpl_idx,
+						&hash_engine_type);
+		if (err)
+			return -EFAULT;
+
+		*hfunc = hash_engine_type ? ETH_RSS_HASH_TOP : ETH_RSS_HASH_XOR;
+	}
+
+	if (indir) {
+		err = hinic_rss_get_indir_tbl(nic_dev,
+					      nic_dev->rss_tmpl_idx, indir);
+		if (err)
+			return -EFAULT;
+	}
+
+	if (key)
+		err = hinic_rss_get_template_tbl(nic_dev,
+						 nic_dev->rss_tmpl_idx, key);
+
+	return err;
+}
+
+static int hinic_set_rxfh(struct net_device *netdev, const u32 *indir,
+			  const u8 *key, const u8 hfunc)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	int err = 0;
+
+	if (!(nic_dev->flags & HINIC_RSS_ENABLE)) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Not support to set rss parameters when rss is disable\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE) {
+		if (hfunc != ETH_RSS_HASH_TOP && hfunc != ETH_RSS_HASH_XOR) {
+			netif_err(nic_dev, drv, netdev,
+				  "Not support to set hfunc type except TOP and XOR\n");
+			return -EOPNOTSUPP;
+		}
+
+		nic_dev->rss_hash_engine = (hfunc == ETH_RSS_HASH_XOR) ?
+			HINIC_RSS_HASH_ENGINE_TYPE_XOR :
+			HINIC_RSS_HASH_ENGINE_TYPE_TOEP;
+		err = hinic_rss_set_hash_engine
+			(nic_dev, nic_dev->rss_tmpl_idx,
+			nic_dev->rss_hash_engine);
+		if (err)
+			return -EFAULT;
+
+		netif_info(nic_dev, drv, netdev,
+			   "Change hfunc to RSS_HASH_%s success\n",
+			   (hfunc == ETH_RSS_HASH_XOR) ? "XOR" : "TOP");
+	}
+
+	err = __set_rss_rxfh(netdev, indir, key);
+
+	return err;
+}
+
+static u32 hinic_get_rxfh_key_size(struct net_device *netdev)
+{
+	return HINIC_RSS_KEY_SIZE;
+}
+
+static u32 hinic_get_rxfh_indir_size(struct net_device *netdev)
+{
+	return HINIC_RSS_INDIR_SIZE;
+}
+
+static const struct ethtool_ops hinic_ethtool_ops = {
+	.get_link_ksettings = hinic_get_link_ksettings,
+	.get_drvinfo = hinic_get_drvinfo,
+	.get_link = ethtool_op_get_link,
+	.get_ringparam = hinic_get_ringparam,
+	.get_channels = hinic_get_channels,
+	.get_rxnfc = hinic_get_rxnfc,
+	.set_rxnfc = hinic_set_rxnfc,
+	.get_rxfh_key_size = hinic_get_rxfh_key_size,
+	.get_rxfh_indir_size = hinic_get_rxfh_indir_size,
+	.get_rxfh = hinic_get_rxfh,
+	.set_rxfh = hinic_set_rxfh,
+
+};
+
+void hinic_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &hinic_ethtool_ops;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 9c55374077f7..eb0af9bb0a0a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -54,11 +54,21 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_SET_RX_CSUM	= 26,
 
+	HINIC_PORT_CMD_GET_RSS_TEMPLATE_INDIR_TBL = 37,
+
 	HINIC_PORT_CMD_SET_PORT_STATE   = 41,
 
 	HINIC_PORT_CMD_SET_RSS_TEMPLATE_TBL = 43,
 
-	HINIC_PORT_CMD_SET_RSS_HASH_ENGINE  = 45,
+	HINIC_PORT_CMD_GET_RSS_TEMPLATE_TBL = 44,
+
+	HINIC_PORT_CMD_SET_RSS_HASH_ENGINE = 45,
+
+	HINIC_PORT_CMD_GET_RSS_HASH_ENGINE = 46,
+
+	HINIC_PORT_CMD_GET_RSS_CTX_TBL	= 47,
+
+	HINIC_PORT_CMD_SET_RSS_CTX_TBL	= 48,
 
 	HINIC_PORT_CMD_RSS_TEMP_MGR	= 49,
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 5135754b7bd8..f04b571e403f 100644
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
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 92a0ec00f1b7..b7bb47d4626e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -625,6 +625,36 @@ int hinic_rss_set_indir_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
 	return err;
 }
 
+int hinic_rss_get_indir_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
+			    u32 *indir_table)
+{
+	struct hinic_rss_indir_table rss_cfg = { 0 };
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size = sizeof(rss_cfg);
+	int err = 0, i;
+
+	rss_cfg.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	rss_cfg.template_id = (u8)tmpl_idx;
+
+	err = hinic_port_msg_cmd(hwdev,
+				 HINIC_PORT_CMD_GET_RSS_TEMPLATE_INDIR_TBL,
+				 &rss_cfg, sizeof(rss_cfg), &rss_cfg,
+				 &out_size);
+	if (err || !out_size || rss_cfg.status) {
+		dev_err(&pdev->dev, "Failed to get indir table, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, rss_cfg.status, out_size);
+		return -EINVAL;
+	}
+
+	hinic_be32_to_cpu(rss_cfg.indir, HINIC_RSS_INDIR_SIZE);
+	for (i = 0; i < HINIC_RSS_INDIR_SIZE; i++)
+		indir_table[i] = rss_cfg.indir[i];
+
+	return 0;
+}
+
 int hinic_set_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
 		       struct hinic_rss_type rss_type)
 {
@@ -685,6 +715,44 @@ int hinic_set_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
 	return 0;
 }
 
+int hinic_get_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
+		       struct hinic_rss_type *rss_type)
+{
+	struct hinic_rss_context_table ctx_tbl = { 0 };
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size = sizeof(ctx_tbl);
+	int err;
+
+	if (!hwdev || !rss_type)
+		return -EINVAL;
+
+	ctx_tbl.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	ctx_tbl.template_id = (u8)tmpl_idx;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_RSS_CTX_TBL,
+				 &ctx_tbl, sizeof(ctx_tbl),
+				 &ctx_tbl, &out_size);
+	if (err || !out_size || ctx_tbl.status) {
+		dev_err(&pdev->dev, "Failed to get hash type, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, ctx_tbl.status, out_size);
+		return -EINVAL;
+	}
+
+	rss_type->ipv4		= HINIC_RSS_TYPE_GET(ctx_tbl.context, IPV4);
+	rss_type->ipv6		= HINIC_RSS_TYPE_GET(ctx_tbl.context, IPV6);
+	rss_type->ipv6_ext	= HINIC_RSS_TYPE_GET(ctx_tbl.context, IPV6_EXT);
+	rss_type->tcp_ipv4	= HINIC_RSS_TYPE_GET(ctx_tbl.context, TCP_IPV4);
+	rss_type->tcp_ipv6	= HINIC_RSS_TYPE_GET(ctx_tbl.context, TCP_IPV6);
+	rss_type->tcp_ipv6_ext	= HINIC_RSS_TYPE_GET(ctx_tbl.context,
+						     TCP_IPV6_EXT);
+	rss_type->udp_ipv4	= HINIC_RSS_TYPE_GET(ctx_tbl.context, UDP_IPV4);
+	rss_type->udp_ipv6	= HINIC_RSS_TYPE_GET(ctx_tbl.context, UDP_IPV6);
+
+	return 0;
+}
+
 int hinic_rss_set_template_tbl(struct hinic_dev *nic_dev, u32 template_id,
 			       const u8 *temp)
 {
@@ -712,6 +780,36 @@ int hinic_rss_set_template_tbl(struct hinic_dev *nic_dev, u32 template_id,
 	return 0;
 }
 
+int hinic_rss_get_template_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
+			       u8 *temp)
+{
+	struct hinic_rss_template_key temp_key = { 0 };
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size = sizeof(temp_key);
+	int err;
+
+	if (!hwdev || !temp)
+		return -EINVAL;
+
+	temp_key.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	temp_key.template_id = (u8)tmpl_idx;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_RSS_TEMPLATE_TBL,
+				 &temp_key, sizeof(temp_key),
+				 &temp_key, &out_size);
+	if (err || !out_size || temp_key.status) {
+		dev_err(&pdev->dev, "Failed to set hash key, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, temp_key.status, out_size);
+		return -EINVAL;
+	}
+
+	memcpy(temp, temp_key.key, HINIC_RSS_KEY_SIZE);
+
+	return 0;
+}
+
 int hinic_rss_set_hash_engine(struct hinic_dev *nic_dev, u8 template_id,
 			      u8 type)
 {
@@ -739,6 +837,34 @@ int hinic_rss_set_hash_engine(struct hinic_dev *nic_dev, u8 template_id,
 	return 0;
 }
 
+int hinic_rss_get_hash_engine(struct hinic_dev *nic_dev, u8 tmpl_idx, u8 *type)
+{
+	struct hinic_rss_engine_type hash_type = { 0 };
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size = sizeof(hash_type);
+	int err;
+
+	if (!hwdev || !type)
+		return -EINVAL;
+
+	hash_type.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	hash_type.template_id = tmpl_idx;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_RSS_HASH_ENGINE,
+				 &hash_type, sizeof(hash_type),
+				 &hash_type, &out_size);
+	if (err || !out_size || hash_type.status) {
+		dev_err(&pdev->dev, "Failed to get hash engine, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, hash_type.status, out_size);
+		return -EINVAL;
+	}
+
+	*type = hash_type.hash_engine;
+	return 0;
+}
+
 int hinic_rss_cfg(struct hinic_dev *nic_dev, u8 rss_en, u8 template_id)
 {
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 0c9ed17134a7..f9e02ff119b7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -242,6 +242,17 @@ struct hinic_rss_template_mgmt {
 	u8	rsvd1[4];
 };
 
+struct hinic_rss_template_key {
+	u8		status;
+	u8		version;
+	u8		rsvd0[6];
+
+	u16		func_id;
+	u8		template_id;
+	u8		rsvd1;
+	u8		key[HINIC_RSS_KEY_SIZE];
+};
+
 struct hinic_rss_context_tbl {
 	u32 group_index;
 	u32 offset;
@@ -250,6 +261,17 @@ struct hinic_rss_context_tbl {
 	u32 ctx;
 };
 
+struct hinic_rss_context_table {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u8	template_id;
+	u8	rsvd1;
+	u32	context;
+};
+
 struct hinic_rss_indirect_tbl {
 	u32 group_index;
 	u32 offset;
@@ -258,6 +280,17 @@ struct hinic_rss_indirect_tbl {
 	u8 entry[HINIC_RSS_INDIR_SIZE];
 };
 
+struct hinic_rss_indir_table {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u8	template_id;
+	u8	rsvd1;
+	u8	indir[HINIC_RSS_INDIR_SIZE];
+};
+
 struct hinic_rss_key {
 	u8	status;
 	u8	version;
@@ -332,18 +365,32 @@ int hinic_set_rx_lro_state(struct hinic_dev *nic_dev, u8 lro_en,
 int hinic_set_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
 		       struct hinic_rss_type rss_type);
 
+int hinic_get_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
+		       struct hinic_rss_type *rss_type);
+
 int hinic_rss_set_indir_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
 			    const u32 *indir_table);
 
+int hinic_rss_get_indir_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
+			    u32 *indir_table);
+
 int hinic_rss_set_template_tbl(struct hinic_dev *nic_dev, u32 template_id,
 			       const u8 *temp);
 
+int hinic_rss_get_template_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
+			       u8 *temp);
+
 int hinic_rss_set_hash_engine(struct hinic_dev *nic_dev, u8 template_id,
 			      u8 type);
 
+int hinic_rss_get_hash_engine(struct hinic_dev *nic_dev, u8 tmpl_idx,
+			      u8 *type);
+
 int hinic_rss_cfg(struct hinic_dev *nic_dev, u8 rss_en, u8 template_id);
 
 int hinic_rss_template_alloc(struct hinic_dev *nic_dev, u8 *tmpl_idx);
 
 int hinic_rss_template_free(struct hinic_dev *nic_dev, u8 tmpl_idx);
+
+void hinic_set_ethtool_ops(struct net_device *netdev);
 #endif
-- 
2.17.1

