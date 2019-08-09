Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C8686FB5
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 04:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405491AbfHICeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 22:34:16 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59036 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405098AbfHICdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 22:33:35 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 33DA942F6152FFBCED8D;
        Fri,  9 Aug 2019 10:33:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 9 Aug 2019 10:33:24 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/12] net: hns3: add check for max TX BD num for tso and non-tso case
Date:   Fri, 9 Aug 2019 10:31:14 +0800
Message-ID: <1565317878-31806-9-git-send-email-tanhuazhong@huawei.com>
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

From: Yunsheng Lin <linyunsheng@huawei.com>

Hardware supports up to 8 TX BD for non-TSO skb and 63 TX
BD for TSO skb. Currently hns3 driver does not check the max
BD num that required by a skb before filling desc, which may
cause the hardware to issue a RAS error throug PCIe AER.

This patch adds the max BD num check before filling desc,
if the bd num is not within the hardware limit, it will
record the error by ring->stats.sw_err_cnt counter and
free the skb.

This patch also cleans up the hns3_nic_bd_num function by
changing the return type and removing an unnecessary check.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 38 ++++++++++---------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  3 +-
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b2a668d..df08f9e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1186,28 +1186,20 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	return 0;
 }
 
-static int hns3_nic_bd_num(struct sk_buff *skb)
+static unsigned int hns3_nic_bd_num(struct sk_buff *skb)
 {
-	int size = skb_headlen(skb);
-	int i, bd_num;
+	unsigned int bd_num;
+	int i;
 
 	/* if the total len is within the max bd limit */
 	if (likely(skb->len <= HNS3_MAX_BD_SIZE))
 		return skb_shinfo(skb)->nr_frags + 1;
 
-	bd_num = hns3_tx_bd_count(size);
+	bd_num = hns3_tx_bd_count(skb_headlen(skb));
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		int frag_bd_num;
-
-		size = skb_frag_size(frag);
-		frag_bd_num = hns3_tx_bd_count(size);
-
-		if (unlikely(frag_bd_num > HNS3_MAX_BD_PER_FRAG))
-			return -ENOMEM;
-
-		bd_num += frag_bd_num;
+		bd_num += hns3_tx_bd_count(skb_frag_size(frag));
 	}
 
 	return bd_num;
@@ -1228,7 +1220,7 @@ static unsigned int hns3_gso_hdr_len(struct sk_buff *skb)
  */
 static bool hns3_skb_need_linearized(struct sk_buff *skb)
 {
-	int bd_limit = HNS3_MAX_BD_PER_FRAG - 1;
+	int bd_limit = HNS3_MAX_BD_NUM_NORMAL - 1;
 	unsigned int tot_len = 0;
 	int i;
 
@@ -1258,21 +1250,16 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 				  struct sk_buff **out_skb)
 {
 	struct sk_buff *skb = *out_skb;
-	int bd_num;
+	unsigned int bd_num;
 
 	bd_num = hns3_nic_bd_num(skb);
-	if (bd_num < 0)
-		return bd_num;
-
-	if (unlikely(bd_num > HNS3_MAX_BD_PER_FRAG)) {
+	if (unlikely(bd_num > HNS3_MAX_BD_NUM_NORMAL)) {
 		struct sk_buff *new_skb;
 
-		if (skb_is_gso(skb) && !hns3_skb_need_linearized(skb))
+		if (skb_is_gso(skb) && bd_num <= HNS3_MAX_BD_NUM_TSO &&
+		    !hns3_skb_need_linearized(skb))
 			goto out;
 
-		bd_num = hns3_tx_bd_count(skb->len);
-		if (unlikely(ring_space(ring) < bd_num))
-			return -EBUSY;
 		/* manual split the send packet */
 		new_skb = skb_copy(skb, GFP_ATOMIC);
 		if (!new_skb)
@@ -1280,6 +1267,11 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		dev_kfree_skb_any(skb);
 		*out_skb = new_skb;
 
+		bd_num = hns3_nic_bd_num(new_skb);
+		if ((skb_is_gso(new_skb) && bd_num > HNS3_MAX_BD_NUM_TSO) ||
+		    (!skb_is_gso(new_skb) && bd_num > HNS3_MAX_BD_NUM_NORMAL))
+			return -ENOMEM;
+
 		u64_stats_update_begin(&ring->syncp);
 		ring->stats.tx_copy++;
 		u64_stats_update_end(&ring->syncp);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index a76712c..5b0ee1f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -195,7 +195,8 @@ enum hns3_nic_state {
 #define HNS3_VECTOR_INITED			1
 
 #define HNS3_MAX_BD_SIZE			65535
-#define HNS3_MAX_BD_PER_FRAG			8
+#define HNS3_MAX_BD_NUM_NORMAL			8
+#define HNS3_MAX_BD_NUM_TSO			63
 #define HNS3_MAX_BD_PER_PKT			MAX_SKB_FRAGS
 
 #define HNS3_VECTOR_GL0_OFFSET			0x100
-- 
2.7.4

