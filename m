Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6420352E1C1
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344333AbiETBQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344287AbiETBP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:15:59 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940D12EA26
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653009357; x=1684545357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gS3QmrY8Ouj0uEw4FUK0Bv7IRhzbf1HjggXr/+kO/04=;
  b=NhWyyuNoAQRU266iUgXil0HmFvsdn324W1GIff2/aRcuqeZ2ypBa59RU
   gF4dKCoYenDW8BcuopZWY1IBTwf/2mqSB6niX/arZ1uX62EBm5P2g/o8j
   sJilZviBuJp/FAlYccplLvY8zBAondoUbryJ6vEGMZ+sD1f6ghgUoi4Fo
   /lW+/Pbin+05ef2qI2el5DmMlegfVkK+7OEpPGKvkWmAfI6jcqSmiuhj4
   +ljjzHQ/yWeMWjobIumqYQhqXj7BdFMmY2KTa7H+ne1bKAbeOZd6+0UVw
   i1pFUmGc4+pm0t3omSEGij4EmWK8111R4Excfh8kxYsYwwcGV69SmRitp
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="333064149"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="333064149"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570534535"
Received: from vcostago-mobl3.jf.intel.com ([10.24.14.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:53 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v5 01/11] ethtool: Add support for configuring frame preemption
Date:   Thu, 19 May 2022 18:15:28 -0700
Message-Id: <20220520011538.1098888-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220520011538.1098888-1-vinicius.gomes@intel.com>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frame preemption (described in IEEE 802.3-2018, Section 99 in
particular) defines the concept of preemptible and express queues. It
allows traffic from express queues to "interrupt" traffic from
preemptible queues, which are "resumed" after the express traffic has
finished transmitting.

Expose the UAPI bits for applications to enable using ethtool-netlink.
Also expose the kernel ethtool functions, so device drivers can
support it.

Frame preemption can only be used when both the local device and the
link partner support it.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 Documentation/networking/ethtool-netlink.rst |  52 ++++++
 include/linux/ethtool.h                      |  23 +++
 include/uapi/linux/ethtool_netlink.h         |  18 ++
 net/ethtool/Makefile                         |   3 +-
 net/ethtool/common.c                         |  23 +++
 net/ethtool/netlink.c                        |  19 ++
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/preempt.c                        | 177 +++++++++++++++++++
 8 files changed, 318 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/preempt.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index dbca3e9ec782..15d7c025cc4e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -220,6 +220,8 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET``       get PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_SET``            set transceiver module parameters
   ``ETHTOOL_MSG_MODULE_GET``            get transceiver module parameters
+  ``ETHTOOL_MSG_PREEMPT_GET``           get frame preemption parameters
+  ``ETHTOOL_MSG_PREEMPT_SET``           set frame preemption parameters
   ===================================== =================================
 
 Kernel to userspace:
@@ -260,6 +262,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_STATS_GET_REPLY``          standard statistics
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY``    PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
+  ``ETHTOOL_MSG_PREEMPT_GET_REPLY``        frame preemption parameters
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1625,6 +1628,53 @@ For SFF-8636 modules, low power mode is forced by the host according to table
 For CMIS modules, low power mode is forced by the host according to table 6-12
 in revision 5.0 of the specification.
 
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
+  ======================================  ======  ==========================
+  ``ETHTOOL_A_PREEMPT_HEADER``            nested  reply header
+  ``ETHTOOL_A_PREEMPT_ENABLED``           bool    frame preemption enabled
+  ``ETHTOOL_A_PREEMPT_PREEMPTIBLE_MASK``  bitset  preemptible queue mask
+  ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``     u32     Min additional frag size
+  ======================================  ======  ==========================
+
+``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE`` configures the minimum non-final
+fragment size that the receiver device supports.
+
+``ETHTOOL_A_PREEMPT_PREEMPTIBLE_MASK`` configures which queues should
+be marked as preemptible. If bit X is '1' then queue X is preemptible,
+the queue is express otherwise.
+
+PREEMPT_SET
+===========
+
+Sets frame preemption parameters.
+
+Request contents:
+
+  ======================================  ======  ==========================
+  ``ETHTOOL_A_PREEMPT_HEADER``            nested  reply header
+  ``ETHTOOL_A_PREEMPT_ENABLED``           bool    frame preemption enabled
+  ``ETHTOOL_A_PREEMPT_PREEMPTIBLE_MASK``  bitset  preemptible queue mask
+  ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``     u32     Min additional frag size
+  ======================================  ======  ==========================
+
+``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE`` configures the minimum non-final
+fragment size that the receiver device supports.
+
+``ETHTOOL_A_PREEMPT_PREEMPTIBLE_MASK`` configures which queues should be marked as
+preemptible.
+
 Request translation
 ===================
 
@@ -1726,4 +1776,6 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_PHC_VCLOCKS_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_SET``
+  n/a                                 ``ETHTOOL_MSG_PREEMPT_GET``
+  n/a                                 ``ETHTOOL_MSG_PREEMPT_SET``
   =================================== =====================================
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 99dc7bfbcd3c..42570ec8ee44 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -453,6 +453,20 @@ struct ethtool_module_power_mode_params {
 	enum ethtool_module_power_mode mode;
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
+	u32 enabled;
+	u32 preemptible_mask;
+	u32 add_frag_size;
+};
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @cap_link_lanes_supported: indicates if the driver supports lanes
@@ -606,6 +620,8 @@ struct ethtool_module_power_mode_params {
  *	not report statistics.
  * @get_fecparam: Get the network device Forward Error Correction parameters.
  * @set_fecparam: Set the network device Forward Error Correction parameters.
+ * @get_preempt: Get the network device Frame Preemption parameters.
+ * @set_preempt: Set the network device Frame Preemption parameters.
  * @get_ethtool_phy_stats: Return extended statistics about the PHY device.
  *	This is only useful if the device maintains PHY statistics and
  *	cannot use the standard PHY library helpers.
@@ -736,6 +752,10 @@ struct ethtool_ops {
 				      struct ethtool_fecparam *);
 	int	(*set_fecparam)(struct net_device *,
 				      struct ethtool_fecparam *);
+	int	(*get_preempt)(struct net_device *dev,
+			       struct ethtool_fp *fp);
+	int	(*set_preempt)(struct net_device *dev, struct ethtool_fp *fp,
+			       struct netlink_ext_ack *extack);
 	void	(*get_ethtool_phy_stats)(struct net_device *,
 					 struct ethtool_stats *, u64 *);
 	int	(*get_phy_tunable)(struct net_device *,
@@ -843,4 +863,7 @@ int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index);
  * next string.
  */
 extern __printf(2, 3) void ethtool_sprintf(u8 **data, const char *fmt, ...);
+
+u8 ethtool_frag_size_to_mult(u32 frag_size);
+
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d2fb4f7be61b..651c7af76776 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -49,6 +49,8 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET,
 	ETHTOOL_MSG_MODULE_GET,
 	ETHTOOL_MSG_MODULE_SET,
+	ETHTOOL_MSG_PREEMPT_GET,
+	ETHTOOL_MSG_PREEMPT_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -94,6 +96,8 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
+	ETHTOOL_MSG_PREEMPT_GET_REPLY,
+	ETHTOOL_MSG_PREEMPT_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -697,6 +701,20 @@ enum {
 	ETHTOOL_A_FEC_STAT_MAX = (__ETHTOOL_A_FEC_STAT_CNT - 1)
 };
 
+/* FRAME PREEMPTION */
+
+enum {
+	ETHTOOL_A_PREEMPT_UNSPEC,
+	ETHTOOL_A_PREEMPT_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_PREEMPT_ENABLED,			/* u8 */
+	ETHTOOL_A_PREEMPT_PREEMPTIBLE_MASK,		/* bitset */
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
index b76432e70e6b..c0ab048b46c9 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o
+		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
+		   preempt.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 566adf85e658..2232b8ef18b4 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -597,3 +597,26 @@ ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
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
+	return clamp_t(u8, mult, 0, 3);
+}
+EXPORT_SYMBOL_GPL(ethtool_frag_size_to_mult);
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 5fe8f4ae2ceb..66b35c35fcdb 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -282,6 +282,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_GET]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
+	[ETHTOOL_MSG_PREEMPT_GET]	= &ethnl_preempt_request_ops,
 	[ETHTOOL_MSG_MODULE_EEPROM_GET]	= &ethnl_module_eeprom_request_ops,
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
@@ -598,6 +599,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_NTF]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_MODULE_NTF]	= &ethnl_module_request_ops,
+	[ETHTOOL_MSG_PREEMPT_NTF]	= &ethnl_preempt_request_ops,
 };
 
 /* default notification handler */
@@ -691,6 +693,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_FEC_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_MODULE_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_PREEMPT_NTF]	= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -1020,6 +1023,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_module_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_module_set_policy) - 1,
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
index 7919ddb2371c..444799f3e91a 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -341,6 +341,7 @@ extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 extern const struct ethnl_request_ops ethnl_fec_request_ops;
+extern const struct ethnl_request_ops ethnl_preempt_request_ops;
 extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
 extern const struct ethnl_request_ops ethnl_stats_request_ops;
 extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
@@ -379,6 +380,8 @@ extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INF
 extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
 extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
 extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS + 1];
+extern const struct nla_policy ethnl_preempt_get_policy[ETHTOOL_A_PREEMPT_HEADER + 1];
+extern const struct nla_policy ethnl_preempt_set_policy[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE + 1];
 extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
 extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
 extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
@@ -402,6 +405,7 @@ int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_preempt(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
diff --git a/net/ethtool/preempt.c b/net/ethtool/preempt.c
new file mode 100644
index 000000000000..0000ba8cb90c
--- /dev/null
+++ b/net/ethtool/preempt.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "common.h"
+#include "netlink.h"
+#include "bitset.h"
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
+#define PREEMPT_QUEUES_COUNT \
+	(sizeof_field(struct ethtool_fp, preemptible_mask) * BITS_PER_BYTE)
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
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct preempt_reply_data *data = PREEMPT_REPDATA(reply_base);
+	const struct ethtool_fp *preempt = &data->fp;
+	int len = 0;
+	int ret;
+
+	ret = ethnl_bitset32_size(&preempt->preemptible_mask, NULL,
+				  PREEMPT_QUEUES_COUNT, NULL, compact);
+	if (ret < 0)
+		return ret;
+
+	len += ret;
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
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct preempt_reply_data *data = PREEMPT_REPDATA(reply_base);
+	const struct ethtool_fp *preempt = &data->fp;
+	int ret;
+
+	if (nla_put_u32(skb, ETHTOOL_A_PREEMPT_ENABLED, preempt->enabled))
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE,
+			preempt->add_frag_size))
+		return -EMSGSIZE;
+
+	ret = ethnl_put_bitset32(skb, ETHTOOL_A_PREEMPT_PREEMPTIBLE_MASK,
+				 &preempt->preemptible_mask, NULL, PREEMPT_QUEUES_COUNT,
+				 NULL, compact);
+	if (ret < 0)
+		return ret;
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
+	[ETHTOOL_A_PREEMPT_PREEMPTIBLE_MASK]		= { .type = NLA_NESTED },
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
+
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
+	ret = ethnl_update_bitset32(&preempt.preemptible_mask, PREEMPT_QUEUES_COUNT,
+				    tb[ETHTOOL_A_PREEMPT_PREEMPTIBLE_MASK],
+				    NULL, info->extack, &mod);
+	if (ret < 0)
+		goto out_ops;
+
+	ethnl_update_bool32(&preempt.enabled,
+			    tb[ETHTOOL_A_PREEMPT_ENABLED], &mod);
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
2.35.3

