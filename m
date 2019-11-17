Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635EFFFAB4
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKQQPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:15:34 -0500
Received: from mail-pl1-f172.google.com ([209.85.214.172]:39509 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfKQQPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:15:33 -0500
Received: by mail-pl1-f172.google.com with SMTP id o9so8230753plk.6
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 08:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xbkb3sjQh44diWrxBhoAJCvqY/2FeEpF4EuKqFNRd6w=;
        b=QVs1ZcOVHIxQ2pffxoZyglFPaFKM+hfpq39OQzq4EtPoevG8oKasTOiPh5gu93LDZ8
         oSJKhR5yxMctH2aGpbuU62kWB5DyrOyLpqB3ZaxNSgW8x7WoTHcIy7WdbvmhuSBZz+mL
         32WW+2Vid/SK8+4kKH/ChZMLtLJquJyGIajchaH2TyHW7rIihbLXKYOjzcZzPG0VzjKy
         yjimQw4SezoAr9/Opdyhqh/ho8CtFEQmAslIRgKzeMujtmOvjxvV5vWkMrZTkLivCfo9
         fbbIw1B8bYlFEGLbXwrXcLKQ/Fi54vM112aFJEW3Kp9JAf+fqNFHbPsN1uq9dMqIBRIC
         mN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xbkb3sjQh44diWrxBhoAJCvqY/2FeEpF4EuKqFNRd6w=;
        b=sTa/zrgVupNYszf7h1rQ/qZPHYNsMdxcYwxMHT2QRilnoA8yBcDrwLjbD3Ipf4dpl8
         ujdzDlqev/8dV6iVOYxLE3Odcoy+2sowqMOuFLNA/M0ikk0p+af1hr82Wbxyso0Lbco2
         wup3y2zmrMrv/KWsWItRnJU7qN2w/qdX89BST+fqczuzlf8oPxn+WBwE0wH+J1FAcr19
         RirVCMrD00fyP48Y5M9h9NGpeqilezbC/2DjOj8VI6Xthqrs44ye03Y1Un1vh199roLq
         teSiu0Rr/oFLBpJxR4oZsZYWrOpHCNPgNyfG5akJW2wYusnMaDe6M8V6NDnf6C9Pd3xa
         jecw==
X-Gm-Message-State: APjAAAX9YFhRDCaJSuT2e6yw8Hwml+1mlkWTA9nSx0TWFn5Ot4XLlE6l
        Bq0WvPwX/uPC30C0Oz+2WZNA+/HMTLE=
X-Google-Smtp-Source: APXvYqzqmpyugBJUnyZS7ekG5Ibyvl7uIPtqqEmmvhpalHXFJ1ax6rkFEklTJBK902xTMLdYluK4bQ==
X-Received: by 2002:a17:90a:37e4:: with SMTP id v91mr34231636pjb.8.1574007332317;
        Sun, 17 Nov 2019 08:15:32 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v2sm2675231pgi.79.2019.11.17.08.15.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Nov 2019 08:15:31 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Andrew Pinski <apinski@marvell.com>,
        Pavan Nikhilesh <pbhagavatula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 12/15] octeontx2-af: Add TIM unit support.
Date:   Sun, 17 Nov 2019 21:44:23 +0530
Message-Id: <1574007266-17123-13-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Pinski <apinski@marvell.com>

Add TIM (Timer) unit support to AF driver that involves initializing
and configuring TIM and its rings through mailbox. This block
helps software to schedule SSO work entries for a future time.

Signed-off-by: Andrew Pinski <apinski@marvell.com>
Co-developed-by: Pavan Nikhilesh <pbhagavatula@marvell.com>
Signed-off-by: Pavan Nikhilesh <pbhagavatula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  80 +++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  12 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  12 +
 .../net/ethernet/marvell/octeontx2/af/rvu_tim.c    | 341 +++++++++++++++++++++
 6 files changed, 448 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_tim.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 5988d58..9c80d8c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -8,4 +8,5 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 
 octeontx2_mbox-y := mbox.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
-		  rvu_reg.o rvu_npc.o rvu_debugfs.o rvu_sso.o
+		  rvu_reg.o rvu_npc.o rvu_debugfs.o rvu_sso.o \
+		  rvu_tim.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 5d199e3..0822fca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -171,6 +171,12 @@ M(SSO_GRP_QOS_CONFIG,	0x608, sso_grp_qos_config, sso_grp_qos_cfg, msg_rsp)\
 M(SSO_GRP_GET_STATS,	0x609, sso_grp_get_stats, sso_info_req, sso_grp_stats)\
 M(SSO_HWS_GET_STATS,	0x610, sso_hws_get_stats, sso_info_req, sso_hws_stats)\
 /* TIM mbox IDs (range 0x800 - 0x9FF) */				\
+M(TIM_LF_ALLOC,		0x800, tim_lf_alloc,				\
+				tim_lf_alloc_req, tim_lf_alloc_rsp)	\
+M(TIM_LF_FREE,		0x801, tim_lf_free, tim_ring_req, msg_rsp)	\
+M(TIM_CONFIG_RING,	0x802, tim_config_ring, tim_config_req, msg_rsp)\
+M(TIM_ENABLE_RING,	0x803, tim_enable_ring, tim_ring_req, tim_enable_rsp)\
+M(TIM_DISABLE_RING,	0x804, tim_disable_ring, tim_ring_req, msg_rsp)	\
 /* CPT mbox IDs (range 0xA00 - 0xBFF) */				\
 /* NPC mbox IDs (range 0x6000 - 0x7FFF) */				\
 M(NPC_MCAM_ALLOC_ENTRY,	0x6000, npc_mcam_alloc_entry, npc_mcam_alloc_entry_req,\
@@ -978,4 +984,78 @@ struct npc_get_kex_cfg_rsp {
 	u8 mkex_pfl_name[MKEX_NAME_LEN];
 };
 
+/* TIM mailbox error codes
+ * Range 801 - 900.
+ */
+enum tim_af_status {
+	TIM_AF_NO_RINGS_LEFT			= -801,
+	TIM_AF_INVAL_NPA_PF_FUNC		= -802,
+	TIM_AF_INVAL_SSO_PF_FUNC		= -803,
+	TIM_AF_RING_STILL_RUNNING		= -804,
+	TIM_AF_LF_INVALID			= -805,
+	TIM_AF_CSIZE_NOT_ALIGNED		= -806,
+	TIM_AF_CSIZE_TOO_SMALL			= -807,
+	TIM_AF_CSIZE_TOO_BIG			= -808,
+	TIM_AF_INTERVAL_TOO_SMALL		= -809,
+	TIM_AF_INVALID_BIG_ENDIAN_VALUE		= -810,
+	TIM_AF_INVALID_CLOCK_SOURCE		= -811,
+	TIM_AF_GPIO_CLK_SRC_NOT_ENABLED		= -812,
+	TIM_AF_INVALID_BSIZE			= -813,
+	TIM_AF_INVALID_ENABLE_PERIODIC		= -814,
+	TIM_AF_INVALID_ENABLE_DONTFREE		= -815,
+	TIM_AF_ENA_DONTFRE_NSET_PERIODIC	= -816,
+	TIM_AF_RING_ALREADY_DISABLED		= -817,
+};
+
+enum tim_clk_srcs {
+	TIM_CLK_SRCS_TENNS	= 0,
+	TIM_CLK_SRCS_GPIO	= 1,
+	TIM_CLK_SRCS_GTI	= 2,
+	TIM_CLK_SRCS_PTP	= 3,
+	TIM_CLK_SRSC_INVALID,
+};
+
+enum tim_gpio_edge {
+	TIM_GPIO_NO_EDGE		= 0,
+	TIM_GPIO_LTOH_TRANS		= 1,
+	TIM_GPIO_HTOL_TRANS		= 2,
+	TIM_GPIO_BOTH_TRANS		= 3,
+	TIM_GPIO_INVALID,
+};
+
+struct tim_lf_alloc_req {
+	struct mbox_msghdr hdr;
+	u16	ring;
+	u16	npa_pf_func;
+	u16	sso_pf_func;
+};
+
+struct tim_ring_req {
+	struct mbox_msghdr hdr;
+	u16	ring;
+};
+
+struct tim_config_req {
+	struct mbox_msghdr hdr;
+	u16	ring;
+	u8	bigendian;
+	u8	clocksource;
+	u8	enableperiodic;
+	u8	enabledontfreebuffer;
+	u32	bucketsize;
+	u32	chunksize;
+	u32	interval;
+};
+
+struct tim_lf_alloc_rsp {
+	struct mbox_msghdr hdr;
+	u64 tenns_clk;
+};
+
+struct tim_enable_rsp {
+	struct mbox_msghdr hdr;
+	u64	timestarted;
+	u32	currentbucket;
+};
+
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 441be60..6d07152 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -958,6 +958,10 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	if (err)
 		goto cgx_err;
 
+	err = rvu_tim_init(rvu);
+	if (err)
+		goto cgx_err;
+
 	return 0;
 
 cgx_err:
@@ -1326,12 +1330,12 @@ int rvu_mbox_handler_attach_resources(struct rvu *rvu,
 		goto exit;
 
 	/* Now attach the requested resources */
-	if (attach->npalf)
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_NPA, 1);
-
 	if (attach->nixlf)
 		rvu_attach_block(rvu, pcifunc, BLKTYPE_NIX, 1);
 
+	if (attach->npalf)
+		rvu_attach_block(rvu, pcifunc, BLKTYPE_NPA, 1);
+
 	if (attach->sso) {
 		/* RVU func doesn't know which exact LF or slot is attached
 		 * to it, it always sees as slot 0,1,2. So for a 'modify'
@@ -1941,6 +1945,8 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 			rvu_sso_lf_teardown(rvu, pcifunc, lf, slot);
 		else if (block->addr == BLKADDR_SSOW)
 			rvu_ssow_lf_teardown(rvu, pcifunc, lf, slot);
+		else if (block->addr == BLKADDR_TIM)
+			rvu_tim_lf_teardown(rvu, pcifunc, lf, slot);
 
 		err = rvu_lf_reset(rvu, block, lf);
 		if (err) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 595dfa7..3fc3b98 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -524,6 +524,10 @@ void rvu_npc_get_mcam_counter_alloc_info(struct rvu *rvu, u16 pcifunc,
 					 int blkaddr, int *alloc_cnt,
 					 int *enable_cnt);
 
+/* TIM APIs */
+int rvu_tim_init(struct rvu *rvu);
+int rvu_tim_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
+
 #ifdef CONFIG_DEBUG_FS
 void rvu_dbg_init(struct rvu *rvu);
 void rvu_dbg_exit(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 1aa3129..6b23e6a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -596,6 +596,18 @@
 #define TIM_AF_RVU_LF_CFG_DEBUG		(0x30000)
 #define TIM_AF_BLK_RST			(0x10)
 #define TIM_AF_LF_RST			(0x20)
+#define TIM_AF_BLK_RST			(0x10)
+#define TIM_AF_RINGX_GMCTL(a)		(0x2000 | (a) << 3)
+#define TIM_AF_RINGX_CTL0(a)		(0x4000 | (a) << 3)
+#define TIM_AF_RINGX_CTL1(a)		(0x6000 | (a) << 3)
+#define TIM_AF_RINGX_CTL2(a)		(0x8000 | (a) << 3)
+#define TIM_AF_FLAGS_REG		(0x80)
+#define TIM_AF_FLAGS_REG_ENA_TIM	BIT_ULL(0)
+#define TIM_AF_RINGX_CTL1_ENA		BIT_ULL(47)
+#define TIM_AF_RINGX_CTL1_RCF_BUSY	BIT_ULL(50)
+
+#define TIM_AF_RING_GMCTL_SHIFT		3
+#define TIM_AF_RING_SSO_PF_FUNC_SHIFT	0
 
 /* CPT */
 #define CPT_AF_CONSTANTS0		(0x0000)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_tim.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_tim.c
new file mode 100644
index 0000000..f5a86b4
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_tim.c
@@ -0,0 +1,341 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Admin Function driver
+ *
+ * Copyright (C) 2019 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/types.h>
+
+#include "rvu_struct.h"
+#include "rvu_reg.h"
+#include "rvu.h"
+
+#define TIM_CHUNKSIZE_MULTIPLE	(16)
+#define TIM_CHUNKSIZE_MIN	(TIM_CHUNKSIZE_MULTIPLE * 0x2)
+#define TIM_CHUNKSIZE_MAX	(TIM_CHUNKSIZE_MULTIPLE * 0x1FFF)
+
+static u64 get_tenns_tsc(void)
+{
+	u64 tsc = 0;
+
+#if defined(CONFIG_ARM64)
+	asm volatile("mrs %0, cntvct_el0" : "=r" (tsc));
+#endif
+	return tsc;
+}
+
+static u64 get_tenns_clk(void)
+{
+	u64 tsc = 0;
+
+#if defined(CONFIG_ARM64)
+	asm volatile("mrs %0, cntfrq_el0" : "=r" (tsc));
+#endif
+	return tsc;
+}
+
+static int rvu_tim_disable_lf(struct rvu *rvu, int lf, int blkaddr)
+{
+	u64 regval;
+
+	regval = rvu_read64(rvu, blkaddr, TIM_AF_RINGX_CTL1(lf));
+	if ((regval & TIM_AF_RINGX_CTL1_ENA) == 0)
+		return TIM_AF_RING_ALREADY_DISABLED;
+
+	/* Clear TIM_AF_RING(0..255)_CTL1[ENA]. */
+	regval = rvu_read64(rvu, blkaddr, TIM_AF_RINGX_CTL1(lf));
+	regval &= ~TIM_AF_RINGX_CTL1_ENA;
+	rvu_write64(rvu, blkaddr, TIM_AF_RINGX_CTL1(lf), regval);
+
+	/* Poll until the corresponding ring’s
+	 * TIM_AF_RING(0..255)_CTL1[RCF_BUSY] is clear.
+	 */
+	rvu_poll_reg(rvu, blkaddr, TIM_AF_RINGX_CTL1(lf),
+		     TIM_AF_RINGX_CTL1_RCF_BUSY, true);
+	return 0;
+}
+
+int rvu_mbox_handler_tim_lf_alloc(struct rvu *rvu,
+				  struct tim_lf_alloc_req *req,
+				  struct tim_lf_alloc_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int lf, blkaddr;
+	u64 regval;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_TIM, pcifunc);
+	if (blkaddr < 0)
+		return TIM_AF_LF_INVALID;
+
+	lf = rvu_get_lf(rvu, &rvu->hw->block[blkaddr], pcifunc, req->ring);
+	if (lf < 0)
+		return TIM_AF_LF_INVALID;
+
+	/* Check if requested 'TIMLF <=> NPALF' mapping is valid */
+	if (req->npa_pf_func) {
+		/* If default, use 'this' TIMLF's PFFUNC */
+		if (req->npa_pf_func == RVU_DEFAULT_PF_FUNC)
+			req->npa_pf_func = pcifunc;
+		if (!is_pffunc_map_valid(rvu, req->npa_pf_func, BLKTYPE_NPA))
+			return TIM_AF_INVAL_NPA_PF_FUNC;
+	}
+
+	/* Check if requested 'TIMLF <=> SSOLF' mapping is valid */
+	if (req->sso_pf_func) {
+		/* If default, use 'this' SSOLF's PFFUNC */
+		if (req->sso_pf_func == RVU_DEFAULT_PF_FUNC)
+			req->sso_pf_func = pcifunc;
+		if (!is_pffunc_map_valid(rvu, req->sso_pf_func, BLKTYPE_SSO))
+			return TIM_AF_INVAL_SSO_PF_FUNC;
+	}
+
+	regval = (((u64)req->npa_pf_func) << 16) |
+		 ((u64)req->sso_pf_func);
+	rvu_write64(rvu, blkaddr, TIM_AF_RINGX_GMCTL(lf), regval);
+
+	rsp->tenns_clk = get_tenns_clk();
+
+	return 0;
+}
+
+int rvu_mbox_handler_tim_lf_free(struct rvu *rvu,
+				 struct tim_ring_req *req,
+				 struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int lf, blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_TIM, pcifunc);
+	if (blkaddr < 0)
+		return TIM_AF_LF_INVALID;
+
+	lf = rvu_get_lf(rvu, &rvu->hw->block[blkaddr], pcifunc, req->ring);
+	if (lf < 0)
+		return TIM_AF_LF_INVALID;
+
+	rvu_tim_lf_teardown(rvu, pcifunc, lf, req->ring);
+
+	return 0;
+}
+
+int rvu_mbox_handler_tim_config_ring(struct rvu *rvu,
+				     struct tim_config_req *req,
+				     struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int lf, blkaddr;
+	u32 intervalmin;
+	u64 regval;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_TIM, pcifunc);
+	if (blkaddr < 0)
+		return TIM_AF_LF_INVALID;
+
+	lf = rvu_get_lf(rvu, &rvu->hw->block[blkaddr], pcifunc, req->ring);
+	if (lf < 0)
+		return TIM_AF_LF_INVALID;
+
+	/* Check the inputs. */
+	/* bigendian can only be 1 or 0. */
+	if (req->bigendian & ~1)
+		return TIM_AF_INVALID_BIG_ENDIAN_VALUE;
+
+	/* Check GPIO clock source has the GPIO edge set. */
+	if (req->clocksource == TIM_CLK_SRCS_GPIO) {
+		regval = rvu_read64(rvu, blkaddr, TIM_AF_FLAGS_REG);
+		if (((regval >> 5) & 0x3) == 0)
+			return TIM_AF_GPIO_CLK_SRC_NOT_ENABLED;
+	}
+
+	/* enableperiodic can only be 1 or 0. */
+	if (req->enableperiodic & ~1)
+		return TIM_AF_INVALID_ENABLE_PERIODIC;
+
+	/* enabledontfreebuffer can only be 1 or 0. */
+	if (req->enabledontfreebuffer & ~1)
+		return TIM_AF_INVALID_ENABLE_DONTFREE;
+
+	/* enabledontfreebuffer needs to be true if enableperiodic
+	 * is enabled.
+	 */
+	if (req->enableperiodic && !req->enabledontfreebuffer)
+		return TIM_AF_ENA_DONTFRE_NSET_PERIODIC;
+
+	/* bucketsize needs to between 2 and 2M (1<<20). */
+	if (req->bucketsize < 2 || req->bucketsize > 1 << 20)
+		return TIM_AF_INVALID_BSIZE;
+
+	if (req->chunksize % TIM_CHUNKSIZE_MULTIPLE)
+		return TIM_AF_CSIZE_NOT_ALIGNED;
+
+	if (req->chunksize < TIM_CHUNKSIZE_MIN)
+		return TIM_AF_CSIZE_TOO_SMALL;
+
+	if (req->chunksize > TIM_CHUNKSIZE_MAX)
+		return TIM_AF_CSIZE_TOO_BIG;
+
+	switch (req->clocksource) {
+	case TIM_CLK_SRCS_TENNS:
+		intervalmin = 256;
+		break;
+	case TIM_CLK_SRCS_GPIO:
+		intervalmin = 256;
+		break;
+	case TIM_CLK_SRCS_GTI:
+	case TIM_CLK_SRCS_PTP:
+		intervalmin = 300;
+		break;
+	default:
+		return TIM_AF_INVALID_CLOCK_SOURCE;
+	}
+
+	if (req->interval < intervalmin)
+		return TIM_AF_INTERVAL_TOO_SMALL;
+
+	/* CTL0 */
+	/* EXPIRE_OFFSET = 0 and is set correctly when enabling. */
+	regval = req->interval;
+	rvu_write64(rvu, blkaddr, TIM_AF_RINGX_CTL0(lf), regval);
+
+	/* CTL1 */
+	regval = (((u64)req->bigendian) << 53) |
+		 (((u64)req->clocksource) << 51) |
+		 (1ull << 48) | /* LOCK_EN */
+		 (((u64)req->enableperiodic) << 45) |
+		 (((u64)(req->enableperiodic ^ 1)) << 44) | /* ENA_LDWB */
+		 (((u64)req->enabledontfreebuffer) << 43) |
+		 (u64)(req->bucketsize - 1);
+	rvu_write64(rvu, blkaddr, TIM_AF_RINGX_CTL1(lf), regval);
+
+	/* CTL2 */
+	regval = ((u64)req->chunksize / TIM_CHUNKSIZE_MULTIPLE) << 40;
+	rvu_write64(rvu, blkaddr, TIM_AF_RINGX_CTL2(lf), regval);
+
+	return 0;
+}
+
+int rvu_mbox_handler_tim_enable_ring(struct rvu *rvu,
+				     struct tim_ring_req *req,
+				     struct tim_enable_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int lf, blkaddr;
+	u64 regval;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_TIM, pcifunc);
+	if (blkaddr < 0)
+		return TIM_AF_LF_INVALID;
+
+	lf = rvu_get_lf(rvu, &rvu->hw->block[blkaddr], pcifunc, req->ring);
+	if (lf < 0)
+		return TIM_AF_LF_INVALID;
+
+	/* Error out if the ring is already running. */
+	regval = rvu_read64(rvu, blkaddr, TIM_AF_RINGX_CTL1(lf));
+	if (regval & TIM_AF_RINGX_CTL1_ENA)
+		return TIM_AF_RING_STILL_RUNNING;
+
+	/* Enable, the ring. */
+	regval = rvu_read64(rvu, blkaddr, TIM_AF_RINGX_CTL1(lf));
+	regval |= TIM_AF_RINGX_CTL1_ENA;
+	rvu_write64(rvu, blkaddr, TIM_AF_RINGX_CTL1(lf), regval);
+
+	rsp->timestarted = get_tenns_tsc();
+	rsp->currentbucket = (regval >> 20) & 0xfffff;
+
+	return 0;
+}
+
+int rvu_mbox_handler_tim_disable_ring(struct rvu *rvu,
+				      struct tim_ring_req *req,
+				      struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int lf, blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_TIM, pcifunc);
+	if (blkaddr < 0)
+		return TIM_AF_LF_INVALID;
+
+	lf = rvu_get_lf(rvu, &rvu->hw->block[blkaddr], pcifunc, req->ring);
+	if (lf < 0)
+		return TIM_AF_LF_INVALID;
+
+	return rvu_tim_disable_lf(rvu, lf, blkaddr);
+}
+
+int rvu_tim_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot)
+{
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_TIM, pcifunc);
+	if (blkaddr < 0)
+		return TIM_AF_LF_INVALID;
+
+	/* Ensure TIM ring is disabled prior to clearing the mapping */
+	rvu_tim_disable_lf(rvu, lf, blkaddr);
+
+	rvu_write64(rvu, blkaddr, TIM_AF_RINGX_GMCTL(lf), 0);
+
+	return 0;
+}
+
+#define FOR_EACH_TIM_LF(lf)	\
+for (lf = 0; lf < hw->block[BLKTYPE_TIM].lf.max; lf++)
+
+int rvu_tim_init(struct rvu *rvu)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	int lf, blkaddr;
+	u8 gpio_edge;
+	u64 regval;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_TIM, 0);
+	if (blkaddr < 0)
+		return 0;
+
+	regval = rvu_read64(rvu, blkaddr, TIM_AF_FLAGS_REG);
+
+	/* Disable the TIM block, if not already disabled. */
+	if (regval & TIM_AF_FLAGS_REG_ENA_TIM) {
+		/* Disable each ring(lf). */
+		FOR_EACH_TIM_LF(lf) {
+			regval = rvu_read64(rvu, blkaddr,
+					    TIM_AF_RINGX_CTL1(lf));
+			if (!(regval & TIM_AF_RINGX_CTL1_ENA))
+				continue;
+
+			rvu_tim_disable_lf(rvu, lf, blkaddr);
+		}
+
+		/* Disable the TIM block. */
+		regval = rvu_read64(rvu, blkaddr, TIM_AF_FLAGS_REG);
+		regval &= ~TIM_AF_FLAGS_REG_ENA_TIM;
+		rvu_write64(rvu, blkaddr, TIM_AF_FLAGS_REG, regval);
+	}
+
+	/* Reset each LF. */
+	FOR_EACH_TIM_LF(lf) {
+		rvu_lf_reset(rvu, &hw->block[BLKTYPE_TIM], lf);
+	}
+
+	/* Reset the TIM block; getting a clean slate. */
+	rvu_write64(rvu, blkaddr, TIM_AF_BLK_RST, 0x1);
+	rvu_poll_reg(rvu, blkaddr, TIM_AF_BLK_RST, BIT_ULL(63), true);
+
+	gpio_edge = TIM_GPIO_NO_EDGE;
+
+	/* Enable TIM block. */
+	regval = (((u64)gpio_edge) << 6) |
+		 BIT_ULL(2) | /* RESET */
+		 BIT_ULL(0); /* ENA_TIM */
+	rvu_write64(rvu, blkaddr, TIM_AF_FLAGS_REG, regval);
+
+	return 0;
+}
-- 
2.7.4

