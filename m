Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E171CC2A4
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgEIQ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:29:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51024 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbgEIQ3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 12:29:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=prwp1QHavwGn4GpYdVuRfwBvuB9obaHQJaG752mW9TU=; b=c7LQdneVMbY7otGjJqohUUhixH
        Jv+43gFRiSAHGsKXKXMiD9NLnY/SepWQe75mZS1/5O7UazDATqhazRF9ddSTGXUmdg3AweeDjnHWE
        dT+HP7ksou1KhwYQ0IclB3Q4XCKhvT500GOlO+ftM4p522/R1pQ2WYro/uRhb7g9nOuU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXSLc-001WHp-91; Sat, 09 May 2020 18:29:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 10/10] net: phy: Send notifier when starting the cable test
Date:   Sat,  9 May 2020 18:28:51 +0200
Message-Id: <20200509162851.362346-11-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509162851.362346-1-andrew@lunn.ch>
References: <20200509162851.362346-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that it takes time to run a cable test, send a notify message at
the start, as well as when it is completed.

v3:
EMSGSIZE when ethnl_bcastmsg_put() fails
Print an error message on failure, since this is a void function.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/ethtool/cabletest.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index e0c917918c70..2d1ad343bd4f 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -13,6 +13,41 @@ cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
 	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
 };
 
+static void ethnl_cable_test_started(struct phy_device *phydev)
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
+		err = -EMSGSIZE;
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
+	ethnl_multicast(skb, phydev->attached_dev);
+	return;
+
+out:
+	nlmsg_free(skb);
+	phydev_err(phydev, "%s: Error %pe\n", __func__, ERR_PTR(err));
+}
+
 int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_MAX + 1];
@@ -47,6 +82,10 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
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

