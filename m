Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342D658D6F
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfF0V62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:58:28 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49171 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfF0V60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:58:26 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45ZYgM0y8Lz1s28g;
        Thu, 27 Jun 2019 23:58:23 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45ZYgM0QPhz1qqkH;
        Thu, 27 Jun 2019 23:58:23 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id Ar1JAORAiqIq; Thu, 27 Jun 2019 23:58:21 +0200 (CEST)
X-Auth-Info: GVjPkiEYULSFumbVwvEuyQ31jNeuCZOJY3fIVjskk7k=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 27 Jun 2019 23:58:21 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH 3/5] net: dsa: microchip: Replace ksz9477_wait_alu_ready polling with regmap
Date:   Thu, 27 Jun 2019 23:55:54 +0200
Message-Id: <20190627215556.23768-4-marex@denx.de>
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
 drivers/net/dsa/microchip/ksz9477.c | 34 ++++++++++-------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 0aab00bf23b9..e5b2f3e45db6 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -176,22 +176,12 @@ static void ksz9477_write_table(struct ksz_device *dev, u32 *table)
 	ksz_write32(dev, REG_SW_ALU_VAL_D, table[3]);
 }
 
-static int ksz9477_wait_alu_ready(struct ksz_device *dev, u32 waiton,
-				  int timeout)
+static int ksz9477_wait_alu_ready(struct ksz_device *dev)
 {
-	u32 data;
-
-	do {
-		ksz_read32(dev, REG_SW_ALU_CTRL__4, &data);
-		if (!(data & waiton))
-			break;
-		usleep_range(1, 10);
-	} while (timeout-- > 0);
-
-	if (timeout <= 0)
-		return -ETIMEDOUT;
+	unsigned int val;
 
-	return 0;
+	return regmap_read_poll_timeout(dev->regmap[2], REG_SW_ALU_CTRL__4,
+					val, !(val & ALU_START), 10, 1000);
 }
 
 static int ksz9477_wait_alu_sta_ready(struct ksz_device *dev, u32 waiton,
@@ -633,8 +623,8 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 	ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_READ | ALU_START);
 
 	/* wait to be finished */
-	ret = ksz9477_wait_alu_ready(dev, ALU_START, 1000);
-	if (ret < 0) {
+	ret = ksz9477_wait_alu_ready(dev);
+	if (ret) {
 		dev_dbg(dev->dev, "Failed to read ALU\n");
 		goto exit;
 	}
@@ -657,8 +647,8 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 	ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_WRITE | ALU_START);
 
 	/* wait to be finished */
-	ret = ksz9477_wait_alu_ready(dev, ALU_START, 1000);
-	if (ret < 0)
+	ret = ksz9477_wait_alu_ready(dev);
+	if (ret)
 		dev_dbg(dev->dev, "Failed to write ALU\n");
 
 exit:
@@ -690,8 +680,8 @@ static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
 	ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_READ | ALU_START);
 
 	/* wait to be finished */
-	ret = ksz9477_wait_alu_ready(dev, ALU_START, 1000);
-	if (ret < 0) {
+	ret = ksz9477_wait_alu_ready(dev);
+	if (ret) {
 		dev_dbg(dev->dev, "Failed to read ALU\n");
 		goto exit;
 	}
@@ -724,8 +714,8 @@ static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
 	ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_WRITE | ALU_START);
 
 	/* wait to be finished */
-	ret = ksz9477_wait_alu_ready(dev, ALU_START, 1000);
-	if (ret < 0)
+	ret = ksz9477_wait_alu_ready(dev);
+	if (ret)
 		dev_dbg(dev->dev, "Failed to write ALU\n");
 
 exit:
-- 
2.20.1

