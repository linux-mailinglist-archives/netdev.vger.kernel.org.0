Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08D329D668
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730950AbgJ1WOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731233AbgJ1WOh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:14:37 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E93932474F;
        Wed, 28 Oct 2020 22:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603923277;
        bh=ju0jOrjbeRMwPzDrMrdXOwOtizflfQHNTwne0k956po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoWyDrwJT6gbIJNh9S9Jrq4e5iGIPsVSG1UzxWAdr2JrOSSeDjCNox64MF6fDdPkB
         nFu6/2Ik72ZjaWqcG1ydzphFd2TmK+J8aNKQzk29yPPGQAk/mzMKGKq7IzsPTilmYD
         F0mTkxz0fIoLFmMfc2f9AGRe9TEZN42rF6kTEJh0=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next 3/5] net: sfp: configure/destroy I2C mdiobus on transceiver plug/unplug
Date:   Wed, 28 Oct 2020 23:14:25 +0100
Message-Id: <20201028221427.22968-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201028221427.22968-1-kabel@kernel.org>
References: <20201028221427.22968-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of configuring the I2C mdiobus when SFP driver is probed,
configure/destroy the mdiobus when SFP transceiver is plugged/unplugged.

This way we can tell the mdio-i2c code which protocol to use for each
SFP transceiver.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index b1f9fc3a5584..a392d5fc6ab4 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -399,9 +399,6 @@ static int sfp_i2c_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
 
 static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 {
-	struct mii_bus *i2c_mii;
-	int ret;
-
 	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
 		return -EINVAL;
 
@@ -409,7 +406,15 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 	sfp->read = sfp_i2c_read;
 	sfp->write = sfp_i2c_write;
 
-	i2c_mii = mdio_i2c_alloc(sfp->dev, i2c, MDIO_I2C_DEFAULT);
+	return 0;
+}
+
+static int sfp_i2c_mdiobus_configure(struct sfp *sfp, enum mdio_i2c_type type)
+{
+	struct mii_bus *i2c_mii;
+	int ret;
+
+	i2c_mii = mdio_i2c_alloc(sfp->dev, sfp->i2c, type);
 	if (IS_ERR(i2c_mii))
 		return PTR_ERR(i2c_mii);
 
@@ -427,6 +432,12 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 	return 0;
 }
 
+static void sfp_i2c_mdiobus_destroy(struct sfp *sfp)
+{
+	mdiobus_unregister(sfp->i2c_mii);
+	sfp->i2c_mii = NULL;
+}
+
 /* Interface */
 static int sfp_read(struct sfp *sfp, bool a2, u8 addr, void *buf, size_t len)
 {
@@ -1768,6 +1779,11 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	else
 		sfp->module_t_start_up = T_START_UP;
 
+	/* Configure mdiobus */
+	ret = sfp_i2c_mdiobus_configure(sfp, MDIO_I2C_DEFAULT);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
@@ -1778,6 +1794,8 @@ static void sfp_sm_mod_remove(struct sfp *sfp)
 
 	sfp_hwmon_remove(sfp);
 
+	sfp_i2c_mdiobus_destroy(sfp);
+
 	memset(&sfp->id, 0, sizeof(sfp->id));
 	sfp->module_power_mW = 0;
 
-- 
2.26.2

