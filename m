Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A1A3F6FC1
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbhHYGpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:45:40 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14414 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238906AbhHYGpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:45:33 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gvbw85TCmzbdZZ;
        Wed, 25 Aug 2021 14:40:56 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:44:46 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:44:46 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/5] net: hns3: add support to set/get rx buf len via ethtool for hns3 driver
Date:   Wed, 25 Aug 2021 14:40:54 +0800
Message-ID: <1629873655-51539-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
References: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Rx buf len is for rx BD buffer size, support setting it via ethtool -G
parameter and getting it via ethtool -g parameter.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 42 ++++++++++++++++++----
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 5a21b9eb9820..c78b3a377197 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -616,7 +616,7 @@ static void hns3_get_ringparam(struct net_device *netdev,
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
-	int queue_num = h->kinfo.num_tqps;
+	int rx_queue_index = h->kinfo.num_tqps;
 
 	if (hns3_nic_resetting(netdev)) {
 		netdev_err(netdev, "dev resetting!");
@@ -627,7 +627,8 @@ static void hns3_get_ringparam(struct net_device *netdev,
 	param->rx_max_pending = HNS3_RING_MAX_PENDING;
 
 	param->tx_pending = priv->ring[0].desc_num;
-	param->rx_pending = priv->ring[queue_num].desc_num;
+	param->rx_pending = priv->ring[rx_queue_index].desc_num;
+	param->rx_buf_len = priv->ring[rx_queue_index].buf_size;
 }
 
 static void hns3_get_pauseparam(struct net_device *netdev,
@@ -1031,12 +1032,20 @@ static struct hns3_enet_ring *hns3_backup_ringparam(struct hns3_nic_priv *priv)
 static int hns3_check_ringparam(struct net_device *ndev,
 				struct ethtool_ringparam *param)
 {
+#define RX_BUF_LEN_2K 2048
+#define RX_BUF_LEN_4K 4096
 	if (hns3_nic_resetting(ndev))
 		return -EBUSY;
 
 	if (param->rx_mini_pending || param->rx_jumbo_pending)
 		return -EINVAL;
 
+	if (param->rx_buf_len != RX_BUF_LEN_2K &&
+	    param->rx_buf_len != RX_BUF_LEN_4K) {
+		netdev_err(ndev, "Rx buf len only support 2048 and 4096\n");
+		return -EINVAL;
+	}
+
 	if (param->tx_pending > HNS3_RING_MAX_PENDING ||
 	    param->tx_pending < HNS3_RING_MIN_PENDING ||
 	    param->rx_pending > HNS3_RING_MAX_PENDING ||
@@ -1049,6 +1058,22 @@ static int hns3_check_ringparam(struct net_device *ndev,
 	return 0;
 }
 
+static int hns3_change_rx_buf_len(struct net_device *ndev, u32 rx_buf_len)
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+	int i;
+
+	h->kinfo.rx_buf_len = rx_buf_len;
+
+	for (i = 0; i < h->kinfo.num_tqps; i++) {
+		h->kinfo.tqp[i]->buf_size = rx_buf_len;
+		priv->ring[i + h->kinfo.num_tqps].buf_size = rx_buf_len;
+	}
+
+	return 0;
+}
+
 static int hns3_set_ringparam(struct net_device *ndev,
 			      struct ethtool_ringparam *param)
 {
@@ -1059,6 +1084,7 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	u32 old_tx_desc_num, new_tx_desc_num;
 	u32 old_rx_desc_num, new_rx_desc_num;
 	u16 queue_num = h->kinfo.num_tqps;
+	u32 old_rx_buf_len;
 	int ret, i;
 
 	ret = hns3_check_ringparam(ndev, param);
@@ -1070,8 +1096,10 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	new_rx_desc_num = ALIGN(param->rx_pending, HNS3_RING_BD_MULTIPLE);
 	old_tx_desc_num = priv->ring[0].desc_num;
 	old_rx_desc_num = priv->ring[queue_num].desc_num;
+	old_rx_buf_len = priv->ring[queue_num].buf_size;
 	if (old_tx_desc_num == new_tx_desc_num &&
-	    old_rx_desc_num == new_rx_desc_num)
+	    old_rx_desc_num == new_rx_desc_num &&
+	    param->rx_buf_len == old_rx_buf_len)
 		return 0;
 
 	tmp_rings = hns3_backup_ringparam(priv);
@@ -1082,19 +1110,21 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	}
 
 	netdev_info(ndev,
-		    "Changing Tx/Rx ring depth from %u/%u to %u/%u\n",
+		    "Changing Tx/Rx ring depth from %u/%u to %u/%u, Changing rx buffer len to %d\n",
 		    old_tx_desc_num, old_rx_desc_num,
-		    new_tx_desc_num, new_rx_desc_num);
+		    new_tx_desc_num, new_rx_desc_num, param->rx_buf_len);
 
 	if (if_running)
 		ndev->netdev_ops->ndo_stop(ndev);
 
 	hns3_change_all_ring_bd_num(priv, new_tx_desc_num, new_rx_desc_num);
+	hns3_change_rx_buf_len(ndev, param->rx_buf_len);
 	ret = hns3_init_all_ring(priv);
 	if (ret) {
-		netdev_err(ndev, "Change bd num fail, revert to old value(%d)\n",
+		netdev_err(ndev, "set ringparam fail, revert to old value(%d)\n",
 			   ret);
 
+		hns3_change_rx_buf_len(ndev, old_rx_buf_len);
 		hns3_change_all_ring_bd_num(priv, old_tx_desc_num,
 					    old_rx_desc_num);
 		for (i = 0; i < h->kinfo.num_tqps * 2; i++)
-- 
2.8.1

