Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7B62A0497
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgJ3Loz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgJ3Loy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 07:44:54 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43D602087E;
        Fri, 30 Oct 2020 11:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604058293;
        bh=ZE/7GpkICLgum3XvZqS09QGNg6xZthjtOImkORFv1+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LneMB7XwT3g9W9AeB1lVxujwguuKfCTlfqAmbMscZAbzc2N25BaxpoE+Uf8CEvilA
         xlSY7O5D0D6r+gXgbNMB/n6DatmRQb5li4RUfHY2OyhdeZErxcUzwtepPKfVd2B62S
         i3tNTEEtUUkhPvWCnQBbIB/oldtGNjjDel1b9Cew=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Ben Whitten <ben.whitten@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC leds + net-next 5/7] net: phy: add simple incrementing phyindex member to phy_device struct
Date:   Fri, 30 Oct 2020 12:44:33 +0100
Message-Id: <20201030114435.20169-6-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201030114435.20169-1-kabel@kernel.org>
References: <20201030114435.20169-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new integer member phyindex to struct phy_device. This member is
unique for every phy_device. Atomic incrementation occurs in
phy_device_register.

This can be used for example in LED sysfs API. The LED subsystem names
each LED in format `device:color:function`, but currently the PHY device
names are not suited for this, since in some situations a PHY device
name can look like this
  d0032004.mdio-mii:01
or even like this
  !soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:08
Clearly this cannot be used as the `device` part of a LED name.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phy_device.c | 3 +++
 include/linux/phy.h          | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5dab6be6fc38..38f581cc9713 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/atomic.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -892,6 +893,7 @@ EXPORT_SYMBOL(get_phy_device);
  */
 int phy_device_register(struct phy_device *phydev)
 {
+	static atomic_t phyindex;
 	int err;
 
 	err = mdiobus_register_device(&phydev->mdio);
@@ -908,6 +910,7 @@ int phy_device_register(struct phy_device *phydev)
 		goto out;
 	}
 
+	phydev->phyindex = atomic_inc_return(&phyindex) - 1;
 	err = device_add(&phydev->mdio.dev);
 	if (err) {
 		phydev_err(phydev, "failed to add\n");
diff --git a/include/linux/phy.h b/include/linux/phy.h
index eb3cb1a98b45..6dd4a28135c3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -480,6 +480,7 @@ struct macsec_ops;
  *
  * @mdio: MDIO bus this PHY is on
  * @drv: Pointer to the driver for this PHY instance
+ * @phyindex: a simple incrementing PHY index
  * @phy_id: UID for this device found during discovery
  * @c45_ids: 802.3-c45 Device Identifiers if is_c45.
  * @is_c45:  Set to true if this PHY uses clause 45 addressing.
@@ -551,6 +552,8 @@ struct phy_device {
 	/* And management functions */
 	struct phy_driver *drv;
 
+	int phyindex;
+
 	u32 phy_id;
 
 	struct phy_c45_device_ids c45_ids;
-- 
2.26.2

