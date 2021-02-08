Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F2B31314D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbhBHLsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:48:24 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12595 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbhBHLoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:44:00 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZ3vT1WmZz165Pt;
        Mon,  8 Feb 2021 19:39:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 19:40:13 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/12] net: hns3: check cmdq message parameters sent from VF
Date:   Mon, 8 Feb 2021 19:39:33 +0800
Message-ID: <1612784382-27262-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
References: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The parameters sent from VF may be unreliable. If these
parameters are used directly, memory overwriting may occur.
Therefore, we need to check parameters before using.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  7 ++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 29 +++++++++++++++++++---
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f5a9884..037df35 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9830,12 +9830,19 @@ int hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 
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
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 754c09a..ffb416e 100644
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
 
@@ -597,6 +607,17 @@ static void hclge_get_rss_key(struct hclge_vport *vport,
 
 	index = mbx_req->msg.data[0];
 
+	/* Check the query index of rss_hash_key from VF, make sure no
+	 * more than the size of rss_hash_key.
+	 */
+	if (((index + 1) * HCLGE_RSS_MBX_RESP_LEN) >
+	      sizeof(vport[0].rss_hash_key)) {
+		dev_warn(&hdev->pdev->dev,
+			 "failed to get the rss hash key, the index(%u) invalid !\n",
+			 index);
+		return;
+	}
+
 	memcpy(resp_msg->data,
 	       &hdev->vport[0].rss_hash_key[index * HCLGE_RSS_MBX_RESP_LEN],
 	       HCLGE_RSS_MBX_RESP_LEN);
-- 
2.7.4

