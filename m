Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0CA6A04EA
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfH1O0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:26:35 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50132 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726861AbfH1OZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:44 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 24F303983C9A7CD764BC;
        Wed, 28 Aug 2019 22:25:41 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:32 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 10/12] net: hns3: add phy selftest function
Date:   Wed, 28 Aug 2019 22:23:14 +0800
Message-ID: <1567002196-63242-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
References: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Currently, the loopback test supports only mac selftest and serdes
selftest. This patch adds phy selftest.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   7 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 150 ++++++++++++++++++---
 2 files changed, 138 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 0332d6f..e219bb1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -59,7 +59,7 @@ static const struct hns3_stats hns3_rxq_stats[] = {
 
 #define HNS3_TQP_STATS_COUNT (HNS3_TXQ_STATS_COUNT + HNS3_RXQ_STATS_COUNT)
 
-#define HNS3_SELF_TEST_TYPE_NUM         3
+#define HNS3_SELF_TEST_TYPE_NUM         4
 #define HNS3_NIC_LB_TEST_PKT_NUM	1
 #define HNS3_NIC_LB_TEST_RING_ID	0
 #define HNS3_NIC_LB_TEST_PACKET_SIZE	128
@@ -89,6 +89,7 @@ static int hns3_lp_setup(struct net_device *ndev, enum hnae3_loop loop, bool en)
 	case HNAE3_LOOP_SERIAL_SERDES:
 	case HNAE3_LOOP_PARALLEL_SERDES:
 	case HNAE3_LOOP_APP:
+	case HNAE3_LOOP_PHY:
 		ret = h->ae_algo->ops->set_loopback(h, loop, en);
 		break;
 	default:
@@ -330,6 +331,10 @@ static void hns3_self_test(struct net_device *ndev,
 	st_param[HNAE3_LOOP_PARALLEL_SERDES][1] =
 			h->flags & HNAE3_SUPPORT_SERDES_PARALLEL_LOOPBACK;
 
+	st_param[HNAE3_LOOP_PHY][0] = HNAE3_LOOP_PHY;
+	st_param[HNAE3_LOOP_PHY][1] =
+			h->flags & HNAE3_SUPPORT_PHY_LOOPBACK;
+
 	if (if_running)
 		ndev->netdev_ops->ndo_stop(ndev);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9ef1f468..428f7c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -53,6 +53,8 @@
 #define HCLGE_DFX_TQP_BD_OFFSET         11
 #define HCLGE_DFX_SSU_2_BD_OFFSET       12
 
+#define HCLGE_LINK_STATUS_MS	10
+
 static int hclge_set_mac_mtu(struct hclge_dev *hdev, int new_mps);
 static int hclge_init_vlan_config(struct hclge_dev *hdev);
 static void hclge_sync_vlan_filter(struct hclge_dev *hdev);
@@ -742,6 +744,12 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 		count += 2;
 		handle->flags |= HNAE3_SUPPORT_SERDES_SERIAL_LOOPBACK;
 		handle->flags |= HNAE3_SUPPORT_SERDES_PARALLEL_LOOPBACK;
+
+		if (hdev->hw.mac.phydev) {
+			count += 1;
+			handle->flags |= HNAE3_SUPPORT_PHY_LOOPBACK;
+		}
+
 	} else if (stringset == ETH_SS_STATS) {
 		count = ARRAY_SIZE(g_mac_stats_string) +
 			hclge_tqps_get_sset_count(handle, stringset);
@@ -6204,6 +6212,65 @@ static void hclge_cfg_mac_mode(struct hclge_dev *hdev, bool enable)
 			"mac enable fail, ret =%d.\n", ret);
 }
 
+static void hclge_phy_link_status_wait(struct hclge_dev *hdev,
+				       int link_ret)
+{
+#define HCLGE_PHY_LINK_STATUS_NUM  200
+
+	struct phy_device *phydev = hdev->hw.mac.phydev;
+	int i = 0;
+	int ret;
+
+	do {
+		ret = phy_read_status(phydev);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"phy update link status fail, ret = %d\n", ret);
+			return;
+		}
+
+		if (phydev->link == link_ret)
+			break;
+
+		msleep(HCLGE_LINK_STATUS_MS);
+	} while (++i < HCLGE_PHY_LINK_STATUS_NUM);
+}
+
+static int hclge_mac_link_status_wait(struct hclge_dev *hdev, int link_ret)
+{
+#define HCLGE_MAC_LINK_STATUS_NUM  100
+
+	int i = 0;
+	int ret;
+
+	do {
+		ret = hclge_get_mac_link_status(hdev);
+		if (ret < 0)
+			return ret;
+		else if (ret == link_ret)
+			return 0;
+
+		msleep(HCLGE_LINK_STATUS_MS);
+	} while (++i < HCLGE_MAC_LINK_STATUS_NUM);
+	return -EBUSY;
+}
+
+static int hclge_mac_phy_link_status_wait(struct hclge_dev *hdev, bool en,
+					  bool is_phy)
+{
+#define HCLGE_LINK_STATUS_DOWN 0
+#define HCLGE_LINK_STATUS_UP   1
+
+	int link_ret;
+
+	link_ret = en ? HCLGE_LINK_STATUS_UP : HCLGE_LINK_STATUS_DOWN;
+
+	if (is_phy)
+		hclge_phy_link_status_wait(hdev, link_ret);
+
+	return hclge_mac_link_status_wait(hdev, link_ret);
+}
+
 static int hclge_set_app_loopback(struct hclge_dev *hdev, bool en)
 {
 	struct hclge_config_mac_mode_cmd *req;
@@ -6246,14 +6313,8 @@ static int hclge_set_serdes_loopback(struct hclge_dev *hdev, bool en,
 #define HCLGE_SERDES_RETRY_MS	10
 #define HCLGE_SERDES_RETRY_NUM	100
 
-#define HCLGE_MAC_LINK_STATUS_MS   10
-#define HCLGE_MAC_LINK_STATUS_NUM  100
-#define HCLGE_MAC_LINK_STATUS_DOWN 0
-#define HCLGE_MAC_LINK_STATUS_UP   1
-
 	struct hclge_serdes_lb_cmd *req;
 	struct hclge_desc desc;
-	int mac_link_ret = 0;
 	int ret, i = 0;
 	u8 loop_mode_b;
 
@@ -6276,10 +6337,8 @@ static int hclge_set_serdes_loopback(struct hclge_dev *hdev, bool en,
 	if (en) {
 		req->enable = loop_mode_b;
 		req->mask = loop_mode_b;
-		mac_link_ret = HCLGE_MAC_LINK_STATUS_UP;
 	} else {
 		req->mask = loop_mode_b;
-		mac_link_ret = HCLGE_MAC_LINK_STATUS_DOWN;
 	}
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -6312,18 +6371,70 @@ static int hclge_set_serdes_loopback(struct hclge_dev *hdev, bool en,
 
 	hclge_cfg_mac_mode(hdev, en);
 
-	i = 0;
-	do {
-		/* serdes Internal loopback, independent of the network cable.*/
-		msleep(HCLGE_MAC_LINK_STATUS_MS);
-		ret = hclge_get_mac_link_status(hdev);
-		if (ret == mac_link_ret)
-			return 0;
-	} while (++i < HCLGE_MAC_LINK_STATUS_NUM);
+	ret = hclge_mac_phy_link_status_wait(hdev, en, FALSE);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"serdes loopback config mac mode timeout\n");
+
+	return ret;
+}
 
-	dev_err(&hdev->pdev->dev, "config mac mode timeout\n");
+static int hclge_enable_phy_loopback(struct hclge_dev *hdev,
+				     struct phy_device *phydev)
+{
+	int ret;
 
-	return -EBUSY;
+	if (!phydev->suspended) {
+		ret = phy_suspend(phydev);
+		if (ret)
+			return ret;
+	}
+
+	ret = phy_resume(phydev);
+	if (ret)
+		return ret;
+
+	return phy_loopback(phydev, true);
+}
+
+static int hclge_disable_phy_loopback(struct hclge_dev *hdev,
+				      struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_loopback(phydev, false);
+	if (ret)
+		return ret;
+
+	return phy_suspend(phydev);
+}
+
+static int hclge_set_phy_loopback(struct hclge_dev *hdev, bool en)
+{
+	struct phy_device *phydev = hdev->hw.mac.phydev;
+	int ret;
+
+	if (!phydev)
+		return -ENOTSUPP;
+
+	if (en)
+		ret = hclge_enable_phy_loopback(hdev, phydev);
+	else
+		ret = hclge_disable_phy_loopback(hdev, phydev);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"set phy loopback fail, ret = %d\n", ret);
+		return ret;
+	}
+
+	hclge_cfg_mac_mode(hdev, en);
+
+	ret = hclge_mac_phy_link_status_wait(hdev, en, TRUE);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"phy loopback config mac mode timeout\n");
+
+	return ret;
 }
 
 static int hclge_tqp_enable(struct hclge_dev *hdev, unsigned int tqp_id,
@@ -6363,6 +6474,9 @@ static int hclge_set_loopback(struct hnae3_handle *handle,
 	case HNAE3_LOOP_PARALLEL_SERDES:
 		ret = hclge_set_serdes_loopback(hdev, en, loop_mode);
 		break;
+	case HNAE3_LOOP_PHY:
+		ret = hclge_set_phy_loopback(hdev, en);
+		break;
 	default:
 		ret = -ENOTSUPP;
 		dev_err(&hdev->pdev->dev,
-- 
2.7.4

