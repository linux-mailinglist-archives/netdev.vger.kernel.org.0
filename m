Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644C4314B2A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhBIJLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:11:05 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12155 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbhBIJFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 04:05:15 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZcN81XN2zlHyT;
        Tue,  9 Feb 2021 17:02:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 17:03:54 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 2/3] net: hns3: add a check for tqp_index in hclge_get_ring_chain_from_mbx()
Date:   Tue, 9 Feb 2021 17:03:06 +0800
Message-ID: <1612861387-35858-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612861387-35858-1-git-send-email-tanhuazhong@huawei.com>
References: <1612861387-35858-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The tqp_index is received from vf, if use it directly,
an out-of-bound issue may be caused, so add a check for
this tqp_index before using it in hclge_get_ring_chain_from_mbx().

Fixes: 84e095d64ed9 ("net: hns3: Change PF to add ring-vect binding & resetQ to mailbox")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 754c09a..ea2dea99 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -158,21 +158,31 @@ static int hclge_get_ring_chain_from_mbx(
 			struct hclge_vport *vport)
 {
 	struct hnae3_ring_chain_node *cur_chain, *new_chain;
+	struct hclge_dev *hdev = vport->back;
 	int ring_num;
-	int i = 0;
+	int i;
 
 	ring_num = req->msg.ring_num;
 
 	if (ring_num > HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM)
 		return -ENOMEM;
 
+	for (i = 0; i < ring_num; i++) {
+		if (req->msg.param[i].tqp_index >= vport->nic.kinfo.rss_size) {
+			dev_err(&hdev->pdev->dev, "tqp index(%u) is out of range(0-%u)\n",
+				req->msg.param[i].tqp_index,
+				vport->nic.kinfo.rss_size - 1);
+			return -EINVAL;
+		}
+	}
+
 	hnae3_set_bit(ring_chain->flag, HNAE3_RING_TYPE_B,
-		      req->msg.param[i].ring_type);
+		      req->msg.param[0].ring_type);
 	ring_chain->tqp_index =
 		hclge_get_queue_id(vport->nic.kinfo.tqp
-				   [req->msg.param[i].tqp_index]);
+				   [req->msg.param[0].tqp_index]);
 	hnae3_set_field(ring_chain->int_gl_idx, HNAE3_RING_GL_IDX_M,
-			HNAE3_RING_GL_IDX_S, req->msg.param[i].int_gl_index);
+			HNAE3_RING_GL_IDX_S, req->msg.param[0].int_gl_index);
 
 	cur_chain = ring_chain;
 
-- 
2.7.4

