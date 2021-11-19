Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9967456AB8
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhKSHNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233493AbhKSHNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA96761B5E;
        Fri, 19 Nov 2021 07:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305845;
        bh=IPa1j6acNy/IFZjVNdu9xmAb8Y/yONlZ9wrGPSKBF0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ho0tLNS01d+hv3mo4Ih51Aut0vpj+UkE13URziHnFS4Gg3ibxThAVhkV9iGAhRiH0
         /o+A/YgCttvCm42VpY/rn4hu9edlVWGbF1x9cajlR4EMD4sRFBPeFDyd4y1goy7RDX
         09PcJqF9uyo0xtvTz3eHTe0qruX5s5LHN7LcCA7tzYrFuepLISlR5beDw8hq4/5AtZ
         lW2MFQCuvsLvqP02eWl6Ivdq7PKtUWXMWT+X10Q0Z8uHkWSPbXDTtNhgwEm/u+oOLu
         VIfQxWSzw3PZr/XWKU1zCyK7T9jpo8yf3ltq3ZEVUy1Mm9ylL+fLRbmsnzzt8Vyswy
         GFr561cwaHmjQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 15/15] natsemi: macsonic: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:33 -0800
Message-Id: <20211119071033.3756560-16-kuba@kernel.org>
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
 drivers/net/ethernet/natsemi/macsonic.c | 27 ++++++++++++++++---------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index 8709d700e15a..b16f7c830f9b 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -203,6 +203,7 @@ static void mac_onboard_sonic_ethernet_addr(struct net_device *dev)
 	struct sonic_local *lp = netdev_priv(dev);
 	const int prom_addr = ONBOARD_SONIC_PROM_BASE;
 	unsigned short val;
+	u8 addr[ETH_ALEN];
 
 	/*
 	 * On NuBus boards we can sometimes look in the ROM resources.
@@ -213,7 +214,8 @@ static void mac_onboard_sonic_ethernet_addr(struct net_device *dev)
 		int i;
 
 		for (i = 0; i < 6; i++)
-			dev->dev_addr[i] = SONIC_READ_PROM(i);
+			addr[i] = SONIC_READ_PROM(i);
+		eth_hw_addr_set(dev, addr);
 		if (!INVALID_MAC(dev->dev_addr))
 			return;
 
@@ -222,7 +224,8 @@ static void mac_onboard_sonic_ethernet_addr(struct net_device *dev)
 		 * source has a rather long and detailed historical account of
 		 * why this is so.
 		 */
-		bit_reverse_addr(dev->dev_addr);
+		bit_reverse_addr(addr);
+		eth_hw_addr_set(dev, addr);
 		if (!INVALID_MAC(dev->dev_addr))
 			return;
 
@@ -243,14 +246,15 @@ static void mac_onboard_sonic_ethernet_addr(struct net_device *dev)
 	SONIC_WRITE(SONIC_CEP, 15);
 
 	val = SONIC_READ(SONIC_CAP2);
-	dev->dev_addr[5] = val >> 8;
-	dev->dev_addr[4] = val & 0xff;
+	addr[5] = val >> 8;
+	addr[4] = val & 0xff;
 	val = SONIC_READ(SONIC_CAP1);
-	dev->dev_addr[3] = val >> 8;
-	dev->dev_addr[2] = val & 0xff;
+	addr[3] = val >> 8;
+	addr[2] = val & 0xff;
 	val = SONIC_READ(SONIC_CAP0);
-	dev->dev_addr[1] = val >> 8;
-	dev->dev_addr[0] = val & 0xff;
+	addr[1] = val >> 8;
+	addr[0] = val & 0xff;
+	eth_hw_addr_set(dev, addr);
 
 	if (!INVALID_MAC(dev->dev_addr))
 		return;
@@ -355,13 +359,16 @@ static int mac_onboard_sonic_probe(struct net_device *dev)
 static int mac_sonic_nubus_ethernet_addr(struct net_device *dev,
 					 unsigned long prom_addr, int id)
 {
+	u8 addr[ETH_ALEN];
 	int i;
+
 	for(i = 0; i < 6; i++)
-		dev->dev_addr[i] = SONIC_READ_PROM(i);
+		addr[i] = SONIC_READ_PROM(i);
 
 	/* Some of the addresses are bit-reversed */
 	if (id != MACSONIC_DAYNA)
-		bit_reverse_addr(dev->dev_addr);
+		bit_reverse_addr(addr);
+	eth_hw_addr_set(dev, addr);
 
 	return 0;
 }
-- 
2.31.1

