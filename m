Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67201CC29D
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgEIQ3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:29:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50930 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728224AbgEIQ3R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 12:29:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=J/htPZFUX0RuyLaiRcqqC8vRIbR7RtXc/9keB6GFb0w=; b=6YIHgQxkZpc7eLQ9m6GuWdVAdq
        PD6b4R2JgnumuwMmwuhUVaMsqVm6DtbStiLl+OO8AekicqnoLX1Qvw7wlAdf9liAiZeriH1s0DRFw
        AhMLa6oNXyM+t4k/QtGA+CrsvVCyYPpXlvbPu+DDWNRLjQ82tlJ1gPAHKs2dBTLf3o4k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXSLc-001WHV-56; Sat, 09 May 2020 18:29:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 06/10] net: ethtool: Add infrastructure for reporting cable test results
Date:   Sat,  9 May 2020 18:28:47 +0200
Message-Id: <20200509162851.362346-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509162851.362346-1-andrew@lunn.ch>
References: <20200509162851.362346-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide infrastructure for PHY drivers to report the cable test
results.  A netlink skb is associated to the phydev. Helpers will be
added which can add results to this skb. Once the test has finished
the results are sent to user space.

When netlink ethtool is not part of the kernel configuration stubs are
provided. It is also impossible to trigger a cable test, so the error
code returned by the alloc function is of no consequence.

v2:
Include the status complete in the netlink notification message

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c           | 22 +++++++++++--
 include/linux/ethtool_netlink.h | 20 ++++++++++++
 include/linux/phy.h             |  5 +++
 net/ethtool/cabletest.c         | 55 +++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 9fa61019533f..afdc1c2146ee 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
+#include <linux/ethtool_netlink.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
 #include <linux/sfp.h>
@@ -30,6 +31,9 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
+#include <net/netlink.h>
+#include <net/genetlink.h>
+#include <net/sock.h>
 
 #define PHY_STATE_TIME	HZ
 
@@ -478,6 +482,8 @@ static void phy_abort_cable_test(struct phy_device *phydev)
 {
 	int err;
 
+	ethnl_cable_test_finished(phydev);
+
 	err = phy_init_hw(phydev);
 	if (err)
 		phydev_err(phydev, "Error while aborting cable test");
@@ -486,7 +492,7 @@ static void phy_abort_cable_test(struct phy_device *phydev)
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack)
 {
-	int err;
+	int err = -ENOMEM;
 
 	if (!(phydev->drv &&
 	      phydev->drv->cable_test_start &&
@@ -512,19 +518,30 @@ int phy_start_cable_test(struct phy_device *phydev,
 		goto out;
 	}
 
+	err = ethnl_cable_test_alloc(phydev);
+	if (err)
+		goto out;
+
 	/* Mark the carrier down until the test is complete */
 	phy_link_down(phydev, true);
 
 	err = phydev->drv->cable_test_start(phydev);
 	if (err) {
 		phy_link_up(phydev);
-		goto out;
+		goto out_free;
 	}
 
 	phydev->state = PHY_CABLETEST;
 
 	if (phy_polling_mode(phydev))
 		phy_trigger_machine(phydev);
+
+	mutex_unlock(&phydev->lock);
+
+	return 0;
+
+out_free:
+	ethnl_cable_test_free(phydev);
 out:
 	mutex_unlock(&phydev->lock);
 
@@ -964,6 +981,7 @@ void phy_state_machine(struct work_struct *work)
 		}
 
 		if (finished) {
+			ethnl_cable_test_finished(phydev);
 			needs_aneg = true;
 			phydev->state = PHY_UP;
 		}
diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index d01b77887f82..7d763ba22f6f 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -14,4 +14,24 @@ enum ethtool_multicast_groups {
 	ETHNL_MCGRP_MONITOR,
 };
 
+struct phy_device;
+
+#if IS_ENABLED(CONFIG_ETHTOOL_NETLINK)
+int ethnl_cable_test_alloc(struct phy_device *phydev);
+void ethnl_cable_test_free(struct phy_device *phydev);
+void ethnl_cable_test_finished(struct phy_device *phydev);
+#else
+static inline int ethnl_cable_test_alloc(struct phy_device *phydev)
+{
+	return -ENOTSUPP;
+}
+
+static inline void ethnl_cable_test_free(struct phy_device *phydev)
+{
+}
+
+static inline void ethnl_cable_test_finished(struct phy_device *phydev)
+{
+}
+#endif /* IS_ENABLED(ETHTOOL_NETLINK) */
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index f58eee735a45..169fae4249a9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -523,6 +523,11 @@ struct phy_device {
 	/* For use by PHYs inside the same package that need a shared state. */
 	struct phy_package_shared *shared;
 
+	/* Reporting cable test results */
+	struct sk_buff *skb;
+	void *ehdr;
+	struct nlattr *nest;
+
 	/* Interrupt and Polling infrastructure */
 	struct delayed_work state_queue;
 
diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index aeb6672a46d0..bed6c67ea933 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/phy.h>
+#include <linux/ethtool_netlink.h>
 #include "netlink.h"
 #include "common.h"
 
@@ -52,3 +53,57 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 	dev_put(dev);
 	return ret;
 }
+
+int ethnl_cable_test_alloc(struct phy_device *phydev)
+{
+	int err = -ENOMEM;
+
+	phydev->skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!phydev->skb)
+		goto out;
+
+	phydev->ehdr = ethnl_bcastmsg_put(phydev->skb,
+					  ETHTOOL_MSG_CABLE_TEST_NTF);
+	if (!phydev->ehdr) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = ethnl_fill_reply_header(phydev->skb, phydev->attached_dev,
+				      ETHTOOL_A_CABLE_TEST_NTF_HEADER);
+	if (err)
+		goto out;
+
+	err = nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_TEST_NTF_STATUS,
+			 ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED);
+	if (err)
+		goto out;
+
+	phydev->nest = nla_nest_start(phydev->skb,
+				      ETHTOOL_A_CABLE_TEST_NTF_NEST);
+	if (!phydev->nest)
+		goto out;
+
+	return 0;
+
+out:
+	nlmsg_free(phydev->skb);
+	return err;
+}
+EXPORT_SYMBOL_GPL(ethnl_cable_test_alloc);
+
+void ethnl_cable_test_free(struct phy_device *phydev)
+{
+	nlmsg_free(phydev->skb);
+}
+EXPORT_SYMBOL_GPL(ethnl_cable_test_free);
+
+void ethnl_cable_test_finished(struct phy_device *phydev)
+{
+	nla_nest_end(phydev->skb, phydev->nest);
+
+	genlmsg_end(phydev->skb, phydev->ehdr);
+
+	ethnl_multicast(phydev->skb, phydev->attached_dev);
+}
+EXPORT_SYMBOL_GPL(ethnl_cable_test_finished);
-- 
2.26.2

