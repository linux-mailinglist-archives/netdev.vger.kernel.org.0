Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45D2301055
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbhAVWwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:52:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:1662 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728476AbhAVWrj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 17:47:39 -0500
IronPort-SDR: 58m1JnN8OZ+1S/QA5hkKZy/mnA5v1+BYVPM2h8LG2ZA+iWPif73v92L7AaA8jvhornyjxJRkmH
 /oCEhwcCPfuQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="166619671"
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="166619671"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:20 -0800
IronPort-SDR: TWoPYWcMtxPUwHDrzfFQbuJkSUA2w2VQrl0E1vIE9B+63QozlUE38HEhEhHgArTeBqa4ike1vs
 70l2uOIaBLZA==
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="355390545"
Received: from apalur-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.155.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:19 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v3 1/8] ethtool: Add support for configuring frame preemption
Date:   Fri, 22 Jan 2021 14:44:46 -0800
Message-Id: <20210122224453.4161729-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122224453.4161729-1-vinicius.gomes@intel.com>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frame preemption (described in IEEE 802.3br-2016) defines the concept
of preemptible and express queues. It allows traffic from express
queues to "interrupt" traffic from preemptible queues, which are
"resumed" after the express traffic has finished transmitting.

Frame preemption can only be used when both the local device and the
link partner support it.

Only parameters for enabling/disabling frame preemption and
configuring the minimum fragment size are included here. Expressing
which queues are marked as preemptible is left to mqprio/taprio, as
having that information there should be easier on the user.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 Documentation/networking/ethtool-netlink.rst |  38 +++++
 include/linux/ethtool.h                      |  23 ++-
 include/uapi/linux/ethtool_netlink.h         |  17 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |  25 ++++
 net/ethtool/netlink.c                        |  19 +++
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/preempt.c                        | 146 +++++++++++++++++++
 8 files changed, 272 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/preempt.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 30b98245979f..339310aa7595 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1279,6 +1279,44 @@ Kernel response contents:
 For UDP tunnel table empty ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES`` indicates that
 the table contains static entries, hard-coded by the NIC.
 
+PREEMPT_GET
+===========
+
+Get information about frame preemption state.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_PREEMPT_HEADER``          nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_PREEMPT_HEADER``           nested  reply header
+  ``ETHTOOL_A_PREEMPT_ENABLED``          u8      frame preemption enabled
+  ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``    u32     Min additional frag size
+  =====================================  ======  ==========================
+
+``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE`` configures the minimum non-final
+fragment size that the receiver device supports.
+
+PREEMPT_SET
+============
+
+Sets frame preemption parameters.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_CHANNELS_HEADER``          nested  reply header
+  ``ETHTOOL_A_PREEMPT_ENABLED``          u8      frame preemption enabled
+  ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``    u32     Min additional frag size
+  =====================================  ======  ==========================
+
+``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE`` configures the minimum non-final
+fragment size that the receiver device supports.
+
 Request translation
 ===================
 
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e3da25b51ae4..f14ddb22285d 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -81,6 +81,7 @@ enum {
 #define ETH_RSS_HASH_NO_CHANGE	0
 
 struct net_device;
+struct netlink_ext_ack;
 
 /* Some generic methods drivers may use in their ethtool_ops */
 u32 ethtool_op_get_link(struct net_device *dev);
@@ -263,6 +264,19 @@ struct ethtool_pause_stats {
 	u64 rx_pause_frames;
 };
 
+/**
+ * struct ethtool_fp - Frame Preemption information
+ *
+ * @enabled: Enable frame preemption.
+ * @add_frag_size: Minimum size for additional (non-final) fragments
+ * in bytes, for the value defined in the IEEE 802.3-2018 standard see
+ * ethtool_frag_size_to_mult().
+ */
+struct ethtool_fp {
+	u8 enabled;
+	u32 add_frag_size;
+};
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @supported_coalesce_params: supported types of interrupt coalescing.
@@ -406,6 +420,8 @@ struct ethtool_pause_stats {
  * @get_ethtool_phy_stats: Return extended statistics about the PHY device.
  *	This is only useful if the device maintains PHY statistics and
  *	cannot use the standard PHY library helpers.
+ * @get_preempt: Get the network device Frame Preemption parameters.
+ * @set_preempt: Set the network device Frame Preemption parameters.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -504,6 +520,10 @@ struct ethtool_ops {
 				      struct ethtool_fecparam *);
 	int	(*set_fecparam)(struct net_device *,
 				      struct ethtool_fecparam *);
+	int	(*get_preempt)(struct net_device *,
+			       struct ethtool_fp *);
+	int	(*set_preempt)(struct net_device *, struct ethtool_fp *,
+			       struct netlink_ext_ack *);
 	void	(*get_ethtool_phy_stats)(struct net_device *,
 					 struct ethtool_stats *, u64 *);
 	int	(*get_phy_tunable)(struct net_device *,
@@ -533,7 +553,6 @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
 				       const struct ethtool_link_ksettings *cmd,
 				       u32 *dev_speed, u8 *dev_duplex);
 
-struct netlink_ext_ack;
 struct phy_device;
 struct phy_tdr_config;
 
@@ -566,4 +585,6 @@ struct ethtool_phy_ops {
  */
 void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops);
 
+u8 ethtool_frag_size_to_mult(u32 frag_size);
+
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index e2bf36e6964b..bd7a722dc13a 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -42,6 +42,8 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_ACT,
 	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 	ETHTOOL_MSG_TUNNEL_INFO_GET,
+	ETHTOOL_MSG_PREEMPT_GET,
+	ETHTOOL_MSG_PREEMPT_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -80,6 +82,8 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_NTF,
 	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
+	ETHTOOL_MSG_PREEMPT_GET_REPLY,
+	ETHTOOL_MSG_PREEMPT_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -628,6 +632,19 @@ enum {
 	ETHTOOL_A_TUNNEL_INFO_MAX = (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)
 };
 
+/* FRAME PREEMPTION */
+
+enum {
+	ETHTOOL_A_PREEMPT_UNSPEC,
+	ETHTOOL_A_PREEMPT_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_PREEMPT_ENABLED,			/* u8 */
+	ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE,		/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_PREEMPT_CNT,
+	ETHTOOL_A_PREEMPT_MAX = (__ETHTOOL_A_PREEMPT_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 7a849ff22dad..4e584903e3ef 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o
+		   tunnels.o preempt.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a1..9206d6b4f858 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -410,3 +410,28 @@ void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops)
 	rtnl_unlock();
 }
 EXPORT_SYMBOL_GPL(ethtool_set_ethtool_phy_ops);
+
+/**
+ * ethtool_frag_size_to_mult() - Convert from a Frame Preemption
+ * Additional Fragment size in bytes to a multiplier.
+ * @frag_size: minimum non-final fragment size in bytes.
+ *
+ * The multiplier is defined as:
+ *	"A 2-bit integer value used to indicate the minimum size of
+ *	non-final fragments supported by the receiver on the given port
+ *	associated with the local System. This value is expressed in units
+ *	of 64 octets of additional fragment length."
+ *	Equivalent to `30.14.1.7 aMACMergeAddFragSize` from the IEEE 802.3-2018
+ *	standard.
+ *
+ * Return: the multiplier is a number in the [0, 2] interval.
+ */
+u8 ethtool_frag_size_to_mult(u32 frag_size)
+{
+	u8 mult = (frag_size / 64) - 1;
+
+	mult = clamp_t(u8, mult, 0, 3);
+
+	return mult;
+}
+EXPORT_SYMBOL_GPL(ethtool_frag_size_to_mult);
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 50d3c8896f91..bc7d66e3ba38 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -245,6 +245,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PAUSE_GET]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
+	[ETHTOOL_MSG_PREEMPT_GET]	= &ethnl_preempt_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -551,6 +552,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_COALESCE_NTF]	= &ethnl_coalesce_request_ops,
 	[ETHTOOL_MSG_PAUSE_NTF]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
+	[ETHTOOL_MSG_PREEMPT_NTF]	= &ethnl_preempt_request_ops,
 };
 
 /* default notification handler */
@@ -643,6 +645,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_COALESCE_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_PAUSE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_PREEMPT_NTF]	= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -912,6 +915,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_tunnel_info_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_tunnel_info_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_PREEMPT_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_preempt_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_preempt_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_PREEMPT_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_preempt,
+		.policy = ethnl_preempt_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_preempt_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index d8efec516d86..53d2e722fad3 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -344,6 +344,7 @@ extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
 extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
+extern const struct ethnl_request_ops ethnl_preempt_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -375,6 +376,8 @@ extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_HEADER +
 extern const struct nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_HEADER + 1];
 extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG + 1];
 extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
+extern const struct nla_policy ethnl_preempt_get_policy[ETHTOOL_A_PREEMPT_HEADER + 1];
+extern const struct nla_policy ethnl_preempt_set_policy[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -392,5 +395,6 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info);
 int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info);
 int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+int ethnl_set_preempt(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/preempt.c b/net/ethtool/preempt.c
new file mode 100644
index 000000000000..4f96d3c2b1d5
--- /dev/null
+++ b/net/ethtool/preempt.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+
+struct preempt_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct preempt_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_fp		fp;
+};
+
+#define PREEMPT_REPDATA(__reply_base) \
+	container_of(__reply_base, struct preempt_reply_data, base)
+
+const struct nla_policy
+ethnl_preempt_get_policy[] = {
+	[ETHTOOL_A_PREEMPT_HEADER]		= NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+static int preempt_prepare_data(const struct ethnl_req_info *req_base,
+				struct ethnl_reply_data *reply_base,
+				struct genl_info *info)
+{
+	struct preempt_reply_data *data = PREEMPT_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	if (!dev->ethtool_ops->get_preempt)
+		return -EOPNOTSUPP;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	ret = dev->ethtool_ops->get_preempt(dev, &data->fp);
+	ethnl_ops_complete(dev);
+
+	return ret;
+}
+
+static int preempt_reply_size(const struct ethnl_req_info *req_base,
+			      const struct ethnl_reply_data *reply_base)
+{
+	int len = 0;
+
+	len += nla_total_size(sizeof(u8)); /* _PREEMPT_ENABLED */
+	len += nla_total_size(sizeof(u32)); /* _PREEMPT_ADD_FRAG_SIZE */
+
+	return len;
+}
+
+static int preempt_fill_reply(struct sk_buff *skb,
+			      const struct ethnl_req_info *req_base,
+			      const struct ethnl_reply_data *reply_base)
+{
+	const struct preempt_reply_data *data = PREEMPT_REPDATA(reply_base);
+	const struct ethtool_fp *preempt = &data->fp;
+
+	if (nla_put_u8(skb, ETHTOOL_A_PREEMPT_ENABLED, preempt->enabled))
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE,
+			preempt->add_frag_size))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_preempt_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_PREEMPT_GET,
+	.reply_cmd		= ETHTOOL_MSG_PREEMPT_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_PREEMPT_HEADER,
+	.req_info_size		= sizeof(struct preempt_req_info),
+	.reply_data_size	= sizeof(struct preempt_reply_data),
+
+	.prepare_data		= preempt_prepare_data,
+	.reply_size		= preempt_reply_size,
+	.fill_reply		= preempt_fill_reply,
+};
+
+const struct nla_policy
+ethnl_preempt_set_policy[ETHTOOL_A_PREEMPT_MAX + 1] = {
+	[ETHTOOL_A_PREEMPT_HEADER]			= NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_PREEMPT_ENABLED]			= NLA_POLICY_RANGE(NLA_U8, 0, 1),
+	[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE]		= { .type = NLA_U32 },
+};
+
+int ethnl_set_preempt(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	struct ethtool_fp preempt = {};
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_PREEMPT_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	ret = -EOPNOTSUPP;
+	if (!dev->ethtool_ops->get_preempt ||
+	    !dev->ethtool_ops->set_preempt)
+		goto out_dev;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = dev->ethtool_ops->get_preempt(dev, &preempt);
+	if (ret < 0) {
+		GENL_SET_ERR_MSG(info, "failed to retrieve frame preemption settings");
+		goto out_ops;
+	}
+
+	ethnl_update_u8(&preempt.enabled,
+			tb[ETHTOOL_A_PREEMPT_ENABLED], &mod);
+	ethnl_update_u32(&preempt.add_frag_size,
+			 tb[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE], &mod);
+	ret = 0;
+	if (!mod)
+		goto out_ops;
+
+	ret = dev->ethtool_ops->set_preempt(dev, &preempt, info->extack);
+	if (ret < 0) {
+		GENL_SET_ERR_MSG(info, "frame preemption settings update failed");
+		goto out_ops;
+	}
+
+	ethtool_notify(dev, ETHTOOL_MSG_PREEMPT_NTF, NULL);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	dev_put(dev);
+	return ret;
+}
-- 
2.30.0

