Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC29526322D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731020AbgIIQgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730550AbgIIQ0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:26:03 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAD3C061756;
        Wed,  9 Sep 2020 09:25:59 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 29126140A72;
        Wed,  9 Sep 2020 18:25:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599668755; bh=FR7+inwZvbFVAUyvtRKpQapSQN3oEXOfxjaahzSXaLs=;
        h=From:To:Date;
        b=Y3DvO2vkbr4CDz6hfyGSc2Tt7tvL65TSQAvTKBJaLK65CPVJLSceKrKy4iXRxjEYl
         7vahHqtEdfyLlFVWHvqaRX68H2UiEmMDbbeIXV0pc6tyf2UR4LtZtA0Vrv2Bump1H4
         GG4U/VQU1x1Khvj3+YShPfDfo772ZezJ9xqRxQO8=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next + leds v2 3/7] net: phy: add simple incrementing phyindex member to phy_device struct
Date:   Wed,  9 Sep 2020 18:25:48 +0200
Message-Id: <20200909162552.11032-4-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909162552.11032-1-marek.behun@nic.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
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
  /soc/internal-regs@d0000000/mdio@32004/switch0@10/mdio:08
Clearly this cannot be used as the `device` part of a LED name.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/phy_device.c | 3 +++
 include/linux/phy.h          | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8adfbad0a1e8f..38f56d39f1229 100644
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
index 3a09d2bf69ea4..52881e21ad951 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -406,6 +406,7 @@ struct macsec_ops;
 /* phy_device: An instance of a PHY
  *
  * drv: Pointer to the driver for this PHY instance
+ * phyindex: a simple incrementing PHY index
  * phy_id: UID for this device found during discovery
  * c45_ids: 802.3-c45 Device Identifers if is_c45.
  * is_c45:  Set to true if this phy uses clause 45 addressing.
@@ -446,6 +447,8 @@ struct phy_device {
 	/* And management functions */
 	struct phy_driver *drv;
 
+	int phyindex;
+
 	u32 phy_id;
 
 	struct phy_c45_device_ids c45_ids;
-- 
2.26.2

