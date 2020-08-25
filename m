Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1422511E6
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 08:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgHYGJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 02:09:56 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:7342 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726015AbgHYGJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 02:09:53 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id CE6C05C1C5A
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 14:07:43 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Subject: [PATCH net-next] net/sched: add act_ct_output support
Date:   Tue, 25 Aug 2020 14:07:43 +0800
Message-Id: <1598335663-26503-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTE0eQhlCQ0sYGhgfVkpOQkNISE5NTUhCS0lVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBA6FQw4Mj5DMyEwDUM6Qx85
        GjUaCRRVSlVKTkJDSEhOTU1PSU1KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJSUJCNwY+
X-HM-Tid: 0a74243abee92087kuqyce6c05c1c5a
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The fragment packets do defrag in act_ct module. If the reassembled
packet should send out to another net device. This over mtu big packet
should be fragmented to send out. This patch add the act ct_output to
archive this.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/tc_act/tc_ct_output.h        |  40 ++
 include/uapi/linux/pkt_cls.h             |   1 +
 include/uapi/linux/tc_act/tc_ct_output.h |  26 ++
 net/sched/Kconfig                        |  11 +
 net/sched/Makefile                       |   1 +
 net/sched/act_ct_output.c                | 614 +++++++++++++++++++++++++++++++
 6 files changed, 693 insertions(+)
 create mode 100644 include/net/tc_act/tc_ct_output.h
 create mode 100644 include/uapi/linux/tc_act/tc_ct_output.h
 create mode 100644 net/sched/act_ct_output.c

diff --git a/include/net/tc_act/tc_ct_output.h b/include/net/tc_act/tc_ct_output.h
new file mode 100644
index 0000000..ac2690b
--- /dev/null
+++ b/include/net/tc_act/tc_ct_output.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_TC_CT_OUTPUT_H
+#define __NET_TC_CT_OUTPUT_H
+
+#include <net/act_api.h>
+#include <linux/tc_act/tc_ct_output.h>
+
+struct tcf_ct_output {
+	struct tc_action	common;
+	int			tcfm_eaction;
+	bool			tcfm_mac_header_xmit;
+	struct net_device __rcu	*tcfm_dev;
+	struct list_head	tcfm_list;
+};
+#define to_ct_output(a) ((struct tcf_ct_output *)a)
+
+static inline bool is_tcf_ct_output_redirect(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (a->ops && a->ops->id == TCA_ID_CT_OUTPUT)
+		return to_ct_output(a)->tcfm_eaction == TCA_CT_OUTPUT_REDIR;
+#endif
+	return false;
+}
+
+static inline bool is_tcf_ct_output_mirror(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (a->ops && a->ops->id == TCA_ID_CT_OUTPUT)
+		return to_ct_output(a)->tcfm_eaction == TCA_CT_OUTPUT_MIRROR;
+#endif
+	return false;
+}
+
+static inline struct net_device *tcf_ct_output_dev(const struct tc_action *a)
+{
+	return rtnl_dereference(to_ct_output(a)->tcfm_dev);
+}
+
+#endif /* __NET_TC_CT_OUTPUT_H */
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee95f42..5a79f72 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -135,6 +135,7 @@ enum tca_id {
 	TCA_ID_MPLS,
 	TCA_ID_CT,
 	TCA_ID_GATE,
+	TCA_ID_CT_OUTPUT,
 	/* other actions go here */
 	__TCA_ID_MAX = 255
 };
diff --git a/include/uapi/linux/tc_act/tc_ct_output.h b/include/uapi/linux/tc_act/tc_ct_output.h
new file mode 100644
index 0000000..6c6dd2b
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_ct_output.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __LINUX_TC_MIR_H
+#define __LINUX_TC_MIR_H
+
+#include <linux/types.h>
+#include <linux/pkt_cls.h>
+
+#define TCA_CT_OUTPUT_REDIR 1  /* packet redirect to EGRESS*/
+#define TCA_CT_OUTPUT_MIRROR 2 /* mirror packet to EGRESS */
+
+struct tc_ct_output {
+	tc_gen;
+	int                     eaction;   /* one of MIRROR/REDIR */
+	__u32                   ifindex;  /* ifindex of egress port */
+};
+
+enum {
+	TCA_CT_OUTPUT_UNSPEC,
+	TCA_CT_OUTPUT_TM,
+	TCA_CT_OUTPUT_PARMS,
+	TCA_CT_OUTPUT_PAD,
+	__TCA_CT_OUTPUT_MAX
+};
+#define TCA_CT_OUTPUT_MAX (__TCA_CT_OUTPUT_MAX - 1)
+
+#endif
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d8..352d058b 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -985,6 +985,17 @@ config NET_ACT_CT
 	  To compile this code as a module, choose M here: the
 	  module will be called act_ct.
 
+config NET_ACT_CT_OUTPUT
+	tristate "connection tracking output tc action"
+	depends on NET_CLS_ACT && NF_CONNTRACK
+	help
+	  Say Y here to allow outputing the connracked packets
+
+	  If unsure, say N.
+
+	  To compile this code as a module, choose M here: the
+	  module will be called act_ct_output.
+
 config NET_ACT_GATE
 	tristate "Frame gate entry list control tc action"
 	depends on NET_CLS_ACT
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 66bbf9a..401a2b2 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_NET_IFE_SKBTCINDEX)	+= act_meta_skbtcindex.o
 obj-$(CONFIG_NET_ACT_TUNNEL_KEY)+= act_tunnel_key.o
 obj-$(CONFIG_NET_ACT_CT)	+= act_ct.o
 obj-$(CONFIG_NET_ACT_GATE)	+= act_gate.o
+obj-$(CONFIG_NET_ACT_CT_OUTPUT)	+= act_ct_output.o
 obj-$(CONFIG_NET_SCH_FIFO)	+= sch_fifo.o
 obj-$(CONFIG_NET_SCH_CBQ)	+= sch_cbq.o
 obj-$(CONFIG_NET_SCH_HTB)	+= sch_htb.o
diff --git a/net/sched/act_ct_output.c b/net/sched/act_ct_output.c
new file mode 100644
index 0000000..a2283be
--- /dev/null
+++ b/net/sched/act_ct_output.c
@@ -0,0 +1,614 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/skbuff.h>
+#include <linux/rtnetlink.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/gfp.h>
+#include <linux/if_arp.h>
+#include <net/net_namespace.h>
+#include <net/netlink.h>
+#include <net/pkt_sched.h>
+#include <net/pkt_cls.h>
+#include <net/dst.h>
+#include <net/ip.h>
+#include <net/ip6_fib.h>
+#include <linux/netfilter_ipv6.h>
+#include <linux/tc_act/tc_ct_output.h>
+#include <net/tc_act/tc_ct_output.h>
+
+static LIST_HEAD(ct_output_list);
+static DEFINE_SPINLOCK(ct_output_list_lock);
+
+#define CT_OUTPUT_RECURSION_LIMIT    4
+static DEFINE_PER_CPU(unsigned int, ct_output_rec_level);
+
+struct tcf_ct_output_frag_data {
+	unsigned long dst;
+	struct qdisc_skb_cb cb;
+	__be16 inner_protocol;
+	u16 vlan_tci;
+	__be16 vlan_proto;
+	unsigned int l2_len;
+	u8 l2_data[VLAN_ETH_HLEN];
+};
+
+static DEFINE_PER_CPU(struct tcf_ct_output_frag_data, tcf_ct_output_frag_data_storage);
+
+static bool tcf_ct_output_is_act_redirect(int action)
+{
+	return action == TCA_CT_OUTPUT_REDIR;
+}
+
+static bool tcf_ct_output_can_reinsert(int action)
+{
+	switch (action) {
+	case TC_ACT_SHOT:
+	case TC_ACT_STOLEN:
+	case TC_ACT_QUEUED:
+	case TC_ACT_TRAP:
+		return true;
+	}
+	return false;
+}
+
+static struct net_device *tcf_ct_output_dev_dereference(struct tcf_ct_output *m)
+{
+	return rcu_dereference_protected(m->tcfm_dev,
+					 lockdep_is_held(&m->tcf_lock));
+}
+
+static void tcf_ct_output_release(struct tc_action *a)
+{
+	struct tcf_ct_output *m = to_ct_output(a);
+	struct net_device *dev;
+
+	spin_lock(&ct_output_list_lock);
+	list_del(&m->tcfm_list);
+	spin_unlock(&ct_output_list_lock);
+
+	/* last reference to action, no need to lock */
+	dev = rcu_dereference_protected(m->tcfm_dev, 1);
+	if (dev)
+		dev_put(dev);
+}
+
+static const struct nla_policy ct_output_policy[TCA_CT_OUTPUT_MAX + 1] = {
+	[TCA_CT_OUTPUT_PARMS]	= { .len = sizeof(struct tc_ct_output) },
+};
+
+static unsigned int ct_output_net_id;
+static struct tc_action_ops act_ct_output_ops;
+
+static int tcf_ct_output_init(struct net *net, struct nlattr *nla,
+			      struct nlattr *est, struct tc_action **a,
+			      int ovr, int bind, bool rtnl_held,
+			      struct tcf_proto *tp,
+			      u32 flags, struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, ct_output_net_id);
+	struct nlattr *tb[TCA_CT_OUTPUT_MAX + 1];
+	struct tcf_chain *goto_ch = NULL;
+	bool mac_header_xmit = false;
+	struct tc_ct_output *parm;
+	struct tcf_ct_output *m;
+	struct net_device *dev;
+	bool exists = false;
+	int ret, err;
+	u32 index;
+
+	if (!nla) {
+		NL_SET_ERR_MSG_MOD(extack, "ct_output requires attributes to be passed");
+		return -EINVAL;
+	}
+	ret = nla_parse_nested_deprecated(tb, TCA_CT_OUTPUT_MAX, nla,
+					  ct_output_policy, extack);
+	if (ret < 0)
+		return ret;
+	if (!tb[TCA_CT_OUTPUT_PARMS]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing required ct_output parameters");
+		return -EINVAL;
+	}
+	parm = nla_data(tb[TCA_CT_OUTPUT_PARMS]);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
+	if (err < 0)
+		return err;
+	exists = err;
+	if (exists && bind)
+		return 0;
+
+	switch (parm->eaction) {
+	case TCA_CT_OUTPUT_MIRROR:
+	case TCA_CT_OUTPUT_REDIR:
+		break;
+	default:
+		if (exists)
+			tcf_idr_release(*a, bind);
+		else
+			tcf_idr_cleanup(tn, index);
+		NL_SET_ERR_MSG_MOD(extack, "Unknown ct_output option");
+		return -EINVAL;
+	}
+
+	if (!exists) {
+		if (!parm->ifindex) {
+			tcf_idr_cleanup(tn, index);
+			NL_SET_ERR_MSG_MOD(extack, "Specified device does not exist");
+			return -EINVAL;
+		}
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_ct_output_ops, bind, flags);
+		if (ret) {
+			tcf_idr_cleanup(tn, index);
+			return ret;
+		}
+		ret = ACT_P_CREATED;
+	} else if (!ovr) {
+		tcf_idr_release(*a, bind);
+		return -EEXIST;
+	}
+
+	m = to_ct_output(*a);
+	if (ret == ACT_P_CREATED)
+		INIT_LIST_HEAD(&m->tcfm_list);
+
+	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
+	if (err < 0)
+		goto release_idr;
+
+	spin_lock_bh(&m->tcf_lock);
+
+	if (parm->ifindex) {
+		dev = dev_get_by_index(net, parm->ifindex);
+		if (!dev) {
+			spin_unlock_bh(&m->tcf_lock);
+			err = -ENODEV;
+			goto put_chain;
+		}
+		mac_header_xmit = dev_is_mac_header_xmit(dev);
+		dev = rcu_replace_pointer(m->tcfm_dev, dev,
+					  lockdep_is_held(&m->tcf_lock));
+		if (dev)
+			dev_put(dev);
+		m->tcfm_mac_header_xmit = mac_header_xmit;
+	}
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	m->tcfm_eaction = parm->eaction;
+	spin_unlock_bh(&m->tcf_lock);
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+
+	if (ret == ACT_P_CREATED) {
+		spin_lock(&ct_output_list_lock);
+		list_add(&m->tcfm_list, &ct_output_list);
+		spin_unlock(&ct_output_list_lock);
+
+		tcf_idr_insert(tn, *a);
+	}
+
+	return ret;
+put_chain:
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+release_idr:
+	tcf_idr_release(*a, bind);
+	return err;
+}
+
+static int tcf_ct_output_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+{
+	struct tcf_ct_output_frag_data *data = this_cpu_ptr(&tcf_ct_output_frag_data_storage);
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
+static void tcf_ct_output_prepare_frag(struct sk_buff *skb)
+{
+	unsigned int hlen = skb_network_offset(skb);
+	struct tcf_ct_output_frag_data *data;
+
+	data = this_cpu_ptr(&tcf_ct_output_frag_data_storage);
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
+tcf_ct_output_dst_get_mtu(const struct dst_entry *dst)
+{
+	return dst->dev->mtu;
+}
+
+static struct dst_ops tcf_ct_output_dst_ops = {
+	.family = AF_UNSPEC,
+	.mtu = tcf_ct_output_dst_get_mtu,
+};
+
+static int tcf_ct_output_fragment(struct net *net, struct sk_buff *skb, u16 mru)
+{
+	if (skb_network_offset(skb) > VLAN_ETH_HLEN) {
+		net_warn_ratelimited("L2 header too long to fragment\n");
+		goto err;
+	}
+
+	if (skb->protocol == htons(ETH_P_IP)) {
+		struct dst_entry tcf_ct_output_dst;
+		unsigned long orig_dst;
+
+		tcf_ct_output_prepare_frag(skb);
+		dst_init(&tcf_ct_output_dst, &tcf_ct_output_dst_ops, NULL, 1,
+			 DST_OBSOLETE_NONE, DST_NOCOUNT);
+		tcf_ct_output_dst.dev = skb->dev;
+
+		orig_dst = skb->_skb_refdst;
+		skb_dst_set_noref(skb, &tcf_ct_output_dst);
+		IPCB(skb)->frag_max_size = mru;
+
+		ip_do_fragment(net, skb->sk, skb, tcf_ct_output_output);
+		refdst_drop(orig_dst);
+	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
+		unsigned long orig_dst;
+		struct rt6_info tcf_ct_output_rt;
+
+		if (!v6ops)
+			goto err;
+
+		tcf_ct_output_prepare_frag(skb);
+		memset(&tcf_ct_output_rt, 0, sizeof(tcf_ct_output_rt));
+		dst_init(&tcf_ct_output_rt.dst, &tcf_ct_output_dst_ops, NULL, 1,
+			 DST_OBSOLETE_NONE, DST_NOCOUNT);
+		tcf_ct_output_rt.dst.dev = skb->dev;
+
+		orig_dst = skb->_skb_refdst;
+		skb_dst_set_noref(skb, &tcf_ct_output_rt.dst);
+		IP6CB(skb)->frag_max_size = mru;
+
+		v6ops->fragment(net, skb->sk, skb, tcf_ct_output_output);
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
+static int tcf_ct_output_forward(struct sk_buff *skb)
+{
+	u16 mru = qdisc_skb_cb(skb)->mru;
+	int err;
+
+	if (mru && skb->len > mru + skb->dev->hard_header_len)
+		err = tcf_ct_output_fragment(dev_net(skb->dev), skb, mru);
+	else
+		err = dev_queue_xmit(skb);
+
+	return err;
+}
+
+static int tcf_ct_output_act(struct sk_buff *skb, const struct tc_action *a,
+			     struct tcf_result *res)
+{
+	struct tcf_ct_output *m = to_ct_output(a);
+	struct sk_buff *skb2 = skb;
+	bool m_mac_header_xmit;
+	struct net_device *dev;
+	unsigned int rec_level;
+	int retval, err = 0;
+	bool use_reinsert;
+	bool is_redirect;
+	bool expects_nh;
+	int m_eaction;
+	int mac_len;
+	bool at_nh;
+
+	rec_level = __this_cpu_inc_return(ct_output_rec_level);
+	if (unlikely(rec_level > CT_OUTPUT_RECURSION_LIMIT)) {
+		net_warn_ratelimited("Packet exceeded ct_output recursion limit on dev %s\n",
+				     netdev_name(skb->dev));
+		__this_cpu_dec(ct_output_rec_level);
+		return TC_ACT_SHOT;
+	}
+
+	tcf_lastuse_update(&m->tcf_tm);
+	tcf_action_update_bstats(&m->common, skb);
+
+	m_mac_header_xmit = READ_ONCE(m->tcfm_mac_header_xmit);
+	m_eaction = READ_ONCE(m->tcfm_eaction);
+	retval = READ_ONCE(m->tcf_action);
+	dev = rcu_dereference_bh(m->tcfm_dev);
+	if (unlikely(!dev)) {
+		pr_notice_once("tc ct_output: target device is gone\n");
+		goto out;
+	}
+
+	if (unlikely(!(dev->flags & IFF_UP))) {
+		net_notice_ratelimited("tc ct_output to Houston: device %s is down\n",
+				       dev->name);
+		goto out;
+	}
+
+	/* we could easily avoid the clone only if called by ingress and clsact;
+	 * since we can't easily detect the clsact caller, skip clone only for
+	 * ingress - that covers the TC S/W datapath.
+	 */
+	is_redirect = tcf_ct_output_is_act_redirect(m_eaction);
+	use_reinsert = skb_at_tc_ingress(skb) && is_redirect &&
+		       tcf_ct_output_can_reinsert(retval);
+	if (!use_reinsert) {
+		skb2 = skb_clone(skb, GFP_ATOMIC);
+		if (!skb2)
+			goto out;
+	}
+
+	expects_nh = !m_mac_header_xmit;
+	at_nh = skb->data == skb_network_header(skb);
+	if (at_nh != expects_nh) {
+		mac_len = skb_at_tc_ingress(skb) ? skb->mac_len :
+			  skb_network_header(skb) - skb_mac_header(skb);
+		if (expects_nh) {
+			/* target device/action expect data at nh */
+			skb_pull_rcsum(skb2, mac_len);
+		} else {
+			/* target device/action expect data at mac */
+			skb_push_rcsum(skb2, mac_len);
+		}
+	}
+
+	skb2->skb_iif = skb->dev->ifindex;
+	skb2->dev = dev;
+
+	/* mirror is always swallowed */
+	if (is_redirect) {
+		skb_set_redirected(skb2, skb2->tc_at_ingress);
+
+		/* let's the caller reinsert the packet, if possible */
+		if (use_reinsert) {
+			if (tcf_ct_output_forward(skb))
+				tcf_action_inc_overlimit_qstats(&m->common);
+			__this_cpu_dec(ct_output_rec_level);
+			return TC_ACT_CONSUMED;
+		}
+	}
+
+	err = tcf_ct_output_forward(skb2);
+	if (err) {
+out:
+		tcf_action_inc_overlimit_qstats(&m->common);
+		if (tcf_ct_output_is_act_redirect(m_eaction))
+			retval = TC_ACT_SHOT;
+	}
+	__this_cpu_dec(ct_output_rec_level);
+
+	return retval;
+}
+
+static void tcf_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+			     u64 drops, u64 lastuse, bool hw)
+{
+	struct tcf_ct_output *m = to_ct_output(a);
+	struct tcf_t *tm = &m->tcf_tm;
+
+	tcf_action_update_stats(a, bytes, packets, drops, hw);
+	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
+}
+
+static int tcf_ct_output_dump(struct sk_buff *skb, struct tc_action *a,
+			      int bind, int ref)
+{
+	unsigned char *b = skb_tail_pointer(skb);
+	struct tcf_ct_output *m = to_ct_output(a);
+	struct tc_ct_output opt = {
+		.index   = m->tcf_index,
+		.refcnt  = refcount_read(&m->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&m->tcf_bindcnt) - bind,
+	};
+	struct net_device *dev;
+	struct tcf_t t;
+
+	spin_lock_bh(&m->tcf_lock);
+	opt.action = m->tcf_action;
+	opt.eaction = m->tcfm_eaction;
+	dev = tcf_ct_output_dev_dereference(m);
+	if (dev)
+		opt.ifindex = dev->ifindex;
+
+	if (nla_put(skb, TCA_CT_OUTPUT_PARMS, sizeof(opt), &opt))
+		goto nla_put_failure;
+
+	tcf_tm_dump(&t, &m->tcf_tm);
+	if (nla_put_64bit(skb, TCA_CT_OUTPUT_TM, sizeof(t), &t, TCA_CT_OUTPUT_PAD))
+		goto nla_put_failure;
+	spin_unlock_bh(&m->tcf_lock);
+
+	return skb->len;
+
+nla_put_failure:
+	spin_unlock_bh(&m->tcf_lock);
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+static int tcf_ct_output_walker(struct net *net, struct sk_buff *skb,
+				struct netlink_callback *cb, int type,
+				const struct tc_action_ops *ops,
+				struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, ct_output_net_id);
+
+	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
+}
+
+static int tcf_ct_output_search(struct net *net, struct tc_action **a, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, ct_output_net_id);
+
+	return tcf_idr_search(tn, a, index);
+}
+
+static int ct_output_device_event(struct notifier_block *unused,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct tcf_ct_output *m;
+
+	ASSERT_RTNL();
+	if (event == NETDEV_UNREGISTER) {
+		spin_lock(&ct_output_list_lock);
+		list_for_each_entry(m, &ct_output_list, tcfm_list) {
+			spin_lock_bh(&m->tcf_lock);
+			if (tcf_ct_output_dev_dereference(m) == dev) {
+				dev_put(dev);
+				/* Note : no rcu grace period necessary, as
+				 * net_device are already rcu protected.
+				 */
+				RCU_INIT_POINTER(m->tcfm_dev, NULL);
+			}
+			spin_unlock_bh(&m->tcf_lock);
+		}
+		spin_unlock(&ct_output_list_lock);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block ct_output_device_notifier = {
+	.notifier_call = ct_output_device_event,
+};
+
+static void tcf_ct_output_dev_put(void *priv)
+{
+	struct net_device *dev = priv;
+
+	dev_put(dev);
+}
+
+static struct net_device *
+tcf_ct_output_get_dev(const struct tc_action *a,
+		      tc_action_priv_destructor *destructor)
+{
+	struct tcf_ct_output *m = to_ct_output(a);
+	struct net_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(m->tcfm_dev);
+	if (dev) {
+		dev_hold(dev);
+		*destructor = tcf_ct_output_dev_put;
+	}
+	rcu_read_unlock();
+
+	return dev;
+}
+
+static size_t tcf_ct_output_get_fill_size(const struct tc_action *act)
+{
+	return nla_total_size(sizeof(struct tc_ct_output));
+}
+
+static struct tc_action_ops act_ct_output_ops = {
+	.kind		=	"ct_output",
+	.id		=	TCA_ID_CT_OUTPUT,
+	.owner		=	THIS_MODULE,
+	.act		=	tcf_ct_output_act,
+	.stats_update	=	tcf_stats_update,
+	.dump		=	tcf_ct_output_dump,
+	.cleanup	=	tcf_ct_output_release,
+	.init		=	tcf_ct_output_init,
+	.walk		=	tcf_ct_output_walker,
+	.lookup		=	tcf_ct_output_search,
+	.get_fill_size	=	tcf_ct_output_get_fill_size,
+	.size		=	sizeof(struct tcf_ct_output),
+	.get_dev	=	tcf_ct_output_get_dev,
+};
+
+static __net_init int ct_output_init_net(struct net *net)
+{
+	struct tc_action_net *tn = net_generic(net, ct_output_net_id);
+
+	return tc_action_net_init(net, tn, &act_ct_output_ops);
+}
+
+static void __net_exit ct_output_exit_net(struct list_head *net_list)
+{
+	tc_action_net_exit(net_list, ct_output_net_id);
+}
+
+static struct pernet_operations ct_output_net_ops = {
+	.init = ct_output_init_net,
+	.exit_batch = ct_output_exit_net,
+	.id   = &ct_output_net_id,
+	.size = sizeof(struct tc_action_net),
+};
+
+MODULE_AUTHOR("wenxu@ucloud.cn");
+MODULE_DESCRIPTION("Device output actions for conntracked packets");
+MODULE_LICENSE("GPL");
+
+static int __init ct_output_init_module(void)
+{
+	int err;
+
+	err = register_netdevice_notifier(&ct_output_device_notifier);
+	if (err)
+		return err;
+
+	pr_info("ct_output action on\n");
+	err = tcf_register_action(&act_ct_output_ops, &ct_output_net_ops);
+	if (err)
+		unregister_netdevice_notifier(&ct_output_device_notifier);
+
+	return err;
+}
+
+static void __exit ct_output_cleanup_module(void)
+{
+	tcf_unregister_action(&act_ct_output_ops, &ct_output_net_ops);
+	unregister_netdevice_notifier(&ct_output_device_notifier);
+}
+
+module_init(ct_output_init_module);
+module_exit(ct_output_cleanup_module);
-- 
1.8.3.1

