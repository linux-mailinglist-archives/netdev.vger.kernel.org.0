Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998B710CAFE
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 15:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfK1O6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 09:58:06 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38742 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbfK1O6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 09:58:05 -0500
Received: by mail-lf1-f67.google.com with SMTP id r14so4005999lfm.5
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 06:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=byxQuHw6IVmwv5QbVm5twa+er8x0Qu7qmmS64lJfOnw=;
        b=PondpcWeSDGdnmJ3H3VheUMZ5EamRr1/9yXbPe7FnTxs0EB3gX3rAmq3N+xxQXg1zC
         8n9IySGiwvx4CXJ87vaurWMM04a78FAMf2Sv1PDfAzRwEzyV7rH4OyqjmmxRqM28QIEv
         FB3fNi1x+H8+Cb63fYmgSdnsF52YRLDjjuMIo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=byxQuHw6IVmwv5QbVm5twa+er8x0Qu7qmmS64lJfOnw=;
        b=a2XiQa+KMalxm4EGvIxL5ltAXZMAEQXibrTIIx09Wp1dPFWGnEaI1/QSPE7pU1puPR
         wyetnLDsgeJUrCxI3lALTvT/uGwP/o+2MwBb/C4hE+Jb0xKLxfLiJNkVZssCbf+Y6Xgr
         aK3Wtj8XFFNyALxLCNrtTyOwJQn70dMxbqWjFFhacABKFK+7P56r2sHOEG/OUdIzcq9V
         46jpVscHkFGoyE42dMt14I0AZQkNcpp7Ym3RUurtQyGQLyjmwdBb/dZAwYnT9dLD2uyy
         bWQ+uJKKlRu1YS+Bhy8YaXN4LM//LP178ONlT3iJbenoctOpYXGtUFk5o3acgkOYkWKz
         YT/Q==
X-Gm-Message-State: APjAAAWv2JTEPsfftVAwn+/Z79mIJhCRg3KuhGwjpWipomqgiUaCBEdB
        nuAcbtydtmRvsLJTiGVPA6/2dg==
X-Google-Smtp-Source: APXvYqyFtd33g1Hp4cvK1H6BPWnHJDxlirit0nsDRKrmBSAkYuEyCJVhYftiyBHH6/qxlZfMH1fiXA==
X-Received: by 2002:a19:e011:: with SMTP id x17mr8564756lfg.59.1574953083383;
        Thu, 28 Nov 2019 06:58:03 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id u2sm2456803lfl.18.2019.11.28.06.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 06:58:03 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>, Timur Tabi <timur@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v6 45/49] net/wan/fsl_ucc_hdlc: fix reading of __be16 registers
Date:   Thu, 28 Nov 2019 15:55:50 +0100
Message-Id: <20191128145554.1297-46-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191128145554.1297-1-linux@rasmusvillemoes.dk>
References: <20191128145554.1297-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When releasing the allocated muram resource, we rely on reading back
the offsets from the riptr/tiptr registers. But those registers are
__be16 (and we indeed write them using iowrite16be), so we can't just
read them back with a normal C dereference.

This is not currently a real problem, since for now the driver is
PPC32-only. But it will soon be allowed to be used on arm and arm64 as
well.

Reviewed-by: Timur Tabi <timur@kernel.org>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index 405b24a5a60d..8d13586bb774 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -732,8 +732,8 @@ static int uhdlc_open(struct net_device *dev)
 
 static void uhdlc_memclean(struct ucc_hdlc_private *priv)
 {
-	qe_muram_free(priv->ucc_pram->riptr);
-	qe_muram_free(priv->ucc_pram->tiptr);
+	qe_muram_free(ioread16be(&priv->ucc_pram->riptr));
+	qe_muram_free(ioread16be(&priv->ucc_pram->tiptr));
 
 	if (priv->rx_bd_base) {
 		dma_free_coherent(priv->dev,
-- 
2.23.0

