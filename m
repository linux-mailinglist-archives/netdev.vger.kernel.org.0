Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564453B4B89
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 02:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhFZAgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 20:36:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:48448 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229884AbhFZAgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 20:36:03 -0400
IronPort-SDR: uFxRITYnVKZHchLtddKEHylIPxkwQFGud29iBPyzUBCbwWuicMlEKlXu5lk4GzeUMVgl9EMqYs
 IVuW3SkG7m7A==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="195054017"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="195054017"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:41 -0700
IronPort-SDR: H+Jb59LWjtQJkSeSQmTFZGo2TN4usWUHklJQORk0LiAwOaxCnCyrnCuqBxN4DeksPsqQQfgppe
 Paqzwkic7k4g==
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="557008595"
Received: from aschmalt-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.160.59])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:40 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v4 01/12] ethtool: Add support for configuring frame preemption
Date:   Fri, 25 Jun 2021 17:33:03 -0700
Message-Id: <20210626003314.3159402-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210626003314.3159402-1-vinicius.gomes@intel.com>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frame preemption (described in IEEE 802.3-2018, Section 99 in
particular) defines the concept of preemptible and express queues. It
allows traffic from express queues to "interrupt" traffic from
preemptible queues, which are "resumed" after the express traffic has
finished transmitting.

Frame preemption can only be used when both the local device and the
link partner support it.

Only parameters for enabling/disabling frame preemption and
configuring the minimum fragment size are included here. Expressing
which queues are marked as preemptible is left to mqprio/taprio, as
having that information there should be easier on the user.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 Documentation/networking/ethtool-netlink.rst |  38 +++++
 include/linux/ethtool.h                      |  22 +++
 include/uapi/linux/ethtool_netlink.h         |  17 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |  25 ++++
 net/ethtool/netlink.c                        |  19 +++
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/preempt.c                        | 146 +++++++++++++++++++
 8 files changed, 272 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/preempt.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 6ea91e41593f..a87f1716944e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1477,6 +1477,44 @@ Low and high bounds are inclusive, for example:
  etherStatsPkts512to1023Octets 512  1023
  ============================= ==== ====
 
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
+Request contents:
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
+===========
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
index 29dbb603bc91..7e449be8f335 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -409,6 +409,19 @@ struct ethtool_module_eeprom {
 	u8	*data;
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
  * @cap_link_lanes_supported: indicates if the driver supports lanes
@@ -561,6 +574,8 @@ struct ethtool_module_eeprom {
  *	not report statistics.
  * @get_fecparam: Get the network device Forward Error Correction parameters.
  * @set_fecparam: Set the network device Forward Error Correction parameters.
+ * @get_preempt: Get the network device Frame Preemption parameters.
+ * @set_preempt: Set the network device Frame Preemption parameters.
  * @get_ethtool_phy_stats: Return extended statistics about the PHY device.
  *	This is only useful if the device maintains PHY statistics and
  *	cannot use the standard PHY library helpers.
@@ -675,6 +690,10 @@ struct ethtool_ops {
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
@@ -766,4 +785,7 @@ ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
  * next string.
  */
 extern __printf(2, 3) void ethtool_sprintf(u8 **data, const char *fmt, ...);
+
+u8 ethtool_frag_size_to_mult(u32 frag_size);
+
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index c7135c9c37a5..4600aba1c693 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -44,6 +44,8 @@ enum {
 	ETHTOOL_MSG_TUNNEL_INFO_GET,
 	ETHTOOL_MSG_FEC_GET,
 	ETHTOOL_MSG_FEC_SET,
+	ETHTOOL_MSG_PREEMPT_GET,
+	ETHTOOL_MSG_PREEMPT_SET,
 	ETHTOOL_MSG_MODULE_EEPROM_GET,
 	ETHTOOL_MSG_STATS_GET,
 
@@ -86,6 +88,8 @@ enum {
 	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
 	ETHTOOL_MSG_FEC_GET_REPLY,
 	ETHTOOL_MSG_FEC_NTF,
+	ETHTOOL_MSG_PREEMPT_GET_REPLY,
+	ETHTOOL_MSG_PREEMPT_NTF,
 	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
 	ETHTOOL_MSG_STATS_GET_REPLY,
 
@@ -664,6 +668,19 @@ enum {
 	ETHTOOL_A_FEC_STAT_MAX = (__ETHTOOL_A_FEC_STAT_CNT - 1)
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
 /* MODULE EEPROM */
 
 enum {
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 723c9a8a8cdf..4b84b2d34c7a 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o fec.o eeprom.o stats.o
+		   tunnels.o fec.o preempt.o eeprom.o stats.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index f9dcbad84788..68d123dd500b 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -579,3 +579,28 @@ ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
 	link_ksettings->base.duplex = link_info->duplex;
 }
 EXPORT_SYMBOL_GPL(ethtool_params_from_link_mode);
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
index a7346346114f..f4e07b740790 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -246,6 +246,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_GET]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
+	[ETHTOOL_MSG_PREEMPT_GET]	= &ethnl_preempt_request_ops,
 	[ETHTOOL_MSG_MODULE_EEPROM_GET]	= &ethnl_module_eeprom_request_ops,
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
 };
@@ -561,6 +562,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_PAUSE_NTF]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_NTF]		= &ethnl_fec_request_ops,
+	[ETHTOOL_MSG_PREEMPT_NTF]	= &ethnl_preempt_request_ops,
 };
 
 /* default notification handler */
@@ -654,6 +656,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_PAUSE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_FEC_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_PREEMPT_NTF]	= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -958,6 +961,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_stats_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_stats_get_policy) - 1,
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
index 3e25a47fd482..cc90a463a81c 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -345,6 +345,7 @@ extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 extern const struct ethnl_request_ops ethnl_fec_request_ops;
+extern const struct ethnl_request_ops ethnl_preempt_request_ops;
 extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
 extern const struct ethnl_request_ops ethnl_stats_request_ops;
 
@@ -381,6 +382,8 @@ extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INF
 extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
 extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
 extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS + 1];
+extern const struct nla_policy ethnl_preempt_get_policy[ETHTOOL_A_PREEMPT_HEADER + 1];
+extern const struct nla_policy ethnl_preempt_set_policy[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE + 1];
 extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
@@ -400,6 +403,7 @@ int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info);
 int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_preempt(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
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
2.32.0

