Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABF8311928
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhBFC4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhBFCse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:48:34 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F678C061226
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:21 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id q2so10713669edi.4
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TczSOMJlcVuD/G6cNnSP+M29wppGj2lvswI8JvvFkjA=;
        b=pRyLWofMRJqw31Vlq/77gy0SwhL2dAprmWNZeGOGIMd5+f8ajU3yCAGm0MjiS5neSc
         Mb0DL9fVnZVpFCo9q1Ip/PFq+JMzFH9yN3ZVQlSl1mh+4qVJZQjcgAs3C8cT8xXVtKYF
         hxMZ3VHOm3vLgtZt+W/ntp1msvnIqnrl3YFuC/v94NKLLuHCjQT+TxB5W7ZEOMnb61ch
         50Wdf339MiyKmKualseK6OUNy3HlrwJOzDC/BI7WmEz67ln5+cvJOEVrDqnhb0Uruf7Y
         UtpYa/VKKSBv1H7RVJL06C11ezUc6QkoxoXdz8B/XzHq+Ez94TQ2fsZRGrKsPPT2fzbG
         oB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TczSOMJlcVuD/G6cNnSP+M29wppGj2lvswI8JvvFkjA=;
        b=RNRabVjcplxyI4CF76jdgRvbAOso7JcjXhCE2ciqJffdG09jdqT9pdCVVA1TjYCLcc
         Axk2r1XapY/3lWap6LLPV5qjzHdrCBcHEIJYniubwt7Y0RYbShjYQDzYYOGzTrgkXWxI
         kqHMrd8YDDJbfOP/mehZ0cJ4tKsGRkEGecsSpKQ4zKIpFEdm4fYhZfU6MdyNFLXzUAs2
         2HsEwOVy6FML26SEt5TTMEohsDkvnsvCZt1djYyXrQjh4zgz/gxhWbP+mM9HDgnP5J0s
         6Epi4+4P4Kye/p/Rf+mGNQ1jwCzhFRAC7xdG6c5i/mlHTxUfyhTn7dfC2z9vO+0+Mm5H
         zVng==
X-Gm-Message-State: AOAM532IbBIXP60KvVcaxhcDc6KB3oMI3fKeKLFgtJyLRYbN1K4sby4m
        awI+9lhfe+FTUID79uqGr2g=
X-Google-Smtp-Source: ABdhPJxOSmF3cmaQ0/YP3DVOn0iYWRvF6dHxmPgwdG/r5PY4IVfP2uJO+gLNj1ute6u3U/umxDnj9g==
X-Received: by 2002:aa7:d2d2:: with SMTP id k18mr5747596edr.222.1612562600086;
        Fri, 05 Feb 2021 14:03:20 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH RESEND v3 net-next 08/12] net: mscc: ocelot: drop the use of the "lags" array
Date:   Sat,  6 Feb 2021 00:02:17 +0200
Message-Id: <20210205220221.255646-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We can now simplify the implementation by always using ocelot_get_bond_mask
to look up the other ports that are offloading the same bonding interface
as us.

In ocelot_set_aggr_pgids, the code had a way to uniquely iterate through
LAGs. We need to achieve the same behavior by marking each LAG as visited,
which we do now by using a temporary 32-bit "visited" bitmask. This is
ok and we do not need dynamic memory allocation, because we know that
this switch architecture will not have more than 32 ports (the PGID port
masks are 32-bit anyway).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Using a "visited" bit mask to avoid memory allocation.

Changes in v2:
Context looks a bit different.

 drivers/net/ethernet/mscc/ocelot.c | 95 ++++++++++++------------------
 include/soc/mscc/ocelot.h          |  2 -
 2 files changed, 39 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5d765245c6d3..c906c449d2dd 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -957,21 +957,11 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			mask = GENMASK(ocelot->num_phys_ports - 1, 0);
 			mask &= ~cpu_fwd_mask;
 		} else if (ocelot->bridge_fwd_mask & BIT(port)) {
-			int lag;
+			struct net_device *bond = ocelot_port->bond;
 
 			mask = ocelot->bridge_fwd_mask & ~BIT(port);
-
-			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
-				unsigned long bond_mask = ocelot->lags[lag];
-
-				if (!bond_mask)
-					continue;
-
-				if (bond_mask & BIT(port)) {
-					mask &= ~bond_mask;
-					break;
-				}
-			}
+			if (bond)
+				mask &= ~ocelot_get_bond_mask(ocelot, bond);
 		} else {
 			/* Standalone ports forward only to DSA tag_8021q CPU
 			 * ports (if those exist), or to the hardware CPU port
@@ -1277,6 +1267,7 @@ EXPORT_SYMBOL(ocelot_port_bridge_leave);
 
 static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 {
+	unsigned long visited = GENMASK(ocelot->num_phys_ports - 1, 0);
 	int i, port, lag;
 
 	/* Reset destination and aggregation PGIDS */
@@ -1287,16 +1278,35 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 		ocelot_write_rix(ocelot, GENMASK(ocelot->num_phys_ports - 1, 0),
 				 ANA_PGID_PGID, i);
 
-	/* Now, set PGIDs for each LAG */
+	/* The visited ports bitmask holds the list of ports offloading any
+	 * bonding interface. Initially we mark all these ports as unvisited,
+	 * then every time we visit a port in this bitmask, we know that it is
+	 * the lowest numbered port, i.e. the one whose logical ID == physical
+	 * port ID == LAG ID. So we mark as visited all further ports in the
+	 * bitmask that are offloading the same bonding interface. This way,
+	 * we set up the aggregation PGIDs only once per bonding interface.
+	 */
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port || !ocelot_port->bond)
+			continue;
+
+		visited &= ~BIT(port);
+	}
+
+	/* Now, set PGIDs for each active LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
+		struct net_device *bond = ocelot->ports[lag]->bond;
 		unsigned long bond_mask;
 		int aggr_count = 0;
 		u8 aggr_idx[16];
 
-		bond_mask = ocelot->lags[lag];
-		if (!bond_mask)
+		if (!bond || (visited & BIT(lag)))
 			continue;
 
+		bond_mask = ocelot_get_bond_mask(ocelot, bond);
+
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
@@ -1313,6 +1323,19 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 			ac |= BIT(aggr_idx[i % aggr_count]);
 			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
 		}
+
+		/* Mark all ports in the same LAG as visited to avoid applying
+		 * the same config again.
+		 */
+		for (port = lag; port < ocelot->num_phys_ports; port++) {
+			struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+			if (!ocelot_port)
+				continue;
+
+			if (ocelot_port->bond == bond)
+				visited |= BIT(port);
+		}
 	}
 }
 
@@ -1353,30 +1376,11 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info)
 {
-	u32 bond_mask = 0;
-	int lag;
-
 	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
 		return -EOPNOTSUPP;
 
 	ocelot->ports[port]->bond = bond;
 
-	bond_mask = ocelot_get_bond_mask(ocelot, bond);
-
-	lag = __ffs(bond_mask);
-
-	/* If the new port is the lowest one, use it as the logical port from
-	 * now on
-	 */
-	if (port == lag) {
-		ocelot->lags[port] = bond_mask;
-		bond_mask &= ~BIT(port);
-		if (bond_mask)
-			ocelot->lags[__ffs(bond_mask)] = 0;
-	} else {
-		ocelot->lags[lag] |= BIT(port);
-	}
-
 	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
@@ -1388,24 +1392,8 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond)
 {
-	int i;
-
 	ocelot->ports[port]->bond = NULL;
 
-	/* Remove port from any lag */
-	for (i = 0; i < ocelot->num_phys_ports; i++)
-		ocelot->lags[i] &= ~BIT(port);
-
-	/* if it was the logical port of the lag, move the lag config to the
-	 * next port
-	 */
-	if (ocelot->lags[port]) {
-		int n = __ffs(ocelot->lags[port]);
-
-		ocelot->lags[n] = ocelot->lags[port];
-		ocelot->lags[port] = 0;
-	}
-
 	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
@@ -1587,11 +1575,6 @@ int ocelot_init(struct ocelot *ocelot)
 		}
 	}
 
-	ocelot->lags = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
-				    sizeof(u32), GFP_KERNEL);
-	if (!ocelot->lags)
-		return -ENOMEM;
-
 	ocelot->stats = devm_kcalloc(ocelot->dev,
 				     ocelot->num_phys_ports * ocelot->num_stats,
 				     sizeof(u64), GFP_KERNEL);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index e36a1ed29c01..089e552719e0 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -657,8 +657,6 @@ struct ocelot {
 	enum ocelot_tag_prefix		npi_inj_prefix;
 	enum ocelot_tag_prefix		npi_xtr_prefix;
 
-	u32				*lags;
-
 	struct list_head		multicast;
 	struct list_head		pgids;
 
-- 
2.25.1

