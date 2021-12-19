Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E583C479F1B
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 05:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbhLSEHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 23:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhLSEHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 23:07:03 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51078C061574;
        Sat, 18 Dec 2021 20:07:03 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id co15so6003804pjb.2;
        Sat, 18 Dec 2021 20:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zre9SQkvE3qSf/HrwAKjDc8PrWTsuqt4cqMd+Uqk3EY=;
        b=QAovIdj/SwLgKoStCx1kuud/1kxsjyOVXs1xNSMbVX9jB4NwQX30kJIt8b1DaJzAMQ
         gXeBtGZRfKcc/hvyg42N3+jh40l5kg3rBfDZr/cdpEJgnYI309L2bZuiqKtecS2Uyjfe
         hf1ZVKispDZynOue+kAjuHMoMCV8ZWV0IORqH04UEfISZwt0Y82iU2cXygUIlvVixHw0
         X15+GGfXytLeKmRfEMHuJsZJ9eQvA7h8XeYv4vUSjjwh3gkGCatfNeLnccPd5jsI1W1V
         nl+rmVdiPxcuxjlGhOqeSemiiJdrue1ri9BEFe+5u/Bw5/YYhLc2p/8pOt7JiCVoq082
         HkIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zre9SQkvE3qSf/HrwAKjDc8PrWTsuqt4cqMd+Uqk3EY=;
        b=Ske96XcqfWeJXloMq9jE6mdcalB2fOifbw02Ilzrcc4gJahV3hFI7VIy7mAbOSCc/o
         QP60E4wv0dxqF8fkpX3sfxvIh/4i5tWmrt5EDgLvY80yMSeFQrp7vIAeYMixDuBuPVNs
         /f7kWh0+hmXNsimJDSekiyLnRn420EFfPX0Aoj2mE+sVYfK607suuNkkvTH4cb7APCR9
         W9gjx7fCpIWl65qb+q5Hv912y970YdcE3wRGJiHTqONj4h82seIXW2tOq2Q2HcE1SGRd
         UQqfZbntJZ59TtJYjhO5bLABhswFuyQ0/SQjxXp3RWLkxSNF/8Ahwkh77DVX5xd5Zl9Z
         lcvQ==
X-Gm-Message-State: AOAM531MN3gbBQx8/37nLSX1zFbOWD431tVWYrnLbFf6XAI1mzXLJw6/
        QizAhOu3xGjLltSMSRMyAjE/apGzt7M=
X-Google-Smtp-Source: ABdhPJwwoSXjNao6Cl3y7QHAUVgAKM6Zy1TwfDFPxgVbkszphIvvuvYp4tey/MOoUybJ2T2JidY4yQ==
X-Received: by 2002:a17:90b:20b:: with SMTP id fy11mr14454878pjb.238.1639886822467;
        Sat, 18 Dec 2021 20:07:02 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (c-71-198-249-153.hsd1.ca.comcast.net. [71.198.249.153])
        by smtp.gmail.com with ESMTPSA id y32sm3691100pfa.92.2021.12.18.20.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 20:07:01 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH stable 4.19] net: systemport: Add global locking for descriptor lifecycle
Date:   Sat, 18 Dec 2021 18:49:25 -0800
Message-Id: <20211219024925.18936-1-f.fainelli@gmail.com>
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
index 0c69becc3c17..b3fc8745b580 100644
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
@@ -2003,6 +2007,7 @@ static int bcm_sysport_open(struct net_device *dev)
 	}
 
 	/* Initialize both hardware and software ring */
+	spin_lock_init(&priv->desc_lock);
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		ret = bcm_sysport_init_tx_ring(priv, i);
 		if (ret) {
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 36e0adf5c9b8..f438b818136a 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -751,6 +751,7 @@ struct bcm_sysport_priv {
 	int			wol_irq;
 
 	/* Transmit rings */
+	spinlock_t		desc_lock;
 	struct bcm_sysport_tx_ring *tx_rings;
 
 	/* Receive queue */
-- 
2.25.1

