Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4913FB10B
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 08:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhH3GLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 02:11:38 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:15269 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbhH3GLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 02:11:33 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Gyg0S2qlTz8CQq;
        Mon, 30 Aug 2021 14:10:16 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 14:10:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 30 Aug 2021 14:10:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/7] net: hns3: reconstruct function hns3_self_test
Date:   Mon, 30 Aug 2021 14:06:37 +0800
Message-ID: <1630303602-44870-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630303602-44870-1-git-send-email-huangguangbin2@huawei.com>
References: <1630303602-44870-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch reconstructs function hns3_self_test to reduce the code
cycle complexity and make code more concise.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 101 +++++++++++++--------
 1 file changed, 64 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index b8d9851aefc5..7ea511d59e91 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -298,33 +298,8 @@ static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
 	return ret_val;
 }
 
-/**
- * hns3_self_test - self test
- * @ndev: net device
- * @eth_test: test cmd
- * @data: test result
- */
-static void hns3_self_test(struct net_device *ndev,
-			   struct ethtool_test *eth_test, u64 *data)
+static void hns3_set_selftest_param(struct hnae3_handle *h, int (*st_param)[2])
 {
-	struct hns3_nic_priv *priv = netdev_priv(ndev);
-	struct hnae3_handle *h = priv->ae_handle;
-	int st_param[HNS3_SELF_TEST_TYPE_NUM][2];
-	bool if_running = netif_running(ndev);
-	int test_index = 0;
-	u32 i;
-
-	if (hns3_nic_resetting(ndev)) {
-		netdev_err(ndev, "dev resetting!");
-		return;
-	}
-
-	/* Only do offline selftest, or pass by default */
-	if (eth_test->flags != ETH_TEST_FL_OFFLINE)
-		return;
-
-	netif_dbg(h, drv, ndev, "self test start");
-
 	st_param[HNAE3_LOOP_APP][0] = HNAE3_LOOP_APP;
 	st_param[HNAE3_LOOP_APP][1] =
 			h->flags & HNAE3_SUPPORT_APP_LOOPBACK;
@@ -341,6 +316,18 @@ static void hns3_self_test(struct net_device *ndev,
 	st_param[HNAE3_LOOP_PHY][0] = HNAE3_LOOP_PHY;
 	st_param[HNAE3_LOOP_PHY][1] =
 			h->flags & HNAE3_SUPPORT_PHY_LOOPBACK;
+}
+
+static void hns3_selftest_prepare(struct net_device *ndev,
+				  bool if_running, int (*st_param)[2])
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+
+	if (netif_msg_ifdown(h))
+		netdev_info(ndev, "self test start\n");
+
+	hns3_set_selftest_param(h, st_param);
 
 	if (if_running)
 		ndev->netdev_ops->ndo_stop(ndev);
@@ -359,6 +346,35 @@ static void hns3_self_test(struct net_device *ndev,
 		h->ae_algo->ops->halt_autoneg(h, true);
 
 	set_bit(HNS3_NIC_STATE_TESTING, &priv->state);
+}
+
+static void hns3_selftest_restore(struct net_device *ndev, bool if_running)
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+
+	clear_bit(HNS3_NIC_STATE_TESTING, &priv->state);
+
+	if (h->ae_algo->ops->halt_autoneg)
+		h->ae_algo->ops->halt_autoneg(h, false);
+
+#if IS_ENABLED(CONFIG_VLAN_8021Q)
+	if (h->ae_algo->ops->enable_vlan_filter)
+		h->ae_algo->ops->enable_vlan_filter(h, true);
+#endif
+
+	if (if_running)
+		ndev->netdev_ops->ndo_open(ndev);
+
+	if (netif_msg_ifdown(h))
+		netdev_info(ndev, "self test end\n");
+}
+
+static void hns3_do_selftest(struct net_device *ndev, int (*st_param)[2],
+			     struct ethtool_test *eth_test, u64 *data)
+{
+	int test_index = 0;
+	u32 i;
 
 	for (i = 0; i < HNS3_SELF_TEST_TYPE_NUM; i++) {
 		enum hnae3_loop loop_type = (enum hnae3_loop)st_param[i][0];
@@ -377,21 +393,32 @@ static void hns3_self_test(struct net_device *ndev,
 
 		test_index++;
 	}
+}
 
-	clear_bit(HNS3_NIC_STATE_TESTING, &priv->state);
-
-	if (h->ae_algo->ops->halt_autoneg)
-		h->ae_algo->ops->halt_autoneg(h, false);
+/**
+ * hns3_nic_self_test - self test
+ * @ndev: net device
+ * @eth_test: test cmd
+ * @data: test result
+ */
+static void hns3_self_test(struct net_device *ndev,
+			   struct ethtool_test *eth_test, u64 *data)
+{
+	int st_param[HNS3_SELF_TEST_TYPE_NUM][2];
+	bool if_running = netif_running(ndev);
 
-#if IS_ENABLED(CONFIG_VLAN_8021Q)
-	if (h->ae_algo->ops->enable_vlan_filter)
-		h->ae_algo->ops->enable_vlan_filter(h, true);
-#endif
+	if (hns3_nic_resetting(ndev)) {
+		netdev_err(ndev, "dev resetting!");
+		return;
+	}
 
-	if (if_running)
-		ndev->netdev_ops->ndo_open(ndev);
+	/* Only do offline selftest, or pass by default */
+	if (eth_test->flags != ETH_TEST_FL_OFFLINE)
+		return;
 
-	netif_dbg(h, drv, ndev, "self test end\n");
+	hns3_selftest_prepare(ndev, if_running, st_param);
+	hns3_do_selftest(ndev, st_param, eth_test, data);
+	hns3_selftest_restore(ndev, if_running);
 }
 
 static void hns3_update_limit_promisc_mode(struct net_device *netdev,
-- 
2.8.1

