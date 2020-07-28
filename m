Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F11522FF72
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 04:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgG1CTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 22:19:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8284 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726362AbgG1CTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 22:19:09 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 827C03F2D34CF3D04A81;
        Tue, 28 Jul 2020 10:19:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 10:18:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 1/5] net: hns3: fix desc filling bug when skb is expanded or lineared
Date:   Tue, 28 Jul 2020 10:16:48 +0800
Message-ID: <1595902612-12880-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595902612-12880-1-git-send-email-tanhuazhong@huawei.com>
References: <1595902612-12880-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

The linear and frag data part may be changed when the skb is expanded
or lineared in skb_cow_head() or skb_checksum_help(), which is called
by hns3_fill_skb_desc(), so the linear len return by skb_headlen()
before the calling of hns3_fill_skb_desc() is unreliable.

Move hns3_fill_skb_desc() before the calling of skb_headlen() to fix
this bug.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 33c481d..3328500 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1093,16 +1093,8 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	int k, sizeoflast;
 	dma_addr_t dma;
 
-	if (type == DESC_TYPE_SKB) {
-		struct sk_buff *skb = (struct sk_buff *)priv;
-		int ret;
-
-		ret = hns3_fill_skb_desc(ring, skb, desc);
-		if (unlikely(ret < 0))
-			return ret;
-
-		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
-	} else if (type == DESC_TYPE_FRAGLIST_SKB) {
+	if (type == DESC_TYPE_FRAGLIST_SKB ||
+	    type == DESC_TYPE_SKB) {
 		struct sk_buff *skb = (struct sk_buff *)priv;
 
 		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
@@ -1439,6 +1431,10 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	next_to_use_head = ring->next_to_use;
 
+	ret = hns3_fill_skb_desc(ring, skb, &ring->desc[ring->next_to_use]);
+	if (unlikely(ret < 0))
+		goto fill_err;
+
 	ret = hns3_fill_skb_to_desc(ring, skb, DESC_TYPE_SKB);
 	if (unlikely(ret < 0))
 		goto fill_err;
-- 
2.7.4

