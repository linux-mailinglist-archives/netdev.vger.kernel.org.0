Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3378545DCDC
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhKYPJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:09:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238674AbhKYPHG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 10:07:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20F8960462;
        Thu, 25 Nov 2021 15:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637852634;
        bh=yndRvHbJPTzQ21iecHFbJ+gUx1juTKox9yYhQjkGgGw=;
        h=From:To:Cc:Subject:Date:From;
        b=gT2qwRcHZF4Y5MTegZuBNOTCEyULudCtCeobAVYTR94PhatpCRROzIF9JeLYN70re
         h9OTYwthYMYjSjHjQ5jL7luxsCIkXAW2KwaomyQkBNMOPf+Q1dUk/mf2tfURBwpJ+q
         SqMbENaY9t4/0YfhzocuO0KR+GOGBFEo/TlEg6wyv9ovZm57ZcpeNcBWtURo8y5QwM
         0siZdTdyq0xHlIQUihEmY3663sbNtNQyqenTtZnGU8QFbPP/dPd0cK16BQq4EDxNwG
         LogKRKLlxYzIFTwB1CaisGm+SNCKeZb8gLJnnX7L4obfGN/yMnnHUVvZC2ajHbeAaE
         N0k4UVKDCBopw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net RFC] net: dsa: mv88e6xxx: Fix forcing speed & duplex when changing to 2500base-x mode
Date:   Thu, 25 Nov 2021 16:03:49 +0100
Message-Id: <20211125150349.18789-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 64d47d50be7a ("net: dsa: mv88e6xxx: configure interface settings
in mac_config") removed forcing of speed and duplex from
mv88e6xxx_mac_config(), where the link is forced down, and left it only
in mv88e6xxx_mac_link_up(), by which time link is unforced.

It seems that in 2500base-x (at least on 88E6190), if the link is not
forced down, the forcing of new settings for speed and duplex doesn't
take.

Fix this by forcing link down.

Fixes: 64d47d50be7a ("net: dsa: mv88e6xxx: configure interface settings in mac_config")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
The patch was tested on 6352, 6190, 6141 and 6393x, and should work
correctly on all models where SerDes is on separate registers from
port registers, but we don't know what would happen for on 6185, where
SerDes status is read from port registers.

I would like to get some comments on this fix before applying,
preferably from someone who can test this on 88E6185 on port which
supports 1000base-x / sgmii (port 7, 8 or 9).

Russell King says (from conversation on IRC):
  I'm still feeling uneasy about it, because forcing the link down in
  mac_link_up just feels wrong... it should already be down with the
  exception of an in-band link... but I'm also wondering if we're in
  2500base-x mode, shouldn't the hardware already be operating in 2.5G

  I'm wondering if the exception for in-band links needs to be
  conditional upon forcing it down having an effect on the PCS status

  looking at the 6352, which has the port controls separate from the
  serdes controls, and we use the serdes as the PCS, it looks like
  forcing the link down

  but on 6185, we don't have a separate serdes, and we rely on the port
  registers

  ...

  I think probably the best thing is to post it, ask for testing for
  the 6185 where one of the 7,8,9 ports is using 1000base-X

  if no one's using such a configuration... then we're not breaking
  anything
---
 drivers/net/dsa/mv88e6xxx/chip.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7ed420128cea..ebeb8500c3f8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -785,12 +785,17 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 	if ((!mv88e6xxx_phy_is_internal(ds, port) &&
 	     !mv88e6xxx_port_ppu_updates(chip, port)) ||
 	    mode == MLO_AN_FIXED) {
-		/* FIXME: for an automedia port, should we force the link
-		 * down here - what if the link comes up due to "other" media
-		 * while we're bringing the port up, how is the exclusivity
-		 * handled in the Marvell hardware? E.g. port 2 on 88E6390
-		 * shared between internal PHY and Serdes.
+		/* FIXME: we need to force the link down here, otherwise the
+		 * forcing of link speed and duplex by .port_set_speed_duplex()
+		 * doesn't work for some modes.
+		 * But what if the link comes up due to "other" media while
+		 * we're bringing the port up, how is the exclusivity handled in
+		 * the Marvell hardware? E.g. port 2 on 88E6390 shared between
+		 * internal PHY and Serdes.
 		 */
+		if (ops->port_sync_link)
+			err = ops->port_sync_link(chip, port, mode, false);
+
 		err = mv88e6xxx_serdes_pcs_link_up(chip, port, mode, speed,
 						   duplex);
 		if (err)
-- 
2.32.0

