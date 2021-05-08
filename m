Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E91376DE0
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhEHAcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhEHAcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:32:02 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90235C061364;
        Fri,  7 May 2021 17:29:49 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id a4so10870594wrr.2;
        Fri, 07 May 2021 17:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BOvSatlS8tFeNsTKg9BoqpzwguXJ04zpGtCKT1DOre8=;
        b=Mm5gWcLd1c4e0pcP92t14azF6y3OzFUybWV5hSMNMRR/39wdqwOv9g7YPTTm04bL0w
         Enslzxz7p9BggaiXc9YQYD3IUQKRlUNqwvlnaFbOgd66yKOt1jR4B2zf4T3WkBH/etAE
         bE6JkxPpd4hZfcNVpj4HRSooHjAnmUXkTelHCf3uiIfSu3pXxWGbMw+pflkCeWvZYtXC
         3owHWXkh8GVBzwNOqjXdtDNvADqAl8SxNtwC9g7ROMcokz0vgbHhBo2BQ76US/QGaO+b
         +WC0qmkOZF6lUcvcHBzU3UozxxV2pnLyxNz6NWxCrVvPfbYMemkYOnkO0fHJfGLTT0ZH
         CVTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BOvSatlS8tFeNsTKg9BoqpzwguXJ04zpGtCKT1DOre8=;
        b=rdr0M8B2vPjVLBhcXfVl4X4qFPNkFDEnP1uSpD4yOj8ObzLbZGWmGBSM2BnUDzdoOv
         tjsGSuDRBZB/VOgXwNKfPsHzRbQVktZOsBENPjTcPbTI2ta8LoX9tgm6AnRIDym4WeqF
         BcVTAqczaqVdbOVH2Y9T1+N73HnBAmOK/93ZjC2YcQKjoKwHvNM2e1v3dEJKppeCyni3
         UKE/6W76vHlLawPbIAzK1EGVnBzklUpepIHttNX38gwVC++pZ9dLqvpyezqXC1EcO00i
         6C3HbacI89dTbckBWu+Qwz+zlnC7ApFtPtSKxCAvLWrFgP0hW0ygRf0dvntLH8imWvsS
         H9rg==
X-Gm-Message-State: AOAM531rSqlvukQMkyRzHDOqPhjDfVT54esh5Wni9kfUs8dT/diAALS1
        byefcXyKu3GxNeUcSur+B+8=
X-Google-Smtp-Source: ABdhPJzGN+9MmRIwVF/kB23ZrSO8uN6toTitQSOApr5CTbYhkUjOFaGK3T0qDCGagw3Sh2CTkWaAEw==
X-Received: by 2002:a5d:64eb:: with SMTP id g11mr16098424wri.260.1620433788224;
        Fri, 07 May 2021 17:29:48 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:47 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 26/28] net: dsa: permit driver to provide custom phy_mii_mask for slave mdiobus
Date:   Sat,  8 May 2021 02:29:16 +0200
Message-Id: <20210508002920.19945-26-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some switch doesn't have a 1:1 map phy to port. Permit driver to provide
a custom phy_mii_mask so the internal mdiobus can correctly use the
provided phy reg as it can differ from the port reg.
The qca8k driver is provided as a first user of this function.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 30 ++++++++++++++++++++++++++++++
 include/net/dsa.h       |  7 +++++++
 net/dsa/dsa2.c          |  7 ++++++-
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 3d195fdd7ed5..3c3e05735b2d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1685,7 +1685,37 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 	return DSA_TAG_PROTO_QCA;
 }
 
+static u32
+qca8k_get_phys_mii_mask(struct dsa_switch *ds)
+{
+	struct device_node *mdio, *phy;
+	u32 reg, phy_mii_mask = 0;
+	int err;
+
+	mdio = of_get_child_by_name(ds->dev->of_node, "mdio");
+	if (mdio) {
+		for_each_available_child_of_node(mdio, phy) {
+			err = of_property_read_u32(phy, "reg", &reg);
+			if (err) {
+				of_node_put(phy);
+				of_node_put(mdio);
+				return 0;
+			}
+
+			phy_mii_mask |= BIT(reg);
+		}
+
+		of_node_put(mdio);
+		return phy_mii_mask;
+	}
+
+	/* Fallback to the lagacy mapping if mdio node is not found */
+	dev_warn(ds->dev, "Using the legacy phys_mii_mapping. Consider updating the dts.");
+	return dsa_user_ports(ds);
+}
+
 static const struct dsa_switch_ops qca8k_switch_ops = {
+	.get_phys_mii_mask	= qca8k_get_phys_mii_mask,
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
 	.get_strings		= qca8k_get_strings,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 83a933e563fe..4003ffc659a4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -511,6 +511,13 @@ struct dsa_switch_ops {
 	void	(*teardown)(struct dsa_switch *ds);
 	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
 
+	/*
+	 * Provide a custom phys_mii_mask for the dsa slave mdiobus instead
+	 * of relying on the dsa_user_ports. Not every switch has a 1:1 map
+	 * port to PHY, hence the driver can provide their fixed mask.
+	 */
+	u32	(*get_phys_mii_mask)(struct dsa_switch *ds);
+
 	/*
 	 * Access to the switch's PHY registers.
 	 */
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 79adabe3e2a7..7eabd4d67849 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -682,8 +682,13 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	 * driver and before ops->setup() has run, since the switch drivers and
 	 * the slave MDIO bus driver rely on these values for probing PHY
 	 * devices or not
+	 * Driver can provide his on mask as some switch doesn't have a 1:1 map
+	 * phy to port.
 	 */
-	ds->phys_mii_mask |= dsa_user_ports(ds);
+	if (ds->ops->get_phys_mii_mask)
+		ds->phys_mii_mask = ds->ops->get_phys_mii_mask(ds);
+	else
+		ds->phys_mii_mask |= dsa_user_ports(ds);
 
 	/* Add the switch to devlink before calling setup, so that setup can
 	 * add dpipe tables
-- 
2.30.2

