Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811C8314B26
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhBIJKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:10:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12157 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhBIJFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 04:05:11 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZcN823JyzlJ0t;
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
Subject: [PATCH net 1/3] net: hns3: add a check for queue_id in hclge_reset_vf_queue()
Date:   Tue, 9 Feb 2021 17:03:05 +0800
Message-ID: <1612861387-35858-2-git-send-email-tanhuazhong@huawei.com>
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

The queue_id is received from vf, if use it directly,
an out-of-bound issue may be caused, so add a check for
this queue_id before using it in hclge_reset_vf_queue().

Fixes: 1a426f8b40fc ("net: hns3: fix the VF queue reset flow error")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c242883..48549db 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9813,12 +9813,19 @@ int hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 
 void hclge_reset_vf_queue(struct hclge_vport *vport, u16 queue_id)
 {
+	struct hnae3_handle *handle = &vport->nic;
 	struct hclge_dev *hdev = vport->back;
 	int reset_try_times = 0;
 	int reset_status;
 	u16 queue_gid;
 	int ret;
 
+	if (queue_id >= handle->kinfo.num_tqps) {
+		dev_warn(&hdev->pdev->dev, "Invalid vf queue id(%u)\n",
+			 queue_id);
+		return;
+	}
+
 	queue_gid = hclge_covert_handle_qid_global(&vport->nic, queue_id);
 
 	ret = hclge_send_reset_tqp_cmd(hdev, queue_gid, true);
-- 
2.7.4

