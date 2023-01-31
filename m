Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056CD6829CC
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjAaKA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjAaKAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:00:53 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14E44ABF6;
        Tue, 31 Jan 2023 02:00:46 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 79BB91C0003;
        Tue, 31 Jan 2023 10:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675159245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aZg/iDWxJ7+7iB6HjrlykOAfUIjKx7WrcYo/FUoXaHA=;
        b=kq3aI+oYfe/kfZ5btHKDVbJE8LcUPQVmUQr8mSsYlYnPBMu1JIq3A+LtMZ/Icjwuo9ZjrM
        pUOnT1hCZRlbgHaDwlEWufBdbUY0zE6uWyEYw1Vz6sdnVu5jUoGoxZkAPWqITFC9uJOAIV
        PGDGJJb96HC4iRczrw006pzPrwruLE1BdAA7BJM/nUPq6Asr+5WdvrM/OQwzpZ85BDzvjn
        gAZnCWxvoL3AM24GIGkfc+BAY8kdDYq87SjjbO4h1htl21GAuZVBNCcCQIC8GjnCx+RakN
        LU2NCRsgP4FNpNTAjhZ7PIBTEg/V2Xy76Q73R0uJiQdmHVsaR+zw99xrMOpkSg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Grant Likely <grant.likely@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: phylink: move phy_device_free() to correctly release phy device
Date:   Tue, 31 Jan 2023 11:02:42 +0100
Message-Id: <20230131100242.33514-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After calling fwnode_phy_find_device(), the phy device refcount is
incremented. Then, when the phy device is attached to a netdev with
phy_attach_direct(), the refcount is also incremented but only
decremented in the caller if phy_attach_direct() fails. Move
phy_device_free() before the "if" to always release it correctly.
Indeed, either phy_attach_direct() failed and we don't want to keep a
reference to the phydev or it succeeded and a reference has been taken
internally.

Fixes: 25396f680dd6 ("net: phylink: introduce phylink_fwnode_phy_connect()")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/phy/phylink.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 09cc65c0da93..4d2519cdb801 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1812,10 +1812,9 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
-	if (ret) {
-		phy_device_free(phy_dev);
+	phy_device_free(phy_dev);
+	if (ret)
 		return ret;
-	}
 
 	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
 	if (ret)
-- 
2.39.0

