Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70EA128FBC
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 20:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfLVTY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 14:24:26 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57442 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfLVTY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 14:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=alGw+BCsHoj9VQeAj13N/jXyPd34jjH4CCWDN0hqjCg=; b=bRv5O2f4gHhVHvsvsxyIcfcoeP
        yIl6qu26mMmsXA2zdXLA2yDmCVPyc7MGprXWcqK1EX0gg6A0hGvXZmAbQHc2t+IwPg6ghq/9vZwYM
        s27BrGyhWghp4HyfnbD57hmFSz4ZzTVfogESugChyza5PBGW6eVXzTKfch5cG0ugn4pO9LCkohoNY
        4KucdBoiK5O9JWpjM/+LVW4BKghu4AorBcWwVfzCU7oN39z7xUPP9d0AFKXtrQ6qqG67Qm0GnZS7j
        1lPekigSgNLPo3KXHHkBvsF5rI66r4KdPJ1dYnNw5yhG6sWCpKr4RjhVfJnwKp+yS7lYLeYITogmO
        0I1u/7fg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:51330 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ij6ps-0005rG-06; Sun, 22 Dec 2019 19:24:16 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ij6pq-00084C-47; Sun, 22 Dec 2019 19:24:14 +0000
In-Reply-To: <20191222192235.GK25745@shell.armlinux.org.uk>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC 3/3] net: dsa: mv88e6xxx: fix vlan setup
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ij6pq-00084C-47@rmk-PC.armlinux.org.uk>
Date:   Sun, 22 Dec 2019 19:24:14 +0000
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
index cd79ee14ea5f..650b101caad7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2680,6 +2680,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 	chip->ds = ds;
 	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
+	ds->vlan_bridge_vtu = true;
 
 	mv88e6xxx_reg_lock(chip);
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 99f71be8cfdb..5e5c1a95af1a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -269,6 +269,7 @@ struct dsa_switch {
 	 * settings on ports if not hardware-supported
 	 */
 	bool			vlan_filtering_is_global;
+	bool			vlan_bridge_vtu;
 
 	/* In case vlan_filtering_is_global is set, the VLAN awareness state
 	 * should be retrieved from here and not from the per-port settings.
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a7c1e7ded8ca..6d167713da83 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -323,7 +323,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
+	    !br_vlan_enabled(dp->bridge_dev))
 		return 0;
 
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -390,7 +391,8 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
+	    !br_vlan_enabled(dp->bridge_dev))
 		return 0;
 
 	/* Do not deprogram the CPU port as it may be shared with other user
@@ -1122,7 +1124,8 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (!br_vlan_enabled(dp->bridge_dev))
+		if (!dp->ds->vlan_bridge_vtu &&
+		    !br_vlan_enabled(dp->bridge_dev))
 			return 0;
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
@@ -1156,7 +1159,8 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
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

