Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2282264353B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 21:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiLEUFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 15:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiLEUFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 15:05:10 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D77E13DCD;
        Mon,  5 Dec 2022 12:05:08 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 73D08124C;
        Mon,  5 Dec 2022 21:05:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1670270706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BFvk8I8NGgkaO68NHQ+fUIWKW1Nsx3uLB2VUw+ynUEY=;
        b=gZRPOpBiyUI76mQOJZmOPSvWIZrxFJxcUxzC930S9BMxmoieXElMVBS4GFlnmPoHICeluA
        dTIGwz6dQMuAa8xFLkBKIlIEJPbZz4bCXnG+yRAnuh9tUmduq7UAq2RaZSQEXQ7eXg+xS7
        5iwny52gApiRzS7M8Eio5eqnndncWxSObJbsHK6/zw/7OeuAYkrLVv9mZIPdgRyc6aH2IC
        9iermRUlnAwMyYwne1ggZ6L38eKAiShgLAWqWncPrfl5AX8WTo4lANOfL5npZ5/GbWPNsM
        /ltgj4/z+SLwUz649XlPCmMP5sI9RDpX1bIdYUX2NdfF4wtyuB6lRxggpvWiAw==
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v2 net] net: phy: mxl-gpy: add MDINT workaround
Date:   Mon,  5 Dec 2022 21:04:53 +0100
Message-Id: <20221205200453.3447866-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Fixes: 7d901a1e878a ("net: phy: add Maxlinear GPY115/21x/24x driver")
Signed-off-by: Michael Walle <michael@walle.cc>
---
changes since v1:
 - split from
   https://lore.kernel.org/netdev/20221202151204.3318592-1-michael@walle.cc/
 - rebase to net queue
 - add Fixes tag
 - remove unused phydev pointer in priv struct
 - add comment on the gpy_mbox_read polling period

 drivers/net/phy/mxl-gpy.c | 85 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 24bae27eedef..cae24091fb6f 100644
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
@@ -70,6 +71,14 @@
 #define VPSPEC1_TEMP_STA	0x0E
 #define VPSPEC1_TEMP_STA_DATA	GENMASK(9, 0)
 
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
@@ -77,7 +86,13 @@
 #define VPSPEC2_WOL_AD45	0x0E0A
 #define WOL_EN			BIT(0)
 
+/* Internal registers, access via mbox */
+#define REG_GPIO0_OUT		0xd3ce00
+
 struct gpy_priv {
+	/* serialize mailbox acesses */
+	struct mutex mbox_lock;
+
 	u8 fw_major;
 	u8 fw_minor;
 };
@@ -187,6 +202,45 @@ static int gpy_hwmon_register(struct phy_device *phydev)
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
+	/* The mbox read is used in the interrupt workaround. It was observed
+	 * that a read might take up to 2.5ms. This is also the time for which
+	 * the interrupt line is stuck low. To be on the safe side, poll the
+	 * ready bit for 10ms.
+	 */
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
@@ -201,6 +255,13 @@ static int gpy_config_init(struct phy_device *phydev)
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
@@ -218,6 +279,7 @@ static int gpy_probe(struct phy_device *phydev)
 	if (!priv)
 		return -ENOMEM;
 	phydev->priv = priv;
+	mutex_init(&priv->mbox_lock);
 
 	fw_version = phy_read(phydev, PHY_FWV);
 	if (fw_version < 0)
@@ -492,6 +554,29 @@ static irqreturn_t gpy_handle_interrupt(struct phy_device *phydev)
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

