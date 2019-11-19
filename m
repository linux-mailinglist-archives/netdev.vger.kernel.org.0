Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6542F1022E0
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfKSLSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:18:37 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40560 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKSLSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:18:37 -0500
Received: by mail-pg1-f193.google.com with SMTP id e17so3851300pgd.7
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 03:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uoDeo1T94JqxutREescHScs1XSs6Wy2vmQo9CV4P47U=;
        b=WcgTsTHr/G6jgJIPHlzw4RjGqgq9pmFTz41CLvkd+aEJL7Pt4VySytVr0UKHl1Yx28
         xxRRGpt1DWvC6AXtZBTjuUdibMQiaATXQph/q2Nw4NUKtkq7j8qspLXvfUMtTJ/2VhTx
         8XoAOOMfkfndS1xgN5ru0me1cd9GgE1SQ5B4qphXrW0T2KXzFPyhAmGA+j7YayAQX/ph
         AssRh3DU6g0gNYKHSEudVGG/ogDy+qNpxAOX/vgBb01NS4qXbe8gnrWpPwWSGMc6wuZn
         vxovE9JmaQ+yDZE++l/B1g4XB+8+CQXkG5twbjDBt0jW2fi124C+HlckeaD5nEaSvBwU
         RpNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uoDeo1T94JqxutREescHScs1XSs6Wy2vmQo9CV4P47U=;
        b=fGHk4f8GYJsJOVKiiPEsUKDYAbF+HoA6hitsIvRwK2XMLt0wyNd7Qy4ReCjy2B4M/R
         52qU07QPluEJV3OTyjLeLfIeD5/Tl6JbRmHHHnhs1vAZ2ZlN5XT7kDGsUik6zD8154K0
         yu3pp24iG5ETcPhdKxx69PpVRYdD8X8BAAEucNI1bMwUGqtkPDq1SnQAlFZDLybtn95h
         ghnlYxcTLCx27iERdGMNaCvdTOV/LpDw7PdI77eeO9rnRvDgLu1AD6XFiDR44jBvxfKs
         FgQvAGIIW5hZN16rvaeeRhJIrDFhpB8Fq08Paad4Oq788umNNGRQkEYmMKUTpLRbVv5A
         xqOw==
X-Gm-Message-State: APjAAAU//53fERp3QoZlaux5LiftchSghh+H6yhSCqVlLPWFVwnsmsp7
        MvBTMiVcmmMF1k+/+pwACaGRiJKyeWw=
X-Google-Smtp-Source: APXvYqxa1sz4R0Blbtg6HYgQd5MBqevkI4N/081YnF8xngxlOJ7JjGlnZ+jztUAQXm4kagg59MtAgQ==
X-Received: by 2002:a63:3f04:: with SMTP id m4mr5027012pga.234.1574162315954;
        Tue, 19 Nov 2019 03:18:35 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id 6sm25918453pfy.43.2019.11.19.03.18.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Nov 2019 03:18:35 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 13/15] octeontx2-af: verify ingress channel in MCAM entry
Date:   Tue, 19 Nov 2019 16:47:37 +0530
Message-Id: <1574162259-28181-14-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
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
index b6291ea..fd0cb77 100644
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
index 00468c88..f474a26 100644
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

