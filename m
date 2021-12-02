Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EE3465FB2
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346010AbhLBIoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:44:14 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29145 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345740AbhLBIoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:44:09 -0500
Received: from kwepemi500003.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J4TrP3qz8zXdQg;
        Thu,  2 Dec 2021 16:38:45 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500003.china.huawei.com (7.221.188.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:44 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 5/9] net: hns3: split function hns3_nic_net_xmit()
Date:   Thu, 2 Dec 2021 16:35:59 +0800
Message-ID: <20211202083603.25176-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202083603.25176-1-huangguangbin2@huawei.com>
References: <20211202083603.25176-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Function hns3_nic_net_xmit() is a bit too long. So add a
new function hns3_handle_skb_desc() to simplify code and improve
code readability.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 47 +++++++++++--------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a6e12d81949e..8dcc2d80553b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1637,7 +1637,6 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 			      struct hns3_desc_cb *desc_cb)
 {
 	struct hns3_desc_param param;
-	u8 fd_op;
 	int ret;
 
 	hns3_init_desc_data(skb, &param);
@@ -2185,15 +2184,39 @@ static int hns3_handle_desc_filling(struct hns3_enet_ring *ring,
 	return hns3_fill_skb_to_desc(ring, skb, DESC_TYPE_SKB);
 }
 
+static int hns3_handle_skb_desc(struct hns3_enet_ring *ring,
+				struct sk_buff *skb,
+				struct hns3_desc_cb *desc_cb,
+				int next_to_use_head)
+{
+	int ret;
+
+	ret = hns3_fill_skb_desc(ring, skb, &ring->desc[ring->next_to_use],
+				 desc_cb);
+	if (unlikely(ret < 0))
+		goto fill_err;
+
+	/* 'ret < 0' means filling error, 'ret == 0' means skb->len is
+	 * zero, which is unlikely, and 'ret > 0' means how many tx desc
+	 * need to be notified to the hw.
+	 */
+	ret = hns3_handle_desc_filling(ring, skb);
+	if (likely(ret > 0))
+		return ret;
+
+fill_err:
+	hns3_clear_desc(ring, next_to_use_head);
+	return ret;
+}
+
 netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hns3_enet_ring *ring = &priv->ring[skb->queue_mapping];
 	struct hns3_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_use];
 	struct netdev_queue *dev_queue;
-	int pre_ntu, next_to_use_head;
+	int pre_ntu, ret;
 	bool doorbell;
-	int ret;
 
 	/* Hardware can only handle short frames above 32 bytes */
 	if (skb_put_padto(skb, HNS3_MIN_TX_LEN)) {
@@ -2218,20 +2241,9 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 		goto out_err_tx_ok;
 	}
 
-	next_to_use_head = ring->next_to_use;
-
-	ret = hns3_fill_skb_desc(ring, skb, &ring->desc[ring->next_to_use],
-				 desc_cb);
-	if (unlikely(ret < 0))
-		goto fill_err;
-
-	/* 'ret < 0' means filling error, 'ret == 0' means skb->len is
-	 * zero, which is unlikely, and 'ret > 0' means how many tx desc
-	 * need to be notified to the hw.
-	 */
-	ret = hns3_handle_desc_filling(ring, skb);
+	ret = hns3_handle_skb_desc(ring, skb, desc_cb, ring->next_to_use);
 	if (unlikely(ret <= 0))
-		goto fill_err;
+		goto out_err_tx_ok;
 
 	pre_ntu = ring->next_to_use ? (ring->next_to_use - 1) :
 					(ring->desc_num - 1);
@@ -2253,9 +2265,6 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	return NETDEV_TX_OK;
 
-fill_err:
-	hns3_clear_desc(ring, next_to_use_head);
-
 out_err_tx_ok:
 	dev_kfree_skb_any(skb);
 	hns3_tx_doorbell(ring, 0, !netdev_xmit_more());
-- 
2.33.0

