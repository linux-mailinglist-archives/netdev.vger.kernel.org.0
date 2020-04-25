Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BA11B8864
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 20:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgDYSGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 14:06:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34944 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbgDYSGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 14:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2gxE2Y677GRCoPWDfI4VxKu+8m6SFYsMVe44nI80ZSY=; b=JNNQH7xlaQRftnZiZku/JXy2sh
        uTWi18Vfz8xJK60Gqx4+uhe5wzJPJga/I/arQONznN4OnJ99qvJuEL0M4H7F4G/yh7DLlr3fAEDOW
        /WSY/AwH29mbGajzGMy+n9aSHly5n5rR9JCrQZjRMXjqen/m+hayBJRCdq2zR8NvLLic=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSPCG-004mhS-5b; Sat, 25 Apr 2020 20:06:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 1/9] net: phy: Add cable test support to state machine
Date:   Sat, 25 Apr 2020 20:06:13 +0200
Message-Id: <20200425180621.1140452-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200425180621.1140452-1-andrew@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 72c69a9c8a98..4a6279c4a3a3 100644
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
@@ -44,6 +45,7 @@ static const char *phy_state_to_str(enum phy_state st)
 	PHY_STATE_STR(UP)
 	PHY_STATE_STR(RUNNING)
 	PHY_STATE_STR(NOLINK)
+	PHY_STATE_STR(CABLETEST)
 	PHY_STATE_STR(HALTED)
 	}
 
@@ -470,6 +472,51 @@ static void phy_trigger_machine(struct phy_device *phydev)
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
@@ -808,6 +855,9 @@ void phy_stop(struct phy_device *phydev)
 
 	mutex_lock(&phydev->lock);
 
+	if (phydev->state == PHY_CABLETEST)
+		phy_cable_test_abort(phydev);
+
 	if (phydev->sfp_bus)
 		sfp_upstream_stop(phydev->sfp_bus);
 
@@ -870,6 +920,7 @@ void phy_state_machine(struct work_struct *work)
 			container_of(dwork, struct phy_device, state_queue);
 	bool needs_aneg = false, do_suspend = false;
 	enum phy_state old_state;
+	bool finished = false;
 	int err = 0;
 
 	mutex_lock(&phydev->lock);
@@ -888,6 +939,20 @@ void phy_state_machine(struct work_struct *work)
 	case PHY_RUNNING:
 		err = phy_check_link_status(phydev);
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
index e2bfb9240587..916a5eb969a1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
 #include <linux/linkmode.h>
+#include <linux/netlink.h>
 #include <linux/mdio.h>
 #include <linux/mii.h>
 #include <linux/mii_timestamper.h>
@@ -343,6 +344,12 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
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
  * - phy_start moves to UP
@@ -354,6 +361,7 @@ enum phy_state {
 	PHY_UP,
 	PHY_RUNNING,
 	PHY_NOLINK,
+	PHY_CABLETEST,
 };
 
 /**
@@ -653,6 +661,13 @@ struct phy_driver {
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
@@ -1191,6 +1206,19 @@ int phy_speed_up(struct phy_device *phydev);
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
2.26.1

