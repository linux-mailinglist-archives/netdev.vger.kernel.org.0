Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41ADA64514C
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiLGBjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiLGBjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:39:10 -0500
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83F822299;
        Tue,  6 Dec 2022 17:39:07 -0800 (PST)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id BDU00001;
        Wed, 07 Dec 2022 09:39:01 +0800
Received: from localhost.localdomain (10.180.204.101) by
 jtjnmail201609.home.langchao.com (10.100.2.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 09:39:00 +0800
From:   wangchuanlei <wangchuanlei@inspur.com>
To:     <leon@kernel.org>, <jiri@resnulli.us>, <echaudro@redhat.com>,
        <alexandr.lobakin@intel.com>, <pabeni@redhat.com>,
        <pshelar@ovn.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>
CC:     <wangpeihui@inspur.com>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>, <linux-kernel@vger.kernel.org>,
        wangchuanlei <wangchuanlei@inspur.com>
Subject: [PATCH] [PATCH v9 net-next] net: openvswitch: Add support to count upcall packets
Date:   Tue, 6 Dec 2022 20:38:57 -0500
Message-ID: <20221207013857.4066561-1-wangchuanlei@inspur.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.180.204.101]
X-ClientProxiedBy: Jtjnmail201614.home.langchao.com (10.100.2.14) To
 jtjnmail201609.home.langchao.com (10.100.2.9)
tUid:   20221207093901754a77e7118c7e6d6eecfe049eeb3e5f
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to count upall packets, when kmod of openvswitch
upcall to count the number of packets for upcall succeed and
failed, which is a better way to see how many packets upcalled
on every interfaces.

Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
---
Changes since v4 - v9:
- optimize the function used by comments

Changes since v3:
- use nested NLA_NESTED attribute in netlink message

Changes since v2:
- add count of upcall failed packets

Changes since v1:
- add count of upcall succeed packets
---
 include/uapi/linux/openvswitch.h | 14 +++++++++
 net/openvswitch/datapath.c       | 41 ++++++++++++++++++++++++++
 net/openvswitch/vport.c          | 50 ++++++++++++++++++++++++++++++++
 net/openvswitch/vport.h          | 16 ++++++++++
 4 files changed, 121 insertions(+)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 94066f87e9ee..c5d62ee82567 100644
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
+	OVS_VPORT_UPCALL_ATTR_SUCCESS,
+	OVS_VPORT_UPCALL_ATTR_FAIL,
+	__OVS_VPORT_UPCALL_ATTR_MAX
+};
+
+#define OVS_VPORT_UPCALL_ATTR_MAX (__OVS_VPORT_UPCALL_ATTR_MAX - 1)
+
 enum {
 	OVS_VXLAN_EXT_UNSPEC,
 	OVS_VXLAN_EXT_GBP,	/* Flag or __u32 */
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index c8a9075ddd0a..1d379d943e00 100644
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
@@ -2097,6 +2128,9 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 			  OVS_VPORT_ATTR_PAD))
 		goto nla_put_failure;
 
+	if (ovs_vport_get_upcall_stats(vport, skb))
+		goto nla_put_failure;
+
 	if (ovs_vport_get_upcall_portids(vport, skb))
 		goto nla_put_failure;
 
@@ -2278,6 +2312,12 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
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
@@ -2507,6 +2547,7 @@ static const struct nla_policy vport_policy[OVS_VPORT_ATTR_MAX + 1] = {
 	[OVS_VPORT_ATTR_OPTIONS] = { .type = NLA_NESTED },
 	[OVS_VPORT_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[OVS_VPORT_ATTR_NETNSID] = { .type = NLA_S32 },
+	[OVS_VPORT_ATTR_UPCALL_STATS] = { .type = NLA_NESTED },
 };
 
 static const struct genl_small_ops dp_vport_genl_ops[] = {
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 82a74f998966..7e0f5c45b512 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -284,6 +284,56 @@ void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
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
+	struct nlattr *nla;
+	int i;
+
+	__u64 tx_success = 0;
+	__u64 tx_fail = 0;
+
+	for_each_possible_cpu(i) {
+		const struct vport_upcall_stats_percpu *stats;
+		unsigned int start;
+
+		stats = per_cpu_ptr(vport->upcall_stats, i);
+		do {
+			start = u64_stats_fetch_begin(&stats->syncp);
+			tx_success += u64_stats_read(&stats->n_success);
+			tx_fail += u64_stats_read(&stats->n_fail);
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
+	}
+
+	nla = nla_nest_start_noflag(skb, OVS_VPORT_ATTR_UPCALL_STATS);
+	if (!nla)
+		return -EMSGSIZE;
+
+	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_ATTR_SUCCESS, tx_success,
+			      OVS_VPORT_ATTR_PAD)) {
+		nla_nest_cancel(skb, nla);
+		return -EMSGSIZE;
+	}
+
+	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_ATTR_FAIL, tx_fail,
+			      OVS_VPORT_ATTR_PAD)) {
+		nla_nest_cancel(skb, nla);
+		return -EMSGSIZE;
+	}
+	nla_nest_end(skb, nla);
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

