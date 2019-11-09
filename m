Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B95FEF5F47
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfKINDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:34 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38073 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfKINDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:31 -0500
Received: by mail-wm1-f68.google.com with SMTP id z19so8884134wmk.3
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XBas+zl+YYYrxLrMX16ojRmOhoFJ7KLkEmlptv/Mu6E=;
        b=ScqqLe17hDzpQinBG+ZO5msjFKu4KYTC6kVsMtM+pxVRKEKUS5l5Ib2y1WS1O2hFeH
         xTiVqBTV/Qv+il8eWIssFcVEAdRzd1GFeZaR2+jVbtySbnErzKVlRAc2UJSRypVZzoPv
         F2DZ6GLW9yVAt/gsEavDRvyHrt2w7ReUSy9FLiPQQoQB0lCE+ayB5j01pBzxNWhOVJJe
         Ug2aSE+NaIVYkLTpijPmsn2GivgnoULTOtfqWUmLMU0Ney2h77x7yOCp4hVJdQ2sRBV5
         NnlJEgnIuGaUZe7WGViI2r7kHBPwbjCdhbGVVvXw1yyY8PEQpfn82XUF/vJ3ydA7NO8E
         ybxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XBas+zl+YYYrxLrMX16ojRmOhoFJ7KLkEmlptv/Mu6E=;
        b=Ea1Dy6zOmgtT3QOWl5Idcex2h+x2nco/ZwxH/PPqlMPkead+kJzHjWJZfJ4+cceTTp
         eEOf/VPZfNF79Ppc/9ajOLkyAo39c1i9/NeeJWaRJaUZ4QJyQbFrj7Yp1KmNV87sc4MX
         WW/trCbW1axXO+YLmkfmQyN1NMy96DFKUEdvVtOU2py8KLjpiq13RVQbSMR4HsxPum+H
         hQyCO5rKFu4nGTZl9mBxSlcgWXA/iMothAJBc462Kd9EhKbuGtxhYLFA8xG8iuufK2oI
         pjophUHWbRw7uTS7oMn7baeWpr7ycmia7VSnwUZayu12XBZJ87X4C500n5rgcRblCABy
         /buQ==
X-Gm-Message-State: APjAAAUDdwuQo91WJlUMPdvMJM6HQSWAGctz2ZYal14ggRp7iTyxKiAl
        dk8yuRomhLAVZPuK+Y29O6M=
X-Google-Smtp-Source: APXvYqy6OGB7xVEWLtEzoHNg5uOWjX8YbxRPYuuywSgrExc7V/iIenKwSSoZmgHk0hUrHw+r85/KIw==
X-Received: by 2002:a1c:96c9:: with SMTP id y192mr13323045wmd.8.1573304608900;
        Sat, 09 Nov 2019 05:03:28 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 08/15] net: mscc: ocelot: refactor ethtool callbacks
Date:   Sat,  9 Nov 2019 15:02:54 +0200
Message-Id: <20191109130301.13716-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Convert them into an implementation that can be called from DSA as well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 64 ++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ad808344e33b..58ead0652bce 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1191,10 +1191,9 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_do_ioctl			= ocelot_ioctl,
 };
 
-static void ocelot_get_strings(struct net_device *netdev, u32 sset, u8 *data)
+static void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset,
+			       u8 *data)
 {
-	struct ocelot_port_private *priv = netdev_priv(netdev);
-	struct ocelot *ocelot = priv->port.ocelot;
 	int i;
 
 	if (sset != ETH_SS_STATS)
@@ -1205,6 +1204,16 @@ static void ocelot_get_strings(struct net_device *netdev, u32 sset, u8 *data)
 		       ETH_GSTRING_LEN);
 }
 
+static void ocelot_port_get_strings(struct net_device *netdev, u32 sset,
+				    u8 *data)
+{
+	struct ocelot_port_private *priv = netdev_priv(netdev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	ocelot_get_strings(ocelot, port, sset, data);
+}
+
 static void ocelot_update_stats(struct ocelot *ocelot)
 {
 	int i, j;
@@ -1245,12 +1254,8 @@ static void ocelot_check_stats_work(struct work_struct *work)
 			   OCELOT_STATS_CHECK_DELAY);
 }
 
-static void ocelot_get_ethtool_stats(struct net_device *dev,
-				     struct ethtool_stats *stats, u64 *data)
+static void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
 	int i;
 
 	/* check and update now */
@@ -1261,25 +1266,37 @@ static void ocelot_get_ethtool_stats(struct net_device *dev,
 		*data++ = ocelot->stats[port * ocelot->num_stats + i];
 }
 
-static int ocelot_get_sset_count(struct net_device *dev, int sset)
+static void ocelot_port_get_ethtool_stats(struct net_device *dev,
+					  struct ethtool_stats *stats,
+					  u64 *data)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 
+	ocelot_get_ethtool_stats(ocelot, port, data);
+}
+
+static int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
+{
 	if (sset != ETH_SS_STATS)
 		return -EOPNOTSUPP;
+
 	return ocelot->num_stats;
 }
 
-static int ocelot_get_ts_info(struct net_device *dev,
-			      struct ethtool_ts_info *info)
+static int ocelot_port_get_sset_count(struct net_device *dev, int sset)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 
-	if (!ocelot->ptp)
-		return ethtool_op_get_ts_info(dev, info);
+	return ocelot_get_sset_count(ocelot, port, sset);
+}
 
+static int ocelot_get_ts_info(struct ocelot *ocelot, int port,
+			      struct ethtool_ts_info *info)
+{
 	info->phc_index = ocelot->ptp_clock ?
 			  ptp_clock_index(ocelot->ptp_clock) : -1;
 	info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
@@ -1295,13 +1312,26 @@ static int ocelot_get_ts_info(struct net_device *dev,
 	return 0;
 }
 
+static int ocelot_port_get_ts_info(struct net_device *dev,
+				   struct ethtool_ts_info *info)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	if (!ocelot->ptp)
+		return ethtool_op_get_ts_info(dev, info);
+
+	return ocelot_get_ts_info(ocelot, port, info);
+}
+
 static const struct ethtool_ops ocelot_ethtool_ops = {
-	.get_strings		= ocelot_get_strings,
-	.get_ethtool_stats	= ocelot_get_ethtool_stats,
-	.get_sset_count		= ocelot_get_sset_count,
+	.get_strings		= ocelot_port_get_strings,
+	.get_ethtool_stats	= ocelot_port_get_ethtool_stats,
+	.get_sset_count		= ocelot_port_get_sset_count,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
-	.get_ts_info		= ocelot_get_ts_info,
+	.get_ts_info		= ocelot_port_get_ts_info,
 };
 
 static void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port,
-- 
2.17.1

