Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A841845A6BE
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 16:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbhKWPrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 10:47:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhKWPrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 10:47:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8C2060E95;
        Tue, 23 Nov 2021 15:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637682250;
        bh=btRYTaHCmjH9uj+Fvf6SHDefw6YLIZdYbiSMoayTVfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVFhe6wdML9M98yJ+t6JZkE/8vfqwN88JusfPM1UTtxMLsTeuC1luqq6jIJ300Piz
         QYB2x8Wq4THoYPPUh3a4f1pEBly382AoLMn4eP366w4q+g3Mc4e/tN0DH9xKolY5OM
         PBa9UgedwDQ71K1Jy8zxQdDpYVXUTcNl3WwhIJu+DL4wxf1+Xr46ptVZfhWU+yKiN6
         N4C/fDDo83U2QggGOiSbUFCpvGefddwB5CKvzqZD4N5byhlymb53RYOd5RWTOBocaj
         IT5qT0j2nA9H1HLIkTdxI3wlcQi0Ubesi9U5qkG9eqpuOnkHRddZoMVjHS6KdAOgOV
         sFIfwo5JcFlfA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 1/2] net: phylink: Force link down and retrigger resolve on interface change
Date:   Tue, 23 Nov 2021 16:44:02 +0100
Message-Id: <20211123154403.32051-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123154403.32051-1-kabel@kernel.org>
References: <20211123154403.32051-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

On PHY state change the phylink_resolve() function can read stale
information from the MAC and report incorrect link speed and duplex to
the kernel message log.

Example with a Marvell 88X3310 PHY connected to a SerDes port on Marvell
88E6393X switch:
- PHY driver triggers state change due to PHY interface mode being
  changed from 10gbase-r to 2500base-x due to copper change in speed
  from 10Gbps to 2.5Gbps, but the PHY itself either hasn't yet changed
  its interface to the host, or the interrupt about loss of SerDes link
  hadn't arrived yet (there can be a delay of several milliseconds for
  this), so we still think that the 10gbase-r mode is up
- phylink_resolve()
  - phylink_mac_pcs_get_state()
    - this fills in speed=10g link=up
  - interface mode is updated to 2500base-x but speed is left at 10Gbps
  - phylink_major_config()
    - interface is changed to 2500base-x
  - phylink_link_up()
    - mv88e6xxx_mac_link_up()
      - .port_set_speed_duplex()
        - speed is set to 10Gbps
    - reports "Link is Up - 10Gbps/Full" to dmesg

Afterwards when the interrupt finally arrives for mv88e6xxx, another
resolve is forced in which we get the correct speed from
phylink_mac_pcs_get_state(), but since the interface is not being
changed anymore, we don't call phylink_major_config() but only
phylink_mac_config(), which does not set speed/duplex anymore.

To fix this, we need to force the link down and trigger another resolve
on PHY interface change event.

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phylink.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 3603c024109a..5b8b61daeb98 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -963,6 +963,7 @@ static void phylink_resolve(struct work_struct *w)
 	struct phylink_link_state link_state;
 	struct net_device *ndev = pl->netdev;
 	bool mac_config = false;
+	bool retrigger = false;
 	bool cur_link_state;
 
 	mutex_lock(&pl->state_mutex);
@@ -976,6 +977,7 @@ static void phylink_resolve(struct work_struct *w)
 		link_state.link = false;
 	} else if (pl->mac_link_dropped) {
 		link_state.link = false;
+		retrigger = true;
 	} else {
 		switch (pl->cur_link_an_mode) {
 		case MLO_AN_PHY:
@@ -1000,6 +1002,15 @@ static void phylink_resolve(struct work_struct *w)
 
 			/* Only update if the PHY link is up */
 			if (pl->phydev && pl->phy_state.link) {
+				/* If the interface has changed, force a
+				 * link down event if the link isn't already
+				 * down, and re-resolve.
+				 */
+				if (link_state.interface !=
+				    pl->phy_state.interface) {
+					retrigger = true;
+					link_state.link = false;
+				}
 				link_state.interface = pl->phy_state.interface;
 
 				/* If we have a PHY, we need to update with
@@ -1042,7 +1053,7 @@ static void phylink_resolve(struct work_struct *w)
 		else
 			phylink_link_up(pl, link_state);
 	}
-	if (!link_state.link && pl->mac_link_dropped) {
+	if (!link_state.link && retrigger) {
 		pl->mac_link_dropped = false;
 		queue_work(system_power_efficient_wq, &pl->resolve);
 	}
-- 
2.32.0

