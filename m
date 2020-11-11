Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793AE2AE6B1
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 03:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbgKKC7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 21:59:32 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:16012 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKKC7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 21:59:30 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 5F2F75C1F55;
        Wed, 11 Nov 2020 10:49:28 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, marcelo.leitner@gmail.com, dcaratti@redhat.com,
        vladbu@nvidia.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v7 net-next 3/3] net/sched: act_frag: add implict packet fragment support.
Date:   Wed, 11 Nov 2020 10:49:27 +0800
Message-Id: <1605062967-19819-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605062967-19819-1-git-send-email-wenxu@ucloud.cn>
References: <1605062967-19819-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQ0hJSEpPH0lNSEkdVkpNS05LTUlCTUNOS0xVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hOT1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NxQ6FTo4Ij05NjgfNxhCDEgB
        KzQaFC1VSlVKTUtOS01JQk1DTE5LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpKQk1KNwY+
X-HM-Tid: 0a75b53544662087kuqy5f2f75c1f55
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Currently kernel tc subsystem can do conntrack in cat_ct. But when several
fragment packets go through the act_ct, function tcf_ct_handle_fragments
will defrag the packets to a big one. But the last action will redirect
mirred to a device which maybe lead the reassembly big packet over the mtu
of target device.

This patch add support for a xmit hook to mirred, that gets executed before
xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
The frag xmit hook maybe reused by other modules.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: Fix the crash for act_frag module without load
v3: modify the kconfig describe and put tcf_xmit_hook_is_enabled
in the tcf_dev_queue_xmit, and xchg atomic for tcf_xmit_hook
v4: using skb_protocol and fix line length exceeds 80 columns
v5: no change
v6: protect the tcf_xmit_hook with rcu lock
v7: add miss __rcu for tcf_xmit_hook

 include/net/act_api.h  |  16 +++++
 net/sched/Kconfig      |  13 ++++
 net/sched/Makefile     |   1 +
 net/sched/act_api.c    |  47 ++++++++++++++
 net/sched/act_ct.c     |   7 +++
 net/sched/act_frag.c   | 164 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/sched/act_mirred.c |   2 +-
 7 files changed, 249 insertions(+), 1 deletion(-)
 create mode 100644 net/sched/act_frag.c

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 8721492..403a618 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -239,6 +239,22 @@ int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct netlink_ext_ack *newchain);
 struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
 					 struct tcf_chain *newchain);
+
+int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
+int tcf_set_xmit_hook(int (*xmit_hook)(struct sk_buff *skb,
+				       int (*xmit)(struct sk_buff *skb)));
+void tcf_clear_xmit_hook(void);
+
+#if IS_ENABLED(CONFIG_NET_ACT_FRAG)
+int tcf_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
+#else
+static inline int tcf_frag_xmit_hook(struct sk_buff *skb,
+				     int (*xmit)(struct sk_buff *skb))
+{
+	return 0;
+}
+#endif
+
 #endif /* CONFIG_NET_CLS_ACT */
 
 static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d8..9a240c7 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -974,9 +974,22 @@ config NET_ACT_TUNNEL_KEY
 	  To compile this code as a module, choose M here: the
 	  module will be called act_tunnel_key.
 
+config NET_ACT_FRAG
+	tristate "Packet fragmentation"
+	depends on NET_CLS_ACT
+	help
+         Say Y here to allow fragmenting big packets when outputting
+         with the mirred action.
+
+	  If unsure, say N.
+
+	  To compile this code as a module, choose M here: the
+	  module will be called act_frag.
+
 config NET_ACT_CT
 	tristate "connection tracking tc action"
 	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT && NF_FLOW_TABLE
+	depends on NET_ACT_FRAG
 	help
 	  Say Y here to allow sending the packets to conntrack module.
 
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 66bbf9a..c146186 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_NET_IFE_SKBMARK)	+= act_meta_mark.o
 obj-$(CONFIG_NET_IFE_SKBPRIO)	+= act_meta_skbprio.o
 obj-$(CONFIG_NET_IFE_SKBTCINDEX)	+= act_meta_skbtcindex.o
 obj-$(CONFIG_NET_ACT_TUNNEL_KEY)+= act_tunnel_key.o
+obj-$(CONFIG_NET_ACT_FRAG)	+= act_frag.o
 obj-$(CONFIG_NET_ACT_CT)	+= act_ct.o
 obj-$(CONFIG_NET_ACT_GATE)	+= act_gate.o
 obj-$(CONFIG_NET_SCH_FIFO)	+= sch_fifo.o
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f66417d..8a8a6a5 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -22,6 +22,53 @@
 #include <net/act_api.h>
 #include <net/netlink.h>
 
+static int (__rcu *tcf_xmit_hook)(struct sk_buff *skb,
+				  int (*xmit)(struct sk_buff *skb));
+static DEFINE_SPINLOCK(tcf_xmit_hook_lock);
+static u16 tcf_xmit_hook_count;
+
+int tcf_set_xmit_hook(int (*xmit_hook)(struct sk_buff *skb,
+				       int (*xmit)(struct sk_buff *skb)))
+{
+	spin_lock(&tcf_xmit_hook_lock);
+	if (!tcf_xmit_hook_count) {
+		rcu_assign_pointer(tcf_xmit_hook, xmit_hook);
+	} else if (xmit_hook != tcf_xmit_hook) {
+		spin_unlock(&tcf_xmit_hook_lock);
+		return -EBUSY;
+	}
+
+	tcf_xmit_hook_count++;
+	spin_unlock(&tcf_xmit_hook_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tcf_set_xmit_hook);
+
+void tcf_clear_xmit_hook(void)
+{
+	spin_lock(&tcf_xmit_hook_lock);
+	if (--tcf_xmit_hook_count == 0)
+		rcu_assign_pointer(tcf_xmit_hook, NULL);
+	spin_unlock(&tcf_xmit_hook_lock);
+
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(tcf_clear_xmit_hook);
+
+int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
+{
+	int (*xmit_hook)(struct sk_buff *skb,
+			 int (*xmit)(struct sk_buff *skb));
+
+	xmit_hook = rcu_dereference(tcf_xmit_hook);
+	if (xmit_hook)
+		return xmit_hook(skb, xmit);
+	else
+		return xmit(skb);
+}
+EXPORT_SYMBOL_GPL(tcf_dev_queue_xmit);
+
 static void tcf_action_goto_chain_exec(const struct tc_action *a,
 				       struct tcf_result *res)
 {
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9c79fb9..dff3c40 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1541,8 +1541,14 @@ static int __init ct_init_module(void)
 	if (err)
 		goto err_register;
 
+	err = tcf_set_xmit_hook(tcf_frag_xmit_hook);
+	if (err)
+		goto err_action;
+
 	return 0;
 
+err_action:
+	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
 err_register:
 	tcf_ct_flow_tables_uninit();
 err_tbl_init:
@@ -1552,6 +1558,7 @@ static int __init ct_init_module(void)
 
 static void __exit ct_cleanup_module(void)
 {
+	tcf_clear_xmit_hook();
 	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
 	tcf_ct_flow_tables_uninit();
 	destroy_workqueue(act_ct_wq);
diff --git a/net/sched/act_frag.c b/net/sched/act_frag.c
new file mode 100644
index 0000000..3a7ab92
--- /dev/null
+++ b/net/sched/act_frag.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+#include <net/netlink.h>
+#include <net/act_api.h>
+#include <net/dst.h>
+#include <net/ip.h>
+#include <net/ip6_fib.h>
+
+struct tcf_frag_data {
+	unsigned long dst;
+	struct qdisc_skb_cb cb;
+	__be16 inner_protocol;
+	u16 vlan_tci;
+	__be16 vlan_proto;
+	unsigned int l2_len;
+	u8 l2_data[VLAN_ETH_HLEN];
+	int (*xmit)(struct sk_buff *skb);
+};
+
+static DEFINE_PER_CPU(struct tcf_frag_data, tcf_frag_data_storage);
+
+static int tcf_frag_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
+{
+	struct tcf_frag_data *data = this_cpu_ptr(&tcf_frag_data_storage);
+
+	if (skb_cow_head(skb, data->l2_len) < 0) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	__skb_dst_copy(skb, data->dst);
+	*qdisc_skb_cb(skb) = data->cb;
+	skb->inner_protocol = data->inner_protocol;
+	if (data->vlan_tci & VLAN_CFI_MASK)
+		__vlan_hwaccel_put_tag(skb, data->vlan_proto,
+				       data->vlan_tci & ~VLAN_CFI_MASK);
+	else
+		__vlan_hwaccel_clear_tag(skb);
+
+	/* Reconstruct the MAC header.  */
+	skb_push(skb, data->l2_len);
+	memcpy(skb->data, &data->l2_data, data->l2_len);
+	skb_postpush_rcsum(skb, skb->data, data->l2_len);
+	skb_reset_mac_header(skb);
+
+	data->xmit(skb);
+
+	return 0;
+}
+
+static void tcf_frag_prepare_frag(struct sk_buff *skb,
+				  int (*xmit)(struct sk_buff *skb))
+{
+	unsigned int hlen = skb_network_offset(skb);
+	struct tcf_frag_data *data;
+
+	data = this_cpu_ptr(&tcf_frag_data_storage);
+	data->dst = skb->_skb_refdst;
+	data->cb = *qdisc_skb_cb(skb);
+	data->xmit = xmit;
+	data->inner_protocol = skb->inner_protocol;
+	if (skb_vlan_tag_present(skb))
+		data->vlan_tci = skb_vlan_tag_get(skb) | VLAN_CFI_MASK;
+	else
+		data->vlan_tci = 0;
+	data->vlan_proto = skb->vlan_proto;
+	data->l2_len = hlen;
+	memcpy(&data->l2_data, skb->data, hlen);
+
+	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
+	skb_pull(skb, hlen);
+}
+
+static unsigned int
+tcf_frag_dst_get_mtu(const struct dst_entry *dst)
+{
+	return dst->dev->mtu;
+}
+
+static struct dst_ops tcf_frag_dst_ops = {
+	.family = AF_UNSPEC,
+	.mtu = tcf_frag_dst_get_mtu,
+};
+
+static int tcf_fragment(struct net *net, struct sk_buff *skb,
+			u16 mru, int (*xmit)(struct sk_buff *skb))
+{
+	if (skb_network_offset(skb) > VLAN_ETH_HLEN) {
+		net_warn_ratelimited("L2 header too long to fragment\n");
+		goto err;
+	}
+
+	if (skb_protocol(skb, true) == htons(ETH_P_IP)) {
+		struct dst_entry tcf_frag_dst;
+		unsigned long orig_dst;
+
+		tcf_frag_prepare_frag(skb, xmit);
+		dst_init(&tcf_frag_dst, &tcf_frag_dst_ops, NULL, 1,
+			 DST_OBSOLETE_NONE, DST_NOCOUNT);
+		tcf_frag_dst.dev = skb->dev;
+
+		orig_dst = skb->_skb_refdst;
+		skb_dst_set_noref(skb, &tcf_frag_dst);
+		IPCB(skb)->frag_max_size = mru;
+
+		ip_do_fragment(net, skb->sk, skb, tcf_frag_xmit);
+		refdst_drop(orig_dst);
+	} else if (skb_protocol(skb, true) == htons(ETH_P_IPV6)) {
+		unsigned long orig_dst;
+		struct rt6_info tcf_frag_rt;
+
+		tcf_frag_prepare_frag(skb, xmit);
+		memset(&tcf_frag_rt, 0, sizeof(tcf_frag_rt));
+		dst_init(&tcf_frag_rt.dst, &tcf_frag_dst_ops, NULL, 1,
+			 DST_OBSOLETE_NONE, DST_NOCOUNT);
+		tcf_frag_rt.dst.dev = skb->dev;
+
+		orig_dst = skb->_skb_refdst;
+		skb_dst_set_noref(skb, &tcf_frag_rt.dst);
+		IP6CB(skb)->frag_max_size = mru;
+
+		ipv6_stub->ipv6_fragment(net, skb->sk, skb, tcf_frag_xmit);
+		refdst_drop(orig_dst);
+	} else {
+		net_warn_ratelimited("Fail frag %s: eth=%x, MRU=%d, MTU=%d\n",
+				     netdev_name(skb->dev),
+				     ntohs(skb_protocol(skb, true)), mru,
+				     skb->dev->mtu);
+		goto err;
+	}
+
+	qdisc_skb_cb(skb)->mru = 0;
+	return 0;
+err:
+	kfree_skb(skb);
+	return -1;
+}
+
+int tcf_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
+{
+	u16 mru = qdisc_skb_cb(skb)->mru;
+	int err;
+
+	if (mru && skb->len > mru + skb->dev->hard_header_len)
+		err = tcf_fragment(dev_net(skb->dev), skb, mru, xmit);
+	else
+		err = xmit(skb);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(tcf_frag_xmit_hook);
+
+static int __init frag_init_module(void)
+{
+	return 0;
+}
+
+static void __exit frag_cleanup_module(void)
+{
+}
+
+module_init(frag_init_module);
+module_exit(frag_cleanup_module);
+MODULE_AUTHOR("wenxu <wenxu@ucloud.cn>");
+MODULE_LICENSE("GPL v2");
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 17d0095..7153c67 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -210,7 +210,7 @@ static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
 	int err;
 
 	if (!want_ingress)
-		err = dev_queue_xmit(skb);
+		err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
 	else
 		err = netif_receive_skb(skb);
 
-- 
1.8.3.1

