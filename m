Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C197666BC9C
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjAPLPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjAPLPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:15:30 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8D310CE;
        Mon, 16 Jan 2023 03:15:29 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 5A67A12F5;
        Mon, 16 Jan 2023 12:15:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673867727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=C06gDDvnh2s2uXUgTh1dnTkoNlX/IPQDuJE9W4nHddo=;
        b=wd6rV9zj0e957LpKghnByz7FoAiMVV30rWchO8czrTlnIAAf2epS9MFi9Csc8sP3BOWKNW
        GOstgZstGUlqKbm62ptIrjW3HtTFooVHqZCOd1uCxCMWdBoTbGsRgPa1HPuObp0eqVyWoP
        Vr1xlop4sBUpRYXYPsvWhBkAFn79HqDqbIKqVKCrSrQJUhFC984eLFdyA/KectC8GIAC+w
        LK/wmTII6OOS5ydG2AC4jrt145uxP7L2DOX273HuVo2Uc+9sXMKpxjd3HJPwcZySLt9YJK
        A4X5XwIuCNIMpihIEGKCGnR2tffaWJKVTOYaIlMWnCl6zEYcHTqFycAL+8v7Sw==
From:   Michael Walle <michael@walle.cc>
To:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Sander Vanheule <sander@svanheule.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] regmap: Rework regmap_mdio_c45_{read|write} for new C45 API.
Date:   Mon, 16 Jan 2023 12:15:09 +0100
Message-Id: <20230116111509.4086236-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

The MDIO subsystem is getting rid of MII_ADDR_C45 and thus also
encoding associated encoding of the C45 device address and register
address into one value. regmap-mdio also uses this encoding for the
C45 bus.

Move to the new C45 helpers for MDIO access and provide regmap-mdio
helper macros.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
This is a revived patch from Andrew's tree.

Mark, could you Ack this instead of taking it through your tree,
because it future net-next changes will depend on it. There are
currently no in-tree users for this regmap. The Kconfig symbol is
never selected.

Andrew, I've changed some minor compilation errors and also
introduced the REGMAP_MDIO_C45_* macros. I think they are needed
by the users, who would otherwise use the MII_DEVADDR_C45_* macros.
---
 drivers/base/regmap/regmap-mdio.c | 41 +++++++++++++++++--------------
 include/linux/regmap.h            |  8 ++++++
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/base/regmap/regmap-mdio.c b/drivers/base/regmap/regmap-mdio.c
index f7293040a2b1..6aa6a2409478 100644
--- a/drivers/base/regmap/regmap-mdio.c
+++ b/drivers/base/regmap/regmap-mdio.c
@@ -10,31 +10,21 @@
 /* Clause-45 mask includes the device type (5 bit) and actual register number (16 bit) */
 #define REGNUM_C45_MASK		GENMASK(20, 0)
 
-static int regmap_mdio_read(struct mdio_device *mdio_dev, u32 reg, unsigned int *val)
+static int regmap_mdio_c22_read(void *context, unsigned int reg, unsigned int *val)
 {
+	struct mdio_device *mdio_dev = context;
 	int ret;
 
+	if (unlikely(reg & ~REGNUM_C22_MASK))
+		return -ENXIO;
+
 	ret = mdiodev_read(mdio_dev, reg);
 	if (ret < 0)
 		return ret;
 
 	*val = ret & REGVAL_MASK;
-	return 0;
-}
-
-static int regmap_mdio_write(struct mdio_device *mdio_dev, u32 reg, unsigned int val)
-{
-	return mdiodev_write(mdio_dev, reg, val);
-}
-
-static int regmap_mdio_c22_read(void *context, unsigned int reg, unsigned int *val)
-{
-	struct mdio_device *mdio_dev = context;
-
-	if (unlikely(reg & ~REGNUM_C22_MASK))
-		return -ENXIO;
 
-	return regmap_mdio_read(mdio_dev, reg, val);
+	return 0;
 }
 
 static int regmap_mdio_c22_write(void *context, unsigned int reg, unsigned int val)
@@ -55,21 +45,36 @@ static const struct regmap_bus regmap_mdio_c22_bus = {
 static int regmap_mdio_c45_read(void *context, unsigned int reg, unsigned int *val)
 {
 	struct mdio_device *mdio_dev = context;
+	unsigned int devad;
+	int ret;
 
 	if (unlikely(reg & ~REGNUM_C45_MASK))
 		return -ENXIO;
 
-	return regmap_mdio_read(mdio_dev, MII_ADDR_C45 | reg, val);
+	devad = reg >> REGMAP_MDIO_C45_DEVAD_SHIFT;
+	reg = reg & REGMAP_MDIO_C45_REGNUM_MASK;
+
+	ret = mdiodev_c45_read(mdio_dev, devad, reg);
+	if (ret < 0)
+		return ret;
+
+	*val = ret & REGVAL_MASK;
+
+	return 0;
 }
 
 static int regmap_mdio_c45_write(void *context, unsigned int reg, unsigned int val)
 {
 	struct mdio_device *mdio_dev = context;
+	unsigned int devad;
 
 	if (unlikely(reg & ~REGNUM_C45_MASK))
 		return -ENXIO;
 
-	return regmap_mdio_write(mdio_dev, MII_ADDR_C45 | reg, val);
+	devad = reg >> REGMAP_MDIO_C45_DEVAD_SHIFT;
+	reg = reg & REGMAP_MDIO_C45_REGNUM_MASK;
+
+	return mdiodev_c45_write(mdio_dev, devad, reg, val);
 }
 
 static const struct regmap_bus regmap_mdio_c45_bus = {
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a3bc695bcca0..029b9e09d3ca 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -38,6 +38,14 @@ struct regmap_field;
 struct snd_ac97;
 struct sdw_slave;
 
+/*
+ * regmap_mdio address encoding. IEEE 802.3ae clause 45 addresses consist of a
+ * device address and a register address.
+ */
+#define REGMAP_MDIO_C45_DEVAD_SHIFT	16
+#define REGMAP_MDIO_C45_DEVAD_MASK	GENMASK(20, 16)
+#define REGMAP_MDIO_C45_REGNUM_MASK	GENMASK(15, 0)
+
 /* An enum of all the supported cache types */
 enum regcache_type {
 	REGCACHE_NONE,
-- 
2.30.2

