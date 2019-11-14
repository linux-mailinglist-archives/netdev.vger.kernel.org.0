Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D32FBFA8
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfKNF2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:28:08 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41255 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfKNF2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:28:07 -0500
Received: by mail-pf1-f194.google.com with SMTP id p26so3342657pfq.8
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6IWpxp3qM8kJ6vUtghRN5Rt2D/DOfRzGBf4tU+65QkM=;
        b=jABVJ51PF6ySWrJxlUBpzABQiu2yvvBigJr8emWYx6qOxZ9ULooaKbaEVKgh0ofRyC
         RYByM5P57Etozv7sGyWQhoJbk0zYOSojjVqsry2vT1dGrkbNy3ssB5xP4QBcAfuHqID4
         6lOCdRisEBrhsV8CYBoV6ZEiu410gcwj8ZcFWrgh9KlS7gKurGgz92NJcWYbYLxgFy6V
         N5cb7st5ml9LNwRTWINX8fmGo8UBkcxbdiGPpgDhqyZk/LokLvEODtMekmvlcsypEKy9
         7njlhNWa86aZtK1NAmQCa2m68OzWRFN0LD0rw0W6m5ngzn/NXr9yRFVOBCp9oEzFkllW
         hJCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6IWpxp3qM8kJ6vUtghRN5Rt2D/DOfRzGBf4tU+65QkM=;
        b=Sm9ypj3qMjY45xGGOWhUD55fgpOrMKQLTygGrLvt9eQLytMUTD7DVpj9v/W3TPwfod
         RgPz0XG97mwacITWM+Eh6pR/1kSaZ5qcayuueeBh8DMUGHw150UmiQ804p/ogx4ceMhT
         YcM+ARl1ujvT7allBXAw/4TSwYW1F4XWkkpD/3EHcL95i9U9scfpes2h36ey6Ypff6Gs
         XyVe9oQyktuZeRd1VsorJYa6ziiV45Z+zXptQCkKa6396oYll5HziaTDMUigMNaNdoli
         muJ2EL6EbpJ2vevVzL8L1dgvTEBMG3RUFyYE0ZWyGCCGIxMl0tOlgJt3uPKeb4yfNuNQ
         cYKw==
X-Gm-Message-State: APjAAAXPvLctD/t0xLmM9nT9g5/GIWr5wHsS2fqkqwYuP3/BtQM2XN4l
        dq16JAR4UgDqV/thPxe/sXChk2IOu7c=
X-Google-Smtp-Source: APXvYqzcu7AaDQnwoOtcshECYIYx65G6wXXgauML4Gwjc3pvdg2XmzQEzplA8xqhqoyvkFLS/c/IwQ==
X-Received: by 2002:a62:82c1:: with SMTP id w184mr8883535pfd.134.1573709285034;
        Wed, 13 Nov 2019 21:28:05 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.28.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:28:04 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 17/18] octeontx2-af: Add option to disable dynamic entry caching in NDC
Date:   Thu, 14 Nov 2019 10:56:32 +0530
Message-Id: <1573709193-15446-18-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

A config option is added to disable caching of dynamic entries
like SQEs and stack pages. Also locks down all HW contexts in NDC,
preventing them from being evicted.

This option is useful when the queue count is large and there are
huge NDC cache misses. It's trade off between SQ context misses and
dynamically changing entries like SQE and stack page pointers.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/Kconfig     | 10 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 64 +++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    | 42 ++++++++++++++
 3 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
index 711ada7..fb34f61 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -16,3 +16,13 @@ config OCTEONTX2_AF
 	  Unit's admin function manager which manages all RVU HW resources
 	  and provides a medium to other PF/VFs to configure HW. Should be
 	  enabled for other RVU device drivers to work.
+
+config NDC_DIS_DYNAMIC_CACHING
+	bool "Disable caching of dynamic entries in NDC"
+	depends on OCTEONTX2_AF
+	default n
+	---help---
+	  This config option disables caching of dynamic entries such as NIX SQEs
+	  , NPA stack pages etc in NDC. Also locks down NIX SQ/CQ/RQ/RSS and
+	  NPA Aura/Pool contexts.
+
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 86042a7..63190b8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -661,6 +661,21 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 	return 0;
 }
 
+static const char *nix_get_ctx_name(int ctype)
+{
+	switch (ctype) {
+	case NIX_AQ_CTYPE_CQ:
+		return "CQ";
+	case NIX_AQ_CTYPE_SQ:
+		return "SQ";
+	case NIX_AQ_CTYPE_RQ:
+		return "RQ";
+	case NIX_AQ_CTYPE_RSS:
+		return "RSS";
+	}
+	return "";
+}
+
 static int nix_lf_hwctx_disable(struct rvu *rvu, struct hwctx_disable_req *req)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
@@ -705,21 +720,60 @@ static int nix_lf_hwctx_disable(struct rvu *rvu, struct hwctx_disable_req *req)
 		if (rc) {
 			err = rc;
 			dev_err(rvu->dev, "Failed to disable %s:%d context\n",
-				(req->ctype == NIX_AQ_CTYPE_CQ) ?
-				"CQ" : ((req->ctype == NIX_AQ_CTYPE_RQ) ?
-				"RQ" : "SQ"), qidx);
+				nix_get_ctx_name(req->ctype), qidx);
 		}
 	}
 
 	return err;
 }
 
+#ifdef CONFIG_NDC_DIS_DYNAMIC_CACHING
+static int nix_lf_hwctx_lockdown(struct rvu *rvu, struct nix_aq_enq_req *req)
+{
+	struct nix_aq_enq_req lock_ctx_req;
+	int err;
+
+	if (req->op != NIX_AQ_INSTOP_INIT)
+		return 0;
+
+	if (req->ctype == NIX_AQ_CTYPE_MCE ||
+	    req->ctype == NIX_AQ_CTYPE_DYNO)
+		return 0;
+
+	memset(&lock_ctx_req, 0, sizeof(struct nix_aq_enq_req));
+	lock_ctx_req.hdr.pcifunc = req->hdr.pcifunc;
+	lock_ctx_req.ctype = req->ctype;
+	lock_ctx_req.op = NIX_AQ_INSTOP_LOCK;
+	lock_ctx_req.qidx = req->qidx;
+	err = rvu_nix_aq_enq_inst(rvu, &lock_ctx_req, NULL);
+	if (err)
+		dev_err(rvu->dev,
+			"PFUNC 0x%x: Failed to lock NIX %s:%d context\n",
+			req->hdr.pcifunc,
+			nix_get_ctx_name(req->ctype), req->qidx);
+	return err;
+}
+
+int rvu_mbox_handler_nix_aq_enq(struct rvu *rvu,
+				struct nix_aq_enq_req *req,
+				struct nix_aq_enq_rsp *rsp)
+{
+	int err;
+
+	err = rvu_nix_aq_enq_inst(rvu, req, rsp);
+	if (!err)
+		err = nix_lf_hwctx_lockdown(rvu, req);
+	return err;
+}
+#else
+
 int rvu_mbox_handler_nix_aq_enq(struct rvu *rvu,
 				struct nix_aq_enq_req *req,
 				struct nix_aq_enq_rsp *rsp)
 {
 	return rvu_nix_aq_enq_inst(rvu, req, rsp);
 }
+#endif
 
 int rvu_mbox_handler_nix_hwctx_disable(struct rvu *rvu,
 				       struct hwctx_disable_req *req,
@@ -2871,6 +2925,10 @@ static int nix_aq_init(struct rvu *rvu, struct rvu_block *block)
 	/* Do not bypass NDC cache */
 	cfg = rvu_read64(rvu, block->addr, NIX_AF_NDC_CFG);
 	cfg &= ~0x3FFEULL;
+#ifdef CONFIG_NDC_DIS_DYNAMIC_CACHING
+	/* Disable caching of SQB aka SQEs */
+	cfg |= 0x04ULL;
+#endif
 	rvu_write64(rvu, block->addr, NIX_AF_NDC_CFG, cfg);
 
 	/* Result structure can be followed by RQ/SQ/CQ context at
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
index a8f9376..6e7c7f4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -241,12 +241,50 @@ static int npa_lf_hwctx_disable(struct rvu *rvu, struct hwctx_disable_req *req)
 	return err;
 }
 
+#ifdef CONFIG_NDC_DIS_DYNAMIC_CACHING
+static int npa_lf_hwctx_lockdown(struct rvu *rvu, struct npa_aq_enq_req *req)
+{
+	struct npa_aq_enq_req lock_ctx_req;
+	int err;
+
+	if (req->op != NPA_AQ_INSTOP_INIT)
+		return 0;
+
+	memset(&lock_ctx_req, 0, sizeof(struct npa_aq_enq_req));
+	lock_ctx_req.hdr.pcifunc = req->hdr.pcifunc;
+	lock_ctx_req.ctype = req->ctype;
+	lock_ctx_req.op = NPA_AQ_INSTOP_LOCK;
+	lock_ctx_req.aura_id = req->aura_id;
+	err = rvu_npa_aq_enq_inst(rvu, &lock_ctx_req, NULL);
+	if (err)
+		dev_err(rvu->dev,
+			"PFUNC 0x%x: Failed to lock NPA context %s:%d\n",
+			req->hdr.pcifunc,
+			(req->ctype == NPA_AQ_CTYPE_AURA) ?
+			"Aura" : "Pool", req->aura_id);
+	return err;
+}
+
+int rvu_mbox_handler_npa_aq_enq(struct rvu *rvu,
+				struct npa_aq_enq_req *req,
+				struct npa_aq_enq_rsp *rsp)
+{
+	int err;
+
+	err = rvu_npa_aq_enq_inst(rvu, req, rsp);
+	if (!err)
+		err = npa_lf_hwctx_lockdown(rvu, req);
+	return err;
+}
+#else
+
 int rvu_mbox_handler_npa_aq_enq(struct rvu *rvu,
 				struct npa_aq_enq_req *req,
 				struct npa_aq_enq_rsp *rsp)
 {
 	return rvu_npa_aq_enq_inst(rvu, req, rsp);
 }
+#endif
 
 int rvu_mbox_handler_npa_hwctx_disable(struct rvu *rvu,
 				       struct hwctx_disable_req *req,
@@ -427,6 +465,10 @@ static int npa_aq_init(struct rvu *rvu, struct rvu_block *block)
 	/* Do not bypass NDC cache */
 	cfg = rvu_read64(rvu, block->addr, NPA_AF_NDC_CFG);
 	cfg &= ~0x03DULL;
+#ifdef CONFIG_NDC_DIS_DYNAMIC_CACHING
+	/* Disable caching of stack pages */
+	cfg |= 0x10ULL;
+#endif
 	rvu_write64(rvu, block->addr, NPA_AF_NDC_CFG, cfg);
 
 	/* Result structure can be followed by Aura/Pool context at
-- 
2.7.4

