Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DD62B73CB
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgKRBh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:37:56 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:59154 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKRBh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:37:56 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 0459E5C1B3E;
        Wed, 18 Nov 2020 09:37:48 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, marcelo.leitner@gmail.com, vladbu@nvidia.com,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 net-next 3/3] net/sched: sch_frag: add generic packet fragment support.
Date:   Wed, 18 Nov 2020 09:37:48 +0800
Message-Id: <1605663468-14275-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTklMHR9LHR9ITEJCVkpNS05NTUhPTUJKSENVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NE06Egw6Hj04UT0XDyw4DB01
        SysaFDVVSlVKTUtOTU1IT01CT0pPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpLT05NNwY+
X-HM-Tid: 0a75d9002e0c2087kuqy0459e5c1b3e
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
v2: make act_frag just buildin for tc core but not a module
    return an error code from tcf_fragment
    depends on INET for ip_do_fragment

 include/net/act_api.h     |   8 +++
 include/net/sch_generic.h |   2 +
 net/sched/Makefile        |   2 +-
 net/sched/act_api.c       |  44 ++++++++++++++
 net/sched/act_ct.c        |   7 +++
 net/sched/act_mirred.c    |   2 +-
 net/sched/sch_frag.c      | 152 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 215 insertions(+), 2 deletions(-)
 create mode 100644 net/sched/sch_frag.c

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 8721492..decb6de 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -239,6 +239,14 @@ int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct netlink_ext_ack *newchain);
 struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
 					 struct tcf_chain *newchain);
+
+typedef int xmit_hook_func(struct sk_buff *skb,
+			   int (*xmit)(struct sk_buff *skb));
+
+int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
+int tcf_set_xmit_hook(xmit_hook_func *xmit_hook);
+void tcf_clear_xmit_hook(void);
+
 #endif /* CONFIG_NET_CLS_ACT */
 
 static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index dd74f06..162ed62 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1281,4 +1281,6 @@ void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 void mini_qdisc_pair_block_init(struct mini_Qdisc_pair *miniqp,
 				struct tcf_block *block);
 
+int sch_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
+
 #endif
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 66bbf9a..b9c5dfe 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the Linux Traffic Control Unit.
 #
 
-obj-y	:= sch_generic.o sch_mq.o
+obj-y	:= sch_generic.o sch_mq.o sch_frag.o
 
 obj-$(CONFIG_NET_SCHED)		+= sch_api.o sch_blackhole.o
 obj-$(CONFIG_NET_CLS)		+= cls_api.o
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 60e1572..fbb35a8 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -22,6 +22,50 @@
 #include <net/act_api.h>
 #include <net/netlink.h>
 
+static xmit_hook_func __rcu *tcf_xmit_hook;
+static DEFINE_SPINLOCK(tcf_xmit_hook_lock);
+static u16 tcf_xmit_hook_count;
+
+int tcf_set_xmit_hook(xmit_hook_func *xmit_hook)
+{
+	spin_lock(&tcf_xmit_hook_lock);
+	if (!tcf_xmit_hook_count) {
+		rcu_assign_pointer(tcf_xmit_hook, xmit_hook);
+	} else if (xmit_hook != rcu_access_pointer(tcf_xmit_hook)) {
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
+	xmit_hook_func *xmit_hook;
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
index aba3cd8..f82dc65 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1541,8 +1541,14 @@ static int __init ct_init_module(void)
 	if (err)
 		goto err_register;
 
+	err = tcf_set_xmit_hook(sch_frag_xmit_hook);
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
 
diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
new file mode 100644
index 0000000..ffd1a41
--- /dev/null
+++ b/net/sched/sch_frag.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+#include <net/netlink.h>
+#include <net/sch_generic.h>
+#include <net/dst.h>
+#include <net/ip.h>
+#include <net/ip6_fib.h>
+
+struct sch_frag_data {
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
+static DEFINE_PER_CPU(struct sch_frag_data, sch_frag_data_storage);
+
+static int sch_frag_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
+{
+	struct sch_frag_data *data = this_cpu_ptr(&sch_frag_data_storage);
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
+	return data->xmit(skb);
+}
+
+static void sch_frag_prepare_frag(struct sk_buff *skb,
+				  int (*xmit)(struct sk_buff *skb))
+{
+	unsigned int hlen = skb_network_offset(skb);
+	struct sch_frag_data *data;
+
+	data = this_cpu_ptr(&sch_frag_data_storage);
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
+sch_frag_dst_get_mtu(const struct dst_entry *dst)
+{
+	return dst->dev->mtu;
+}
+
+static struct dst_ops sch_frag_dst_ops = {
+	.family = AF_UNSPEC,
+	.mtu = sch_frag_dst_get_mtu,
+};
+
+static int sch_fragment(struct net *net, struct sk_buff *skb,
+			u16 mru, int (*xmit)(struct sk_buff *skb))
+{
+	int ret = -1;
+
+	if (skb_network_offset(skb) > VLAN_ETH_HLEN) {
+		net_warn_ratelimited("L2 header too long to fragment\n");
+		goto err;
+	}
+
+	if (skb_protocol(skb, true) == htons(ETH_P_IP)) {
+		struct dst_entry sch_frag_dst;
+		unsigned long orig_dst;
+
+		sch_frag_prepare_frag(skb, xmit);
+		dst_init(&sch_frag_dst, &sch_frag_dst_ops, NULL, 1,
+			 DST_OBSOLETE_NONE, DST_NOCOUNT);
+		sch_frag_dst.dev = skb->dev;
+
+		orig_dst = skb->_skb_refdst;
+		skb_dst_set_noref(skb, &sch_frag_dst);
+		IPCB(skb)->frag_max_size = mru;
+
+#ifdef CONFIG_INET
+		ret = ip_do_fragment(net, skb->sk, skb, sch_frag_xmit);
+#endif
+		refdst_drop(orig_dst);
+	} else if (skb_protocol(skb, true) == htons(ETH_P_IPV6)) {
+		unsigned long orig_dst;
+		struct rt6_info sch_frag_rt;
+
+		sch_frag_prepare_frag(skb, xmit);
+		memset(&sch_frag_rt, 0, sizeof(sch_frag_rt));
+		dst_init(&sch_frag_rt.dst, &sch_frag_dst_ops, NULL, 1,
+			 DST_OBSOLETE_NONE, DST_NOCOUNT);
+		sch_frag_rt.dst.dev = skb->dev;
+
+		orig_dst = skb->_skb_refdst;
+		skb_dst_set_noref(skb, &sch_frag_rt.dst);
+		IP6CB(skb)->frag_max_size = mru;
+
+		ret = ipv6_stub->ipv6_fragment(net, skb->sk, skb,
+					       sch_frag_xmit);
+		refdst_drop(orig_dst);
+	} else {
+		net_warn_ratelimited("Fail frag %s: eth=%x, MRU=%d, MTU=%d\n",
+				     netdev_name(skb->dev),
+				     ntohs(skb_protocol(skb, true)), mru,
+				     skb->dev->mtu);
+		goto err;
+	}
+
+	return ret;
+err:
+	kfree_skb(skb);
+	return ret;
+}
+
+int sch_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
+{
+	u16 mru = qdisc_skb_cb(skb)->mru;
+	int err;
+
+	if (mru && skb->len > mru + skb->dev->hard_header_len)
+		err = sch_fragment(dev_net(skb->dev), skb, mru, xmit);
+	else
+		err = xmit(skb);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(sch_frag_xmit_hook);
-- 
1.8.3.1

