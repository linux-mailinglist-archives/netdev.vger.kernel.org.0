Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E85F104280
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfKTRtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:49:50 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44032 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbfKTRtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:49:49 -0500
Received: by mail-pg1-f194.google.com with SMTP id e6so67349pgi.11
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/0ltRi7dMIqVnKBtA0p63fd0OpBDxTNBV+P84wA5MmA=;
        b=SZF5vOgoePZjbcHFYTx/jfys+iNtA31ZUuRftgD66wqhBP+qvghqACYcwfR62yl91I
         WhD+3NPuCk4MeEEnXnZ7MB2v7u9yMjEUNlCYnd/tkXPWYF4yB/3CWzzaRlLdSjN8sIrF
         ez8ZVpNIPSHb8Lr4bKM8uPI6DZ6hqA+nzr6mYCdZZ68fi5xRKxxobD8stNgdWULmHXyp
         ieulLfK3TqiSTHM16Bhs992xlB/thkvPVgR3N5UsTiYezKNADPImulov2ZXNyZsRk9Z/
         xMBsfuZtjTc5DtbTi6J32GRu72Bw/OcjwDvqBJEFEY3crZaFcvP7P89LTBrpNaElm32A
         CPdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/0ltRi7dMIqVnKBtA0p63fd0OpBDxTNBV+P84wA5MmA=;
        b=ipIAHQj4sbV0h9WRvLO/Ea63R/GMxFuOAPtTjYhJy35ib0gb6wvQOuq+O6+weHTnWo
         7Z4mWWYh4MFNs9ytGPZuBUAmnJd0ygfu1rTH+mbC50f0JYacZiMNeDdwKUHLy5wThAIk
         nd932apVJREoxxsT6ZtsDKwKpcoBPE3yrWXaABJkoqVb8324ZHxI7AK0pouEv6zbS+7z
         IYIzK40BMuV8zoT7InzxQmRpTL3prhxNqMlFO2Hct/mmUA88ZLc+WWjJrgPtOkTS7+18
         SXmbWkFpluQa4sveinAINTeOhNbC5HTC4dK3E1rrWC1HLb18Cf7r6JSxIffuRw+0B0sB
         yDMg==
X-Gm-Message-State: APjAAAVdVEtzfaVnlE2PboNMsYaqV5kUt40xLNbXD6NOEUpACGVEW6t+
        8V2C6aqa8LnDgd3wNAOGzks1WID8
X-Google-Smtp-Source: APXvYqxOUBNvKI9ER6i1euRHshOemJrUy5evg+4amArWL1tAUYaDH8usyKGOnv8GxUI4CPzEQMNuSA==
X-Received: by 2002:a65:4907:: with SMTP id p7mr4550348pgs.327.1574272188581;
        Wed, 20 Nov 2019 09:49:48 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y24sm32230522pfr.116.2019.11.20.09.49.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 20 Nov 2019 09:49:47 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v3 13/16] octeontx2-af: verify ingress channel in MCAM entry
Date:   Wed, 20 Nov 2019 23:18:03 +0530
Message-Id: <1574272086-21055-14-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

A RVU PF and it's VFs share a CGX port and can only take pkts
received at that port. While installing MCAM entries for forwarding
packets it should be made sure that this is not violated. Hence
before installing MCAM entry sent by PF/VF the ingress channel
in the match key needs to be verified.

This patch does this channel verification.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  4 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 47 ++++++++++++++++++++++
 3 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 9812972..f561dfa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2479,7 +2479,7 @@ static void rvu_enable_afvf_intr(struct rvu *rvu)
 
 #define PCI_DEVID_OCTEONTX2_LBK 0xA061
 
-static int lbk_get_num_chans(void)
+int rvu_get_num_lbk_chans(void)
 {
 	struct pci_dev *pdev;
 	void __iomem *base;
@@ -2514,7 +2514,7 @@ static int rvu_enable_sriov(struct rvu *rvu)
 		return 0;
 	}
 
-	chans = lbk_get_num_chans();
+	chans = rvu_get_num_lbk_chans();
 	if (chans < 0)
 		return chans;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 7fe1f1c..a90af41 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -427,6 +427,7 @@ int rvu_get_lf(struct rvu *rvu, struct rvu_block *block, u16 pcifunc, u16 slot);
 int rvu_lf_reset(struct rvu *rvu, struct rvu_block *block, int lf);
 int rvu_get_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc);
 int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero);
+int rvu_get_num_lbk_chans(void);
 
 /* RVU HW reg validation */
 enum regmap_block {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 40e431d..cf61796 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -28,11 +28,40 @@
 
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
 
+#define NPC_KEX_CHAN_MASK	0xFFFULL
+
 static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
 				      int blkaddr, u16 pcifunc);
 static void npc_mcam_free_all_counters(struct rvu *rvu, struct npc_mcam *mcam,
 				       u16 pcifunc);
 
+static int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc,
+				   u8 intf, u16 channel)
+{
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id, lmac_id;
+	int base = 0, end;
+
+	if (intf == NIX_INTF_TX)
+		return 0;
+
+	if (is_afvf(pcifunc)) {
+		end = rvu_get_num_lbk_chans();
+		if (end < 0)
+			return -EINVAL;
+	} else {
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+		base = NIX_CHAN_CGX_LMAC_CHX(cgx_id, lmac_id, 0x0);
+		/* CGX mapped functions has maximum of 16 channels */
+		end = NIX_CHAN_CGX_LMAC_CHX(cgx_id, lmac_id, 0xF);
+	}
+
+	if (channel < base || channel > end)
+		return -EINVAL;
+
+	return 0;
+}
+
 void rvu_npc_set_pkind(struct rvu *rvu, int pkind, struct rvu_pfvf *pfvf)
 {
 	int blkaddr;
@@ -1808,12 +1837,17 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u16 pcifunc = req->hdr.pcifunc;
+	u16 channel, chan_mask;
 	int blkaddr, rc;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
 		return NPC_MCAM_INVALID_REQ;
 
+	chan_mask = req->entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
+	channel = req->entry_data.kw[0] & NPC_KEX_CHAN_MASK;
+	channel &= chan_mask;
+
 	mutex_lock(&mcam->lock);
 	rc = npc_mcam_verify_entry(mcam, pcifunc, req->entry);
 	if (rc)
@@ -1830,6 +1864,11 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 		goto exit;
 	}
 
+	if (npc_mcam_verify_channel(rvu, pcifunc, req->intf, channel)) {
+		rc = NPC_MCAM_INVALID_REQ;
+		goto exit;
+	}
+
 	npc_config_mcam_entry(rvu, mcam, blkaddr, req->entry, req->intf,
 			      &req->entry_data, req->enable_entry);
 
@@ -2165,6 +2204,7 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u16 entry = NPC_MCAM_ENTRY_INVALID;
 	u16 cntr = NPC_MCAM_ENTRY_INVALID;
+	u16 channel, chan_mask;
 	int blkaddr, rc;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
@@ -2174,6 +2214,13 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 	if (req->intf != NIX_INTF_RX && req->intf != NIX_INTF_TX)
 		return NPC_MCAM_INVALID_REQ;
 
+	chan_mask = req->entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
+	channel = req->entry_data.kw[0] & NPC_KEX_CHAN_MASK;
+	channel &= chan_mask;
+
+	if (npc_mcam_verify_channel(rvu, req->hdr.pcifunc, req->intf, channel))
+		return NPC_MCAM_INVALID_REQ;
+
 	/* Try to allocate a MCAM entry */
 	entry_req.hdr.pcifunc = req->hdr.pcifunc;
 	entry_req.contig = true;
-- 
2.7.4

