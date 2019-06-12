Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A4742BC1
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438183AbfFLQGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:06:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49264 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437056AbfFLQGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:06:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2iaj43uRUIMGUAUPsY/JO63UpgZX0OQimtYuKMAmDMw=; b=aH19HdGCYChwVDdWR3OPkChhj2
        2z86k3hBM4SkEHorxBpQXipdJ2qj+hV3RGJzfTYBqwAQ5fVWRVz4c84LVUZmQPVI/C7vPOQUF6DC6
        05Ze8CeExLId7uMJklXfDC2uJJD6Cniy4wvH/ECdilU41gMgrW5gaw5gPkCFWDpskJNI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lC-00068H-U7; Wed, 12 Jun 2019 18:06:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 01/13] net: phy: Add cable test support to state machine
Date:   Wed, 12 Jun 2019 18:05:22 +0200
Message-Id: <20190612160534.23533-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running a cable test is desruptive to normal operation of the PHY and
can take a 5 to 10 seconds to complete. The RTNL lock cannot be held
for this amount of time, and add a new state to the state machine for
running a cable test.

The driver is expected to implement two functions. The first is used
to start a cable test. Once the test has started, it should return.

The second function is called once per second, or on interrupt to
check if the cable test is complete, and to allow the PHY to report
the status.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 65 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h   | 28 +++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 984de987241c..65b13c74c158 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -15,6 +15,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netlink.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/mm.h>
@@ -42,6 +43,7 @@ static const char *phy_state_to_str(enum phy_state st)
 	PHY_STATE_STR(RUNNING)
 	PHY_STATE_STR(NOLINK)
 	PHY_STATE_STR(FORCING)
+	PHY_STATE_STR(CABLETEST)
 	PHY_STATE_STR(HALTED)
 	PHY_STATE_STR(RESUMING)
 	}
@@ -465,6 +467,51 @@ static void phy_trigger_machine(struct phy_device *phydev)
 	phy_queue_state_machine(phydev, 0);
 }
 
+static void phy_cable_test_abort(struct phy_device *phydev)
+{
+	genphy_soft_reset(phydev);
+}
+
+int phy_start_cable_test(struct phy_device *phydev,
+			 struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!(phydev->drv &&
+	      phydev->drv->cable_test_start &&
+	      phydev->drv->cable_test_get_status)) {
+		NL_SET_ERR_MSG(extack,
+			       "PHY driver does not support cable testing");
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&phydev->lock);
+	if (phydev->state < PHY_UP ||
+	    phydev->state >= PHY_CABLETEST) {
+		NL_SET_ERR_MSG(extack,
+			       "PHY not configured. Try setting interface up");
+		err = -EBUSY;
+		goto out;
+	}
+
+	/* Mark the carrier down until the test is complete */
+	phy_link_down(phydev, true);
+
+	err = phydev->drv->cable_test_start(phydev);
+	if (err) {
+		phy_link_up(phydev);
+		goto out;
+	}
+
+	phydev->state = PHY_CABLETEST;
+
+out:
+	mutex_unlock(&phydev->lock);
+
+	return err;
+}
+EXPORT_SYMBOL(phy_start_cable_test);
+
 static int phy_config_aneg(struct phy_device *phydev)
 {
 	if (phydev->drv->config_aneg)
@@ -810,6 +857,9 @@ void phy_stop(struct phy_device *phydev)
 
 	mutex_lock(&phydev->lock);
 
+	if (phydev->state == PHY_CABLETEST)
+		phy_cable_test_abort(phydev);
+
 	if (phy_interrupt_is_valid(phydev))
 		phy_disable_interrupts(phydev);
 
@@ -881,6 +931,7 @@ void phy_state_machine(struct work_struct *work)
 			container_of(dwork, struct phy_device, state_queue);
 	bool needs_aneg = false, do_suspend = false;
 	enum phy_state old_state;
+	bool finished = false;
 	int err = 0;
 
 	mutex_lock(&phydev->lock);
@@ -914,6 +965,20 @@ void phy_state_machine(struct work_struct *work)
 			phy_link_down(phydev, false);
 		}
 		break;
+	case PHY_CABLETEST:
+		err = phydev->drv->cable_test_get_status(phydev, &finished);
+		if (err) {
+			phy_cable_test_abort(phydev);
+			needs_aneg = true;
+			phydev->state = PHY_UP;
+			break;
+		}
+
+		if (finished) {
+			needs_aneg = true;
+			phydev->state = PHY_UP;
+		}
+		break;
 	case PHY_HALTED:
 		if (phydev->link) {
 			phydev->link = 0;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0f9552b17ee7..2531684f507d 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -20,6 +20,7 @@
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
 #include <linux/linkmode.h>
+#include <linux/netlink.h>
 #include <linux/mdio.h>
 #include <linux/mii.h>
 #include <linux/module.h>
@@ -306,6 +307,12 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
  * - irq or timer will set NOLINK if link goes down
  * - phy_stop moves to HALTED
  *
+ * CABLETEST: PHY is performing a cable test. Packet reception/sending
+ * is not expected to work, carrier will be indicated as down. PHY will be
+ * poll once per second, or on interrupt for it current state.
+ * Once complete, move to UP to restart the PHY.
+ * - phy_stop aborts the running test and moves to HALTED
+ *
  * HALTED: PHY is up, but no polling or interrupts are done. Or
  * PHY is in an error state.
  *
@@ -324,6 +331,7 @@ enum phy_state {
 	PHY_RUNNING,
 	PHY_NOLINK,
 	PHY_FORCING,
+	PHY_CABLETEST,
 	PHY_RESUMING
 };
 
@@ -626,6 +634,13 @@ struct phy_driver {
 	int (*module_eeprom)(struct phy_device *dev,
 			     struct ethtool_eeprom *ee, u8 *data);
 
+	/* Start a cable test */
+	int (*cable_test_start)(struct phy_device *dev);
+	/* Once per second, or on interrupt, request the status of the
+	 * test.
+	 */
+	int (*cable_test_get_status)(struct phy_device *dev, bool *finished);
+
 	/* Get statistics from the phy using ethtool */
 	int (*get_sset_count)(struct phy_device *dev);
 	void (*get_strings)(struct phy_device *dev, u8 *data);
@@ -1050,6 +1065,19 @@ int phy_speed_up(struct phy_device *phydev);
 int phy_restart_aneg(struct phy_device *phydev);
 int phy_reset_after_clk_enable(struct phy_device *phydev);
 
+#if IS_ENABLED(CONFIG_PHYLIB)
+int phy_start_cable_test(struct phy_device *phydev,
+			 struct netlink_ext_ack *extack);
+#else
+static inline
+int phy_start_cable_test(struct phy_device *phydev,
+			 struct netlink_ext_ack *extack)
+{
+	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
+	return -EOPNOTSUPP;
+}
+#endif
+
 static inline void phy_device_reset(struct phy_device *phydev, int value)
 {
 	mdio_device_reset(&phydev->mdio, value);
-- 
2.20.1

