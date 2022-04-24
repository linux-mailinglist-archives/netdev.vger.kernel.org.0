Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E428050D1CB
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 15:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiDXNGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 09:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbiDXNGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 09:06:16 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C33E17C533;
        Sun, 24 Apr 2022 06:03:15 -0700 (PDT)
Received: from kwepemi100025.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KmSwb62Q0z1JBQx;
        Sun, 24 Apr 2022 21:02:23 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100025.china.huawei.com (7.221.188.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 24 Apr 2022 21:03:13 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 24 Apr 2022 21:03:13 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 6/6] net: hns3: add return value for mailbox handling in PF
Date:   Sun, 24 Apr 2022 20:57:25 +0800
Message-ID: <20220424125725.43232-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220424125725.43232-1-huangguangbin2@huawei.com>
References: <20220424125725.43232-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, there are some querying mailboxes sent from VF to PF,
and VF will wait the PF's handling result. For mailbox
HCLGE_MBX_GET_QID_IN_PF and HCLGE_MBX_GET_RSS_KEY, it may fail
when the input parameter is invalid, but the prototype of their
handler function is void. In this case, PF always return success
to VF, which may cause the VF get incorrect result.

Fixes it by adding return value for these function.

Fixes: 63b1279d9905 ("net: hns3: check queue id range before using")
Fixes: 532cfc0df1e4 ("net: hns3: add a check for index in hclge_get_rss_key()")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 53f939923c28..7998ca617a92 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -594,9 +594,9 @@ static int hclge_set_vf_mtu(struct hclge_vport *vport,
 	return hclge_set_vport_mtu(vport, mtu);
 }
 
-static void hclge_get_queue_id_in_pf(struct hclge_vport *vport,
-				     struct hclge_mbx_vf_to_pf_cmd *mbx_req,
-				     struct hclge_respond_to_vf_msg *resp_msg)
+static int hclge_get_queue_id_in_pf(struct hclge_vport *vport,
+				    struct hclge_mbx_vf_to_pf_cmd *mbx_req,
+				    struct hclge_respond_to_vf_msg *resp_msg)
 {
 	struct hnae3_handle *handle = &vport->nic;
 	struct hclge_dev *hdev = vport->back;
@@ -606,17 +606,18 @@ static void hclge_get_queue_id_in_pf(struct hclge_vport *vport,
 	if (queue_id >= handle->kinfo.num_tqps) {
 		dev_err(&hdev->pdev->dev, "Invalid queue id(%u) from VF %u\n",
 			queue_id, mbx_req->mbx_src_vfid);
-		return;
+		return -EINVAL;
 	}
 
 	qid_in_pf = hclge_covert_handle_qid_global(&vport->nic, queue_id);
 	memcpy(resp_msg->data, &qid_in_pf, sizeof(qid_in_pf));
 	resp_msg->len = sizeof(qid_in_pf);
+	return 0;
 }
 
-static void hclge_get_rss_key(struct hclge_vport *vport,
-			      struct hclge_mbx_vf_to_pf_cmd *mbx_req,
-			      struct hclge_respond_to_vf_msg *resp_msg)
+static int hclge_get_rss_key(struct hclge_vport *vport,
+			     struct hclge_mbx_vf_to_pf_cmd *mbx_req,
+			     struct hclge_respond_to_vf_msg *resp_msg)
 {
 #define HCLGE_RSS_MBX_RESP_LEN	8
 	struct hclge_dev *hdev = vport->back;
@@ -634,13 +635,14 @@ static void hclge_get_rss_key(struct hclge_vport *vport,
 		dev_warn(&hdev->pdev->dev,
 			 "failed to get the rss hash key, the index(%u) invalid !\n",
 			 index);
-		return;
+		return -EINVAL;
 	}
 
 	memcpy(resp_msg->data,
 	       &rss_cfg->rss_hash_key[index * HCLGE_RSS_MBX_RESP_LEN],
 	       HCLGE_RSS_MBX_RESP_LEN);
 	resp_msg->len = HCLGE_RSS_MBX_RESP_LEN;
+	return 0;
 }
 
 static void hclge_link_fail_parse(struct hclge_dev *hdev, u8 link_fail_code)
@@ -816,10 +818,10 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 					"VF fail(%d) to set mtu\n", ret);
 			break;
 		case HCLGE_MBX_GET_QID_IN_PF:
-			hclge_get_queue_id_in_pf(vport, req, &resp_msg);
+			ret = hclge_get_queue_id_in_pf(vport, req, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_RSS_KEY:
-			hclge_get_rss_key(vport, req, &resp_msg);
+			ret = hclge_get_rss_key(vport, req, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_LINK_MODE:
 			hclge_get_link_mode(vport, req);
-- 
2.33.0

