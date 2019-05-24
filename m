Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9A829706
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391107AbfEXLVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:21:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17564 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390535AbfEXLVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 07:21:22 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B86DA1F9F949FB09928B;
        Fri, 24 May 2019 19:21:20 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 24 May 2019 19:21:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/4] net: hns3: initialize CPU reverse mapping
Date:   Fri, 24 May 2019 19:19:45 +0800
Message-ID: <1558696788-12944-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558696788-12944-1-git-send-email-tanhuazhong@huawei.com>
References: <1558696788-12944-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Allocate CPU rmap and add entry for each irq. CPU rmap is
used in aRFS to get the queue number of the rx completion
interrupts.

In additional, remove the calling of
irq_set_affinity_notifier() in hns3_nic_init_irq(), because
we have registered notifier in irq_cpu_rmap_add() for each
vector, otherwise it may cause use-after-free issue.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 77 +++++++++++++++----------
 1 file changed, 48 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 196a3d7..b2be424 100644
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
@@ -79,23 +82,6 @@ static irqreturn_t hns3_irq_handle(int irq, void *vector)
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
@@ -107,8 +93,7 @@ static void hns3_nic_uninit_irq(struct hns3_nic_priv *priv)
 		if (tqp_vectors->irq_init_flag != HNS3_VECTOR_INITED)
 			continue;
 
-		/* clear the affinity notifier and affinity mask */
-		irq_set_affinity_notifier(tqp_vectors->vector_irq, NULL);
+		/* clear the affinity mask */
 		irq_set_affinity_hint(tqp_vectors->vector_irq, NULL);
 
 		/* release the irq resource */
@@ -161,12 +146,6 @@ static int hns3_nic_init_irq(struct hns3_nic_priv *priv)
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
 
@@ -340,6 +319,40 @@ static void hns3_tqp_disable(struct hnae3_queue *tqp)
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
@@ -351,11 +364,16 @@ static int hns3_nic_net_up(struct net_device *netdev)
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
@@ -384,7 +402,8 @@ static int hns3_nic_net_up(struct net_device *netdev)
 		hns3_vector_disable(&priv->tqp_vector[j]);
 
 	hns3_nic_uninit_irq(priv);
-
+free_rmap:
+	hns3_free_rx_cpu_rmap(netdev);
 	return ret;
 }
 
@@ -467,6 +486,8 @@ static void hns3_nic_net_down(struct net_device *netdev)
 	if (ops->stop)
 		ops->stop(priv->ae_handle);
 
+	hns3_free_rx_cpu_rmap(netdev);
+
 	/* free irq resources */
 	hns3_nic_uninit_irq(priv);
 
@@ -3331,8 +3352,6 @@ static void hns3_nic_uninit_vector_data(struct hns3_nic_priv *priv)
 		hns3_free_vector_ring_chain(tqp_vector, &vector_ring_chain);
 
 		if (tqp_vector->irq_init_flag == HNS3_VECTOR_INITED) {
-			irq_set_affinity_notifier(tqp_vector->vector_irq,
-						  NULL);
 			irq_set_affinity_hint(tqp_vector->vector_irq, NULL);
 			free_irq(tqp_vector->vector_irq, tqp_vector);
 			tqp_vector->irq_init_flag = HNS3_VECTOR_NOT_INITED;
-- 
2.7.4

