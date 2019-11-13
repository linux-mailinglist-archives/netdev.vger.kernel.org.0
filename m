Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE81FA07D
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfKMBue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:50:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:37232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727384AbfKMBud (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57D6C2245C;
        Wed, 13 Nov 2019 01:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609833;
        bh=WNsF6Bm/ucOCzZ4B1FgoNMBmvHRd5PQZhX2EkWDEkZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtZytccUj/M0ZV2VJx6eI1Aa6TSq5gJsEFm6utA3fXPC6R7PtRowiSy5xqeJAe4Lr
         QoRV5tt3On5VGtI0gQxNVMVqwmA8VCVuJ3Q9pRssvXkTFmluUjz1Pe/Nr9aJrm0S6m
         07caIac2Wfmaj5dCbIBwRSvM3qKujDlVi8lbCnMo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 006/209] net: hns3: Fix loss of coal configuration while doing reset
Date:   Tue, 12 Nov 2019 20:47:02 -0500
Message-Id: <20191113015025.9685-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit e4fd75022c24eb28cc1034e97e60cecc24f325f3 ]

The user's coal configuration will be lost after reset, so the tx_coal
and rx_coal fields are added to the struct hns_nic_priv to save the coal
configuration and used to restore the user's configuration after the reset
is complete.

Fixes: bb6b94a896d4 ("net: hns3: Add reset interface implementation in client")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 71 +++++++++----------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  2 +
 2 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a5e3d38f18230..15030df574a8b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -195,8 +195,6 @@ void hns3_set_vector_coalesce_tx_gl(struct hns3_enet_tqp_vector *tqp_vector,
 static void hns3_vector_gl_rl_init(struct hns3_enet_tqp_vector *tqp_vector,
 				   struct hns3_nic_priv *priv)
 {
-	struct hnae3_handle *h = priv->ae_handle;
-
 	/* initialize the configuration for interrupt coalescing.
 	 * 1. GL (Interrupt Gap Limiter)
 	 * 2. RL (Interrupt Rate Limiter)
@@ -209,9 +207,6 @@ static void hns3_vector_gl_rl_init(struct hns3_enet_tqp_vector *tqp_vector,
 	tqp_vector->tx_group.coal.int_gl = HNS3_INT_GL_50K;
 	tqp_vector->rx_group.coal.int_gl = HNS3_INT_GL_50K;
 
-	/* Default: disable RL */
-	h->kinfo.int_rl_setting = 0;
-
 	tqp_vector->int_adapt_down = HNS3_INT_ADAPT_DOWN_START;
 	tqp_vector->rx_group.coal.flow_level = HNS3_FLOW_LOW;
 	tqp_vector->tx_group.coal.flow_level = HNS3_FLOW_LOW;
@@ -3423,6 +3418,31 @@ int hns3_nic_reset_all_ring(struct hnae3_handle *h)
 	return 0;
 }
 
+static void hns3_store_coal(struct hns3_nic_priv *priv)
+{
+	/* ethtool only support setting and querying one coal
+	 * configuation for now, so save the vector 0' coal
+	 * configuation here in order to restore it.
+	 */
+	memcpy(&priv->tx_coal, &priv->tqp_vector[0].tx_group.coal,
+	       sizeof(struct hns3_enet_coalesce));
+	memcpy(&priv->rx_coal, &priv->tqp_vector[0].rx_group.coal,
+	       sizeof(struct hns3_enet_coalesce));
+}
+
+static void hns3_restore_coal(struct hns3_nic_priv *priv)
+{
+	u16 vector_num = priv->vector_num;
+	int i;
+
+	for (i = 0; i < vector_num; i++) {
+		memcpy(&priv->tqp_vector[i].tx_group.coal, &priv->tx_coal,
+		       sizeof(struct hns3_enet_coalesce));
+		memcpy(&priv->tqp_vector[i].rx_group.coal, &priv->rx_coal,
+		       sizeof(struct hns3_enet_coalesce));
+	}
+}
+
 static int hns3_reset_notify_down_enet(struct hnae3_handle *handle)
 {
 	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
@@ -3469,6 +3489,8 @@ static int hns3_reset_notify_init_enet(struct hnae3_handle *handle)
 	/* Carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
 
+	hns3_restore_coal(priv);
+
 	ret = hns3_nic_init_vector_data(priv);
 	if (ret)
 		return ret;
@@ -3496,6 +3518,8 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 		return ret;
 	}
 
+	hns3_store_coal(priv);
+
 	ret = hns3_uninit_all_ring(priv);
 	if (ret)
 		netdev_err(netdev, "uninit ring error\n");
@@ -3530,24 +3554,7 @@ static int hns3_reset_notify(struct hnae3_handle *handle,
 	return ret;
 }
 
-static void hns3_restore_coal(struct hns3_nic_priv *priv,
-			      struct hns3_enet_coalesce *tx,
-			      struct hns3_enet_coalesce *rx)
-{
-	u16 vector_num = priv->vector_num;
-	int i;
-
-	for (i = 0; i < vector_num; i++) {
-		memcpy(&priv->tqp_vector[i].tx_group.coal, tx,
-		       sizeof(struct hns3_enet_coalesce));
-		memcpy(&priv->tqp_vector[i].rx_group.coal, rx,
-		       sizeof(struct hns3_enet_coalesce));
-	}
-}
-
-static int hns3_modify_tqp_num(struct net_device *netdev, u16 new_tqp_num,
-			       struct hns3_enet_coalesce *tx,
-			       struct hns3_enet_coalesce *rx)
+static int hns3_modify_tqp_num(struct net_device *netdev, u16 new_tqp_num)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = hns3_get_handle(netdev);
@@ -3565,7 +3572,7 @@ static int hns3_modify_tqp_num(struct net_device *netdev, u16 new_tqp_num,
 	if (ret)
 		goto err_alloc_vector;
 
-	hns3_restore_coal(priv, tx, rx);
+	hns3_restore_coal(priv);
 
 	ret = hns3_nic_init_vector_data(priv);
 	if (ret)
@@ -3597,7 +3604,6 @@ int hns3_set_channels(struct net_device *netdev,
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct hnae3_knic_private_info *kinfo = &h->kinfo;
-	struct hns3_enet_coalesce tx_coal, rx_coal;
 	bool if_running = netif_running(netdev);
 	u32 new_tqp_num = ch->combined_count;
 	u16 org_tqp_num;
@@ -3629,15 +3635,7 @@ int hns3_set_channels(struct net_device *netdev,
 		goto open_netdev;
 	}
 
-	/* Changing the tqp num may also change the vector num,
-	 * ethtool only support setting and querying one coal
-	 * configuation for now, so save the vector 0' coal
-	 * configuation here in order to restore it.
-	 */
-	memcpy(&tx_coal, &priv->tqp_vector[0].tx_group.coal,
-	       sizeof(struct hns3_enet_coalesce));
-	memcpy(&rx_coal, &priv->tqp_vector[0].rx_group.coal,
-	       sizeof(struct hns3_enet_coalesce));
+	hns3_store_coal(priv);
 
 	hns3_nic_dealloc_vector_data(priv);
 
@@ -3645,10 +3643,9 @@ int hns3_set_channels(struct net_device *netdev,
 	hns3_put_ring_config(priv);
 
 	org_tqp_num = h->kinfo.num_tqps;
-	ret = hns3_modify_tqp_num(netdev, new_tqp_num, &tx_coal, &rx_coal);
+	ret = hns3_modify_tqp_num(netdev, new_tqp_num);
 	if (ret) {
-		ret = hns3_modify_tqp_num(netdev, org_tqp_num,
-					  &tx_coal, &rx_coal);
+		ret = hns3_modify_tqp_num(netdev, org_tqp_num);
 		if (ret) {
 			/* If revert to old tqp failed, fatal error occurred */
 			dev_err(&netdev->dev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index cb450d7ec8c16..94d7446811d5d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -541,6 +541,8 @@ struct hns3_nic_priv {
 	/* Vxlan/Geneve information */
 	struct hns3_udp_tunnel udp_tnl[HNS3_UDP_TNL_MAX];
 	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
+	struct hns3_enet_coalesce tx_coal;
+	struct hns3_enet_coalesce rx_coal;
 };
 
 union l3_hdr_info {
-- 
2.20.1

