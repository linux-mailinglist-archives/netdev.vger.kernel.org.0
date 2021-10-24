Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2519438809
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 11:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhJXJsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 05:48:01 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13972 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbhJXJr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 05:47:58 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HcY7N0qgszZcF6;
        Sun, 24 Oct 2021 17:43:44 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 5/8] net: hns3: modify functions of converting speed ability to ethtool link mode
Date:   Sun, 24 Oct 2021 17:41:12 +0800
Message-ID: <20211024094115.42158-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024094115.42158-1-huangguangbin2@huawei.com>
References: <20211024094115.42158-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions of converting speed ability to ethtool link mode just
support setting mac->supported currently, to reuse these functions to
set ethtool link mode for others(i.e. advertising), delete the argument
mac and add argument link_mode.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 70 ++++++++++---------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b79e36144647..4159c27b99cb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1093,96 +1093,100 @@ static int hclge_check_port_speed(struct hnae3_handle *handle, u32 speed)
 	return -EINVAL;
 }
 
-static void hclge_convert_setting_sr(struct hclge_mac *mac, u16 speed_ability)
+static void hclge_convert_setting_sr(u16 speed_ability,
+				     unsigned long *link_mode)
 {
 	if (speed_ability & HCLGE_SUPPORT_10G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_25G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_40G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_50G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_100G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_200G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_200000baseSR4_Full_BIT,
-				 mac->supported);
+				 link_mode);
 }
 
-static void hclge_convert_setting_lr(struct hclge_mac *mac, u16 speed_ability)
+static void hclge_convert_setting_lr(u16 speed_ability,
+				     unsigned long *link_mode)
 {
 	if (speed_ability & HCLGE_SUPPORT_10G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_25G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_50G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_40G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_100G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_200G_BIT)
 		linkmode_set_bit(
 			ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT,
-			mac->supported);
+			link_mode);
 }
 
-static void hclge_convert_setting_cr(struct hclge_mac *mac, u16 speed_ability)
+static void hclge_convert_setting_cr(u16 speed_ability,
+				     unsigned long *link_mode)
 {
 	if (speed_ability & HCLGE_SUPPORT_10G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_25G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_40G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_50G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_100G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_200G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
-				 mac->supported);
+				 link_mode);
 }
 
-static void hclge_convert_setting_kr(struct hclge_mac *mac, u16 speed_ability)
+static void hclge_convert_setting_kr(u16 speed_ability,
+				     unsigned long *link_mode)
 {
 	if (speed_ability & HCLGE_SUPPORT_1G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_10G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_25G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_40G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_50G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_100G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
-				 mac->supported);
+				 link_mode);
 	if (speed_ability & HCLGE_SUPPORT_200G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_200000baseKR4_Full_BIT,
-				 mac->supported);
+				 link_mode);
 }
 
 static void hclge_convert_setting_fec(struct hclge_mac *mac)
@@ -1226,9 +1230,9 @@ static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
 		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
 				 mac->supported);
 
-	hclge_convert_setting_sr(mac, speed_ability);
-	hclge_convert_setting_lr(mac, speed_ability);
-	hclge_convert_setting_cr(mac, speed_ability);
+	hclge_convert_setting_sr(speed_ability, mac->supported);
+	hclge_convert_setting_lr(speed_ability, mac->supported);
+	hclge_convert_setting_cr(speed_ability, mac->supported);
 	if (hnae3_dev_fec_supported(hdev))
 		hclge_convert_setting_fec(mac);
 
@@ -1244,7 +1248,7 @@ static void hclge_parse_backplane_link_mode(struct hclge_dev *hdev,
 {
 	struct hclge_mac *mac = &hdev->hw.mac;
 
-	hclge_convert_setting_kr(mac, speed_ability);
+	hclge_convert_setting_kr(speed_ability, mac->supported);
 	if (hnae3_dev_fec_supported(hdev))
 		hclge_convert_setting_fec(mac);
 
-- 
2.33.0

