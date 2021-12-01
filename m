Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6AF46550E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243657AbhLASUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:20:39 -0500
Received: from mga04.intel.com ([192.55.52.120]:40342 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352042AbhLASUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 13:20:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="235250493"
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="235250493"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 10:17:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="460124643"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by orsmga006.jf.intel.com with ESMTP; 01 Dec 2021 10:17:10 -0800
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, arkadiusz.kubalewski@intel.com
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com,
        petrm@nvidia.com
Subject: [PATCH v4 net-next 2/4] ethtool: Add ability to configure recovered clock for SyncE feature
Date:   Wed,  1 Dec 2021 19:02:06 +0100
Message-Id: <20211201180208.640179-3-maciej.machnikowski@intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20211201180208.640179-1-maciej.machnikowski@intel.com>
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add netlink ethtool messages:
- ETHTOOL_MSG_RCLK_GET
- ETHTOOL_MSG_RCLK_SET
Required for controling basic SyncE functionality - configuration of
recovered reference clocks from PHY port on netdevice supporting SyncE.

- ETHTOOL_MSG_RCLK_GET - will read the current state if pin index is
			given or will return allowed range if it's not

- ETHTOOL_MSG_RCLK_SET - will configure given recovered clock pin to
			output recovered clock

Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
---
 Documentation/networking/ethtool-netlink.rst |  67 +++++
 include/linux/ethtool.h                      |   9 +
 include/uapi/linux/ethtool_netlink.h         |  21 ++
 net/ethtool/Makefile                         |   3 +-
 net/ethtool/netlink.c                        |  20 ++
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/synce.c                          | 267 +++++++++++++++++++
 7 files changed, 390 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/synce.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 9d98e0511249..51db9338785a 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -220,6 +220,8 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET``       get PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_SET``            set transceiver module parameters
   ``ETHTOOL_MSG_MODULE_GET``            get transceiver module parameters
+  ``ETHTOOL_RCLK_GET``                  get recovered clock parameters
+  ``ETHTOOL_RCLK_SET``                  set recovered clock parameters
   ===================================== =================================
 
 Kernel to userspace:
@@ -260,6 +262,8 @@ Kernel to userspace:
   ``ETHTOOL_MSG_STATS_GET_REPLY``          standard statistics
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY``    PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
+  ``ETHTOOL_MSG_RCLK_GET_REPLY``           reference recovered clock config
+  ``ETHTOOL_MSG_RCLK_NTF``                 reference recovered clock config
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1598,6 +1602,67 @@ For SFF-8636 modules, low power mode is forced by the host according to table
 For CMIS modules, low power mode is forced by the host according to table 6-12
 in revision 5.0 of the specification.
 
+RCLK_GET
+========
+
+Get status of an output pin for PHY recovered frequency clock.
+
+Request contents:
+
+  ======================================  ======  ==========================
+  ``ETHTOOL_A_RCLK_HEADER``               nested  request header
+  ``ETHTOOL_A_RCLK_OUT_PIN_IDX``          u32     index of a pin
+  ======================================  ======  ==========================
+
+Kernel response contents:
+
+  ======================================  ======  ==========================
+  ``ETHTOOL_A_RCLK_OUT_PIN_IDX``          u32     index of a pin
+  ``ETHTOOL_A_RCLK_PIN_FLAGS``            u32     state of a pin
+  ``ETHTOOL_A_RCLK_RANGE_MIN_PIN``        u32     min index of RCLK pins
+  ``ETHTOOL_A_RCLK_RANGE_MAX_PIN``        u32     max index of RCLK pins
+  ======================================  ======  ==========================
+
+Supported device can have mulitple reference recover clock pins available
+to be used as source of frequency for a DPLL.
+Once a pin on given port is enabled. The PHY recovered frequency is being
+fed onto that pin, and can be used by DPLL to synchonize with its signal.
+Pins don't have to start with index equal 0 - device can also have different
+external sources pins.
+
+The ``ETHTOOL_A_RCLK_OUT_PIN_IDX`` is optional parameter. If present in
+the RCLK_GET request, the ``ETHTOOL_A_RCLK_PIN_ENABLED`` is provided in a
+response, it contatins state of the pin pointed by the index. Values are:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_rclk_pin_state
+
+If ``ETHTOOL_A_RCLK_OUT_PIN_IDX`` is not present in the RCLK_GET request,
+the range of available pins is returned:
+``ETHTOOL_A_RCLK_RANGE_MIN_PIN`` is lowest possible index of a pin available
+for recovering frequency from PHY.
+``ETHTOOL_A_RCLK_RANGE_MAX_PIN`` is highest possible index of a pin available
+for recovering frequency from PHY.
+
+RCLK_SET
+==========
+
+Set status of an output pin for PHY recovered frequency clock.
+
+Request contents:
+
+  ======================================  ======  ========================
+  ``ETHTOOL_A_RCLK_HEADER``               nested  request header
+  ``ETHTOOL_A_RCLK_OUT_PIN_IDX``          u32     index of a pin
+  ``ETHTOOL_A_RCLK_PIN_FLAGS``            u32      requested state
+  ======================================  ======  ========================
+
+``ETHTOOL_A_RCLK_OUT_PIN_IDX`` is a index of a pin for which the change of
+state is requested. Values of ``ETHTOOL_A_RCLK_PIN_ENABLED`` are:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_rclk_pin_state
+
 Request translation
 ===================
 
@@ -1699,4 +1764,6 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_PHC_VCLOCKS_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_SET``
+  n/a                                 ``ETHTOOL_MSG_RCLK_GET``
+  n/a                                 ``ETHTOOL_MSG_RCLK_SET``
   =================================== =====================================
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index a26f37a27167..e344e5153f9b 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -614,6 +614,9 @@ struct ethtool_module_power_mode_params {
  *	plugged-in.
  * @set_module_power_mode: Set the power mode policy for the plug-in module
  *	used by the network device.
+ * @get_rclk_range: Get range of valid Reference Clock input pins for the port.
+ * @get_rclk_state: Get state of Reference Clock input signal pin.
+ * @set_rclk_out: Enable/disable Reference Clock input signal pin.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -750,6 +753,12 @@ struct ethtool_ops {
 	int	(*set_module_power_mode)(struct net_device *dev,
 					 const struct ethtool_module_power_mode_params *params,
 					 struct netlink_ext_ack *extack);
+	int	(*get_rclk_range)(struct net_device *dev, u32 *min_idx,
+				  u32 *max_idx, struct netlink_ext_ack *extack);
+	int	(*get_rclk_state)(struct net_device *dev, u32 out_idx,
+				  bool *ena, struct netlink_ext_ack *extack);
+	int	(*set_rclk_out)(struct net_device *dev, u32 out_idx, bool ena,
+				struct netlink_ext_ack *extack);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index cca6e474a085..9a860f052a36 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -49,6 +49,8 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET,
 	ETHTOOL_MSG_MODULE_GET,
 	ETHTOOL_MSG_MODULE_SET,
+	ETHTOOL_MSG_RCLK_GET,
+	ETHTOOL_MSG_RCLK_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -94,6 +96,8 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
+	ETHTOOL_MSG_RCLK_GET_REPLY,
+	ETHTOOL_MSG_RCLK_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -853,6 +857,23 @@ enum {
 	ETHTOOL_A_MODULE_MAX = (__ETHTOOL_A_MODULE_CNT - 1)
 };
 
+/* REF CLK */
+
+enum {
+	ETHTOOL_A_RCLK_UNSPEC,
+	ETHTOOL_A_RCLK_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_RCLK_OUT_PIN_IDX,	/* u32 */
+	ETHTOOL_A_RCLK_PIN_FLAGS,	/* u32 */
+	ETHTOOL_A_RCLK_PIN_MIN,		/* u32 */
+	ETHTOOL_A_RCLK_PIN_MAX,		/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_RCLK_CNT,
+	ETHTOOL_A_RCLK_MAX = (__ETHTOOL_A_RCLK_CNT - 1)
+};
+
+#define ETHTOOL_RCLK_PIN_FLAGS_ENA	(1 << 0)
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index b76432e70e6b..dd6de311a9c2 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o
+		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
+		   synce.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 38b44c0291b1..76ee82c687fe 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -283,6 +283,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
 	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
+	[ETHTOOL_MSG_RCLK_GET]		= &ethnl_rclk_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -595,6 +596,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_NTF]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_MODULE_NTF]	= &ethnl_module_request_ops,
+	[ETHTOOL_MSG_RCLK_NTF]		= &ethnl_rclk_request_ops,
 };
 
 /* default notification handler */
@@ -689,6 +691,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_FEC_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_MODULE_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_RCLK_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -1018,6 +1021,23 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_module_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_module_set_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_RCLK_GET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_rclk_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_rclk_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_RCLK_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_rclk,
+		.policy = ethnl_rclk_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_rclk_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 490598e5eedd..bdeb559f0db7 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -338,6 +338,7 @@ extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
 extern const struct ethnl_request_ops ethnl_stats_request_ops;
 extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
 extern const struct ethnl_request_ops ethnl_module_request_ops;
+extern const struct ethnl_request_ops ethnl_rclk_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -376,6 +377,8 @@ extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1
 extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
 extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
+extern const struct nla_policy ethnl_rclk_get_policy[ETHTOOL_A_RCLK_OUT_PIN_IDX + 1];
+extern const struct nla_policy ethnl_rclk_set_policy[ETHTOOL_A_RCLK_PIN_FLAGS + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -395,6 +398,7 @@ int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_rclk(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
diff --git a/net/ethtool/synce.c b/net/ethtool/synce.c
new file mode 100644
index 000000000000..f4ebb4c57d4d
--- /dev/null
+++ b/net/ethtool/synce.c
@@ -0,0 +1,267 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/ethtool.h>
+#include "netlink.h"
+
+struct rclk_out_pin_info {
+	u32 idx;
+	bool valid;
+};
+
+struct rclk_request_data {
+	struct ethnl_req_info base;
+	struct rclk_out_pin_info out_pin;
+};
+
+struct rclk_pin_state_info {
+	u32 range_min;
+	u32 range_max;
+	u32 flags;
+	u32 idx;
+};
+
+struct rclk_reply_data {
+	struct ethnl_reply_data	base;
+	struct rclk_pin_state_info pin_state;
+};
+
+#define RCLK_REPDATA(__reply_base) \
+	container_of(__reply_base, struct rclk_reply_data, base)
+
+#define RCLK_REQDATA(__req_base) \
+	container_of(__req_base, struct rclk_request_data, base)
+
+/* RCLK_GET */
+
+const struct nla_policy
+ethnl_rclk_get_policy[ETHTOOL_A_RCLK_OUT_PIN_IDX + 1] = {
+	[ETHTOOL_A_RCLK_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_RCLK_OUT_PIN_IDX] = { .type = NLA_U32 },
+};
+
+static int rclk_parse_request(struct ethnl_req_info *req_base,
+			      struct nlattr **tb,
+			      struct netlink_ext_ack *extack)
+{
+	struct rclk_request_data *req = RCLK_REQDATA(req_base);
+
+	if (tb[ETHTOOL_A_RCLK_OUT_PIN_IDX]) {
+		req->out_pin.idx = nla_get_u32(tb[ETHTOOL_A_RCLK_OUT_PIN_IDX]);
+		req->out_pin.valid = true;
+	}
+
+	return 0;
+}
+
+static int rclk_state_get(struct net_device *dev,
+			  struct rclk_reply_data *data,
+			  struct netlink_ext_ack *extack,
+			  u32 out_idx)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	bool pin_state;
+	int ret;
+
+	if (!ops->get_rclk_state)
+		return -EOPNOTSUPP;
+
+	ret = ops->get_rclk_state(dev, out_idx, &pin_state, extack);
+	if (ret)
+		return ret;
+
+	data->pin_state.flags = pin_state ? ETHTOOL_RCLK_PIN_FLAGS_ENA : 0;
+	data->pin_state.idx = out_idx;
+
+	return ret;
+}
+
+static int rclk_range_get(struct net_device *dev,
+			  struct rclk_reply_data *data,
+			  struct netlink_ext_ack *extack)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	u32 min_idx, max_idx;
+	int ret;
+
+	if (!ops->get_rclk_range)
+		return -EOPNOTSUPP;
+
+	ret = ops->get_rclk_range(dev, &min_idx, &max_idx, extack);
+	if (ret)
+		return ret;
+
+	data->pin_state.range_min = min_idx;
+	data->pin_state.range_max = max_idx;
+
+	return ret;
+}
+
+static int rclk_prepare_data(const struct ethnl_req_info *req_base,
+			     struct ethnl_reply_data *reply_base,
+			     struct genl_info *info)
+{
+	struct rclk_reply_data *reply = RCLK_REPDATA(reply_base);
+	struct rclk_request_data *request = RCLK_REQDATA(req_base);
+	struct netlink_ext_ack *extack = info ? info->extack : NULL;
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	memset(&reply->pin_state, 0, sizeof(reply->pin_state));
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	if (request->out_pin.valid)
+		ret = rclk_state_get(dev, reply, extack,
+				     request->out_pin.idx);
+	else
+		ret = rclk_range_get(dev, reply, extack);
+
+	ethnl_ops_complete(dev);
+
+	return ret;
+}
+
+static int rclk_fill_reply(struct sk_buff *skb,
+			   const struct ethnl_req_info *req_base,
+			   const struct ethnl_reply_data *reply_base)
+{
+	const struct rclk_reply_data *reply = RCLK_REPDATA(reply_base);
+	const struct rclk_request_data *request = RCLK_REQDATA(req_base);
+
+	if (request->out_pin.valid) {
+		if (nla_put_u32(skb, ETHTOOL_A_RCLK_PIN_FLAGS,
+				reply->pin_state.flags))
+			return -EMSGSIZE;
+		if (nla_put_u32(skb, ETHTOOL_A_RCLK_OUT_PIN_IDX,
+				reply->pin_state.idx))
+			return -EMSGSIZE;
+	} else {
+		if (nla_put_u32(skb, ETHTOOL_A_RCLK_PIN_MIN,
+				reply->pin_state.range_min))
+			return -EMSGSIZE;
+		if (nla_put_u32(skb, ETHTOOL_A_RCLK_PIN_MAX,
+				reply->pin_state.range_max))
+			return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
+static int rclk_reply_size(const struct ethnl_req_info *req_base,
+			   const struct ethnl_reply_data *reply_base)
+{
+	const struct rclk_request_data *request = RCLK_REQDATA(req_base);
+
+	if (request->out_pin.valid)
+		return nla_total_size(sizeof(u32)) +	/* ETHTOOL_A_RCLK_PIN_FLAGS */
+		       nla_total_size(sizeof(u32));	/* ETHTOOL_A_RCLK_OUT_PIN_IDX */
+	else
+		return nla_total_size(sizeof(u32)) +	/* ETHTOOL_A_RCLK_PIN_MIN */
+		       nla_total_size(sizeof(u32));	/* ETHTOOL_A_RCLK_PIN_MAX */
+}
+
+const struct ethnl_request_ops ethnl_rclk_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_RCLK_GET,
+	.reply_cmd		= ETHTOOL_MSG_RCLK_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_RCLK_HEADER,
+	.req_info_size		= sizeof(struct rclk_request_data),
+	.reply_data_size	= sizeof(struct rclk_reply_data),
+
+	.parse_request		= rclk_parse_request,
+	.prepare_data		= rclk_prepare_data,
+	.reply_size		= rclk_reply_size,
+	.fill_reply		= rclk_fill_reply,
+};
+
+/* RCLK SET */
+
+const struct nla_policy
+ethnl_rclk_set_policy[ETHTOOL_A_RCLK_PIN_FLAGS + 1] = {
+	[ETHTOOL_A_RCLK_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_RCLK_OUT_PIN_IDX] = { .type = NLA_U32 },
+	[ETHTOOL_A_RCLK_PIN_FLAGS] = { .type = NLA_U32 },
+};
+
+static int rclk_set_state(struct net_device *dev, struct nlattr **tb,
+			  bool *p_mod, struct netlink_ext_ack *extack)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	bool old_state, new_state;
+	u32 min_idx, max_idx;
+	u32 out_idx;
+	int ret;
+
+	if (!tb[ETHTOOL_A_RCLK_PIN_FLAGS] &&
+	    !tb[ETHTOOL_A_RCLK_OUT_PIN_IDX])
+		return 0;
+
+	if (!ops->set_rclk_out || !ops->get_rclk_range) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[ETHTOOL_A_RCLK_PIN_FLAGS],
+				    "Setting recovered clock state is not supported by this device");
+		return -EOPNOTSUPP;
+	}
+
+	ret = ops->get_rclk_range(dev, &min_idx, &max_idx, extack);
+	if (ret)
+		return ret;
+
+	out_idx = nla_get_u32(tb[ETHTOOL_A_RCLK_OUT_PIN_IDX]);
+	if (out_idx < min_idx || out_idx > max_idx) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[ETHTOOL_A_RCLK_OUT_PIN_IDX],
+				    "Requested recovered clock pin index is out of range");
+		return -EINVAL;
+	}
+
+	ret = ops->get_rclk_state(dev, out_idx, &old_state, extack);
+	if (ret < 0)
+		return ret;
+
+	new_state = !!(nla_get_u32(tb[ETHTOOL_A_RCLK_PIN_FLAGS]) &
+		       ETHTOOL_RCLK_PIN_FLAGS_ENA);
+
+	/* If state changed - flag need for sending the notification */
+	*p_mod = old_state != new_state;
+
+	return ops->set_rclk_out(dev, out_idx, new_state, extack);
+}
+
+int ethnl_set_rclk(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_RCLK_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = rclk_set_state(dev, tb, &mod, info->extack);
+	if (ret < 0)
+		goto out_ops;
+
+	if (!mod)
+		goto out_ops;
+
+	ethtool_notify(dev, ETHTOOL_MSG_RCLK_NTF, NULL);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
+
-- 
2.26.3

