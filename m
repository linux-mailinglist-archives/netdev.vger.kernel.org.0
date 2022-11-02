Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46A3615976
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 04:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiKBDL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 23:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKBDLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 23:11:42 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27FB23EAF;
        Tue,  1 Nov 2022 20:11:32 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A233dg6016728;
        Tue, 1 Nov 2022 20:11:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=M48BniECihiJTWmrPFQ73kv33y8HXTUYbw9MraqI6P0=;
 b=RO5SlX0y4l93gW2Vdp4v0sc7Dn8HJV/C7V5n/hq72ZXzvv4eR5ONDa0jUQyV6xo8kxca
 M1NZYSQeUMPp2P7C25Zq7QwFPM7ZsPoB0WiSd6s39nugoVW5WlkyImafl20o0V2IsTlV
 4rJkAY92RdgPiVFG+SnfigyjaAxFsfc3l9d+u07HkbNw4NjKv9nwDrnHBdb7viOBafVs
 dDzjSdnik+ijyR+hsuLaJMkR2qapGv9ZSvIork/m3unDLZ36xMKtJ6ggjWyeLUZ5ZBkg
 HNx6Updk5wUO7z/mp9IAPNQ1lgu249cAf/CLx+ZiRpNzwDIGtdC6LTtaTnVP17VVHpNL oA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kkgacg0nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 20:11:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Nov
 2022 20:11:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Nov 2022 20:11:22 -0700
Received: from localhost.localdomain (unknown [10.28.36.165])
        by maili.marvell.com (Postfix) with ESMTP id 56FDB3F705D;
        Tue,  1 Nov 2022 20:11:20 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <sgoutham@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net PATCH] octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]
Date:   Wed, 2 Nov 2022 08:41:13 +0530
Message-ID: <20221102031113.1919861-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: KCFDgeRmBNXxwxZDXf7fvcr_uPzqQ0ZD
X-Proofpoint-ORIG-GUID: KCFDgeRmBNXxwxZDXf7fvcr_uPzqQ0ZD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_12,2022-11-01_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In scenarios where multiple errors have occurred
for a SQ before SW starts handling error interrupt,
SQ_CTX[OP_INT] may get overwritten leading to
NIX_LF_SQ_OP_INT returning incorrect value.
To workaround this read LMT, MNQ and SQ individual
error status registers to determine the cause of error.

Fixes: 4ff7d1488a84 ("octeontx2-pf: Error handling support")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 135 ++++++++++++++----
 .../marvell/octeontx2/nic/otx2_struct.h       |  57 ++++++++
 2 files changed, 162 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 892ca88e0cf4..303930499a4c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -15,6 +15,7 @@
 #include <net/ip.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <linux/bitfield.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -1171,6 +1172,59 @@ int otx2_set_real_num_queues(struct net_device *netdev,
 }
 EXPORT_SYMBOL(otx2_set_real_num_queues);
 
+static char *nix_sqoperr_e_str[NIX_SQOPERR_MAX] = {
+	"NIX_SQOPERR_OOR",
+	"NIX_SQOPERR_CTX_FAULT",
+	"NIX_SQOPERR_CTX_POISON",
+	"NIX_SQOPERR_DISABLED",
+	"NIX_SQOPERR_SIZE_ERR",
+	"NIX_SQOPERR_OFLOW",
+	"NIX_SQOPERR_SQB_NULL",
+	"NIX_SQOPERR_SQB_FAULT",
+	"NIX_SQOPERR_SQE_SZ_ZERO",
+};
+
+static char *nix_mnqerr_e_str[NIX_MNQERR_MAX] = {
+	"NIX_MNQERR_SQ_CTX_FAULT",
+	"NIX_MNQERR_SQ_CTX_POISON",
+	"NIX_MNQERR_SQB_FAULT",
+	"NIX_MNQERR_SQB_POISON",
+	"NIX_MNQERR_TOTAL_ERR",
+	"NIX_MNQERR_LSO_ERR",
+	"NIX_MNQERR_CQ_QUERY_ERR",
+	"NIX_MNQERR_MAX_SQE_SIZE_ERR",
+	"NIX_MNQERR_MAXLEN_ERR",
+	"NIX_MNQERR_SQE_SIZEM1_ZERO",
+};
+
+static char *nix_snd_status_e_str[NIX_SND_STATUS_MAX] =  {
+	"NIX_SND_STATUS_GOOD",
+	"NIX_SND_STATUS_SQ_CTX_FAULT",
+	"NIX_SND_STATUS_SQ_CTX_POISON",
+	"NIX_SND_STATUS_SQB_FAULT",
+	"NIX_SND_STATUS_SQB_POISON",
+	"NIX_SND_STATUS_HDR_ERR",
+	"NIX_SND_STATUS_EXT_ERR",
+	"NIX_SND_STATUS_JUMP_FAULT",
+	"NIX_SND_STATUS_JUMP_POISON",
+	"NIX_SND_STATUS_CRC_ERR",
+	"NIX_SND_STATUS_IMM_ERR",
+	"NIX_SND_STATUS_SG_ERR",
+	"NIX_SND_STATUS_MEM_ERR",
+	"NIX_SND_STATUS_INVALID_SUBDC",
+	"NIX_SND_STATUS_SUBDC_ORDER_ERR",
+	"NIX_SND_STATUS_DATA_FAULT",
+	"NIX_SND_STATUS_DATA_POISON",
+	"NIX_SND_STATUS_NPC_DROP_ACTION",
+	"NIX_SND_STATUS_LOCK_VIOL",
+	"NIX_SND_STATUS_NPC_UCAST_CHAN_ERR",
+	"NIX_SND_STATUS_NPC_MCAST_CHAN_ERR",
+	"NIX_SND_STATUS_NPC_MCAST_ABORT",
+	"NIX_SND_STATUS_NPC_VTAG_PTR_ERR",
+	"NIX_SND_STATUS_NPC_VTAG_SIZE_ERR",
+	"NIX_SND_STATUS_SEND_STATS_ERR",
+};
+
 static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 {
 	struct otx2_nic *pf = data;
@@ -1204,46 +1258,67 @@ static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 
 	/* SQ */
 	for (qidx = 0; qidx < pf->hw.tot_tx_queues; qidx++) {
+		u64 sq_op_err_dbg, mnq_err_dbg, snd_err_dbg;
+		u8 sq_op_err_code, mnq_err_code, snd_err_code;
+
+		/* Below debug registers captures first errors corresponding to
+		 * those registers. We don't have to check against SQ qid as
+		 * these are fatal errors.
+		 */
+
 		ptr = otx2_get_regaddr(pf, NIX_LF_SQ_OP_INT);
 		val = otx2_atomic64_add((qidx << 44), ptr);
 		otx2_write64(pf, NIX_LF_SQ_OP_INT, (qidx << 44) |
 			     (val & NIX_SQINT_BITS));
 
-		if (!(val & (NIX_SQINT_BITS | BIT_ULL(42))))
-			continue;
-
 		if (val & BIT_ULL(42)) {
 			netdev_err(pf->netdev, "SQ%lld: error reading NIX_LF_SQ_OP_INT, NIX_LF_ERR_INT 0x%llx\n",
 				   qidx, otx2_read64(pf, NIX_LF_ERR_INT));
-		} else {
-			if (val & BIT_ULL(NIX_SQINT_LMT_ERR)) {
-				netdev_err(pf->netdev, "SQ%lld: LMT store error NIX_LF_SQ_OP_ERR_DBG:0x%llx",
-					   qidx,
-					   otx2_read64(pf,
-						       NIX_LF_SQ_OP_ERR_DBG));
-				otx2_write64(pf, NIX_LF_SQ_OP_ERR_DBG,
-					     BIT_ULL(44));
-			}
-			if (val & BIT_ULL(NIX_SQINT_MNQ_ERR)) {
-				netdev_err(pf->netdev, "SQ%lld: Meta-descriptor enqueue error NIX_LF_MNQ_ERR_DGB:0x%llx\n",
-					   qidx,
-					   otx2_read64(pf, NIX_LF_MNQ_ERR_DBG));
-				otx2_write64(pf, NIX_LF_MNQ_ERR_DBG,
-					     BIT_ULL(44));
-			}
-			if (val & BIT_ULL(NIX_SQINT_SEND_ERR)) {
-				netdev_err(pf->netdev, "SQ%lld: Send error, NIX_LF_SEND_ERR_DBG 0x%llx",
-					   qidx,
-					   otx2_read64(pf,
-						       NIX_LF_SEND_ERR_DBG));
-				otx2_write64(pf, NIX_LF_SEND_ERR_DBG,
-					     BIT_ULL(44));
-			}
-			if (val & BIT_ULL(NIX_SQINT_SQB_ALLOC_FAIL))
-				netdev_err(pf->netdev, "SQ%lld: SQB allocation failed",
-					   qidx);
+			goto done;
 		}
 
+		sq_op_err_dbg = otx2_read64(pf, NIX_LF_SQ_OP_ERR_DBG);
+		if (!(sq_op_err_dbg & BIT(44)))
+			goto chk_mnq_err_dbg;
+
+		sq_op_err_code = FIELD_GET(GENMASK(7, 0), sq_op_err_dbg);
+		netdev_err(pf->netdev, "SQ%lld: NIX_LF_SQ_OP_ERR_DBG(%llx)  err=%s\n",
+			   qidx, sq_op_err_dbg, nix_sqoperr_e_str[sq_op_err_code]);
+
+		otx2_write64(pf, NIX_LF_SQ_OP_ERR_DBG, BIT_ULL(44));
+
+		if (sq_op_err_code == NIX_SQOPERR_SQB_NULL)
+			goto chk_mnq_err_dbg;
+
+		/* Err is not NIX_SQOPERR_SQB_NULL, call aq function to read SQ structure.
+		 * TODO: But we are in irq context. How to call mbox functions which does sleep
+		 */
+
+chk_mnq_err_dbg:
+		mnq_err_dbg = otx2_read64(pf, NIX_LF_MNQ_ERR_DBG);
+		if (!(mnq_err_dbg & BIT(44)))
+			goto chk_snd_err_dbg;
+
+		mnq_err_code = FIELD_GET(GENMASK(7, 0), mnq_err_dbg);
+		netdev_err(pf->netdev, "SQ%lld: NIX_LF_MNQ_ERR_DBG(%llx)  err=%s\n",
+			   qidx, mnq_err_dbg,  nix_mnqerr_e_str[mnq_err_code]);
+		otx2_write64(pf, NIX_LF_MNQ_ERR_DBG, BIT_ULL(44));
+
+chk_snd_err_dbg:
+		snd_err_dbg = otx2_read64(pf, NIX_LF_SEND_ERR_DBG);
+		if (snd_err_dbg & BIT(44)) {
+			snd_err_code = FIELD_GET(GENMASK(7, 0), snd_err_dbg);
+			netdev_err(pf->netdev, "SQ%lld: NIX_LF_SND_ERR_DBG:0x%llx err=%s\n",
+				   qidx, snd_err_dbg, nix_snd_status_e_str[snd_err_code]);
+			otx2_write64(pf, NIX_LF_SEND_ERR_DBG, BIT_ULL(44));
+		}
+
+done:
+		/* Print values and reset */
+		if (val & BIT_ULL(NIX_SQINT_SQB_ALLOC_FAIL))
+			netdev_err(pf->netdev, "SQ%lld: SQB allocation failed",
+				   qidx);
+
 		schedule_work(&pf->reset_task);
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index aa205a0d158f..fa37b9f312ca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -281,4 +281,61 @@ enum nix_sqint_e {
 			BIT_ULL(NIX_SQINT_SEND_ERR) | \
 			BIT_ULL(NIX_SQINT_SQB_ALLOC_FAIL))
 
+enum nix_sqoperr_e {
+	NIX_SQOPERR_OOR = 0,
+	NIX_SQOPERR_CTX_FAULT = 1,
+	NIX_SQOPERR_CTX_POISON = 2,
+	NIX_SQOPERR_DISABLED = 3,
+	NIX_SQOPERR_SIZE_ERR = 4,
+	NIX_SQOPERR_OFLOW = 5,
+	NIX_SQOPERR_SQB_NULL = 6,
+	NIX_SQOPERR_SQB_FAULT = 7,
+	NIX_SQOPERR_SQE_SZ_ZERO = 8,
+	NIX_SQOPERR_MAX,
+};
+
+enum nix_mnqerr_e {
+	NIX_MNQERR_SQ_CTX_FAULT = 0,
+	NIX_MNQERR_SQ_CTX_POISON = 1,
+	NIX_MNQERR_SQB_FAULT = 2,
+	NIX_MNQERR_SQB_POISON = 3,
+	NIX_MNQERR_TOTAL_ERR = 4,
+	NIX_MNQERR_LSO_ERR = 5,
+	NIX_MNQERR_CQ_QUERY_ERR = 6,
+	NIX_MNQERR_MAX_SQE_SIZE_ERR = 7,
+	NIX_MNQERR_MAXLEN_ERR = 8,
+	NIX_MNQERR_SQE_SIZEM1_ZERO = 9,
+	NIX_MNQERR_MAX,
+};
+
+enum nix_snd_status_e {
+	NIX_SND_STATUS_GOOD = 0x0,
+	NIX_SND_STATUS_SQ_CTX_FAULT = 0x1,
+	NIX_SND_STATUS_SQ_CTX_POISON = 0x2,
+	NIX_SND_STATUS_SQB_FAULT = 0x3,
+	NIX_SND_STATUS_SQB_POISON = 0x4,
+	NIX_SND_STATUS_HDR_ERR = 0x5,
+	NIX_SND_STATUS_EXT_ERR = 0x6,
+	NIX_SND_STATUS_JUMP_FAULT = 0x7,
+	NIX_SND_STATUS_JUMP_POISON = 0x8,
+	NIX_SND_STATUS_CRC_ERR = 0x9,
+	NIX_SND_STATUS_IMM_ERR = 0x10,
+	NIX_SND_STATUS_SG_ERR = 0x11,
+	NIX_SND_STATUS_MEM_ERR = 0x12,
+	NIX_SND_STATUS_INVALID_SUBDC = 0x13,
+	NIX_SND_STATUS_SUBDC_ORDER_ERR = 0x14,
+	NIX_SND_STATUS_DATA_FAULT = 0x15,
+	NIX_SND_STATUS_DATA_POISON = 0x16,
+	NIX_SND_STATUS_NPC_DROP_ACTION = 0x17,
+	NIX_SND_STATUS_LOCK_VIOL = 0x18,
+	NIX_SND_STATUS_NPC_UCAST_CHAN_ERR = 0x19,
+	NIX_SND_STATUS_NPC_MCAST_CHAN_ERR = 0x20,
+	NIX_SND_STATUS_NPC_MCAST_ABORT = 0x21,
+	NIX_SND_STATUS_NPC_VTAG_PTR_ERR = 0x22,
+	NIX_SND_STATUS_NPC_VTAG_SIZE_ERR = 0x23,
+	NIX_SND_STATUS_SEND_MEM_FAULT = 0x24,
+	NIX_SND_STATUS_SEND_STATS_ERR = 0x25,
+	NIX_SND_STATUS_MAX,
+};
+
 #endif /* OTX2_STRUCT_H */
-- 
2.25.1

