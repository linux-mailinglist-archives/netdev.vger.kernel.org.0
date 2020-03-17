Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA621882FE
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 13:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgCQMIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 08:08:15 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38792 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgCQMIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 08:08:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1cPwpOW6wyy38AvvEB2WIvO8j6ro4+e3JqGRpkola/Q=; b=auMKY7FCbW+rsFHdZPMl5yAo5U
        LNCQSOQbEDbGNzvTFHic78orL+xQHsq9ogAuYHulpWPgBDGPy9KVIeU3rIfGNtgJvB1M7kiRdjWvm
        pqh7uh7fIA85R9ywdZpJXLOH3P2pc3h+AFpk8wUyXrhjFm6/K5LZA8c1mcPQdTUH1jdvrwdbeivv2
        UTURpPhwrVCHpBOLvPL+2OIzd4x9+rARVwkN2fye51fdshzipmuGGVMMhqXPfGO+w/qxe48qm6RBs
        fS2i/K2rUeh4IwXiv9aeSXxEyDSA8bmZHPCjw/wvLdVkzpWJUZyTIMmMiqLy74KxltZvYuK4KZr5j
        s99raqMg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:55692 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEB0y-0006vN-T9; Tue, 17 Mar 2020 12:08:08 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEB0y-0006iF-5g; Tue, 17 Mar 2020 12:08:08 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH REPOST net-next] net: dsa: mv88e6xxx: fix vlan setup
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jEB0y-0006iF-5g@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Mar 2020 12:08:08 +0000
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
This patch depends on, and completes the changes previously merged in
net-next in 2b99e54b30ed ("Merge branch 'VLANs-DSA-switches-and-multiple-bridges'")
It has been delayed due to the lack of discussion concerning the
naming of "vlan_bridge_vtu" which remains unresolved.

 drivers/net/dsa/mv88e6xxx/chip.c |  1 +
 include/net/dsa.h                |  1 +
 net/dsa/slave.c                  | 12 ++++++++----
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 221593261e8f..3a8346a95dae 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3036,6 +3036,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 	chip->ds = ds;
 	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
+	ds->vlan_bridge_vtu = true;
 
 	mv88e6xxx_reg_lock(chip);
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index beeb81a532e3..4c895764447f 100644
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
index c5beb3031a72..a4009e1e7bdd 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -314,7 +314,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
+	    !br_vlan_enabled(dp->bridge_dev))
 		return 0;
 
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -381,7 +382,8 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
+	    !br_vlan_enabled(dp->bridge_dev))
 		return 0;
 
 	/* Do not deprogram the CPU port as it may be shared with other user
@@ -1166,7 +1168,8 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (!br_vlan_enabled(dp->bridge_dev))
+		if (!dp->ds->vlan_bridge_vtu &&
+		    !br_vlan_enabled(dp->bridge_dev))
 			return 0;
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
@@ -1200,7 +1203,8 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
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

