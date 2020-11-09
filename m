Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C182AAFE4
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 04:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgKIDW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 22:22:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7615 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729192AbgKIDWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 22:22:25 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CTxBD0NRrzLvv0;
        Mon,  9 Nov 2020 11:22:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 9 Nov 2020 11:22:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 01/11] net: hns3: add support for configuring interrupt quantity limiting
Date:   Mon, 9 Nov 2020 11:22:29 +0800
Message-ID: <1604892159-19990-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QL(quantity limiting) means that hardware supports the interrupt
coalesce based on the frame quantity.  QL can be configured when
int_ql_max in device's specification is non-zero, so add support
to configure it. Also, rename two coalesce init function to fit
their purpose.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 65 ++++++++++++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 13 ++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 43 +++++++++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  1 +
 5 files changed, 105 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a362516..6e08719 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -237,35 +237,68 @@ void hns3_set_vector_coalesce_tx_gl(struct hns3_enet_tqp_vector *tqp_vector,
 	writel(tx_gl_reg, tqp_vector->mask_addr + HNS3_VECTOR_GL1_OFFSET);
 }
 
-static void hns3_vector_gl_rl_init(struct hns3_enet_tqp_vector *tqp_vector,
-				   struct hns3_nic_priv *priv)
+void hns3_set_vector_coalesce_tx_ql(struct hns3_enet_tqp_vector *tqp_vector,
+				    u32 ql_value)
 {
+	writel(ql_value, tqp_vector->mask_addr + HNS3_VECTOR_TX_QL_OFFSET);
+}
+
+void hns3_set_vector_coalesce_rx_ql(struct hns3_enet_tqp_vector *tqp_vector,
+				    u32 ql_value)
+{
+	writel(ql_value, tqp_vector->mask_addr + HNS3_VECTOR_RX_QL_OFFSET);
+}
+
+static void hns3_vector_coalesce_init(struct hns3_enet_tqp_vector *tqp_vector,
+				      struct hns3_nic_priv *priv)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(priv->ae_handle->pdev);
+	struct hns3_enet_coalesce *tx_coal = &tqp_vector->tx_group.coal;
+	struct hns3_enet_coalesce *rx_coal = &tqp_vector->rx_group.coal;
+
 	/* initialize the configuration for interrupt coalescing.
 	 * 1. GL (Interrupt Gap Limiter)
 	 * 2. RL (Interrupt Rate Limiter)
+	 * 3. QL (Interrupt Quantity Limiter)
 	 *
 	 * Default: enable interrupt coalescing self-adaptive and GL
 	 */
-	tqp_vector->tx_group.coal.gl_adapt_enable = 1;
-	tqp_vector->rx_group.coal.gl_adapt_enable = 1;
+	tx_coal->gl_adapt_enable = 1;
+	rx_coal->gl_adapt_enable = 1;
+
+	tx_coal->int_gl = HNS3_INT_GL_50K;
+	rx_coal->int_gl = HNS3_INT_GL_50K;
 
-	tqp_vector->tx_group.coal.int_gl = HNS3_INT_GL_50K;
-	tqp_vector->rx_group.coal.int_gl = HNS3_INT_GL_50K;
+	rx_coal->flow_level = HNS3_FLOW_LOW;
+	tx_coal->flow_level = HNS3_FLOW_LOW;
 
-	tqp_vector->rx_group.coal.flow_level = HNS3_FLOW_LOW;
-	tqp_vector->tx_group.coal.flow_level = HNS3_FLOW_LOW;
+	if (ae_dev->dev_specs.int_ql_max) {
+		tx_coal->ql_enable = 1;
+		rx_coal->ql_enable = 1;
+		tx_coal->int_ql_max = ae_dev->dev_specs.int_ql_max;
+		rx_coal->int_ql_max = ae_dev->dev_specs.int_ql_max;
+		tx_coal->int_ql = HNS3_INT_QL_DEFAULT_CFG;
+		rx_coal->int_ql = HNS3_INT_QL_DEFAULT_CFG;
+	}
 }
 
-static void hns3_vector_gl_rl_init_hw(struct hns3_enet_tqp_vector *tqp_vector,
-				      struct hns3_nic_priv *priv)
+static void
+hns3_vector_coalesce_init_hw(struct hns3_enet_tqp_vector *tqp_vector,
+			     struct hns3_nic_priv *priv)
 {
+	struct hns3_enet_coalesce *tx_coal = &tqp_vector->tx_group.coal;
+	struct hns3_enet_coalesce *rx_coal = &tqp_vector->rx_group.coal;
 	struct hnae3_handle *h = priv->ae_handle;
 
-	hns3_set_vector_coalesce_tx_gl(tqp_vector,
-				       tqp_vector->tx_group.coal.int_gl);
-	hns3_set_vector_coalesce_rx_gl(tqp_vector,
-				       tqp_vector->rx_group.coal.int_gl);
+	hns3_set_vector_coalesce_tx_gl(tqp_vector, tx_coal->int_gl);
+	hns3_set_vector_coalesce_rx_gl(tqp_vector, rx_coal->int_gl);
 	hns3_set_vector_coalesce_rl(tqp_vector, h->kinfo.int_rl_setting);
+
+	if (tx_coal->ql_enable)
+		hns3_set_vector_coalesce_tx_ql(tqp_vector, tx_coal->int_ql);
+
+	if (rx_coal->ql_enable)
+		hns3_set_vector_coalesce_rx_ql(tqp_vector, rx_coal->int_ql);
 }
 
 static int hns3_nic_set_real_num_queue(struct net_device *netdev)
@@ -3536,7 +3569,7 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 
 	for (i = 0; i < priv->vector_num; i++) {
 		tqp_vector = &priv->tqp_vector[i];
-		hns3_vector_gl_rl_init_hw(tqp_vector, priv);
+		hns3_vector_coalesce_init_hw(tqp_vector, priv);
 		tqp_vector->num_tqps = 0;
 	}
 
@@ -3632,7 +3665,7 @@ static int hns3_nic_alloc_vector_data(struct hns3_nic_priv *priv)
 		tqp_vector->idx = i;
 		tqp_vector->mask_addr = vector[i].io_addr;
 		tqp_vector->vector_irq = vector[i].vector;
-		hns3_vector_gl_rl_init(tqp_vector, priv);
+		hns3_vector_coalesce_init(tqp_vector, priv);
 	}
 
 out:
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 1c81dea..10990bd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -181,6 +181,8 @@ enum hns3_nic_state {
 #define HNS3_VECTOR_GL2_OFFSET			0x300
 #define HNS3_VECTOR_RL_OFFSET			0x900
 #define HNS3_VECTOR_RL_EN_B			6
+#define HNS3_VECTOR_TX_QL_OFFSET		0xe00
+#define HNS3_VECTOR_RX_QL_OFFSET		0xf00
 
 #define HNS3_RING_EN_B				0
 
@@ -427,9 +429,14 @@ enum hns3_flow_level_range {
 #define HNS3_INT_RL_MAX			0x00EC
 #define HNS3_INT_RL_ENABLE_MASK		0x40
 
+#define HNS3_INT_QL_DEFAULT_CFG		0x20
+
 struct hns3_enet_coalesce {
 	u16 int_gl;
-	u8 gl_adapt_enable;
+	u16 int_ql;
+	u16 int_ql_max;
+	u8 gl_adapt_enable:1;
+	u8 ql_enable:1;
 	enum hns3_flow_level_range flow_level;
 };
 
@@ -595,6 +602,10 @@ void hns3_set_vector_coalesce_tx_gl(struct hns3_enet_tqp_vector *tqp_vector,
 				    u32 gl_value);
 void hns3_set_vector_coalesce_rl(struct hns3_enet_tqp_vector *tqp_vector,
 				 u32 rl_value);
+void hns3_set_vector_coalesce_rx_ql(struct hns3_enet_tqp_vector *tqp_vector,
+				    u32 ql_value);
+void hns3_set_vector_coalesce_tx_ql(struct hns3_enet_tqp_vector *tqp_vector,
+				    u32 ql_value);
 
 void hns3_enable_vlan_filter(struct net_device *netdev, bool enable);
 void hns3_request_update_promisc_mode(struct hnae3_handle *handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6b07b27..9af7cb9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1115,6 +1115,9 @@ static int hns3_get_coalesce_per_queue(struct net_device *netdev, u32 queue,
 	cmd->tx_coalesce_usecs_high = h->kinfo.int_rl_setting;
 	cmd->rx_coalesce_usecs_high = h->kinfo.int_rl_setting;
 
+	cmd->tx_max_coalesced_frames = tx_vector->tx_group.coal.int_ql;
+	cmd->rx_max_coalesced_frames = rx_vector->rx_group.coal.int_ql;
+
 	return 0;
 }
 
@@ -1188,6 +1191,29 @@ static int hns3_check_rl_coalesce_para(struct net_device *netdev,
 	return 0;
 }
 
+static int hns3_check_ql_coalesce_param(struct net_device *netdev,
+					struct ethtool_coalesce *cmd)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
+
+	if ((cmd->tx_max_coalesced_frames || cmd->rx_max_coalesced_frames) &&
+	    !ae_dev->dev_specs.int_ql_max) {
+		netdev_err(netdev, "coalesced frames is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (cmd->tx_max_coalesced_frames > ae_dev->dev_specs.int_ql_max ||
+	    cmd->rx_max_coalesced_frames > ae_dev->dev_specs.int_ql_max) {
+		netdev_err(netdev,
+			   "invalid coalesced_frames value, range is 0-%u\n",
+			   ae_dev->dev_specs.int_ql_max);
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
 static int hns3_check_coalesce_para(struct net_device *netdev,
 				    struct ethtool_coalesce *cmd)
 {
@@ -1207,6 +1233,10 @@ static int hns3_check_coalesce_para(struct net_device *netdev,
 		return ret;
 	}
 
+	ret = hns3_check_ql_coalesce_param(netdev, cmd);
+	if (ret)
+		return ret;
+
 	if (cmd->use_adaptive_tx_coalesce == 1 ||
 	    cmd->use_adaptive_rx_coalesce == 1) {
 		netdev_info(netdev,
@@ -1238,6 +1268,9 @@ static void hns3_set_coalesce_per_queue(struct net_device *netdev,
 	tx_vector->tx_group.coal.int_gl = cmd->tx_coalesce_usecs;
 	rx_vector->rx_group.coal.int_gl = cmd->rx_coalesce_usecs;
 
+	tx_vector->tx_group.coal.int_ql = cmd->tx_max_coalesced_frames;
+	rx_vector->rx_group.coal.int_ql = cmd->rx_max_coalesced_frames;
+
 	hns3_set_vector_coalesce_tx_gl(tx_vector,
 				       tx_vector->tx_group.coal.int_gl);
 	hns3_set_vector_coalesce_rx_gl(rx_vector,
@@ -1245,6 +1278,13 @@ static void hns3_set_coalesce_per_queue(struct net_device *netdev,
 
 	hns3_set_vector_coalesce_rl(tx_vector, h->kinfo.int_rl_setting);
 	hns3_set_vector_coalesce_rl(rx_vector, h->kinfo.int_rl_setting);
+
+	if (tx_vector->tx_group.coal.ql_enable)
+		hns3_set_vector_coalesce_tx_ql(tx_vector,
+					       tx_vector->tx_group.coal.int_ql);
+	if (rx_vector->tx_group.coal.ql_enable)
+		hns3_set_vector_coalesce_rx_ql(rx_vector,
+					       rx_vector->rx_group.coal.int_ql);
 }
 
 static int hns3_set_coalesce(struct net_device *netdev,
@@ -1471,7 +1511,8 @@ static int hns3_get_module_eeprom(struct net_device *netdev,
 #define HNS3_ETHTOOL_COALESCE	(ETHTOOL_COALESCE_USECS |		\
 				 ETHTOOL_COALESCE_USE_ADAPTIVE |	\
 				 ETHTOOL_COALESCE_RX_USECS_HIGH |	\
-				 ETHTOOL_COALESCE_TX_USECS_HIGH)
+				 ETHTOOL_COALESCE_TX_USECS_HIGH |	\
+				 ETHTOOL_COALESCE_MAX_FRAMES)
 
 static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1f02640..8bcdb28 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1379,6 +1379,7 @@ static void hclge_parse_dev_specs(struct hclge_dev *hdev,
 	ae_dev->dev_specs.max_non_tso_bd_num = req0->max_non_tso_bd_num;
 	ae_dev->dev_specs.rss_ind_tbl_size =
 		le16_to_cpu(req0->rss_ind_tbl_size);
+	ae_dev->dev_specs.int_ql_max = le16_to_cpu(req0->int_ql_max);
 	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
 	ae_dev->dev_specs.max_tm_rate = le32_to_cpu(req0->max_tm_rate);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index c8e3fdd..8209be9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3004,6 +3004,7 @@ static void hclgevf_parse_dev_specs(struct hclgevf_dev *hdev,
 	ae_dev->dev_specs.max_non_tso_bd_num = req0->max_non_tso_bd_num;
 	ae_dev->dev_specs.rss_ind_tbl_size =
 					le16_to_cpu(req0->rss_ind_tbl_size);
+	ae_dev->dev_specs.int_ql_max = le16_to_cpu(req0->int_ql_max);
 	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
 }
 
-- 
2.7.4

