Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B8942BC2
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440143AbfFLQGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:06:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49276 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437056AbfFLQGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:06:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8u+J8RQjpmXeN5BHvZQ6jGvBn4wSapbm2ApCOe6KNU0=; b=mhAO7wpxfq2d9zIlZ6q8MkVksj
        o6ClfrKUn4ZQMSnP0eFofws4BblBZ4ScSs+lDI7tIooapOgilVc6Yyd8VVDYyyU6yh99AeX42sixt
        JYhDY7uYkD8WLnlgPwyYLzI6+GKacV59JP2Oo+CyFWtlAUxM8ZUEqMvsV/9HYvm3tpAg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lD-00068j-4G; Wed, 12 Jun 2019 18:06:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 06/13] net: phy: Add infrastructure for reporting cable test results
Date:   Wed, 12 Jun 2019 18:05:27 +0200
Message-Id: <20190612160534.23533-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide infrastrucutre for PHY drivers to report the cable test
results.  A netlink skb is associated to the phydev. Helpers will be
added which can add results to this skb. Once the test has finished
the results are sent to user space.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 44 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/phy.h   |  5 +++++
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index dbd4484f04be..db8a5957acdd 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
+#include <linux/ethtool_netlink.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
 #include <linux/workqueue.h>
@@ -29,6 +30,9 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
+#include <net/netlink.h>
+#include <net/genetlink.h>
+#include <net/sock.h>
 
 #define PHY_STATE_STR(_state)			\
 	case PHY_##_state:			\
@@ -467,15 +471,25 @@ static void phy_trigger_machine(struct phy_device *phydev)
 	phy_queue_state_machine(phydev, 0);
 }
 
+static void phy_cable_test_finished(struct phy_device *phydev)
+{
+	nla_nest_end(phydev->skb, phydev->nest);
+	genlmsg_end(phydev->skb, phydev->ehdr);
+
+	ethnl_multicast(phydev->skb, phydev->attached_dev);
+}
+
 static void phy_cable_test_abort(struct phy_device *phydev)
 {
+	phy_cable_test_finished(phydev);
 	genphy_soft_reset(phydev);
 }
 
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack)
 {
-	int err;
+	int err = -ENOMEM;
+	int ret;
 
 	if (!(phydev->drv &&
 	      phydev->drv->cable_test_start &&
@@ -494,19 +508,44 @@ int phy_start_cable_test(struct phy_device *phydev,
 		goto out;
 	}
 
+	phydev->skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!phydev->skb)
+		goto out;
+
+	phydev->ehdr = ethnl_bcastmsg_put(phydev->skb, ETHNL_CMD_EVENT);
+	if (!phydev->ehdr)
+		goto out_free;
+
+	phydev->nest = ethnl_nest_start(phydev->skb,
+					ETHTOOL_A_EVENT_CABLE_TEST);
+	if (!phydev->nest)
+		goto out_free;
+
+	ret = ethnl_fill_dev(phydev->skb, phydev->attached_dev,
+			     ETHTOOL_A_CABLE_TEST_DEV);
+	if (ret < 0)
+		goto out_free;
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
+	nlmsg_free(phydev->skb);
 out:
 	mutex_unlock(&phydev->lock);
 
@@ -977,6 +1016,7 @@ void phy_state_machine(struct work_struct *work)
 		}
 
 		if (finished) {
+			phy_cable_test_finished(phydev);
 			needs_aneg = true;
 			phydev->state = PHY_UP;
 		}
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0dc6adc73a01..da8cc97b55dc 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -450,6 +450,11 @@ struct phy_device {
 	/* For use by PHYs to maintain extra state */
 	void *priv;
 
+	/* Reporting cable test results */
+	struct sk_buff *skb;
+	void *ehdr;
+	struct nlattr *nest;
+
 	/* Interrupt and Polling infrastructure */
 	struct delayed_work state_queue;
 
-- 
2.20.1

