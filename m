Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6565B313B18
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhBHRjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbhBHRil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:38:41 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43914C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:38:01 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id f14so26238945ejc.8
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AqME99/Ojuh3DDv/902YHf7kyzGbSNsgtx1SJ+X0YQQ=;
        b=sNVvH3iL9lwdkU9mi00EEY3QBhER6zG3KPTUYQpwyijKH8e6Bn6/57ug0uUJWExNtj
         Jwt+TeN+6OzwPNQb/EbO7/FFdWSX/+RvJsCNN/PCC7A2Xn7HsrlA9caeu+nU2eeb1PgV
         1A5LsUEj30dqJDeatxfISXO7Os2CAgFPy8hHG0bMS/6fce7TOTSb5lVlwU2iYEnjC9XI
         fFNCesNb82y47qU78NX9mk51Iu2kx9uuK4uAnnWbVhefITd6ABepa7W2hBjxwciwo1jO
         qnWzvcxfYl6EgzQb4gyW2uvsVn7IPcxB+0dKkicfwuah7bpAkr7YHmAKVYQy7uDXqA45
         hpzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AqME99/Ojuh3DDv/902YHf7kyzGbSNsgtx1SJ+X0YQQ=;
        b=DBGbfN6RLbKUht5WHWzjcUKmND4K8NdHCtz6BuP0BeHNgrdNYwNIaRTYx5igj0k4Kw
         XZnEM7/vOwDuyigivsWzBb2GNrteoPKZ5Qlqe4UuUXzIe+lSV/GzDaTy8XElaw6e+a5p
         Fvvu4+HSBYIvyBrQjZB791TJkXPFHKYWaxxKUTsFNuA/kc56Uq4Xl2Hd6rn2iAJMwQQd
         yFVofDdDkmHlq8m8kegTeFZyXKKgesy3DIyYmFOzlpmqzqMKFWvb7+E6UuqNqk7zbyKP
         VMsi8YHDabW9k7Qt3XUgwEDLhlN4uvZDxPpA5UprIRhLtjW6/OOqSpF33w2NoNMzQHM2
         Ajhw==
X-Gm-Message-State: AOAM532zqxn062BMfvua0uVYkjiI5DC19g9hAHASqaL82CHxDpn37sNI
        Utksp4T5TfKa3VMb8V7fF84=
X-Google-Smtp-Source: ABdhPJxq+iwKBN3HAIY91QXC7c3nl/OqkWTLE0xXmaclWh4Ft/8AoX90uPTK3UoWMPNqqtkHgz7oWQ==
X-Received: by 2002:a17:906:9717:: with SMTP id k23mr17353751ejx.207.1612805879892;
        Mon, 08 Feb 2021 09:37:59 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id e11sm9039262ejx.77.2021.02.08.09.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 09:37:59 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net] net: dsa: felix: implement port flushing on .phylink_mac_link_down
Date:   Mon,  8 Feb 2021 19:36:27 +0200
Message-Id: <20210208173627.3128054-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are several issues which may be seen when the link goes down while
forwarding traffic, all of which can be attributed to the fact that the
port flushing procedure from the reference manual was not closely
followed.

With flow control enabled on both the ingress port and the egress port,
it may happen when a link goes down that Ethernet packets are in flight.
In flow control mode, frames are held back and not dropped. When there
is enough traffic in flight (example: iperf3 TCP), then the ingress port
might enter congestion and never exit that state. This is a problem,
because it is the egress port's link that went down, and that has caused
the inability of the ingress port to send packets to any other port.
This is solved by flushing the egress port's queues when it goes down.

There is also a problem when performing stream splitting for
IEEE 802.1CB traffic (not yet upstream, but a sort of multicast,
basically). There, if one port from the destination ports mask goes
down, splitting the stream towards the other destinations will no longer
be performed. This can be traced down to this line:

	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);

which should have been instead, as per the reference manual:

	ocelot_port_rmwl(ocelot_port, 0, DEV_MAC_ENA_CFG_RX_ENA,
			 DEV_MAC_ENA_CFG);

Basically only DEV_MAC_ENA_CFG_RX_ENA should be disabled, but not
DEV_MAC_ENA_CFG_TX_ENA - I don't have further insight into why that is
the case, but apparently multicasting to several ports will cause issues
if at least one of them doesn't have DEV_MAC_ENA_CFG_TX_ENA set.

I am not sure what the state of the Ocelot VSC7514 driver is, but
probably not as bad as Felix/Seville, since VSC7514 uses phylib and has
the following in ocelot_adjust_link:

	if (!phydev->link)
		return;

therefore the port is not really put down when the link is lost, unlike
the DSA drivers which use .phylink_mac_link_down for that.

Nonetheless, I put ocelot_port_flush() in the common ocelot.c because it
needs to access some registers from drivers/net/ethernet/mscc/ocelot_rew.h
which are not exported in include/soc/mscc/ and a bugfix patch should
probably not move headers around.

Fixes: bdeced75b13f ("net: dsa: felix: Add PCS operations for PHYLINK")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c        | 17 ++++++++-
 drivers/net/ethernet/mscc/ocelot.c    | 54 +++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_io.c |  8 ++++
 include/soc/mscc/ocelot.h             |  2 +
 4 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 7dc230677b78..45fdb1256dbf 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -233,9 +233,24 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int err;
+
+	ocelot_port_rmwl(ocelot_port, 0, DEV_MAC_ENA_CFG_RX_ENA,
+			 DEV_MAC_ENA_CFG);
 
-	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
 	ocelot_fields_write(ocelot, port, QSYS_SWITCH_PORT_MODE_PORT_ENA, 0);
+
+	err = ocelot_port_flush(ocelot, port);
+	if (err)
+		dev_err(ocelot->dev, "failed to flush port %d: %d\n",
+			port, err);
+
+	/* Put the port in reset. */
+	ocelot_port_writel(ocelot_port,
+			   DEV_CLOCK_CFG_MAC_TX_RST |
+			   DEV_CLOCK_CFG_MAC_RX_RST |
+			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
+			   DEV_CLOCK_CFG);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ff87a0bc089c..c072eb5c0764 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -375,6 +375,60 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	}
 }
 
+static u32 ocelot_read_eq_avail(struct ocelot *ocelot, int port)
+{
+	return ocelot_read_rix(ocelot, QSYS_SW_STATUS, port);
+}
+
+int ocelot_port_flush(struct ocelot *ocelot, int port)
+{
+	int err, val;
+
+	/* Disable dequeuing from the egress queues */
+	ocelot_rmw_rix(ocelot, QSYS_PORT_MODE_DEQUEUE_DIS,
+		       QSYS_PORT_MODE_DEQUEUE_DIS,
+		       QSYS_PORT_MODE, port);
+
+	/* Disable flow control */
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
+
+	/* Disable priority flow control */
+	ocelot_fields_write(ocelot, port,
+			    QSYS_SWITCH_PORT_MODE_TX_PFC_ENA, 0);
+
+	/* Wait at least the time it takes to receive a frame of maximum length
+	 * at the port.
+	 * Worst-case delays for 10 kilobyte jumbo frames are:
+	 * 8 ms on a 10M port
+	 * 800 μs on a 100M port
+	 * 80 μs on a 1G port
+	 * 32 μs on a 2.5G port
+	 */
+	usleep_range(8000, 10000);
+
+	/* Disable half duplex backpressure. */
+	ocelot_rmw_rix(ocelot, 0, SYS_FRONT_PORT_MODE_HDX_MODE,
+		       SYS_FRONT_PORT_MODE, port);
+
+	/* Flush the queues associated with the port. */
+	ocelot_rmw_gix(ocelot, REW_PORT_CFG_FLUSH_ENA, REW_PORT_CFG_FLUSH_ENA,
+		       REW_PORT_CFG, port);
+
+	/* Enable dequeuing from the egress queues. */
+	ocelot_rmw_rix(ocelot, 0, QSYS_PORT_MODE_DEQUEUE_DIS, QSYS_PORT_MODE,
+		       port);
+
+	/* Wait until flushing is complete. */
+	err = read_poll_timeout(ocelot_read_eq_avail, val, !val,
+				100, 2000000, false, ocelot, port);
+
+	/* Clear flushing again. */
+	ocelot_rmw_gix(ocelot, 0, REW_PORT_CFG_FLUSH_ENA, REW_PORT_CFG, port);
+
+	return err;
+}
+EXPORT_SYMBOL(ocelot_port_flush);
+
 void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			struct phy_device *phydev)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index 0acb45948418..ea4e83410fe4 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -71,6 +71,14 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
 }
 EXPORT_SYMBOL(ocelot_port_writel);
 
+void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg)
+{
+	u32 cur = ocelot_port_readl(port, reg);
+
+	ocelot_port_writel(port, (cur & (~mask)) | val, reg);
+}
+EXPORT_SYMBOL(ocelot_port_rmwl);
+
 u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
 			    u32 reg, u32 offset)
 {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2f4cd3288bcc..c34b9ccb6472 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -709,6 +709,7 @@ struct ocelot_policer {
 /* I/O */
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
+void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg);
 u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
 void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
 void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
@@ -737,6 +738,7 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset);
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info);
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
+int ocelot_port_flush(struct ocelot *ocelot, int port);
 void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			struct phy_device *phydev);
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled,
-- 
2.25.1

