Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE6243E32C
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhJ1ONU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:13:20 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:26132 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbhJ1ONU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:13:20 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Hg6qN2QdLz1DHqq;
        Thu, 28 Oct 2021 22:08:48 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 22:10:45 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 22:10:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net] Revert "net: hns3: fix pause config problem after autoneg disabled"
Date:   Thu, 28 Oct 2021 22:06:24 +0800
Message-ID: <20211028140624.53149-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 3bda2e5df476417b6d08967e2d84234a59d57b1c.

According to discussion with Andrew as follow:
https://lore.kernel.org/netdev/09eda9fe-196b-006b-6f01-f54e75715961@huawei.com/

HNS3 driver needs to separate pause autoneg from general autoneg, so revert
this incorrect patch.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 -
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 33 +++++--------------
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 30 -----------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |  1 -
 5 files changed, 10 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index da3a593f6a56..d701451596c8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -568,7 +568,6 @@ struct hnae3_ae_ops {
 			       u32 *auto_neg, u32 *rx_en, u32 *tx_en);
 	int (*set_pauseparam)(struct hnae3_handle *handle,
 			      u32 auto_neg, u32 rx_en, u32 tx_en);
-	int (*restore_pauseparam)(struct hnae3_handle *handle);
 
 	int (*set_autoneg)(struct hnae3_handle *handle, bool enable);
 	int (*get_autoneg)(struct hnae3_handle *handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 7d92dd273ed7..5ebd96f6833d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -824,26 +824,6 @@ static int hns3_check_ksettings_param(const struct net_device *netdev,
 	return 0;
 }
 
-static int hns3_set_phy_link_ksettings(struct net_device *netdev,
-				       const struct ethtool_link_ksettings *cmd)
-{
-	struct hnae3_handle *handle = hns3_get_handle(netdev);
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
-	int ret;
-
-	if (cmd->base.speed == SPEED_1000 &&
-	    cmd->base.autoneg == AUTONEG_DISABLE)
-		return -EINVAL;
-
-	if (cmd->base.autoneg == AUTONEG_DISABLE && ops->restore_pauseparam) {
-		ret = ops->restore_pauseparam(handle);
-		if (ret)
-			return ret;
-	}
-
-	return phy_ethtool_ksettings_set(netdev->phydev, cmd);
-}
-
 static int hns3_set_link_ksettings(struct net_device *netdev,
 				   const struct ethtool_link_ksettings *cmd)
 {
@@ -862,11 +842,16 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 		  cmd->base.autoneg, cmd->base.speed, cmd->base.duplex);
 
 	/* Only support ksettings_set for netdev with phy attached for now */
-	if (netdev->phydev)
-		return hns3_set_phy_link_ksettings(netdev, cmd);
-	else if (test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps) &&
-		 ops->set_phy_link_ksettings)
+	if (netdev->phydev) {
+		if (cmd->base.speed == SPEED_1000 &&
+		    cmd->base.autoneg == AUTONEG_DISABLE)
+			return -EINVAL;
+
+		return phy_ethtool_ksettings_set(netdev->phydev, cmd);
+	} else if (test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps) &&
+		   ops->set_phy_link_ksettings) {
 		return ops->set_phy_link_ksettings(handle, cmd);
+	}
 
 	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 269e579762b2..d891390d492f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10998,35 +10998,6 @@ static int hclge_set_pauseparam(struct hnae3_handle *handle, u32 auto_neg,
 	return -EOPNOTSUPP;
 }
 
-static int hclge_restore_pauseparam(struct hnae3_handle *handle)
-{
-	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_dev *hdev = vport->back;
-	u32 auto_neg, rx_pause, tx_pause;
-	int ret;
-
-	hclge_get_pauseparam(handle, &auto_neg, &rx_pause, &tx_pause);
-	/* when autoneg is disabled, the pause setting of phy has no effect
-	 * unless the link goes down.
-	 */
-	ret = phy_suspend(hdev->hw.mac.phydev);
-	if (ret)
-		return ret;
-
-	phy_set_asym_pause(hdev->hw.mac.phydev, rx_pause, tx_pause);
-
-	ret = phy_resume(hdev->hw.mac.phydev);
-	if (ret)
-		return ret;
-
-	ret = hclge_mac_pause_setup_hw(hdev);
-	if (ret)
-		dev_err(&hdev->pdev->dev,
-			"restore pauseparam error, ret = %d.\n", ret);
-
-	return ret;
-}
-
 static void hclge_get_ksettings_an_result(struct hnae3_handle *handle,
 					  u8 *auto_neg, u32 *speed, u8 *duplex)
 {
@@ -12990,7 +12961,6 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.halt_autoneg = hclge_halt_autoneg,
 	.get_pauseparam = hclge_get_pauseparam,
 	.set_pauseparam = hclge_set_pauseparam,
-	.restore_pauseparam = hclge_restore_pauseparam,
 	.set_mtu = hclge_set_mtu,
 	.reset_queue = hclge_reset_tqp,
 	.get_stats = hclge_get_stats,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 124791e4bfee..95074e91a846 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1435,7 +1435,7 @@ static int hclge_bp_setup_hw(struct hclge_dev *hdev, u8 tc)
 	return 0;
 }
 
-int hclge_mac_pause_setup_hw(struct hclge_dev *hdev)
+static int hclge_mac_pause_setup_hw(struct hclge_dev *hdev)
 {
 	bool tx_en, rx_en;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 4b2c3a788980..2ee9b795f71d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -244,7 +244,6 @@ int hclge_tm_get_pri_weight(struct hclge_dev *hdev, u8 pri_id, u8 *weight);
 int hclge_tm_get_pri_shaper(struct hclge_dev *hdev, u8 pri_id,
 			    enum hclge_opcode_type cmd,
 			    struct hclge_tm_shaper_para *para);
-int hclge_mac_pause_setup_hw(struct hclge_dev *hdev);
 int hclge_tm_get_q_to_qs_map(struct hclge_dev *hdev, u16 q_id, u16 *qset_id);
 int hclge_tm_get_q_to_tc(struct hclge_dev *hdev, u16 q_id, u8 *tc_id);
 int hclge_tm_get_pg_to_pri_map(struct hclge_dev *hdev, u8 pg_id,
-- 
2.33.0

