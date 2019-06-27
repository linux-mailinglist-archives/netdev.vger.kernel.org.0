Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F69658D6D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfF0V6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:58:24 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48426 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0V6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:58:23 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45ZYgK5z1sz1rZRv;
        Thu, 27 Jun 2019 23:58:21 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45ZYgK5krzz1qqkH;
        Thu, 27 Jun 2019 23:58:21 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id R6EWvMzZV9q7; Thu, 27 Jun 2019 23:58:20 +0200 (CEST)
X-Auth-Info: jMkj5hd8vNMb9DZUPJPWJ4WjzLssEHv5geC9N5CkKkQ=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 27 Jun 2019 23:58:20 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH 2/5] net: dsa: microchip: Replace ksz9477_wait_vlan_ctrl_ready polling with regmap
Date:   Thu, 27 Jun 2019 23:55:53 +0200
Message-Id: <20190627215556.23768-3-marex@denx.de>
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
 drivers/net/dsa/microchip/ksz9477.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index ece25f38e02a..0aab00bf23b9 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -89,22 +89,12 @@ static void ksz9477_port_cfg32(struct ksz_device *dev, int port, int offset,
 			   bits, set ? bits : 0);
 }
 
-static int ksz9477_wait_vlan_ctrl_ready(struct ksz_device *dev, u32 waiton,
-					int timeout)
+static int ksz9477_wait_vlan_ctrl_ready(struct ksz_device *dev)
 {
-	u8 data;
-
-	do {
-		ksz_read8(dev, REG_SW_VLAN_CTRL, &data);
-		if (!(data & waiton))
-			break;
-		usleep_range(1, 10);
-	} while (timeout-- > 0);
-
-	if (timeout <= 0)
-		return -ETIMEDOUT;
+	unsigned int val;
 
-	return 0;
+	return regmap_read_poll_timeout(dev->regmap[0], REG_SW_VLAN_CTRL,
+					val, !(val & VLAN_START), 10, 1000);
 }
 
 static int ksz9477_get_vlan_table(struct ksz_device *dev, u16 vid,
@@ -118,8 +108,8 @@ static int ksz9477_get_vlan_table(struct ksz_device *dev, u16 vid,
 	ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_READ | VLAN_START);
 
 	/* wait to be cleared */
-	ret = ksz9477_wait_vlan_ctrl_ready(dev, VLAN_START, 1000);
-	if (ret < 0) {
+	ret = ksz9477_wait_vlan_ctrl_ready(dev);
+	if (ret) {
 		dev_dbg(dev->dev, "Failed to read vlan table\n");
 		goto exit;
 	}
@@ -151,8 +141,8 @@ static int ksz9477_set_vlan_table(struct ksz_device *dev, u16 vid,
 	ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_START | VLAN_WRITE);
 
 	/* wait to be cleared */
-	ret = ksz9477_wait_vlan_ctrl_ready(dev, VLAN_START, 1000);
-	if (ret < 0) {
+	ret = ksz9477_wait_vlan_ctrl_ready(dev);
+	if (ret) {
 		dev_dbg(dev->dev, "Failed to write vlan table\n");
 		goto exit;
 	}
-- 
2.20.1

