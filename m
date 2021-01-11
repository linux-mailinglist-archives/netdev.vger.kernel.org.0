Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CAB2F106F
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 11:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbhAKKrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 05:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729350AbhAKKrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 05:47:45 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A65FC06179F
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 02:47:04 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kyuix-0005K4-NA; Mon, 11 Jan 2021 11:46:59 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kyuix-0005io-9O; Mon, 11 Jan 2021 11:46:59 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH net-next v8 1/2] net: dsa: add optional stats64 support
Date:   Mon, 11 Jan 2021 11:46:57 +0100
Message-Id: <20210111104658.21930-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111104658.21930-1-o.rempel@pengutronix.de>
References: <20210111104658.21930-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow DSA drivers to export stats64

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h |  4 +++-
 net/dsa/slave.c   | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 4e60d2610f20..c50abb295fb6 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -477,7 +477,7 @@ struct dsa_switch_ops {
 	void	(*phylink_fixed_state)(struct dsa_switch *ds, int port,
 				       struct phylink_link_state *state);
 	/*
-	 * ethtool hardware statistics.
+	 * Port statistics counters.
 	 */
 	void	(*get_strings)(struct dsa_switch *ds, int port,
 			       u32 stringset, uint8_t *data);
@@ -486,6 +486,8 @@ struct dsa_switch_ops {
 	int	(*get_sset_count)(struct dsa_switch *ds, int port, int sset);
 	void	(*get_ethtool_phy_stats)(struct dsa_switch *ds,
 					 int port, uint64_t *data);
+	void	(*get_stats64)(struct dsa_switch *ds, int port,
+				   struct rtnl_link_stats64 *s);
 
 	/*
 	 * ethtool Wake-on-LAN
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4a0498bf6c65..1fb823d3c7d7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1602,6 +1602,18 @@ static struct devlink_port *dsa_slave_get_devlink_port(struct net_device *dev)
 	return dp->ds->devlink ? &dp->devlink_port : NULL;
 }
 
+static void dsa_slave_get_stats64(struct net_device *dev,
+				  struct rtnl_link_stats64 *s)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->get_stats64)
+		ds->ops->get_stats64(ds, dp->index, s);
+	else
+		dev_get_tstats64(dev, s);
+}
+
 static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_open	 	= dsa_slave_open,
 	.ndo_stop		= dsa_slave_close,
@@ -1621,7 +1633,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 #endif
 	.ndo_get_phys_port_name	= dsa_slave_get_phys_port_name,
 	.ndo_setup_tc		= dsa_slave_setup_tc,
-	.ndo_get_stats64	= dev_get_tstats64,
+	.ndo_get_stats64	= dsa_slave_get_stats64,
 	.ndo_get_port_parent_id	= dsa_slave_get_port_parent_id,
 	.ndo_vlan_rx_add_vid	= dsa_slave_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= dsa_slave_vlan_rx_kill_vid,
-- 
2.30.0

