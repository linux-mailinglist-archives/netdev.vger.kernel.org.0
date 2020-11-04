Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796062A6067
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgKDJSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:18:33 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:31665 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgKDJSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:18:32 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 30F775C1222;
        Wed,  4 Nov 2020 16:56:33 +0800 (CST)
From:   wenxu@ucloud.cn
To:     marcelo.leitner@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net/sched: act_frag: add implict packet fragment support.
Date:   Wed,  4 Nov 2020 16:56:32 +0800
Message-Id: <1604480192-25035-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604480192-25035-1-git-send-email-wenxu@ucloud.cn>
References: <1604480192-25035-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTUMaGRhMTR9CHxpJVkpNS09PQ0tKQkhJTUlVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hOT1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NEk6PDo5Ij5JFUIRMi06MEsJ
        Fh0wCSlVSlVKTUtPT0NLSkJITklMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpLQk1ONwY+
X-HM-Tid: 0a759278d2c72087kuqy30f775c1222
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
 include/net/act_api.h  |   8 +++
 net/sched/Kconfig      |  11 ++++
 net/sched/Makefile     |   1 +
 net/sched/act_api.c    |  41 ++++++++++++
 net/sched/act_ct.c     |   3 +
 net/sched/act_frag.c   | 166 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/sched/act_mirred.c |  10 ++-
 7 files changed, 237 insertions(+), 3 deletions(-)
 create mode 100644 net/sched/act_frag.c

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 8721492..6110bfe 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -239,6 +239,14 @@ int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct netlink_ext_ack *newchain);
 struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
 					 struct tcf_chain *newchain);
+
+int tcf_exec_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
+void tcf_set_xmit_hook(int (*xmit_hook)(struct sk_buff *skb,
+					int (*xmit)(struct sk_buff *skb)));
+void tcf_clear_xmit_hook(void);
+void tcf_inc_xmit_hook(void);
+void tcf_dec_xmit_hook(void);
+bool tcf_xmit_hook_is_enabled(void);
 #endif /* CONFIG_NET_CLS_ACT */
 
 static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d8..b526da2 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -974,9 +974,20 @@ config NET_ACT_TUNNEL_KEY
 	  To compile this code as a module, choose M here: the
 	  module will be called act_tunnel_key.
 
+config NET_ACT_FRAG
+	tristate "send packets do frag"
+	help
+	  Say Y here to allow sending the packets to do frag
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
index f66417d..a0533c1 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -22,6 +22,47 @@
 #include <net/act_api.h>
 #include <net/netlink.h>
 
+static int (*tcf_xmit_hook)(struct sk_buff *skb,
+			    int (*xmit)(struct sk_buff *skb));
+DEFINE_STATIC_KEY_FALSE(tcf_xmit_hook_in_use);
+
+int tcf_exec_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
+{
+	return tcf_xmit_hook(skb, xmit);
+}
+EXPORT_SYMBOL(tcf_exec_xmit_hook);
+
+void tcf_set_xmit_hook(int (*xmit_hook)(struct sk_buff *skb,
+					int (*xmit)(struct sk_buff *skb)))
+{
+	tcf_xmit_hook = xmit_hook;
+}
+EXPORT_SYMBOL(tcf_set_xmit_hook);
+
+void tcf_clear_xmit_hook(void)
+{
+	tcf_xmit_hook = NULL;
+}
+EXPORT_SYMBOL(tcf_clear_xmit_hook);
+
+void tcf_inc_xmit_hook(void)
+{
+	static_branch_inc(&tcf_xmit_hook_in_use);
+}
+EXPORT_SYMBOL(tcf_inc_xmit_hook);
+
+void tcf_dec_xmit_hook(void)
+{
+	static_branch_dec(&tcf_xmit_hook_in_use);
+}
+EXPORT_SYMBOL(tcf_dec_xmit_hook);
+
+bool tcf_xmit_hook_is_enabled(void)
+{
+	return static_branch_unlikely(&tcf_xmit_hook_in_use);
+}
+EXPORT_SYMBOL(tcf_xmit_hook_is_enabled);
+
 static void tcf_action_goto_chain_exec(const struct tc_action *a,
 				       struct tcf_result *res)
 {
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index aba3cd8..e23bc1f 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1541,6 +1541,8 @@ static int __init ct_init_module(void)
 	if (err)
 		goto err_register;
 
+	tcf_inc_xmit_hook();
+
 	return 0;
 
 err_register:
@@ -1552,6 +1554,7 @@ static int __init ct_init_module(void)
 
 static void __exit ct_cleanup_module(void)
 {
+	tcf_dec_xmit_hook();
 	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
 	tcf_ct_flow_tables_uninit();
 	destroy_workqueue(act_ct_wq);
diff --git a/net/sched/act_frag.c b/net/sched/act_frag.c
new file mode 100644
index 0000000..6bc4319
--- /dev/null
+++ b/net/sched/act_frag.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+#include <net/netlink.h>
+#include <net/pkt_sched.h>
+#include <net/pkt_cls.h>
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
+		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci & ~VLAN_CFI_MASK);
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
+	if (skb->protocol == htons(ETH_P_IP)) {
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
+	} else if (skb->protocol == htons(ETH_P_IPV6)) {
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
+		net_warn_ratelimited("Failed fragment ->%s: eth=%04x, MRU=%d, MTU=%d.\n",
+				     netdev_name(skb->dev), ntohs(skb->protocol),
+				     mru, skb->dev->mtu);
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
+static int tcf_frag_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
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
+
+static int __init frag_init_module(void)
+{
+	tcf_set_xmit_hook(tcf_frag_hook);
+
+	return 0;
+}
+
+static void __exit frag_cleanup_module(void)
+{
+	tcf_clear_xmit_hook();
+}
+
+module_init(frag_init_module);
+module_exit(frag_cleanup_module);
+MODULE_AUTHOR("wenxu <wenxu@ucloud.cn>");
+MODULE_LICENSE("GPL v2");
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 17d0095..f79ba06 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -209,10 +209,14 @@ static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
 {
 	int err;
 
-	if (!want_ingress)
-		err = dev_queue_xmit(skb);
-	else
+	if (!want_ingress) {
+		if (tcf_xmit_hook_is_enabled())
+			err = tcf_exec_xmit_hook(skb, dev_queue_xmit);
+		else
+			err = dev_queue_xmit(skb);
+	} else {
 		err = netif_receive_skb(skb);
+	}
 
 	return err;
 }
-- 
1.8.3.1

