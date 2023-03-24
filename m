Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9395E6C7B8F
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjCXJg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjCXJg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:36:57 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8E023D99;
        Fri, 24 Mar 2023 02:36:55 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 14A6610000F;
        Fri, 24 Mar 2023 09:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679650614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Odm7qShtV6wGQf5vqVQshQRG9PVCO1dlSKvAJeUzWto=;
        b=J5v3PHJJlWSaIH/MWKTkrFnB8rt1h6EY250/dPlXLVFc335knI7tnBKeDg8xVzFyptn7n2
        kBYfHFXQtHp4ANDf9lpubTfP8oI1xboFMbomIIjDM/qZi7ZI4uGh8kITYzOVn0DRz6PkqO
        VhCzFhvJQN3vD7ShyYDxbZWpAK+l+4NI9ZKaV2Dq37SryvbT1IHQ9wmRmX0wHYtZSJ8g7Q
        Om4PqfPrUrfEY7qRwlHSIhzwewVPoP17x/tRxCihkRFjB5Q8ePtRXCneiuu2o3LYIA8YPX
        MGIXARjCWZ/2EruTS6ONQaDvkbvIC2PNLUZfgqHv89aTvOy5XXJeoD+QxAphXw==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [RFC 1/7] regmap: add a helper to translate the register address
Date:   Fri, 24 Mar 2023 10:36:38 +0100
Message-Id: <20230324093644.464704-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register addresses passed to regmap operations can be offset with
regmap.reg_base and downshifted with regmap.reg_downshift.

Add a helper to apply both these operations and return the translated
address, that we can then use to perform the actual register operation
ont the underlying bus.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/base/regmap/regmap.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d2a54eb0efd9..a4e4367648bf 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1676,6 +1676,12 @@ static void regmap_set_work_buf_flag_mask(struct regmap *map, int max_bytes,
 		buf[i] |= (mask >> (8 * i)) & 0xff;
 }
 
+static unsigned int regmap_reg_addr(struct regmap *map, unsigned int reg)
+{
+	reg += map->reg_base;
+	return reg >> map->format.reg_downshift;
+}
+
 static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
 				  const void *val, size_t val_len, bool noinc)
 {
@@ -1753,8 +1759,7 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
 			return ret;
 	}
 
-	reg += map->reg_base;
-	reg >>= map->format.reg_downshift;
+	reg = regmap_reg_addr(map, reg);
 	map->format.format_reg(map->work_buf, reg, map->reg_shift);
 	regmap_set_work_buf_flag_mask(map, map->format.reg_bytes,
 				      map->write_flag_mask);
@@ -1924,8 +1929,7 @@ static int _regmap_bus_formatted_write(void *context, unsigned int reg,
 			return ret;
 	}
 
-	reg += map->reg_base;
-	reg >>= map->format.reg_downshift;
+	reg = regmap_reg_addr(map, reg);
 	map->format.format_write(map, reg, val);
 
 	trace_regmap_hw_write_start(map, reg, 1);
@@ -1942,8 +1946,7 @@ static int _regmap_bus_reg_write(void *context, unsigned int reg,
 {
 	struct regmap *map = context;
 
-	reg += map->reg_base;
-	reg >>= map->format.reg_downshift;
+	reg = regmap_reg_addr(map, reg);
 	return map->bus->reg_write(map->bus_context, reg, val);
 }
 
@@ -2494,8 +2497,7 @@ static int _regmap_raw_multi_reg_write(struct regmap *map,
 		unsigned int reg = regs[i].reg;
 		unsigned int val = regs[i].def;
 		trace_regmap_hw_write_start(map, reg, 1);
-		reg += map->reg_base;
-		reg >>= map->format.reg_downshift;
+		reg = regmap_reg_addr(map, reg);
 		map->format.format_reg(u8, reg, map->reg_shift);
 		u8 += reg_bytes + pad_bytes;
 		map->format.format_val(u8, val, 0);
@@ -2821,8 +2823,7 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 			return ret;
 	}
 
-	reg += map->reg_base;
-	reg >>= map->format.reg_downshift;
+	reg = regmap_reg_addr(map, reg);
 	map->format.format_reg(map->work_buf, reg, map->reg_shift);
 	regmap_set_work_buf_flag_mask(map, map->format.reg_bytes,
 				      map->read_flag_mask);
@@ -2842,8 +2843,7 @@ static int _regmap_bus_reg_read(void *context, unsigned int reg,
 {
 	struct regmap *map = context;
 
-	reg += map->reg_base;
-	reg >>= map->format.reg_downshift;
+	reg = regmap_reg_addr(map, reg);
 	return map->bus->reg_read(map->bus_context, reg, val);
 }
 
@@ -3235,8 +3235,7 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 		*change = false;
 
 	if (regmap_volatile(map, reg) && map->reg_update_bits) {
-		reg += map->reg_base;
-		reg >>= map->format.reg_downshift;
+		reg = regmap_reg_addr(map, reg);
 		ret = map->reg_update_bits(map->bus_context, reg, mask, val);
 		if (ret == 0 && change)
 			*change = true;
-- 
2.39.2

