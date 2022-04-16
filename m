Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CA45035A7
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 11:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiDPJWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 05:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiDPJWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 05:22:00 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E760B49CA5;
        Sat, 16 Apr 2022 02:19:27 -0700 (PDT)
Received: from kwepemi500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KgSM01KVkzQwRN;
        Sat, 16 Apr 2022 17:19:24 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500022.china.huawei.com (7.221.188.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 17:19:26 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 17:19:25 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 3/9] net: hns3: refine the definition for struct hclge_pf_to_vf_msg
Date:   Sat, 16 Apr 2022 17:13:37 +0800
Message-ID: <20220416091343.35817-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220416091343.35817-1-huangguangbin2@huawei.com>
References: <20220416091343.35817-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

The struct hclge_pf_to_vf_msg is used for mailbox message from
PF to VF, including both response and request. But its definition
can only indicate respone, which makes the message data copy in
function hclge_send_mbx_msg() unreadable. So refine it by edding
a general message definition into it.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h | 17 +++++++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c  |  2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index b668df6193be..8c7fadf2b734 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -135,10 +135,19 @@ struct hclge_vf_to_pf_msg {
 
 struct hclge_pf_to_vf_msg {
 	u16 code;
-	u16 vf_mbx_msg_code;
-	u16 vf_mbx_msg_subcode;
-	u16 resp_status;
-	u8 resp_data[HCLGE_MBX_MAX_RESP_DATA_SIZE];
+	union {
+		/* used for mbx response */
+		struct {
+			u16 vf_mbx_msg_code;
+			u16 vf_mbx_msg_subcode;
+			u16 resp_status;
+			u8 resp_data[HCLGE_MBX_MAX_RESP_DATA_SIZE];
+		};
+		/* used for general mbx */
+		struct {
+			u8 msg_data[HCLGE_MBX_MAX_MSG_SIZE];
+		};
+	};
 };
 
 struct hclge_mbx_vf_to_pf_cmd {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 6799d16de34b..76d0f17d6be3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -102,7 +102,7 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 	resp_pf_to_vf->msg_len = msg_len;
 	resp_pf_to_vf->msg.code = mbx_opcode;
 
-	memcpy(&resp_pf_to_vf->msg.vf_mbx_msg_code, msg, msg_len);
+	memcpy(resp_pf_to_vf->msg.msg_data, msg, msg_len);
 
 	trace_hclge_pf_mbx_send(hdev, resp_pf_to_vf);
 
-- 
2.33.0

