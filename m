Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DFD336A13
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 03:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhCKCOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 21:14:15 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13906 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhCKCNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 21:13:50 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DwssK2ZpszkXPV;
        Thu, 11 Mar 2021 10:12:21 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 10:13:39 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/2] net: hns3: use pause capability queried from firmware
Date:   Thu, 11 Mar 2021 10:14:12 +0800
Message-ID: <1615428852-2637-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615428852-2637-1-git-send-email-tanhuazhong@huawei.com>
References: <1615428852-2637-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

For maintainability and compatibility, add support to use pause
capability queried from firmware, and add debugfs support to dump
this capability.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             |  4 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c      |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c      |  8 ++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c  |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 16 ++++++++++++----
 6 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e9e60a9..9e9076f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -90,6 +90,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_HW_PAD_B,
 	HNAE3_DEV_SUPPORT_STASH_B,
 	HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B,
+	HNAE3_DEV_SUPPORT_PAUSE_B,
 };
 
 #define hnae3_dev_fd_supported(hdev) \
@@ -134,6 +135,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_dev_stash_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_STASH_B, (hdev)->ae_dev->caps)
 
+#define hnae3_dev_pause_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_PAUSE_B, (hdev)->ae_dev->caps)
+
 #define hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, (ae_dev)->caps)
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index dd11c57..ded92ea 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -362,6 +362,9 @@ static void hns3_dbg_dev_caps(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "support UDP tunnel csum: %s\n",
 		 test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, caps) ?
 		 "yes" : "no");
+	dev_info(&h->pdev->dev, "support PAUSE: %s\n",
+		 test_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps) ?
+		 "yes" : "no");
 }
 
 static void hns3_dbg_dev_specs(struct hnae3_handle *h)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index adcec4e..28afb27 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -642,6 +642,10 @@ static void hns3_get_pauseparam(struct net_device *netdev,
 				struct ethtool_pauseparam *param)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
+
+	if (!test_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps))
+		return;
 
 	if (h->ae_algo->ops->get_pauseparam)
 		h->ae_algo->ops->get_pauseparam(h, &param->autoneg,
@@ -652,6 +656,10 @@ static int hns3_set_pauseparam(struct net_device *netdev,
 			       struct ethtool_pauseparam *param)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
+
+	if (!test_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps))
+		return -EOPNOTSUPP;
 
 	netif_dbg(h, drv, netdev,
 		  "set pauseparam: autoneg=%u, rx:%u, tx:%u\n",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 02419bb..1c90c6b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -355,6 +355,7 @@ static void hclge_set_default_capability(struct hclge_dev *hdev)
 	set_bit(HNAE3_DEV_SUPPORT_GRO_B, ae_dev->caps);
 	if (hdev->ae_dev->dev_version == HNAE3_DEVICE_VERSION_V2) {
 		set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
+		set_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps);
 	}
 }
 
@@ -382,6 +383,8 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_FEC_B))
 		set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_PAUSE_B))
+		set_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps);
 }
 
 static __le32 hclge_build_api_caps(void)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index e8480ff..774a9ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -385,6 +385,7 @@ enum HCLGE_CAP_BITS {
 	HCLGE_CAP_STASH_B,
 	HCLGE_CAP_UDP_TUNNEL_CSUM_B,
 	HCLGE_CAP_FEC_B = 13,
+	HCLGE_CAP_PAUSE_B = 14,
 };
 
 enum HCLGE_API_CAP_BITS {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0e0a16c..26269d6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1150,8 +1150,10 @@ static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
 	if (hnae3_dev_fec_supported(hdev))
 		hclge_convert_setting_fec(mac);
 
+	if (hnae3_dev_pause_supported(hdev))
+		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, mac->supported);
+
 	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, mac->supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, mac->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT, mac->supported);
 }
 
@@ -1163,8 +1165,11 @@ static void hclge_parse_backplane_link_mode(struct hclge_dev *hdev,
 	hclge_convert_setting_kr(mac, speed_ability);
 	if (hnae3_dev_fec_supported(hdev))
 		hclge_convert_setting_fec(mac);
+
+	if (hnae3_dev_pause_supported(hdev))
+		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, mac->supported);
+
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Backplane_BIT, mac->supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, mac->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT, mac->supported);
 }
 
@@ -1193,10 +1198,13 @@ static void hclge_parse_copper_link_mode(struct hclge_dev *hdev,
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, supported);
 	}
 
+	if (hnae3_dev_pause_supported(hdev)) {
+		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, supported);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, supported);
+	}
+
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_TP_BIT, supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, supported);
 }
 
 static void hclge_parse_link_mode(struct hclge_dev *hdev, u16 speed_ability)
-- 
2.7.4

