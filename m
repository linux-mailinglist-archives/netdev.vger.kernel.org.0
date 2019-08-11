Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 240E68902D
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfHKHhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:37:01 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:37621 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbfHKHhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:37:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B028C1966;
        Sun, 11 Aug 2019 03:36:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=I+y6RFfeXmA8j7Zf6aNnZL9aDLMse7jM6C7d8dutS5o=; b=IeXRvavr
        S9PoznihSPPJmBr4w8t940sWbsQ05JMLtT19BPHY5hBpDLS2JSUbo6B7L683jQp6
        pyNe+4Ufgvb0vix1w8rC8Ljckinwf/THG8mGK9laQsQMGNdhxSlcdHYMqRSkLufy
        qjADh9EIw+Vq+YrgHLlDLDnRLUL+OQ6nXbD1OjcNFanl86bSCEtcy7Kx0I568pRA
        UR+Oo/mZcEO9NI7VNPDh/HlqM7HHBWRUQkIWAjjzLg24XcdKy8DX99wAUid6TTqr
        JMioYQkyqX2azN5pKQKjeAEim+mQpItaDVOTe/AVpi+i5ksqmxA37RVzoDkPYDl2
        MtcNp6RK8N55LQ==
X-ME-Sender: <xms:msVPXXMpvIsFg9SB0M2Zbasn9OMu-XZazep1QHkZeMuDoWcbAlNnmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuffhomhgrihhnpehmohguvgdrnhgvthenucfkphepudelfedrge
    ejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:msVPXZW9s7W25mWbMOoxe4071Bd2Q-6sGef93G5LAotMbD1yJcv-kQ>
    <xmx:msVPXSTkpkc_AITFyaGWf9accrzs7-vdec5ldi5KDfsZPDFT87qXug>
    <xmx:msVPXVUQve8u0OD6-JeRoLZdRH2HjaHypFgxxEMHbwEJQ2JXwXAVKQ>
    <xmx:msVPXcP0o0fuBhQJrM--Pwcl5vfL6HpZS09V-IlA64XlcPWKl79abg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 172CA8005C;
        Sun, 11 Aug 2019 03:36:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 06/10] drop_monitor: Add packet alert mode
Date:   Sun, 11 Aug 2019 10:35:51 +0300
Message-Id: <20190811073555.27068-7-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190811073555.27068-1-idosch@idosch.org>
References: <20190811073555.27068-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

So far drop monitor supported only one alert mode in which a summary of
locations in which packets were recently dropped was sent to user space.

This alert mode is sufficient in order to understand that packets were
dropped, but lacks information to perform a more detailed analysis.

Add a new alert mode in which the dropped packet itself is passed to
user space along with metadata: The drop location (as program counter
and resolved symbol), ingress netdevice and drop timestamp. More
metadata can be added in the future.

To avoid performing expensive operations in the context in which
kfree_skb() is invoked (can be hard IRQ), the dropped skb is cloned and
queued on per-CPU skb drop list. Then, in process context the netlink
message is allocated, prepared and finally sent to user space.

The per-CPU skb drop list is limited to 1000 skbs to prevent exhausting
the system's memory. Subsequent patches will make this limit
configurable and also add a counter that indicates how many skbs were
tail dropped.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/uapi/linux/net_dropmon.h |  27 +++
 net/core/drop_monitor.c          | 280 ++++++++++++++++++++++++++++++-
 2 files changed, 305 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 0fecdedeb6ca..cfaaf75371b8 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -53,6 +53,7 @@ enum {
 	NET_DM_CMD_CONFIG,
 	NET_DM_CMD_START,
 	NET_DM_CMD_STOP,
+	NET_DM_CMD_PACKET_ALERT,
 	_NET_DM_CMD_MAX,
 };
 
@@ -63,12 +64,38 @@ enum {
  */
 #define NET_DM_GRP_ALERT 1
 
+enum net_dm_attr {
+	NET_DM_ATTR_UNSPEC,
+
+	NET_DM_ATTR_ALERT_MODE,			/* u8 */
+	NET_DM_ATTR_PC,				/* u64 */
+	NET_DM_ATTR_SYMBOL,			/* string */
+	NET_DM_ATTR_IN_PORT,			/* nested */
+	NET_DM_ATTR_TIMESTAMP,			/* struct timespec */
+	NET_DM_ATTR_PROTO,			/* u16 */
+	NET_DM_ATTR_PAYLOAD,			/* binary */
+	NET_DM_ATTR_PAD,
+
+	__NET_DM_ATTR_MAX,
+	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
+};
+
 /**
  * enum net_dm_alert_mode - Alert mode.
  * @NET_DM_ALERT_MODE_SUMMARY: A summary of recent drops is sent to user space.
+ * @NET_DM_ALERT_MODE_PACKET: Each dropped packet is sent to user space along
+ *                            with metadata.
  */
 enum net_dm_alert_mode {
 	NET_DM_ALERT_MODE_SUMMARY,
+	NET_DM_ALERT_MODE_PACKET,
+};
+
+enum {
+	NET_DM_ATTR_PORT_NETDEV_IFINDEX,	/* u32 */
+
+	__NET_DM_ATTR_PORT_MAX,
+	NET_DM_ATTR_PORT_MAX = __NET_DM_ATTR_PORT_MAX - 1
 };
 
 #endif
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 9cd2f662cb9e..ba765832413b 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -54,6 +54,7 @@ static DEFINE_MUTEX(net_dm_mutex);
 struct per_cpu_dm_data {
 	spinlock_t		lock;	/* Protects 'skb' and 'send_timer' */
 	struct sk_buff		*skb;
+	struct sk_buff_head	drop_queue;
 	struct work_struct	dm_alert_work;
 	struct timer_list	send_timer;
 };
@@ -85,6 +86,14 @@ struct net_dm_alert_ops {
 	void (*work_item_func)(struct work_struct *work);
 };
 
+struct net_dm_skb_cb {
+	void *pc;
+};
+
+#define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
+
+#define NET_DM_QUEUE_LEN 1000
+
 static struct sk_buff *reset_per_cpu_data(struct per_cpu_dm_data *data)
 {
 	size_t al;
@@ -257,8 +266,214 @@ static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
 	.work_item_func		= send_dm_alert,
 };
 
+static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
+					      struct sk_buff *skb,
+					      void *location)
+{
+	ktime_t tstamp = ktime_get_real();
+	struct per_cpu_dm_data *data;
+	struct sk_buff *nskb;
+	unsigned long flags;
+
+	nskb = skb_clone(skb, GFP_ATOMIC);
+	if (!nskb)
+		return;
+
+	NET_DM_SKB_CB(nskb)->pc = location;
+	/* Override the timestamp because we care about the time when the
+	 * packet was dropped.
+	 */
+	nskb->tstamp = tstamp;
+
+	data = this_cpu_ptr(&dm_cpu_data);
+
+	spin_lock_irqsave(&data->drop_queue.lock, flags);
+	if (skb_queue_len(&data->drop_queue) < NET_DM_QUEUE_LEN)
+		__skb_queue_tail(&data->drop_queue, nskb);
+	else
+		goto unlock_free;
+	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
+
+	schedule_work(&data->dm_alert_work);
+
+	return;
+
+unlock_free:
+	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
+	consume_skb(nskb);
+}
+
+static void net_dm_packet_trace_napi_poll_hit(void *ignore,
+					      struct napi_struct *napi,
+					      int work, int budget)
+{
+}
+
+static size_t net_dm_in_port_size(void)
+{
+	       /* NET_DM_ATTR_IN_PORT nest */
+	return nla_total_size(0) +
+	       /* NET_DM_ATTR_PORT_NETDEV_IFINDEX */
+	       nla_total_size(sizeof(u32));
+}
+
+#define NET_DM_MAX_SYMBOL_LEN 40
+
+static size_t net_dm_packet_report_size(size_t payload_len)
+{
+	size_t size;
+
+	size = nlmsg_msg_size(GENL_HDRLEN + net_drop_monitor_family.hdrsize);
+
+	return NLMSG_ALIGN(size) +
+	       /* NET_DM_ATTR_PC */
+	       nla_total_size(sizeof(u64)) +
+	       /* NET_DM_ATTR_SYMBOL */
+	       nla_total_size(NET_DM_MAX_SYMBOL_LEN + 1) +
+	       /* NET_DM_ATTR_IN_PORT */
+	       net_dm_in_port_size() +
+	       /* NET_DM_ATTR_TIMESTAMP */
+	       nla_total_size(sizeof(struct timespec)) +
+	       /* NET_DM_ATTR_PROTO */
+	       nla_total_size(sizeof(u16)) +
+	       /* NET_DM_ATTR_PAYLOAD */
+	       nla_total_size(payload_len);
+}
+
+static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex)
+{
+	struct nlattr *attr;
+
+	attr = nla_nest_start(msg, NET_DM_ATTR_IN_PORT);
+	if (!attr)
+		return -EMSGSIZE;
+
+	if (ifindex &&
+	    nla_put_u32(msg, NET_DM_ATTR_PORT_NETDEV_IFINDEX, ifindex))
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
+static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
+				     size_t payload_len)
+{
+	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
+	char buf[NET_DM_MAX_SYMBOL_LEN];
+	struct nlattr *attr;
+	struct timespec ts;
+	void *hdr;
+	int rc;
+
+	hdr = genlmsg_put(msg, 0, 0, &net_drop_monitor_family, 0,
+			  NET_DM_CMD_PACKET_ALERT);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
+		goto nla_put_failure;
+
+	snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
+	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
+		goto nla_put_failure;
+
+	rc = net_dm_packet_report_in_port_put(msg, skb->skb_iif);
+	if (rc)
+		goto nla_put_failure;
+
+	if (ktime_to_timespec_cond(skb->tstamp, &ts) &&
+	    nla_put(msg, NET_DM_ATTR_TIMESTAMP, sizeof(ts), &ts))
+		goto nla_put_failure;
+
+	if (!payload_len)
+		goto out;
+
+	if (nla_put_u16(msg, NET_DM_ATTR_PROTO, be16_to_cpu(skb->protocol)))
+		goto nla_put_failure;
+
+	attr = skb_put(msg, nla_total_size(payload_len));
+	attr->nla_type = NET_DM_ATTR_PAYLOAD;
+	attr->nla_len = nla_attr_size(payload_len);
+	if (skb_copy_bits(skb, 0, nla_data(attr), payload_len))
+		goto nla_put_failure;
+
+out:
+	genlmsg_end(msg, hdr);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+#define NET_DM_MAX_PACKET_SIZE (0xffff - NLA_HDRLEN - NLA_ALIGNTO)
+
+static void net_dm_packet_report(struct sk_buff *skb)
+{
+	struct sk_buff *msg;
+	size_t payload_len;
+	int rc;
+
+	/* Make sure we start copying the packet from the MAC header */
+	if (skb->data > skb_mac_header(skb))
+		skb_push(skb, skb->data - skb_mac_header(skb));
+	else
+		skb_pull(skb, skb_mac_header(skb) - skb->data);
+
+	/* Ensure packet fits inside a single netlink attribute */
+	payload_len = min_t(size_t, skb->len, NET_DM_MAX_PACKET_SIZE);
+
+	msg = nlmsg_new(net_dm_packet_report_size(payload_len), GFP_KERNEL);
+	if (!msg)
+		goto out;
+
+	rc = net_dm_packet_report_fill(msg, skb, payload_len);
+	if (rc) {
+		nlmsg_free(msg);
+		goto out;
+	}
+
+	genlmsg_multicast(&net_drop_monitor_family, msg, 0, 0, GFP_KERNEL);
+
+out:
+	consume_skb(skb);
+}
+
+static void net_dm_packet_work(struct work_struct *work)
+{
+	struct per_cpu_dm_data *data;
+	struct sk_buff_head list;
+	struct sk_buff *skb;
+	unsigned long flags;
+
+	data = container_of(work, struct per_cpu_dm_data, dm_alert_work);
+
+	__skb_queue_head_init(&list);
+
+	spin_lock_irqsave(&data->drop_queue.lock, flags);
+	skb_queue_splice_tail_init(&data->drop_queue, &list);
+	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
+
+	while ((skb = __skb_dequeue(&list)))
+		net_dm_packet_report(skb);
+}
+
+static const struct net_dm_alert_ops net_dm_alert_packet_ops = {
+	.kfree_skb_probe	= net_dm_packet_trace_kfree_skb_hit,
+	.napi_poll_probe	= net_dm_packet_trace_napi_poll_hit,
+	.work_item_func		= net_dm_packet_work,
+};
+
 static const struct net_dm_alert_ops *net_dm_alert_ops_arr[] = {
 	[NET_DM_ALERT_MODE_SUMMARY]	= &net_dm_alert_summary_ops,
+	[NET_DM_ALERT_MODE_PACKET]	= &net_dm_alert_packet_ops,
 };
 
 static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
@@ -326,9 +541,12 @@ static void net_dm_trace_off_set(void)
 	 */
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
+		struct sk_buff *skb;
 
 		del_timer_sync(&data->send_timer);
 		cancel_work_sync(&data->dm_alert_work);
+		while ((skb = __skb_dequeue(&data->drop_queue)))
+			consume_skb(skb);
 	}
 
 	list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
@@ -370,12 +588,61 @@ static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
 	return rc;
 }
 
+static int net_dm_alert_mode_get_from_info(struct genl_info *info,
+					   enum net_dm_alert_mode *p_alert_mode)
+{
+	u8 val;
+
+	val = nla_get_u8(info->attrs[NET_DM_ATTR_ALERT_MODE]);
+
+	switch (val) {
+	case NET_DM_ALERT_MODE_SUMMARY: /* fall-through */
+	case NET_DM_ALERT_MODE_PACKET:
+		*p_alert_mode = val;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int net_dm_alert_mode_set(struct genl_info *info)
+{
+	struct netlink_ext_ack *extack = info->extack;
+	enum net_dm_alert_mode alert_mode;
+	int rc;
+
+	if (!info->attrs[NET_DM_ATTR_ALERT_MODE])
+		return 0;
+
+	rc = net_dm_alert_mode_get_from_info(info, &alert_mode);
+	if (rc) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid alert mode");
+		return -EINVAL;
+	}
+
+	net_dm_alert_mode = alert_mode;
+
+	return 0;
+}
+
 static int net_dm_cmd_config(struct sk_buff *skb,
 			struct genl_info *info)
 {
-	NL_SET_ERR_MSG_MOD(info->extack, "Command not supported");
+	struct netlink_ext_ack *extack = info->extack;
+	int rc;
 
-	return -EOPNOTSUPP;
+	if (trace_state == TRACE_ON) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot configure drop monitor while tracing is on");
+		return -EBUSY;
+	}
+
+	rc = net_dm_alert_mode_set(info);
+	if (rc)
+		return rc;
+
+	return 0;
 }
 
 static int net_dm_cmd_trace(struct sk_buff *skb,
@@ -430,6 +697,11 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 	return NOTIFY_DONE;
 }
 
+static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
+	[NET_DM_ATTR_UNSPEC] = { .strict_start_type = NET_DM_ATTR_UNSPEC + 1 },
+	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
+};
+
 static const struct genl_ops dropmon_ops[] = {
 	{
 		.cmd = NET_DM_CMD_CONFIG,
@@ -467,6 +739,8 @@ static struct genl_family net_drop_monitor_family __ro_after_init = {
 	.hdrsize        = 0,
 	.name           = "NET_DM",
 	.version        = 2,
+	.maxattr	= NET_DM_ATTR_MAX,
+	.policy		= net_dm_nl_policy,
 	.pre_doit	= net_dm_nl_pre_doit,
 	.post_doit	= net_dm_nl_post_doit,
 	.module		= THIS_MODULE,
@@ -510,6 +784,7 @@ static int __init init_net_drop_monitor(void)
 	for_each_possible_cpu(cpu) {
 		data = &per_cpu(dm_cpu_data, cpu);
 		spin_lock_init(&data->lock);
+		skb_queue_head_init(&data->drop_queue);
 	}
 
 	goto out;
@@ -539,6 +814,7 @@ static void exit_net_drop_monitor(void)
 		 * to this struct and can free the skb inside it
 		 */
 		kfree_skb(data->skb);
+		WARN_ON(!skb_queue_empty(&data->drop_queue));
 	}
 
 	BUG_ON(genl_unregister_family(&net_drop_monitor_family));
-- 
2.21.0

