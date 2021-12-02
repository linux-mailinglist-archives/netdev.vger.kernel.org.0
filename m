Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D98465FB1
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345953AbhLBIoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:44:13 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27335 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345762AbhLBIoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:44:09 -0500
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J4TtY335xzbj8y;
        Thu,  2 Dec 2021 16:40:37 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500002.china.huawei.com (7.221.188.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:45 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 6/9] net: hns3: split function hclge_update_port_base_vlan_cfg()
Date:   Thu, 2 Dec 2021 16:36:00 +0800
Message-ID: <20211202083603.25176-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202083603.25176-1-huangguangbin2@huawei.com>
References: <20211202083603.25176-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently the function hclge_update_port_base_vlan_cfg() is a
bit long. Split it to several small functions, to improve the
readability.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 69 ++++++++++---------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b691f306138a..4a52d18f4166 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10540,12 +10540,41 @@ static bool hclge_need_update_vlan_filter(const struct hclge_vlan_info *new_cfg,
 	return false;
 }
 
+static int hclge_modify_port_base_vlan_tag(struct hclge_vport *vport,
+					   struct hclge_vlan_info *new_info,
+					   struct hclge_vlan_info *old_info)
+{
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	/* add new VLAN tag */
+	ret = hclge_set_vlan_filter_hw(hdev, htons(new_info->vlan_proto),
+				       vport->vport_id, new_info->vlan_tag,
+				       false);
+	if (ret)
+		return ret;
+
+	/* remove old VLAN tag */
+	if (old_info->vlan_tag == 0)
+		ret = hclge_set_vf_vlan_common(hdev, vport->vport_id,
+					       true, 0);
+	else
+		ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
+					       vport->vport_id,
+					       old_info->vlan_tag, true);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to clear vport%u port base vlan %u, ret = %d.\n",
+			vport->vport_id, old_info->vlan_tag, ret);
+
+	return ret;
+}
+
 int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 				    struct hclge_vlan_info *vlan_info)
 {
 	struct hnae3_handle *nic = &vport->nic;
 	struct hclge_vlan_info *old_vlan_info;
-	struct hclge_dev *hdev = vport->back;
 	int ret;
 
 	old_vlan_info = &vport->port_base_vlan_cfg.vlan_info;
@@ -10558,38 +10587,12 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 	if (!hclge_need_update_vlan_filter(vlan_info, old_vlan_info))
 		goto out;
 
-	if (state == HNAE3_PORT_BASE_VLAN_MODIFY) {
-		/* add new VLAN tag */
-		ret = hclge_set_vlan_filter_hw(hdev,
-					       htons(vlan_info->vlan_proto),
-					       vport->vport_id,
-					       vlan_info->vlan_tag,
-					       false);
-		if (ret)
-			return ret;
-
-		/* remove old VLAN tag */
-		if (old_vlan_info->vlan_tag == 0)
-			ret = hclge_set_vf_vlan_common(hdev, vport->vport_id,
-						       true, 0);
-		else
-			ret = hclge_set_vlan_filter_hw(hdev,
-						       htons(ETH_P_8021Q),
-						       vport->vport_id,
-						       old_vlan_info->vlan_tag,
-						       true);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"failed to clear vport%u port base vlan %u, ret = %d.\n",
-				vport->vport_id, old_vlan_info->vlan_tag, ret);
-			return ret;
-		}
-
-		goto out;
-	}
-
-	ret = hclge_update_vlan_filter_entries(vport, state, vlan_info,
-					       old_vlan_info);
+	if (state == HNAE3_PORT_BASE_VLAN_MODIFY)
+		ret = hclge_modify_port_base_vlan_tag(vport, vlan_info,
+						      old_vlan_info);
+	else
+		ret = hclge_update_vlan_filter_entries(vport, state, vlan_info,
+						       old_vlan_info);
 	if (ret)
 		return ret;
 
-- 
2.33.0

