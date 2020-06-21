Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DC4202D93
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 00:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbgFUW4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 18:56:16 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54342 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbgFUW4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 18:56:03 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 079082007BB;
        Mon, 22 Jun 2020 00:56:01 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E96DD20059D;
        Mon, 22 Jun 2020 00:56:00 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7A93E20414;
        Mon, 22 Jun 2020 00:56:00 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 5/9] net: dsa: add support for phylink_pcs_ops
Date:   Mon, 22 Jun 2020 01:54:47 +0300
Message-Id: <20200621225451.12435-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200621225451.12435-1-ioana.ciornei@nxp.com>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support split PCS using PHYLINK properly, we need to add a
phylink_pcs_ops structure.

Note that a DSA driver that wants to use these needs to implement all 4
of them: the DSA core checks the presence of these 4 function pointers
in dsa_switch_ops and only then does it add a PCS to PHYLINK. This is
done in order to preserve compatibility with drivers that have not yet
been converted, or don't need, a split PCS setup.

Also, when pcs_get_state() and pcs_an_restart() are present, their mac
counterparts (mac_pcs_get_state(), mac_an_restart()) will no longer get
called, as can be seen in phylink.c.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v3:
 * patch added

 include/net/dsa.h  | 12 ++++++++++++
 net/dsa/dsa_priv.h |  1 +
 net/dsa/port.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c    |  6 ++++++
 4 files changed, 65 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 50389772c597..09aa36198f4b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -446,6 +446,18 @@ struct dsa_switch_ops {
 				       bool tx_pause, bool rx_pause);
 	void	(*phylink_fixed_state)(struct dsa_switch *ds, int port,
 				       struct phylink_link_state *state);
+	void	(*phylink_pcs_get_state)(struct dsa_switch *ds, int port,
+					 struct phylink_link_state *state);
+	int	(*phylink_pcs_config)(struct dsa_switch *ds, int port,
+				      unsigned int mode,
+				      phy_interface_t interface,
+				      const unsigned long *advertising);
+	void	(*phylink_pcs_an_restart)(struct dsa_switch *ds, int port);
+	void	(*phylink_pcs_link_up)(struct dsa_switch *ds, int port,
+				       unsigned int mode,
+				       phy_interface_t interface, int speed,
+				       int duplex);
+
 	/*
 	 * ethtool hardware statistics.
 	 */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index adecf73bd608..de8e11796178 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -169,6 +169,7 @@ int dsa_port_vid_del(struct dsa_port *dp, u16 vid);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
+extern const struct phylink_pcs_ops dsa_port_phylink_pcs_ops;
 
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index e23ece229c7e..a2b0460d2593 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -592,6 +592,52 @@ const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.mac_link_up = dsa_port_phylink_mac_link_up,
 };
 
+static void dsa_port_pcs_get_state(struct phylink_config *config,
+				   struct phylink_link_state *state)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+
+	ds->ops->phylink_pcs_get_state(ds, dp->index, state);
+}
+
+static void dsa_port_pcs_an_restart(struct phylink_config *config)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+
+	ds->ops->phylink_pcs_an_restart(ds, dp->index);
+}
+
+static int dsa_port_pcs_config(struct phylink_config *config,
+			       unsigned int mode, phy_interface_t interface,
+			       const unsigned long *advertising)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+
+	return ds->ops->phylink_pcs_config(ds, dp->index, mode, interface,
+					   advertising);
+}
+
+static void dsa_port_pcs_link_up(struct phylink_config *config,
+				 unsigned int mode, phy_interface_t interface,
+				 int speed, int duplex)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+
+	ds->ops->phylink_pcs_link_up(ds, dp->index, mode, interface, speed,
+				     duplex);
+}
+
+const struct phylink_pcs_ops dsa_port_phylink_pcs_ops = {
+	.pcs_get_state = dsa_port_pcs_get_state,
+	.pcs_config = dsa_port_pcs_config,
+	.pcs_an_restart = dsa_port_pcs_an_restart,
+	.pcs_link_up = dsa_port_pcs_link_up,
+};
+
 static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 {
 	struct dsa_switch *ds = dp->ds;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4c7f086a047b..8856e70f6a06 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1650,6 +1650,12 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	if (ds->ops->get_phy_flags)
 		phy_flags = ds->ops->get_phy_flags(ds, dp->index);
 
+	if (ds->ops->phylink_pcs_get_state &&
+	    ds->ops->phylink_pcs_an_restart &&
+	    ds->ops->phylink_pcs_config &&
+	    ds->ops->phylink_pcs_link_up)
+		phylink_add_pcs(dp->pl, &dsa_port_phylink_pcs_ops);
+
 	ret = phylink_of_phy_connect(dp->pl, port_dn, phy_flags);
 	if (ret == -ENODEV && ds->slave_mii_bus) {
 		/* We could not connect to a designated PHY or SFP, so try to
-- 
2.25.1

