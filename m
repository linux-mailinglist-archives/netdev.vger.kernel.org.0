Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8D2461781
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244192AbhK2OKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:10:36 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16317 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbhK2OIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:08:30 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J2nCr1Hgwz91SJ;
        Mon, 29 Nov 2021 22:04:40 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:05 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:05 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 02/10] net: hns3: refactor hns3_nic_reuse_page()
Date:   Mon, 29 Nov 2021 22:00:19 +0800
Message-ID: <20211129140027.23036-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211129140027.23036-1-huangguangbin2@huawei.com>
References: <20211129140027.23036-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Split rx copybreak handle into a separate function from function
hns3_nic_reuse_page() to improve code simplicity.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 55 ++++++++++++-------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 3eb2985b9c8d..731cefb3563c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3546,6 +3546,38 @@ static bool hns3_can_reuse_page(struct hns3_desc_cb *cb)
 	return page_count(cb->priv) == cb->pagecnt_bias;
 }
 
+static int hns3_handle_rx_copybreak(struct sk_buff *skb, int i,
+				    struct hns3_enet_ring *ring,
+				    int pull_len,
+				    struct hns3_desc_cb *desc_cb)
+{
+	struct hns3_desc *desc = &ring->desc[ring->next_to_clean];
+	u32 frag_offset = desc_cb->page_offset + pull_len;
+	int size = le16_to_cpu(desc->rx.size);
+	u32 frag_size = size - pull_len;
+	void *frag = napi_alloc_frag(frag_size);
+
+	if (unlikely(!frag)) {
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.frag_alloc_err++;
+		u64_stats_update_end(&ring->syncp);
+
+		hns3_rl_err(ring_to_netdev(ring),
+			    "failed to allocate rx frag\n");
+		return -ENOMEM;
+	}
+
+	desc_cb->reuse_flag = 1;
+	memcpy(frag, desc_cb->buf + frag_offset, frag_size);
+	skb_add_rx_frag(skb, i, virt_to_page(frag),
+			offset_in_page(frag), frag_size, frag_size);
+
+	u64_stats_update_begin(&ring->syncp);
+	ring->stats.frag_alloc++;
+	u64_stats_update_end(&ring->syncp);
+	return 0;
+}
+
 static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 				struct hns3_enet_ring *ring, int pull_len,
 				struct hns3_desc_cb *desc_cb)
@@ -3555,6 +3587,7 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 	int size = le16_to_cpu(desc->rx.size);
 	u32 truesize = hns3_buf_size(ring);
 	u32 frag_size = size - pull_len;
+	int ret = 0;
 	bool reused;
 
 	if (ring->page_pool) {
@@ -3589,27 +3622,9 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 		desc_cb->page_offset = 0;
 		desc_cb->reuse_flag = 1;
 	} else if (frag_size <= ring->rx_copybreak) {
-		void *frag = napi_alloc_frag(frag_size);
-
-		if (unlikely(!frag)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.frag_alloc_err++;
-			u64_stats_update_end(&ring->syncp);
-
-			hns3_rl_err(ring_to_netdev(ring),
-				    "failed to allocate rx frag\n");
+		ret = hns3_handle_rx_copybreak(skb, i, ring, pull_len, desc_cb);
+		if (ret)
 			goto out;
-		}
-
-		desc_cb->reuse_flag = 1;
-		memcpy(frag, desc_cb->buf + frag_offset, frag_size);
-		skb_add_rx_frag(skb, i, virt_to_page(frag),
-				offset_in_page(frag), frag_size, frag_size);
-
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.frag_alloc++;
-		u64_stats_update_end(&ring->syncp);
-		return;
 	}
 
 out:
-- 
2.33.0

