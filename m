Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BC18921E
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 17:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfHKPIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 11:08:15 -0400
Received: from mail.nic.cz ([217.31.204.67]:50424 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbfHKPIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 11:08:15 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 06339140AE8;
        Sun, 11 Aug 2019 17:08:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565536093; bh=peqVi3Kr/YFr7ZQTja6Q4tk5oqFPjW1MCqMTxD+/tX4=;
        h=From:To:Date;
        b=oS6GIPEsubKSr6c68YD2CP+42Os7FyIP+cJA5YbCyPxPyk9DDUfm5O3cE05zV8a2e
         S1ndYFbNNWz9Y17kb6lP6JgIpn1GtgJDNo/m3t/QPojoCMFJHUxDm5dbQrRRSdXoFr
         Ws/m0wofLKFHaBhQa3TpOurcLRW1ufg6wsmB1sLM=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next 1/2] net: dsa: mv88e6xxx: fix RGMII-ID port setup
Date:   Sun, 11 Aug 2019 17:08:11 +0200
Message-Id: <20190811150812.6780-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6xxx_port_setup_mac looks if one of the {link, speed, duplex}
parameters is being changed from the current setting, and if not, does
not do anything. This test is wrong in some situations: this method also
has the mode argument, which can also be changed.

For example on Turris Omnia, the mode is PHY_INTERFACE_MODE_RGMII_ID,
which has to be set byt the ->port_set_rgmii_delay method. The test does
not look if mode is being changed (in fact there is currently no method
to determine port mode as phy_interface_t type).

The simplest solution seems to be to drop this test altogether and
simply do the setup when requested.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2e8b1ab2c6f7..aae63f6515b3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -420,15 +420,6 @@ int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 	if (err)
 		return err;
 
-	/* Has anything actually changed? We don't expect the
-	 * interface mode to change without one of the other
-	 * parameters also changing
-	 */
-	if (state.link == link &&
-	    state.speed == speed &&
-	    state.duplex == duplex)
-		return 0;
-
 	/* Port's MAC control must not be changed unless the link is down */
 	err = chip->info->ops->port_set_link(chip, port, 0);
 	if (err)
-- 
2.21.0

