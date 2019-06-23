Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4FF50031
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfFXD2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:28:25 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45573 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfFXD2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 23:28:25 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45X6kH5HP4z1rcrg;
        Mon, 24 Jun 2019 00:37:27 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45X6kH553vz1qqkp;
        Mon, 24 Jun 2019 00:37:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id vN4wlNRT2bhE; Mon, 24 Jun 2019 00:37:26 +0200 (CEST)
X-Auth-Info: bMc2ULGzfp+QgGoG36hsn0/W7kKNOBO95Bb4EJu3r0I=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 24 Jun 2019 00:37:26 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH V3 10/10] net: dsa: microchip: Replace ad-hoc bit manipulation with regmap
Date:   Mon, 24 Jun 2019 00:35:08 +0200
Message-Id: <20190623223508.2713-11-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190623223508.2713-1-marex@denx.de>
References: <20190623223508.2713-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regmap provides bit manipulation functions to set/clear bits, use those
insted of reimplementing them.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
---
V2: New patch
V3: - Rebase on next/master
    - Test on KSZ9477EVB
---
 drivers/net/dsa/microchip/ksz9477.c | 46 ++++-------------------------
 1 file changed, 6 insertions(+), 40 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 7d209fd9f26f..8f13dcc05a10 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -67,60 +67,26 @@ static const struct {
 
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
-	u8 data;
-
-	ksz_read8(dev, addr, &data);
-	if (set)
-		data |= bits;
-	else
-		data &= ~bits;
-	ksz_write8(dev, addr, data);
+	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
 }
 
 static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 			 bool set)
 {
-	u32 addr;
-	u8 data;
-
-	addr = PORT_CTRL_ADDR(port, offset);
-	ksz_read8(dev, addr, &data);
-
-	if (set)
-		data |= bits;
-	else
-		data &= ~bits;
-
-	ksz_write8(dev, addr, data);
+	regmap_update_bits(dev->regmap[0], PORT_CTRL_ADDR(port, offset),
+			   bits, set ? bits : 0);
 }
 
 static void ksz9477_cfg32(struct ksz_device *dev, u32 addr, u32 bits, bool set)
 {
-	u32 data;
-
-	ksz_read32(dev, addr, &data);
-	if (set)
-		data |= bits;
-	else
-		data &= ~bits;
-	ksz_write32(dev, addr, data);
+	regmap_update_bits(dev->regmap[2], addr, bits, set ? bits : 0);
 }
 
 static void ksz9477_port_cfg32(struct ksz_device *dev, int port, int offset,
 			       u32 bits, bool set)
 {
-	u32 addr;
-	u32 data;
-
-	addr = PORT_CTRL_ADDR(port, offset);
-	ksz_read32(dev, addr, &data);
-
-	if (set)
-		data |= bits;
-	else
-		data &= ~bits;
-
-	ksz_write32(dev, addr, data);
+	regmap_update_bits(dev->regmap[2], PORT_CTRL_ADDR(port, offset),
+			   bits, set ? bits : 0);
 }
 
 static int ksz9477_wait_vlan_ctrl_ready(struct ksz_device *dev, u32 waiton,
-- 
2.20.1

