Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFCC25E35D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 23:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgIDVho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 17:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgIDVhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 17:37:37 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84301C061244;
        Fri,  4 Sep 2020 14:37:37 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id o20so5289875pfp.11;
        Fri, 04 Sep 2020 14:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OcqTF8e+JoPTx8G7niKWJfaNLj5p/Hr+7vHNXOoyo6g=;
        b=Fd4+PI039xeDAGiLj2zvjnXW/xFbXg4gRJgx3/Twe7P4ewcVqs6J7F3c98aLjk+ckF
         EEBXeTRtJC+IMQfah2+jmgb2lwTnkIL1fln8gGENv7D1xRg1m3jhl/VW07V3h5ddONfB
         ke8x0Bo3O028ZEmOVhYcTFbWipmOGCKDNGY8BUqby51QGHBhosQY5SkkOGXI4YuW980d
         yeW9a1tq9s7sw0wk1D6Vie8HLp+FF644Je4CC53rqMo9g3jcZzQ4gXw5VGpWfoeIwBS3
         lupJk5P1Vq/lsG/sQHxj59qwJzD7nQQQDnsvdAlHMZ5Z2+U2aIy50JTBi0sruURMCfRG
         7RQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcqTF8e+JoPTx8G7niKWJfaNLj5p/Hr+7vHNXOoyo6g=;
        b=NvkJ1S6/vPsqZhVPb4E7s/gfmzAPC3boXmw/0R1iPqezRrR128IX6hhJLlZpKdihOS
         gPtfnFbyu8XSN0dFrxQYegFXgCyQpBWaW8BU89eqr2HXpV9bYmVnLW5FmYcub3zG4ikE
         oN9c78ifsZEzFdurlX3XF617+Uo+qT95YF+qbxc16jhqY3ZMt9I+31OPpYZ6AQC0o2Qn
         XSOzYCFUkXqMEJfAu5OP/TP7IJ2VoHX/QGnKzibj61ruJfq9h5Z86eAEshcwi6jub66q
         jZ9KVfr/LZB9qKJIMh9jpJf++q8u/lIsaysT5IEyxHrBKZhXnaNL5ZHxqA6P/IljAoHw
         8dzw==
X-Gm-Message-State: AOAM533qo82EoWT/721z3I4YsfJQlQYjx5G9RLf6vVjb3eaHnAsb7t3t
        XGRfjjRAPDu/58GHTA641pBZtmTHl4c=
X-Google-Smtp-Source: ABdhPJxPdsXscoBWkZ2+aiNOYJCbs99t8HQ2YHV7V7wZzDVyklFO/INQlaz5ypfq4Lck9WKydN1EEA==
X-Received: by 2002:a63:1a51:: with SMTP id a17mr8536939pgm.309.1599255456571;
        Fri, 04 Sep 2020 14:37:36 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d17sm1255093pgn.56.2020.09.04.14.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 14:37:35 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE)
Subject: [PATCH net-next v2 2/2] net: dsa: bcm_sf2: Ensure that MDIO diversion is used
Date:   Fri,  4 Sep 2020 14:37:30 -0700
Message-Id: <20200904213730.3467899-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200904213730.3467899-1-f.fainelli@gmail.com>
References: <20200904213730.3467899-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Registering our slave MDIO bus outside of the OF infrastructure is
necessary in order to avoid creating double references of the same
Device Tree nodes, however it is not sufficient to guarantee that the
MDIO bus diversion is used because of_phy_connect() will still resolve
to a valid PHY phandle and it will connect to the PHY using its parent
MDIO bus which is still the SF2 master MDIO bus. The reason for that is
because BCM7445 systems were already shipped with a Device Tree blob
looking like this (irrelevant parts omitted for simplicity):

	ports {
		#address-cells = <1>;
		#size-cells = <0>;

		port@1 {
			phy-mode = "rgmii-txid";
			phy-handle = <&phy0>;
                        reg = <1>;
			label = "rgmii_1";
		};
	...

	mdio@403c0 {
		...

		phy0: ethernet-phy@0 {
			broken-turn-around;
			device_type = "ethernet-phy";
			max-speed = <0x3e8>;
			reg = <0>;
			compatible = "brcm,bcm53125", "ethernet-phy-ieee802.3-c22";
		};
	};

There is a hardware issue with chip revisions (Dx) that lead to the
development of the following commits:

461cd1b03e32 ("net: dsa: bcm_sf2: Register our slave MDIO bus")
536fab5bf582 ("net: dsa: bcm_sf2: Do not register slave MDIO bus with OF")
b8c6cd1d316f ("net: dsa: bcm_sf2: do not use indirect reads and writes for 7445E0")

There should have been an internal MDIO bus node created for the chip
revision (Dx) that suffers from this problem, but it did not happen back
then.

Had that happen, that we should have correctly parented phy@0 (bcm53125
below) as child node of the internal MDIO bus, but the production Device
Tree blob that was shipped with the firmware targeted the fixed version
of the chip, despite both the affected and corrected chips being shipped
into production.

The problem is that of_phy_connect() for port@1 will happily resolve the
'phy-handle' from the mdio@403c0 node, which bypasses the diversion
completely. This results in this double programming that the diversion
refers to and aims to avoid. In order to force of_phy_connect() to fail,
and have DSA call to dsa_slave_phy_connect(), we must deactivate
ethernet-phy@0 from mdio@403c0, and the best way to do that is by
removing the phandle property completely.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 1c7fbb6f0447..8e215c148487 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -489,9 +489,11 @@ static void bcm_sf2_identify_ports(struct bcm_sf2_priv *priv,
 static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
-	struct device_node *dn;
+	struct device_node *dn, *child;
+	struct phy_device *phydev;
+	struct property *prop;
 	static int index;
-	int err;
+	int err, reg;
 
 	/* Find our integrated MDIO bus node */
 	dn = of_find_compatible_node(NULL, NULL, "brcm,unimac-mdio");
@@ -534,6 +536,31 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	priv->slave_mii_bus->parent = ds->dev->parent;
 	priv->slave_mii_bus->phy_mask = ~priv->indir_phy_mask;
 
+	/* We need to make sure that of_phy_connect() will not work by
+	 * removing the 'phandle' and 'linux,phandle' properties and
+	 * unregister the existing PHY device that was already registered.
+	 */
+	for_each_available_child_of_node(dn, child) {
+		if (of_property_read_u32(child, "reg", &reg) ||
+		    reg >= PHY_MAX_ADDR)
+			continue;
+
+		if (!(priv->indir_phy_mask & BIT(reg)))
+			continue;
+
+		prop = of_find_property(child, "phandle", NULL);
+		if (prop)
+			of_remove_property(child, prop);
+
+		prop = of_find_property(child, "linux,phandle", NULL);
+		if (prop)
+			of_remove_property(child, prop);
+
+		phydev = of_phy_find_device(child);
+		if (phydev)
+			phy_device_remove(phydev);
+	}
+
 	err = mdiobus_register(priv->slave_mii_bus);
 	if (err && dn)
 		of_node_put(dn);
-- 
2.25.1

