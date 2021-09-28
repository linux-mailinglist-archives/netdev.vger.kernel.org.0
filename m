Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1636041ADEB
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbhI1Lgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:36:54 -0400
Received: from inva021.nxp.com ([92.121.34.21]:37198 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240302AbhI1Lgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 07:36:53 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BD10A202805;
        Tue, 28 Sep 2021 13:35:11 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0894A2027EE;
        Tue, 28 Sep 2021 13:35:10 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id DEC57183AC89;
        Tue, 28 Sep 2021 19:35:06 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Arvid.Brodin@xdin.com, m-karicheri2@ti.com,
        vinicius.gomes@intel.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, alexandre.belloni@bootlin.com,
        ivan.khoronzhuk@linaro.org, andre.guedes@linux.intel.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        vladimir.oltean@nxp.com, xiaoliang.yang_1@nxp.com, jhs@mojatatu.com
Subject: [RFC, net-next] net: qos: introduce a frer action to implement 802.1CB
Date:   Tue, 28 Sep 2021 19:44:51 +0800
Message-Id: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduce a frer action to implement frame replication and
elimination for reliability, which is defined in IEEE P802.1CB.

There are two modes for frer action: generate and push the tag, recover
and pop the tag. frer tag has three types: RTAG, HSR, and PRP. This
patch only supports RTAG now.

User can push the tag on egress port of the talker device, recover and
pop the tag on ingress port of the listener device. When it's a relay
system, push the tag on ingress port, or set individual recover on
ingress port. Set the sequence recover on egress port.

Use action "mirred" to do split function, and use "vlan-modify" to do
active stream identification function on relay system.

Below is the setting example in user space:
push rtag on relay system:
	> tc qdisc add dev swp0 clsact
	> tc filter add dev swp0 ingress protocol 802.1Q flower \
		skip_hw dst_mac 00:01:02:03:04:05 vlan_id 1 \
		action frer rtag tag-action tag-push

split stream:
	> tc filter add dev swp0 ingress protocol 802.1Q flower \
		skip_hw dst_mac 00:01:02:03:04:05 vlan_id 1 \
		action mirred egress mirror dev swp1

individual recover:
	> tc filter add dev swp0 ingress protocol 802.1Q flower
		skip_hw dst_mac 00:01:02:03:04:06 vlan_id 1 \
		action frer rtag recover \
		alg vector history-length 32 reset-time 10000

recover and pop rtag:
	> tc filter add dev swp0 egress protocol 802.1Q flower
		skip_hw dst_mac 00:01:02:03:04:06 vlan_id 1 \
		action frer rtag recover \
		alg vector history-length 32 reset-time 10000 \
		tag-action tag-pop

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 include/net/flow_offload.h          |   9 +
 include/net/tc_act/tc_frer.h        |  52 +++
 include/uapi/linux/if_ether.h       |   1 +
 include/uapi/linux/pkt_cls.h        |   1 +
 include/uapi/linux/tc_act/tc_frer.h |  50 ++
 net/sched/Kconfig                   |  13 +
 net/sched/Makefile                  |   1 +
 net/sched/act_frer.c                | 695 ++++++++++++++++++++++++++++
 net/sched/cls_api.c                 |  11 +
 9 files changed, 833 insertions(+)
 create mode 100644 include/net/tc_act/tc_frer.h
 create mode 100644 include/uapi/linux/tc_act/tc_frer.h
 create mode 100644 net/sched/act_frer.c

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3961461d9c8b..cfa9b69cec69 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -148,6 +148,7 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_MANGLE,
 	FLOW_ACTION_GATE,
 	FLOW_ACTION_PPPOE_PUSH,
+	FLOW_ACTION_FRER,
 	NUM_FLOW_ACTIONS,
 };
 
@@ -278,6 +279,14 @@ struct flow_action_entry {
 		struct {				/* FLOW_ACTION_PPPOE_PUSH */
 			u16		sid;
 		} pppoe;
+		struct {
+			u8		tag_type;
+			u8		tag_action;
+			u8		recover;
+			u8		rcvy_alg;
+			u8		rcvy_history_len;
+			u8		rcvy_reset_msec;
+		} frer;
 	};
 	struct flow_action_cookie *cookie; /* user defined action cookie */
 };
diff --git a/include/net/tc_act/tc_frer.h b/include/net/tc_act/tc_frer.h
new file mode 100644
index 000000000000..b2ad2b2a3fe1
--- /dev/null
+++ b/include/net/tc_act/tc_frer.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright 2021 NXP */
+
+#ifndef __NET_TC_FRER_H
+#define __NET_TC_FRER_H
+
+#include <net/act_api.h>
+#include <linux/tc_act/tc_frer.h>
+
+struct tcf_frer;
+
+struct tcf_frer_proto_ops {
+	int (*encode)(struct sk_buff *skb, struct tcf_frer *frer_act);
+	int (*decode)(struct sk_buff *skb);
+	void (*tag_pop)(struct sk_buff *skb, struct tcf_frer *frer_act);
+};
+
+struct tcf_frer {
+	struct tc_action		common;
+	u8				tag_type;
+	u8				tag_action;
+	u8				recover;
+	u8				rcvy_alg;
+	u8				rcvy_history_len;
+	u64				rcvy_reset_msec;
+	u32				gen_seq_num;
+	u32				rcvy_seq_num;
+	u64				seq_space;
+	u32				seq_history;
+	bool				take_any;
+	bool				rcvy_take_noseq;
+	u32				cps_seq_rcvy_lost_pkts;
+	u32				cps_seq_rcvy_tagless_pkts;
+	u32				cps_seq_rcvy_out_of_order_pkts;
+	u32				cps_seq_rcvy_rogue_pkts;
+	u32				cps_seq_rcvy_resets;
+	struct hrtimer			hrtimer;
+	const struct tcf_frer_proto_ops	*proto_ops;
+};
+
+#define to_frer(a) ((struct tcf_frer *)a)
+
+static inline bool is_tcf_frer(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (a->ops && a->ops->id == TCA_ID_FRER)
+		return true;
+#endif
+	return false;
+}
+
+#endif
diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index 5f589c7a8382..812aa75f7f23 100644
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
index 6836ccb9c45d..a3fc0c478a65 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -136,6 +136,7 @@ enum tca_id {
 	TCA_ID_MPLS,
 	TCA_ID_CT,
 	TCA_ID_GATE,
+	TCA_ID_FRER,
 	/* other actions go here */
 	__TCA_ID_MAX = 255
 };
diff --git a/include/uapi/linux/tc_act/tc_frer.h b/include/uapi/linux/tc_act/tc_frer.h
new file mode 100644
index 000000000000..cd86274483e7
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_frer.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/* Copyright 2021 NXP */
+
+#ifndef __LINUX_TC_FRER_H
+#define __LINUX_TC_FRER_H
+
+#include <linux/pkt_cls.h>
+
+struct tc_frer {
+	tc_gen;
+};
+
+enum {
+	TCA_FRER_UNSPEC,
+	TCA_FRER_TM,
+	TCA_FRER_PARMS,
+	TCA_FRER_PAD,
+	TCA_FRER_TAG_TYPE,
+	TCA_FRER_TAG_ACTION,
+	TCA_FRER_RECOVER,
+	TCA_FRER_RECOVER_ALG,
+	TCA_FRER_RECOVER_HISTORY_LEN,
+	TCA_FRER_RECOVER_RESET_TM,
+	TCA_FRER_RECOVER_TAGLESS_PKTS,
+	TCA_FRER_RECOVER_OUT_OF_ORDER_PKTS,
+	TCA_FRER_RECOVER_ROGUE_PKTS,
+	TCA_FRER_RECOVER_LOST_PKTS,
+	TCA_FRER_RECOVER_RESETS,
+	__TCA_FRER_MAX,
+};
+#define TCA_FRER_MAX (__TCA_FRER_MAX - 1)
+
+enum tc_frer_tag_action {
+	TCA_FRER_TAG_NULL,
+	TCA_FRER_TAG_PUSH,
+	TCA_FRER_TAG_POP,
+};
+
+enum tc_frer_tag_type {
+	TCA_FRER_TAG_RTAG,
+	TCA_FRER_TAG_HSR,
+	TCA_FRER_TAG_PRP,
+};
+
+enum tc_frer_rcvy_alg {
+	TCA_FRER_RCVY_VECTOR_ALG,
+	TCA_FRER_RCVY_MATCH_ALG,
+};
+
+#endif
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 1e8ab4749c6c..93e2687042c2 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -997,6 +997,19 @@ config NET_ACT_GATE
 	  To compile this code as a module, choose M here: the
 	  module will be called act_gate.
 
+config NET_ACT_FRER
+	tristate "Frame frer tc action"
+	depends on NET_CLS_ACT
+	help
+	  Say Y here to support frame replication and elimination for
+	  reliability, which is defined by IEEE 802.1CB.
+	  This action allow to add a frer tag. It also allow to remove
+	  the frer tag and drop repeat frames.
+
+	  If unsure, say N.
+	  To compile this code as a module, choose M here: the
+	  module will be called act_frer.
+
 config NET_IFE_SKBMARK
 	tristate "Support to encoding decoding skb mark on IFE action"
 	depends on NET_ACT_IFE
diff --git a/net/sched/Makefile b/net/sched/Makefile
index dd14ef413fda..69e7e94be567 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_NET_IFE_SKBTCINDEX)	+= act_meta_skbtcindex.o
 obj-$(CONFIG_NET_ACT_TUNNEL_KEY)+= act_tunnel_key.o
 obj-$(CONFIG_NET_ACT_CT)	+= act_ct.o
 obj-$(CONFIG_NET_ACT_GATE)	+= act_gate.o
+obj-$(CONFIG_NET_ACT_FRER)	+= act_frer.o
 obj-$(CONFIG_NET_SCH_FIFO)	+= sch_fifo.o
 obj-$(CONFIG_NET_SCH_CBQ)	+= sch_cbq.o
 obj-$(CONFIG_NET_SCH_HTB)	+= sch_htb.o
diff --git a/net/sched/act_frer.c b/net/sched/act_frer.c
new file mode 100644
index 000000000000..6f8ec5782d3d
--- /dev/null
+++ b/net/sched/act_frer.c
@@ -0,0 +1,695 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright 2021 NXP */
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
+#include <net/tc_act/tc_frer.h>
+
+#define FRER_SEQ_SPACE		16
+#define FRER_RCVY_RESET_MSEC	100
+#define FRER_RCVY_INVALID_SEQ	0x100
+#define FRER_RCVY_PASSED	0
+#define FRER_RCVY_DISCARDED	-1
+
+static unsigned int frer_net_id;
+static struct tc_action_ops act_frer_ops;
+
+struct r_tag {
+	__be16 reserved;
+	__be16 sequence_nr;
+	__be16 encap_proto;
+} __packed;
+
+struct rtag_ethhdr {
+	struct ethhdr		ethhdr;
+	struct r_tag		h_rtag;
+} __packed;
+
+struct rtag_vlan_ethhdr {
+	struct vlan_ethhdr	vlanhdr;
+	struct r_tag		h_rtag;
+} __packed;
+
+static const struct nla_policy frer_policy[TCA_FRER_MAX + 1] = {
+	[TCA_FRER_PARMS]		=
+		NLA_POLICY_EXACT_LEN(sizeof(struct tc_frer)),
+	[TCA_FRER_TAG_TYPE]		= { .type = NLA_U8 },
+	[TCA_FRER_TAG_ACTION]		= { .type = NLA_U8 },
+	[TCA_FRER_RECOVER]		= { .type = NLA_U8 },
+	[TCA_FRER_RECOVER_ALG]		= { .type = NLA_U8 },
+	[TCA_FRER_RECOVER_HISTORY_LEN]	= { .type = NLA_U8 },
+	[TCA_FRER_RECOVER_RESET_TM]	= { .type = NLA_U64 },
+};
+
+static void frer_seq_recovery_reset(struct tcf_frer *frer_act);
+
+static enum hrtimer_restart frer_hrtimer_func(struct hrtimer *timer)
+{
+	struct tcf_frer *frer_act = container_of(timer, struct tcf_frer,
+						 hrtimer);
+	ktime_t remaining_tm;
+
+	frer_seq_recovery_reset(frer_act);
+
+	remaining_tm = (ktime_t)(frer_act->rcvy_reset_msec * 1000000);
+
+	hrtimer_forward(timer, timer->base->get_time(), remaining_tm);
+
+	return HRTIMER_RESTART;
+}
+
+static int frer_rtag_decode(struct sk_buff *skb)
+{
+	struct rtag_vlan_ethhdr *rtag_vlan_hdr;
+	struct rtag_ethhdr *rtag_hdr;
+	struct vlan_ethhdr *vlanhdr;
+	struct ethhdr *ethhdr;
+	struct r_tag *rtag;
+	bool is_vlan;
+	u16 sequence;
+	u16 proto;
+
+	ethhdr = (struct ethhdr *)skb_mac_header(skb);
+	proto = ethhdr->h_proto;
+	is_vlan = false;
+
+	if (proto == htons(ETH_P_8021Q)) {
+		vlanhdr = (struct vlan_ethhdr *)ethhdr;
+		proto = vlanhdr->h_vlan_encapsulated_proto;
+		is_vlan = true;
+	}
+
+	if (proto != htons(ETH_P_RTAG))
+		return FRER_RCVY_INVALID_SEQ;
+
+	if (is_vlan) {
+		rtag_vlan_hdr = (struct rtag_vlan_ethhdr *)ethhdr;
+		rtag = &rtag_vlan_hdr->h_rtag;
+	} else {
+		rtag_hdr = (struct rtag_ethhdr *)ethhdr;
+		rtag = &rtag_hdr->h_rtag;
+	}
+
+	sequence = ntohs(rtag->sequence_nr);
+
+	return sequence;
+}
+
+static int frer_seq_generation_alg(struct tcf_frer *frer_act)
+{
+	u32 gen_seq_max = frer_act->seq_space - 1;
+	u32 gen_seq_num = frer_act->gen_seq_num;
+	int sequence_number;
+
+	sequence_number = gen_seq_num;
+
+	if (gen_seq_num >= gen_seq_max)
+		gen_seq_num = 0;
+	else
+		gen_seq_num++;
+
+	frer_act->gen_seq_num = gen_seq_num;
+
+	return sequence_number;
+}
+
+static int frer_rtag_encode(struct sk_buff *skb, struct tcf_frer *frer_act)
+{
+	struct vlan_ethhdr *vlanhdr;
+	struct ethhdr *ethhdr;
+	struct r_tag *rtag;
+	int rtag_len, head_len;
+	unsigned char *dst, *src, *p;
+	__be16 *proto, proto_val;
+
+	ethhdr = (struct ethhdr *)skb_mac_header(skb);
+	if (ethhdr->h_proto == htons(ETH_P_8021Q)) {
+		vlanhdr = (struct vlan_ethhdr *)ethhdr;
+		p = (unsigned char *)(vlanhdr + 1);
+		proto = &vlanhdr->h_vlan_encapsulated_proto;
+	} else {
+		p = (unsigned char *)(ethhdr + 1);
+		proto = &ethhdr->h_proto;
+	}
+
+	proto_val = *proto;
+	*proto = htons(ETH_P_RTAG);
+
+	src = skb_mac_header(skb);
+	head_len = p - src;
+
+	rtag_len = sizeof(struct r_tag);
+	if (skb_cow_head(skb, rtag_len) < 0)
+		return -ENOMEM;
+
+	skb_push(skb, rtag_len);
+	skb->mac_header -= rtag_len;
+
+	dst = skb_mac_header(skb);
+	memmove(dst, src, head_len);
+
+	rtag = (struct r_tag *)(dst + head_len);
+	rtag->encap_proto = proto_val;
+	rtag->sequence_nr = htons(frer_act->gen_seq_num);
+	rtag->reserved = 0;
+
+	return 0;
+}
+
+static void frer_rtag_pop(struct sk_buff *skb, struct tcf_frer *frer_act)
+{
+	struct vlan_ethhdr *vlanhdr;
+	struct ethhdr *ethhdr;
+	struct r_tag *rtag;
+	int rtag_len, head_len;
+	unsigned char *dst, *src, *p;
+	__be16 *proto;
+
+	ethhdr = (struct ethhdr *)skb_mac_header(skb);
+
+	if (ethhdr->h_proto == htons(ETH_P_8021Q)) {
+		vlanhdr = (struct vlan_ethhdr *)ethhdr;
+		p = (unsigned char *)(vlanhdr + 1);
+		proto = &vlanhdr->h_vlan_encapsulated_proto;
+	} else {
+		p = (unsigned char *)(ethhdr + 1);
+		proto = &ethhdr->h_proto;
+	}
+
+	if (*proto != htons(ETH_P_RTAG))
+		return;
+
+	rtag = (struct r_tag *)p;
+	rtag_len = sizeof(struct r_tag);
+	*proto = rtag->encap_proto;
+
+	src = skb_mac_header(skb);
+	head_len = p - src;
+
+	skb->data = skb_mac_header(skb);
+	skb_pull(skb, rtag_len);
+
+	skb_reset_mac_header(skb);
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL)
+		skb->csum_start += rtag_len;
+
+	dst = skb_mac_header(skb);
+	memmove(dst, src, head_len);
+}
+
+static const struct tcf_frer_proto_ops rtag_ops = {
+	.encode = frer_rtag_encode,
+	.decode = frer_rtag_decode,
+	.tag_pop = frer_rtag_pop,
+};
+
+static int tcf_frer_init(struct net *net, struct nlattr *nla,
+			 struct nlattr *est, struct tc_action **a,
+			 int ovr, int bind, bool rtnl_held,
+			 struct tcf_proto *tp, u32 flags,
+			 struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, frer_net_id);
+	struct nlattr *tb[TCA_FRER_MAX + 1];
+	struct tcf_chain *goto_ch = NULL;
+	struct tcf_frer *frer_act;
+	struct tc_frer *parm;
+	int ret = 0, err, index;
+	ktime_t remaining_tm;
+
+	if (!nla)
+		return -EINVAL;
+
+	err = nla_parse_nested(tb, TCA_FRER_MAX, nla, frer_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_FRER_PARMS])
+		return -EINVAL;
+
+	parm = nla_data(tb[TCA_FRER_PARMS]);
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
+				     &act_frer_ops, bind, false, 0);
+
+		if (ret) {
+			tcf_idr_cleanup(tn, index);
+			return ret;
+		}
+	} else if (!ovr) {
+		tcf_idr_release(*a, bind);
+		return -EEXIST;
+	}
+
+	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
+	if (err < 0)
+		goto release_idr;
+
+	frer_act = to_frer(*a);
+
+	spin_lock_bh(&frer_act->tcf_lock);
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+
+	frer_act->tag_type = nla_get_u8(tb[TCA_FRER_TAG_TYPE]);
+	frer_act->tag_action = nla_get_u8(tb[TCA_FRER_TAG_ACTION]);
+	frer_act->recover = nla_get_u8(tb[TCA_FRER_RECOVER]);
+	frer_act->rcvy_alg = nla_get_u8(tb[TCA_FRER_RECOVER_ALG]);
+	frer_act->rcvy_history_len = nla_get_u8(tb[TCA_FRER_RECOVER_HISTORY_LEN]);
+	frer_act->rcvy_reset_msec = nla_get_u64(tb[TCA_FRER_RECOVER_RESET_TM]);
+
+	frer_act->gen_seq_num = 0;
+	frer_act->seq_space = 1 << FRER_SEQ_SPACE;
+	frer_act->rcvy_seq_num = 0;
+	frer_act->seq_history = 0xFFFFFFFF;
+	frer_act->rcvy_take_noseq = true;
+
+	switch (frer_act->tag_type) {
+	case TCA_FRER_TAG_RTAG:
+		frer_act->proto_ops = &rtag_ops;
+		break;
+	case TCA_FRER_TAG_HSR:
+	case TCA_FRER_TAG_PRP:
+	default:
+		spin_unlock_bh(&frer_act->tcf_lock);
+		return -EOPNOTSUPP;
+	}
+
+	if (frer_act->recover && frer_act->rcvy_reset_msec) {
+		hrtimer_init(&frer_act->hrtimer, CLOCK_TAI,
+			     HRTIMER_MODE_REL_SOFT);
+		frer_act->hrtimer.function = frer_hrtimer_func;
+
+		remaining_tm = (ktime_t)(frer_act->rcvy_reset_msec * 1000000);
+		hrtimer_start(&frer_act->hrtimer, remaining_tm,
+			      HRTIMER_MODE_REL_SOFT);
+	}
+
+	spin_unlock_bh(&frer_act->tcf_lock);
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
+static void frer_seq_recovery_reset(struct tcf_frer *frer_act)
+{
+	spin_lock(&frer_act->tcf_lock);
+	if (frer_act->rcvy_alg == TCA_FRER_RCVY_VECTOR_ALG) {
+		frer_act->rcvy_seq_num = frer_act->seq_space - 1;
+		frer_act->seq_history = 0;
+	}
+	frer_act->cps_seq_rcvy_resets++;
+	frer_act->take_any = true;
+	spin_unlock(&frer_act->tcf_lock);
+}
+
+static void frer_shift_seq_history(int value, struct tcf_frer *frer_act)
+{
+	int history_len = frer_act->rcvy_history_len;
+
+	if ((frer_act->seq_history & BIT(history_len - 1)) == 0)
+		frer_act->cps_seq_rcvy_lost_pkts++;
+
+	frer_act->seq_history <<= 1;
+
+	if (value)
+		frer_act->seq_history |= BIT(0);
+}
+
+static int frer_vector_rcvy_alg(struct tcf_frer *frer_act, int sequence,
+				bool individual)
+{
+	struct hrtimer *timer = &frer_act->hrtimer;
+	bool reset_timer = false;
+	ktime_t remaining_tm;
+	int delta, ret;
+
+	if (sequence == FRER_RCVY_INVALID_SEQ) {
+		frer_act->cps_seq_rcvy_tagless_pkts++;
+		if (frer_act->rcvy_take_noseq) {
+			reset_timer = true;
+			ret = FRER_RCVY_PASSED;
+			goto out;
+		} else {
+			return FRER_RCVY_DISCARDED;
+		}
+	}
+
+	delta = (sequence - frer_act->rcvy_seq_num) & (frer_act->seq_space - 1);
+	/* -(RecovSeqSpace/2) <= delta <= ((RecovSeqSpace/2)-1) */
+	if (delta & (frer_act->seq_space / 2))
+		delta -= frer_act->seq_space;
+
+	if (frer_act->take_any) {
+		frer_act->take_any = false;
+		frer_act->seq_history |= BIT(0);
+		frer_act->rcvy_seq_num = sequence;
+
+		reset_timer = true;
+		ret = FRER_RCVY_PASSED;
+		goto out;
+	}
+
+	if (delta >= frer_act->rcvy_history_len ||
+	    delta <= -frer_act->rcvy_history_len) {
+		/* Packet is out-of-range. */
+		frer_act->cps_seq_rcvy_rogue_pkts++;
+
+		if (individual)
+			reset_timer = true;
+
+		ret = FRER_RCVY_DISCARDED;
+		goto out;
+	} else if (delta <= 0) {
+		/* Packet is old and in SequenceHistory. */
+		if (frer_act->seq_history & BIT(-delta)) {
+			if (individual)
+				reset_timer = true;
+
+			/* Packet has been seen. */
+			ret = FRER_RCVY_DISCARDED;
+			goto out;
+		} else {
+			/* Packet has not been seen. */
+			frer_act->seq_history |= BIT(-delta);
+			frer_act->cps_seq_rcvy_out_of_order_pkts++;
+
+			reset_timer = true;
+			ret = FRER_RCVY_PASSED;
+			goto out;
+		}
+	} else {
+		/* Packet is not too far ahead of the one we want. */
+		if (delta != 1)
+			frer_act->cps_seq_rcvy_out_of_order_pkts++;
+
+		while (--delta)
+			frer_shift_seq_history(0, frer_act);
+		frer_shift_seq_history(1, frer_act);
+		frer_act->rcvy_seq_num = sequence;
+
+		reset_timer = true;
+		ret = FRER_RCVY_PASSED;
+		goto out;
+	}
+out:
+	if (reset_timer && frer_act->rcvy_reset_msec) {
+		remaining_tm =
+			(ktime_t)(frer_act->rcvy_reset_msec * 1000000);
+		hrtimer_start(timer, remaining_tm, HRTIMER_MODE_REL_SOFT);
+	}
+
+	return ret;
+}
+
+static int frer_match_rcvy_alg(struct tcf_frer *frer_act, int sequence,
+			       bool individual)
+{
+	struct hrtimer *timer = &frer_act->hrtimer;
+	bool reset_timer = false;
+	ktime_t remaining_tm;
+	int delta, ret;
+
+	if (sequence == FRER_RCVY_INVALID_SEQ) {
+		frer_act->cps_seq_rcvy_tagless_pkts++;
+
+		return FRER_RCVY_PASSED;
+	}
+
+	if (frer_act->take_any) {
+		frer_act->take_any = false;
+		frer_act->rcvy_seq_num = sequence;
+
+		reset_timer = true;
+		ret = FRER_RCVY_PASSED;
+		goto out;
+	}
+
+	delta = sequence - frer_act->rcvy_seq_num;
+	if (delta) {
+		/* Packet has not been seen, accept it. */
+		if (delta != 1)
+			frer_act->cps_seq_rcvy_out_of_order_pkts++;
+
+		frer_act->rcvy_seq_num = sequence;
+
+		reset_timer = true;
+		ret = FRER_RCVY_PASSED;
+		goto out;
+	} else {
+		if (individual)
+			reset_timer = true;
+
+		/* Packet has been seen. Do not forward. */
+		ret = FRER_RCVY_DISCARDED;
+		goto out;
+	}
+
+out:
+	if (reset_timer && frer_act->rcvy_reset_msec) {
+		remaining_tm = (ktime_t)(frer_act->rcvy_reset_msec * 1000000);
+		hrtimer_start(timer, remaining_tm, HRTIMER_MODE_REL_SOFT);
+	}
+
+	return ret;
+}
+
+static int tcf_frer_act(struct sk_buff *skb, const struct tc_action *a,
+			struct tcf_result *res)
+{
+	struct tcf_frer *frer_act = to_frer(a);
+	bool ingress, individual;
+	int ret, retval;
+	int sequence;
+
+	tcf_lastuse_update(&frer_act->tcf_tm);
+	tcf_action_update_bstats(&frer_act->common, skb);
+
+	retval = READ_ONCE(frer_act->tcf_action);
+
+	sequence = frer_act->proto_ops->decode(skb);
+
+	ingress = skb_at_tc_ingress(skb);
+	individual = ingress;
+
+	if (frer_act->recover) {
+		spin_lock(&frer_act->tcf_lock);
+
+		if (frer_act->rcvy_alg == TCA_FRER_RCVY_VECTOR_ALG)
+			ret = frer_vector_rcvy_alg(frer_act, sequence,
+						   individual);
+		else
+			ret = frer_match_rcvy_alg(frer_act, sequence,
+						  individual);
+		if (ret) {
+			frer_act->tcf_qstats.drops++;
+			retval = TC_ACT_SHOT;
+		}
+
+		if (frer_act->tag_action == TCA_FRER_TAG_POP)
+			frer_act->proto_ops->tag_pop(skb, frer_act);
+
+		spin_unlock(&frer_act->tcf_lock);
+
+		return retval;
+	}
+
+	if (frer_act->tag_action == TCA_FRER_TAG_PUSH &&
+	    sequence == FRER_RCVY_INVALID_SEQ) {
+		spin_lock(&frer_act->tcf_lock);
+
+		frer_seq_generation_alg(frer_act);
+
+		frer_act->proto_ops->encode(skb, frer_act);
+
+		spin_unlock(&frer_act->tcf_lock);
+	}
+
+	return retval;
+}
+
+static int tcf_frer_dump(struct sk_buff *skb, struct tc_action *a,
+			 int bind, int ref)
+{
+	unsigned char *b = skb_tail_pointer(skb);
+	struct tcf_frer *frer_act = to_frer(a);
+	struct tc_frer opt = {
+		.index	= frer_act->tcf_index,
+		.refcnt	= refcount_read(&frer_act->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&frer_act->tcf_bindcnt) - bind,
+	};
+	struct tcf_t t;
+
+	spin_lock_bh(&frer_act->tcf_lock);
+	opt.action = frer_act->tcf_action;
+
+	if (nla_put(skb, TCA_FRER_PARMS, sizeof(opt), &opt))
+		goto nla_put_failure;
+
+	if (nla_put_u8(skb, TCA_FRER_TAG_TYPE, frer_act->tag_type))
+		goto nla_put_failure;
+
+	if (nla_put_u8(skb, TCA_FRER_TAG_ACTION, frer_act->tag_action))
+		goto nla_put_failure;
+
+	if (nla_put_u8(skb, TCA_FRER_RECOVER, frer_act->recover))
+		goto nla_put_failure;
+
+	if (nla_put_u8(skb, TCA_FRER_RECOVER_ALG, frer_act->rcvy_alg))
+		goto nla_put_failure;
+
+	if (nla_put_u8(skb, TCA_FRER_RECOVER_HISTORY_LEN,
+		       frer_act->rcvy_history_len))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(skb, TCA_FRER_RECOVER_RESET_TM,
+			      frer_act->rcvy_reset_msec, TCA_FRER_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, TCA_FRER_RECOVER_TAGLESS_PKTS,
+			frer_act->cps_seq_rcvy_tagless_pkts))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, TCA_FRER_RECOVER_OUT_OF_ORDER_PKTS,
+			frer_act->cps_seq_rcvy_out_of_order_pkts))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, TCA_FRER_RECOVER_ROGUE_PKTS,
+			frer_act->cps_seq_rcvy_rogue_pkts))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, TCA_FRER_RECOVER_LOST_PKTS,
+			frer_act->cps_seq_rcvy_lost_pkts))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, TCA_FRER_RECOVER_RESETS,
+			frer_act->cps_seq_rcvy_resets))
+		goto nla_put_failure;
+
+	tcf_tm_dump(&t, &frer_act->tcf_tm);
+	if (nla_put_64bit(skb, TCA_FRER_TM, sizeof(t),
+			  &t, TCA_FRER_PAD))
+		goto nla_put_failure;
+	spin_unlock_bh(&frer_act->tcf_lock);
+
+	return skb->len;
+
+nla_put_failure:
+	spin_unlock_bh(&frer_act->tcf_lock);
+	nlmsg_trim(skb, b);
+
+	return -1;
+}
+
+static int tcf_frer_walker(struct net *net, struct sk_buff *skb,
+			   struct netlink_callback *cb, int type,
+			   const struct tc_action_ops *ops,
+			   struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, frer_net_id);
+
+	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
+}
+
+static int tcf_frer_search(struct net *net, struct tc_action **a, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, frer_net_id);
+
+	return tcf_idr_search(tn, a, index);
+}
+
+static void tcf_frer_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+				  u64 drops, u64 lastuse, bool hw)
+{
+	struct tcf_frer *frer_act = to_frer(a);
+	struct tcf_t *tm = &frer_act->tcf_tm;
+
+	tcf_action_update_stats(a, bytes, packets, drops, hw);
+	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
+}
+
+static void tcf_frer_cleanup(struct tc_action *a)
+{
+	struct tcf_frer *frer_act = to_frer(a);
+
+	if (frer_act->rcvy_reset_msec)
+		hrtimer_cancel(&frer_act->hrtimer);
+}
+
+static size_t tcf_frer_get_fill_size(const struct tc_action *act)
+{
+	return nla_total_size(sizeof(struct tc_frer));
+}
+
+static struct tc_action_ops act_frer_ops = {
+	.kind		=	"frer",
+	.id		=	TCA_ID_FRER,
+	.owner		=	THIS_MODULE,
+	.act		=	tcf_frer_act,
+	.init		=	tcf_frer_init,
+	.cleanup	=	tcf_frer_cleanup,
+	.dump		=	tcf_frer_dump,
+	.walk		=	tcf_frer_walker,
+	.stats_update	=	tcf_frer_stats_update,
+	.get_fill_size	=	tcf_frer_get_fill_size,
+	.lookup		=	tcf_frer_search,
+	.size		=	sizeof(struct tcf_frer),
+};
+
+static __net_init int frer_init_net(struct net *net)
+{
+	struct tc_action_net *tn = net_generic(net, frer_net_id);
+
+	return tc_action_net_init(net, tn, &act_frer_ops);
+}
+
+static void __net_exit frer_exit_net(struct list_head *net_list)
+{
+	tc_action_net_exit(net_list, frer_net_id);
+};
+
+static struct pernet_operations frer_net_ops = {
+	.init = frer_init_net,
+	.exit_batch = frer_exit_net,
+	.id   = &frer_net_id,
+	.size = sizeof(struct tc_action_net),
+};
+
+static int __init frer_init_module(void)
+{
+	return tcf_register_action(&act_frer_ops, &frer_net_ops);
+}
+
+static void __exit frer_cleanup_module(void)
+{
+	tcf_unregister_action(&act_frer_ops, &frer_net_ops);
+}
+
+module_init(frer_init_module);
+module_exit(frer_cleanup_module);
+MODULE_LICENSE("GPL v2");
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2ef8f5a6205a..353184987427 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -39,6 +39,7 @@
 #include <net/tc_act/tc_ct.h>
 #include <net/tc_act/tc_mpls.h>
 #include <net/tc_act/tc_gate.h>
+#include <net/tc_act/tc_frer.h>
 #include <net/flow_offload.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
@@ -3706,6 +3707,16 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			err = tcf_gate_get_entries(entry, act);
 			if (err)
 				goto err_out_locked;
+		} else if (is_tcf_frer(act)) {
+			entry->id = FLOW_ACTION_FRER;
+			entry->frer.tag_type = to_frer(act)->tag_type;
+			entry->frer.tag_action = to_frer(act)->tag_action;
+			entry->frer.recover = to_frer(act)->recover;
+			entry->frer.rcvy_alg = to_frer(act)->rcvy_alg;
+			entry->frer.rcvy_history_len =
+				to_frer(act)->rcvy_history_len;
+			entry->frer.rcvy_reset_msec =
+				to_frer(act)->rcvy_reset_msec;
 		} else {
 			err = -EOPNOTSUPP;
 			goto err_out_locked;
-- 
2.17.1

