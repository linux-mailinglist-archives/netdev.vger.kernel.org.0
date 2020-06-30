Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8E420EBA9
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 04:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgF3CyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 22:54:13 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:46320 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgF3CyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 22:54:13 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 373BF41872;
        Tue, 30 Jun 2020 10:54:07 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net/sched: act_mirred: fix fragment the packet after defrag in act_ct
Date:   Tue, 30 Jun 2020 10:54:06 +0800
Message-Id: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIQ0NLS0tLSkpPT09LQllXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWRciNQs4HDkVIkMhKwodCx4sMR4NOhxWVlVKSk4oSVlXWQkOFx
        4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mz46Ogw6Hjg6ES0SSUoPNQxP
        NTgaCxVVSlVKTkJIT0NOTU9DSUhCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUNNSUw3Bg++
X-HM-Tid: 0a7303255d862086kuqy373bf41872
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The fragment packets do defrag in act_ct module. The reassembled packet
over the mtu in the act_mirred. This big packet should be fragmented
to send out.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
This patch is based on
http://patchwork.ozlabs.org/project/netdev/patch/1593422178-26949-1-git-send-email-wenxu@ucloud.cn/

 include/net/sch_generic.h |   6 +-
 net/sched/act_ct.c        |   7 ++-
 net/sched/act_mirred.c    | 157 ++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 158 insertions(+), 12 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index c510b03..3597244 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -384,6 +384,7 @@ struct qdisc_skb_cb {
 	};
 #define QDISC_CB_PRIV_LEN 20
 	unsigned char		data[QDISC_CB_PRIV_LEN];
+	u16			mru;
 };
 
 typedef void tcf_chain_head_change_t(struct tcf_proto *tp_head, void *priv);
@@ -1283,9 +1284,4 @@ void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 void mini_qdisc_pair_block_init(struct mini_Qdisc_pair *miniqp,
 				struct tcf_block *block);
 
-static inline int skb_tc_reinsert(struct sk_buff *skb, struct tcf_result *res)
-{
-	return res->ingress ? netif_receive_skb(skb) : dev_queue_xmit(skb);
-}
-
 #endif
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ec0250f..59c85ee 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -705,6 +705,8 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		local_bh_enable();
 		if (err && err != -EINPROGRESS)
 			goto out_free;
+
+		cb.mru = IPCB(skb)->frag_max_size;
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
@@ -713,6 +715,8 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		err = nf_ct_frag6_gather(net, skb, user);
 		if (err && err != -EINPROGRESS)
 			goto out_free;
+
+		cb.mru = IP6CB(skb)->frag_max_size;
 #else
 		err = -EOPNOTSUPP;
 		goto out_free;
@@ -1017,7 +1021,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 
 out:
 	tcf_action_update_bstats(&c->common, skb);
-	qdisc_skb_cb(skb)->pkt_len = skb->len;
+	if (qdisc_skb_cb(skb)->mru)
+		qdisc_skb_cb(skb)->pkt_len = skb->len;
 	return retval;
 
 drop:
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 83dd82f..2ab9180 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -21,7 +21,11 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
+#include <net/dst.h>
+#include <net/ip.h>
+#include <net/ip6_fib.h>
 #include <linux/tc_act/tc_mirred.h>
+#include <linux/netfilter_ipv6.h>
 #include <net/tc_act/tc_mirred.h>
 
 static LIST_HEAD(mirred_list);
@@ -30,6 +34,18 @@
 #define MIRRED_RECURSION_LIMIT    4
 static DEFINE_PER_CPU(unsigned int, mirred_rec_level);
 
+struct tcf_mirred_frag_data {
+	unsigned long dst;
+	struct qdisc_skb_cb cb;
+	__be16 inner_protocol;
+	u16 vlan_tci;
+	__be16 vlan_proto;
+	unsigned int l2_len;
+	u8 l2_data[VLAN_ETH_HLEN];
+};
+
+static DEFINE_PER_CPU(struct tcf_mirred_frag_data, tcf_mirred_frag_data_storage);
+
 static bool tcf_mirred_is_act_redirect(int action)
 {
 	return action == TCA_EGRESS_REDIR || action == TCA_INGRESS_REDIR;
@@ -207,6 +223,138 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
+static int tcf_mirred_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+{
+	struct tcf_mirred_frag_data *data = this_cpu_ptr(&tcf_mirred_frag_data_storage);
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
+	dev_queue_xmit(skb);
+
+	return 0;
+}
+
+static void tcf_mirred_prepare_frag(struct sk_buff *skb)
+{
+	unsigned int hlen = skb_network_offset(skb);
+	struct tcf_mirred_frag_data *data;
+
+	data = this_cpu_ptr(&tcf_mirred_frag_data_storage);
+	data->dst = skb->_skb_refdst;
+	data->cb = *qdisc_skb_cb(skb);
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
+tcf_mirred_dst_get_mtu(const struct dst_entry *dst)
+{
+	return dst->dev->mtu;
+}
+
+static struct dst_ops tcf_mirred_dst_ops = {
+	.family = AF_UNSPEC,
+	.mtu = tcf_mirred_dst_get_mtu,
+};
+
+static int tcf_mirred_fragment(struct net *net, struct sk_buff *skb, u16 mru)
+{
+	if (skb_network_offset(skb) > VLAN_ETH_HLEN) {
+		net_warn_ratelimited("L2 header too long to fragment\n");
+		goto err;
+	}
+
+	if (skb->protocol == htons(ETH_P_IP)) {
+		struct dst_entry tcf_mirred_dst;
+		unsigned long orig_dst;
+
+		tcf_mirred_prepare_frag(skb);
+		dst_init(&tcf_mirred_dst, &tcf_mirred_dst_ops, NULL, 1,
+			 DST_OBSOLETE_NONE, DST_NOCOUNT);
+		tcf_mirred_dst.dev = skb->dev;
+
+		orig_dst = skb->_skb_refdst;
+		skb_dst_set_noref(skb, &tcf_mirred_dst);
+		IPCB(skb)->frag_max_size = mru;
+
+		ip_do_fragment(net, skb->sk, skb, tcf_mirred_output);
+		refdst_drop(orig_dst);
+	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
+		unsigned long orig_dst;
+		struct rt6_info tcf_mirred_rt;
+
+		if (!v6ops)
+			goto err;
+
+		tcf_mirred_prepare_frag(skb);
+		memset(&tcf_mirred_rt, 0, sizeof(tcf_mirred_rt));
+		dst_init(&tcf_mirred_rt.dst, &tcf_mirred_dst_ops, NULL, 1,
+			 DST_OBSOLETE_NONE, DST_NOCOUNT);
+		tcf_mirred_rt.dst.dev = skb->dev;
+
+		orig_dst = skb->_skb_refdst;
+		skb_dst_set_noref(skb, &tcf_mirred_rt.dst);
+		IP6CB(skb)->frag_max_size = mru;
+
+		v6ops->fragment(net, skb->sk, skb, tcf_mirred_output);
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
+static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
+{
+	u16 mru = qdisc_skb_cb(skb)->mru;
+	int err;
+
+	if (!want_ingress)
+		if (mru && skb->len > mru + skb->dev->hard_header_len)
+			err = tcf_mirred_fragment(dev_net(skb->dev), skb, mru);
+		else
+			err = dev_queue_xmit(skb);
+	else
+		err = netif_receive_skb(skb);
+
+	return err;
+}
+
 static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			  struct tcf_result *res)
 {
@@ -289,18 +437,15 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 		/* let's the caller reinsert the packet, if possible */
 		if (use_reinsert) {
 			res->ingress = want_ingress;
-			if (skb_tc_reinsert(skb, res))
+			err = tcf_mirred_forward(res->ingress, skb);
+			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
 			__this_cpu_dec(mirred_rec_level);
 			return TC_ACT_CONSUMED;
 		}
 	}
 
-	if (!want_ingress)
-		err = dev_queue_xmit(skb2);
-	else
-		err = netif_receive_skb(skb2);
-
+	err = tcf_mirred_forward(want_ingress, skb2);
 	if (err) {
 out:
 		tcf_action_inc_overlimit_qstats(&m->common);
-- 
1.8.3.1

