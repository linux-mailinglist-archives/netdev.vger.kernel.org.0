Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C52E42BCE
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406804AbfFLQHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:07:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406284AbfFLQHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=t7aqvT8sSfePHXMJJf/rrVUS+Lgv4sV/KBzceNahJjA=; b=gnBNhx2Pylp5Oyt+cg+Fs1qpvp
        l94RefdBx6Z9VbtnF08PqqUPkd8GrWcV8ANvNNA9mZfqb/w/3OZpcLsmlQNXozIEknn0CvCF6jFt4
        ZMWl+p3gtfBxvPklX07G65J2bcVUJj0annmwXdBnYY4tyF6cspZtlQJL0GJQyybuXnGw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lD-000698-CN; Wed, 12 Jun 2019 18:06:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 11/13] net: phy: Add helpers and attributes for amplitude graph
Date:   Wed, 12 Jun 2019 18:05:32 +0200
Message-Id: <20190612160534.23533-12-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The amplitude graph needs to return the measured amplitude of the
reflected signal for each pair. Add a helper to store such a
measurement into the results skbuf. The size of the transmitted pulse
affects the size of the measured pulse. So add a helper to report the
pulse size.

For a 100m cable, and measurements at one meter interval, the default
size netlink skbuf is too small. Change to 8K.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c                | 51 +++++++++++++++++++++++++++-
 include/linux/phy.h                  |  4 +++
 include/uapi/linux/ethtool_netlink.h | 20 +++++++++++
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 38a766fc0923..9a210927aec0 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -532,6 +532,55 @@ int phy_cable_test_fault_length(struct phy_device *phydev, u8 pair, u16 cm)
 }
 EXPORT_SYMBOL_GPL(phy_cable_test_fault_length);
 
+int phy_cable_test_amplitude(struct phy_device *phydev,
+			     int distance, u8 pair, int mV)
+{
+	struct nlattr *nest;
+	int ret = -EMSGSIZE;
+
+	nest = ethnl_nest_start(phydev->skb,
+				ETHTOOL_A_CABLE_TEST_EVENT_AMPLITUDE);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u16(phydev->skb, ETHTOOL_A_CABLE_AMPLITUDE_DISTANCE,
+			distance))
+		goto err;
+	if (nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_AMPLITUDE_PAIR, pair))
+		goto err;
+	if (nla_put_u16(phydev->skb, ETHTOOL_A_CABLE_AMPLITUDE_mV, mV))
+		goto err;
+
+	nla_nest_end(phydev->skb, nest);
+	return 0;
+
+err:
+	nla_nest_cancel(phydev->skb, nest);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_cable_test_amplitude);
+
+int phy_cable_test_pulse(struct phy_device *phydev, int mV)
+{
+	struct nlattr *nest;
+	int ret = -EMSGSIZE;
+
+	nest = ethnl_nest_start(phydev->skb, ETHTOOL_A_CABLE_TEST_EVENT_PULSE);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u16(phydev->skb, ETHTOOL_A_CABLE_PULSE_mV, mV))
+		goto err;
+
+	nla_nest_end(phydev->skb, nest);
+	return 0;
+
+err:
+	nla_nest_cancel(phydev->skb, nest);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_cable_test_pulse);
+
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack, u32 seq,
 			 int options)
@@ -556,7 +605,7 @@ int phy_start_cable_test(struct phy_device *phydev,
 		goto out;
 	}
 
-	phydev->skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	phydev->skb = genlmsg_new(8192, GFP_KERNEL);
 	if (!phydev->skb)
 		goto out;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2ef7dc37ea44..3c5f0c7b8847 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1093,6 +1093,10 @@ int phy_start_cable_test(struct phy_device *phydev,
 int phy_cable_test_result(struct phy_device *phydev, u8 pair, u16 result);
 int phy_cable_test_fault_length(struct phy_device *phydev, u8 pair,
 				u16 cm);
+int phy_cable_test_amplitude(struct phy_device *phydev, int distance, u8 pair,
+			     int mV);
+int phy_cable_test_pulse(struct phy_device *phydev, int mV);
+
 #define PHY_CABLE_TEST_AMPLITUDE_GRAPH BIT(0)
 
 static inline void phy_device_reset(struct phy_device *phydev, int value)
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 841f23ca2306..613638a423cd 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -550,11 +550,31 @@ enum {
 	ETHTOOL_A_CABLE_LENGTH_MAX = (__ETHTOOL_A_CABLE_LENGTH_CNT - 1)
 };
 
+enum {
+	ETHTOOL_A_CABLE_AMPLITUDE_UNSPEC,
+	ETHTOOL_A_CABLE_AMPLITUDE_DISTANCE,	/* u16 */
+	ETHTOOL_A_CABLE_AMPLITUDE_PAIR,		/* u8 */
+	ETHTOOL_A_CABLE_AMPLITUDE_mV,		/* s16 */
+
+	__ETHTOOL_A_CABLE_AMPLITUDE_CNT,
+	ETHTOOL_A_CABLE_AMPLITUDE_MAX = (__ETHTOOL_A_CABLE_AMPLITUDE_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_PULSE_UNSPEC,
+	ETHTOOL_A_CABLE_PULSE_mV,		/* s16 */
+
+	__ETHTOOL_A_CABLE_PULSE_CNT,
+	ETHTOOL_A_CABLE_PULSE_MAX = (__ETHTOOL_A_CABLE_PULSE_CNT - 1)
+};
+
 enum {
 	ETHTOOL_A_CABLE_TEST_EVENT_UNSPEC,
 	ETHTOOL_A_CABLE_TEST_EVENT_DEV,		/* nest - ETHTOOL_A_DEV_* */
 	ETHTOOL_A_CABLE_TEST_EVENT_RESULT,	/* nest - ETHTOOL_A_CABLE_RESULT_ */
 	ETHTOOL_A_CABLE_TEST_EVENT_FAULT_LENGTH,/* nest - ETHTOOL_A_CABLE_FAULT_LENGTH_ */
+	ETHTOOL_A_CABLE_TEST_EVENT_AMPLITUDE,	/* next - ETHTOOL_A_CABLE_AMPLITUDE_ */
+	ETHTOOL_A_CABLE_TEST_EVENT_PULSE,	/* next - ETHTOOL_A_CABLE_PULSE_ */
 
 	__ETHTOOL_A_CABLE_TEST_EVENT_CNT,
 	ETHTOOL_A_CABLE_TEST_EVENT_MAX = (__ETHTOOL_A_CABLE_TEST_EVENT_CNT - 1)
-- 
2.20.1

