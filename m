Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4EE426B1
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437381AbfFLMwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:52:16 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46392 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437322AbfFLMwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:52:16 -0400
Received: by mail-ed1-f68.google.com with SMTP id d4so2235587edr.13
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 05:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S6S7jllG1tOk8U29rtsgSO/xzQxPxF1mZ8IfjFwOYqU=;
        b=FGibPUusOvKWRf5zKfB3y4q/OvvZU5XX/DOmJKnM/eVADGY78SdcghrAk3PtgityaV
         F/sIqlGqyK999mhGTOTwTQ2V9u8TUF4/GTqR1l+8eNGrP+0ko5IJJsM3UOnXw8MhWKFD
         eqVATPre99tYzvsA0eg19WYKn0+TZP+AGoGcPj30ZxbPQ5ufUI2CtUZDzsRUZZa5nBBy
         xgkogr6kQ7ICsb9XkvU8Q/AKD9K9JkzRluI+Y8AEBl7d0/QCgLzV1MFYzUZvDR2+OXwu
         5c8fJzHLlxU/bWQBxyD0j9PemzXILs/bHTtBCmE4wZY1yC+caJcSvKuJ/Kv7DKRXJMOP
         GYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S6S7jllG1tOk8U29rtsgSO/xzQxPxF1mZ8IfjFwOYqU=;
        b=MAeBuWMRBIsChPvIUjG1oZ5UXDhiANj5sg5r5vOD8Bofm+GUSW9hYOSo6JppSuEd3m
         3n3tDJNtNaMi7FSOX9sSpZMgGl/lSZl5nc0Y05xJsyROVhjK1j8vwUHzHjchNRDUXhTf
         9Pg99Cn0dalKnmA56OBC7rPm+XN11Vd8PJjiodThENXQ67uuZk2lTgPFNvhPcu4eUUGX
         GOwKTkU9gK1O/AMN6yHb1cKDcyvKv2r7a8gAVAlvwx6uyQh+6G4DHorV7bE8BSxKySeO
         I4UCli97hYeRB6NIvZrcGR9pXIebuxAFlGvLCNqLBAszpzRovRR//r8BPG/nn/tcBKLM
         1n9w==
X-Gm-Message-State: APjAAAUK4R8oVU1hnlo1EdY+1KACFiuyRL2Q7JzElia/cLdj1oOfjIIs
        bd71Y8SohBbHwtN7lw5KAtPJTsPzpFM=
X-Google-Smtp-Source: APXvYqyvxvvjc47m+UDniDMHVJEAspc8ditGimnYcLI2gmr+Ku0Juk2xxNuqcMFXeVg+E58pjvgpKw==
X-Received: by 2002:a50:b6f4:: with SMTP id f49mr8006344ede.142.1560343933562;
        Wed, 12 Jun 2019 05:52:13 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id u15sm17043eja.32.2019.06.12.05.52.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 05:52:13 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 1/3] net: sched: add mpls manipulation actions to TC
Date:   Wed, 12 Jun 2019 13:51:44 +0100
Message-Id: <1560343906-19426-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560343906-19426-1-git-send-email-john.hurley@netronome.com>
References: <1560343906-19426-1-git-send-email-john.hurley@netronome.com>
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
TTL field of an MPLS header is also provided.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/tc_act/tc_mpls.h        |  27 +++
 include/uapi/linux/pkt_cls.h        |   2 +
 include/uapi/linux/tc_act/tc_mpls.h |  32 +++
 net/sched/Kconfig                   |  11 +
 net/sched/Makefile                  |   1 +
 net/sched/act_mpls.c                | 450 ++++++++++++++++++++++++++++++++++++
 6 files changed, 523 insertions(+)
 create mode 100644 include/net/tc_act/tc_mpls.h
 create mode 100644 include/uapi/linux/tc_act/tc_mpls.h
 create mode 100644 net/sched/act_mpls.c

diff --git a/include/net/tc_act/tc_mpls.h b/include/net/tc_act/tc_mpls.h
new file mode 100644
index 0000000..ca7393a
--- /dev/null
+++ b/include/net/tc_act/tc_mpls.h
@@ -0,0 +1,27 @@
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
+	__be16 tcfm_proto;
+	struct rcu_head	rcu;
+};
+
+#define ACT_MPLS_TC_NOT_SET	0xff
+
+struct tcf_mpls {
+	struct tc_action common;
+	struct tcf_mpls_params __rcu *mpls_p;
+};
+#define to_mpls(a) ((struct tcf_mpls *)a)
+
+#endif /* __NET_TC_MPLS_H */
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index a93680f..197621a 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -83,6 +83,7 @@ enum {
 #define TCA_ACT_SIMP 22
 #define TCA_ACT_IFE 25
 #define TCA_ACT_SAMPLE 26
+#define TCA_ACT_MPLS 27
 
 /* Action type identifiers*/
 enum tca_id {
@@ -104,6 +105,7 @@ enum tca_id {
 	TCA_ID_SIMP = TCA_ACT_SIMP,
 	TCA_ID_IFE = TCA_ACT_IFE,
 	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
+	TCA_ID_MPLS = TCA_ACT_MPLS,
 	/* other actions go here */
 	TCA_ID_CTINFO,
 	__TCA_ID_MAX = 255
diff --git a/include/uapi/linux/tc_act/tc_mpls.h b/include/uapi/linux/tc_act/tc_mpls.h
new file mode 100644
index 0000000..6e8907b
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_mpls.h
@@ -0,0 +1,32 @@
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
+	tc_gen;
+	int m_action;
+};
+
+enum {
+	TCA_MPLS_UNSPEC,
+	TCA_MPLS_TM,
+	TCA_MPLS_PARMS,
+	TCA_MPLS_PAD,
+	TCA_MPLS_PROTO,
+	TCA_MPLS_LABEL,
+	TCA_MPLS_TC,
+	TCA_MPLS_TTL,
+	__TCA_MPLS_MAX,
+};
+#define TCA_MPLS_MAX (__TCA_MPLS_MAX - 1)
+
+#endif
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index d104f7e..a34dcd3 100644
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
index 0000000..ff56ada
--- /dev/null
+++ b/net/sched/act_mpls.c
@@ -0,0 +1,450 @@
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
+static void tcf_mpls_mod_lse(struct mpls_shim_hdr *lse,
+			     struct tcf_mpls_params *p, bool set_bos)
+{
+	u32 new_lse = be32_to_cpu(lse->label_stack_entry);
+
+	if (p->tcfm_label) {
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
+	if (set_bos)
+		new_lse |= 1 << MPLS_LS_S_SHIFT;
+
+	lse->label_stack_entry = cpu_to_be32(new_lse);
+}
+
+static inline void tcf_mpls_set_eth_type(struct sk_buff *skb, __be16 ethertype)
+{
+	struct ethhdr *hdr = eth_hdr(skb);
+
+	skb_postpull_rcsum(skb, &hdr->h_proto, ETH_TLEN);
+	hdr->h_proto = ethertype;
+	skb_postpush_rcsum(skb, &hdr->h_proto, ETH_TLEN);
+}
+
+static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
+			struct tcf_result *res)
+{
+	struct tcf_mpls *m = to_mpls(a);
+	struct mpls_shim_hdr *lse;
+	struct tcf_mpls_params *p;
+	u32 temp_lse;
+	int ret;
+	u8 ttl;
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
+		if (unlikely(!eth_p_mpls(skb->protocol)))
+			goto out;
+
+		if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
+			goto drop;
+
+		skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
+		memmove(skb->data + MPLS_HLEN, skb->data, ETH_HLEN);
+
+		__skb_pull(skb, MPLS_HLEN);
+		skb_reset_mac_header(skb);
+		skb_set_network_header(skb, ETH_HLEN);
+
+		tcf_mpls_set_eth_type(skb, p->tcfm_proto);
+		skb->protocol = p->tcfm_proto;
+		break;
+	case TCA_MPLS_ACT_PUSH:
+		if (unlikely(skb_cow_head(skb, MPLS_HLEN)))
+			goto drop;
+
+		skb_push(skb, MPLS_HLEN);
+		memmove(skb->data, skb->data + MPLS_HLEN, ETH_HLEN);
+		skb_reset_mac_header(skb);
+		skb_set_network_header(skb, ETH_HLEN);
+
+		lse = mpls_hdr(skb);
+		lse->label_stack_entry = 0;
+		tcf_mpls_mod_lse(lse, p, !eth_p_mpls(skb->protocol));
+		skb_postpush_rcsum(skb, lse, MPLS_HLEN);
+
+		tcf_mpls_set_eth_type(skb, p->tcfm_proto);
+		skb->protocol = p->tcfm_proto;
+		break;
+	case TCA_MPLS_ACT_MODIFY:
+		if (unlikely(!eth_p_mpls(skb->protocol)))
+			goto out;
+
+		if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
+			goto drop;
+
+		lse = mpls_hdr(skb);
+		skb_postpull_rcsum(skb, lse, MPLS_HLEN);
+		tcf_mpls_mod_lse(lse, p, false);
+		skb_postpush_rcsum(skb, lse, MPLS_HLEN);
+		break;
+	case TCA_MPLS_ACT_DEC_TTL:
+		if (unlikely(!eth_p_mpls(skb->protocol)))
+			goto out;
+
+		if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
+			goto drop;
+
+		lse = mpls_hdr(skb);
+		temp_lse = be32_to_cpu(lse->label_stack_entry);
+		ttl = (temp_lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
+		if (!--ttl)
+			goto drop;
+
+		temp_lse &= ~MPLS_LS_TTL_MASK;
+		temp_lse |= ttl << MPLS_LS_TTL_SHIFT;
+		skb_postpull_rcsum(skb, lse, MPLS_HLEN);
+		lse->label_stack_entry = cpu_to_be32(temp_lse);
+		skb_postpush_rcsum(skb, lse, MPLS_HLEN);
+		break;
+	default:
+		WARN_ONCE(1, "Invalid MPLS action\n");
+	}
+
+out:
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
+	if (!*label || *label & ~MPLS_LABEL_MASK) {
+		NL_SET_ERR_MSG_MOD(extack, "MPLS label out of range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
+	[TCA_MPLS_PARMS]	= NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
+	[TCA_MPLS_PROTO]	= { .type = NLA_U16 },
+	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
+	[TCA_MPLS_TC]		= NLA_POLICY_RANGE(NLA_U8, 0, 7),
+	[TCA_MPLS_TTL]		= NLA_POLICY_MIN(NLA_U8, 1),
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
+		NL_SET_ERR_MSG_MOD(extack, "missing netlink attributes");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, TCA_MPLS_MAX, nla, mpls_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_MPLS_PARMS]) {
+		NL_SET_ERR_MSG_MOD(extack, "no MPLS params");
+		return -EINVAL;
+	}
+	parm = nla_data(tb[TCA_MPLS_PARMS]);
+
+	/* Verify parameters against action type. */
+	switch (parm->m_action) {
+	case TCA_MPLS_ACT_POP:
+		if (!tb[TCA_MPLS_PROTO] ||
+		    !eth_proto_is_802_3(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
+			NL_SET_ERR_MSG_MOD(extack, "MPLS POP: invalid proto");
+			return -EINVAL;
+		}
+		if (tb[TCA_MPLS_LABEL] || tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC]) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "MPLS POP: unsupported attrs");
+			return -EINVAL;
+		}
+		break;
+	case TCA_MPLS_ACT_DEC_TTL:
+		if (tb[TCA_MPLS_PROTO] || tb[TCA_MPLS_LABEL] ||
+		    tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC]) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "MPLS DEC TTL: unsupported attrs");
+			return -EINVAL;
+		}
+		break;
+	case TCA_MPLS_ACT_PUSH:
+		if (!tb[TCA_MPLS_LABEL]) {
+			NL_SET_ERR_MSG_MOD(extack, "MPLS PUSH: missing label");
+			return -EINVAL;
+		}
+		if (tb[TCA_MPLS_PROTO] &&
+		    !eth_p_mpls(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
+			NL_SET_ERR_MSG_MOD(extack, "MPLS PUSH: invalid proto");
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
+			NL_SET_ERR_MSG_MOD(extack,
+					   "MPLS MOD: unsupported attrs");
+			return -EINVAL;
+		}
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "MPLS: unknown action");
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
+					     0;
+	p->tcfm_tc = tb[TCA_MPLS_TC] ? nla_get_u8(tb[TCA_MPLS_TC]) :
+				       ACT_MPLS_TC_NOT_SET;
+	p->tcfm_ttl = tb[TCA_MPLS_TTL] ? nla_get_u8(tb[TCA_MPLS_TTL]) :
+					 mpls_ttl;
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
+	if (p->tcfm_label && nla_put_u32(skb, TCA_MPLS_LABEL, p->tcfm_label))
+		goto nla_put_failure;
+
+	if (p->tcfm_tc != ACT_MPLS_TC_NOT_SET &&
+	    nla_put_u8(skb, TCA_MPLS_TC, p->tcfm_tc))
+		goto nla_put_failure;
+
+	if (p->tcfm_ttl && nla_put_u8(skb, TCA_MPLS_TTL, p->tcfm_ttl))
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

