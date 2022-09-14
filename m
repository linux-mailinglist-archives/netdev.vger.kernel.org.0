Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1251E5B87F6
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 14:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiINMPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 08:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiINMPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 08:15:08 -0400
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA54F33E3C;
        Wed, 14 Sep 2022 05:15:05 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id JNE00102;
        Wed, 14 Sep 2022 20:15:02 +0800
Received: from localhost.localdomain (10.180.206.78) by
 jtjnmail201611.home.langchao.com (10.100.2.11) with Microsoft SMTP Server id
 15.1.2507.12; Wed, 14 Sep 2022 20:15:01 +0800
From:   wangchuanlei <wangchuanlei@inspur.com>
To:     <pshelar@ovn.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <wangpeihui@inspur.com>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>, <linux-kernel@vger.kernel.org>,
        wangchuanlei <wangchuanlei@inspur.com>
Subject: [PATCH] [PATCH 1/2] openvswitch: Add support to count upall packets
Date:   Wed, 14 Sep 2022 08:14:59 -0400
Message-ID: <20220914121459.1384093-1-wangchuanlei@inspur.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.180.206.78]
tUid:   2022914201502759d797f42cdb01b7856ef049c625e15
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to count upcall packets on every interface.
I always encounter high cpu use of ovs-vswictchd, this
help to check which interface send too many packets
without open vlog/set switch, and have no influence
on datapath.

Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
---
 include/uapi/linux/openvswitch.h |  5 ++++
 net/openvswitch/datapath.c       | 45 ++++++++++++++++++++++++++++++++
 net/openvswitch/datapath.h       | 10 +++++++
 net/openvswitch/vport.c          | 31 ++++++++++++++++++++++
 net/openvswitch/vport.h          |  4 +++
 5 files changed, 95 insertions(+)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 94066f87e9ee..8ec45511bc41 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -126,6 +126,10 @@ struct ovs_vport_stats {
 	__u64   tx_dropped;		/* no space available in linux  */
 };
 
+struct ovs_vport_upcall_stats {
+	__u64   upcall_packets;             /* total packets upcalls */
+};
+
 /* Allow last Netlink attribute to be unaligned */
 #define OVS_DP_F_UNALIGNED	(1 << 0)
 
@@ -277,6 +281,7 @@ enum ovs_vport_attr {
 	OVS_VPORT_ATTR_PAD,
 	OVS_VPORT_ATTR_IFINDEX,
 	OVS_VPORT_ATTR_NETNSID,
+	OVS_VPORT_ATTR_UPCALL_STATS, /* struct ovs_vport_upcall_stats */
 	__OVS_VPORT_ATTR_MAX
 };
 
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index c8a9075ddd0a..f4e1f67dc57a 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -209,6 +209,23 @@ static struct vport *new_vport(const struct vport_parms *parms)
 	return vport;
 }
 
+static void ovs_vport_upcalls(struct sk_buff *skb,
+			      const struct dp_upcall_info *upcall_info)
+{
+	if (upcall_info->cmd == OVS_PACKET_CMD_MISS ||
+	    upcall_info->cmd == OVS_PACKET_CMD_ACTION) {
+		const struct vport *p = OVS_CB(skb)->input_vport;
+		struct vport_upcall_stats_percpu *vport_stats;
+		u64 *stats_counter_upcall;
+
+		vport_stats = this_cpu_ptr(p->vport_upcall_stats_percpu);
+		stats_counter_upcall = &vport_stats->n_missed;
+		u64_stats_update_begin(&vport_stats->syncp);
+		(*stats_counter_upcall)++;
+		u64_stats_update_end(&vport_stats->syncp);
+	}
+}
+
 void ovs_dp_detach_port(struct vport *p)
 {
 	ASSERT_OVSL();
@@ -216,6 +233,9 @@ void ovs_dp_detach_port(struct vport *p)
 	/* First drop references to device. */
 	hlist_del_rcu(&p->dp_hash_node);
 
+	/* Free percpu memory */
+	free_percpu(p->vport_upcall_stats_percpu);
+
 	/* Then destroy it. */
 	ovs_vport_del(p);
 }
@@ -308,6 +328,8 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_buff *skb,
 	if (err)
 		goto err;
 
+	ovs_vport_upcalls(skb, upcall_info);
+
 	return 0;
 
 err:
@@ -1825,6 +1847,13 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
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
@@ -2068,6 +2097,7 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 {
 	struct ovs_header *ovs_header;
 	struct ovs_vport_stats vport_stats;
+	struct ovs_vport_upcall_stats vport_upcall_stats;
 	int err;
 
 	ovs_header = genlmsg_put(skb, portid, seq, &dp_vport_genl_family,
@@ -2097,6 +2127,13 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
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
 
@@ -2278,6 +2315,14 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
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
index 0cd29971a907..57fc002142a3 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -50,6 +50,16 @@ struct dp_stats_percpu {
 	struct u64_stats_sync syncp;
 };
 
+/**
+ * struct vport_upcall_stats_percpu - per-cpu packet upcall statistics for
+ * a given vport.
+ * @n_missed: Number of packets that upcall to userspace.
+ */
+struct vport_upcall_stats_percpu {
+	u64 n_missed;
+	struct u64_stats_sync syncp;
+};
+
 /**
  * struct dp_nlsk_pids - array of netlink portids of for a datapath.
  *                       This is used when OVS_DP_F_DISPATCH_UPCALL_PER_CPU
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 82a74f998966..c05056f907f0 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -284,6 +284,37 @@ void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
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
+	stats->upcall_packets = 0;
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
+		stats->upcall_packets += local_stats.n_missed;
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

