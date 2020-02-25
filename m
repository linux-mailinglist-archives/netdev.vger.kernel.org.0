Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2851416F2F2
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 00:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgBYXIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 18:08:55 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:36999 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728806AbgBYXIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 18:08:55 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 501A22304C;
        Wed, 26 Feb 2020 00:08:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582672133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lu9/4txrqSbNm1WLkzOFGzQzJ4skJABQr2+n6FdHMgQ=;
        b=qBqQtyvDMbuQT+9D7uL71AfMzBul8U6m8h45VHhFjmOUlViFlhUL7RMUPqyjGNFWJ4axOj
        kvD6SOKQvmE0gdhmBXp3ihkpWGHjOD3ZFR4BKI5ztQFZ5m1rrO+U2sPBJKzQv25kCTVXBk
        qBw9bToymiPhYrYZ48zNXUmmJr/7JEQ=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [RFC PATCH 1/2] net: phy: let the driver register its own IRQ handler
Date:   Wed, 26 Feb 2020 00:08:18 +0100
Message-Id: <20200225230819.7325-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225230819.7325-1-michael@walle.cc>
References: <20200225230819.7325-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 501A22304C
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.962];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[9];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c::/31, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are more and more PHY drivers which has more than just the PHY
link change interrupts. For example, temperature thresholds or PTP
interrupts.

At the moment it is not possible to correctly handle interrupts for PHYs
which has a clear-on-read interrupt status register. It is also likely
that the current approach of the phylib isn't working for all PHYs out
there.

Therefore, this patch let the PHY driver register its own interrupt
handler. To notify the phylib about a link change, the interrupt handler
has to call the new function phy_drv_interrupt().

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/phy.c        | 15 +++++++++++++++
 drivers/net/phy/phy_device.c |  6 ++++--
 include/linux/phy.h          |  2 ++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d76e038cf2cb..f25aacbcf1d9 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -942,6 +942,21 @@ void phy_mac_interrupt(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_mac_interrupt);
 
+/**
+ * phy_drv_interrupt - PHY drivers says the link has changed
+ * @phydev: phy_device struct with changed link
+ *
+ * The PHY driver may implement his own interrupt handler. It will call this
+ * function to notify us about a link change. Trigger the state machine and
+ * work a work queue.
+ */
+void phy_drv_interrupt(struct phy_device *phydev)
+{
+	/* Trigger a state machine change */
+	phy_trigger_machine(phydev);
+}
+EXPORT_SYMBOL(phy_drv_interrupt);
+
 static void mmd_eee_adv_to_linkmode(unsigned long *advertising, u16 eee_adv)
 {
 	linkmode_zero(advertising);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6a5056e0ae77..6d8c94e61251 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -965,7 +965,8 @@ int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
 		return rc;
 
 	phy_prepare_link(phydev, handler);
-	if (phy_interrupt_is_valid(phydev))
+	if (phy_interrupt_is_valid(phydev) &&
+	    phydev->drv->flags & PHY_HAS_OWN_IRQ_HANDLER)
 		phy_request_interrupt(phydev);
 
 	return 0;
@@ -2411,7 +2412,8 @@ EXPORT_SYMBOL(phy_validate_pause);
 
 static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 {
-	return phydrv->config_intr && phydrv->ack_interrupt;
+	return ((phydrv->config_intr && phydrv->ack_interrupt) ||
+		phydrv->flags & PHY_HAS_OWN_IRQ_HANDLER);
 }
 
 /**
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c570e162e05e..46f73b94fd60 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -75,6 +75,7 @@ extern const int phy_10gbit_features_array[1];
 
 #define PHY_IS_INTERNAL		0x00000001
 #define PHY_RST_AFTER_CLK_EN	0x00000002
+#define PHY_HAS_OWN_IRQ_HANDLER	0x00000004
 #define MDIO_DEVICE_IS_PHY	0x80000000
 
 /* Interface Mode definitions */
@@ -1235,6 +1236,7 @@ int phy_drivers_register(struct phy_driver *new_driver, int n,
 void phy_state_machine(struct work_struct *work);
 void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies);
 void phy_mac_interrupt(struct phy_device *phydev);
+void phy_drv_interrupt(struct phy_device *phydev);
 void phy_start_machine(struct phy_device *phydev);
 void phy_stop_machine(struct phy_device *phydev);
 void phy_ethtool_ksettings_get(struct phy_device *phydev,
-- 
2.20.1

