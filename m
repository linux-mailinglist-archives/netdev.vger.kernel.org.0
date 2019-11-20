Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2B4104272
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfKTRtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:49:09 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33261 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbfKTRtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:49:09 -0500
Received: by mail-pg1-f194.google.com with SMTP id h27so100833pgn.0
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yH/qYJxCE31ayyark6kZgwoI8kT0q2lUxCAX2T9qZmA=;
        b=A3hXC1Vpqt3TyNAtYC9kQa3lJTyuJ3D6ARebddTw4HLlZJwEpplp+4Q3MMgu+fnzz4
         pwn5JFr+GZzMQvCYH1U7za2WXDjo6NjT6n4nAGcHBO9mnmcIB4y/KZ+ol32qRZTEvMvK
         O24ncx9hjAvwRzUKxKHV5fK0NmYG4hitCwOOjMm+ARTvKJVhOG1y7XfRrVCVp6Ldqsf5
         AhR39TFbdmMT2+35RqBAaRZhOt46MCeqTdGteOmD6Bb06G3RZVCAJ4KCojip/vV/7cLb
         +1Pzi97Dk6w3x6cdZ/481De7jOz6+4jT57tnbVEmJEr/SWEXWUtfLEnfA1Xqkok9oZx1
         u7Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yH/qYJxCE31ayyark6kZgwoI8kT0q2lUxCAX2T9qZmA=;
        b=bMT9bExFrOrxLSd5jeWnAZa9qb0o9dwcECtvOwugNF9YZ866vJ6ZkKkyWkywMFJ5my
         AWgMBgZBHTRP7w7Qhc36mW/Q9Uz3LuDeQQpgkKMnvHqDtFBuKRA4iQCsMxFlagnj9zTx
         mwUa8ZmLm+J2uoQ/MNvh1d+3MsObz0dH8uc+xggzDjoo5Obp+44/4epfrUmWa673pTjq
         GXJwobMpnQVhND95vMWcm1eZhMUgVm0Xa3TMA0dyTmcvTeKUGaAwq+vdAgvhTHvr5KZP
         w2DWz8N5V3J9MYJjrH71SXsYtbMda6XZvjsbZdYUlztsjvPF5Xh6/JyqNS9qnKPPIfHe
         LQNA==
X-Gm-Message-State: APjAAAUlUUe4EI/itUHIJ9KxscHyIMx0a29faxHDu24mo51xGOSSeivG
        zq8z/bfXe+5YMvU3OXdurktuBFbQ
X-Google-Smtp-Source: APXvYqy0ZgQhJNaeT0znC9sfJEaao0o3vTgYb2OwjXL53yeeIKV89oz5j31jOpjzPzLvrpUWHQxUBg==
X-Received: by 2002:a65:4907:: with SMTP id p7mr4547461pgs.327.1574272146724;
        Wed, 20 Nov 2019 09:49:06 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y24sm32230522pfr.116.2019.11.20.09.49.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 20 Nov 2019 09:49:06 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v3 03/16] octeontx2-af: Cleanup CGX config permission checks
Date:   Wed, 20 Nov 2019 23:17:53 +0530
Message-Id: <1574272086-21055-4-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
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

