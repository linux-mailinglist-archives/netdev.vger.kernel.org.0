Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485F83B4063
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 11:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhFYJ1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 05:27:09 -0400
Received: from inva020.nxp.com ([92.121.34.13]:32954 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231439AbhFYJ07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 05:26:59 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 058991A04A8;
        Fri, 25 Jun 2021 11:24:38 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 90C6F1A271F;
        Fri, 25 Jun 2021 11:24:37 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 61403183ACDD;
        Fri, 25 Jun 2021 17:24:35 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: [net-next, v4, 05/11] ethtool: add a new command for getting PHC virtual clocks
Date:   Fri, 25 Jun 2021 17:35:07 +0800
Message-Id: <20210625093513.38524-6-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210625093513.38524-1-yangbo.lu@nxp.com>
References: <20210625093513.38524-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface for getting PHC (PTP Hardware Clock)
virtual clocks, which are based on PHC physical clock
providing hardware timestamp to network packets.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v3:
	- Added this patch.
Changes for v4:
	- Updated doc.
	- Removed ioctl command.
	- Replied only the number of vclock index.
---
 Documentation/networking/ethtool-netlink.rst | 22 +++++
 include/linux/ethtool.h                      | 10 +++
 include/uapi/linux/ethtool_netlink.h         | 15 ++++
 net/ethtool/Makefile                         |  2 +-
 net/ethtool/common.c                         | 13 +++
 net/ethtool/netlink.c                        | 10 +++
 net/ethtool/netlink.h                        |  2 +
 net/ethtool/phc_vclocks.c                    | 94 ++++++++++++++++++++
 8 files changed, 167 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/phc_vclocks.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 6ea91e41593f..c86628e6a235 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -212,6 +212,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_FEC_SET``               set FEC settings
   ``ETHTOOL_MSG_MODULE_EEPROM_GET``     read SFP module EEPROM
   ``ETHTOOL_MSG_STATS_GET``             get standard statistics
+  ``ETHTOOL_MSG_PHC_VCLOCKS_GET``       get PHC virtual clocks info
   ===================================== ================================
 
 Kernel to userspace:
@@ -250,6 +251,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_FEC_NTF``                  FEC settings
   ``ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY``  read SFP module EEPROM
   ``ETHTOOL_MSG_STATS_GET_REPLY``          standard statistics
+  ``ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY``    PHC virtual clocks info
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1477,6 +1479,25 @@ Low and high bounds are inclusive, for example:
  etherStatsPkts512to1023Octets 512  1023
  ============================= ==== ====
 
+PHC_VCLOCKS_GET
+===============
+
+Query device PHC virtual clocks information.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_PHC_VCLOCKS_HEADER``      nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_PHC_VCLOCKS_HEADER``      nested  reply header
+  ``ETHTOOL_A_PHC_VCLOCKS_NUM``         u32     PHC virtual clocks number
+  ``ETHTOOL_A_PHC_VCLOCKS_INDEX``       s32     PHC index array
+  ====================================  ======  ==========================
+
 Request translation
 ===================
 
@@ -1575,4 +1596,5 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_CABLE_TEST_ACT``
   n/a                                 ``ETHTOOL_MSG_CABLE_TEST_TDR_ACT``
   n/a                                 ``ETHTOOL_MSG_TUNNEL_INFO_GET``
+  n/a                                 ``ETHTOOL_MSG_PHC_VCLOCKS_GET``
   =================================== =====================================
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 29dbb603bc91..232daaec56e4 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -757,6 +757,16 @@ void
 ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
 			      enum ethtool_link_mode_bit_indices link_mode);
 
+/**
+ * ethtool_get_phc_vclocks - Derive phc vclocks information, and caller
+ *                           is responsible to free memory of vclock_index
+ * @dev: pointer to net_device structure
+ * @vclock_index: pointer to pointer of vclock index
+ *
+ * Return number of phc vclocks
+ */
+int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index);
+
 /**
  * ethtool_sprintf - Write formatted string to ethtool string data
  * @data: Pointer to start of string to update
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index c7135c9c37a5..b3b93710eff7 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -46,6 +46,7 @@ enum {
 	ETHTOOL_MSG_FEC_SET,
 	ETHTOOL_MSG_MODULE_EEPROM_GET,
 	ETHTOOL_MSG_STATS_GET,
+	ETHTOOL_MSG_PHC_VCLOCKS_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -88,6 +89,7 @@ enum {
 	ETHTOOL_MSG_FEC_NTF,
 	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
 	ETHTOOL_MSG_STATS_GET_REPLY,
+	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -440,6 +442,19 @@ enum {
 	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
 };
 
+/* PHC VCLOCKS */
+
+enum {
+	ETHTOOL_A_PHC_VCLOCKS_UNSPEC,
+	ETHTOOL_A_PHC_VCLOCKS_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_PHC_VCLOCKS_NUM,			/* u32 */
+	ETHTOOL_A_PHC_VCLOCKS_INDEX,			/* array, s32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_PHC_VCLOCKS_CNT,
+	ETHTOOL_A_PHC_VCLOCKS_MAX = (__ETHTOOL_A_PHC_VCLOCKS_CNT - 1)
+};
+
 /* CABLE TEST */
 
 enum {
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 723c9a8a8cdf..0a19470efbfb 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o fec.o eeprom.o stats.o
+		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index f9dcbad84788..798231b07676 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -4,6 +4,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/rtnetlink.h>
+#include <linux/ptp_clock_kernel.h>
 
 #include "common.h"
 
@@ -554,6 +555,18 @@ int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	return 0;
 }
 
+int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index)
+{
+	struct ethtool_ts_info info = { };
+	int num = 0;
+
+	if (!__ethtool_get_ts_info(dev, &info))
+		num = ptp_get_vclocks_index(info.phc_index, vclock_index);
+
+	return num;
+}
+EXPORT_SYMBOL(ethtool_get_phc_vclocks);
+
 const struct ethtool_phy_ops *ethtool_phy_ops;
 
 void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops)
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index a7346346114f..73e0f5b626bf 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -248,6 +248,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
 	[ETHTOOL_MSG_MODULE_EEPROM_GET]	= &ethnl_module_eeprom_request_ops,
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
+	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -958,6 +959,15 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_stats_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_stats_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_PHC_VCLOCKS_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_phc_vclocks_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_phc_vclocks_get_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 3e25a47fd482..3fc395c86702 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -347,6 +347,7 @@ extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 extern const struct ethnl_request_ops ethnl_fec_request_ops;
 extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
 extern const struct ethnl_request_ops ethnl_stats_request_ops;
+extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -382,6 +383,7 @@ extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
 extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
 extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS + 1];
 extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
+extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/phc_vclocks.c b/net/ethtool/phc_vclocks.c
new file mode 100644
index 000000000000..637b2f5297d5
--- /dev/null
+++ b/net/ethtool/phc_vclocks.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2021 NXP
+ */
+#include "netlink.h"
+#include "common.h"
+
+struct phc_vclocks_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct phc_vclocks_reply_data {
+	struct ethnl_reply_data		base;
+	int				num;
+	int				*index;
+};
+
+#define PHC_VCLOCKS_REPDATA(__reply_base) \
+	container_of(__reply_base, struct phc_vclocks_reply_data, base)
+
+const struct nla_policy ethnl_phc_vclocks_get_policy[] = {
+	[ETHTOOL_A_PHC_VCLOCKS_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+static int phc_vclocks_prepare_data(const struct ethnl_req_info *req_base,
+				    struct ethnl_reply_data *reply_base,
+				    struct genl_info *info)
+{
+	struct phc_vclocks_reply_data *data = PHC_VCLOCKS_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	data->num = ethtool_get_phc_vclocks(dev, &data->index);
+	ethnl_ops_complete(dev);
+
+	return ret;
+}
+
+static int phc_vclocks_reply_size(const struct ethnl_req_info *req_base,
+				  const struct ethnl_reply_data *reply_base)
+{
+	const struct phc_vclocks_reply_data *data =
+		PHC_VCLOCKS_REPDATA(reply_base);
+	int len = 0;
+
+	if (data->num > 0) {
+		len += nla_total_size(sizeof(u32));
+		len += nla_total_size(sizeof(s32) * data->num);
+	}
+
+	return len;
+}
+
+static int phc_vclocks_fill_reply(struct sk_buff *skb,
+				  const struct ethnl_req_info *req_base,
+				  const struct ethnl_reply_data *reply_base)
+{
+	const struct phc_vclocks_reply_data *data =
+		PHC_VCLOCKS_REPDATA(reply_base);
+
+	if (data->num <= 0)
+		return 0;
+
+	if (nla_put_u32(skb, ETHTOOL_A_PHC_VCLOCKS_NUM, data->num) ||
+	    nla_put(skb, ETHTOOL_A_PHC_VCLOCKS_INDEX,
+		    sizeof(s32) * data->num, data->index))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static void phc_vclocks_cleanup_data(struct ethnl_reply_data *reply_base)
+{
+	const struct phc_vclocks_reply_data *data =
+		PHC_VCLOCKS_REPDATA(reply_base);
+
+	kfree(data->index);
+}
+
+const struct ethnl_request_ops ethnl_phc_vclocks_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_PHC_VCLOCKS_GET,
+	.reply_cmd		= ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_PHC_VCLOCKS_HEADER,
+	.req_info_size		= sizeof(struct phc_vclocks_req_info),
+	.reply_data_size	= sizeof(struct phc_vclocks_reply_data),
+
+	.prepare_data		= phc_vclocks_prepare_data,
+	.reply_size		= phc_vclocks_reply_size,
+	.fill_reply		= phc_vclocks_fill_reply,
+	.cleanup_data		= phc_vclocks_cleanup_data,
+};
-- 
2.25.1

