Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A913A04EB
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfH1O0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:26:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5234 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726691AbfH1OZk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:40 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1825CCC0AA225B890167;
        Wed, 28 Aug 2019 22:25:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:30 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/12] net: hns3: modify base parameter of kstrtouint in hclge_dbg_dump_tm_map
Date:   Wed, 28 Aug 2019 22:23:07 +0800
Message-ID: <1567002196-63242-4-git-send-email-tanhuazhong@huawei.com>
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

This patch replaces kstrtouint()'s patameter base with 0 in the
hclge_dbg_dump_tm_mac(), which makes it more flexible. Also
uses a macro to replace string "dump tm map", since it has been
used multiple times.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 3b4cd23..0639250 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -564,7 +564,7 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 	int pri_id, ret;
 	u32 i;
 
-	ret = kstrtouint(&cmd_buf[12], 10, &queue_id);
+	ret = kstrtouint(cmd_buf, 0, &queue_id);
 	queue_id = (ret != 0) ? 0 : queue_id;
 
 	cmd = HCLGE_OPC_TM_NQ_TO_QS_LINK;
@@ -1099,6 +1099,7 @@ static void hclge_dbg_dump_mac_tnl_status(struct hclge_dev *hdev)
 int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 {
 #define DUMP_REG	"dump reg"
+#define DUMP_TM_MAP	"dump tm map"
 
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
@@ -1107,8 +1108,8 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_fd_tcam(hdev);
 	} else if (strncmp(cmd_buf, "dump tc", 7) == 0) {
 		hclge_dbg_dump_tc(hdev);
-	} else if (strncmp(cmd_buf, "dump tm map", 11) == 0) {
-		hclge_dbg_dump_tm_map(hdev, cmd_buf);
+	} else if (strncmp(cmd_buf, DUMP_TM_MAP, strlen(DUMP_TM_MAP)) == 0) {
+		hclge_dbg_dump_tm_map(hdev, &cmd_buf[sizeof(DUMP_TM_MAP)]);
 	} else if (strncmp(cmd_buf, "dump tm", 7) == 0) {
 		hclge_dbg_dump_tm(hdev);
 	} else if (strncmp(cmd_buf, "dump qos pause cfg", 18) == 0) {
-- 
2.7.4

