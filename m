Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5606421C1
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 04:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiLEDAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 22:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiLEDAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 22:00:39 -0500
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5992110B6C;
        Sun,  4 Dec 2022 19:00:37 -0800 (PST)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id ZFF00131;
        Mon, 05 Dec 2022 11:00:31 +0800
Received: from localhost.localdomain (10.180.204.101) by
 jtjnmail201608.home.langchao.com (10.100.2.8) with Microsoft SMTP Server id
 15.1.2507.16; Mon, 5 Dec 2022 11:00:29 +0800
From:   wangchuanlei <wangchuanlei@inspur.com>
To:     <echaudro@redhat.com>, <alexandr.lobakin@intel.com>,
        <pabeni@redhat.com>, <pshelar@ovn.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>
CC:     <wangpeihui@inspur.com>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>, <linux-kernel@vger.kernel.org>,
        wangchuanlei <wangchuanlei@inspur.com>
Subject: [PATCH] [PATCH v7 net-next] net: openvswitch: Add support to count upcall packets
Date:   Sun, 4 Dec 2022 22:00:24 -0500
Message-ID: <20221205030024.3990061-1-wangchuanlei@inspur.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.180.204.101]
tUid:   2022120511003148c8b27a14b98214b07a9e506d28dcbc
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to count upall packets, when kmod of openvswitch
upcall to userspace , here count the number of packets for
upcall succeed and failed, which is a better way to see how
many packets upcalled to userspace(ovs-vswitchd) on every
interfaces.

Here modify format of code used by comments of v6.

Changes since v4 & v5 & v6:
- optimize the function used by comments

Changes since v3:
- use nested NLA_NESTED attribute in netlink message

Changes since v2:
- add count of upcall failed packets

Changes since v1:
- add count of upcall succeed packets

Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
---
 include/uapi/linux/openvswitch.h | 14 ++++++++++
 net/openvswitch/datapath.c       | 47 ++++++++++++++++++++++++++++++++
 net/openvswitch/vport.c          | 40 +++++++++++++++++++++++++++
 net/openvswitch/vport.h          | 16 +++++++++++
 4 files changed, 117 insertions(+)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 94066f87e9ee..8422ebf6885b 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -277,11 +277,25 @@ enum ovs_vport_attr {
 	OVS_VPORT_ATTR_PAD,
 	OVS_VPORT_ATTR_IFINDEX,
 	OVS_VPORT_ATTR_NETNSID,
+	OVS_VPORT_ATTR_UPCALL_STATS,
 	__OVS_VPORT_ATTR_MAX
 };
 
 #define OVS_VPORT_ATTR_MAX (__OVS_VPORT_ATTR_MAX - 1)
 
+/**
+ * enum ovs_vport_upcall_attr - attributes for %OVS_VPORT_UPCALL* commands
+ * @OVS_VPORT_UPCALL_SUCCESS: 64-bit upcall success packets.
+ * @OVS_VPORT_UPCALL_FAIL: 64-bit upcall fail packets.
+ */
+enum ovs_vport_upcall_attr {
+	OVS_VPORT_UPCALL_SUCCESS,
+	OVS_VPORT_UPCALL_FAIL,
+	__OVS_VPORT_UPCALL_MAX
+};
+
+#define OVS_VPORT_UPCALL_MAX (__OVS_VPORT_UPCALL_MAX - 1)
+
 enum {
 	OVS_VXLAN_EXT_UNSPEC,
 	OVS_VXLAN_EXT_GBP,	/* Flag or __u32 */
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index c8a9075ddd0a..d8ca73dac3b0 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -209,6 +209,26 @@ static struct vport *new_vport(const struct vport_parms *parms)
 	return vport;
 }
 
+static void ovs_vport_update_upcall_stats(struct sk_buff *skb,
+					  const struct dp_upcall_info *upcall_info,
+					  bool upcall_result)
+{
+	struct vport *p = OVS_CB(skb)->input_vport;
+	struct vport_upcall_stats_percpu *stats;
+
+	if (upcall_info->cmd != OVS_PACKET_CMD_MISS &&
+	    upcall_info->cmd != OVS_PACKET_CMD_ACTION)
+		return;
+
+	stats = this_cpu_ptr(p->upcall_stats);
+	u64_stats_update_begin(&stats->syncp);
+	if (upcall_result)
+		u64_stats_inc(&stats->n_success);
+	else
+		u64_stats_inc(&stats->n_fail);
+	u64_stats_update_end(&stats->syncp);
+}
+
 void ovs_dp_detach_port(struct vport *p)
 {
 	ASSERT_OVSL();
@@ -216,6 +236,9 @@ void ovs_dp_detach_port(struct vport *p)
 	/* First drop references to device. */
 	hlist_del_rcu(&p->dp_hash_node);
 
+	/* Free percpu memory */
+	free_percpu(p->upcall_stats);
+
 	/* Then destroy it. */
 	ovs_vport_del(p);
 }
@@ -305,6 +328,8 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_buff *skb,
 		err = queue_userspace_packet(dp, skb, key, upcall_info, cutlen);
 	else
 		err = queue_gso_packets(dp, skb, key, upcall_info, cutlen);
+
+	ovs_vport_update_upcall_stats(skb, upcall_info, !err);
 	if (err)
 		goto err;
 
@@ -1825,6 +1850,12 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 		goto err_destroy_portids;
 	}
 
+	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
+	if (!vport->upcall_stats) {
+		err = -ENOMEM;
+		goto err_destroy_portids;
+	}
+
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
 				   info->snd_seq, 0, OVS_DP_CMD_NEW);
 	BUG_ON(err < 0);
@@ -2068,6 +2099,7 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 {
 	struct ovs_header *ovs_header;
 	struct ovs_vport_stats vport_stats;
+	struct nlattr *nla;
 	int err;
 
 	ovs_header = genlmsg_put(skb, portid, seq, &dp_vport_genl_family,
@@ -2097,6 +2129,14 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 			  OVS_VPORT_ATTR_PAD))
 		goto nla_put_failure;
 
+	nla = nla_nest_start_noflag(skb, OVS_VPORT_ATTR_UPCALL_STATS);
+	if (!nla)
+		goto nla_put_failure;
+
+	if (ovs_vport_get_upcall_stats(vport, skb))
+		goto nla_put_failure;
+	nla_nest_end(skb, nla);
+
 	if (ovs_vport_get_upcall_portids(vport, skb))
 		goto nla_put_failure;
 
@@ -2278,6 +2318,12 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 		goto exit_unlock_free;
 	}
 
+	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
+	if (!vport->upcall_stats) {
+		err = -ENOMEM;
+		goto exit_unlock_free;
+	}
+
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
@@ -2507,6 +2553,7 @@ static const struct nla_policy vport_policy[OVS_VPORT_ATTR_MAX + 1] = {
 	[OVS_VPORT_ATTR_OPTIONS] = { .type = NLA_NESTED },
 	[OVS_VPORT_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[OVS_VPORT_ATTR_NETNSID] = { .type = NLA_S32 },
+	[OVS_VPORT_ATTR_UPCALL_STATS] = { .type = NLA_NESTED },
 };
 
 static const struct genl_small_ops dp_vport_genl_ops[] = {
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 82a74f998966..832109e3217e 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -284,6 +284,46 @@ void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
 	stats->tx_packets = dev_stats->tx_packets;
 }
 
+/**
+ *	ovs_vport_get_upcall_stats - retrieve upcall stats
+ *
+ * @vport: vport from which to retrieve the stats.
+ * @skb: sk_buff where upcall stats should be appended.
+ *
+ * Retrieves upcall stats for the given device.
+ *
+ * Must be called with ovs_mutex or rcu_read_lock.
+ */
+int ovs_vport_get_upcall_stats(struct vport *vport, struct sk_buff *skb)
+{
+	int i;
+
+	__u64 tx_success = 0;
+	__u64 tx_fail = 0;
+
+	for_each_possible_cpu(i) {
+		const struct vport_upcall_stats_percpu *upcall_stats;
+		unsigned int start;
+
+		upcall_stats = per_cpu_ptr(vport->upcall_stats, i);
+		do {
+			start = u64_stats_fetch_begin(&upcall_stats->syncp);
+			tx_success += u64_stats_read(&upcall_stats->n_success);
+			tx_fail += u64_stats_read(&upcall_stats->n_fail);
+		} while (u64_stats_fetch_retry(&upcall_stats->syncp, start));
+	}
+
+	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_SUCCESS, tx_success,
+			      OVS_VPORT_ATTR_PAD))
+		return -EMSGSIZE;
+
+	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_FAIL, tx_fail,
+			      OVS_VPORT_ATTR_PAD))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
 /**
  *	ovs_vport_get_options - retrieve device options
  *
diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
index 7d276f60c000..3af18b5faa95 100644
--- a/net/openvswitch/vport.h
+++ b/net/openvswitch/vport.h
@@ -32,6 +32,8 @@ struct vport *ovs_vport_locate(const struct net *net, const char *name);
 
 void ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
 
+int ovs_vport_get_upcall_stats(struct vport *vport, struct sk_buff *skb);
+
 int ovs_vport_set_options(struct vport *, struct nlattr *options);
 int ovs_vport_get_options(const struct vport *, struct sk_buff *);
 
@@ -65,6 +67,7 @@ struct vport_portids {
  * @hash_node: Element in @dev_table hash table in vport.c.
  * @dp_hash_node: Element in @datapath->ports hash table in datapath.c.
  * @ops: Class structure.
+ * @upcall_stats: Upcall stats of every ports.
  * @detach_list: list used for detaching vport in net-exit call.
  * @rcu: RCU callback head for deferred destruction.
  */
@@ -78,6 +81,7 @@ struct vport {
 	struct hlist_node hash_node;
 	struct hlist_node dp_hash_node;
 	const struct vport_ops *ops;
+	struct vport_upcall_stats_percpu __percpu *upcall_stats;
 
 	struct list_head detach_list;
 	struct rcu_head rcu;
@@ -137,6 +141,18 @@ struct vport_ops {
 	struct list_head list;
 };
 
+/**
+ * struct vport_upcall_stats_percpu - per-cpu packet upcall statistics for
+ * a given vport.
+ * @n_success: Number of packets that upcall to userspace succeed.
+ * @n_fail:    Number of packets that upcall to userspace failed.
+ */
+struct vport_upcall_stats_percpu {
+	struct u64_stats_sync syncp;
+	u64_stats_t n_success;
+	u64_stats_t n_fail;
+};
+
 struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *,
 			      const struct vport_parms *);
 void ovs_vport_free(struct vport *);
-- 
2.27.0

