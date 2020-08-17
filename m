Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C57245FE1
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgHQI0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbgHQI0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:26:38 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA70C061388;
        Mon, 17 Aug 2020 01:26:38 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f10so7131539plj.8;
        Mon, 17 Aug 2020 01:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o0FMk4NSKHdON29FQ/delLJrHAtl7s1b3Zn2ITn/KyQ=;
        b=EMmUPSbN+4ipANeDlXBtAnB3UwDY9H6TP8yOz6wWku97mB6+sfEUFOlpE72g1O6h+G
         eKrUOejHzvHY6tyzDx+IDTwXdbaK3zLGMU/M598ekvxCtnC/7d5d6ZCR/ZcR2UAv3fbe
         VACi+Zor+zAIOATP/Yas9HdBtd3o20TU5dAvVWXl0gbWV28T+49O1BKHmxBFxvmklfmt
         SPVaLg+2T0xkD0oIgr1nz1XfAk640XPjM5ZOfmUjy+0G9gOsCqrDT81YmPmeM6i4QCL5
         edf5DD3C4xCx1GBFsyuZiKQ42c55kRmRuEvQqQ6C2gxiwS4bNYibBkfB32keH/g72ew7
         ErFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o0FMk4NSKHdON29FQ/delLJrHAtl7s1b3Zn2ITn/KyQ=;
        b=ojYs/Cb17MCxM0S8grC8fWkahlgIj1brbIY+WupEzSEeJPnHXFtEuDSUwAr3RXrdZc
         egAbyBfs6J27bZZCoeVWtHFvMM4bPhLZdOGaExw88uU9SR6EPfMCsWOhczcCtkYFlmAz
         eK44YyVYEJGaIY5xuUp+cCM8xPLJzH/AR4zArtIrRbJIjGCo9xuBVdY99Ya3cPqGOUhB
         NEUQX9DoYATJyLyC5lLPJ4JSw/ntUDRud1oC2sDQmDOovVzw7D6CNWJ4+k+okMJGq8il
         tMV0dSRDaKIROySXR0tNqia+yCKuOfjCB7fwdc512wtdbgV+3fAsXSxkRWLpnAe69vrg
         iqaQ==
X-Gm-Message-State: AOAM531sDdsiqUu0gtsRL3kWkrG1Zugu4XMG47Gxu/MdFWHugr0IyEY3
        pyXxvryyv+BAZOer9611Fxo=
X-Google-Smtp-Source: ABdhPJybXxJ+dBHrJmIu3dZ4nk6KLcetVg87DxiqclRyCqvNLKi590hC96D0VCcPHISVJroeNA4prQ==
X-Received: by 2002:a17:90a:eb17:: with SMTP id j23mr11335001pjz.151.1597652797309;
        Mon, 17 Aug 2020 01:26:37 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:26:36 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 17/20] ethernet: ni: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:31 +0530
Message-Id: <20200817082434.21176-19-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/ni/nixge.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 4075f5e59955..a6861df9904f 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -787,9 +787,9 @@ static irqreturn_t nixge_rx_irq(int irq, void *_ndev)
 	return IRQ_HANDLED;
 }
 
-static void nixge_dma_err_handler(unsigned long data)
+static void nixge_dma_err_handler(struct tasklet_struct *t)
 {
-	struct nixge_priv *lp = (struct nixge_priv *)data;
+	struct nixge_priv *lp = from_tasklet(lp, t, dma_err_tasklet);
 	struct nixge_hw_dma_bd *cur_p;
 	struct nixge_tx_skb *tx_skb;
 	u32 cr, i;
@@ -879,8 +879,7 @@ static int nixge_open(struct net_device *ndev)
 	phy_start(phy);
 
 	/* Enable tasklets for Axi DMA error handling */
-	tasklet_init(&priv->dma_err_tasklet, nixge_dma_err_handler,
-		     (unsigned long)priv);
+	tasklet_setup(&priv->dma_err_tasklet, nixge_dma_err_handler);
 
 	napi_enable(&priv->napi);
 
-- 
2.17.1

