Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CEBEAEC7
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfJaLXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:23:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5666 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726552AbfJaLXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:23:02 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0C2A028BB33B0E13450E;
        Thu, 31 Oct 2019 19:22:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 19:22:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/9] net: hns3: dump some debug information when reset fail
Date:   Thu, 31 Oct 2019 19:23:16 +0800
Message-ID: <1572521004-36126-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
References: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When reset fails, there is some information that will help for
finding out why does reset fail. and removes an unused
core_rst_cnt field in struct hclge_rst_stats.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  5 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  3 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 29 ++++++++++++++++++++++
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 0ccc8e7..122ad92 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -929,7 +929,7 @@ static void hclge_dbg_fd_tcam(struct hclge_dev *hdev)
 	}
 }
 
-static void hclge_dbg_dump_rst_info(struct hclge_dev *hdev)
+void hclge_dbg_dump_rst_info(struct hclge_dev *hdev)
 {
 	dev_info(&hdev->pdev->dev, "PF reset count: %u\n",
 		 hdev->rst_stats.pf_rst_cnt);
@@ -945,8 +945,6 @@ static void hclge_dbg_dump_rst_info(struct hclge_dev *hdev)
 		 hdev->rst_stats.hw_reset_done_cnt);
 	dev_info(&hdev->pdev->dev, "reset count: %u\n",
 		 hdev->rst_stats.reset_cnt);
-	dev_info(&hdev->pdev->dev, "reset count: %u\n",
-		 hdev->rst_stats.reset_cnt);
 	dev_info(&hdev->pdev->dev, "reset fail count: %u\n",
 		 hdev->rst_stats.reset_fail_cnt);
 	dev_info(&hdev->pdev->dev, "vector0 interrupt enable status: 0x%x\n",
@@ -961,6 +959,7 @@ static void hclge_dbg_dump_rst_info(struct hclge_dev *hdev)
 		 hclge_read_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG));
 	dev_info(&hdev->pdev->dev, "function reset status: 0x%x\n",
 		 hclge_read_dev(&hdev->hw, HCLGE_FUN_RST_ING));
+	dev_info(&hdev->pdev->dev, "hdev state: 0x%lx\n", hdev->state);
 }
 
 static void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index bf6bca2..19667c9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3669,6 +3669,9 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 	hclge_reset_handshake(hdev, true);
 
 	dev_err(&hdev->pdev->dev, "Reset fail!\n");
+
+	hclge_dbg_dump_rst_info(hdev);
+
 	return false;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9e59f0e..4386788 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -656,7 +656,6 @@ struct hclge_rst_stats {
 	u32 hw_reset_done_cnt;	/* the number of HW reset has completed */
 	u32 pf_rst_cnt;		/* the number of PF reset */
 	u32 flr_rst_cnt;	/* the number of FLR */
-	u32 core_rst_cnt;	/* the number of CORE reset */
 	u32 global_rst_cnt;	/* the number of GLOBAL */
 	u32 imp_rst_cnt;	/* the number of IMP reset */
 	u32 reset_cnt;		/* the number of reset */
@@ -1005,4 +1004,5 @@ int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev,
 void hclge_report_hw_error(struct hclge_dev *hdev,
 			   enum hnae3_hw_error_type type);
 void hclge_inform_vf_promisc_info(struct hclge_vport *vport);
+void hclge_dbg_dump_rst_info(struct hclge_dev *hdev);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 408e386..c38eba8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1549,6 +1549,33 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 	return ret;
 }
 
+static void hclgevf_dump_rst_info(struct hclgevf_dev *hdev)
+{
+	dev_info(&hdev->pdev->dev, "VF function reset count: %u\n",
+		 hdev->rst_stats.vf_func_rst_cnt);
+	dev_info(&hdev->pdev->dev, "FLR reset count: %u\n",
+		 hdev->rst_stats.flr_rst_cnt);
+	dev_info(&hdev->pdev->dev, "VF reset count: %u\n",
+		 hdev->rst_stats.vf_rst_cnt);
+	dev_info(&hdev->pdev->dev, "reset done count: %u\n",
+		 hdev->rst_stats.rst_done_cnt);
+	dev_info(&hdev->pdev->dev, "HW reset done count: %u\n",
+		 hdev->rst_stats.hw_rst_done_cnt);
+	dev_info(&hdev->pdev->dev, "reset count: %u\n",
+		 hdev->rst_stats.rst_cnt);
+	dev_info(&hdev->pdev->dev, "reset fail count: %u\n",
+		 hdev->rst_stats.rst_fail_cnt);
+	dev_info(&hdev->pdev->dev, "vector0 interrupt enable status: 0x%x\n",
+		 hclgevf_read_dev(&hdev->hw, HCLGEVF_MISC_VECTOR_REG_BASE));
+	dev_info(&hdev->pdev->dev, "vector0 interrupt status: 0x%x\n",
+		 hclgevf_read_dev(&hdev->hw, HCLGEVF_VECTOR0_CMDQ_STAT_REG));
+	dev_info(&hdev->pdev->dev, "handshake status: 0x%x\n",
+		 hclgevf_read_dev(&hdev->hw, HCLGEVF_CMDQ_TX_DEPTH_REG));
+	dev_info(&hdev->pdev->dev, "function reset status: 0x%x\n",
+		 hclgevf_read_dev(&hdev->hw, HCLGEVF_RST_ING));
+	dev_info(&hdev->pdev->dev, "hdev state: 0x%lx\n", hdev->state);
+}
+
 static void hclgevf_reset_err_handle(struct hclgevf_dev *hdev)
 {
 	/* recover handshake status with IMP when reset fail */
@@ -1563,6 +1590,8 @@ static void hclgevf_reset_err_handle(struct hclgevf_dev *hdev)
 	if (hclgevf_is_reset_pending(hdev)) {
 		set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
 		hclgevf_reset_task_schedule(hdev);
+	} else {
+		hclgevf_dump_rst_info(hdev);
 	}
 }
 
-- 
2.7.4

