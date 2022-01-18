Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0C491779
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344482AbiARCl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346051AbiARChc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:37:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FE3C061747;
        Mon, 17 Jan 2022 18:34:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3337A60A6B;
        Tue, 18 Jan 2022 02:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E096EC36AEB;
        Tue, 18 Jan 2022 02:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473250;
        bh=HUX8zC8VUF7r0QnJ6B/WpuRDXY8O4kCl6za7Ycf6cyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ut+gy4HW6HeXi64f7RjzUZbguzQ4zkcdKGp7c+PDlBtwD1xTQFCtBYFDMWk7rpJyL
         SMqhCt04TC1Gk9cHxGNbDWJKLjyVRSa9N4+uHIcGMj+RKhnA4mbyzWTwdnyzDrnkl5
         z3itusr9AHDAdG5zOAsbJFsT1WNTI4l+92LUin5ICGNIjizCuBrkoAm5GXT31+4U+b
         OrV6Rcruz3OZIB8darkGSk3vRTOqPXHFjXqnCQik7qGzvFNwMGJfOAZdhyxhhhW+BQ
         V53YT1Z+P8iE2XUCWEbafJaMziqfN5KcO+koaY/dbzNm7x1VikFGeYOxK9rywkMXWJ
         0ekrceXq3vpbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 040/188] apple: macmace: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:29:24 -0500
Message-Id: <20220118023152.1948105-40-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e217fc4affc8c7392e4db48488b36d2a5d446e9d ]

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apple/macmace.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/apple/macmace.c b/drivers/net/ethernet/apple/macmace.c
index 95d3061c61be9..8fcaf16399201 100644
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
2.34.1

