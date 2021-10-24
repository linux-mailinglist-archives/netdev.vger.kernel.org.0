Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3029243880D
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 11:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhJXJsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 05:48:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29930 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhJXJr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 05:47:58 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HcY4C7485zbmhX;
        Sun, 24 Oct 2021 17:40:59 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 6/8] net: hns3: add update ethtool advertised link modes for FIBRE port when autoneg off
Date:   Sun, 24 Oct 2021 17:41:13 +0800
Message-ID: <20211024094115.42158-7-huangguangbin2@huawei.com>
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

Currently, the ethtool advertised link modes of FIBRE port is cleared to
zero when autoneg is off, so user can not get the advertised link modes
info directly from "ethtool <dev>" command.

In order to ameliorate this situation, update data of speeds, fec and pause
of advertised link modes when autoneg is off.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 78 ++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4159c27b99cb..f1db6699f81f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3051,6 +3051,82 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 	clear_bit(HCLGE_STATE_LINK_UPDATING, &hdev->state);
 }
 
+static void hclge_update_speed_advertising(struct hclge_mac *mac)
+{
+	u32 speed_ability;
+
+	if (hclge_get_speed_bit(mac->speed, &speed_ability))
+		return;
+
+	switch (mac->module_type) {
+	case HNAE3_MODULE_TYPE_FIBRE_LR:
+		hclge_convert_setting_lr(speed_ability, mac->advertising);
+		break;
+	case HNAE3_MODULE_TYPE_FIBRE_SR:
+	case HNAE3_MODULE_TYPE_AOC:
+		hclge_convert_setting_sr(speed_ability, mac->advertising);
+		break;
+	case HNAE3_MODULE_TYPE_CR:
+		hclge_convert_setting_cr(speed_ability, mac->advertising);
+		break;
+	case HNAE3_MODULE_TYPE_KR:
+		hclge_convert_setting_kr(speed_ability, mac->advertising);
+		break;
+	default:
+		break;
+	}
+}
+
+static void hclge_update_fec_advertising(struct hclge_mac *mac)
+{
+	if (mac->fec_mode & BIT(HNAE3_FEC_RS))
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT,
+				 mac->advertising);
+	else if (mac->fec_mode & BIT(HNAE3_FEC_BASER))
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT,
+				 mac->advertising);
+	else
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT,
+				 mac->advertising);
+}
+
+static void hclge_update_pause_advertising(struct hclge_dev *hdev)
+{
+	struct hclge_mac *mac = &hdev->hw.mac;
+	bool rx_en, tx_en;
+
+	switch (hdev->fc_mode_last_time) {
+	case HCLGE_FC_RX_PAUSE:
+		rx_en = true;
+		tx_en = false;
+		break;
+	case HCLGE_FC_TX_PAUSE:
+		rx_en = false;
+		tx_en = true;
+		break;
+	case HCLGE_FC_FULL:
+		rx_en = true;
+		tx_en = true;
+		break;
+	default:
+		rx_en = false;
+		tx_en = false;
+		break;
+	}
+
+	linkmode_set_pause(mac->advertising, tx_en, rx_en);
+}
+
+static void hclge_update_advertising(struct hclge_dev *hdev)
+{
+	struct hclge_mac *mac = &hdev->hw.mac;
+
+	linkmode_zero(mac->advertising);
+	hclge_update_speed_advertising(mac);
+	hclge_update_fec_advertising(mac);
+	hclge_update_pause_advertising(hdev);
+}
+
 static void hclge_update_port_capability(struct hclge_dev *hdev,
 					 struct hclge_mac *mac)
 {
@@ -3073,7 +3149,7 @@ static void hclge_update_port_capability(struct hclge_dev *hdev,
 	} else {
 		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
 				   mac->supported);
-		linkmode_zero(mac->advertising);
+		hclge_update_advertising(hdev);
 	}
 }
 
-- 
2.33.0

