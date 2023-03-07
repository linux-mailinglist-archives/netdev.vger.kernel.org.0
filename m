Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCBD6ADC61
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjCGKtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCGKtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:49:41 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A949C10A85;
        Tue,  7 Mar 2023 02:49:39 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327A6QmA032158;
        Tue, 7 Mar 2023 02:49:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=pN9HuWX2y6mKu7y/guyEp0KE2VkVx1IDQ3cN6AtAPwY=;
 b=N/xSwk4pbdum8H/ifKeh88Dz2Usvln9BFymrGr/BSc0HqETvN+hauUM7fao8YkGxCMQT
 Ft7iZtDHQ5A2B/01ESVf+NEsAtxAvW2nPAaLMmv83lye4nUCC5cX9VcnOkiDUsS2b5Xe
 rQkYSeIdOJODh4CKjvhjbifG0ipVsPx0TBlCz3ozJIqmvMc202GruHV7nyqgv04d/zYw
 mKLP1W1IAULgcNhOqG9ayrYbMKz75V1XQAf2baMQWoSxAAWFgNvoY24qgDtfojd/U2yW
 vmwsOzVocYXlvqppAKHmPgCZdQX1XhYb+DQWfxPPwPam/+uIqpEDrJf3cYCjFAGkxjZ2 kQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3p5y87sb4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 02:49:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 7 Mar
 2023 02:49:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Tue, 7 Mar 2023 02:49:23 -0800
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 6FFCD3F7043;
        Tue,  7 Mar 2023 02:49:19 -0800 (PST)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <sumang@marvell.com>, <richardcochran@gmail.com>
CC:     Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v3] octeontx2-af: Unlock contexts in the queue context cache in case of fault detection
Date:   Tue, 7 Mar 2023 16:19:08 +0530
Message-ID: <20230307104908.3391164-1-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: q-Zk6l4l8W1U2IzQ_t5vVnMV41PBZ1lo
X-Proofpoint-ORIG-GUID: q-Zk6l4l8W1U2IzQ_t5vVnMV41PBZ1lo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_04,2023-03-07_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suman Ghosh <sumang@marvell.com>

NDC caches contexts of frequently used queue's (Rx and Tx queues)
contexts. Due to a HW errata when NDC detects fault/poision while
accessing contexts it could go into an illegal state where a cache
line could get locked forever. To makesure all cache lines in NDC
are available for optimum performance upon fault/lockerror/posion
errors scan through all cache lines in NDC and clear the lock bit.

Fixes: 4a3581cd5995 ("octeontx2-af: NPA AQ instruction enqueue support")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
---
v3:
    - Addressed review comments given by Simon Horman 
      1. Modified NDC macros to use FIELD_GET 
      2. Fixed a bug in bit shift operation
v2:
    - Rebased to latest net tree after net-next merge as suggested by
      Paolo

 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  5 ++
 .../marvell/octeontx2/af/rvu_debugfs.c        |  7 +--
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 16 ++++-
 .../ethernet/marvell/octeontx2/af/rvu_npa.c   | 58 ++++++++++++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  3 +
 5 files changed, 82 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 389663a13d1d..ef721caeac49 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -884,6 +884,9 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf,
 int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc);
 int rvu_cpt_init(struct rvu *rvu);
 
+#define NDC_AF_BANK_MASK       GENMASK_ULL(7, 0)
+#define NDC_AF_BANK_LINE_MASK  GENMASK_ULL(31, 16)
+
 /* CN10K RVU */
 int rvu_set_channels_base(struct rvu *rvu);
 void rvu_program_channels(struct rvu *rvu);
@@ -902,6 +905,8 @@ static inline void rvu_dbg_init(struct rvu *rvu) {}
 static inline void rvu_dbg_exit(struct rvu *rvu) {}
 #endif
 
+int rvu_ndc_fix_locked_cacheline(struct rvu *rvu, int blkaddr);
+
 /* RVU Switch */
 void rvu_switch_enable(struct rvu *rvu);
 void rvu_switch_disable(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index fa280ebd3052..26cfa501f1a1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -198,9 +198,6 @@ enum cpt_eng_type {
 	CPT_IE_TYPE = 3,
 };
 
-#define NDC_MAX_BANK(rvu, blk_addr) (rvu_read64(rvu, \
-						blk_addr, NDC_AF_CONST) & 0xFF)
-
 #define rvu_dbg_NULL NULL
 #define rvu_dbg_open_NULL NULL
 
@@ -1448,6 +1445,7 @@ static int ndc_blk_hits_miss_stats(struct seq_file *s, int idx, int blk_addr)
 	struct nix_hw *nix_hw;
 	struct rvu *rvu;
 	int bank, max_bank;
+	u64 ndc_af_const;
 
 	if (blk_addr == BLKADDR_NDC_NPA0) {
 		rvu = s->private;
@@ -1456,7 +1454,8 @@ static int ndc_blk_hits_miss_stats(struct seq_file *s, int idx, int blk_addr)
 		rvu = nix_hw->rvu;
 	}
 
-	max_bank = NDC_MAX_BANK(rvu, blk_addr);
+	ndc_af_const = rvu_read64(rvu, blk_addr, NDC_AF_CONST);
+	max_bank = FIELD_GET(NDC_AF_BANK_MASK, ndc_af_const);
 	for (bank = 0; bank < max_bank; bank++) {
 		seq_printf(s, "BANK:%d\n", bank);
 		seq_printf(s, "\tHits:\t%lld\n",
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 26e639e57dae..4ad707e758b9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -790,6 +790,7 @@ static int nix_aq_enqueue_wait(struct rvu *rvu, struct rvu_block *block,
 	struct nix_aq_res_s *result;
 	int timeout = 1000;
 	u64 reg, head;
+	int ret;
 
 	result = (struct nix_aq_res_s *)aq->res->base;
 
@@ -813,9 +814,22 @@ static int nix_aq_enqueue_wait(struct rvu *rvu, struct rvu_block *block,
 			return -EBUSY;
 	}
 
-	if (result->compcode != NIX_AQ_COMP_GOOD)
+	if (result->compcode != NIX_AQ_COMP_GOOD) {
 		/* TODO: Replace this with some error code */
+		if (result->compcode == NIX_AQ_COMP_CTX_FAULT ||
+		    result->compcode == NIX_AQ_COMP_LOCKERR ||
+		    result->compcode == NIX_AQ_COMP_CTX_POISON) {
+			ret = rvu_ndc_fix_locked_cacheline(rvu, BLKADDR_NDC_NIX0_RX);
+			ret |= rvu_ndc_fix_locked_cacheline(rvu, BLKADDR_NDC_NIX0_TX);
+			ret |= rvu_ndc_fix_locked_cacheline(rvu, BLKADDR_NDC_NIX1_RX);
+			ret |= rvu_ndc_fix_locked_cacheline(rvu, BLKADDR_NDC_NIX1_TX);
+			if (ret)
+				dev_err(rvu->dev,
+					"%s: Not able to unlock cachelines\n", __func__);
+		}
+
 		return -EBUSY;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
index 70bd036ed76e..4f5ca5ab13a4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2018 Marvell.
  *
  */
-
+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 
@@ -42,9 +42,18 @@ static int npa_aq_enqueue_wait(struct rvu *rvu, struct rvu_block *block,
 			return -EBUSY;
 	}
 
-	if (result->compcode != NPA_AQ_COMP_GOOD)
+	if (result->compcode != NPA_AQ_COMP_GOOD) {
 		/* TODO: Replace this with some error code */
+		if (result->compcode == NPA_AQ_COMP_CTX_FAULT ||
+		    result->compcode == NPA_AQ_COMP_LOCKERR ||
+		    result->compcode == NPA_AQ_COMP_CTX_POISON) {
+			if (rvu_ndc_fix_locked_cacheline(rvu, BLKADDR_NDC_NPA0))
+				dev_err(rvu->dev,
+					"%s: Not able to unlock cachelines\n", __func__);
+		}
+
 		return -EBUSY;
+	}
 
 	return 0;
 }
@@ -545,3 +554,48 @@ void rvu_npa_lf_teardown(struct rvu *rvu, u16 pcifunc, int npalf)
 
 	npa_ctx_free(rvu, pfvf);
 }
+
+/* Due to an Hardware errata, in some corner cases, AQ context lock
+ * operations can result in a NDC way getting into an illegal state
+ * of not valid but locked.
+ *
+ * This API solves the problem by clearing the lock bit of the NDC block.
+ * The operation needs to be done for each line of all the NDC banks.
+ */
+int rvu_ndc_fix_locked_cacheline(struct rvu *rvu, int blkaddr)
+{
+	int bank, max_bank, line, max_line, err;
+	u64 reg, ndc_af_const;
+
+	/* Set the ENABLE bit(63) to '0' */
+	reg = rvu_read64(rvu, blkaddr, NDC_AF_CAMS_RD_INTERVAL);
+	rvu_write64(rvu, blkaddr, NDC_AF_CAMS_RD_INTERVAL, reg & GENMASK_ULL(62, 0));
+
+	/* Poll until the BUSY bits(47:32) are set to '0' */
+	err = rvu_poll_reg(rvu, blkaddr, NDC_AF_CAMS_RD_INTERVAL, GENMASK_ULL(47, 32), true);
+	if (err) {
+		dev_err(rvu->dev, "Timed out while polling for NDC CAM busy bits.\n");
+		return err;
+	}
+
+	ndc_af_const = rvu_read64(rvu, blkaddr, NDC_AF_CONST);
+	max_bank = FIELD_GET(NDC_AF_BANK_MASK, ndc_af_const);
+	max_line = FIELD_GET(NDC_AF_BANK_LINE_MASK, ndc_af_const);
+	for (bank = 0; bank < max_bank; bank++) {
+		for (line = 0; line < max_line; line++) {
+			/* Check if 'cache line valid bit(63)' is not set
+			 * but 'cache line lock bit(60)' is set and on
+			 * success, reset the lock bit(60).
+			 */
+			reg = rvu_read64(rvu, blkaddr,
+					 NDC_AF_BANKX_LINEX_METADATA(bank, line));
+			if (!(reg & BIT_ULL(63)) && (reg & BIT_ULL(60))) {
+				rvu_write64(rvu, blkaddr,
+					    NDC_AF_BANKX_LINEX_METADATA(bank, line),
+					    reg & ~BIT_ULL(60));
+			}
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 1729b22580ce..7007f0b8e659 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -694,6 +694,7 @@
 #define NDC_AF_INTR_ENA_W1S		(0x00068)
 #define NDC_AF_INTR_ENA_W1C		(0x00070)
 #define NDC_AF_ACTIVE_PC		(0x00078)
+#define NDC_AF_CAMS_RD_INTERVAL		(0x00080)
 #define NDC_AF_BP_TEST_ENABLE		(0x001F8)
 #define NDC_AF_BP_TEST(a)		(0x00200 | (a) << 3)
 #define NDC_AF_BLK_RST			(0x002F0)
@@ -709,6 +710,8 @@
 		(0x00F00 | (a) << 5 | (b) << 4)
 #define NDC_AF_BANKX_HIT_PC(a)		(0x01000 | (a) << 3)
 #define NDC_AF_BANKX_MISS_PC(a)		(0x01100 | (a) << 3)
+#define NDC_AF_BANKX_LINEX_METADATA(a, b) \
+		(0x10000 | (a) << 12 | (b) << 3)
 
 /* LBK */
 #define LBK_CONST			(0x10ull)
-- 
2.25.1

