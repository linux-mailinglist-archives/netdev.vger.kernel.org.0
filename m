Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C05395003E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfFXDbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:31:32 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:39622 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbfFXDba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 23:31:30 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45X6k81h4Jz1rBNc;
        Mon, 24 Jun 2019 00:37:20 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45X6k81WDRz1qqkd;
        Mon, 24 Jun 2019 00:37:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id pBou40w4yW8T; Mon, 24 Jun 2019 00:37:19 +0200 (CEST)
X-Auth-Info: gct3O+Y35OQvOQutXCmEPEFXurQP9n0oqEsKGzyDvO4=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 24 Jun 2019 00:37:19 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH V3 04/10] net: dsa: microchip: Move ksz_cfg and ksz_port_cfg to ksz9477.c
Date:   Mon, 24 Jun 2019 00:35:02 +0200
Message-Id: <20190623223508.2713-5-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190623223508.2713-1-marex@denx.de>
References: <20190623223508.2713-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions are only used by the KSZ9477 code, move them from
the header into that code. Note that these functions will be soon
replaced by regmap equivalents.

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
 drivers/net/dsa/microchip/ksz9477.c    | 29 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h | 29 --------------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 508380f80875..e8b96566abd9 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -65,6 +65,35 @@ static const struct {
 	{ 0x83, "tx_discards" },
 };
 
+static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
+{
+	u8 data;
+
+	ksz_read8(dev, addr, &data);
+	if (set)
+		data |= bits;
+	else
+		data &= ~bits;
+	ksz_write8(dev, addr, data);
+}
+
+static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
+			 bool set)
+{
+	u32 addr;
+	u8 data;
+
+	addr = dev->dev_ops->get_port_addr(port, offset);
+	ksz_read8(dev, addr, &data);
+
+	if (set)
+		data |= bits;
+	else
+		data &= ~bits;
+
+	ksz_write8(dev, addr, data);
+}
+
 static void ksz9477_cfg32(struct ksz_device *dev, u32 addr, u32 bits, bool set)
 {
 	u32 data;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c15b49528bad..fe576a00facf 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -141,35 +141,6 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 	ksz_write32(dev, dev->dev_ops->get_port_addr(port, offset), data);
 }
 
-static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
-{
-	u8 data;
-
-	ksz_read8(dev, addr, &data);
-	if (set)
-		data |= bits;
-	else
-		data &= ~bits;
-	ksz_write8(dev, addr, data);
-}
-
-static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
-			 bool set)
-{
-	u32 addr;
-	u8 data;
-
-	addr = dev->dev_ops->get_port_addr(port, offset);
-	ksz_read8(dev, addr, &data);
-
-	if (set)
-		data |= bits;
-	else
-		data &= ~bits;
-
-	ksz_write8(dev, addr, data);
-}
-
 struct ksz_poll_ctx {
 	struct ksz_device *dev;
 	int port;
-- 
2.20.1

