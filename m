Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E000491CAC
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348793AbiARDRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351866AbiARDIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:08:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114D0C0611DA;
        Mon, 17 Jan 2022 18:49:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61F22612E8;
        Tue, 18 Jan 2022 02:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D909C36AE3;
        Tue, 18 Jan 2022 02:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474166;
        bh=4k/SKNSsGbjCuaZEpGz13QvUt/XSg1eJ9l2IVsHUGmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N25sxPXL8Q33FtuHijTobwkNJLobDzYrnXXp1pqttZEwEzeANl0935O4pcOm+qy91
         S2Jy7i52OYdAad48TyQIxLK+90HrZVwaRhGS8rh/fjY8mFlC8cwdCWSDaMjcRYg29U
         p9/zUe5Y9tamS3iVL3Rve8Dq9MXX2PnNIkA18bAdcI3SBBlOx28AEvo8hOdrOS3KiT
         C7ajgiUSdhOmjZ6BXfiuFS3ysHxhf4AcYy/Fqiu167l3dxE3qaRpn43xK74mziCuVW
         cNeHTqrZj63yOJfNGPlJJT0nBF5bWL4aNY2Mv+725AYrgD+4nixWziu/DsDYx8w1Yi
         DXaseKpo2/dFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/56] amd: a2065/ariadne: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:48:18 -0500
Message-Id: <20220118024908.1953673-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 285e4c664d6461b175b4613fc77126b5006a1912 ]

dev_addr is initialized byte by byte from series.

Fixes build on x86 (32bit).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/a2065.c   | 18 ++++++++++--------
 drivers/net/ethernet/amd/ariadne.c | 20 +++++++++++---------
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/amd/a2065.c b/drivers/net/ethernet/amd/a2065.c
index e22f976a0d185..9b224f0d5f435 100644
--- a/drivers/net/ethernet/amd/a2065.c
+++ b/drivers/net/ethernet/amd/a2065.c
@@ -677,6 +677,7 @@ static int a2065_init_one(struct zorro_dev *z,
 	unsigned long base_addr = board + A2065_LANCE;
 	unsigned long mem_start = board + A2065_RAM;
 	struct resource *r1, *r2;
+	u8 addr[ETH_ALEN];
 	u32 serial;
 	int err;
 
@@ -703,17 +704,18 @@ static int a2065_init_one(struct zorro_dev *z,
 	r2->name = dev->name;
 
 	serial = be32_to_cpu(z->rom.er_SerialNumber);
-	dev->dev_addr[0] = 0x00;
+	addr[0] = 0x00;
 	if (z->id != ZORRO_PROD_AMERISTAR_A2065) {	/* Commodore */
-		dev->dev_addr[1] = 0x80;
-		dev->dev_addr[2] = 0x10;
+		addr[1] = 0x80;
+		addr[2] = 0x10;
 	} else {					/* Ameristar */
-		dev->dev_addr[1] = 0x00;
-		dev->dev_addr[2] = 0x9f;
+		addr[1] = 0x00;
+		addr[2] = 0x9f;
 	}
-	dev->dev_addr[3] = (serial >> 16) & 0xff;
-	dev->dev_addr[4] = (serial >> 8) & 0xff;
-	dev->dev_addr[5] = serial & 0xff;
+	addr[3] = (serial >> 16) & 0xff;
+	addr[4] = (serial >> 8) & 0xff;
+	addr[5] = serial & 0xff;
+	eth_hw_addr_set(dev, addr);
 	dev->base_addr = (unsigned long)ZTWO_VADDR(base_addr);
 	dev->mem_start = (unsigned long)ZTWO_VADDR(mem_start);
 	dev->mem_end = dev->mem_start + A2065_RAM_SIZE;
diff --git a/drivers/net/ethernet/amd/ariadne.c b/drivers/net/ethernet/amd/ariadne.c
index 4b6a5cb85dd27..b2f740249b01d 100644
--- a/drivers/net/ethernet/amd/ariadne.c
+++ b/drivers/net/ethernet/amd/ariadne.c
@@ -441,11 +441,11 @@ static int ariadne_open(struct net_device *dev)
 
 	/* Set the Ethernet Hardware Address */
 	lance->RAP = CSR12;		/* Physical Address Register, PADR[15:0] */
-	lance->RDP = ((u_short *)&dev->dev_addr[0])[0];
+	lance->RDP = ((const u_short *)&dev->dev_addr[0])[0];
 	lance->RAP = CSR13;		/* Physical Address Register, PADR[31:16] */
-	lance->RDP = ((u_short *)&dev->dev_addr[0])[1];
+	lance->RDP = ((const u_short *)&dev->dev_addr[0])[1];
 	lance->RAP = CSR14;		/* Physical Address Register, PADR[47:32] */
-	lance->RDP = ((u_short *)&dev->dev_addr[0])[2];
+	lance->RDP = ((const u_short *)&dev->dev_addr[0])[2];
 
 	/* Set the Init Block Mode */
 	lance->RAP = CSR15;		/* Mode Register */
@@ -717,6 +717,7 @@ static int ariadne_init_one(struct zorro_dev *z,
 	unsigned long mem_start = board + ARIADNE_RAM;
 	struct resource *r1, *r2;
 	struct net_device *dev;
+	u8 addr[ETH_ALEN];
 	u32 serial;
 	int err;
 
@@ -740,12 +741,13 @@ static int ariadne_init_one(struct zorro_dev *z,
 	r2->name = dev->name;
 
 	serial = be32_to_cpu(z->rom.er_SerialNumber);
-	dev->dev_addr[0] = 0x00;
-	dev->dev_addr[1] = 0x60;
-	dev->dev_addr[2] = 0x30;
-	dev->dev_addr[3] = (serial >> 16) & 0xff;
-	dev->dev_addr[4] = (serial >> 8) & 0xff;
-	dev->dev_addr[5] = serial & 0xff;
+	addr[0] = 0x00;
+	addr[1] = 0x60;
+	addr[2] = 0x30;
+	addr[3] = (serial >> 16) & 0xff;
+	addr[4] = (serial >> 8) & 0xff;
+	addr[5] = serial & 0xff;
+	eth_hw_addr_set(dev, addr);
 	dev->base_addr = (unsigned long)ZTWO_VADDR(base_addr);
 	dev->mem_start = (unsigned long)ZTWO_VADDR(mem_start);
 	dev->mem_end = dev->mem_start + ARIADNE_RAM_SIZE;
-- 
2.34.1

