Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462374A386
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbfFROLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:11:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19038 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729668AbfFROLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 10:11:07 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 831F08D63C477775D037;
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
Subject: [PATCH net-next v5 1/3] hinic: add rss support
Date:   Tue, 18 Jun 2019 06:20:51 +0000
Message-ID: <20190618062053.7545-2-xuechaojing@huawei.com>
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

This patch adds rss support for the HINIC driver.

Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  26 ++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  10 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  26 ++
 .../net/ethernet/huawei/hinic/hinic_hw_wqe.h  |  16 ++
 .../net/ethernet/huawei/hinic/hinic_main.c    | 126 ++++++++-
 .../net/ethernet/huawei/hinic/hinic_port.c    | 263 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    |  82 ++++++
 7 files changed, 541 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index 5186cc9023aa..8926768280f2 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -31,6 +31,7 @@
 enum hinic_flags {
 	HINIC_LINK_UP = BIT(0),
 	HINIC_INTF_UP = BIT(1),
+	HINIC_RSS_ENABLE = BIT(2),
 };
 
 struct hinic_rx_mode_work {
@@ -38,6 +39,23 @@ struct hinic_rx_mode_work {
 	u32                     rx_mode;
 };
 
+struct hinic_rss_type {
+	u8 tcp_ipv6_ext;
+	u8 ipv6_ext;
+	u8 tcp_ipv6;
+	u8 ipv6;
+	u8 tcp_ipv4;
+	u8 ipv4;
+	u8 udp_ipv6;
+	u8 udp_ipv4;
+};
+
+enum hinic_rss_hash_type {
+	HINIC_RSS_HASH_ENGINE_TYPE_XOR,
+	HINIC_RSS_HASH_ENGINE_TYPE_TOEP,
+	HINIC_RSS_HASH_ENGINE_TYPE_MAX,
+};
+
 struct hinic_dev {
 	struct net_device               *netdev;
 	struct hinic_hwdev              *hwdev;
@@ -45,6 +63,8 @@ struct hinic_dev {
 	u32                             msg_enable;
 	unsigned int                    tx_weight;
 	unsigned int                    rx_weight;
+	u16				num_qps;
+	u16				max_qps;
 
 	unsigned int                    flags;
 
@@ -59,6 +79,12 @@ struct hinic_dev {
 
 	struct hinic_txq_stats          tx_stats;
 	struct hinic_rxq_stats          rx_stats;
+
+	u8				rss_tmpl_idx;
+	u8				rss_hash_engine;
+	u16				num_rss;
+	u16				rss_limit;
+	struct hinic_rss_type		rss_type;
 };
 
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 756a7e3280bd..5e01672fd47b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -98,9 +98,6 @@ static int get_capability(struct hinic_hwdev *hwdev,
 	if (nic_cap->num_qps > HINIC_Q_CTXT_MAX)
 		nic_cap->num_qps = HINIC_Q_CTXT_MAX;
 
-	/* num_qps must be power of 2 */
-	nic_cap->num_qps = BIT(fls(nic_cap->num_qps) - 1);
-
 	nic_cap->max_qps = dev_cap->max_sqs + 1;
 	if (nic_cap->max_qps != (dev_cap->max_rqs + 1))
 		return -EFAULT;
@@ -883,6 +880,13 @@ void hinic_free_hwdev(struct hinic_hwdev *hwdev)
 	hinic_free_hwif(hwdev->hwif);
 }
 
+int hinic_hwdev_max_num_qps(struct hinic_hwdev *hwdev)
+{
+	struct hinic_cap *nic_cap = &hwdev->nic_cap;
+
+	return nic_cap->max_qps;
+}
+
 /**
  * hinic_hwdev_num_qps - return the number QPs available for use
  * @hwdev: the NIC HW device
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index fba4fe82472a..9c55374077f7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -56,6 +56,14 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_SET_PORT_STATE   = 41,
 
+	HINIC_PORT_CMD_SET_RSS_TEMPLATE_TBL = 43,
+
+	HINIC_PORT_CMD_SET_RSS_HASH_ENGINE  = 45,
+
+	HINIC_PORT_CMD_RSS_TEMP_MGR	= 49,
+
+	HINIC_PORT_CMD_RSS_CFG		= 66,
+
 	HINIC_PORT_CMD_FWCTXT_INIT      = 69,
 
 	HINIC_PORT_CMD_SET_FUNC_STATE   = 93,
@@ -71,6 +79,22 @@ enum hinic_port_cmd {
 	HINIC_PORT_CMD_SET_LRO_TIMER	= 244,
 };
 
+enum hinic_ucode_cmd {
+	HINIC_UCODE_CMD_MODIFY_QUEUE_CONTEXT    = 0,
+	HINIC_UCODE_CMD_CLEAN_QUEUE_CONTEXT,
+	HINIC_UCODE_CMD_ARM_SQ,
+	HINIC_UCODE_CMD_ARM_RQ,
+	HINIC_UCODE_CMD_SET_RSS_INDIR_TABLE,
+	HINIC_UCODE_CMD_SET_RSS_CONTEXT_TABLE,
+	HINIC_UCODE_CMD_GET_RSS_INDIR_TABLE,
+	HINIC_UCODE_CMD_GET_RSS_CONTEXT_TABLE,
+	HINIC_UCODE_CMD_SET_IQ_ENABLE,
+	HINIC_UCODE_CMD_SET_RQ_FLUSH            = 10
+};
+
+#define NIC_RSS_CMD_TEMP_ALLOC  0x01
+#define NIC_RSS_CMD_TEMP_FREE   0x02
+
 enum hinic_mgmt_msg_cmd {
 	HINIC_MGMT_MSG_CMD_BASE         = 160,
 
@@ -230,6 +254,8 @@ struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev);
 
 void hinic_free_hwdev(struct hinic_hwdev *hwdev);
 
+int hinic_hwdev_max_num_qps(struct hinic_hwdev *hwdev);
+
 int hinic_hwdev_num_qps(struct hinic_hwdev *hwdev);
 
 struct hinic_sq *hinic_hwdev_get_sq(struct hinic_hwdev *hwdev, int i);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
index ef852b7b57a3..a441b0b89d6f 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
@@ -239,6 +239,22 @@
 #define HINIC_GET_RX_PKT_TYPE(offload_type)	\
 			RQ_CQE_OFFOLAD_TYPE_GET(offload_type, PKT_TYPE)
 
+#define HINIC_RSS_TYPE_VALID_SHIFT			23
+#define HINIC_RSS_TYPE_TCP_IPV6_EXT_SHIFT		24
+#define HINIC_RSS_TYPE_IPV6_EXT_SHIFT			25
+#define HINIC_RSS_TYPE_TCP_IPV6_SHIFT			26
+#define HINIC_RSS_TYPE_IPV6_SHIFT			27
+#define HINIC_RSS_TYPE_TCP_IPV4_SHIFT			28
+#define HINIC_RSS_TYPE_IPV4_SHIFT			29
+#define HINIC_RSS_TYPE_UDP_IPV6_SHIFT			30
+#define HINIC_RSS_TYPE_UDP_IPV4_SHIFT			31
+
+#define HINIC_RSS_TYPE_SET(val, member)                        \
+		(((u32)(val) & 0x1) << HINIC_RSS_TYPE_##member##_SHIFT)
+
+#define HINIC_RSS_TYPE_GET(val, member)                        \
+		(((u32)(val) >> HINIC_RSS_TYPE_##member##_SHIFT) & 0x1)
+
 enum hinic_l4offload_type {
 	HINIC_L4_OFF_DISABLE            = 0,
 	HINIC_TCP_OFFLOAD_ENABLE        = 1,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 419880564ee5..3020d21ce788 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -391,11 +391,118 @@ static int hinic_configure_max_qnum(struct hinic_dev *nic_dev)
 	return 0;
 }
 
+static int hinic_rss_init(struct hinic_dev *nic_dev)
+{
+	u32 indir_tbl[HINIC_RSS_INDIR_SIZE] = { 0 };
+	u8 default_rss_key[HINIC_RSS_KEY_SIZE];
+	u8 tmpl_idx = nic_dev->rss_tmpl_idx;
+	int err, i;
+
+	netdev_rss_key_fill(default_rss_key, sizeof(default_rss_key));
+	for (i = 0; i < HINIC_RSS_INDIR_SIZE; i++)
+		indir_tbl[i] = ethtool_rxfh_indir_default(i, nic_dev->num_rss);
+
+	err = hinic_rss_set_template_tbl(nic_dev, tmpl_idx, default_rss_key);
+	if (err)
+		return err;
+
+	err = hinic_rss_set_indir_tbl(nic_dev, tmpl_idx, indir_tbl);
+	if (err)
+		return err;
+
+	err = hinic_set_rss_type(nic_dev, tmpl_idx, nic_dev->rss_type);
+	if (err)
+		return err;
+
+	err = hinic_rss_set_hash_engine(nic_dev, tmpl_idx,
+					nic_dev->rss_hash_engine);
+	if (err)
+		return err;
+
+	err = hinic_rss_cfg(nic_dev, 1, tmpl_idx);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void hinic_rss_deinit(struct hinic_dev *nic_dev)
+{
+	hinic_rss_cfg(nic_dev, 0, nic_dev->rss_tmpl_idx);
+}
+
+static void hinic_init_rss_parameters(struct hinic_dev *nic_dev)
+{
+	nic_dev->rss_hash_engine = HINIC_RSS_HASH_ENGINE_TYPE_XOR;
+	nic_dev->rss_type.tcp_ipv6_ext = 1;
+	nic_dev->rss_type.ipv6_ext = 1;
+	nic_dev->rss_type.tcp_ipv6 = 1;
+	nic_dev->rss_type.ipv6 = 1;
+	nic_dev->rss_type.tcp_ipv4 = 1;
+	nic_dev->rss_type.ipv4 = 1;
+	nic_dev->rss_type.udp_ipv6 = 1;
+	nic_dev->rss_type.udp_ipv4 = 1;
+}
+
+static void hinic_enable_rss(struct hinic_dev *nic_dev)
+{
+	struct net_device *netdev = nic_dev->netdev;
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	int i, node, err = 0;
+	u16 num_cpus = 0;
+
+	nic_dev->max_qps = hinic_hwdev_max_num_qps(hwdev);
+	if (nic_dev->max_qps <= 1) {
+		nic_dev->flags &= ~HINIC_RSS_ENABLE;
+		nic_dev->rss_limit = nic_dev->max_qps;
+		nic_dev->num_qps = nic_dev->max_qps;
+		nic_dev->num_rss = nic_dev->max_qps;
+
+		return;
+	}
+
+	err = hinic_rss_template_alloc(nic_dev, &nic_dev->rss_tmpl_idx);
+	if (err) {
+		netif_err(nic_dev, drv, netdev,
+			  "Failed to alloc tmpl_idx for rss, can't enable rss for this function\n");
+		nic_dev->flags &= ~HINIC_RSS_ENABLE;
+		nic_dev->max_qps = 1;
+		nic_dev->rss_limit = nic_dev->max_qps;
+		nic_dev->num_qps = nic_dev->max_qps;
+		nic_dev->num_rss = nic_dev->max_qps;
+
+		return;
+	}
+
+	nic_dev->flags |= HINIC_RSS_ENABLE;
+
+	for (i = 0; i < num_online_cpus(); i++) {
+		node = cpu_to_node(i);
+		if (node == dev_to_node(&pdev->dev))
+			num_cpus++;
+	}
+
+	if (!num_cpus)
+		num_cpus = num_online_cpus();
+
+	nic_dev->num_qps = min_t(u16, nic_dev->max_qps, num_cpus);
+
+	nic_dev->rss_limit = nic_dev->num_qps;
+	nic_dev->num_rss = nic_dev->num_qps;
+
+	hinic_init_rss_parameters(nic_dev);
+	err = hinic_rss_init(nic_dev);
+	if (err)
+		netif_err(nic_dev, drv, netdev, "Failed to init rss\n");
+}
+
 static int hinic_open(struct net_device *netdev)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	enum hinic_port_link_state link_state;
-	int err, ret, num_qps;
+	int err, ret;
 
 	if (!(nic_dev->flags & HINIC_INTF_UP)) {
 		err = hinic_hwdev_ifup(nic_dev->hwdev);
@@ -420,6 +527,8 @@ static int hinic_open(struct net_device *netdev)
 		goto err_create_rxqs;
 	}
 
+	hinic_enable_rss(nic_dev);
+
 	err = hinic_configure_max_qnum(nic_dev);
 	if (err) {
 		netif_err(nic_dev, drv, nic_dev->netdev,
@@ -427,9 +536,8 @@ static int hinic_open(struct net_device *netdev)
 		goto err_port_state;
 	}
 
-	num_qps = hinic_hwdev_num_qps(nic_dev->hwdev);
-	netif_set_real_num_tx_queues(netdev, num_qps);
-	netif_set_real_num_rx_queues(netdev, num_qps);
+	netif_set_real_num_tx_queues(netdev, nic_dev->num_qps);
+	netif_set_real_num_rx_queues(netdev, nic_dev->num_qps);
 
 	err = hinic_port_set_state(nic_dev, HINIC_PORT_ENABLE);
 	if (err) {
@@ -485,9 +593,12 @@ static int hinic_open(struct net_device *netdev)
 	if (ret)
 		netif_warn(nic_dev, drv, netdev,
 			   "Failed to revert port state\n");
-
 err_port_state:
 	free_rxqs(nic_dev);
+	if (nic_dev->flags & HINIC_RSS_ENABLE) {
+		hinic_rss_deinit(nic_dev);
+		hinic_rss_template_free(nic_dev, nic_dev->rss_tmpl_idx);
+	}
 
 err_create_rxqs:
 	free_txqs(nic_dev);
@@ -531,6 +642,11 @@ static int hinic_close(struct net_device *netdev)
 		return err;
 	}
 
+	if (nic_dev->flags & HINIC_RSS_ENABLE) {
+		hinic_rss_deinit(nic_dev);
+		hinic_rss_template_free(nic_dev, nic_dev->rss_tmpl_idx);
+	}
+
 	free_rxqs(nic_dev);
 	free_txqs(nic_dev);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index c9aedecd19c9..510cde869ddf 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -553,3 +553,266 @@ int hinic_set_rx_lro_state(struct hinic_dev *nic_dev, u8 lro_en,
 
 	return 0;
 }
+
+int hinic_rss_set_indir_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
+			    const u32 *indir_table)
+{
+	struct hinic_rss_indirect_tbl *indir_tbl;
+	struct hinic_func_to_io *func_to_io;
+	struct hinic_cmdq_buf cmd_buf;
+	struct hinic_hwdev *hwdev;
+	struct hinic_hwif *hwif;
+	struct pci_dev *pdev;
+	u32 indir_size;
+	u64 out_param;
+	int err, i;
+	u32 *temp;
+
+	hwdev = nic_dev->hwdev;
+	func_to_io = &hwdev->func_to_io;
+	hwif = hwdev->hwif;
+	pdev = hwif->pdev;
+
+	err = hinic_alloc_cmdq_buf(&func_to_io->cmdqs, &cmd_buf);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to allocate cmdq buf\n");
+		return err;
+	}
+
+	cmd_buf.size = sizeof(*indir_tbl);
+
+	indir_tbl = cmd_buf.buf;
+	indir_tbl->group_index = cpu_to_be32(tmpl_idx);
+
+	for (i = 0; i < HINIC_RSS_INDIR_SIZE; i++) {
+		indir_tbl->entry[i] = indir_table[i];
+
+		if (0x3 == (i & 0x3)) {
+			temp = (u32 *)&indir_tbl->entry[i - 3];
+			*temp = cpu_to_be32(*temp);
+		}
+	}
+
+	/* cfg the rss indirect table by command queue */
+	indir_size = HINIC_RSS_INDIR_SIZE / 2;
+	indir_tbl->offset = 0;
+	indir_tbl->size = cpu_to_be32(indir_size);
+
+	err = hinic_cmdq_direct_resp(&func_to_io->cmdqs, HINIC_MOD_L2NIC,
+				     HINIC_UCODE_CMD_SET_RSS_INDIR_TABLE,
+				     &cmd_buf, &out_param);
+	if (err || out_param != 0) {
+		dev_err(&pdev->dev, "Failed to set rss indir table\n");
+		err = -EFAULT;
+		goto free_buf;
+	}
+
+	indir_tbl->offset = cpu_to_be32(indir_size);
+	indir_tbl->size = cpu_to_be32(indir_size);
+	memcpy(&indir_tbl->entry[0], &indir_tbl->entry[indir_size], indir_size);
+
+	err = hinic_cmdq_direct_resp(&func_to_io->cmdqs, HINIC_MOD_L2NIC,
+				     HINIC_UCODE_CMD_SET_RSS_INDIR_TABLE,
+				     &cmd_buf, &out_param);
+	if (err || out_param != 0) {
+		dev_err(&pdev->dev, "Failed to set rss indir table\n");
+		err = -EFAULT;
+	}
+
+free_buf:
+	hinic_free_cmdq_buf(&func_to_io->cmdqs, &cmd_buf);
+
+	return err;
+}
+
+int hinic_set_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
+		       struct hinic_rss_type rss_type)
+{
+	struct hinic_rss_context_tbl *ctx_tbl;
+	struct hinic_func_to_io *func_to_io;
+	struct hinic_cmdq_buf cmd_buf;
+	struct hinic_hwdev *hwdev;
+	struct hinic_hwif *hwif;
+	struct pci_dev *pdev;
+	u64 out_param;
+	u32 ctx = 0;
+	int err;
+
+	hwdev = nic_dev->hwdev;
+	func_to_io = &hwdev->func_to_io;
+	hwif = hwdev->hwif;
+	pdev = hwif->pdev;
+
+	err = hinic_alloc_cmdq_buf(&func_to_io->cmdqs, &cmd_buf);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to allocate cmd buf\n");
+		return -ENOMEM;
+	}
+
+	ctx |=  HINIC_RSS_TYPE_SET(1, VALID) |
+		HINIC_RSS_TYPE_SET(rss_type.ipv4, IPV4) |
+		HINIC_RSS_TYPE_SET(rss_type.ipv6, IPV6) |
+		HINIC_RSS_TYPE_SET(rss_type.ipv6_ext, IPV6_EXT) |
+		HINIC_RSS_TYPE_SET(rss_type.tcp_ipv4, TCP_IPV4) |
+		HINIC_RSS_TYPE_SET(rss_type.tcp_ipv6, TCP_IPV6) |
+		HINIC_RSS_TYPE_SET(rss_type.tcp_ipv6_ext, TCP_IPV6_EXT) |
+		HINIC_RSS_TYPE_SET(rss_type.udp_ipv4, UDP_IPV4) |
+		HINIC_RSS_TYPE_SET(rss_type.udp_ipv6, UDP_IPV6);
+
+	cmd_buf.size = sizeof(struct hinic_rss_context_tbl);
+
+	ctx_tbl = (struct hinic_rss_context_tbl *)cmd_buf.buf;
+	ctx_tbl->group_index = cpu_to_be32(tmpl_idx);
+	ctx_tbl->offset = 0;
+	ctx_tbl->size = sizeof(u32);
+	ctx_tbl->size = cpu_to_be32(ctx_tbl->size);
+	ctx_tbl->rsvd = 0;
+	ctx_tbl->ctx = cpu_to_be32(ctx);
+
+	/* cfg the rss context table by command queue */
+	err = hinic_cmdq_direct_resp(&func_to_io->cmdqs, HINIC_MOD_L2NIC,
+				     HINIC_UCODE_CMD_SET_RSS_CONTEXT_TABLE,
+				     &cmd_buf, &out_param);
+
+	hinic_free_cmdq_buf(&func_to_io->cmdqs, &cmd_buf);
+
+	if (err || out_param != 0) {
+		dev_err(&pdev->dev, "Failed to set rss context table, err: %d\n",
+			err);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+int hinic_rss_set_template_tbl(struct hinic_dev *nic_dev, u32 template_id,
+			       const u8 *temp)
+{
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct hinic_rss_key rss_key = { 0 };
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size;
+	int err;
+
+	rss_key.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	rss_key.template_id = template_id;
+	memcpy(rss_key.key, temp, HINIC_RSS_KEY_SIZE);
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_RSS_TEMPLATE_TBL,
+				 &rss_key, sizeof(rss_key),
+				 &rss_key, &out_size);
+	if (err || !out_size || rss_key.status) {
+		dev_err(&pdev->dev,
+			"Failed to set rss hash key, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, rss_key.status, out_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int hinic_rss_set_hash_engine(struct hinic_dev *nic_dev, u8 template_id,
+			      u8 type)
+{
+	struct hinic_rss_engine_type rss_engine = { 0 };
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size;
+	int err;
+
+	rss_engine.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	rss_engine.hash_engine = type;
+	rss_engine.template_id = template_id;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_RSS_HASH_ENGINE,
+				 &rss_engine, sizeof(rss_engine),
+				 &rss_engine, &out_size);
+	if (err || !out_size || rss_engine.status) {
+		dev_err(&pdev->dev,
+			"Failed to set hash engine, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, rss_engine.status, out_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int hinic_rss_cfg(struct hinic_dev *nic_dev, u8 rss_en, u8 template_id)
+{
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_rss_config rss_cfg = { 0 };
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size;
+	int err;
+
+	rss_cfg.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	rss_cfg.rss_en = rss_en;
+	rss_cfg.template_id = template_id;
+	rss_cfg.rq_priority_number = 0;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_RSS_CFG,
+				 &rss_cfg, sizeof(rss_cfg),
+				 &rss_cfg, &out_size);
+	if (err || !out_size || rss_cfg.status) {
+		dev_err(&pdev->dev,
+			"Failed to set rss cfg, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, rss_cfg.status, out_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int hinic_rss_template_alloc(struct hinic_dev *nic_dev, u8 *tmpl_idx)
+{
+	struct hinic_rss_template_mgmt template_mgmt = { 0 };
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size;
+	int err;
+
+	template_mgmt.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	template_mgmt.cmd = NIC_RSS_CMD_TEMP_ALLOC;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_RSS_TEMP_MGR,
+				 &template_mgmt, sizeof(template_mgmt),
+				 &template_mgmt, &out_size);
+	if (err || !out_size || template_mgmt.status) {
+		dev_err(&pdev->dev, "Failed to alloc rss template, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, template_mgmt.status, out_size);
+		return -EINVAL;
+	}
+
+	*tmpl_idx = template_mgmt.template_id;
+
+	return 0;
+}
+
+int hinic_rss_template_free(struct hinic_dev *nic_dev, u8 tmpl_idx)
+{
+	struct hinic_rss_template_mgmt template_mgmt = { 0 };
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size;
+	int err;
+
+	template_mgmt.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	template_mgmt.template_id = tmpl_idx;
+	template_mgmt.cmd = NIC_RSS_CMD_TEMP_FREE;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_RSS_TEMP_MGR,
+				 &template_mgmt, sizeof(template_mgmt),
+				 &template_mgmt, &out_size);
+	if (err || !out_size || template_mgmt.status) {
+		dev_err(&pdev->dev, "Failed to free rss template, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, template_mgmt.status, out_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 972b7be460a8..0c9ed17134a7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -22,6 +22,9 @@
 
 #include "hinic_dev.h"
 
+#define HINIC_RSS_KEY_SIZE	40
+#define HINIC_RSS_INDIR_SIZE	256
+
 enum hinic_rx_mode {
 	HINIC_RX_MODE_UC        = BIT(0),
 	HINIC_RX_MODE_MC        = BIT(1),
@@ -228,6 +231,67 @@ struct hinic_lro_timer {
 	u32	timer;
 };
 
+struct hinic_rss_template_mgmt {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u8	cmd;
+	u8	template_id;
+	u8	rsvd1[4];
+};
+
+struct hinic_rss_context_tbl {
+	u32 group_index;
+	u32 offset;
+	u32 size;
+	u32 rsvd;
+	u32 ctx;
+};
+
+struct hinic_rss_indirect_tbl {
+	u32 group_index;
+	u32 offset;
+	u32 size;
+	u32 rsvd;
+	u8 entry[HINIC_RSS_INDIR_SIZE];
+};
+
+struct hinic_rss_key {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u8	template_id;
+	u8	rsvd1;
+	u8	key[HINIC_RSS_KEY_SIZE];
+};
+
+struct hinic_rss_engine_type {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u8	template_id;
+	u8	hash_engine;
+	u8	rsvd1[4];
+};
+
+struct hinic_rss_config {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u8	rss_en;
+	u8	template_id;
+	u8	rq_priority_number;
+	u8	rsvd1[11];
+};
+
 int hinic_port_add_mac(struct hinic_dev *nic_dev, const u8 *addr,
 		       u16 vlan_id);
 
@@ -264,4 +328,22 @@ int hinic_set_rx_csum_offload(struct hinic_dev *nic_dev, u32 en);
 
 int hinic_set_rx_lro_state(struct hinic_dev *nic_dev, u8 lro_en,
 			   u32 lro_timer, u32 wqe_num);
+
+int hinic_set_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
+		       struct hinic_rss_type rss_type);
+
+int hinic_rss_set_indir_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
+			    const u32 *indir_table);
+
+int hinic_rss_set_template_tbl(struct hinic_dev *nic_dev, u32 template_id,
+			       const u8 *temp);
+
+int hinic_rss_set_hash_engine(struct hinic_dev *nic_dev, u8 template_id,
+			      u8 type);
+
+int hinic_rss_cfg(struct hinic_dev *nic_dev, u8 rss_en, u8 template_id);
+
+int hinic_rss_template_alloc(struct hinic_dev *nic_dev, u8 *tmpl_idx);
+
+int hinic_rss_template_free(struct hinic_dev *nic_dev, u8 tmpl_idx);
 #endif
-- 
2.17.1

