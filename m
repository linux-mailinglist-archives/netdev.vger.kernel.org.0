Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81D54673F1
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 10:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379619AbhLCJ3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 04:29:13 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15692 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379610AbhLCJ3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 04:29:11 -0500
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J56n150pMzZdMG;
        Fri,  3 Dec 2021 17:23:01 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:40 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:39 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 02/11] net: hns3: refactor function hclge_set_vlan_filter_hw
Date:   Fri, 3 Dec 2021 17:20:50 +0800
Message-ID: <20211203092059.24947-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203092059.24947-1-huangguangbin2@huawei.com>
References: <20211203092059.24947-1-huangguangbin2@huawei.com>
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

Function hclge_set_vlan_filter_hw() is a bit too long, so add a new
function hclge_need_update_port_vlan() to simplify code and improve
code readability.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 45 +++++++++++--------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 5a5e74dfd0be..0d2ed05c4f50 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10005,6 +10005,32 @@ static int hclge_set_port_vlan_filter(struct hclge_dev *hdev, __be16 proto,
 	return ret;
 }
 
+static bool hclge_need_update_port_vlan(struct hclge_dev *hdev, u16 vport_id,
+					u16 vlan_id, bool is_kill)
+{
+	/* vlan 0 may be added twice when 8021q module is enabled */
+	if (!is_kill && !vlan_id &&
+	    test_bit(vport_id, hdev->vlan_table[vlan_id]))
+		return false;
+
+	if (!is_kill && test_and_set_bit(vport_id, hdev->vlan_table[vlan_id])) {
+		dev_warn(&hdev->pdev->dev,
+			 "Add port vlan failed, vport %u is already in vlan %u\n",
+			 vport_id, vlan_id);
+		return false;
+	}
+
+	if (is_kill &&
+	    !test_and_clear_bit(vport_id, hdev->vlan_table[vlan_id])) {
+		dev_warn(&hdev->pdev->dev,
+			 "Delete port vlan failed, vport %u is not in vlan %u\n",
+			 vport_id, vlan_id);
+		return false;
+	}
+
+	return true;
+}
+
 static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 				    u16 vport_id, u16 vlan_id,
 				    bool is_kill)
@@ -10026,26 +10052,9 @@ static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 		return ret;
 	}
 
-	/* vlan 0 may be added twice when 8021q module is enabled */
-	if (!is_kill && !vlan_id &&
-	    test_bit(vport_id, hdev->vlan_table[vlan_id]))
+	if (!hclge_need_update_port_vlan(hdev, vport_id, vlan_id, is_kill))
 		return 0;
 
-	if (!is_kill && test_and_set_bit(vport_id, hdev->vlan_table[vlan_id])) {
-		dev_err(&hdev->pdev->dev,
-			"Add port vlan failed, vport %u is already in vlan %u\n",
-			vport_id, vlan_id);
-		return -EINVAL;
-	}
-
-	if (is_kill &&
-	    !test_and_clear_bit(vport_id, hdev->vlan_table[vlan_id])) {
-		dev_err(&hdev->pdev->dev,
-			"Delete port vlan failed, vport %u is not in vlan %u\n",
-			vport_id, vlan_id);
-		return -EINVAL;
-	}
-
 	for_each_set_bit(vport_idx, hdev->vlan_table[vlan_id], HCLGE_VPORT_NUM)
 		vport_num++;
 
-- 
2.33.0

