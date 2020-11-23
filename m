Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA82C0F03
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389637AbgKWPiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389630AbgKWPix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:53 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1346EC061A4D;
        Mon, 23 Nov 2020 07:38:53 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id oq3so23903963ejb.7;
        Mon, 23 Nov 2020 07:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CV6UwT07nXETd6Jffx0QFSiDDCu+xqCT56jb99c/GxI=;
        b=udBgVt5hVzZ3IX46FEIJKwCFC7wvrtbHaIapMiBkSUmbEmTLyrlOEJ2abtdcQU7iK5
         zyAgSC0M9SxTIqdBSsQH9n8XU7axyuld6ethW8LcEZ2kprz92SVCIcnNu6pcFiEItfu/
         /8uSJOwE9Ti5nFbMlEUX2io2ebGsp7lD03XQEqd0BekrGsBysD3jMlk5gqSz1VSbIf0i
         IEZeQ+NdROvgwc1UTyNCZJnIvn58H7G6Y8btdAATXik1CGhTB4uYLWpcZ36//4Ovyyr+
         Vn1zHckWhzpkp85RcCSBsnqBdA+TYrAWxFDtJhIv1w9bOswLYptFoCem37AFkM/cANUA
         aYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CV6UwT07nXETd6Jffx0QFSiDDCu+xqCT56jb99c/GxI=;
        b=Gf6OUZohu6J4kfJ3jsVTP8hAop7hTfl6f6fZ6S4NiaeRaMrvVowLJuM9SxaEi7Zrvl
         HO3I3RfFRyAcpetgYhHl04u4PLVpZ3mc1lpv38OmzAj/dZgzlCi91Ioj+6irYkuC3775
         SAt9BWQWgiSbD18l3Qf5FkY6naVzzzRR433xkcX+L2ivBiKHoP7IpeoYlUnfLExrq0Li
         oBAwQYOoYGiJc2sBlQZArADdxfhi0zbTTV6kTGrz97LCUhqXKXOdehNyb3Z8zj+H07P3
         aQawgsH1PIBOFf9GtpqeqWKe+Cef7pgPA37/cLe6aOwEKTQ+xQbxvCq3Gi/8bWlCec1A
         1g6w==
X-Gm-Message-State: AOAM532X7GLFoSsgROW4InlXGgHQtlwDZ9YROoSu8VFc/o6f+8RDFTsO
        Xbx1wbXAHkiaBKfCFdWettU=
X-Google-Smtp-Source: ABdhPJwv5AfIAm8gE9ZAbaT8RZ9Aiq+i6fXP3G1rFdMeiGJMEI9awwH/PzbOwh94WeaEQpI0nysfJQ==
X-Received: by 2002:a17:906:5396:: with SMTP id g22mr172395ejo.111.1606145931787;
        Mon, 23 Nov 2020 07:38:51 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:51 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Marek Vasut <marex@denx.de>,
        Antoine Tenart <atenart@kernel.org>
Subject: [PATCH net-next 08/15] net: phy: micrel: remove the use of .ack_interrupt()
Date:   Mon, 23 Nov 2020 17:38:10 +0200
Message-Id: <20201123153817.1616814-9-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123153817.1616814-1-ciorneiioana@gmail.com>
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In preparation of removing the .ack_interrupt() callback, we must replace
its occurrences (aka phy_clear_interrupt), from the 2 places where it is
called from (phy_enable_interrupts and phy_disable_interrupts), with
equivalent functionality.

This means that clearing interrupts now becomes something that the PHY
driver is responsible of doing, before enabling interrupts and after
clearing them. Make this driver follow the new contract.

Cc: Divya Koppera <Divya.Koppera@microchip.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Philippe Schenker <philippe.schenker@toradex.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/micrel.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 9aa96ebd31c8..97f08f20630b 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -162,7 +162,7 @@ static int kszphy_ack_interrupt(struct phy_device *phydev)
 static int kszphy_config_intr(struct phy_device *phydev)
 {
 	const struct kszphy_type *type = phydev->drv->driver_data;
-	int temp;
+	int temp, err;
 	u16 mask;
 
 	if (type && type->interrupt_level_mask)
@@ -178,12 +178,23 @@ static int kszphy_config_intr(struct phy_device *phydev)
 	phy_write(phydev, MII_KSZPHY_CTRL, temp);
 
 	/* enable / disable interrupts */
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = kszphy_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		temp = KSZPHY_INTCS_ALL;
-	else
+		err = phy_write(phydev, MII_KSZPHY_INTCS, temp);
+	} else {
 		temp = 0;
+		err = phy_write(phydev, MII_KSZPHY_INTCS, temp);
+		if (err)
+			return err;
+
+		err = kszphy_ack_interrupt(phydev);
+	}
 
-	return phy_write(phydev, MII_KSZPHY_INTCS, temp);
+	return err;
 }
 
 static irqreturn_t kszphy_handle_interrupt(struct phy_device *phydev)
@@ -1182,7 +1193,6 @@ static struct phy_driver ksphy_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.driver_data	= &ks8737_type,
 	.config_init	= kszphy_config_init,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= genphy_suspend,
@@ -1195,7 +1205,6 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz8021_type,
 	.probe		= kszphy_probe,
 	.config_init	= kszphy_config_init,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
@@ -1211,7 +1220,6 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz8021_type,
 	.probe		= kszphy_probe,
 	.config_init	= kszphy_config_init,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
@@ -1228,7 +1236,6 @@ static struct phy_driver ksphy_driver[] = {
 	.probe		= kszphy_probe,
 	.config_init	= ksz8041_config_init,
 	.config_aneg	= ksz8041_config_aneg,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
@@ -1244,7 +1251,6 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz8041_type,
 	.probe		= kszphy_probe,
 	.config_init	= kszphy_config_init,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
@@ -1258,7 +1264,6 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz8051_type,
 	.probe		= kszphy_probe,
 	.config_init	= kszphy_config_init,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
@@ -1275,7 +1280,6 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz8041_type,
 	.probe		= kszphy_probe,
 	.config_init	= kszphy_config_init,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
@@ -1291,7 +1295,6 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz8081_type,
 	.probe		= kszphy_probe,
 	.config_init	= ksz8081_config_init,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
@@ -1305,7 +1308,6 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	/* PHY_BASIC_FEATURES */
 	.config_init	= ksz8061_config_init,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= genphy_suspend,
@@ -1319,7 +1321,6 @@ static struct phy_driver ksphy_driver[] = {
 	.probe		= kszphy_probe,
 	.get_features	= ksz9031_get_features,
 	.config_init	= ksz9021_config_init,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
@@ -1339,7 +1340,6 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= ksz9031_config_init,
 	.soft_reset	= genphy_soft_reset,
 	.read_status	= ksz9031_read_status,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
@@ -1369,7 +1369,6 @@ static struct phy_driver ksphy_driver[] = {
 	.probe		= kszphy_probe,
 	.config_init	= ksz9131_config_init,
 	.read_status	= genphy_read_status,
-	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
-- 
2.28.0

