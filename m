Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D74FFAAB
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfKQQPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:15:00 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34728 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfKQQO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:14:59 -0500
Received: by mail-pl1-f195.google.com with SMTP id h13so8250937plr.1
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 08:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZYhWikcQBD81EX7fPZ0drmuTXLvQiUHXE6xHup37O4w=;
        b=hvGr4hI0wU3OKLud1k6ffO/m98/MgU8KQGKjVDHLP4dJHlNNKfyDDPQNILk/akBf1A
         vzDL7NHPh7L62JmQzDcFcxGvWxeNZPyjq8aj2fUZhuyT1D3NqVdkOcDr6FgMr8LtnVi9
         wue8wvAAhY6CykzfbM0VXIN24C/80fwtBri6SH7wktlaNGoGMndvvNe3OXK7lZSiENT+
         jzyMVftbrKJvGs7RpDH8qCKrEgK31/uKh6hIKcDinYJGN2s2bpdOVm0pnjoKtizpPCU1
         OMmi3ly3FuvHVJcqheC0WygwJarO6BiimLWmOvCMxlMvv8Ex5qfi9j5rY1Oc4pR5F4Ob
         PBdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZYhWikcQBD81EX7fPZ0drmuTXLvQiUHXE6xHup37O4w=;
        b=TFXLfHF/iuvSJhNpT0gB3XojUKiv0YxbdMnO2VHVlTEFKciDN/TMUOjPJWXNbLhLoZ
         fQSPpEYAubtjiIHg9gdjJV3VRcfBjvZu7wy0gJrZXP/jADgYQIDlXyr5dmfajadi8PMg
         nMk+Bz/DL3N7hVeKEAVpvGXtoIVYbTMgykV/TgB2wLpECX7f3jOs0IJ1R7jiZbpHSe6s
         umwywrVio9IhGrIyvDQ/Do5F6+Ixj5Z4vIj5xOQncoUq5/6OQieMY+MEizkjOs4CH6cN
         ii+0ut0xxw87F0D07Lrc9b9wMu09o0W2Y+wy6GC15HN9Erf8boW4OXlNTFpdTQSbY2V7
         UpHA==
X-Gm-Message-State: APjAAAUc7J4KLcrScuunuwmuVcGhpKSHWuJ22DEykqHRdJVqt5ClHstt
        O95fo3Foq+M2mXeC0T7PF9Q/dAKhzbs=
X-Google-Smtp-Source: APXvYqyIncVPgSisse2MrdJr364b/321dSwGyIO52A/4EfmShGLfvF7JskagOAI0/r3x2L2A81bC1g==
X-Received: by 2002:a17:902:9343:: with SMTP id g3mr25864151plp.278.1574007298604;
        Sun, 17 Nov 2019 08:14:58 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v2sm2675231pgi.79.2019.11.17.08.14.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Nov 2019 08:14:58 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 03/15] octeontx2-af: Cleanup CGX config permission checks
Date:   Sun, 17 Nov 2019 21:44:14 +0530
Message-Id: <1574007266-17123-4-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
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
index 0bbb2eb..5790a76 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -350,6 +350,18 @@ int rvu_cgx_exit(struct rvu *rvu)
 	return 0;
 }
 
+/* Most of the CGX configuration is restricted to the mapped PF only,
+ * VF's of mapped PF and other PFs are not allowed. This fn() checks
+ * whether a PFFUNC is permitted to do the config or not.
+ */
+inline bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
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

