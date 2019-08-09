Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0025286FB9
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 04:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405520AbfHICei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 22:34:38 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58882 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403994AbfHICde (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 22:33:34 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F0DC0BA11ED27F493A5C;
        Fri,  9 Aug 2019 10:33:31 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 9 Aug 2019 10:33:25 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/12] net: hns3: add handshake with VF for PF reset
Date:   Fri, 9 Aug 2019 10:31:17 +0800
Message-ID: <1565317878-31806-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
References: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before PF asserting function reset, it should make sure
that all its VFs have been ready, otherwise, it will cause
some hardware errors.

So this patch adds function hclge_func_reset_sync_vf() to
synchronize VF before asserting PF function reset. For new
firmware which supports command HCLGE_OPC_QUERY_VF_RST_RDY,
we will try to query VFs' ready status within 30 seconds.
And keep the old implementation for compatible with firmware
which does not support this command.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  7 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 56 ++++++++++++++++++----
 2 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index dade20a..29979be 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -87,6 +87,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_QUERY_VF_RSRC		= 0x0024,
 	HCLGE_OPC_GET_CFG_PARAM		= 0x0025,
 	HCLGE_OPC_PF_RST_DONE		= 0x0026,
+	HCLGE_OPC_QUERY_VF_RST_RDY	= 0x0027,
 
 	HCLGE_OPC_STATS_64_BIT		= 0x0030,
 	HCLGE_OPC_STATS_32_BIT		= 0x0031,
@@ -588,6 +589,12 @@ struct hclge_config_mac_mode_cmd {
 	u8 rsv[20];
 };
 
+struct hclge_pf_rst_sync_cmd {
+#define HCLGE_PF_RST_ALL_VF_RDY_B	0
+	u8 all_vf_ready;
+	u8 rsv[23];
+};
+
 #define HCLGE_CFG_SPEED_S		0
 #define HCLGE_CFG_SPEED_M		GENMASK(5, 0)
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1315275..d207dac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -35,6 +35,9 @@
 #define BUF_RESERVE_PERCENT	90
 
 #define HCLGE_RESET_MAX_FAIL_CNT	5
+#define HCLGE_RESET_SYNC_TIME		100
+#define HCLGE_PF_RESET_SYNC_TIME	20
+#define HCLGE_PF_RESET_SYNC_CNT		1500
 
 /* Get DFX BD number offset */
 #define HCLGE_DFX_BIOS_BD_OFFSET        1
@@ -3184,6 +3187,39 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 	return 0;
 }
 
+int hclge_func_reset_sync_vf(struct hclge_dev *hdev)
+{
+	struct hclge_pf_rst_sync_cmd *req;
+	struct hclge_desc desc;
+	int cnt = 0;
+	int ret;
+
+	req = (struct hclge_pf_rst_sync_cmd *)desc.data;
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_VF_RST_RDY, true);
+
+	do {
+		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+		/* for compatible with old firmware, wait
+		 * 100 ms for VF to stop IO
+		 */
+		if (ret == -EOPNOTSUPP) {
+			msleep(HCLGE_RESET_SYNC_TIME);
+			return 0;
+		} else if (ret) {
+			dev_err(&hdev->pdev->dev, "sync with VF fail %d!\n",
+				ret);
+			return ret;
+		} else if (req->all_vf_ready) {
+			return 0;
+		}
+		msleep(HCLGE_PF_RESET_SYNC_TIME);
+		hclge_cmd_reuse_desc(&desc, true);
+	} while (cnt++ < HCLGE_PF_RESET_SYNC_CNT);
+
+	dev_err(&hdev->pdev->dev, "sync with VF timeout!\n");
+	return -ETIME;
+}
+
 int hclge_func_reset_cmd(struct hclge_dev *hdev, int func_id)
 {
 	struct hclge_desc desc;
@@ -3350,17 +3386,18 @@ static void hclge_reset_handshake(struct hclge_dev *hdev, bool enable)
 
 static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 {
-#define HCLGE_RESET_SYNC_TIME 100
-
 	u32 reg_val;
 	int ret = 0;
 
 	switch (hdev->reset_type) {
 	case HNAE3_FUNC_RESET:
-		/* There is no mechanism for PF to know if VF has stopped IO
-		 * for now, just wait 100 ms for VF to stop IO
+		/* to confirm whether all running VF is ready
+		 * before request PF reset
 		 */
-		msleep(HCLGE_RESET_SYNC_TIME);
+		ret = hclge_func_reset_sync_vf(hdev);
+		if (ret)
+			return ret;
+
 		ret = hclge_func_reset_cmd(hdev, 0);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
@@ -3377,10 +3414,13 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 		hdev->rst_stats.pf_rst_cnt++;
 		break;
 	case HNAE3_FLR_RESET:
-		/* There is no mechanism for PF to know if VF has stopped IO
-		 * for now, just wait 100 ms for VF to stop IO
+		/* to confirm whether all running VF is ready
+		 * before request PF reset
 		 */
-		msleep(HCLGE_RESET_SYNC_TIME);
+		ret = hclge_func_reset_sync_vf(hdev);
+		if (ret)
+			return ret;
+
 		set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
 		set_bit(HNAE3_FLR_DOWN, &hdev->flr_state);
 		hdev->rst_stats.flr_rst_cnt++;
-- 
2.7.4

