Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B744366BCE
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240963AbhDUNHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240968AbhDUNGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 09:06:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C81C06138D
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 06:05:48 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lZCY3-0006AR-M4; Wed, 21 Apr 2021 15:05:43 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lZCY2-0004qf-Bi; Wed, 21 Apr 2021 15:05:42 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v1] net: dsa: fix bridge support for drivers without port_bridge_flags callback
Date:   Wed, 21 Apr 2021 15:05:40 +0200
Message-Id: <20210421130540.12522-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with patch:
a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")

drivers without "port_bridge_flags" callback will fail to join the bridge.
Looking at the code, -EOPNOTSUPP seems to be the proper return value,
which makes at least microchip and atheros switches work again.

Fixes: a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/dsa/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 01e30264b25b..6379d66a6bb3 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -550,7 +550,7 @@ int dsa_port_bridge_flags(const struct dsa_port *dp,
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->port_bridge_flags)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	return ds->ops->port_bridge_flags(ds, dp->index, flags, extack);
 }
-- 
2.29.2

