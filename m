Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3795F1CC2A1
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgEIQ31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:29:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50976 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728304AbgEIQ3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 12:29:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7SakAlyoXs/gwSLBPE2rlCAfW/8JDD19oBHxBjtiVLQ=; b=kYzRuVW/cBtshoOWj6AHRQ670s
        8FEibIcYikw5BY88ektVhwvM/Q1eolSHZ1K/B2DHWQOjxtzH/0lRjrPhmS0hNJzLEXNkxi+9VU3Wh
        WGqYWkWuTLHpM+J95R4ZpGQO1k9frIQQzjgjnf0maz/5FJ1ZKC6T5F5+h9RlOc4dNQPI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXSLc-001WHG-2K; Sat, 09 May 2020 18:29:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 03/10] net: ethtool: netlink: Add support for triggering a cable test
Date:   Sat,  9 May 2020 18:28:44 +0200
Message-Id: <20200509162851.362346-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509162851.362346-1-andrew@lunn.ch>
References: <20200509162851.362346-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new ethtool netlink calls to trigger the starting of a PHY cable
test.

Add Kconfig'ury to ETHTOOL_NETLINK so that PHYLIB is not a module when
ETHTOOL_NETLINK is builtin, which would result in kernel linking errors.

v2:
Remove unwanted white space change
Remove ethnl_cable_test_act_ops and use doit handler
Rename cable_test_set_policy cable_test_act_policy
Remove ETHTOOL_MSG_CABLE_TEST_ACT_REPLY

v3:
Remove ETHTOOL_MSG_CABLE_TEST_ACT_REPLY from documentation
Remove unused cable_test_get_policy
Add Reviewed-by tags

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst | 16 +++++-
 include/uapi/linux/ethtool_netlink.h         | 13 +++++
 net/Kconfig                                  |  1 +
 net/ethtool/Makefile                         |  2 +-
 net/ethtool/cabletest.c                      | 54 ++++++++++++++++++++
 net/ethtool/netlink.c                        |  5 ++
 net/ethtool/netlink.h                        |  1 +
 7 files changed, 90 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/cabletest.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 8f5cefc539cf..a8731d33d0c9 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -204,6 +204,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_EEE_GET``               get EEE settings
   ``ETHTOOL_MSG_EEE_SET``               set EEE settings
   ``ETHTOOL_MSG_TSINFO_GET``		get timestamping info
+  ``ETHTOOL_MSG_CABLE_TEST_ACT``        action start cable test
   ===================================== ================================
 
 Kernel to userspace:
@@ -958,13 +959,25 @@ Kernel response contents:
 is no special value for this case). The bitset attributes are omitted if they
 would be empty (no bit set).
 
+CABLE_TEST
+==========
+
+Start a cable test.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_CABLE_TEST_HEADER``       nested  request header
+  ====================================  ======  ==========================
+
 
 Request translation
 ===================
 
 The following table maps ioctl commands to netlink commands providing their
 functionality. Entries with "n/a" in right column are commands which do not
-have their netlink replacement yet.
+have their netlink replacement yet. Entries which "n/a" in the left column
+are netlink only.
 
   =================================== =====================================
   ioctl command                       netlink command
@@ -1053,4 +1066,5 @@ have their netlink replacement yet.
   ``ETHTOOL_PHY_STUNABLE``            n/a
   ``ETHTOOL_GFECPARAM``               n/a
   ``ETHTOOL_SFECPARAM``               n/a
+  n/a                                 ''ETHTOOL_MSG_CABLE_TEST_ACT''
   =================================== =====================================
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index bf1d310e20bc..48bb3a23b3fa 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -39,6 +39,7 @@ enum {
 	ETHTOOL_MSG_EEE_GET,
 	ETHTOOL_MSG_EEE_SET,
 	ETHTOOL_MSG_TSINFO_GET,
+	ETHTOOL_MSG_CABLE_TEST_ACT,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -403,6 +404,18 @@ enum {
 	/* add new constants above here */
 	__ETHTOOL_A_TSINFO_CNT,
 	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
+
+};
+
+/* CABLE TEST */
+
+enum {
+	ETHTOOL_A_CABLE_TEST_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_HEADER,		/* nest - _A_HEADER_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_CABLE_TEST_CNT,
+	ETHTOOL_A_CABLE_TEST_MAX = __ETHTOOL_A_CABLE_TEST_CNT - 1
 };
 
 /* generic netlink info */
diff --git a/net/Kconfig b/net/Kconfig
index c5ba2d180c43..5c524c6ee75d 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -455,6 +455,7 @@ config FAILOVER
 config ETHTOOL_NETLINK
 	bool "Netlink interface for ethtool"
 	default y
+	depends on PHYLIB=y || PHYLIB=n
 	help
 	  An alternative userspace interface for ethtool based on generic
 	  netlink. It provides better extensibility and some new features,
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 6c360c9c9370..0c2b94f20499 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -6,4 +6,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
-		   channels.o coalesce.o pause.o eee.o tsinfo.o
+		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o
diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
new file mode 100644
index 000000000000..aeb6672a46d0
--- /dev/null
+++ b/net/ethtool/cabletest.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/phy.h>
+#include "netlink.h"
+#include "common.h"
+
+/* CABLE_TEST_ACT */
+
+static const struct nla_policy
+cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
+	[ETHTOOL_A_CABLE_TEST_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
+};
+
+int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_MAX + 1];
+	struct ethnl_req_info req_info = {};
+	struct net_device *dev;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_CABLE_TEST_MAX,
+			  cable_test_act_policy, info->extack);
+	if (ret < 0)
+		return ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_CABLE_TEST_HEADER],
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
+	ret = phy_start_cable_test(dev->phydev, info->extack);
+
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev_put:
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 0c772318c023..b9c9ddf408fe 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -839,6 +839,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_CABLE_TEST_ACT,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_act_cable_test,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 81b8fa020bcb..bd7df592db2f 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -357,5 +357,6 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info);
+int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.26.2

