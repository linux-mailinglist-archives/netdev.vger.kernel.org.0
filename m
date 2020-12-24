Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CCF2E27A9
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 15:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgLXO0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 09:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgLXO0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 09:26:43 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F1DC06138C;
        Thu, 24 Dec 2020 06:26:02 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id w1so2472081pjc.0;
        Thu, 24 Dec 2020 06:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p5OOA0vAPiVA8ZIkD7KgNkPxCYfKKWPfzTIiwGStjcc=;
        b=NKFeTK1FPdhwu/0w/5r3XpnZUiLir3X1fXJoj1c3B/fxnxjzVf7pPyBAEIdmOXJTf8
         CYM5kMC7uJ2W7rnumdqt1V/y9Cdg5lGdFpucoAKbRnlqmPN4+LcA0HaG93/mxv7+Zcfw
         qRCuMJ2bl72+c9eZVqG0LTJBBDIgFTi4isHmfe5SHsRlqVusAEQGvBFOQpo+TCmK4CK1
         MxlUii8FiS8h7T3nGP8+o9zUG1jh9alsSsa8ykZIej6ZA3KnkfLrahEyaI8HZ6/rgRIi
         8a8QEojj+1KauSWDo6G7ytxzmal+wgqHc+AyoB3HnSygWlCoARLwL78hHNwBjQS8XxPi
         9idQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p5OOA0vAPiVA8ZIkD7KgNkPxCYfKKWPfzTIiwGStjcc=;
        b=bQ9edTlNYA2YzBYSEkAECP1UV4zHVjcox6kB5ZpqU9h/mXR8SOZzVHoKJjvDPbkqCX
         wakqcjHPuZ6QCB4bBWFi1twtboZfzNyJoJiCd6rbTHO4fA7IYB5FPeFSs8/xRaAsW5XE
         Py4D0qbQTvO4LqSteJ1taqsgaVFQI+PFMvL7VrOp2xe9rPDWdFMjai8CanXVxPbVDveq
         BRLXz0dv9XQzxShHVX/v3fz2vp4yz+Uwl8gISR5DPBxgKc0ENPVdxZuC3n1CSwhD25w7
         LY5bBjer/vX5B4ggS8NsSiN8ScnxKwzWgjqua43f1Zlui0jc6VWw9tDJozmDcw1T5Ecl
         m1rA==
X-Gm-Message-State: AOAM531PZk4gb5axKM+JoNSvMk+LmZYtEobAwr+w6TdGjSGv7vgp7afw
        p1Sa25jatXTZ+Iv4qBmF7BxLeB+AIbQ=
X-Google-Smtp-Source: ABdhPJzu8Ot+YFAcDFa6AYDYxYNBf3QgYbPdHpZAkjqHHDJ9ExXkEphkz89et0z+ocVTNu/44GNCnQ==
X-Received: by 2002:a17:90a:7844:: with SMTP id y4mr4738006pjl.68.1608819962297;
        Thu, 24 Dec 2020 06:26:02 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id r185sm26936351pfc.53.2020.12.24.06.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 06:26:01 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/6] bcm63xx_enet: add xmit_more support
Date:   Thu, 24 Dec 2020 22:24:18 +0800
Message-Id: <20201224142421.32350-4-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201224142421.32350-1-liew.s.piaw@gmail.com>
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support bulking hardware TX queue by using netdev_xmit_more().

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 90f8214b4d22..452968f168ed 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -633,14 +633,17 @@ bcm_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	netdev_sent_queue(dev, skb->len);
 
-	/* kick tx dma */
-	enet_dmac_writel(priv, priv->dma_chan_en_mask,
-				 ENETDMAC_CHANCFG, priv->tx_chan);
-
 	/* stop queue if no more desc available */
 	if (!priv->tx_desc_count)
 		netif_stop_queue(dev);
 
+	/* kick tx dma */
+        if (!netdev_xmit_more() || !priv->tx_desc_count)
+                enet_dmac_writel(priv, priv->dma_chan_en_mask,
+                                 ENETDMAC_CHANCFG, priv->tx_chan);
+
+
+
 	dev->stats.tx_bytes += skb->len;
 	dev->stats.tx_packets++;
 	ret = NETDEV_TX_OK;
-- 
2.17.1

