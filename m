Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A393F55E305
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbiF0JtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 05:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiF0JtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 05:49:14 -0400
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17A42735;
        Mon, 27 Jun 2022 02:49:11 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id BB4E3101E1D9F;
        Mon, 27 Jun 2022 11:49:09 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 7985461B8672;
        Mon, 27 Jun 2022 11:49:09 +0200 (CEST)
X-Mailbox-Line: From c5595bdb20625382538816c2e6d917d95c62e09b Mon Sep 17 00:00:00 2001
Message-Id: <c5595bdb20625382538816c2e6d917d95c62e09b.1656322883.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Mon, 27 Jun 2022 11:49:08 +0200
Subject: [PATCH net v3] net: phy: Don't trigger state machine while in suspend
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upon system sleep, mdio_bus_phy_suspend() stops the phy_state_machine(),
but subsequent interrupts may retrigger it:

They may have been left enabled to facilitate wakeup and are not
quiesced until the ->suspend_noirq() phase.  Unwanted interrupts may
hence occur between mdio_bus_phy_suspend() and dpm_suspend_noirq(),
as well as between dpm_resume_noirq() and mdio_bus_phy_resume().

Retriggering the phy_state_machine() through an interrupt is not only
undesirable for the reason given in mdio_bus_phy_suspend() (freezing it
midway with phydev->lock held), but also because the PHY may be
inaccessible after it's suspended:  Accesses to USB-attached PHYs are
blocked once usb_suspend_both() clears the can_submit flag and PHYs on
PCI network cards may become inaccessible upon suspend as well.

Amend phy_interrupt() to avoid triggering the state machine if the PHY
is suspended.  Signal wakeup instead if the attached net_device or its
parent has been configured as a wakeup source.  (Those conditions are
identical to mdio_bus_phy_may_suspend().)  Postpone handling of the
interrupt until the PHY has resumed.

Before stopping the phy_state_machine() in mdio_bus_phy_suspend(),
wait for a concurrent phy_interrupt() to run to completion.  That is
necessary because phy_interrupt() may have checked the PHY's suspend
status before the system sleep transition commenced and it may thus
retrigger the state machine after it was stopped.

Likewise, after re-enabling interrupt handling in mdio_bus_phy_resume(),
wait for a concurrent phy_interrupt() to complete to ensure that
interrupts which it postponed are properly rerun.

The issue was exposed by commit 3873b20fd278 ("usbnet: smsc95xx: Forward
PHY interrupts to PHY driver to avoid polling"), but has existed since
forever.  Hence the stable designation.

Link: https://lore.kernel.org/netdev/a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com/
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable@vger.kernel.org
---
 Resending as requested by Jakub.  No code changes since v1.
 
 Changes v1 -> v2:
 * Extend rationale in commit message.
 * Drop Fixes tag, add Tested-by tag (Marek).
 
 Changes v2 -> v3:
 * Add stable designation.
 * Add Acked-by tag (Rafael).
 
 Link to v1:
 https://lore.kernel.org/netdev/688f559346ea747d3b47a4d16ef8277e093f9ebe.1653556322.git.lukas@wunner.de/
 
 Link to v2:
 https://lore.kernel.org/netdev/cover.1654680790.git.lukas@wunner.de/
 
 drivers/net/phy/phy.c        | 23 +++++++++++++++++++++++
 drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
 include/linux/phy.h          |  6 ++++++
 3 files changed, 52 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef62f357b76d..8d3ee3a6495b 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -31,6 +31,7 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
+#include <linux/suspend.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 #include <net/sock.h>
@@ -976,6 +977,28 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 	struct phy_driver *drv = phydev->drv;
 	irqreturn_t ret;
 
+	/* Wakeup interrupts may occur during a system sleep transition.
+	 * Postpone handling until the PHY has resumed.
+	 */
+	if (IS_ENABLED(CONFIG_PM_SLEEP) && phydev->irq_suspended) {
+		struct net_device *netdev = phydev->attached_dev;
+
+		if (netdev) {
+			struct device *parent = netdev->dev.parent;
+
+			if (netdev->wol_enabled)
+				pm_system_wakeup();
+			else if (device_may_wakeup(&netdev->dev))
+				pm_wakeup_dev_event(&netdev->dev, 0, true);
+			else if (parent && device_may_wakeup(parent))
+				pm_wakeup_dev_event(parent, 0, true);
+		}
+
+		phydev->irq_rerun = 1;
+		disable_irq_nosync(irq);
+		return IRQ_HANDLED;
+	}
+
 	mutex_lock(&phydev->lock);
 	ret = drv->handle_interrupt(phydev);
 	mutex_unlock(&phydev->lock);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 431a8719c635..46acddd865a7 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -278,6 +278,15 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
 	if (phydev->mac_managed_pm)
 		return 0;
 
+	/* Wakeup interrupts may occur during the system sleep transition when
+	 * the PHY is inaccessible. Set flag to postpone handling until the PHY
+	 * has resumed. Wait for concurrent interrupt handler to complete.
+	 */
+	if (phy_interrupt_is_valid(phydev)) {
+		phydev->irq_suspended = 1;
+		synchronize_irq(phydev->irq);
+	}
+
 	/* We must stop the state machine manually, otherwise it stops out of
 	 * control, possibly with the phydev->lock held. Upon resume, netdev
 	 * may call phy routines that try to grab the same lock, and that may
@@ -315,6 +324,20 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 	if (ret < 0)
 		return ret;
 no_resume:
+	if (phy_interrupt_is_valid(phydev)) {
+		phydev->irq_suspended = 0;
+		synchronize_irq(phydev->irq);
+
+		/* Rerun interrupts which were postponed by phy_interrupt()
+		 * because they occurred during the system sleep transition.
+		 */
+		if (phydev->irq_rerun) {
+			phydev->irq_rerun = 0;
+			enable_irq(phydev->irq);
+			irq_wake_thread(phydev->irq, phydev);
+		}
+	}
+
 	if (phydev->attached_dev && phydev->adjust_link)
 		phy_start_machine(phydev);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 508f1149665b..b09f7d36cff2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -572,6 +572,10 @@ struct macsec_ops;
  * @mdix_ctrl: User setting of crossover
  * @pma_extable: Cached value of PMA/PMD Extended Abilities Register
  * @interrupts: Flag interrupts have been enabled
+ * @irq_suspended: Flag indicating PHY is suspended and therefore interrupt
+ *                 handling shall be postponed until PHY has resumed
+ * @irq_rerun: Flag indicating interrupts occurred while PHY was suspended,
+ *             requiring a rerun of the interrupt handler after resume
  * @interface: enum phy_interface_t value
  * @skb: Netlink message for cable diagnostics
  * @nest: Netlink nest used for cable diagnostics
@@ -626,6 +630,8 @@ struct phy_device {
 
 	/* Interrupts are enabled */
 	unsigned interrupts:1;
+	unsigned irq_suspended:1;
+	unsigned irq_rerun:1;
 
 	enum phy_state state;
 
-- 
2.36.1

