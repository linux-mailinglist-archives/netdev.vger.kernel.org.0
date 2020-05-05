Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4E81C4AF7
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgEEATB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:19:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbgEEATB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 20:19:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Cs7gXRieqA/hKSrbcwQ6bI1VZ2XfhrWkA6NiAbRUtOY=; b=VOYPltANrkC8gNgSMrhLy2Q4PN
        muhN9gKnrMPGZva68qyJ1/GTReoRvQEf19Y4Y+nbfJbxHhS+le/PLJbYoMcZfVSzHJbeWtWaNJrEr
        yqZ/o0NlHKMBkb5DUjrmF5NXJXDcWpSTd+D+PTstnTmaoRlkgzebMu6WTpZ03+6O9AFU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVlID-000sGx-Lz; Tue, 05 May 2020 02:18:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 10/10] net: phy: Send notifier when starting the cable test
Date:   Tue,  5 May 2020 02:18:21 +0200
Message-Id: <20200505001821.208534-11-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200505001821.208534-1-andrew@lunn.ch>
References: <20200505001821.208534-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that it takes time to run a cable test, send a notify message at
the start, as well as when it is completed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/cabletest.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index f500454a54eb..e59f570494c0 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -20,6 +20,41 @@ cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
 	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
 };
 
+static int ethnl_cable_test_started(struct phy_device *phydev)
+{
+	struct sk_buff *skb;
+	int err = -ENOMEM;
+	void *ehdr;
+
+	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb)
+		goto out;
+
+	ehdr = ethnl_bcastmsg_put(skb, ETHTOOL_MSG_CABLE_TEST_NTF);
+	if (!ehdr) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = ethnl_fill_reply_header(skb, phydev->attached_dev,
+				      ETHTOOL_A_CABLE_TEST_NTF_HEADER);
+	if (err)
+		goto out;
+
+	err = nla_put_u8(skb, ETHTOOL_A_CABLE_TEST_NTF_STATUS,
+			 ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED);
+	if (err)
+		goto out;
+
+	genlmsg_end(skb, ehdr);
+
+	return ethnl_multicast(skb, phydev->attached_dev);
+
+out:
+	nlmsg_free(skb);
+	return err;
+}
+
 int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_MAX + 1];
@@ -54,6 +89,10 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 	ret = phy_start_cable_test(dev->phydev, info->extack);
 
 	ethnl_ops_complete(dev);
+
+	if (!ret)
+		ethnl_cable_test_started(dev->phydev);
+
 out_rtnl:
 	rtnl_unlock();
 out_dev_put:
-- 
2.26.2

