Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047013A92D7
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhFPGlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:41:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4802 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbhFPGlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:41:39 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4b533rkFzWtL4;
        Wed, 16 Jun 2021 14:34:31 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:30 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:30 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/7] net: hns3: add support to query tx spare buffer size for pf
Date:   Wed, 16 Jun 2021 14:36:14 +0800
Message-ID: <1623825377-41948-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623825377-41948-1-git-send-email-huangguangbin2@huawei.com>
References: <1623825377-41948-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

Add support to query tx spare buffer size from configuration
file, and use this info to do spare buffer initialization when
the module parameter 'tx_spare_buf_size' is not specified.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         |  7 +++++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  |  2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 14 ++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h |  2 ++
 5 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 5822fc06f767..0b202f4def83 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -760,6 +760,7 @@ struct hnae3_knic_private_info {
 	u16 rx_buf_len;
 	u16 num_tx_desc;
 	u16 num_rx_desc;
+	u32 tx_spare_buf_size;
 
 	struct hnae3_tc_info tc_info;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index e5466daac1c4..d86b3735aa9f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1005,13 +1005,16 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 {
 	struct hns3_tx_spare *tx_spare;
 	struct page *page;
+	u32 alloc_size;
 	dma_addr_t dma;
 	int order;
 
-	if (!tx_spare_buf_size)
+	alloc_size = tx_spare_buf_size ? tx_spare_buf_size :
+		     ring->tqp->handle->kinfo.tx_spare_buf_size;
+	if (!alloc_size)
 		return;
 
-	order = get_order(tx_spare_buf_size);
+	order = get_order(alloc_size);
 	tx_spare = devm_kzalloc(ring_to_dev(ring), sizeof(*tx_spare),
 				GFP_KERNEL);
 	if (!tx_spare) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 51be76f1795e..a322dfeba5cf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -542,6 +542,8 @@ struct hclge_pf_res_cmd {
 #define HCLGE_CFG_UMV_TBL_SPACE_M	GENMASK(31, 16)
 #define HCLGE_CFG_PF_RSS_SIZE_S		0
 #define HCLGE_CFG_PF_RSS_SIZE_M		GENMASK(3, 0)
+#define HCLGE_CFG_TX_SPARE_BUF_SIZE_S	4
+#define HCLGE_CFG_TX_SPARE_BUF_SIZE_M	GENMASK(15, 4)
 
 #define HCLGE_CFG_CMD_CNT		4
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f6fdf93c8cad..f3e482ab3c71 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1279,6 +1279,7 @@ static u32 hclge_get_max_speed(u16 speed_ability)
 
 static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 {
+#define HCLGE_TX_SPARE_SIZE_UNIT		4096
 #define SPEED_ABILITY_EXT_SHIFT			8
 
 	struct hclge_cfg_param_cmd *req;
@@ -1358,6 +1359,15 @@ static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 	cfg->pf_rss_size_max = cfg->pf_rss_size_max ?
 			       1U << cfg->pf_rss_size_max :
 			       cfg->vf_rss_size_max;
+
+	/* The unit of the tx spare buffer size queried from configuration
+	 * file is HCLGE_TX_SPARE_SIZE_UNIT(4096) bytes, so a conversion is
+	 * needed here.
+	 */
+	cfg->tx_spare_buf_size = hnae3_get_field(__le32_to_cpu(req->param[2]),
+						 HCLGE_CFG_TX_SPARE_BUF_SIZE_M,
+						 HCLGE_CFG_TX_SPARE_BUF_SIZE_S);
+	cfg->tx_spare_buf_size *= HCLGE_TX_SPARE_SIZE_UNIT;
 }
 
 /* hclge_get_cfg: query the static parameter from flash
@@ -1539,6 +1549,7 @@ static int hclge_configure(struct hclge_dev *hdev)
 	hdev->tc_max = cfg.tc_num;
 	hdev->tm_info.hw_pfc_map = 0;
 	hdev->wanted_umv_size = cfg.umv_space;
+	hdev->tx_spare_buf_size = cfg.tx_spare_buf_size;
 	if (cfg.vlan_fliter_cap == HCLGE_VLAN_FLTR_CAN_MDF)
 		set_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps);
 
@@ -1736,6 +1747,7 @@ static int hclge_knic_setup(struct hclge_vport *vport, u16 num_tqps,
 	kinfo->num_rx_desc = num_rx_desc;
 
 	kinfo->rx_buf_len = hdev->rx_buf_len;
+	kinfo->tx_spare_buf_size = hdev->tx_spare_buf_size;
 
 	kinfo->tqp = devm_kcalloc(&hdev->pdev->dev, num_tqps,
 				  sizeof(struct hnae3_queue *), GFP_KERNEL);
@@ -11059,6 +11071,8 @@ static void hclge_info_show(struct hclge_dev *hdev)
 		 hdev->flag & HCLGE_FLAG_DCB_ENABLE ? "enable" : "disable");
 	dev_info(dev, "MQPRIO %s\n",
 		 hdev->flag & HCLGE_FLAG_MQPRIO_ENABLE ? "enable" : "disable");
+	dev_info(dev, "Default tx spare buffer size: %u\n",
+		 hdev->tx_spare_buf_size);
 
 	dev_info(dev, "PF info end.\n");
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 02852738ce21..3d3352491dba 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -384,6 +384,7 @@ struct hclge_cfg {
 	u8 mac_addr[ETH_ALEN];
 	u8 default_speed;
 	u32 numa_node_map;
+	u32 tx_spare_buf_size;
 	u16 speed_ability;
 	u16 umv_space;
 };
@@ -848,6 +849,7 @@ struct hclge_dev {
 	u16 alloc_rss_size;		/* Allocated RSS task queue */
 	u16 vf_rss_size_max;		/* HW defined VF max RSS task queue */
 	u16 pf_rss_size_max;		/* HW defined PF max RSS task queue */
+	u32 tx_spare_buf_size;		/* HW defined TX spare buffer size */
 
 	u16 fdir_pf_filter_count; /* Num of guaranteed filters for this PF */
 	u16 num_alloc_vport;		/* Num vports this driver supports */
-- 
2.8.1

