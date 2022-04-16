Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2545F50359B
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 11:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiDPJWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 05:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiDPJWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 05:22:00 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A852C49CA3;
        Sat, 16 Apr 2022 02:19:27 -0700 (PDT)
Received: from kwepemi500025.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KgSG05nzTzCr5B;
        Sat, 16 Apr 2022 17:15:04 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 17:19:25 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 17:19:25 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 2/9] net: hns3: refactor hns3_set_ringparam()
Date:   Sat, 16 Apr 2022 17:13:36 +0800
Message-ID: <20220416091343.35817-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220416091343.35817-1-huangguangbin2@huawei.com>
References: <20220416091343.35817-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
index 372b4c258df1..bea810a26aac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1104,6 +1104,36 @@ static int hns3_check_ringparam(struct net_device *ndev,
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
@@ -1125,29 +1155,19 @@ static int hns3_set_ringparam(struct net_device *ndev,
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
@@ -1158,24 +1178,25 @@ static int hns3_set_ringparam(struct net_device *ndev,
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

