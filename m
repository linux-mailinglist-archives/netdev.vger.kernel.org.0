Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0926FBFA6
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfKNF2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:28:02 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45619 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfKNF2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:28:01 -0500
Received: by mail-pg1-f193.google.com with SMTP id k1so1629695pgg.12
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O1335/k8TL9oBmH/f/FEU5cth7kDLPRUOOIwc/+8nHk=;
        b=O7jycZDuVduborW9J5RANmYsSdQ3sVUDJWqrc8UgiuKBGLtcJGnI57zNFcbkh/cY0S
         iXnA3u4z1dKJ7kc7E36TaDNqqk9trs04YVUo6Qd7Tvsv3A4/dQWXsh/TiPcXzLAE/+jG
         Ff+zBWE0pbIzpIOm5ts6c3RptFNsThq40gh7rk7ktGwGdxuKfrmMnbv0zRSxKfu/j/rO
         kchB05QppOcuCIoB1dkAhh3jCU6vbdU6ZC7aJVagf0H62aD1pojtnwZiUVz7bpkDvFxA
         nUWzEwSROZpmKY4SAVt8l8E/zUG4qeUHlBRpopQf/Ku81Pl4tOfPjfT5g00xTGKEBw7S
         9nMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O1335/k8TL9oBmH/f/FEU5cth7kDLPRUOOIwc/+8nHk=;
        b=QqNI+9oDE1RSKbt+22sM7W+pu0ERwJYS8ZZTamFv4b4GeBgGV1pX6bqtECvyUAbcr4
         BRcYwnyialv78wCdWa6LQ7c372dljlV2wCRrozN3ueXyCw/dfph5vOcq69EXUHYZnNUR
         8YB1Rqt1e676iErCdyynmP1tYon0Lc7VEbyn2WB/QKR9FL+oAYClrUi6n/2RWiXosJ68
         /cFog/VTrviP9u6eCr2S9VhSuMN7cCZYfmhg40zO+j1UFZwUHzTcSB2rwvH5MXd1Uyp0
         BiT4QKRjnE6OoRTt7DQxvkgvDVaIkmaXhjdJlvdiPq0NchZDDpou/xORG9ouiRhnqpNL
         r0rQ==
X-Gm-Message-State: APjAAAX09uT7GVF3HYdkhS+8Rt2rX+jovQoNqLxKx3Pmsd39ntEcHALa
        /G+tpt/jDYJSvR7Yb3Szwji9/adAYTg=
X-Google-Smtp-Source: APXvYqxGEImu8I+5leLQuJHl7NeFxE+qv6D6YkzvVpL/z4wI+D32J9Sea73bEJW7R5BB3f+2id3zHA==
X-Received: by 2002:a17:90a:1b4d:: with SMTP id q71mr10113791pjq.120.1573709278636;
        Wed, 13 Nov 2019 21:27:58 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.27.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:27:57 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 15/18] octeontx2-af: Enable broadcast packet replication
Date:   Thu, 14 Nov 2019 10:56:30 +0530
Message-Id: <1573709193-15446-16-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Ingress packet replication support has been added to 96xx B0
silicon. This patch enables using that feature to replicate
ingress broadcast packets to PF and it's VFs.

Also fixed below issues
- VFs can also install NPC MCAM entry to forward broadcast pkts.
  Otherwise, unless PF's interface is UP, VFs will not receive
  bcast packets.
- NPC MCAM entry is disabled when PF and all it's VFs are down.
- Few corner cases in installing multicast entry list.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  3 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 36 +++++----
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 87 ++++++++++++----------
 4 files changed, 69 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index bf9272f..3985053 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -64,6 +64,7 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
 	hw->cap.nix_fixed_txschq_mapping = false;
 	hw->cap.nix_shaping = true;
 	hw->cap.nix_tx_link_bp = true;
+	hw->cap.nix_rx_multicast = true;
 
 	if (is_rvu_96xx_B0(rvu)) {
 		hw->cap.nix_fixed_txschq_mapping = true;
@@ -72,6 +73,8 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
 		hw->cap.nix_txsch_per_sdp_lmac = 76;
 		hw->cap.nix_shaping = false;
 		hw->cap.nix_tx_link_bp = false;
+		if (is_rvu_96xx_A0(rvu))
+			hw->cap.nix_rx_multicast = false;
 	}
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 000d02b..7370864 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -235,6 +235,7 @@ struct hw_cap {
 	bool	nix_fixed_txschq_mapping; /* Schq mapping fixed or flexible */
 	bool	nix_shaping;		 /* Is shaping and coloring supported */
 	bool	nix_tx_link_bp;		 /* Can link backpressure TL queues ? */
+	bool	nix_rx_multicast;	 /* Rx packet replication support */
 };
 
 struct rvu_hwinfo {
@@ -441,6 +442,7 @@ void rvu_npc_disable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_enable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 				       int nixlf, u64 chan);
+void rvu_npc_disable_bcast_entry(struct rvu *rvu, u16 pcifunc);
 int rvu_npc_update_rxvlan(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 3b32e91..4519d80 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -64,7 +64,6 @@ enum nix_makr_fmt_indexes {
 
 struct mce {
 	struct hlist_node	node;
-	u16			idx;
 	u16			pcifunc;
 };
 
@@ -1754,7 +1753,7 @@ static int nix_setup_mce(struct rvu *rvu, int mce, u8 op,
 }
 
 static int nix_update_mce_list(struct nix_mce_list *mce_list,
-			       u16 pcifunc, int idx, bool add)
+			       u16 pcifunc, bool add)
 {
 	struct mce *mce, *tail = NULL;
 	bool delete = false;
@@ -1783,7 +1782,6 @@ static int nix_update_mce_list(struct nix_mce_list *mce_list,
 	mce = kzalloc(sizeof(*mce), GFP_KERNEL);
 	if (!mce)
 		return -ENOMEM;
-	mce->idx = idx;
 	mce->pcifunc = pcifunc;
 	if (!tail)
 		hlist_add_head(&mce->node, &mce_list->head);
@@ -1795,12 +1793,12 @@ static int nix_update_mce_list(struct nix_mce_list *mce_list,
 
 static int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
 {
-	int err = 0, idx, next_idx, count;
+	int err = 0, idx, next_idx, last_idx;
 	struct nix_mce_list *mce_list;
-	struct mce *mce, *next_mce;
 	struct nix_mcast *mcast;
 	struct nix_hw *nix_hw;
 	struct rvu_pfvf *pfvf;
+	struct mce *mce;
 	int blkaddr;
 
 	/* Broadcast pkt replication is not needed for AF's VFs, hence skip */
@@ -1832,31 +1830,31 @@ static int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
 
 	mutex_lock(&mcast->mce_lock);
 
-	err = nix_update_mce_list(mce_list, pcifunc, idx, add);
+	err = nix_update_mce_list(mce_list, pcifunc, add);
 	if (err)
 		goto end;
 
 	/* Disable MCAM entry in NPC */
-
-	if (!mce_list->count)
+	if (!mce_list->count) {
+		rvu_npc_disable_bcast_entry(rvu, pcifunc);
 		goto end;
-	count = mce_list->count;
+	}
 
 	/* Dump the updated list to HW */
+	idx = pfvf->bcast_mce_idx;
+	last_idx = idx + mce_list->count - 1;
 	hlist_for_each_entry(mce, &mce_list->head, node) {
-		next_idx = 0;
-		count--;
-		if (count) {
-			next_mce = hlist_entry(mce->node.next,
-					       struct mce, node);
-			next_idx = next_mce->idx;
-		}
+		if (idx > last_idx)
+			break;
+
+		next_idx = idx + 1;
 		/* EOL should be set in last MCE */
-		err = nix_setup_mce(rvu, mce->idx,
-				    NIX_AQ_INSTOP_WRITE, mce->pcifunc,
-				    next_idx, count ? false : true);
+		err = nix_setup_mce(rvu, idx, NIX_AQ_INSTOP_WRITE,
+				    mce->pcifunc, next_idx,
+				    (next_idx > last_idx) ? true : false);
 		if (err)
 			goto end;
+		idx++;
 	}
 
 end:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index f0363d0..40e431d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -477,68 +477,75 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	struct mcam_entry entry = { {0} };
+	struct rvu_hwinfo *hw = rvu->hw;
 	struct nix_rx_action action;
-#ifdef MCAST_MCE
 	struct rvu_pfvf *pfvf;
-#endif
 	int blkaddr, index;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
 		return;
 
-	/* Only PF can add a bcast match entry */
-	if (pcifunc & RVU_PFVF_FUNC_MASK)
+	/* Skip LBK VFs */
+	if (is_afvf(pcifunc))
+		return;
+
+	/* If pkt replication is not supported,
+	 * then only PF is allowed to add a bcast match entry.
+	 */
+	if (!hw->cap.nix_rx_multicast && pcifunc & RVU_PFVF_FUNC_MASK)
 		return;
-#ifdef MCAST_MCE
-	pfvf = rvu_get_pfvf(rvu, pcifunc & ~RVU_PFVF_FUNC_MASK);
-#endif
 
+	/* Get 'pcifunc' of PF device */
+	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_BCAST_ENTRY);
 
-	/* Check for L2B bit and LMAC channel
-	 * NOTE: Since MKEX default profile(a reduced version intended to
-	 * accommodate more capability but igoring few bits) a stap-gap
-	 * approach.
-	 * Since we care for L2B which by HRM NPC_PARSE_KEX_S at BIT_POS[25], So
-	 * moved to BIT_POS[13], ignoring ERRCODE, ERRLEV as we'll loose out
-	 * on capability features needed for CoS (/from ODP PoV) e.g: VLAN,
-	 * DSCP.
-	 *
-	 * Reduced layout of MKEX default profile -
-	 * Includes following are (i.e.CHAN, L2/3{B/M}, LA, LB, LC, LD):
-	 *
-	 * BIT_POS[31:28] : LD
-	 * BIT_POS[27:24] : LC
-	 * BIT_POS[23:20] : LB
-	 * BIT_POS[19:16] : LA
-	 * BIT_POS[15:12] : L3B, L3M, L2B, L2M
-	 * BIT_POS[11:00] : CHAN
-	 *
+	/* Match ingress channel */
+	entry.kw[0] = chan;
+	entry.kw_mask[0] = 0xfffull;
+
+	/* Match broadcast MAC address.
+	 * DMAC is extracted at 0th bit of PARSE_KEX::KW1
 	 */
-	entry.kw[0] = BIT_ULL(13) | chan;
-	entry.kw_mask[0] = BIT_ULL(13) | 0xFFFULL;
+	entry.kw[1] = 0xffffffffffffull;
+	entry.kw_mask[1] = 0xffffffffffffull;
 
 	*(u64 *)&action = 0x00;
-#ifdef MCAST_MCE
-	/* Early silicon doesn't support pkt replication,
-	 * so install entry with UCAST action, so that PF
-	 * receives all broadcast packets.
-	 */
-	action.op = NIX_RX_ACTIONOP_MCAST;
-	action.pf_func = pcifunc;
-	action.index = pfvf->bcast_mce_idx;
-#else
-	action.op = NIX_RX_ACTIONOP_UCAST;
-	action.pf_func = pcifunc;
-#endif
+	if (!hw->cap.nix_rx_multicast) {
+		/* Early silicon doesn't support pkt replication,
+		 * so install entry with UCAST action, so that PF
+		 * receives all broadcast packets.
+		 */
+		action.op = NIX_RX_ACTIONOP_UCAST;
+		action.pf_func = pcifunc;
+	} else {
+		pfvf = rvu_get_pfvf(rvu, pcifunc);
+		action.index = pfvf->bcast_mce_idx;
+		action.op = NIX_RX_ACTIONOP_MCAST;
+	}
 
 	entry.action = *(u64 *)&action;
 	npc_config_mcam_entry(rvu, mcam, blkaddr, index,
 			      NIX_INTF_RX, &entry, true);
 }
 
+void rvu_npc_disable_bcast_entry(struct rvu *rvu, u16 pcifunc)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	int blkaddr, index;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return;
+
+	/* Get 'pcifunc' of PF device */
+	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
+
+	index = npc_get_nixlf_mcam_index(mcam, pcifunc, 0, NIXLF_BCAST_ENTRY);
+	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, false);
+}
+
 void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 				    int group, int alg_idx, int mcam_index)
 {
-- 
2.7.4

