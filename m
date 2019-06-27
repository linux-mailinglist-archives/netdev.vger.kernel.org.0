Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F2B58D71
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfF0V62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:58:28 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:51432 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0V60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:58:26 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45ZYgN2xhYz1rb1L;
        Thu, 27 Jun 2019 23:58:24 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45ZYgN2V2dz1qqkH;
        Thu, 27 Jun 2019 23:58:24 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id WMk8UneRPTpA; Thu, 27 Jun 2019 23:58:23 +0200 (CEST)
X-Auth-Info: dxaUiVnHFeewnfDhJEflI7oX62nSF+we8HuyQmzB5SM=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 27 Jun 2019 23:58:23 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH 4/5] net: dsa: microchip: Replace ksz9477_wait_alu_sta_ready polling with regmap
Date:   Thu, 27 Jun 2019 23:55:55 +0200
Message-Id: <20190627215556.23768-5-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627215556.23768-1-marex@denx.de>
References: <20190627215556.23768-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regmap provides polling function to poll for bits in a register. This
function is another reimplementation of polling for bit being clear in
a register. Replace this with regmap polling function. Moreover, inline
the function parameters, as the function is never called with any other
parameter values than this one.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 32 +++++++++++------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index e5b2f3e45db6..bfc44799854c 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -184,22 +184,14 @@ static int ksz9477_wait_alu_ready(struct ksz_device *dev)
 					val, !(val & ALU_START), 10, 1000);
 }
 
-static int ksz9477_wait_alu_sta_ready(struct ksz_device *dev, u32 waiton,
-				      int timeout)
+static int ksz9477_wait_alu_sta_ready(struct ksz_device *dev)
 {
-	u32 data;
-
-	do {
-		ksz_read32(dev, REG_SW_ALU_STAT_CTRL__4, &data);
-		if (!(data & waiton))
-			break;
-		usleep_range(1, 10);
-	} while (timeout-- > 0);
-
-	if (timeout <= 0)
-		return -ETIMEDOUT;
+	unsigned int val;
 
-	return 0;
+	return regmap_read_poll_timeout(dev->regmap[2],
+					REG_SW_ALU_STAT_CTRL__4,
+					val, !(val & ALU_STAT_START),
+					10, 1000);
 }
 
 static int ksz9477_reset_switch(struct ksz_device *dev)
@@ -821,7 +813,7 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 		ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
 
 		/* wait to be finished */
-		if (ksz9477_wait_alu_sta_ready(dev, ALU_STAT_START, 1000) < 0) {
+		if (ksz9477_wait_alu_sta_ready(dev)) {
 			dev_dbg(dev->dev, "Failed to read ALU STATIC\n");
 			goto exit;
 		}
@@ -862,7 +854,7 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 	ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
 
 	/* wait to be finished */
-	if (ksz9477_wait_alu_sta_ready(dev, ALU_STAT_START, 1000) < 0)
+	if (ksz9477_wait_alu_sta_ready(dev))
 		dev_dbg(dev->dev, "Failed to read ALU STATIC\n");
 
 exit:
@@ -892,8 +884,8 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
 		ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
 
 		/* wait to be finished */
-		ret = ksz9477_wait_alu_sta_ready(dev, ALU_STAT_START, 1000);
-		if (ret < 0) {
+		ret = ksz9477_wait_alu_sta_ready(dev);
+		if (ret) {
 			dev_dbg(dev->dev, "Failed to read ALU STATIC\n");
 			goto exit;
 		}
@@ -934,8 +926,8 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
 	ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
 
 	/* wait to be finished */
-	ret = ksz9477_wait_alu_sta_ready(dev, ALU_STAT_START, 1000);
-	if (ret < 0)
+	ret = ksz9477_wait_alu_sta_ready(dev);
+	if (ret)
 		dev_dbg(dev->dev, "Failed to read ALU STATIC\n");
 
 exit:
-- 
2.20.1

