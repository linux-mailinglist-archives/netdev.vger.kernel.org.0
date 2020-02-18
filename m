Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED58F1625B8
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 12:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgBRLqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 06:46:36 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52498 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgBRLqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 06:46:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=elyYOg3YX4wWmRsgH1KfPyyX/So1dzrnxEODItYA0J4=; b=xzfPYp3bRes3kT7G6LPz7qu/vK
        kavSLtcHN0bNlhlpRaskh0M3ikbRpdEwoNhHxo/mmDrBRnryl7Y3kpSWViqB2sQUuVHpyOCl5kX3m
        6OjpBUbHJcsuMrd7gmISgSm6yL49U1erxk4KOhDxjh9w1z6DynPcm57tuVIdYCReGpZWc8OiWR8eF
        OgCJ9JejAyTs7i7tfC8hgOea+n+ADBnPNLHFwI72g7clKic7srvA0IzYcXkynRaWVBcHYdQpuNEWj
        ZWGfLv36JrZPHeaYj3IGixcNhYDuOGwBsPv2N+9x4n/DTyWra9BUD5HN4uUef69yjkFedhjT4cuJW
        m2dxhZTw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:40514 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j41KY-0006x2-KF; Tue, 18 Feb 2020 11:46:22 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j41KW-0002v5-2S; Tue, 18 Feb 2020 11:46:20 +0000
In-Reply-To: <20200218114515.GL18808@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] net: dsa: mv88e6xxx: fix vlan setup
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j41KW-0002v5-2S@rmk-PC.armlinux.org.uk>
Date:   Tue, 18 Feb 2020 11:46:20 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA assumes that a bridge which has vlan filtering disabled is not
vlan aware, and ignores all vlan configuration. However, the kernel
software bridge code allows configuration in this state.

This causes the kernel's idea of the bridge vlan state and the
hardware state to disagree, so "bridge vlan show" indicates a correct
configuration but the hardware lacks all configuration. Even worse,
enabling vlan filtering on a DSA bridge immediately blocks all traffic
which, given the output of "bridge vlan show", is very confusing.

Provide an option that drivers can set to indicate they want to receive
vlan configuration even when vlan filtering is disabled. This is safe
for Marvell DSA bridges, which do not look up ingress traffic in the
VTU if the port is in 8021Q disabled state. Whether this change is
suitable for all DSA bridges is not known.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  1 +
 include/net/dsa.h                |  1 +
 net/dsa/slave.c                  | 12 ++++++++----
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 629eb7bbbb23..e656e571ef7d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2934,6 +2934,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 	chip->ds = ds;
 	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
+	ds->vlan_bridge_vtu = true;
 
 	mv88e6xxx_reg_lock(chip);
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 63495e3443ac..d3a826646e8e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -273,6 +273,7 @@ struct dsa_switch {
 	 * settings on ports if not hardware-supported
 	 */
 	bool			vlan_filtering_is_global;
+	bool			vlan_bridge_vtu;
 
 	/* In case vlan_filtering_is_global is set, the VLAN awareness state
 	 * should be retrieved from here and not from the per-port settings.
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 088c886e609e..534d511b349e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -318,7 +318,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
+	    !br_vlan_enabled(dp->bridge_dev))
 		return 0;
 
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -385,7 +386,8 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
+	    !br_vlan_enabled(dp->bridge_dev))
 		return 0;
 
 	/* Do not deprogram the CPU port as it may be shared with other user
@@ -1106,7 +1108,8 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (!br_vlan_enabled(dp->bridge_dev))
+		if (!dp->ds->vlan_bridge_vtu &&
+		    !br_vlan_enabled(dp->bridge_dev))
 			return 0;
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
@@ -1140,7 +1143,8 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (!br_vlan_enabled(dp->bridge_dev))
+		if (!dp->ds->vlan_bridge_vtu &&
+		    !br_vlan_enabled(dp->bridge_dev))
 			return 0;
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-- 
2.20.1

