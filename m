Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BDB1B8865
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 20:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgDYSGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 14:06:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726306AbgDYSGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 14:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=F4DAl+vCUQUHAYS7F8xdCh+SWQy6Z2ZJtOSjqdWS0LY=; b=vC8gIzKIOtZ11ZuMghL9FRlqtD
        sjBtuwAmMV5T86+QGU0LRzhMV6mMXk23SSoSzg99MM6pAUbu2/3aX794MMSZr/1wwkdJQMciFh9vx
        vdzUx3ER1HrYPjM4UCTlbBCmoE3ZCxuhmH2pBu0Co8CJwfKJ79gBG0C5QOLlSs1e7zgw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSPCG-004mhc-8E; Sat, 25 Apr 2020 20:06:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 3/9] net: ethtool: netlink: Add support for triggering a cable test
Date:   Sat, 25 Apr 2020 20:06:15 +0200
Message-Id: <20200425180621.1140452-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200425180621.1140452-1-andrew@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
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

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/networking/ethtool-netlink.rst | 18 ++++-
 include/uapi/linux/ethtool_netlink.h         | 14 ++++
 net/Kconfig                                  |  1 +
 net/ethtool/Makefile                         |  2 +-
 net/ethtool/cabletest.c                      | 82 ++++++++++++++++++++
 net/ethtool/netlink.c                        |  6 ++
 net/ethtool/netlink.h                        |  2 +
 7 files changed, 122 insertions(+), 3 deletions(-)
 create mode 100644 net/ethtool/cabletest.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 567326491f80..0c354567e991 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -204,6 +204,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_EEE_GET``               get EEE settings
   ``ETHTOOL_MSG_EEE_SET``               set EEE settings
   ``ETHTOOL_MSG_TSINFO_GET``		get timestamping info
+  ``ETHTOOL_MSG_CABLE_TEST_ACT``        action start cable test
   ===================================== ================================
 
 Kernel to userspace:
@@ -235,6 +236,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_EEE_GET_REPLY``         EEE settings
   ``ETHTOOL_MSG_EEE_NTF``               EEE settings
   ``ETHTOOL_MSG_TSINFO_GET_REPLY``	timestamping info
+  ``ETHTOOL_MSG_CABLE_TEST_ACT_REPLY``  Cable test action result
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -758,7 +760,6 @@ Kernel checks that requested channel counts do not exceed limits reported by
 driver. Driver may impose additional constraints and may not suspport all
 attributes.
 
-
 COALESCE_GET
 ============
 
@@ -955,13 +956,25 @@ Kernel response contents:
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
@@ -1050,4 +1063,5 @@ have their netlink replacement yet.
   ``ETHTOOL_PHY_STUNABLE``            n/a
   ``ETHTOOL_GFECPARAM``               n/a
   ``ETHTOOL_SFECPARAM``               n/a
+  n/a                                 ''ETHTOOL_MSG_CABLE_TEST_ACT''
   =================================== =====================================
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 7fde76366ba4..598d0b502ebd 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -39,6 +39,7 @@ enum {
 	ETHTOOL_MSG_EEE_GET,
 	ETHTOOL_MSG_EEE_SET,
 	ETHTOOL_MSG_TSINFO_GET,
+	ETHTOOL_MSG_CABLE_TEST_ACT,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -74,6 +75,7 @@ enum {
 	ETHTOOL_MSG_EEE_GET_REPLY,
 	ETHTOOL_MSG_EEE_NTF,
 	ETHTOOL_MSG_TSINFO_GET_REPLY,
+	ETHTOOL_MSG_CABLE_TEST_ACT_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -401,6 +403,18 @@ enum {
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
index df8d8c9bd021..d72d0d804456 100644
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
index 000000000000..44b8165ac66e
--- /dev/null
+++ b/net/ethtool/cabletest.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/phy.h>
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct cable_test_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct cable_test_reply_data {
+	struct ethnl_reply_data		base;
+};
+
+#define CABLE_TEST_REPDATA(__reply_base) \
+	container_of(__reply_base, struct cable_test_reply_data, base)
+
+static const struct nla_policy
+cable_test_get_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
+	[ETHTOOL_A_CABLE_TEST_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
+};
+
+const struct ethnl_request_ops ethnl_cable_test_act_ops = {
+	.request_cmd		= ETHTOOL_MSG_CABLE_TEST_ACT,
+	.reply_cmd		= ETHTOOL_MSG_CABLE_TEST_ACT_REPLY,
+	.hdr_attr		= ETHTOOL_A_CABLE_TEST_HEADER,
+	.max_attr		= ETHTOOL_A_CABLE_TEST_MAX,
+	.req_info_size		= sizeof(struct cable_test_req_info),
+	.reply_data_size	= sizeof(struct cable_test_reply_data),
+	.request_policy		= cable_test_get_policy,
+};
+
+/* CABLE_TEST_ACT */
+
+static const struct nla_policy
+cable_test_set_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
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
+			  cable_test_set_policy, info->extack);
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
index 0c772318c023..56efd12c58ba 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -231,6 +231,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PAUSE_GET]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
+	[ETHTOOL_MSG_CABLE_TEST_ACT]	= &ethnl_cable_test_act_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -839,6 +840,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
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
index 81b8fa020bcb..03e65e2b9e3d 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -345,6 +345,7 @@ extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
 extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
+extern const struct ethnl_request_ops ethnl_cable_test_act_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -357,5 +358,6 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info);
+int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.26.1

