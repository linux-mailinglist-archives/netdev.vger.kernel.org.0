Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A29F40A186
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 01:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349184AbhIMXUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 19:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347475AbhIMXPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 19:15:53 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085C2C0613B9;
        Mon, 13 Sep 2021 16:11:54 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id s15so9669004qta.10;
        Mon, 13 Sep 2021 16:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UD+QaBq/OsNVfpqPRWDA1Fhy0oNndCEqffmQzP2mVk8=;
        b=C90gXxVyQkgawla/U0Zyelli4xhA8cm9Ds6zCjm8sAZr6EGr1cTb4HDuXuvYD9D8Ue
         YOnMqzis6USddv0mWttGrOyVss9en8MZdal793mXQYta/4m4Cvy714Bq7VcAixFcPxhL
         bnR/R6s6p5ihj+4GaPILyi6GnLM2OJ4Hj8O/W4R1Flc3vwhNsIESn2aXYrFfYnvw3zae
         jAmXRmDG5EbpkHmRJI8q5D2RGZplK2MIw0bLGTC5eOQNEnKTopcyv8HfVMsik+W/Guqs
         ciEialXIrz2OzoBIM8+28xCGsOZLcgvtRbwFgkzaVgDvwSgKDtTf/M0d2J/O6pLEYWzC
         awFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UD+QaBq/OsNVfpqPRWDA1Fhy0oNndCEqffmQzP2mVk8=;
        b=dKhqdQjk2o39mngmXfk7X3gn0P/sxEeF63ygD9DSTbA/t2fBvd8TB+EMNKgv5CrF/8
         8GqB41+eLM182wCou7dMP1rLDu23QGeJg1UzLfn3qnn0ZcZwxJHpsIkv4s4CuUVpMSwJ
         uM2QshhcmAjnn8ll+wJXfge9eU3WTpHS4PhoDiT5rppTjGbuPNaEfhjwT2EgstZ4fh0K
         6uS8zrZomFyhhgMhX7qC2QxjXcnfWvm5ZTWUcAZ76emGTGtAeeFJwYoEg5sqcRz2W7NU
         IKKjPHrm7QxjszM76fKZ7YCKvdZHsreT/8a4ZEj7fdb1fCUXIHtcbFPvLmoV2CfD6cW/
         J3dA==
X-Gm-Message-State: AOAM532aE5nm+D9pZdOZTksxMS6Xq4uqOofAqMBWQoZoDPpw/bW2WalN
        KCFWNNoRxATi5FYSN8Uu/0n/wmZ/ZRo=
X-Google-Smtp-Source: ABdhPJwGWcsDZS+pB7wJe+vIuyNgRWlrc2mKZv+sLlP1oNUwt8s2H/ugrGHRu92XzdYZT9/7OC5d2Q==
X-Received: by 2002:ac8:544e:: with SMTP id d14mr1902484qtq.133.1631574712564;
        Mon, 13 Sep 2021 16:11:52 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:37b3:a1b4:7605:f2bb])
        by smtp.gmail.com with ESMTPSA id c193sm6492478qkg.120.2021.09.13.16.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 16:11:52 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [RFC Patch net-next v2] net_sched: introduce eBPF based Qdisc
Date:   Mon, 13 Sep 2021 16:11:08 -0700
Message-Id: <20210913231108.19762-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This *incomplete* patch introduces a programmable Qdisc with
eBPF.  The goal is to make this Qdisc as programmable as possible,
that is, to replace as many existing Qdisc's as we can, no matter
in tree or out of tree. And we want to make programmer's and researcher's
life as easy as possible, so that they don't have to write a complete
Qdisc kernel module just to experiment some queuing theory.

The design was discussed during last LPC:
https://linuxplumbersconf.org/event/7/contributions/679/attachments/520/1188/sch_bpf.pdf

Here is a summary of design decisions I made:

1. Avoid eBPF struct_ops, as it would be really hard to program
   a Qdisc with this approach, literally all the struct Qdisc_ops
   and struct Qdisc_class_ops are needed to implement. This is almost
   as hard as programming a Qdisc kernel module.

2. Avoid exposing skb's to user-space, which means we don't introduce
   a map to store skb's. Instead, store them in kernel without exposure
   to user-space. There are three different reasons behind this:

   2a) User-space does not need to read skb, there is no use case to let
   user-space make decisions, so far.

   2b) Kernel would lose the visibility of the "queues", as maps are only
   shared between eBPF programs and user-space. These queues still have to
   interact with the kernel, for example, kernel wants to reset all queues
   when we reset the network interface, kernel wants to adjust number of
   queues if they are mapped to hardware queues.

   2c) It is harder to interact with existing TC infra. See below.

3. Integrate with existing TC infra. For example, if the user doesn't want
   to implement her own filters (e.g. a flow dissector), she should be able
   to re-use the existing TC filters. And each queue can be easily mapped
   to a TC class and dump its stats easily via netlink. Users can use this
   Qdisc together with any other Qdisc's too, pretty much like a regular
   Qdisc.

So I choose to use priority queues to store skb's inside a flow and to
store flows inside a Qdisc, and let eBPF programs decide the *relative*
position of the skb within the flow and the *relative* order of the flows
too, upon each enqueue and dequeue. Each flow is also exposed to user as
a TC class, like many other classful Qdisc's.

Although the biggest limitation is obviously that users can not traverse
the packets or flows inside the Qdisc, I think at least they could store
those global information of interest inside their own hashmap.

Any high-level feedbacks are welcome. Please do not review any coding details
until RFC tag is removed.

TODO:
1. actually test it
2. write a document for this Qdisc
3. add test cases and sample code

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
v2: Rebase on latest net-next
    Make the code more complete (but still incomplete)

 include/linux/bpf_types.h      |   2 +
 include/linux/priority_queue.h |  90 ++++++
 include/linux/skbuff.h         |   2 +
 include/uapi/linux/bpf.h       |  20 ++
 include/uapi/linux/pkt_sched.h |  15 +
 net/sched/Kconfig              |  15 +
 net/sched/Makefile             |   1 +
 net/sched/sch_bpf.c            | 609 +++++++++++++++++++++++++++++++++++++++++
 8 files changed, 754 insertions(+)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 9c81724e4b98..50e49e0e31a5 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -8,6 +8,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_SCHED_CLS, tc_cls_act,
 	      struct __sk_buff, struct sk_buff)
 BPF_PROG_TYPE(BPF_PROG_TYPE_SCHED_ACT, tc_cls_act,
 	      struct __sk_buff, struct sk_buff)
+BPF_PROG_TYPE(BPF_PROG_TYPE_SCHED_QDISC, tc_cls_act,
+	      struct __sk_buff, struct sk_buff)
 BPF_PROG_TYPE(BPF_PROG_TYPE_XDP, xdp,
 	      struct xdp_md, struct xdp_buff)
 #ifdef CONFIG_CGROUP_BPF
diff --git a/include/linux/priority_queue.h b/include/linux/priority_queue.h
new file mode 100644
index 000000000000..08177517977f
--- /dev/null
+++ b/include/linux/priority_queue.h
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  A priority queue implementation based on rbtree
+ *
+ *   Copyright (C) 2021, Bytedance, Cong Wang <cong.wang@bytedance.com>
+ */
+
+#ifndef	_LINUX_PRIORITY_QUEUE_H
+#define	_LINUX_PRIORITY_QUEUE_H
+
+#include <linux/rbtree.h>
+
+struct pq_node {
+	struct rb_node rb_node;
+};
+
+struct pq_root {
+	struct rb_root_cached rb_root;
+	bool (*cmp)(struct pq_node *l, struct pq_node *r);
+};
+
+static inline void pq_root_init(struct pq_root *root,
+				bool (*cmp)(struct pq_node *l, struct pq_node *r))
+{
+	root->rb_root = RB_ROOT_CACHED;
+	root->cmp = cmp;
+}
+
+static inline void pq_push(struct pq_root *root, struct pq_node *node)
+{
+	struct rb_node **link = &root->rb_root.rb_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct pq_node *entry;
+	bool leftmost = true;
+
+	/*
+	 * Find the right place in the rbtree:
+	 */
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct pq_node, rb_node);
+		/*
+		 * We dont care about collisions. Nodes with
+		 * the same key stay together.
+		 */
+		if (root->cmp(entry, node)) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = false;
+		}
+	}
+
+	rb_link_node(&node->rb_node, parent, link);
+	rb_insert_color_cached(&node->rb_node, &root->rb_root, leftmost);
+}
+
+static inline struct pq_node *pq_top(struct pq_root *root)
+{
+	struct rb_node *left = rb_first_cached(&root->rb_root);
+
+	if (!left)
+		return NULL;
+	return rb_entry(left, struct pq_node, rb_node);
+}
+
+static inline struct pq_node *pq_pop(struct pq_root *root)
+{
+	struct pq_node *t = pq_top(root);
+
+	if (t)
+		rb_erase_cached(&t->rb_node, &root->rb_root);
+	return t;
+}
+
+static inline void pq_flush(struct pq_root *root, void (*destroy)(struct pq_node *))
+{
+	struct rb_node *node, *next;
+
+	for (node = rb_first(&root->rb_root.rb_root);
+	     next = node ? rb_next(node) : NULL, node != NULL;
+	     node = next) {
+		struct pq_node *pqe;
+
+		pqe = rb_entry(node, struct pq_node, rb_node);
+		if (destroy)
+			destroy(pqe);
+	}
+}
+#endif	/* _LINUX_PRIORITY_QUEUE_H */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6bdb0db3e825..800d76e480da 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -36,6 +36,7 @@
 #include <linux/splice.h>
 #include <linux/in6.h>
 #include <linux/if_packet.h>
+#include <linux/priority_queue.h>
 #include <net/flow.h>
 #include <net/page_pool.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -735,6 +736,7 @@ struct sk_buff {
 			};
 		};
 		struct rb_node		rbnode; /* used in netem, ip4 defrag, and tcp stack */
+		struct pq_node		pqnode; /* used in ebpf qdisc */
 		struct list_head	list;
 	};
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 51cfd91cc387..2cbab321885b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -949,6 +949,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_SCHED_QDISC,
 };
 
 enum bpf_attach_type {
@@ -6260,4 +6261,23 @@ enum {
 	BTF_F_ZERO	=	(1ULL << 3),
 };
 
+struct sch_bpf_ctx {
+	/* Input */
+	struct __sk_buff *skb;
+	__u32 nr_flows;
+	__u32 handle;
+
+	/* Output */
+	__u64 rank;
+	__u64 delay;
+	__u32 classid;
+};
+
+enum {
+	SCH_BPF_OK,
+	SCH_BPF_REQUEUE,
+	SCH_BPF_DROP,
+	SCH_BPF_THROTTLE,
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 79a699f106b1..d9cc1989ab36 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1263,4 +1263,19 @@ enum {
 
 #define TCA_ETS_MAX (__TCA_ETS_MAX - 1)
 
+enum {
+	TCA_SCH_BPF_UNSPEC,
+	TCA_SCH_BPF_ENQUEUE_PROG_NAME,	/* string */
+	TCA_SCH_BPF_ENQUEUE_PROG_FD,	/* u32 */
+	TCA_SCH_BPF_ENQUEUE_PROG_ID,	/* u32 */
+	TCA_SCH_BPF_ENQUEUE_PROG_TAG,	/* data */
+	TCA_SCH_BPF_DEQUEUE_PROG_NAME,	/* string */
+	TCA_SCH_BPF_DEQUEUE_PROG_FD,	/* u32 */
+	TCA_SCH_BPF_DEQUEUE_PROG_ID,	/* u32 */
+	TCA_SCH_BPF_DEQUEUE_PROG_TAG,	/* data */
+	__TCA_SCH_BPF_MAX,
+};
+
+#define TCA_SCH_BPF_MAX (__TCA_SCH_BPF_MAX - 1)
+
 #endif
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 1e8ab4749c6c..19f68aac79b1 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -439,6 +439,21 @@ config NET_SCH_ETS
 
 	  If unsure, say N.
 
+config NET_SCH_BPF
+	tristate "eBPF based programmable queue discipline"
+	help
+	  This eBPF based queue discipline offers a way to program your
+	  own packet scheduling algorithm. This is a classful qdisc which
+	  also allows you to decide the hierarchy.
+
+	  Say Y here if you want to use the eBPF based programmable queue
+	  discipline.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sch_bpf.
+
+	  If unsure, say N.
+
 menuconfig NET_SCH_DEFAULT
 	bool "Allow override default queue discipline"
 	help
diff --git a/net/sched/Makefile b/net/sched/Makefile
index dd14ef413fda..9ef0d579f5ff 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_NET_SCH_FQ_PIE)	+= sch_fq_pie.o
 obj-$(CONFIG_NET_SCH_CBS)	+= sch_cbs.o
 obj-$(CONFIG_NET_SCH_ETF)	+= sch_etf.o
 obj-$(CONFIG_NET_SCH_TAPRIO)	+= sch_taprio.o
+obj-$(CONFIG_NET_SCH_BPF)	+= sch_bpf.o
 
 obj-$(CONFIG_NET_CLS_U32)	+= cls_u32.o
 obj-$(CONFIG_NET_CLS_ROUTE4)	+= cls_route.o
diff --git a/net/sched/sch_bpf.c b/net/sched/sch_bpf.c
new file mode 100644
index 000000000000..ba5ca247fa40
--- /dev/null
+++ b/net/sched/sch_bpf.c
@@ -0,0 +1,609 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Programmable Qdisc with eBPF
+ *
+ * Copyright (C) 2021, Bytedance, Cong Wang <cong.wang@bytedance.com>
+ */
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/jiffies.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/filter.h>
+#include <linux/bpf.h>
+#include <linux/priority_queue.h>
+#include <net/netlink.h>
+#include <net/pkt_sched.h>
+#include <net/pkt_cls.h>
+
+#define ACT_BPF_NAME_LEN	256
+
+struct sch_bpf_prog {
+	struct bpf_prog *prog;
+	const char *name;
+};
+
+struct sch_bpf_class {
+	struct Qdisc_class_common common;
+	struct Qdisc *qdisc;
+	struct pq_node node;
+	struct pq_root pq;
+
+	u32 rank;
+	unsigned int drops;
+	unsigned int overlimits;
+	struct gnet_stats_basic_packed bstats;
+};
+
+struct sch_bpf_qdisc {
+	struct tcf_proto __rcu *filter_list; /* optional external classifier */
+	struct tcf_block *block;
+	struct Qdisc_class_hash clhash;
+	struct sch_bpf_prog enqueue_prog;
+	struct sch_bpf_prog dequeue_prog;
+
+	struct pq_root flows;
+	struct qdisc_watchdog watchdog;
+};
+
+struct sch_bpf_skb_cb {
+	u64 rank;
+};
+
+static struct sch_bpf_skb_cb *sch_bpf_skb_cb(struct sk_buff *skb)
+{
+	qdisc_cb_private_validate(skb, sizeof(struct sch_bpf_skb_cb));
+	return (struct sch_bpf_skb_cb *)qdisc_skb_cb(skb)->data;
+}
+
+static int sch_bpf_dump_prog(const struct sch_bpf_prog *prog, struct sk_buff *skb,
+			     int name, int id, int tag)
+{
+	struct nlattr *nla;
+
+	if (prog->name &&
+	    nla_put_string(skb, name, prog->name))
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, id, prog->prog->aux->id))
+		return -EMSGSIZE;
+
+	nla = nla_reserve(skb, tag, sizeof(prog->prog->tag));
+	if (!nla)
+		return -EMSGSIZE;
+
+	memcpy(nla_data(nla), prog->prog->tag, nla_len(nla));
+	return 0;
+}
+
+static int sch_bpf_dump(struct Qdisc *sch, struct sk_buff *skb)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+	struct nlattr *opts;
+
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
+	if (!opts)
+		goto nla_put_failure;
+
+	if (sch_bpf_dump_prog(&q->enqueue_prog, skb, TCA_SCH_BPF_ENQUEUE_PROG_NAME,
+			      TCA_SCH_BPF_ENQUEUE_PROG_ID, TCA_SCH_BPF_ENQUEUE_PROG_TAG))
+		goto nla_put_failure;
+	if (sch_bpf_dump_prog(&q->dequeue_prog, skb, TCA_SCH_BPF_DEQUEUE_PROG_NAME,
+			      TCA_SCH_BPF_DEQUEUE_PROG_ID, TCA_SCH_BPF_DEQUEUE_PROG_TAG))
+		goto nla_put_failure;
+
+	return nla_nest_end(skb, opts);
+
+nla_put_failure:
+	return -1;
+}
+
+static int sch_bpf_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
+{
+	return 0;
+}
+
+static struct sch_bpf_class *sch_bpf_find(struct Qdisc *sch, u32 classid)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+	struct Qdisc_class_common *clc;
+
+	clc = qdisc_class_find(&q->clhash, classid);
+	if (!clc)
+		return NULL;
+	return container_of(clc, struct sch_bpf_class, common);
+}
+
+static struct sch_bpf_class *sch_bpf_classify(struct sk_buff *skb,
+					      struct Qdisc *sch, int *qerr)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+	struct sch_bpf_class *cl = NULL;
+	struct tcf_proto *tcf;
+	struct tcf_result res;
+	int result;
+
+	tcf = rcu_dereference_bh(q->filter_list);
+	if (!tcf)
+		return NULL;
+	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
+	result = tcf_classify(skb, NULL, tcf, &res, false);
+	if (result  >= 0) {
+#ifdef CONFIG_NET_CLS_ACT
+		switch (result) {
+		case TC_ACT_QUEUED:
+		case TC_ACT_STOLEN:
+		case TC_ACT_TRAP:
+			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
+			fallthrough;
+		case TC_ACT_SHOT:
+			return NULL;
+		}
+#endif
+		cl = (void *)res.class;
+		if (!cl) {
+			cl = sch_bpf_find(sch, res.classid);
+			if (!cl)
+				return NULL;
+		}
+	}
+
+	return cl;
+}
+
+static int sch_bpf_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+			   struct sk_buff **to_free)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+	unsigned int len = qdisc_pkt_len(skb);
+	struct sch_bpf_ctx ctx = {};
+	struct sch_bpf_class *cl;
+	int res = NET_XMIT_SUCCESS;
+
+	cl = sch_bpf_classify(skb, sch, &res);
+	if (!cl) {
+		struct bpf_prog *enqueue;
+
+		enqueue = rcu_dereference(q->enqueue_prog.prog);
+		bpf_compute_data_pointers(skb);
+
+		ctx.skb = (struct __sk_buff *)skb;
+		ctx.nr_flows = q->clhash.hashelems;
+		ctx.handle = sch->handle;
+		res = bpf_prog_run(enqueue, &ctx);
+		switch (res) {
+		case SCH_BPF_DROP:
+			__qdisc_drop(skb, to_free);
+			return NET_XMIT_DROP;
+		}
+		cl = sch_bpf_find(sch, ctx.classid);
+		if (!cl) {
+			if (res & __NET_XMIT_BYPASS)
+				qdisc_qstats_drop(sch);
+			__qdisc_drop(skb, to_free);
+			return res;
+		}
+	}
+
+	if (cl->qdisc) {
+		res = qdisc_enqueue(skb, cl->qdisc, to_free);
+		if (res != NET_XMIT_SUCCESS) {
+			if (net_xmit_drop_count(res)) {
+				qdisc_qstats_drop(sch);
+				cl->drops++;
+			}
+			return res;
+		}
+	} else {
+		sch_bpf_skb_cb(skb)->rank = ctx.rank;
+		pq_push(&cl->pq, &skb->pqnode);
+	}
+
+	sch->qstats.backlog += len;
+	sch->q.qlen++;
+	return res;
+}
+
+static struct sk_buff *sch_bpf_dequeue(struct Qdisc *sch)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+	struct sk_buff *skb, *ret = NULL;
+	struct sch_bpf_ctx ctx = {};
+	struct bpf_prog *dequeue;
+	struct sch_bpf_class *cl;
+	struct pq_node *flow;
+	s64 now;
+	int res;
+
+requeue:
+	flow = pq_pop(&q->flows);
+	if (!flow)
+		return NULL;
+
+	cl = container_of(flow, struct sch_bpf_class, node);
+	if (cl->qdisc) {
+		skb = cl->qdisc->dequeue(cl->qdisc);
+		ctx.classid = cl->common.classid;
+	} else {
+		struct pq_node *p = pq_pop(&cl->pq);
+
+		if (!p)
+			return NULL;
+		skb = container_of(p, struct sk_buff, pqnode);
+		ctx.classid = cl->rank;
+	}
+	ctx.skb = (struct __sk_buff *) skb;
+	ctx.handle = sch->handle;
+	ctx.nr_flows = q->clhash.hashelems;
+
+	dequeue = rcu_dereference(q->dequeue_prog.prog);
+	bpf_compute_data_pointers(skb);
+	res = bpf_prog_run(dequeue, &ctx);
+	switch (res) {
+	case SCH_BPF_OK:
+		ret = skb;
+		break;
+	case SCH_BPF_REQUEUE:
+		sch_bpf_skb_cb(skb)->rank = ctx.rank;
+		cl->rank = ctx.classid;
+		pq_push(&cl->pq, &skb->pqnode);
+		bstats_update(&cl->bstats, skb);
+		pq_push(&q->flows, &cl->node);
+		goto requeue;
+	case SCH_BPF_THROTTLE:
+		now = ktime_get_ns();
+		qdisc_watchdog_schedule_ns(&q->watchdog, now + ctx.delay);
+		qdisc_qstats_overlimit(sch);
+		cl->overlimits++;
+		return NULL;
+	default:
+		kfree_skb(skb);
+		ret = NULL;
+	}
+
+	if (pq_top(&cl->pq))
+		pq_push(&q->flows, &cl->node);
+	return ret;
+}
+
+static struct sk_buff *sch_bpf_peek(struct Qdisc *sch)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+	struct pq_node *node = pq_top(&q->flows);
+	struct sch_bpf_class *cl;
+	struct sk_buff *skb;
+
+	if (!node)
+		return NULL;
+	cl = container_of(node, struct sch_bpf_class, node);
+	node = pq_top(&cl->pq);
+	if (!node)
+		return NULL;
+	skb = container_of(node, struct sk_buff, pqnode);
+	return skb;
+}
+
+static struct Qdisc *sch_bpf_leaf(struct Qdisc *sch, unsigned long arg)
+{
+	struct sch_bpf_class *cl = (struct sch_bpf_class *)arg;
+
+	return cl->qdisc;
+}
+
+static int sch_bpf_graft(struct Qdisc *sch, unsigned long arg, struct Qdisc *new,
+			 struct Qdisc **old, struct netlink_ext_ack *extack)
+{
+	struct sch_bpf_class *cl = (struct sch_bpf_class *)arg;
+
+	if (new)
+		*old = qdisc_replace(sch, new, &cl->qdisc);
+	return 0;
+}
+
+static unsigned long sch_bpf_bind(struct Qdisc *sch, unsigned long parent,
+				  u32 classid)
+{
+	return 0;
+}
+
+static void sch_bpf_unbind(struct Qdisc *q, unsigned long cl)
+{
+}
+
+static unsigned long sch_bpf_search(struct Qdisc *sch, u32 handle)
+{
+	return (unsigned long)sch_bpf_find(sch, handle);
+}
+
+static struct tcf_block *sch_bpf_tcf_block(struct Qdisc *sch, unsigned long cl,
+					   struct netlink_ext_ack *extack)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+
+	if (cl)
+		return NULL;
+	return q->block;
+}
+
+static const struct nla_policy sch_bpf_policy[TCA_SCH_BPF_MAX + 1] = {
+	[TCA_SCH_BPF_ENQUEUE_PROG_FD]	= { .type = NLA_U32 },
+	[TCA_SCH_BPF_ENQUEUE_PROG_NAME]	= { .type = NLA_NUL_STRING,
+					    .len = ACT_BPF_NAME_LEN },
+	[TCA_SCH_BPF_DEQUEUE_PROG_FD]	= { .type = NLA_U32 },
+	[TCA_SCH_BPF_DEQUEUE_PROG_NAME]	= { .type = NLA_NUL_STRING,
+					    .len = ACT_BPF_NAME_LEN },
+};
+
+static int bpf_init_prog(struct nlattr *fd, struct nlattr *name, struct sch_bpf_prog *prog)
+{
+	char *prog_name = NULL;
+	struct bpf_prog *fp;
+	u32 bpf_fd;
+
+	if (!fd)
+		return -EINVAL;
+	bpf_fd = nla_get_u32(fd);
+
+	fp = bpf_prog_get_type(bpf_fd, BPF_PROG_TYPE_SCHED_QDISC);
+	if (IS_ERR(fp))
+		return PTR_ERR(fp);
+
+	if (name) {
+		prog_name = nla_memdup(name, GFP_KERNEL);
+		if (!prog_name) {
+			bpf_prog_put(fp);
+			return -ENOMEM;
+		}
+	}
+
+	prog->name = prog_name;
+	prog->prog = fp;
+	return 0;
+}
+
+static void bpf_cleanup_prog(struct sch_bpf_prog *prog)
+{
+	if (prog->prog)
+		bpf_prog_put(prog->prog);
+	kfree(prog->name);
+}
+
+static int sch_bpf_change(struct Qdisc *sch, struct nlattr *opt,
+			  struct netlink_ext_ack *extack)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+	struct nlattr *tb[TCA_SCH_BPF_MAX + 1];
+	int err;
+
+	if (!opt)
+		return -EINVAL;
+
+	err = nla_parse_nested_deprecated(tb, TCA_SCH_BPF_MAX, opt,
+					  sch_bpf_policy, NULL);
+	if (err < 0)
+		return err;
+
+	err = bpf_init_prog(tb[TCA_SCH_BPF_ENQUEUE_PROG_FD],
+			    tb[TCA_SCH_BPF_ENQUEUE_PROG_NAME], &q->enqueue_prog);
+	if (err)
+		return err;
+	err = bpf_init_prog(tb[TCA_SCH_BPF_DEQUEUE_PROG_FD],
+			    tb[TCA_SCH_BPF_DEQUEUE_PROG_NAME], &q->dequeue_prog);
+	return err;
+}
+
+static bool skb_rank(struct pq_node *l, struct pq_node *r)
+{
+	struct sk_buff *lskb, *rskb;
+
+	lskb = container_of(l, struct sk_buff, pqnode);
+	rskb = container_of(r, struct sk_buff, pqnode);
+
+	return sch_bpf_skb_cb(lskb)->rank < sch_bpf_skb_cb(rskb)->rank;
+}
+
+static void skb_flush(struct pq_node *n)
+{
+	struct sk_buff *skb = container_of(n, struct sk_buff, pqnode);
+
+	kfree_skb(skb);
+}
+
+static bool flow_rank(struct pq_node *l, struct pq_node *r)
+{
+	struct sch_bpf_class *lflow, *rflow;
+
+	lflow = container_of(l, struct sch_bpf_class, node);
+	rflow = container_of(r, struct sch_bpf_class, node);
+
+	return lflow->rank < rflow->rank;
+}
+
+static void flow_flush(struct pq_node *n)
+{
+	struct sch_bpf_class *cl = container_of(n, struct sch_bpf_class, node);
+
+	pq_flush(&cl->pq, skb_flush);
+}
+
+static int sch_bpf_init(struct Qdisc *sch, struct nlattr *opt,
+			struct netlink_ext_ack *extack)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+	int err;
+
+	qdisc_watchdog_init(&q->watchdog, sch);
+	if (opt) {
+		err = sch_bpf_change(sch, opt, extack);
+		if (err)
+			return err;
+	}
+
+	err = tcf_block_get(&q->block, &q->filter_list, sch, extack);
+	if (err)
+		return err;
+
+	pq_root_init(&q->flows, flow_rank);
+	return qdisc_class_hash_init(&q->clhash);
+}
+
+static void sch_bpf_reset(struct Qdisc *sch)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+
+	qdisc_watchdog_cancel(&q->watchdog);
+	pq_flush(&q->flows, flow_flush);
+}
+
+static void sch_bpf_destroy(struct Qdisc *sch)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+
+	qdisc_watchdog_cancel(&q->watchdog);
+	tcf_block_put(q->block);
+	qdisc_class_hash_destroy(&q->clhash);
+	sch_bpf_reset(sch);
+	bpf_cleanup_prog(&q->enqueue_prog);
+	bpf_cleanup_prog(&q->dequeue_prog);
+}
+
+static int sch_bpf_change_class(struct Qdisc *sch, u32 classid,
+				u32 parentid, struct nlattr **tca,
+				unsigned long *arg,
+				struct netlink_ext_ack *extack)
+{
+	struct sch_bpf_class *cl = (struct sch_bpf_class *)*arg;
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+
+	if (!cl) {
+		cl = kzalloc(sizeof(*cl), GFP_KERNEL);
+		if (!cl)
+			return -ENOBUFS;
+		cl->rank = classid;
+		pq_root_init(&cl->pq, skb_rank);
+		qdisc_class_hash_insert(&q->clhash, &cl->common);
+	}
+
+	qdisc_class_hash_grow(sch, &q->clhash);
+	*arg = (unsigned long)cl;
+	return 0;
+}
+
+static int sch_bpf_delete(struct Qdisc *sch, unsigned long arg,
+			  struct netlink_ext_ack *extack)
+{
+	struct sch_bpf_class *cl = (struct sch_bpf_class *)arg;
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+
+	qdisc_class_hash_remove(&q->clhash, &cl->common);
+	if (cl->qdisc)
+		qdisc_put(cl->qdisc);
+	else
+		pq_flush(&cl->pq, skb_flush);
+	return 0;
+}
+
+static int sch_bpf_dump_class(struct Qdisc *sch, unsigned long arg,
+			      struct sk_buff *skb, struct tcmsg *tcm)
+{
+	struct sch_bpf_class *cl = (struct sch_bpf_class *)arg;
+
+	tcm->tcm_handle |= TC_H_MIN(cl->rank);
+	return 0;
+}
+
+static int
+sch_bpf_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
+{
+	struct sch_bpf_class *cl = (struct sch_bpf_class *)arg;
+	struct gnet_stats_queue qs = {
+		.drops = cl->drops,
+		.overlimits = cl->overlimits,
+	};
+	__u32 qlen = 0;
+
+	if (cl->qdisc)
+		qdisc_qstats_qlen_backlog(cl->qdisc, &qlen, &qs.backlog);
+	else
+		qlen = 0;
+
+	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
+				  d, NULL, &cl->bstats) < 0 ||
+	    gnet_stats_copy_queue(d, NULL, &qs, qlen) < 0)
+		return -1;
+	return 0;
+}
+
+static void sch_bpf_walk(struct Qdisc *sch, struct qdisc_walker *arg)
+{
+	struct sch_bpf_qdisc *q = qdisc_priv(sch);
+	struct sch_bpf_class *cl;
+	unsigned int i;
+
+	if (arg->stop)
+		return;
+
+	for (i = 0; i < q->clhash.hashsize; i++) {
+		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
+			if (arg->count < arg->skip) {
+				arg->count++;
+				continue;
+			}
+			if (arg->fn(sch, (unsigned long)cl, arg) < 0) {
+				arg->stop = 1;
+				return;
+			}
+			arg->count++;
+		}
+	}
+}
+
+static const struct Qdisc_class_ops sch_bpf_class_ops = {
+	.graft		=	sch_bpf_graft,
+	.leaf		=	sch_bpf_leaf,
+	.find		=	sch_bpf_search,
+	.change		=	sch_bpf_change_class,
+	.delete		=	sch_bpf_delete,
+	.tcf_block	=	sch_bpf_tcf_block,
+	.bind_tcf	=	sch_bpf_bind,
+	.unbind_tcf	=	sch_bpf_unbind,
+	.dump		=	sch_bpf_dump_class,
+	.dump_stats	=	sch_bpf_dump_class_stats,
+	.walk		=	sch_bpf_walk,
+};
+
+static struct Qdisc_ops sch_bpf_qdisc_ops __read_mostly = {
+	.cl_ops		=	&sch_bpf_class_ops,
+	.id		=	"bpf",
+	.priv_size	=	sizeof(struct sch_bpf_qdisc),
+	.enqueue	=	sch_bpf_enqueue,
+	.dequeue	=	sch_bpf_dequeue,
+	.peek		=	sch_bpf_peek,
+	.init		=	sch_bpf_init,
+	.reset		=	sch_bpf_reset,
+	.destroy	=	sch_bpf_destroy,
+	.change		=	sch_bpf_change,
+	.dump		=	sch_bpf_dump,
+	.dump_stats	=	sch_bpf_dump_stats,
+	.owner		=	THIS_MODULE,
+};
+
+static int __init sch_bpf_mod_init(void)
+{
+	return register_qdisc(&sch_bpf_qdisc_ops);
+}
+
+static void __exit sch_bpf_mod_exit(void)
+{
+	unregister_qdisc(&sch_bpf_qdisc_ops);
+}
+
+module_init(sch_bpf_mod_init)
+module_exit(sch_bpf_mod_exit)
+MODULE_AUTHOR("Cong Wang");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("eBPF queue discipline");
