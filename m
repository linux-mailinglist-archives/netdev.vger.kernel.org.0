Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 259A012A9AB
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfLZCQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:16:51 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50363 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfLZCQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:16:37 -0500
Received: by mail-pj1-f68.google.com with SMTP id r67so2753886pjb.0;
        Wed, 25 Dec 2019 18:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0xNn8rOhvQ0q/eVsblgqPKWbsQdxuQgNbseY+ebe5zk=;
        b=uiH/hT6t6N6748th+48BCkyAR9uJD4b2RaXJ/h0XZhFcgflKtDXLZQmQiA3JzpMJGs
         Zd0RCN6QwOdEnsZJTQagx5UyQtzRsrjgoEd2sJhTKFVlpFnJCAe/fqUJuM69bqV5U58t
         WL0h/LsNJ7p1N4IjrgvxU1mzQyZhwtplLhmvfjopUf4OeHziS4iekLjfA0pQIPQpVQpL
         JsoqRFxpIQtzdc7FVY5IPwKdLWv3IfOQidAAueRTeKeb6IOKQTgGB67e9TTGyqZlOXpa
         D2hL7mdfMwrJJu5EL+ZVe4/EnSIibbtc/lxzEZyxaCCOz+HwitrJh1+s41RPbuSW0NGr
         JFRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0xNn8rOhvQ0q/eVsblgqPKWbsQdxuQgNbseY+ebe5zk=;
        b=nKX0XatxvOHWKJTiJgR8Oc7XUDVPCtJKv/yXlbdsNvG3Uscx6M8hGccxA9fDFVZSy1
         2HArHjIT2TLBieXKIVDQ/8TaHl7K7otYZMjnUIDxLygk3Y8vu73vfmdUPFBxyQoBzs4z
         ozFoyrPxhaqYohmhgJrPQivzFYW7okpL7RL+dvqPiWr0DaiUcA1St5n/+m9Ywjj55jN3
         7Bn2IJCS5EIMgIF/XrVoDYVQyWp8gGkpqaCIONTACZufEsEfrzZSUvwl3chO58ahSC/W
         h0+W6tpjnUtQvOnp6vDK2B9B2EMdhK3L8a+1jYxSobpTvfiBdk2ab37DN5d3WVeEqOFb
         ceFw==
X-Gm-Message-State: APjAAAUZQ6w/w0deM4bCKGKiGomdxhco+XDz966azvE/nZ3IjAW5cJLf
        mhhkh/208Foq7lk7G4E0IK12hoJq
X-Google-Smtp-Source: APXvYqyyk+sKrngMza8Vnp27YMJnAMAIgvq+TTfss04Qs9J89dP1kprzwI916gHpkL7bvb79KtZjYQ==
X-Received: by 2002:a17:902:9a98:: with SMTP id w24mr43971499plp.300.1577326596658;
        Wed, 25 Dec 2019 18:16:36 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b65sm31880723pgc.18.2019.12.25.18.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:16:36 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>, Rob Herring <robh@kernel.org>
Subject: [PATCH V9 net-next 10/12] net: mdio: of: Register discovered MII time stampers.
Date:   Wed, 25 Dec 2019 18:16:18 -0800
Message-Id: <3e3eac41c3a43a9dc444903e0b0179b59f250498.1577326042.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1577326042.git.richardcochran@gmail.com>
References: <cover.1577326042.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When parsing a PHY node, register its time stamper, if any, and attach
the instance to the PHY device.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 drivers/net/phy/phy_device.c |  3 +++
 drivers/of/of_mdio.c         | 30 +++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ee45838f90c9..debbda61e12b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -881,6 +881,9 @@ EXPORT_SYMBOL(phy_device_register);
  */
 void phy_device_remove(struct phy_device *phydev)
 {
+	if (phydev->mii_ts)
+		unregister_mii_timestamper(phydev->mii_ts);
+
 	device_del(&phydev->mdio.dev);
 
 	/* Assert the reset signal */
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index c6b87ce2b0cc..0b7aee235813 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -42,14 +42,37 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 	return -EINVAL;
 }
 
+static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
+{
+	struct of_phandle_args arg;
+	int err;
+
+	err = of_parse_phandle_with_fixed_args(node, "timestamper", 1, 0, &arg);
+
+	if (err == -ENOENT)
+		return NULL;
+	else if (err)
+		return ERR_PTR(err);
+
+	if (arg.args_count != 1)
+		return ERR_PTR(-EINVAL);
+
+	return register_mii_timestamper(arg.np, arg.args[0]);
+}
+
 static int of_mdiobus_register_phy(struct mii_bus *mdio,
 				    struct device_node *child, u32 addr)
 {
+	struct mii_timestamper *mii_ts;
 	struct phy_device *phy;
 	bool is_c45;
 	int rc;
 	u32 phy_id;
 
+	mii_ts = of_find_mii_timestamper(child);
+	if (IS_ERR(mii_ts))
+		return PTR_ERR(mii_ts);
+
 	is_c45 = of_device_is_compatible(child,
 					 "ethernet-phy-ieee802.3-c45");
 
@@ -57,11 +80,14 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
 	else
 		phy = get_phy_device(mdio, addr, is_c45);
-	if (IS_ERR(phy))
+	if (IS_ERR(phy)) {
+		unregister_mii_timestamper(mii_ts);
 		return PTR_ERR(phy);
+	}
 
 	rc = of_irq_get(child, 0);
 	if (rc == -EPROBE_DEFER) {
+		unregister_mii_timestamper(mii_ts);
 		phy_device_free(phy);
 		return rc;
 	}
@@ -90,10 +116,12 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	 * register it */
 	rc = phy_device_register(phy);
 	if (rc) {
+		unregister_mii_timestamper(mii_ts);
 		phy_device_free(phy);
 		of_node_put(child);
 		return rc;
 	}
+	phy->mii_ts = mii_ts;
 
 	dev_dbg(&mdio->dev, "registered phy %pOFn at address %i\n",
 		child, addr);
-- 
2.20.1

