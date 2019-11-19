Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD971022E1
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfKSLSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:18:41 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46309 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKSLSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:18:40 -0500
Received: by mail-pg1-f193.google.com with SMTP id r18so11183753pgu.13
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 03:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=soNolZE06aVFqtb1dxX81iQeJPNXhtjSX5SdpqHrCfY=;
        b=H/reMI1PoBU3hjHbKyGf2VwGKBKEi8o4iwTVxFWWAUIyS4nn3SrRQKnRSPZOHeKcxx
         UOFNt7ltFnE+dxAlwejg+DVqcXvhIWh1fX83K6vAYIzhjVp4I8Zf6ghyalj0kKhNLzMM
         zRvhObHVhnWKwLTEXpzyXNfPpqDLNrU0w0tpchMBDGLakKRfWjBwjfj5/B/MiSyChhu4
         QqKgZG13cL3kJpmxJZqfd+GWe/rpT8clBiKcOMSU31HPYwT4DId+TZyGheM+qy3S9lme
         9rFfCxX6/MMmkdc1MTn16PEOhzU62NyGR6Mcldl7Ht6TOJMs7NiEx4iLs9Y5b5tN0j2Q
         eJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=soNolZE06aVFqtb1dxX81iQeJPNXhtjSX5SdpqHrCfY=;
        b=kwpgdjkSgZZvM25nsz7NZhjutENHfpaDzAWsOh9wFMfyTqvL4eAv3x4HAUKurfCdGq
         7OPNQj8ER0sZvXkWCiedltKmitR39EvbGDblj4RcHFVTP39MQWgV77Q9vCd5Uf9j4qXc
         ubousHiIcwwpBCvaisgMXgzfUlTn5WJncNcClmOrYZQNKdd/C0a5r9qSebepsWNavXvq
         veoj/SmOWPB5ENJ5NoQsoVkeqQaOkD5KTrYG7BXJeqK5SdgE1+VZhuAQc3fowh+Hc9Yg
         fYiIi29C6fulEIKRERAUUUezBcMcupc0s29U3uhACAsG+0CZmbvVKlDdNdIzIAS/bed4
         Scmg==
X-Gm-Message-State: APjAAAXWJJ40P8F5Bc9qDA28UUOLGjnmuvPZx9uFkOfaZyCKQH3WMDkM
        9wI7dQE5gfgPuydeDQnXXA4bPgWXW58=
X-Google-Smtp-Source: APXvYqxItDotvxdI17Vrr7FaUdbrK8BQ7/HT6i3beNkkCwG23dL29mIVUrDd5pnizcNNwXMcSSc/OA==
X-Received: by 2002:a63:b24:: with SMTP id 36mr5158650pgl.30.1574162319603;
        Tue, 19 Nov 2019 03:18:39 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id 6sm25918453pfy.43.2019.11.19.03.18.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Nov 2019 03:18:38 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Kiran Kumar K <kirankumark@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 14/15] octeontx2-af: NPC Tx parsed data key extraction profile
Date:   Tue, 19 Nov 2019 16:47:38 +0530
Message-Id: <1574162259-28181-15-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kiran Kumar K <kirankumark@marvell.com>

This patch enables Tx side parsing by configuring the pkind 63 in
tx_parse_cfg and add default ldata profile for tx.

Unlike Ingress parsing where CHAN field represents the port where the
pkt is received, for a transmitted pkt, NIX HW adds a header which will
have PF_FUNC, SQ idx information, which if extracted to NPC parse key
can be used to do egress side filtering/forwarding.

This patch configures HW to extract this header info into parse key.

Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   6 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 235 ++++++++++++++++-----
 2 files changed, 191 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index f1201e0..07f0f4b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -58,6 +58,8 @@ enum nix_makr_fmt_indexes {
 	NIX_MARK_CFG_MAX,
 };
 
+#define NIX_TX_PKIND   63ULL
+
 /* For now considering MC resources needed for broadcast
  * pkt replication only. i.e 256 HWVFs + 12 PFs.
  */
@@ -1110,6 +1112,10 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	/* Config Rx pkt length, csum checks and apad  enable / disable */
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_CFG(nixlf), req->rx_cfg);
 
+	/* Configure pkind for TX parse config, 63 from npc_profile */
+	cfg = NIX_TX_PKIND;
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf), cfg);
+
 	intf = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
 	err = nix_interface_init(rvu, pcifunc, intf, nixlf);
 	if (err)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index cf61796..d1aab99 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -29,12 +29,33 @@
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
 
 #define NPC_KEX_CHAN_MASK	0xFFFULL
+#define NPC_KEX_PF_FUNC_MASK    0xFFFFULL
 
 static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
 				      int blkaddr, u16 pcifunc);
 static void npc_mcam_free_all_counters(struct rvu *rvu, struct npc_mcam *mcam,
 				       u16 pcifunc);
 
+static int npc_mcam_verify_pf_func(struct rvu *rvu,
+				   struct mcam_entry *entry_data,
+				   u8 intf, u16 pcifunc)
+{
+	u16 pf_func, pf_func_mask;
+
+	if (intf == NIX_INTF_RX)
+		return 0;
+
+	pf_func_mask = (entry_data->kw_mask[0] >> 32) &
+		NPC_KEX_PF_FUNC_MASK;
+	pf_func = (entry_data->kw[0] >> 32) & NPC_KEX_PF_FUNC_MASK;
+
+	pf_func = htons(pf_func);
+	if (pf_func_mask != NPC_KEX_PF_FUNC_MASK || pf_func != pcifunc)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc,
 				   u8 intf, u16 channel)
 {
@@ -720,37 +741,78 @@ void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 			(((bytesm1) << 16) | ((hdr_ofs) << 8) | ((ena) << 7) | \
 			 ((flags_ena) << 6) | ((key_ofs) & 0x3F))
 
-static void npc_config_ldata_extract(struct rvu *rvu, int blkaddr)
+static void npc_config_tx_ldata_extract(struct rvu *rvu, int blkaddr)
 {
-	struct npc_mcam *mcam = &rvu->hw->mcam;
-	int lid, ltype;
-	int lid_count;
 	u64 cfg;
 
-	cfg = rvu_read64(rvu, blkaddr, NPC_AF_CONST);
-	lid_count = (cfg >> 4) & 0xF;
+	/* Default TX MCAM KEX profile */
+	/* Layer A: Ethernet: */
 
-	/* First clear any existing config i.e
-	 * disable LDATA and FLAGS extraction.
-	 */
-	for (lid = 0; lid < lid_count; lid++) {
-		for (ltype = 0; ltype < 16; ltype++) {
-			SET_KEX_LD(NIX_INTF_RX, lid, ltype, 0, 0ULL);
-			SET_KEX_LD(NIX_INTF_RX, lid, ltype, 1, 0ULL);
-			SET_KEX_LD(NIX_INTF_TX, lid, ltype, 0, 0ULL);
-			SET_KEX_LD(NIX_INTF_TX, lid, ltype, 1, 0ULL);
+	/* PF_FUNC: 2B , KW0 [47:32] */
+	cfg = KEX_LD_CFG(0x01, 0x0, 0x1, 0x0, 0x4);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LA, NPC_LT_LA_IH_NIX_ETHER, 0, cfg);
 
-			SET_KEX_LDFLAGS(NIX_INTF_RX, 0, ltype, 0ULL);
-			SET_KEX_LDFLAGS(NIX_INTF_RX, 1, ltype, 0ULL);
-			SET_KEX_LDFLAGS(NIX_INTF_TX, 0, ltype, 0ULL);
-			SET_KEX_LDFLAGS(NIX_INTF_TX, 1, ltype, 0ULL);
-		}
-	}
+	/* PF_FUNC incase of higig2 */
+	cfg = KEX_LD_CFG(0x01, 0x0, 0x1, 0x0, 0x4);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LA, NPC_LT_LA_IH_NIX_HIGIG2_ETHER, 0,
+		   cfg);
 
-	if (mcam->keysize != NPC_MCAM_KEY_X2)
-		return;
+	/* Layer B: Single VLAN (CTAG) */
+	/* CTAG VLAN[2..3] KW0[63:48] */
+	cfg = KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LB, NPC_LT_LB_CTAG, 0, cfg);
+
+	/* CTAG VLAN[2..3] KW1[15:0] */
+	cfg = KEX_LD_CFG(0x01, 0x4, 0x1, 0x0, 0x8);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LB, NPC_LT_LB_CTAG, 1, cfg);
+
+	/* Layer B: Stacked VLAN (STAG|QinQ) */
+	/* Outer VLAN: 2 bytes, KW0[63:48] */
+	cfg = KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 0, cfg);
+
+	/* Outer VLAN: 2 Bytes, KW1[15:0] */
+	cfg = KEX_LD_CFG(0x01, 0x8, 0x1, 0x0, 0x8);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 1, cfg);
+
+	/* DMAC: 6 bytes, KW1[63:16] */
+	cfg = KEX_LD_CFG(0x05, 0x8, 0x1, 0x0, 0xa);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LA, NPC_LT_LA_IH_NIX_ETHER, 1, cfg);
+
+	/* clasification in higig2 header */
+	cfg = KEX_LD_CFG(0x01, 0x10, 0x1, 0x0, 0xa);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LA, NPC_LT_LA_IH_NIX_HIGIG2_ETHER, 1,
+		   cfg);
+
+	/* Layer C: IPv4 */
+	/* SIP+DIP: 8 bytes, KW2[63:0] */
+	cfg = KEX_LD_CFG(0x07, 0xc, 0x1, 0x0, 0x10);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LC, NPC_LT_LC_IP, 0, cfg);
+
+	/* Layer D:UDP */
+	/* SPORT: 2 bytes, KW3[15:0] */
+	cfg = KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LD, NPC_LT_LD_UDP, 0, cfg);
+
+	/* DPORT: 2 bytes, KW3[31:16] */
+	cfg = KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LD, NPC_LT_LD_UDP, 1, cfg);
+
+	/* Layer D:TCP */
+	/* SPORT: 2 bytes, KW3[15:0] */
+	cfg = KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LD, NPC_LT_LD_TCP, 0, cfg);
+
+	/* DPORT: 2 bytes, KW3[31:16] */
+	cfg = KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a);
+	SET_KEX_LD(NIX_INTF_TX, NPC_LID_LD, NPC_LT_LD_TCP, 1, cfg);
+}
+
+static void npc_config_rx_ldata_extract(struct rvu *rvu, int blkaddr)
+{
+	u64 cfg;
 
-	/* Default MCAM KEX profile */
+	/* Default RX MCAM KEX profile */
 	/* Layer A: Ethernet: */
 
 	/* DMAC: 6 bytes, KW1[47:0] */
@@ -761,21 +823,34 @@ static void npc_config_ldata_extract(struct rvu *rvu, int blkaddr)
 	cfg = KEX_LD_CFG(0x01, 0xc, 0x1, 0x0, 0x4);
 	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LA, NPC_LT_LA_ETHER, 1, cfg);
 
+	/* Classification in higig2 header */
+	cfg = KEX_LD_CFG(0x01, 0x8, 0x1, 0x0, NPC_PARSE_RESULT_DMAC_OFFSET);
+	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LA, NPC_LT_LA_HIGIG2_ETHER, 0, cfg);
+
+	/* Vid in higig2 header */
+	cfg = KEX_LD_CFG(0x01, 0xc, 0x1, 0x0, NPC_PARSE_RESULT_DMAC_OFFSET + 2);
+	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LA, NPC_LT_LA_HIGIG2_ETHER, 1, cfg);
+
 	/* Layer B: Single VLAN (CTAG) */
 	/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
-	cfg = KEX_LD_CFG(0x03, 0x0, 0x1, 0x0, 0x4);
+	cfg = KEX_LD_CFG(0x03, 0x2, 0x1, 0x0, 0x4);
 	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LB, NPC_LT_LB_CTAG, 0, cfg);
 
 	/* Layer B: Stacked VLAN (STAG|QinQ) */
-	/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
-	cfg = KEX_LD_CFG(0x03, 0x4, 0x1, 0x0, 0x4);
+	/* Outer VLAN: 2 bytes, KW0[63:48] */
+	cfg = KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6);
 	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 0, cfg);
 
+	/* Ethertype: 2 bytes, KW0[47:32] */
+	cfg = KEX_LD_CFG(0x01, 0x8, 0x1, 0x0, 0x4);
+	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 1, cfg);
+
 	/* Layer C: IPv4 */
 	/* SIP+DIP: 8 bytes, KW2[63:0] */
 	cfg = KEX_LD_CFG(0x07, 0xc, 0x1, 0x0, 0x10);
 	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LC, NPC_LT_LC_IP, 0, cfg);
 	/* TOS: 1 byte, KW1[63:56] */
+
 	cfg = KEX_LD_CFG(0x0, 0x1, 0x1, 0x0, 0xf);
 	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LC, NPC_LT_LC_IP, 1, cfg);
 
@@ -783,6 +858,7 @@ static void npc_config_ldata_extract(struct rvu *rvu, int blkaddr)
 	/* SPORT: 2 bytes, KW3[15:0] */
 	cfg = KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18);
 	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LD, NPC_LT_LD_UDP, 0, cfg);
+
 	/* DPORT: 2 bytes, KW3[31:16] */
 	cfg = KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a);
 	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LD, NPC_LT_LD_UDP, 1, cfg);
@@ -791,11 +867,49 @@ static void npc_config_ldata_extract(struct rvu *rvu, int blkaddr)
 	/* SPORT: 2 bytes, KW3[15:0] */
 	cfg = KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18);
 	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LD, NPC_LT_LD_TCP, 0, cfg);
+
 	/* DPORT: 2 bytes, KW3[31:16] */
 	cfg = KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a);
 	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LD, NPC_LT_LD_TCP, 1, cfg);
 }
 
+static void npc_config_ldata_extract(struct rvu *rvu, int blkaddr)
+{
+	int lid, ltype;
+	int lid_count;
+	u64 cfg;
+
+	cfg = rvu_read64(rvu, blkaddr, NPC_AF_CONST);
+	lid_count = (cfg >> 4) & 0xF;
+
+	/* First clear any existing config i.e
+	 * disable LDATA and FLAGS extraction.
+	 */
+	for (lid = 0; lid < lid_count; lid++) {
+		for (ltype = 0; ltype < 16; ltype++) {
+			SET_KEX_LD(NIX_INTF_RX, lid, ltype, 0, 0ULL);
+			SET_KEX_LD(NIX_INTF_RX, lid, ltype, 1, 0ULL);
+			SET_KEX_LD(NIX_INTF_TX, lid, ltype, 0, 0ULL);
+			SET_KEX_LD(NIX_INTF_TX, lid, ltype, 1, 0ULL);
+
+			SET_KEX_LDFLAGS(NIX_INTF_RX, 0, ltype, 0ULL);
+			SET_KEX_LDFLAGS(NIX_INTF_RX, 1, ltype, 0ULL);
+			SET_KEX_LDFLAGS(NIX_INTF_TX, 0, ltype, 0ULL);
+			SET_KEX_LDFLAGS(NIX_INTF_TX, 1, ltype, 0ULL);
+		}
+	}
+
+	cfg = (rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(0)) >> 32) & 0x07;
+	/* Default profile works with key size NPC_MCAM_KEY_X2 */
+	if (cfg != NPC_MCAM_KEY_X2)
+		return;
+
+	/* Config RX ldata extract */
+	npc_config_rx_ldata_extract(rvu, blkaddr);
+	/* Config TX ldata extract */
+	npc_config_tx_ldata_extract(rvu, blkaddr);
+}
+
 static void npc_program_mkex_profile(struct rvu *rvu, int blkaddr,
 				     struct npc_mcam_kex *mkex)
 {
@@ -837,6 +951,20 @@ static void npc_program_mkex_profile(struct rvu *rvu, int blkaddr,
 	}
 }
 
+static bool is_parse_nibble_config_valid(struct rvu *rvu,
+					 struct npc_mcam_kex *mcam_kex)
+{
+	if (!is_rvu_96xx_B0(rvu))
+		return true;
+
+	/* Due to a HW issue in above silicon versions, parse nibble enable
+	 * configuration has to be identical for both Rx and Tx interfaces.
+	 */
+	if (mcam_kex->keyx_cfg[NIX_INTF_RX] != mcam_kex->keyx_cfg[NIX_INTF_TX])
+		return false;
+	return true;
+}
+
 /* strtoull of "mkexprof" with base:36 */
 #define MKEX_SIGN      0x19bbfdbd15f
 #define MKEX_END_SIGN  0xdeadbeef
@@ -854,8 +982,10 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr)
 	if (!strncmp(mkex_profile, "default", MKEX_NAME_LEN))
 		goto load_default;
 
-	if (cgx_get_mkex_prfl_info(&prfl_addr, &prfl_sz))
+	if (!rvu->fwdata)
 		goto load_default;
+	prfl_addr = rvu->fwdata->mcam_addr;
+	prfl_sz = rvu->fwdata->mcam_sz;
 
 	if (!prfl_addr || !prfl_sz)
 		goto load_default;
@@ -870,13 +1000,7 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr)
 		/* Compare with mkex mod_param name string */
 		if (mcam_kex->mkex_sign == MKEX_SIGN &&
 		    !strncmp(mcam_kex->name, mkex_profile, MKEX_NAME_LEN)) {
-			/* Due to an errata (35786) in A0/B0 pass silicon,
-			 * parse nibble enable configuration has to be
-			 * identical for both Rx and Tx interfaces.
-			 */
-			if (is_rvu_96xx_B0(rvu) &&
-			    mcam_kex->keyx_cfg[NIX_INTF_RX] !=
-			    mcam_kex->keyx_cfg[NIX_INTF_TX])
+			if (!is_parse_nibble_config_valid(rvu, mcam_kex))
 				goto load_default;
 
 			/* Program selected mkex profile */
@@ -1219,36 +1343,36 @@ int rvu_npc_init(struct rvu *rvu)
 
 	/* Enable below for Rx pkts.
 	 * - Outer IPv4 header checksum validation.
-	 * - Detect outer L2 broadcast address and set NPC_RESULT_S[L2M].
+	 * - Detect outer L2 broadcast address and set NPC_RESULT_S[L2B].
+	 * - Detect outer L2 multicast address and set NPC_RESULT_S[L2M].
 	 * - Inner IPv4 header checksum validation.
 	 * - Set non zero checksum error code value
 	 */
 	rvu_write64(rvu, blkaddr, NPC_AF_PCK_CFG,
 		    rvu_read64(rvu, blkaddr, NPC_AF_PCK_CFG) |
-		    BIT_ULL(32) | BIT_ULL(24) | BIT_ULL(6) |
-		    BIT_ULL(2) | BIT_ULL(1));
+		    ((u64)NPC_EC_OIP4_CSUM << 32) | (NPC_EC_IIP4_CSUM << 24) |
+		    BIT_ULL(7) | BIT_ULL(6) | BIT_ULL(2) | BIT_ULL(1));
 
 	/* Set RX and TX side MCAM search key size.
-	 * LA..LD (ltype only) + Channel
+	 * LA..LE (ltype only) + Channel
 	 */
-	nibble_ena = 0x49247;
+	nibble_ena = 0x249207;
 	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX),
 			((keyz & 0x3) << 32) | nibble_ena);
-	/* Due to an errata (35786) in A0 pass silicon, parse nibble enable
-	 * configuration has to be identical for both Rx and Tx interfaces.
-	 */
+
+	/* Extract Ltypes LID_LA to LID_LE */
 	if (!is_rvu_96xx_B0(rvu))
-		nibble_ena = (1ULL << 19) - 1;
+		nibble_ena = 0x249200;
 	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_TX),
 			((keyz & 0x3) << 32) | nibble_ena);
 
+	/* Configure MKEX profile */
+	npc_load_mkex_profile(rvu, blkaddr);
+
 	err = npc_mcam_rsrcs_init(rvu, blkaddr);
 	if (err)
 		return err;
 
-	/* Configure MKEX profile */
-	npc_load_mkex_profile(rvu, blkaddr);
-
 	/* Set TX miss action to UCAST_DEFAULT i.e
 	 * transmit the packet on NIX LF SQ's default channel.
 	 */
@@ -1262,7 +1386,6 @@ int rvu_npc_init(struct rvu *rvu)
 		    NIX_RX_ACTIONOP_DROP);
 	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_MISS_STAT_ACT(NIX_INTF_RX),
 		    BIT_ULL(9) | mcam->rx_miss_act_cntr);
-
 	return 0;
 }
 
@@ -1869,6 +1992,12 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 		goto exit;
 	}
 
+	if (npc_mcam_verify_pf_func(rvu, &req->entry_data, req->intf,
+				    pcifunc)) {
+		rc = NPC_MCAM_INVALID_REQ;
+		goto exit;
+	}
+
 	npc_config_mcam_entry(rvu, mcam, blkaddr, req->entry, req->intf,
 			      &req->entry_data, req->enable_entry);
 
@@ -2091,10 +2220,11 @@ int rvu_mbox_handler_npc_mcam_free_counter(struct rvu *rvu,
 		index = find_next_bit(mcam->bmap, mcam->bmap_entries, entry);
 		if (index >= mcam->bmap_entries)
 			break;
+		entry = index + 1;
+
 		if (mcam->entry2cntr_map[index] != req->cntr)
 			continue;
 
-		entry = index + 1;
 		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr,
 					      index, req->cntr);
 	}
@@ -2137,10 +2267,11 @@ int rvu_mbox_handler_npc_mcam_unmap_counter(struct rvu *rvu,
 		index = find_next_bit(mcam->bmap, mcam->bmap_entries, entry);
 		if (index >= mcam->bmap_entries)
 			break;
+		entry = index + 1;
+
 		if (mcam->entry2cntr_map[index] != req->cntr)
 			continue;
 
-		entry = index + 1;
 		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr,
 					      index, req->cntr);
 	}
@@ -2221,6 +2352,10 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 	if (npc_mcam_verify_channel(rvu, req->hdr.pcifunc, req->intf, channel))
 		return NPC_MCAM_INVALID_REQ;
 
+	if (npc_mcam_verify_pf_func(rvu, &req->entry_data, req->intf,
+				    req->hdr.pcifunc))
+		return NPC_MCAM_INVALID_REQ;
+
 	/* Try to allocate a MCAM entry */
 	entry_req.hdr.pcifunc = req->hdr.pcifunc;
 	entry_req.contig = true;
-- 
2.7.4

