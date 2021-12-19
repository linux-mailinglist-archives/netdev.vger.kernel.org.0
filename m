Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE581479F17
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 05:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbhLSEGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 23:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbhLSEGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 23:06:55 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C80FC06173E;
        Sat, 18 Dec 2021 20:06:55 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p18so5283779pld.13;
        Sat, 18 Dec 2021 20:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/P3EFPZBJVQEBZkUjmtwDarVt2254Pzb7CyVzWf8b6U=;
        b=NdRagsE7Kdfm68/1xV4Py1wKIfHdBdz+FexoeRKlnH79nxoUI9DF+iDyWkVvKcoeKR
         GIl6rUuFyMvKhkexB/rzwmoFPnLaNXmG2L8/RrcxPTSqSiJFrpJguk2lCFKbtKlC8ROx
         BUa8I1qGDqZS4Gnxm4nZyvj8A/bVLe1eYgChZC823Cr4zbf2KwlWCl1WPTrRRMUuu4P6
         ySpA7OTazM9yEeRGxOm+iy/C++M96QTrYgX+gjWDHfOvtJI/2FBmNahLHZIhE1y3sLJ7
         TVr7BAIjaclL+7Qy7Fwt2YTt37+3qVxpv3jirbizJIMaF+R/YwyRukMCWW5enN/llh5S
         kCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/P3EFPZBJVQEBZkUjmtwDarVt2254Pzb7CyVzWf8b6U=;
        b=rU194Z0ted63Ry9lVpUgev/l2p9GkCwMBi8xbY7d8RAR3chLkagnS+8R7KDtWyoNt7
         xBeU0MIw51l9jI6DHWLUVvSdcyHbd0Vv4mlPrMiuyDnZdV6mvekYczuAl/MAFLbZyheG
         g1x3WRKGsY5MuIeCIIqh7hR0g5ID9LF09AlvWyC3VUuN7Wm/5Ea+1B7ljWJSVb+yCyXC
         /HfxWd6ovKF+2waBpsnxtB4yjGAHMHsdGUM2ZV/eU+NrNXNf9x5wHy1zaImX7qp/frI+
         c7Cbzbs4mDrWLP1J2v1HOQwD6aD5ePCCq2yoFGOVB2tskF1kSQJX88J2QLGhknJcXWfm
         v4Fg==
X-Gm-Message-State: AOAM531rUqclzZEvDGIYnqxY5/q4NMRDs/dqNP3SsZ0OdRFLKswZm1T6
        H1o/wbAebJLl6iokt9dadhXjY3qHkOQ=
X-Google-Smtp-Source: ABdhPJyHE+70jLIYTFcZ9PboulE4nV3ykgOKMLDY2giiJEio8FpSc8dUJG56Vw1JXObQYtJJUikZFw==
X-Received: by 2002:a17:902:ea02:b0:149:927:7e66 with SMTP id s2-20020a170902ea0200b0014909277e66mr686218plg.70.1639886814255;
        Sat, 18 Dec 2021 20:06:54 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (c-71-198-249-153.hsd1.ca.comcast.net. [71.198.249.153])
        by smtp.gmail.com with ESMTPSA id k2sm12306297pgh.11.2021.12.18.20.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 20:06:53 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH stable 4.9] net: systemport: Add global locking for descriptor lifecycle
Date:   Sat, 18 Dec 2021 18:49:17 -0800
Message-Id: <20211219024917.18828-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 8b8e6e782456f1ce02a7ae914bbd5b1053f0b034 upstream

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
Link: https://lore.kernel.org/r/20211215202450.4086240-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 5 +++++
 drivers/net/ethernet/broadcom/bcmsysport.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 5d67dbdd943d..98392a069f2b 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -90,9 +90,13 @@ static inline void tdma_port_write_desc_addr(struct bcm_sysport_priv *priv,
 					     struct dma_desc *desc,
 					     unsigned int port)
 {
+	unsigned long desc_flags;
+
 	/* Ports are latched, so write upper address first */
+	spin_lock_irqsave(&priv->desc_lock, desc_flags);
 	tdma_writel(priv, desc->addr_status_len, TDMA_WRITE_PORT_HI(port));
 	tdma_writel(priv, desc->addr_lo, TDMA_WRITE_PORT_LO(port));
+	spin_unlock_irqrestore(&priv->desc_lock, desc_flags);
 }
 
 /* Ethtool operations */
@@ -1587,6 +1591,7 @@ static int bcm_sysport_open(struct net_device *dev)
 	}
 
 	/* Initialize both hardware and software ring */
+	spin_lock_init(&priv->desc_lock);
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		ret = bcm_sysport_init_tx_ring(priv, i);
 		if (ret) {
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 0d3444f1d78a..1cf5af2b11e1 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -660,6 +660,7 @@ struct bcm_sysport_priv {
 	int			wol_irq;
 
 	/* Transmit rings */
+	spinlock_t		desc_lock;
 	struct bcm_sysport_tx_ring tx_rings[TDMA_NUM_RINGS];
 
 	/* Receive queue */
-- 
2.25.1

