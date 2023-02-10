Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE84692399
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 17:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbjBJQrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 11:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjBJQrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 11:47:39 -0500
X-Greylist: delayed 1812 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Feb 2023 08:47:37 PST
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEDEEB72
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 08:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding;
        bh=JyAhWn70jSZ6baYcHd8LQtrCGh6bwhtu+2O+5t5dzvI=;
        b=VBJ/7MJ0sDWiRfyXEfQBGEoFzqBjSmeksfJJYQJs/yIWjh/EkNXpVth7x8wFF1LQXBD76s2I0O5k9
         o6pxvHuqUndAjp1iUEIyOD9eKkQhJH+5ihAP5TiiU3xAZAPOJzAvV43tb+8f0X2GJZxpA7YtwOMy2G
         RvY5PSIlD/kbtsVCxxYBfuPSJ8y7dtN0PrNKxlya22c84UwyCB1tPySohEgA/XV4I/z+WAS4Egk6FE
         9HRs8BZccUaA0DvdoeULWJtn4Rs7SkRyN5gtyqNIQ42leqKY66oX1I3eiRZzLBSgHrphWAEMfgcCkC
         9Xn7+v/4PMR17yVpyx9JK9I2SEM1H0g==
X-Final-To: netdev@vger.kernel.org, i.bornyakov@metrotek.ru, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, system@metrotek.ru
Received: from localhost.localdomain ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Fri, 10 Feb 2023 18:46:46 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     netdev@vger.kernel.org
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        system@metrotek.ru
Subject: [PATCH net-next] net: phylink: support validated pause and autoneg in fixed-link
Date:   Fri, 10 Feb 2023 18:46:27 +0300
Message-Id: <20230210154627.19086-1-i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In fixed-link setup phylink_parse_fixedlink() unconditionally sets
Pause, Asym_Pause and Autoneg bits to "supported" bitmap, while MAC may
not support these.

This leads to ethtool reporting:

 > Supported pause frame use: Symmetric Receive-only
 > Supports auto-negotiation: Yes

regardless of what is actually supported.

Instead of unconditionally set Pause, Asym_Pause and Autoneg it is
sensible to set them according to validated "supported" bitmap, i.e. the
result of phylink_validate().

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/phylink.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2805b04d6402..ba5d3868604b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -688,6 +688,7 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 				   struct fwnode_handle *fwnode)
 {
 	struct fwnode_handle *fixed_node;
+	bool pause, asym_pause, autoneg;
 	const struct phy_setting *s;
 	struct gpio_desc *desc;
 	u32 speed;
@@ -760,13 +761,23 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 	linkmode_copy(pl->link_config.advertising, pl->supported);
 	phylink_validate(pl, pl->supported, &pl->link_config);
 
+	pause = phylink_test(pl->supported, Pause);
+	asym_pause = phylink_test(pl->supported, Asym_Pause);
+	autoneg = phylink_test(pl->supported, Autoneg);
 	s = phy_lookup_setting(pl->link_config.speed, pl->link_config.duplex,
 			       pl->supported, true);
 	linkmode_zero(pl->supported);
 	phylink_set(pl->supported, MII);
-	phylink_set(pl->supported, Pause);
-	phylink_set(pl->supported, Asym_Pause);
-	phylink_set(pl->supported, Autoneg);
+
+	if (pause)
+		phylink_set(pl->supported, Pause);
+
+	if (asym_pause)
+		phylink_set(pl->supported, Asym_Pause);
+
+	if (autoneg)
+		phylink_set(pl->supported, Autoneg);
+
 	if (s) {
 		__set_bit(s->bit, pl->supported);
 		__set_bit(s->bit, pl->link_config.lp_advertising);
-- 
2.39.1


