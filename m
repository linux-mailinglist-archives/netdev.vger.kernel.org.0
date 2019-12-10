Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D0F119A76
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLJV4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:56:34 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62242 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726417AbfLJV4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:56:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBALuNEo018145;
        Tue, 10 Dec 2019 13:56:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ZoIpr7pEGnYCdv4Z+GTqycWOf3RsV8OZOAEh9ntwu00=;
 b=UiXgTfZYtnqO2xKMtrz2eSYNSm3ndTugqfGJfL7J/qMH07Ro3qmXD4TVaPCnU2J8JF3c
 8sCIcgqmh2J4TamFzmNPIOUZk59tkR6eQZE8qdIHHAUDysvIpuNFMPU1+LJr7GnGryPz
 UOB6V6H5uvuSUSOz+/ySQ33Wck7Mb5l0mxQhCOnJfH8g4xtmLQkSA/nY8Hidbdj1Kn2z
 +t+Z0S3jzZj/O2Vg0Lb/JjxfxmQfZ9LLUhB9qV7rvWqId/vrHGhi1fvQkjmPxxJc/028
 yj9iBLMRqSsj0PdqI/EOE2C0GL+2UY00Qe2oHaHDjmsvj85iWOLk0wzwDsVM6xB3hmGF Iw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wtbqg28h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 13:56:31 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 10 Dec
 2019 13:56:29 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 10 Dec 2019 13:56:29 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2F9893F703F;
        Tue, 10 Dec 2019 13:56:29 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBALuTCv023991;
        Tue, 10 Dec 2019 13:56:29 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBALuTSK023990;
        Tue, 10 Dec 2019 13:56:29 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH net 1/2] bnx2x: Do not handle requests from VFs after parity
Date:   Tue, 10 Dec 2019 13:56:22 -0800
Message-ID: <20191210215623.23950-2-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191210215623.23950-1-manishc@marvell.com>
References: <20191210215623.23950-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_07:2019-12-10,2019-12-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parity error from the hardware will cause PF to lose the state
of their VFs due to PF's internal reload and hardware reset following
the parity error. Restrict any configuration request from the VFs after
the parity as it could cause unexpected hardware behavior, only way
for VFs to recover would be to trigger FLR on VFs and reload them.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 11 +++++++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  | 12 ++++++++++++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 192ff8d5da32..119e5135f090 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -9976,9 +9976,16 @@ static void bnx2x_recovery_failed(struct bnx2x *bp)
  */
 static void bnx2x_parity_recover(struct bnx2x *bp)
 {
-	bool global = false;
 	u32 error_recovered, error_unrecovered;
-	bool is_parity;
+	bool is_parity, global = false;
+	int vf_idx;
+
+	for (vf_idx = 0; vf_idx < bp->requested_nr_virtfn; vf_idx++) {
+		struct bnx2x_virtf *vf = BP_VF(bp, vf_idx);
+
+		if (vf)
+			vf->state = VF_LOST;
+	}
 
 	DP(NETIF_MSG_HW, "Handling parity\n");
 	while (1) {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
index b6ebd92ec565..3a716c015415 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
@@ -139,6 +139,7 @@ struct bnx2x_virtf {
 #define VF_ACQUIRED	1	/* VF acquired, but not initialized */
 #define VF_ENABLED	2	/* VF Enabled */
 #define VF_RESET	3	/* VF FLR'd, pending cleanup */
+#define VF_LOST		4	/* Recovery while VFs are loaded */
 
 	bool flr_clnup_stage;	/* true during flr cleanup */
 	bool malicious;		/* true if FW indicated so, until FLR */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
index 0752b7fa4d9c..ea0e9394f898 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
@@ -2107,6 +2107,18 @@ static void bnx2x_vf_mbx_request(struct bnx2x *bp, struct bnx2x_virtf *vf,
 {
 	int i;
 
+	if (vf->state == VF_LOST) {
+		/* Just ack the FW and return if VFs are lost
+		 * in case of parity error. VFs are supposed to be timedout
+		 * on waiting for PF response.
+		 */
+		DP(BNX2X_MSG_IOV,
+		   "VF 0x%x lost, not handling the request\n", vf->abs_vfid);
+
+		storm_memset_vf_mbx_ack(bp, vf->abs_vfid);
+		return;
+	}
+
 	/* check if tlv type is known */
 	if (bnx2x_tlv_supported(mbx->first_tlv.tl.type)) {
 		/* Lock the per vf op mutex and note the locker's identity.
-- 
2.18.1

