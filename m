Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1A54B035B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiBJCaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:30:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiBJCaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:30:09 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC16237C6
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 18:30:10 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 219II1Zb014384;
        Wed, 9 Feb 2022 18:30:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=Rwu8Yup2Yg8QFcW5ScQ1R8+6z4RQFA4nXHYdof7uQ3A=;
 b=SBSpXODkCj22QGqrEiq2LeZd2CKAiReXkoDcvihiDduODfkTT53pOCoyBaCoBkjZC6Hd
 DMcbjvnMHrmB05sxvibRTqEL1TECWi/Cu2bIO4MhDC5T+SUiasz4CPm8F5tdSXuBKu0Q
 hP+j1hdqgGp7arN8em34KJ4dhCEE9hyohz25zofkl/+3FFrNbKniBp9KnxUYcEAXdIl/
 WJsrr1Y1YwN+5Yd/H3UUQ6dSygR5NWMxYBcp6JwDZ5W9irAVf4dWUVLHSQWT1g+nXG2h
 ql3S5gH6ytGL7miHQpzX/ZL8frFV/+nay1IQgUQMSHazX61uJ+FX79G1mFpLFx8zfnNH fw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e4am94684-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 18:30:06 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Feb
 2022 18:30:04 -0800
Received: from ahp-hp.devlab.local (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 9 Feb 2022 18:30:04 -0800
From:   Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <manishc@marvell.com>,
        <davem@davemloft.net>,
        Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>,
        "Pravin Kumar Ganesh Dhende" <pdhende@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: [PATCH net-next 1/1] qed: prevent a fw assert during device shutdown
Date:   Wed, 9 Feb 2022 11:28:14 -0800
Message-ID: <20220209192814.2048658-1-vbhavaraju@marvell.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: QUy__PiourOoKTHr9ThEEALX2WgAFLpT
X-Proofpoint-ORIG-GUID: QUy__PiourOoKTHr9ThEEALX2WgAFLpT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_12,2022-02-09_01,2021-12-02_01
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device firmware can assert if the device shutdown path in driver
encounters an async. events from mfw (processed in
qed_mcp_handle_events()) after qed_mcp_unload_req() returns.
A call to qed_mcp_unload_req() currently marks the device as inactive
and thus stops any new events, but there is a windows where in-flight
events might still be received by the driver.

To prevent this race condition, atomically set QED_MCP_BYPASS_PROC_BIT
in qed_mcp_unload_req() to make sure qed_mcp_handle_events() ignores all
events. Wait for any event that might already be in-process to complete
by monitoring QED_MCP_IN_PROCESSING_BIT.

Signed-off-by: Pravin Kumar Ganesh Dhende <pdhende@marvell.com>
Signed-off-by: Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c |  3 ++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 42 +++++++++++++++++++++--
 drivers/net/ethernet/qlogic/qed/qed_mcp.h |  8 +++++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index cc4ec2bb36db..672480c9d195 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3098,6 +3098,9 @@ int qed_hw_init(struct qed_dev *cdev, struct qed_hw_init_params *p_params)
 			continue;
 		}
 
+		/* Some flows may keep variable set */
+		p_hwfn->mcp_info->mcp_handling_status = 0;
+
 		rc = qed_calc_hw_mode(p_hwfn);
 		if (rc)
 			return rc;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index b3811ad4bcf0..9fb1fa479d4b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -140,7 +140,7 @@ static struct qed_mcp_cmd_elem *qed_mcp_cmd_get_elem(struct qed_hwfn *p_hwfn,
 int qed_mcp_free(struct qed_hwfn *p_hwfn)
 {
 	if (p_hwfn->mcp_info) {
-		struct qed_mcp_cmd_elem *p_cmd_elem, *p_tmp;
+		struct qed_mcp_cmd_elem *p_cmd_elem = NULL, *p_tmp;
 
 		kfree(p_hwfn->mcp_info->mfw_mb_cur);
 		kfree(p_hwfn->mcp_info->mfw_mb_shadow);
@@ -249,6 +249,7 @@ int qed_mcp_cmd_init(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	/* Initialize the MFW spinlock */
 	spin_lock_init(&p_info->cmd_lock);
 	spin_lock_init(&p_info->link_lock);
+	spin_lock_init(&p_info->unload_lock);
 
 	INIT_LIST_HEAD(&p_info->cmd_list);
 
@@ -1095,10 +1096,15 @@ int qed_mcp_load_done(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	return 0;
 }
 
+#define MFW_COMPLETION_MAX_ITER 5000
+#define MFW_COMPLETION_INTERVAL_MS 1
+
 int qed_mcp_unload_req(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
 	struct qed_mcp_mb_params mb_params;
+	u32 cnt = MFW_COMPLETION_MAX_ITER;
 	u32 wol_param;
+	int rc;
 
 	switch (p_hwfn->cdev->wol_config) {
 	case QED_OV_WOL_DISABLED:
@@ -1121,7 +1127,23 @@ int qed_mcp_unload_req(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	mb_params.param = wol_param;
 	mb_params.flags = QED_MB_FLAG_CAN_SLEEP | QED_MB_FLAG_AVOID_BLOCK;
 
-	return qed_mcp_cmd_and_union(p_hwfn, p_ptt, &mb_params);
+	spin_lock_bh(&p_hwfn->mcp_info->unload_lock);
+	set_bit(QED_MCP_BYPASS_PROC_BIT,
+		&p_hwfn->mcp_info->mcp_handling_status);
+	spin_unlock_bh(&p_hwfn->mcp_info->unload_lock);
+
+	rc = qed_mcp_cmd_and_union(p_hwfn, p_ptt, &mb_params);
+
+	while (test_bit(QED_MCP_IN_PROCESSING_BIT,
+			&p_hwfn->mcp_info->mcp_handling_status) && --cnt)
+		msleep(MFW_COMPLETION_INTERVAL_MS);
+
+	if (!cnt)
+		DP_NOTICE(p_hwfn,
+			  "Failed to wait MFW event completion after %d msec\n",
+			  MFW_COMPLETION_MAX_ITER * MFW_COMPLETION_INTERVAL_MS);
+
+	return rc;
 }
 
 int qed_mcp_unload_done(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
@@ -2021,6 +2043,19 @@ int qed_mcp_handle_events(struct qed_hwfn *p_hwfn,
 			   "Msg [%d] - old CMD 0x%02x, new CMD 0x%02x\n",
 			   i, info->mfw_mb_shadow[i], info->mfw_mb_cur[i]);
 
+		spin_lock_bh(&p_hwfn->mcp_info->unload_lock);
+		if (test_bit(QED_MCP_BYPASS_PROC_BIT,
+			     &p_hwfn->mcp_info->mcp_handling_status)) {
+			spin_unlock_bh(&p_hwfn->mcp_info->unload_lock);
+			DP_INFO(p_hwfn,
+				"Msg [%d] is bypassed on unload flow\n", i);
+			continue;
+		}
+
+		set_bit(QED_MCP_IN_PROCESSING_BIT,
+			&p_hwfn->mcp_info->mcp_handling_status);
+		spin_unlock_bh(&p_hwfn->mcp_info->unload_lock);
+
 		switch (i) {
 		case MFW_DRV_MSG_LINK_CHANGE:
 			qed_mcp_handle_link_change(p_hwfn, p_ptt, false);
@@ -2074,6 +2109,9 @@ int qed_mcp_handle_events(struct qed_hwfn *p_hwfn,
 			DP_INFO(p_hwfn, "Unimplemented MFW message %d\n", i);
 			rc = -EINVAL;
 		}
+
+		clear_bit(QED_MCP_IN_PROCESSING_BIT,
+			  &p_hwfn->mcp_info->mcp_handling_status);
 	}
 
 	/* ACK everything */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 2f26bee54e6c..9bd0565fe8ab 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -788,6 +788,14 @@ struct qed_mcp_info {
 
 	/* S/N for debug data mailbox commands */
 	atomic_t dbg_data_seq;
+
+	/* Spinlock used to sync the flag mcp_handling_status with
+	 * the mfw events handler
+	 */
+	spinlock_t unload_lock;
+	unsigned long mcp_handling_status;
+#define QED_MCP_BYPASS_PROC_BIT 0
+#define QED_MCP_IN_PROCESSING_BIT       1
 };
 
 struct qed_mcp_mb_params {
-- 
2.27.0

