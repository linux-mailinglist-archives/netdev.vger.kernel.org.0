Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B73E456AAE
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbhKSHNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233324AbhKSHNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B5C561AD2;
        Fri, 19 Nov 2021 07:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305841;
        bh=wYsicMGFhLNPuLkuiU2UBEJYQmixbXe5g2bsE1DrtnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObTF/k/LSdJpzdZbyXZQI9stq173IbM4ZJiuwgtYA89yBnDhG/DTxHYhyHrdGVcER
         0MYRaGlfb2EXENmX9HWd9x2gXGyxLOP5YLFGg80AdPhcmT21MzybRwy9VCrcaU5SNI
         dZzraDI4pnSEIoUGnWeJHaHfYFtpCY0HpkCFTrv62aah3R7IDqUgf9MDUtNdhm4kQl
         2oaD+RXl47PLRGlIHIj4Dg2xKDnGtmD6/MAS/CifpHniWzCR1FmNxViPTWoB9VEHwd
         OpIAGunOtlsoglNzoxP2us9/+MF9X9s+twKr0fUlJJnChRUxSHy+gUjGwbKXWzs/Ya
         GW/pIWY9rFuQw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/15] amd: a2065/ariadne: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:21 -0800
Message-Id: <20211119071033.3756560-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_addr is initialized byte by byte from series.

Fixes build on x86 (32bit).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/a2065.c   | 18 ++++++++++--------
 drivers/net/ethernet/amd/ariadne.c | 20 +++++++++++---------
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/amd/a2065.c b/drivers/net/ethernet/amd/a2065.c
index 2f808dbc8b0e..3a351d3396bf 100644
--- a/drivers/net/ethernet/amd/a2065.c
+++ b/drivers/net/ethernet/amd/a2065.c
@@ -680,6 +680,7 @@ static int a2065_init_one(struct zorro_dev *z,
 	unsigned long base_addr = board + A2065_LANCE;
 	unsigned long mem_start = board + A2065_RAM;
 	struct resource *r1, *r2;
+	u8 addr[ETH_ALEN];
 	u32 serial;
 	int err;
 
@@ -706,17 +707,18 @@ static int a2065_init_one(struct zorro_dev *z,
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
index 5e0f645f5bde..4ea7b9f3c424 100644
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
2.31.1

