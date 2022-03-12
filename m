Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860E44D714D
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 23:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiCLWmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 17:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiCLWmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 17:42:54 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B581C2F78;
        Sat, 12 Mar 2022 14:41:48 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E854422239;
        Sat, 12 Mar 2022 23:41:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647124906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=41OBeTclfUqu9E10Glc2yaP92LM2mbCEsKFyGzia5ns=;
        b=Bcn6TJQ5PIRq9iL30BAkPa0a8pZNAeeweCiUUFVv+KPsAq9+0DdqDKkFsyjIS7dpq4sim6
        C+/u3gQgAL2fZqiP748QRXdhRJ2zkqBpLsk1qEF5tOZqGeDzmw8ZZHFI7M/gwtxYO8wnBt
        3d1Oull4pGs6zUkgaUiE8/unIaV7tJk=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net] net: mdio: mscc-miim: fix duplicate debugfs entry
Date:   Sat, 12 Mar 2022 23:41:40 +0100
Message-Id: <20220312224140.4173930-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver can have up to two regmaps. If the second one is registered
its debugfs entry will have the same name as the first one and the
following error will be printed:

[    3.833521] debugfs: Directory 'e200413c.mdio' with parent 'regmap' already present!

Give the second regmap a name to avoid this.

Fixes: a27a76282837 ("net: mdio: mscc-miim: convert to a regmap implementation")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/mdio/mdio-mscc-miim.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index dfd7f3001a15..fc5655328b1f 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -197,6 +197,13 @@ static const struct regmap_config mscc_miim_regmap_config = {
 	.reg_stride	= 4,
 };
 
+static const struct regmap_config mscc_miim_phy_regmap_config = {
+	.reg_bits	= 32,
+	.val_bits	= 32,
+	.reg_stride	= 4,
+	.name		= "phy",
+};
+
 int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
 		    struct regmap *mii_regmap, int status_offset)
 {
@@ -260,7 +267,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		}
 
 		phy_regmap = devm_regmap_init_mmio(&pdev->dev, phy_regs,
-						   &mscc_miim_regmap_config);
+						   &mscc_miim_phy_regmap_config);
 		if (IS_ERR(phy_regmap)) {
 			dev_err(&pdev->dev, "Unable to create phy register regmap\n");
 			return PTR_ERR(phy_regmap);
-- 
2.30.2

