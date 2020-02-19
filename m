Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C1C163947
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 02:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgBSBYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 20:24:13 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10213 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727794AbgBSBYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 20:24:13 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A8B2DA2DAFA8989017A0;
        Wed, 19 Feb 2020 09:24:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Wed, 19 Feb 2020 09:24:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/4] net: hns3: add support for dump MAC ID and loopback status in debugfs
Date:   Wed, 19 Feb 2020 09:23:32 +0800
Message-ID: <1582075413-34966-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582075413-34966-1-git-send-email-tanhuazhong@huawei.com>
References: <1582075413-34966-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The MAC ID and loopback status information are obtained from
the hardware, which will be helpful for debugging. This patch
adds support for these two items in debugfs.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 55 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  3 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 4 files changed, 60 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 1d4ffc5..345a84b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -260,6 +260,7 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump m7 info\n");
 	dev_info(&h->pdev->dev, "dump ncl_config <offset> <length>(in hex)\n");
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
+	dev_info(&h->pdev->dev, "dump loopback\n");
 
 	memset(printf_buf, 0, HNS3_DBG_BUF_LEN);
 	strncat(printf_buf, "dump reg [[bios common] [ssu <port_id>]",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 5e94b35..6295cf9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1171,6 +1171,57 @@ static void hclge_dbg_dump_ncl_config(struct hclge_dev *hdev,
 	}
 }
 
+static void hclge_dbg_dump_loopback(struct hclge_dev *hdev,
+				    const char *cmd_buf)
+{
+	struct phy_device *phydev = hdev->hw.mac.phydev;
+	struct hclge_config_mac_mode_cmd *req_app;
+	struct hclge_serdes_lb_cmd *req_serdes;
+	struct hclge_desc desc;
+	u8 loopback_en;
+	int ret;
+
+	req_app = (struct hclge_config_mac_mode_cmd *)desc.data;
+	req_serdes = (struct hclge_serdes_lb_cmd *)desc.data;
+
+	dev_info(&hdev->pdev->dev, "mac id: %u\n", hdev->hw.mac.mac_id);
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CONFIG_MAC_MODE, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump app loopback status, ret = %d\n", ret);
+		return;
+	}
+
+	loopback_en = hnae3_get_bit(le32_to_cpu(req_app->txrx_pad_fcs_loop_en),
+				    HCLGE_MAC_APP_LP_B);
+	dev_info(&hdev->pdev->dev, "app loopback: %s\n",
+		 loopback_en ? "on" : "off");
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_SERDES_LOOPBACK, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump serdes loopback status, ret = %d\n",
+			ret);
+		return;
+	}
+
+	loopback_en = req_serdes->enable & HCLGE_CMD_SERDES_SERIAL_INNER_LOOP_B;
+	dev_info(&hdev->pdev->dev, "serdes serial loopback: %s\n",
+		 loopback_en ? "on" : "off");
+
+	loopback_en = req_serdes->enable &
+			HCLGE_CMD_SERDES_PARALLEL_INNER_LOOP_B;
+	dev_info(&hdev->pdev->dev, "serdes parallel loopback: %s\n",
+		 loopback_en ? "on" : "off");
+
+	if (phydev)
+		dev_info(&hdev->pdev->dev, "phy loopback: %s\n",
+			 phydev->loopback_enabled ? "on" : "off");
+}
+
 /* hclge_dbg_dump_mac_tnl_status: print message about mac tnl interrupt
  * @hdev: pointer to struct hclge_dev
  */
@@ -1271,6 +1322,7 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 {
 #define DUMP_REG	"dump reg"
 #define DUMP_TM_MAP	"dump tm map"
+#define DUMP_LOOPBACK	"dump loopback"
 
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
@@ -1304,6 +1356,9 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 					  &cmd_buf[sizeof("dump ncl_config")]);
 	} else if (strncmp(cmd_buf, "dump mac tnl status", 19) == 0) {
 		hclge_dbg_dump_mac_tnl_status(hdev);
+	} else if (strncmp(cmd_buf, DUMP_LOOPBACK,
+		   strlen(DUMP_LOOPBACK)) == 0) {
+		hclge_dbg_dump_loopback(hdev, &cmd_buf[sizeof(DUMP_LOOPBACK)]);
 	} else if (strncmp(cmd_buf, "dump qs shaper", 14) == 0) {
 		hclge_dbg_dump_qs_shaper(hdev,
 					 &cmd_buf[sizeof("dump qs shaper")]);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 492bc94..51399db 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -824,6 +824,8 @@ static void hclge_get_mac_stat(struct hnae3_handle *handle,
 static int hclge_parse_func_status(struct hclge_dev *hdev,
 				   struct hclge_func_status_cmd *status)
 {
+#define HCLGE_MAC_ID_MASK	0xF
+
 	if (!(status->pf_state & HCLGE_PF_STATE_DONE))
 		return -EINVAL;
 
@@ -833,6 +835,7 @@ static int hclge_parse_func_status(struct hclge_dev *hdev,
 	else
 		hdev->flag &= ~HCLGE_FLAG_MAIN;
 
+	hdev->hw.mac.mac_id = status->mac_id & HCLGE_MAC_ID_MASK;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index f78cbb4c..71df23d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -249,6 +249,7 @@ enum HCLGE_MAC_DUPLEX {
 #define QUERY_ACTIVE_SPEED	1
 
 struct hclge_mac {
+	u8 mac_id;
 	u8 phy_addr;
 	u8 flag;
 	u8 media_type;	/* port media type, e.g. fibre/copper/backplane */
-- 
2.7.4

