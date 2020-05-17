Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA9A1D6CB7
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgEQT7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:59:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36274 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbgEQT7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 15:59:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/tHtcFb6RdN2o4GMXkqTHTvXTryyNXV+fr5nJ5zoi+4=; b=je9sEor6b5SKgXJQLvGcP5eXcF
        MMz1wQefsreFoaQZ3WLXU+vEaawTrmqLHmZPuL/WVNlprrWIYN53GCMaedIBf0bHQI4gN4hxtQsoH
        KujVrlD0A1BIV8TMsS6OwsWY26oC84CIIkHAlLd47Ik+9FuuSTQP/BcuoDidr+4erUiw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaPR9-002Yot-4A; Sun, 17 May 2020 21:59:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/7] net: ethtool: Add generic parts of cable test TDR
Date:   Sun, 17 May 2020 21:58:46 +0200
Message-Id: <20200517195851.610435-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200517195851.610435-1-andrew@lunn.ch>
References: <20200517195851.610435-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the generic parts of the code used to trigger a cable test and
return raw TDR data. Any PHY driver which support this must implement
the new driver op.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c           | 65 ++++++++++++++++++++++++++++++++-
 include/linux/ethtool_netlink.h |  4 +-
 include/linux/phy.h             | 13 +++++++
 net/ethtool/cabletest.c         | 65 ++++++++++++++++++++++++++++++---
 net/ethtool/netlink.c           |  5 +++
 net/ethtool/netlink.h           |  1 +
 6 files changed, 144 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d4bbf79dab6c..1f794c1716cf 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -519,7 +519,7 @@ int phy_start_cable_test(struct phy_device *phydev,
 		goto out;
 	}
 
-	err = ethnl_cable_test_alloc(phydev);
+	err = ethnl_cable_test_alloc(phydev, ETHTOOL_MSG_CABLE_TEST_NTF);
 	if (err)
 		goto out;
 
@@ -552,6 +552,69 @@ int phy_start_cable_test(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_start_cable_test);
 
+int phy_start_cable_test_tdr(struct phy_device *phydev,
+			     struct netlink_ext_ack *extack)
+{
+	struct net_device *dev = phydev->attached_dev;
+	int err = -ENOMEM;
+
+	if (!(phydev->drv &&
+	      phydev->drv->cable_test_tdr_start &&
+	      phydev->drv->cable_test_get_status)) {
+		NL_SET_ERR_MSG(extack,
+			       "PHY driver does not support cable test TDR");
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&phydev->lock);
+	if (phydev->state == PHY_CABLETEST) {
+		NL_SET_ERR_MSG(extack,
+			       "PHY already performing a test");
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (phydev->state < PHY_UP ||
+	    phydev->state > PHY_CABLETEST) {
+		NL_SET_ERR_MSG(extack,
+			       "PHY not configured. Try setting interface up");
+		err = -EBUSY;
+		goto out;
+	}
+
+	err = ethnl_cable_test_alloc(phydev, ETHTOOL_MSG_CABLE_TEST_TDR_NTF);
+	if (err)
+		goto out;
+
+	/* Mark the carrier down until the test is complete */
+	phy_link_down(phydev, true);
+
+	netif_testing_on(dev);
+	err = phydev->drv->cable_test_tdr_start(phydev);
+	if (err) {
+		netif_testing_off(dev);
+		phy_link_up(phydev);
+		goto out_free;
+	}
+
+	phydev->state = PHY_CABLETEST;
+
+	if (phy_polling_mode(phydev))
+		phy_trigger_machine(phydev);
+
+	mutex_unlock(&phydev->lock);
+
+	return 0;
+
+out_free:
+	ethnl_cable_test_free(phydev);
+out:
+	mutex_unlock(&phydev->lock);
+
+	return err;
+}
+EXPORT_SYMBOL(phy_start_cable_test_tdr);
+
 static int phy_config_aneg(struct phy_device *phydev)
 {
 	if (phydev->drv->config_aneg)
diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index e317fc99565e..24817ba252a0 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -17,13 +17,13 @@ enum ethtool_multicast_groups {
 struct phy_device;
 
 #if IS_ENABLED(CONFIG_ETHTOOL_NETLINK)
-int ethnl_cable_test_alloc(struct phy_device *phydev);
+int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd);
 void ethnl_cable_test_free(struct phy_device *phydev);
 void ethnl_cable_test_finished(struct phy_device *phydev);
 int ethnl_cable_test_result(struct phy_device *phydev, u8 pair, u8 result);
 int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm);
 #else
-static inline int ethnl_cable_test_alloc(struct phy_device *phydev)
+static inline int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5d8ff5428010..c35d45fe74ce 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -705,6 +705,10 @@ struct phy_driver {
 
 	/* Start a cable test */
 	int (*cable_test_start)(struct phy_device *dev);
+
+	/* Start a raw TDR cable test */
+	int (*cable_test_tdr_start)(struct phy_device *dev);
+
 	/* Once per second, or on interrupt, request the status of the
 	 * test.
 	 */
@@ -1255,6 +1259,8 @@ int phy_reset_after_clk_enable(struct phy_device *phydev);
 #if IS_ENABLED(CONFIG_PHYLIB)
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack);
+int phy_start_cable_test_tdr(struct phy_device *phydev,
+			     struct netlink_ext_ack *extack);
 #else
 static inline
 int phy_start_cable_test(struct phy_device *phydev,
@@ -1263,6 +1269,13 @@ int phy_start_cable_test(struct phy_device *phydev,
 	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
 	return -EOPNOTSUPP;
 }
+static inline
+int phy_start_cable_test_tdr(struct phy_device *phydev,
+			     struct netlink_ext_ack *extack)
+{
+	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
+	return -EOPNOTSUPP;
+}
 #endif
 
 int phy_cable_test_result(struct phy_device *phydev, u8 pair, u16 result);
diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index 5ba06eabe8c2..44dc4b8e26ac 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -13,7 +13,7 @@ cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
 	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
 };
 
-static int ethnl_cable_test_started(struct phy_device *phydev)
+static int ethnl_cable_test_started(struct phy_device *phydev, u8 cmd)
 {
 	struct sk_buff *skb;
 	int err = -ENOMEM;
@@ -23,7 +23,7 @@ static int ethnl_cable_test_started(struct phy_device *phydev)
 	if (!skb)
 		goto out;
 
-	ehdr = ethnl_bcastmsg_put(skb, ETHTOOL_MSG_CABLE_TEST_NTF);
+	ehdr = ethnl_bcastmsg_put(skb, cmd);
 	if (!ehdr) {
 		err = -EMSGSIZE;
 		goto out;
@@ -86,7 +86,8 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 	ethnl_ops_complete(dev);
 
 	if (!ret)
-		ethnl_cable_test_started(dev->phydev);
+		ethnl_cable_test_started(dev->phydev,
+					 ETHTOOL_MSG_CABLE_TEST_NTF);
 
 out_rtnl:
 	rtnl_unlock();
@@ -95,7 +96,7 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-int ethnl_cable_test_alloc(struct phy_device *phydev)
+int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd)
 {
 	int err = -ENOMEM;
 
@@ -103,8 +104,7 @@ int ethnl_cable_test_alloc(struct phy_device *phydev)
 	if (!phydev->skb)
 		goto out;
 
-	phydev->ehdr = ethnl_bcastmsg_put(phydev->skb,
-					  ETHTOOL_MSG_CABLE_TEST_NTF);
+	phydev->ehdr = ethnl_bcastmsg_put(phydev->skb, cmd);
 	if (!phydev->ehdr) {
 		err = -EMSGSIZE;
 		goto out;
@@ -199,3 +199,56 @@ int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ethnl_cable_test_fault_length);
+
+static const struct nla_policy
+cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1] = {
+	[ETHTOOL_A_CABLE_TEST_TDR_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_CABLE_TEST_TDR_HEADER]	= { .type = NLA_NESTED },
+};
+
+int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1];
+	struct ethnl_req_info req_info = {};
+	struct net_device *dev;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_CABLE_TEST_TDR_MAX,
+			  cable_test_tdr_act_policy, info->extack);
+	if (ret < 0)
+		return ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_CABLE_TEST_TDR_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+
+	dev = req_info.dev;
+	if (!dev->phydev) {
+		ret = -EOPNOTSUPP;
+		goto out_dev_put;
+	}
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = phy_start_cable_test_tdr(dev->phydev, info->extack);
+
+	ethnl_ops_complete(dev);
+
+	if (!ret)
+		ethnl_cable_test_started(dev->phydev,
+					 ETHTOOL_MSG_CABLE_TEST_TDR_NTF);
+
+out_rtnl:
+	rtnl_unlock();
+out_dev_put:
+	dev_put(dev);
+	return ret;
+}
+
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 87bc02da74bc..b236b0d6cccf 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -844,6 +844,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_act_cable_test,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_act_cable_test_tdr,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index b0eb5d920099..9a96b6e90dc2 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -360,5 +360,6 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info);
+int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.26.2

