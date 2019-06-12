Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2187342BC0
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438123AbfFLQGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:06:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49252 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729970AbfFLQGF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:06:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FdIzabBmTkzS+35pYJja1FVeJXv6RSkiZubJ1yFKbqI=; b=lc5DqCY2vA/YjGvkelJgWdp6eq
        ChwTTKq7k/3ACoj08wrbnFzgB9UhmTfXcDGn0OAWpW8BlmBocig3OfXnJXq4ZrdUEZQOQbZlXLTO4
        LFInt8z5/6OYCAhit8nRV+Q//4VB8RqdgZ1f/aF3qxCDnlfAxmpqORmJPqswT+0fGvCk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lD-00068t-6c; Wed, 12 Jun 2019 18:06:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 08/13] net: phy: Add helpers for reporting test results
Date:   Wed, 12 Jun 2019 18:05:29 +0200
Message-Id: <20190612160534.23533-9-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY drivers can use these helpers for reporting the results. The
results get translated into netlink attributes which are added to the
pre-allocated skbuf.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 47 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h   |  4 ++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 3c614639ce20..6540523d773a 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -485,6 +485,53 @@ static void phy_cable_test_abort(struct phy_device *phydev)
 	genphy_soft_reset(phydev);
 }
 
+int phy_cable_test_result(struct phy_device *phydev, u8 pair, u16 result)
+{
+	struct nlattr *nest;
+	int ret = -EMSGSIZE;
+
+	nest = ethnl_nest_start(phydev->skb, ETHTOOL_A_CABLE_TEST_EVENT_RESULT);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_RESULT_PAIR, pair))
+		goto err;
+	if (nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_RESULT_CODE, result))
+		goto err;
+
+	nla_nest_end(phydev->skb, nest);
+	return 0;
+
+err:
+	nla_nest_cancel(phydev->skb, nest);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_cable_test_result);
+
+int phy_cable_test_fault_length(struct phy_device *phydev, u8 pair, u16 cm)
+{
+	struct nlattr *nest;
+	int ret = -EMSGSIZE;
+
+	nest = ethnl_nest_start(phydev->skb,
+				ETHTOOL_A_CABLE_TEST_EVENT_FAULT_LENGTH);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR, pair))
+		goto err;
+	if (nla_put_u16(phydev->skb, ETHTOOL_A_CABLE_FAULT_LENGTH_CM, cm))
+		goto err;
+
+	nla_nest_end(phydev->skb, nest);
+	return 0;
+
+err:
+	nla_nest_cancel(phydev->skb, nest);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_cable_test_fault_length);
+
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack, u32 seq)
 {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index cea151c66ac1..23c18583ea07 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1090,6 +1090,10 @@ int phy_start_cable_test(struct phy_device *phydev,
 }
 #endif
 
+int phy_cable_test_result(struct phy_device *phydev, u8 pair, u16 result);
+int phy_cable_test_fault_length(struct phy_device *phydev, u8 pair,
+				u16 cm);
+
 static inline void phy_device_reset(struct phy_device *phydev, int value)
 {
 	mdio_device_reset(&phydev->mdio, value);
-- 
2.20.1

