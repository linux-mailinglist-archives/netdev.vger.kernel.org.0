Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DAE1C6F6E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgEFLeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:34:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6272 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727937AbgEFLeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:34:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BXTbE030247;
        Wed, 6 May 2020 04:34:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=OlAJk6XqUIfLA9WTTqZUXtTPpoTIe5fzPl+gbkqHcL8=;
 b=gw7kOvEpzJcrTdzSKs4JGx56+B1w125Y75Y0FVG8VqharhAppz7a0PrdTKdfiPeIOAqQ
 IH+cT2ywmh7FdsSFHIPNMMOPl60Rc9lrFCsWISsQ/2rTddN8XDY/AHiVOHvLp1lQXF9V
 RWnjOsgQlZenUmsLV6iTaKuqBJR1/7+5oVOMJdRT9qTD5CuCyB778Ic7RoUSNfnc13up
 lZfEYk7qUl1ajGvTkdOtjEfwltG0VWFdyrkyP2lMK2r/rLgf+P90BppiKKNigGJIOiMw
 D6m7QStlIbdDRrEFRjmzw1z9BCN2Pxd1xaqB53CokQaw1gp01K/ymbYDm9vcRwvJwM6o Uw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30urytrs58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:34:18 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:34:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 May 2020 04:34:16 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id C0D6E3F7041;
        Wed,  6 May 2020 04:34:13 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 10/12] net: qed: introduce critical fan failure handler
Date:   Wed, 6 May 2020 14:33:12 +0300
Message-ID: <8eb207cb6dcf136b32ed3b29835fa74cb0fee41d.1588758463.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588758463.git.irusskikh@marvell.com>
References: <cover.1588758463.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_05:2020-05-05,2020-05-06 signatures=0
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
2.25.1

