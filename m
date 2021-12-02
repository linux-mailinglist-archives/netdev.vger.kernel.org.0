Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595D8465FB5
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345887AbhLBIoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:44:20 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29146 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345821AbhLBIoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:44:10 -0500
Received: from kwepemi500001.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J4TrR0W8NzXdQv;
        Thu,  2 Dec 2021 16:38:47 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500001.china.huawei.com (7.221.188.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:46 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:45 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 9/9] net: hns3: refactor function hns3_get_vector_ring_chain()
Date:   Thu, 2 Dec 2021 16:36:03 +0800
Message-ID: <20211202083603.25176-10-huangguangbin2@huawei.com>
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

From: Jie Wang <wangjie125@huawei.com>

Currently  hns3_get_vector_ring_chain() is a bit long. Refactor it by
extracting sub process to improve the readability.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 121 ++++++++----------
 1 file changed, 53 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 8dcc2d80553b..babc5d7a3b52 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4342,87 +4342,70 @@ static int hns3_nic_common_poll(struct napi_struct *napi, int budget)
 	return rx_pkt_total;
 }
 
-static int hns3_get_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
-				      struct hnae3_ring_chain_node *head)
+static int hns3_create_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
+				  struct hnae3_ring_chain_node **head,
+				  bool is_tx)
 {
+	u32 bit_value = is_tx ? HNAE3_RING_TYPE_TX : HNAE3_RING_TYPE_RX;
+	u32 field_value = is_tx ? HNAE3_RING_GL_TX : HNAE3_RING_GL_RX;
+	struct hnae3_ring_chain_node *cur_chain = *head;
 	struct pci_dev *pdev = tqp_vector->handle->pdev;
-	struct hnae3_ring_chain_node *cur_chain = head;
 	struct hnae3_ring_chain_node *chain;
-	struct hns3_enet_ring *tx_ring;
-	struct hns3_enet_ring *rx_ring;
-
-	tx_ring = tqp_vector->tx_group.ring;
-	if (tx_ring) {
-		cur_chain->tqp_index = tx_ring->tqp->tqp_index;
-		hnae3_set_bit(cur_chain->flag, HNAE3_RING_TYPE_B,
-			      HNAE3_RING_TYPE_TX);
-		hnae3_set_field(cur_chain->int_gl_idx, HNAE3_RING_GL_IDX_M,
-				HNAE3_RING_GL_IDX_S, HNAE3_RING_GL_TX);
-
-		cur_chain->next = NULL;
-
-		while (tx_ring->next) {
-			tx_ring = tx_ring->next;
-
-			chain = devm_kzalloc(&pdev->dev, sizeof(*chain),
-					     GFP_KERNEL);
-			if (!chain)
-				goto err_free_chain;
-
-			cur_chain->next = chain;
-			chain->tqp_index = tx_ring->tqp->tqp_index;
-			hnae3_set_bit(chain->flag, HNAE3_RING_TYPE_B,
-				      HNAE3_RING_TYPE_TX);
-			hnae3_set_field(chain->int_gl_idx,
-					HNAE3_RING_GL_IDX_M,
-					HNAE3_RING_GL_IDX_S,
-					HNAE3_RING_GL_TX);
-
-			cur_chain = chain;
-		}
-	}
+	struct hns3_enet_ring *ring;
 
-	rx_ring = tqp_vector->rx_group.ring;
-	if (!tx_ring && rx_ring) {
-		cur_chain->next = NULL;
-		cur_chain->tqp_index = rx_ring->tqp->tqp_index;
-		hnae3_set_bit(cur_chain->flag, HNAE3_RING_TYPE_B,
-			      HNAE3_RING_TYPE_RX);
-		hnae3_set_field(cur_chain->int_gl_idx, HNAE3_RING_GL_IDX_M,
-				HNAE3_RING_GL_IDX_S, HNAE3_RING_GL_RX);
+	ring = is_tx ? tqp_vector->tx_group.ring : tqp_vector->rx_group.ring;
 
-		rx_ring = rx_ring->next;
+	if (cur_chain) {
+		while (cur_chain->next)
+			cur_chain = cur_chain->next;
 	}
 
-	while (rx_ring) {
+	while (ring) {
 		chain = devm_kzalloc(&pdev->dev, sizeof(*chain), GFP_KERNEL);
 		if (!chain)
-			goto err_free_chain;
-
-		cur_chain->next = chain;
-		chain->tqp_index = rx_ring->tqp->tqp_index;
+			return -ENOMEM;
+		if (cur_chain)
+			cur_chain->next = chain;
+		else
+			*head = chain;
+		chain->tqp_index = ring->tqp->tqp_index;
 		hnae3_set_bit(chain->flag, HNAE3_RING_TYPE_B,
-			      HNAE3_RING_TYPE_RX);
-		hnae3_set_field(chain->int_gl_idx, HNAE3_RING_GL_IDX_M,
-				HNAE3_RING_GL_IDX_S, HNAE3_RING_GL_RX);
+				bit_value);
+		hnae3_set_field(chain->int_gl_idx,
+				HNAE3_RING_GL_IDX_M,
+				HNAE3_RING_GL_IDX_S, field_value);
 
 		cur_chain = chain;
 
-		rx_ring = rx_ring->next;
+		ring = ring->next;
 	}
 
 	return 0;
+}
+
+static struct hnae3_ring_chain_node *
+hns3_get_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector)
+{
+	struct pci_dev *pdev = tqp_vector->handle->pdev;
+	struct hnae3_ring_chain_node *cur_chain = NULL;
+	struct hnae3_ring_chain_node *chain;
+
+	if (hns3_create_ring_chain(tqp_vector, &cur_chain, true))
+		goto err_free_chain;
+
+	if (hns3_create_ring_chain(tqp_vector, &cur_chain, false))
+		goto err_free_chain;
+
+	return cur_chain;
 
 err_free_chain:
-	cur_chain = head->next;
 	while (cur_chain) {
 		chain = cur_chain->next;
 		devm_kfree(&pdev->dev, cur_chain);
 		cur_chain = chain;
 	}
-	head->next = NULL;
 
-	return -ENOMEM;
+	return NULL;
 }
 
 static void hns3_free_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
@@ -4431,7 +4414,7 @@ static void hns3_free_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
 	struct pci_dev *pdev = tqp_vector->handle->pdev;
 	struct hnae3_ring_chain_node *chain_tmp, *chain;
 
-	chain = head->next;
+	chain = head;
 
 	while (chain) {
 		chain_tmp = chain->next;
@@ -4546,7 +4529,7 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 	}
 
 	for (i = 0; i < priv->vector_num; i++) {
-		struct hnae3_ring_chain_node vector_ring_chain;
+		struct hnae3_ring_chain_node *vector_ring_chain;
 
 		tqp_vector = &priv->tqp_vector[i];
 
@@ -4556,15 +4539,16 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 		tqp_vector->tx_group.total_packets = 0;
 		tqp_vector->handle = h;
 
-		ret = hns3_get_vector_ring_chain(tqp_vector,
-						 &vector_ring_chain);
-		if (ret)
+		vector_ring_chain = hns3_get_vector_ring_chain(tqp_vector);
+		if (!vector_ring_chain) {
+			ret = -ENOMEM;
 			goto map_ring_fail;
+		}
 
 		ret = h->ae_algo->ops->map_ring_to_vector(h,
-			tqp_vector->vector_irq, &vector_ring_chain);
+			tqp_vector->vector_irq, vector_ring_chain);
 
-		hns3_free_vector_ring_chain(tqp_vector, &vector_ring_chain);
+		hns3_free_vector_ring_chain(tqp_vector, vector_ring_chain);
 
 		if (ret)
 			goto map_ring_fail;
@@ -4663,7 +4647,7 @@ static void hns3_clear_ring_group(struct hns3_enet_ring_group *group)
 
 static void hns3_nic_uninit_vector_data(struct hns3_nic_priv *priv)
 {
-	struct hnae3_ring_chain_node vector_ring_chain;
+	struct hnae3_ring_chain_node *vector_ring_chain;
 	struct hnae3_handle *h = priv->ae_handle;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	int i;
@@ -4678,13 +4662,14 @@ static void hns3_nic_uninit_vector_data(struct hns3_nic_priv *priv)
 		 * chain between vector and ring, we should go on to deal with
 		 * the remaining options.
 		 */
-		if (hns3_get_vector_ring_chain(tqp_vector, &vector_ring_chain))
+		vector_ring_chain = hns3_get_vector_ring_chain(tqp_vector);
+		if (!vector_ring_chain)
 			dev_warn(priv->dev, "failed to get ring chain\n");
 
 		h->ae_algo->ops->unmap_ring_from_vector(h,
-			tqp_vector->vector_irq, &vector_ring_chain);
+			tqp_vector->vector_irq, vector_ring_chain);
 
-		hns3_free_vector_ring_chain(tqp_vector, &vector_ring_chain);
+		hns3_free_vector_ring_chain(tqp_vector, vector_ring_chain);
 
 		hns3_clear_ring_group(&tqp_vector->rx_group);
 		hns3_clear_ring_group(&tqp_vector->tx_group);
-- 
2.33.0

