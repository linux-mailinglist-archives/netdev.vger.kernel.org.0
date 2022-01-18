Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE31491475
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244715AbiARCWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244595AbiARCVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:21:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52654C061755;
        Mon, 17 Jan 2022 18:21:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E49C1612E5;
        Tue, 18 Jan 2022 02:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E319C36AEB;
        Tue, 18 Jan 2022 02:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472507;
        bh=UmX2nlXkaOkWexEcFV10+goTcCTrpnTdiU5pNGjw6w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiR97JpslWt9mMGJSq1P3KpakTsXFuWeYJ2BRujoJjTuZMKXO0HC+m/Dykqhl6j45
         6MRKj794apuaq1vrSwHZcrAjI+MdASZf2F3fLQ/UHWZLNhzjqjWA40Prr6Kdpn4sdL
         ZcWd6JNI064W2Vpq7UvDnYHOvgxtYDfQtULodp7LcEQM3rTPfzknlyH7upj+A7f/VA
         eZpE8mQ9lOfalxiYwRJKceCuV6efjLMfEbxE3fWKPxca1j5k8pv9Yd+ElT9wMAMBKg
         cpboGo+zVnnR/5ZUmLr1bwVwXj07lyBFixdxnrttnlDHAaSnpitT+4Ah/tbAAU5uTq
         cwVu9W3Ndz/hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 036/217] amd: a2065/ariadne: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:16:39 -0500
Message-Id: <20220118021940.1942199-36-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 2f808dbc8b0ed..3a351d3396bfe 100644
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
index 5e0f645f5bde7..4ea7b9f3c4249 100644
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

