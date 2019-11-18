Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C79EC1003CD
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfKRLYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:24:32 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38851 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbfKRLYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:24:31 -0500
Received: by mail-wm1-f68.google.com with SMTP id z19so18382402wmk.3
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 03:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IVdoGLW+H0ZKnJRayTBX6GqWyaD6YHKGaBDMMFO7/WI=;
        b=NH7FWgxoQiwr4LoAjxEWPXz7OgPdny/87RwuMrzkmPgKISYDOap46Q8/0cPFbhFB4G
         ZZpRjvTrHrfCSQC9zW37jijJDu4gzlSGe1F+XHMDmUQFD0duW7wQO7Fpiz6XOdu+/R3l
         F212mzs2E6Q3AxfovSV2tzrRwzYTfhflateDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IVdoGLW+H0ZKnJRayTBX6GqWyaD6YHKGaBDMMFO7/WI=;
        b=LTeQLI8tP1JMgYuPmBHZHPQ3EpErjOrlIyGW3UeBu1kR+jMt3Hsxq0SzBeCgkT9UPc
         mLnmnf/knzwJDCLn4IVwnzy5mjt15R9H1l0QkCz1baETbjGxTRHKuxqnBCQbM9Bvfd91
         A4fUncjxWkDu9VxbFhfr1oCoRa53ZYR8r+D+csihklH2oqgxtUc/2nJDYwFTMghlqwpD
         TLeQgtCeqd6oc/rdmsQM3Y3Xdpmt+d2rYZAfYGt/DgR2WT1g/b5c3zvYi0VDgSVj846R
         yEO8YiY8V7JiiRp+BXOOsVBn0Gr1zCxNGydKZ3v3njZgRA9jhEY9Aw36POKyqvaL6NkZ
         ZZgA==
X-Gm-Message-State: APjAAAVoJMOWomG2W17bwrqdxJP48/k5P4q6RkSRIf6/HRbTjM9u5Jmk
        RLj0QLlUCgOOFxz8sPbP37CM7g==
X-Google-Smtp-Source: APXvYqwwh12tB12JuthAp/C3MnVxgal/xwmAHyNat9wBHwHK00It/wImMmkOkU0iHk9+sdMLh98WhQ==
X-Received: by 2002:a1c:de88:: with SMTP id v130mr30219981wmg.89.1574076269555;
        Mon, 18 Nov 2019 03:24:29 -0800 (PST)
Received: from prevas-ravi.prevas.se (ip-5-186-115-54.cgn.fibianet.dk. [5.186.115.54])
        by smtp.gmail.com with ESMTPSA id y2sm21140815wmy.2.2019.11.18.03.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 03:24:29 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>, Timur Tabi <timur@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v5 44/48] net/wan/fsl_ucc_hdlc: avoid use of IS_ERR_VALUE()
Date:   Mon, 18 Nov 2019 12:23:20 +0100
Message-Id: <20191118112324.22725-45-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191118112324.22725-1-linux@rasmusvillemoes.dk>
References: <20191118112324.22725-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building this on a 64-bit platform gcc rightly warns that the
error checking is broken (-ENOMEM stored in an u32 does not compare
greater than (unsigned long)-MAX_ERRNO). Instead, now that
qe_muram_alloc() returns s32, use that type to store the return value
and use standard kernel style "ret < 0".

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 10 +++++-----
 drivers/net/wan/fsl_ucc_hdlc.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index ce6af7d5380f..405b24a5a60d 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -84,8 +84,8 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
 	int ret, i;
 	void *bd_buffer;
 	dma_addr_t bd_dma_addr;
-	u32 riptr;
-	u32 tiptr;
+	s32 riptr;
+	s32 tiptr;
 	u32 gumr;
 
 	ut_info = priv->ut_info;
@@ -195,7 +195,7 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
 	priv->ucc_pram_offset = qe_muram_alloc(sizeof(struct ucc_hdlc_param),
 				ALIGNMENT_OF_UCC_HDLC_PRAM);
 
-	if (IS_ERR_VALUE(priv->ucc_pram_offset)) {
+	if (priv->ucc_pram_offset < 0) {
 		dev_err(priv->dev, "Can not allocate MURAM for hdlc parameter.\n");
 		ret = -ENOMEM;
 		goto free_tx_bd;
@@ -233,14 +233,14 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
 
 	/* Alloc riptr, tiptr */
 	riptr = qe_muram_alloc(32, 32);
-	if (IS_ERR_VALUE(riptr)) {
+	if (riptr < 0) {
 		dev_err(priv->dev, "Cannot allocate MURAM mem for Receive internal temp data pointer\n");
 		ret = -ENOMEM;
 		goto free_tx_skbuff;
 	}
 
 	tiptr = qe_muram_alloc(32, 32);
-	if (IS_ERR_VALUE(tiptr)) {
+	if (tiptr < 0) {
 		dev_err(priv->dev, "Cannot allocate MURAM mem for Transmit internal temp data pointer\n");
 		ret = -ENOMEM;
 		goto free_riptr;
diff --git a/drivers/net/wan/fsl_ucc_hdlc.h b/drivers/net/wan/fsl_ucc_hdlc.h
index 8b3507ae1781..71d5ad0a7b98 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.h
+++ b/drivers/net/wan/fsl_ucc_hdlc.h
@@ -98,7 +98,7 @@ struct ucc_hdlc_private {
 
 	unsigned short tx_ring_size;
 	unsigned short rx_ring_size;
-	u32 ucc_pram_offset;
+	s32 ucc_pram_offset;
 
 	unsigned short encoding;
 	unsigned short parity;
-- 
2.23.0

