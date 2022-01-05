Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1D6485467
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbiAEOZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:42 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:31072 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240695AbiAEOZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:21 -0500
Received: from kwepemi100010.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JTWrb1P3Tz1DKQZ;
        Wed,  5 Jan 2022 22:21:51 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100010.china.huawei.com (7.221.188.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 12/15] net: hns3: create new set of common tqp stats APIs for PF and VF reuse
Date:   Wed, 5 Jan 2022 22:20:12 +0800
Message-ID: <20220105142015.51097-13-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220105142015.51097-1-huangguangbin2@huawei.com>
References: <20220105142015.51097-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

This patch creates new set of common tqp stats structures and APIs for PF
and VF tqp stats module. Subfunctions such as get tqp stats, update tqp
stats and reset tqp stats are inclued in this patch.

These new common tqp stats APIs will be used to replace the old PF and VF
tqp stats APIs in next patches.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/Makefile  |   5 +-
 .../hns3/hns3_common/hclge_comm_cmd.h         |   2 +
 .../hns3/hns3_common/hclge_comm_tqp_stats.c   | 117 ++++++++++++++++++
 .../hns3/hns3_common/hclge_comm_tqp_stats.h   |  39 ++++++
 4 files changed, 161 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h

diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/ethernet/hisilicon/hns3/Makefile
index 00d0a8e7f234..6efea4662858 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -18,11 +18,12 @@ hns3-$(CONFIG_HNS3_DCB) += hns3_dcbnl.o
 obj-$(CONFIG_HNS3_HCLGEVF) += hclgevf.o
 
 hclgevf-objs = hns3vf/hclgevf_main.o hns3vf/hclgevf_mbx.o  hns3vf/hclgevf_devlink.o \
-		hns3_common/hclge_comm_cmd.o hns3_common/hclge_comm_rss.o
+		hns3_common/hclge_comm_cmd.o hns3_common/hclge_comm_rss.o hns3_common/hclge_comm_tqp_stats.o
 
 obj-$(CONFIG_HNS3_HCLGE) += hclge.o
 hclge-objs = hns3pf/hclge_main.o hns3pf/hclge_mdio.o hns3pf/hclge_tm.o \
 		hns3pf/hclge_mbx.o hns3pf/hclge_err.o  hns3pf/hclge_debugfs.o hns3pf/hclge_ptp.o hns3pf/hclge_devlink.o \
-		hns3_common/hclge_comm_cmd.o hns3_common/hclge_comm_rss.o
+		hns3_common/hclge_comm_cmd.o hns3_common/hclge_comm_rss.o hns3_common/hclge_comm_tqp_stats.o
+
 
 hclge-$(CONFIG_HNS3_DCB) += hns3pf/hclge_dcb.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index eb034f8f87db..72976eed930a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -110,6 +110,8 @@ enum HCLGE_COMM_API_CAP_BITS {
 
 enum hclge_comm_opcode_type {
 	HCLGE_COMM_OPC_QUERY_FW_VER		= 0x0001,
+	HCLGE_COMM_OPC_QUERY_TX_STATUS		= 0x0B03,
+	HCLGE_COMM_OPC_QUERY_RX_STATUS		= 0x0B13,
 	HCLGE_COMM_OPC_RSS_GENERIC_CFG		= 0x0D01,
 	HCLGE_COMM_OPC_RSS_INPUT_TUPLE		= 0x0D02,
 	HCLGE_COMM_OPC_RSS_INDIR_TABLE		= 0x0D07,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
new file mode 100644
index 000000000000..3a73cbb3eee1
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0+
+// Copyright (c) 2021-2021 Hisilicon Limited.
+
+#include <linux/err.h>
+
+#include "hnae3.h"
+#include "hclge_comm_cmd.h"
+#include "hclge_comm_tqp_stats.h"
+
+u64 *hclge_comm_tqps_get_stats(struct hnae3_handle *handle, u64 *data)
+{
+	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
+	struct hclge_comm_tqp *tqp;
+	u64 *buff = data;
+	u16 i;
+
+	for (i = 0; i < kinfo->num_tqps; i++) {
+		tqp = container_of(kinfo->tqp[i], struct hclge_comm_tqp, q);
+		*buff++ = tqp->tqp_stats.rcb_tx_ring_pktnum_rcd;
+	}
+
+	for (i = 0; i < kinfo->num_tqps; i++) {
+		tqp = container_of(kinfo->tqp[i], struct hclge_comm_tqp, q);
+		*buff++ = tqp->tqp_stats.rcb_rx_ring_pktnum_rcd;
+	}
+
+	return buff;
+}
+
+int hclge_comm_tqps_get_sset_count(struct hnae3_handle *handle)
+{
+	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
+
+	return kinfo->num_tqps * HCLGE_COMM_QUEUE_PAIR_SIZE;
+}
+
+u8 *hclge_comm_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
+{
+	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
+	u8 *buff = data;
+	u16 i;
+
+	for (i = 0; i < kinfo->num_tqps; i++) {
+		struct hclge_comm_tqp *tqp =
+			container_of(kinfo->tqp[i], struct hclge_comm_tqp, q);
+		snprintf(buff, ETH_GSTRING_LEN, "txq%u_pktnum_rcd", tqp->index);
+		buff += ETH_GSTRING_LEN;
+	}
+
+	for (i = 0; i < kinfo->num_tqps; i++) {
+		struct hclge_comm_tqp *tqp =
+			container_of(kinfo->tqp[i], struct hclge_comm_tqp, q);
+		snprintf(buff, ETH_GSTRING_LEN, "rxq%u_pktnum_rcd", tqp->index);
+		buff += ETH_GSTRING_LEN;
+	}
+
+	return buff;
+}
+
+int hclge_comm_tqps_update_stats(struct hnae3_handle *handle,
+				 struct hclge_comm_hw *hw)
+{
+	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
+	struct hclge_comm_tqp *tqp;
+	struct hclge_desc desc;
+	int ret;
+	u16 i;
+
+	for (i = 0; i < kinfo->num_tqps; i++) {
+		tqp = container_of(kinfo->tqp[i], struct hclge_comm_tqp, q);
+		hclge_comm_cmd_setup_basic_desc(&desc,
+						HCLGE_COMM_OPC_QUERY_RX_STATUS,
+						true);
+
+		desc.data[0] = cpu_to_le32(tqp->index);
+		ret = hclge_comm_cmd_send(hw, &desc, 1);
+		if (ret) {
+			dev_err(&hw->cmq.csq.pdev->dev,
+				"failed to get tqp stat, ret = %d, tx = %u.\n",
+				ret, i);
+			return ret;
+		}
+		tqp->tqp_stats.rcb_rx_ring_pktnum_rcd +=
+			le32_to_cpu(desc.data[1]);
+
+		hclge_comm_cmd_setup_basic_desc(&desc,
+						HCLGE_COMM_OPC_QUERY_TX_STATUS,
+						true);
+
+		desc.data[0] = cpu_to_le32(tqp->index & 0x1ff);
+		ret = hclge_comm_cmd_send(hw, &desc, 1);
+		if (ret) {
+			dev_err(&hw->cmq.csq.pdev->dev,
+				"failed to get tqp stat, ret = %d, rx = %u.\n",
+				ret, i);
+			return ret;
+		}
+		tqp->tqp_stats.rcb_tx_ring_pktnum_rcd +=
+			le32_to_cpu(desc.data[1]);
+	}
+
+	return 0;
+}
+
+void hclge_comm_reset_tqp_stats(struct hnae3_handle *handle)
+{
+	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
+	struct hclge_comm_tqp *tqp;
+	struct hnae3_queue *queue;
+	u16 i;
+
+	for (i = 0; i < kinfo->num_tqps; i++) {
+		queue = kinfo->tqp[i];
+		tqp = container_of(queue, struct hclge_comm_tqp, q);
+		memset(&tqp->tqp_stats, 0, sizeof(tqp->tqp_stats));
+	}
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h
new file mode 100644
index 000000000000..a46350162ee8
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+// Copyright (c) 2021-2021 Hisilicon Limited.
+
+#ifndef __HCLGE_COMM_TQP_STATS_H
+#define __HCLGE_COMM_TQP_STATS_H
+#include <linux/types.h>
+#include <linux/etherdevice.h>
+#include "hnae3.h"
+
+/* each tqp has TX & RX two queues */
+#define HCLGE_COMM_QUEUE_PAIR_SIZE 2
+
+/* TQP stats */
+struct hclge_comm_tqp_stats {
+	/* query_tqp_tx_queue_statistics ,opcode id:  0x0B03 */
+	u64 rcb_tx_ring_pktnum_rcd; /* 32bit */
+	/* query_tqp_rx_queue_statistics ,opcode id:  0x0B13 */
+	u64 rcb_rx_ring_pktnum_rcd; /* 32bit */
+};
+
+struct hclge_comm_tqp {
+	/* copy of device pointer from pci_dev,
+	 * used when perform DMA mapping
+	 */
+	struct device *dev;
+	struct hnae3_queue q;
+	struct hclge_comm_tqp_stats tqp_stats;
+	u16 index;	/* Global index in a NIC controller */
+
+	bool alloced;
+};
+
+u64 *hclge_comm_tqps_get_stats(struct hnae3_handle *handle, u64 *data);
+int hclge_comm_tqps_get_sset_count(struct hnae3_handle *handle);
+u8 *hclge_comm_tqps_get_strings(struct hnae3_handle *handle, u8 *data);
+void hclge_comm_reset_tqp_stats(struct hnae3_handle *handle);
+int hclge_comm_tqps_update_stats(struct hnae3_handle *handle,
+				 struct hclge_comm_hw *hw);
+#endif
-- 
2.33.0

