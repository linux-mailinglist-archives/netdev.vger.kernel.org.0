Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3532D58D6E
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfF0V6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:58:24 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:36810 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbfF0V6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:58:21 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45ZYgJ4W1Jz1s28d;
        Thu, 27 Jun 2019 23:58:20 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45ZYgJ3vX5z1qqkH;
        Thu, 27 Jun 2019 23:58:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id fmHbXE27zbp7; Thu, 27 Jun 2019 23:58:19 +0200 (CEST)
X-Auth-Info: 3K2R4t132r8v3pbDIZ2LEuAqugifgtZHNKcQOP4mfLA=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 27 Jun 2019 23:58:19 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH 1/5] net: dsa: microchip: Replace ad-hoc polling with regmap
Date:   Thu, 27 Jun 2019 23:55:52 +0200
Message-Id: <20190627215556.23768-2-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627215556.23768-1-marex@denx.de>
References: <20190627215556.23768-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regmap provides polling function to poll for bits in a register,
use in instead of reimplementing it.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 14 +++++---------
 drivers/net/dsa/microchip/ksz_common.h | 14 --------------
 2 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 8f13dcc05a10..ece25f38e02a 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -263,12 +263,8 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 static void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
 			      u64 *cnt)
 {
-	struct ksz_poll_ctx ctx = {
-		.dev = dev,
-		.port = port,
-		.offset = REG_PORT_MIB_CTRL_STAT__4,
-	};
 	struct ksz_port *p = &dev->ports[port];
+	unsigned int val;
 	u32 data;
 	int ret;
 
@@ -278,11 +274,11 @@ static void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
 	data |= (addr << MIB_COUNTER_INDEX_S);
 	ksz_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, data);
 
-	ret = readx_poll_timeout(ksz_pread32_poll, &ctx, data,
-				 !(data & MIB_COUNTER_READ), 10, 1000);
-
+	ret = regmap_read_poll_timeout(dev->regmap[2],
+			PORT_CTRL_ADDR(port, REG_PORT_MIB_CTRL_STAT__4),
+			val, !(val & MIB_COUNTER_READ), 10, 1000);
 	/* failed to read MIB. get out of loop */
-	if (ret < 0) {
+	if (ret) {
 		dev_dbg(dev->dev, "Failed to get MIB\n");
 		return;
 	}
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 745318424f71..ee7096d8af07 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -119,20 +119,6 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 	ksz_write32(dev, dev->dev_ops->get_port_addr(port, offset), data);
 }
 
-struct ksz_poll_ctx {
-	struct ksz_device *dev;
-	int port;
-	int offset;
-};
-
-static inline u32 ksz_pread32_poll(struct ksz_poll_ctx *ctx)
-{
-	u32 data;
-
-	ksz_pread32(ctx->dev, ctx->port, ctx->offset, &data);
-	return data;
-}
-
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
-- 
2.20.1

