Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEA018B1A6
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfHMH4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:56:05 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:54629 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725981AbfHMH4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:56:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id E51833031;
        Tue, 13 Aug 2019 03:56:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 03:56:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Rx5DjOyc93HrduOfg87R+1tVm+Q6EgZCybPMgK7wSjk=; b=KBq60zhD
        nRMnaNOjJ/8twyBlGWWXkTwt3ypjyndnA7dQb5b6Xfy58f9Lx3us54YJC6qaUSey
        hhxjMKJa1S3Zp5UX52BcJ3Z/RqweKKUGe7sxAmfXkNehvqQbzukIrZuz+Lt07LkY
        GOO3aU7NtAajsTJfoDLqQkt51AgnU71o2FQ7M3bmsf0dp/h9l4rpZjQtxzUDZm3a
        gSsTWEyq486V9fC64Mjmi9QM8dqnPdECvKT219rtAKWPtdN4sYijLTFIa/z5PdMj
        oJklLRR8CA8xJoh4H+lRXidhgqeKZjUe2p4Bu01gAwdylbfmcd/1mTLUv7tNLicK
        GYvEoeriiZZoPA==
X-ME-Sender: <xms:E21SXQc57kPAid4JYWcnzSeNDOxVhwi0E9bjbiwEx5XpaPNd0e-9ug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvhedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgepfe
X-ME-Proxy: <xmx:E21SXWeHQzlUmTKNk3QsIxkJQh9A1LewBw73EKK-NLd04O89ELrSkA>
    <xmx:E21SXcgdBvTWor_aagW-Ta8eFxoCSgewpQUZRYQLg8Y0MXUtBJndBQ>
    <xmx:E21SXaRnu1h_7Kmom-wcx94O9tt96vV1xf-CarDhcE5lkDQ_jbPWMQ>
    <xmx:E21SXc0HiR21C0YURVbSb-nA5sxkLqF4gbYKLhah77LeheZYrdE1JQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB53280063;
        Tue, 13 Aug 2019 03:55:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 05/14] drop_monitor: Add support for packet alert mode for hardware drops
Date:   Tue, 13 Aug 2019 10:53:51 +0300
Message-Id: <20190813075400.11841-6-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813075400.11841-1-idosch@idosch.org>
References: <20190813075400.11841-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In a similar fashion to software drops, extend drop monitor to send
netlink events when packets are dropped by the underlying hardware.

The main difference is that instead of encoding the program counter (PC)
from which kfree_skb() was called in the netlink message, we encode the
hardware trap name. The two are mostly equivalent since they should both
help the user understand why the packet was dropped.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/net_dropmon.h |  10 +
 net/core/drop_monitor.c          | 304 ++++++++++++++++++++++++++++++-
 2 files changed, 310 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 405b31cbf723..9f8fb1bb4aa4 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -83,6 +83,10 @@ enum net_dm_attr {
 	NET_DM_ATTR_ORIG_LEN,			/* u32 */
 	NET_DM_ATTR_QUEUE_LEN,			/* u32 */
 	NET_DM_ATTR_STATS,			/* nested */
+	NET_DM_ATTR_HW_STATS,			/* nested */
+	NET_DM_ATTR_ORIGIN,			/* u16 */
+	NET_DM_ATTR_HW_TRAP_GROUP_NAME,		/* string */
+	NET_DM_ATTR_HW_TRAP_NAME,		/* string */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
@@ -101,6 +105,7 @@ enum net_dm_alert_mode {
 
 enum {
 	NET_DM_ATTR_PORT_NETDEV_IFINDEX,	/* u32 */
+	NET_DM_ATTR_PORT_NETDEV_NAME,		/* string */
 
 	__NET_DM_ATTR_PORT_MAX,
 	NET_DM_ATTR_PORT_MAX = __NET_DM_ATTR_PORT_MAX - 1
@@ -113,4 +118,9 @@ enum {
 	NET_DM_ATTR_STATS_MAX = __NET_DM_ATTR_STATS_MAX - 1
 };
 
+enum net_dm_origin {
+	NET_DM_ORIGIN_SW,
+	NET_DM_ORIGIN_HW,
+};
+
 #endif
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index a2c7f9162c9d..5a950b5af8fd 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -95,12 +95,16 @@ struct net_dm_alert_ops {
 	void (*napi_poll_probe)(void *ignore, struct napi_struct *napi,
 				int work, int budget);
 	void (*work_item_func)(struct work_struct *work);
+	void (*hw_work_item_func)(struct work_struct *work);
 	void (*hw_probe)(struct sk_buff *skb,
 			 const struct net_dm_hw_metadata *hw_metadata);
 };
 
 struct net_dm_skb_cb {
-	void *pc;
+	union {
+		struct net_dm_hw_metadata *hw_metadata;
+		void *pc;
+	};
 };
 
 #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
@@ -335,7 +339,9 @@ static size_t net_dm_in_port_size(void)
 	       /* NET_DM_ATTR_IN_PORT nest */
 	return nla_total_size(0) +
 	       /* NET_DM_ATTR_PORT_NETDEV_IFINDEX */
-	       nla_total_size(sizeof(u32));
+	       nla_total_size(sizeof(u32)) +
+	       /* NET_DM_ATTR_PORT_NETDEV_NAME */
+	       nla_total_size(IFNAMSIZ + 1);
 }
 
 #define NET_DM_MAX_SYMBOL_LEN 40
@@ -347,6 +353,8 @@ static size_t net_dm_packet_report_size(size_t payload_len)
 	size = nlmsg_msg_size(GENL_HDRLEN + net_drop_monitor_family.hdrsize);
 
 	return NLMSG_ALIGN(size) +
+	       /* NET_DM_ATTR_ORIGIN */
+	       nla_total_size(sizeof(u16)) +
 	       /* NET_DM_ATTR_PC */
 	       nla_total_size(sizeof(u64)) +
 	       /* NET_DM_ATTR_SYMBOL */
@@ -363,7 +371,8 @@ static size_t net_dm_packet_report_size(size_t payload_len)
 	       nla_total_size(payload_len);
 }
 
-static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex)
+static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
+					    const char *name)
 {
 	struct nlattr *attr;
 
@@ -375,6 +384,9 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex)
 	    nla_put_u32(msg, NET_DM_ATTR_PORT_NETDEV_IFINDEX, ifindex))
 		goto nla_put_failure;
 
+	if (name && nla_put_string(msg, NET_DM_ATTR_PORT_NETDEV_NAME, name))
+		goto nla_put_failure;
+
 	nla_nest_end(msg, attr);
 
 	return 0;
@@ -399,6 +411,9 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (!hdr)
 		return -EMSGSIZE;
 
+	if (nla_put_u16(msg, NET_DM_ATTR_ORIGIN, NET_DM_ORIGIN_SW))
+		goto nla_put_failure;
+
 	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
@@ -406,7 +421,7 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
 		goto nla_put_failure;
 
-	rc = net_dm_packet_report_in_port_put(msg, skb->skb_iif);
+	rc = net_dm_packet_report_in_port_put(msg, skb->skb_iif, NULL);
 	if (rc)
 		goto nla_put_failure;
 
@@ -493,16 +508,249 @@ static void net_dm_packet_work(struct work_struct *work)
 		net_dm_packet_report(skb);
 }
 
+static size_t
+net_dm_hw_packet_report_size(size_t payload_len,
+			     const struct net_dm_hw_metadata *hw_metadata)
+{
+	size_t size;
+
+	size = nlmsg_msg_size(GENL_HDRLEN + net_drop_monitor_family.hdrsize);
+
+	return NLMSG_ALIGN(size) +
+	       /* NET_DM_ATTR_ORIGIN */
+	       nla_total_size(sizeof(u16)) +
+	       /* NET_DM_ATTR_HW_TRAP_GROUP_NAME */
+	       nla_total_size(strlen(hw_metadata->trap_group_name) + 1) +
+	       /* NET_DM_ATTR_HW_TRAP_NAME */
+	       nla_total_size(strlen(hw_metadata->trap_name) + 1) +
+	       /* NET_DM_ATTR_IN_PORT */
+	       net_dm_in_port_size() +
+	       /* NET_DM_ATTR_TIMESTAMP */
+	       nla_total_size(sizeof(struct timespec)) +
+	       /* NET_DM_ATTR_ORIG_LEN */
+	       nla_total_size(sizeof(u32)) +
+	       /* NET_DM_ATTR_PROTO */
+	       nla_total_size(sizeof(u16)) +
+	       /* NET_DM_ATTR_PAYLOAD */
+	       nla_total_size(payload_len);
+}
+
+static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
+					struct sk_buff *skb, size_t payload_len)
+{
+	struct net_dm_hw_metadata *hw_metadata;
+	struct nlattr *attr;
+	struct timespec ts;
+	void *hdr;
+
+	hw_metadata = NET_DM_SKB_CB(skb)->hw_metadata;
+
+	hdr = genlmsg_put(msg, 0, 0, &net_drop_monitor_family, 0,
+			  NET_DM_CMD_PACKET_ALERT);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (nla_put_u16(msg, NET_DM_ATTR_ORIGIN, NET_DM_ORIGIN_HW))
+		goto nla_put_failure;
+
+	if (nla_put_string(msg, NET_DM_ATTR_HW_TRAP_GROUP_NAME,
+			   hw_metadata->trap_group_name))
+		goto nla_put_failure;
+
+	if (nla_put_string(msg, NET_DM_ATTR_HW_TRAP_NAME,
+			   hw_metadata->trap_name))
+		goto nla_put_failure;
+
+	if (hw_metadata->input_dev) {
+		struct net_device *dev = hw_metadata->input_dev;
+		int rc;
+
+		rc = net_dm_packet_report_in_port_put(msg, dev->ifindex,
+						      dev->name);
+		if (rc)
+			goto nla_put_failure;
+	}
+
+	if (ktime_to_timespec_cond(skb->tstamp, &ts) &&
+	    nla_put(msg, NET_DM_ATTR_TIMESTAMP, sizeof(ts), &ts))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NET_DM_ATTR_ORIG_LEN, skb->len))
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
+static struct net_dm_hw_metadata *
+net_dm_hw_metadata_clone(const struct net_dm_hw_metadata *hw_metadata)
+{
+	struct net_dm_hw_metadata *n_hw_metadata;
+	const char *trap_group_name;
+	const char *trap_name;
+
+	n_hw_metadata = kmalloc(sizeof(*hw_metadata), GFP_ATOMIC);
+	if (!n_hw_metadata)
+		return NULL;
+
+	trap_group_name = kmemdup(hw_metadata->trap_group_name,
+				  strlen(hw_metadata->trap_group_name) + 1,
+				  GFP_ATOMIC | __GFP_ZERO);
+	if (!trap_group_name)
+		goto free_hw_metadata;
+	n_hw_metadata->trap_group_name = trap_group_name;
+
+	trap_name = kmemdup(hw_metadata->trap_name,
+			    strlen(hw_metadata->trap_name) + 1,
+			    GFP_ATOMIC | __GFP_ZERO);
+	if (!trap_name)
+		goto free_trap_group;
+	n_hw_metadata->trap_name = trap_name;
+
+	n_hw_metadata->input_dev = hw_metadata->input_dev;
+	if (n_hw_metadata->input_dev)
+		dev_hold(n_hw_metadata->input_dev);
+
+	return n_hw_metadata;
+
+free_trap_group:
+	kfree(trap_group_name);
+free_hw_metadata:
+	kfree(n_hw_metadata);
+	return NULL;
+}
+
+static void
+net_dm_hw_metadata_free(const struct net_dm_hw_metadata *hw_metadata)
+{
+	if (hw_metadata->input_dev)
+		dev_put(hw_metadata->input_dev);
+	kfree(hw_metadata->trap_name);
+	kfree(hw_metadata->trap_group_name);
+	kfree(hw_metadata);
+}
+
+static void net_dm_hw_packet_report(struct sk_buff *skb)
+{
+	struct net_dm_hw_metadata *hw_metadata;
+	struct sk_buff *msg;
+	size_t payload_len;
+	int rc;
+
+	if (skb->data > skb_mac_header(skb))
+		skb_push(skb, skb->data - skb_mac_header(skb));
+	else
+		skb_pull(skb, skb_mac_header(skb) - skb->data);
+
+	payload_len = min_t(size_t, skb->len, NET_DM_MAX_PACKET_SIZE);
+	if (net_dm_trunc_len)
+		payload_len = min_t(size_t, net_dm_trunc_len, payload_len);
+
+	hw_metadata = NET_DM_SKB_CB(skb)->hw_metadata;
+	msg = nlmsg_new(net_dm_hw_packet_report_size(payload_len, hw_metadata),
+			GFP_KERNEL);
+	if (!msg)
+		goto out;
+
+	rc = net_dm_hw_packet_report_fill(msg, skb, payload_len);
+	if (rc) {
+		nlmsg_free(msg);
+		goto out;
+	}
+
+	genlmsg_multicast(&net_drop_monitor_family, msg, 0, 0, GFP_KERNEL);
+
+out:
+	net_dm_hw_metadata_free(NET_DM_SKB_CB(skb)->hw_metadata);
+	consume_skb(skb);
+}
+
+static void net_dm_hw_packet_work(struct work_struct *work)
+{
+	struct per_cpu_dm_data *hw_data;
+	struct sk_buff_head list;
+	struct sk_buff *skb;
+	unsigned long flags;
+
+	hw_data = container_of(work, struct per_cpu_dm_data, dm_alert_work);
+
+	__skb_queue_head_init(&list);
+
+	spin_lock_irqsave(&hw_data->drop_queue.lock, flags);
+	skb_queue_splice_tail_init(&hw_data->drop_queue, &list);
+	spin_unlock_irqrestore(&hw_data->drop_queue.lock, flags);
+
+	while ((skb = __skb_dequeue(&list)))
+		net_dm_hw_packet_report(skb);
+}
+
 static void
 net_dm_hw_packet_probe(struct sk_buff *skb,
 		       const struct net_dm_hw_metadata *hw_metadata)
 {
+	struct net_dm_hw_metadata *n_hw_metadata;
+	ktime_t tstamp = ktime_get_real();
+	struct per_cpu_dm_data *hw_data;
+	struct sk_buff *nskb;
+	unsigned long flags;
+
+	nskb = skb_clone(skb, GFP_ATOMIC);
+	if (!nskb)
+		return;
+
+	n_hw_metadata = net_dm_hw_metadata_clone(hw_metadata);
+	if (!n_hw_metadata)
+		goto free;
+
+	NET_DM_SKB_CB(nskb)->hw_metadata = n_hw_metadata;
+	nskb->tstamp = tstamp;
+
+	hw_data = this_cpu_ptr(&dm_hw_cpu_data);
+
+	spin_lock_irqsave(&hw_data->drop_queue.lock, flags);
+	if (skb_queue_len(&hw_data->drop_queue) < net_dm_queue_len)
+		__skb_queue_tail(&hw_data->drop_queue, nskb);
+	else
+		goto unlock_free;
+	spin_unlock_irqrestore(&hw_data->drop_queue.lock, flags);
+
+	schedule_work(&hw_data->dm_alert_work);
+
+	return;
+
+unlock_free:
+	spin_unlock_irqrestore(&hw_data->drop_queue.lock, flags);
+	u64_stats_update_begin(&hw_data->stats.syncp);
+	hw_data->stats.dropped++;
+	u64_stats_update_end(&hw_data->stats.syncp);
+	net_dm_hw_metadata_free(n_hw_metadata);
+free:
+	consume_skb(nskb);
 }
 
 static const struct net_dm_alert_ops net_dm_alert_packet_ops = {
 	.kfree_skb_probe	= net_dm_packet_trace_kfree_skb_hit,
 	.napi_poll_probe	= net_dm_packet_trace_napi_poll_hit,
 	.work_item_func		= net_dm_packet_work,
+	.hw_work_item_func	= net_dm_hw_packet_work,
 	.hw_probe		= net_dm_hw_packet_probe,
 };
 
@@ -819,6 +1067,50 @@ static int net_dm_stats_put(struct sk_buff *msg)
 	return -EMSGSIZE;
 }
 
+static void net_dm_hw_stats_read(struct net_dm_stats *stats)
+{
+	int cpu;
+
+	memset(stats, 0, sizeof(*stats));
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
+		struct net_dm_stats *cpu_stats = &hw_data->stats;
+		unsigned int start;
+		u64 dropped;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			dropped = cpu_stats->dropped;
+		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+
+		stats->dropped += dropped;
+	}
+}
+
+static int net_dm_hw_stats_put(struct sk_buff *msg)
+{
+	struct net_dm_stats stats;
+	struct nlattr *attr;
+
+	net_dm_hw_stats_read(&stats);
+
+	attr = nla_nest_start(msg, NET_DM_ATTR_HW_STATS);
+	if (!attr)
+		return -EMSGSIZE;
+
+	if (nla_put_u64_64bit(msg, NET_DM_ATTR_STATS_DROPPED,
+			      stats.dropped, NET_DM_ATTR_PAD))
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
 static int net_dm_stats_fill(struct sk_buff *msg, struct genl_info *info)
 {
 	void *hdr;
@@ -833,6 +1125,10 @@ static int net_dm_stats_fill(struct sk_buff *msg, struct genl_info *info)
 	if (rc)
 		goto nla_put_failure;
 
+	rc = net_dm_hw_stats_put(msg);
+	if (rc)
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 
 	return 0;
-- 
2.21.0

