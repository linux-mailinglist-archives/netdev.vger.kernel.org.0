Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFD4262AD8
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgIIIrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729960AbgIIIq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:46:26 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC4AC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:46:24 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s2so1001291pjr.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DACBqctBh6K/lxXBtUEpWPPKXy/+y/7V6/I8NP3tZNw=;
        b=CSYfLNc9HhhetvhmGa8yIRj616OC+BHBaSLAQ1seXj7RWM0bXluUQgb7EP2UnQUA2d
         8rYRFvPx4Xrly67HQ9/NBiwRuOyJAcQtVOhCMGDpOthaA0TBKmrtR/zU8usV6Stl8ehr
         W5MnfuirrFsozgUc6ULclgtimRQKmyg2MJ6//TFH3O1XtSd7JI6+2JpqT4OcVgP+1ieq
         ScesDchm8LbafCVhfr4rTI9XuCzwpeeeffk/gemh9zmmGqNCdGZ6bi1msTWAiwGw2E+o
         JCx4AnSv8goehSLNns2wE6Oh3ACDlLX3Zd8f1K3i5fKCccd1QRQNcND1quEn8ucfPHes
         zbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DACBqctBh6K/lxXBtUEpWPPKXy/+y/7V6/I8NP3tZNw=;
        b=YCYSifHJ8X8kznvYfee5ub1yFyWrj/OYG6jOhKdEOrbHxsrUrbrApntGbNaVnvFU09
         ZznB89ALIxuce8g7HjrJVExdluESaj6wNEAWoSt/xB1rkpJhzjjUCAkLWnkXwIMrjS2t
         5Y2IvAb4F5kXBD7yH1GlfZh6SAqcl5prGOUd7sMwiHQ5zjghCt/BUqKoRVpYrJI6dG02
         w+t7lribxInif9zSVT09o1DntAPeWawXLPY51Xva0jMrigUuqcgFxVNdfTYm3pefbt28
         I/K/Corm0LOGQevmCVfvCeVmJSX/hc64fluj4bDfCcHKU+oGTviBwmikf8ca3P4PaU4T
         Nu5A==
X-Gm-Message-State: AOAM532Nv+tI9O6wue+O4Uz2PnuQWm+w/dZOT8RxcM8Vsrk49JeerzSX
        bc+nnbvPNMBoTLil+pOiYE0=
X-Google-Smtp-Source: ABdhPJxDKMng6NCm58G/wa6NgVEVOWibpt14HedO6cZou3eY/uduRDZZlIE+KCxmzAb6ZuHiOoDYwA==
X-Received: by 2002:a17:90a:930c:: with SMTP id p12mr387pjo.72.1599641184086;
        Wed, 09 Sep 2020 01:46:24 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:46:23 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 17/20] ethernet: ni: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:15:07 +0530
Message-Id: <20200909084510.648706-18-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.25.1

