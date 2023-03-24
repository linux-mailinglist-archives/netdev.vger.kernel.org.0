Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994DE6C7961
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 09:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjCXIGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 04:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjCXIGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 04:06:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AB123874
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 01:06:21 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pfcRB-00077S-IU; Fri, 24 Mar 2023 09:06:13 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pfcR9-006KcS-18; Fri, 24 Mar 2023 09:06:11 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pfcR7-00ENzY-JV; Fri, 24 Mar 2023 09:06:09 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net v2 5/6] net: dsa: microchip: ksz8863_smi: fix bulk access
Date:   Fri, 24 Mar 2023 09:06:07 +0100
Message-Id: <20230324080608.3428714-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230324080608.3428714-1-o.rempel@pengutronix.de>
References: <20230324080608.3428714-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current regmap bulk access is broken, resulting to wrong reads/writes
if ksz_read64/ksz_write64 functions are used.
Mostly this issue was visible by using ksz8_fdb_dump(), which returned
corrupt MAC address.

The reason is that regmap was configured to have max_raw_read/write,
even if ksz8863_mdio_read/write functions are able to handle unlimited
read/write accesses. On ksz_read64 function we are using multiple 32bit
accesses by incrementing each access by 1 instead of 4. Resulting buffer
had 01234567.12345678 instead of 01234567.89abcdef.

We have multiple ways to fix it:
- enable 4 byte alignment for 32bit accesses. Since the HW do not have
  this requirement. It will break driver.
- disable max_raw_* limit.

This patch is removing max_raw_* limit for regmap accesses in ksz8863_smi.

Fixes: 60a364760002 ("net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8863_smi.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
index 2f4623f3bd85..3698112138b7 100644
--- a/drivers/net/dsa/microchip/ksz8863_smi.c
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -82,22 +82,16 @@ static const struct regmap_bus regmap_smi[] = {
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
-		.max_raw_read = 1,
-		.max_raw_write = 1,
 	},
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
 		.val_format_endian_default = REGMAP_ENDIAN_BIG,
-		.max_raw_read = 2,
-		.max_raw_write = 2,
 	},
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
 		.val_format_endian_default = REGMAP_ENDIAN_BIG,
-		.max_raw_read = 4,
-		.max_raw_write = 4,
 	}
 };
 
@@ -108,7 +102,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 8,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	},
@@ -118,7 +111,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 16,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	},
@@ -128,7 +120,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 32,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	}
-- 
2.30.2

