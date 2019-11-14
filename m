Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE777FBF9A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKNF1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:27:23 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37154 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfKNF1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:27:23 -0500
Received: by mail-pf1-f194.google.com with SMTP id p24so3352645pfn.4
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vXLYtU9pUKKMqiZ13uyXFZWfUrpAk68A6tE4Irb023g=;
        b=jhqNvyhXUIYf45w+FmDFRXU48kL+HsbgOo2Zu1TcLtWrAuS4FVRwiEfbrO0SxMqAza
         qQfLefN7mkNi4igswsP5JyAIwOFdIl7TztnI6ZNZHUmULsm06uEqMXBEA+B6hUlDG2Lc
         XI5DOerjY6q3u98bfa6aiEj8ZD4BGVE0PWkMJD4LW+yG5mCWG12vvfwbpCofFy6N7kkU
         PI2B88G5kP54XqMt8mnrp8GhUYBMiszCDPiHccS41keZciMORcdEi/BiyF/+z9qCcJJx
         qyXPo7N5vLh37RFmWLOXyPf468DpRNMeYlfYzd4ThDsOzSk62mMJ6BZoGzFksc3PoFgk
         vWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vXLYtU9pUKKMqiZ13uyXFZWfUrpAk68A6tE4Irb023g=;
        b=Z7S83ML4T7Sp2oMibPCS8cnf1Xq48dyGcIbiUIhpQpKeg83HmIfXILcbYpGmE2kRrw
         xkaVf5gr90gtG8Dfve3TfQLaJHGYKOSMTYYkxXyiKswwwjQxfSJR8YRlhmrIGbyzGfX7
         Tz1r5nMrpyaZ03uYk7I5eLKDwhqlbx3FZQUWJDQgTIYFrkME/uslBcSoH0/CtDFHsitg
         FOAgvYbeqlHdA193MWitGWHT4gz7nrWXRG7BUOoYUoArzXQvJJDYdQRunf2EakXReKp8
         guU5ZC6u3lINCzzIJapL7t+umbSJ6ziFwpUaLVBzmx6omZSVjTHyckXAjFagev+ImDfE
         BC4g==
X-Gm-Message-State: APjAAAXrrfERy3vYQHVOXid3fMeDlbKMPE8rY8a0tNjBzC/rhyiS44/D
        /ehBobTKCDIzdkCocsZqet1JxBCPxS4=
X-Google-Smtp-Source: APXvYqw5JOHes1lCFV0YfCXqJ1q7pZl9Dq9VmeWq3zjv9FfgWMU3X13uNDoGq0L5tRMouHYS66KHzQ==
X-Received: by 2002:a63:ff46:: with SMTP id s6mr8043574pgk.337.1573709241139;
        Wed, 13 Nov 2019 21:27:21 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.27.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:27:20 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Prakash Brahmajyosyula <bprakash@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 04/18] octeontx2-af: Add NDC block stats to debugfs.
Date:   Thu, 14 Nov 2019 10:56:19 +0530
Message-Id: <1573709193-15446-5-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prakash Brahmajyosyula <bprakash@marvell.com>

NDC is a data cache unit which caches NPA and NIX block's
aura/pool/RQ/SQ/CQ/etc contexts to reduce number of costly
DRAM accesses.

This patch adds support to dump cache's performance stats
like cache line hit/miss counters, average cycles taken for
accessing cached and non-cached data. This will help in
checking if NPA/NIX context reads/writes are having NDC cache
misses which inturn might effect performance.

Also changed NDC enums to reflect correct NDC hardware instance.

Signed-off-by: Prakash Brahmajyosyula <bprakash@marvell.com>
Signed-off-by: Linu Cherian <lcherian@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h |  16 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   6 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 140 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  27 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |  32 ++---
 5 files changed, 201 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index e332e82..baec832 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -196,4 +196,20 @@ enum nix_scheduler {
 #define DEFAULT_RSS_CONTEXT_GROUP	0
 #define MAX_RSS_INDIR_TBL_SIZE		256 /* 1 << Max adder bits */
 
+/* NDC info */
+enum ndc_idx_e {
+	NIX0_RX = 0x0,
+	NIX0_TX = 0x1,
+	NPA0_U  = 0x2,
+};
+
+enum ndc_ctype_e {
+	CACHING = 0x0,
+	BYPASS = 0x1,
+};
+
+#define NDC_MAX_PORT 6
+#define NDC_READ_TRANS 0
+#define NDC_WRITE_TRANS 1
+
 #endif /* COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 8ed5498..cf8741d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -433,9 +433,9 @@ static void rvu_reset_all_blocks(struct rvu *rvu)
 	rvu_block_reset(rvu, BLKADDR_SSO, SSO_AF_BLK_RST);
 	rvu_block_reset(rvu, BLKADDR_TIM, TIM_AF_BLK_RST);
 	rvu_block_reset(rvu, BLKADDR_CPT0, CPT_AF_BLK_RST);
-	rvu_block_reset(rvu, BLKADDR_NDC0, NDC_AF_BLK_RST);
-	rvu_block_reset(rvu, BLKADDR_NDC1, NDC_AF_BLK_RST);
-	rvu_block_reset(rvu, BLKADDR_NDC2, NDC_AF_BLK_RST);
+	rvu_block_reset(rvu, BLKADDR_NDC_NIX0_RX, NDC_AF_BLK_RST);
+	rvu_block_reset(rvu, BLKADDR_NDC_NIX0_TX, NDC_AF_BLK_RST);
+	rvu_block_reset(rvu, BLKADDR_NDC_NPA0, NDC_AF_BLK_RST);
 }
 
 static void rvu_scan_block(struct rvu *rvu, struct rvu_block *block)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 125b94f..581b611 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -21,6 +21,9 @@
 
 #define DEBUGFS_DIR_NAME "octeontx2"
 
+#define NDC_MAX_BANK(rvu, blk_addr) (rvu_read64(rvu, \
+						blk_addr, NDC_AF_CONST) & 0xFF)
+
 #define rvu_dbg_NULL NULL
 #define rvu_dbg_open_NULL NULL
 
@@ -609,6 +612,113 @@ static int rvu_dbg_npa_pool_ctx_display(struct seq_file *filp, void *unused)
 
 RVU_DEBUG_SEQ_FOPS(npa_pool_ctx, npa_pool_ctx_display, npa_pool_ctx_write);
 
+static void ndc_cache_stats(struct seq_file *s, int blk_addr,
+			    int ctype, int transaction)
+{
+	u64 req, out_req, lat, cant_alloc;
+	struct rvu *rvu = s->private;
+	int port;
+
+	for (port = 0; port < NDC_MAX_PORT; port++) {
+		req = rvu_read64(rvu, blk_addr, NDC_AF_PORTX_RTX_RWX_REQ_PC
+						(port, ctype, transaction));
+		lat = rvu_read64(rvu, blk_addr, NDC_AF_PORTX_RTX_RWX_LAT_PC
+						(port, ctype, transaction));
+		out_req = rvu_read64(rvu, blk_addr,
+				     NDC_AF_PORTX_RTX_RWX_OSTDN_PC
+				     (port, ctype, transaction));
+		cant_alloc = rvu_read64(rvu, blk_addr,
+					NDC_AF_PORTX_RTX_CANT_ALLOC_PC
+					(port, transaction));
+		seq_printf(s, "\nPort:%d\n", port);
+		seq_printf(s, "\tTotal Requests:\t\t%lld\n", req);
+		seq_printf(s, "\tTotal Time Taken:\t%lld cycles\n", lat);
+		seq_printf(s, "\tAvg Latency:\t\t%lld cycles\n", lat / req);
+		seq_printf(s, "\tOutstanding Requests:\t%lld\n", out_req);
+		seq_printf(s, "\tCant Alloc Requests:\t%lld\n", cant_alloc);
+	}
+}
+
+static int ndc_blk_cache_stats(struct seq_file *s, int idx, int blk_addr)
+{
+	seq_puts(s, "\n***** CACHE mode read stats *****\n");
+	ndc_cache_stats(s, blk_addr, CACHING, NDC_READ_TRANS);
+	seq_puts(s, "\n***** CACHE mode write stats *****\n");
+	ndc_cache_stats(s, blk_addr, CACHING, NDC_WRITE_TRANS);
+	seq_puts(s, "\n***** BY-PASS mode read stats *****\n");
+	ndc_cache_stats(s, blk_addr, BYPASS, NDC_READ_TRANS);
+	seq_puts(s, "\n***** BY-PASS mode write stats *****\n");
+	ndc_cache_stats(s, blk_addr, BYPASS, NDC_WRITE_TRANS);
+	return 0;
+}
+
+static int rvu_dbg_npa_ndc_cache_display(struct seq_file *filp, void *unused)
+{
+	return ndc_blk_cache_stats(filp, NPA0_U, BLKADDR_NDC_NPA0);
+}
+
+RVU_DEBUG_SEQ_FOPS(npa_ndc_cache, npa_ndc_cache_display, NULL);
+
+static int ndc_blk_hits_miss_stats(struct seq_file *s, int idx, int blk_addr)
+{
+	struct rvu *rvu = s->private;
+	int bank, max_bank;
+
+	max_bank = NDC_MAX_BANK(rvu, blk_addr);
+	for (bank = 0; bank < max_bank; bank++) {
+		seq_printf(s, "BANK:%d\n", bank);
+		seq_printf(s, "\tHits:\t%lld\n",
+			   (u64)rvu_read64(rvu, blk_addr,
+			   NDC_AF_BANKX_HIT_PC(bank)));
+		seq_printf(s, "\tMiss:\t%lld\n",
+			   (u64)rvu_read64(rvu, blk_addr,
+			    NDC_AF_BANKX_MISS_PC(bank)));
+	}
+	return 0;
+}
+
+static int rvu_dbg_nix_ndc_rx_cache_display(struct seq_file *filp, void *unused)
+{
+	return ndc_blk_cache_stats(filp, NIX0_RX,
+				   BLKADDR_NDC_NIX0_RX);
+}
+
+RVU_DEBUG_SEQ_FOPS(nix_ndc_rx_cache, nix_ndc_rx_cache_display, NULL);
+
+static int rvu_dbg_nix_ndc_tx_cache_display(struct seq_file *filp, void *unused)
+{
+	return ndc_blk_cache_stats(filp, NIX0_TX,
+				   BLKADDR_NDC_NIX0_TX);
+}
+
+RVU_DEBUG_SEQ_FOPS(nix_ndc_tx_cache, nix_ndc_tx_cache_display, NULL);
+
+static int rvu_dbg_npa_ndc_hits_miss_display(struct seq_file *filp,
+					     void *unused)
+{
+	return ndc_blk_hits_miss_stats(filp, NPA0_U, BLKADDR_NDC_NPA0);
+}
+
+RVU_DEBUG_SEQ_FOPS(npa_ndc_hits_miss, npa_ndc_hits_miss_display, NULL);
+
+static int rvu_dbg_nix_ndc_rx_hits_miss_display(struct seq_file *filp,
+						void *unused)
+{
+	return ndc_blk_hits_miss_stats(filp,
+				      NPA0_U, BLKADDR_NDC_NIX0_RX);
+}
+
+RVU_DEBUG_SEQ_FOPS(nix_ndc_rx_hits_miss, nix_ndc_rx_hits_miss_display, NULL);
+
+static int rvu_dbg_nix_ndc_tx_hits_miss_display(struct seq_file *filp,
+						void *unused)
+{
+	return ndc_blk_hits_miss_stats(filp,
+				      NPA0_U, BLKADDR_NDC_NIX0_TX);
+}
+
+RVU_DEBUG_SEQ_FOPS(nix_ndc_tx_hits_miss, nix_ndc_tx_hits_miss_display, NULL);
+
 /* Dumps given nix_sq's context */
 static void print_nix_sq_ctx(struct seq_file *m, struct nix_aq_enq_rsp *rsp)
 {
@@ -1087,6 +1197,26 @@ static void rvu_dbg_nix_init(struct rvu *rvu)
 	if (!pfile)
 		goto create_failed;
 
+	pfile = debugfs_create_file("ndc_tx_cache", 0600, rvu->rvu_dbg.nix, rvu,
+				    &rvu_dbg_nix_ndc_tx_cache_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("ndc_rx_cache", 0600, rvu->rvu_dbg.nix, rvu,
+				    &rvu_dbg_nix_ndc_rx_cache_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("ndc_tx_hits_miss", 0600, rvu->rvu_dbg.nix,
+				    rvu, &rvu_dbg_nix_ndc_tx_hits_miss_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("ndc_rx_hits_miss", 0600, rvu->rvu_dbg.nix,
+				    rvu, &rvu_dbg_nix_ndc_rx_hits_miss_fops);
+	if (!pfile)
+		goto create_failed;
+
 	pfile = debugfs_create_file("qsize", 0600, rvu->rvu_dbg.nix, rvu,
 				    &rvu_dbg_nix_qsize_fops);
 	if (!pfile)
@@ -1122,6 +1252,16 @@ static void rvu_dbg_npa_init(struct rvu *rvu)
 	if (!pfile)
 		goto create_failed;
 
+	pfile = debugfs_create_file("ndc_cache", 0600, rvu->rvu_dbg.npa, rvu,
+				    &rvu_dbg_npa_ndc_cache_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("ndc_hits_miss", 0600, rvu->rvu_dbg.npa,
+				    rvu, &rvu_dbg_npa_ndc_hits_miss_fops);
+	if (!pfile)
+		goto create_failed;
+
 	return;
 
 create_failed:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 09a8d61..3d7b293c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -435,7 +435,6 @@
 #define CPT_AF_LF_RST			(0x44000)
 #define CPT_AF_BLK_RST			(0x46000)
 
-#define NDC_AF_BLK_RST                  (0x002F0)
 #define NPC_AF_BLK_RST                  (0x00040)
 
 /* NPC */
@@ -499,4 +498,30 @@
 #define NPC_AF_DBG_DATAX(a)		(0x3001400 | (a) << 4)
 #define NPC_AF_DBG_RESULTX(a)		(0x3001800 | (a) << 4)
 
+/* NDC */
+#define NDC_AF_CONST			(0x00000)
+#define NDC_AF_CLK_EN			(0x00020)
+#define NDC_AF_CTL			(0x00030)
+#define NDC_AF_BANK_CTL			(0x00040)
+#define NDC_AF_BANK_CTL_DONE		(0x00048)
+#define NDC_AF_INTR			(0x00058)
+#define NDC_AF_INTR_W1S			(0x00060)
+#define NDC_AF_INTR_ENA_W1S		(0x00068)
+#define NDC_AF_INTR_ENA_W1C		(0x00070)
+#define NDC_AF_ACTIVE_PC		(0x00078)
+#define NDC_AF_BP_TEST_ENABLE		(0x001F8)
+#define NDC_AF_BP_TEST(a)		(0x00200 | (a) << 3)
+#define NDC_AF_BLK_RST			(0x002F0)
+#define NDC_PRIV_AF_INT_CFG		(0x002F8)
+#define NDC_AF_HASHX(a)			(0x00300 | (a) << 3)
+#define NDC_AF_PORTX_RTX_RWX_REQ_PC(a, b, c) \
+		(0x00C00 | (a) << 5 | (b) << 4 | (c) << 3)
+#define NDC_AF_PORTX_RTX_RWX_OSTDN_PC(a, b, c) \
+		(0x00D00 | (a) << 5 | (b) << 4 | (c) << 3)
+#define NDC_AF_PORTX_RTX_RWX_LAT_PC(a, b, c) \
+		(0x00E00 | (a) << 5 | (b) << 4 | (c) << 3)
+#define NDC_AF_PORTX_RTX_CANT_ALLOC_PC(a, b) \
+		(0x00F00 | (a) << 5 | (b) << 4)
+#define NDC_AF_BANKX_HIT_PC(a)		(0x01000 | (a) << 3)
+#define NDC_AF_BANKX_MISS_PC(a)		(0x01100 | (a) << 3)
 #endif /* RVU_REG_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 92aac44..f6a260d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -13,22 +13,22 @@
 
 /* RVU Block Address Enumeration */
 enum rvu_block_addr_e {
-	BLKADDR_RVUM    = 0x0ULL,
-	BLKADDR_LMT     = 0x1ULL,
-	BLKADDR_MSIX    = 0x2ULL,
-	BLKADDR_NPA     = 0x3ULL,
-	BLKADDR_NIX0    = 0x4ULL,
-	BLKADDR_NIX1    = 0x5ULL,
-	BLKADDR_NPC     = 0x6ULL,
-	BLKADDR_SSO     = 0x7ULL,
-	BLKADDR_SSOW    = 0x8ULL,
-	BLKADDR_TIM     = 0x9ULL,
-	BLKADDR_CPT0    = 0xaULL,
-	BLKADDR_CPT1    = 0xbULL,
-	BLKADDR_NDC0    = 0xcULL,
-	BLKADDR_NDC1    = 0xdULL,
-	BLKADDR_NDC2    = 0xeULL,
-	BLK_COUNT	= 0xfULL,
+	BLKADDR_RVUM		= 0x0ULL,
+	BLKADDR_LMT		= 0x1ULL,
+	BLKADDR_MSIX		= 0x2ULL,
+	BLKADDR_NPA		= 0x3ULL,
+	BLKADDR_NIX0		= 0x4ULL,
+	BLKADDR_NIX1		= 0x5ULL,
+	BLKADDR_NPC		= 0x6ULL,
+	BLKADDR_SSO		= 0x7ULL,
+	BLKADDR_SSOW		= 0x8ULL,
+	BLKADDR_TIM		= 0x9ULL,
+	BLKADDR_CPT0		= 0xaULL,
+	BLKADDR_CPT1		= 0xbULL,
+	BLKADDR_NDC_NIX0_RX	= 0xcULL,
+	BLKADDR_NDC_NIX0_TX	= 0xdULL,
+	BLKADDR_NDC_NPA0	= 0xeULL,
+	BLK_COUNT		= 0xfULL,
 };
 
 /* RVU Block Type Enumeration */
-- 
2.7.4

