Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917F91D6CBA
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgEQT7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:59:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36330 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgEQT7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 15:59:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dScCHfJPbvF8oZ24uB/Dgw6Rg8h6+kKYjG2yKndR0wQ=; b=EJaXIcNfe+HvVQdRICvfgl5HE3
        WHLXphETj44YGtldmizWP50+2oK9mTM3oT41U503LcGw83SLEnVVMJPDRWyZeRg/KHmeEtM4HObf1
        noSyz11XjKNtnPTgpoJxNm35iIecFkIMY/YfV11IG3vbeSjlWOeAZ4jA5wIRMNAY79fE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaPR9-002Yp3-6I; Sun, 17 May 2020 21:59:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 3/7] net: ethtool: Add helpers for cable test TDR data
Date:   Sun, 17 May 2020 21:58:47 +0200
Message-Id: <20200517195851.610435-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200517195851.610435-1-andrew@lunn.ch>
References: <20200517195851.610435-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers for returning raw TDR helpers in netlink messages.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/ethtool_netlink.h | 21 +++++++++
 net/ethtool/cabletest.c         | 79 ++++++++++++++++++++++++++++++++-
 2 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 24817ba252a0..8fbe4f97ffad 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -22,6 +22,10 @@ void ethnl_cable_test_free(struct phy_device *phydev);
 void ethnl_cable_test_finished(struct phy_device *phydev);
 int ethnl_cable_test_result(struct phy_device *phydev, u8 pair, u8 result);
 int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm);
+int ethnl_cable_test_amplitude(struct phy_device *phydev, u8 pair, s16 mV);
+int ethnl_cable_test_pulse(struct phy_device *phydev, u16 mV);
+int ethnl_cable_test_step(struct phy_device *phydev, u32 first, u32 last,
+			  u32 step);
 #else
 static inline int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd)
 {
@@ -46,5 +50,22 @@ static inline int ethnl_cable_test_fault_length(struct phy_device *phydev,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int ethnl_cable_test_amplitude(struct phy_device *phydev,
+					     u8 pair, s16 mV)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ethnl_cable_test_pulse(struct phy_device *phydev, u16 mV)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ethnl_cable_test_step(struct phy_device *phydev, u32 first,
+					u32 last, u32 step)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* IS_ENABLED(ETHTOOL_NETLINK) */
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index 44dc4b8e26ac..c02575e26336 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -100,7 +100,10 @@ int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd)
 {
 	int err = -ENOMEM;
 
-	phydev->skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	/* One TDR sample occupies 20 bytes. For a 150 meter cable,
+	 * with four pairs, around 12K is needed.
+	 */
+	phydev->skb = genlmsg_new(SZ_16K, GFP_KERNEL);
 	if (!phydev->skb)
 		goto out;
 
@@ -252,3 +255,77 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
+int ethnl_cable_test_amplitude(struct phy_device *phydev,
+			       u8 pair, s16 mV)
+{
+	struct nlattr *nest;
+	int ret = -EMSGSIZE;
+
+	nest = nla_nest_start(phydev->skb,
+			      ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE);
+	if (!nest)
+		return -EMSGSIZE;
+
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
+EXPORT_SYMBOL_GPL(ethnl_cable_test_amplitude);
+
+int ethnl_cable_test_pulse(struct phy_device *phydev, u16 mV)
+{
+	struct nlattr *nest;
+	int ret = -EMSGSIZE;
+
+	nest = nla_nest_start(phydev->skb, ETHTOOL_A_CABLE_TDR_NEST_PULSE);
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
+EXPORT_SYMBOL_GPL(ethnl_cable_test_pulse);
+
+int ethnl_cable_test_step(struct phy_device *phydev, u32 first, u32 last,
+			  u32 step)
+{
+	struct nlattr *nest;
+	int ret = -EMSGSIZE;
+
+	nest = nla_nest_start(phydev->skb, ETHTOOL_A_CABLE_TDR_NEST_STEP);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(phydev->skb, ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE,
+			first))
+		goto err;
+
+	if (nla_put_u32(phydev->skb, ETHTOOL_A_CABLE_STEP_LAST_DISTANCE, last))
+		goto err;
+
+	if (nla_put_u32(phydev->skb, ETHTOOL_A_CABLE_STEP_STEP_DISTANCE, step))
+		goto err;
+
+	nla_nest_end(phydev->skb, nest);
+	return 0;
+
+err:
+	nla_nest_cancel(phydev->skb, nest);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ethnl_cable_test_step);
-- 
2.26.2

