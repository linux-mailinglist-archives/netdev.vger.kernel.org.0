Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8503861529
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 16:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfGGOCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 10:02:24 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40772 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfGGOCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 10:02:23 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so12166726eds.7
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 07:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WKhag70FTIzn7Weh4bj4NMexPxXzmlBGaDNCUzZq1y4=;
        b=iXWQzQSpUiJQGHbZcf1mub3d94qSjBbrTQNuGOtkf2yN+eU99OhFru2R+BOPTP3O7V
         y5RqOg2baaPDns3Sn9YqD2sUGLEAx3aPO0Knrx+3bVZ5wIQoPNZidXvU7VF8Yaiq0Ux7
         vU/izsTyp8lNMwB9Lf9HIa5D/Y0Ib8ZkYJOHPyZJFtRKuSKRFoVuyj8SEP5oI/3RqDmq
         awgi78zuHK/yu9H2xH70H6gfS8FGFMv9RB1S+nicnf2rrsCRVkwaVyJq+q+zoTWmbSnz
         YHsCML70msmTllg/Qj7GNnLKkLZdRXhw7LQv2SPUqHBDtTJSd8K18XY/vpPZlCCYJZBh
         a+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WKhag70FTIzn7Weh4bj4NMexPxXzmlBGaDNCUzZq1y4=;
        b=FBmFBp1qS9OTV4UXWPCtxlnMwaro0XpO7bOOKOzvrwmFW+ZuANoe3fFOvY8l3x0rAY
         IJNA3MuqY24CJpPtURu2oglMPjvsO8raBmbR5QVGa2klVLwIsdPwyxokMuEEKt2/Uese
         FWPAWbIVJidj3J8VyS0rYTFZAaGxJ8G3clNbw8e0pcbrrNpEuuRNc9AwVNBO0J13ImY5
         1dOXxHK3kvb9bq9gVk9W7gZ8b5dCy57v3ZBssoUmY700h1XEAMIgNUfS+iA/n0r7fXja
         SsfIwJj0KmawLSJWOzPMmiM4hzif1PCHlLWqeo1cTI9YxagWv2pAjsphG9P34uG2JOFk
         l2zw==
X-Gm-Message-State: APjAAAWChLnhdFOvi15S4hD8Kd1tSaimlCDNjFx+mQS9yEeZpHfK3n54
        yP2YxYzCFMwo4g9moHBz5BZhwHfskno=
X-Google-Smtp-Source: APXvYqwubJ70vMdAWYL51uMjdPHZOMRKWepM0PMdEyLwRHrXv5Ybj0IkQS9zL1Euu7+2FDKCCWtXzQ==
X-Received: by 2002:a17:906:2557:: with SMTP id j23mr12149975ejb.228.1562508139037;
        Sun, 07 Jul 2019 07:02:19 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id t2sm4673327eda.95.2019.07.07.07.02.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 07 Jul 2019 07:02:18 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        dcaratti@redhat.com, mrv@mojatatu.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v7 4/5] net: sched: add mpls manipulation actions to TC
Date:   Sun,  7 Jul 2019 15:01:57 +0100
Message-Id: <1562508118-28841-5-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562508118-28841-1-git-send-email-john.hurley@netronome.com>
References: <1562508118-28841-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, TC offers the ability to match on the MPLS fields of a packet
through the use of the flow_dissector_key_mpls struct. However, as yet, TC
actions do not allow the modification or manipulation of such fields.

Add a new module that registers TC action ops to allow manipulation of
MPLS. This includes the ability to push and pop headers as well as modify
the contents of new or existing headers. A further action to decrement the
TTL field of an MPLS header is also provided with a new helper added to
support this.

Examples of the usage of the new action with flower rules to push and pop
MPLS labels are:

tc filter add dev eth0 protocol ip parent ffff: flower \
    action mpls push protocol mpls_uc label 123  \
    action mirred egress redirect dev eth1

tc filter add dev eth0 protocol mpls_uc parent ffff: flower \
    action mpls pop protocol ipv4  \
    action mirred egress redirect dev eth1

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/linux/skbuff.h              |   1 +
 include/net/tc_act/tc_mpls.h        |  30 +++
 include/uapi/linux/pkt_cls.h        |   3 +-
 include/uapi/linux/tc_act/tc_mpls.h |  33 +++
 net/core/skbuff.c                   |  30 +++
 net/sched/Kconfig                   |  11 +
 net/sched/Makefile                  |   1 +
 net/sched/act_mpls.c                | 406 ++++++++++++++++++++++++++++++++++++
 8 files changed, 514 insertions(+), 1 deletion(-)
 create mode 100644 include/net/tc_act/tc_mpls.h
 create mode 100644 include/uapi/linux/tc_act/tc_mpls.h
 create mode 100644 net/sched/act_mpls.c

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dc07f00..c6fbe09 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3449,6 +3449,7 @@ int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto);
 int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto);
 int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse);
+int skb_mpls_dec_ttl(struct sk_buff *skb);
 struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
 			     gfp_t gfp);
 
diff --git a/include/net/tc_act/tc_mpls.h b/include/net/tc_act/tc_mpls.h
new file mode 100644
index 0000000..4bc3d92
--- /dev/null
+++ b/include/net/tc_act/tc_mpls.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#ifndef __NET_TC_MPLS_H
+#define __NET_TC_MPLS_H
+
+#include <linux/tc_act/tc_mpls.h>
+#include <net/act_api.h>
+
+struct tcf_mpls_params {
+	int tcfm_action;
+	u32 tcfm_label;
+	u8 tcfm_tc;
+	u8 tcfm_ttl;
+	u8 tcfm_bos;
+	__be16 tcfm_proto;
+	struct rcu_head	rcu;
+};
+
+#define ACT_MPLS_TC_NOT_SET	0xff
+#define ACT_MPLS_BOS_NOT_SET	0xff
+#define ACT_MPLS_LABEL_NOT_SET	0xffffffff
+
+struct tcf_mpls {
+	struct tc_action common;
+	struct tcf_mpls_params __rcu *mpls_p;
+};
+#define to_mpls(a) ((struct tcf_mpls *)a)
+
+#endif /* __NET_TC_MPLS_H */
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 8cc6b67..e22ef4a 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -104,8 +104,9 @@ enum tca_id {
 	TCA_ID_SIMP = TCA_ACT_SIMP,
 	TCA_ID_IFE = TCA_ACT_IFE,
 	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
-	/* other actions go here */
 	TCA_ID_CTINFO,
+	TCA_ID_MPLS,
+	/* other actions go here */
 	__TCA_ID_MAX = 255
 };
 
diff --git a/include/uapi/linux/tc_act/tc_mpls.h b/include/uapi/linux/tc_act/tc_mpls.h
new file mode 100644
index 0000000..9360e95
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_mpls.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#ifndef __LINUX_TC_MPLS_H
+#define __LINUX_TC_MPLS_H
+
+#include <linux/pkt_cls.h>
+
+#define TCA_MPLS_ACT_POP	1
+#define TCA_MPLS_ACT_PUSH	2
+#define TCA_MPLS_ACT_MODIFY	3
+#define TCA_MPLS_ACT_DEC_TTL	4
+
+struct tc_mpls {
+	tc_gen;		/* generic TC action fields. */
+	int m_action;	/* action of type TCA_MPLS_ACT_*. */
+};
+
+enum {
+	TCA_MPLS_UNSPEC,
+	TCA_MPLS_TM,	/* struct tcf_t; time values associated with action. */
+	TCA_MPLS_PARMS,	/* struct tc_mpls; action type and general TC fields. */
+	TCA_MPLS_PAD,
+	TCA_MPLS_PROTO,	/* be16; eth_type of pushed or next (for pop) header. */
+	TCA_MPLS_LABEL,	/* u32; MPLS label. Lower 20 bits are used. */
+	TCA_MPLS_TC,	/* u8; MPLS TC field. Lower 3 bits are used. */
+	TCA_MPLS_TTL,	/* u8; MPLS TTL field. Must not be 0. */
+	TCA_MPLS_BOS,	/* u8; MPLS BOS field. Either 1 or 0. */
+	__TCA_MPLS_MAX,
+};
+#define TCA_MPLS_MAX (__TCA_MPLS_MAX - 1)
+
+#endif
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 46da15c..34ee236 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -59,6 +59,7 @@
 #include <linux/errqueue.h>
 #include <linux/prefetch.h>
 #include <linux/if_vlan.h>
+#include <linux/mpls.h>
 
 #include <net/protocol.h>
 #include <net/dst.h>
@@ -5466,6 +5467,35 @@ int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse)
 EXPORT_SYMBOL_GPL(skb_mpls_update_lse);
 
 /**
+ * skb_mpls_dec_ttl() - decrement the TTL of the outermost MPLS header
+ *
+ * @skb: buffer
+ *
+ * Expects skb->data at mac header.
+ *
+ * Returns 0 on success, -errno otherwise.
+ */
+int skb_mpls_dec_ttl(struct sk_buff *skb)
+{
+	u32 lse;
+	u8 ttl;
+
+	if (unlikely(!eth_p_mpls(skb->protocol)))
+		return -EINVAL;
+
+	lse = be32_to_cpu(mpls_hdr(skb)->label_stack_entry);
+	ttl = (lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
+	if (!--ttl)
+		return -EINVAL;
+
+	lse &= ~MPLS_LS_TTL_MASK;
+	lse |= ttl << MPLS_LS_TTL_SHIFT;
+
+	return skb_mpls_update_lse(skb, cpu_to_be32(lse));
+}
+EXPORT_SYMBOL_GPL(skb_mpls_dec_ttl);
+
+/**
  * alloc_skb_with_frags - allocate skb with page frags
  *
  * @header_len: size of linear part
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 360fdd3..731f5fb 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -842,6 +842,17 @@ config NET_ACT_CSUM
 	  To compile this code as a module, choose M here: the
 	  module will be called act_csum.
 
+config NET_ACT_MPLS
+	tristate "MPLS manipulation"
+	depends on NET_CLS_ACT
+	help
+	  Say Y here to push or pop MPLS headers.
+
+	  If unsure, say N.
+
+	  To compile this code as a module, choose M here: the
+	  module will be called act_mpls.
+
 config NET_ACT_VLAN
         tristate "Vlan manipulation"
         depends on NET_CLS_ACT
diff --git a/net/sched/Makefile b/net/sched/Makefile
index d54bfcb..c266036 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_NET_ACT_PEDIT)	+= act_pedit.o
 obj-$(CONFIG_NET_ACT_SIMP)	+= act_simple.o
 obj-$(CONFIG_NET_ACT_SKBEDIT)	+= act_skbedit.o
 obj-$(CONFIG_NET_ACT_CSUM)	+= act_csum.o
+obj-$(CONFIG_NET_ACT_MPLS)	+= act_mpls.o
 obj-$(CONFIG_NET_ACT_VLAN)	+= act_vlan.o
 obj-$(CONFIG_NET_ACT_BPF)	+= act_bpf.o
 obj-$(CONFIG_NET_ACT_CONNMARK)	+= act_connmark.o
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
new file mode 100644
index 0000000..ca2597c
--- /dev/null
+++ b/net/sched/act_mpls.c
@@ -0,0 +1,406 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mpls.h>
+#include <linux/rtnetlink.h>
+#include <linux/skbuff.h>
+#include <linux/tc_act/tc_mpls.h>
+#include <net/mpls.h>
+#include <net/netlink.h>
+#include <net/pkt_sched.h>
+#include <net/pkt_cls.h>
+#include <net/tc_act/tc_mpls.h>
+
+static unsigned int mpls_net_id;
+static struct tc_action_ops act_mpls_ops;
+
+#define ACT_MPLS_TTL_DEFAULT	255
+
+static __be32 tcf_mpls_get_lse(struct mpls_shim_hdr *lse,
+			       struct tcf_mpls_params *p, bool set_bos)
+{
+	u32 new_lse = 0;
+
+	if (lse)
+		new_lse = be32_to_cpu(lse->label_stack_entry);
+
+	if (p->tcfm_label != ACT_MPLS_LABEL_NOT_SET) {
+		new_lse &= ~MPLS_LS_LABEL_MASK;
+		new_lse |= p->tcfm_label << MPLS_LS_LABEL_SHIFT;
+	}
+	if (p->tcfm_ttl) {
+		new_lse &= ~MPLS_LS_TTL_MASK;
+		new_lse |= p->tcfm_ttl << MPLS_LS_TTL_SHIFT;
+	}
+	if (p->tcfm_tc != ACT_MPLS_TC_NOT_SET) {
+		new_lse &= ~MPLS_LS_TC_MASK;
+		new_lse |= p->tcfm_tc << MPLS_LS_TC_SHIFT;
+	}
+	if (p->tcfm_bos != ACT_MPLS_BOS_NOT_SET) {
+		new_lse &= ~MPLS_LS_S_MASK;
+		new_lse |= p->tcfm_bos << MPLS_LS_S_SHIFT;
+	} else if (set_bos) {
+		new_lse |= 1 << MPLS_LS_S_SHIFT;
+	}
+
+	return cpu_to_be32(new_lse);
+}
+
+static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
+			struct tcf_result *res)
+{
+	struct tcf_mpls *m = to_mpls(a);
+	struct tcf_mpls_params *p;
+	__be32 new_lse;
+	int ret;
+
+	tcf_lastuse_update(&m->tcf_tm);
+	bstats_cpu_update(this_cpu_ptr(m->common.cpu_bstats), skb);
+
+	/* Ensure 'data' points at mac_header prior calling mpls manipulating
+	 * functions.
+	 */
+	if (skb_at_tc_ingress(skb))
+		skb_push_rcsum(skb, skb->mac_len);
+
+	ret = READ_ONCE(m->tcf_action);
+
+	p = rcu_dereference_bh(m->mpls_p);
+
+	switch (p->tcfm_action) {
+	case TCA_MPLS_ACT_POP:
+		if (skb_mpls_pop(skb, p->tcfm_proto))
+			goto drop;
+		break;
+	case TCA_MPLS_ACT_PUSH:
+		new_lse = tcf_mpls_get_lse(NULL, p, !eth_p_mpls(skb->protocol));
+		if (skb_mpls_push(skb, new_lse, p->tcfm_proto))
+			goto drop;
+		break;
+	case TCA_MPLS_ACT_MODIFY:
+		new_lse = tcf_mpls_get_lse(mpls_hdr(skb), p, false);
+		if (skb_mpls_update_lse(skb, new_lse))
+			goto drop;
+		break;
+	case TCA_MPLS_ACT_DEC_TTL:
+		if (skb_mpls_dec_ttl(skb))
+			goto drop;
+		break;
+	}
+
+	if (skb_at_tc_ingress(skb))
+		skb_pull_rcsum(skb, skb->mac_len);
+
+	return ret;
+
+drop:
+	qstats_drop_inc(this_cpu_ptr(m->common.cpu_qstats));
+	return TC_ACT_SHOT;
+}
+
+static int valid_label(const struct nlattr *attr,
+		       struct netlink_ext_ack *extack)
+{
+	const u32 *label = nla_data(attr);
+
+	if (*label & ~MPLS_LABEL_MASK || *label == MPLS_LABEL_IMPLNULL) {
+		NL_SET_ERR_MSG_MOD(extack, "MPLS label out of range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
+	[TCA_MPLS_UNSPEC]	= { .strict_start_type = TCA_MPLS_UNSPEC + 1 },
+	[TCA_MPLS_PARMS]	= NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
+	[TCA_MPLS_PROTO]	= { .type = NLA_U16 },
+	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
+	[TCA_MPLS_TC]		= NLA_POLICY_RANGE(NLA_U8, 0, 7),
+	[TCA_MPLS_TTL]		= NLA_POLICY_MIN(NLA_U8, 1),
+	[TCA_MPLS_BOS]		= NLA_POLICY_RANGE(NLA_U8, 0, 1),
+};
+
+static int tcf_mpls_init(struct net *net, struct nlattr *nla,
+			 struct nlattr *est, struct tc_action **a,
+			 int ovr, int bind, bool rtnl_held,
+			 struct tcf_proto *tp, struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, mpls_net_id);
+	struct nlattr *tb[TCA_MPLS_MAX + 1];
+	struct tcf_chain *goto_ch = NULL;
+	struct tcf_mpls_params *p;
+	struct tc_mpls *parm;
+	bool exists = false;
+	struct tcf_mpls *m;
+	int ret = 0, err;
+	u8 mpls_ttl = 0;
+
+	if (!nla) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing netlink attributes");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, TCA_MPLS_MAX, nla, mpls_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_MPLS_PARMS]) {
+		NL_SET_ERR_MSG_MOD(extack, "No MPLS params");
+		return -EINVAL;
+	}
+	parm = nla_data(tb[TCA_MPLS_PARMS]);
+
+	/* Verify parameters against action type. */
+	switch (parm->m_action) {
+	case TCA_MPLS_ACT_POP:
+		if (!tb[TCA_MPLS_PROTO]) {
+			NL_SET_ERR_MSG_MOD(extack, "Protocol must be set for MPLS pop");
+			return -EINVAL;
+		}
+		if (!eth_proto_is_802_3(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
+			NL_SET_ERR_MSG_MOD(extack, "Invalid protocol type for MPLS pop");
+			return -EINVAL;
+		}
+		if (tb[TCA_MPLS_LABEL] || tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC] ||
+		    tb[TCA_MPLS_BOS]) {
+			NL_SET_ERR_MSG_MOD(extack, "Label, TTL, TC or BOS cannot be used with MPLS pop");
+			return -EINVAL;
+		}
+		break;
+	case TCA_MPLS_ACT_DEC_TTL:
+		if (tb[TCA_MPLS_PROTO] || tb[TCA_MPLS_LABEL] ||
+		    tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC] || tb[TCA_MPLS_BOS]) {
+			NL_SET_ERR_MSG_MOD(extack, "Label, TTL, TC, BOS or protocol cannot be used with MPLS dec_ttl");
+			return -EINVAL;
+		}
+		break;
+	case TCA_MPLS_ACT_PUSH:
+		if (!tb[TCA_MPLS_LABEL]) {
+			NL_SET_ERR_MSG_MOD(extack, "Label is required for MPLS push");
+			return -EINVAL;
+		}
+		if (tb[TCA_MPLS_PROTO] &&
+		    !eth_p_mpls(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
+			NL_SET_ERR_MSG_MOD(extack, "Protocol must be an MPLS type for MPLS push");
+			return -EPROTONOSUPPORT;
+		}
+		/* Push needs a TTL - if not specified, set a default value. */
+		if (!tb[TCA_MPLS_TTL]) {
+#if IS_ENABLED(CONFIG_MPLS)
+			mpls_ttl = net->mpls.default_ttl ?
+				   net->mpls.default_ttl : ACT_MPLS_TTL_DEFAULT;
+#else
+			mpls_ttl = ACT_MPLS_TTL_DEFAULT;
+#endif
+		}
+		break;
+	case TCA_MPLS_ACT_MODIFY:
+		if (tb[TCA_MPLS_PROTO]) {
+			NL_SET_ERR_MSG_MOD(extack, "Protocol cannot be used with MPLS modify");
+			return -EINVAL;
+		}
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unknown MPLS action");
+		return -EINVAL;
+	}
+
+	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	if (err < 0)
+		return err;
+	exists = err;
+	if (exists && bind)
+		return 0;
+
+	if (!exists) {
+		ret = tcf_idr_create(tn, parm->index, est, a,
+				     &act_mpls_ops, bind, true);
+		if (ret) {
+			tcf_idr_cleanup(tn, parm->index);
+			return ret;
+		}
+
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
+	m = to_mpls(*a);
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p) {
+		err = -ENOMEM;
+		goto put_chain;
+	}
+
+	p->tcfm_action = parm->m_action;
+	p->tcfm_label = tb[TCA_MPLS_LABEL] ? nla_get_u32(tb[TCA_MPLS_LABEL]) :
+					     ACT_MPLS_LABEL_NOT_SET;
+	p->tcfm_tc = tb[TCA_MPLS_TC] ? nla_get_u8(tb[TCA_MPLS_TC]) :
+				       ACT_MPLS_TC_NOT_SET;
+	p->tcfm_ttl = tb[TCA_MPLS_TTL] ? nla_get_u8(tb[TCA_MPLS_TTL]) :
+					 mpls_ttl;
+	p->tcfm_bos = tb[TCA_MPLS_BOS] ? nla_get_u8(tb[TCA_MPLS_BOS]) :
+					 ACT_MPLS_BOS_NOT_SET;
+	p->tcfm_proto = tb[TCA_MPLS_PROTO] ? nla_get_be16(tb[TCA_MPLS_PROTO]) :
+					     htons(ETH_P_MPLS_UC);
+
+	spin_lock_bh(&m->tcf_lock);
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	rcu_swap_protected(m->mpls_p, p, lockdep_is_held(&m->tcf_lock));
+	spin_unlock_bh(&m->tcf_lock);
+
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+	if (p)
+		kfree_rcu(p, rcu);
+
+	if (ret == ACT_P_CREATED)
+		tcf_idr_insert(tn, *a);
+	return ret;
+put_chain:
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+release_idr:
+	tcf_idr_release(*a, bind);
+	return err;
+}
+
+static void tcf_mpls_cleanup(struct tc_action *a)
+{
+	struct tcf_mpls *m = to_mpls(a);
+	struct tcf_mpls_params *p;
+
+	p = rcu_dereference_protected(m->mpls_p, 1);
+	if (p)
+		kfree_rcu(p, rcu);
+}
+
+static int tcf_mpls_dump(struct sk_buff *skb, struct tc_action *a,
+			 int bind, int ref)
+{
+	unsigned char *b = skb_tail_pointer(skb);
+	struct tcf_mpls *m = to_mpls(a);
+	struct tcf_mpls_params *p;
+	struct tc_mpls opt = {
+		.index    = m->tcf_index,
+		.refcnt   = refcount_read(&m->tcf_refcnt) - ref,
+		.bindcnt  = atomic_read(&m->tcf_bindcnt) - bind,
+	};
+	struct tcf_t t;
+
+	spin_lock_bh(&m->tcf_lock);
+	opt.action = m->tcf_action;
+	p = rcu_dereference_protected(m->mpls_p, lockdep_is_held(&m->tcf_lock));
+	opt.m_action = p->tcfm_action;
+
+	if (nla_put(skb, TCA_MPLS_PARMS, sizeof(opt), &opt))
+		goto nla_put_failure;
+
+	if (p->tcfm_label != ACT_MPLS_LABEL_NOT_SET &&
+	    nla_put_u32(skb, TCA_MPLS_LABEL, p->tcfm_label))
+		goto nla_put_failure;
+
+	if (p->tcfm_tc != ACT_MPLS_TC_NOT_SET &&
+	    nla_put_u8(skb, TCA_MPLS_TC, p->tcfm_tc))
+		goto nla_put_failure;
+
+	if (p->tcfm_ttl && nla_put_u8(skb, TCA_MPLS_TTL, p->tcfm_ttl))
+		goto nla_put_failure;
+
+	if (p->tcfm_bos != ACT_MPLS_BOS_NOT_SET &&
+	    nla_put_u8(skb, TCA_MPLS_BOS, p->tcfm_bos))
+		goto nla_put_failure;
+
+	if (nla_put_be16(skb, TCA_MPLS_PROTO, p->tcfm_proto))
+		goto nla_put_failure;
+
+	tcf_tm_dump(&t, &m->tcf_tm);
+
+	if (nla_put_64bit(skb, TCA_MPLS_TM, sizeof(t), &t, TCA_MPLS_PAD))
+		goto nla_put_failure;
+
+	spin_unlock_bh(&m->tcf_lock);
+
+	return skb->len;
+
+nla_put_failure:
+	spin_unlock_bh(&m->tcf_lock);
+	nlmsg_trim(skb, b);
+	return -EMSGSIZE;
+}
+
+static int tcf_mpls_walker(struct net *net, struct sk_buff *skb,
+			   struct netlink_callback *cb, int type,
+			   const struct tc_action_ops *ops,
+			   struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, mpls_net_id);
+
+	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
+}
+
+static int tcf_mpls_search(struct net *net, struct tc_action **a, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, mpls_net_id);
+
+	return tcf_idr_search(tn, a, index);
+}
+
+static struct tc_action_ops act_mpls_ops = {
+	.kind		=	"mpls",
+	.id		=	TCA_ID_MPLS,
+	.owner		=	THIS_MODULE,
+	.act		=	tcf_mpls_act,
+	.dump		=	tcf_mpls_dump,
+	.init		=	tcf_mpls_init,
+	.cleanup	=	tcf_mpls_cleanup,
+	.walk		=	tcf_mpls_walker,
+	.lookup		=	tcf_mpls_search,
+	.size		=	sizeof(struct tcf_mpls),
+};
+
+static __net_init int mpls_init_net(struct net *net)
+{
+	struct tc_action_net *tn = net_generic(net, mpls_net_id);
+
+	return tc_action_net_init(tn, &act_mpls_ops);
+}
+
+static void __net_exit mpls_exit_net(struct list_head *net_list)
+{
+	tc_action_net_exit(net_list, mpls_net_id);
+}
+
+static struct pernet_operations mpls_net_ops = {
+	.init = mpls_init_net,
+	.exit_batch = mpls_exit_net,
+	.id   = &mpls_net_id,
+	.size = sizeof(struct tc_action_net),
+};
+
+static int __init mpls_init_module(void)
+{
+	return tcf_register_action(&act_mpls_ops, &mpls_net_ops);
+}
+
+static void __exit mpls_cleanup_module(void)
+{
+	tcf_unregister_action(&act_mpls_ops, &mpls_net_ops);
+}
+
+module_init(mpls_init_module);
+module_exit(mpls_cleanup_module);
+
+MODULE_AUTHOR("Netronome Systems <oss-drivers@netronome.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MPLS manipulation actions");
-- 
2.7.4

