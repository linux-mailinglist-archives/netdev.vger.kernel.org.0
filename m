Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A0F456AB9
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhKSHNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233324AbhKSHNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 511E161B73;
        Fri, 19 Nov 2021 07:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305844;
        bh=E3XU2HuuJLi24Zt12BsQWqaK6BCMSkPf2ME/FqpqAzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rB9vCkr8iAzFbFgw3mgNtXkRXkY8P8x2UceF5TPVoQXFaYDobOxuVMMxoSxbSppPX
         U3VG7i1IxK7bZXcSeVxkIHuy0bn4dgDjqe3Z42GCkSXvl2Qr4ImoGWNEPZzjMm9jo3
         40AoZIfv1praYkxtTMRecJUSE3+YG2Zcuc9VbHDxz7iZ4Xmk1sthf+dAzefRMpbMdH
         tbxlRy8YP/JDX5636XPcmfuAeYevgip9q7lEruYpUrr+SFpZDSJneoBuNYp3ccz3ya
         rxz5N0U005Ka/eT0IAkr+V19OWRV0i12n7XGeEBRBAp1vZJWuGhA6X+DXIgBS4LdY0
         0jmyjHH62k9OQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 13/15] apple: macmace: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:31 -0800
Message-Id: <20211119071033.3756560-14-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/apple/macmace.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/apple/macmace.c b/drivers/net/ethernet/apple/macmace.c
index 95d3061c61be..8fcaf1639920 100644
--- a/drivers/net/ethernet/apple/macmace.c
+++ b/drivers/net/ethernet/apple/macmace.c
@@ -92,7 +92,7 @@ static void mace_reset(struct net_device *dev);
 static irqreturn_t mace_interrupt(int irq, void *dev_id);
 static irqreturn_t mace_dma_intr(int irq, void *dev_id);
 static void mace_tx_timeout(struct net_device *dev, unsigned int txqueue);
-static void __mace_set_address(struct net_device *dev, void *addr);
+static void __mace_set_address(struct net_device *dev, const void *addr);
 
 /*
  * Load a receive DMA channel with a base address and ring length
@@ -197,6 +197,7 @@ static int mace_probe(struct platform_device *pdev)
 	unsigned char *addr;
 	struct net_device *dev;
 	unsigned char checksum = 0;
+	u8 macaddr[ETH_ALEN];
 	int err;
 
 	dev = alloc_etherdev(PRIV_BYTES);
@@ -229,8 +230,9 @@ static int mace_probe(struct platform_device *pdev)
 	for (j = 0; j < 6; ++j) {
 		u8 v = bitrev8(addr[j<<4]);
 		checksum ^= v;
-		dev->dev_addr[j] = v;
+		macaddr[j] = v;
 	}
+	eth_hw_addr_set(dev, macaddr);
 	for (; j < 8; ++j) {
 		checksum ^= bitrev8(addr[j<<4]);
 	}
@@ -315,11 +317,12 @@ static void mace_reset(struct net_device *dev)
  * Load the address on a mace controller.
  */
 
-static void __mace_set_address(struct net_device *dev, void *addr)
+static void __mace_set_address(struct net_device *dev, const void *addr)
 {
 	struct mace_data *mp = netdev_priv(dev);
 	volatile struct mace *mb = mp->mace;
-	unsigned char *p = addr;
+	const unsigned char *p = addr;
+	u8 macaddr[ETH_ALEN];
 	int i;
 
 	/* load up the hardware address */
@@ -331,7 +334,8 @@ static void __mace_set_address(struct net_device *dev, void *addr)
 			;
 	}
 	for (i = 0; i < 6; ++i)
-		mb->padr = dev->dev_addr[i] = p[i];
+		mb->padr = macaddr[i] = p[i];
+	eth_hw_addr_set(dev, macaddr);
 	if (mp->chipid != BROKEN_ADDRCHG_REV)
 		mb->iac = 0;
 }
-- 
2.31.1

