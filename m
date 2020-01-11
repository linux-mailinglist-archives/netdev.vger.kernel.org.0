Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4632137C63
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 09:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgAKIeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 03:34:06 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36968 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728679AbgAKIeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 03:34:04 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BE48167DC97F74CD342A;
        Sat, 11 Jan 2020 16:34:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 16:33:54 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/7] net: hns3: refactor the notification scheme of PF reset
Date:   Sat, 11 Jan 2020 16:33:53 +0800
Message-ID: <1578731633-10709-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578731633-10709-1-git-send-email-tanhuazhong@huawei.com>
References: <1578731633-10709-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hclge_reset_prepare_down() is only used to inform VF that PF is
going to do function reset, then using hclge_func_reset_sync_vf()
in hclge_reset_prepare_wait() to query whether VF is ready before
asserting PF function reset. To make the code more readable,
this patch uses a new function hclge_function_reset_notify_vf()
to do this job.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 42 ++++++++++------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 21ecd79..76e8aa4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3562,23 +3562,6 @@ static void hclge_clear_reset_cause(struct hclge_dev *hdev)
 	hclge_enable_vector(&hdev->misc_vector, true);
 }
 
-static int hclge_reset_prepare_down(struct hclge_dev *hdev)
-{
-	int ret = 0;
-
-	switch (hdev->reset_type) {
-	case HNAE3_FUNC_RESET:
-		/* fall through */
-	case HNAE3_FLR_RESET:
-		ret = hclge_set_all_vf_rst(hdev, true);
-		break;
-	default:
-		break;
-	}
-
-	return ret;
-}
-
 static void hclge_reset_handshake(struct hclge_dev *hdev, bool enable)
 {
 	u32 reg_val;
@@ -3592,6 +3575,19 @@ static void hclge_reset_handshake(struct hclge_dev *hdev, bool enable)
 	hclge_write_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG, reg_val);
 }
 
+static int hclge_func_reset_notify_vf(struct hclge_dev *hdev)
+{
+	int ret;
+
+	ret = hclge_set_all_vf_rst(hdev, true);
+	if (ret)
+		return ret;
+
+	hclge_func_reset_sync_vf(hdev);
+
+	return 0;
+}
+
 static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 {
 	u32 reg_val;
@@ -3599,7 +3595,9 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 
 	switch (hdev->reset_type) {
 	case HNAE3_FUNC_RESET:
-		hclge_func_reset_sync_vf(hdev);
+		ret = hclge_func_reset_notify_vf(hdev);
+		if (ret)
+			return ret;
 
 		ret = hclge_func_reset_cmd(hdev, 0);
 		if (ret) {
@@ -3617,7 +3615,9 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 		hdev->rst_stats.pf_rst_cnt++;
 		break;
 	case HNAE3_FLR_RESET:
-		hclge_func_reset_sync_vf(hdev);
+		ret = hclge_func_reset_notify_vf(hdev);
+		if (ret)
+			return ret;
 		break;
 	case HNAE3_IMP_RESET:
 		hclge_handle_imp_error(hdev);
@@ -3761,10 +3761,6 @@ static int hclge_reset_prepare(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
-	ret = hclge_reset_prepare_down(hdev);
-	if (ret)
-		return ret;
-
 	rtnl_lock();
 	ret = hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
 	rtnl_unlock();
-- 
2.7.4

