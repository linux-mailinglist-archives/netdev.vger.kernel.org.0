Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80BF2B59AD
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 07:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgKQGWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 01:22:03 -0500
Received: from inva020.nxp.com ([92.121.34.13]:54272 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726854AbgKQGWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 01:22:02 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 848191A11A5;
        Tue, 17 Nov 2020 07:21:57 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8EB761A11A3;
        Tue, 17 Nov 2020 07:21:48 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 18B91402D2;
        Tue, 17 Nov 2020 07:21:37 +0100 (CET)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     xiaoliang.yang_1@nxp.com, Arvid.Brodin@xdin.com,
        m-karicheri2@ti.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ivan.khoronzhuk@linaro.org, andre.guedes@linux.intel.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        po.liu@nxp.com, mingkai.hu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com
Subject: [RFC, net-next] net: qos: introduce a redundancy flow action
Date:   Tue, 17 Nov 2020 14:30:13 +0800
Message-Id: <20201117063013.37433-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduce a redundancy flow action to implement frame
replication and elimination for reliability, which is defined in
IEEE P802.1CB.

There are two modes for redundancy action: generator and recover mode.
Generator mode add redundancy tag and replicate the frame to different
egress ports. Recover mode drop the repeat frames and remove redundancy
tag from the frame.

Below is the setting example in user space:
	> tc qdisc add dev swp0 clsact
	> tc filter add dev swp0 ingress protocol 802.1Q flower \
		skip_hw dst_mac 00:01:02:03:04:05 vlan_id 1 \
		action redundancy generator split dev swp1 dev swp2

	> tc filter add dev swp0 ingress protocol 802.1Q flower
		skip_hw dst_mac 00:01:02:03:04:06 vlan_id 1 \
		action redundancy recover

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 include/net/flow_offload.h                |   6 +
 include/net/tc_act/tc_redundancy.h        |  69 +++
 include/uapi/linux/if_ether.h             |   1 +
 include/uapi/linux/pkt_cls.h              |   1 +
 include/uapi/linux/tc_act/tc_redundancy.h |  36 ++
 net/sched/Kconfig                         |  14 +
 net/sched/Makefile                        |   1 +
 net/sched/act_redundancy.c                | 495 ++++++++++++++++++++++
 net/sched/cls_api.c                       |  31 ++
 9 files changed, 654 insertions(+)
 create mode 100644 include/net/tc_act/tc_redundancy.h
 create mode 100644 include/uapi/linux/tc_act/tc_redundancy.h
 create mode 100644 net/sched/act_redundancy.c

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 123b1e9ea304..aed41f3801b7 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -147,6 +147,7 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_POP,
 	FLOW_ACTION_MPLS_MANGLE,
 	FLOW_ACTION_GATE,
+	FLOW_ACTION_REDUNDANCY,
 	NUM_FLOW_ACTIONS,
 };
 
@@ -271,6 +272,11 @@ struct flow_action_entry {
 			u32		num_entries;
 			struct action_gate_entry *entries;
 		} gate;
+		struct {
+			u8		mode;
+			u32		split_num;
+			struct net_device **split_devs;
+		} redundancy;
 	};
 	struct flow_action_cookie *cookie; /* user defined action cookie */
 };
diff --git a/include/net/tc_act/tc_redundancy.h b/include/net/tc_act/tc_redundancy.h
new file mode 100644
index 000000000000..77b043636f93
--- /dev/null
+++ b/include/net/tc_act/tc_redundancy.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright 2020 NXP */
+
+#ifndef __NET_TC_REDUNDANCY_H
+#define __NET_TC_REDUNDANCY_H
+
+#include <net/act_api.h>
+#include <linux/tc_act/tc_redundancy.h>
+
+struct tcf_redundancy_split_dev {
+	struct list_head list;
+	struct net_device *dev;
+};
+
+struct tcf_redundancy {
+	struct tc_action	common;
+	u8			mode;
+	struct list_head	split_list;
+	u32			gen_seq_num;
+	u32			sequence_history;
+	u32			recov_seq_num;
+};
+
+#define to_redundancy(a) ((struct tcf_redundancy *)a)
+
+static inline bool is_tcf_redundancy(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (a->ops && a->ops->id == TCA_ID_REDUNDANCY)
+		return true;
+#endif
+	return false;
+}
+
+static inline u8 tcf_redundancy_mode(const struct tc_action *a)
+{
+	u8 mode;
+
+	mode = to_redundancy(a)->mode;
+
+	return mode;
+}
+
+static inline struct net_device **
+	tcf_redundancy_create_dev_array(const struct tc_action *a, int *len)
+{
+	struct tcf_redundancy_split_dev *entry;
+	struct tcf_redundancy *red_act;
+	struct net_device **devices;
+	int i = 0;
+
+	red_act = to_redundancy(a);
+
+	list_for_each_entry(entry, &red_act->split_list, list)
+		i++;
+
+	devices = kcalloc(i, sizeof(*devices), GFP_ATOMIC);
+	if (!devices)
+		return NULL;
+	*len = i;
+
+	i = 0;
+	list_for_each_entry(entry, &red_act->split_list, list)
+		devices[i++] = entry->dev;
+
+	return devices;
+}
+
+#endif
diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index a0b637911d3c..c465d68b1d93 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -114,6 +114,7 @@
 #define ETH_P_EDSA	0xDADA		/* Ethertype DSA [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_DSA_8021Q	0xDADB		/* Fake VLAN Header for DSA [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_IFE	0xED3E		/* ForCES inter-FE LFB type */
+#define ETH_P_RTAG	0xF1C1		/* Redundancy Tag(IEEE 802.1CB) */
 #define ETH_P_AF_IUCV   0xFBFB		/* IBM af_iucv [ NOT AN OFFICIALLY REGISTERED ID ] */
 
 #define ETH_P_802_3_MIN	0x0600		/* If the value in the ethernet type is less than this value
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee95f42fb0ec..17a82cae74f4 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -135,6 +135,7 @@ enum tca_id {
 	TCA_ID_MPLS,
 	TCA_ID_CT,
 	TCA_ID_GATE,
+	TCA_ID_REDUNDANCY,
 	/* other actions go here */
 	__TCA_ID_MAX = 255
 };
diff --git a/include/uapi/linux/tc_act/tc_redundancy.h b/include/uapi/linux/tc_act/tc_redundancy.h
new file mode 100644
index 000000000000..2ddffff73f24
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_redundancy.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/* Copyright 2020 NXP */
+
+#ifndef __LINUX_TC_REDUNDANCY_H
+#define __LINUX_TC_REDUNDANCY_H
+
+#include <linux/pkt_cls.h>
+
+struct tc_redundancy {
+	tc_gen;
+};
+
+enum {
+	TCA_REDUNDANCY_ENTRY_UNSPEC,
+	TCA_REDUNDANCY_ENTRY_PORT,
+	__TCA_REDUNDANCY_ENTRY_MAX,
+};
+#define TCA_REDUNDANCY_ENTRY_MAX (__TCA_REDUNDANCY_ENTRY_MAX - 1)
+
+enum {
+	TCA_REDUNDANCY_UNSPEC,
+	TCA_REDUNDANCY_TM,
+	TCA_REDUNDANCY_PARMS,
+	TCA_REDUNDANCY_PAD,
+	TCA_REDUNDANCY_MODE,
+	TCA_REDUNDANCY_SPLITLIST,
+	__TCA_REDUNDANCY_MAX,
+};
+#define TCA_REDUNDANCY_MAX (__TCA_REDUNDANCY_MAX - 1)
+
+enum {
+	TCA_REDUNDANCY_GENERATOR,
+	TCA_REDUNDANCY_RECOVER,
+};
+
+#endif
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d88800e..fba452fb9bd5 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -997,6 +997,20 @@ config NET_ACT_GATE
 	  To compile this code as a module, choose M here: the
 	  module will be called act_gate.
 
+config NET_ACT_REDUNDANCY
+	tristate "Frame redundancy tc action"
+	depends on NET_CLS_ACT
+	help
+	  Say Y here to support frame replication and elimination for
+	  reliability, which is defined by IEEE 802.1CB.
+	  This action allow to control the ingress flow to split to
+	  multiple egress ports, each frame will add a redundancy tag.
+	  It also allow to remove redundancy tag and drop repeat frames.
+
+	  If unsure, say N.
+	  To compile this code as a module, choose M here: the
+	  module will be called act_redundancy.
+
 config NET_IFE_SKBMARK
 	tristate "Support to encoding decoding skb mark on IFE action"
 	depends on NET_ACT_IFE
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 66bbf9a98f9e..1809e894510f 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_NET_IFE_SKBTCINDEX)	+= act_meta_skbtcindex.o
 obj-$(CONFIG_NET_ACT_TUNNEL_KEY)+= act_tunnel_key.o
 obj-$(CONFIG_NET_ACT_CT)	+= act_ct.o
 obj-$(CONFIG_NET_ACT_GATE)	+= act_gate.o
+obj-$(CONFIG_NET_ACT_REDUNDANCY)	+= act_redundancy.o
 obj-$(CONFIG_NET_SCH_FIFO)	+= sch_fifo.o
 obj-$(CONFIG_NET_SCH_CBQ)	+= sch_cbq.o
 obj-$(CONFIG_NET_SCH_HTB)	+= sch_htb.o
diff --git a/net/sched/act_redundancy.c b/net/sched/act_redundancy.c
new file mode 100644
index 000000000000..c937b772c29d
--- /dev/null
+++ b/net/sched/act_redundancy.c
@@ -0,0 +1,495 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright 2020 NXP */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/skbuff.h>
+#include <linux/rtnetlink.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <net/act_api.h>
+#include <net/netlink.h>
+#include <net/pkt_cls.h>
+#include <net/tc_act/tc_redundancy.h>
+
+#define SEQ_HISTORY_LEN 32
+
+static unsigned int redundancy_net_id;
+static struct tc_action_ops act_redundancy_ops;
+
+struct redundancy_tag {
+	__be16 proto;
+	__be16 reserved;
+	__be16 sequence;
+} __packed;
+
+struct rtag_ethhdr {
+	unsigned char		h_dest[ETH_ALEN];
+	unsigned char		h_source[ETH_ALEN];
+	struct redundancy_tag	h_rtag;
+	__be16			h_proto;
+} __packed;
+
+struct rtag_vlan_ethhdr {
+	unsigned char		h_dest[ETH_ALEN];
+	unsigned char		h_source[ETH_ALEN];
+	__be16			h_vlan_proto;
+	__be16			h_vlan_TCI;
+	struct redundancy_tag	h_rtag;
+	__be16			h_proto;
+} __packed;
+
+static const struct nla_policy entry_policy[TCA_REDUNDANCY_ENTRY_MAX + 1] = {
+	[TCA_REDUNDANCY_ENTRY_PORT]	= { .type = NLA_U32 },
+};
+
+static const struct nla_policy red_policy[TCA_REDUNDANCY_MAX + 1] = {
+	[TCA_REDUNDANCY_PARMS]		=
+		NLA_POLICY_EXACT_LEN(sizeof(struct tc_redundancy)),
+	[TCA_REDUNDANCY_MODE]		= { .type = NLA_U8 },
+	[TCA_REDUNDANCY_SPLITLIST]	= { .type = NLA_NESTED },
+};
+
+static void tcf_red_release_splitlist(struct list_head *listhead)
+{
+	struct tcf_redundancy_split_dev *entry, *e;
+
+	list_for_each_entry_safe(entry, e, listhead, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+}
+
+static int tcf_red_parse_splitlist(struct net *net, struct nlattr *list_attr,
+				   struct tcf_redundancy *red_act,
+				   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_REDUNDANCY_ENTRY_MAX + 1] = { };
+	struct tcf_redundancy_split_dev *entry;
+	struct net_device *dev;
+	struct nlattr *n;
+	int err, rem;
+	u32 ifindex;
+
+	if (!list_attr)
+		return -EINVAL;
+
+	nla_for_each_nested(n, list_attr, rem) {
+		err = nla_parse_nested(tb, TCA_REDUNDANCY_ENTRY_MAX, n,
+				       entry_policy, extack);
+		if (err < 0) {
+			NL_SET_ERR_MSG(extack, "Could not parse nested entry");
+			return -EINVAL;
+		}
+		ifindex = nla_get_u32(tb[TCA_REDUNDANCY_ENTRY_PORT]);
+		dev = dev_get_by_index(net, ifindex);
+		entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+		if (!entry) {
+			NL_SET_ERR_MSG(extack, "Not enough memory for entry");
+			tcf_red_release_splitlist(&red_act->split_list);
+			return -ENOMEM;
+		}
+		entry->dev = dev;
+		list_add_tail(&entry->list, &red_act->split_list);
+	}
+	return 0;
+}
+
+static int tcf_red_init(struct net *net, struct nlattr *nla,
+			struct nlattr *est, struct tc_action **a,
+			int ovr, int bind, bool rtnl_held,
+			struct tcf_proto *tp, u32 flags,
+			struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, redundancy_net_id);
+	struct nlattr *tb[TCA_REDUNDANCY_MAX + 1];
+	struct tcf_chain *goto_ch = NULL;
+	struct tcf_redundancy *red_act;
+	struct tc_redundancy *parm;
+	int ret = 0, err, index;
+
+	if (!nla)
+		return -EINVAL;
+
+	err = nla_parse_nested(tb, TCA_REDUNDANCY_MAX, nla, red_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_REDUNDANCY_PARMS])
+		return -EINVAL;
+
+	parm = nla_data(tb[TCA_REDUNDANCY_PARMS]);
+	index = parm->index;
+
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
+	if (err < 0)
+		return err;
+
+	if (err && bind)
+		return 0;
+
+	if (!err) {
+		ret = tcf_idr_create(tn, index, est, a,
+				     &act_redundancy_ops, bind, false, 0);
+
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
+	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
+	if (err < 0)
+		goto release_idr;
+
+	red_act = to_redundancy(*a);
+
+	spin_lock_bh(&red_act->tcf_lock);
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+
+	if (ret == ACT_P_CREATED)
+		INIT_LIST_HEAD(&red_act->split_list);
+
+	red_act->mode = nla_get_u8(tb[TCA_REDUNDANCY_MODE]);
+	if (tb[TCA_REDUNDANCY_SPLITLIST])
+		tcf_red_parse_splitlist(net, tb[TCA_REDUNDANCY_SPLITLIST],
+					red_act, extack);
+
+	red_act->gen_seq_num = 0;
+	red_act->recov_seq_num = 0;
+	red_act->sequence_history = 0xFFFFFFFF;
+	spin_unlock_bh(&red_act->tcf_lock);
+
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+
+	return ret;
+
+release_idr:
+	tcf_idr_release(*a, bind);
+	return err;
+}
+
+static int tcf_red_tag_insert(struct sk_buff *skb,
+			      struct tcf_redundancy *red_act)
+{
+	int rtag_len = sizeof(struct redundancy_tag);
+	struct rtag_vlan_ethhdr *red_vlan_hdr;
+	struct rtag_ethhdr *red_hdr;
+	struct redundancy_tag *rtag;
+	unsigned char *dst, *src;
+
+	red_vlan_hdr = (struct rtag_vlan_ethhdr *)skb_mac_header(skb);
+	if (red_vlan_hdr->h_vlan_proto == htons(ETH_P_8021Q)) {
+		rtag = &red_vlan_hdr->h_rtag;
+	} else {
+		red_hdr = (struct rtag_ethhdr *)skb_mac_header(skb);
+		rtag = &red_hdr->h_rtag;
+	}
+
+	if (rtag->proto == htons(ETH_P_RTAG))
+		return 0;
+
+	if (skb_cow_head(skb, rtag_len) < 0)
+		return -ENOMEM;
+
+	src = skb_mac_header(skb);
+	skb->data = skb_mac_header(skb);
+	skb_push(skb, rtag_len);
+
+	skb_reset_mac_header(skb);
+	dst = skb_mac_header(skb);
+	memmove(dst, src, (unsigned char *)rtag - src);
+
+	rtag--;
+	rtag->proto = htons(ETH_P_RTAG);
+	rtag->sequence = htons(red_act->gen_seq_num);
+	rtag->reserved = 0;
+
+	return 0;
+}
+
+static void tcf_red_recover_reset(u16 sequence, struct tcf_redundancy *red_act)
+{
+	red_act->sequence_history = 0xFFFFFFFF;
+	red_act->recov_seq_num = sequence;
+}
+
+static int tcf_red_recover_drop(u16 sequence,
+				struct tcf_redundancy *red_act)
+{
+	int drop = 1;
+	u32 len;
+	int i, bit;
+
+	if (sequence > (red_act->recov_seq_num + SEQ_HISTORY_LEN) ||
+	    sequence < (red_act->recov_seq_num - SEQ_HISTORY_LEN)) {
+		tcf_red_recover_reset(sequence, red_act);
+		return 0;
+	}
+
+	if (sequence > red_act->recov_seq_num) {
+		len = sequence - red_act->recov_seq_num;
+		for (i = 0; i < len; i++) {
+			bit = SEQ_HISTORY_LEN - 1 - i;
+			if (!(red_act->sequence_history & BIT(bit)))
+				red_act->tcf_qstats.drops++;
+		}
+		red_act->sequence_history <<= len;
+		red_act->sequence_history |= 1;
+		red_act->recov_seq_num = sequence;
+
+		return 0;
+	}
+
+	len = red_act->recov_seq_num - sequence;
+
+	if (red_act->sequence_history & (1 << len))
+		return drop;
+
+	red_act->sequence_history |= (1 << len);
+
+	return 0;
+}
+
+static int tcf_red_tag_remove(struct sk_buff *skb,
+			      struct tcf_redundancy *red_act)
+{
+	int rtag_len = sizeof(struct redundancy_tag);
+	struct rtag_vlan_ethhdr *red_vlan_hdr;
+	struct rtag_ethhdr *red_hdr;
+	struct redundancy_tag *rtag;
+	unsigned char *dst, *src;
+	u16 sequence;
+
+	red_vlan_hdr = (struct rtag_vlan_ethhdr *)skb_mac_header(skb);
+	if (red_vlan_hdr->h_vlan_proto == htons(ETH_P_8021Q)) {
+		rtag = &red_vlan_hdr->h_rtag;
+	} else {
+		red_hdr = (struct rtag_ethhdr *)skb_mac_header(skb);
+		rtag = &red_hdr->h_rtag;
+	}
+
+	if (rtag->proto != htons(ETH_P_RTAG))
+		return 0;
+
+	sequence = ntohs(rtag->sequence);
+
+	src = skb_mac_header(skb);
+	skb->data = skb_mac_header(skb);
+	skb_pull(skb, rtag_len);
+
+	skb_reset_mac_header(skb);
+	dst = skb_mac_header(skb);
+	memmove(dst, src, (unsigned char *)rtag - src);
+
+	return tcf_red_recover_drop(sequence, red_act);
+}
+
+static int tcf_red_act(struct sk_buff *skb, const struct tc_action *a,
+		       struct tcf_result *res)
+{
+	struct tcf_redundancy *red_act = to_redundancy(a);
+	struct tcf_redundancy_split_dev *entry;
+	struct net_device *splitdev;
+	struct sk_buff *skb2 = skb;
+	int err, ret, retval;
+
+	tcf_lastuse_update(&red_act->tcf_tm);
+	tcf_action_update_bstats(&red_act->common, skb);
+
+	retval = READ_ONCE(red_act->tcf_action);
+
+	if (red_act->mode == TCA_REDUNDANCY_RECOVER) {
+		/* Recover skb */
+		spin_lock(&red_act->tcf_lock);
+		ret = tcf_red_tag_remove(skb, red_act);
+		if (ret)
+			retval = TC_ACT_SHOT;
+
+		spin_unlock(&red_act->tcf_lock);
+		return retval;
+	}
+
+	err = tcf_red_tag_insert(skb, red_act);
+	if (err) {
+		tcf_action_inc_overlimit_qstats(&red_act->common);
+		return TC_ACT_SHOT;
+	}
+
+	list_for_each_entry(entry, &red_act->split_list, list) {
+		splitdev = entry->dev;
+		skb2 = skb_clone(skb, GFP_ATOMIC);
+		skb2->skb_iif = splitdev->ifindex;
+		skb2->dev = splitdev;
+		dev_queue_xmit(skb2);
+	}
+
+	spin_lock(&red_act->tcf_lock);
+	red_act->gen_seq_num++;
+	spin_unlock(&red_act->tcf_lock);
+
+	return retval;
+}
+
+static int dumping_entry(struct sk_buff *skb,
+			 struct tcf_redundancy_split_dev *entry)
+{
+	struct nlattr *item;
+
+	item = nla_nest_start_noflag(skb, 0);
+	if (!item)
+		return -ENOSPC;
+
+	if (nla_put_u32(skb, TCA_REDUNDANCY_ENTRY_PORT,
+			entry->dev->ifindex))
+		goto nla_put_failure;
+
+	return nla_nest_end(skb, item);
+
+nla_put_failure:
+	nla_nest_cancel(skb, item);
+	return -1;
+}
+
+static int tcf_red_dump(struct sk_buff *skb, struct tc_action *a,
+			int bind, int ref)
+{
+	unsigned char *b = skb_tail_pointer(skb);
+	struct tcf_redundancy_split_dev *entry;
+	struct tcf_redundancy *red_act = to_redundancy(a);
+	struct tc_redundancy opt = {
+		.index	= red_act->tcf_index,
+		.refcnt	= refcount_read(&red_act->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&red_act->tcf_bindcnt) - bind,
+	};
+	struct tcf_t t;
+	struct nlattr *entry_list;
+
+	spin_lock_bh(&red_act->tcf_lock);
+	opt.action = red_act->tcf_action;
+
+	if (nla_put(skb, TCA_REDUNDANCY_PARMS, sizeof(opt), &opt))
+		goto nla_put_failure;
+
+	if (nla_put_u8(skb, TCA_REDUNDANCY_MODE, red_act->mode))
+		goto nla_put_failure;
+
+	entry_list = nla_nest_start_noflag(skb, TCA_REDUNDANCY_SPLITLIST);
+	if (!entry_list)
+		goto nla_put_failure;
+
+	list_for_each_entry(entry, &red_act->split_list, list) {
+		if (dumping_entry(skb, entry) < 0)
+			goto nla_put_failure;
+	}
+	nla_nest_end(skb, entry_list);
+
+	tcf_tm_dump(&t, &red_act->tcf_tm);
+	if (nla_put_64bit(skb, TCA_REDUNDANCY_TM, sizeof(t),
+			  &t, TCA_REDUNDANCY_PAD))
+		goto nla_put_failure;
+	spin_unlock_bh(&red_act->tcf_lock);
+
+	return skb->len;
+
+nla_put_failure:
+	spin_unlock_bh(&red_act->tcf_lock);
+	nlmsg_trim(skb, b);
+
+	return -1;
+}
+
+static int tcf_red_walker(struct net *net, struct sk_buff *skb,
+			  struct netlink_callback *cb, int type,
+			  const struct tc_action_ops *ops,
+			  struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, redundancy_net_id);
+
+	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
+}
+
+static int tcf_red_search(struct net *net, struct tc_action **a, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, redundancy_net_id);
+
+	return tcf_idr_search(tn, a, index);
+}
+
+static void tcf_red_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+				 u64 drops, u64 lastuse, bool hw)
+{
+	struct tcf_redundancy *red_act = to_redundancy(a);
+	struct tcf_t *tm = &red_act->tcf_tm;
+
+	tcf_action_update_stats(a, bytes, packets, drops, hw);
+	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
+}
+
+static void tcf_red_cleanup(struct tc_action *a)
+{
+	struct tcf_redundancy *red_act = to_redundancy(a);
+
+	tcf_red_release_splitlist(&red_act->split_list);
+}
+
+static size_t tcf_red_get_fill_size(const struct tc_action *act)
+{
+	return nla_total_size(sizeof(struct tc_redundancy));
+}
+
+static struct tc_action_ops act_redundancy_ops = {
+	.kind		=	"redundancy",
+	.id		=	TCA_ID_REDUNDANCY,
+	.owner		=	THIS_MODULE,
+	.act		=	tcf_red_act,
+	.init		=	tcf_red_init,
+	.cleanup	=	tcf_red_cleanup,
+	.dump		=	tcf_red_dump,
+	.walk		=	tcf_red_walker,
+	.stats_update	=	tcf_red_stats_update,
+	.get_fill_size	=	tcf_red_get_fill_size,
+	.lookup		=	tcf_red_search,
+	.size		=	sizeof(struct tcf_redundancy),
+};
+
+static __net_init int redundancy_init_net(struct net *net)
+{
+	struct tc_action_net *tn = net_generic(net, redundancy_net_id);
+
+	return tc_action_net_init(net, tn, &act_redundancy_ops);
+}
+
+static void __net_exit redundancy_exit_net(struct list_head *net_list)
+{
+	tc_action_net_exit(net_list, redundancy_net_id);
+};
+
+static struct pernet_operations redundancy_net_ops = {
+	.init = redundancy_init_net,
+	.exit_batch = redundancy_exit_net,
+	.id   = &redundancy_net_id,
+	.size = sizeof(struct tc_action_net),
+};
+
+static int __init redundancy_init_module(void)
+{
+	return tcf_register_action(&act_redundancy_ops, &redundancy_net_ops);
+}
+
+static void __exit redundancy_cleanup_module(void)
+{
+	tcf_unregister_action(&act_redundancy_ops, &redundancy_net_ops);
+}
+
+module_init(redundancy_init_module);
+module_exit(redundancy_cleanup_module);
+MODULE_LICENSE("GPL v2");
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ba0715ee9eac..68ae5ffe07a0 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -39,6 +39,7 @@
 #include <net/tc_act/tc_ct.h>
 #include <net/tc_act/tc_mpls.h>
 #include <net/tc_act/tc_gate.h>
+#include <net/tc_act/tc_redundancy.h>
 #include <net/flow_offload.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
@@ -3534,6 +3535,30 @@ static int tcf_gate_get_entries(struct flow_action_entry *entry,
 	return 0;
 }
 
+static void tcf_redundancy_devlist_destructor(void *priv)
+{
+	struct netdevice **devices = priv;
+
+	kfree(devices);
+}
+
+static int tcf_redundancy_get_splitdevs(struct flow_action_entry *entry,
+					const struct tc_action *act)
+{
+	u32 len;
+
+	entry->redundancy.split_devs = tcf_redundancy_create_dev_array(act, &len);
+	if (!entry->redundancy.split_devs)
+		return -EINVAL;
+
+	entry->redundancy.split_num = len;
+
+	entry->destructor = tcf_redundancy_devlist_destructor;
+	entry->destructor_priv = entry->redundancy.split_devs;
+
+	return 0;
+}
+
 static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 {
 	if (WARN_ON_ONCE(hw_stats > TCA_ACT_HW_STATS_ANY))
@@ -3703,6 +3728,12 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			err = tcf_gate_get_entries(entry, act);
 			if (err)
 				goto err_out_locked;
+		} else if (is_tcf_redundancy(act)) {
+			entry->id = FLOW_ACTION_REDUNDANCY;
+			entry->redundancy.mode = tcf_redundancy_mode(act);
+			err = tcf_redundancy_get_splitdevs(entry, act);
+			if (err)
+				goto err_out;
 		} else {
 			err = -EOPNOTSUPP;
 			goto err_out_locked;
-- 
2.17.1

