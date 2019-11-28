Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 474EF10CAF9
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 15:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfK1O6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 09:58:08 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46854 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbfK1O6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 09:58:05 -0500
Received: by mail-lj1-f196.google.com with SMTP id e9so28812740ljp.13
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 06:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LUyJI7Xtt6B49WNUawbgsGkfQ59e//4g+j9sie0K+wA=;
        b=fr41RTJEy5Zr1Mf34JJS2aTc0bRxU1MD9uDHZeMlDw2PpU5RYyFvfn9cfdKFgw7gRi
         2EnpXvd2e2Fbq0fLk6r3nWUB2D3yhONTgOXuQ+LTEUIQ9ozzk2aJcS/eQhTFDmKhAnrJ
         enhP0jBLFcIMlhOAvq1jZL/fyPjFWIASW6ad0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LUyJI7Xtt6B49WNUawbgsGkfQ59e//4g+j9sie0K+wA=;
        b=qFK5bfvI4WLjus5bw/+fwvxEpegS2pDHjrVGXIm3IRf6J7YFMB7U7ZtBNaEWn0u9gq
         gND9Nbj1PtWM8S4qGlWSl+pwiaYq0OWOXcqj0CCZ7Pl+O4FT3cL3/6W7Pyqp43Kw8167
         +oRyFgnouel+nvd9uuSIIq0Mv0Tt6w7GrWZB0G0/gmWFiHWr3hCAGE9LtaOCwhx/dUqL
         W/c00U587tUifhTDUPcqa/KL0GghrySRHD9FF+cQrPVZ2GBNQSnmwWcIgF8ZXDHR/Wqe
         +Wkb9zaV0JqPgs3glnYLJNV1BMRldqziMS2ZerDa9zwx9f06iZ56kRXYpJX0Js93BzLQ
         OR6Q==
X-Gm-Message-State: APjAAAXFDaeKnB/ALZ135G9QK1XkYXpGX0r3nO6SzaozllNa00NXx8Ox
        OyoPdgLRU+RaRWXe5VmzsWHYfQ==
X-Google-Smtp-Source: APXvYqzvOsid7pV5utL0Oet589uRnpcNr0xR7W0TnHfGMl1kiNe7Uit0KU1mpk3Kb2fnMEJkAeqIoA==
X-Received: by 2002:a2e:b5b8:: with SMTP id f24mr33942968ljn.188.1574953082288;
        Thu, 28 Nov 2019 06:58:02 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id u2sm2456803lfl.18.2019.11.28.06.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 06:58:01 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>, Timur Tabi <timur@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v6 44/49] net/wan/fsl_ucc_hdlc: avoid use of IS_ERR_VALUE()
Date:   Thu, 28 Nov 2019 15:55:49 +0100
Message-Id: <20191128145554.1297-45-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191128145554.1297-1-linux@rasmusvillemoes.dk>
References: <20191128145554.1297-1-linux@rasmusvillemoes.dk>
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

Reviewed-by: Timur Tabi <timur@kernel.org>
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

