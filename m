Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326097D420
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbfHAD55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:57:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3728 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729724AbfHAD54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:57:56 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 905049B5BF4A425B1B74;
        Thu,  1 Aug 2019 11:57:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/12] net: hns3: refine for set ring parameters
Date:   Thu, 1 Aug 2019 11:55:37 +0800
Message-ID: <1564631745-36733-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
References: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Previously, when changing the ring parameters, we free the old
ring resources firstly, and then setup the new ring resources.
In some case of an memory allocation fail, there will be no
resources to use. This patch refines it by setup new ring
resources and free the old ring resources in order.

Also reduce the max ring BD number to 32760 according to UM.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 88 +++++++++++++++-------
 3 files changed, 65 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index d2df42d..79973a0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3588,7 +3588,7 @@ static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
 	return ret;
 }
 
-static void hns3_fini_ring(struct hns3_enet_ring *ring)
+void hns3_fini_ring(struct hns3_enet_ring *ring)
 {
 	hns3_free_desc(ring);
 	devm_kfree(ring_to_dev(ring), ring->desc_cb);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 1a17856..0a970f5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -75,7 +75,7 @@ enum hns3_nic_state {
 #define HNS3_TX_TIMEOUT (5 * HZ)
 #define HNS3_RING_NAME_LEN			16
 #define HNS3_BUFFER_SIZE_2048			2048
-#define HNS3_RING_MAX_PENDING			32768
+#define HNS3_RING_MAX_PENDING			32760
 #define HNS3_RING_MIN_PENDING			24
 #define HNS3_RING_BD_MULTIPLE			8
 /* max frame size of mac */
@@ -642,6 +642,7 @@ void hns3_clean_tx_ring(struct hns3_enet_ring *ring);
 int hns3_init_all_ring(struct hns3_nic_priv *priv);
 int hns3_uninit_all_ring(struct hns3_nic_priv *priv);
 int hns3_nic_reset_all_ring(struct hnae3_handle *h);
+void hns3_fini_ring(struct hns3_enet_ring *ring);
 netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev);
 bool hns3_is_phys_func(struct pci_dev *pdev);
 int hns3_clean_rx_ring(
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index fe0f82a..02f46c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -867,8 +867,8 @@ static int hns3_get_rxnfc(struct net_device *netdev,
 	}
 }
 
-static int hns3_change_all_ring_bd_num(struct hns3_nic_priv *priv,
-				       u32 tx_desc_num, u32 rx_desc_num)
+static void hns3_change_all_ring_bd_num(struct hns3_nic_priv *priv,
+					u32 tx_desc_num, u32 rx_desc_num)
 {
 	struct hnae3_handle *h = priv->ae_handle;
 	int i;
@@ -881,21 +881,29 @@ static int hns3_change_all_ring_bd_num(struct hns3_nic_priv *priv,
 		priv->ring_data[i + h->kinfo.num_tqps].ring->desc_num =
 			rx_desc_num;
 	}
-
-	return hns3_init_all_ring(priv);
 }
 
-static int hns3_set_ringparam(struct net_device *ndev,
-			      struct ethtool_ringparam *param)
+static struct hns3_enet_ring *hns3_backup_ringparam(struct hns3_nic_priv *priv)
 {
-	struct hns3_nic_priv *priv = netdev_priv(ndev);
-	struct hnae3_handle *h = priv->ae_handle;
-	bool if_running = netif_running(ndev);
-	u32 old_tx_desc_num, new_tx_desc_num;
-	u32 old_rx_desc_num, new_rx_desc_num;
-	int queue_num = h->kinfo.num_tqps;
-	int ret;
+	struct hnae3_handle *handle = priv->ae_handle;
+	struct hns3_enet_ring *tmp_rings;
+	int i;
 
+	tmp_rings = kcalloc(handle->kinfo.num_tqps * 2,
+			    sizeof(struct hns3_enet_ring), GFP_KERNEL);
+	if (!tmp_rings)
+		return NULL;
+
+	for (i = 0; i < handle->kinfo.num_tqps * 2; i++)
+		memcpy(&tmp_rings[i], priv->ring_data[i].ring,
+		       sizeof(struct hns3_enet_ring));
+
+	return tmp_rings;
+}
+
+static int hns3_check_ringparam(struct net_device *ndev,
+				struct ethtool_ringparam *param)
+{
 	if (hns3_nic_resetting(ndev))
 		return -EBUSY;
 
@@ -911,6 +919,25 @@ static int hns3_set_ringparam(struct net_device *ndev,
 		return -EINVAL;
 	}
 
+	return 0;
+}
+
+static int hns3_set_ringparam(struct net_device *ndev,
+			      struct ethtool_ringparam *param)
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+	struct hns3_enet_ring *tmp_rings;
+	bool if_running = netif_running(ndev);
+	u32 old_tx_desc_num, new_tx_desc_num;
+	u32 old_rx_desc_num, new_rx_desc_num;
+	u16 queue_num = h->kinfo.num_tqps;
+	int ret, i;
+
+	ret = hns3_check_ringparam(ndev, param);
+	if (ret)
+		return ret;
+
 	/* Hardware requires that its descriptors must be multiple of eight */
 	new_tx_desc_num = ALIGN(param->tx_pending, HNS3_RING_BD_MULTIPLE);
 	new_rx_desc_num = ALIGN(param->rx_pending, HNS3_RING_BD_MULTIPLE);
@@ -920,6 +947,13 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	    old_rx_desc_num == new_rx_desc_num)
 		return 0;
 
+	tmp_rings = hns3_backup_ringparam(priv);
+	if (!tmp_rings) {
+		netdev_err(ndev,
+			   "backup ring param failed by allocating memory fail\n");
+		return -ENOMEM;
+	}
+
 	netdev_info(ndev,
 		    "Changing Tx/Rx ring depth from %d/%d to %d/%d\n",
 		    old_tx_desc_num, old_rx_desc_num,
@@ -928,22 +962,24 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	if (if_running)
 		ndev->netdev_ops->ndo_stop(ndev);
 
-	ret = hns3_uninit_all_ring(priv);
-	if (ret)
-		return ret;
-
-	ret = hns3_change_all_ring_bd_num(priv, new_tx_desc_num,
-					  new_rx_desc_num);
+	hns3_change_all_ring_bd_num(priv, new_tx_desc_num, new_rx_desc_num);
+	ret = hns3_init_all_ring(priv);
 	if (ret) {
-		ret = hns3_change_all_ring_bd_num(priv, old_tx_desc_num,
-						  old_rx_desc_num);
-		if (ret) {
-			netdev_err(ndev,
-				   "Revert to old bd num fail, ret=%d.\n", ret);
-			return ret;
-		}
+		netdev_err(ndev, "Change bd num fail, revert to old value(%d)\n",
+			   ret);
+
+		hns3_change_all_ring_bd_num(priv, old_tx_desc_num,
+					    old_rx_desc_num);
+		for (i = 0; i < h->kinfo.num_tqps * 2; i++)
+			memcpy(priv->ring_data[i].ring, &tmp_rings[i],
+			       sizeof(struct hns3_enet_ring));
+	} else {
+		for (i = 0; i < h->kinfo.num_tqps * 2; i++)
+			hns3_fini_ring(&tmp_rings[i]);
 	}
 
+	kfree(tmp_rings);
+
 	if (if_running)
 		ret = ndev->netdev_ops->ndo_open(ndev);
 
-- 
2.7.4

