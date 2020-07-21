Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCB8228272
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 16:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgGUOmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 10:42:10 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8466 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729353AbgGUOmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 10:42:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LEe4HJ002024;
        Tue, 21 Jul 2020 07:42:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=soOISmrN6AihBedCSNqv6UBc+tUvnI41br1BaxY4uRY=;
 b=Ol35WKBBqI8tmRc8P89Tb0K3+NOVRWJLv8vQN1MdyB0PbmPyqPNOZSPeTf/dSSo513Tc
 Z5iHHHz9oOpccm1DOFfXgk5B0EXgzs/lOYDac5m9BNhC3hGuORVwcPR/b9fQb31SgKWM
 dJY4G5sbWwB3tCDYnJa29O/lxt0D0GTpqHD5WMK6KBWFBOQsZ25czfVvalIgSmCR/qfQ
 3Nsp04e9kImTxF6WvDos/3LvKMva31ja2JW25tUyI/RptLNn8vyjGpqjE35D1hBpijnw
 GAVah6GriNeV9jynkzewSJ/Kn0mt3rGjVWVPn3G7TnX6x0Mzvjj87cazTOiMXuXnkh+f +g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxenm0pd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 07:42:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jul
 2020 07:42:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jul
 2020 07:42:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 07:42:03 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 2318C3F703F;
        Tue, 21 Jul 2020 07:41:59 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Tomer Tayar" <tomer.tayar@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 2/2] qed: suppress false-positives interrupt error messages on HW init
Date:   Tue, 21 Jul 2020 17:41:43 +0300
Message-ID: <20200721144143.379-3-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721144143.379-1-alobakin@marvell.com>
References: <20200721144143.379-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_09:2020-07-21,2020-07-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was found that qed_pglueb_rbc_attn_handler() can produce a lot of
false-positive error detections on driver load/reload (especially after
crashes/recoveries) and spam the kernel log:

[    4.958275] [qed_pglueb_rbc_attn_handler:324()]ICPL error - 00d00ff0
[ 2079.146764] [qed_pglueb_rbc_attn_handler:324()]ICPL error - 00d80ff0
[ 2116.374631] [qed_pglueb_rbc_attn_handler:324()]ICPL error - 00d80ff0
[ 2135.250564] [qed_pglueb_rbc_attn_handler:324()]ICPL error - 00d80ff0
[...]

Reduce the logging level of two false-positive prone error messages from
notice to verbose on initialization (only) to not mix it with real error
attentions while debugging.

Fixes: 666db4862f2d ("qed: Revise load sequence to avoid PCI errors")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c | 50 +++++++++++++----------
 drivers/net/ethernet/qlogic/qed/qed_int.h |  4 +-
 3 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 9c26fde663b3..dbdac983ccde 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3102,7 +3102,7 @@ int qed_hw_init(struct qed_dev *cdev, struct qed_hw_init_params *p_params)
 		}
 
 		/* Log and clear previous pglue_b errors if such exist */
-		qed_pglueb_rbc_attn_handler(p_hwfn, p_hwfn->p_main_ptt);
+		qed_pglueb_rbc_attn_handler(p_hwfn, p_hwfn->p_main_ptt, true);
 
 		/* Enable the PF's internal FID_enable in the PXP */
 		rc = qed_pglueb_set_pfid_enable(p_hwfn, p_hwfn->p_main_ptt,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 7e13a9d9b89c..5eec1fc6229d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -257,9 +257,10 @@ static int qed_grc_attn_cb(struct qed_hwfn *p_hwfn)
 #define PGLUE_ATTENTION_ZLR_VALID		(1 << 25)
 #define PGLUE_ATTENTION_ILT_VALID		(1 << 23)
 
-int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn,
-				struct qed_ptt *p_ptt)
+int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+				bool hw_init)
 {
+	char msg[256];
 	u32 tmp;
 
 	tmp = qed_rd(p_hwfn, p_ptt, PGLUE_B_REG_TX_ERR_WR_DETAILS2);
@@ -273,22 +274,23 @@ int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn,
 		details = qed_rd(p_hwfn, p_ptt,
 				 PGLUE_B_REG_TX_ERR_WR_DETAILS);
 
-		DP_NOTICE(p_hwfn,
-			  "Illegal write by chip to [%08x:%08x] blocked.\n"
-			  "Details: %08x [PFID %02x, VFID %02x, VF_VALID %02x]\n"
-			  "Details2 %08x [Was_error %02x BME deassert %02x FID_enable deassert %02x]\n",
-			  addr_hi, addr_lo, details,
-			  (u8)GET_FIELD(details, PGLUE_ATTENTION_DETAILS_PFID),
-			  (u8)GET_FIELD(details, PGLUE_ATTENTION_DETAILS_VFID),
-			  GET_FIELD(details,
-				    PGLUE_ATTENTION_DETAILS_VF_VALID) ? 1 : 0,
-			  tmp,
-			  GET_FIELD(tmp,
-				    PGLUE_ATTENTION_DETAILS2_WAS_ERR) ? 1 : 0,
-			  GET_FIELD(tmp,
-				    PGLUE_ATTENTION_DETAILS2_BME) ? 1 : 0,
-			  GET_FIELD(tmp,
-				    PGLUE_ATTENTION_DETAILS2_FID_EN) ? 1 : 0);
+		snprintf(msg, sizeof(msg),
+			 "Illegal write by chip to [%08x:%08x] blocked.\n"
+			 "Details: %08x [PFID %02x, VFID %02x, VF_VALID %02x]\n"
+			 "Details2 %08x [Was_error %02x BME deassert %02x FID_enable deassert %02x]",
+			 addr_hi, addr_lo, details,
+			 (u8)GET_FIELD(details, PGLUE_ATTENTION_DETAILS_PFID),
+			 (u8)GET_FIELD(details, PGLUE_ATTENTION_DETAILS_VFID),
+			 !!GET_FIELD(details, PGLUE_ATTENTION_DETAILS_VF_VALID),
+			 tmp,
+			 !!GET_FIELD(tmp, PGLUE_ATTENTION_DETAILS2_WAS_ERR),
+			 !!GET_FIELD(tmp, PGLUE_ATTENTION_DETAILS2_BME),
+			 !!GET_FIELD(tmp, PGLUE_ATTENTION_DETAILS2_FID_EN));
+
+		if (hw_init)
+			DP_VERBOSE(p_hwfn, NETIF_MSG_INTR, "%s\n", msg);
+		else
+			DP_NOTICE(p_hwfn, "%s\n", msg);
 	}
 
 	tmp = qed_rd(p_hwfn, p_ptt, PGLUE_B_REG_TX_ERR_RD_DETAILS2);
@@ -321,8 +323,14 @@ int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn,
 	}
 
 	tmp = qed_rd(p_hwfn, p_ptt, PGLUE_B_REG_TX_ERR_WR_DETAILS_ICPL);
-	if (tmp & PGLUE_ATTENTION_ICPL_VALID)
-		DP_NOTICE(p_hwfn, "ICPL error - %08x\n", tmp);
+	if (tmp & PGLUE_ATTENTION_ICPL_VALID) {
+		snprintf(msg, sizeof(msg), "ICPL error - %08x", tmp);
+
+		if (hw_init)
+			DP_VERBOSE(p_hwfn, NETIF_MSG_INTR, "%s\n", msg);
+		else
+			DP_NOTICE(p_hwfn, "%s\n", msg);
+	}
 
 	tmp = qed_rd(p_hwfn, p_ptt, PGLUE_B_REG_MASTER_ZLR_ERR_DETAILS);
 	if (tmp & PGLUE_ATTENTION_ZLR_VALID) {
@@ -361,7 +369,7 @@ int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn,
 
 static int qed_pglueb_rbc_attn_cb(struct qed_hwfn *p_hwfn)
 {
-	return qed_pglueb_rbc_attn_handler(p_hwfn, p_hwfn->p_dpc_ptt);
+	return qed_pglueb_rbc_attn_handler(p_hwfn, p_hwfn->p_dpc_ptt, false);
 }
 
 static int qed_fw_assertion(struct qed_hwfn *p_hwfn)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.h b/drivers/net/ethernet/qlogic/qed/qed_int.h
index e09db3386367..110169e90121 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.h
@@ -442,7 +442,7 @@ int qed_int_set_timer_res(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 
 #define QED_MAPPING_MEMORY_SIZE(dev)	(NUM_OF_SBS(dev))
 
-int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn,
-				struct qed_ptt *p_ptt);
+int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+				bool hw_init);
 
 #endif
-- 
2.25.1

