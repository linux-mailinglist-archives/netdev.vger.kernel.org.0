Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8F614397
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 04:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfEFCuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 22:50:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7161 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726147AbfEFCuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 22:50:20 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 96D972F8CED492A96385;
        Mon,  6 May 2019 10:50:18 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 May 2019 10:50:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <nhorman@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/12] net: hns3: add linearizing checking for TSO case
Date:   Mon, 6 May 2019 10:48:44 +0800
Message-ID: <1557110932-683-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
References: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

HW requires every continuous 8 buffer data to be larger than MSS,
we simplify it by ensuring skb_headlen + the first continuous
7 frags to to be larger than GSO header len + mss, and the
remaining continuous 7 frags to be larger than MSS except the
last 7 frags.

This patch adds hns3_skb_need_linearized to handle it for TSO
case.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 45 +++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 453fdf4..944e0ae 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1181,6 +1181,47 @@ static int hns3_nic_bd_num(struct sk_buff *skb)
 	return bd_num;
 }
 
+static unsigned int hns3_gso_hdr_len(struct sk_buff *skb)
+{
+	if (!skb->encapsulation)
+		return skb_transport_offset(skb) + tcp_hdrlen(skb);
+
+	return skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb);
+}
+
+/* HW need every continuous 8 buffer data to be larger than MSS,
+ * we simplify it by ensuring skb_headlen + the first continuous
+ * 7 frags to to be larger than gso header len + mss, and the remaining
+ * continuous 7 frags to be larger than MSS except the last 7 frags.
+ */
+static bool hns3_skb_need_linearized(struct sk_buff *skb)
+{
+	int bd_limit = HNS3_MAX_BD_PER_FRAG - 1;
+	unsigned int tot_len = 0;
+	int i;
+
+	for (i = 0; i < bd_limit; i++)
+		tot_len += skb_frag_size(&skb_shinfo(skb)->frags[i]);
+
+	/* ensure headlen + the first 7 frags is greater than mss + header
+	 * and the first 7 frags is greater than mss.
+	 */
+	if (((tot_len + skb_headlen(skb)) < (skb_shinfo(skb)->gso_size +
+	    hns3_gso_hdr_len(skb))) || (tot_len < skb_shinfo(skb)->gso_size))
+		return true;
+
+	/* ensure the remaining continuous 7 buffer is greater than mss */
+	for (i = 0; i < (skb_shinfo(skb)->nr_frags - bd_limit - 1); i++) {
+		tot_len -= skb_frag_size(&skb_shinfo(skb)->frags[i]);
+		tot_len += skb_frag_size(&skb_shinfo(skb)->frags[i + bd_limit]);
+
+		if (tot_len < skb_shinfo(skb)->gso_size)
+			return true;
+	}
+
+	return false;
+}
+
 static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 				  struct sk_buff **out_skb)
 {
@@ -1194,6 +1235,9 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 	if (unlikely(bd_num > HNS3_MAX_BD_PER_FRAG)) {
 		struct sk_buff *new_skb;
 
+		if (skb_is_gso(skb) && !hns3_skb_need_linearized(skb))
+			goto out;
+
 		bd_num = hns3_tx_bd_count(skb->len);
 		if (unlikely(ring_space(ring) < bd_num))
 			return -EBUSY;
@@ -1209,6 +1253,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		u64_stats_update_end(&ring->syncp);
 	}
 
+out:
 	if (unlikely(ring_space(ring) < bd_num))
 		return -EBUSY;
 
-- 
2.7.4

