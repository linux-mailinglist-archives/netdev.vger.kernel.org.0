Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14385BA4B2
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 04:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiIPCkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 22:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiIPCkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 22:40:51 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97763ED61;
        Thu, 15 Sep 2022 19:40:47 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MTJ936WlkzNm9k;
        Fri, 16 Sep 2022 10:36:07 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 16 Sep 2022 10:40:45 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 10:40:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>, <shenjian15@huawei.com>
Subject: [PATCH net-next 1/4] net: hns3: add support for external loopback test
Date:   Fri, 16 Sep 2022 10:38:00 +0800
Message-ID: <20220916023803.23756-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220916023803.23756-1-huangguangbin2@huawei.com>
References: <20220916023803.23756-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

This patch add support for external loopback test.
The successful test need the link is up with duplex full. The
driver do external loopback first, and then the whole offline
test.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  2 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 51 ++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  3 +
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 61 +++++++++++++------
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 26 +++++---
 5 files changed, 119 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 9fb4cc303301..30a76f44a819 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -195,6 +195,7 @@ struct hns3_mac_stats {
 
 /* hnae3 loop mode */
 enum hnae3_loop {
+	HNAE3_LOOP_EXTERNAL,
 	HNAE3_LOOP_APP,
 	HNAE3_LOOP_SERIAL_SERDES,
 	HNAE3_LOOP_PARALLEL_SERDES,
@@ -839,6 +840,7 @@ struct hnae3_roce_private_info {
 #define HNAE3_SUPPORT_SERDES_SERIAL_LOOPBACK	BIT(2)
 #define HNAE3_SUPPORT_VF	      BIT(3)
 #define HNAE3_SUPPORT_SERDES_PARALLEL_LOOPBACK	BIT(4)
+#define HNAE3_SUPPORT_EXTERNAL_LOOPBACK	BIT(5)
 
 #define HNAE3_USER_UPE		BIT(0)	/* unicast promisc enabled by user */
 #define HNAE3_USER_MPE		BIT(1)	/* mulitcast promisc enabled by user */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 82f83e3f8162..db099549e511 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5827,6 +5827,57 @@ int hns3_set_channels(struct net_device *netdev,
 	return 0;
 }
 
+void hns3_external_lb_prepare(struct net_device *ndev, bool if_running)
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+	int i;
+
+	if (!if_running)
+		return;
+
+	netif_carrier_off(ndev);
+	netif_tx_disable(ndev);
+
+	for (i = 0; i < priv->vector_num; i++)
+		hns3_vector_disable(&priv->tqp_vector[i]);
+
+	for (i = 0; i < h->kinfo.num_tqps; i++)
+		hns3_tqp_disable(h->kinfo.tqp[i]);
+
+	/* delay ring buffer clearing to hns3_reset_notify_uninit_enet
+	 * during reset process, because driver may not be able
+	 * to disable the ring through firmware when downing the netdev.
+	 */
+	if (!hns3_nic_resetting(ndev))
+		hns3_nic_reset_all_ring(priv->ae_handle);
+
+	hns3_reset_tx_queue(priv->ae_handle);
+}
+
+void hns3_external_lb_restore(struct net_device *ndev, bool if_running)
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+	int i;
+
+	if (!if_running)
+		return;
+
+	hns3_nic_reset_all_ring(priv->ae_handle);
+
+	for (i = 0; i < priv->vector_num; i++)
+		hns3_vector_enable(&priv->tqp_vector[i]);
+
+	for (i = 0; i < h->kinfo.num_tqps; i++)
+		hns3_tqp_enable(h->kinfo.tqp[i]);
+
+	netif_tx_wake_all_queues(ndev);
+
+	if (h->ae_algo->ops->get_status(h))
+		netif_carrier_on(ndev);
+}
+
 static const struct hns3_hw_error_info hns3_hw_err[] = {
 	{ .type = HNAE3_PPU_POISON_ERROR,
 	  .msg = "PPU poison" },
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 4a3253692dcc..133a054af6b7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -744,4 +744,7 @@ u16 hns3_get_max_available_channels(struct hnae3_handle *h);
 void hns3_cq_period_mode_init(struct hns3_nic_priv *priv,
 			      enum dim_cq_period_mode tx_mode,
 			      enum dim_cq_period_mode rx_mode);
+
+void hns3_external_lb_prepare(struct net_device *ndev, bool if_running);
+void hns3_external_lb_restore(struct net_device *ndev, bool if_running);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 45cd19ef3c5b..cdf76fb58d45 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -69,7 +69,6 @@ static const struct hns3_stats hns3_rxq_stats[] = {
 
 #define HNS3_TQP_STATS_COUNT (HNS3_TXQ_STATS_COUNT + HNS3_RXQ_STATS_COUNT)
 
-#define HNS3_SELF_TEST_TYPE_NUM         4
 #define HNS3_NIC_LB_TEST_PKT_NUM	1
 #define HNS3_NIC_LB_TEST_RING_ID	0
 #define HNS3_NIC_LB_TEST_PACKET_SIZE	128
@@ -95,6 +94,7 @@ static int hns3_lp_setup(struct net_device *ndev, enum hnae3_loop loop, bool en)
 	case HNAE3_LOOP_PARALLEL_SERDES:
 	case HNAE3_LOOP_APP:
 	case HNAE3_LOOP_PHY:
+	case HNAE3_LOOP_EXTERNAL:
 		ret = h->ae_algo->ops->set_loopback(h, loop, en);
 		break;
 	default:
@@ -304,6 +304,10 @@ static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
 
 static void hns3_set_selftest_param(struct hnae3_handle *h, int (*st_param)[2])
 {
+	st_param[HNAE3_LOOP_EXTERNAL][0] = HNAE3_LOOP_EXTERNAL;
+	st_param[HNAE3_LOOP_EXTERNAL][1] =
+			h->flags & HNAE3_SUPPORT_EXTERNAL_LOOPBACK;
+
 	st_param[HNAE3_LOOP_APP][0] = HNAE3_LOOP_APP;
 	st_param[HNAE3_LOOP_APP][1] =
 			h->flags & HNAE3_SUPPORT_APP_LOOPBACK;
@@ -322,17 +326,11 @@ static void hns3_set_selftest_param(struct hnae3_handle *h, int (*st_param)[2])
 			h->flags & HNAE3_SUPPORT_PHY_LOOPBACK;
 }
 
-static void hns3_selftest_prepare(struct net_device *ndev,
-				  bool if_running, int (*st_param)[2])
+static void hns3_selftest_prepare(struct net_device *ndev, bool if_running)
 {
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
 	struct hnae3_handle *h = priv->ae_handle;
 
-	if (netif_msg_ifdown(h))
-		netdev_info(ndev, "self test start\n");
-
-	hns3_set_selftest_param(h, st_param);
-
 	if (if_running)
 		ndev->netdev_ops->ndo_stop(ndev);
 
@@ -371,18 +369,15 @@ static void hns3_selftest_restore(struct net_device *ndev, bool if_running)
 
 	if (if_running)
 		ndev->netdev_ops->ndo_open(ndev);
-
-	if (netif_msg_ifdown(h))
-		netdev_info(ndev, "self test end\n");
 }
 
 static void hns3_do_selftest(struct net_device *ndev, int (*st_param)[2],
 			     struct ethtool_test *eth_test, u64 *data)
 {
-	int test_index = 0;
+	int test_index = HNAE3_LOOP_APP;
 	u32 i;
 
-	for (i = 0; i < HNS3_SELF_TEST_TYPE_NUM; i++) {
+	for (i = HNAE3_LOOP_APP; i < HNAE3_LOOP_NONE; i++) {
 		enum hnae3_loop loop_type = (enum hnae3_loop)st_param[i][0];
 
 		if (!st_param[i][1])
@@ -401,6 +396,20 @@ static void hns3_do_selftest(struct net_device *ndev, int (*st_param)[2],
 	}
 }
 
+static void hns3_do_external_lb(struct net_device *ndev,
+				struct ethtool_test *eth_test, u64 *data)
+{
+	data[HNAE3_LOOP_EXTERNAL] = hns3_lp_up(ndev, HNAE3_LOOP_EXTERNAL);
+	if (!data[HNAE3_LOOP_EXTERNAL])
+		data[HNAE3_LOOP_EXTERNAL] = hns3_lp_run_test(ndev, HNAE3_LOOP_EXTERNAL);
+	hns3_lp_down(ndev, HNAE3_LOOP_EXTERNAL);
+
+	if (data[HNAE3_LOOP_EXTERNAL])
+		eth_test->flags |= ETH_TEST_FL_FAILED;
+
+	eth_test->flags |= ETH_TEST_FL_EXTERNAL_LB_DONE;
+}
+
 /**
  * hns3_self_test - self test
  * @ndev: net device
@@ -410,7 +419,9 @@ static void hns3_do_selftest(struct net_device *ndev, int (*st_param)[2],
 static void hns3_self_test(struct net_device *ndev,
 			   struct ethtool_test *eth_test, u64 *data)
 {
-	int st_param[HNS3_SELF_TEST_TYPE_NUM][2];
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+	int st_param[HNAE3_LOOP_NONE][2];
 	bool if_running = netif_running(ndev);
 
 	if (hns3_nic_resetting(ndev)) {
@@ -418,13 +429,29 @@ static void hns3_self_test(struct net_device *ndev,
 		return;
 	}
 
-	/* Only do offline selftest, or pass by default */
-	if (eth_test->flags != ETH_TEST_FL_OFFLINE)
+	if (!(eth_test->flags & ETH_TEST_FL_OFFLINE))
 		return;
 
-	hns3_selftest_prepare(ndev, if_running, st_param);
+	if (netif_msg_ifdown(h))
+		netdev_info(ndev, "self test start\n");
+
+	hns3_set_selftest_param(h, st_param);
+
+	/* external loopback test requires that the link is up and the duplex is
+	 * full, do external test first to reduce the whole test time
+	 */
+	if (eth_test->flags & ETH_TEST_FL_EXTERNAL_LB) {
+		hns3_external_lb_prepare(ndev, if_running);
+		hns3_do_external_lb(ndev, eth_test, data);
+		hns3_external_lb_restore(ndev, if_running);
+	}
+
+	hns3_selftest_prepare(ndev, if_running);
 	hns3_do_selftest(ndev, st_param, eth_test, data);
 	hns3_selftest_restore(ndev, if_running);
+
+	if (netif_msg_ifdown(h))
+		netdev_info(ndev, "self test end\n");
 }
 
 static void hns3_update_limit_promisc_mode(struct net_device *netdev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c760fed50da2..d7278d9a4939 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -149,10 +149,11 @@ static const u32 tqp_intr_reg_addr_list[] = {HCLGE_TQP_INTR_CTRL_REG,
 					     HCLGE_TQP_INTR_RL_REG};
 
 static const char hns3_nic_test_strs[][ETH_GSTRING_LEN] = {
-	"App    Loopback test",
-	"Serdes serial Loopback test",
-	"Serdes parallel Loopback test",
-	"Phy    Loopback test"
+	"External Loopback test",
+	"App      Loopback test",
+	"Serdes   serial Loopback test",
+	"Serdes   parallel Loopback test",
+	"Phy      Loopback test"
 };
 
 static const struct hclge_comm_stats_str g_mac_stats_string[] = {
@@ -718,7 +719,8 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 #define HCLGE_LOOPBACK_TEST_FLAGS (HNAE3_SUPPORT_APP_LOOPBACK | \
 		HNAE3_SUPPORT_PHY_LOOPBACK | \
 		HNAE3_SUPPORT_SERDES_SERIAL_LOOPBACK | \
-		HNAE3_SUPPORT_SERDES_PARALLEL_LOOPBACK)
+		HNAE3_SUPPORT_SERDES_PARALLEL_LOOPBACK | \
+		HNAE3_SUPPORT_EXTERNAL_LOOPBACK)
 
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
@@ -740,9 +742,12 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 			handle->flags |= HNAE3_SUPPORT_APP_LOOPBACK;
 		}
 
-		count += 2;
+		count += 1;
 		handle->flags |= HNAE3_SUPPORT_SERDES_SERIAL_LOOPBACK;
+		count += 1;
 		handle->flags |= HNAE3_SUPPORT_SERDES_PARALLEL_LOOPBACK;
+		count += 1;
+		handle->flags |= HNAE3_SUPPORT_EXTERNAL_LOOPBACK;
 
 		if ((hdev->hw.mac.phydev && hdev->hw.mac.phydev->drv &&
 		     hdev->hw.mac.phydev->drv->set_loopback) ||
@@ -773,6 +778,11 @@ static void hclge_get_strings(struct hnae3_handle *handle, u32 stringset,
 					   size, p);
 		p = hclge_comm_tqps_get_strings(handle, p);
 	} else if (stringset == ETH_SS_TEST) {
+		if (handle->flags & HNAE3_SUPPORT_EXTERNAL_LOOPBACK) {
+			memcpy(p, hns3_nic_test_strs[HNAE3_LOOP_EXTERNAL],
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
 		if (handle->flags & HNAE3_SUPPORT_APP_LOOPBACK) {
 			memcpy(p, hns3_nic_test_strs[HNAE3_LOOP_APP],
 			       ETH_GSTRING_LEN);
@@ -7901,7 +7911,7 @@ static int hclge_set_loopback(struct hnae3_handle *handle,
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
-	int ret;
+	int ret = 0;
 
 	/* Loopback can be enabled in three places: SSU, MAC, and serdes. By
 	 * default, SSU loopback is enabled, so if the SMAC and the DMAC are
@@ -7928,6 +7938,8 @@ static int hclge_set_loopback(struct hnae3_handle *handle,
 	case HNAE3_LOOP_PHY:
 		ret = hclge_set_phy_loopback(hdev, en);
 		break;
+	case HNAE3_LOOP_EXTERNAL:
+		break;
 	default:
 		ret = -ENOTSUPP;
 		dev_err(&hdev->pdev->dev,
-- 
2.33.0

