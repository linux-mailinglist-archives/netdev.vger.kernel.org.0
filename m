Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86F13174062
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 20:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgB1Tjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 14:39:53 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59846 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgB1Tjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 14:39:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kKUmTfsf9JBUifas5FnuiJ6AZBdxyf8altjpKEbZ/Zs=; b=HXvleotVzvse4yzfU6djIUaqsn
        RzadHFxWrle7rZZ0ZoInj5bOtNu9AEG/TX3bHzknO/yS2avPHm2Ahb/v6363k5Rz4iZXX0qNAFBV7
        wmvZoC0usnZiYO+rxvG+fSurfYXIhONNGs63kKrhlTAL+FfgfrjZlyEjNxUA4u5kkaDHPB4tImzZg
        v7FHXsoRS1N/wLGUdsjGIfWx/0UF++hcieqPxE+a6AIRGiREleR8oUvUjvI1HUYUrh3y09YXMk1HK
        ydsNL/NCyMMLLrrOd/Xm5ncJXaRHgqq8YPjzwFdOafnZTziga1Dkng1YHYLGks1OIAWE9JQT+tMz5
        oTYM/AFA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:40282 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7lU1-0005iH-1G; Fri, 28 Feb 2020 19:39:37 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7lU0-0003pp-Ff; Fri, 28 Feb 2020 19:39:36 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net] net: dsa: fix phylink_start()/phylink_stop() calls
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j7lU0-0003pp-Ff@rmk-PC.armlinux.org.uk>
Date:   Fri, 28 Feb 2020 19:39:36 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Place phylink_start()/phylink_stop() inside dsa_port_enable() and
dsa_port_disable(), which ensures that we call phylink_stop() before
tearing down phylink - which is a documented requirement.  Failure
to do so can cause use-after-free bugs.

Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 32 ++++++++++++++++++++++++++------
 net/dsa/slave.c    |  8 ++------
 3 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a7662e7a691d..5099a337c9cc 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -117,7 +117,9 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 /* port.c */
 int dsa_port_set_state(struct dsa_port *dp, u8 state,
 		       struct switchdev_trans *trans);
+int dsa_port_enable_locked(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
+void dsa_port_disable_locked(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 774facb8d547..96f074670140 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -63,12 +63,15 @@ static void dsa_port_set_state_now(struct dsa_port *dp, u8 state)
 		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
 }
 
-int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
+int dsa_port_enable_locked(struct dsa_port *dp, struct phy_device *phy)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
 	int err;
 
+	if (dp->pl)
+		phylink_start(dp->pl);
+
 	if (ds->ops->port_enable) {
 		err = ds->ops->port_enable(ds, port, phy);
 		if (err)
@@ -81,7 +84,18 @@ int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
 	return 0;
 }
 
-void dsa_port_disable(struct dsa_port *dp)
+int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
+{
+	int err;
+
+	rtnl_lock();
+	err = dsa_port_enable_locked(dp, phy);
+	rtnl_unlock();
+
+	return err;
+}
+
+void dsa_port_disable_locked(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
@@ -91,6 +105,16 @@ void dsa_port_disable(struct dsa_port *dp)
 
 	if (ds->ops->port_disable)
 		ds->ops->port_disable(ds, port);
+
+	if (dp->pl)
+		phylink_stop(dp->pl);
+}
+
+void dsa_port_disable(struct dsa_port *dp)
+{
+	rtnl_lock();
+	dsa_port_disable_locked(dp);
+	rtnl_unlock();
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
@@ -614,10 +638,6 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 		goto err_phy_connect;
 	}
 
-	rtnl_lock();
-	phylink_start(dp->pl);
-	rtnl_unlock();
-
 	return 0;
 
 err_phy_connect:
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 088c886e609e..36523e942983 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -88,12 +88,10 @@ static int dsa_slave_open(struct net_device *dev)
 			goto clear_allmulti;
 	}
 
-	err = dsa_port_enable(dp, dev->phydev);
+	err = dsa_port_enable_locked(dp, dev->phydev);
 	if (err)
 		goto clear_promisc;
 
-	phylink_start(dp->pl);
-
 	return 0;
 
 clear_promisc:
@@ -114,9 +112,7 @@ static int dsa_slave_close(struct net_device *dev)
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
-	phylink_stop(dp->pl);
-
-	dsa_port_disable(dp);
+	dsa_port_disable_locked(dp);
 
 	dev_mc_unsync(master, dev);
 	dev_uc_unsync(master, dev);
-- 
2.20.1

