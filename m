Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC3A3A7AD4
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 11:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhFOJiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 05:38:52 -0400
Received: from inva021.nxp.com ([92.121.34.21]:42036 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231557AbhFOJiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 05:38:46 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 43FFB200791;
        Tue, 15 Jun 2021 11:36:41 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0293C20073F;
        Tue, 15 Jun 2021 11:36:35 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 1DD3440313;
        Tue, 15 Jun 2021 17:36:26 +0800 (+08)
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
Subject: [net-next, v3, 05/10] ethtool: add a new command for getting PHC virtual clocks
Date:   Tue, 15 Jun 2021 17:45:12 +0800
Message-Id: <20210615094517.48752-6-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210615094517.48752-1-yangbo.lu@nxp.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
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
---
 include/linux/ethtool.h              |  2 +
 include/uapi/linux/ethtool.h         | 14 +++++
 include/uapi/linux/ethtool_netlink.h | 15 +++++
 net/ethtool/Makefile                 |  2 +-
 net/ethtool/common.c                 | 23 ++++++++
 net/ethtool/common.h                 |  2 +
 net/ethtool/ioctl.c                  | 27 +++++++++
 net/ethtool/netlink.c                | 10 ++++
 net/ethtool/netlink.h                |  2 +
 net/ethtool/phc_vclocks.c            | 86 ++++++++++++++++++++++++++++
 10 files changed, 182 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/phc_vclocks.c

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e030f7510cd3..dccbe1829ea5 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -86,6 +86,8 @@ struct netlink_ext_ack;
 /* Some generic methods drivers may use in their ethtool_ops */
 u32 ethtool_op_get_link(struct net_device *dev);
 int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *eti);
+int ethtool_op_get_phc_vclocks(struct net_device *dev,
+			       struct ethtool_phc_vclocks *phc_vclocks);
 
 
 /* Link extended state and substate. */
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index cfef6b08169a..0fb04f945767 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -17,6 +17,7 @@
 #include <linux/const.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
+#include <linux/ptp_clock.h>
 
 #ifndef __KERNEL__
 #include <limits.h> /* for INT_MAX */
@@ -1341,6 +1342,18 @@ struct ethtool_ts_info {
 	__u32	rx_reserved[3];
 };
 
+/**
+ * struct ethtool_phc_vclocks - holds a device's PTP virtual clocks
+ * @cmd: command number = %ETHTOOL_GET_PHC_VCLOCKS
+ * @num: number of PTP vclocks
+ * @index: all index values of PTP vclocks
+ */
+struct ethtool_phc_vclocks {
+	__u32	cmd;
+	__u8	num;
+	__s32	index[PTP_MAX_VCLOCKS];
+};
+
 /*
  * %ETHTOOL_SFEATURES changes features present in features[].valid to the
  * values of corresponding bits in features[].requested. Bits in .requested
@@ -1552,6 +1565,7 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_PHY_STUNABLE	0x0000004f /* Set PHY tunable configuration */
 #define ETHTOOL_GFECPARAM	0x00000050 /* Get FEC settings */
 #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
+#define ETHTOOL_GET_PHC_VCLOCKS	0x00000052 /* Get PHC virtual clocks info */
 
 /* compatibility with older code */
 #define SPARC_ETH_GSET		ETHTOOL_GSET
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 825cfda1c5d5..f8fa688f8351 100644
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
+	ETHTOOL_A_PHC_VCLOCKS_NUM,			/* u8 */
+	ETHTOOL_A_PHC_VCLOCKS_INDEX,			/* s32 */
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
index f9dcbad84788..14035f2dc6d4 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -4,6 +4,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/rtnetlink.h>
+#include <linux/ptp_clock_kernel.h>
 
 #include "common.h"
 
@@ -554,6 +555,28 @@ int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	return 0;
 }
 
+int __ethtool_get_phc_vclocks(struct net_device *dev,
+			      struct ethtool_phc_vclocks *phc_vclocks)
+{
+	struct ethtool_ts_info info = { };
+	int index[PTP_MAX_VCLOCKS];
+	int num = 0;
+
+	phc_vclocks->cmd = ETHTOOL_GET_PHC_VCLOCKS;
+	phc_vclocks->num = 0;
+	memset(phc_vclocks->index, -1, sizeof(phc_vclocks->index));
+
+	if (!__ethtool_get_ts_info(dev, &info))
+		num = ptp_get_vclocks_index(info.phc_index, index);
+
+	if (num > 0) {
+		phc_vclocks->num = num;
+		memcpy(phc_vclocks->index, index, sizeof(int) * num);
+	}
+
+	return 0;
+}
+
 const struct ethtool_phy_ops *ethtool_phy_ops;
 
 void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops)
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 2dc2b80aea5f..e5296bfc21a4 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -44,6 +44,8 @@ bool convert_legacy_settings_to_link_ksettings(
 	const struct ethtool_cmd *legacy_settings);
 int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max);
 int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info);
+int __ethtool_get_phc_vclocks(struct net_device *dev,
+			      struct ethtool_phc_vclocks *phc_vclocks);
 
 extern const struct ethtool_phy_ops *ethtool_phy_ops;
 
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 3fa7a394eabf..c199e5785197 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2188,6 +2188,29 @@ static int ethtool_get_ts_info(struct net_device *dev, void __user *useraddr)
 	return 0;
 }
 
+static int ethtool_get_phc_vclocks(struct net_device *dev,
+				   void __user *useraddr)
+{
+	struct ethtool_phc_vclocks phc_vclocks;
+	int err;
+
+	err = __ethtool_get_phc_vclocks(dev, &phc_vclocks);
+	if (err)
+		return err;
+
+	if (copy_to_user(useraddr, &phc_vclocks, sizeof(phc_vclocks)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int ethtool_op_get_phc_vclocks(struct net_device *dev,
+			       struct ethtool_phc_vclocks *phc_vclocks)
+{
+	return __ethtool_get_phc_vclocks(dev, phc_vclocks);
+}
+EXPORT_SYMBOL(ethtool_op_get_phc_vclocks);
+
 int ethtool_get_module_info_call(struct net_device *dev,
 				 struct ethtool_modinfo *modinfo)
 {
@@ -2634,6 +2657,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_GFEATURES:
 	case ETHTOOL_GCHANNELS:
 	case ETHTOOL_GET_TS_INFO:
+	case ETHTOOL_GET_PHC_VCLOCKS:
 	case ETHTOOL_GEEE:
 	case ETHTOOL_GTUNABLE:
 	case ETHTOOL_PHY_GTUNABLE:
@@ -2858,6 +2882,9 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_SFECPARAM:
 		rc = ethtool_set_fecparam(dev, useraddr);
 		break;
+	case ETHTOOL_GET_PHC_VCLOCKS:
+		rc = ethtool_get_phc_vclocks(dev, useraddr);
+		break;
 	default:
 		rc = -EOPNOTSUPP;
 	}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 88d8a0243f35..2436232d0ecc 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -248,6 +248,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
 	[ETHTOOL_MSG_MODULE_EEPROM_GET]	= &ethnl_module_eeprom_request_ops,
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
+	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -953,6 +954,15 @@ static const struct genl_ops ethtool_genl_ops[] = {
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
index 90b10966b16b..c424f243392b 100644
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
 extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_DATA + 1];
 extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
+extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/phc_vclocks.c b/net/ethtool/phc_vclocks.c
new file mode 100644
index 000000000000..5423e74ef9af
--- /dev/null
+++ b/net/ethtool/phc_vclocks.c
@@ -0,0 +1,86 @@
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
+	struct ethtool_phc_vclocks	phc_vclocks;
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
+	ret = __ethtool_get_phc_vclocks(dev, &data->phc_vclocks);
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
+	const struct ethtool_phc_vclocks *phc_vclocks = &data->phc_vclocks;
+	int len = 0;
+
+	if (phc_vclocks->num > 0) {
+		len += nla_total_size(sizeof(u32));
+		len += nla_total_size(sizeof(data->phc_vclocks.index));
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
+	const struct ethtool_phc_vclocks *phc_vclocks = &data->phc_vclocks;
+
+	if (phc_vclocks->num <= 0)
+		return 0;
+
+	if (nla_put_u32(skb, ETHTOOL_A_PHC_VCLOCKS_NUM, phc_vclocks->num) ||
+	    nla_put(skb, ETHTOOL_A_PHC_VCLOCKS_INDEX,
+		    sizeof(phc_vclocks->index), phc_vclocks->index))
+		return -EMSGSIZE;
+
+	return 0;
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
+};
-- 
2.25.1

