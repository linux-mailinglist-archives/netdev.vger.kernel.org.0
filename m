Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8CB3198B9
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhBLDXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:23:21 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12514 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhBLDXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:23:09 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DcJfC5CnKzjMHh;
        Fri, 12 Feb 2021 11:20:19 +0800 (CST)
Received: from SZA170332453E.china.huawei.com (10.46.104.160) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Feb 2021 11:21:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 05/13] net: hns3: refactor out hclge_set_vf_vlan_common()
Date:   Fri, 12 Feb 2021 11:21:05 +0800
Message-ID: <20210212032113.5384-6-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20210212032113.5384-1-tanhuazhong@huawei.com>
References: <20210212032113.5384-1-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.46.104.160]
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
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 73 ++++++++++++-------
 1 file changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d3e68963967d..3eb675d54d6f 100644
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
@@ -8841,12 +8825,22 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 		return ret;
 	}
 
+	return 0;
+}
+
+static int hclge_check_vf_vlan_cmd_status(struct hclge_dev *hdev, u16 vfid,
+					  bool is_kill, struct hclge_desc *desc)
+{
+	struct hclge_vlan_filter_vf_cfg_cmd *req;
+
+	req = (struct hclge_vlan_filter_vf_cfg_cmd *)desc[0].data;
+
 	if (!is_kill) {
 #define HCLGE_VF_VLAN_NO_ENTRY	2
-		if (!req0->resp_code || req0->resp_code == 1)
+		if (!req->resp_code || req->resp_code == 1)
 			return 0;
 
-		if (req0->resp_code == HCLGE_VF_VLAN_NO_ENTRY) {
+		if (req->resp_code == HCLGE_VF_VLAN_NO_ENTRY) {
 			set_bit(vfid, hdev->vf_vlan_full);
 			dev_warn(&hdev->pdev->dev,
 				 "vf vlan table is full, vf vlan filter is disabled\n");
@@ -8855,10 +8849,10 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 
 		dev_err(&hdev->pdev->dev,
 			"Add vf vlan filter fail, ret =%u.\n",
-			req0->resp_code);
+			req->resp_code);
 	} else {
 #define HCLGE_VF_VLAN_DEL_NO_FOUND	1
-		if (!req0->resp_code)
+		if (!req->resp_code)
 			return 0;
 
 		/* vf vlan filter is disabled when vf vlan table is full,
@@ -8866,17 +8860,46 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 		 * Just return 0 without warning, avoid massive verbose
 		 * print logs when unload.
 		 */
-		if (req0->resp_code == HCLGE_VF_VLAN_DEL_NO_FOUND)
+		if (req->resp_code == HCLGE_VF_VLAN_DEL_NO_FOUND)
 			return 0;
 
 		dev_err(&hdev->pdev->dev,
 			"Kill vf vlan filter fail, ret =%u.\n",
-			req0->resp_code);
+			req->resp_code);
 	}
 
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
2.25.1

