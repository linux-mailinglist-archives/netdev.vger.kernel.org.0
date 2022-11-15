Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0129B629273
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiKOH3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiKOH3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:29:01 -0500
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25C95F6D;
        Mon, 14 Nov 2022 23:28:56 -0800 (PST)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id JIR00150;
        Tue, 15 Nov 2022 15:28:50 +0800
Received: from localhost.localdomain (10.180.206.146) by
 jtjnmail201612.home.langchao.com (10.100.2.12) with Microsoft SMTP Server id
 15.1.2507.12; Tue, 15 Nov 2022 15:28:51 +0800
From:   wangchuanlei <wangchuanlei@inspur.com>
To:     <echaudro@redhat.com>, <pshelar@ovn.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <wangpeihui@inspur.com>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>, <linux-kernel@vger.kernel.org>,
        wangchuanlei <wangchuanlei@inspur.com>
Subject: [PATCH v2] openvswitch: Add support to count upall packets
Date:   Tue, 15 Nov 2022 02:28:48 -0500
Message-ID: <20221115072848.589294-1-wangchuanlei@inspur.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.206.146]
tUid:   20221115152850f0900d0604a9d1dd08f4ed271e46b7d4
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added the total number of upcalls and the total of upcall failures.
Due to ovs-userspace do not support NLA_NESTED, here still use the
"struct ovs_vport_upcall_stats"

Thank you
wangchuanlei

On 14 Sep 2022, at 14:14, wangchuanlei wrote:

> Add support to count upcall packets on every interface.
> I always encounter high cpu use of ovs-vswictchd, this help to check
> which interface send too many packets without open vlog/set switch,
> and have no influence on datapath.

Hi,

I did not do a full review, but I think we should not try to make the
 same mistake as before and embed a structure inside a netlink message.

You are adding “struct ovs_vport_upcall_stats” but in theory,
 you could have just added the new entry to “ovs_vport_stats”.
 But this is breaking userspace as it expects an exact structure size :(

So I think the right approach would be to have “
OVS_VPORT_ATTR_UPCALL_STATS” be an NLA_NESTED type, and have
individual stat attributes as NLA_U64 (or whatever type you need).

What is also confusing is that you use upcall_packets in
 ovs_vport_upcall_stats, which to me are the total of up calls,
but you called it n_missed in your stats. I think you should try to
 avoid missed in the upcall path, and just call it n_upcall_packets also.

In addition, I think you should keep two types of statics, and make them
 available, namely the total number of upcalls and the total of upcall
failures.

Cheers,

Eelco

Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
---
 include/uapi/linux/openvswitch.h |  6 ++++
 net/openvswitch/datapath.c       | 54 +++++++++++++++++++++++++++++++-
 net/openvswitch/datapath.h       | 12 +++++++
 net/openvswitch/vport.c          | 33 +++++++++++++++++++
 net/openvswitch/vport.h          |  4 +++
 5 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 94066f87e9ee..bb671d92b711 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -126,6 +126,11 @@ struct ovs_vport_stats {
 	__u64   tx_dropped;		/* no space available in linux  */
 };
 
+struct ovs_vport_upcall_stats {
+	__u64   upcall_success;             /* total packets upcalls  succeed */
+	__u64   upcall_fail;				/* total packets upcalls  failed */
+};
+
 /* Allow last Netlink attribute to be unaligned */
 #define OVS_DP_F_UNALIGNED	(1 << 0)
 
@@ -277,6 +282,7 @@ enum ovs_vport_attr {
 	OVS_VPORT_ATTR_PAD,
 	OVS_VPORT_ATTR_IFINDEX,
 	OVS_VPORT_ATTR_NETNSID,
+	OVS_VPORT_ATTR_UPCALL_STATS, /* struct ovs_vport_upcall_stats */
 	__OVS_VPORT_ATTR_MAX
 };
 
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index c8a9075ddd0a..8b8ea95f94ae 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -209,6 +209,28 @@ static struct vport *new_vport(const struct vport_parms *parms)
 	return vport;
 }
 
+static void ovs_vport_upcalls(struct sk_buff *skb,
+			      const struct dp_upcall_info *upcall_info,
+			      bool upcall_success)
+{
+	if (upcall_info->cmd == OVS_PACKET_CMD_MISS ||
+	    upcall_info->cmd == OVS_PACKET_CMD_ACTION) {
+		const struct vport *p = OVS_CB(skb)->input_vport;
+		struct vport_upcall_stats_percpu *vport_stats;
+		u64 *stats_counter_upcall;
+
+		vport_stats = this_cpu_ptr(p->vport_upcall_stats_percpu);
+		if (upcall_success)
+			stats_counter_upcall = &vport_stats->n_upcall_success;
+		else
+			stats_counter_upcall = &vport_stats->n_upcall_fail;
+
+		u64_stats_update_begin(&vport_stats->syncp);
+		(*stats_counter_upcall)++;
+		u64_stats_update_end(&vport_stats->syncp);
+	}
+}
+
 void ovs_dp_detach_port(struct vport *p)
 {
 	ASSERT_OVSL();
@@ -216,6 +238,9 @@ void ovs_dp_detach_port(struct vport *p)
 	/* First drop references to device. */
 	hlist_del_rcu(&p->dp_hash_node);
 
+	/* Free percpu memory */
+	free_percpu(p->vport_upcall_stats_percpu);
+
 	/* Then destroy it. */
 	ovs_vport_del(p);
 }
@@ -305,8 +330,12 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_buff *skb,
 		err = queue_userspace_packet(dp, skb, key, upcall_info, cutlen);
 	else
 		err = queue_gso_packets(dp, skb, key, upcall_info, cutlen);
-	if (err)
+	if (err) {
+		ovs_vport_upcalls(skb, upcall_info, false);
 		goto err;
+	} else {
+		ovs_vport_upcalls(skb, upcall_info, true);
+	}
 
 	return 0;
 
@@ -1825,6 +1854,13 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 		goto err_destroy_portids;
 	}
 
+	vport->vport_upcall_stats_percpu =
+				netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
+	if (!vport->vport_upcall_stats_percpu) {
+		err = -ENOMEM;
+		goto err_destroy_portids;
+	}
+
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
 				   info->snd_seq, 0, OVS_DP_CMD_NEW);
 	BUG_ON(err < 0);
@@ -2068,6 +2104,7 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 {
 	struct ovs_header *ovs_header;
 	struct ovs_vport_stats vport_stats;
+	struct ovs_vport_upcall_stats vport_upcall_stats;
 	int err;
 
 	ovs_header = genlmsg_put(skb, portid, seq, &dp_vport_genl_family,
@@ -2097,6 +2134,13 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 			  OVS_VPORT_ATTR_PAD))
 		goto nla_put_failure;
 
+	ovs_vport_get_upcall_stats(vport, &vport_upcall_stats);
+	if (nla_put_64bit(skb, OVS_VPORT_ATTR_UPCALL_STATS,
+			  sizeof(struct ovs_vport_upcall_stats),
+			  &vport_upcall_stats,
+			  OVS_VPORT_ATTR_PAD))
+		goto nla_put_failure;
+
 	if (ovs_vport_get_upcall_portids(vport, skb))
 		goto nla_put_failure;
 
@@ -2278,6 +2322,14 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 		goto exit_unlock_free;
 	}
 
+	vport->vport_upcall_stats_percpu =
+		netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
+
+	if (!vport->vport_upcall_stats_percpu) {
+		err = -ENOMEM;
+		goto exit_unlock_free;
+	}
+
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 0cd29971a907..2f40db78d617 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -50,6 +50,18 @@ struct dp_stats_percpu {
 	struct u64_stats_sync syncp;
 };
 
+/**
+ * struct vport_upcall_stats_percpu - per-cpu packet upcall statistics for
+ * a given vport.
+ * @n_upcall_success: Number of packets that upcall to userspace succeed.
+ * @n_upcall_fail:    Number of packets that upcall to userspace failed.
+ */
+struct vport_upcall_stats_percpu {
+	u64 n_upcall_success;
+	u64 n_upcall_fail;
+	struct u64_stats_sync syncp;
+};
+
 /**
  * struct dp_nlsk_pids - array of netlink portids of for a datapath.
  *                       This is used when OVS_DP_F_DISPATCH_UPCALL_PER_CPU
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 82a74f998966..39b018da685e 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -284,6 +284,39 @@ void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
 	stats->tx_packets = dev_stats->tx_packets;
 }
 
+/**
+ *	ovs_vport_get_upcall_stats - retrieve upcall stats
+ *
+ * @vport: vport from which to retrieve the stats
+ * @ovs_vport_upcall_stats: location to store stats
+ *
+ * Retrieves upcall stats for the given device.
+ *
+ * Must be called with ovs_mutex or rcu_read_lock.
+ */
+void ovs_vport_get_upcall_stats(struct vport *vport, struct ovs_vport_upcall_stats *stats)
+{
+	int i;
+
+	stats->upcall_success = 0;
+	stats->upcall_fail = 0;
+
+	for_each_possible_cpu(i) {
+		const struct vport_upcall_stats_percpu *percpu_upcall_stats;
+		struct vport_upcall_stats_percpu local_stats;
+		unsigned int start;
+
+		percpu_upcall_stats = per_cpu_ptr(vport->vport_upcall_stats_percpu, i);
+		do {
+			start = u64_stats_fetch_begin_irq(&percpu_upcall_stats->syncp);
+			local_stats = *percpu_upcall_stats;
+		} while (u64_stats_fetch_retry_irq(&percpu_upcall_stats->syncp, start));
+
+		stats->upcall_success += local_stats.n_upcall_success;
+		stats->upcall_fail += local_stats.n_upcall_fail;
+	}
+}
+
 /**
  *	ovs_vport_get_options - retrieve device options
  *
diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
index 7d276f60c000..6defacd6d718 100644
--- a/net/openvswitch/vport.h
+++ b/net/openvswitch/vport.h
@@ -32,6 +32,9 @@ struct vport *ovs_vport_locate(const struct net *net, const char *name);
 
 void ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
 
+void ovs_vport_get_upcall_stats(struct vport *vport,
+				struct ovs_vport_upcall_stats *stats);
+
 int ovs_vport_set_options(struct vport *, struct nlattr *options);
 int ovs_vport_get_options(const struct vport *, struct sk_buff *);
 
@@ -78,6 +81,7 @@ struct vport {
 	struct hlist_node hash_node;
 	struct hlist_node dp_hash_node;
 	const struct vport_ops *ops;
+	struct vport_upcall_stats_percpu __percpu *vport_upcall_stats_percpu;
 
 	struct list_head detach_list;
 	struct rcu_head rcu;
-- 
2.27.0

