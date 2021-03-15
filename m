Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13D333B284
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhCOMXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:23:45 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13615 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbhCOMX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 08:23:28 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DzbBP6gc6z17Lbf;
        Mon, 15 Mar 2021 20:21:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 20:23:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/9] net: hns3: refactor out hclge_add_fd_entry()
Date:   Mon, 15 Mar 2021 20:23:43 +0800
Message-ID: <1615811031-55209-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

The process of function hclge_add_fd_entry() is complex and
prolix. To make it more readable, extract the process of
fs->ring_cookie to a single function.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 67 +++++++++++++---------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a664383..4929220 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6126,6 +6126,42 @@ static bool hclge_is_cls_flower_active(struct hnae3_handle *handle)
 	return hdev->fd_active_type == HCLGE_FD_TC_FLOWER_ACTIVE;
 }
 
+static int hclge_fd_parse_ring_cookie(struct hclge_dev *hdev, u64 ring_cookie,
+				      u16 *vport_id, u8 *action, u16 *queue_id)
+{
+	struct hclge_vport *vport = hdev->vport;
+
+	if (ring_cookie == RX_CLS_FLOW_DISC) {
+		*action = HCLGE_FD_ACTION_DROP_PACKET;
+	} else {
+		u32 ring = ethtool_get_flow_spec_ring(ring_cookie);
+		u8 vf = ethtool_get_flow_spec_ring_vf(ring_cookie);
+		u16 tqps;
+
+		if (vf > hdev->num_req_vfs) {
+			dev_err(&hdev->pdev->dev,
+				"Error: vf id (%u) > max vf num (%u)\n",
+				vf, hdev->num_req_vfs);
+			return -EINVAL;
+		}
+
+		*vport_id = vf ? hdev->vport[vf].vport_id : vport->vport_id;
+		tqps = hdev->vport[vf].nic.kinfo.num_tqps;
+
+		if (ring >= tqps) {
+			dev_err(&hdev->pdev->dev,
+				"Error: queue id (%u) > max tqp num (%u)\n",
+				ring, tqps - 1);
+			return -EINVAL;
+		}
+
+		*action = HCLGE_FD_ACTION_SELECT_QUEUE;
+		*queue_id = ring;
+	}
+
+	return 0;
+}
+
 static int hclge_add_fd_entry(struct hnae3_handle *handle,
 			      struct ethtool_rxnfc *cmd)
 {
@@ -6162,33 +6198,10 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	if (ret)
 		return ret;
 
-	if (fs->ring_cookie == RX_CLS_FLOW_DISC) {
-		action = HCLGE_FD_ACTION_DROP_PACKET;
-	} else {
-		u32 ring = ethtool_get_flow_spec_ring(fs->ring_cookie);
-		u8 vf = ethtool_get_flow_spec_ring_vf(fs->ring_cookie);
-		u16 tqps;
-
-		if (vf > hdev->num_req_vfs) {
-			dev_err(&hdev->pdev->dev,
-				"Error: vf id (%u) > max vf num (%u)\n",
-				vf, hdev->num_req_vfs);
-			return -EINVAL;
-		}
-
-		dst_vport_id = vf ? hdev->vport[vf].vport_id : vport->vport_id;
-		tqps = vf ? hdev->vport[vf].alloc_tqps : vport->alloc_tqps;
-
-		if (ring >= tqps) {
-			dev_err(&hdev->pdev->dev,
-				"Error: queue id (%u) > max tqp num (%u)\n",
-				ring, tqps - 1);
-			return -EINVAL;
-		}
-
-		action = HCLGE_FD_ACTION_SELECT_QUEUE;
-		q_index = ring;
-	}
+	ret = hclge_fd_parse_ring_cookie(hdev, fs->ring_cookie, &dst_vport_id,
+					 &action, &q_index);
+	if (ret)
+		return ret;
 
 	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
 	if (!rule)
-- 
2.7.4

