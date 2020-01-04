Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E924130032
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgADCtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:49:51 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8676 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727355AbgADCtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:42 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B51FC1725FB5C0EBD351;
        Sat,  4 Jan 2020 10:49:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Sat, 4 Jan 2020 10:49:26 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/8] net: hns3: re-organize vector handle
Date:   Sat, 4 Jan 2020 10:49:25 +0800
Message-ID: <1578106171-17238-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
References: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

To prevent loss user's IRQ affinity configuration when DOWN,
this patch moves out release/request operation of the vector
handle from net DOWN/UP, just do it when vector resource changes.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 100 ++++++++++++------------
 1 file changed, 52 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9a0694a..01bad67 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -161,6 +161,8 @@ static int hns3_nic_init_irq(struct hns3_nic_priv *priv)
 			return ret;
 		}
 
+		disable_irq(tqp_vectors->vector_irq);
+
 		irq_set_affinity_hint(tqp_vectors->vector_irq,
 				      &tqp_vectors->affinity_mask);
 
@@ -179,6 +181,7 @@ static void hns3_mask_vector_irq(struct hns3_enet_tqp_vector *tqp_vector,
 static void hns3_vector_enable(struct hns3_enet_tqp_vector *tqp_vector)
 {
 	napi_enable(&tqp_vector->napi);
+	enable_irq(tqp_vector->vector_irq);
 
 	/* enable vector */
 	hns3_mask_vector_irq(tqp_vector, 1);
@@ -378,18 +381,6 @@ static int hns3_nic_net_up(struct net_device *netdev)
 	if (ret)
 		return ret;
 
-	/* the device can work without cpu rmap, only aRFS needs it */
-	ret = hns3_set_rx_cpu_rmap(netdev);
-	if (ret)
-		netdev_warn(netdev, "set rx cpu rmap fail, ret=%d!\n", ret);
-
-	/* get irq resource for all vectors */
-	ret = hns3_nic_init_irq(priv);
-	if (ret) {
-		netdev_err(netdev, "init irq failed! ret=%d\n", ret);
-		goto free_rmap;
-	}
-
 	clear_bit(HNS3_NIC_STATE_DOWN, &priv->state);
 
 	/* enable the vectors */
@@ -402,22 +393,15 @@ static int hns3_nic_net_up(struct net_device *netdev)
 
 	/* start the ae_dev */
 	ret = h->ae_algo->ops->start ? h->ae_algo->ops->start(h) : 0;
-	if (ret)
-		goto out_start_err;
-
-	return 0;
-
-out_start_err:
-	set_bit(HNS3_NIC_STATE_DOWN, &priv->state);
-	while (j--)
-		hns3_tqp_disable(h->kinfo.tqp[j]);
+	if (ret) {
+		set_bit(HNS3_NIC_STATE_DOWN, &priv->state);
+		while (j--)
+			hns3_tqp_disable(h->kinfo.tqp[j]);
 
-	for (j = i - 1; j >= 0; j--)
-		hns3_vector_disable(&priv->tqp_vector[j]);
+		for (j = i - 1; j >= 0; j--)
+			hns3_vector_disable(&priv->tqp_vector[j]);
+	}
 
-	hns3_nic_uninit_irq(priv);
-free_rmap:
-	hns3_free_rx_cpu_rmap(netdev);
 	return ret;
 }
 
@@ -514,11 +498,6 @@ static void hns3_nic_net_down(struct net_device *netdev)
 	if (ops->stop)
 		ops->stop(priv->ae_handle);
 
-	hns3_free_rx_cpu_rmap(netdev);
-
-	/* free irq resources */
-	hns3_nic_uninit_irq(priv);
-
 	/* delay ring buffer clearing to hns3_reset_notify_uninit_enet
 	 * during reset process, because driver may not be able
 	 * to disable the ring through firmware when downing the netdev.
@@ -3642,19 +3621,13 @@ static void hns3_nic_uninit_vector_data(struct hns3_nic_priv *priv)
 
 		hns3_free_vector_ring_chain(tqp_vector, &vector_ring_chain);
 
-		if (tqp_vector->irq_init_flag == HNS3_VECTOR_INITED) {
-			irq_set_affinity_hint(tqp_vector->vector_irq, NULL);
-			free_irq(tqp_vector->vector_irq, tqp_vector);
-			tqp_vector->irq_init_flag = HNS3_VECTOR_NOT_INITED;
-		}
-
 		hns3_clear_ring_group(&tqp_vector->rx_group);
 		hns3_clear_ring_group(&tqp_vector->tx_group);
 		netif_napi_del(&priv->tqp_vector[i].napi);
 	}
 }
 
-static int hns3_nic_dealloc_vector_data(struct hns3_nic_priv *priv)
+static void hns3_nic_dealloc_vector_data(struct hns3_nic_priv *priv)
 {
 	struct hnae3_handle *h = priv->ae_handle;
 	struct pci_dev *pdev = h->pdev;
@@ -3666,11 +3639,10 @@ static int hns3_nic_dealloc_vector_data(struct hns3_nic_priv *priv)
 		tqp_vector = &priv->tqp_vector[i];
 		ret = h->ae_algo->ops->put_vector(h, tqp_vector->vector_irq);
 		if (ret)
-			return ret;
+			return;
 	}
 
 	devm_kfree(&pdev->dev, priv->tqp_vector);
-	return 0;
 }
 
 static void hns3_ring_get_cfg(struct hnae3_queue *q, struct hns3_nic_priv *priv,
@@ -4069,6 +4041,18 @@ static int hns3_client_init(struct hnae3_handle *handle)
 		goto out_reg_netdev_fail;
 	}
 
+	/* the device can work without cpu rmap, only aRFS needs it */
+	ret = hns3_set_rx_cpu_rmap(netdev);
+	if (ret)
+		dev_warn(priv->dev, "set rx cpu rmap fail, ret=%d\n", ret);
+
+	ret = hns3_nic_init_irq(priv);
+	if (ret) {
+		dev_err(priv->dev, "init irq failed! ret=%d\n", ret);
+		hns3_free_rx_cpu_rmap(netdev);
+		goto out_init_irq_fail;
+	}
+
 	ret = hns3_client_start(handle);
 	if (ret) {
 		dev_err(priv->dev, "hns3_client_start fail! ret=%d\n", ret);
@@ -4090,6 +4074,9 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	return ret;
 
 out_client_start:
+	hns3_free_rx_cpu_rmap(netdev);
+	hns3_nic_uninit_irq(priv);
+out_init_irq_fail:
 	unregister_netdev(netdev);
 out_reg_netdev_fail:
 	hns3_uninit_phy(netdev);
@@ -4127,15 +4114,17 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 		goto out_netdev_free;
 	}
 
+	hns3_free_rx_cpu_rmap(netdev);
+
+	hns3_nic_uninit_irq(priv);
+
 	hns3_del_all_fd_rules(netdev, true);
 
 	hns3_clear_all_ring(handle, true);
 
 	hns3_nic_uninit_vector_data(priv);
 
-	ret = hns3_nic_dealloc_vector_data(priv);
-	if (ret)
-		netdev_err(netdev, "dealloc vector error\n");
+	hns3_nic_dealloc_vector_data(priv);
 
 	ret = hns3_uninit_all_ring(priv);
 	if (ret)
@@ -4462,17 +4451,32 @@ static int hns3_reset_notify_init_enet(struct hnae3_handle *handle)
 	if (ret)
 		goto err_uninit_vector;
 
+	/* the device can work without cpu rmap, only aRFS needs it */
+	ret = hns3_set_rx_cpu_rmap(netdev);
+	if (ret)
+		dev_warn(priv->dev, "set rx cpu rmap fail, ret=%d\n", ret);
+
+	ret = hns3_nic_init_irq(priv);
+	if (ret) {
+		dev_err(priv->dev, "init irq failed! ret=%d\n", ret);
+		hns3_free_rx_cpu_rmap(netdev);
+		goto err_init_irq_fail;
+	}
+
 	ret = hns3_client_start(handle);
 	if (ret) {
 		dev_err(priv->dev, "hns3_client_start fail! ret=%d\n", ret);
-		goto err_uninit_ring;
+		goto err_client_start_fail;
 	}
 
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
 
 	return ret;
 
-err_uninit_ring:
+err_client_start_fail:
+	hns3_free_rx_cpu_rmap(netdev);
+	hns3_nic_uninit_irq(priv);
+err_init_irq_fail:
 	hns3_uninit_all_ring(priv);
 err_uninit_vector:
 	hns3_nic_uninit_vector_data(priv);
@@ -4522,6 +4526,8 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 		return 0;
 	}
 
+	hns3_free_rx_cpu_rmap(netdev);
+	hns3_nic_uninit_irq(priv);
 	hns3_clear_all_ring(handle, true);
 	hns3_reset_tx_queue(priv->ae_handle);
 
@@ -4529,9 +4535,7 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 
 	hns3_store_coal(priv);
 
-	ret = hns3_nic_dealloc_vector_data(priv);
-	if (ret)
-		netdev_err(netdev, "dealloc vector error\n");
+	hns3_nic_dealloc_vector_data(priv);
 
 	ret = hns3_uninit_all_ring(priv);
 	if (ret)
-- 
2.7.4

