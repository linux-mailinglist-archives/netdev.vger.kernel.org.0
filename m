Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5413140C6DA
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 15:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbhION5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 09:57:45 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9876 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbhION5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 09:57:38 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H8hTd2GM7z8yLV;
        Wed, 15 Sep 2021 21:51:49 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 4/6] net: hns3: check queue id range before using
Date:   Wed, 15 Sep 2021 21:52:09 +0800
Message-ID: <20210915135211.9129-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915135211.9129-1-huangguangbin2@huawei.com>
References: <20210915135211.9129-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The input parameters may not be reliable. Before using the
queue id, we should check this parameter. Otherwise, memory
overwriting may occur.

Fixes: d34100184685 ("net: hns3: refactor the mailbox message between PF and VF")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 07aa6ada4fdb..65d78ee4d65a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -590,9 +590,17 @@ static void hclge_get_queue_id_in_pf(struct hclge_vport *vport,
 				     struct hclge_mbx_vf_to_pf_cmd *mbx_req,
 				     struct hclge_respond_to_vf_msg *resp_msg)
 {
+	struct hnae3_handle *handle = &vport->nic;
+	struct hclge_dev *hdev = vport->back;
 	u16 queue_id, qid_in_pf;
 
 	memcpy(&queue_id, mbx_req->msg.data, sizeof(queue_id));
+	if (queue_id >= handle->kinfo.num_tqps) {
+		dev_err(&hdev->pdev->dev, "Invalid queue id(%u) from VF %u\n",
+			queue_id, mbx_req->mbx_src_vfid);
+		return;
+	}
+
 	qid_in_pf = hclge_covert_handle_qid_global(&vport->nic, queue_id);
 	memcpy(resp_msg->data, &qid_in_pf, sizeof(qid_in_pf));
 	resp_msg->len = sizeof(qid_in_pf);
-- 
2.33.0

