Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9434963F62C
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 18:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiLARe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 12:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLARe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 12:34:27 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E6692A0F;
        Thu,  1 Dec 2022 09:34:26 -0800 (PST)
Received: from localhost.localdomain (unknown [81.5.110.16])
        by mail.ispras.ru (Postfix) with ESMTPSA id 2605440D4004;
        Thu,  1 Dec 2022 17:34:22 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 2605440D4004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1669916062;
        bh=1Yld3/6UrtN3Zfgf3UojbyOQXGmtYGVa6e3vHIqgirg=;
        h=From:To:Cc:Subject:Date:From;
        b=jgYoo7JcltneHCFmNbgYXH8Hj+3mR2lkhRLFW/8ZWR34wZWSx15Wrg7GXFlQ5Ma42
         vFiKki6aYExBWhk8jNAXeZnYqbMkj0zSXq45MN93DaX8Y2fhC/Qoc7XH056YlMfJFy
         rCNa7PeHrXr4HgxiRJj/gcHMJqjjvmf8u9c7DVH0=
From:   Valentina Goncharenko <goncharenko.vp@ispras.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Valentina Goncharenko <goncharenko.vp@ispras.ru>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jon Ringle <jringle@gridpoint.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH 1/2] net: encx24j600: Add parentheses to fix precedence
Date:   Thu,  1 Dec 2022 20:34:07 +0300
Message-Id: <20221201173408.26954-1-goncharenko.vp@ispras.ru>
X-Mailer: git-send-email 2.25.1
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

In functions regmap_encx24j600_phy_reg_read() and
regmap_encx24j600_phy_reg_write() in the conditions of the waiting
cycles for filling the variable 'ret' it is necessary to add parentheses
to prevent wrong assignment due to logical operations precedence.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d70e53262f5c ("net: Microchip encx24j600 driver")
Signed-off-by: Valentina Goncharenko <goncharenko.vp@ispras.ru>
---
 drivers/net/ethernet/microchip/encx24j600-regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index 81a8ccca7e5e..2e337c7a5773 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -359,7 +359,7 @@ static int regmap_encx24j600_phy_reg_read(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
@@ -397,7 +397,7 @@ static int regmap_encx24j600_phy_reg_write(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
-- 
2.25.1

