Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 877F5696C9
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388112AbfGOOFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388084AbfGOOFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:05:21 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A8352081C;
        Mon, 15 Jul 2019 14:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199520;
        bh=BCC8ryny6doXoWeAn3LpOBSsVGMWLmnLAL8OIfhGTWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDW7c27Y0Ds9YZKPFu244gQ/8cjPdjl9l3UD540ui2+gcCYw3Sb25a9efY/R9SsJ1
         678mebfrlpZ6Fb2xMiXZOPJ8yVT/YmxHr37Eku05fCswdUVpGO2G7ly8AjWbihvuui
         6SEszixlH8UGVY4QNJlPUeSN8jTJ2RW0zeZe5P/c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 031/219] net: hns3: initialize CPU reverse mapping
Date:   Mon, 15 Jul 2019 10:00:32 -0400
Message-Id: <20190715140341.6443-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit ffab9691bcb2fe2594f4c38bfceb4d9685b93b87 ]

Allocate CPU rmap and add entry for each irq. CPU rmap is
used in aRFS to get the queue number of the rx completion
interrupts.

In additional, remove the calling of
irq_set_affinity_notifier() in hns3_nic_init_irq(), because
we have registered notifier in irq_cpu_rmap_add() for each
vector, otherwise it may cause use-after-free issue.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 77 ++++++++++++-------
 1 file changed, 48 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index c7d310903319..5e41ed4954f9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4,6 +4,9 @@
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
+#ifdef CONFIG_RFS_ACCEL
+#include <linux/cpu_rmap.h>
+#endif
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -72,23 +75,6 @@ static irqreturn_t hns3_irq_handle(int irq, void *vector)
 	return IRQ_HANDLED;
 }
 
-/* This callback function is used to set affinity changes to the irq affinity
- * masks when the irq_set_affinity_notifier function is used.
- */
-static void hns3_nic_irq_affinity_notify(struct irq_affinity_notify *notify,
-					 const cpumask_t *mask)
-{
-	struct hns3_enet_tqp_vector *tqp_vectors =
-		container_of(notify, struct hns3_enet_tqp_vector,
-			     affinity_notify);
-
-	tqp_vectors->affinity_mask = *mask;
-}
-
-static void hns3_nic_irq_affinity_release(struct kref *ref)
-{
-}
-
 static void hns3_nic_uninit_irq(struct hns3_nic_priv *priv)
 {
 	struct hns3_enet_tqp_vector *tqp_vectors;
@@ -100,8 +86,7 @@ static void hns3_nic_uninit_irq(struct hns3_nic_priv *priv)
 		if (tqp_vectors->irq_init_flag != HNS3_VECTOR_INITED)
 			continue;
 
-		/* clear the affinity notifier and affinity mask */
-		irq_set_affinity_notifier(tqp_vectors->vector_irq, NULL);
+		/* clear the affinity mask */
 		irq_set_affinity_hint(tqp_vectors->vector_irq, NULL);
 
 		/* release the irq resource */
@@ -154,12 +139,6 @@ static int hns3_nic_init_irq(struct hns3_nic_priv *priv)
 			return ret;
 		}
 
-		tqp_vectors->affinity_notify.notify =
-					hns3_nic_irq_affinity_notify;
-		tqp_vectors->affinity_notify.release =
-					hns3_nic_irq_affinity_release;
-		irq_set_affinity_notifier(tqp_vectors->vector_irq,
-					  &tqp_vectors->affinity_notify);
 		irq_set_affinity_hint(tqp_vectors->vector_irq,
 				      &tqp_vectors->affinity_mask);
 
@@ -333,6 +312,40 @@ static void hns3_tqp_disable(struct hnae3_queue *tqp)
 	hns3_write_dev(tqp, HNS3_RING_EN_REG, rcb_reg);
 }
 
+static void hns3_free_rx_cpu_rmap(struct net_device *netdev)
+{
+#ifdef CONFIG_RFS_ACCEL
+	free_irq_cpu_rmap(netdev->rx_cpu_rmap);
+	netdev->rx_cpu_rmap = NULL;
+#endif
+}
+
+static int hns3_set_rx_cpu_rmap(struct net_device *netdev)
+{
+#ifdef CONFIG_RFS_ACCEL
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hns3_enet_tqp_vector *tqp_vector;
+	int i, ret;
+
+	if (!netdev->rx_cpu_rmap) {
+		netdev->rx_cpu_rmap = alloc_irq_cpu_rmap(priv->vector_num);
+		if (!netdev->rx_cpu_rmap)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < priv->vector_num; i++) {
+		tqp_vector = &priv->tqp_vector[i];
+		ret = irq_cpu_rmap_add(netdev->rx_cpu_rmap,
+				       tqp_vector->vector_irq);
+		if (ret) {
+			hns3_free_rx_cpu_rmap(netdev);
+			return ret;
+		}
+	}
+#endif
+	return 0;
+}
+
 static int hns3_nic_net_up(struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
@@ -344,11 +357,16 @@ static int hns3_nic_net_up(struct net_device *netdev)
 	if (ret)
 		return ret;
 
+	/* the device can work without cpu rmap, only aRFS needs it */
+	ret = hns3_set_rx_cpu_rmap(netdev);
+	if (ret)
+		netdev_warn(netdev, "set rx cpu rmap fail, ret=%d!\n", ret);
+
 	/* get irq resource for all vectors */
 	ret = hns3_nic_init_irq(priv);
 	if (ret) {
 		netdev_err(netdev, "hns init irq failed! ret=%d\n", ret);
-		return ret;
+		goto free_rmap;
 	}
 
 	clear_bit(HNS3_NIC_STATE_DOWN, &priv->state);
@@ -377,7 +395,8 @@ static int hns3_nic_net_up(struct net_device *netdev)
 		hns3_vector_disable(&priv->tqp_vector[j]);
 
 	hns3_nic_uninit_irq(priv);
-
+free_rmap:
+	hns3_free_rx_cpu_rmap(netdev);
 	return ret;
 }
 
@@ -460,6 +479,8 @@ static void hns3_nic_net_down(struct net_device *netdev)
 	if (ops->stop)
 		ops->stop(priv->ae_handle);
 
+	hns3_free_rx_cpu_rmap(netdev);
+
 	/* free irq resources */
 	hns3_nic_uninit_irq(priv);
 
@@ -3198,8 +3219,6 @@ static void hns3_nic_uninit_vector_data(struct hns3_nic_priv *priv)
 		hns3_free_vector_ring_chain(tqp_vector, &vector_ring_chain);
 
 		if (tqp_vector->irq_init_flag == HNS3_VECTOR_INITED) {
-			irq_set_affinity_notifier(tqp_vector->vector_irq,
-						  NULL);
 			irq_set_affinity_hint(tqp_vector->vector_irq, NULL);
 			free_irq(tqp_vector->vector_irq, tqp_vector);
 			tqp_vector->irq_init_flag = HNS3_VECTOR_NOT_INITED;
-- 
2.20.1

