Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F84311866
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhBFCgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhBFCdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:33:45 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02176C0611C3
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:26 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id p20so14444543ejb.6
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QKpdkMelmR9vRcUe1LgJJjZ28BK97tyoDUjRYm59MYc=;
        b=K941JhIqBaRbKKn1ghP4M3PUJOZP6SNub3Ka8tXVNuBm8Tyl9nrfNVPBZdVyPtJqC3
         XOY+01Iewa/quotq0I4Ac4RVUjZepY4FQTsT4SG2s1hMR8ebCSVGuokmgDOg7IwzXivg
         porbQjTTurkrqwh0TmhAGNyvW9WTb2uo9CySRyYfqqaGQiGvdOmwBKmap1+VlfCuF+jT
         71I/BArfQSqMmaMbEb/2isjJprjsQCESP1uF/QNIq3rPvEg3/X8ekQ4k8ST13etJHoiZ
         vG4732WEFomGJDgmLaONLIlIHwSMLgHctG4HcWMn5Nik25dHjGFeEKQ5Kk5TldsNTAky
         2vrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QKpdkMelmR9vRcUe1LgJJjZ28BK97tyoDUjRYm59MYc=;
        b=nhBxkfpt8Q/1sNdVkoAZ38izdpjZR6AyvbYhcAlcoeeNUJKWfU2G6qO0xcfuiFeYU1
         m/kLQRmzfRkW3E8zt1hbiQhNYmyh6ScumXcm4z6mR7haAVG/6fT9cA8A177oUZLQc49z
         nuvjUilHNk1roZcWf9UG2I5HpIdJUCx4ni2YqWakm+RwjsAUxRFb05fGV/tllKJWfmkn
         dN8qGRj7b4tI+Lmh+QVbAMJEM4rNPutuVl/IFCDKZUD3NRcEnO+JV+JWJEpQO00vRYl7
         3KAqRctGBmNKEtHMRm8tRUIF8ihyeVHoicd9axHXgrfKFzF9ZK6yfCc7FNe4nnZ3OfDI
         OJuA==
X-Gm-Message-State: AOAM530AafkRP8POq9L+VJ+5UXs3PXrmTJ3BL6/rfCXhksidab0s1HwG
        sGsZN5OgvRWxuBIRPSQLxRU=
X-Google-Smtp-Source: ABdhPJwg2+NLU42ofgvgY2mrH0+hJHaA8xZ8frtW79VHEnn5G8Rm4IwQCPWlngPnqbmuJ4aN4H0GcQ==
X-Received: by 2002:a17:906:dff1:: with SMTP id lc17mr5803338ejc.198.1612562604576;
        Fri, 05 Feb 2021 14:03:24 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:24 -0800 (PST)
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
Subject: [PATCH RESEND v3 net-next 12/12] net: dsa: felix: propagate the LAG offload ops towards the ocelot lib
Date:   Sat,  6 Feb 2021 00:02:21 +0200
Message-Id: <20210205220221.255646-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot switch has been supporting LAG offload since its initial
commit, however felix could not make use of that, due to lack of a LAG
abstraction in DSA. Now that we have that, let's forward DSA's calls
towards the ocelot library, who will deal with setting up the bonding.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
lag_leave and lag_change now return void.

Changes in v2:
s/lag_dev/bond/g

 drivers/net/dsa/ocelot/felix.c     | 32 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.h |  6 ------
 include/soc/mscc/ocelot.h          |  6 ++++++
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index c3200dfcb83b..a9840e80bd1f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -569,6 +569,35 @@ static void felix_bridge_leave(struct dsa_switch *ds, int port,
 	ocelot_port_bridge_leave(ocelot, port, br);
 }
 
+static int felix_lag_join(struct dsa_switch *ds, int port,
+			  struct net_device *bond,
+			  struct netdev_lag_upper_info *info)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_lag_join(ocelot, port, bond, info);
+}
+
+static int felix_lag_leave(struct dsa_switch *ds, int port,
+			   struct net_device *bond)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_lag_leave(ocelot, port, bond);
+
+	return 0;
+}
+
+static int felix_lag_change(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_lag_change(ocelot, port, dp->lag_tx_enabled);
+
+	return 0;
+}
+
 static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 			      const struct switchdev_obj_port_vlan *vlan)
 {
@@ -1341,6 +1370,9 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_mdb_del			= felix_mdb_del,
 	.port_bridge_join		= felix_bridge_join,
 	.port_bridge_leave		= felix_bridge_leave,
+	.port_lag_join			= felix_lag_join,
+	.port_lag_leave			= felix_lag_leave,
+	.port_lag_change		= felix_lag_change,
 	.port_stp_state_set		= felix_bridge_stp_state_set,
 	.port_vlan_filtering		= felix_vlan_filtering,
 	.port_vlan_add			= felix_vlan_add,
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index b18f6644726a..c485795c606b 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -109,12 +109,6 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 		      unsigned int vid, enum macaccess_entry_type type);
 int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid);
-int ocelot_port_lag_join(struct ocelot *ocelot, int port,
-			 struct net_device *bond,
-			 struct netdev_lag_upper_info *info);
-void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
-			   struct net_device *bond);
-void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
 int ocelot_netdev_to_port(struct net_device *dev);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 6e806872cd24..d0d48e9620fb 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -798,6 +798,12 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
+int ocelot_port_lag_join(struct ocelot *ocelot, int port,
+			 struct net_device *bond,
+			 struct netdev_lag_upper_info *info);
+void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
+			   struct net_device *bond);
+void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
 
 int ocelot_devlink_sb_register(struct ocelot *ocelot);
 void ocelot_devlink_sb_unregister(struct ocelot *ocelot);
-- 
2.25.1

