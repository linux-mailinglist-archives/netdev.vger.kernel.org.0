Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639D0316036
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhBJHo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:44:59 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12893 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbhBJHoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:44:54 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DbBZ01KmSz7jW5;
        Wed, 10 Feb 2021 15:42:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Feb 2021 15:44:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/13] net: hns3: refactor out hclge_set_vf_vlan_common()
Date:   Wed, 10 Feb 2021 15:43:17 +0800
Message-ID: <1612943005-59416-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612943005-59416-1-git-send-email-tanhuazhong@huawei.com>
References: <1612943005-59416-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

To improve code readability and maintainability, separate
the command handling part and the status parsing part from
bloated hclge_set_vf_vlan_common().

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 63 +++++++++++++++-------
 1 file changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e2c5b8f..4fac22d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8786,32 +8786,16 @@ static void hclge_enable_vlan_filter(struct hnae3_handle *handle, bool enable)
 		handle->netdev_flags &= ~HNAE3_VLAN_FLTR;
 }
 
-static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
-				    bool is_kill, u16 vlan,
-				    __be16 proto)
+static int hclge_set_vf_vlan_filter_cmd(struct hclge_dev *hdev, u16 vfid,
+					bool is_kill, u16 vlan,
+					struct hclge_desc *desc)
 {
-	struct hclge_vport *vport = &hdev->vport[vfid];
 	struct hclge_vlan_filter_vf_cfg_cmd *req0;
 	struct hclge_vlan_filter_vf_cfg_cmd *req1;
-	struct hclge_desc desc[2];
 	u8 vf_byte_val;
 	u8 vf_byte_off;
 	int ret;
 
-	/* if vf vlan table is full, firmware will close vf vlan filter, it
-	 * is unable and unnecessary to add new vlan id to vf vlan filter.
-	 * If spoof check is enable, and vf vlan is full, it shouldn't add
-	 * new vlan, because tx packets with these vlan id will be dropped.
-	 */
-	if (test_bit(vfid, hdev->vf_vlan_full) && !is_kill) {
-		if (vport->vf_info.spoofchk && vlan) {
-			dev_err(&hdev->pdev->dev,
-				"Can't add vlan due to spoof check is on and vf vlan table is full\n");
-			return -EPERM;
-		}
-		return 0;
-	}
-
 	hclge_cmd_setup_basic_desc(&desc[0],
 				   HCLGE_OPC_VLAN_FILTER_VF_CFG, false);
 	hclge_cmd_setup_basic_desc(&desc[1],
@@ -8841,6 +8825,18 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 		return ret;
 	}
 
+	return 0;
+}
+
+static int hclge_check_vf_vlan_cmd_status(struct hclge_dev *hdev, u16 vfid,
+					  bool is_kill, struct hclge_desc *desc)
+{
+	struct hclge_vlan_filter_vf_cfg_cmd *req0;
+	struct hclge_vlan_filter_vf_cfg_cmd *req1;
+
+	req0 = (struct hclge_vlan_filter_vf_cfg_cmd *)desc[0].data;
+	req1 = (struct hclge_vlan_filter_vf_cfg_cmd *)desc[1].data;
+
 	if (!is_kill) {
 #define HCLGE_VF_VLAN_NO_ENTRY	2
 		if (!req0->resp_code || req0->resp_code == 1)
@@ -8877,6 +8873,35 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 	return -EIO;
 }
 
+static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
+				    bool is_kill, u16 vlan,
+				    __be16 proto)
+{
+	struct hclge_vport *vport = &hdev->vport[vfid];
+	struct hclge_desc desc[2];
+	int ret;
+
+	/* if vf vlan table is full, firmware will close vf vlan filter, it
+	 * is unable and unnecessary to add new vlan id to vf vlan filter.
+	 * If spoof check is enable, and vf vlan is full, it shouldn't add
+	 * new vlan, because tx packets with these vlan id will be dropped.
+	 */
+	if (test_bit(vfid, hdev->vf_vlan_full) && !is_kill) {
+		if (vport->vf_info.spoofchk && vlan) {
+			dev_err(&hdev->pdev->dev,
+				"Can't add vlan due to spoof check is on and vf vlan table is full\n");
+			return -EPERM;
+		}
+		return 0;
+	}
+
+	ret = hclge_set_vf_vlan_filter_cmd(hdev, vfid, is_kill, vlan, desc);
+	if (ret)
+		return ret;
+
+	return hclge_check_vf_vlan_cmd_status(hdev, vfid, is_kill, desc);
+}
+
 static int hclge_set_port_vlan_filter(struct hclge_dev *hdev, __be16 proto,
 				      u16 vlan_id, bool is_kill)
 {
-- 
2.7.4

