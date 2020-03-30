Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6E61984A5
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgC3TjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:10 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:43439 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727936AbgC3TjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:09 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id EE7D5580545;
        Mon, 30 Mar 2020 15:39:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=pgnEx+85PcYYRM01IRFGLsbJ4WuOih2ZeAfVXRSYRAI=; b=wSuQZqqF
        nP9+V4GhbYVRAxhrOG+7KEWKPLfdbOyYd+1RGfUVHubQAtSC0TyhIkjoik/iMr7d
        X54jlkBje/C4OftmbtekE6udkHrt6ISAHs7VlltuZ9U4z+p0fcaci3XIs35BAWxe
        AM5uM+Lb7+8O6mTBZbX69O1gXxbYMOwdKKL3jAuXfkp1wtV0BQbJ+Ow4jlu1U2zz
        BDyoAulW8RYs7PeTDm8AlOw1q4KFE3zvPFqiBKDftNBv+hGavfr/Z/LbD/0SmJw1
        7YdxXZIzAtIEPfbMxQK2MHiF6Vw/OZsjWrM6+cUxH2UT9N9+PPwdkRcYSy5Up1Kp
        n1M6RbrAmVsOyA==
X-ME-Sender: <xms:20qCXjYFoelxKizyUufZLpDq_qIwxS2LQrDGWMawXg4-76hu-1o99w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:20qCXg25yJmog0YfQPI5vqqRhkCPOkmKRn0WReRZZVjp_nuXD8pAjA>
    <xmx:20qCXosDasvYaSCHyRqVfaTjRLJnaNM8omB4lVIh9gioHoqSlXoZiQ>
    <xmx:20qCXucp7QC-9RKdKFxRHkS1AL5oIzEevy8-CUVHkHVzn57EaZFulw>
    <xmx:20qCXjApo0peLs0r2qcSg2vTojr9QVWQUqjmFYDLMpZCO8Bt9fytag>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91870306CA49;
        Mon, 30 Mar 2020 15:39:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 01/15] devlink: Add packet trap policers support
Date:   Mon, 30 Mar 2020 22:38:18 +0300
Message-Id: <20200330193832.2359876-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Devices capable of offloading the kernel's datapath and perform
functions such as bridging and routing must also be able to send (trap)
specific packets to the kernel (i.e., the CPU) for processing.

For example, a device acting as a multicast-aware bridge must be able to
trap IGMP membership reports to the kernel for processing by the bridge
module.

In most cases, the underlying device is capable of handling packet rates
that are several orders of magnitude higher compared to those that can
be handled by the CPU.

Therefore, in order to prevent the underlying device from overwhelming
the CPU, devices usually include packet trap policers that are able to
police the trapped packets to rates that can be handled by the CPU.

This patch allows capable device drivers to register their supported
packet trap policers with devlink. User space can then tune the
parameters of these policer (currently, rate and burst size) and read
from the device the number of packets that were dropped by the policer,
if supported.

Subsequent patches in the series will allow device drivers to create
default binding between these policers and packet trap groups and allow
user space to change the binding.

v2:
* Add 'strict_start_type' in devlink policy
* Have device drivers provide max/min rate/burst size for each policer.
  Use them to check validity of user provided parameters

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h        |  76 +++++++
 include/uapi/linux/devlink.h |  11 +
 net/core/devlink.c           | 428 +++++++++++++++++++++++++++++++++++
 3 files changed, 515 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3f5cf62e4de8..9cd08fcfaff7 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -35,6 +35,7 @@ struct devlink {
 	struct devlink_dpipe_headers *dpipe_headers;
 	struct list_head trap_list;
 	struct list_head trap_group_list;
+	struct list_head trap_policer_list;
 	const struct devlink_ops *ops;
 	struct xarray snapshot_ids;
 	struct device *dev;
@@ -545,6 +546,29 @@ struct devlink_health_reporter_ops {
 			struct netlink_ext_ack *extack);
 };
 
+/**
+ * struct devlink_trap_policer - Immutable packet trap policer attributes.
+ * @id: Policer identifier.
+ * @init_rate: Initial rate in packets / sec.
+ * @init_burst: Initial burst size in packets.
+ * @max_rate: Maximum rate.
+ * @min_rate: Minimum rate.
+ * @max_burst: Maximum burst size.
+ * @min_burst: Minimum burst size.
+ *
+ * Describes immutable attributes of packet trap policers that drivers register
+ * with devlink.
+ */
+struct devlink_trap_policer {
+	u32 id;
+	u64 init_rate;
+	u64 init_burst;
+	u64 max_rate;
+	u64 min_rate;
+	u64 max_burst;
+	u64 min_burst;
+};
+
 /**
  * struct devlink_trap_group - Immutable packet trap group attributes.
  * @name: Trap group name.
@@ -742,6 +766,18 @@ enum devlink_trap_group_generic_id {
 		.generic = true,					      \
 	}
 
+#define DEVLINK_TRAP_POLICER(_id, _rate, _burst, _max_rate, _min_rate,	      \
+			     _max_burst, _min_burst)			      \
+	{								      \
+		.id = _id,						      \
+		.init_rate = _rate,					      \
+		.init_burst = _burst,					      \
+		.max_rate = _max_rate,					      \
+		.min_rate = _min_rate,					      \
+		.max_burst = _max_burst,				      \
+		.min_burst = _min_burst,				      \
+	}
+
 struct devlink_ops {
 	int (*reload_down)(struct devlink *devlink, bool netns_change,
 			   struct netlink_ext_ack *extack);
@@ -838,6 +874,38 @@ struct devlink_ops {
 	 */
 	int (*trap_group_init)(struct devlink *devlink,
 			       const struct devlink_trap_group *group);
+	/**
+	 * @trap_policer_init: Trap policer initialization function.
+	 *
+	 * Should be used by device drivers to initialize the trap policer in
+	 * the underlying device.
+	 */
+	int (*trap_policer_init)(struct devlink *devlink,
+				 const struct devlink_trap_policer *policer);
+	/**
+	 * @trap_policer_fini: Trap policer de-initialization function.
+	 *
+	 * Should be used by device drivers to de-initialize the trap policer
+	 * in the underlying device.
+	 */
+	void (*trap_policer_fini)(struct devlink *devlink,
+				  const struct devlink_trap_policer *policer);
+	/**
+	 * @trap_policer_set: Trap policer parameters set function.
+	 */
+	int (*trap_policer_set)(struct devlink *devlink,
+				const struct devlink_trap_policer *policer,
+				u64 rate, u64 burst,
+				struct netlink_ext_ack *extack);
+	/**
+	 * @trap_policer_counter_get: Trap policer counter get function.
+	 *
+	 * Should be used by device drivers to report number of packets dropped
+	 * by the policer.
+	 */
+	int (*trap_policer_counter_get)(struct devlink *devlink,
+					const struct devlink_trap_policer *policer,
+					u64 *p_drops);
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
@@ -1080,6 +1148,14 @@ int devlink_trap_groups_register(struct devlink *devlink,
 void devlink_trap_groups_unregister(struct devlink *devlink,
 				    const struct devlink_trap_group *groups,
 				    size_t groups_count);
+int
+devlink_trap_policers_register(struct devlink *devlink,
+			       const struct devlink_trap_policer *policers,
+			       size_t policers_count);
+void
+devlink_trap_policers_unregister(struct devlink *devlink,
+				 const struct devlink_trap_policer *policers,
+				 size_t policers_count);
 
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
 
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index e7891d1d2ebd..1ae90e06c06d 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -117,6 +117,11 @@ enum devlink_command {
 	DEVLINK_CMD_TRAP_GROUP_NEW,
 	DEVLINK_CMD_TRAP_GROUP_DEL,
 
+	DEVLINK_CMD_TRAP_POLICER_GET,	/* can dump */
+	DEVLINK_CMD_TRAP_POLICER_SET,
+	DEVLINK_CMD_TRAP_POLICER_NEW,
+	DEVLINK_CMD_TRAP_POLICER_DEL,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -217,6 +222,7 @@ enum devlink_param_reset_dev_on_drv_probe_value {
 enum {
 	DEVLINK_ATTR_STATS_RX_PACKETS,		/* u64 */
 	DEVLINK_ATTR_STATS_RX_BYTES,		/* u64 */
+	DEVLINK_ATTR_STATS_RX_DROPPED,		/* u64 */
 
 	__DEVLINK_ATTR_STATS_MAX,
 	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
@@ -431,6 +437,11 @@ enum devlink_attr {
 	DEVLINK_ATTR_NETNS_ID,			/* u32 */
 
 	DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,	/* u8 */
+
+	DEVLINK_ATTR_TRAP_POLICER_ID,			/* u32 */
+	DEVLINK_ATTR_TRAP_POLICER_RATE,			/* u64 */
+	DEVLINK_ATTR_TRAP_POLICER_BURST,		/* u64 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 85c7887356f6..e22b8ed67bf7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5719,6 +5719,23 @@ struct devlink_stats {
 	struct u64_stats_sync syncp;
 };
 
+/**
+ * struct devlink_trap_policer_item - Packet trap policer attributes.
+ * @policer: Immutable packet trap policer attributes.
+ * @rate: Rate in packets / sec.
+ * @burst: Burst size in packets.
+ * @list: trap_policer_list member.
+ *
+ * Describes packet trap policer attributes. Created by devlink during trap
+ * policer registration.
+ */
+struct devlink_trap_policer_item {
+	const struct devlink_trap_policer *policer;
+	u64 rate;
+	u64 burst;
+	struct list_head list;
+};
+
 /**
  * struct devlink_trap_group_item - Packet trap group attributes.
  * @group: Immutable packet trap group attributes.
@@ -5755,6 +5772,19 @@ struct devlink_trap_item {
 	void *priv;
 };
 
+static struct devlink_trap_policer_item *
+devlink_trap_policer_item_lookup(struct devlink *devlink, u32 id)
+{
+	struct devlink_trap_policer_item *policer_item;
+
+	list_for_each_entry(policer_item, &devlink->trap_policer_list, list) {
+		if (policer_item->policer->id == id)
+			return policer_item;
+	}
+
+	return NULL;
+}
+
 static struct devlink_trap_item *
 devlink_trap_item_lookup(struct devlink *devlink, const char *name)
 {
@@ -6292,7 +6322,245 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
 	return 0;
 }
 
+static struct devlink_trap_policer_item *
+devlink_trap_policer_item_get_from_info(struct devlink *devlink,
+					struct genl_info *info)
+{
+	u32 id;
+
+	if (!info->attrs[DEVLINK_ATTR_TRAP_POLICER_ID])
+		return NULL;
+	id = nla_get_u32(info->attrs[DEVLINK_ATTR_TRAP_POLICER_ID]);
+
+	return devlink_trap_policer_item_lookup(devlink, id);
+}
+
+static int
+devlink_trap_policer_stats_put(struct sk_buff *msg, struct devlink *devlink,
+			       const struct devlink_trap_policer *policer)
+{
+	struct nlattr *attr;
+	u64 drops;
+	int err;
+
+	if (!devlink->ops->trap_policer_counter_get)
+		return 0;
+
+	err = devlink->ops->trap_policer_counter_get(devlink, policer, &drops);
+	if (err)
+		return err;
+
+	attr = nla_nest_start(msg, DEVLINK_ATTR_STATS);
+	if (!attr)
+		return -EMSGSIZE;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_DROPPED, drops,
+			      DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, attr);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, attr);
+	return -EMSGSIZE;
+}
+
+static int
+devlink_nl_trap_policer_fill(struct sk_buff *msg, struct devlink *devlink,
+			     const struct devlink_trap_policer_item *policer_item,
+			     enum devlink_command cmd, u32 portid, u32 seq,
+			     int flags)
+{
+	void *hdr;
+	int err;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, DEVLINK_ATTR_TRAP_POLICER_ID,
+			policer_item->policer->id))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_TRAP_POLICER_RATE,
+			      policer_item->rate, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_TRAP_POLICER_BURST,
+			      policer_item->burst, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	err = devlink_trap_policer_stats_put(msg, devlink,
+					     policer_item->policer);
+	if (err)
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static int devlink_nl_cmd_trap_policer_get_doit(struct sk_buff *skb,
+						struct genl_info *info)
+{
+	struct devlink_trap_policer_item *policer_item;
+	struct netlink_ext_ack *extack = info->extack;
+	struct devlink *devlink = info->user_ptr[0];
+	struct sk_buff *msg;
+	int err;
+
+	if (list_empty(&devlink->trap_policer_list))
+		return -EOPNOTSUPP;
+
+	policer_item = devlink_trap_policer_item_get_from_info(devlink, info);
+	if (!policer_item) {
+		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
+		return -ENOENT;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_trap_policer_fill(msg, devlink, policer_item,
+					   DEVLINK_CMD_TRAP_POLICER_NEW,
+					   info->snd_portid, info->snd_seq, 0);
+	if (err)
+		goto err_trap_policer_fill;
+
+	return genlmsg_reply(msg, info);
+
+err_trap_policer_fill:
+	nlmsg_free(msg);
+	return err;
+}
+
+static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
+						  struct netlink_callback *cb)
+{
+	enum devlink_command cmd = DEVLINK_CMD_TRAP_POLICER_NEW;
+	struct devlink_trap_policer_item *policer_item;
+	u32 portid = NETLINK_CB(cb->skb).portid;
+	struct devlink *devlink;
+	int start = cb->args[0];
+	int idx = 0;
+	int err;
+
+	mutex_lock(&devlink_mutex);
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		mutex_lock(&devlink->lock);
+		list_for_each_entry(policer_item, &devlink->trap_policer_list,
+				    list) {
+			if (idx < start) {
+				idx++;
+				continue;
+			}
+			err = devlink_nl_trap_policer_fill(msg, devlink,
+							   policer_item, cmd,
+							   portid,
+							   cb->nlh->nlmsg_seq,
+							   NLM_F_MULTI);
+			if (err) {
+				mutex_unlock(&devlink->lock);
+				goto out;
+			}
+			idx++;
+		}
+		mutex_unlock(&devlink->lock);
+	}
+out:
+	mutex_unlock(&devlink_mutex);
+
+	cb->args[0] = idx;
+	return msg->len;
+}
+
+static int
+devlink_trap_policer_set(struct devlink *devlink,
+			 struct devlink_trap_policer_item *policer_item,
+			 struct genl_info *info)
+{
+	struct netlink_ext_ack *extack = info->extack;
+	struct nlattr **attrs = info->attrs;
+	u64 rate, burst;
+	int err;
+
+	rate = policer_item->rate;
+	burst = policer_item->burst;
+
+	if (attrs[DEVLINK_ATTR_TRAP_POLICER_RATE])
+		rate = nla_get_u64(attrs[DEVLINK_ATTR_TRAP_POLICER_RATE]);
+
+	if (attrs[DEVLINK_ATTR_TRAP_POLICER_BURST])
+		burst = nla_get_u64(attrs[DEVLINK_ATTR_TRAP_POLICER_BURST]);
+
+	if (rate < policer_item->policer->min_rate) {
+		NL_SET_ERR_MSG_MOD(extack, "Policer rate lower than limit");
+		return -EINVAL;
+	}
+
+	if (rate > policer_item->policer->max_rate) {
+		NL_SET_ERR_MSG_MOD(extack, "Policer rate higher than limit");
+		return -EINVAL;
+	}
+
+	if (burst < policer_item->policer->min_burst) {
+		NL_SET_ERR_MSG_MOD(extack, "Policer burst size lower than limit");
+		return -EINVAL;
+	}
+
+	if (burst > policer_item->policer->max_burst) {
+		NL_SET_ERR_MSG_MOD(extack, "Policer burst size higher than limit");
+		return -EINVAL;
+	}
+
+	err = devlink->ops->trap_policer_set(devlink, policer_item->policer,
+					     rate, burst, info->extack);
+	if (err)
+		return err;
+
+	policer_item->rate = rate;
+	policer_item->burst = burst;
+
+	return 0;
+}
+
+static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
+						struct genl_info *info)
+{
+	struct devlink_trap_policer_item *policer_item;
+	struct netlink_ext_ack *extack = info->extack;
+	struct devlink *devlink = info->user_ptr[0];
+
+	if (list_empty(&devlink->trap_policer_list))
+		return -EOPNOTSUPP;
+
+	if (!devlink->ops->trap_policer_set)
+		return -EOPNOTSUPP;
+
+	policer_item = devlink_trap_policer_item_get_from_info(devlink, info);
+	if (!policer_item) {
+		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
+		return -ENOENT;
+	}
+
+	return devlink_trap_policer_set(devlink, policer_item, info);
+}
+
 static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
+	[DEVLINK_ATTR_UNSPEC] = { .strict_start_type =
+		DEVLINK_ATTR_TRAP_POLICER_ID },
 	[DEVLINK_ATTR_BUS_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_DEV_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_PORT_INDEX] = { .type = NLA_U32 },
@@ -6331,6 +6599,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_TRAP_POLICER_ID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -6666,6 +6937,19 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
+	{
+		.cmd = DEVLINK_CMD_TRAP_POLICER_GET,
+		.doit = devlink_nl_cmd_trap_policer_get_doit,
+		.dumpit = devlink_nl_cmd_trap_policer_get_dumpit,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = DEVLINK_CMD_TRAP_POLICER_SET,
+		.doit = devlink_nl_cmd_trap_policer_set_doit,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
+	},
 };
 
 static struct genl_family devlink_nl_family __ro_after_init = {
@@ -6714,6 +6998,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	INIT_LIST_HEAD(&devlink->reporter_list);
 	INIT_LIST_HEAD(&devlink->trap_list);
 	INIT_LIST_HEAD(&devlink->trap_group_list);
+	INIT_LIST_HEAD(&devlink->trap_policer_list);
 	mutex_init(&devlink->lock);
 	mutex_init(&devlink->reporters_lock);
 	return devlink;
@@ -6798,6 +7083,7 @@ void devlink_free(struct devlink *devlink)
 {
 	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
+	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
 	WARN_ON(!list_empty(&devlink->trap_list));
 	WARN_ON(!list_empty(&devlink->reporter_list));
@@ -8589,6 +8875,148 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_unregister);
 
+static void
+devlink_trap_policer_notify(struct devlink *devlink,
+			    const struct devlink_trap_policer_item *policer_item,
+			    enum devlink_command cmd)
+{
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON_ONCE(cmd != DEVLINK_CMD_TRAP_POLICER_NEW &&
+		     cmd != DEVLINK_CMD_TRAP_POLICER_DEL);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_trap_policer_fill(msg, devlink, policer_item, cmd, 0,
+					   0, 0);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
+static int
+devlink_trap_policer_register(struct devlink *devlink,
+			      const struct devlink_trap_policer *policer)
+{
+	struct devlink_trap_policer_item *policer_item;
+	int err;
+
+	if (devlink_trap_policer_item_lookup(devlink, policer->id))
+		return -EEXIST;
+
+	policer_item = kzalloc(sizeof(*policer_item), GFP_KERNEL);
+	if (!policer_item)
+		return -ENOMEM;
+
+	policer_item->policer = policer;
+	policer_item->rate = policer->init_rate;
+	policer_item->burst = policer->init_burst;
+
+	if (devlink->ops->trap_policer_init) {
+		err = devlink->ops->trap_policer_init(devlink, policer);
+		if (err)
+			goto err_policer_init;
+	}
+
+	list_add_tail(&policer_item->list, &devlink->trap_policer_list);
+	devlink_trap_policer_notify(devlink, policer_item,
+				    DEVLINK_CMD_TRAP_POLICER_NEW);
+
+	return 0;
+
+err_policer_init:
+	kfree(policer_item);
+	return err;
+}
+
+static void
+devlink_trap_policer_unregister(struct devlink *devlink,
+				const struct devlink_trap_policer *policer)
+{
+	struct devlink_trap_policer_item *policer_item;
+
+	policer_item = devlink_trap_policer_item_lookup(devlink, policer->id);
+	if (WARN_ON_ONCE(!policer_item))
+		return;
+
+	devlink_trap_policer_notify(devlink, policer_item,
+				    DEVLINK_CMD_TRAP_POLICER_DEL);
+	list_del(&policer_item->list);
+	if (devlink->ops->trap_policer_fini)
+		devlink->ops->trap_policer_fini(devlink, policer);
+	kfree(policer_item);
+}
+
+/**
+ * devlink_trap_policers_register - Register packet trap policers with devlink.
+ * @devlink: devlink.
+ * @policers: Packet trap policers.
+ * @policers_count: Count of provided packet trap policers.
+ *
+ * Return: Non-zero value on failure.
+ */
+int
+devlink_trap_policers_register(struct devlink *devlink,
+			       const struct devlink_trap_policer *policers,
+			       size_t policers_count)
+{
+	int i, err;
+
+	mutex_lock(&devlink->lock);
+	for (i = 0; i < policers_count; i++) {
+		const struct devlink_trap_policer *policer = &policers[i];
+
+		if (WARN_ON(policer->id == 0 ||
+			    policer->max_rate < policer->min_rate ||
+			    policer->max_burst < policer->min_burst)) {
+			err = -EINVAL;
+			goto err_trap_policer_verify;
+		}
+
+		err = devlink_trap_policer_register(devlink, policer);
+		if (err)
+			goto err_trap_policer_register;
+	}
+	mutex_unlock(&devlink->lock);
+
+	return 0;
+
+err_trap_policer_register:
+err_trap_policer_verify:
+	for (i--; i >= 0; i--)
+		devlink_trap_policer_unregister(devlink, &policers[i]);
+	mutex_unlock(&devlink->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
+
+/**
+ * devlink_trap_policers_unregister - Unregister packet trap policers from devlink.
+ * @devlink: devlink.
+ * @policers: Packet trap policers.
+ * @policers_count: Count of provided packet trap policers.
+ */
+void
+devlink_trap_policers_unregister(struct devlink *devlink,
+				 const struct devlink_trap_policer *policers,
+				 size_t policers_count)
+{
+	int i;
+
+	mutex_lock(&devlink->lock);
+	for (i = policers_count - 1; i >= 0; i--)
+		devlink_trap_policer_unregister(devlink, &policers[i]);
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
+
 static void __devlink_compat_running_version(struct devlink *devlink,
 					     char *buf, size_t len)
 {
-- 
2.24.1

