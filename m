Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5331CC29B
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgEIQ3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:29:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50914 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728171AbgEIQ3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 12:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZSKP1heR1R0U8WVToOoSmtsMUCQWYClBAlZQhdp3s14=; b=s3vArVDvt4ohy8wtS9qrJ8dOFL
        PPDRqJLoXecqCd8Tzftd36ZeIoIAHFrB5t6pyn6feMltort54SqwgLeBfc2a0pye6pa4K/nBB23WX
        xoeO/+nVGqiFFCP+SBBROl6shPSe8m0TvxFriBwn7dbsmJ5E/8CizWgV5imaschTAQQI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXSLc-001WHa-65; Sat, 09 May 2020 18:29:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 07/10] net: ethtool: Add helpers for reporting test results
Date:   Sat,  9 May 2020 18:28:48 +0200
Message-Id: <20200509162851.362346-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509162851.362346-1-andrew@lunn.ch>
References: <20200509162851.362346-1-andrew@lunn.ch>
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

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/ethtool_netlink.h | 13 ++++++++
 include/linux/phy.h             |  4 +++
 net/ethtool/cabletest.c         | 55 +++++++++++++++++++++++++++++++--
 3 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 7d763ba22f6f..c7db23eebb75 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -20,6 +20,8 @@ struct phy_device;
 int ethnl_cable_test_alloc(struct phy_device *phydev);
 void ethnl_cable_test_free(struct phy_device *phydev);
 void ethnl_cable_test_finished(struct phy_device *phydev);
+int ethnl_cable_test_result(struct phy_device *phydev, u8 pair, u8 result);
+int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm);
 #else
 static inline int ethnl_cable_test_alloc(struct phy_device *phydev)
 {
@@ -33,5 +35,16 @@ static inline void ethnl_cable_test_free(struct phy_device *phydev)
 static inline void ethnl_cable_test_finished(struct phy_device *phydev)
 {
 }
+static inline int ethnl_cable_test_result(struct phy_device *phydev, u8 pair,
+					  u8 result)
+{
+	return -ENOTSUPP;
+}
+
+static inline int ethnl_cable_test_fault_length(struct phy_device *phydev,
+						u8 pair, u32 cm)
+{
+	return -ENOTSUPP;
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
index bed6c67ea933..e0c917918c70 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -65,7 +65,7 @@ int ethnl_cable_test_alloc(struct phy_device *phydev)
 	phydev->ehdr = ethnl_bcastmsg_put(phydev->skb,
 					  ETHTOOL_MSG_CABLE_TEST_NTF);
 	if (!phydev->ehdr) {
-		err = -EINVAL;
+		err = -EMSGSIZE;
 		goto out;
 	}
 
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

