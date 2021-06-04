Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C4C39BA79
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 16:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFDOEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 10:04:48 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:34599 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbhFDOEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 10:04:46 -0400
Received: by mail-ed1-f48.google.com with SMTP id cb9so11314161edb.1;
        Fri, 04 Jun 2021 07:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ATTEBnkS8247ZxltsEDem/zatVT8czV8mG1/GhKPjpk=;
        b=ARDDDo9rgDhkQK/pSYHxA1ao399eEAefxkxYkhoijM5Euf3qo8Lp6etmsNjqdSQoju
         utMGZzHZU80o3mT+kqFHi3zP6Nd1kSKBPkQhaxpcMgiDSKZ/HJ0cXRVhL+0pHeXIKqD6
         kT/zGre0XbGkABkT+sfONkAQ4z47Is1NJIU7Tcns1mGu1QGYgdwcV4dcwPm8Zil6jQQX
         6hQB1L/jKEm8G5KKoMAy8wReyMav/fxSpDajdbBGb7d7u6eAnwdUAES9U7HQFXWH1J7V
         3FnLeH1JeTZS9RitVGUmEHmfwtCCAKVHj/Yvz+02VWXoxMtcsKE5VvIQ0iaUbsVw8SnU
         tJUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ATTEBnkS8247ZxltsEDem/zatVT8czV8mG1/GhKPjpk=;
        b=nQt/i8NcngmeDEkOlS1ITPSzHSCbIt5OOiCv2nA57LzUO2PQqscffEjfrghgFWkxGj
         cNBJuNhIjDU0SKWICPUZcpM0F5tHvBF1292sGPwQDGtV9zR+BPnVl8SFQx8qIkxkEqpR
         sYZbbeVm5+z7Mj+4aj3N7RZnIF44LifOjJYvYeej/hEUWEIqyPkW4stsGiXrjhR7Lmer
         nDpng6olwqzY6NeS0lyVWqtC4VTfUVtJbgxB+g6o5PTBUhelH7xsicStoFLOOWXI52bY
         xKwvYcxW3HwUJlQq/df2DK4ZGQry9hMM/0hOItGuqXqdttVQydAC6MOnPXyR1xwE2ChU
         Vmpg==
X-Gm-Message-State: AOAM533RtM2Ear6Hnc/dX2S4wYPR2RqtlUyDra8870I7xRP3aG0KwDaz
        pvVpJhFfOkdJxfSyzhDdTTbzYETzz60=
X-Google-Smtp-Source: ABdhPJykp8uME9Kfkr0nRiH8COUbGAFklB4wBqjosLg7kyeU22g+gAgEMUmYIpyKx5guaYXf8E2klg==
X-Received: by 2002:aa7:d6cc:: with SMTP id x12mr4855931edr.55.1622815319140;
        Fri, 04 Jun 2021 07:01:59 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id a22sm2804513ejv.67.2021.06.04.07.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 07:01:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 3/4] net: dsa: sja1105: determine PHY/MAC role from PHY interface type
Date:   Fri,  4 Jun 2021 17:01:50 +0300
Message-Id: <20210604140151.2885611-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210604140151.2885611-1-olteanv@gmail.com>
References: <20210604140151.2885611-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that both RevMII as well as RevRMII exist, we can deprecate the
sja1105,role-mac and sja1105,role-phy properties and simply let the user
select that a port operates in MII PHY role by using
	phy-mode = "rev-mii";
or in RMII PHY role by using
	phy-mode = "rev-rmii";

There are no fixed-link MII or RMII properties in mainline device trees,
and the setup itself is fairly uncommon, so there shouldn't be risks of
breaking compatibility.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../devicetree/bindings/net/dsa/sja1105.txt   | 37 +----------
 drivers/net/dsa/sja1105/sja1105_main.c        | 64 ++++++-------------
 2 files changed, 19 insertions(+), 82 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/sja1105.txt b/Documentation/devicetree/bindings/net/dsa/sja1105.txt
index 13fd21074d48..dcf3b2c1d26b 100644
--- a/Documentation/devicetree/bindings/net/dsa/sja1105.txt
+++ b/Documentation/devicetree/bindings/net/dsa/sja1105.txt
@@ -19,37 +19,6 @@ Required properties:
 	of support for RGMII internal delays (supported on P/Q/R/S, but not on
 	E/T).
 
-Optional properties:
-
-- sja1105,role-mac:
-- sja1105,role-phy:
-	Boolean properties that can be assigned under each port node. By
-	default (unless otherwise specified) a port is configured as MAC if it
-	is driving a PHY (phy-handle is present) or as PHY if it is PHY-less
-	(fixed-link specified, presumably because it is connected to a MAC).
-	The effect of this property (in either its implicit or explicit form)
-	is:
-	- In the case of MII or RMII it specifies whether the SJA1105 port is a
-	  clock source or sink for this interface (not applicable for RGMII
-	  where there is a Tx and an Rx clock).
-	- In the case of RGMII it affects the behavior regarding internal
-	  delays:
-	  1. If sja1105,role-mac is specified, and the phy-mode property is one
-	     of "rgmii-id", "rgmii-txid" or "rgmii-rxid", then the entity
-	     designated to apply the delay/clock skew necessary for RGMII
-	     is the PHY. The SJA1105 MAC does not apply any internal delays.
-	  2. If sja1105,role-phy is specified, and the phy-mode property is one
-	     of the above, the designated entity to apply the internal delays
-	     is the SJA1105 MAC (if hardware-supported). This is only supported
-	     by the second-generation (P/Q/R/S) hardware. On a first-generation
-	     E or T device, it is an error to specify an RGMII phy-mode other
-	     than "rgmii" for a port that is in fixed-link mode. In that case,
-	     the clock skew must either be added by the MAC at the other end of
-	     the fixed-link, or by PCB serpentine traces on the board.
-	These properties are required, for example, in the case where SJA1105
-	ports are at both ends of a MII/RMII PHY-less setup. One end would need
-	to have sja1105,role-mac, while the other sja1105,role-phy.
-
 See Documentation/devicetree/bindings/net/dsa/dsa.txt for the list of standard
 DSA required and optional properties.
 
@@ -87,7 +56,6 @@ arch/arm/boot/dts/ls1021a-tsn.dts:
 				phy-handle = <&rgmii_phy6>;
 				phy-mode = "rgmii-id";
 				reg = <0>;
-				/* Implicit "sja1105,role-mac;" */
 			};
 			port@1 {
 				/* ETH2 written on chassis */
@@ -95,7 +63,6 @@ arch/arm/boot/dts/ls1021a-tsn.dts:
 				phy-handle = <&rgmii_phy3>;
 				phy-mode = "rgmii-id";
 				reg = <1>;
-				/* Implicit "sja1105,role-mac;" */
 			};
 			port@2 {
 				/* ETH3 written on chassis */
@@ -103,7 +70,6 @@ arch/arm/boot/dts/ls1021a-tsn.dts:
 				phy-handle = <&rgmii_phy4>;
 				phy-mode = "rgmii-id";
 				reg = <2>;
-				/* Implicit "sja1105,role-mac;" */
 			};
 			port@3 {
 				/* ETH4 written on chassis */
@@ -111,14 +77,13 @@ arch/arm/boot/dts/ls1021a-tsn.dts:
 				label = "swp4";
 				phy-mode = "rgmii-id";
 				reg = <3>;
-				/* Implicit "sja1105,role-mac;" */
 			};
 			port@4 {
 				/* Internal port connected to eth2 */
 				ethernet = <&enet2>;
 				phy-mode = "rgmii";
 				reg = <4>;
-				/* Implicit "sja1105,role-phy;" */
+
 				fixed-link {
 					speed = <1000>;
 					full-duplex;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5839c1e0475a..cbce6e90dc63 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -57,14 +57,6 @@ static bool sja1105_can_forward(struct sja1105_l2_forwarding_entry *l2_fwd,
 	return !!(l2_fwd[from].reach_port & BIT(to));
 }
 
-/* Structure used to temporarily transport device tree
- * settings into sja1105_setup
- */
-struct sja1105_dt_port {
-	phy_interface_t phy_mode;
-	sja1105_mii_role_t role;
-};
-
 static int sja1105_init_mac_settings(struct sja1105_private *priv)
 {
 	struct sja1105_mac_config_entry default_mac = {
@@ -143,8 +135,7 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 	return 0;
 }
 
-static int sja1105_init_mii_settings(struct sja1105_private *priv,
-				     struct sja1105_dt_port *ports)
+static int sja1105_init_mii_settings(struct sja1105_private *priv)
 {
 	struct device *dev = &priv->spidev->dev;
 	struct sja1105_xmii_params_entry *mii;
@@ -171,16 +162,24 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 	mii = table->entries;
 
 	for (i = 0; i < ds->num_ports; i++) {
+		sja1105_mii_role_t role = XMII_MAC;
+
 		if (dsa_is_unused_port(priv->ds, i))
 			continue;
 
-		switch (ports[i].phy_mode) {
+		switch (priv->phy_mode[i]) {
+		case PHY_INTERFACE_MODE_REVMII:
+			role = XMII_PHY;
+			fallthrough;
 		case PHY_INTERFACE_MODE_MII:
 			if (!priv->info->supports_mii[i])
 				goto unsupported;
 
 			mii->xmii_mode[i] = XMII_MODE_MII;
 			break;
+		case PHY_INTERFACE_MODE_REVRMII:
+			role = XMII_PHY;
+			fallthrough;
 		case PHY_INTERFACE_MODE_RMII:
 			if (!priv->info->supports_rmii[i])
 				goto unsupported;
@@ -211,24 +210,11 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 unsupported:
 		default:
 			dev_err(dev, "Unsupported PHY mode %s on port %d!\n",
-				phy_modes(ports[i].phy_mode), i);
+				phy_modes(priv->phy_mode[i]), i);
 			return -EINVAL;
 		}
 
-		/* Even though the SerDes port is able to drive SGMII autoneg
-		 * like a PHY would, from the perspective of the XMII tables,
-		 * the SGMII port should always be put in MAC mode.
-		 * Similarly, RGMII is a symmetric protocol electrically
-		 * speaking, and the 'RGMII PHY' role does not mean anything to
-		 * hardware. Just keep the 'PHY role' notation relevant to the
-		 * driver to mean 'the switch port should apply RGMII delays',
-		 * but unconditionally put the port in the MAC role.
-		 */
-		if (ports[i].phy_mode == PHY_INTERFACE_MODE_SGMII ||
-		    phy_interface_mode_is_rgmii(ports[i].phy_mode))
-			mii->phy_mac[i] = XMII_MAC;
-		else
-			mii->phy_mac[i] = ports[i].role;
+		mii->phy_mac[i] = role;
 	}
 	return 0;
 }
@@ -751,8 +737,7 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	return 0;
 }
 
-static int sja1105_static_config_load(struct sja1105_private *priv,
-				      struct sja1105_dt_port *ports)
+static int sja1105_static_config_load(struct sja1105_private *priv)
 {
 	int rc;
 
@@ -767,7 +752,7 @@ static int sja1105_static_config_load(struct sja1105_private *priv,
 	rc = sja1105_init_mac_settings(priv);
 	if (rc < 0)
 		return rc;
-	rc = sja1105_init_mii_settings(priv, ports);
+	rc = sja1105_init_mii_settings(priv);
 	if (rc < 0)
 		return rc;
 	rc = sja1105_init_static_fdb(priv);
@@ -824,7 +809,6 @@ static int sja1105_parse_rgmii_delays(struct sja1105_private *priv)
 }
 
 static int sja1105_parse_ports_node(struct sja1105_private *priv,
-				    struct sja1105_dt_port *ports,
 				    struct device_node *ports_node)
 {
 	struct device *dev = &priv->spidev->dev;
@@ -853,7 +837,6 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 			of_node_put(child);
 			return -ENODEV;
 		}
-		ports[index].phy_mode = phy_mode;
 
 		phy_node = of_parse_phandle(child, "phy-handle", 0);
 		if (!phy_node) {
@@ -867,27 +850,17 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 			 * So it's a fixed link. Default to PHY role.
 			 */
 			priv->fixed_link[index] = true;
-			ports[index].role = XMII_PHY;
 		} else {
-			/* phy-handle present => put port in MAC role */
-			ports[index].role = XMII_MAC;
 			of_node_put(phy_node);
 		}
 
-		/* The MAC/PHY role can be overridden with explicit bindings */
-		if (of_property_read_bool(child, "sja1105,role-mac"))
-			ports[index].role = XMII_MAC;
-		else if (of_property_read_bool(child, "sja1105,role-phy"))
-			ports[index].role = XMII_PHY;
-
 		priv->phy_mode[index] = phy_mode;
 	}
 
 	return 0;
 }
 
-static int sja1105_parse_dt(struct sja1105_private *priv,
-			    struct sja1105_dt_port *ports)
+static int sja1105_parse_dt(struct sja1105_private *priv)
 {
 	struct device *dev = &priv->spidev->dev;
 	struct device_node *switch_node = dev->of_node;
@@ -902,7 +875,7 @@ static int sja1105_parse_dt(struct sja1105_private *priv,
 		return -ENODEV;
 	}
 
-	rc = sja1105_parse_ports_node(priv, ports, ports_node);
+	rc = sja1105_parse_ports_node(priv, ports_node);
 	of_node_put(ports_node);
 
 	return rc;
@@ -3008,11 +2981,10 @@ static const struct dsa_8021q_ops sja1105_dsa_8021q_ops = {
  */
 static int sja1105_setup(struct dsa_switch *ds)
 {
-	struct sja1105_dt_port ports[SJA1105_MAX_NUM_PORTS];
 	struct sja1105_private *priv = ds->priv;
 	int rc;
 
-	rc = sja1105_parse_dt(priv, ports);
+	rc = sja1105_parse_dt(priv);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to parse DT: %d\n", rc);
 		return rc;
@@ -3033,7 +3005,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 		return rc;
 	}
 	/* Create and send configuration down to device */
-	rc = sja1105_static_config_load(priv, ports);
+	rc = sja1105_static_config_load(priv);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to load static config: %d\n", rc);
 		goto out_ptp_clock_unregister;
-- 
2.25.1

