Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3C3585051
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiG2NEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbiG2NEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:04:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74CB4F662
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:04:07 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oHPeh-0006nN-9c; Fri, 29 Jul 2022 15:03:51 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oHPef-000VuV-83; Fri, 29 Jul 2022 15:03:49 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oHPed-00CQY8-HF; Fri, 29 Jul 2022 15:03:47 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v1 04/10] net: dsa: microchip: ksz9477: add error handling to ksz9477_r/w_phy
Date:   Fri, 29 Jul 2022 15:03:40 +0200
Message-Id: <20220729130346.2961889-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220729130346.2961889-1-o.rempel@pengutronix.de>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now ksz_pread/ksz_pwrite can return error value. So, make use of it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz9477.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 9d749537cf01..074d4c16d427 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -283,6 +283,7 @@ static void ksz9477_r_phy_quirks(struct ksz_device *dev, u16 addr, u16 reg,
 int ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 {
 	u16 val = 0xffff;
+	int ret;
 
 	/* No real PHY after this. Simulate the PHY.
 	 * A fixed PHY can be setup in the device tree, but this function is
@@ -323,7 +324,10 @@ int ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 			break;
 		}
 	} else {
-		ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
+		ret = ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
+		if (ret)
+			return ret;
+
 		ksz9477_r_phy_quirks(dev, addr, reg, &val);
 	}
 
@@ -340,11 +344,9 @@ int ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 
 	/* No gigabit support.  Do not write to this register. */
 	if (!(dev->features & GBIT_SUPPORT) && reg == MII_CTRL1000)
-		return 0;
+		return -ENOTSUPP;
 
-	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
-
-	return 0;
+	return ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
 }
 
 void ksz9477_cfg_port_member(struct ksz_device *dev, int port, u8 member)
-- 
2.30.2

