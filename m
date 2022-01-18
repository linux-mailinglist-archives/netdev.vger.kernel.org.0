Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F42349147A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244626AbiARCWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244990AbiARCWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:22:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA76C06175B;
        Mon, 17 Jan 2022 18:22:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F69BB81239;
        Tue, 18 Jan 2022 02:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB96BC36AEB;
        Tue, 18 Jan 2022 02:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472540;
        bh=TzeY5kjwuR+907nvx0UXsopJcumuIJtfZTdJBviSCmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p16/TXVN3fnkqi361UgRXEnkA7i5zdfowynTd5tDCW4wCE1eJuOUrNNrZB/f3G9Le
         HbYr4Q6PTM1Ke4X2Jw2RtzCbOLwbYI94Gwtg1AFaJnFt0k94+QRSIz9XjXBTi/O9qi
         yKUVrLuBs08GU3Et4f2uSIGFKsfkPTpij9qux39oxIVB6hHBZl1ccJ8k9xJ7T9MYJX
         JelVgaI96+13eR6yAUe8sa1Y2s/V/gN5T2dRhHQNhrmIyCArL6G8CoKKEzVILHEf9v
         bT1uGMLGot2mwpaYQMxl45WxqTPfv0likZL2ao8W8Hst88WdHGESpvEfIRzP7+B+sp
         90EeSegHRwMsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        u.kleine-koenig@pengutronix.de, sudipm.mukherjee@gmail.com,
        dmitry.torokhov@gmail.com, deller@gmx.de, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 045/217] lasi_82594: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:16:48 -0500
Message-Id: <20220118021940.1942199-45-sashal@kernel.org>
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

[ Upstream commit 5b6d5affd27486ec9152a66df1741cf67782712a ]

dev_addr is set from IO reads, passed to an arch-specific helper.
Note that the helper never reads it so uninitialized temp is fine.

Fixes build on parisc.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/i825xx/lasi_82596.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/lasi_82596.c b/drivers/net/ethernet/i825xx/lasi_82596.c
index 48e001881c75f..0af70094aba34 100644
--- a/drivers/net/ethernet/i825xx/lasi_82596.c
+++ b/drivers/net/ethernet/i825xx/lasi_82596.c
@@ -147,6 +147,7 @@ lan_init_chip(struct parisc_device *dev)
 	struct	net_device *netdevice;
 	struct i596_private *lp;
 	int retval = -ENOMEM;
+	u8 addr[ETH_ALEN];
 	int i;
 
 	if (!dev->irq) {
@@ -167,13 +168,14 @@ lan_init_chip(struct parisc_device *dev)
 	netdevice->base_addr = dev->hpa.start;
 	netdevice->irq = dev->irq;
 
-	if (pdc_lan_station_id(netdevice->dev_addr, netdevice->base_addr)) {
+	if (pdc_lan_station_id(addr, netdevice->base_addr)) {
 		for (i = 0; i < 6; i++) {
-			netdevice->dev_addr[i] = gsc_readb(LAN_PROM_ADDR + i);
+			addr[i] = gsc_readb(LAN_PROM_ADDR + i);
 		}
 		printk(KERN_INFO
 		       "%s: MAC of HP700 LAN read from EEPROM\n", __FILE__);
 	}
+	eth_hw_addr_set(netdevice, addr);
 
 	lp = netdev_priv(netdevice);
 	lp->options = dev->id.sversion == 0x72 ? OPT_SWAP_PORT : 0;
-- 
2.34.1

