Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EC525B591
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgIBVDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIBVDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:03:37 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5238FC061244;
        Wed,  2 Sep 2020 14:03:37 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w7so376643pfi.4;
        Wed, 02 Sep 2020 14:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVbnIv7pbAdrtQM6KfEJY+PSmQg9DgIQ14umlSws9rM=;
        b=VAkpAH7eFF/XU/Ej4NBSa75xXMDcvJ9fFVwlpkRAHEwwgBsm1O2gjnQz1f1u3loW4L
         V671inYBAEbNe9QPaEz8ER6OWKF993vB63kX6kaDOzWNANZw+lW1NYmbbB1+GlKhwdcH
         klcPMinm8DjptPJgkLL1ktcVSWGUIAKi54LlI409YE1QePWRzTgOg8MqIKj4WP4m94EB
         v2O/wLnHH0+WtOAcPWKdeRlGaU41bcdAmKefz70W4l5N/J3lk7JZiSZM45/O9IOmffCB
         jCVuD/n8POMhRI1tEJJnU/KcPhUZGqxL70NzY34PDdzKgPEURUwufz3MAL0eYAgT+gyb
         1q5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVbnIv7pbAdrtQM6KfEJY+PSmQg9DgIQ14umlSws9rM=;
        b=Ux0vbNZG6n2iLRqrZlRLC0fmQfdIQJQeXFfgbylU0TW4QwHYlp4nW2zvj9w3vMBVs7
         ROO5Sxw1OM7zImJhBnOvMjE5AqL/U686eJuhGBjBZ4mkR8wP0yo68NqOq0YYgUyOZn2+
         hzS/aawFyGnQMjs0ASZmp1Jnqe4uriork9TSFCnhQX8OlQL+0PrzzaEpgdjkIgSd4/WS
         GbCS+KEvXSGMGaq/0fUY2Nrp+hlA/pXNiuqVEZcHLifup51MEd96MeDROuT9371SyQef
         LIdIKco3uiJ7d4FGaAaaOAFBVCuXgnH3AgGELlGx21sWvq6aB9C+k4Xq5fjzBBIyNvg1
         hc5A==
X-Gm-Message-State: AOAM530g3PAD8ZSekYDSKzFZjilzTy51S9ws2buqHy6jBITlAGP15uVl
        ydmJyzCeRK3XhlzRwILxbi/VIA8FxyE=
X-Google-Smtp-Source: ABdhPJyVVhWQxTxuvXFrM5i3h+gPExpgSl5FNvOM5fqM4yUluhmAZNS32PiAVsP18J1c721kGuXd4Q==
X-Received: by 2002:a65:62c3:: with SMTP id m3mr3304602pgv.338.1599080616385;
        Wed, 02 Sep 2020 14:03:36 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j10sm434092pff.171.2020.09.02.14.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 14:03:35 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: bcm_sf2: Ensure that MDIO diversion is used
Date:   Wed,  2 Sep 2020 14:03:27 -0700
Message-Id: <20200902210328.3131578-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
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
MDIO bus which is still the SF2 master MDIO bus.

Ensure that of_phy_connect() does not suceed by removing any phandle
reference for the PHY we need to divert. This forces the DSA code to use
the DSA slave_mii_bus that we register and ensures the MDIO diversion is
being used.

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

