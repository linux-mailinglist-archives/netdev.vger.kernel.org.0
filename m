Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977033CC33D
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 14:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhGQMfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 08:35:53 -0400
Received: from phobos.denx.de ([85.214.62.61]:54578 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhGQMfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Jul 2021 08:35:52 -0400
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 8AEEF81E47;
        Sat, 17 Jul 2021 14:32:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1626525175;
        bh=UskjqA6F+AQy9nhvBVhpfasWucpUXDwQofnPqvUZ1R8=;
        h=From:To:Cc:Subject:Date:From;
        b=XcqBP5TKakpwZZmC3AIKb8dki4M1UtJgZ+TSpW8g5aWeALbpo8FBUB1Mmx/9ItKbg
         v17vqxtQW58cl0aJ6emSwP2jDs43BNxZ4QahSR+JT2+TaheHuc+yUHTdia27xivq4Z
         4xR8B3ppbTSAI9Gkwli1pk2I6Q9otWDqpTy7emuLaWSjm+VUbEEkoWoHUg2GGRldVQ
         InS9PVkr3qx0Ut3Q7h3jQ3kJXsqHXQdGEOyNhL0m+0AvZ4iH/zoOqskU/D0oL6unz7
         HjfZSXyLdZBg+3Wv+k+ceamu3ALD8JM1QRnqHxmirBsRyaZJ85oOk6awOW/Yks4Nys
         AoIfWGD9AbbgQ==
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] net: phy: Fix data type in DP83822 dp8382x_disable_wol()
Date:   Sat, 17 Jul 2021 14:32:49 +0200
Message-Id: <20210717123249.56505-1-marex@denx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last argument of phy_clear_bits_mmd(..., u16 val); is u16 and not
int, just inline the value into the function call arguments.

No functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/phy/dp83822.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index f7a2ec150e54..211b5476a6f5 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -326,11 +326,9 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
 
 static int dp8382x_disable_wol(struct phy_device *phydev)
 {
-	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
-		    DP83822_WOL_SECURE_ON;
-
-	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
-				  MII_DP83822_WOL_CFG, value);
+	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
+				  DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
+				  DP83822_WOL_SECURE_ON);
 }
 
 static int dp83822_read_status(struct phy_device *phydev)
-- 
2.30.2

