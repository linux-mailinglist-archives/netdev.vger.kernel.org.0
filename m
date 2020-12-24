Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEEB2E27A7
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 15:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgLXO0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 09:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgLXO0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 09:26:39 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B759FC0617A7;
        Thu, 24 Dec 2020 06:25:59 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id d2so1306922pfq.5;
        Thu, 24 Dec 2020 06:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W6/+FtIew+DXRW3+N/9J9qYZ49HugSJ5H2PNvgyUorQ=;
        b=BlAw9L/THAbK3gaynjVqpc+xMoWbIqbMESC9F24u+T/5j3g1AnSW1/TLieDU0AsqV8
         Zu72Nkpvaswp0dVGj4aESVa3bbZL5qwB2+CbGL6O6xzXtspDwHxHVSexZ2b3+JC93ky7
         X7dV15DilA/MfzOjQSL4oBMHv/bpTqRlpI221gZT22z42r8DoJQ4Zs098VJC8ykmk1mh
         h2FAZGpvzNIMw158sBkeb8fM19EScx8KC2QYjPe+4ywac2BR9ji0h7YOPcwbHwcy6Y06
         hirzP3D3mCYWcrE41CloLfPXjdymPMcnMZ6rof+DPY3GY4M29EUrsNXHknbeGIMhOHtp
         hbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W6/+FtIew+DXRW3+N/9J9qYZ49HugSJ5H2PNvgyUorQ=;
        b=HATxsqM+KTKj0kWP4hVOfEMlUS5WhSZmzNWMD6ssO61aiXho8WfQuvHTQ1B3PXR0GL
         fmQGprDeAyjQyKY25rjErljnEpZbZtIBK7xFGfO+9dAtiEUl6CkzZA/kmsnoe9BItcTd
         APhWr/qeGnIaaI32hc2jszvJEWfyefS0+fBGoQawOwwkhA1dadD5kFiCTvwHtcu9WQtW
         5dj+oogoCe4umWAoZepVVS3WKHzxZrZDZQUqhGakhNfpOV4tk9Hy8LVdaYKFYK9XYRjb
         L9OVVgJF5jMXJ8Gs5L6pPNLRhnEHRN3SbruQcA3tI0zvlModIyMQ27GtQm/TtOHbxvJY
         XtjA==
X-Gm-Message-State: AOAM530PhVd1lAu/01W2oZXD9cdcXhyQ3HLfufJfMEtY9ToRADmiDaIv
        2NN3hCxCMLOTkF8p8SxEoSw=
X-Google-Smtp-Source: ABdhPJwD23ZszShDda46K8utLRcxeEl4xqOAR5CZs8xZmNX9PlvzP5zuvm+UxwJxz+MBluRswSbelg==
X-Received: by 2002:a62:764a:0:b029:19d:9fa8:5bc6 with SMTP id r71-20020a62764a0000b029019d9fa85bc6mr27433865pfc.76.1608819959335;
        Thu, 24 Dec 2020 06:25:59 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id r185sm26936351pfc.53.2020.12.24.06.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 06:25:58 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/6] bcm63xx_enet: add BQL support
Date:   Thu, 24 Dec 2020 22:24:17 +0800
Message-Id: <20201224142421.32350-3-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201224142421.32350-1-liew.s.piaw@gmail.com>
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Byte Queue Limits support to reduce/remove bufferbloat in
bcm63xx_enet.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index b82b7805c36a..90f8214b4d22 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -417,9 +417,11 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 static int bcm_enet_tx_reclaim(struct net_device *dev, int force)
 {
 	struct bcm_enet_priv *priv;
+	unsigned int bytes;
 	int released;
 
 	priv = netdev_priv(dev);
+	bytes = 0;
 	released = 0;
 
 	while (priv->tx_desc_count < priv->tx_ring_size) {
@@ -456,10 +458,13 @@ static int bcm_enet_tx_reclaim(struct net_device *dev, int force)
 		if (desc->len_stat & DMADESC_UNDER_MASK)
 			dev->stats.tx_errors++;
 
+		bytes += skb->len;
 		dev_kfree_skb(skb);
 		released++;
 	}
 
+	netdev_completed_queue(dev, released, bytes);
+
 	if (netif_queue_stopped(dev) && released)
 		netif_wake_queue(dev);
 
@@ -626,6 +631,8 @@ bcm_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	desc->len_stat = len_stat;
 	wmb();
 
+	netdev_sent_queue(dev, skb->len);
+
 	/* kick tx dma */
 	enet_dmac_writel(priv, priv->dma_chan_en_mask,
 				 ENETDMAC_CHANCFG, priv->tx_chan);
@@ -1169,6 +1176,7 @@ static int bcm_enet_stop(struct net_device *dev)
 	kdev = &priv->pdev->dev;
 
 	netif_stop_queue(dev);
+	netdev_reset_queue(dev);
 	napi_disable(&priv->napi);
 	if (priv->has_phy)
 		phy_stop(dev->phydev);
@@ -2338,6 +2346,7 @@ static int bcm_enetsw_stop(struct net_device *dev)
 
 	del_timer_sync(&priv->swphy_poll);
 	netif_stop_queue(dev);
+	netdev_reset_queue(dev);
 	napi_disable(&priv->napi);
 	del_timer_sync(&priv->rx_timeout);
 
-- 
2.17.1

