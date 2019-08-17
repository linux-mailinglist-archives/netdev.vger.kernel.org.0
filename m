Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00059108D
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfHQNak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:30:40 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:48121 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbfHQNaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:30:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 411E720DE;
        Sat, 17 Aug 2019 09:30:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=OzB96tySEXXmx8dIO4JUAiKd5PAuQdYgAw17S9g2t4M=; b=q2tUHpm0
        PVmm0wFnyh6+SEb+5bz3d89ENBhU18jSLnFoZBJHucWdOjlBt4Dg8lrVyOxPAhnL
        DlPMO+l/obFoPXEvMGEouWwxUiSIR9SPs8wSyAzjx8nR4ipA/MlVoWtdVxgxWEh9
        41UIAeu7oAKxx+J2cVRyq4d+VBRG5sxooL0+hJEauwu5M4xFqNuUeQPhGIliq+My
        AualXvtmJxhH/IlwUreWVZgAVlXyHonZIXX3ac3jx/UNhwB7YFf7S7yV5A79hNJv
        Cm8TLkcVgrcHHnR19k1j5ubVrGteZkzMyrGYhLRB57cjuD+MLsRiyiI+hp/Y/gmN
        tQhfA1rA+U1DCg==
X-ME-Sender: <xms:fwFYXRFk6PktGOYaQ2sDLDagtFuRu-qVQgTkoiU8gpJGAS-bgwnItw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejjedrvddurddukedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgephe
X-ME-Proxy: <xmx:fwFYXcZwQHTTJgJtqYAYqC8ivHhZ4D0SqGVKdct4BLZlfJ9JSK22FA>
    <xmx:fwFYXWZJ049ITc7K2EnqDtYf30aUPObATJmsun2Y_NKfbryamLooBw>
    <xmx:fwFYXfN7ll682kspcvVaqij9nJXMsezMZFPCkp-9FLwIHdaSwWeNZw>
    <xmx:fwFYXZ6misAw8n9UF6YUx1YxmERXn7wCLbbmOHv2SRV1gGQt7ghSvw>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 684AA8005B;
        Sat, 17 Aug 2019 09:30:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 07/16] drop_monitor: Allow user to start monitoring hardware drops
Date:   Sat, 17 Aug 2019 16:28:16 +0300
Message-Id: <20190817132825.29790-8-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817132825.29790-1-idosch@idosch.org>
References: <20190817132825.29790-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Drop monitor has start and stop commands, but so far these were only
used to start and stop monitoring of software drops.

Now that drop monitor can also monitor hardware drops, we should allow
the user to control these as well.

Do that by adding SW and HW flags to these commands. If no flag is
specified, then only start / stop monitoring software drops. This is
done in order to maintain backward-compatibility with existing user
space applications.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/net_dropmon.h |   2 +
 net/core/drop_monitor.c          | 124 ++++++++++++++++++++++++++++++-
 2 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 3bddc9ec978c..75a35dccb675 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -90,6 +90,8 @@ enum net_dm_attr {
 	NET_DM_ATTR_HW_ENTRIES,			/* nested */
 	NET_DM_ATTR_HW_ENTRY,			/* nested */
 	NET_DM_ATTR_HW_TRAP_COUNT,		/* u32 */
+	NET_DM_ATTR_SW_DROPS,			/* flag */
+	NET_DM_ATTR_HW_DROPS,			/* flag */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 807c79d606aa..bfc024024aa3 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -952,13 +952,82 @@ static const struct net_dm_alert_ops *net_dm_alert_ops_arr[] = {
 void net_dm_hw_report(struct sk_buff *skb,
 		      const struct net_dm_hw_metadata *hw_metadata)
 {
+	rcu_read_lock();
+
 	if (!monitor_hw)
-		return;
+		goto out;
 
 	net_dm_alert_ops_arr[net_dm_alert_mode]->hw_probe(skb, hw_metadata);
+
+out:
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(net_dm_hw_report);
 
+static int net_dm_hw_monitor_start(struct netlink_ext_ack *extack)
+{
+	const struct net_dm_alert_ops *ops;
+	int cpu;
+
+	if (monitor_hw) {
+		NL_SET_ERR_MSG_MOD(extack, "Hardware monitoring already enabled");
+		return -EAGAIN;
+	}
+
+	ops = net_dm_alert_ops_arr[net_dm_alert_mode];
+
+	if (!try_module_get(THIS_MODULE)) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to take reference on module");
+		return -ENODEV;
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
+		struct net_dm_hw_entries *hw_entries;
+
+		INIT_WORK(&hw_data->dm_alert_work, ops->hw_work_item_func);
+		timer_setup(&hw_data->send_timer, sched_send_work, 0);
+		hw_entries = net_dm_hw_reset_per_cpu_data(hw_data);
+		kfree(hw_entries);
+	}
+
+	monitor_hw = true;
+
+	return 0;
+}
+
+static void net_dm_hw_monitor_stop(struct netlink_ext_ack *extack)
+{
+	int cpu;
+
+	if (!monitor_hw)
+		NL_SET_ERR_MSG_MOD(extack, "Hardware monitoring already disabled");
+
+	monitor_hw = false;
+
+	/* After this call returns we are guaranteed that no CPU is processing
+	 * any hardware drops.
+	 */
+	synchronize_rcu();
+
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
+		struct sk_buff *skb;
+
+		del_timer_sync(&hw_data->send_timer);
+		cancel_work_sync(&hw_data->dm_alert_work);
+		while ((skb = __skb_dequeue(&hw_data->drop_queue))) {
+			struct net_dm_hw_metadata *hw_metadata;
+
+			hw_metadata = NET_DM_SKB_CB(skb)->hw_metadata;
+			net_dm_hw_metadata_free(hw_metadata);
+			consume_skb(skb);
+		}
+	}
+
+	module_put(THIS_MODULE);
+}
+
 static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 {
 	const struct net_dm_alert_ops *ops;
@@ -1153,14 +1222,61 @@ static int net_dm_cmd_config(struct sk_buff *skb,
 	return 0;
 }
 
+static int net_dm_monitor_start(bool set_sw, bool set_hw,
+				struct netlink_ext_ack *extack)
+{
+	bool sw_set = false;
+	int rc;
+
+	if (set_sw) {
+		rc = set_all_monitor_traces(TRACE_ON, extack);
+		if (rc)
+			return rc;
+		sw_set = true;
+	}
+
+	if (set_hw) {
+		rc = net_dm_hw_monitor_start(extack);
+		if (rc)
+			goto err_monitor_hw;
+	}
+
+	return 0;
+
+err_monitor_hw:
+	if (sw_set)
+		set_all_monitor_traces(TRACE_OFF, extack);
+	return rc;
+}
+
+static void net_dm_monitor_stop(bool set_sw, bool set_hw,
+				struct netlink_ext_ack *extack)
+{
+	if (set_hw)
+		net_dm_hw_monitor_stop(extack);
+	if (set_sw)
+		set_all_monitor_traces(TRACE_OFF, extack);
+}
+
 static int net_dm_cmd_trace(struct sk_buff *skb,
 			struct genl_info *info)
 {
+	bool set_sw = !!info->attrs[NET_DM_ATTR_SW_DROPS];
+	bool set_hw = !!info->attrs[NET_DM_ATTR_HW_DROPS];
+	struct netlink_ext_ack *extack = info->extack;
+
+	/* To maintain backward compatibility, we start / stop monitoring of
+	 * software drops if no flag is specified.
+	 */
+	if (!set_sw && !set_hw)
+		set_sw = true;
+
 	switch (info->genlhdr->cmd) {
 	case NET_DM_CMD_START:
-		return set_all_monitor_traces(TRACE_ON, info->extack);
+		return net_dm_monitor_start(set_sw, set_hw, extack);
 	case NET_DM_CMD_STOP:
-		return set_all_monitor_traces(TRACE_OFF, info->extack);
+		net_dm_monitor_stop(set_sw, set_hw, extack);
+		return 0;
 	}
 
 	return -EOPNOTSUPP;
@@ -1392,6 +1508,8 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
 	[NET_DM_ATTR_TRUNC_LEN] = { .type = NLA_U32 },
 	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
+	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
+	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
 };
 
 static const struct genl_ops dropmon_ops[] = {
-- 
2.21.0

