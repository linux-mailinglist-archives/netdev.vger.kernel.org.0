Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A881779D2
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgCCPB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:01:57 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36944 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbgCCPB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:01:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QqsKTXA0HShX4J4xcw7YhSYq9YfAGZtEKJeLUvG3Hdg=; b=knBT+K5sfVg4fJpDYo9BLkQvsq
        RSTqTxva8/c/SSfHb14UX209izi9aDFglxu2UQBgu7VTZxxemXdQD1S5tB7t0irlzNEXVCpc5M/xO
        PP66oh6Lyhwb2gp9KRsXtiyPLk7qGz+n/eFE8wVZoBP95nlaG24VlRMN813q+/SMIiwtb8XZ6D5zq
        xEzhbVRWIP35QFHd/+TAtumgcDvySeQOUFBtoLbOMSvUzIgK+/v0LaCwh8fEyxLV3+vnq21VwMCd5
        pWB/eV+LpSIAxgq28fJHyZZGnWGVrqXo/gXIfpJqzDXA4UJB+7/HMYv2wfNBSmaBDk6pwvmfeftFo
        UQPV2Lbw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42102 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j993K-0000Cm-Vo; Tue, 03 Mar 2020 15:01:47 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j993K-0005kp-87; Tue, 03 Mar 2020 15:01:46 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org
Subject: [PATCH net v2] net: dsa: fix phylink_start()/phylink_stop() calls
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j993K-0005kp-87@rmk-PC.armlinux.org.uk>
Date:   Tue, 03 Mar 2020 15:01:46 +0000
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
v2: reorder phylink_start() / phylink_stop() as per Andrew's comment.

 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 32 ++++++++++++++++++++++++++------
 net/dsa/slave.c    |  8 ++------
 3 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 65ba1f0c195a..36bb934dc36e 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -117,7 +117,9 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 /* port.c */
 int dsa_port_set_state(struct dsa_port *dp, u8 state,
 		       struct switchdev_trans *trans);
+int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
+void dsa_port_disable_rt(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index ae1bd6d3edcb..2c8f87117f2c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -63,7 +63,7 @@ static void dsa_port_set_state_now(struct dsa_port *dp, u8 state)
 		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
 }
 
-int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
+int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
@@ -78,14 +78,31 @@ int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
 	if (!dp->bridge_dev)
 		dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 
+	if (dp->pl)
+		phylink_start(dp->pl);
+
 	return 0;
 }
 
-void dsa_port_disable(struct dsa_port *dp)
+int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
+{
+	int err;
+
+	rtnl_lock();
+	err = dsa_port_enable_rt(dp, phy);
+	rtnl_unlock();
+
+	return err;
+}
+
+void dsa_port_disable_rt(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
 
+	if (dp->pl)
+		phylink_stop(dp->pl);
+
 	if (!dp->bridge_dev)
 		dsa_port_set_state_now(dp, BR_STATE_DISABLED);
 
@@ -93,6 +110,13 @@ void dsa_port_disable(struct dsa_port *dp)
 		ds->ops->port_disable(ds, port);
 }
 
+void dsa_port_disable(struct dsa_port *dp)
+{
+	rtnl_lock();
+	dsa_port_disable_rt(dp);
+	rtnl_unlock();
+}
+
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 {
 	struct dsa_notifier_bridge_info info = {
@@ -621,10 +645,6 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 		goto err_phy_connect;
 	}
 
-	rtnl_lock();
-	phylink_start(dp->pl);
-	rtnl_unlock();
-
 	return 0;
 
 err_phy_connect:
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 54529543ce87..eb114531bef8 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -90,12 +90,10 @@ static int dsa_slave_open(struct net_device *dev)
 			goto clear_allmulti;
 	}
 
-	err = dsa_port_enable(dp, dev->phydev);
+	err = dsa_port_enable_rt(dp, dev->phydev);
 	if (err)
 		goto clear_promisc;
 
-	phylink_start(dp->pl);
-
 	return 0;
 
 clear_promisc:
@@ -119,9 +117,7 @@ static int dsa_slave_close(struct net_device *dev)
 	cancel_work_sync(&dp->xmit_work);
 	skb_queue_purge(&dp->xmit_queue);
 
-	phylink_stop(dp->pl);
-
-	dsa_port_disable(dp);
+	dsa_port_disable_rt(dp);
 
 	dev_mc_unsync(master, dev);
 	dev_uc_unsync(master, dev);
-- 
2.20.1

