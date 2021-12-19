Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A23479F19
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 05:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbhLSEHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 23:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbhLSEG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 23:06:59 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B475EC061574;
        Sat, 18 Dec 2021 20:06:59 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id y9so6086982pgj.5;
        Sat, 18 Dec 2021 20:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5UCrbeZE0/Q22/WjPe0zTQJA5Vl3xT8+2urtxw69CMo=;
        b=pwFfC1srCoFN/pFdkbi/l5g4DRPh7Ar4EOLxoG6aX30BxOBMpA+6Ay4K5TjznD87W3
         NEyvRZrqBQwgayoCtSubcH6bghNSgZi+ENlAaua475x0i/ZoBw5sE2sjM81RkjYzmLKF
         XaIbARqk/vt/XZl4Ndc4V6zrajRXFxWntCdsBNsksS/KfdKowPdNppG+iibQxmHu2c7b
         Xy4+JgyEtQ30yrgxYKDPwomWeHoszaHrXQUxn7fNQ/wwVfCWl7gzMJpkvzmaaJWgfXXr
         Y85Owk7+Xt7s3IhSgNOSO1G5tpgJXW4cdF0cHhCfs6fxdOYRk4FaR5Z5sWoVRBxNiaN5
         KHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5UCrbeZE0/Q22/WjPe0zTQJA5Vl3xT8+2urtxw69CMo=;
        b=vQ73AhtTVZOBWJ2KMwCAp90XT/uIUiUHze/k7kCCRzVLaYoF9kSzUZw26ybNDABE30
         D4TIoD3MaFsO3ieGudd4TKuqy7UFbS9P9QLstiyqE/JesjHnOJKKUX+951cZr6/AWAC7
         q1NZDPBu1xmOHDzyu2QDqLBZrsI439b7SoPGrZnJGSa6Q3qU1ZWPpII0trdPqBR/mGXp
         ycrZ5kiAf4PEmzf11R3/+Dv01ZxVg/V9H6ck3+dp9uv1bVxvNpK26yJowaiEXsNcYjwI
         BE5Pp6BrJJIlECjVDSnmcMdO8SO6DmA4VcwXspmQXzAM+heC4qyKnC1LGnm20uCRQF3U
         7IKg==
X-Gm-Message-State: AOAM5320iQ85PndfGMfdGx44fzD7JKLspTD81gE/OUV7YH7hV76ERhoI
        Tzq5vYo0ISORrEzaMIa1zKRiSb5EXyQ=
X-Google-Smtp-Source: ABdhPJzUs2XJepkVfHFJCtEGlC4ogdLw1FSHq8+RTTREBa8o61HfpnsG3nmp2mvxO8DDpnIRhj2kQw==
X-Received: by 2002:a05:6a00:2181:b0:4a7:ed1f:c5ba with SMTP id h1-20020a056a00218100b004a7ed1fc5bamr10277438pfi.2.1639886818862;
        Sat, 18 Dec 2021 20:06:58 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (c-71-198-249-153.hsd1.ca.comcast.net. [71.198.249.153])
        by smtp.gmail.com with ESMTPSA id u71sm12325252pgd.68.2021.12.18.20.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 20:06:58 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH stable 4.14] net: systemport: Add global locking for descriptor lifecycle
Date:   Sat, 18 Dec 2021 18:49:20 -0800
Message-Id: <20211219024920.18882-1-f.fainelli@gmail.com>
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
index 0083e2a52a30..576381ee757d 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -120,9 +120,13 @@ static inline void tdma_port_write_desc_addr(struct bcm_sysport_priv *priv,
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
@@ -1880,6 +1884,7 @@ static int bcm_sysport_open(struct net_device *dev)
 	}
 
 	/* Initialize both hardware and software ring */
+	spin_lock_init(&priv->desc_lock);
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		ret = bcm_sysport_init_tx_ring(priv, i);
 		if (ret) {
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 3df4a48b8eac..de2c7a6b3cd2 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -733,6 +733,7 @@ struct bcm_sysport_priv {
 	int			wol_irq;
 
 	/* Transmit rings */
+	spinlock_t		desc_lock;
 	struct bcm_sysport_tx_ring *tx_rings;
 
 	/* Receive queue */
-- 
2.25.1

