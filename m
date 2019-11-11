Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1292CF7BD0
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 19:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbfKKSkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 13:40:06 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43075 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727604AbfKKSkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:40:03 -0500
Received: by mail-pl1-f193.google.com with SMTP id a18so8126192plm.10
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 10:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1vHrMo9PkwSU6sZvCCU8CvH0PDybtkLKLFkcjdRCAlA=;
        b=FP7exOY/VMD0Cl+sDSo1iV8h66/4iTl/cCvPMLli6XybJ3I1+nibCc6BfxFRJi0PrZ
         up7VXxaE5Yb6JZ09ciXueql1adTPf8FPKKaGtobQy5SY/c0paUZrRDFGDZiD58dlwlCy
         njKxIB2JhnE5f88T8vSGeI3+w2MlgTJY8MH6e0EkoCyQFX27dHcKh1VgH04p5USkURvx
         pEuUGjq3ySB4PD9xjJDWV72Hgx/v0c5VEPMOHd2iZf9x53oV5jqX3K3dWeJy4HS9ibYC
         kpPz59G6M4EWmomgg2ngXVDK82DVeZCIjpgqkvoHxyLiuXOSH5zxHh+Mj+sJv03IoPXc
         NtPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1vHrMo9PkwSU6sZvCCU8CvH0PDybtkLKLFkcjdRCAlA=;
        b=YF4WOeWTlTMYfaOHNvgLTuJOxrAP8e0/TmcjDhOUFz7RLrJAQBKJGAsRPriJuY7tus
         cLcZuN+8LLRGbueRxReoQaC5W8t+QfVy8bVvGTMfPTyDhvbRSh7waSlX6u72y2PGR0zv
         3mw2lHAf6Jal0P99mXu61KPLH1tFXcWN8fbTNZRdcZ3dXsLLQAt7qWvT2lVk+w02m2Br
         tDdHToEgVQdH4dwbGZ93xL31Skoy9go731brYfgaFSD1WIp1Qrm4ZIIxgcKvT4xdz3uW
         XqRYhvtZrcuxrE6kKKOqSiHExVvbOgaVzno8fTpWIPASANpDE8Al8J+dZ08WWCRLZejR
         OQPA==
X-Gm-Message-State: APjAAAXmaPC1uu6ywFI2MSoJ8pXwoxNojTKAQeVVUpa6HiuCPsVtjktG
        HxdewKX69o5hdISjrtNL7KBLRravZlA=
X-Google-Smtp-Source: APXvYqwjYoQ+6r5kh286mup9NVkU+sCLncNByvLI7wTGXqQxPCveRHRRzEiZHGIMtv4IZL+KSjSCRA==
X-Received: by 2002:a17:902:9b81:: with SMTP id y1mr15340496plp.54.1573497601279;
        Mon, 11 Nov 2019 10:40:01 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id b5sm16921762pfp.149.2019.11.11.10.39.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 10:40:00 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 18/18] octeontx2-af: Start/Stop traffic in CGX along with NPC
Date:   Tue, 12 Nov 2019 00:08:14 +0530
Message-Id: <1573497494-11468-19-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Traffic for a CGX mapped NIXLF can be stopped by disabling entries
in NPC MCAM or by configuring CGX and mailbox messages exist for the
two options. If traffic is stopped at CGX then VFs of that PF are
also effected hence CGX traffic should be started/stopped by
tracking all the users of it. This patch implements that CGX users
tracking. CGX is also configured along with NPC if required.

Also removed a check which mandates even number of LBK VFs.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 12 ------
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  5 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 49 ++++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 13 +++++-
 4 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 3985053..5c190c3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2364,18 +2364,6 @@ static int rvu_enable_sriov(struct rvu *rvu)
 	if (vfs > chans)
 		vfs = chans;
 
-	/* AF's VFs work in pairs and talk over consecutive loopback channels.
-	 * Thus we want to enable maximum even number of VFs. In case
-	 * odd number of VFs are available then the last VF on the list
-	 * remains disabled.
-	 */
-	if (vfs & 0x1) {
-		dev_warn(&pdev->dev,
-			 "Number of VFs should be even. Enabling %d out of %d.\n",
-			 vfs - 1, vfs);
-		vfs--;
-	}
-
 	if (!vfs)
 		return 0;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 7370864..b252d86 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -179,6 +179,9 @@ struct rvu_pfvf {
 	struct mcam_entry entry;
 	int rxvlan_index;
 	bool rxvlan;
+
+	bool	cgx_in_use; /* this PF/VF using CGX? */
+	int	cgx_users;  /* number of cgx users - used only by PFs */
 };
 
 struct nix_txsch {
@@ -306,6 +309,7 @@ struct rvu {
 	struct			workqueue_struct *cgx_evh_wq;
 	spinlock_t		cgx_evq_lock; /* cgx event queue lock */
 	struct list_head	cgx_evq_head; /* cgx event queue head */
+	struct mutex		cgx_cfg_lock; /* serialize cgx configuration */
 
 	char mkex_pfl_name[MKEX_NAME_LEN]; /* Configured MKEX profile name */
 
@@ -410,6 +414,7 @@ int rvu_cgx_exit(struct rvu *rvu);
 void *rvu_cgx_pdata(u8 cgx_id, struct rvu *rvu);
 int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start);
 void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable);
+int rvu_cgx_start_stop_io(struct rvu *rvu, u16 pcifunc, bool start);
 int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id, int index,
 			   int rxtxflag, u64 *stat);
 /* NPA APIs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 90d43aa..7541553 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -308,6 +308,8 @@ int rvu_cgx_init(struct rvu *rvu)
 	if (err)
 		return err;
 
+	mutex_init(&rvu->cgx_cfg_lock);
+
 	/* Ensure event handler registration is completed, before
 	 * we turn on the links
 	 */
@@ -638,3 +640,50 @@ int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id,
 
 	return 0;
 }
+
+int rvu_cgx_start_stop_io(struct rvu *rvu, u16 pcifunc, bool start)
+{
+	struct rvu_pfvf *parent_pf, *pfvf;
+	int cgx_users, err = 0;
+
+	if (!is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc)))
+		return 0;
+
+	parent_pf = &rvu->pf[rvu_get_pf(pcifunc)];
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+
+	mutex_lock(&rvu->cgx_cfg_lock);
+
+	if (start && pfvf->cgx_in_use)
+		goto exit;  /* CGX is already started hence nothing to do */
+	if (!start && !pfvf->cgx_in_use)
+		goto exit; /* CGX is already stopped hence nothing to do */
+
+	if (start) {
+		cgx_users = parent_pf->cgx_users;
+		parent_pf->cgx_users++;
+	} else {
+		parent_pf->cgx_users--;
+		cgx_users = parent_pf->cgx_users;
+	}
+
+	/* Start CGX when first of all NIXLFs is started.
+	 * Stop CGX when last of all NIXLFs is stopped.
+	 */
+	if (!cgx_users) {
+		err = rvu_cgx_config_rxtx(rvu, pcifunc & ~RVU_PFVF_FUNC_MASK,
+					  start);
+		if (err) {
+			dev_err(rvu->dev, "Unable to %s CGX\n",
+				start ? "start" : "stop");
+			/* Revert the usage count in case of error */
+			parent_pf->cgx_users = start ? parent_pf->cgx_users  - 1
+					       : parent_pf->cgx_users  + 1;
+			goto exit;
+		}
+	}
+	pfvf->cgx_in_use = start;
+exit:
+	mutex_unlock(&rvu->cgx_cfg_lock);
+	return err;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 63190b8..8a59f7d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -194,6 +194,11 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 		break;
 	case NIX_INTF_TYPE_LBK:
 		vf = (pcifunc & RVU_PFVF_FUNC_MASK) - 1;
+
+		/* Note that AF's VFs work in pairs and talk over consecutive
+		 * loopback channels.Therefore if odd number of AF VFs are
+		 * enabled then the last VF remains with no pair.
+		 */
 		pfvf->rx_chan_base = NIX_CHAN_LBK_CHX(0, vf);
 		pfvf->tx_chan_base = vf & 0x1 ? NIX_CHAN_LBK_CHX(0, vf - 1) :
 						NIX_CHAN_LBK_CHX(0, vf + 1);
@@ -3120,7 +3125,8 @@ int rvu_mbox_handler_nix_lf_start_rx(struct rvu *rvu, struct msg_req *req,
 		return err;
 
 	rvu_npc_enable_default_entries(rvu, pcifunc, nixlf);
-	return 0;
+
+	return rvu_cgx_start_stop_io(rvu, pcifunc, true);
 }
 
 int rvu_mbox_handler_nix_lf_stop_rx(struct rvu *rvu, struct msg_req *req,
@@ -3134,7 +3140,8 @@ int rvu_mbox_handler_nix_lf_stop_rx(struct rvu *rvu, struct msg_req *req,
 		return err;
 
 	rvu_npc_disable_default_entries(rvu, pcifunc, nixlf);
-	return 0;
+
+	return rvu_cgx_start_stop_io(rvu, pcifunc, false);
 }
 
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
@@ -3150,6 +3157,8 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	nix_rx_sync(rvu, blkaddr);
 	nix_txschq_free(rvu, pcifunc);
 
+	rvu_cgx_start_stop_io(rvu, pcifunc, false);
+
 	if (pfvf->sq_ctx) {
 		ctx_req.ctype = NIX_AQ_CTYPE_SQ;
 		err = nix_lf_hwctx_disable(rvu, &ctx_req);
-- 
2.7.4

