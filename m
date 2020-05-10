Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744C21CCD37
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 21:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgEJTNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 15:13:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729254AbgEJTM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 15:12:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PBj/fJnWlERfIMy+9kS2YP2Zub3zLQBtC2dNQDGe8Vs=; b=42PKWZs4MuezckP7SeDthhFbhd
        E/LzXsRgRJrHdcX60TzA/CMUY+RzfCmgHhA0Ol630c0D4mpAwXK4gQGID74zqaIKVy5ls3dBdhYUA
        VM4EcuuJ3xsKZEvTBVrSJAhSanYvyJT1gGSdUuiO+OVIlVupwtVtld53QCYQV0i7UXLo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXrNc-001jdy-N4; Sun, 10 May 2020 21:12:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 07/10] net: ethtool: Add helpers for reporting test results
Date:   Sun, 10 May 2020 21:12:37 +0200
Message-Id: <20200510191240.413699-9-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200510191240.413699-1-andrew@lunn.ch>
References: <20200510191240.413699-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY drivers can use these helpers for reporting the results. The
results get translated into netlink attributes which are added to the
pre-allocated skbuf.

v3:
Poison phydev->skb
Return -EMSGSIZE when ethnl_bcastmsg_put() fails
Return valid error code when nla_nest_start() fails
Use u8 for results
Actually put u32 length into message

v4:
s/ENOTSUPP/EOPNOTSUPP/g

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/linux/ethtool_netlink.h | 15 +++++++++-
 include/linux/phy.h             |  4 +++
 net/ethtool/cabletest.c         | 53 ++++++++++++++++++++++++++++++++-
 3 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 7d763ba22f6f..e317fc99565e 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -20,10 +20,12 @@ struct phy_device;
 int ethnl_cable_test_alloc(struct phy_device *phydev);
 void ethnl_cable_test_free(struct phy_device *phydev);
 void ethnl_cable_test_finished(struct phy_device *phydev);
+int ethnl_cable_test_result(struct phy_device *phydev, u8 pair, u8 result);
+int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm);
 #else
 static inline int ethnl_cable_test_alloc(struct phy_device *phydev)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 static inline void ethnl_cable_test_free(struct phy_device *phydev)
@@ -33,5 +35,16 @@ static inline void ethnl_cable_test_free(struct phy_device *phydev)
 static inline void ethnl_cable_test_finished(struct phy_device *phydev)
 {
 }
+static inline int ethnl_cable_test_result(struct phy_device *phydev, u8 pair,
+					  u8 result)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ethnl_cable_test_fault_length(struct phy_device *phydev,
+						u8 pair, u32 cm)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* IS_ENABLED(ETHTOOL_NETLINK) */
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 169fae4249a9..5d8ff5428010 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1265,6 +1265,10 @@ int phy_start_cable_test(struct phy_device *phydev,
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
index ae8e63647663..e0c917918c70 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -81,13 +81,16 @@ int ethnl_cable_test_alloc(struct phy_device *phydev)
 
 	phydev->nest = nla_nest_start(phydev->skb,
 				      ETHTOOL_A_CABLE_TEST_NTF_NEST);
-	if (!phydev->nest)
+	if (!phydev->nest) {
+		err = -EMSGSIZE;
 		goto out;
+	}
 
 	return 0;
 
 out:
 	nlmsg_free(phydev->skb);
+	phydev->skb = NULL;
 	return err;
 }
 EXPORT_SYMBOL_GPL(ethnl_cable_test_alloc);
@@ -95,6 +98,7 @@ EXPORT_SYMBOL_GPL(ethnl_cable_test_alloc);
 void ethnl_cable_test_free(struct phy_device *phydev)
 {
 	nlmsg_free(phydev->skb);
+	phydev->skb = NULL;
 }
 EXPORT_SYMBOL_GPL(ethnl_cable_test_free);
 
@@ -107,3 +111,50 @@ void ethnl_cable_test_finished(struct phy_device *phydev)
 	ethnl_multicast(phydev->skb, phydev->attached_dev);
 }
 EXPORT_SYMBOL_GPL(ethnl_cable_test_finished);
+
+int ethnl_cable_test_result(struct phy_device *phydev, u8 pair, u8 result)
+{
+	struct nlattr *nest;
+	int ret = -EMSGSIZE;
+
+	nest = nla_nest_start(phydev->skb, ETHTOOL_A_CABLE_NEST_RESULT);
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
+			      ETHTOOL_A_CABLE_NEST_FAULT_LENGTH);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR, pair))
+		goto err;
+	if (nla_put_u32(phydev->skb, ETHTOOL_A_CABLE_FAULT_LENGTH_CM, cm))
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

