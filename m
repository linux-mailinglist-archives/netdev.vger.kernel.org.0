Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08AA2FF285
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbfKPQTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:19:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729240AbfKPPpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:45:54 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 054DD20859;
        Sat, 16 Nov 2019 15:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919154;
        bh=1St0IB4d/J+sBqQdxP+OYlthiRbpI303Kf15KzA281M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6+FSHTAr0yDklp9tcWpKqBTZSVJTvhI85DwSKYOy1/P4tJg9GCDI6g359b8KAj8o
         X2Byre9DC3mDm2kH+PtSKOousF96pbfHghVjgB1W4CHuy3pZpcIauGutogK9VHMd3w
         CeHJmnx478mzo7/51AUdzFu+Fl2sxD7eyvUpksP8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 168/237] net: hns3: bugfix for buffer not free problem during resetting
Date:   Sat, 16 Nov 2019 10:40:03 -0500
Message-Id: <20191116154113.7417-168-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 73b907a083b8a8c1c62cb494bc9fbe6ae086c460 ]

When hns3_get_ring_config()/hns3_queue_to_ring()/
hns3_get_vector_ring_chain() failed during resetting, the allocated
memory has not been freed before these three functions return. So
this patch adds error handler in these functions to fix it.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 24 ++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0ccfa6a845353..c1873e04b0fb6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2558,7 +2558,7 @@ static int hns3_get_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
 			chain = devm_kzalloc(&pdev->dev, sizeof(*chain),
 					     GFP_KERNEL);
 			if (!chain)
-				return -ENOMEM;
+				goto err_free_chain;
 
 			cur_chain->next = chain;
 			chain->tqp_index = tx_ring->tqp->tqp_index;
@@ -2588,7 +2588,7 @@ static int hns3_get_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
 	while (rx_ring) {
 		chain = devm_kzalloc(&pdev->dev, sizeof(*chain), GFP_KERNEL);
 		if (!chain)
-			return -ENOMEM;
+			goto err_free_chain;
 
 		cur_chain->next = chain;
 		chain->tqp_index = rx_ring->tqp->tqp_index;
@@ -2603,6 +2603,16 @@ static int hns3_get_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
 	}
 
 	return 0;
+
+err_free_chain:
+	cur_chain = head->next;
+	while (cur_chain) {
+		chain = cur_chain->next;
+		devm_kfree(&pdev->dev, chain);
+		cur_chain = chain;
+	}
+
+	return -ENOMEM;
 }
 
 static void hns3_free_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
@@ -2847,8 +2857,10 @@ static int hns3_queue_to_ring(struct hnae3_queue *tqp,
 		return ret;
 
 	ret = hns3_ring_get_cfg(tqp, priv, HNAE3_RING_TYPE_RX);
-	if (ret)
+	if (ret) {
+		devm_kfree(priv->dev, priv->ring_data[tqp->tqp_index].ring);
 		return ret;
+	}
 
 	return 0;
 }
@@ -2875,6 +2887,12 @@ static int hns3_get_ring_config(struct hns3_nic_priv *priv)
 
 	return 0;
 err:
+	while (i--) {
+		devm_kfree(priv->dev, priv->ring_data[i].ring);
+		devm_kfree(priv->dev,
+			   priv->ring_data[i + h->kinfo.num_tqps].ring);
+	}
+
 	devm_kfree(&pdev->dev, priv->ring_data);
 	return ret;
 }
-- 
2.20.1

