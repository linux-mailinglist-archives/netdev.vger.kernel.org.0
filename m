Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CD7F4C69
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbfKHNC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:02:27 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38556 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730743AbfKHNCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:02:24 -0500
Received: by mail-lf1-f65.google.com with SMTP id q28so4421251lfa.5
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 05:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IVdoGLW+H0ZKnJRayTBX6GqWyaD6YHKGaBDMMFO7/WI=;
        b=XGWfSCSUEAVnpUU/P6J3Qpi258NYlF3UJQSunn16SlUdmsp2q+W8Bk2e/nwHBQtUA0
         fTuY1Ravcq9bFl1d3rl/f799vNBuCYFEgPCX2t9OqCPlkEeIvRZyKcQb8orXRDyeqpLG
         r3uSJRO/BS/Xt5o6Y8WDp/Fl9289KO+LrOKYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IVdoGLW+H0ZKnJRayTBX6GqWyaD6YHKGaBDMMFO7/WI=;
        b=UbK7QTcQCnr+h6xv9bIIgZjq+SIZxU6NlhMFOQYolYOkpF5SeTfnGaOeKQMpu7cSXO
         RqK94H0B4TXGDv0Ut9LZr3FOJ+sowIsm6dmoclQBJgdMZlftsW0Q9eDpD/G9q1bSOuB6
         c7gQLXxQgx8ayQaKxqzYpTznxEVvFQre7HROO8rLaZAaf+6x59rXYOJ0NN1ZyM18r1k6
         QlbSpy+ijuv3eil9VaZbhaMuxWkWDCZr/j0OxUpbx8VxQsXuC8y1UoiJW70wrdF07E7f
         apWiXuupD/v/2IImxFSJwEljA/d1DKf4BTVHeaQhp+SRdJ1mKSgaL3twyM2+lqYTDqgy
         VC4Q==
X-Gm-Message-State: APjAAAXcmMgPrwGU14gGbmXw3onwY8jTBM0Jpnr2Y4GD/CSbzfq5hqVx
        RQYslzYMEgM7Y/X2R2U8Of+5mw==
X-Google-Smtp-Source: APXvYqwfxfaitvaPMgKPzDm4mZzVxujIi4YRrNIWmv3dBUm4XchC7Z1ld8b5BxN/rmHZMQ6u7CZ4hg==
X-Received: by 2002:a19:148:: with SMTP id 69mr6994219lfb.76.1573218141700;
        Fri, 08 Nov 2019 05:02:21 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id d28sm2454725lfn.33.2019.11.08.05.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 05:02:21 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v4 43/47] net/wan/fsl_ucc_hdlc: avoid use of IS_ERR_VALUE()
Date:   Fri,  8 Nov 2019 14:01:19 +0100
Message-Id: <20191108130123.6839-44-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
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

