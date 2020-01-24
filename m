Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E532B149235
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 00:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387449AbgAXX7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 18:59:37 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41116 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729236AbgAXX7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 18:59:37 -0500
Received: by mail-pg1-f196.google.com with SMTP id x8so1924508pgk.8;
        Fri, 24 Jan 2020 15:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JUzqmVJFhWwG8HFditFQcO6aapkFWx5TjN8Oa2FhIrM=;
        b=F1e/egivRVdyTOIgkP8CkoPKuL7Q9M71wcKl7ClErYRfa1GDI9I76QTYf+ygljM75L
         A4p4dRCsSEsvQJWuYZfpg1sG5Epv1ehn08bNXuaY6ViHLqURPQ06NVfs3acqN6+CnlnF
         IskPUTPnGZQFmutMrOCI0T/c1mXlEQ38PK2e6XvWc7Mq60VR9Kimi40c+490PF7gB4Qo
         dCRNpPR7y/0YWyr5hjJcc6ibw2rY/GMTjJjbMsPf+8s9i0/vFjamNYA3iqAyIRBhE/uk
         nBmMoGoqF+pNZUd9xka3D5vpEB4TcVXDqmcYWzAyRd7MTBImqzHkX4qM5Xkwkxz2nnJ8
         8rXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JUzqmVJFhWwG8HFditFQcO6aapkFWx5TjN8Oa2FhIrM=;
        b=SOgKuXsdAlOR1u9MfucYhkrBDmi/l0xCQ8OK3MDdz5YIJlGaAmCpg5QJLJ4eI2Rgki
         ua/xbSMctwlP7dTk9zjzDiRM1UMT6sEiBVT8ujXPswhHmgAKer3NesvLSvuJp/UlZePV
         ck6E/l3vc2v+U7amNLImEm+DDOJdDYdUbeHg2Zqq1ZZp2KEaimSIy5A2nwl8llSGi7bu
         m2qNCgLAk/a8VS3wwCNDHPIP/0k0B9XVQScG8DM89y100BS5OCVhd88YIdBoaUkOEKjX
         mmiIt8PPWi3njm54918yLZmCC4XmLM2fXFhvWWLeTWFJ8JyM0t8eMKjPi5vC9cJKU6y0
         Fjyw==
X-Gm-Message-State: APjAAAU1Xmhxr0lQMwuROYWGR2242MuJ1A1LX00kR2km3Bk0kPqDdxYj
        ox1iZ/rlEd/tEnuvMnigxAKP+jQ9
X-Google-Smtp-Source: APXvYqxvCowj6sS9W6qTOnidLRAzEdDePooYHcIK4YgYovq0XHgK1Ppz4ODLY66MbvlKJVmFxzAG3A==
X-Received: by 2002:a62:1bc5:: with SMTP id b188mr5698687pfb.113.1579910375806;
        Fri, 24 Jan 2020 15:59:35 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l9sm7407244pgh.34.2020.01.24.15.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 15:59:35 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, edumazet@google.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM SYSTEMPORT
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: systemport: Do not block interrupts in TX reclaim
Date:   Fri, 24 Jan 2020 15:59:30 -0800
Message-Id: <20200124235930.640-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to disable interrupts with a spin_lock_irqsave() in
bcm_sysport_tx_poll() since we are in softIRQ context already. Leave
interrupts enabled, thus giving a chance for the RX interrupts to be
processed.

This now makes bcm_sysport_tx_reclaim() equivalent to
bcm_sysport_tx_clean(), thus remove the former, and make
bcm_sysport_tx_reclaim_all() to use the latter.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 30 ++++++----------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index f07ac0e0af59..dfff0657ce8f 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -925,26 +925,6 @@ static unsigned int __bcm_sysport_tx_reclaim(struct bcm_sysport_priv *priv,
 	return pkts_compl;
 }
 
-/* Locked version of the per-ring TX reclaim routine */
-static unsigned int bcm_sysport_tx_reclaim(struct bcm_sysport_priv *priv,
-					   struct bcm_sysport_tx_ring *ring)
-{
-	struct netdev_queue *txq;
-	unsigned int released;
-	unsigned long flags;
-
-	txq = netdev_get_tx_queue(priv->netdev, ring->index);
-
-	spin_lock_irqsave(&ring->lock, flags);
-	released = __bcm_sysport_tx_reclaim(priv, ring);
-	if (released)
-		netif_tx_wake_queue(txq);
-
-	spin_unlock_irqrestore(&ring->lock, flags);
-
-	return released;
-}
-
 /* Locked version of the per-ring TX reclaim, but does not wake the queue */
 static void bcm_sysport_tx_clean(struct bcm_sysport_priv *priv,
 				 struct bcm_sysport_tx_ring *ring)
@@ -960,9 +940,15 @@ static int bcm_sysport_tx_poll(struct napi_struct *napi, int budget)
 {
 	struct bcm_sysport_tx_ring *ring =
 		container_of(napi, struct bcm_sysport_tx_ring, napi);
+	struct bcm_sysport_priv *priv = ring->priv;
 	unsigned int work_done = 0;
 
-	work_done = bcm_sysport_tx_reclaim(ring->priv, ring);
+	spin_lock(&ring->lock);
+	work_done = __bcm_sysport_tx_reclaim(priv, ring);
+	if (work_done)
+		netif_tx_wake_queue(netdev_get_tx_queue(priv->netdev,
+							ring->index));
+	spin_unlock(&ring->lock);
 
 	if (work_done == 0) {
 		napi_complete(napi);
@@ -984,7 +970,7 @@ static void bcm_sysport_tx_reclaim_all(struct bcm_sysport_priv *priv)
 	unsigned int q;
 
 	for (q = 0; q < priv->netdev->num_tx_queues; q++)
-		bcm_sysport_tx_reclaim(priv, &priv->tx_rings[q]);
+		bcm_sysport_tx_clean(priv, &priv->tx_rings[q]);
 }
 
 static int bcm_sysport_poll(struct napi_struct *napi, int budget)
-- 
2.17.1

