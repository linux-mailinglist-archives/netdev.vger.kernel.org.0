Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35254EAEC0
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfJaLXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:23:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5669 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726711AbfJaLXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:23:08 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2B38BBA11EC3B279E4BD;
        Thu, 31 Oct 2019 19:22:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 19:22:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 9/9] net: hns3: cleanup byte order issues when printed
Date:   Thu, 31 Oct 2019 19:23:24 +0800
Message-ID: <1572521004-36126-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
References: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

Though the hip08 and the IMP(Intelligent Management Processor)
have the same byte order right now, it is better to convert
__be or __le variable into the CPU's byte order before print.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  39 ++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 100 ++++++++++++---------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +-
 4 files changed, 83 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 466a6e3..6b328a2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -190,21 +190,24 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	addr = le64_to_cpu(tx_desc->addr);
 	dev_info(dev, "TX Queue Num: %u, BD Index: %u\n", q_num, tx_index);
 	dev_info(dev, "(TX)addr: %pad\n", &addr);
-	dev_info(dev, "(TX)vlan_tag: %u\n", tx_desc->tx.vlan_tag);
-	dev_info(dev, "(TX)send_size: %u\n", tx_desc->tx.send_size);
+	dev_info(dev, "(TX)vlan_tag: %u\n", le16_to_cpu(tx_desc->tx.vlan_tag));
+	dev_info(dev, "(TX)send_size: %u\n",
+		 le16_to_cpu(tx_desc->tx.send_size));
 	dev_info(dev, "(TX)vlan_tso: %u\n", tx_desc->tx.type_cs_vlan_tso);
 	dev_info(dev, "(TX)l2_len: %u\n", tx_desc->tx.l2_len);
 	dev_info(dev, "(TX)l3_len: %u\n", tx_desc->tx.l3_len);
 	dev_info(dev, "(TX)l4_len: %u\n", tx_desc->tx.l4_len);
-	dev_info(dev, "(TX)vlan_tag: %u\n", tx_desc->tx.outer_vlan_tag);
-	dev_info(dev, "(TX)tv: %u\n", tx_desc->tx.tv);
+	dev_info(dev, "(TX)vlan_tag: %u\n",
+		 le16_to_cpu(tx_desc->tx.outer_vlan_tag));
+	dev_info(dev, "(TX)tv: %u\n", le16_to_cpu(tx_desc->tx.tv));
 	dev_info(dev, "(TX)vlan_msec: %u\n", tx_desc->tx.ol_type_vlan_msec);
 	dev_info(dev, "(TX)ol2_len: %u\n", tx_desc->tx.ol2_len);
 	dev_info(dev, "(TX)ol3_len: %u\n", tx_desc->tx.ol3_len);
 	dev_info(dev, "(TX)ol4_len: %u\n", tx_desc->tx.ol4_len);
-	dev_info(dev, "(TX)paylen: %u\n", tx_desc->tx.paylen);
-	dev_info(dev, "(TX)vld_ra_ri: %u\n", tx_desc->tx.bdtp_fe_sc_vld_ra_ri);
-	dev_info(dev, "(TX)mss: %u\n", tx_desc->tx.mss);
+	dev_info(dev, "(TX)paylen: %u\n", le32_to_cpu(tx_desc->tx.paylen));
+	dev_info(dev, "(TX)vld_ra_ri: %u\n",
+		 le16_to_cpu(tx_desc->tx.bdtp_fe_sc_vld_ra_ri));
+	dev_info(dev, "(TX)mss: %u\n", le16_to_cpu(tx_desc->tx.mss));
 
 	ring  = &priv->ring[q_num + h->kinfo.num_tqps];
 	value = readl_relaxed(ring->tqp->io_base + HNS3_RING_RX_RING_TAIL_REG);
@@ -214,15 +217,19 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	addr = le64_to_cpu(rx_desc->addr);
 	dev_info(dev, "RX Queue Num: %u, BD Index: %u\n", q_num, rx_index);
 	dev_info(dev, "(RX)addr: %pad\n", &addr);
-	dev_info(dev, "(RX)l234_info: %u\n", rx_desc->rx.l234_info);
-	dev_info(dev, "(RX)pkt_len: %u\n", rx_desc->rx.pkt_len);
-	dev_info(dev, "(RX)size: %u\n", rx_desc->rx.size);
-	dev_info(dev, "(RX)rss_hash: %u\n", rx_desc->rx.rss_hash);
-	dev_info(dev, "(RX)fd_id: %u\n", rx_desc->rx.fd_id);
-	dev_info(dev, "(RX)vlan_tag: %u\n", rx_desc->rx.vlan_tag);
-	dev_info(dev, "(RX)o_dm_vlan_id_fb: %u\n", rx_desc->rx.o_dm_vlan_id_fb);
-	dev_info(dev, "(RX)ot_vlan_tag: %u\n", rx_desc->rx.ot_vlan_tag);
-	dev_info(dev, "(RX)bd_base_info: %u\n", rx_desc->rx.bd_base_info);
+	dev_info(dev, "(RX)l234_info: %u\n",
+		 le32_to_cpu(rx_desc->rx.l234_info));
+	dev_info(dev, "(RX)pkt_len: %u\n", le16_to_cpu(rx_desc->rx.pkt_len));
+	dev_info(dev, "(RX)size: %u\n", le16_to_cpu(rx_desc->rx.size));
+	dev_info(dev, "(RX)rss_hash: %u\n", le32_to_cpu(rx_desc->rx.rss_hash));
+	dev_info(dev, "(RX)fd_id: %u\n", le16_to_cpu(rx_desc->rx.fd_id));
+	dev_info(dev, "(RX)vlan_tag: %u\n", le16_to_cpu(rx_desc->rx.vlan_tag));
+	dev_info(dev, "(RX)o_dm_vlan_id_fb: %u\n",
+		 le16_to_cpu(rx_desc->rx.o_dm_vlan_id_fb));
+	dev_info(dev, "(RX)ot_vlan_tag: %u\n",
+		 le16_to_cpu(rx_desc->rx.ot_vlan_tag));
+	dev_info(dev, "(RX)bd_base_info: %u\n",
+		 le32_to_cpu(rx_desc->rx.bd_base_info));
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index d5a121a..ba05368 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1710,8 +1710,8 @@ static int hns3_ndo_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 	int ret = -EIO;
 
 	netif_dbg(h, drv, netdev,
-		  "set vf vlan: vf=%d, vlan=%u, qos=%u, vlan_proto=%u\n",
-		  vf, vlan, qos, vlan_proto);
+		  "set vf vlan: vf=%d, vlan=%u, qos=%u, vlan_proto=0x%x\n",
+		  vf, vlan, qos, ntohs(vlan_proto));
 
 	if (h->ae_algo->ops->set_vf_vlan_filter)
 		ret = h->ae_algo->ops->set_vf_vlan_filter(h, vf, vlan,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index e65c8cf..112df34 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -169,7 +169,7 @@ static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 		if (dfx_message->flag)
 			dev_info(&hdev->pdev->dev, "%s: 0x%x\n",
 				 dfx_message->message,
-				 desc->data[i % entries_per_desc]);
+				 le32_to_cpu(desc->data[i % entries_per_desc]));
 
 		dfx_message++;
 	}
@@ -237,44 +237,48 @@ static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 	if (ret)
 		return;
 
-	dev_info(dev, "sch_nq_cnt: 0x%x\n", desc[0].data[1]);
+	dev_info(dev, "sch_nq_cnt: 0x%x\n", le32_to_cpu(desc[0].data[1]));
 
 	ret = hclge_dbg_cmd_send(hdev, desc, nq_id, 1, HCLGE_OPC_SCH_RQ_CNT);
 	if (ret)
 		return;
 
-	dev_info(dev, "sch_rq_cnt: 0x%x\n", desc[0].data[1]);
+	dev_info(dev, "sch_rq_cnt: 0x%x\n", le32_to_cpu(desc[0].data[1]));
 
 	ret = hclge_dbg_cmd_send(hdev, desc, 0, 2, HCLGE_OPC_TM_INTERNAL_STS);
 	if (ret)
 		return;
 
-	dev_info(dev, "pri_bp: 0x%x\n", desc[0].data[1]);
-	dev_info(dev, "fifo_dfx_info: 0x%x\n", desc[0].data[2]);
-	dev_info(dev, "sch_roce_fifo_afull_gap: 0x%x\n", desc[0].data[3]);
-	dev_info(dev, "tx_private_waterline: 0x%x\n", desc[0].data[4]);
-	dev_info(dev, "tm_bypass_en: 0x%x\n", desc[0].data[5]);
-	dev_info(dev, "SSU_TM_BYPASS_EN: 0x%x\n", desc[1].data[0]);
-	dev_info(dev, "SSU_RESERVE_CFG: 0x%x\n", desc[1].data[1]);
+	dev_info(dev, "pri_bp: 0x%x\n", le32_to_cpu(desc[0].data[1]));
+	dev_info(dev, "fifo_dfx_info: 0x%x\n", le32_to_cpu(desc[0].data[2]));
+	dev_info(dev, "sch_roce_fifo_afull_gap: 0x%x\n",
+		 le32_to_cpu(desc[0].data[3]));
+	dev_info(dev, "tx_private_waterline: 0x%x\n",
+		 le32_to_cpu(desc[0].data[4]));
+	dev_info(dev, "tm_bypass_en: 0x%x\n", le32_to_cpu(desc[0].data[5]));
+	dev_info(dev, "SSU_TM_BYPASS_EN: 0x%x\n", le32_to_cpu(desc[1].data[0]));
+	dev_info(dev, "SSU_RESERVE_CFG: 0x%x\n", le32_to_cpu(desc[1].data[1]));
 
 	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1,
 				 HCLGE_OPC_TM_INTERNAL_CNT);
 	if (ret)
 		return;
 
-	dev_info(dev, "SCH_NIC_NUM: 0x%x\n", desc[0].data[1]);
-	dev_info(dev, "SCH_ROCE_NUM: 0x%x\n", desc[0].data[2]);
+	dev_info(dev, "SCH_NIC_NUM: 0x%x\n", le32_to_cpu(desc[0].data[1]));
+	dev_info(dev, "SCH_ROCE_NUM: 0x%x\n", le32_to_cpu(desc[0].data[2]));
 
 	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1,
 				 HCLGE_OPC_TM_INTERNAL_STS_1);
 	if (ret)
 		return;
 
-	dev_info(dev, "TC_MAP_SEL: 0x%x\n", desc[0].data[1]);
-	dev_info(dev, "IGU_PFC_PRI_EN: 0x%x\n", desc[0].data[2]);
-	dev_info(dev, "MAC_PFC_PRI_EN: 0x%x\n", desc[0].data[3]);
-	dev_info(dev, "IGU_PRI_MAP_TC_CFG: 0x%x\n", desc[0].data[4]);
-	dev_info(dev, "IGU_TX_PRI_MAP_TC_CFG: 0x%x\n", desc[0].data[5]);
+	dev_info(dev, "TC_MAP_SEL: 0x%x\n", le32_to_cpu(desc[0].data[1]));
+	dev_info(dev, "IGU_PFC_PRI_EN: 0x%x\n", le32_to_cpu(desc[0].data[2]));
+	dev_info(dev, "MAC_PFC_PRI_EN: 0x%x\n", le32_to_cpu(desc[0].data[3]));
+	dev_info(dev, "IGU_PRI_MAP_TC_CFG: 0x%x\n",
+		 le32_to_cpu(desc[0].data[4]));
+	dev_info(dev, "IGU_TX_PRI_MAP_TC_CFG: 0x%x\n",
+		 le32_to_cpu(desc[0].data[5]));
 }
 
 static void hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev, const char *cmd_buf)
@@ -364,7 +368,7 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 	pg_shap_cfg_cmd = (struct hclge_pg_shapping_cmd *)desc.data;
 	dev_info(&hdev->pdev->dev, "PG_C pg_id: %u\n", pg_shap_cfg_cmd->pg_id);
 	dev_info(&hdev->pdev->dev, "PG_C pg_shapping: 0x%x\n",
-		 pg_shap_cfg_cmd->pg_shapping_para);
+		 le32_to_cpu(pg_shap_cfg_cmd->pg_shapping_para));
 
 	cmd = HCLGE_OPC_TM_PG_P_SHAPPING;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -375,7 +379,7 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 	pg_shap_cfg_cmd = (struct hclge_pg_shapping_cmd *)desc.data;
 	dev_info(&hdev->pdev->dev, "PG_P pg_id: %u\n", pg_shap_cfg_cmd->pg_id);
 	dev_info(&hdev->pdev->dev, "PG_P pg_shapping: 0x%x\n",
-		 pg_shap_cfg_cmd->pg_shapping_para);
+		 le32_to_cpu(pg_shap_cfg_cmd->pg_shapping_para));
 
 	cmd = HCLGE_OPC_TM_PORT_SHAPPING;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -385,7 +389,7 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 
 	port_shap_cfg_cmd = (struct hclge_port_shapping_cmd *)desc.data;
 	dev_info(&hdev->pdev->dev, "PORT port_shapping: 0x%x\n",
-		 port_shap_cfg_cmd->port_shapping_para);
+		 le32_to_cpu(port_shap_cfg_cmd->port_shapping_para));
 
 	cmd = HCLGE_OPC_TM_PG_SCH_MODE_CFG;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -393,7 +397,8 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 	if (ret)
 		goto err_tm_pg_cmd_send;
 
-	dev_info(&hdev->pdev->dev, "PG_SCH pg_id: %u\n", desc.data[0]);
+	dev_info(&hdev->pdev->dev, "PG_SCH pg_id: %u\n",
+		 le32_to_cpu(desc.data[0]));
 
 	cmd = HCLGE_OPC_TM_PRI_SCH_MODE_CFG;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -401,7 +406,8 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 	if (ret)
 		goto err_tm_pg_cmd_send;
 
-	dev_info(&hdev->pdev->dev, "PRI_SCH pri_id: %u\n", desc.data[0]);
+	dev_info(&hdev->pdev->dev, "PRI_SCH pri_id: %u\n",
+		 le32_to_cpu(desc.data[0]));
 
 	cmd = HCLGE_OPC_TM_QS_SCH_MODE_CFG;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -409,7 +415,8 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 	if (ret)
 		goto err_tm_pg_cmd_send;
 
-	dev_info(&hdev->pdev->dev, "QS_SCH qs_id: %u\n", desc.data[0]);
+	dev_info(&hdev->pdev->dev, "QS_SCH qs_id: %u\n",
+		 le32_to_cpu(desc.data[0]));
 
 	if (!hnae3_dev_dcb_supported(hdev)) {
 		dev_info(&hdev->pdev->dev,
@@ -429,7 +436,7 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 	dev_info(&hdev->pdev->dev, "BP_TO_QSET qs_group_id: 0x%x\n",
 		 bp_to_qs_map_cmd->qs_group_id);
 	dev_info(&hdev->pdev->dev, "BP_TO_QSET qs_bit_map: 0x%x\n",
-		 bp_to_qs_map_cmd->qs_bit_map);
+		 le32_to_cpu(bp_to_qs_map_cmd->qs_bit_map));
 	return;
 
 err_tm_pg_cmd_send:
@@ -471,7 +478,7 @@ static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
 
 	qs_to_pri_map = (struct hclge_qs_to_pri_link_cmd *)desc.data;
 	dev_info(&hdev->pdev->dev, "QS_TO_PRI qs_id: %u\n",
-		 qs_to_pri_map->qs_id);
+		 le16_to_cpu(qs_to_pri_map->qs_id));
 	dev_info(&hdev->pdev->dev, "QS_TO_PRI priority: %u\n",
 		 qs_to_pri_map->priority);
 	dev_info(&hdev->pdev->dev, "QS_TO_PRI link_vld: %u\n",
@@ -484,9 +491,10 @@ static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
 		goto err_tm_cmd_send;
 
 	nq_to_qs_map = (struct hclge_nq_to_qs_link_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "NQ_TO_QS nq_id: %u\n", nq_to_qs_map->nq_id);
+	dev_info(&hdev->pdev->dev, "NQ_TO_QS nq_id: %u\n",
+		 le16_to_cpu(nq_to_qs_map->nq_id));
 	dev_info(&hdev->pdev->dev, "NQ_TO_QS qset_id: 0x%x\n",
-		 nq_to_qs_map->qset_id);
+		 le16_to_cpu(nq_to_qs_map->qset_id));
 
 	cmd = HCLGE_OPC_TM_PG_WEIGHT;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -505,7 +513,8 @@ static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
 		goto err_tm_cmd_send;
 
 	qs_weight = (struct hclge_qs_weight_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "QS qs_id: %u\n", qs_weight->qs_id);
+	dev_info(&hdev->pdev->dev, "QS qs_id: %u\n",
+		 le16_to_cpu(qs_weight->qs_id));
 	dev_info(&hdev->pdev->dev, "QS dwrr: %u\n", qs_weight->dwrr);
 
 	cmd = HCLGE_OPC_TM_PRI_WEIGHT;
@@ -527,7 +536,7 @@ static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
 	shap_cfg_cmd = (struct hclge_pri_shapping_cmd *)desc.data;
 	dev_info(&hdev->pdev->dev, "PRI_C pri_id: %u\n", shap_cfg_cmd->pri_id);
 	dev_info(&hdev->pdev->dev, "PRI_C pri_shapping: 0x%x\n",
-		 shap_cfg_cmd->pri_shapping_para);
+		 le32_to_cpu(shap_cfg_cmd->pri_shapping_para));
 
 	cmd = HCLGE_OPC_TM_PRI_P_SHAPPING;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -538,7 +547,7 @@ static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
 	shap_cfg_cmd = (struct hclge_pri_shapping_cmd *)desc.data;
 	dev_info(&hdev->pdev->dev, "PRI_P pri_id: %u\n", shap_cfg_cmd->pri_id);
 	dev_info(&hdev->pdev->dev, "PRI_P pri_shapping: 0x%x\n",
-		 shap_cfg_cmd->pri_shapping_para);
+		 le32_to_cpu(shap_cfg_cmd->pri_shapping_para));
 
 	hclge_dbg_dump_tm_pg(hdev);
 
@@ -658,7 +667,7 @@ static void hclge_dbg_dump_qos_pause_cfg(struct hclge_dev *hdev)
 	dev_info(&hdev->pdev->dev, "pause_trans_gap: 0x%x\n",
 		 pause_param->pause_trans_gap);
 	dev_info(&hdev->pdev->dev, "pause_trans_time: 0x%x\n",
-		 pause_param->pause_trans_time);
+		 le16_to_cpu(pause_param->pause_trans_time));
 }
 
 static void hclge_dbg_dump_qos_pri_map(struct hclge_dev *hdev)
@@ -712,7 +721,7 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 	tx_buf_cmd = (struct hclge_tx_buff_alloc_cmd *)desc[0].data;
 	for (i = 0; i < HCLGE_MAX_TC_NUM; i++)
 		dev_info(&hdev->pdev->dev, "tx_packet_buf_tc_%d: 0x%x\n", i,
-			 tx_buf_cmd->tx_pkt_buff[i]);
+			 le16_to_cpu(tx_buf_cmd->tx_pkt_buff[i]));
 
 	cmd = HCLGE_OPC_RX_PRIV_BUFF_ALLOC;
 	hclge_cmd_setup_basic_desc(desc, cmd, true);
@@ -724,10 +733,10 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 	rx_buf_cmd = (struct hclge_rx_priv_buff_cmd *)desc[0].data;
 	for (i = 0; i < HCLGE_MAX_TC_NUM; i++)
 		dev_info(&hdev->pdev->dev, "rx_packet_buf_tc_%d: 0x%x\n", i,
-			 rx_buf_cmd->buf_num[i]);
+			 le16_to_cpu(rx_buf_cmd->buf_num[i]));
 
 	dev_info(&hdev->pdev->dev, "rx_share_buf: 0x%x\n",
-		 rx_buf_cmd->shared_buf);
+		 le16_to_cpu(rx_buf_cmd->shared_buf));
 
 	cmd = HCLGE_OPC_RX_COM_WL_ALLOC;
 	hclge_cmd_setup_basic_desc(desc, cmd, true);
@@ -738,7 +747,8 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 	rx_com_wl = (struct hclge_rx_com_wl *)desc[0].data;
 	dev_info(&hdev->pdev->dev, "\n");
 	dev_info(&hdev->pdev->dev, "rx_com_wl: high: 0x%x, low: 0x%x\n",
-		 rx_com_wl->com_wl.high, rx_com_wl->com_wl.low);
+		 le16_to_cpu(rx_com_wl->com_wl.high),
+		 le16_to_cpu(rx_com_wl->com_wl.low));
 
 	cmd = HCLGE_OPC_RX_GBL_PKT_CNT;
 	hclge_cmd_setup_basic_desc(desc, cmd, true);
@@ -749,7 +759,8 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 	rx_packet_cnt = (struct hclge_rx_com_wl *)desc[0].data;
 	dev_info(&hdev->pdev->dev,
 		 "rx_global_packet_cnt: high: 0x%x, low: 0x%x\n",
-		 rx_packet_cnt->com_wl.high, rx_packet_cnt->com_wl.low);
+		 le16_to_cpu(rx_packet_cnt->com_wl.high),
+		 le16_to_cpu(rx_packet_cnt->com_wl.low));
 	dev_info(&hdev->pdev->dev, "\n");
 
 	if (!hnae3_dev_dcb_supported(hdev)) {
@@ -769,14 +780,16 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
 		dev_info(&hdev->pdev->dev,
 			 "rx_priv_wl_tc_%d: high: 0x%x, low: 0x%x\n", i,
-			 rx_priv_wl->tc_wl[i].high, rx_priv_wl->tc_wl[i].low);
+			 le16_to_cpu(rx_priv_wl->tc_wl[i].high),
+			 le16_to_cpu(rx_priv_wl->tc_wl[i].low));
 
 	rx_priv_wl = (struct hclge_rx_priv_wl_buf *)desc[1].data;
 	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
 		dev_info(&hdev->pdev->dev,
 			 "rx_priv_wl_tc_%d: high: 0x%x, low: 0x%x\n",
 			 i + HCLGE_TC_NUM_ONE_DESC,
-			 rx_priv_wl->tc_wl[i].high, rx_priv_wl->tc_wl[i].low);
+			 le16_to_cpu(rx_priv_wl->tc_wl[i].high),
+			 le16_to_cpu(rx_priv_wl->tc_wl[i].low));
 
 	cmd = HCLGE_OPC_RX_COM_THRD_ALLOC;
 	hclge_cmd_setup_basic_desc(&desc[0], cmd, true);
@@ -791,16 +804,16 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
 		dev_info(&hdev->pdev->dev,
 			 "rx_com_thrd_tc_%d: high: 0x%x, low: 0x%x\n", i,
-			 rx_com_thrd->com_thrd[i].high,
-			 rx_com_thrd->com_thrd[i].low);
+			 le16_to_cpu(rx_com_thrd->com_thrd[i].high),
+			 le16_to_cpu(rx_com_thrd->com_thrd[i].low));
 
 	rx_com_thrd = (struct hclge_rx_com_thrd *)desc[1].data;
 	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
 		dev_info(&hdev->pdev->dev,
 			 "rx_com_thrd_tc_%d: high: 0x%x, low: 0x%x\n",
 			 i + HCLGE_TC_NUM_ONE_DESC,
-			 rx_com_thrd->com_thrd[i].high,
-			 rx_com_thrd->com_thrd[i].low);
+			 le16_to_cpu(rx_com_thrd->com_thrd[i].high),
+			 le16_to_cpu(rx_com_thrd->com_thrd[i].low));
 	return;
 
 err_qos_cmd_send:
@@ -845,7 +858,8 @@ static void hclge_dbg_dump_mng_table(struct hclge_dev *hdev)
 		memset(printf_buf, 0, HCLGE_DBG_BUF_LEN);
 		snprintf(printf_buf, HCLGE_DBG_BUF_LEN,
 			 "%02u   |%02x:%02x:%02x:%02x:%02x:%02x|",
-			 req0->index, req0->mac_addr[0], req0->mac_addr[1],
+			 le16_to_cpu(req0->index),
+			 req0->mac_addr[0], req0->mac_addr[1],
 			 req0->mac_addr[2], req0->mac_addr[3],
 			 req0->mac_addr[4], req0->mac_addr[5]);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index babec3b..4f8f068 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5740,7 +5740,7 @@ static int hclge_del_fd_entry(struct hnae3_handle *handle,
 
 	if (!hclge_fd_rule_exist(hdev, fs->location)) {
 		dev_err(&hdev->pdev->dev,
-			"Delete fail, rule %d is inexistent\n", fs->location);
+			"Delete fail, rule %u is inexistent\n", fs->location);
 		return -ENOENT;
 	}
 
-- 
2.7.4

