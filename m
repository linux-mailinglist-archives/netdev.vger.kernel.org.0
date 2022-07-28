Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3D9583FC6
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbiG1NRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbiG1NRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:17:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BE123153
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:17:45 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oH3OL-0004rS-Ts; Thu, 28 Jul 2022 15:17:29 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oH3OJ-000Jl3-Pg; Thu, 28 Jul 2022 15:17:27 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oH3OI-000AYl-Vm; Thu, 28 Jul 2022 15:17:26 +0200
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
Subject: [PATCH net v1 1/1] net: dsa: microchip: don't try do read Gbit registers on non Gbit chips
Date:   Thu, 28 Jul 2022 15:17:25 +0200
Message-Id: <20220728131725.40492-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not try to read not existing or wrong register on chips without
GBIT_SUPPORT.

Fixes: c2e866911e25 ("net: dsa: microchip: break KSZ9477 DSA driver into two files")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz9477.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index c73bb6d383ad..f6bbd9646c85 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -316,7 +316,13 @@ void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 			break;
 		}
 	} else {
-		ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
+		/* No gigabit support.  Do not read wrong registers. */
+		if (!(dev->features & GBIT_SUPPORT) &&
+		    (reg == MII_CTRL1000 || reg == MII_ESTATUS ||
+		     reg == MII_STAT1000))
+			val = 0;
+		else
+			ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
 	}
 
 	*data = val;
-- 
2.30.2

