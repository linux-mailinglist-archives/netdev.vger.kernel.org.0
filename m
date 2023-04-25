Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734456EE985
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbjDYVVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjDYVVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:21:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174E4358D
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682457613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kWTZ5Vho5SI03O9TKFPQvuOPYkH/1kX6orkuWFdd9rE=;
        b=PIRd8EqSdXYJ+ZTiSrisp5oC7Mk/S7bAXLChtEvS2Klw5AUg1sPj0o2BBwewLNVXMMsFQK
        7Bh52c8bqGAnJWapaDvCXFpt7F97Xn4TO7ZyfmAhPHzWt5l2zuZL+4FYjUDoCd2APUwrvF
        /s8pusFIEzQapOVrNciCUyiiyBx6YkQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-L9PvduteNKiuzFkg081fnA-1; Tue, 25 Apr 2023 17:20:05 -0400
X-MC-Unique: L9PvduteNKiuzFkg081fnA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA3C93C025B9;
        Tue, 25 Apr 2023 21:20:04 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E43E492B03;
        Tue, 25 Apr 2023 21:20:02 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next] net: phy: drop PHYLIB_LEDS knob
Date:   Tue, 25 Apr 2023 23:19:11 +0200
Message-Id: <c783f6b8d8cc08100b13ce50a1330913dd95dbce.1682457539.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 4bb7aac70b5d ("net: phy: fix circular LEDS_CLASS dependencies")
solved a build failure, but introduces a new config knob with a default
'y' value: PHYLIB_LEDS.

The latter is against the current new config policy. The exception
was raised to allow the user to catch bad configurations without led
support.

Anyway the current definition of PHYLIB_LEDS does not fit the above
goal: if LEDS_CLASS is disabled, the new config will be available
only with PHYLIB disabled, too.

Instead of building a more complex and error-prone dependency definition
it looks simpler and more in line with the mentioned policies use
IS_REACHABLE(CONFIG_LEDS_CLASS) instead of the new symbol.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
@Andrew, @Arnd: the rationale here is to avoid the new config knob=y,
which caused in the past a few complains from Linus. In this case I
think the raised exception is not valid, for the reason mentioned above.

If you have different preferences or better solutions to address that,
please voice them :)
---
 drivers/net/phy/Kconfig      | 9 ---------
 drivers/net/phy/phy_device.c | 2 +-
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 2f3ddc446cbb..f83420b86794 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -44,15 +44,6 @@ config LED_TRIGGER_PHY
 		<Speed in megabits>Mbps OR <Speed in gigabits>Gbps OR link
 		for any speed known to the PHY.
 
-config PHYLIB_LEDS
-	bool "Support probing LEDs from device tree"
-	depends on LEDS_CLASS=y || LEDS_CLASS=PHYLIB
-	depends on OF
-	default y
-	help
-	  When LED class support is enabled, phylib can automatically
-	  probe LED setting from device tree.
-
 config FIXED_PHY
 	tristate "MDIO Bus/PHY emulation with fixed speed/link PHYs"
 	select SWPHY
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 17d0d0555a79..fd28d389b00f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3288,7 +3288,7 @@ static int phy_probe(struct device *dev)
 	/* Get the LEDs from the device tree, and instantiate standard
 	 * LEDs for them.
 	 */
-	if (IS_ENABLED(CONFIG_PHYLIB_LEDS))
+	if (IS_REACHABLE(CONFIG_LEDS_CLASS))
 		err = of_phy_leds(phydev);
 
 out:
-- 
2.40.0

