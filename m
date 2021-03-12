Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E6E3387E7
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 09:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhCLIu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 03:50:28 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13154 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhCLItv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 03:49:51 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DxfZr4nkMzmWY1;
        Fri, 12 Mar 2021 16:47:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Mar 2021 16:49:40 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/4] net: hns3: add phy loopback support for imp-controlled PHYs
Date:   Fri, 12 Mar 2021 16:50:16 +0800
Message-ID: <1615539016-45698-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615539016-45698-1-git-send-email-tanhuazhong@huawei.com>
References: <1615539016-45698-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

If the imp-controlled PHYs feature is enabled, driver can not
call phy driver interface to set loopback anymore and needs
to send command to firmware to start phy loopback.

Driver reuses the existing firmware command 0x0315 to start
phy loopback, just add a setting bit in this command. As this
command is not only for serdes loopback anymore, rename this
command to "xxx_COMMON_LOOPBACK", and modify function name,
macro name and logs related to it.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  9 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 20 +++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 58 ++++++++++++----------
 3 files changed, 51 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index abeacc9..804f4c8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -127,7 +127,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_QUERY_MAC_TNL_INT	= 0x0310,
 	HCLGE_OPC_MAC_TNL_INT_EN	= 0x0311,
 	HCLGE_OPC_CLEAR_MAC_TNL_INT	= 0x0312,
-	HCLGE_OPC_SERDES_LOOPBACK       = 0x0315,
+	HCLGE_OPC_COMMON_LOOPBACK       = 0x0315,
 	HCLGE_OPC_CONFIG_FEC_MODE	= 0x031A,
 
 	/* PFC/Pause commands */
@@ -964,9 +964,10 @@ struct hclge_pf_rst_done_cmd {
 
 #define HCLGE_CMD_SERDES_SERIAL_INNER_LOOP_B	BIT(0)
 #define HCLGE_CMD_SERDES_PARALLEL_INNER_LOOP_B	BIT(2)
-#define HCLGE_CMD_SERDES_DONE_B			BIT(0)
-#define HCLGE_CMD_SERDES_SUCCESS_B		BIT(1)
-struct hclge_serdes_lb_cmd {
+#define HCLGE_CMD_GE_PHY_INNER_LOOP_B		BIT(3)
+#define HCLGE_CMD_COMMON_LB_DONE_B		BIT(0)
+#define HCLGE_CMD_COMMON_LB_SUCCESS_B		BIT(1)
+struct hclge_common_lb_cmd {
 	u8 mask;
 	u8 enable;
 	u8 result;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 6b1d197..1c69913 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1546,13 +1546,13 @@ static void hclge_dbg_dump_loopback(struct hclge_dev *hdev,
 {
 	struct phy_device *phydev = hdev->hw.mac.phydev;
 	struct hclge_config_mac_mode_cmd *req_app;
-	struct hclge_serdes_lb_cmd *req_serdes;
+	struct hclge_common_lb_cmd *req_common;
 	struct hclge_desc desc;
 	u8 loopback_en;
 	int ret;
 
 	req_app = (struct hclge_config_mac_mode_cmd *)desc.data;
-	req_serdes = (struct hclge_serdes_lb_cmd *)desc.data;
+	req_common = (struct hclge_common_lb_cmd *)desc.data;
 
 	dev_info(&hdev->pdev->dev, "mac id: %u\n", hdev->hw.mac.mac_id);
 
@@ -1569,27 +1569,33 @@ static void hclge_dbg_dump_loopback(struct hclge_dev *hdev,
 	dev_info(&hdev->pdev->dev, "app loopback: %s\n",
 		 loopback_en ? "on" : "off");
 
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_SERDES_LOOPBACK, true);
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_COMMON_LOOPBACK, true);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"failed to dump serdes loopback status, ret = %d\n",
+			"failed to dump common loopback status, ret = %d\n",
 			ret);
 		return;
 	}
 
-	loopback_en = req_serdes->enable & HCLGE_CMD_SERDES_SERIAL_INNER_LOOP_B;
+	loopback_en = req_common->enable & HCLGE_CMD_SERDES_SERIAL_INNER_LOOP_B;
 	dev_info(&hdev->pdev->dev, "serdes serial loopback: %s\n",
 		 loopback_en ? "on" : "off");
 
-	loopback_en = req_serdes->enable &
+	loopback_en = req_common->enable &
 			HCLGE_CMD_SERDES_PARALLEL_INNER_LOOP_B;
 	dev_info(&hdev->pdev->dev, "serdes parallel loopback: %s\n",
 		 loopback_en ? "on" : "off");
 
-	if (phydev)
+	if (phydev) {
 		dev_info(&hdev->pdev->dev, "phy loopback: %s\n",
 			 phydev->loopback_enabled ? "on" : "off");
+	} else if (hnae3_dev_phy_imp_supported(hdev)) {
+		loopback_en = req_common->enable &
+			      HCLGE_CMD_GE_PHY_INNER_LOOP_B;
+		dev_info(&hdev->pdev->dev, "phy loopback: %s\n",
+			 loopback_en ? "on" : "off");
+	}
 }
 
 /* hclge_dbg_dump_mac_tnl_status: print message about mac tnl interrupt
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index adc2ec7..a664383 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -751,8 +751,9 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 		handle->flags |= HNAE3_SUPPORT_SERDES_SERIAL_LOOPBACK;
 		handle->flags |= HNAE3_SUPPORT_SERDES_PARALLEL_LOOPBACK;
 
-		if (hdev->hw.mac.phydev && hdev->hw.mac.phydev->drv &&
-		    hdev->hw.mac.phydev->drv->set_loopback) {
+		if ((hdev->hw.mac.phydev && hdev->hw.mac.phydev->drv &&
+		     hdev->hw.mac.phydev->drv->set_loopback) ||
+		    hnae3_dev_phy_imp_supported(hdev)) {
 			count += 1;
 			handle->flags |= HNAE3_SUPPORT_PHY_LOOPBACK;
 		}
@@ -7270,19 +7271,19 @@ static int hclge_set_app_loopback(struct hclge_dev *hdev, bool en)
 	return ret;
 }
 
-static int hclge_cfg_serdes_loopback(struct hclge_dev *hdev, bool en,
+static int hclge_cfg_common_loopback(struct hclge_dev *hdev, bool en,
 				     enum hnae3_loop loop_mode)
 {
-#define HCLGE_SERDES_RETRY_MS	10
-#define HCLGE_SERDES_RETRY_NUM	100
+#define HCLGE_COMMON_LB_RETRY_MS	10
+#define HCLGE_COMMON_LB_RETRY_NUM	100
 
-	struct hclge_serdes_lb_cmd *req;
+	struct hclge_common_lb_cmd *req;
 	struct hclge_desc desc;
 	int ret, i = 0;
 	u8 loop_mode_b;
 
-	req = (struct hclge_serdes_lb_cmd *)desc.data;
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_SERDES_LOOPBACK, false);
+	req = (struct hclge_common_lb_cmd *)desc.data;
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_COMMON_LOOPBACK, false);
 
 	switch (loop_mode) {
 	case HNAE3_LOOP_SERIAL_SERDES:
@@ -7291,9 +7292,12 @@ static int hclge_cfg_serdes_loopback(struct hclge_dev *hdev, bool en,
 	case HNAE3_LOOP_PARALLEL_SERDES:
 		loop_mode_b = HCLGE_CMD_SERDES_PARALLEL_INNER_LOOP_B;
 		break;
+	case HNAE3_LOOP_PHY:
+		loop_mode_b = HCLGE_CMD_GE_PHY_INNER_LOOP_B;
+		break;
 	default:
 		dev_err(&hdev->pdev->dev,
-			"unsupported serdes loopback mode %d\n", loop_mode);
+			"unsupported common loopback mode %d\n", loop_mode);
 		return -ENOTSUPP;
 	}
 
@@ -7307,39 +7311,39 @@ static int hclge_cfg_serdes_loopback(struct hclge_dev *hdev, bool en,
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"serdes loopback set fail, ret = %d\n", ret);
+			"common loopback set fail, ret = %d\n", ret);
 		return ret;
 	}
 
 	do {
-		msleep(HCLGE_SERDES_RETRY_MS);
-		hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_SERDES_LOOPBACK,
+		msleep(HCLGE_COMMON_LB_RETRY_MS);
+		hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_COMMON_LOOPBACK,
 					   true);
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
-				"serdes loopback get, ret = %d\n", ret);
+				"common loopback get, ret = %d\n", ret);
 			return ret;
 		}
-	} while (++i < HCLGE_SERDES_RETRY_NUM &&
-		 !(req->result & HCLGE_CMD_SERDES_DONE_B));
+	} while (++i < HCLGE_COMMON_LB_RETRY_NUM &&
+		 !(req->result & HCLGE_CMD_COMMON_LB_DONE_B));
 
-	if (!(req->result & HCLGE_CMD_SERDES_DONE_B)) {
-		dev_err(&hdev->pdev->dev, "serdes loopback set timeout\n");
+	if (!(req->result & HCLGE_CMD_COMMON_LB_DONE_B)) {
+		dev_err(&hdev->pdev->dev, "common loopback set timeout\n");
 		return -EBUSY;
-	} else if (!(req->result & HCLGE_CMD_SERDES_SUCCESS_B)) {
-		dev_err(&hdev->pdev->dev, "serdes loopback set failed in fw\n");
+	} else if (!(req->result & HCLGE_CMD_COMMON_LB_SUCCESS_B)) {
+		dev_err(&hdev->pdev->dev, "common loopback set failed in fw\n");
 		return -EIO;
 	}
 	return ret;
 }
 
-static int hclge_set_serdes_loopback(struct hclge_dev *hdev, bool en,
+static int hclge_set_common_loopback(struct hclge_dev *hdev, bool en,
 				     enum hnae3_loop loop_mode)
 {
 	int ret;
 
-	ret = hclge_cfg_serdes_loopback(hdev, en, loop_mode);
+	ret = hclge_cfg_common_loopback(hdev, en, loop_mode);
 	if (ret)
 		return ret;
 
@@ -7388,8 +7392,12 @@ static int hclge_set_phy_loopback(struct hclge_dev *hdev, bool en)
 	struct phy_device *phydev = hdev->hw.mac.phydev;
 	int ret;
 
-	if (!phydev)
+	if (!phydev) {
+		if (hnae3_dev_phy_imp_supported(hdev))
+			return hclge_set_common_loopback(hdev, en,
+							 HNAE3_LOOP_PHY);
 		return -ENOTSUPP;
+	}
 
 	if (en)
 		ret = hclge_enable_phy_loopback(hdev, phydev);
@@ -7460,7 +7468,7 @@ static int hclge_set_loopback(struct hnae3_handle *handle,
 		break;
 	case HNAE3_LOOP_SERIAL_SERDES:
 	case HNAE3_LOOP_PARALLEL_SERDES:
-		ret = hclge_set_serdes_loopback(hdev, en, loop_mode);
+		ret = hclge_set_common_loopback(hdev, en, loop_mode);
 		break;
 	case HNAE3_LOOP_PHY:
 		ret = hclge_set_phy_loopback(hdev, en);
@@ -7493,11 +7501,11 @@ static int hclge_set_default_loopback(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
-	ret = hclge_cfg_serdes_loopback(hdev, false, HNAE3_LOOP_SERIAL_SERDES);
+	ret = hclge_cfg_common_loopback(hdev, false, HNAE3_LOOP_SERIAL_SERDES);
 	if (ret)
 		return ret;
 
-	return hclge_cfg_serdes_loopback(hdev, false,
+	return hclge_cfg_common_loopback(hdev, false,
 					 HNAE3_LOOP_PARALLEL_SERDES);
 }
 
-- 
2.7.4

