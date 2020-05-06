Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BC71C6F66
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgEFLeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:34:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32926 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727804AbgEFLd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:33:59 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BWigc010442;
        Wed, 6 May 2020 04:33:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=qwjTTVoE4Jqx8khSa04h0zg/rUZpB+wKGftm+nPrkFI=;
 b=TPfOI0lWZEkoxC9pJ50zTkqJA8txt+rl2Mu1yr77TY5oaNDPcGtfxWrGmagzh3OdPDQq
 Tqfww7fKPG7Vw8yscWX8dyB8jDUG0MZuMvqIV4scfGXMjWy14i+d5FkN0qVAan9x9trz
 05ugu+M+VqRy0QqXUudPAV/uEbC8tTdZGAdlRTprdU5Wcko6CLuvkrnvM1DHawwTF9hs
 WS8jj/g/q13tUrLxkpjA76P9JL4vzcmIArWnEkiumX3M1x64IYIhBdQR1HaWtppDjT8J
 YrF4nBIVDebXgbY359b0sy2bNpfNqFIrSzo0rQbq2aCnXOv0B+8GXoqu7L8aFdOCVwYC pA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30uaukvqkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:33:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:33:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 May 2020 04:33:56 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 4EE663F7040;
        Wed,  6 May 2020 04:33:54 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 03/12] net: qed: invoke err notify on critical areas
Date:   Wed, 6 May 2020 14:33:05 +0300
Message-ID: <5d3bdaf4999b819d1fb278bd9bbbdad773d98d19.1588758463.git.irusskikh@marvell.com>
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

In a number of critical places not only debug trace should be printed,
but the appropriate hw error condition should be raised and error
handling/recovery should start.

Introduce our new qed_hw_err_notify invocation in these places to
record and indicate critical error conditions in hardware.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c |  4 +++-
 drivers/net/ethernet/qlogic/qed/qed_hw.c  |  7 ++++---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 20 ++++++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_mcp.c |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_spq.c | 16 ++++++++++------
 5 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 7119a18af19e..6e857468e993 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3085,7 +3085,9 @@ int qed_hw_init(struct qed_dev *cdev, struct qed_hw_init_params *p_params)
 			rc = qed_final_cleanup(p_hwfn, p_hwfn->p_main_ptt,
 					       p_hwfn->rel_pf_id, false);
 			if (rc) {
-				DP_NOTICE(p_hwfn, "Final cleanup failed\n");
+				qed_hw_err_notify(p_hwfn, p_hwfn->p_main_ptt,
+						  QED_HW_ERR_RAMROD_FAIL,
+						  "Final cleanup failed\n");
 				goto load_err;
 			}
 		}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.c b/drivers/net/ethernet/qlogic/qed/qed_hw.c
index 90b777019cf5..2d176e1b508c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hw.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_hw.c
@@ -762,9 +762,10 @@ static int qed_dmae_execute_command(struct qed_hwfn *p_hwfn,
 							    dst_type,
 							    length_cur);
 		if (qed_status) {
-			DP_NOTICE(p_hwfn,
-				  "qed_dmae_execute_sub_operation Failed with error 0x%x. source_addr 0x%llx, destination addr 0x%llx, size_in_dwords 0x%x\n",
-				  qed_status, src_addr, dst_addr, length_cur);
+			qed_hw_err_notify(p_hwfn, p_ptt, QED_HW_ERR_DMAE_FAIL,
+					  "qed_dmae_execute_sub_operation Failed with error 0x%x. source_addr 0x%llx, destination addr 0x%llx, size_in_dwords 0x%x\n",
+					  qed_status, src_addr,
+					  dst_addr, length_cur);
 			break;
 		}
 	}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 9f5113639eaf..1b1447b2f059 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -363,6 +363,14 @@ static int qed_pglueb_rbc_attn_cb(struct qed_hwfn *p_hwfn)
 	return qed_pglueb_rbc_attn_handler(p_hwfn, p_hwfn->p_dpc_ptt);
 }
 
+static int qed_fw_assertion(struct qed_hwfn *p_hwfn)
+{
+	qed_hw_err_notify(p_hwfn, p_hwfn->p_dpc_ptt, QED_HW_ERR_FW_ASSERT,
+			  "FW assertion!\n");
+
+	return -EINVAL;
+}
+
 #define QED_DORQ_ATTENTION_REASON_MASK  (0xfffff)
 #define QED_DORQ_ATTENTION_OPAQUE_MASK  (0xffff)
 #define QED_DORQ_ATTENTION_OPAQUE_SHIFT (0x0)
@@ -606,7 +614,8 @@ static struct aeu_invert_reg aeu_descs[NUM_ATTN_REGS] = {
 	{
 		{       /* After Invert 4 */
 			{"General Attention 32", ATTENTION_SINGLE,
-			 NULL, MAX_BLOCK_ID},
+			 qed_fw_assertion,
+			 MAX_BLOCK_ID},
 			{"General Attention %d",
 			 (2 << ATTENTION_LENGTH_SHIFT) |
 			 (33 << ATTENTION_OFFSET_SHIFT), NULL, MAX_BLOCK_ID},
@@ -927,9 +936,12 @@ qed_int_deassertion_aeu_bit(struct qed_hwfn *p_hwfn,
 		qed_int_attn_print(p_hwfn, p_aeu->block_index,
 				   ATTN_TYPE_INTERRUPT, !b_fatal);
 
-
-	/* If the attention is benign, no need to prevent it */
-	if (!rc)
+	/* Reach assertion if attention is fatal */
+	if (b_fatal)
+		qed_hw_err_notify(p_hwfn, p_hwfn->p_dpc_ptt, QED_HW_ERR_HW_ATTN,
+				  "`%s': Fatal attention\n",
+				  p_bit_name);
+	else /* If the attention is benign, no need to prevent it */
 		goto out;
 
 	/* Prevent this Attention from being asserted in the future */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 280527cc0578..46653afc385c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -575,6 +575,8 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		if (!QED_MB_FLAGS_IS_SET(p_mb_params, AVOID_BLOCK))
 			qed_mcp_cmd_set_blocking(p_hwfn, true);
 
+		qed_hw_err_notify(p_hwfn, p_ptt,
+				  QED_HW_ERR_MFW_RESP_FAIL, NULL);
 		return -EAGAIN;
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_spq.c b/drivers/net/ethernet/qlogic/qed/qed_spq.c
index f5f3c03b9dd2..790c28d696a0 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_spq.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_spq.c
@@ -160,12 +160,16 @@ static int qed_spq_block(struct qed_hwfn *p_hwfn,
 		return 0;
 	}
 err:
-	DP_NOTICE(p_hwfn,
-		  "Ramrod is stuck [CID %08x cmd %02x protocol %02x echo %04x]\n",
-		  le32_to_cpu(p_ent->elem.hdr.cid),
-		  p_ent->elem.hdr.cmd_id,
-		  p_ent->elem.hdr.protocol_id,
-		  le16_to_cpu(p_ent->elem.hdr.echo));
+	p_ptt = qed_ptt_acquire(p_hwfn);
+	if (!p_ptt)
+		return -EBUSY;
+	qed_hw_err_notify(p_hwfn, p_ptt, QED_HW_ERR_RAMROD_FAIL,
+			  "Ramrod is stuck [CID %08x cmd %02x protocol %02x echo %04x]\n",
+			  le32_to_cpu(p_ent->elem.hdr.cid),
+			  p_ent->elem.hdr.cmd_id,
+			  p_ent->elem.hdr.protocol_id,
+			  le16_to_cpu(p_ent->elem.hdr.echo));
+	qed_ptt_release(p_hwfn, p_ptt);
 
 	return -EBUSY;
 }
-- 
2.25.1

