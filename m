Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0220AEB26
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbfD2Tuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:50:44 -0400
Received: from mail.us.es ([193.147.175.20]:41740 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729284AbfD2Tuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:50:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 372DC1031AE
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:50:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26D4DDA715
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:50:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 25D1DDA704; Mon, 29 Apr 2019 21:50:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 885C9DA706;
        Mon, 29 Apr 2019 21:50:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 29 Apr 2019 21:50:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3E0FA4265A31;
        Mon, 29 Apr 2019 21:50:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH 7/9 net-next,v2] netfilter: bridge: add connection tracking system
Date:   Mon, 29 Apr 2019 21:50:12 +0200
Message-Id: <20190429195014.4724-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190429195014.4724-1-pablo@netfilter.org>
References: <20190429195014.4724-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds basic connection tracking support for the bridge,
including initial IPv4 support.

This patch register two hooks to deal with the bridge forwarding path,
one at bridge prerouting hook to call nf_conntrack_in() and another at
the bridge postrouting hook to confirm the entry.

The conntrack bridge prerouting hook defragments packets and it passes
them to nf_conntrack_in() to look up for an existing entry, otherwise a
new entry is created in the conntrack table.

The conntrack bridge postrouting hook confirms new entries, ie. if this
is the first packet seen of this flow that went through the entire
bridge layer, then it adds the entries to the hashtable and (if needed)
it refragments the skbuff into the original fragments, leaving the
geometry as is if possible. Exceptions are linearized skbuffs, eg.
skbuffs that are passed up to nfqueue and conntrack helpers, as well
as cloned skbuff for the local delivery (eg. tcpdump) or in case of
bridge port flooding.

The packet defragmentation is done through the ip_defrag() call.  This
forces us to save the bridge control buffer, reset the IP control buffer
area and then restore it after call. This function also bumps the IP
fragmentation statistics. The maximum fragment length is stored in the
control buffer and it is used to refragment the skbuff.

The new fraglist iterator and fragment transformer APIs is used to
implement the bridge refragmentation code. The br_ip_fragment() function
drops the packet in case the maximum fragment size seen is larger than
the output port MTU.

This patchset follows the principle that conntrack should not drop
packets, so users can do it through policy via invalid state.

Like br_netfilter, there is no refragmentation for packets that are
passed up for local delivery, ie. prerouting -> input path. There are
calls to nf_reset() already in several spots since time ago already, eg.
af_packet, that show that skbuff fraglist from the netif_rx path is
supported already.

The helpers are called from the postrouting hook, before confirmation,
from there we may see packet floods to bridge ports. Then, although
unlikely, this may result in exercising the helpers many times for each
clone. It would be good to explore how to pass all the packets in a list
to the conntrack hook to do this handle only once for this case.

This patch is based on original work from Florian Westphal.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/net/netfilter/nf_conntrack_bridge.h |   7 +
 include/net/netfilter/nf_conntrack_core.h   |   3 +
 net/bridge/br_device.c                      |   1 +
 net/bridge/br_private.h                     |   1 +
 net/bridge/netfilter/Kconfig                |  14 ++
 net/bridge/netfilter/Makefile               |   3 +
 net/bridge/netfilter/nf_conntrack_bridge.c  | 378 ++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_proto.c          |   7 +-
 8 files changed, 410 insertions(+), 4 deletions(-)
 create mode 100644 net/bridge/netfilter/nf_conntrack_bridge.c

diff --git a/include/net/netfilter/nf_conntrack_bridge.h b/include/net/netfilter/nf_conntrack_bridge.h
index 3be1642e04f7..9a5514d5bc51 100644
--- a/include/net/netfilter/nf_conntrack_bridge.h
+++ b/include/net/netfilter/nf_conntrack_bridge.h
@@ -10,4 +10,11 @@ struct nf_ct_bridge_info {
 void nf_ct_bridge_register(struct nf_ct_bridge_info *info);
 void nf_ct_bridge_unregister(struct nf_ct_bridge_info *info);
 
+struct nf_ct_bridge_frag_data {
+	char	mac[ETH_HLEN];
+	bool	vlan_present;
+	u16	vlan_tci;
+	__be16	vlan_proto;
+};
+
 #endif
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index ae41e92251dd..de10faf2ce91 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -64,6 +64,9 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	return ret;
 }
 
+unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
+			struct nf_conn *ct, enum ip_conntrack_info ctinfo);
+
 void print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 		 const struct nf_conntrack_l4proto *proto);
 
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 013323b6dbe4..693aefad7f8a 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -56,6 +56,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	br_switchdev_frame_unmark(skb);
 	BR_INPUT_SKB_CB(skb)->brdev = dev;
+	BR_INPUT_SKB_CB(skb)->frag_max_size = 0;
 
 	skb_reset_mac_header(skb);
 	eth = eth_hdr(skb);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 334a8c496b50..68561741e827 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -425,6 +425,7 @@ struct net_bridge {
 struct br_input_skb_cb {
 	struct net_device *brdev;
 
+	u16 frag_max_size;
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	u8 igmp;
 	u8 mrouters_only:1;
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 9a0159aebe1a..eb61197d8af8 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -18,6 +18,20 @@ config NF_LOG_BRIDGE
 	tristate "Bridge packet logging"
 	select NF_LOG_COMMON
 
+config NF_CONNTRACK_BRIDGE
+	tristate "IPv4/IPV6 bridge connection tracking support"
+	depends on NF_CONNTRACK
+	default n
+	help
+	  Connection tracking keeps a record of what packets have passed
+	  through your machine, in order to figure out how they are related
+	  into connections. This is used to enhance packet filtering via
+	  stateful policies. Enable this if you want native tracking from
+	  the bridge. This is provides a replacement for the `br_netfilter'
+	  infrastructure.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 endif # NF_TABLES_BRIDGE
 
 menuconfig BRIDGE_NF_EBTABLES
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 9b868861f21a..9d7767322a64 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -5,6 +5,9 @@
 
 obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
 
+# connection tracking
+obj-$(CONFIG_NF_CONNTRACK_BRIDGE) += nf_conntrack_bridge.o
+
 # packet logging
 obj-$(CONFIG_NF_LOG_BRIDGE) += nf_log_bridge.o
 
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
new file mode 100644
index 000000000000..2571528ed582
--- /dev/null
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -0,0 +1,378 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/types.h>
+#include <linux/ip.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv6.h>
+#include <linux/netfilter_bridge.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/icmp.h>
+#include <linux/sysctl.h>
+#include <net/route.h>
+#include <net/ip.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_bridge.h>
+
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+#include <net/netfilter/nf_tables.h>
+
+#include "../br_private.h"
+
+/* Best effort variant of ip_do_fragment which preserves geometry, unless skbuff
+ * has been linearized or cloned.
+ */
+static int nf_br_ip_fragment(struct net *net, struct sock *sk,
+			     struct sk_buff *skb,
+			     struct nf_ct_bridge_frag_data *data,
+			     int (*output)(struct net *, struct sock *sk,
+					   const struct nf_ct_bridge_frag_data *data,
+					   struct sk_buff *))
+{
+	int frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
+	unsigned int hlen, ll_rs, mtu;
+	struct ip_frag_state state;
+	struct iphdr *iph;
+	int err;
+
+	/* for offloaded checksums cleanup checksum before fragmentation */
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    (err = skb_checksum_help(skb)))
+		goto blackhole;
+
+	iph = ip_hdr(skb);
+
+	/*
+	 *	Setup starting values
+	 */
+
+	hlen = iph->ihl * 4;
+	frag_max_size -= hlen;
+	ll_rs = LL_RESERVED_SPACE(skb->dev);
+	mtu = skb->dev->mtu;
+
+	if (skb_has_frag_list(skb)) {
+		unsigned int first_len = skb_pagelen(skb);
+		struct ip_fraglist_iter iter;
+		struct sk_buff *frag;
+
+		if (first_len - hlen > mtu ||
+		    skb_headroom(skb) < ll_rs)
+			goto blackhole;
+
+		if (skb_cloned(skb))
+			goto slow_path;
+
+		skb_walk_frags(skb, frag) {
+			if (frag->len > mtu ||
+			    skb_headroom(frag) < hlen + ll_rs)
+				goto blackhole;
+
+			if (skb_shared(frag))
+				goto slow_path;
+		}
+
+		ip_fraglist_init(skb, iph, hlen, &iter);
+
+		for (;;) {
+			if (iter.frag)
+				ip_fraglist_prepare(skb, &iter);
+
+			err = output(net, sk, data, skb);
+			if (err || !iter.frag)
+				break;
+
+			skb = ip_fraglist_next(&iter);
+		}
+		return err;
+	}
+slow_path:
+	/* This is a linearized skbuff, the original geometry is lost for us.
+	 * This may also be a clone skbuff, we could preserve the geometry for
+	 * the copies but probably not worth the effort.
+	 */
+	ip_frag_init(skb, hlen, ll_rs, frag_max_size, &state);
+
+	while (state.left > 0) {
+		struct sk_buff *skb2;
+
+		skb2 = ip_frag_next(skb, &state);
+		if (IS_ERR(skb2)) {
+			err = PTR_ERR(skb2);
+			goto blackhole;
+		}
+
+		err = output(net, sk, data, skb2);
+		if (err)
+			goto blackhole;
+	}
+	consume_skb(skb);
+	return err;
+
+blackhole:
+	kfree_skb(skb);
+	return 0;
+}
+
+/* ip_defrag() expects IPCB() in place. */
+static void br_skb_cb_save(struct sk_buff *skb, struct br_input_skb_cb *cb,
+			   size_t inet_skb_parm_size)
+{
+	memcpy(cb, skb->cb, sizeof(*cb));
+	memset(skb->cb, 0, inet_skb_parm_size);
+}
+
+static void br_skb_cb_restore(struct sk_buff *skb,
+			      const struct br_input_skb_cb *cb,
+			      u16 fragsz)
+{
+	memcpy(skb->cb, cb, sizeof(*cb));
+	BR_INPUT_SKB_CB(skb)->frag_max_size = fragsz;
+}
+
+static unsigned int nf_ct_br_defrag4(struct sk_buff *skb,
+				     const struct nf_hook_state *state)
+{
+	u16 zone_id = NF_CT_DEFAULT_ZONE_ID;
+	enum ip_conntrack_info ctinfo;
+	struct br_input_skb_cb cb;
+	const struct nf_conn *ct;
+	int err;
+
+	if (!ip_is_fragment(ip_hdr(skb)))
+		return NF_ACCEPT;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct)
+		zone_id = nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo));
+
+	br_skb_cb_save(skb, &cb, sizeof(struct inet_skb_parm));
+	local_bh_disable();
+	err = ip_defrag(state->net, skb,
+			IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id);
+	local_bh_enable();
+	if (!err) {
+		br_skb_cb_restore(skb, &cb, IPCB(skb)->frag_max_size);
+		skb->ignore_df = 1;
+		return NF_ACCEPT;
+	}
+
+	return NF_STOLEN;
+}
+
+static int nf_ct_br_ip_check(const struct sk_buff *skb)
+{
+	const struct iphdr *iph;
+	int nhoff, len;
+
+	nhoff = skb_network_offset(skb);
+	iph = ip_hdr(skb);
+	if (iph->ihl < 5 ||
+	    iph->version != 4)
+		return -1;
+
+	len = ntohs(iph->tot_len);
+	if (skb->len < nhoff + len ||
+	    len < (iph->ihl * 4))
+		return -1;
+
+	return 0;
+}
+
+static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
+				     const struct nf_hook_state *state)
+{
+	struct nf_hook_state bridge_state = *state;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	u32 len;
+	int ret;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if ((ct && !nf_ct_is_template(ct)) ||
+	    ctinfo == IP_CT_UNTRACKED)
+		return NF_ACCEPT;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+			return NF_ACCEPT;
+
+		len = ntohs(ip_hdr(skb)->tot_len);
+		if (pskb_trim_rcsum(skb, len))
+			return NF_ACCEPT;
+
+		if (nf_ct_br_ip_check(skb))
+			return NF_ACCEPT;
+
+		bridge_state.pf = NFPROTO_IPV4;
+		ret = nf_ct_br_defrag4(skb, &bridge_state);
+		break;
+	case htons(ETH_P_IPV6):
+		/* fall through */
+	default:
+		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+		return NF_ACCEPT;
+	}
+
+	if (ret != NF_ACCEPT)
+		return ret;
+
+	return nf_conntrack_in(skb, &bridge_state);
+}
+
+static void nf_ct_bridge_frag_save(struct sk_buff *skb,
+				   struct nf_ct_bridge_frag_data *data)
+{
+	if (skb_vlan_tag_present(skb)) {
+		data->vlan_present = true;
+		data->vlan_tci = skb->vlan_tci;
+		data->vlan_proto = skb->vlan_proto;
+	} else {
+		data->vlan_present = false;
+	}
+	skb_copy_from_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
+}
+
+static unsigned int
+nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
+		    int (*output)(struct net *, struct sock *sk,
+				  const struct nf_ct_bridge_frag_data *data,
+				  struct sk_buff *))
+{
+	struct nf_ct_bridge_frag_data data;
+
+	if (!BR_INPUT_SKB_CB(skb)->frag_max_size)
+		return NF_ACCEPT;
+
+	nf_ct_bridge_frag_save(skb, &data);
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		nf_br_ip_fragment(state->net, state->sk, skb, &data, output);
+		break;
+	case htons(ETH_P_IPV6):
+		return NF_ACCEPT;
+	default:
+		WARN_ON_ONCE(1);
+		return NF_DROP;
+	}
+
+	return NF_STOLEN;
+}
+
+/* Actually only slow path refragmentation needs this. */
+static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
+				     const struct nf_ct_bridge_frag_data *data)
+{
+	int err;
+
+	err = skb_cow_head(skb, ETH_HLEN);
+	if (err) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+	if (data->vlan_present)
+		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci);
+
+	skb_copy_to_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
+	skb_reset_mac_header(skb);
+
+	return 0;
+}
+
+static int nf_ct_bridge_refrag_post(struct net *net, struct sock *sk,
+				    const struct nf_ct_bridge_frag_data *data,
+				    struct sk_buff *skb)
+{
+	int err;
+
+	err = nf_ct_bridge_frag_restore(skb, data);
+	if (err < 0)
+		return err;
+
+	return br_dev_queue_push_xmit(net, sk, skb);
+}
+
+static unsigned int nf_ct_bridge_confirm(struct sk_buff *skb)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	int protoff;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
+		return nf_conntrack_confirm(skb);
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
+		break;
+	case htons(ETH_P_IPV6): {
+		 unsigned char pnum = ipv6_hdr(skb)->nexthdr;
+		__be16 frag_off;
+
+		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
+					   &frag_off);
+		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
+			return nf_conntrack_confirm(skb);
+		}
+		break;
+	default:
+		return NF_ACCEPT;
+	}
+	return nf_confirm(skb, protoff, ct, ctinfo);
+}
+
+static unsigned int nf_ct_bridge_post(void *priv, struct sk_buff *skb,
+				      const struct nf_hook_state *state)
+{
+	int ret;
+
+	ret = nf_ct_bridge_confirm(skb);
+	if (ret != NF_ACCEPT)
+		return ret;
+
+	return nf_ct_bridge_refrag(skb, state, nf_ct_bridge_refrag_post);
+}
+
+static struct nf_hook_ops nf_ct_bridge_hook_ops[] __read_mostly = {
+	{
+		.hook		= nf_ct_bridge_pre,
+		.pf		= NFPROTO_BRIDGE,
+		.hooknum	= NF_BR_PRE_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK,
+	},
+	{
+		.hook		= nf_ct_bridge_post,
+		.pf		= NFPROTO_BRIDGE,
+		.hooknum	= NF_BR_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+	},
+};
+
+static struct nf_ct_bridge_info bridge_info = {
+	.ops		= nf_ct_bridge_hook_ops,
+	.ops_size	= ARRAY_SIZE(nf_ct_bridge_hook_ops),
+	.me		= THIS_MODULE,
+};
+
+static int __init nf_conntrack_l3proto_bridge_init(void)
+{
+	nf_ct_bridge_register(&bridge_info);
+
+	return 0;
+}
+
+static void __exit nf_conntrack_l3proto_bridge_fini(void)
+{
+	nf_ct_bridge_unregister(&bridge_info);
+}
+
+module_init(nf_conntrack_l3proto_bridge_init);
+module_exit(nf_conntrack_l3proto_bridge_fini);
+
+MODULE_ALIAS("nf_conntrack-" __stringify(AF_BRIDGE));
+MODULE_LICENSE("GPL");
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 3813cb551df9..7e2e8b8d6ebe 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -121,10 +121,8 @@ const struct nf_conntrack_l4proto *nf_ct_l4proto_find(u8 l4proto)
 };
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_find);
 
-static unsigned int nf_confirm(struct sk_buff *skb,
-			       unsigned int protoff,
-			       struct nf_conn *ct,
-			       enum ip_conntrack_info ctinfo)
+unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
+			struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
 	const struct nf_conn_help *help;
 
@@ -155,6 +153,7 @@ static unsigned int nf_confirm(struct sk_buff *skb,
 	/* We've seen it coming out the other side: confirm it */
 	return nf_conntrack_confirm(skb);
 }
+EXPORT_SYMBOL_GPL(nf_confirm);
 
 static unsigned int ipv4_confirm(void *priv,
 				 struct sk_buff *skb,
-- 
2.11.0

