Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC45F4C7D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfKHNDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:03:03 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36529 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730780AbfKHNCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:02:25 -0500
Received: by mail-lf1-f65.google.com with SMTP id m6so4423018lfl.3
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 05:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SKjk4xtgUQ/kA6JZGPtMJVtONpNy6V4lFIeGBwHjI8g=;
        b=fbtFc25QQKF1HYy9EJWgNQgGlj4NvVM/SZQzlg+mehsa55gfaar01ZvOzQEFiHiJS8
         NIWL01E4b4KculB+YonomNkzR6/ye1LnowBIkbJ9/0ahn29mzO+PzUdzYz/FKdLUGozG
         3Bl1Mlzo2VusjD/D//znojGiimZguwgG2m4r0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SKjk4xtgUQ/kA6JZGPtMJVtONpNy6V4lFIeGBwHjI8g=;
        b=uY39CyW8pq2HTP6mFcia69CYCG1GsjiKCLsR6CVwVFdjiurZzuW8lluMKq0CBVLvjY
         npZV5cDx08p4edBmpF7glz5JCUpx+9Z+BY7Z//L5mEZX9GoeF77YgC3ahcJc7a5/08mD
         RkTuKknxUGaaQyVRa0L4d1ksVVw9/vNJeKDpVR/oDaGJ9YsoXZYMI1sAc0UJp1BTY5Ax
         ZbXGXxVCTQ/PVeSautQi0ff9xFheLzAi8qoAOgdUkusZ7ZHSM1MABOooTGMLf7WTPV71
         lSBj7wZma/exj9syvQ5YQeA3oD50x+DA6r838sTkqRJLQ0vNoTZJlc5QfO+zpu544pxC
         y16Q==
X-Gm-Message-State: APjAAAWKydbL90mk6vEKhJ9fmFWl/oiw2PWjUbjbrdO+20bZwQC+IH5v
        qMLv3+vQsUc2Q9yDYplHqLIgeg==
X-Google-Smtp-Source: APXvYqwH4Au0vtX7CvDcjAgRV7H9RHuuGAfZs53rG3gF/CjSF6Puxm/KMJghDcukVOdVzQRBjC2v/w==
X-Received: by 2002:a19:f107:: with SMTP id p7mr6505066lfh.91.1573218142811;
        Fri, 08 Nov 2019 05:02:22 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id d28sm2454725lfn.33.2019.11.08.05.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 05:02:22 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v4 44/47] net/wan/fsl_ucc_hdlc: fix reading of __be16 registers
Date:   Fri,  8 Nov 2019 14:01:20 +0100
Message-Id: <20191108130123.6839-45-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
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

