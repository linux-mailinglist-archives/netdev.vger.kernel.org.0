Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423F01D2BFF
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 11:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgENJ61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 05:58:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31564 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgENJ6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 05:58:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04E9uAvc028883;
        Thu, 14 May 2020 02:58:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Eo4DTD+tFI8Tjq79pERqA0P3Xetpc/u04JjpjVh9HsE=;
 b=TD2nt9fedGmXUhAxWlcWgshpBKROnH+3VshIL8UrXUmvbjt/Ps6zDdRwtbjp3U9x1YHz
 EB3lke+plD9fNL6n/DlGrENYv4vwmClTa2fIKpbRiWE8OpKJW2k+5r2XrOquPd2y2gqG
 4v6aVl7INB3X6srt30v7SKTI0MOw1peQi1gwvRBbbyyrhK5Nn+NhZ4vrYcgQoda4i9Oh
 DP5cUWEuVQeBeKIGAakNVw8umcXPRJFmA85u811q3lzefMsecmt3hlc6S7ocyLf14V1C
 Ap53vQo8yXbYqo12JfzKQYeVH/aEXpl9hmTALpzlqjIhG75x0ABpRuHA06NNJrJ0xQKm Fg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3100xk1qx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 02:58:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 02:58:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 02:58:20 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 83A263F703F;
        Thu, 14 May 2020 02:58:17 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        "Michal Kalderon" <michal.kalderon@marvell.com>
Subject: [PATCH v2 net-next 09/11] net: qed: introduce critical fan failure handler
Date:   Thu, 14 May 2020 12:57:25 +0300
Message-ID: <20200514095727.1361-10-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514095727.1361-1-irusskikh@marvell.com>
References: <20200514095727.1361-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_02:2020-05-13,2020-05-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fan failure is sent by firmware, driver reacts on this error with
newly introduced notification path. It will collect dump and shut down
the device to prevent physical breakage

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 21d53b00c2e6..ab042b835797 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -12761,7 +12761,7 @@ enum MFW_DRV_MSG_TYPE {
 	MFW_DRV_MSG_GET_FCOE_STATS,
 	MFW_DRV_MSG_GET_ISCSI_STATS,
 	MFW_DRV_MSG_GET_RDMA_STATS,
-	MFW_DRV_MSG_BW_UPDATE10,
+	MFW_DRV_MSG_FAILURE_DETECTED,
 	MFW_DRV_MSG_TRANSCEIVER_STATE_CHANGE,
 	MFW_DRV_MSG_BW_UPDATE11,
 	MFW_DRV_MSG_RESERVED,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 62be13d49dd8..0058e804efc3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -1706,6 +1706,17 @@ static void qed_mcp_update_stag(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 		    &resp, &param);
 }
 
+static void qed_mcp_handle_fan_failure(struct qed_hwfn *p_hwfn,
+				       struct qed_ptt *p_ptt)
+{
+	/* A single notification should be sent to upper driver in CMT mode */
+	if (p_hwfn != QED_LEADING_HWFN(p_hwfn->cdev))
+		return;
+
+	qed_hw_err_notify(p_hwfn, p_ptt, QED_HW_ERR_FAN_FAIL,
+			  "Fan failure was detected on the network interface card and it's going to be shut down.\n");
+}
+
 void qed_mcp_read_ufp_config(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
 	struct public_func shmem_info;
@@ -1852,6 +1863,9 @@ int qed_mcp_handle_events(struct qed_hwfn *p_hwfn,
 		case MFW_DRV_MSG_S_TAG_UPDATE:
 			qed_mcp_update_stag(p_hwfn, p_ptt);
 			break;
+		case MFW_DRV_MSG_FAILURE_DETECTED:
+			qed_mcp_handle_fan_failure(p_hwfn, p_ptt);
+			break;
 		case MFW_DRV_MSG_GET_TLV_REQ:
 			qed_mfw_tlv_req(p_hwfn);
 			break;
-- 
2.17.1

