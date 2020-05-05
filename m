Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBC51C4AF1
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgEEASq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:18:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41276 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbgEEASn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 20:18:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bfNKjJWlaled4Ss3zCwwy8GfHI11+f2ul0ZnQA3aspw=; b=K8Z+V2h0iSxkbsg7KXJPOpkaVH
        XhCgRKemPkuRE8Fwp2FBQFo8+upBdrWtmqQm0P/LEvydazKmU4czqfzkYCZKefZq+O1nMK48JGv5F
        e9Wz/YbRoPmFBkun0VXy7lfTjXbx18cQgv1jnFlePkXJsIWiyC/xJmv1DuN+Z5vqhgP4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVlID-000sGi-Ij; Tue, 05 May 2020 02:18:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 07/10] net: ethtool: Add helpers for reporting test results
Date:   Tue,  5 May 2020 02:18:18 +0200
Message-Id: <20200505001821.208534-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200505001821.208534-1-andrew@lunn.ch>
References: <20200505001821.208534-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY drivers can use these helpers for reporting the results. The
results get translated into netlink attributes which are added to the
pre-allocated skbuf.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/ethtool_netlink.h | 13 +++++++++
 include/linux/phy.h             |  4 +++
 net/ethtool/cabletest.c         | 47 +++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 7d763ba22f6f..0d12abbdf3c3 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -20,6 +20,8 @@ struct phy_device;
 int ethnl_cable_test_alloc(struct phy_device *phydev);
 void ethnl_cable_test_free(struct phy_device *phydev);
 void ethnl_cable_test_finished(struct phy_device *phydev);
+int ethnl_cable_test_result(struct phy_device *phydev, u8 pair, u16 result);
+int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm);
 #else
 static inline int ethnl_cable_test_alloc(struct phy_device *phydev)
 {
@@ -33,5 +35,16 @@ static inline void ethnl_cable_test_free(struct phy_device *phydev)
 static inline void ethnl_cable_test_finished(struct phy_device *phydev)
 {
 }
+static inline int ethnl_cable_test_result(struct phy_device *phydev, u8 pair,
+					  u16 result)
+{
+	return -ENOTSUPP;
+}
+
+static inline int ethnl_cable_test_fault_length(struct phy_device *phydev,
+						u8 pair, u16 cm)
+{
+	return -ENOTSUPP;
+}
 #endif /* IS_ENABLED(ETHTOOL_NETLINK) */
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index ee69f781995a..856b4293a645 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1229,6 +1229,10 @@ int phy_start_cable_test(struct phy_device *phydev,
 }
 #endif
 
+int phy_cable_test_result(struct phy_device *phydev, u8 pair, u16 result);
+int phy_cable_test_fault_length(struct phy_device *phydev, u8 pair,
+				u16 cm);
+
 static inline void phy_device_reset(struct phy_device *phydev, int value)
 {
 	mdio_device_reset(&phydev->mdio, value);
diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index 4c888db33ef0..f500454a54eb 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -114,3 +114,50 @@ void ethnl_cable_test_finished(struct phy_device *phydev)
 	ethnl_multicast(phydev->skb, phydev->attached_dev);
 }
 EXPORT_SYMBOL_GPL(ethnl_cable_test_finished);
+
+int ethnl_cable_test_result(struct phy_device *phydev, u8 pair, u16 result)
+{
+	struct nlattr *nest;
+	int ret = -EMSGSIZE;
+
+	nest = nla_nest_start(phydev->skb, ETHTOOL_A_CABLE_TEST_NTF_RESULT);
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
+EXPORT_SYMBOL_GPL(ethnl_cable_test_result);
+
+int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm)
+{
+	struct nlattr *nest;
+	int ret = -EMSGSIZE;
+
+	nest = nla_nest_start(phydev->skb,
+			      ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH);
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
+EXPORT_SYMBOL_GPL(ethnl_cable_test_fault_length);
-- 
2.26.2

