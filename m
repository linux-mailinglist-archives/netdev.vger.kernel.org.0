Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C8747632B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 21:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbhLOUY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 15:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbhLOUY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 15:24:56 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDDCC061574;
        Wed, 15 Dec 2021 12:24:56 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id f11so23918pfc.9;
        Wed, 15 Dec 2021 12:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aQsIra73/x88GR1KtCmaf/z2BjHJdIeNO56pE9+Q+NI=;
        b=obESI4k11QInt55Yl8KhxPfxoa8YfxniAXIohBgTdbbKvHpkycJMEcxciMnOgv1XZl
         keA9bPaBizdqyUocB3Oi7qALuC+U/xlQ69xW9AcjH7qT45QqBYPZjCwxClS63W93bQcM
         d8q0RZMg4yXkv3xL6IQt8wcdoFTUF1s+VjLJxZDb57XQ3gmjrGEiRiybdRnuDCZVpYKs
         v4p6lj4sZTzTOtM17aHy0BhY/WdQW/StAH8xi28Mcjbn275L1i/bhjAnw0+wFR3Kp+rC
         OGZ9n4ci8Hcp7a7/z0/bM//PZpcJ/UPU4fAU56rCHwK8TgglCBI5wvWbh4eLy9HjcxLD
         6r+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aQsIra73/x88GR1KtCmaf/z2BjHJdIeNO56pE9+Q+NI=;
        b=pVLdohAaOhtsmN9CDRu/y0Jqk0iZzDH+RHdDseXvni/7hsBOkFzrw1N/9Ebx2lH1pY
         HMh2lXGWG7jb9nZDPpDXqPEA1m/kNYHCD3ZqI5y/QSep1RscCcbBROOq+hJWmvl3UhKj
         sXYhgRXbyfPmHgnIm64GmiCStfBMmwRBCvp/iGPz/cCajYWp/l+d5YSeThwR3JxpSNF/
         RhMcl7+3Ov+MTkTrdb4yABSBiDHVRn4hu2oGOS6Y4StEJo1H5NuJOmfyZo3g4SuNDWsr
         6lvYyBtfl4nfPNi6s8aZiSIR36RLPzE/6qyA1KbkW7ePddt9Zw/9TNk7dWDBSyX0AYhv
         4D8A==
X-Gm-Message-State: AOAM533UUXEViHI8n/fqz81x+YErEQb0e84dLnxM2TSELA4E0fsSX0NR
        +hSB5cw+giAudMeZRmFJgJWP7Jo2w/0=
X-Google-Smtp-Source: ABdhPJyPWKjqw8D/5KJS0JAYGh+25/9nlfyItg5JEhRCrRRvgv0MPmLLD96/grCfeY8Wo/EXshFjGg==
X-Received: by 2002:a63:6c48:: with SMTP id h69mr9002848pgc.603.1639599895582;
        Wed, 15 Dec 2021 12:24:55 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c18sm3812049pfl.201.2021.12.15.12.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 12:24:55 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM SYSTEMPORT
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: systemport: Add global locking for descriptor lifecycle
Date:   Wed, 15 Dec 2021 12:24:49 -0800
Message-Id: <20211215202450.4086240-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The descriptor list is a shared resource across all of the transmit queues, and
the locking mechanism used today only protects concurrency across a given
transmit queue between the transmit and reclaiming. This creates an opportunity
for the SYSTEMPORT hardware to work on corrupted descriptors if we have
multiple producers at once which is the case when using multiple transmit
queues.

This was particularly noticeable when using multiple flows/transmit queues and
it showed up in interesting ways in that UDP packets would get a correct UDP
header checksum being calculated over an incorrect packet length. Similarly TCP
packets would get an equally correct checksum computed by the hardware over an
incorrect packet length.

The SYSTEMPORT hardware maintains an internal descriptor list that it re-arranges
when the driver produces a new descriptor anytime it writes to the
WRITE_PORT_{HI,LO} registers, there is however some delay in the hardware to
re-organize its descriptors and it is possible that concurrent TX queues
eventually break this internal allocation scheme to the point where the
length/status part of the descriptor gets used for an incorrect data buffer.

The fix is to impose a global serialization for all TX queues in the short
section where we are writing to the WRITE_PORT_{HI,LO} registers which solves
the corruption even with multiple concurrent TX queues being used.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 5 ++++-
 drivers/net/ethernet/broadcom/bcmsysport.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 40933bf5a710..60dde29974bf 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1309,11 +1309,11 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	struct device *kdev = &priv->pdev->dev;
 	struct bcm_sysport_tx_ring *ring;
+	unsigned long flags, desc_flags;
 	struct bcm_sysport_cb *cb;
 	struct netdev_queue *txq;
 	u32 len_status, addr_lo;
 	unsigned int skb_len;
-	unsigned long flags;
 	dma_addr_t mapping;
 	u16 queue;
 	int ret;
@@ -1373,8 +1373,10 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
 	ring->desc_count--;
 
 	/* Ports are latched, so write upper address first */
+	spin_lock_irqsave(&priv->desc_lock, desc_flags);
 	tdma_writel(priv, len_status, TDMA_WRITE_PORT_HI(ring->index));
 	tdma_writel(priv, addr_lo, TDMA_WRITE_PORT_LO(ring->index));
+	spin_unlock_irqrestore(&priv->desc_lock, desc_flags);
 
 	/* Check ring space and update SW control flow */
 	if (ring->desc_count == 0)
@@ -2013,6 +2015,7 @@ static int bcm_sysport_open(struct net_device *dev)
 	}
 
 	/* Initialize both hardware and software ring */
+	spin_lock_init(&priv->desc_lock);
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		ret = bcm_sysport_init_tx_ring(priv, i);
 		if (ret) {
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 984f76e74b43..16b73bb9acc7 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -711,6 +711,7 @@ struct bcm_sysport_priv {
 	int			wol_irq;
 
 	/* Transmit rings */
+	spinlock_t		desc_lock;
 	struct bcm_sysport_tx_ring *tx_rings;
 
 	/* Receive queue */
-- 
2.25.1

