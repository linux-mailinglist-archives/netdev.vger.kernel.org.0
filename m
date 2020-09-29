Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF6A27C157
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgI2Je7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:34:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14775 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728010AbgI2Jey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 05:34:54 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BA94BA33FDB1052017C0;
        Tue, 29 Sep 2020 17:34:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:34:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/7] net: hns3: replace macro HNS3_MAX_NON_TSO_BD_NUM
Date:   Tue, 29 Sep 2020 17:31:59 +0800
Message-ID: <1601371925-49426-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
References: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the driver is able to query the device's specifications,
which includes the maximum BD number of non TSO packet, so replace
macro HNS3_MAX_NON_TSO_BD_NUM with the queried value, and rewrite
macro HNS3_MAX_NON_TSO_SIZE whose value depends on the the maximum
BD number of non TSO packet.

Also, add a new parameter max_non_tso_bd_num to function
hns3_tx_bd_num() and hns3_skb_need_linearized(), then they can get
the maximum BD number of non TSO packet from the caller instead of
calculating by themself, The note of hns3_skb_need_linearized()
should be update as well.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 47 +++++++++++++++----------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  6 ++--
 2 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1c4e820e..a393755 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1184,21 +1184,23 @@ static unsigned int hns3_skb_bd_num(struct sk_buff *skb, unsigned int *bd_size,
 	return bd_num;
 }
 
-static unsigned int hns3_tx_bd_num(struct sk_buff *skb, unsigned int *bd_size)
+static unsigned int hns3_tx_bd_num(struct sk_buff *skb, unsigned int *bd_size,
+				   u8 max_non_tso_bd_num)
 {
 	struct sk_buff *frag_skb;
 	unsigned int bd_num = 0;
 
 	/* If the total len is within the max bd limit */
 	if (likely(skb->len <= HNS3_MAX_BD_SIZE && !skb_has_frag_list(skb) &&
-		   skb_shinfo(skb)->nr_frags < HNS3_MAX_NON_TSO_BD_NUM))
+		   skb_shinfo(skb)->nr_frags < max_non_tso_bd_num))
 		return skb_shinfo(skb)->nr_frags + 1U;
 
 	/* The below case will always be linearized, return
 	 * HNS3_MAX_BD_NUM_TSO + 1U to make sure it is linearized.
 	 */
 	if (unlikely(skb->len > HNS3_MAX_TSO_SIZE ||
-		     (!skb_is_gso(skb) && skb->len > HNS3_MAX_NON_TSO_SIZE)))
+		     (!skb_is_gso(skb) && skb->len >
+		      HNS3_MAX_NON_TSO_SIZE(max_non_tso_bd_num))))
 		return HNS3_MAX_TSO_BD_NUM + 1U;
 
 	bd_num = hns3_skb_bd_num(skb, bd_size, bd_num);
@@ -1223,31 +1225,34 @@ static unsigned int hns3_gso_hdr_len(struct sk_buff *skb)
 	return skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb);
 }
 
-/* HW need every continuous 8 buffer data to be larger than MSS,
- * we simplify it by ensuring skb_headlen + the first continuous
- * 7 frags to to be larger than gso header len + mss, and the remaining
- * continuous 7 frags to be larger than MSS except the last 7 frags.
+/* HW need every continuous max_non_tso_bd_num buffer data to be larger
+ * than MSS, we simplify it by ensuring skb_headlen + the first continuous
+ * max_non_tso_bd_num - 1 frags to be larger than gso header len + mss,
+ * and the remaining continuous max_non_tso_bd_num - 1 frags to be larger
+ * than MSS except the last max_non_tso_bd_num - 1 frags.
  */
 static bool hns3_skb_need_linearized(struct sk_buff *skb, unsigned int *bd_size,
-				     unsigned int bd_num)
+				     unsigned int bd_num, u8 max_non_tso_bd_num)
 {
 	unsigned int tot_len = 0;
 	int i;
 
-	for (i = 0; i < HNS3_MAX_NON_TSO_BD_NUM - 1U; i++)
+	for (i = 0; i < max_non_tso_bd_num - 1U; i++)
 		tot_len += bd_size[i];
 
-	/* ensure the first 8 frags is greater than mss + header */
-	if (tot_len + bd_size[HNS3_MAX_NON_TSO_BD_NUM - 1U] <
+	/* ensure the first max_non_tso_bd_num frags is greater than
+	 * mss + header
+	 */
+	if (tot_len + bd_size[max_non_tso_bd_num - 1U] <
 	    skb_shinfo(skb)->gso_size + hns3_gso_hdr_len(skb))
 		return true;
 
-	/* ensure every continuous 7 buffer is greater than mss
-	 * except the last one.
+	/* ensure every continuous max_non_tso_bd_num - 1 buffer is greater
+	 * than mss except the last one.
 	 */
-	for (i = 0; i < bd_num - HNS3_MAX_NON_TSO_BD_NUM; i++) {
+	for (i = 0; i < bd_num - max_non_tso_bd_num; i++) {
 		tot_len -= bd_size[i];
-		tot_len += bd_size[i + HNS3_MAX_NON_TSO_BD_NUM - 1U];
+		tot_len += bd_size[i + max_non_tso_bd_num - 1U];
 
 		if (tot_len < skb_shinfo(skb)->gso_size)
 			return true;
@@ -1269,13 +1274,15 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 				  struct sk_buff *skb)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	u8 max_non_tso_bd_num = priv->max_non_tso_bd_num;
 	unsigned int bd_size[HNS3_MAX_TSO_BD_NUM + 1U];
 	unsigned int bd_num;
 
-	bd_num = hns3_tx_bd_num(skb, bd_size);
-	if (unlikely(bd_num > HNS3_MAX_NON_TSO_BD_NUM)) {
+	bd_num = hns3_tx_bd_num(skb, bd_size, max_non_tso_bd_num);
+	if (unlikely(bd_num > max_non_tso_bd_num)) {
 		if (bd_num <= HNS3_MAX_TSO_BD_NUM && skb_is_gso(skb) &&
-		    !hns3_skb_need_linearized(skb, bd_size, bd_num)) {
+		    !hns3_skb_need_linearized(skb, bd_size, bd_num,
+					      max_non_tso_bd_num)) {
 			trace_hns3_over_8bd(skb);
 			goto out;
 		}
@@ -1286,7 +1293,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		bd_num = hns3_tx_bd_count(skb->len);
 		if ((skb_is_gso(skb) && bd_num > HNS3_MAX_TSO_BD_NUM) ||
 		    (!skb_is_gso(skb) &&
-		     bd_num > HNS3_MAX_NON_TSO_BD_NUM)) {
+		     bd_num > max_non_tso_bd_num)) {
 			trace_hns3_over_8bd(skb);
 			return -ENOMEM;
 		}
@@ -3991,6 +3998,7 @@ static void hns3_info_show(struct hns3_nic_priv *priv)
 static int hns3_client_init(struct hnae3_handle *handle)
 {
 	struct pci_dev *pdev = handle->pdev;
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 	u16 alloc_tqps, max_rss_size;
 	struct hns3_nic_priv *priv;
 	struct net_device *netdev;
@@ -4007,6 +4015,7 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	priv->netdev = netdev;
 	priv->ae_handle = handle;
 	priv->tx_timeout_count = 0;
+	priv->max_non_tso_bd_num = ae_dev->dev_specs.max_non_tso_bd_num;
 	set_bit(HNS3_NIC_STATE_DOWN, &priv->state);
 
 	handle->msg_enable = netif_msg_init(debug, DEFAULT_MSG_LEVEL);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 8a6c8ba..35b0375 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -167,13 +167,12 @@ enum hns3_nic_state {
 #define HNS3_VECTOR_INITED			1
 
 #define HNS3_MAX_BD_SIZE			65535
-#define HNS3_MAX_NON_TSO_BD_NUM			8U
 #define HNS3_MAX_TSO_BD_NUM			63U
 #define HNS3_MAX_TSO_SIZE \
 	(HNS3_MAX_BD_SIZE * HNS3_MAX_TSO_BD_NUM)
 
-#define HNS3_MAX_NON_TSO_SIZE \
-	(HNS3_MAX_BD_SIZE * HNS3_MAX_NON_TSO_BD_NUM)
+#define HNS3_MAX_NON_TSO_SIZE(max_non_tso_bd_num) \
+	(HNS3_MAX_BD_SIZE * (max_non_tso_bd_num))
 
 #define HNS3_VECTOR_GL0_OFFSET			0x100
 #define HNS3_VECTOR_GL1_OFFSET			0x200
@@ -475,6 +474,7 @@ struct hns3_nic_priv {
 	struct hns3_enet_ring *ring;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	u16 vector_num;
+	u8 max_non_tso_bd_num;
 
 	u64 tx_timeout_count;
 
-- 
2.7.4

