Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C35E5062B6
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 05:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348029AbiDSDfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 23:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347661AbiDSDfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 23:35:41 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A40C2BB09;
        Mon, 18 Apr 2022 20:32:55 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kj8Wg2DwFzhXw1;
        Tue, 19 Apr 2022 11:32:47 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 11:32:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 11:32:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH V2 net-next 2/9] net: hns3: refactor hns3_set_ringparam()
Date:   Tue, 19 Apr 2022 11:27:02 +0800
Message-ID: <20220419032709.15408-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220419032709.15408-1-huangguangbin2@huawei.com>
References: <20220419032709.15408-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Use struct hns3_ring_param to replace variable new/old_xxx and
add hns3_is_ringparam_changed() to judge them if is changed to
improve code readability.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 65 ++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3_ethtool.h    |  6 ++
 2 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 8663ba5d41d8..e647751e9054 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1106,6 +1106,36 @@ static int hns3_check_ringparam(struct net_device *ndev,
 	return 0;
 }
 
+static bool
+hns3_is_ringparam_changed(struct net_device *ndev,
+			  struct ethtool_ringparam *param,
+			  struct kernel_ethtool_ringparam *kernel_param,
+			  struct hns3_ring_param *old_ringparam,
+			  struct hns3_ring_param *new_ringparam)
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+	u16 queue_num = h->kinfo.num_tqps;
+
+	new_ringparam->tx_desc_num = ALIGN(param->tx_pending,
+					   HNS3_RING_BD_MULTIPLE);
+	new_ringparam->rx_desc_num = ALIGN(param->rx_pending,
+					   HNS3_RING_BD_MULTIPLE);
+	old_ringparam->tx_desc_num = priv->ring[0].desc_num;
+	old_ringparam->rx_desc_num = priv->ring[queue_num].desc_num;
+	old_ringparam->rx_buf_len = priv->ring[queue_num].buf_size;
+	new_ringparam->rx_buf_len = kernel_param->rx_buf_len;
+
+	if (old_ringparam->tx_desc_num == new_ringparam->tx_desc_num &&
+	    old_ringparam->rx_desc_num == new_ringparam->rx_desc_num &&
+	    old_ringparam->rx_buf_len == new_ringparam->rx_buf_len) {
+		netdev_info(ndev, "ringparam not changed\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int hns3_change_rx_buf_len(struct net_device *ndev, u32 rx_buf_len)
 {
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
@@ -1151,14 +1181,11 @@ static int hns3_set_ringparam(struct net_device *ndev,
 			      struct kernel_ethtool_ringparam *kernel_param,
 			      struct netlink_ext_ack *extack)
 {
+	struct hns3_ring_param old_ringparam, new_ringparam;
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
 	struct hnae3_handle *h = priv->ae_handle;
 	struct hns3_enet_ring *tmp_rings;
 	bool if_running = netif_running(ndev);
-	u32 old_tx_desc_num, new_tx_desc_num;
-	u32 old_rx_desc_num, new_rx_desc_num;
-	u16 queue_num = h->kinfo.num_tqps;
-	u32 old_rx_buf_len;
 	int ret, i;
 
 	ret = hns3_check_ringparam(ndev, param, kernel_param);
@@ -1169,15 +1196,8 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	if (ret)
 		return ret;
 
-	/* Hardware requires that its descriptors must be multiple of eight */
-	new_tx_desc_num = ALIGN(param->tx_pending, HNS3_RING_BD_MULTIPLE);
-	new_rx_desc_num = ALIGN(param->rx_pending, HNS3_RING_BD_MULTIPLE);
-	old_tx_desc_num = priv->ring[0].desc_num;
-	old_rx_desc_num = priv->ring[queue_num].desc_num;
-	old_rx_buf_len = priv->ring[queue_num].buf_size;
-	if (old_tx_desc_num == new_tx_desc_num &&
-	    old_rx_desc_num == new_rx_desc_num &&
-	    kernel_param->rx_buf_len == old_rx_buf_len)
+	if (!hns3_is_ringparam_changed(ndev, param, kernel_param,
+				       &old_ringparam, &new_ringparam))
 		return 0;
 
 	tmp_rings = hns3_backup_ringparam(priv);
@@ -1188,24 +1208,25 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	}
 
 	netdev_info(ndev,
-		    "Changing Tx/Rx ring depth from %u/%u to %u/%u, Changing rx buffer len from %d to %d\n",
-		    old_tx_desc_num, old_rx_desc_num,
-		    new_tx_desc_num, new_rx_desc_num,
-		    old_rx_buf_len, kernel_param->rx_buf_len);
+		    "Changing Tx/Rx ring depth from %u/%u to %u/%u, Changing rx buffer len from %u to %u\n",
+		    old_ringparam.tx_desc_num, old_ringparam.rx_desc_num,
+		    new_ringparam.tx_desc_num, new_ringparam.rx_desc_num,
+		    old_ringparam.rx_buf_len, new_ringparam.rx_buf_len);
 
 	if (if_running)
 		ndev->netdev_ops->ndo_stop(ndev);
 
-	hns3_change_all_ring_bd_num(priv, new_tx_desc_num, new_rx_desc_num);
-	hns3_change_rx_buf_len(ndev, kernel_param->rx_buf_len);
+	hns3_change_all_ring_bd_num(priv, new_ringparam.tx_desc_num,
+				    new_ringparam.rx_desc_num);
+	hns3_change_rx_buf_len(ndev, new_ringparam.rx_buf_len);
 	ret = hns3_init_all_ring(priv);
 	if (ret) {
 		netdev_err(ndev, "set ringparam fail, revert to old value(%d)\n",
 			   ret);
 
-		hns3_change_rx_buf_len(ndev, old_rx_buf_len);
-		hns3_change_all_ring_bd_num(priv, old_tx_desc_num,
-					    old_rx_desc_num);
+		hns3_change_rx_buf_len(ndev, old_ringparam.rx_buf_len);
+		hns3_change_all_ring_bd_num(priv, old_ringparam.tx_desc_num,
+					    old_ringparam.rx_desc_num);
 		for (i = 0; i < h->kinfo.num_tqps * 2; i++)
 			memcpy(&priv->ring[i], &tmp_rings[i],
 			       sizeof(struct hns3_enet_ring));
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h
index 822d6fcbc73b..da207d1d9aa9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h
@@ -28,4 +28,10 @@ struct hns3_ethtool_link_ext_state_mapping {
 	u8 link_ext_substate;
 };
 
+struct hns3_ring_param {
+	u32 tx_desc_num;
+	u32 rx_desc_num;
+	u32 rx_buf_len;
+};
+
 #endif
-- 
2.33.0

