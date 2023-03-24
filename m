Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4291E6C7B92
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbjCXJhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjCXJhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:37:05 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075C923D99;
        Fri, 24 Mar 2023 02:37:00 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 823AE10000B;
        Fri, 24 Mar 2023 09:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679650619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P2Hf3CyBE1M1ZSzvmtnhpsHtD4ulFZUJigNP2kIndHE=;
        b=FKAM9peeuA+PH2hCx7Lpn923cVj1ybMQ/8TN4DrVdmhszBYuujwIa6mzcq6xCgz2LFooEH
        gRPaihCd2v4Gy0JuvaPp2qBAxdy1dvUA09E9hxSdXMXu9NQ5L81dEB8F2ORsDn4CcqMO77
        KCHk++76+XpwvI9xaVr8eGz/Kt30CDbE9Gej7Z0Vwrd7j+TZsNtsGAurnFFmB/T+Ba1NWp
        2Ep+BbFpM/xJ5heCWM2ML0qRe19ghIGyPd72YWQFQbddCD1pVBE89D/KkTBZxU2SSRMt/1
        RSeaafTwQQ6hWslc7H7AWnoTiwLIYBidFhwb9cBE8cP6DDPefu/gf8swCKt/Vw==
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
Subject: [RFC 2/7] regmap: check for alignment on translated register addresses
Date:   Fri, 24 Mar 2023 10:36:39 +0100
Message-Id: <20230324093644.464704-3-maxime.chevallier@bootlin.com>
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

With regmap->reg_base and regmap->reg_downshift, the actual register
address that is going to be used for the next operation might not be the
same as the one we have as an input. Addresses can be offset with
reg_base and shifted, which will affect alignment.

Check for alignment on the real register address.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/base/regmap/regmap.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index a4e4367648bf..726f59612fd6 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2016,7 +2016,7 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
 {
 	int ret;
 
-	if (!IS_ALIGNED(reg, map->reg_stride))
+	if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
 		return -EINVAL;
 
 	map->lock(map->lock_arg);
@@ -2043,7 +2043,7 @@ int regmap_write_async(struct regmap *map, unsigned int reg, unsigned int val)
 {
 	int ret;
 
-	if (!IS_ALIGNED(reg, map->reg_stride))
+	if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
 		return -EINVAL;
 
 	map->lock(map->lock_arg);
@@ -2258,7 +2258,7 @@ int regmap_noinc_write(struct regmap *map, unsigned int reg,
 		return -EINVAL;
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
-	if (!IS_ALIGNED(reg, map->reg_stride))
+	if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
 		return -EINVAL;
 	if (val_len == 0)
 		return -EINVAL;
@@ -2399,7 +2399,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	int ret = 0, i;
 	size_t val_bytes = map->format.val_bytes;
 
-	if (!IS_ALIGNED(reg, map->reg_stride))
+	if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
 		return -EINVAL;
 
 	/*
@@ -2638,7 +2638,7 @@ static int _regmap_multi_reg_write(struct regmap *map,
 			int reg = regs[i].reg;
 			if (!map->writeable_reg(map->dev, reg))
 				return -EINVAL;
-			if (!IS_ALIGNED(reg, map->reg_stride))
+			if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
 				return -EINVAL;
 		}
 
@@ -2789,7 +2789,7 @@ int regmap_raw_write_async(struct regmap *map, unsigned int reg,
 
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
-	if (!IS_ALIGNED(reg, map->reg_stride))
+	if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
 		return -EINVAL;
 
 	map->lock(map->lock_arg);
@@ -2911,7 +2911,7 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
 {
 	int ret;
 
-	if (!IS_ALIGNED(reg, map->reg_stride))
+	if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
 		return -EINVAL;
 
 	map->lock(map->lock_arg);
@@ -2945,7 +2945,7 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
-	if (!IS_ALIGNED(reg, map->reg_stride))
+	if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
 		return -EINVAL;
 	if (val_count == 0)
 		return -EINVAL;
@@ -3040,7 +3040,7 @@ int regmap_noinc_read(struct regmap *map, unsigned int reg,
 
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
-	if (!IS_ALIGNED(reg, map->reg_stride))
+	if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
 		return -EINVAL;
 	if (val_len == 0)
 		return -EINVAL;
@@ -3162,7 +3162,7 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 	size_t val_bytes = map->format.val_bytes;
 	bool vol = regmap_volatile_range(map, reg, val_count);
 
-	if (!IS_ALIGNED(reg, map->reg_stride))
+	if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
 		return -EINVAL;
 	if (val_count == 0)
 		return -EINVAL;
-- 
2.39.2

