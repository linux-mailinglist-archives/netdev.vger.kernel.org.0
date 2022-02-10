Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECEA4B104D
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbiBJOYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:24:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242883AbiBJOYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:24:04 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88722D2
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 06:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P45QKWgwTJcEnV4qdDBMJHNPO/CYLSrO9s583PhxSss=; b=ccWhdGjt4uPw7tfKFLha5pqtxz
        vHPbeoh488KWbXd22Roha4ibPXn/a48JTT6YtHW/2I1GlOCkYxMsLzhwBXvRxTg+t7X8ayQjrSibK
        US9IR4GbDD0Qm4M86hnLD+CBk+D4JC8CNQnEhEbHrDyJO2S5hUjeMHysWzU2COBeJN/o=;
Received: from p200300daa71e0b00a1d8c0925f6cfb96.dip0.t-ipconnect.de ([2003:da:a71e:b00:a1d8:c092:5f6c:fb96] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nIAMc-0002Vw-3X
        for netdev@vger.kernel.org; Thu, 10 Feb 2022 15:24:02 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [RFC 2/2] net: bridge: add a software fast-path implementation
Date:   Thu, 10 Feb 2022 15:24:01 +0100
Message-Id: <20220210142401.4912-2-nbd@nbd.name>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220210142401.4912-1-nbd@nbd.name>
References: <20220210142401.4912-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This opt-in feature creates a per-port cache of dest_mac+src_mac+vlan tuples
with enough information to quickly push frames to the correct destination port.
It can be enabled per-port

Cache entries are automatically created when a skb is forwarded from one port
to another, and only if there is room and both ports have the offload flag set.

Whenever a fdb entry changes, all corresponding cache entries associated with
it are automatically flushed.

In my test on MT7622 when bridging 1.85 Gbit/s from Ethernet to WLAN, this
significantly improves bridging performance, especially with VLAN filtering
enabled:

CPU usage:
- no offload, no VLAN: 79%
- no offload, VLAN: 84%
- offload, no VLAN: 73-74%
- offload, VLAN: 74%

MT7622 has support for hardware offloading of packets from LAN to WLAN, both
routed and bridged. For bridging it needs source/destination MAC address entries
like the ones stored in this offload cache. This code will be extended later
in order to create appropriate flow_offload rules to handle this

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/if_bridge.h       |   1 +
 include/uapi/linux/if_link.h    |   3 +
 net/bridge/Kconfig              |  10 +
 net/bridge/Makefile             |   1 +
 net/bridge/br.c                 |   8 +
 net/bridge/br_device.c          |   4 +
 net/bridge/br_fdb.c             |  20 +-
 net/bridge/br_forward.c         |   3 +
 net/bridge/br_if.c              |   4 +
 net/bridge/br_input.c           |   5 +
 net/bridge/br_netlink.c         |  31 ++-
 net/bridge/br_offload.c         | 466 ++++++++++++++++++++++++++++++++
 net/bridge/br_private.h         |  30 +-
 net/bridge/br_private_offload.h |  53 ++++
 net/bridge/br_stp.c             |   3 +
 net/bridge/br_vlan_tunnel.c     |   3 +
 net/core/rtnetlink.c            |   2 +-
 17 files changed, 641 insertions(+), 6 deletions(-)
 create mode 100644 net/bridge/br_offload.c
 create mode 100644 net/bridge/br_private_offload.h

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 18d3b264b754..944630df0ec3 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -59,6 +59,7 @@ struct br_ip_list {
 #define BR_MRP_LOST_IN_CONT	BIT(19)
 #define BR_TX_FWD_OFFLOAD	BIT(20)
 #define BR_BPDU_FILTER		BIT(21)
+#define BR_OFFLOAD		BIT(22)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4c847c2d6afa..a7349414a27f 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -482,6 +482,8 @@ enum {
 	IFLA_BR_VLAN_STATS_PER_PORT,
 	IFLA_BR_MULTI_BOOLOPT,
 	IFLA_BR_MCAST_QUERIER_STATE,
+	IFLA_BR_OFFLOAD_CACHE_SIZE,
+	IFLA_BR_OFFLOAD_CACHE_RESERVED,
 	__IFLA_BR_MAX,
 };
 
@@ -538,6 +540,7 @@ enum {
 	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	IFLA_BRPORT_BPDU_FILTER,
+	IFLA_BRPORT_OFFLOAD,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
index 3c8ded7d3e84..3f93da1f66da 100644
--- a/net/bridge/Kconfig
+++ b/net/bridge/Kconfig
@@ -34,6 +34,16 @@ config BRIDGE
 
 	  If unsure, say N.
 
+config BRIDGE_OFFLOAD
+	bool "Offloading support"
+	depends on BRIDGE
+	help
+	  If you say Y here, you can turn on a per-port offload flag, which
+	  will cache src/destination mac address flows between ports and handle
+	  them faster.
+
+	  If unsure, say N.
+
 config BRIDGE_IGMP_SNOOPING
 	bool "IGMP/MLD snooping"
 	depends on BRIDGE
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 7fb9a021873b..166f76b5f258 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -11,6 +11,7 @@ bridge-y	:= br.o br_device.o br_fdb.o br_forward.o br_if.o br_input.o \
 			br_netlink_tunnel.o br_arp_nd_proxy.o
 
 bridge-$(CONFIG_SYSFS) += br_sysfs_if.o br_sysfs_br.o
+bridge-$(CONFIG_BRIDGE_OFFLOAD) += br_offload.o
 
 bridge-$(subst m,y,$(CONFIG_BRIDGE_NETFILTER)) += br_nf_core.o
 
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 1fac72cc617f..bd46e5e20b30 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -18,6 +18,7 @@
 #include <net/switchdev.h>
 
 #include "br_private.h"
+#include "br_private_offload.h"
 
 /*
  * Handle changes in state of network devices enslaved to a bridge.
@@ -381,6 +382,10 @@ static int __init br_init(void)
 	if (err)
 		goto err_out;
 
+	err = br_offload_init();
+	if (err)
+		goto err_out0;
+
 	err = register_pernet_subsys(&br_net_ops);
 	if (err)
 		goto err_out1;
@@ -430,6 +435,8 @@ static int __init br_init(void)
 err_out2:
 	unregister_pernet_subsys(&br_net_ops);
 err_out1:
+	br_offload_fini();
+err_out0:
 	br_fdb_fini();
 err_out:
 	stp_proto_unregister(&br_stp_proto);
@@ -452,6 +459,7 @@ static void __exit br_deinit(void)
 #if IS_ENABLED(CONFIG_ATM_LANE)
 	br_fdb_test_addr_hook = NULL;
 #endif
+	br_offload_fini();
 	br_fdb_fini();
 }
 
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8d6bab244c4a..10c4e4039c7b 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -524,6 +524,10 @@ void br_dev_setup(struct net_device *dev)
 	br->bridge_hello_time = br->hello_time = 2 * HZ;
 	br->bridge_forward_delay = br->forward_delay = 15 * HZ;
 	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
+#ifdef CONFIG_BRIDGE_OFFLOAD
+	br->offload_cache_size = 128;
+	br->offload_cache_reserved = 8;
+#endif
 	dev->max_mtu = ETH_MAX_MTU;
 
 	br_netfilter_rtable_init(br);
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6ccda68bd473..49abfc13a323 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -23,6 +23,7 @@
 #include <net/switchdev.h>
 #include <trace/events/bridge.h>
 #include "br_private.h"
+#include "br_private_offload.h"
 
 static const struct rhashtable_params br_fdb_rht_params = {
 	.head_offset = offsetof(struct net_bridge_fdb_entry, rhnode),
@@ -185,6 +186,8 @@ static void fdb_notify(struct net_bridge *br,
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
+	br_offload_fdb_update(fdb);
+
 	if (swdev_notify)
 		br_switchdev_fdb_notify(br, fdb, type);
 
@@ -393,6 +396,10 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 	fdb->key.vlan_id = vid;
 	fdb->flags = flags;
 	fdb->updated = fdb->used = jiffies;
+#ifdef CONFIG_BRIDGE_OFFLOAD
+	INIT_HLIST_HEAD(&fdb->offload_in);
+	INIT_HLIST_HEAD(&fdb->offload_out);
+#endif
 	err = rhashtable_lookup_insert_fast(&br->fdb_hash_tbl, &fdb->rhnode,
 					    br_fdb_rht_params);
 	if (err) {
@@ -527,8 +534,10 @@ void br_fdb_cleanup(struct work_struct *work)
 	 */
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(f, &br->fdb_list, fdb_node) {
-		unsigned long this_timer = f->updated + delay;
+		unsigned long this_timer;
 
+		br_offload_fdb_refresh_time(br, f);
+		this_timer = f->updated + delay;
 		if (test_bit(BR_FDB_STATIC, &f->flags) ||
 		    test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &f->flags)) {
 			if (test_bit(BR_FDB_NOTIFY, &f->flags)) {
@@ -651,8 +660,11 @@ int br_fdb_fillbuf(struct net_bridge *br, void *buf,
 		if (num >= maxnum)
 			break;
 
-		if (has_expired(br, f))
-			continue;
+		if (has_expired(br, f)) {
+			if (!br_offload_fdb_refresh_time(br, f) ||
+			    has_expired(br, f))
+				continue;
+		}
 
 		/* ignore pseudo entry for local MAC address */
 		if (!f->dst)
@@ -797,6 +809,7 @@ int br_fdb_dump(struct sk_buff *skb,
 		if (!filter_dev && f->dst)
 			goto skip;
 
+		br_offload_fdb_refresh_time(br, f);
 		err = fdb_fill_info(skb, br, f,
 				    NETLINK_CB(cb->skb).portid,
 				    cb->nlh->nlmsg_seq,
@@ -831,6 +844,7 @@ int br_fdb_get(struct sk_buff *skb,
 		goto errout;
 	}
 
+	br_offload_fdb_refresh_time(br, f);
 	err = fdb_fill_info(skb, br, f, portid, seq,
 			    RTM_NEWNEIGH, 0);
 errout:
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 9fe5c888f27d..6d9025106d9d 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -16,6 +16,7 @@
 #include <linux/if_vlan.h>
 #include <linux/netfilter_bridge.h>
 #include "br_private.h"
+#include "br_private_offload.h"
 
 /* Don't forward packets to originating port or forwarding disabled */
 static inline int should_deliver(const struct net_bridge_port *p,
@@ -32,6 +33,8 @@ static inline int should_deliver(const struct net_bridge_port *p,
 
 int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
+	br_offload_output(skb);
+
 	skb_push(skb, ETH_HLEN);
 	if (!is_skb_forwardable(skb->dev, skb))
 		goto drop;
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 55f47cadb114..c68c7f6cc429 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -25,6 +25,7 @@
 #include <net/net_namespace.h>
 
 #include "br_private.h"
+#include "br_private_offload.h"
 
 /*
  * Determine initial path cost based on speed.
@@ -772,6 +773,9 @@ void br_port_flags_change(struct net_bridge_port *p, unsigned long mask)
 
 	if (mask & BR_NEIGH_SUPPRESS)
 		br_recalculate_neigh_suppress_enabled(br);
+
+	if (mask & BR_OFFLOAD)
+		br_offload_port_state(p);
 }
 
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag)
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index d8263c4849c1..b606ca06ff2d 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -22,6 +22,7 @@
 #include <linux/rculist.h>
 #include "br_private.h"
 #include "br_private_tunnel.h"
+#include "br_private_offload.h"
 
 static int
 br_netif_receive_skb(struct net *net, struct sock *sk, struct sk_buff *skb)
@@ -164,6 +165,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 			dst->used = now;
 		br_forward(dst->dst, skb, local_rcv, false);
 	} else {
+		br_offload_skb_disable(skb);
 		if (!mcast_hit)
 			br_flood(br, skb, pkt_type, local_rcv, false);
 		else
@@ -293,6 +295,9 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 
 	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
 
+	if (br_offload_input(p, skb))
+		return RX_HANDLER_CONSUMED;
+
 	p = br_port_get_rcu(skb->dev);
 	if (p->flags & BR_VLAN_TUNNEL)
 		br_handle_ingress_vlan_tunnel(skb, p, nbp_vlan_group_rcu(p));
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 11215c55adc2..994aca4b633a 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -19,6 +19,7 @@
 #include "br_private_cfm.h"
 #include "br_private_tunnel.h"
 #include "br_private_mcast_eht.h"
+#include "br_private_offload.h"
 
 static int __get_num_vlan_infos(struct net_bridge_vlan_group *vg,
 				u32 filter_mask)
@@ -185,6 +186,7 @@ static inline size_t br_port_info_size(void)
 		+ nla_total_size(1)	/* IFLA_BRPORT_NEIGH_SUPPRESS */
 		+ nla_total_size(1)	/* IFLA_BRPORT_ISOLATED */
 		+ nla_total_size(1)	/* IFLA_BRPORT_BPDU_FILTER */
+		+ nla_total_size(1)	/* IFLA_BRPORT_OFFLOAD */
 		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_ROOT_ID */
 		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_BRIDGE_ID */
 		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_DESIGNATED_PORT */
@@ -271,7 +273,8 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_BRPORT_MRP_IN_OPEN,
 		       !!(p->flags & BR_MRP_LOST_IN_CONT)) ||
 	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)) ||
-	    nla_put_u8(skb, IFLA_BRPORT_BPDU_FILTER, !!(p->flags & BR_BPDU_FILTER)))
+	    nla_put_u8(skb, IFLA_BRPORT_BPDU_FILTER, !!(p->flags & BR_BPDU_FILTER)) ||
+	    nla_put_u8(skb, IFLA_BRPORT_OFFLOAD, !!(p->flags & BR_OFFLOAD)))
 		return -EMSGSIZE;
 
 	timerval = br_timer_value(&p->message_age_timer);
@@ -832,6 +835,7 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
 	[IFLA_BRPORT_BACKUP_PORT] = { .type = NLA_U32 },
 	[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT] = { .type = NLA_U32 },
 	[IFLA_BRPORT_BPDU_FILTER] = { .type = NLA_U8 },
+	[IFLA_BRPORT_OFFLOAD] = { .type = NLA_U8 },
 };
 
 /* Change the state of the port and notify spanning tree */
@@ -897,6 +901,7 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
 	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
 	br_set_port_flag(p, tb, IFLA_BRPORT_BPDU_FILTER, BR_BPDU_FILTER);
+	br_set_port_flag(p, tb, IFLA_BRPORT_OFFLOAD, BR_OFFLOAD);
 
 	changed_mask = old_flags ^ p->flags;
 
@@ -1165,6 +1170,8 @@ static const struct nla_policy br_policy[IFLA_BR_MAX + 1] = {
 	[IFLA_BR_VLAN_STATS_PER_PORT] = { .type = NLA_U8 },
 	[IFLA_BR_MULTI_BOOLOPT] =
 		NLA_POLICY_EXACT_LEN(sizeof(struct br_boolopt_multi)),
+	[IFLA_BR_OFFLOAD_CACHE_SIZE] = { .type = NLA_U32 },
+	[IFLA_BR_OFFLOAD_CACHE_RESERVED] = { .type = NLA_U32 },
 };
 
 static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
@@ -1424,6 +1431,19 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 		br_opt_toggle(br, BROPT_NF_CALL_ARPTABLES, !!val);
 	}
 #endif
+#ifdef CONFIG_BRIDGE_OFFLOAD
+	if (data[IFLA_BR_OFFLOAD_CACHE_SIZE]) {
+		u32 val = nla_get_u32(data[IFLA_BR_OFFLOAD_CACHE_SIZE]);
+
+		br_offload_set_cache_size(br, val);
+	}
+
+	if (data[IFLA_BR_OFFLOAD_CACHE_RESERVED]) {
+		u32 val = nla_get_u32(data[IFLA_BR_OFFLOAD_CACHE_RESERVED]);
+
+		br_offload_set_cache_reserved(br, val);
+	}
+#endif
 
 	if (data[IFLA_BR_MULTI_BOOLOPT]) {
 		struct br_boolopt_multi *bm;
@@ -1512,6 +1532,10 @@ static size_t br_get_size(const struct net_device *brdev)
 	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_NF_CALL_IPTABLES */
 	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_NF_CALL_IP6TABLES */
 	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_NF_CALL_ARPTABLES */
+#endif
+#ifdef CONFIG_BRIDGE_OFFLOAD
+	       nla_total_size(sizeof(u32)) +	/* IFLA_BR_OFFLOAD_CACHE_SIZE */
+	       nla_total_size(sizeof(u32)) +	/* IFLA_BR_OFFLOAD_CACHE_RESERVED */
 #endif
 	       nla_total_size(sizeof(struct br_boolopt_multi)) + /* IFLA_BR_MULTI_BOOLOPT */
 	       0;
@@ -1636,6 +1660,11 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
 		       br_opt_get(br, BROPT_NF_CALL_ARPTABLES) ? 1 : 0))
 		return -EMSGSIZE;
 #endif
+#ifdef CONFIG_BRIDGE_OFFLOAD
+	if (nla_put_u32(skb, IFLA_BR_OFFLOAD_CACHE_SIZE, br->offload_cache_size) ||
+	    nla_put_u32(skb, IFLA_BR_OFFLOAD_CACHE_RESERVED, br->offload_cache_reserved))
+		return -EMSGSIZE;
+#endif
 
 	return 0;
 }
diff --git a/net/bridge/br_offload.c b/net/bridge/br_offload.c
new file mode 100644
index 000000000000..8cb9266e6cf9
--- /dev/null
+++ b/net/bridge/br_offload.c
@@ -0,0 +1,466 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/workqueue.h>
+#include "br_private.h"
+#include "br_private_offload.h"
+
+static DEFINE_SPINLOCK(offload_lock);
+
+struct bridge_flow_key {
+	u8 dest[ETH_ALEN];
+	u8 src[ETH_ALEN];
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+	u16 vlan_tag;
+	bool vlan_present;
+#endif
+};
+
+struct bridge_flow {
+	struct net_bridge_port *port;
+	struct rhash_head node;
+	struct bridge_flow_key key;
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+	bool vlan_out_present;
+	u16 vlan_out;
+#endif
+
+	unsigned long used;
+	struct net_bridge_fdb_entry *fdb_in, *fdb_out;
+	struct hlist_node fdb_list_in, fdb_list_out;
+
+	struct rcu_head rcu;
+};
+
+static const struct rhashtable_params flow_params = {
+	.automatic_shrinking = true,
+	.head_offset = offsetof(struct bridge_flow, node),
+	.key_len = sizeof(struct bridge_flow_key),
+	.key_offset = offsetof(struct bridge_flow, key),
+};
+
+static struct kmem_cache *offload_cache __read_mostly;
+
+static void
+flow_rcu_free(struct rcu_head *head)
+{
+	struct bridge_flow *flow;
+
+	flow = container_of(head, struct bridge_flow, rcu);
+	kmem_cache_free(offload_cache, flow);
+}
+
+static void
+__br_offload_flow_free(struct bridge_flow *flow)
+{
+	flow->used = 0;
+	hlist_del(&flow->fdb_list_in);
+	hlist_del(&flow->fdb_list_out);
+
+	call_rcu(&flow->rcu, flow_rcu_free);
+}
+
+static void
+br_offload_flow_free(struct bridge_flow *flow)
+{
+	if (rhashtable_remove_fast(&flow->port->offload.rht, &flow->node,
+				   flow_params) != 0)
+		return;
+
+	__br_offload_flow_free(flow);
+}
+
+static bool
+br_offload_flow_fdb_refresh_time(struct bridge_flow *flow,
+				 struct net_bridge_fdb_entry *fdb)
+{
+	if (!time_after(flow->used, fdb->updated))
+		return false;
+
+	fdb->updated = flow->used;
+
+	return true;
+}
+
+
+static void
+br_offload_flow_refresh_time(struct bridge_flow *flow)
+{
+	br_offload_flow_fdb_refresh_time(flow, flow->fdb_in);
+	br_offload_flow_fdb_refresh_time(flow, flow->fdb_out);
+}
+
+static void
+br_offload_destroy_cb(void *ptr, void *arg)
+{
+	struct bridge_flow *flow = ptr;
+
+	br_offload_flow_refresh_time(flow);
+	__br_offload_flow_free(flow);
+}
+
+static bool
+br_offload_need_gc(struct net_bridge_port *p)
+{
+	return (atomic_read(&p->offload.rht.nelems) +
+	        p->br->offload_cache_reserved) >= p->br->offload_cache_size;
+}
+
+static void
+br_offload_gc_work(struct work_struct *work)
+{
+	struct rhashtable_iter hti;
+	struct net_bridge_port *p;
+	struct bridge_flow *gc_flow = NULL;
+	struct bridge_flow *flow;
+	unsigned long gc_used;
+
+	p = container_of(work, struct net_bridge_port, offload.gc_work);
+
+	if (!br_offload_need_gc(p))
+		return;
+
+	rhashtable_walk_enter(&p->offload.rht, &hti);
+	rhashtable_walk_start(&hti);
+	while ((flow = rhashtable_walk_next(&hti)) != NULL) {
+		unsigned long used;
+
+		if (IS_ERR(flow))
+			continue;
+
+		used = READ_ONCE(flow->used);
+		if (!used)
+			continue;
+
+		if (gc_flow && !time_before(used, gc_used))
+			continue;
+
+		gc_flow = flow;
+		gc_used = used;
+	}
+	rhashtable_walk_stop(&hti);
+	rhashtable_walk_exit(&hti);
+
+	if (!gc_flow)
+		return;
+
+	spin_lock_bh(&offload_lock);
+	if (br_offload_need_gc(p) && gc_flow &&
+	    gc_flow->used == gc_used)
+		br_offload_flow_free(gc_flow);
+	if (p->offload.enabled && br_offload_need_gc(p))
+		queue_work(system_long_wq, work);
+	spin_unlock_bh(&offload_lock);
+
+}
+
+void br_offload_port_state(struct net_bridge_port *p)
+{
+	struct net_bridge_port_offload *o = &p->offload;
+	bool enabled = true;
+	bool flush = false;
+
+	if (p->state != BR_STATE_FORWARDING ||
+	    !(p->flags & BR_OFFLOAD))
+		enabled = false;
+
+	spin_lock_bh(&offload_lock);
+	if (o->enabled == enabled)
+		goto out;
+
+	if (enabled) {
+		if (!o->gc_work.func)
+			INIT_WORK(&o->gc_work, br_offload_gc_work);
+		rhashtable_init(&o->rht, &flow_params);
+	} else {
+		flush = true;
+		rhashtable_free_and_destroy(&o->rht, br_offload_destroy_cb, o);
+	}
+
+	o->enabled = enabled;
+
+out:
+	spin_unlock_bh(&offload_lock);
+
+	if (flush)
+		flush_work(&o->gc_work);
+}
+
+void br_offload_fdb_update(const struct net_bridge_fdb_entry *fdb)
+{
+	struct bridge_flow *f;
+	struct hlist_node *tmp;
+
+	spin_lock_bh(&offload_lock);
+
+	hlist_for_each_entry_safe(f, tmp, &fdb->offload_in, fdb_list_in) {
+		br_offload_flow_refresh_time(f);
+		br_offload_flow_free(f);
+	}
+	hlist_for_each_entry_safe(f, tmp, &fdb->offload_out, fdb_list_out) {
+		br_offload_flow_refresh_time(f);
+		br_offload_flow_free(f);
+	}
+
+	spin_unlock_bh(&offload_lock);
+}
+
+bool br_offload_fdb_refresh_time(struct net_bridge *br,
+				 struct net_bridge_fdb_entry *fdb)
+{
+	unsigned long timeout = jiffies - br->ageing_time;
+	struct bridge_flow *f;
+	struct hlist_node *tmp;
+	bool ret = false;
+
+	spin_lock_bh(&offload_lock);
+
+	hlist_for_each_entry_safe(f, tmp, &fdb->offload_in, fdb_list_in) {
+		if (br_offload_flow_fdb_refresh_time(f, fdb))
+			ret = true;
+		if (time_before(f->used, timeout))
+			br_offload_flow_free(f);
+	}
+
+	hlist_for_each_entry_safe(f, tmp, &fdb->offload_out, fdb_list_out) {
+		if (br_offload_flow_fdb_refresh_time(f, fdb))
+			ret = true;
+		if (time_before(f->used, timeout))
+			br_offload_flow_free(f);
+	}
+
+	spin_unlock_bh(&offload_lock);
+
+	return ret;
+}
+
+static void
+br_offload_prepare_key(struct net_bridge_port *p, struct bridge_flow_key *key,
+		       struct sk_buff *skb)
+{
+	memset(key, 0, sizeof(*key));
+	memcpy(key, eth_hdr(skb), 2 * ETH_ALEN);
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+	if (!br_opt_get(p->br, BROPT_VLAN_ENABLED))
+		return;
+
+	if (!skb_vlan_tag_present(skb) || skb->vlan_proto != p->br->vlan_proto)
+		return;
+
+	key->vlan_present = true;
+	key->vlan_tag = skb_vlan_tag_get_id(skb);
+#endif
+}
+
+void br_offload_output(struct sk_buff *skb)
+{
+	struct net_bridge_port_offload *o;
+	struct br_input_skb_cb *cb = (struct br_input_skb_cb *)skb->cb;
+	struct net_bridge_port *p, *inp;
+	struct net_device *dev;
+	struct net_bridge_fdb_entry *fdb_in, *fdb_out;
+	struct net_bridge_vlan_group *vg;
+	struct bridge_flow_key key;
+	struct bridge_flow *flow;
+	u16 vlan;
+
+	if (!cb->offload)
+		return;
+
+	rcu_read_lock();
+
+	p = br_port_get_rcu(skb->dev);
+	if (!p)
+		goto out;
+
+	o = &p->offload;
+	if (!o->enabled)
+		goto out;
+
+	if (atomic_read(&p->offload.rht.nelems) >= p->br->offload_cache_size)
+		goto out;
+
+	dev = dev_get_by_index_rcu(dev_net(p->br->dev), cb->input_ifindex);
+	if (!dev)
+		goto out;
+
+	inp = br_port_get_rcu(dev);
+	if (!p)
+		goto out;
+
+	vg = nbp_vlan_group_rcu(inp);
+	vlan = cb->input_vlan_present ? cb->input_vlan_tag : br_get_pvid(vg);
+	fdb_in = br_fdb_find_rcu(p->br, eth_hdr(skb)->h_source, vlan);
+	if (!fdb_in)
+		goto out;
+
+	vg = nbp_vlan_group_rcu(p);
+	vlan = skb_vlan_tag_present(skb) ? skb_vlan_tag_get_id(skb) : br_get_pvid(vg);
+	fdb_out = br_fdb_find_rcu(p->br, eth_hdr(skb)->h_dest, vlan);
+	if (!fdb_out)
+		goto out;
+
+	br_offload_prepare_key(p, &key, skb);
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+	key.vlan_present = cb->input_vlan_present;
+	key.vlan_tag = cb->input_vlan_tag;
+#endif
+
+	flow = kmem_cache_alloc(offload_cache, GFP_ATOMIC);
+	flow->port = fdb_in->dst;
+	memcpy(&flow->key, &key, sizeof(key));
+
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+	flow->vlan_out_present = skb_vlan_tag_present(skb);
+	flow->vlan_out = skb_vlan_tag_get(skb);
+#endif
+
+	flow->fdb_in = fdb_in;
+	flow->fdb_out = fdb_out;
+	flow->used = jiffies;
+
+	spin_lock_bh(&offload_lock);
+	if (!o->enabled ||
+	    atomic_read(&p->offload.rht.nelems) >= p->br->offload_cache_size ||
+	    rhashtable_insert_fast(&flow->port->offload.rht, &flow->node, flow_params)) {
+		kmem_cache_free(offload_cache, flow);
+		goto out_unlock;
+	}
+
+	hlist_add_head(&flow->fdb_list_in, &fdb_in->offload_in);
+	hlist_add_head(&flow->fdb_list_out, &fdb_out->offload_out);
+
+	if (br_offload_need_gc(p))
+		queue_work(system_long_wq, &p->offload.gc_work);
+
+out_unlock:
+	spin_unlock_bh(&offload_lock);
+
+out:
+	rcu_read_unlock();
+}
+
+bool br_offload_input(struct net_bridge_port *p, struct sk_buff *skb)
+{
+	struct net_bridge_port_offload *o = &p->offload;
+	struct br_input_skb_cb *cb = (struct br_input_skb_cb *)skb->cb;
+	struct bridge_flow_key key;
+	struct net_bridge_port *dst;
+	struct bridge_flow *flow;
+	unsigned long now = jiffies;
+	bool ret = false;
+
+	if (skb->len < sizeof(key))
+		return false;
+
+	if (!o->enabled)
+		return false;
+
+	if (is_multicast_ether_addr(eth_hdr(skb)->h_dest))
+		return false;
+
+	br_offload_prepare_key(p, &key, skb);
+
+	rcu_read_lock();
+	flow = rhashtable_lookup(&o->rht, &key, flow_params);
+	if (!flow) {
+		cb->offload = 1;
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+		cb->input_vlan_present = key.vlan_present != 0;
+		cb->input_vlan_tag = key.vlan_tag;
+		cb->input_ifindex = p->dev->ifindex;
+#endif
+		goto out;
+	}
+
+	if (flow->fdb_in->dst != p)
+		goto out;
+
+	dst = flow->fdb_out->dst;
+	if (!dst)
+		goto out;
+
+	ret = true;
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+	if (!flow->vlan_out_present && key.vlan_present) {
+		__vlan_hwaccel_clear_tag(skb);
+	} else if (flow->vlan_out_present) {
+		if (skb_vlan_tag_present(skb) &&
+		    skb->vlan_proto != p->br->vlan_proto) {
+			/* Protocol-mismatch, empty out vlan_tci for new tag */
+			skb_push(skb, ETH_HLEN);
+			skb = vlan_insert_tag_set_proto(skb, skb->vlan_proto,
+							skb_vlan_tag_get(skb));
+			if (unlikely(!skb))
+				goto out;
+
+			skb_pull(skb, ETH_HLEN);
+			skb_reset_mac_len(skb);
+		}
+
+		__vlan_hwaccel_put_tag(skb, p->br->vlan_proto,
+				       flow->vlan_out);
+	}
+#endif
+
+	skb->dev = dst->dev;
+	skb_push(skb, ETH_HLEN);
+
+	if (skb_warn_if_lro(skb) || !is_skb_forwardable(skb->dev, skb)) {
+		kfree_skb(skb);
+		goto out;
+	}
+
+	if (flow->used != now)
+		flow->used = now;
+	skb_forward_csum(skb);
+	dev_queue_xmit(skb);
+
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
+static void
+br_offload_check_gc(struct net_bridge *br)
+{
+	struct net_bridge_port *p;
+
+	spin_lock_bh(&br->lock);
+	list_for_each_entry(p, &br->port_list, list)
+		if (br_offload_need_gc(p))
+			queue_work(system_long_wq, &p->offload.gc_work);
+	spin_unlock_bh(&br->lock);
+}
+
+
+int br_offload_set_cache_size(struct net_bridge *br, unsigned long val)
+{
+	br->offload_cache_size = val;
+	br_offload_check_gc(br);
+
+	return 0;
+}
+
+int br_offload_set_cache_reserved(struct net_bridge *br, unsigned long val)
+{
+	br->offload_cache_reserved = val;
+	br_offload_check_gc(br);
+
+	return 0;
+}
+
+int __init br_offload_init(void)
+{
+	offload_cache = kmem_cache_create("bridge_offload_cache",
+					  sizeof(struct bridge_flow),
+					  0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!offload_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void br_offload_fini(void)
+{
+	kmem_cache_destroy(offload_cache);
+}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2661dda1a92b..40021fe4b8c8 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -268,7 +268,15 @@ struct net_bridge_fdb_entry {
 	unsigned long			updated ____cacheline_aligned_in_smp;
 	unsigned long			used;
 
-	struct rcu_head			rcu;
+	union {
+#ifdef CONFIG_BRIDGE_OFFLOAD
+		struct {
+			struct hlist_head		offload_in;
+			struct hlist_head		offload_out;
+		};
+#endif
+		struct rcu_head			rcu;
+	};
 };
 
 #define MDB_PG_FLAGS_PERMANENT	BIT(0)
@@ -343,6 +351,12 @@ struct net_bridge_mdb_entry {
 	struct rcu_head			rcu;
 };
 
+struct net_bridge_port_offload {
+	struct rhashtable		rht;
+	struct work_struct		gc_work;
+	bool				enabled;
+};
+
 struct net_bridge_port {
 	struct net_bridge		*br;
 	struct net_device		*dev;
@@ -404,6 +418,9 @@ struct net_bridge_port {
 	u16				backup_redirected_cnt;
 
 	struct bridge_stp_xstats	stp_xstats;
+#ifdef CONFIG_BRIDGE_OFFLOAD
+	struct net_bridge_port_offload	offload;
+#endif
 };
 
 #define kobj_to_brport(obj)	container_of(obj, struct net_bridge_port, kobj)
@@ -555,6 +572,11 @@ struct br_input_skb_cb {
 	u8 br_netfilter_broute:1;
 #endif
 
+#ifdef CONFIG_BRIDGE_OFFLOAD
+	u32				offload_cache_size;
+	u32				offload_cache_reserved;
+#endif
+
 #ifdef CONFIG_NET_SWITCHDEV
 	/* Set if TX data plane offloading is used towards at least one
 	 * hardware domain.
@@ -580,6 +602,12 @@ struct br_input_skb_cb {
 #else
 # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(0)
 #endif
+#ifdef CONFIG_BRIDGE_OFFLOAD
+	u8 offload:1;
+	u8 input_vlan_present:1;
+	u16 input_vlan_tag;
+	int input_ifindex;
+#endif
 
 #define br_printk(level, br, format, args...)	\
 	printk(level "%s: " format, (br)->dev->name, ##args)
diff --git a/net/bridge/br_private_offload.h b/net/bridge/br_private_offload.h
new file mode 100644
index 000000000000..f66edd0539ab
--- /dev/null
+++ b/net/bridge/br_private_offload.h
@@ -0,0 +1,53 @@
+#ifndef __BR_OFFLOAD_H
+#define __BR_OFFLOAD_H
+
+#ifdef CONFIG_BRIDGE_OFFLOAD
+bool br_offload_input(struct net_bridge_port *p, struct sk_buff *skb);
+void br_offload_output(struct sk_buff *skb);
+void br_offload_port_state(struct net_bridge_port *p);
+void br_offload_fdb_update(const struct net_bridge_fdb_entry *fdb);
+bool br_offload_fdb_refresh_time(struct net_bridge *br,
+				 struct net_bridge_fdb_entry *fdb);
+int br_offload_init(void);
+void br_offload_fini(void);
+int br_offload_set_cache_size(struct net_bridge *br, unsigned long val);
+int br_offload_set_cache_reserved(struct net_bridge *br, unsigned long val);
+#else
+static inline bool br_offload_input(struct net_bridge_port *p, struct sk_buff *skb)
+{
+	return false;
+}
+static inline void br_offload_output(struct sk_buff *skb)
+{
+}
+static inline void br_offload_port_state(struct net_bridge_port *p)
+{
+}
+static inline void br_offload_fdb_update(const struct net_bridge_fdb_entry *fdb)
+{
+}
+static inline bool br_offload_fdb_refresh_time(struct net_bridge *br,
+					       struct net_bridge_fdb_entry *fdb)
+{
+	return false;
+}
+static inline int br_offload_init(void)
+{
+	return 0;
+}
+static inline void br_offload_fini(void)
+{
+}
+#endif
+
+static inline void br_offload_skb_disable(struct sk_buff *skb)
+{
+#ifdef CONFIG_BRIDGE_OFFLOAD
+	struct br_input_skb_cb *cb = (struct br_input_skb_cb *)skb->cb;
+
+	if (cb->offload)
+		cb->offload = 0;
+#endif
+}
+
+#endif
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 1d80f34a139c..b57788b53d24 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -12,6 +12,7 @@
 
 #include "br_private.h"
 #include "br_private_stp.h"
+#include "br_private_offload.h"
 
 /* since time values in bpdu are in jiffies and then scaled (1/256)
  * before sending, make sure that is at least one STP tick.
@@ -52,6 +53,8 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
 				(unsigned int) p->port_no, p->dev->name,
 				br_port_state_names[p->state]);
 
+	br_offload_port_state(p);
+
 	if (p->br->stp_enabled == BR_KERNEL_STP) {
 		switch (p->state) {
 		case BR_STATE_BLOCKING:
diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index 6399a8a69d07..ffc65dc4eea8 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -15,6 +15,7 @@
 
 #include "br_private.h"
 #include "br_private_tunnel.h"
+#include "br_private_offload.h"
 
 static inline int br_vlan_tunid_cmp(struct rhashtable_compare_arg *arg,
 				    const void *ptr)
@@ -180,6 +181,7 @@ void br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
 	skb_dst_drop(skb);
 
 	__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, vlan->vid);
+	br_offload_skb_disable(skb);
 }
 
 int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
@@ -201,6 +203,7 @@ int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 	if (err)
 		return err;
 
+	br_offload_skb_disable(skb);
 	tunnel_dst = rcu_dereference(vlan->tinfo.tunnel_dst);
 	if (tunnel_dst && dst_hold_safe(&tunnel_dst->dst))
 		skb_dst_set(skb, &tunnel_dst->dst);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 00328f0dd22b..da8d3b72a77e 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -55,7 +55,7 @@
 #include <net/net_namespace.h>
 
 #define RTNL_MAX_TYPE		50
-#define RTNL_SLAVE_MAX_TYPE	40
+#define RTNL_SLAVE_MAX_TYPE	41
 
 struct rtnl_link {
 	rtnl_doit_func		doit;
-- 
2.32.0 (Apple Git-132)

