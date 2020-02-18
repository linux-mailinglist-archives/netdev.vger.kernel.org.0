Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8911625B7
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 12:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgBRLqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 06:46:30 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52480 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgBRLq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 06:46:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kGCZZPfE0J2ZUir5tm3eNXimaURxlsPoBGldmwXkzZ8=; b=JS7nmu9oldZdnC4VpYBi39R20/
        v6DIuhFdbO/fbvwx5TUlkHCMVsMTFIKWJ++wfoTP+Dg8jFqIHA4IkqlAWCfzzaWRakQDt88wiEcD0
        oMJ1BhnI8vdyBtSJs8aw6H85gbSd3ZEqKqZJN7Bd6O5RHUQs4sqQ2ixh0jP9NUMev5kdolLqoCliJ
        erhNNZG2xSa8A/el57L7IOx9yhjoN3bthzu5HRRjV+VhC22yrbsXQLxhNZaeZuvdcxbPMI3iQcu7v
        tBmP/LdyfEfM68dA6h68lXlzcu1PrZbpae7WraZz7ZIiKUCREA1VwxEOKty93nPAM/F30Z9CJFEXv
        1wN2fGpQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:56556 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j41KR-0006ws-HM; Tue, 18 Feb 2020 11:46:15 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j41KQ-0002uy-TQ; Tue, 18 Feb 2020 11:46:14 +0000
In-Reply-To: <20200218114515.GL18808@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: dsa: mv88e6xxx: fix duplicate vlan warning
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j41KQ-0002uy-TQ@rmk-PC.armlinux.org.uk>
Date:   Tue, 18 Feb 2020 11:46:14 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting VLANs on DSA switches, the VLAN is added to both the port
concerned as well as the CPU port by dsa_slave_vlan_add().  If multiple
ports are configured with the same VLAN ID, this triggers a warning on
the CPU port.

Avoid this warning for CPU ports.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 4ec09cc8dcdc..629eb7bbbb23 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1795,7 +1795,7 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
 }
 
 static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
-				    u16 vid, u8 member)
+				    u16 vid, u8 member, bool warn)
 {
 	const u8 non_member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER;
 	struct mv88e6xxx_vtu_entry vlan;
@@ -1840,7 +1840,7 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
 		err = mv88e6xxx_vtu_loadpurge(chip, &vlan);
 		if (err)
 			return err;
-	} else {
+	} else if (warn) {
 		dev_info(chip->dev, "p%d: already a member of VLAN %d\n",
 			 port, vid);
 	}
@@ -1854,6 +1854,7 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	bool warn;
 	u8 member;
 	u16 vid;
 
@@ -1867,10 +1868,15 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	else
 		member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_TAGGED;
 
+	/* net/dsa/slave.c will call dsa_port_vlan_add() for the affected port
+	 * and then the CPU port. Do not warn for duplicates for the CPU port.
+	 */
+	warn = !dsa_is_cpu_port(ds, port);
+
 	mv88e6xxx_reg_lock(chip);
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
-		if (mv88e6xxx_port_vlan_join(chip, port, vid, member))
+		if (mv88e6xxx_port_vlan_join(chip, port, vid, member, warn))
 			dev_err(ds->dev, "p%d: failed to add VLAN %d%c\n", port,
 				vid, untagged ? 'u' : 't');
 
-- 
2.20.1

