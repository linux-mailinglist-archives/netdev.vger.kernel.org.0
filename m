Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2C24A3E60
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 08:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240427AbiAaHyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 02:54:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42186 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234839AbiAaHyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 02:54:36 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20V0rkZ6018867;
        Sun, 30 Jan 2022 23:54:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=i1zgG6gyOjvvK9GUlJzZfZ+9aQ6qDekKL12n5v3sGko=;
 b=F1oX2wv4UyAbTH+7EQUosof6ZGV2D51hSVq+SRjglwEc+p8a5yOQTPKdSd2PnBv3xn1l
 YOK3KUEpCDhjI3mChmglUDUQ+/53HiHgTZYTXhJ2UUFFZE9jMMq2OMH0u5horueiq8PI
 4IS9PIazj9QS3FSftVNBbsGnn4eAnak+3b78NWU7gjMm8Din4OZYgCd+qwH57PEwz2wC
 xTAhdFx2HhPmmlGsMlYik9Sy6WBh2QD7vgZDp0CKwO30LHLwHs7nYjQDcDEpfUSd8Fjh
 ybC3AcuYhh5it72l4M5PoY1UOUS9NELQJdAPy2R2MkU1Qle5SzH2o93F/QvpeTtPtKqX qw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dx1pa14y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 30 Jan 2022 23:54:29 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 30 Jan
 2022 23:54:28 -0800
Received: from ahp-hp.devlab.local (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 30 Jan 2022 23:54:28 -0800
From:   Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: [PATCH net-next 1/1] qed: use msleep() in qed_mcp_cmd() and add qed_mcp_cmd_nosleep() for udelay.
Date:   Sun, 30 Jan 2022 16:52:35 -0800
Message-ID: <20220131005235.1647881-1-vbhavaraju@marvell.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: c8DXeBj1JtPRyyrbbB5pMVMetJOuYUqV
X-Proofpoint-GUID: c8DXeBj1JtPRyyrbbB5pMVMetJOuYUqV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_02,2022-01-28_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change qed_mcp_cmd() to use msleep() (by setting QED_MB_FLAG_CAN_SLEEP
flag) and add new nosleep() version of the api. These api are used to
issue cmds to management fw and the change affects how driver
behaves while waiting for a response/resource.

All sleepable callers of the existing api now use msleep() version. For
non-sleepable callers, the new nosleep() version is explicitly used.

Signed-off-by: Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 48 +++++++++++++++++------
 drivers/net/ethernet/qlogic/qed/qed_mcp.h | 30 +++++++++++++-
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index da1eadabcb41..b3811ad4bcf0 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -614,12 +614,13 @@ static int qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 				      usecs);
 }
 
-int qed_mcp_cmd(struct qed_hwfn *p_hwfn,
-		struct qed_ptt *p_ptt,
-		u32 cmd,
-		u32 param,
-		u32 *o_mcp_resp,
-		u32 *o_mcp_param)
+static int _qed_mcp_cmd(struct qed_hwfn *p_hwfn,
+			struct qed_ptt *p_ptt,
+			u32 cmd,
+			u32 param,
+			u32 *o_mcp_resp,
+			u32 *o_mcp_param,
+			bool can_sleep)
 {
 	struct qed_mcp_mb_params mb_params;
 	int rc;
@@ -627,6 +628,7 @@ int qed_mcp_cmd(struct qed_hwfn *p_hwfn,
 	memset(&mb_params, 0, sizeof(mb_params));
 	mb_params.cmd = cmd;
 	mb_params.param = param;
+	mb_params.flags = can_sleep ? QED_MB_FLAG_CAN_SLEEP : 0;
 
 	rc = qed_mcp_cmd_and_union(p_hwfn, p_ptt, &mb_params);
 	if (rc)
@@ -638,6 +640,28 @@ int qed_mcp_cmd(struct qed_hwfn *p_hwfn,
 	return 0;
 }
 
+int qed_mcp_cmd(struct qed_hwfn *p_hwfn,
+		struct qed_ptt *p_ptt,
+		u32 cmd,
+		u32 param,
+		u32 *o_mcp_resp,
+		u32 *o_mcp_param)
+{
+	return (_qed_mcp_cmd(p_hwfn, p_ptt, cmd, param,
+			     o_mcp_resp, o_mcp_param, true));
+}
+
+int qed_mcp_cmd_nosleep(struct qed_hwfn *p_hwfn,
+			struct qed_ptt *p_ptt,
+			u32 cmd,
+			u32 param,
+			u32 *o_mcp_resp,
+			u32 *o_mcp_param)
+{
+	return (_qed_mcp_cmd(p_hwfn, p_ptt, cmd, param,
+			     o_mcp_resp, o_mcp_param, false));
+}
+
 static int
 qed_mcp_nvm_wr_cmd(struct qed_hwfn *p_hwfn,
 		   struct qed_ptt *p_ptt,
@@ -1728,8 +1752,8 @@ static void qed_mcp_update_bw(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	qed_configure_pf_max_bandwidth(p_hwfn->cdev, p_info->bandwidth_max);
 
 	/* Acknowledge the MFW */
-	qed_mcp_cmd(p_hwfn, p_ptt, DRV_MSG_CODE_BW_UPDATE_ACK, 0, &resp,
-		    &param);
+	qed_mcp_cmd_nosleep(p_hwfn, p_ptt, DRV_MSG_CODE_BW_UPDATE_ACK, 0, &resp,
+			    &param);
 }
 
 static void qed_mcp_update_stag(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
@@ -1766,8 +1790,8 @@ static void qed_mcp_update_stag(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 		   p_hwfn->mcp_info->func_info.ovlan, p_hwfn->hw_info.hw_mode);
 
 	/* Acknowledge the MFW */
-	qed_mcp_cmd(p_hwfn, p_ptt, DRV_MSG_CODE_S_TAG_UPDATE_ACK, 0,
-		    &resp, &param);
+	qed_mcp_cmd_nosleep(p_hwfn, p_ptt, DRV_MSG_CODE_S_TAG_UPDATE_ACK, 0,
+			    &resp, &param);
 }
 
 static void qed_mcp_handle_fan_failure(struct qed_hwfn *p_hwfn,
@@ -3675,8 +3699,8 @@ static int qed_mcp_resource_cmd(struct qed_hwfn *p_hwfn,
 {
 	int rc;
 
-	rc = qed_mcp_cmd(p_hwfn, p_ptt, DRV_MSG_CODE_RESOURCE_CMD, param,
-			 p_mcp_resp, p_mcp_param);
+	rc = qed_mcp_cmd_nosleep(p_hwfn, p_ptt, DRV_MSG_CODE_RESOURCE_CMD,
+				 param, p_mcp_resp, p_mcp_param);
 	if (rc)
 		return rc;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 369e1892450a..2f26bee54e6c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -393,11 +393,12 @@ int qed_mcp_get_board_config(struct qed_hwfn *p_hwfn,
 			     struct qed_ptt *p_ptt, u32 *p_board_config);
 
 /**
- * qed_mcp_cmd(): General function for sending commands to the MCP
+ * qed_mcp_cmd(): Sleepable function for sending commands to the MCP
  *                mailbox. It acquire mutex lock for the entire
  *                operation, from sending the request until the MCP
  *                response. Waiting for MCP response will be checked up
- *                to 5 seconds every 5ms.
+ *                to 5 seconds every 10ms. Should not be called from atomic
+ *                context.
  *
  * @p_hwfn: HW device data.
  * @p_ptt: PTT required for register access.
@@ -416,6 +417,31 @@ int qed_mcp_cmd(struct qed_hwfn *p_hwfn,
 		u32 *o_mcp_resp,
 		u32 *o_mcp_param);
 
+/**
+ * qed_mcp_cmd_nosleep(): Function for sending commands to the MCP
+ *                        mailbox. It acquire mutex lock for the entire
+ *                        operation, from sending the request until the MCP
+ *                        response. Waiting for MCP response will be checked up
+ *                        to 5 seconds every 10us. Should be called when sleep
+ *                        is not allowed.
+ *
+ * @p_hwfn: HW device data.
+ * @p_ptt: PTT required for register access.
+ * @cmd: command to be sent to the MCP.
+ * @param: Optional param
+ * @o_mcp_resp: The MCP response code (exclude sequence).
+ * @o_mcp_param: Optional parameter provided by the MCP
+ *                     response
+ *
+ * Return: Int - 0 - Operation was successul.
+ */
+int qed_mcp_cmd_nosleep(struct qed_hwfn *p_hwfn,
+			struct qed_ptt *p_ptt,
+			u32 cmd,
+			u32 param,
+			u32 *o_mcp_resp,
+			u32 *o_mcp_param);
+
 /**
  * qed_mcp_drain(): drains the nig, allowing completion to pass in
  *                  case of pauses.
-- 
2.27.0

