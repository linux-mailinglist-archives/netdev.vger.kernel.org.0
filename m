Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A341646655
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiLHBMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiLHBLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:49 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69D58DBFE
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461900; x=1701997900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ur9D3Zyj4ohE0jEAvvRQrdxrcGppRAujm2i1fIy5420=;
  b=M4KckJyclYD0NtODL60YMKaT/lEvk1qbL7JgqDlO9iipp1LX//oh37W4
   O+7yhg3aKFlyTKXXCcSkUev5UTdoG8Fpp8ckCqf+pfk2hKIx7dTHKyFF5
   TwFtURvhfTwG7CXXI4+S+4oS/vnBjCTKHMAHZp/b7mTbNDPZjNdxwMMFr
   ukGZahFwttkJlojKjOPQ2O80JAnm84LwHW2gMCXvphhu/n8DWSg1eQakE
   YSAEEqdR+RrE+e+t8LzqzFvXIXNJgAb9U/qphfnZXSBCahE/keWF1E5M2
   mtqFEvcl6377jRWMQpJL4Gu9eOZYYbddBSwPgGaxS3+xbI5eqYih2Hcjm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672891"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672891"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445377"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445377"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 10/13] ethtool: refactor bit shifts to use BIT and BIT_ULL
Date:   Wed,  7 Dec 2022 17:11:19 -0800
Message-Id: <20221208011122.2343363-11-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A previous patch fixed bit shifts into the sign bit. Formalize this
change and enable clearer code with a conversion of all (1 << foo) to
BIT(foo). This aligns better with the kernel and makes mistakes less
likely due to forgetting the '1UL' during (1UL << foo) usage.

There were a couple of places changed with 1ULL << foo that got changed
to BIT_ULL(foo).

Most of the changes were made by a complicated regular expression that
helped me find the issues (vim style regex):
s/\(\s\+\)(\?\s*1\(U\|UL\)\?\s*<<\s*\([0-9A-Za-z_]\+\))\?/\1BIT(\3)/

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 amd8111e.c         | 198 +++++++++++-----------
 de2104x.c          | 410 ++++++++++++++++++++++-----------------------
 ethtool.c          |  18 +-
 internal.h         |  26 +--
 natsemi.c          | 358 +++++++++++++++++++--------------------
 netlink/bitset.c   |   6 +-
 netlink/features.c |   4 +-
 netlink/monitor.c  |   4 +-
 netlink/parser.c   |   4 +-
 netlink/settings.c |  10 +-
 netlink/stats.c    |   2 +-
 qsfp.h             | 346 +++++++++++++++++++-------------------
 realtek.c          |  48 +++---
 rxclass.c          |   2 +-
 sfc.c              |   2 +-
 sfpdiag.c          |  58 +++----
 sfpid.c            | 146 ++++++++--------
 tse.c              |   2 +-
 18 files changed, 822 insertions(+), 822 deletions(-)

diff --git a/amd8111e.c b/amd8111e.c
index 5a2fc2082e55..17394f9e4565 100644
--- a/amd8111e.c
+++ b/amd8111e.c
@@ -5,20 +5,20 @@
 
 typedef enum {
 	/* VAL2 */
-	RDMD0			= (1 << 16),
+	RDMD0			= BIT(16),
 	/* VAL1 */
-	TDMD3			= (1 << 11),
-	TDMD2			= (1 << 10),
-	TDMD1			= (1 << 9),
-	TDMD0			= (1 << 8),
+	TDMD3			= BIT(11),
+	TDMD2			= BIT(10),
+	TDMD1			= BIT(9),
+	TDMD0			= BIT(8),
 	/* VAL0 */
-	UINTCMD			= (1 << 6),
-	RX_FAST_SPND		= (1 << 5),
-	TX_FAST_SPND		= (1 << 4),
-	RX_SPND			= (1 << 3),
-	TX_SPND			= (1 << 2),
-	INTREN			= (1 << 1),
-	RUN			= (1 << 0),
+	UINTCMD			= BIT(6),
+	RX_FAST_SPND		= BIT(5),
+	TX_FAST_SPND		= BIT(4),
+	RX_SPND			= BIT(3),
+	TX_SPND			= BIT(2),
+	INTREN			= BIT(1),
+	RUN			= BIT(0),
 
 	CMD0_CLEAR 		= 0x000F0F7F,   /* Command style register */
 
@@ -26,27 +26,27 @@ typedef enum {
 typedef enum {
 
 	/* VAL3 */
-	CONDUIT_MODE		= (1 << 29),
+	CONDUIT_MODE		= BIT(29),
 	/* VAL2 */
-	RPA			= (1 << 19),
-	DRCVPA			= (1 << 18),
-	DRCVBC			= (1 << 17),
-	PROM			= (1 << 16),
+	RPA			= BIT(19),
+	DRCVPA			= BIT(18),
+	DRCVBC			= BIT(17),
+	PROM			= BIT(16),
 	/* VAL1 */
-	ASTRP_RCV		= (1 << 13),
-	RCV_DROP0	  	= (1 << 12),
-	EMBA			= (1 << 11),
-	DXMT2PD			= (1 << 10),
-	LTINTEN			= (1 << 9),
-	DXMTFCS			= (1 << 8),
+	ASTRP_RCV		= BIT(13),
+	RCV_DROP0		= BIT(12),
+	EMBA			= BIT(11),
+	DXMT2PD			= BIT(10),
+	LTINTEN			= BIT(9),
+	DXMTFCS			= BIT(8),
 	/* VAL0 */
-	APAD_XMT		= (1 << 6),
-	DRTY			= (1 << 5),
-	INLOOP			= (1 << 4),
-	EXLOOP			= (1 << 3),
-	REX_RTRY		= (1 << 2),
-	REX_UFLO		= (1 << 1),
-	REX_LCOL		= (1 << 0),
+	APAD_XMT		= BIT(6),
+	DRTY			= BIT(5),
+	INLOOP			= BIT(4),
+	EXLOOP			= BIT(3),
+	REX_RTRY		= BIT(2),
+	REX_UFLO		= BIT(1),
+	REX_LCOL		= BIT(0),
 
 	CMD2_CLEAR 		= 0x3F7F3F7F,   /* Command style register */
 
@@ -54,79 +54,79 @@ typedef enum {
 typedef enum {
 
 	/* VAL3 */
-	ASF_INIT_DONE_ALIAS	= (1 << 29),
+	ASF_INIT_DONE_ALIAS	= BIT(29),
 	/* VAL2 */
-	JUMBO			= (1 << 21),
-	VSIZE			= (1 << 20),
-	VLONLY			= (1 << 19),
-	VL_TAG_DEL		= (1 << 18),
+	JUMBO			= BIT(21),
+	VSIZE			= BIT(20),
+	VLONLY			= BIT(19),
+	VL_TAG_DEL		= BIT(18),
 	/* VAL1 */
-	EN_PMGR			= (1 << 14),
-	INTLEVEL		= (1 << 13),
-	FORCE_FULL_DUPLEX	= (1 << 12),
-	FORCE_LINK_STATUS	= (1 << 11),
-	APEP			= (1 << 10),
-	MPPLBA			= (1 << 9),
+	EN_PMGR			= BIT(14),
+	INTLEVEL		= BIT(13),
+	FORCE_FULL_DUPLEX	= BIT(12),
+	FORCE_LINK_STATUS	= BIT(11),
+	APEP			= BIT(10),
+	MPPLBA			= BIT(9),
 	/* VAL0 */
-	RESET_PHY_PULSE		= (1 << 2),
-	RESET_PHY		= (1 << 1),
-	PHY_RST_POL		= (1 << 0),
+	RESET_PHY_PULSE		= BIT(2),
+	RESET_PHY		= BIT(1),
+	PHY_RST_POL		= BIT(0),
 
 }CMD3_BITS;
 typedef enum {
 
-	INTR			= (1UL << 31),
-	PCSINT			= (1 << 28),
-	LCINT			= (1 << 27),
-	APINT5			= (1 << 26),
-	APINT4			= (1 << 25),
-	APINT3			= (1 << 24),
-	TINT_SUM		= (1 << 23),
-	APINT2			= (1 << 22),
-	APINT1			= (1 << 21),
-	APINT0			= (1 << 20),
-	MIIPDTINT		= (1 << 19),
-	MCCINT			= (1 << 17),
-	MREINT			= (1 << 16),
-	RINT_SUM		= (1 << 15),
-	SPNDINT			= (1 << 14),
-	MPINT			= (1 << 13),
-	SINT			= (1 << 12),
-	TINT3			= (1 << 11),
-	TINT2			= (1 << 10),
-	TINT1			= (1 << 9),
-	TINT0			= (1 << 8),
-	UINT			= (1 << 7),
-	STINT			= (1 << 4),
-	RINT0			= (1 << 0),
+	INTR			= BIT(31),
+	PCSINT			= BIT(28),
+	LCINT			= BIT(27),
+	APINT5			= BIT(26),
+	APINT4			= BIT(25),
+	APINT3			= BIT(24),
+	TINT_SUM		= BIT(23),
+	APINT2			= BIT(22),
+	APINT1			= BIT(21),
+	APINT0			= BIT(20),
+	MIIPDTINT		= BIT(19),
+	MCCINT			= BIT(17),
+	MREINT			= BIT(16),
+	RINT_SUM		= BIT(15),
+	SPNDINT			= BIT(14),
+	MPINT			= BIT(13),
+	SINT			= BIT(12),
+	TINT3			= BIT(11),
+	TINT2			= BIT(10),
+	TINT1			= BIT(9),
+	TINT0			= BIT(8),
+	UINT			= BIT(7),
+	STINT			= BIT(4),
+	RINT0			= BIT(0),
 
 }INT0_BITS;
 typedef enum {
 
 	/* VAL3 */
-	LCINTEN			= (1 << 27),
-	APINT5EN		= (1 << 26),
-	APINT4EN		= (1 << 25),
-	APINT3EN		= (1 << 24),
+	LCINTEN			= BIT(27),
+	APINT5EN		= BIT(26),
+	APINT4EN		= BIT(25),
+	APINT3EN		= BIT(24),
 	/* VAL2 */
-	APINT2EN		= (1 << 22),
-	APINT1EN		= (1 << 21),
-	APINT0EN		= (1 << 20),
-	MIIPDTINTEN		= (1 << 19),
-	MCCIINTEN		= (1 << 18),
-	MCCINTEN		= (1 << 17),
-	MREINTEN		= (1 << 16),
+	APINT2EN		= BIT(22),
+	APINT1EN		= BIT(21),
+	APINT0EN		= BIT(20),
+	MIIPDTINTEN		= BIT(19),
+	MCCIINTEN		= BIT(18),
+	MCCINTEN		= BIT(17),
+	MREINTEN		= BIT(16),
 	/* VAL1 */
-	SPNDINTEN		= (1 << 14),
-	MPINTEN			= (1 << 13),
-	TINTEN3			= (1 << 11),
-	SINTEN			= (1 << 12),
-	TINTEN2			= (1 << 10),
-	TINTEN1			= (1 << 9),
-	TINTEN0			= (1 << 8),
+	SPNDINTEN		= BIT(14),
+	MPINTEN			= BIT(13),
+	TINTEN3			= BIT(11),
+	SINTEN			= BIT(12),
+	TINTEN2			= BIT(10),
+	TINTEN1			= BIT(9),
+	TINTEN0			= BIT(8),
 	/* VAL0 */
-	STINTEN			= (1 << 4),
-	RINTEN0			= (1 << 0),
+	STINTEN			= BIT(4),
+	RINTEN0			= BIT(0),
 
 	INTEN0_CLEAR 		= 0x1F7F7F1F, /* Command style register */
 
@@ -134,17 +134,17 @@ typedef enum {
 
 typedef enum {
 
-	PMAT_DET		= (1 << 12),
-	MP_DET		        = (1 << 11),
-	LC_DET			= (1 << 10),
-	SPEED_MASK		= (1 << 9)|(1 << 8)|(1 << 7),
-	FULL_DPLX		= (1 << 6),
-	LINK_STATS		= (1 << 5),
-	AUTONEG_COMPLETE	= (1 << 4),
-	MIIPD			= (1 << 3),
-	RX_SUSPENDED		= (1 << 2),
-	TX_SUSPENDED		= (1 << 1),
-	RUNNING			= (1 << 0),
+	PMAT_DET		= BIT(12),
+	MP_DET		        = BIT(11),
+	LC_DET			= BIT(10),
+	SPEED_MASK		= BIT(9) | BIT(8) | BIT(7),
+	FULL_DPLX		= BIT(6),
+	LINK_STATS		= BIT(5),
+	AUTONEG_COMPLETE	= BIT(4),
+	MIIPD			= BIT(3),
+	RX_SUSPENDED		= BIT(2),
+	TX_SUSPENDED		= BIT(1),
+	RUNNING			= BIT(0),
 
 }STAT0_BITS;
 
diff --git a/de2104x.c b/de2104x.c
index 190422fb2249..a429281272b5 100644
--- a/de2104x.c
+++ b/de2104x.c
@@ -97,7 +97,7 @@ print_rx_missed(u32 csr8)
 {
 	fprintf(stdout,
 		"0x40: CSR8 (Missed Frames Counter)       0x%08x\n", csr8);
-	if (csr8 & (1 << 16))
+	if (csr8 & BIT(16))
 		fprintf(stdout,
 		"      Counter overflow\n");
 	else {
@@ -131,7 +131,7 @@ static void de21040_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		,
 		v,
 		csr0_tap[(v >> 17) & 3],
-		v & (1 << 16) ? "Diagnostic" : "Standard",
+		v & BIT(16) ? "Diagnostic" : "Standard",
 		csr0_cache_al[(v >> 14) & 3]);
 	tmp = (v >> 8) & 0x3f;
 	if (tmp == 0)
@@ -145,10 +145,10 @@ static void de21040_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"      Descriptor skip length %d longwords\n"
 		"      %s bus arbitration scheme\n"
 		,
-		v & (1 << 7) ? "Big" : "Little",
+		v & BIT(7) ? "Big" : "Little",
 		(v >> 2) & 0x1f,
-		v & (1 << 1) ? "Round-robin" : "RX-has-priority");
-	if (v & (1 << 0))
+		v & BIT(1) ? "Round-robin" : "RX-has-priority");
+	if (v & BIT(0))
 		fprintf(stdout, "      Software reset asserted\n");
 
 	/*
@@ -168,29 +168,29 @@ static void de21040_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"      Link %s\n"
 		,
 		v,
-		v & (1 << 13) ? csr5_buserr[(v >> 23) & 0x7] : "",
+		v & BIT(13) ? csr5_buserr[(v >> 23) & 0x7] : "",
 		csr5_tx_state[(v >> 20) & 0x7],
 		csr5_rx_state[(v >> 17) & 0x7],
-		v & (1 << 12) ? "fail" : "OK");
-	if (v & (1 << 16))
+		v & BIT(12) ? "fail" : "OK");
+	if (v & BIT(16))
 		fprintf(stdout,
 		"      Normal interrupts: %s%s%s\n"
 		,
-		v & (1 << 0) ? "TxOK " : "",
-		v & (1 << 2) ? "TxNoBufs " : "",
-		v & (1 << 6) ? "RxOK" : "");
-	if (v & (1 << 15))
+		v & BIT(0) ? "TxOK " : "",
+		v & BIT(2) ? "TxNoBufs " : "",
+		v & BIT(6) ? "RxOK" : "");
+	if (v & BIT(15))
 		fprintf(stdout,
 		"      Abnormal intr: %s%s%s%s%s%s%s%s\n"
 		,
-		v & (1 << 1) ? "TxStop " : "",
-		v & (1 << 3) ? "TxJabber " : "",
-		v & (1 << 5) ? "TxUnder " : "",
-		v & (1 << 7) ? "RxNoBufs " : "",
-		v & (1 << 8) ? "RxStopped " : "",
-		v & (1 << 9) ? "RxTimeout " : "",
-		v & (1 << 10) ? "AUI_TP " : "",
-		v & (1 << 11) ? "FD_Short " : "");
+		v & BIT(1) ? "TxStop " : "",
+		v & BIT(3) ? "TxJabber " : "",
+		v & BIT(5) ? "TxUnder " : "",
+		v & BIT(7) ? "RxNoBufs " : "",
+		v & BIT(8) ? "RxStopped " : "",
+		v & BIT(9) ? "RxTimeout " : "",
+		v & BIT(10) ? "AUI_TP " : "",
+		v & BIT(11) ? "FD_Short " : "");
 
 	/*
 	 * CSR6
@@ -216,22 +216,22 @@ static void de21040_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"      %s filtering mode\n"
 		,
 		v,
-		v & (1<<17) ? "      Capture effect enabled\n" : "",
-		v & (1<<16) ? "      Back pressure enabled\n" : "",
+		v & BIT(17) ? "      Capture effect enabled\n" : "",
+		v & BIT(16) ? "      Back pressure enabled\n" : "",
 		csr6_tx_thresh[(v >> 14) & 3],
-		v & (1<<13) ? "en" : "dis",
-		v & (1<<12) ? "      Forcing collisions\n" : "",
+		v & BIT(13) ? "en" : "dis",
+		v & BIT(12) ? "      Forcing collisions\n" : "",
 		csr6_om[(v >> 10) & 3],
-		v & (1<<9) ? "Full" : "Half",
-		v & (1<<8) ? "      Flaky oscillator disable\n" : "",
-		v & (1<<7) ? "      Pass All Multicast\n" : "",
-		v & (1<<6) ? "      Promisc Mode\n" : "",
-		v & (1<<5) ? "      Start/Stop Backoff Counter\n" : "",
-		v & (1<<4) ? "      Inverse Filtering\n" : "",
-		v & (1<<3) ? "      Pass Bad Frames\n" : "",
-		v & (1<<2) ? "      Hash-only Filtering\n" : "",
-		v & (1<<1) ? "en" : "dis",
-		v & (1<<0) ? "Hash" : "Perfect");
+		v & BIT(9) ? "Full" : "Half",
+		v & BIT(8) ? "      Flaky oscillator disable\n" : "",
+		v & BIT(7) ? "      Pass All Multicast\n" : "",
+		v & BIT(6) ? "      Promisc Mode\n" : "",
+		v & BIT(5) ? "      Start/Stop Backoff Counter\n" : "",
+		v & BIT(4) ? "      Inverse Filtering\n" : "",
+		v & BIT(3) ? "      Pass Bad Frames\n" : "",
+		v & BIT(2) ? "      Hash-only Filtering\n" : "",
+		v & BIT(1) ? "en" : "dis",
+		v & BIT(0) ? "Hash" : "Perfect");
 
 	/*
 	 * CSR7
@@ -256,21 +256,21 @@ static void de21040_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"%s"
 		,
 		v,
-		v & (1<<16) ? "      Normal interrupt summary\n" : "",
-		v & (1<<15) ? "      Abnormal interrupt summary\n" : "",
-		v & (1<<13) ? "      System error\n" : "",
-		v & (1<<12) ? "      Link fail\n" : "",
-		v & (1<<11) ? "      Full duplex\n" : "",
-		v & (1<<10) ? "      AUI_TP pin\n" : "",
-		v & (1<<9) ? "      Receive watchdog timeout\n" : "",
-		v & (1<<8) ? "      Receive stopped\n" : "",
-		v & (1<<7) ? "      Receive buffer unavailable\n" : "",
-		v & (1<<6) ? "      Receive interrupt\n" : "",
-		v & (1<<5) ? "      Transmit underflow\n" : "",
-		v & (1<<3) ? "      Transmit jabber timeout\n" : "",
-		v & (1<<2) ? "      Transmit buffer unavailable\n" : "",
-		v & (1<<1) ? "      Transmit stopped\n" : "",
-		v & (1<<0) ? "      Transmit interrupt\n" : "");
+		v & BIT(16) ? "      Normal interrupt summary\n" : "",
+		v & BIT(15) ? "      Abnormal interrupt summary\n" : "",
+		v & BIT(13) ? "      System error\n" : "",
+		v & BIT(12) ? "      Link fail\n" : "",
+		v & BIT(11) ? "      Full duplex\n" : "",
+		v & BIT(10) ? "      AUI_TP pin\n" : "",
+		v & BIT(9) ? "      Receive watchdog timeout\n" : "",
+		v & BIT(8) ? "      Receive stopped\n" : "",
+		v & BIT(7) ? "      Receive buffer unavailable\n" : "",
+		v & BIT(6) ? "      Receive interrupt\n" : "",
+		v & BIT(5) ? "      Transmit underflow\n" : "",
+		v & BIT(3) ? "      Transmit jabber timeout\n" : "",
+		v & BIT(2) ? "      Transmit buffer unavailable\n" : "",
+		v & BIT(1) ? "      Transmit stopped\n" : "",
+		v & BIT(0) ? "      Transmit interrupt\n" : "");
 
 	/*
 	 * CSR8
@@ -307,14 +307,14 @@ static void de21040_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"      AUI_TP pin: %s\n"
 		,
 		v,
-		v & (1<<7) ? "      PLL sampler high\n" : "",
-		v & (1<<6) ? "      PLL sampler low\n" : "",
-		v & (1<<5) ? "      PLL self-test pass\n" : "",
-		v & (1<<4) ? "      PLL self-test done\n" : "",
-		v & (1<<3) ? "      Autopolarity state\n" : "",
-		v & (1<<2) ? "      Link fail\n" : "",
-		v & (1<<1) ? "      Network connection error\n" : "",
-		v & (1<<0) ? "AUI" : "TP");
+		v & BIT(7) ? "      PLL sampler high\n" : "",
+		v & BIT(6) ? "      PLL sampler low\n" : "",
+		v & BIT(5) ? "      PLL self-test pass\n" : "",
+		v & BIT(4) ? "      PLL self-test done\n" : "",
+		v & BIT(3) ? "      Autopolarity state\n" : "",
+		v & BIT(2) ? "      Link fail\n" : "",
+		v & BIT(1) ? "      Network connection error\n" : "",
+		v & BIT(0) ? "AUI" : "TP");
 
 	/*
 	 * CSR13
@@ -337,22 +337,22 @@ static void de21040_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"%s"
 		,
 		v,
-		v & (1<<15) ? "      Enable pins 5, 6, 7\n" : "",
-		v & (1<<14) ? "      Enable pins 2, 4\n" : "",
-		v & (1<<13) ? "      Enable pins 1, 3\n" : "",
-		v & (1<<12) ? "      Input enable\n" : "",
-		v & (1<<11) ? 1 : 0,
-		v & (1<<10) ? 1 : 0,
-		v & (1<<9) ? 1 : 0,
-		v & (1<<8) ? 1 : 0,
-		v & (1<<7) ? "      APLL start\n" : "",
-		v & (1<<6) ? "      Serial interface input multiplexer\n" : "",
-		v & (1<<5) ? "      Encoder input multiplexer\n" : "",
-		v & (1<<4) ? "      SIA PLL external input enable\n" : "",
-		v & (1<<3) ? "AUI" : "10base-T",
-		v & (1<<2) ? "      CSR autoconfiguration\n" : "",
-		v & (1<<1) ? "      AUI_TP pin autoconfiguration\n" : "",
-		v & (1<<0) ? "      SIA reset\n" : "");
+		v & BIT(15) ? "      Enable pins 5, 6, 7\n" : "",
+		v & BIT(14) ? "      Enable pins 2, 4\n" : "",
+		v & BIT(13) ? "      Enable pins 1, 3\n" : "",
+		v & BIT(12) ? "      Input enable\n" : "",
+		v & BIT(11) ? 1 : 0,
+		v & BIT(10) ? 1 : 0,
+		v & BIT(9) ? 1 : 0,
+		v & BIT(8) ? 1 : 0,
+		v & BIT(7) ? "      APLL start\n" : "",
+		v & BIT(6) ? "      Serial interface input multiplexer\n" : "",
+		v & BIT(5) ? "      Encoder input multiplexer\n" : "",
+		v & BIT(4) ? "      SIA PLL external input enable\n" : "",
+		v & BIT(3) ? "AUI" : "10base-T",
+		v & BIT(2) ? "      CSR autoconfiguration\n" : "",
+		v & BIT(1) ? "      AUI_TP pin autoconfiguration\n" : "",
+		v & BIT(0) ? "      SIA reset\n" : "");
 
 	/*
 	 * CSR14
@@ -374,18 +374,18 @@ static void de21040_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"%s"
 		,
 		v,
-		v & (1<<14) ? "      Set polarity plus\n" : "",
-		v & (1<<13) ? "      Autopolarity enable\n" : "",
-		v & (1<<12) ? "      Link test enable\n" : "",
-		v & (1<<11) ? "      Heartbeat enable\n" : "",
-		v & (1<<10) ? "      Collision detect enable\n" : "",
-		v & (1<<9) ? "      Collision squelch enable\n" : "",
-		v & (1<<8) ? "      Receive squelch enable\n" : "",
+		v & BIT(14) ? "      Set polarity plus\n" : "",
+		v & BIT(13) ? "      Autopolarity enable\n" : "",
+		v & BIT(12) ? "      Link test enable\n" : "",
+		v & BIT(11) ? "      Heartbeat enable\n" : "",
+		v & BIT(10) ? "      Collision detect enable\n" : "",
+		v & BIT(9) ? "      Collision squelch enable\n" : "",
+		v & BIT(8) ? "      Receive squelch enable\n" : "",
 		csr14_tp_comp[(v >> 4) & 0x3],
-		v & (1<<3) ? "      Link pulse send enable\n" : "",
-		v & (1<<2) ? "      Driver enable\n" : "",
-		v & (1<<1) ? "      Loopback enable\n" : "",
-		v & (1<<0) ? "      Encoder enable\n" : "");
+		v & BIT(3) ? "      Link pulse send enable\n" : "",
+		v & BIT(2) ? "      Driver enable\n" : "",
+		v & BIT(1) ? "      Loopback enable\n" : "",
+		v & BIT(0) ? "      Encoder enable\n" : "");
 
 	/*
 	 * CSR15
@@ -405,16 +405,16 @@ static void de21040_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"%s"
 		,
 		v,
-		v & (1<<13) ? "      Force receiver low\n" : "",
-		v & (1<<12) ? "      PLL self-test start\n" : "",
-		v & (1<<11) ? "      Force link fail\n" : "",
-		v & (1<<9) ? "      Force unsquelch\n" : "",
-		v & (1<<8) ? "      Test clock\n" : "",
-		v & (1<<5) ? "      Receive watchdog release\n" : "",
-		v & (1<<4) ? "      Receive watchdog disable\n" : "",
-		v & (1<<2) ? "      Jabber clock\n" : "",
-		v & (1<<1) ? "      Host unjab\n" : "",
-		v & (1<<0) ? "      Jabber disable\n" : "");
+		v & BIT(13) ? "      Force receiver low\n" : "",
+		v & BIT(12) ? "      PLL self-test start\n" : "",
+		v & BIT(11) ? "      Force link fail\n" : "",
+		v & BIT(9) ? "      Force unsquelch\n" : "",
+		v & BIT(8) ? "      Test clock\n" : "",
+		v & BIT(5) ? "      Receive watchdog release\n" : "",
+		v & BIT(4) ? "      Receive watchdog disable\n" : "",
+		v & BIT(2) ? "      Jabber clock\n" : "",
+		v & BIT(1) ? "      Host unjab\n" : "",
+		v & BIT(0) ? "      Jabber disable\n" : "");
 }
 
 static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
@@ -437,9 +437,9 @@ static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"      Cache alignment: %s\n"
 		,
 		v,
-		v & (1 << 20) ? "Big" : "Little",
+		v & BIT(20) ? "Big" : "Little",
 		csr0_tap[(v >> 17) & 3],
-		v & (1 << 16) ? "Diagnostic" : "Standard",
+		v & BIT(16) ? "Diagnostic" : "Standard",
 		csr0_cache_al[(v >> 14) & 3]);
 	tmp = (v >> 8) & 0x3f;
 	if (tmp == 0)
@@ -453,10 +453,10 @@ static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"      Descriptor skip length %d longwords\n"
 		"      %s bus arbitration scheme\n"
 		,
-		v & (1 << 7) ? "Big" : "Little",
+		v & BIT(7) ? "Big" : "Little",
 		(v >> 2) & 0x1f,
-		v & (1 << 1) ? "Round-robin" : "RX-has-priority");
-	if (v & (1 << 0))
+		v & BIT(1) ? "Round-robin" : "RX-has-priority");
+	if (v & BIT(0))
 		fprintf(stdout, "      Software reset asserted\n");
 
 	/*
@@ -476,30 +476,30 @@ static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"      Link %s\n"
 		,
 		v,
-		v & (1 << 13) ? csr5_buserr[(v >> 23) & 0x7] : "",
+		v & BIT(13) ? csr5_buserr[(v >> 23) & 0x7] : "",
 		csr5_tx_state[(v >> 20) & 0x7],
 		csr5_rx_state[(v >> 17) & 0x7],
-		v & (1 << 12) ? "fail" : "OK");
-	if (v & (1 << 16))
+		v & BIT(12) ? "fail" : "OK");
+	if (v & BIT(16))
 		fprintf(stdout,
 		"      Normal interrupts: %s%s%s%s%s\n"
 		,
-		v & (1 << 0) ? "TxOK " : "",
-		v & (1 << 2) ? "TxNoBufs " : "",
-		v & (1 << 6) ? "RxOK" : "",
-		v & (1 << 11) ? "TimerExp " : "",
-		v & (1 << 14) ? "EarlyRx " : "");
-	if (v & (1 << 15))
+		v & BIT(0) ? "TxOK " : "",
+		v & BIT(2) ? "TxNoBufs " : "",
+		v & BIT(6) ? "RxOK" : "",
+		v & BIT(11) ? "TimerExp " : "",
+		v & BIT(14) ? "EarlyRx " : "");
+	if (v & BIT(15))
 		fprintf(stdout,
 		"      Abnormal intr: %s%s%s%s%s%s%s\n"
 		,
-		v & (1 << 1) ? "TxStop " : "",
-		v & (1 << 3) ? "TxJabber " : "",
-		v & (1 << 4) ? "ANC " : "",
-		v & (1 << 5) ? "TxUnder " : "",
-		v & (1 << 7) ? "RxNoBufs " : "",
-		v & (1 << 8) ? "RxStopped " : "",
-		v & (1 << 9) ? "RxTimeout " : "");
+		v & BIT(1) ? "TxStop " : "",
+		v & BIT(3) ? "TxJabber " : "",
+		v & BIT(4) ? "ANC " : "",
+		v & BIT(5) ? "TxUnder " : "",
+		v & BIT(7) ? "RxNoBufs " : "",
+		v & BIT(8) ? "RxStopped " : "",
+		v & BIT(9) ? "RxTimeout " : "");
 
 	/*
 	 * CSR6
@@ -525,22 +525,22 @@ static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"      %s filtering mode\n"
 		,
 		v,
-		v & (1<<31) ? "      Special capture effect enabled\n" : "",
-		v & (1<<17) ? "      Capture effect enabled\n" : "",
+		v & BIT(31) ? "      Special capture effect enabled\n" : "",
+		v & BIT(17) ? "      Capture effect enabled\n" : "",
 		csr6_tx_thresh[(v >> 14) & 3],
-		v & (1<<13) ? "en" : "dis",
-		v & (1<<12) ? "      Forcing collisions\n" : "",
+		v & BIT(13) ? "en" : "dis",
+		v & BIT(12) ? "      Forcing collisions\n" : "",
 		csr6_om[(v >> 10) & 3],
-		v & (1<<9) ? "Full" : "Half",
-		v & (1<<8) ? "      Flaky oscillator disable\n" : "",
-		v & (1<<7) ? "      Pass All Multicast\n" : "",
-		v & (1<<6) ? "      Promisc Mode\n" : "",
-		v & (1<<5) ? "      Start/Stop Backoff Counter\n" : "",
-		v & (1<<4) ? "      Inverse Filtering\n" : "",
-		v & (1<<3) ? "      Pass Bad Frames\n" : "",
-		v & (1<<2) ? "      Hash-only Filtering\n" : "",
-		v & (1<<1) ? "en" : "dis",
-		v & (1<<0) ? "Hash" : "Perfect");
+		v & BIT(9) ? "Full" : "Half",
+		v & BIT(8) ? "      Flaky oscillator disable\n" : "",
+		v & BIT(7) ? "      Pass All Multicast\n" : "",
+		v & BIT(6) ? "      Promisc Mode\n" : "",
+		v & BIT(5) ? "      Start/Stop Backoff Counter\n" : "",
+		v & BIT(4) ? "      Inverse Filtering\n" : "",
+		v & BIT(3) ? "      Pass Bad Frames\n" : "",
+		v & BIT(2) ? "      Hash-only Filtering\n" : "",
+		v & BIT(1) ? "en" : "dis",
+		v & BIT(0) ? "Hash" : "Perfect");
 
 	/*
 	 * CSR7
@@ -566,22 +566,22 @@ static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"%s"
 		,
 		v,
-		v & (1<<16) ? "      Normal interrupt summary\n" : "",
-		v & (1<<15) ? "      Abnormal interrupt summary\n" : "",
-		v & (1<<14) ? "      Early receive interrupt\n" : "",
-		v & (1<<13) ? "      System error\n" : "",
-		v & (1<<12) ? "      Link fail\n" : "",
-		v & (1<<11) ? "      Timer expired\n" : "",
-		v & (1<<9) ? "      Receive watchdog timeout\n" : "",
-		v & (1<<8) ? "      Receive stopped\n" : "",
-		v & (1<<7) ? "      Receive buffer unavailable\n" : "",
-		v & (1<<6) ? "      Receive interrupt\n" : "",
-		v & (1<<5) ? "      Transmit underflow\n" : "",
-		v & (1<<4) ? "      Link pass\n" : "",
-		v & (1<<3) ? "      Transmit jabber timeout\n" : "",
-		v & (1<<2) ? "      Transmit buffer unavailable\n" : "",
-		v & (1<<1) ? "      Transmit stopped\n" : "",
-		v & (1<<0) ? "      Transmit interrupt\n" : "");
+		v & BIT(16) ? "      Normal interrupt summary\n" : "",
+		v & BIT(15) ? "      Abnormal interrupt summary\n" : "",
+		v & BIT(14) ? "      Early receive interrupt\n" : "",
+		v & BIT(13) ? "      System error\n" : "",
+		v & BIT(12) ? "      Link fail\n" : "",
+		v & BIT(11) ? "      Timer expired\n" : "",
+		v & BIT(9) ? "      Receive watchdog timeout\n" : "",
+		v & BIT(8) ? "      Receive stopped\n" : "",
+		v & BIT(7) ? "      Receive buffer unavailable\n" : "",
+		v & BIT(6) ? "      Receive interrupt\n" : "",
+		v & BIT(5) ? "      Transmit underflow\n" : "",
+		v & BIT(4) ? "      Link pass\n" : "",
+		v & BIT(3) ? "      Transmit jabber timeout\n" : "",
+		v & BIT(2) ? "      Transmit buffer unavailable\n" : "",
+		v & BIT(1) ? "      Transmit stopped\n" : "",
+		v & BIT(0) ? "      Transmit interrupt\n" : "");
 
 	/*
 	 * CSR8
@@ -598,20 +598,20 @@ static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"      Data: %d%d%d%d%d%d%d%d\n"
 		,
 		v,
-		v & (1<<15) ? "Mode " : "",
-		v & (1<<14) ? "Read " : "",
-		v & (1<<13) ? "Write " : "",
-		v & (1<<12) ? "BootROM " : "",
-		v & (1<<11) ? "SROM " : "",
-		v & (1<<10) ? "ExtReg " : "",
-		v & (1<<7) ? 1 : 0,
-		v & (1<<6) ? 1 : 0,
-		v & (1<<5) ? 1 : 0,
-		v & (1<<4) ? 1 : 0,
-		v & (1<<3) ? 1 : 0,
-		v & (1<<2) ? 1 : 0,
-		v & (1<<1) ? 1 : 0,
-		v & (1<<0) ? 1 : 0);
+		v & BIT(15) ? "Mode " : "",
+		v & BIT(14) ? "Read " : "",
+		v & BIT(13) ? "Write " : "",
+		v & BIT(12) ? "BootROM " : "",
+		v & BIT(11) ? "SROM " : "",
+		v & BIT(10) ? "ExtReg " : "",
+		v & BIT(7) ? 1 : 0,
+		v & BIT(6) ? 1 : 0,
+		v & BIT(5) ? 1 : 0,
+		v & BIT(4) ? 1 : 0,
+		v & BIT(3) ? 1 : 0,
+		v & BIT(2) ? 1 : 0,
+		v & BIT(1) ? 1 : 0,
+		v & BIT(0) ? 1 : 0);
 
 	/*
 	 * CSR10
@@ -630,7 +630,7 @@ static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"      Timer value: %u cycles\n"
 		,
 		v,
-		v & (1<<16) ? "      Continuous mode\n" : "",
+		v & BIT(16) ? "      Continuous mode\n" : "",
 		v & 0xffff);
 
 	/*
@@ -656,19 +656,19 @@ static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		,
 		v,
 		v >> 16,
-		v & (1<<15) ? "      Link partner negotiable\n" : "",
+		v & BIT(15) ? "      Link partner negotiable\n" : "",
 		csr12_nway_state[(v >> 12) & 0x7],
-		v & (1<<11) ? "      Transmit remote fault\n" : "",
-		v & (1<<10) ? "      Unstable NLP detected\n" : "",
-		v & (1<<9) ? "      Non-selected port receive activity\n" : "",
-		v & (1<<8) ? "      Selected port receive activity\n" : "",
-		v & (1<<7) ? "      PLL sampler high\n" : "",
-		v & (1<<6) ? "      PLL sampler low\n" : "",
-		v & (1<<5) ? "      PLL self-test pass\n" : "",
-		v & (1<<4) ? "      PLL self-test done\n" : "",
-		v & (1<<3) ? "      Autopolarity state\n" : "",
-		v & (1<<2) ? "      Link fail\n" : "",
-		v & (1<<1) ? "      Network connection error\n" : "");
+		v & BIT(11) ? "      Transmit remote fault\n" : "",
+		v & BIT(10) ? "      Unstable NLP detected\n" : "",
+		v & BIT(9) ? "      Non-selected port receive activity\n" : "",
+		v & BIT(8) ? "      Selected port receive activity\n" : "",
+		v & BIT(7) ? "      PLL sampler high\n" : "",
+		v & BIT(6) ? "      PLL sampler low\n" : "",
+		v & BIT(5) ? "      PLL self-test pass\n" : "",
+		v & BIT(4) ? "      PLL self-test done\n" : "",
+		v & BIT(3) ? "      Autopolarity state\n" : "",
+		v & BIT(2) ? "      Link fail\n" : "",
+		v & BIT(1) ? "      Network connection error\n" : "");
 
 	/*
 	 * CSR13
@@ -683,9 +683,9 @@ static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		,
 		v,
 		(v >> 4) & 0xfff,
-		v & (1<<3) ? "AUI/BNC port" : "10base-T port",
-		v & (1<<2) ? "      CSR autoconfiguration enabled\n" : "",
-		v & (1<<0) ? "      SIA register reset asserted\n" : "");
+		v & BIT(3) ? "AUI/BNC port" : "10base-T port",
+		v & BIT(2) ? "      CSR autoconfiguration enabled\n" : "",
+		v & BIT(0) ? "      SIA register reset asserted\n" : "");
 
 	/*
 	 * CSR14
@@ -710,21 +710,21 @@ static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"%s"
 		,
 		v,
-		v & (1<<15) ? "      10base-T/AUI autosensing\n" : "",
-		v & (1<<14) ? "      Set polarity plus\n" : "",
-		v & (1<<13) ? "      Autopolarity enable\n" : "",
-		v & (1<<12) ? "      Link test enable\n" : "",
-		v & (1<<11) ? "      Heartbeat enable\n" : "",
-		v & (1<<10) ? "      Collision detect enable\n" : "",
-		v & (1<<9) ? "      Collision squelch enable\n" : "",
-		v & (1<<8) ? "      Receive squelch enable\n" : "",
-		v & (1<<7) ? "      Autonegotiation enable\n" : "",
-		v & (1<<6) ? "      Must Be One\n" : "",
+		v & BIT(15) ? "      10base-T/AUI autosensing\n" : "",
+		v & BIT(14) ? "      Set polarity plus\n" : "",
+		v & BIT(13) ? "      Autopolarity enable\n" : "",
+		v & BIT(12) ? "      Link test enable\n" : "",
+		v & BIT(11) ? "      Heartbeat enable\n" : "",
+		v & BIT(10) ? "      Collision detect enable\n" : "",
+		v & BIT(9) ? "      Collision squelch enable\n" : "",
+		v & BIT(8) ? "      Receive squelch enable\n" : "",
+		v & BIT(7) ? "      Autonegotiation enable\n" : "",
+		v & BIT(6) ? "      Must Be One\n" : "",
 		csr14_tp_comp[(v >> 4) & 0x3],
-		v & (1<<3) ? "      Link pulse send enable\n" : "",
-		v & (1<<2) ? "      Driver enable\n" : "",
-		v & (1<<1) ? "      Loopback enable\n" : "",
-		v & (1<<0) ? "      Encoder enable\n" : "");
+		v & BIT(3) ? "      Link pulse send enable\n" : "",
+		v & BIT(2) ? "      Driver enable\n" : "",
+		v & BIT(1) ? "      Loopback enable\n" : "",
+		v & BIT(0) ? "      Encoder enable\n" : "");
 
 	/*
 	 * CSR15
@@ -750,22 +750,22 @@ static void de21041_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"%s"
 		,
 		v,
-		v & (1<<15) ? "      GP LED2 on\n" : "",
-		v & (1<<14) ? "      GP LED2 enable\n" : "",
-		v & (1<<13) ? "      Force receiver low\n" : "",
-		v & (1<<12) ? "      PLL self-test start\n" : "",
-		v & (1<<11) ? "      LED stretch disable\n" : "",
-		v & (1<<10) ? "      Force link fail\n" : "",
-		v & (1<<9) ? "      Force unsquelch\n" : "",
-		v & (1<<8) ? "      Test clock\n" : "",
-		v & (1<<7) ? "      GP LED1 on\n" : "",
-		v & (1<<6) ? "      GP LED1 enable\n" : "",
-		v & (1<<5) ? "      Receive watchdog release\n" : "",
-		v & (1<<4) ? "      Receive watchdog disable\n" : "",
-		v & (1<<3) ? "AUI" : "BNC",
-		v & (1<<2) ? "      Jabber clock\n" : "",
-		v & (1<<1) ? "      Host unjab\n" : "",
-		v & (1<<0) ? "      Jabber disable\n" : "");
+		v & BIT(15) ? "      GP LED2 on\n" : "",
+		v & BIT(14) ? "      GP LED2 enable\n" : "",
+		v & BIT(13) ? "      Force receiver low\n" : "",
+		v & BIT(12) ? "      PLL self-test start\n" : "",
+		v & BIT(11) ? "      LED stretch disable\n" : "",
+		v & BIT(10) ? "      Force link fail\n" : "",
+		v & BIT(9) ? "      Force unsquelch\n" : "",
+		v & BIT(8) ? "      Test clock\n" : "",
+		v & BIT(7) ? "      GP LED1 on\n" : "",
+		v & BIT(6) ? "      GP LED1 enable\n" : "",
+		v & BIT(5) ? "      Receive watchdog release\n" : "",
+		v & BIT(4) ? "      Receive watchdog disable\n" : "",
+		v & BIT(3) ? "AUI" : "BNC",
+		v & BIT(2) ? "      Jabber clock\n" : "",
+		v & BIT(1) ? "      Host unjab\n" : "",
+		v & BIT(0) ? "      Jabber disable\n" : "");
 }
 
 int
diff --git a/ethtool.c b/ethtool.c
index a72577b32601..4776afe89e23 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -128,7 +128,7 @@ struct feature_defs {
 
 #define FEATURE_BITS_TO_BLOCKS(n_bits)		DIV_ROUND_UP(n_bits, 32U)
 #define FEATURE_WORD(blocks, index, field)	((blocks)[(index) / 32U].field)
-#define FEATURE_FIELD_FLAG(index)		(1U << (index) % 32U)
+#define FEATURE_FIELD_FLAG(index)		(BIT((index)) % 32U)
 #define FEATURE_BIT_SET(blocks, index, field)			\
 	(FEATURE_WORD(blocks, index, field) |= FEATURE_FIELD_FLAG(index))
 #define FEATURE_BIT_CLEAR(blocks, index, field)			\
@@ -1667,7 +1667,7 @@ static int dump_tsinfo(const struct ethtool_ts_info *info)
 	fprintf(stdout, "Capabilities:\n");
 
 	for (i = 0; i < N_SOTS; i++) {
-		if (info->so_timestamping & (1 << i))
+		if (info->so_timestamping & BIT(i))
 			fprintf(stdout, "\t%s\n", so_timestamping_labels[i]);
 	}
 
@@ -1686,7 +1686,7 @@ static int dump_tsinfo(const struct ethtool_ts_info *info)
 		fprintf(stdout, "\n");
 
 	for (i = 0; i < N_TX_TYPES; i++) {
-		if (info->tx_types & (1 << i))
+		if (info->tx_types & BIT(i))
 			fprintf(stdout,	"\t%s\n", tx_type_labels[i]);
 	}
 
@@ -1698,7 +1698,7 @@ static int dump_tsinfo(const struct ethtool_ts_info *info)
 		fprintf(stdout, "\n");
 
 	for (i = 0; i < N_RX_FILTERS; i++) {
-		if (info->rx_filters & (1 << i))
+		if (info->rx_filters & BIT(i))
 			fprintf(stdout, "\t%s\n", rx_filter_labels[i]);
 	}
 
@@ -1719,7 +1719,7 @@ get_stringset(struct cmd_context *ctx, enum ethtool_stringset set_id,
 
 	sset_info.hdr.cmd = ETHTOOL_GSSET_INFO;
 	sset_info.hdr.reserved = 0;
-	sset_info.hdr.sset_mask = 1ULL << set_id;
+	sset_info.hdr.sset_mask = BIT_ULL(set_id);
 	if (send_ioctl(ctx, &sset_info) == 0) {
 		const u32 *sset_lengths = sset_info.hdr.data;
 
@@ -4029,7 +4029,7 @@ static int do_grxfh(struct cmd_context *ctx)
 	for (i = 0; i < hfuncs->len; i++)
 		printf("    %s: %s\n",
 		       (const char *)hfuncs->data + i * ETH_GSTRING_LEN,
-		       (rss->hfunc & (1 << i)) ? "on" : "off");
+		       (rss->hfunc & BIT(i)) ? "on" : "off");
 
 out:
 	free(hfuncs);
@@ -4315,7 +4315,7 @@ static int do_srxfh(struct cmd_context *ctx)
 					      i * ETH_GSTRING_LEN);
 			if (!strncmp(hfunc_name, req_hfunc_name,
 				     ETH_GSTRING_LEN))
-				req_hfunc = (u32)1 << i;
+				req_hfunc = BIT(i);
 		}
 
 		if (!req_hfunc) {
@@ -4722,7 +4722,7 @@ static int do_gprivflags(struct cmd_context *ctx)
 		printf("%-*s: %s\n",
 		       max_len,
 		       (const char *)strings->data + i * ETH_GSTRING_LEN,
-		       (flags.data & (1U << i)) ? "on" : "off");
+		       (flags.data & BIT(i)) ? "on" : "off");
 
 	rc = 0;
 
@@ -4769,7 +4769,7 @@ static int do_sprivflags(struct cmd_context *ctx)
 				   i * ETH_GSTRING_LEN);
 		cmdline[i].type = CMDL_FLAG;
 		cmdline[i].wanted_val = &wanted_flags;
-		cmdline[i].flag_val = 1U << i;
+		cmdline[i].flag_val = BIT(i);
 		cmdline[i].seen_val = &seen_flags;
 	}
 	parse_generic_cmdline(ctx, &any_changed, cmdline, strings->len);
diff --git a/internal.h b/internal.h
index 6e79374bcfd5..b5561d24c030 100644
--- a/internal.h
+++ b/internal.h
@@ -97,17 +97,17 @@ static inline u64 cpu_to_be64(u64 value)
 
 static inline void set_bit(unsigned int nr, unsigned long *addr)
 {
-	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
+	addr[nr / BITS_PER_LONG] |= BIT_ULL(nr % BITS_PER_LONG);
 }
 
 static inline void clear_bit(unsigned int nr, unsigned long *addr)
 {
-	addr[nr / BITS_PER_LONG] &= ~(1UL << (nr % BITS_PER_LONG));
+	addr[nr / BITS_PER_LONG] &= ~BIT_ULL(nr % BITS_PER_LONG);
 }
 
 static inline int test_bit(unsigned int nr, const unsigned long *addr)
 {
-	return !!((1UL << (nr % BITS_PER_LONG)) &
+	return !!(BIT_ULL(nr % BITS_PER_LONG) &
 		  (((unsigned long *)addr)[nr / BITS_PER_LONG]));
 }
 
@@ -130,19 +130,19 @@ enum {
 
 static inline bool debug_on(unsigned long debug, unsigned int bit)
 {
-	return (debug & (1 << bit));
+	return (debug & BIT(bit));
 }
 
 /* Internal values for old-style offload flags.  Values and names
  * must not clash with the flags defined for ETHTOOL_{G,S}FLAGS.
  */
-#define ETH_FLAG_RXCSUM		(1 << 0)
-#define ETH_FLAG_TXCSUM		(1 << 1)
-#define ETH_FLAG_SG		(1 << 2)
-#define ETH_FLAG_TSO		(1 << 3)
-#define ETH_FLAG_UFO		(1 << 4)
-#define ETH_FLAG_GSO		(1 << 5)
-#define ETH_FLAG_GRO		(1 << 6)
+#define ETH_FLAG_RXCSUM		BIT(0)
+#define ETH_FLAG_TXCSUM		BIT(1)
+#define ETH_FLAG_SG		BIT(2)
+#define ETH_FLAG_TSO		BIT(3)
+#define ETH_FLAG_UFO		BIT(4)
+#define ETH_FLAG_GSO		BIT(5)
+#define ETH_FLAG_GRO		BIT(6)
 #define ETH_FLAG_INT_MASK	(ETH_FLAG_RXCSUM | ETH_FLAG_TXCSUM |	\
 				 ETH_FLAG_SG | ETH_FLAG_TSO | ETH_FLAG_UFO | \
 				 ETH_FLAG_GSO | ETH_FLAG_GRO),
@@ -205,14 +205,14 @@ static inline int ethtool_link_mode_test_bit(unsigned int nr, const u32 *mask)
 {
 	if (nr >= ETHTOOL_LINK_MODE_MASK_MAX_KERNEL_NBITS)
 		return !!0;
-	return !!(mask[nr / 32] & (1UL << (nr % 32)));
+	return !!(mask[nr / 32] & BIT(nr % 32));
 }
 
 static inline int ethtool_link_mode_set_bit(unsigned int nr, u32 *mask)
 {
 	if (nr >= ETHTOOL_LINK_MODE_MASK_MAX_KERNEL_NBITS)
 		return -1;
-	mask[nr / 32] |= (1UL << (nr % 32));
+	mask[nr / 32] |= BIT(nr % 32);
 	return 0;
 }
 
diff --git a/natsemi.c b/natsemi.c
index 4d9fc092b623..43d38f3b337c 100644
--- a/natsemi.c
+++ b/natsemi.c
@@ -9,155 +9,155 @@
 
 /* register indices in the ethtool_regs->data */
 #define REG_CR				0
-#define   BIT_CR_TXE			(1<<0)
-#define   BIT_CR_RXE			(1<<2)
-#define   BIT_CR_RST			(1<<8)
+#define   BIT_CR_TXE			BIT(0)
+#define   BIT_CR_RXE			BIT(2)
+#define   BIT_CR_RST			BIT(8)
 #define REG_CFG				1
-#define   BIT_CFG_BEM			(1<<0)
-#define   BIT_CFG_BROM_DIS		(1<<2)
-#define   BIT_CFG_PHY_DIS		(1<<9)
-#define   BIT_CFG_PHY_RST		(1<<10)
-#define   BIT_CFG_EXT_PHY		(1<<12)
-#define   BIT_CFG_ANEG_EN		(1<<13)
-#define   BIT_CFG_ANEG_100		(1<<14)
-#define   BIT_CFG_ANEG_FDUP		(1<<15)
-#define   BIT_CFG_PINT_ACEN		(1<<17)
+#define   BIT_CFG_BEM			BIT(0)
+#define   BIT_CFG_BROM_DIS		BIT(2)
+#define   BIT_CFG_PHY_DIS		BIT(9)
+#define   BIT_CFG_PHY_RST		BIT(10)
+#define   BIT_CFG_EXT_PHY		BIT(12)
+#define   BIT_CFG_ANEG_EN		BIT(13)
+#define   BIT_CFG_ANEG_100		BIT(14)
+#define   BIT_CFG_ANEG_FDUP		BIT(15)
+#define   BIT_CFG_PINT_ACEN		BIT(17)
 #define   BIT_CFG_PHY_CFG		(0x3f<<18)
-#define   BIT_CFG_ANEG_DN		(1<<27)
-#define   BIT_CFG_POL			(1<<28)
-#define   BIT_CFG_FDUP			(1<<29)
-#define   BIT_CFG_SPEED100		(1<<30)
-#define   BIT_CFG_LNKSTS		(1<<31)
+#define   BIT_CFG_ANEG_DN		BIT(27)
+#define   BIT_CFG_POL			BIT(28)
+#define   BIT_CFG_FDUP			BIT(29)
+#define   BIT_CFG_SPEED100		BIT(30)
+#define   BIT_CFG_LNKSTS		BIT(31)
 
 #define REG_MEAR			2
 #define REG_PTSCR			3
-#define   BIT_PTSCR_EEBIST_FAIL		(1<<0)
-#define   BIT_PTSCR_EELOAD_EN		(1<<2)
-#define   BIT_PTSCR_RBIST_RXFFAIL	(1<<3)
-#define   BIT_PTSCR_RBIST_TXFAIL	(1<<4)
-#define   BIT_PTSCR_RBIST_RXFAIL	(1<<5)
+#define   BIT_PTSCR_EEBIST_FAIL		BIT(0)
+#define   BIT_PTSCR_EELOAD_EN		BIT(2)
+#define   BIT_PTSCR_RBIST_RXFFAIL	BIT(3)
+#define   BIT_PTSCR_RBIST_TXFAIL	BIT(4)
+#define   BIT_PTSCR_RBIST_RXFAIL	BIT(5)
 #define REG_ISR				4
 #define REG_IMR				5
-#define   BIT_INTR_RXOK			(1<<0)
+#define   BIT_INTR_RXOK			BIT(0)
 #define   NAME_INTR_RXOK		"Rx Complete"
-#define   BIT_INTR_RXDESC		(1<<1)
+#define   BIT_INTR_RXDESC		BIT(1)
 #define   NAME_INTR_RXDESC		"Rx Descriptor"
-#define   BIT_INTR_RXERR		(1<<2)
+#define   BIT_INTR_RXERR		BIT(2)
 #define   NAME_INTR_RXERR		"Rx Packet Error"
-#define   BIT_INTR_RXEARLY		(1<<3)
+#define   BIT_INTR_RXEARLY		BIT(3)
 #define   NAME_INTR_RXEARLY		"Rx Early Threshold"
-#define   BIT_INTR_RXIDLE		(1<<4)
+#define   BIT_INTR_RXIDLE		BIT(4)
 #define   NAME_INTR_RXIDLE		"Rx Idle"
-#define   BIT_INTR_RXORN		(1<<5)
+#define   BIT_INTR_RXORN		BIT(5)
 #define   NAME_INTR_RXORN		"Rx Overrun"
-#define   BIT_INTR_TXOK			(1<<6)
+#define   BIT_INTR_TXOK			BIT(6)
 #define   NAME_INTR_TXOK		"Tx Packet OK"
-#define   BIT_INTR_TXDESC		(1<<7)
+#define   BIT_INTR_TXDESC		BIT(7)
 #define   NAME_INTR_TXDESC		"Tx Descriptor"
-#define   BIT_INTR_TXERR		(1<<8)
+#define   BIT_INTR_TXERR		BIT(8)
 #define   NAME_INTR_TXERR		"Tx Packet Error"
-#define   BIT_INTR_TXIDLE		(1<<9)
+#define   BIT_INTR_TXIDLE		BIT(9)
 #define   NAME_INTR_TXIDLE		"Tx Idle"
-#define   BIT_INTR_TXURN		(1<<10)
+#define   BIT_INTR_TXURN		BIT(10)
 #define   NAME_INTR_TXURN		"Tx Underrun"
-#define   BIT_INTR_MIB			(1<<11)
+#define   BIT_INTR_MIB			BIT(11)
 #define   NAME_INTR_MIB			"MIB Service"
-#define   BIT_INTR_SWI			(1<<12)
+#define   BIT_INTR_SWI			BIT(12)
 #define   NAME_INTR_SWI			"Software"
-#define   BIT_INTR_PME			(1<<13)
+#define   BIT_INTR_PME			BIT(13)
 #define   NAME_INTR_PME			"Power Management Event"
-#define   BIT_INTR_PHY			(1<<14)
+#define   BIT_INTR_PHY			BIT(14)
 #define   NAME_INTR_PHY			"Phy"
-#define   BIT_INTR_HIBERR		(1<<15)
+#define   BIT_INTR_HIBERR		BIT(15)
 #define   NAME_INTR_HIBERR		"High Bits Error"
-#define   BIT_INTR_RXSOVR		(1<<16)
+#define   BIT_INTR_RXSOVR		BIT(16)
 #define   NAME_INTR_RXSOVR		"Rx Status FIFO Overrun"
-#define   BIT_INTR_RTABT		(1<<20)
+#define   BIT_INTR_RTABT		BIT(20)
 #define   NAME_INTR_RTABT		"Received Target Abort"
-#define   BIT_INTR_RMABT		(1<<20)
+#define   BIT_INTR_RMABT		BIT(20)
 #define   NAME_INTR_RMABT		"Received Master Abort"
-#define   BIT_INTR_SSERR		(1<<20)
+#define   BIT_INTR_SSERR		BIT(20)
 #define   NAME_INTR_SSERR		"Signaled System Error"
-#define   BIT_INTR_DPERR		(1<<20)
+#define   BIT_INTR_DPERR		BIT(20)
 #define   NAME_INTR_DPERR		"Detected Parity Error"
-#define   BIT_INTR_RXRCMP		(1<<20)
+#define   BIT_INTR_RXRCMP		BIT(20)
 #define   NAME_INTR_RXRCMP		"Rx Reset Complete"
-#define   BIT_INTR_TXRCMP		(1<<20)
+#define   BIT_INTR_TXRCMP		BIT(20)
 #define   NAME_INTR_TXRCMP		"Tx Reset Complete"
 #define REG_IER				6
-#define   BIT_IER_IE			(1<<0)
+#define   BIT_IER_IE			BIT(0)
 #define REG_TXDP			8
 #define REG_TXCFG			9
 #define   BIT_TXCFG_DRTH		(0x3f<<0)
 #define   BIT_TXCFG_FLTH		(0x3f<<8)
 #define   BIT_TXCFG_MXDMA		(0x7<<20)
-#define   BIT_TXCFG_ATP			(1<<28)
-#define   BIT_TXCFG_MLB			(1<<29)
-#define   BIT_TXCFG_HBI			(1<<30)
-#define   BIT_TXCFG_CSI			(1<<31)
+#define   BIT_TXCFG_ATP			BIT(28)
+#define   BIT_TXCFG_MLB			BIT(29)
+#define   BIT_TXCFG_HBI			BIT(30)
+#define   BIT_TXCFG_CSI			BIT(31)
 #define REG_RXDP			12
 #define REG_RXCFG			13
 #define   BIT_RXCFG_DRTH		(0x1f<<1)
 #define   BIT_RXCFG_MXDMA		(0x7<<20)
-#define   BIT_RXCFG_ALP			(1<<27)
-#define   BIT_RXCFG_ATX			(1<<28)
-#define   BIT_RXCFG_ARP			(1<<30)
-#define   BIT_RXCFG_AEP			(1<<31)
+#define   BIT_RXCFG_ALP			BIT(27)
+#define   BIT_RXCFG_ATX			BIT(28)
+#define   BIT_RXCFG_ARP			BIT(30)
+#define   BIT_RXCFG_AEP			BIT(31)
 #define REG_CCSR			15
-#define   BIT_CCSR_CLKRUN_EN		(1<<0)
-#define   BIT_CCSR_PMEEN		(1<<8)
-#define   BIT_CCSR_PMESTS		(1<<15)
+#define   BIT_CCSR_CLKRUN_EN		BIT(0)
+#define   BIT_CCSR_PMEEN		BIT(8)
+#define   BIT_CCSR_PMESTS		BIT(15)
 #define REG_WCSR			16
-#define   BIT_WCSR_WKPHY		(1<<0)
-#define   BIT_WCSR_WKUCP		(1<<1)
-#define   BIT_WCSR_WKMCP		(1<<2)
-#define   BIT_WCSR_WKBCP		(1<<3)
-#define   BIT_WCSR_WKARP		(1<<4)
-#define   BIT_WCSR_WKPAT0		(1<<5)
-#define   BIT_WCSR_WKPAT1		(1<<6)
-#define   BIT_WCSR_WKPAT2		(1<<7)
-#define   BIT_WCSR_WKPAT3		(1<<8)
-#define   BIT_WCSR_WKMAG		(1<<9)
-#define   BIT_WCSR_MPSOE		(1<<10)
-#define   BIT_WCSR_SOHACK		(1<<20)
-#define   BIT_WCSR_PHYINT		(1<<22)
-#define   BIT_WCSR_UCASTR		(1<<23)
-#define   BIT_WCSR_MCASTR		(1<<24)
-#define   BIT_WCSR_BCASTR		(1<<25)
-#define   BIT_WCSR_ARPR			(1<<26)
-#define   BIT_WCSR_PATM0		(1<<27)
-#define   BIT_WCSR_PATM1		(1<<28)
-#define   BIT_WCSR_PATM2		(1<<29)
-#define   BIT_WCSR_PATM3		(1<<30)
-#define   BIT_WCSR_MPR			(1<<31)
+#define   BIT_WCSR_WKPHY		BIT(0)
+#define   BIT_WCSR_WKUCP		BIT(1)
+#define   BIT_WCSR_WKMCP		BIT(2)
+#define   BIT_WCSR_WKBCP		BIT(3)
+#define   BIT_WCSR_WKARP		BIT(4)
+#define   BIT_WCSR_WKPAT0		BIT(5)
+#define   BIT_WCSR_WKPAT1		BIT(6)
+#define   BIT_WCSR_WKPAT2		BIT(7)
+#define   BIT_WCSR_WKPAT3		BIT(8)
+#define   BIT_WCSR_WKMAG		BIT(9)
+#define   BIT_WCSR_MPSOE		BIT(10)
+#define   BIT_WCSR_SOHACK		BIT(20)
+#define   BIT_WCSR_PHYINT		BIT(22)
+#define   BIT_WCSR_UCASTR		BIT(23)
+#define   BIT_WCSR_MCASTR		BIT(24)
+#define   BIT_WCSR_BCASTR		BIT(25)
+#define   BIT_WCSR_ARPR			BIT(26)
+#define   BIT_WCSR_PATM0		BIT(27)
+#define   BIT_WCSR_PATM1		BIT(28)
+#define   BIT_WCSR_PATM2		BIT(29)
+#define   BIT_WCSR_PATM3		BIT(30)
+#define   BIT_WCSR_MPR			BIT(31)
 #define REG_PCR				17
 #define   BIT_PCR_PAUSE_CNT		(0xffff<<0)
-#define   BIT_PCR_PSNEG			(1<<21)
-#define   BIT_PCR_PS_RCVD		(1<<22)
-#define   BIT_PCR_PS_DA			(1<<29)
-#define   BIT_PCR_PSMCAST		(1<<30)
-#define   BIT_PCR_PSEN			(1<<31)
+#define   BIT_PCR_PSNEG			BIT(21)
+#define   BIT_PCR_PS_RCVD		BIT(22)
+#define   BIT_PCR_PS_DA			BIT(29)
+#define   BIT_PCR_PSMCAST		BIT(30)
+#define   BIT_PCR_PSEN			BIT(31)
 #define REG_RFCR			18
-#define   BIT_RFCR_UHEN			(1<<20)
-#define   BIT_RFCR_MHEN			(1<<21)
-#define   BIT_RFCR_AARP			(1<<22)
-#define   BIT_RFCR_APAT0		(1<<23)
-#define   BIT_RFCR_APAT1		(1<<24)
-#define   BIT_RFCR_APAT2		(1<<25)
-#define   BIT_RFCR_APAT3		(1<<26)
-#define   BIT_RFCR_APM			(1<<27)
-#define   BIT_RFCR_AAU			(1<<28)
-#define   BIT_RFCR_AAM			(1<<29)
-#define   BIT_RFCR_AAB			(1<<30)
-#define   BIT_RFCR_RFEN			(1<<31)
+#define   BIT_RFCR_UHEN			BIT(20)
+#define   BIT_RFCR_MHEN			BIT(21)
+#define   BIT_RFCR_AARP			BIT(22)
+#define   BIT_RFCR_APAT0		BIT(23)
+#define   BIT_RFCR_APAT1		BIT(24)
+#define   BIT_RFCR_APAT2		BIT(25)
+#define   BIT_RFCR_APAT3		BIT(26)
+#define   BIT_RFCR_APM			BIT(27)
+#define   BIT_RFCR_AAU			BIT(28)
+#define   BIT_RFCR_AAM			BIT(29)
+#define   BIT_RFCR_AAB			BIT(30)
+#define   BIT_RFCR_RFEN			BIT(31)
 #define REG_RFDR			19
 #define REG_BRAR			20
-#define   BIT_BRAR_AUTOINC		(1<<31)
+#define   BIT_BRAR_AUTOINC		BIT(31)
 #define REG_BRDR			21
 #define REG_SRR				22
 #define REG_MIBC			23
-#define   BIT_MIBC_WRN			(1<<0)
-#define   BIT_MIBC_FRZ			(1<<1)
+#define   BIT_MIBC_WRN			BIT(0)
+#define   BIT_MIBC_FRZ			BIT(1)
 #define REG_MIB0			24
 #define REG_MIB1			25
 #define REG_MIB2			26
@@ -166,26 +166,26 @@
 #define REG_MIB5			29
 #define REG_MIB6			30
 #define REG_BMCR			32
-#define   BIT_BMCR_FDUP			(1<<8)
-#define   BIT_BMCR_ANRST		(1<<9)
-#define   BIT_BMCR_ISOL			(1<<10)
-#define   BIT_BMCR_PDOWN		(1<<11)
-#define   BIT_BMCR_ANEN			(1<<12)
-#define   BIT_BMCR_SPEED		(1<<13)
-#define   BIT_BMCR_LOOP			(1<<14)
-#define   BIT_BMCR_RST			(1<<15)
+#define   BIT_BMCR_FDUP			BIT(8)
+#define   BIT_BMCR_ANRST		BIT(9)
+#define   BIT_BMCR_ISOL			BIT(10)
+#define   BIT_BMCR_PDOWN		BIT(11)
+#define   BIT_BMCR_ANEN			BIT(12)
+#define   BIT_BMCR_SPEED		BIT(13)
+#define   BIT_BMCR_LOOP			BIT(14)
+#define   BIT_BMCR_RST			BIT(15)
 #define REG_BMSR			33
-#define   BIT_BMSR_JABBER		(1<<1)
-#define   BIT_BMSR_LNK			(1<<2)
-#define   BIT_BMSR_ANCAP		(1<<3)
-#define   BIT_BMSR_RFAULT		(1<<4)
-#define   BIT_BMSR_ANDONE		(1<<5)
-#define   BIT_BMSR_PREAMBLE		(1<<6)
-#define   BIT_BMSR_10HCAP		(1<<11)
-#define   BIT_BMSR_10FCAP		(1<<12)
-#define   BIT_BMSR_100HCAP		(1<<13)
-#define   BIT_BMSR_100FCAP		(1<<14)
-#define   BIT_BMSR_100T4CAP		(1<<15)
+#define   BIT_BMSR_JABBER		BIT(1)
+#define   BIT_BMSR_LNK			BIT(2)
+#define   BIT_BMSR_ANCAP		BIT(3)
+#define   BIT_BMSR_RFAULT		BIT(4)
+#define   BIT_BMSR_ANDONE		BIT(5)
+#define   BIT_BMSR_PREAMBLE		BIT(6)
+#define   BIT_BMSR_10HCAP		BIT(11)
+#define   BIT_BMSR_10FCAP		BIT(12)
+#define   BIT_BMSR_100HCAP		BIT(13)
+#define   BIT_BMSR_100FCAP		BIT(14)
+#define   BIT_BMSR_100T4CAP		BIT(15)
 #define REG_PHYIDR1			34
 #define REG_PHYIDR2			35
 #define   BIT_PHYIDR2_OUILSB		(0x3f<<10)
@@ -193,81 +193,81 @@
 #define   BIT_PHYIDR2_REV		(0xf)
 #define REG_ANAR			36
 #define   BIT_ANAR_PROTO		(0x1f<<0)
-#define   BIT_ANAR_10			(1<<5)
-#define   BIT_ANAR_10_FD		(1<<6)
-#define   BIT_ANAR_TX			(1<<7)
-#define   BIT_ANAR_TXFD			(1<<8)
-#define   BIT_ANAR_T4			(1<<9)
-#define   BIT_ANAR_PAUSE		(1<<10)
-#define   BIT_ANAR_RF			(1<<13)
-#define   BIT_ANAR_NP			(1<<15)
+#define   BIT_ANAR_10			BIT(5)
+#define   BIT_ANAR_10_FD		BIT(6)
+#define   BIT_ANAR_TX			BIT(7)
+#define   BIT_ANAR_TXFD			BIT(8)
+#define   BIT_ANAR_T4			BIT(9)
+#define   BIT_ANAR_PAUSE		BIT(10)
+#define   BIT_ANAR_RF			BIT(13)
+#define   BIT_ANAR_NP			BIT(15)
 #define REG_ANLPAR			37
 #define   BIT_ANLPAR_PROTO		(0x1f<<0)
-#define   BIT_ANLPAR_10			(1<<5)
-#define   BIT_ANLPAR_10_FD		(1<<6)
-#define   BIT_ANLPAR_TX			(1<<7)
-#define   BIT_ANLPAR_TXFD		(1<<8)
-#define   BIT_ANLPAR_T4			(1<<9)
-#define   BIT_ANLPAR_PAUSE		(1<<10)
-#define   BIT_ANLPAR_RF			(1<<13)
-#define   BIT_ANLPAR_ACK		(1<<14)
-#define   BIT_ANLPAR_NP			(1<<15)
+#define   BIT_ANLPAR_10			BIT(5)
+#define   BIT_ANLPAR_10_FD		BIT(6)
+#define   BIT_ANLPAR_TX			BIT(7)
+#define   BIT_ANLPAR_TXFD		BIT(8)
+#define   BIT_ANLPAR_T4			BIT(9)
+#define   BIT_ANLPAR_PAUSE		BIT(10)
+#define   BIT_ANLPAR_RF			BIT(13)
+#define   BIT_ANLPAR_ACK		BIT(14)
+#define   BIT_ANLPAR_NP			BIT(15)
 #define REG_ANER			38
-#define   BIT_ANER_LP_AN_ENABLE		(1<<0)
-#define   BIT_ANER_PAGE_RX		(1<<1)
-#define   BIT_ANER_NP_ABLE		(1<<2)
-#define   BIT_ANER_LP_NP_ABLE		(1<<3)
-#define   BIT_ANER_PDF			(1<<4)
+#define   BIT_ANER_LP_AN_ENABLE		BIT(0)
+#define   BIT_ANER_PAGE_RX		BIT(1)
+#define   BIT_ANER_NP_ABLE		BIT(2)
+#define   BIT_ANER_LP_NP_ABLE		BIT(3)
+#define   BIT_ANER_PDF			BIT(4)
 #define REG_ANNPTR			39
 #define REG_PHYSTS			48
-#define   BIT_PHYSTS_LNK		(1<<0)
-#define   BIT_PHYSTS_SPD10		(1<<1)
-#define   BIT_PHYSTS_FDUP		(1<<2)
-#define   BIT_PHYSTS_LOOP		(1<<3)
-#define   BIT_PHYSTS_ANDONE		(1<<4)
-#define   BIT_PHYSTS_JABBER		(1<<5)
-#define   BIT_PHYSTS_RF			(1<<6)
-#define   BIT_PHYSTS_MINT		(1<<7)
-#define   BIT_PHYSTS_FC			(1<<11)
-#define   BIT_PHYSTS_POL		(1<<12)
-#define   BIT_PHYSTS_RXERR		(1<<13)
+#define   BIT_PHYSTS_LNK		BIT(0)
+#define   BIT_PHYSTS_SPD10		BIT(1)
+#define   BIT_PHYSTS_FDUP		BIT(2)
+#define   BIT_PHYSTS_LOOP		BIT(3)
+#define   BIT_PHYSTS_ANDONE		BIT(4)
+#define   BIT_PHYSTS_JABBER		BIT(5)
+#define   BIT_PHYSTS_RF			BIT(6)
+#define   BIT_PHYSTS_MINT		BIT(7)
+#define   BIT_PHYSTS_FC			BIT(11)
+#define   BIT_PHYSTS_POL		BIT(12)
+#define   BIT_PHYSTS_RXERR		BIT(13)
 #define REG_MICR			49
-#define   BIT_MICR_INTEN		(1<<1)
+#define   BIT_MICR_INTEN		BIT(1)
 #define REG_MISR			50
-#define   BIT_MISR_MSK_RHF		(1<<9)
-#define   BIT_MISR_MSK_FHF		(1<<10)
-#define   BIT_MISR_MSK_ANC		(1<<11)
-#define   BIT_MISR_MSK_RF		(1<<12)
-#define   BIT_MISR_MSK_JAB		(1<<13)
-#define   BIT_MISR_MSK_LNK		(1<<14)
-#define   BIT_MISR_MINT			(1<<15)
+#define   BIT_MISR_MSK_RHF		BIT(9)
+#define   BIT_MISR_MSK_FHF		BIT(10)
+#define   BIT_MISR_MSK_ANC		BIT(11)
+#define   BIT_MISR_MSK_RF		BIT(12)
+#define   BIT_MISR_MSK_JAB		BIT(13)
+#define   BIT_MISR_MSK_LNK		BIT(14)
+#define   BIT_MISR_MINT			BIT(15)
 #define REG_PGSEL			51
 #define REG_FCSCR			52
 #define REG_RECR			53
 #define REG_PCSR			54
-#define   BIT_PCSR_NRZI			(1<<2)
-#define   BIT_PCSR_FORCE_100		(1<<5)
-#define   BIT_PCSR_SDOPT		(1<<8)
-#define   BIT_PCSR_SDFORCE		(1<<9)
-#define   BIT_PCSR_TQM			(1<<10)
-#define   BIT_PCSR_CLK			(1<<11)
-#define   BIT_PCSR_4B5B			(1<<12)
+#define   BIT_PCSR_NRZI			BIT(2)
+#define   BIT_PCSR_FORCE_100		BIT(5)
+#define   BIT_PCSR_SDOPT		BIT(8)
+#define   BIT_PCSR_SDFORCE		BIT(9)
+#define   BIT_PCSR_TQM			BIT(10)
+#define   BIT_PCSR_CLK			BIT(11)
+#define   BIT_PCSR_4B5B			BIT(12)
 #define REG_PHYCR			57
 #define   BIT_PHYCR_PHYADDR		(0x1f<<0)
-#define   BIT_PHYCR_PAUSE_STS		(1<<7)
-#define   BIT_PHYCR_STRETCH		(1<<8)
-#define   BIT_PHYCR_BIST		(1<<9)
-#define   BIT_PHYCR_BIST_STAT		(1<<10)
-#define   BIT_PHYCR_PSR15		(1<<11)
+#define   BIT_PHYCR_PAUSE_STS		BIT(7)
+#define   BIT_PHYCR_STRETCH		BIT(8)
+#define   BIT_PHYCR_BIST		BIT(9)
+#define   BIT_PHYCR_BIST_STAT		BIT(10)
+#define   BIT_PHYCR_PSR15		BIT(11)
 #define REG_TBTSCR			58
-#define   BIT_TBTSCR_JAB		(1<<0)
-#define   BIT_TBTSCR_BEAT		(1<<1)
-#define   BIT_TBTSCR_AUTOPOL		(1<<3)
-#define   BIT_TBTSCR_POL		(1<<4)
-#define   BIT_TBTSCR_FPOL		(1<<5)
-#define   BIT_TBTSCR_FORCE_10		(1<<6)
-#define   BIT_TBTSCR_PULSE		(1<<7)
-#define   BIT_TBTSCR_LOOP		(1<<8)
+#define   BIT_TBTSCR_JAB		BIT(0)
+#define   BIT_TBTSCR_BEAT		BIT(1)
+#define   BIT_TBTSCR_AUTOPOL		BIT(3)
+#define   BIT_TBTSCR_POL		BIT(4)
+#define   BIT_TBTSCR_FPOL		BIT(5)
+#define   BIT_TBTSCR_FORCE_10		BIT(6)
+#define   BIT_TBTSCR_PULSE		BIT(7)
+#define   BIT_TBTSCR_LOOP		BIT(8)
 #define REG_PMDCSR			64
 #define REG_TSTDAT			65
 #define REG_DSPCFG			66
diff --git a/netlink/bitset.c b/netlink/bitset.c
index 10ce8e9def9a..cecadeb7bb5a 100644
--- a/netlink/bitset.c
+++ b/netlink/bitset.c
@@ -75,7 +75,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 
 		if (idx >= 8 * mnl_attr_get_payload_len(bits))
 			return false;
-		return bitmap[idx / 32] & (1U << (idx % 32));
+		return bitmap[idx / 32] & BIT(idx % 32);
 	}
 
 	bits = bitset_tb[ETHTOOL_A_BITSET_BITS];
@@ -227,9 +227,9 @@ int walk_bitset(const struct nlattr *bitset, const struct stringset *labels,
 		val_bm = mnl_attr_get_payload(bits);
 		mask_bm = mask ? mnl_attr_get_payload(mask) : NULL;
 		for (idx = 0; idx < count; idx++)
-			if (!mask_bm || (mask_bm[idx / 32] & (1 << (idx % 32))))
+			if (!mask_bm || (mask_bm[idx / 32] & BIT(idx % 32)))
 				cb(idx, get_string(labels, idx),
-				   val_bm[idx / 32] & (1 << (idx % 32)), data);
+				   val_bm[idx / 32] & BIT(idx % 32), data);
 		return 0;
 	}
 
diff --git a/netlink/features.c b/netlink/features.c
index f6ba47f21a12..38f6272852d7 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -57,7 +57,7 @@ static int prepare_feature_results(const struct nlattr *const *tb,
 
 static bool feature_on(const uint32_t *bitmap, unsigned int idx)
 {
-	return bitmap[idx / 32] & (1UL << (idx % 32));
+	return bitmap[idx / 32] & BIT(idx % 32);
 }
 
 static void dump_feature(const struct feature_results *results,
@@ -302,7 +302,7 @@ static void set_sf_req_mask(struct nl_context *nlctx, unsigned int idx)
 {
 	struct sfeatures_context *sfctx = nlctx->cmd_private;
 
-	sfctx->req_mask[idx / 32] |= (1UL << (idx % 32));
+	sfctx->req_mask[idx / 32] |= BIT(idx % 32);
 }
 
 static int fill_legacy_flag(struct nl_context *nlctx, const char *flag_name,
diff --git a/netlink/monitor.c b/netlink/monitor.c
index ace9b259d39f..3f746671acb4 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -87,12 +87,12 @@ static void clear_filter(struct nl_context *nlctx)
 
 static bool test_filter_cmd(const struct nl_context *nlctx, unsigned int cmd)
 {
-	return nlctx->filter_cmds[cmd / 32] & (1U << (cmd % 32));
+	return nlctx->filter_cmds[cmd / 32] & BIT(cmd % 32);
 }
 
 static void set_filter_cmd(struct nl_context *nlctx, unsigned int cmd)
 {
-	nlctx->filter_cmds[cmd / 32] |= (1U << (cmd % 32));
+	nlctx->filter_cmds[cmd / 32] |= BIT(cmd % 32);
 }
 
 static void set_filter_all(struct nl_context *nlctx)
diff --git a/netlink/parser.c b/netlink/parser.c
index c573a9598a9f..d105d64ad6ea 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -910,12 +910,12 @@ static const struct param_parser *find_parser(const struct param_parser *params,
 
 static bool __parser_bit(const uint64_t *map, unsigned int idx)
 {
-	return map[idx / 64] & (1 << (idx % 64));
+	return map[idx / 64] & BIT(idx % 64);
 }
 
 static void __parser_set(uint64_t *map, unsigned int idx)
 {
-	map[idx / 64] |= (1 << (idx % 64));
+	map[idx / 64] |= BIT(idx % 64);
 }
 
 static void __parser_set_group(const struct param_parser *params,
diff --git a/netlink/settings.c b/netlink/settings.c
index ea86e365383b..e067ccfe507c 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -275,7 +275,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 			const uint32_t *raw_data = mnl_attr_get_payload(bits);
 			char buff[14];
 
-			if (!(raw_data[idx / 32] & (1U << (idx % 32))))
+			if (!(raw_data[idx / 32] & BIT(idx % 32)))
 				continue;
 			if (!lm_class_match(idx, class))
 				continue;
@@ -782,9 +782,9 @@ void wol_modes_cb(unsigned int idx, const char *name __maybe_unused, bool val,
 
 	if (idx >= 32)
 		return;
-	wol->supported |= (1U << idx);
+	wol->supported |= BIT(idx);
 	if (val)
-		wol->wolopts |= (1U << idx);
+		wol->wolopts |= BIT(idx);
 }
 
 int wol_reply_cb(const struct nlmsghdr *nlhdr, void *data)
@@ -832,7 +832,7 @@ void msgmask_cb(unsigned int idx, const char *name __maybe_unused, bool val,
 	if (idx >= 32)
 		return;
 	if (val)
-		*msg_mask |= (1U << idx);
+		*msg_mask |= BIT(idx);
 }
 
 void msgmask_cb2(unsigned int idx __maybe_unused, const char *name,
@@ -1172,7 +1172,7 @@ static int linkmodes_reply_advert_all_cb(const struct nlmsghdr *nlhdr,
 	/* keep only "real" link modes */
 	for (i = 0; i < modes_count; i++)
 		if (!lm_class_match(i, LM_CLASS_REAL))
-			supported_modes[i / 32] &= ~((uint32_t)1 << (i % 32));
+			supported_modes[i / 32] &= ~BIT(i % 32);
 
 	req_bitset = ethnla_nest_start(req_msgbuff, ETHTOOL_A_LINKMODES_OURS);
 	if (!req_bitset)
diff --git a/netlink/stats.c b/netlink/stats.c
index 9f609a4ec550..c4605ba24838 100644
--- a/netlink/stats.c
+++ b/netlink/stats.c
@@ -244,7 +244,7 @@ static int stats_parse_all_groups(struct nl_context *nlctx, uint16_t type,
 		return -ENOMEM;
 
 	for (i = 0; i < nbits; i++)
-		bits[i / 32] |= 1U << (i % 32);
+		bits[i / 32] |= BIT(i % 32);
 
 	ret = -EMSGSIZE;
 	nest = ethnla_nest_start(msgbuff, type);
diff --git a/qsfp.h b/qsfp.h
index 7960bf26fb07..94cb796a0b13 100644
--- a/qsfp.h
+++ b/qsfp.h
@@ -29,100 +29,100 @@
 
 #define	SFF8636_STATUS_2_OFFSET	0x02
 /* Flat Memory:0- Paging, 1- Page 0 only */
-#define	 SFF8636_STATUS_PAGE_3_PRESENT		(1 << 2)
-#define	 SFF8636_STATUS_INTL_OUTPUT		(1 << 1)
-#define	 SFF8636_STATUS_DATA_NOT_READY		(1 << 0)
+#define	 SFF8636_STATUS_PAGE_3_PRESENT		BIT(2)
+#define	 SFF8636_STATUS_INTL_OUTPUT		BIT(1)
+#define	 SFF8636_STATUS_DATA_NOT_READY		BIT(0)
 
 /* Channel Status Interrupt Flags - 3-5 */
 #define	SFF8636_LOS_AW_OFFSET	0x03
-#define	 SFF8636_TX4_LOS_AW		(1 << 7)
-#define	 SFF8636_TX3_LOS_AW		(1 << 6)
-#define	 SFF8636_TX2_LOS_AW		(1 << 5)
-#define	 SFF8636_TX1_LOS_AW		(1 << 4)
-#define	 SFF8636_RX4_LOS_AW		(1 << 3)
-#define	 SFF8636_RX3_LOS_AW		(1 << 2)
-#define	 SFF8636_RX2_LOS_AW		(1 << 1)
-#define	 SFF8636_RX1_LOS_AW		(1 << 0)
+#define	 SFF8636_TX4_LOS_AW		BIT(7)
+#define	 SFF8636_TX3_LOS_AW		BIT(6)
+#define	 SFF8636_TX2_LOS_AW		BIT(5)
+#define	 SFF8636_TX1_LOS_AW		BIT(4)
+#define	 SFF8636_RX4_LOS_AW		BIT(3)
+#define	 SFF8636_RX3_LOS_AW		BIT(2)
+#define	 SFF8636_RX2_LOS_AW		BIT(1)
+#define	 SFF8636_RX1_LOS_AW		BIT(0)
 
 #define	SFF8636_FAULT_AW_OFFSET	0x04
-#define	 SFF8636_TX4_FAULT_AW	(1 << 3)
-#define	 SFF8636_TX3_FAULT_AW	(1 << 2)
-#define	 SFF8636_TX2_FAULT_AW	(1 << 1)
-#define	 SFF8636_TX1_FAULT_AW	(1 << 0)
+#define	 SFF8636_TX4_FAULT_AW	BIT(3)
+#define	 SFF8636_TX3_FAULT_AW	BIT(2)
+#define	 SFF8636_TX2_FAULT_AW	BIT(1)
+#define	 SFF8636_TX1_FAULT_AW	BIT(0)
 
 /* Module Monitor Interrupt Flags - 6-8 */
 #define	SFF8636_TEMP_AW_OFFSET	0x06
-#define	 SFF8636_TEMP_HALARM_STATUS		(1 << 7)
-#define	 SFF8636_TEMP_LALARM_STATUS		(1 << 6)
-#define	 SFF8636_TEMP_HWARN_STATUS		(1 << 5)
-#define	 SFF8636_TEMP_LWARN_STATUS		(1 << 4)
+#define	 SFF8636_TEMP_HALARM_STATUS		BIT(7)
+#define	 SFF8636_TEMP_LALARM_STATUS		BIT(6)
+#define	 SFF8636_TEMP_HWARN_STATUS		BIT(5)
+#define	 SFF8636_TEMP_LWARN_STATUS		BIT(4)
 
 #define	SFF8636_VCC_AW_OFFSET	0x07
-#define	 SFF8636_VCC_HALARM_STATUS		(1 << 7)
-#define	 SFF8636_VCC_LALARM_STATUS		(1 << 6)
-#define	 SFF8636_VCC_HWARN_STATUS		(1 << 5)
-#define	 SFF8636_VCC_LWARN_STATUS		(1 << 4)
+#define	 SFF8636_VCC_HALARM_STATUS		BIT(7)
+#define	 SFF8636_VCC_LALARM_STATUS		BIT(6)
+#define	 SFF8636_VCC_HWARN_STATUS		BIT(5)
+#define	 SFF8636_VCC_LWARN_STATUS		BIT(4)
 
 /* Channel Monitor Interrupt Flags - 9-21 */
 #define	SFF8636_RX_PWR_12_AW_OFFSET	0x09
-#define	 SFF8636_RX_PWR_1_HALARM		(1 << 7)
-#define	 SFF8636_RX_PWR_1_LALARM		(1 << 6)
-#define	 SFF8636_RX_PWR_1_HWARN			(1 << 5)
-#define	 SFF8636_RX_PWR_1_LWARN			(1 << 4)
-#define	 SFF8636_RX_PWR_2_HALARM		(1 << 3)
-#define	 SFF8636_RX_PWR_2_LALARM		(1 << 2)
-#define	 SFF8636_RX_PWR_2_HWARN			(1 << 1)
-#define	 SFF8636_RX_PWR_2_LWARN			(1 << 0)
+#define	 SFF8636_RX_PWR_1_HALARM		BIT(7)
+#define	 SFF8636_RX_PWR_1_LALARM		BIT(6)
+#define	 SFF8636_RX_PWR_1_HWARN			BIT(5)
+#define	 SFF8636_RX_PWR_1_LWARN			BIT(4)
+#define	 SFF8636_RX_PWR_2_HALARM		BIT(3)
+#define	 SFF8636_RX_PWR_2_LALARM		BIT(2)
+#define	 SFF8636_RX_PWR_2_HWARN			BIT(1)
+#define	 SFF8636_RX_PWR_2_LWARN			BIT(0)
 
 #define	SFF8636_RX_PWR_34_AW_OFFSET	0x0A
-#define	 SFF8636_RX_PWR_3_HALARM		(1 << 7)
-#define	 SFF8636_RX_PWR_3_LALARM		(1 << 6)
-#define	 SFF8636_RX_PWR_3_HWARN			(1 << 5)
-#define	 SFF8636_RX_PWR_3_LWARN			(1 << 4)
-#define	 SFF8636_RX_PWR_4_HALARM		(1 << 3)
-#define	 SFF8636_RX_PWR_4_LALARM		(1 << 2)
-#define	 SFF8636_RX_PWR_4_HWARN			(1 << 1)
-#define	 SFF8636_RX_PWR_4_LWARN			(1 << 0)
+#define	 SFF8636_RX_PWR_3_HALARM		BIT(7)
+#define	 SFF8636_RX_PWR_3_LALARM		BIT(6)
+#define	 SFF8636_RX_PWR_3_HWARN			BIT(5)
+#define	 SFF8636_RX_PWR_3_LWARN			BIT(4)
+#define	 SFF8636_RX_PWR_4_HALARM		BIT(3)
+#define	 SFF8636_RX_PWR_4_LALARM		BIT(2)
+#define	 SFF8636_RX_PWR_4_HWARN			BIT(1)
+#define	 SFF8636_RX_PWR_4_LWARN			BIT(0)
 
 #define	SFF8636_TX_BIAS_12_AW_OFFSET	0x0B
-#define	 SFF8636_TX_BIAS_1_HALARM		(1 << 7)
-#define	 SFF8636_TX_BIAS_1_LALARM		(1 << 6)
-#define	 SFF8636_TX_BIAS_1_HWARN		(1 << 5)
-#define	 SFF8636_TX_BIAS_1_LWARN		(1 << 4)
-#define	 SFF8636_TX_BIAS_2_HALARM		(1 << 3)
-#define	 SFF8636_TX_BIAS_2_LALARM		(1 << 2)
-#define	 SFF8636_TX_BIAS_2_HWARN		(1 << 1)
-#define	 SFF8636_TX_BIAS_2_LWARN		(1 << 0)
+#define	 SFF8636_TX_BIAS_1_HALARM		BIT(7)
+#define	 SFF8636_TX_BIAS_1_LALARM		BIT(6)
+#define	 SFF8636_TX_BIAS_1_HWARN		BIT(5)
+#define	 SFF8636_TX_BIAS_1_LWARN		BIT(4)
+#define	 SFF8636_TX_BIAS_2_HALARM		BIT(3)
+#define	 SFF8636_TX_BIAS_2_LALARM		BIT(2)
+#define	 SFF8636_TX_BIAS_2_HWARN		BIT(1)
+#define	 SFF8636_TX_BIAS_2_LWARN		BIT(0)
 
 #define	SFF8636_TX_BIAS_34_AW_OFFSET	0xC
-#define	 SFF8636_TX_BIAS_3_HALARM		(1 << 7)
-#define	 SFF8636_TX_BIAS_3_LALARM		(1 << 6)
-#define	 SFF8636_TX_BIAS_3_HWARN		(1 << 5)
-#define	 SFF8636_TX_BIAS_3_LWARN		(1 << 4)
-#define	 SFF8636_TX_BIAS_4_HALARM		(1 << 3)
-#define	 SFF8636_TX_BIAS_4_LALARM		(1 << 2)
-#define	 SFF8636_TX_BIAS_4_HWARN		(1 << 1)
-#define	 SFF8636_TX_BIAS_4_LWARN		(1 << 0)
+#define	 SFF8636_TX_BIAS_3_HALARM		BIT(7)
+#define	 SFF8636_TX_BIAS_3_LALARM		BIT(6)
+#define	 SFF8636_TX_BIAS_3_HWARN		BIT(5)
+#define	 SFF8636_TX_BIAS_3_LWARN		BIT(4)
+#define	 SFF8636_TX_BIAS_4_HALARM		BIT(3)
+#define	 SFF8636_TX_BIAS_4_LALARM		BIT(2)
+#define	 SFF8636_TX_BIAS_4_HWARN		BIT(1)
+#define	 SFF8636_TX_BIAS_4_LWARN		BIT(0)
 
 #define	SFF8636_TX_PWR_12_AW_OFFSET	0x0D
-#define	 SFF8636_TX_PWR_1_HALARM		(1 << 7)
-#define	 SFF8636_TX_PWR_1_LALARM		(1 << 6)
-#define	 SFF8636_TX_PWR_1_HWARN			(1 << 5)
-#define	 SFF8636_TX_PWR_1_LWARN			(1 << 4)
-#define	 SFF8636_TX_PWR_2_HALARM		(1 << 3)
-#define	 SFF8636_TX_PWR_2_LALARM		(1 << 2)
-#define	 SFF8636_TX_PWR_2_HWARN			(1 << 1)
-#define	 SFF8636_TX_PWR_2_LWARN			(1 << 0)
+#define	 SFF8636_TX_PWR_1_HALARM		BIT(7)
+#define	 SFF8636_TX_PWR_1_LALARM		BIT(6)
+#define	 SFF8636_TX_PWR_1_HWARN			BIT(5)
+#define	 SFF8636_TX_PWR_1_LWARN			BIT(4)
+#define	 SFF8636_TX_PWR_2_HALARM		BIT(3)
+#define	 SFF8636_TX_PWR_2_LALARM		BIT(2)
+#define	 SFF8636_TX_PWR_2_HWARN			BIT(1)
+#define	 SFF8636_TX_PWR_2_LWARN			BIT(0)
 
 #define	SFF8636_TX_PWR_34_AW_OFFSET	0x0E
-#define	 SFF8636_TX_PWR_3_HALARM		(1 << 7)
-#define	 SFF8636_TX_PWR_3_LALARM		(1 << 6)
-#define	 SFF8636_TX_PWR_3_HWARN			(1 << 5)
-#define	 SFF8636_TX_PWR_3_LWARN			(1 << 4)
-#define	 SFF8636_TX_PWR_4_HALARM		(1 << 3)
-#define	 SFF8636_TX_PWR_4_LALARM		(1 << 2)
-#define	 SFF8636_TX_PWR_4_HWARN			(1 << 1)
-#define	 SFF8636_TX_PWR_4_LWARN			(1 << 0)
+#define	 SFF8636_TX_PWR_3_HALARM		BIT(7)
+#define	 SFF8636_TX_PWR_3_LALARM		BIT(6)
+#define	 SFF8636_TX_PWR_3_HWARN			BIT(5)
+#define	 SFF8636_TX_PWR_3_LWARN			BIT(4)
+#define	 SFF8636_TX_PWR_4_HALARM		BIT(3)
+#define	 SFF8636_TX_PWR_4_LALARM		BIT(2)
+#define	 SFF8636_TX_PWR_4_HWARN			BIT(1)
+#define	 SFF8636_TX_PWR_4_LWARN			BIT(0)
 
 /* Module Monitoring Values - 22-33 */
 #define	SFF8636_TEMP_CURR		0x16
@@ -151,10 +151,10 @@
 
 /* Control Bytes - 86 - 99 */
 #define	SFF8636_TX_DISABLE_OFFSET	0x56
-#define	 SFF8636_TX_DISABLE_4			(1 << 3)
-#define	 SFF8636_TX_DISABLE_3			(1 << 2)
-#define	 SFF8636_TX_DISABLE_2			(1 << 1)
-#define	 SFF8636_TX_DISABLE_1			(1 << 0)
+#define	 SFF8636_TX_DISABLE_4			BIT(3)
+#define	 SFF8636_TX_DISABLE_3			BIT(2)
+#define	 SFF8636_TX_DISABLE_2			BIT(1)
+#define	 SFF8636_TX_DISABLE_1			BIT(0)
 
 #define	SFF8636_RX_RATE_SELECT_OFFSET	0x57
 #define	 SFF8636_RX_RATE_SELECT_4_MASK		(3 << 6)
@@ -174,9 +174,9 @@
 #define	SFF8636_RX_APP_SELECT_1_OFFSET	0x5B
 
 #define	SFF8636_PWR_MODE_OFFSET		0x5D
-#define	 SFF8636_HIGH_PWR_ENABLE		(1 << 2)
-#define	 SFF8636_LOW_PWR_SET			(1 << 1)
-#define	 SFF8636_PWR_OVERRIDE			(1 << 0)
+#define	 SFF8636_HIGH_PWR_ENABLE		BIT(2)
+#define	 SFF8636_LOW_PWR_SET			BIT(1)
+#define	 SFF8636_PWR_OVERRIDE			BIT(0)
 
 #define	SFF8636_TX_APP_SELECT_4_OFFSET	0x5E
 #define	SFF8636_TX_APP_SELECT_3_OFFSET	0x5F
@@ -184,32 +184,32 @@
 #define	SFF8636_TX_APP_SELECT_1_OFFSET	0x61
 
 #define	SFF8636_LOS_MASK_OFFSET		0x64
-#define	 SFF8636_TX_LOS_4_MASK			(1 << 7)
-#define	 SFF8636_TX_LOS_3_MASK			(1 << 6)
-#define	 SFF8636_TX_LOS_2_MASK			(1 << 5)
-#define	 SFF8636_TX_LOS_1_MASK			(1 << 4)
-#define	 SFF8636_RX_LOS_4_MASK			(1 << 3)
-#define	 SFF8636_RX_LOS_3_MASK			(1 << 2)
-#define	 SFF8636_RX_LOS_2_MASK			(1 << 1)
-#define	 SFF8636_RX_LOS_1_MASK			(1 << 0)
+#define	 SFF8636_TX_LOS_4_MASK			BIT(7)
+#define	 SFF8636_TX_LOS_3_MASK			BIT(6)
+#define	 SFF8636_TX_LOS_2_MASK			BIT(5)
+#define	 SFF8636_TX_LOS_1_MASK			BIT(4)
+#define	 SFF8636_RX_LOS_4_MASK			BIT(3)
+#define	 SFF8636_RX_LOS_3_MASK			BIT(2)
+#define	 SFF8636_RX_LOS_2_MASK			BIT(1)
+#define	 SFF8636_RX_LOS_1_MASK			BIT(0)
 
 #define	SFF8636_FAULT_MASK_OFFSET	0x65
-#define	 SFF8636_TX_FAULT_1_MASK		(1 << 3)
-#define	 SFF8636_TX_FAULT_2_MASK		(1 << 2)
-#define	 SFF8636_TX_FAULT_3_MASK		(1 << 1)
-#define	 SFF8636_TX_FAULT_4_MASK		(1 << 0)
+#define	 SFF8636_TX_FAULT_1_MASK		BIT(3)
+#define	 SFF8636_TX_FAULT_2_MASK		BIT(2)
+#define	 SFF8636_TX_FAULT_3_MASK		BIT(1)
+#define	 SFF8636_TX_FAULT_4_MASK		BIT(0)
 
 #define	SFF8636_TEMP_MASK_OFFSET	0x67
-#define	 SFF8636_TEMP_HALARM_MASK		(1 << 7)
-#define	 SFF8636_TEMP_LALARM_MASK		(1 << 6)
-#define	 SFF8636_TEMP_HWARN_MASK		(1 << 5)
-#define	 SFF8636_TEMP_LWARN_MASK		(1 << 4)
+#define	 SFF8636_TEMP_HALARM_MASK		BIT(7)
+#define	 SFF8636_TEMP_LALARM_MASK		BIT(6)
+#define	 SFF8636_TEMP_HWARN_MASK		BIT(5)
+#define	 SFF8636_TEMP_LWARN_MASK		BIT(4)
 
 #define	SFF8636_VCC_MASK_OFFSET		0x68
-#define	 SFF8636_VCC_HALARM_MASK		(1 << 7)
-#define	 SFF8636_VCC_LALARM_MASK		(1 << 6)
-#define	 SFF8636_VCC_HWARN_MASK			(1 << 5)
-#define	 SFF8636_VCC_LWARN_MASK			(1 << 4)
+#define	 SFF8636_VCC_HALARM_MASK		BIT(7)
+#define	 SFF8636_VCC_LALARM_MASK		BIT(6)
+#define	 SFF8636_VCC_HWARN_MASK			BIT(5)
+#define	 SFF8636_VCC_LWARN_MASK			BIT(4)
 
 /*------------------------------------------------------------------------------
  *
@@ -225,15 +225,15 @@
 #define SFF8636_EXT_ID_OFFSET		0x81
 #define	 SFF8636_EXT_ID_PWR_CLASS_MASK		0xC0
 #define	  SFF8636_EXT_ID_PWR_CLASS_1		(0 << 6)
-#define	  SFF8636_EXT_ID_PWR_CLASS_2		(1 << 6)
+#define	  SFF8636_EXT_ID_PWR_CLASS_2		BIT(6)
 #define	  SFF8636_EXT_ID_PWR_CLASS_3		(2 << 6)
 #define	  SFF8636_EXT_ID_PWR_CLASS_4		(3 << 6)
 #define	 SFF8636_EXT_ID_CLIE_MASK		0x10
-#define	  SFF8636_EXT_ID_CLIEI_CODE_PRESENT	(1 << 4)
+#define	  SFF8636_EXT_ID_CLIEI_CODE_PRESENT	BIT(4)
 #define	 SFF8636_EXT_ID_CDR_TX_MASK		0x08
-#define	  SFF8636_EXT_ID_CDR_TX_PRESENT		(1 << 3)
+#define	  SFF8636_EXT_ID_CDR_TX_PRESENT		BIT(3)
 #define	 SFF8636_EXT_ID_CDR_RX_MASK		0x04
-#define	  SFF8636_EXT_ID_CDR_RX_PRESENT		(1 << 2)
+#define	  SFF8636_EXT_ID_CDR_RX_PRESENT		BIT(2)
 #define	 SFF8636_EXT_ID_EPWR_CLASS_MASK		0x03
 #define	  SFF8636_EXT_ID_PWR_CLASS_LEGACY	0
 #define	  SFF8636_EXT_ID_PWR_CLASS_5		1
@@ -266,78 +266,78 @@
 /* Specification Compliance - 131-138 */
 /* Ethernet Compliance Codes - 131 */
 #define	SFF8636_ETHERNET_COMP_OFFSET	0x83
-#define	 SFF8636_ETHERNET_RSRVD			(1 << 7)
-#define	 SFF8636_ETHERNET_10G_LRM		(1 << 6)
-#define	 SFF8636_ETHERNET_10G_LR		(1 << 5)
-#define	 SFF8636_ETHERNET_10G_SR		(1 << 4)
-#define	 SFF8636_ETHERNET_40G_CR4		(1 << 3)
-#define	 SFF8636_ETHERNET_40G_SR4		(1 << 2)
-#define	 SFF8636_ETHERNET_40G_LR4		(1 << 1)
-#define	 SFF8636_ETHERNET_40G_ACTIVE	(1 << 0)
+#define	 SFF8636_ETHERNET_RSRVD			BIT(7)
+#define	 SFF8636_ETHERNET_10G_LRM		BIT(6)
+#define	 SFF8636_ETHERNET_10G_LR		BIT(5)
+#define	 SFF8636_ETHERNET_10G_SR		BIT(4)
+#define	 SFF8636_ETHERNET_40G_CR4		BIT(3)
+#define	 SFF8636_ETHERNET_40G_SR4		BIT(2)
+#define	 SFF8636_ETHERNET_40G_LR4		BIT(1)
+#define	 SFF8636_ETHERNET_40G_ACTIVE	BIT(0)
 
 /* SONET Compliance Codes - 132 */
 #define	SFF8636_SONET_COMP_OFFSET	0x84
-#define	 SFF8636_SONET_40G_OTN			(1 << 3)
-#define	 SFF8636_SONET_OC48_LR			(1 << 2)
-#define	 SFF8636_SONET_OC48_IR			(1 << 1)
-#define	 SFF8636_SONET_OC48_SR			(1 << 0)
+#define	 SFF8636_SONET_40G_OTN			BIT(3)
+#define	 SFF8636_SONET_OC48_LR			BIT(2)
+#define	 SFF8636_SONET_OC48_IR			BIT(1)
+#define	 SFF8636_SONET_OC48_SR			BIT(0)
 
 /* SAS/SATA Complaince Codes - 133 */
 #define	SFF8636_SAS_COMP_OFFSET		0x85
-#define	 SFF8636_SAS_12G			(1 << 6)
-#define	 SFF8636_SAS_6G				(1 << 5)
-#define	 SFF8636_SAS_3G				(1 << 4)
+#define	 SFF8636_SAS_12G			BIT(6)
+#define	 SFF8636_SAS_6G				BIT(5)
+#define	 SFF8636_SAS_3G				BIT(4)
 
 /* Gigabit Ethernet Compliance Codes - 134 */
 #define	SFF8636_GIGE_COMP_OFFSET	0x86
-#define	 SFF8636_GIGE_1000_BASE_T		(1 << 3)
-#define	 SFF8636_GIGE_1000_BASE_CX		(1 << 2)
-#define	 SFF8636_GIGE_1000_BASE_LX		(1 << 1)
-#define	 SFF8636_GIGE_1000_BASE_SX		(1 << 0)
+#define	 SFF8636_GIGE_1000_BASE_T		BIT(3)
+#define	 SFF8636_GIGE_1000_BASE_CX		BIT(2)
+#define	 SFF8636_GIGE_1000_BASE_LX		BIT(1)
+#define	 SFF8636_GIGE_1000_BASE_SX		BIT(0)
 
 /* Fibre Channel Link length/Transmitter Tech. - 135,136 */
 #define	SFF8636_FC_LEN_OFFSET		0x87
-#define	 SFF8636_FC_LEN_VERY_LONG		(1 << 7)
-#define	 SFF8636_FC_LEN_SHORT			(1 << 6)
-#define	 SFF8636_FC_LEN_INT			(1 << 5)
-#define	 SFF8636_FC_LEN_LONG			(1 << 4)
-#define	 SFF8636_FC_LEN_MED			(1 << 3)
-#define	 SFF8636_FC_TECH_LONG_LC		(1 << 1)
-#define	 SFF8636_FC_TECH_ELEC_INTER		(1 << 0)
+#define	 SFF8636_FC_LEN_VERY_LONG		BIT(7)
+#define	 SFF8636_FC_LEN_SHORT			BIT(6)
+#define	 SFF8636_FC_LEN_INT			BIT(5)
+#define	 SFF8636_FC_LEN_LONG			BIT(4)
+#define	 SFF8636_FC_LEN_MED			BIT(3)
+#define	 SFF8636_FC_TECH_LONG_LC		BIT(1)
+#define	 SFF8636_FC_TECH_ELEC_INTER		BIT(0)
 
 #define	SFF8636_FC_TECH_OFFSET		0x88
-#define	 SFF8636_FC_TECH_ELEC_INTRA		(1 << 7)
-#define	 SFF8636_FC_TECH_SHORT_WO_OFC		(1 << 6)
-#define	 SFF8636_FC_TECH_SHORT_W_OFC		(1 << 5)
-#define	 SFF8636_FC_TECH_LONG_LL		(1 << 4)
+#define	 SFF8636_FC_TECH_ELEC_INTRA		BIT(7)
+#define	 SFF8636_FC_TECH_SHORT_WO_OFC		BIT(6)
+#define	 SFF8636_FC_TECH_SHORT_W_OFC		BIT(5)
+#define	 SFF8636_FC_TECH_LONG_LL		BIT(4)
 
 /* Fibre Channel Transmitter Media - 137 */
 #define	SFF8636_FC_TRANS_MEDIA_OFFSET	0x89
 /* Twin Axial Pair */
-#define	 SFF8636_FC_TRANS_MEDIA_TW		(1 << 7)
+#define	 SFF8636_FC_TRANS_MEDIA_TW		BIT(7)
 /* Shielded Twisted Pair */
-#define	 SFF8636_FC_TRANS_MEDIA_TP		(1 << 6)
+#define	 SFF8636_FC_TRANS_MEDIA_TP		BIT(6)
 /* Miniature Coax */
-#define	 SFF8636_FC_TRANS_MEDIA_MI		(1 << 5)
+#define	 SFF8636_FC_TRANS_MEDIA_MI		BIT(5)
 /* Video Coax */
-#define	 SFF8636_FC_TRANS_MEDIA_TV		(1 << 4)
+#define	 SFF8636_FC_TRANS_MEDIA_TV		BIT(4)
 /* Multi-mode 62.5m */
-#define	 SFF8636_FC_TRANS_MEDIA_M6		(1 << 3)
+#define	 SFF8636_FC_TRANS_MEDIA_M6		BIT(3)
 /* Multi-mode 50m */
-#define	 SFF8636_FC_TRANS_MEDIA_M5		(1 << 2)
+#define	 SFF8636_FC_TRANS_MEDIA_M5		BIT(2)
 /* Multi-mode 50um */
-#define	 SFF8636_FC_TRANS_MEDIA_OM3		(1 << 1)
+#define	 SFF8636_FC_TRANS_MEDIA_OM3		BIT(1)
 /* Single Mode */
-#define	 SFF8636_FC_TRANS_MEDIA_SM		(1 << 0)
+#define	 SFF8636_FC_TRANS_MEDIA_SM		BIT(0)
 
 /* Fibre Channel Speed - 138 */
 #define	SFF8636_FC_SPEED_OFFSET		0x8A
-#define	 SFF8636_FC_SPEED_1200_MBPS		(1 << 7)
-#define	 SFF8636_FC_SPEED_800_MBPS		(1 << 6)
-#define	 SFF8636_FC_SPEED_1600_MBPS		(1 << 5)
-#define	 SFF8636_FC_SPEED_400_MBPS		(1 << 4)
-#define	 SFF8636_FC_SPEED_200_MBPS		(1 << 2)
-#define	 SFF8636_FC_SPEED_100_MBPS		(1 << 0)
+#define	 SFF8636_FC_SPEED_1200_MBPS		BIT(7)
+#define	 SFF8636_FC_SPEED_800_MBPS		BIT(6)
+#define	 SFF8636_FC_SPEED_1600_MBPS		BIT(5)
+#define	 SFF8636_FC_SPEED_400_MBPS		BIT(4)
+#define	 SFF8636_FC_SPEED_200_MBPS		BIT(2)
+#define	 SFF8636_FC_SPEED_100_MBPS		BIT(0)
 
 /* Encoding - 139 */
 /* Values are defined under SFF8024_ENCODING */
@@ -355,7 +355,7 @@
 
 /* Extended RateSelect - 141 */
 #define	SFF8636_EXT_RS_OFFSET		0x8D
-#define	 SFF8636_EXT_RS_V1			(1 << 0)
+#define	 SFF8636_EXT_RS_V1			BIT(0)
 
 /* Length (Standard SM Fiber)-km - 142 */
 #define	SFF8636_SM_LEN_OFFSET		0x8E
@@ -405,18 +405,18 @@
 /* 1550 nm VCSEL */
 #define	 SFF8636_TRANS_1550_VCSEL		(2 << 4)
 /* 1310 nm VCSEL */
-#define	 SFF8636_TRANS_1310_VCSEL		(1 << 4)
+#define	 SFF8636_TRANS_1310_VCSEL		BIT(4)
 /* 850 nm VCSEL */
 #define	 SFF8636_TRANS_850_VCSEL		(0 << 4)
 
  /* Active/No wavelength control */
-#define	 SFF8636_DEV_TECH_ACTIVE_WAVE_LEN	(1 << 3)
+#define	 SFF8636_DEV_TECH_ACTIVE_WAVE_LEN	BIT(3)
 /* Cooled transmitter */
-#define	 SFF8636_DEV_TECH_COOL_TRANS		(1 << 2)
+#define	 SFF8636_DEV_TECH_COOL_TRANS		BIT(2)
 /* APD/Pin Detector */
-#define	 SFF8636_DEV_TECH_APD_DETECTOR		(1 << 1)
+#define	 SFF8636_DEV_TECH_APD_DETECTOR		BIT(1)
 /* Transmitter tunable */
-#define	 SFF8636_DEV_TECH_TUNABLE		(1 << 0)
+#define	 SFF8636_DEV_TECH_TUNABLE		BIT(0)
 
 /* Vendor Name - 148-163 */
 #define	 SFF8636_VENDOR_NAME_START_OFFSET	0x94
@@ -424,11 +424,11 @@
 
 /* Extended Module Codes - 164 */
 #define	 SFF8636_EXT_MOD_CODE_OFFSET	0xA4
-#define	  SFF8636_EXT_MOD_INFINIBAND_EDR	(1 << 4)
-#define	  SFF8636_EXT_MOD_INFINIBAND_FDR	(1 << 3)
-#define	  SFF8636_EXT_MOD_INFINIBAND_QDR	(1 << 2)
-#define	  SFF8636_EXT_MOD_INFINIBAND_DDR	(1 << 1)
-#define	  SFF8636_EXT_MOD_INFINIBAND_SDR	(1 << 0)
+#define	  SFF8636_EXT_MOD_INFINIBAND_EDR	BIT(4)
+#define	  SFF8636_EXT_MOD_INFINIBAND_FDR	BIT(3)
+#define	  SFF8636_EXT_MOD_INFINIBAND_QDR	BIT(2)
+#define	  SFF8636_EXT_MOD_INFINIBAND_DDR	BIT(1)
+#define	  SFF8636_EXT_MOD_INFINIBAND_SDR	BIT(0)
 
 /* Vendor OUI - 165-167 */
 #define	 SFF8636_VENDOR_OUI_OFFSET		0xA5
@@ -521,31 +521,31 @@
 
 #define	 SFF8636_OPTION_2_OFFSET	0xC1
 /* Rx output amplitude */
-#define	  SFF8636_O2_RX_OUTPUT_AMP	(1 << 0)
+#define	  SFF8636_O2_RX_OUTPUT_AMP	BIT(0)
 #define	 SFF8636_OPTION_3_OFFSET	0xC2
 /* Rx Squelch Disable */
-#define	  SFF8636_O3_RX_SQL_DSBL	(1 << 3)
+#define	  SFF8636_O3_RX_SQL_DSBL	BIT(3)
 /* Rx Output Disable capable */
-#define	  SFF8636_O3_RX_OUTPUT_DSBL	(1 << 2)
+#define	  SFF8636_O3_RX_OUTPUT_DSBL	BIT(2)
 /* Tx Squelch Disable */
-#define	  SFF8636_O3_TX_SQL_DSBL	(1 << 1)
+#define	  SFF8636_O3_TX_SQL_DSBL	BIT(1)
 /* Tx Squelch Impl */
-#define	  SFF8636_O3_TX_SQL_IMPL	(1 << 0)
+#define	  SFF8636_O3_TX_SQL_IMPL	BIT(0)
 #define	 SFF8636_OPTION_4_OFFSET	0xC3
 /* Memory Page 02 present */
-#define	  SFF8636_O4_PAGE_02_PRESENT	(1 << 7)
+#define	  SFF8636_O4_PAGE_02_PRESENT	BIT(7)
 /* Memory Page 01 present */
-#define	  SFF8636_O4_PAGE_01_PRESENT	(1 << 6)
+#define	  SFF8636_O4_PAGE_01_PRESENT	BIT(6)
 /* Rate Select implemented */
-#define	  SFF8636_O4_RATE_SELECT	(1 << 5)
+#define	  SFF8636_O4_RATE_SELECT	BIT(5)
 /* Tx_DISABLE implemented */
-#define	  SFF8636_O4_TX_DISABLE		(1 << 4)
+#define	  SFF8636_O4_TX_DISABLE		BIT(4)
 /* Tx_FAULT implemented */
-#define	  SFF8636_O4_TX_FAULT		(1 << 3)
+#define	  SFF8636_O4_TX_FAULT		BIT(3)
 /* Tx Squelch implemented */
-#define	  SFF8636_O4_TX_SQUELCH		(1 << 2)
+#define	  SFF8636_O4_TX_SQUELCH		BIT(2)
 /* Tx Loss of Signal */
-#define	  SFF8636_O4_TX_LOS		(1 << 1)
+#define	  SFF8636_O4_TX_LOS		BIT(1)
 
 /* Vendor SN - 196-211 */
 #define	 SFF8636_VENDOR_SN_START_OFFSET	0xC4
@@ -564,15 +564,15 @@
 /* Diagnostic Monitoring Type - 220 */
 #define	 SFF8636_DIAG_TYPE_OFFSET	0xDC
 #define	  SFF8636_RX_PWR_TYPE_MASK	0x8
-#define	   SFF8636_RX_PWR_TYPE_AVG_PWR	(1 << 3)
+#define	   SFF8636_RX_PWR_TYPE_AVG_PWR	BIT(3)
 #define	   SFF8636_RX_PWR_TYPE_OMA	(0 << 3)
 #define	  SFF8636_TX_PWR_TYPE_MASK	0x4
-#define	   SFF8636_TX_PWR_TYPE_AVG_PWR	(1 << 2)
+#define	   SFF8636_TX_PWR_TYPE_AVG_PWR	BIT(2)
 
 /* Enhanced Options - 221 */
 #define	 SFF8636_ENH_OPTIONS_OFFSET	0xDD
-#define	  SFF8636_RATE_SELECT_EXT_SUPPORT	(1 << 3)
-#define	  SFF8636_RATE_SELECT_APP_TABLE_SUPPORT	(1 << 2)
+#define	  SFF8636_RATE_SELECT_EXT_SUPPORT	BIT(3)
+#define	  SFF8636_RATE_SELECT_APP_TABLE_SUPPORT	BIT(2)
 
 /* Check code - 223 */
 #define	 SFF8636_CC_EXT_OFFSET		0xDF
diff --git a/realtek.c b/realtek.c
index ee0c6119dafa..a2d6ebe6aaa4 100644
--- a/realtek.c
+++ b/realtek.c
@@ -227,17 +227,17 @@ print_intr_bits(u16 mask)
 {
 	fprintf(stdout,
 		"      %s%s%s%s%s%s%s%s%s%s%s\n",
-		mask & (1 << 15)	? "SERR " : "",
-		mask & (1 << 14)	? "TimeOut " : "",
-		mask & (1 << 8)		? "SWInt " : "",
-		mask & (1 << 7)		? "TxNoBuf " : "",
-		mask & (1 << 6)		? "RxFIFO " : "",
-		mask & (1 << 5)		? "LinkChg " : "",
-		mask & (1 << 4)		? "RxNoBuf " : "",
-		mask & (1 << 3)		? "TxErr " : "",
-		mask & (1 << 2)		? "TxOK " : "",
-		mask & (1 << 1)		? "RxErr " : "",
-		mask & (1 << 0)		? "RxOK " : "");
+		mask & BIT(15)	? "SERR " : "",
+		mask & BIT(14)	? "TimeOut " : "",
+		mask & BIT(8)		? "SWInt " : "",
+		mask & BIT(7)		? "TxNoBuf " : "",
+		mask & BIT(6)		? "RxFIFO " : "",
+		mask & BIT(5)		? "LinkChg " : "",
+		mask & BIT(4)		? "RxNoBuf " : "",
+		mask & BIT(3)		? "TxErr " : "",
+		mask & BIT(2)		? "TxOK " : "",
+		mask & BIT(1)		? "RxErr " : "",
+		mask & BIT(0)		? "RxOK " : "");
 }
 
 int
@@ -342,10 +342,10 @@ realtek_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 	if (v & 0xf) {
 	fprintf(stdout,
 		"      %s%s%s%s\n",
-		v & (1 << 3) ? "ERxGood " : "",
-		v & (1 << 2) ? "ERxBad " : "",
-		v & (1 << 1) ? "ERxOverWrite " : "",
-		v & (1 << 0) ? "ERxOK " : "");
+		v & BIT(3) ? "ERxGood " : "",
+		v & BIT(2) ? "ERxBad " : "",
+		v & BIT(1) ? "ERxOverWrite " : "",
+		v & BIT(0) ? "ERxOK " : "");
 	}
 
 	v = data8[0x37];
@@ -353,9 +353,9 @@ realtek_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		"0x37: Command                                       0x%02x\n"
 		"      Rx %s, Tx %s%s\n",
 		data8[0x37],
-		v & (1 << 3) ? "on" : "off",
-		v & (1 << 2) ? "on" : "off",
-		v & (1 << 4) ? ", RESET" : "");
+		v & BIT(3) ? "on" : "off",
+		v & BIT(2) ? "on" : "off",
+		v & BIT(4) ? ", RESET" : "");
 
 	if (board_type < RTL_GIGA_MAC_VER_01) {
 	fprintf(stdout,
@@ -631,17 +631,17 @@ realtek_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 	fprintf(stdout,
 		"0xE0: C+ Command                                  0x%04x\n",
 		v);
-	if (v & (1 << 9))
+	if (v & BIT(9))
 		fprintf(stdout, "      Big-endian mode\n");
-	if (v & (1 << 8))
+	if (v & BIT(8))
 		fprintf(stdout, "      Home LAN enable\n");
-	if (v & (1 << 6))
+	if (v & BIT(6))
 		fprintf(stdout, "      VLAN de-tagging\n");
-	if (v & (1 << 5))
+	if (v & BIT(5))
 		fprintf(stdout, "      RX checksumming\n");
-	if (v & (1 << 4))
+	if (v & BIT(4))
 		fprintf(stdout, "      PCI 64-bit DAC\n");
-	if (v & (1 << 3))
+	if (v & BIT(3))
 		fprintf(stdout, "      PCI Multiple RW\n");
 
 	v = data[0xe0 >> 2] >> 16;
diff --git a/rxclass.c b/rxclass.c
index ebdd97960e5b..6ceb75c40a5a 100644
--- a/rxclass.c
+++ b/rxclass.c
@@ -446,7 +446,7 @@ static int rmgr_find_empty_slot(struct rmgr_ctrl *rmgr,
 	 * If loc rolls over it should be greater than or equal to rmgr->size
 	 * and as such we know we have reached the end of the list.
 	 */
-	if (!~(rmgr->slot[slot_num] | (~1UL << rmgr->size % BITS_PER_LONG))) {
+	if (!~(rmgr->slot[slot_num] | ~BIT_ULL(rmgr->size % BITS_PER_LONG))) {
 		loc -= 1 + (loc % BITS_PER_LONG);
 		slot_num--;
 	}
diff --git a/sfc.c b/sfc.c
index a33077b4f263..50b59d72b861 100644
--- a/sfc.c
+++ b/sfc.c
@@ -3773,7 +3773,7 @@ print_field_value(const struct efx_nic_reg_field *field, const u8 *buf)
 		digit = buf[left >> 3];
 		if ((left & 7) + sig_bits > 8)
 			digit |= buf[(left >> 3) + 1] << 8;
-		digit = (digit >> (left & 7)) & ((1 << sig_bits) - 1);
+		digit = (digit >> (left & 7)) & (BIT(sig_bits) - 1);
 		printf("%x", digit);
 		sig_bits = 4; /* for all subsequent digits */
 	}
diff --git a/sfpdiag.c b/sfpdiag.c
index 502b6e3bf11e..467b593d59a5 100644
--- a/sfpdiag.c
+++ b/sfpdiag.c
@@ -22,12 +22,12 @@
 #define SFF_A0_COMP                       94
 
 /* EEPROM bit values for various registers */
-#define SFF_A0_DOM_EXTCAL                 (1 << 4)
-#define SFF_A0_DOM_INTCAL                 (1 << 5)
-#define SFF_A0_DOM_IMPL                   (1 << 6)
-#define SFF_A0_DOM_PWRT                   (1 << 3)
+#define SFF_A0_DOM_EXTCAL                 BIT(4)
+#define SFF_A0_DOM_INTCAL                 BIT(5)
+#define SFF_A0_DOM_IMPL                   BIT(6)
+#define SFF_A0_DOM_PWRT                   BIT(3)
 
-#define SFF_A0_OPTIONS_AW                 (1 << 7)
+#define SFF_A0_OPTIONS_AW                 BIT(7)
 
 /*
  * See ethtool.c comments about SFF-8472, this is the offset
@@ -92,30 +92,30 @@ static struct sff8472_aw_flags {
 	int offset;             /* A2-relative address offset */
 	__u8 value;             /* Alarm is on if (offset & value) != 0. */
 } sff8472_aw_flags[] = {
-	{ "Laser bias current high alarm",   SFF_A2_ALRM_FLG, (1 << 3) },
-	{ "Laser bias current low alarm",    SFF_A2_ALRM_FLG, (1 << 2) },
-	{ "Laser bias current high warning", SFF_A2_WARN_FLG, (1 << 3) },
-	{ "Laser bias current low warning",  SFF_A2_WARN_FLG, (1 << 2) },
-
-	{ "Laser output power high alarm",   SFF_A2_ALRM_FLG, (1 << 1) },
-	{ "Laser output power low alarm",    SFF_A2_ALRM_FLG, (1 << 0) },
-	{ "Laser output power high warning", SFF_A2_WARN_FLG, (1 << 1) },
-	{ "Laser output power low warning",  SFF_A2_WARN_FLG, (1 << 0) },
-
-	{ "Module temperature high alarm",   SFF_A2_ALRM_FLG, (1 << 7) },
-	{ "Module temperature low alarm",    SFF_A2_ALRM_FLG, (1 << 6) },
-	{ "Module temperature high warning", SFF_A2_WARN_FLG, (1 << 7) },
-	{ "Module temperature low warning",  SFF_A2_WARN_FLG, (1 << 6) },
-
-	{ "Module voltage high alarm",   SFF_A2_ALRM_FLG, (1 << 5) },
-	{ "Module voltage low alarm",    SFF_A2_ALRM_FLG, (1 << 4) },
-	{ "Module voltage high warning", SFF_A2_WARN_FLG, (1 << 5) },
-	{ "Module voltage low warning",  SFF_A2_WARN_FLG, (1 << 4) },
-
-	{ "Laser rx power high alarm",   SFF_A2_ALRM_FLG + 1, (1 << 7) },
-	{ "Laser rx power low alarm",    SFF_A2_ALRM_FLG + 1, (1 << 6) },
-	{ "Laser rx power high warning", SFF_A2_WARN_FLG + 1, (1 << 7) },
-	{ "Laser rx power low warning",  SFF_A2_WARN_FLG + 1, (1 << 6) },
+	{ "Laser bias current high alarm",   SFF_A2_ALRM_FLG, BIT(3) },
+	{ "Laser bias current low alarm",    SFF_A2_ALRM_FLG, BIT(2) },
+	{ "Laser bias current high warning", SFF_A2_WARN_FLG, BIT(3) },
+	{ "Laser bias current low warning",  SFF_A2_WARN_FLG, BIT(2) },
+
+	{ "Laser output power high alarm",   SFF_A2_ALRM_FLG, BIT(1) },
+	{ "Laser output power low alarm",    SFF_A2_ALRM_FLG, BIT(0) },
+	{ "Laser output power high warning", SFF_A2_WARN_FLG, BIT(1) },
+	{ "Laser output power low warning",  SFF_A2_WARN_FLG, BIT(0) },
+
+	{ "Module temperature high alarm",   SFF_A2_ALRM_FLG, BIT(7) },
+	{ "Module temperature low alarm",    SFF_A2_ALRM_FLG, BIT(6) },
+	{ "Module temperature high warning", SFF_A2_WARN_FLG, BIT(7) },
+	{ "Module temperature low warning",  SFF_A2_WARN_FLG, BIT(6) },
+
+	{ "Module voltage high alarm",   SFF_A2_ALRM_FLG, BIT(5) },
+	{ "Module voltage low alarm",    SFF_A2_ALRM_FLG, BIT(4) },
+	{ "Module voltage high warning", SFF_A2_WARN_FLG, BIT(5) },
+	{ "Module voltage low warning",  SFF_A2_WARN_FLG, BIT(4) },
+
+	{ "Laser rx power high alarm",   SFF_A2_ALRM_FLG + 1, BIT(7) },
+	{ "Laser rx power low alarm",    SFF_A2_ALRM_FLG + 1, BIT(6) },
+	{ "Laser rx power high warning", SFF_A2_WARN_FLG + 1, BIT(7) },
+	{ "Laser rx power low warning",  SFF_A2_WARN_FLG + 1, BIT(6) },
 
 	{ NULL, 0, 0 },
 };
diff --git a/sfpid.c b/sfpid.c
index b701e292518d..7654715fe311 100644
--- a/sfpid.c
+++ b/sfpid.c
@@ -48,128 +48,128 @@ static void sff8079_show_transceiver(const __u8 *id)
 	       id[3], id[4], id[5], id[6],
 	       id[7], id[8], id[9], id[10], id[36]);
 	/* 10G Ethernet Compliance Codes */
-	if (id[3] & (1 << 7))
+	if (id[3] & BIT(7))
 		printf("%s 10G Ethernet: 10G Base-ER" \
 		       " [SFF-8472 rev10.4 onwards]\n", pfx);
-	if (id[3] & (1 << 6))
+	if (id[3] & BIT(6))
 		printf("%s 10G Ethernet: 10G Base-LRM\n", pfx);
-	if (id[3] & (1 << 5))
+	if (id[3] & BIT(5))
 		printf("%s 10G Ethernet: 10G Base-LR\n", pfx);
-	if (id[3] & (1 << 4))
+	if (id[3] & BIT(4))
 		printf("%s 10G Ethernet: 10G Base-SR\n", pfx);
 	/* Infiniband Compliance Codes */
-	if (id[3] & (1 << 3))
+	if (id[3] & BIT(3))
 		printf("%s Infiniband: 1X SX\n", pfx);
-	if (id[3] & (1 << 2))
+	if (id[3] & BIT(2))
 		printf("%s Infiniband: 1X LX\n", pfx);
-	if (id[3] & (1 << 1))
+	if (id[3] & BIT(1))
 		printf("%s Infiniband: 1X Copper Active\n", pfx);
-	if (id[3] & (1 << 0))
+	if (id[3] & BIT(0))
 		printf("%s Infiniband: 1X Copper Passive\n", pfx);
 	/* ESCON Compliance Codes */
-	if (id[4] & (1 << 7))
+	if (id[4] & BIT(7))
 		printf("%s ESCON: ESCON MMF, 1310nm LED\n", pfx);
-	if (id[4] & (1 << 6))
+	if (id[4] & BIT(6))
 		printf("%s ESCON: ESCON SMF, 1310nm Laser\n", pfx);
 	/* SONET Compliance Codes */
-	if (id[4] & (1 << 5))
+	if (id[4] & BIT(5))
 		printf("%s SONET: OC-192, short reach\n", pfx);
-	if (id[4] & (1 << 4))
+	if (id[4] & BIT(4))
 		printf("%s SONET: SONET reach specifier bit 1\n", pfx);
-	if (id[4] & (1 << 3))
+	if (id[4] & BIT(3))
 		printf("%s SONET: SONET reach specifier bit 2\n", pfx);
-	if (id[4] & (1 << 2))
+	if (id[4] & BIT(2))
 		printf("%s SONET: OC-48, long reach\n", pfx);
-	if (id[4] & (1 << 1))
+	if (id[4] & BIT(1))
 		printf("%s SONET: OC-48, intermediate reach\n", pfx);
-	if (id[4] & (1 << 0))
+	if (id[4] & BIT(0))
 		printf("%s SONET: OC-48, short reach\n", pfx);
-	if (id[5] & (1 << 6))
+	if (id[5] & BIT(6))
 		printf("%s SONET: OC-12, single mode, long reach\n", pfx);
-	if (id[5] & (1 << 5))
+	if (id[5] & BIT(5))
 		printf("%s SONET: OC-12, single mode, inter. reach\n", pfx);
-	if (id[5] & (1 << 4))
+	if (id[5] & BIT(4))
 		printf("%s SONET: OC-12, short reach\n", pfx);
-	if (id[5] & (1 << 2))
+	if (id[5] & BIT(2))
 		printf("%s SONET: OC-3, single mode, long reach\n", pfx);
-	if (id[5] & (1 << 1))
+	if (id[5] & BIT(1))
 		printf("%s SONET: OC-3, single mode, inter. reach\n", pfx);
-	if (id[5] & (1 << 0))
+	if (id[5] & BIT(0))
 		printf("%s SONET: OC-3, short reach\n", pfx);
 	/* Ethernet Compliance Codes */
-	if (id[6] & (1 << 7))
+	if (id[6] & BIT(7))
 		printf("%s Ethernet: BASE-PX\n", pfx);
-	if (id[6] & (1 << 6))
+	if (id[6] & BIT(6))
 		printf("%s Ethernet: BASE-BX10\n", pfx);
-	if (id[6] & (1 << 5))
+	if (id[6] & BIT(5))
 		printf("%s Ethernet: 100BASE-FX\n", pfx);
-	if (id[6] & (1 << 4))
+	if (id[6] & BIT(4))
 		printf("%s Ethernet: 100BASE-LX/LX10\n", pfx);
-	if (id[6] & (1 << 3))
+	if (id[6] & BIT(3))
 		printf("%s Ethernet: 1000BASE-T\n", pfx);
-	if (id[6] & (1 << 2))
+	if (id[6] & BIT(2))
 		printf("%s Ethernet: 1000BASE-CX\n", pfx);
-	if (id[6] & (1 << 1))
+	if (id[6] & BIT(1))
 		printf("%s Ethernet: 1000BASE-LX\n", pfx);
-	if (id[6] & (1 << 0))
+	if (id[6] & BIT(0))
 		printf("%s Ethernet: 1000BASE-SX\n", pfx);
 	/* Fibre Channel link length */
-	if (id[7] & (1 << 7))
+	if (id[7] & BIT(7))
 		printf("%s FC: very long distance (V)\n", pfx);
-	if (id[7] & (1 << 6))
+	if (id[7] & BIT(6))
 		printf("%s FC: short distance (S)\n", pfx);
-	if (id[7] & (1 << 5))
+	if (id[7] & BIT(5))
 		printf("%s FC: intermediate distance (I)\n", pfx);
-	if (id[7] & (1 << 4))
+	if (id[7] & BIT(4))
 		printf("%s FC: long distance (L)\n", pfx);
-	if (id[7] & (1 << 3))
+	if (id[7] & BIT(3))
 		printf("%s FC: medium distance (M)\n", pfx);
 	/* Fibre Channel transmitter technology */
-	if (id[7] & (1 << 2))
+	if (id[7] & BIT(2))
 		printf("%s FC: Shortwave laser, linear Rx (SA)\n", pfx);
-	if (id[7] & (1 << 1))
+	if (id[7] & BIT(1))
 		printf("%s FC: Longwave laser (LC)\n", pfx);
-	if (id[7] & (1 << 0))
+	if (id[7] & BIT(0))
 		printf("%s FC: Electrical inter-enclosure (EL)\n", pfx);
-	if (id[8] & (1 << 7))
+	if (id[8] & BIT(7))
 		printf("%s FC: Electrical intra-enclosure (EL)\n", pfx);
-	if (id[8] & (1 << 6))
+	if (id[8] & BIT(6))
 		printf("%s FC: Shortwave laser w/o OFC (SN)\n", pfx);
-	if (id[8] & (1 << 5))
+	if (id[8] & BIT(5))
 		printf("%s FC: Shortwave laser with OFC (SL)\n", pfx);
-	if (id[8] & (1 << 4))
+	if (id[8] & BIT(4))
 		printf("%s FC: Longwave laser (LL)\n", pfx);
-	if (id[8] & (1 << 3))
+	if (id[8] & BIT(3))
 		printf("%s Active Cable\n", pfx);
-	if (id[8] & (1 << 2))
+	if (id[8] & BIT(2))
 		printf("%s Passive Cable\n", pfx);
-	if (id[8] & (1 << 1))
+	if (id[8] & BIT(1))
 		printf("%s FC: Copper FC-BaseT\n", pfx);
 	/* Fibre Channel transmission media */
-	if (id[9] & (1 << 7))
+	if (id[9] & BIT(7))
 		printf("%s FC: Twin Axial Pair (TW)\n", pfx);
-	if (id[9] & (1 << 6))
+	if (id[9] & BIT(6))
 		printf("%s FC: Twisted Pair (TP)\n", pfx);
-	if (id[9] & (1 << 5))
+	if (id[9] & BIT(5))
 		printf("%s FC: Miniature Coax (MI)\n", pfx);
-	if (id[9] & (1 << 4))
+	if (id[9] & BIT(4))
 		printf("%s FC: Video Coax (TV)\n", pfx);
-	if (id[9] & (1 << 3))
+	if (id[9] & BIT(3))
 		printf("%s FC: Multimode, 62.5um (M6)\n", pfx);
-	if (id[9] & (1 << 2))
+	if (id[9] & BIT(2))
 		printf("%s FC: Multimode, 50um (M5)\n", pfx);
-	if (id[9] & (1 << 0))
+	if (id[9] & BIT(0))
 		printf("%s FC: Single Mode (SM)\n", pfx);
 	/* Fibre Channel speed */
-	if (id[10] & (1 << 7))
+	if (id[10] & BIT(7))
 		printf("%s FC: 1200 MBytes/sec\n", pfx);
-	if (id[10] & (1 << 6))
+	if (id[10] & BIT(6))
 		printf("%s FC: 800 MBytes/sec\n", pfx);
-	if (id[10] & (1 << 4))
+	if (id[10] & BIT(4))
 		printf("%s FC: 400 MBytes/sec\n", pfx);
-	if (id[10] & (1 << 2))
+	if (id[10] & BIT(2))
 		printf("%s FC: 200 MBytes/sec\n", pfx);
-	if (id[10] & (1 << 0))
+	if (id[10] & BIT(0))
 		printf("%s FC: 100 MBytes/sec\n", pfx);
 	/* Extended Specification Compliance Codes from SFF-8024 */
 	if (id[36] == 0x1)
@@ -304,7 +304,7 @@ static void sff8079_show_oui(const __u8 *id)
 
 static void sff8079_show_wavelength_or_copper_compliance(const __u8 *id)
 {
-	if (id[8] & (1 << 2)) {
+	if (id[8] & BIT(2)) {
 		printf("\t%-41s : 0x%02x", "Passive Cu cmplnce.", id[60]);
 		switch (id[60]) {
 		case 0x00:
@@ -318,7 +318,7 @@ static void sff8079_show_wavelength_or_copper_compliance(const __u8 *id)
 			break;
 		}
 		printf(" [SFF-8472 rev10.4 only]\n");
-	} else if (id[8] & (1 << 3)) {
+	} else if (id[8] & BIT(3)) {
 		printf("\t%-41s : 0x%02x", "Active Cu cmplnce.", id[60]);
 		switch (id[60]) {
 		case 0x00:
@@ -371,31 +371,31 @@ static void sff8079_show_options(const __u8 *id)
 		"\tOption                                    :";
 
 	printf("\t%-41s : 0x%02x 0x%02x\n", "Option values", id[64], id[65]);
-	if (id[65] & (1 << 1))
+	if (id[65] & BIT(1))
 		printf("%s RX_LOS implemented\n", pfx);
-	if (id[65] & (1 << 2))
+	if (id[65] & BIT(2))
 		printf("%s RX_LOS implemented, inverted\n", pfx);
-	if (id[65] & (1 << 3))
+	if (id[65] & BIT(3))
 		printf("%s TX_FAULT implemented\n", pfx);
-	if (id[65] & (1 << 4))
+	if (id[65] & BIT(4))
 		printf("%s TX_DISABLE implemented\n", pfx);
-	if (id[65] & (1 << 5))
+	if (id[65] & BIT(5))
 		printf("%s RATE_SELECT implemented\n", pfx);
-	if (id[65] & (1 << 6))
+	if (id[65] & BIT(6))
 		printf("%s Tunable transmitter technology\n", pfx);
-	if (id[65] & (1 << 7))
+	if (id[65] & BIT(7))
 		printf("%s Receiver decision threshold implemented\n", pfx);
-	if (id[64] & (1 << 0))
+	if (id[64] & BIT(0))
 		printf("%s Linear receiver output implemented\n", pfx);
-	if (id[64] & (1 << 1))
+	if (id[64] & BIT(1))
 		printf("%s Power level 2 requirement\n", pfx);
-	if (id[64] & (1 << 2))
+	if (id[64] & BIT(2))
 		printf("%s Cooled transceiver implemented\n", pfx);
-	if (id[64] & (1 << 3))
+	if (id[64] & BIT(3))
 		printf("%s Retimer or CDR implemented\n", pfx);
-	if (id[64] & (1 << 4))
+	if (id[64] & BIT(4))
 		printf("%s Paging implemented\n", pfx);
-	if (id[64] & (1 << 5))
+	if (id[64] & BIT(5))
 		printf("%s Power level 3 requirement\n", pfx);
 }
 
@@ -485,7 +485,7 @@ int sff8079_show_all_nl(struct cmd_context *ctx)
 	sff8079_show_all_common(buf);
 
 	/* Finish if A2h page is not present */
-	if (!(buf[92] & (1 << 6)))
+	if (!(buf[92] & BIT(6)))
 		goto out;
 
 	/* Read A2h page */
diff --git a/tse.c b/tse.c
index 8fd2d2304ea8..b21b7c6112c2 100644
--- a/tse.c
+++ b/tse.c
@@ -17,7 +17,7 @@
 int
 bitset(u32 val, int bit)
 {
-	if (val & (1 << bit))
+	if (val & BIT(bit))
 		return 1;
 	return 0;
 }
-- 
2.31.1

