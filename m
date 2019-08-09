Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5C986FA8
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 04:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405407AbfHICdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 22:33:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58996 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405037AbfHICdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 22:33:35 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1349CDA33A809864F972;
        Fri,  9 Aug 2019 10:33:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 9 Aug 2019 10:33:24 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 10/12] net: hns3: refine MAC pause statistics querying function
Date:   Fri, 9 Aug 2019 10:31:16 +0800
Message-ID: <1565317878-31806-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
References: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

This patch refines the interface for querying MAC pause
statistics, and adds structure hns3_mac_stats to keep the
count of TX & RX.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             | 11 +++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         | 11 ++++-------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 12 +++++++-----
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a4624db..43740ee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -91,6 +91,11 @@ struct hnae3_queue {
 	u16 rx_desc_num;/* total number of rx desc */
 };
 
+struct hns3_mac_stats {
+	u64 tx_pause_cnt;
+	u64 rx_pause_cnt;
+};
+
 /*hnae3 loop mode*/
 enum hnae3_loop {
 	HNAE3_LOOP_APP,
@@ -298,6 +303,8 @@ struct hnae3_ae_dev {
  *   Remove multicast address from mac table
  * update_stats()
  *   Update Old network device statistics
+ * get_mac_stats()
+ *   get mac pause statistics including tx_cnt and rx_cnt
  * get_ethtool_stats()
  *   Get ethtool network device statistics
  * get_strings()
@@ -426,8 +433,8 @@ struct hnae3_ae_ops {
 	void (*update_stats)(struct hnae3_handle *handle,
 			     struct net_device_stats *net_stats);
 	void (*get_stats)(struct hnae3_handle *handle, u64 *data);
-	void (*get_mac_pause_stats)(struct hnae3_handle *handle, u64 *tx_cnt,
-				    u64 *rx_cnt);
+	void (*get_mac_stats)(struct hnae3_handle *handle,
+			      struct hns3_mac_stats *mac_stats);
 	void (*get_strings)(struct hnae3_handle *handle,
 			    u32 stringset, u8 *data);
 	int (*get_sset_count)(struct hnae3_handle *handle, int stringset);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index df08f9e..1750f80 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1726,15 +1726,12 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 	/* When mac received many pause frames continuous, it's unable to send
 	 * packets, which may cause tx timeout
 	 */
-	if (h->ae_algo->ops->update_stats &&
-	    h->ae_algo->ops->get_mac_pause_stats) {
-		u64 tx_pause_cnt, rx_pause_cnt;
+	if (h->ae_algo->ops->get_mac_stats) {
+		struct hns3_mac_stats mac_stats;
 
-		h->ae_algo->ops->update_stats(h, &ndev->stats);
-		h->ae_algo->ops->get_mac_pause_stats(h, &tx_pause_cnt,
-						     &rx_pause_cnt);
+		h->ae_algo->ops->get_mac_stats(h, &mac_stats);
 		netdev_info(ndev, "tx_pause_cnt: %llu, rx_pause_cnt: %llu\n",
-			    tx_pause_cnt, rx_pause_cnt);
+			    mac_stats.tx_pause_cnt, mac_stats.rx_pause_cnt);
 	}
 
 	hw_head = readl_relaxed(tx_ring->tqp->io_base +
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7d7ab9e..1315275 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -750,14 +750,16 @@ static void hclge_get_stats(struct hnae3_handle *handle, u64 *data)
 	p = hclge_tqps_get_stats(handle, p);
 }
 
-static void hclge_get_mac_pause_stat(struct hnae3_handle *handle, u64 *tx_cnt,
-				     u64 *rx_cnt)
+static void hclge_get_mac_stat(struct hnae3_handle *handle,
+			       struct hns3_mac_stats *mac_stats)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	*tx_cnt = hdev->hw_stats.mac_stats.mac_tx_mac_pause_num;
-	*rx_cnt = hdev->hw_stats.mac_stats.mac_rx_mac_pause_num;
+	hclge_update_stats(handle, NULL);
+
+	mac_stats->tx_pause_cnt = hdev->hw_stats.mac_stats.mac_tx_mac_pause_num;
+	mac_stats->rx_pause_cnt = hdev->hw_stats.mac_stats.mac_rx_mac_pause_num;
 }
 
 static int hclge_parse_func_status(struct hclge_dev *hdev,
@@ -9798,7 +9800,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.set_mtu = hclge_set_mtu,
 	.reset_queue = hclge_reset_tqp,
 	.get_stats = hclge_get_stats,
-	.get_mac_pause_stats = hclge_get_mac_pause_stat,
+	.get_mac_stats = hclge_get_mac_stat,
 	.update_stats = hclge_update_stats,
 	.get_strings = hclge_get_strings,
 	.get_sset_count = hclge_get_sset_count,
-- 
2.7.4

