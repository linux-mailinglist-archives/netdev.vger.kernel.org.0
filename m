Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA501705D9
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgBZRTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:19:13 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51272 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgBZRTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:19:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IGe5ttkspNdSlvEWltQ5I5AVLTm9HkEoXTUVivLKwmU=; b=wcAl2m00PV9tiPXKSxtdKQFJWH
        gujwk1Zb9kguNETgSZ960bzNTncGxL/W/MA7HIxrIBpMXzocEx/swOHdRJdV6USPXhFeF0GOEH6E4
        UAqEvprWekA/bMnDam7nOcsHjehvUOF2DpIspOUA8jNBD0F5Vpklz8YM3WfBWLIN3TVATkCKPvRmp
        stzgT83EiMJMwrB5FOIR0BLcQ5B8WhD7MxOja0yoas15SiUZmd+YNQkLSJZ1PNqWvB5FLVbPmpVmz
        8YR6W4iwkW8Gk6U5VHhFpv4hBNZRn0CyBncxCz8Jqnc5SfEM+Mci+o9ELxF3DVtXp6rvu4UJSKCqQ
        yYLTxRCA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:54666 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j70GR-0000Pj-Ok; Wed, 26 Feb 2020 17:14:27 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j70GQ-0004Nz-FS; Wed, 26 Feb 2020 17:14:26 +0000
In-Reply-To: <20200226171349.GD25745@shell.armlinux.org.uk>
References: <20200226171349.GD25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v3 2/2] net: dsa: mv88e6xxx: fix duplicate vlan
 warning
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j70GQ-0004Nz-FS@rmk-PC.armlinux.org.uk>
Date:   Wed, 26 Feb 2020 17:14:26 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting VLANs on DSA switches, the VLAN is added to both the port
concerned as well as the CPU port by dsa_slave_vlan_add(), as well as
any DSA ports.  If multiple ports are configured with the same VLAN ID,
this triggers a warning on the CPU and DSA ports.

Avoid this warning for CPU and DSA ports.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 4ec09cc8dcdc..705c118f6fdd 100644
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
+	warn = !dsa_is_cpu_port(ds, port) && !dsa_is_dsa_port(ds, port);
+
 	mv88e6xxx_reg_lock(chip);
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
-		if (mv88e6xxx_port_vlan_join(chip, port, vid, member))
+		if (mv88e6xxx_port_vlan_join(chip, port, vid, member, warn))
 			dev_err(ds->dev, "p%d: failed to add VLAN %d%c\n", port,
 				vid, untagged ? 'u' : 't');
 
-- 
2.20.1

