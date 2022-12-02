Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8304A6408FC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbiLBPMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbiLBPMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:12:13 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D01F9B78A;
        Fri,  2 Dec 2022 07:12:12 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 7E361124C;
        Fri,  2 Dec 2022 16:12:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669993930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qG7sQTY2fpVZirjAuGQmiko+Gx7p3pYVJOqz3hGWL/g=;
        b=nWhpormn9zVgFEJfIKZJprMMn+T+ky0Z81lsWbdoAr95O34jB+Lr/iKBZEfvSCHuKgBKhu
        rIeoVyu6bImhacHkBc5OLXdekRkkp3Mipm+r24gENkBP5Ijn+G9tMD0kGwy87Nansih6xv
        DSQuf0O+tmQ3OlYRJUpKSRwJxd8YyxBWaizLkXyDyl3tEdv4VYGAtvAZXj2GlNIUmxMrwc
        +6/mQ70cKrU7dHfunXJAQepu3FuUm5sGGt6EXKIMqHkUD4dNcUCFL+bYq0+L08elcluJbU
        kOMMrW+doHYPg3xWoCpv8k+s4gX1Klf3aYlWXZDf6ZyIgyropyYOQbmZ5tvhrg==
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v1 1/4] net: phy: mxl-gpy: add MDINT workaround
Date:   Fri,  2 Dec 2022 16:12:01 +0100
Message-Id: <20221202151204.3318592-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221202151204.3318592-1-michael@walle.cc>
References: <20221202151204.3318592-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At least the GPY215B and GPY215C has a bug where it is still driving the
interrupt line (MDINT) even after the interrupt status register is read
and its bits are cleared. This will cause an interrupt storm.

Although the MDINT is multiplexed with a GPIO pin and theoretically we
could switch the pinmux to GPIO input mode, this isn't possible because
the access to this register will stall exactly as long as the interrupt
line is asserted. We exploit this very fact and just read a random
internal register in our interrupt handler. This way, it will be delayed
until the external interrupt line is released and an interrupt storm is
avoided.

The internal register access via the mailbox was deduced by looking at
the downstream PHY API because the datasheet doesn't mention any of
this.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mxl-gpy.c | 83 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 0ff7ef076072..20e610dda891 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/bitfield.h>
 #include <linux/hwmon.h>
+#include <linux/mutex.h>
 #include <linux/phy.h>
 #include <linux/polynomial.h>
 #include <linux/netdevice.h>
@@ -81,6 +82,14 @@
 #define VSPEC1_TEMP_STA	0x0E
 #define VSPEC1_TEMP_STA_DATA	GENMASK(9, 0)
 
+/* Mailbox */
+#define VSPEC1_MBOX_DATA	0x5
+#define VSPEC1_MBOX_ADDRLO	0x6
+#define VSPEC1_MBOX_CMD		0x7
+#define VSPEC1_MBOX_CMD_ADDRHI	GENMASK(7, 0)
+#define VSPEC1_MBOX_CMD_RD	(0 << 8)
+#define VSPEC1_MBOX_CMD_READY	BIT(15)
+
 /* WoL */
 #define VPSPEC2_WOL_CTL		0x0E06
 #define VPSPEC2_WOL_AD01	0x0E08
@@ -88,7 +97,15 @@
 #define VPSPEC2_WOL_AD45	0x0E0A
 #define WOL_EN			BIT(0)
 
+/* Internal registers, access via mbox */
+#define REG_GPIO0_OUT		0xd3ce00
+
 struct gpy_priv {
+	struct phy_device *phydev;
+
+	/* serialize mailbox acesses */
+	struct mutex mbox_lock;
+
 	u8 fw_major;
 	u8 fw_minor;
 };
@@ -198,6 +215,40 @@ static int gpy_hwmon_register(struct phy_device *phydev)
 }
 #endif
 
+static int gpy_mbox_read(struct phy_device *phydev, u32 addr)
+{
+	struct gpy_priv *priv = phydev->priv;
+	int val, ret;
+	u16 cmd;
+
+	mutex_lock(&priv->mbox_lock);
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_MBOX_ADDRLO,
+			    addr);
+	if (ret)
+		goto out;
+
+	cmd = VSPEC1_MBOX_CMD_RD;
+	cmd |= FIELD_PREP(VSPEC1_MBOX_CMD_ADDRHI, addr >> 16);
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_MBOX_CMD, cmd);
+	if (ret)
+		goto out;
+
+	ret = phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
+					VSPEC1_MBOX_CMD, val,
+					(val & VSPEC1_MBOX_CMD_READY),
+					500, 10000, false);
+	if (ret)
+		goto out;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_MBOX_DATA);
+
+out:
+	mutex_unlock(&priv->mbox_lock);
+	return ret;
+}
+
 static int gpy_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -212,6 +263,13 @@ static int gpy_config_init(struct phy_device *phydev)
 	return ret < 0 ? ret : 0;
 }
 
+static bool gpy_has_broken_mdint(struct phy_device *phydev)
+{
+	/* At least these PHYs are known to have broken interrupt handling */
+	return phydev->drv->phy_id == PHY_ID_GPY215B ||
+	       phydev->drv->phy_id == PHY_ID_GPY215C;
+}
+
 static int gpy_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -228,7 +286,9 @@ static int gpy_probe(struct phy_device *phydev)
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
+	priv->phydev = phydev;
 	phydev->priv = priv;
+	mutex_init(&priv->mbox_lock);
 
 	fw_version = phy_read(phydev, PHY_FWV);
 	if (fw_version < 0)
@@ -574,6 +634,29 @@ static irqreturn_t gpy_handle_interrupt(struct phy_device *phydev)
 	if (!(reg & PHY_IMASK_MASK))
 		return IRQ_NONE;
 
+	/* The PHY might leave the interrupt line asserted even after PHY_ISTAT
+	 * is read. To avoid interrupt storms, delay the interrupt handling as
+	 * long as the PHY drives the interrupt line. An internal bus read will
+	 * stall as long as the interrupt line is asserted, thus just read a
+	 * random register here.
+	 * Because we cannot access the internal bus at all while the interrupt
+	 * is driven by the PHY, there is no way to make the interrupt line
+	 * unstuck (e.g. by changing the pinmux to GPIO input) during that time
+	 * frame. Therefore, polling is the best we can do and won't do any more
+	 * harm.
+	 * It was observed that this bug happens on link state and link speed
+	 * changes on a GPY215B and GYP215C independent of the firmware version
+	 * (which doesn't mean that this list is exhaustive).
+	 */
+	if (gpy_has_broken_mdint(phydev) &&
+	    (reg & (PHY_IMASK_LSTC | PHY_IMASK_LSPC))) {
+		reg = gpy_mbox_read(phydev, REG_GPIO0_OUT);
+		if (reg < 0) {
+			phy_error(phydev);
+			return IRQ_NONE;
+		}
+	}
+
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
-- 
2.30.2

