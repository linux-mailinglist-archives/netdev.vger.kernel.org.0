Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71ECF7ECF
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbfKKTGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:06:30 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41867 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729080AbfKKSiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:38:51 -0500
Received: by mail-pl1-f193.google.com with SMTP id d29so8127335plj.8
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 10:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vXLYtU9pUKKMqiZ13uyXFZWfUrpAk68A6tE4Irb023g=;
        b=Qn+QqWS+WvtAiDPCEKGEoL+isvIw68m2xQW1q08gQcHrfSZoeDft4R9JRmWkF64h0H
         hN85o9TJ+4Elkd26enGgA34Y9Y+qVyuZ0/BaFSSV41wcG/t5XjEF6n6ibGvPPsU3VhGO
         mwDk53vY37OwkzF9qlNmTw6aT6nIW/VbSQKgraxpQuZO65zo3KpXqrbt05H65YlSiDSP
         0icjqCnJWBCJ8TU6oGtdx4pJD8uJgH2SNMSoaRI/9cu8lv8MJPIdXY+YV3up4OHTctTS
         bIpT09mT86ttmRSg1U3WbW0SJ79zdN+e2/K7D6y+crPNkhia2wNJgH+ArQN6GdclwypT
         lqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vXLYtU9pUKKMqiZ13uyXFZWfUrpAk68A6tE4Irb023g=;
        b=b28lpDvql0M7xMarYYTCy9KY8iN0TDPXXD7lm0H2S5MpDS+jrfb2KByYvjSKt1uCs6
         1RVLcnDx8qF4LMMsXxQt+S9G7fg4RL3kXlOvM2ZuW0u321CAIUXeTNE1tTwGIVOCS7vj
         OY2DYhe4+j169c2o99N5QwuHHL8FrF4LdA1HWJZTHz4wFFuqbqbGnIif3ydnJGL5vcI3
         ubnccOTP2qPTtJLlbdPjr3oRVDDKBtS8uEjLouK/rsptrEKEIUXJuWMlon/q9rABukrC
         Mp2Tf+xyugdrD7tR+OLw5M1ugeIbD3T3X687x+k/cuBHW0Y+oikcCuaRKCnLCv1Tv8VO
         Z0dg==
X-Gm-Message-State: APjAAAXAb2Zu2DBrCuo9hg/PFr3jPRCYMzqUfeh1LTSz36/kVhQ1gdli
        aJyEo8zve5psRXuDX0UtoBn2y5SGjaY=
X-Google-Smtp-Source: APXvYqwzXpMIn9cA9/R5kaVg8vJxsLzhWZLd3xUZF70laPbN2fVZhbCXb4STmJlxvb89qBkIcZ+tJQ==
X-Received: by 2002:a17:902:6ac6:: with SMTP id i6mr26553208plt.183.1573497530175;
        Mon, 11 Nov 2019 10:38:50 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id b5sm16921762pfp.149.2019.11.11.10.38.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 10:38:49 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Prakash Brahmajyosyula <bprakash@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 04/18] octeontx2-af: Add NDC block stats to debugfs.
Date:   Tue, 12 Nov 2019 00:08:00 +0530
Message-Id: <1573497494-11468-5-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
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

