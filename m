Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD38189032
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfHKHhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:37:11 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:35185 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726538AbfHKHhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:37:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B47AA1A27;
        Sun, 11 Aug 2019 03:37:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:37:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=uwvlvV5FQAG49BkIn9cWQYDSu+azcJDpOVwCnA4iffc=; b=l/zO1CJk
        dZipzv7ffSADbE1IgJgW79tBzyQ/Et7+uToPN6Px8EAHYcR0gRHPCK+8QepUs80h
        almrXJ8O0VL9XM5cGsclys+Y5Mo5Te9Aw2f70KE9zxy8oBMKHGT5kWDHLDUFrz09
        2Cmif0pE7ctDIR/5Ob8njRXJUotzNI6+3GPzJ6BGwk053hgt0bDde070F1EEquQr
        pwPFysLq2E/zAsVIGen99MiOqxHGn1JpuFt5YnLIUrVuEcE6hLPY5A0PMc9RLk69
        KT/XzQL/tyuYPuOra6OvdxwnbRRdaDopdkccqrEGR1tD75Ss0jZ9L7fA6eBVT9uh
        wSOGyZEaN4nn8A==
X-ME-Sender: <xms:pMVPXQuJGftOj4_S8Ms24iSP7JPqZy3CRdExHR97W1iGy0RvUTivNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:pMVPXV27UbteBadaBW5z-fBiueYihq_O_Kf33JsoG2oK-Rj2XKLgNQ>
    <xmx:pMVPXX2KbIzSGQe3Xhwj3sIwIscuLRIz53IT6mLHZsjKo561__edoA>
    <xmx:pMVPXYoWTf_wNUFFKKvl42rBxZDmZVuQT6xCOX-LXXbWj0eVU4E4cA>
    <xmx:pMVPXZF7OlGDxv2A7OhCeSw-GQgiE0d0s6wRZ3PWZO7BkPe0EJCdkA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1DD648005C;
        Sun, 11 Aug 2019 03:37:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 10/10] drop_monitor: Expose tail drop counter
Date:   Sun, 11 Aug 2019 10:35:55 +0300
Message-Id: <20190811073555.27068-11-idosch@idosch.org>
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

Previous patch made the length of the per-CPU skb drop list
configurable. Expose a counter that shows how many packets could not be
enqueued to this list.

This allows users determine the desired queue length.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/uapi/linux/net_dropmon.h |  10 +++
 net/core/drop_monitor.c          | 101 +++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 1d0bdb1ba954..405b31cbf723 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -56,6 +56,8 @@ enum {
 	NET_DM_CMD_PACKET_ALERT,
 	NET_DM_CMD_CONFIG_GET,
 	NET_DM_CMD_CONFIG_NEW,
+	NET_DM_CMD_STATS_GET,
+	NET_DM_CMD_STATS_NEW,
 	_NET_DM_CMD_MAX,
 };
 
@@ -80,6 +82,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_TRUNC_LEN,			/* u32 */
 	NET_DM_ATTR_ORIG_LEN,			/* u32 */
 	NET_DM_ATTR_QUEUE_LEN,			/* u32 */
+	NET_DM_ATTR_STATS,			/* nested */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
@@ -103,4 +106,11 @@ enum {
 	NET_DM_ATTR_PORT_MAX = __NET_DM_ATTR_PORT_MAX - 1
 };
 
+enum {
+	NET_DM_ATTR_STATS_DROPPED,		/* u64 */
+
+	__NET_DM_ATTR_STATS_MAX,
+	NET_DM_ATTR_STATS_MAX = __NET_DM_ATTR_STATS_MAX - 1
+};
+
 #endif
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index eb3c34d69ea9..39e094907391 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -51,12 +51,18 @@ static int trace_state = TRACE_OFF;
  */
 static DEFINE_MUTEX(net_dm_mutex);
 
+struct net_dm_stats {
+	u64 dropped;
+	struct u64_stats_sync syncp;
+};
+
 struct per_cpu_dm_data {
 	spinlock_t		lock;	/* Protects 'skb' and 'send_timer' */
 	struct sk_buff		*skb;
 	struct sk_buff_head	drop_queue;
 	struct work_struct	dm_alert_work;
 	struct timer_list	send_timer;
+	struct net_dm_stats	stats;
 };
 
 struct dm_hw_stat_delta {
@@ -300,6 +306,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 
 unlock_free:
 	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
+	u64_stats_update_begin(&data->stats.syncp);
+	data->stats.dropped++;
+	u64_stats_update_end(&data->stats.syncp);
 	consume_skb(nskb);
 }
 
@@ -732,6 +741,93 @@ static int net_dm_cmd_config_get(struct sk_buff *skb, struct genl_info *info)
 	return rc;
 }
 
+static void net_dm_stats_read(struct net_dm_stats *stats)
+{
+	int cpu;
+
+	memset(stats, 0, sizeof(*stats));
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
+		struct net_dm_stats *cpu_stats = &data->stats;
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
+static int net_dm_stats_put(struct sk_buff *msg)
+{
+	struct net_dm_stats stats;
+	struct nlattr *attr;
+
+	net_dm_stats_read(&stats);
+
+	attr = nla_nest_start(msg, NET_DM_ATTR_STATS);
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
+static int net_dm_stats_fill(struct sk_buff *msg, struct genl_info *info)
+{
+	void *hdr;
+	int rc;
+
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
+			  &net_drop_monitor_family, 0, NET_DM_CMD_STATS_NEW);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	rc = net_dm_stats_put(msg);
+	if (rc)
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
+static int net_dm_cmd_stats_get(struct sk_buff *skb, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	int rc;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	rc = net_dm_stats_fill(msg, info);
+	if (rc)
+		goto free_msg;
+
+	return genlmsg_reply(msg, info);
+
+free_msg:
+	nlmsg_free(msg);
+	return rc;
+}
+
 static int dropmon_net_event(struct notifier_block *ev_block,
 			     unsigned long event, void *ptr)
 {
@@ -799,6 +895,10 @@ static const struct genl_ops dropmon_ops[] = {
 		.cmd = NET_DM_CMD_CONFIG_GET,
 		.doit = net_dm_cmd_config_get,
 	},
+	{
+		.cmd = NET_DM_CMD_STATS_GET,
+		.doit = net_dm_cmd_stats_get,
+	},
 };
 
 static int net_dm_nl_pre_doit(const struct genl_ops *ops,
@@ -865,6 +965,7 @@ static int __init init_net_drop_monitor(void)
 		data = &per_cpu(dm_cpu_data, cpu);
 		spin_lock_init(&data->lock);
 		skb_queue_head_init(&data->drop_queue);
+		u64_stats_init(&data->stats.syncp);
 	}
 
 	goto out;
-- 
2.21.0

