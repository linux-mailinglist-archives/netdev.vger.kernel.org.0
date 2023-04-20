Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8D56E8D0C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbjDTIql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbjDTIqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:46:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74E5448F;
        Thu, 20 Apr 2023 01:46:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54DF2640BF;
        Thu, 20 Apr 2023 08:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C34FC433EF;
        Thu, 20 Apr 2023 08:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681980391;
        bh=jAAc7mhrkz2LrFCwa/9pwGLcpUffUuXN/d4ElfEWUrQ=;
        h=From:To:Cc:Subject:Date:From;
        b=UbVbab3qAMZvdUkmgWLfwm2mXZ7qdcu71nt2dch6jIE16HaRAvAsO7U5nEkW6zCUw
         S+9wo6Ot7A9KqH2TV/vruJzfT/N7PY5KM25Y70jQvOq0SLV71BncpI54S02tMNJGuh
         /N2kH6+Ibd/csm+jVRV5EVDbnSejmF3rl5Cr/AQDCDV0f7ikYjucqE85W4aZmsdyFu
         3Z6CZeKuodwKFV8IqV0DiEoYQIVar2jjadJMTPInP1HhP5lrg4Q0OauATVixND+4fb
         SyUiVrnYVEH/ereL+kV/dUbdI7uTtYqP9+dMM+mvqa8WKX9Uxm6/cfP1pgCYNoEuzp
         KqP24Wdzyf3+Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Frank Sae <Frank.Sae@motor-comm.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: fix circular LEDS_CLASS dependencies
Date:   Thu, 20 Apr 2023 10:45:51 +0200
Message-Id: <20230420084624.3005701-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The CONFIG_PHYLIB symbol is selected by a number of device drivers that
need PHY support, but it now has a dependency on CONFIG_LEDS_CLASS,
which may not be enabled, causing build failures.

Avoid the risk of missing and circular dependencies by guarding the
phylib LED support itself in another Kconfig symbol that can only be
enabled if the dependency is met.

This could be made a hidden symbol and always enabled when both CONFIG_OF
and CONFIG_LEDS_CLASS are reachable from the phylib, but there may be an
advantage in having users see this option when they have a misconfigured
kernel without built-in LED support.

Fixes: 01e5b728e9e4 ("net: phy: Add a binding for PHY LEDs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/phy/Kconfig      | 9 ++++++++-
 drivers/net/phy/phy_device.c | 3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index b8cc49820ced..513675ae4dd2 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -18,7 +18,6 @@ menuconfig PHYLIB
 	depends on NETDEVICES
 	select MDIO_DEVICE
 	select MDIO_DEVRES
-	depends on LEDS_CLASS || LEDS_CLASS=n
 	help
 	  Ethernet controllers are usually attached to PHY
 	  devices.  This option provides infrastructure for
@@ -45,6 +44,14 @@ config LED_TRIGGER_PHY
 		<Speed in megabits>Mbps OR <Speed in gigabits>Gbps OR link
 		for any speed known to the PHY.
 
+config PHYLIB_LEDS
+	bool "Support probing LEDs from device tree"
+	depends on LEDS_CLASS=y || LEDS_CLASS=PHYLIB
+	depends on OF
+	default y
+	help
+	  When LED class support is enabled, phylib can automatically
+	  probe LED setting from device tree.
 
 config FIXED_PHY
 	tristate "MDIO Bus/PHY emulation with fixed speed/link PHYs"
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 538523a7cd51..d373446ab5ac 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3284,7 +3284,8 @@ static int phy_probe(struct device *dev)
 	/* Get the LEDs from the device tree, and instantiate standard
 	 * LEDs for them.
 	 */
-	err = of_phy_leds(phydev);
+	if (IS_ENABLED(CONFIG_PHYLIB_LEDS))
+		err = of_phy_leds(phydev);
 
 out:
 	/* Re-assert the reset signal on error */
-- 
2.39.2

