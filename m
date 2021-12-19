Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BFC479F15
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 05:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhLSEGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 23:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbhLSEGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 23:06:51 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC29C061574;
        Sat, 18 Dec 2021 20:06:51 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gj24so6033919pjb.0;
        Sat, 18 Dec 2021 20:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6E/U5iniUcywCqJbrcoGtp6XLjkIdDnXTD4rB+ab2yc=;
        b=kWzj2ouRCw/uZcU5+KHd3LH6CM3OYDPvYFq9IVes77p+RkYXQVrsKZw8yIlqBNCccy
         BSnVNyQ6IrFdeQwsu4V2EmFyQ7UMB7sO0eNrufwV+f958hKf4oINZBiwlUZXXhnp1yHY
         H2eIqx1/kmRnExcdgIqaF1O7WV1SaFMwhT6otfVv/L5FGCU2eNdspW3mfhhrzgNzV5uP
         OzhUSCz36HnXXFuG00oaUrPUMdIEDVW1p9SPNkyCOLyXNJvNf56l8d1NVhXfkQzCNdYU
         gD3S1ST5Fs2LP3w1MlbivmfF+kMhOoGhnaF/uPa0XiREyLlSr+5cpwcA0Li/gnhX9tgJ
         SwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6E/U5iniUcywCqJbrcoGtp6XLjkIdDnXTD4rB+ab2yc=;
        b=7kpCyz4E115w1MA7elXLnpUzE42tyUlonIvtLdlXLGQAOI0xws0X6wBYh/xZuvUGTk
         uLl9CgbSkEh4Ln11gPR7sQxVceLSbylzrRGmeiwTAsNYdRoCl+3Rn7f/YcwKse+cwgL1
         XLVAryZFiQHX0ai9GqSZNlGKRDrrU3HTy4RRrYbDurNuMXc3You9dKE5kQ+cQ3GLE1bz
         s0KF+9OXq7lwx8hmqhNXHkeAUiSKkboW1R1eik30OEExTy4QIJzxnsxUtJfWwHN+9Eac
         9eJBfQkontC3ZDggjHKp2hgsOOnzFRUMMhgx8QUchbk4wQPiWq90SWQBnKfQVbKd/14i
         SUhA==
X-Gm-Message-State: AOAM5312qj9NNqZnwmBIkNSot7dZWbm5KAiaZJ1Wjsn7rSYDv+Dwvpal
        H/OpEj22wz1GhxGeDC9vgt2iq6mKNWU=
X-Google-Smtp-Source: ABdhPJwCLfFMXZo6tTUDGVf31Kv1SYfrMqAS1c/boxz+cTtdoCrIYtyjw5/QlueQqbxAL6Aun4OmaA==
X-Received: by 2002:a17:90a:8914:: with SMTP id u20mr12633585pjn.98.1639886810621;
        Sat, 18 Dec 2021 20:06:50 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (c-71-198-249-153.hsd1.ca.comcast.net. [71.198.249.153])
        by smtp.gmail.com with ESMTPSA id o9sm13122186pgu.12.2021.12.18.20.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 20:06:49 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH stable 4.4] net: systemport: Add global locking for descriptor lifecycle
Date:   Sat, 18 Dec 2021 18:49:12 -0800
Message-Id: <20211219024912.18774-1-f.fainelli@gmail.com>
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
index 94f06c35ad9c..c76102754c22 100644
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
@@ -1608,6 +1612,7 @@ static int bcm_sysport_open(struct net_device *dev)
 	}
 
 	/* Initialize both hardware and software ring */
+	spin_lock_init(&priv->desc_lock);
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		ret = bcm_sysport_init_tx_ring(priv, i);
 		if (ret) {
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index e668b1ce5828..bb484c7faf67 100644
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

