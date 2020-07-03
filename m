Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAB12139D5
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgGCMKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 08:10:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38948 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725984AbgGCMKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 08:10:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063C08PW007410;
        Fri, 3 Jul 2020 05:10:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=jke35txsH3tYejAl3NjGnm13UV2bb0iBJUxmdfEsQyk=;
 b=tJPFHCAuHOz325dJqx4Vn8xv3Qp/XuSZQ4oRofUR31t1WK6tKDBZ2G+aCYVWORdMwuDI
 GK9GFWSqoJyuUHd2wa6hrozYwLYOg4BiOfpwiNPQAksLanT9dMQ6L7fFT3qUbwhfrDzI
 zqtvWK5+AIiL68V90PQo1YwmrTaM/6YdBX0VuiuyB2TuoFxkGxambymWhrFEuFqmaiOS
 mcnWmdzmfx1lHRI21jiRepHlYtSA+nSrZAujiTLofJwfSSJEXtvGtpF/Zf+5CB1Shm4E
 ahfmRROGz78cVvDVjLCdnn5eNWf7oYLaIx4M/aySkpAYNyB0YG8lc/WwxXJKfbxbvjXf Zw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 31x5mp1n83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 05:10:04 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul
 2020 05:10:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Jul 2020 05:10:02 -0700
Received: from sudarshana-rh72.punelab.qlogic.com. (unknown [10.30.45.63])
        by maili.marvell.com (Postfix) with ESMTP id 00F633F704B;
        Fri,  3 Jul 2020 05:10:00 -0700 (PDT)
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next v2 3/4] bnx2x: Add support for idlechk tests.
Date:   Fri, 3 Jul 2020 17:39:49 +0530
Message-ID: <1593778190-1818-4-git-send-email-skalluru@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593778190-1818-1-git-send-email-skalluru@marvell.com>
References: <1593778190-1818-1-git-send-email-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_06:2020-07-02,2020-07-03 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds driver implementation for performing the idlechk tests.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |  10 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   7 +
 .../net/ethernet/broadcom/bnx2x/bnx2x_self_test.c  | 268 ++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c  |   2 +
 4 files changed, 277 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index 4f5b2b8..dee61d9 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1979,6 +1979,9 @@ struct bnx2x_func_init_params {
 
 #define skip_queue(bp, idx)	(NO_FCOE(bp) && IS_FCOE_IDX(idx))
 
+/*self test*/
+int bnx2x_idle_chk(struct bnx2x *bp);
+
 /**
  * bnx2x_set_mac_one - configure a single MAC address
  *
@@ -2430,13 +2433,6 @@ void bnx2x_igu_clear_sb_gen(struct bnx2x *bp, u8 func, u8 idu_sb_id,
 #define HC_SEG_ACCESS_ATTN		4
 #define HC_SEG_ACCESS_NORM		0   /*Driver decision 0-1*/
 
-static const u32 dmae_reg_go_c[] = {
-	DMAE_REG_GO_C0, DMAE_REG_GO_C1, DMAE_REG_GO_C2, DMAE_REG_GO_C3,
-	DMAE_REG_GO_C4, DMAE_REG_GO_C5, DMAE_REG_GO_C6, DMAE_REG_GO_C7,
-	DMAE_REG_GO_C8, DMAE_REG_GO_C9, DMAE_REG_GO_C10, DMAE_REG_GO_C11,
-	DMAE_REG_GO_C12, DMAE_REG_GO_C13, DMAE_REG_GO_C14, DMAE_REG_GO_C15
-};
-
 void bnx2x_set_ethtool_ops(struct bnx2x *bp, struct net_device *netdev);
 void bnx2x_notify_link_changed(struct bnx2x *bp);
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index db5107e7..06dfb90 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -276,6 +276,13 @@ enum bnx2x_board_type {
 
 MODULE_DEVICE_TABLE(pci, bnx2x_pci_tbl);
 
+const u32 dmae_reg_go_c[] = {
+	DMAE_REG_GO_C0, DMAE_REG_GO_C1, DMAE_REG_GO_C2, DMAE_REG_GO_C3,
+	DMAE_REG_GO_C4, DMAE_REG_GO_C5, DMAE_REG_GO_C6, DMAE_REG_GO_C7,
+	DMAE_REG_GO_C8, DMAE_REG_GO_C9, DMAE_REG_GO_C10, DMAE_REG_GO_C11,
+	DMAE_REG_GO_C12, DMAE_REG_GO_C13, DMAE_REG_GO_C14, DMAE_REG_GO_C15
+};
+
 /* Global resources for unloading a previously loaded device */
 #define BNX2X_PREV_WAIT_NEEDED 1
 static DEFINE_SEMAPHORE(bnx2x_prev_sem);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c
index 93a7f7e..32a2295 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c
@@ -18,7 +18,11 @@
 #define MAX_FAIL_MSG 256
 
 /* statistics and error reporting */
-static int idle_chk_errors;
+static int idle_chk_errors, idle_chk_warnings;
+
+/* masks for all chip types */
+static int is_e1, is_e1h, is_e2, is_e3a0, is_e3b0;
+
 
 /* struct for the argument list for a predicate in the self test databasei */
 struct st_pred_args {
@@ -30,7 +34,7 @@ struct st_pred_args {
 	u32 imm4; /* 4th value in predicate condition, left-to-right */
 };
 
-/*struct representing self test record - a single test*/
+/* struct representing self test record - a single test */
 struct st_record {
 	u8 chip_mask;
 	u8 macro;
@@ -111,7 +115,7 @@ static int peq_neq_neq_r2(struct st_pred_args *args)
 /* struct holding the database of self test checks (registers and predicates) */
 /* lines start from 2 since line 1 is heading in csv */
 #define ST_DB_LINES 468
-struct st_record st_database[ST_DB_LINES] = {
+static struct st_record st_database[ST_DB_LINES] = {
 /*line 2*/{(0x3), 1, 0x2114,
 	NA, 1, 0, pand_neq,
 	NA, IDLE_CHK_ERROR,
@@ -2920,3 +2924,261 @@ struct st_record st_database[ST_DB_LINES] = {
 	"NIG: PBF IF5 FIFO is not empty",
 	{NA, NA, 1, NA, NA, NA} },
 };
+
+/* handle self test fails according to severity and type */
+static void bnx2x_self_test_log(struct bnx2x *bp, u8 severity, char *message)
+{
+	switch (severity) {
+	case IDLE_CHK_ERROR:
+		BNX2X_ERR("ERROR %s", message);
+		idle_chk_errors++;
+		break;
+	case IDLE_CHK_ERROR_NO_TRAFFIC:
+		DP(NETIF_MSG_HW, "INFO %s", message);
+		break;
+	case IDLE_CHK_WARNING:
+		DP(NETIF_MSG_HW, "WARNING %s", message);
+		idle_chk_warnings++;
+		break;
+	}
+}
+
+/* specific test for QM rd/wr pointers and rd/wr banks */
+static void bnx2x_idle_chk6(struct bnx2x *bp,
+			    struct st_record *rec, char *message)
+{
+	u32 rd_ptr, wr_ptr, rd_bank, wr_bank;
+	int i;
+
+	for (i = 0; i < rec->loop; i++) {
+		/* read regs */
+		rec->pred_args.val1 =
+			REG_RD(bp, rec->reg1 + i * rec->incr);
+		rec->pred_args.val2 =
+			REG_RD(bp, rec->reg1 + i * rec->incr + 4);
+
+		/* calc read and write pointers */
+		rd_ptr = ((rec->pred_args.val1 & 0x3FFFFFC0) >> 6);
+		wr_ptr = ((((rec->pred_args.val1 & 0xC0000000) >> 30) & 0x3) |
+			((rec->pred_args.val2 & 0x3FFFFF) << 2));
+
+		/* perfrom pointer test */
+		if (rd_ptr != wr_ptr) {
+			snprintf(message, MAX_FAIL_MSG,
+				 "QM: PTRTBL entry %d- rd_ptr is not equal to wr_ptr. Values are 0x%x and 0x%x\n",
+				 i, rd_ptr, wr_ptr);
+			bnx2x_self_test_log(bp, rec->severity, message);
+		}
+
+		/* calculate read and write banks */
+		rd_bank = ((rec->pred_args.val1 & 0x30) >> 4);
+		wr_bank = (rec->pred_args.val1 & 0x03);
+
+		/* perform bank test */
+		if (rd_bank != wr_bank) {
+			snprintf(message, MAX_FAIL_MSG,
+				 "QM: PTRTBL entry %d - rd_bank is not equal to wr_bank. Values are 0x%x 0x%x\n",
+				 i, rd_bank, wr_bank);
+			bnx2x_self_test_log(bp, rec->severity, message);
+		}
+	}
+}
+
+/* specific test for cfc info ram and cid cam */
+static void bnx2x_idle_chk7(struct bnx2x *bp,
+			    struct st_record *rec, char *message)
+{
+	int i;
+
+	/* iterate through lcids */
+	for (i = 0; i < rec->loop; i++) {
+		/* make sure cam entry is valid (bit 0) */
+		if ((REG_RD(bp, (rec->reg2 + i * 4)) & 0x1) != 0x1)
+			continue;
+
+		/* get connection type (multiple reads due to widebus) */
+		REG_RD(bp, (rec->reg1 + i * rec->incr));
+		REG_RD(bp, (rec->reg1 + i * rec->incr + 4));
+		rec->pred_args.val1 =
+			REG_RD(bp, (rec->reg1 + i * rec->incr + 8));
+		REG_RD(bp, (rec->reg1 + i * rec->incr + 12));
+
+		/* obtain connection type */
+		if (is_e1 || is_e1h) {
+			/* E1 E1H (bits 4..7) */
+			rec->pred_args.val1 &= 0x78;
+			rec->pred_args.val1 >>= 3;
+		} else {
+			/* E2 E3A0 E3B0 (bits 26..29) */
+			rec->pred_args.val1 &= 0x1E000000;
+			rec->pred_args.val1 >>= 25;
+		}
+
+		/* get activity counter value */
+		rec->pred_args.val2 = REG_RD(bp, rec->reg3 + i * 4);
+
+		/* validate ac value is legal for con_type at idle state */
+		if (rec->bnx2x_predicate(&rec->pred_args)) {
+			snprintf(message, MAX_FAIL_MSG,
+				 "%s. Values are 0x%x 0x%x\n", rec->fail_msg,
+				 rec->pred_args.val1, rec->pred_args.val2);
+			bnx2x_self_test_log(bp, rec->severity, message);
+		}
+	}
+}
+
+/* self test procedure
+ * scan auto-generated database
+ * for each line:
+ * 1.	compare chip mask
+ * 2.	determine type (according to maro number)
+ * 3.	read registers
+ * 4.	call predicate
+ * 5.	collate results and statistics
+ */
+int bnx2x_idle_chk(struct bnx2x *bp)
+{
+	u16 i;				/* loop counter */
+	u16 st_ind;			/* self test database access index */
+	struct st_record rec;		/* current record variable */
+	char message[MAX_FAIL_MSG];	/* message to log */
+
+	/*init stats*/
+	idle_chk_errors = 0;
+	idle_chk_warnings = 0;
+
+	/*create masks for all chip types*/
+	is_e1	= CHIP_IS_E1(bp);
+	is_e1h	= CHIP_IS_E1H(bp);
+	is_e2	= CHIP_IS_E2(bp);
+	is_e3a0	= CHIP_IS_E3A0(bp);
+	is_e3b0	= CHIP_IS_E3B0(bp);
+
+	/*database main loop*/
+	for (st_ind = 0; st_ind < ST_DB_LINES; st_ind++) {
+		rec = st_database[st_ind];
+
+		/*check if test applies to chip*/
+		if (!((rec.chip_mask & IDLE_CHK_E1) && is_e1) &&
+		    !((rec.chip_mask & IDLE_CHK_E1H) && is_e1h) &&
+		    !((rec.chip_mask & IDLE_CHK_E2) && is_e2) &&
+		    !((rec.chip_mask & IDLE_CHK_E3A0) && is_e3a0) &&
+		    !((rec.chip_mask & IDLE_CHK_E3B0) && is_e3b0))
+			continue;
+
+		/* identify macro */
+		switch (rec.macro) {
+		case 1:
+			/* read single reg and call predicate */
+			rec.pred_args.val1 = REG_RD(bp, rec.reg1);
+			DP(BNX2X_MSG_IDLE, "mac1 add %x\n", rec.reg1);
+			if (rec.bnx2x_predicate(&rec.pred_args)) {
+				snprintf(message, sizeof(message),
+					 "%s.Value is 0x%x\n", rec.fail_msg,
+					 rec.pred_args.val1);
+				bnx2x_self_test_log(bp, rec.severity, message);
+			}
+			break;
+		case 2:
+			/* read repeatedly starting from reg1 and call
+			 * predicate after each read
+			 */
+			for (i = 0; i < rec.loop; i++) {
+				rec.pred_args.val1 =
+					REG_RD(bp, rec.reg1 + i * rec.incr);
+				DP(BNX2X_MSG_IDLE, "mac2 add %x\n", rec.reg1);
+				if (rec.bnx2x_predicate(&rec.pred_args)) {
+					snprintf(message, sizeof(message),
+						 "%s. Value is 0x%x in loop %d\n",
+						 rec.fail_msg,
+						 rec.pred_args.val1, i);
+					bnx2x_self_test_log(bp, rec.severity,
+							    message);
+				}
+			}
+			break;
+		case 3:
+			/* read two regs and call predicate */
+			rec.pred_args.val1 = REG_RD(bp, rec.reg1);
+			rec.pred_args.val2 = REG_RD(bp, rec.reg2);
+			DP(BNX2X_MSG_IDLE, "mac3 add1 %x add2 %x\n",
+			   rec.reg1, rec.reg2);
+			if (rec.bnx2x_predicate(&rec.pred_args)) {
+				snprintf(message, sizeof(message),
+					 "%s. Values are 0x%x 0x%x\n",
+					 rec.fail_msg, rec.pred_args.val1,
+					 rec.pred_args.val2);
+				bnx2x_self_test_log(bp, rec.severity, message);
+			}
+			break;
+		case 4:
+			/*unused to-date*/
+			for (i = 0; i < rec.loop; i++) {
+				rec.pred_args.val1 =
+					REG_RD(bp, rec.reg1 + i * rec.incr);
+				rec.pred_args.val2 =
+					(REG_RD(bp,
+						rec.reg2 + i * rec.incr)) >> 1;
+				if (rec.bnx2x_predicate(&rec.pred_args)) {
+					snprintf(message, sizeof(message),
+						 "%s. Values are 0x%x 0x%x in loop %d\n",
+						 rec.fail_msg,
+						 rec.pred_args.val1,
+						 rec.pred_args.val2, i);
+					bnx2x_self_test_log(bp, rec.severity,
+							    message);
+				}
+			}
+			break;
+		case 5:
+			/* compare two regs, pending
+			 * the value of a condition reg
+			 */
+			rec.pred_args.val1 = REG_RD(bp, rec.reg1);
+			rec.pred_args.val2 = REG_RD(bp, rec.reg2);
+			DP(BNX2X_MSG_IDLE, "mac3 add1 %x add2 %x add3 %x\n",
+			   rec.reg1, rec.reg2, rec.reg3);
+			if (REG_RD(bp, rec.reg3) != 0) {
+				if (rec.bnx2x_predicate(&rec.pred_args)) {
+					snprintf(message, sizeof(message),
+						 "%s. Values are 0x%x 0x%x\n",
+						 rec.fail_msg,
+						 rec.pred_args.val1,
+						 rec.pred_args.val2);
+					bnx2x_self_test_log(bp, rec.severity,
+							    message);
+				}
+			}
+			break;
+		case 6:
+			/* compare read and write pointers
+			 * and read and write banks in QM
+			 */
+			bnx2x_idle_chk6(bp, &rec, message);
+			break;
+		case 7:
+			/* compare cfc info cam with cid cam */
+			bnx2x_idle_chk7(bp, &rec, message);
+			break;
+		default:
+			DP(BNX2X_MSG_IDLE,
+			   "unknown macro in self test data base. macro %d line %d",
+			   rec.macro, st_ind);
+		}
+	}
+
+	/* abort if interface is not running */
+	if (!netif_running(bp->dev))
+		return idle_chk_errors;
+
+	/* return value accorindg to statistics */
+	if (idle_chk_errors == 0) {
+		DP(BNX2X_MSG_IDLE,
+		   "completed successfully (logged %d warnings)\n",
+		   idle_chk_warnings);
+	} else {
+		BNX2X_ERR("failed (with %d errors, %d warnings)\n",
+			  idle_chk_errors, idle_chk_warnings);
+	}
+	return idle_chk_errors;
+}
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
index 7e0919a..0b193ed 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
@@ -23,6 +23,8 @@
 #include "bnx2x_cmn.h"
 #include "bnx2x_sriov.h"
 
+extern const u32 dmae_reg_go_c[];
+
 /* Statistics */
 
 /*
-- 
1.8.3.1

