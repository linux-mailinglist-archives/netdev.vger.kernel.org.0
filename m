Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF1A6C7B91
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbjCXJhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjCXJhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:37:06 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1F524C98;
        Fri, 24 Mar 2023 02:37:04 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8584A100015;
        Fri, 24 Mar 2023 09:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679650623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ya2n9BSLCKw2UN7tvwjwr02RTqzpvvXHPx/OBwXBY1E=;
        b=fndyXpHryL7YQKlmX8ZIcCG8Ai+ANP8YQynTi8SIOuE5wZfRJqgBwcyt1bCC3+9TTFpRtU
        CzyynAZn5njEA4PlprcSwmvsclzZywk7c48bvMjtrqudKHq2wmCOik0NiOspRhES5geQfr
        94H92JCirWYmY5NCOq/1GR9t3PSGpQUprpE6/h6X0LCm5zTs+Rvg6Jqwh0dTn+pEAtZUlJ
        wle1WndMMjo9gsBUcZs/aoaeLPqQgazGcX7gSjQvtCKYEffeea1zGOXAzWi2JLMwlg9Pa8
        wccrPWCpodwbZwJ+dCV4uXReZvRq8rJWWI2sNMrpQLSr8ooWA7TOmNM4kfxZ8w==
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
Subject: [RFC 3/7] regmap: allow upshifting register addresses before performing operations
Date:   Fri, 24 Mar 2023 10:36:40 +0100
Message-Id: <20230324093644.464704-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the existing reg_downshift mechanism, that is used to
translate register addresses on busses that have a smaller address
stride, it's also possible to want to upshift register addresses.

Such a case was encountered when network PHYs and PCS that usually sit
on a MDIO bus (16-bits register with a stride of 1) are integrated
directly as memory-mapped devices. Here, the same register layout
defined in 802.3 is used, but the register now have a larger stride.

Introduce a mechanism to also allow upshifting register addresses.
Re-purpose reg_downshift into a more generic, signed reg_shift, whose
sign indicates the direction of the shift. To avoid confusion, also
introduce macros to explicitly indicate if we want to downshift or
upshift.

For bisectability, change any use of reg_downshift to use reg_shift.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/base/regmap/internal.h |  2 +-
 drivers/base/regmap/regmap.c   | 10 ++++++++--
 drivers/mfd/ocelot-spi.c       |  2 +-
 include/linux/regmap.h         | 15 ++++++++++++---
 4 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index da8996e7a1f1..2ef53936652b 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -31,7 +31,7 @@ struct regmap_format {
 	size_t buf_size;
 	size_t reg_bytes;
 	size_t pad_bytes;
-	size_t reg_downshift;
+	int reg_shift;
 	size_t val_bytes;
 	void (*format_write)(struct regmap *map,
 			     unsigned int reg, unsigned int val);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 726f59612fd6..c4cde4f45b05 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -814,7 +814,7 @@ struct regmap *__regmap_init(struct device *dev,
 
 	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
 	map->format.pad_bytes = config->pad_bits / 8;
-	map->format.reg_downshift = config->reg_downshift;
+	map->format.reg_shift = config->reg_shift;
 	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
 	map->format.buf_size = DIV_ROUND_UP(config->reg_bits +
 			config->val_bits + config->pad_bits, 8);
@@ -1679,7 +1679,13 @@ static void regmap_set_work_buf_flag_mask(struct regmap *map, int max_bytes,
 static unsigned int regmap_reg_addr(struct regmap *map, unsigned int reg)
 {
 	reg += map->reg_base;
-	return reg >> map->format.reg_downshift;
+
+	if (map->format.reg_shift > 0)
+		reg >>= map->format.reg_shift;
+	else if (map->format.reg_shift < 0)
+		reg <<= -(map->format.reg_shift);
+
+	return reg;
 }
 
 static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
index 2ecd271de2fb..2d1349a10ca9 100644
--- a/drivers/mfd/ocelot-spi.c
+++ b/drivers/mfd/ocelot-spi.c
@@ -125,7 +125,7 @@ static int ocelot_spi_initialize(struct device *dev)
 static const struct regmap_config ocelot_spi_regmap_config = {
 	.reg_bits = 24,
 	.reg_stride = 4,
-	.reg_downshift = 2,
+	.reg_shift = REGMAP_DOWNSHIFT(2),
 	.val_bits = 32,
 
 	.write_flag_mask = 0x80,
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 4d10790adeb0..f02c3857b023 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -46,6 +46,14 @@ struct sdw_slave;
 #define REGMAP_MDIO_C45_DEVAD_MASK	GENMASK(20, 16)
 #define REGMAP_MDIO_C45_REGNUM_MASK	GENMASK(15, 0)
 
+/*
+ * regmap.reg_shift indicates by how much we must shift registers prior to
+ * performing any operation. It's a signed value, positive numbers means
+ * downshifting the register's address, while negative numbers means upshifting.
+ */
+#define REGMAP_UPSHIFT(s)	(-(s))
+#define REGMAP_DOWNSHIFT(s)	(s)
+
 /* An enum of all the supported cache types */
 enum regcache_type {
 	REGCACHE_NONE,
@@ -246,8 +254,9 @@ typedef void (*regmap_unlock)(void *);
  * @reg_stride: The register address stride. Valid register addresses are a
  *              multiple of this value. If set to 0, a value of 1 will be
  *              used.
- * @reg_downshift: The number of bits to downshift the register before
- *		   performing any operations.
+ * @reg_shift: The number of bits to shift the register before performing any
+ *	       operations. Any positive number will be downshifted, and negative
+ *	       values will be upshifted
  * @reg_base: Value to be added to every register address before performing any
  *	      operation.
  * @pad_bits: Number of bits of padding between register and value.
@@ -381,7 +390,7 @@ struct regmap_config {
 
 	int reg_bits;
 	int reg_stride;
-	int reg_downshift;
+	int reg_shift;
 	unsigned int reg_base;
 	int pad_bits;
 	int val_bits;
-- 
2.39.2

