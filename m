Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C173CD065
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhGSIgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:36:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15039 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbhGSIgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:36:00 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GSx314lNkzZqp1;
        Mon, 19 Jul 2021 17:13:17 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:16:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:16:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <fengchengwen@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net 1/4] net: hns3: fix possible mismatches resp of mailbox
Date:   Mon, 19 Jul 2021 17:13:05 +0800
Message-ID: <1626685988-25869-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1626685988-25869-1-git-send-email-huangguangbin2@huawei.com>
References: <1626685988-25869-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chengwen Feng <fengchengwen@huawei.com>

Currently, the mailbox synchronous communication between VF and PF use
the following fields to maintain communication:
1. Origin_mbx_msg which was combined by message code and subcode, used
to match request and response.
2. Received_resp which means whether received response.

There may possible mismatches of the following situation:
1. VF sends message A with code=1 subcode=1.
2. PF was blocked about 500ms when processing the message A.
3. VF will detect message A timeout because it can't get the response
within 500ms.
4. VF sends message B with code=1 subcode=1 which equal message A.
5. PF processes the first message A and send the response message to
VF.
6. VF will identify the response matched the message B because the
code/subcode is the same. This will lead to mismatch of request and
response.

To fix the above bug, we use the following scheme:
1. The message sent from VF was labelled with match_id which was a
unique 16-bit non-zero value.
2. The response sent from PF will label with match_id which got from
the request.
3. The VF uses the match_id to match request and response message.

As for PF driver, it only needs to copy the match_id from request to
response.

Fixes: dde1a86e93ca ("net: hns3: Add mailbox support to PF driver")
Signed-off-by: Chengwen Feng <fengchengwen@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h        | 6 ++++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 0a6cda309b24..56b573e47072 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -143,7 +143,8 @@ struct hclge_mbx_vf_to_pf_cmd {
 	u8 mbx_need_resp;
 	u8 rsv1[1];
 	u8 msg_len;
-	u8 rsv2[3];
+	u8 rsv2;
+	u16 match_id;
 	struct hclge_vf_to_pf_msg msg;
 };
 
@@ -153,7 +154,8 @@ struct hclge_mbx_pf_to_vf_cmd {
 	u8 dest_vfid;
 	u8 rsv[3];
 	u8 msg_len;
-	u8 rsv1[3];
+	u8 rsv1;
+	u16 match_id;
 	struct hclge_pf_to_vf_msg msg;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index e10a2c36b706..c0a478ae9583 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -47,6 +47,7 @@ static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 
 	resp_pf_to_vf->dest_vfid = vf_to_pf_req->mbx_src_vfid;
 	resp_pf_to_vf->msg_len = vf_to_pf_req->msg_len;
+	resp_pf_to_vf->match_id = vf_to_pf_req->match_id;
 
 	resp_pf_to_vf->msg.code = HCLGE_MBX_PF_VF_RESP;
 	resp_pf_to_vf->msg.vf_mbx_msg_code = vf_to_pf_req->msg.code;
-- 
2.8.1

