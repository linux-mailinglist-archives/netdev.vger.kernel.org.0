Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568611022D4
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfKSLSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:18:02 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38934 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbfKSLSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:18:02 -0500
Received: by mail-pg1-f194.google.com with SMTP id 29so11213048pgm.6
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 03:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yH/qYJxCE31ayyark6kZgwoI8kT0q2lUxCAX2T9qZmA=;
        b=WfF1nI+FM5/TI+URQadbY/Svo7GX3s8XhNkCLgbbVww7NlA0BpZ27wNZkDRm5jpQGc
         rOd9wyT5zQeNJTN3aJmp/O/8AN8D1nPv6hGC+E0QktGGobsp+BkF4IprBMBp+MGctEmN
         tSdRtclSHBIhe1j1lWkbgpf9Bg4hB9eq48N8F5TDtkS58pCo/JVjXLF8e04ORRPL3pSq
         NwMOt8MntQfE09XS+6cEHdIWeIZFz90P5Vc7jhSpW2/n1BYVklzXQqtmbGp6o2/eihgm
         PdUTXuhVWu7ZfOwFze+r62yLalslmf5nebxay7Pm4q+Z+XMcDeAenae6I2tJuJfbgW39
         f4hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yH/qYJxCE31ayyark6kZgwoI8kT0q2lUxCAX2T9qZmA=;
        b=FxpxqSWn/XIp0wt6RX/yUsp/Cfz8tMoa+Flf6OlsmpmkkEyo4qO3rvlpiQtfF2m5Ux
         HT7VHB2y1qsqV/ADNZhKZTSVIqGA8VGpv1jyC6QYl/M28jO4BPtP5ZYWjH1VRLmD1ft1
         lIBEKN+j40zbJua3NbLCFeE65KjjXvCJ6TJlc8JSC2mKm6QXL5CYxE6FxCq1iFepo41q
         04jEbZNmz/Scup+0R6QA2KnpWngEOrSA9tIsMM9KVMZnldrJbX5I5W0UMhxla5/5yhFb
         +7VSIM9FjgyyLte3e+scMfj2W1fPsX3at3cQHdOhxmU5j2fOrzSXA37bUGkWM3iYPTCO
         wiRw==
X-Gm-Message-State: APjAAAUbsecUA0Jxaz/IL22C1/pHpZn3jbzVlOP2BlRIVUxBDZa9LrIf
        vIuQMY6QSb/JxFbSrSIzE1k22107Jas=
X-Google-Smtp-Source: APXvYqyX9M3RPgophIIwvl13YM7uQ96nwpRWX9OTtxOyS07VCHyHfhUTP6WTnQ5cAk3RKykuMViERA==
X-Received: by 2002:a62:174d:: with SMTP id 74mr5017827pfx.145.1574162280918;
        Tue, 19 Nov 2019 03:18:00 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id 6sm25918453pfy.43.2019.11.19.03.17.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Nov 2019 03:18:00 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 03/15] octeontx2-af: Cleanup CGX config permission checks
Date:   Tue, 19 Nov 2019 16:47:27 +0530
Message-Id: <1574162259-28181-4-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Most of the CGX register config is restricted to mapped RVU PFs,
this patch cleans up these permission checks spread across
the rvu_cgx.c file by moving the checks to a common fn().

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 55 ++++++++++------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 0bbb2eb..e3c87c2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -350,6 +350,18 @@ int rvu_cgx_exit(struct rvu *rvu)
 	return 0;
 }
 
+/* Most of the CGX configuration is restricted to the mapped PF only,
+ * VF's of mapped PF and other PFs are not allowed. This fn() checks
+ * whether a PFFUNC is permitted to do the config or not.
+ */
+static bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
+{
+	if ((pcifunc & RVU_PFVF_FUNC_MASK) ||
+	    !is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc)))
+		return false;
+	return true;
+}
+
 void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable)
 {
 	u8 cgx_id, lmac_id;
@@ -373,11 +385,8 @@ int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start)
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id, lmac_id;
 
-	/* This msg is expected only from PFs that are mapped to CGX LMACs,
-	 * if received from other PF/VF simply ACK, nothing to do.
-	 */
-	if ((pcifunc & RVU_PFVF_FUNC_MASK) || !is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+	if (!is_cgx_config_permitted(rvu, pcifunc))
+		return -EPERM;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -409,8 +418,7 @@ int rvu_mbox_handler_cgx_stats(struct rvu *rvu, struct msg_req *req,
 	u8 cgx_idx, lmac;
 	void *cgxd;
 
-	if ((req->hdr.pcifunc & RVU_PFVF_FUNC_MASK) ||
-	    !is_pf_cgxmapped(rvu, pf))
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -ENODEV;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
@@ -477,12 +485,8 @@ int rvu_mbox_handler_cgx_promisc_enable(struct rvu *rvu, struct msg_req *req,
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id, lmac_id;
 
-	/* This msg is expected only from PFs that are mapped to CGX LMACs,
-	 * if received from other PF/VF simply ACK, nothing to do.
-	 */
-	if ((req->hdr.pcifunc & RVU_PFVF_FUNC_MASK) ||
-	    !is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -493,16 +497,11 @@ int rvu_mbox_handler_cgx_promisc_enable(struct rvu *rvu, struct msg_req *req,
 int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 					 struct msg_rsp *rsp)
 {
-	u16 pcifunc = req->hdr.pcifunc;
-	int pf = rvu_get_pf(pcifunc);
+	int pf = rvu_get_pf(req->hdr.pcifunc);
 	u8 cgx_id, lmac_id;
 
-	/* This msg is expected only from PFs that are mapped to CGX LMACs,
-	 * if received from other PF/VF simply ACK, nothing to do.
-	 */
-	if ((req->hdr.pcifunc & RVU_PFVF_FUNC_MASK) ||
-	    !is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -515,11 +514,8 @@ static int rvu_cgx_config_linkevents(struct rvu *rvu, u16 pcifunc, bool en)
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id, lmac_id;
 
-	/* This msg is expected only from PFs that are mapped to CGX LMACs,
-	 * if received from other PF/VF simply ACK, nothing to do.
-	 */
-	if ((pcifunc & RVU_PFVF_FUNC_MASK) || !is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+	if (!is_cgx_config_permitted(rvu, pcifunc))
+		return -EPERM;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -571,11 +567,8 @@ static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id, lmac_id;
 
-	/* This msg is expected only from PFs that are mapped to CGX LMACs,
-	 * if received from other PF/VF simply ACK, nothing to do.
-	 */
-	if ((pcifunc & RVU_PFVF_FUNC_MASK) || !is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+	if (!is_cgx_config_permitted(rvu, pcifunc))
+		return -EPERM;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
-- 
2.7.4

