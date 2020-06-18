Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D611FFDC9
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgFRWQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:16:19 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36863 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728186AbgFRWQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:16:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from lariel@mellanox.com)
        with SMTP; 19 Jun 2020 01:16:11 +0300
Received: from gen-l-vrt-029.mtl.labs.mlnx (gen-l-vrt-029.mtl.labs.mlnx [10.237.29.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 05IMG9Ge012581;
        Fri, 19 Jun 2020 01:16:10 +0300
From:   Ariel Levkovich <lariel@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Ariel Levkovich <lariel@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 1/3] net/sched: Introduce action hash
Date:   Fri, 19 Jun 2020 01:15:46 +0300
Message-Id: <20200618221548.3805-2-lariel@mellanox.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200618221548.3805-1-lariel@mellanox.com>
References: <20200618221548.3805-1-lariel@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow setting a hash value to a packet for a future match.

The action will determine the packet's hash result according to
the selected hash type.

The first option is to select a basic asymmetric l4 hash calculation
on the packet headers which will either use the skb->hash value as
if such was already calculated and set by the device driver, or it
will perform the kernel jenkins hash function on the packet which will
generate the result otherwise.

The other option is for user to provide an BPF program which is
dedicated to calculate the hash. In such case the program is loaded
and used by tc to perform the hash calculation and provide it to
the hash action to be stored in skb->hash field.

The BPF option can be useful for future HW offload support of the hash
calculation by emulating the HW hash function when it's different than
the kernel's but yet we want to maintain consistency between the SW and
the HW.

Usage is as follows:

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 0 proto ip \
flower ip_proto tcp \
action hash bpf object-file <bpf file> \
action goto chain 2

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 0 proto ip \
flower ip_proto udp \
action hash asym_l4 basis <basis> \
action goto chain 2

Matching on the result:
$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 2 proto ip \
flower hash 0x0/0xf  \
action mirred egress redirect dev ens1f0_1

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 2 proto ip \
flower hash 0x1/0xf  \
action mirred egress redirect dev ens1f0_2

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/act_api.h               |   2 +
 include/net/tc_act/tc_hash.h        |  22 ++
 include/uapi/linux/pkt_cls.h        |   1 +
 include/uapi/linux/tc_act/tc_hash.h |  32 +++
 net/sched/Kconfig                   |  11 +
 net/sched/Makefile                  |   1 +
 net/sched/act_hash.c                | 376 ++++++++++++++++++++++++++++
 net/sched/cls_api.c                 |   1 +
 8 files changed, 446 insertions(+)
 create mode 100644 include/net/tc_act/tc_hash.h
 create mode 100644 include/uapi/linux/tc_act/tc_hash.h
 create mode 100644 net/sched/act_hash.c

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 8c3934880670..b7e5d060bd2f 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -12,6 +12,8 @@
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
+#define ACT_BPF_NAME_LEN	256
+
 struct tcf_idrinfo {
 	struct mutex	lock;
 	struct idr	action_idr;
diff --git a/include/net/tc_act/tc_hash.h b/include/net/tc_act/tc_hash.h
new file mode 100644
index 000000000000..f03bb19709e5
--- /dev/null
+++ b/include/net/tc_act/tc_hash.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef __NET_TC_HASH_H
+#define __NET_TC_HASH_H
+
+#include <net/act_api.h>
+#include <uapi/linux/tc_act/tc_hash.h>
+
+struct tcf_hash_params {
+	enum tc_hash_alg alg;
+	u32 basis;
+	struct bpf_prog	*prog;
+	const char *bpf_name;
+	struct rcu_head	rcu;
+};
+
+struct tcf_hash {
+	struct tc_action common;
+	struct tcf_hash_params __rcu *hash_p;
+};
+#define to_hash(a) ((struct tcf_hash *)a)
+
+#endif /* __NET_TC_HASH_H */
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 7576209d96f9..2fd93389d091 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -135,6 +135,7 @@ enum tca_id {
 	TCA_ID_MPLS,
 	TCA_ID_CT,
 	TCA_ID_GATE,
+	TCA_ID_HASH,
 	/* other actions go here */
 	__TCA_ID_MAX = 255
 };
diff --git a/include/uapi/linux/tc_act/tc_hash.h b/include/uapi/linux/tc_act/tc_hash.h
new file mode 100644
index 000000000000..ff3063f70ee0
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_hash.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef __LINUX_TC_HASH_H
+#define __LINUX_TC_HASH_H
+
+#include <linux/pkt_cls.h>
+
+enum tc_hash_alg {
+	TCA_HASH_ALG_L4,
+	TCA_HASH_ALG_BPF,
+};
+
+enum {
+	TCA_HASH_UNSPEC,
+	TCA_HASH_TM,
+	TCA_HASH_PARMS,
+	TCA_HASH_ALG,
+	TCA_HASH_BASIS,
+	TCA_HASH_BPF_FD,
+	TCA_HASH_BPF_NAME,
+	TCA_HASH_BPF_ID,
+	TCA_HASH_BPF_TAG,
+	TCA_HASH_PAD,
+	__TCA_HASH_MAX,
+};
+#define TCA_HASH_MAX (__TCA_HASH_MAX - 1)
+
+struct tc_hash {
+	tc_gen;
+};
+
+#endif
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 84badf00647e..e9725bb40f4f 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -993,6 +993,17 @@ config NET_ACT_GATE
 	  To compile this code as a module, choose M here: the
 	  module will be called act_gate.
 
+config NET_ACT_HASH
+	tristate "Hash calculation action"
+	depends on NET_CLS_ACT
+	help
+	  Say Y here to perform hash calculation on packet headers.
+
+	  If unsure, say N.
+
+	  To compile this code as a module, choose M here: the
+	  module will be called act_hash.
+
 config NET_IFE_SKBMARK
 	tristate "Support to encoding decoding skb mark on IFE action"
 	depends on NET_ACT_IFE
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 66bbf9a98f9e..2d1415fb57db 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_NET_ACT_CONNMARK)	+= act_connmark.o
 obj-$(CONFIG_NET_ACT_CTINFO)	+= act_ctinfo.o
 obj-$(CONFIG_NET_ACT_SKBMOD)	+= act_skbmod.o
 obj-$(CONFIG_NET_ACT_IFE)	+= act_ife.o
+obj-$(CONFIG_NET_ACT_HASH)      += act_hash.o
 obj-$(CONFIG_NET_IFE_SKBMARK)	+= act_meta_mark.o
 obj-$(CONFIG_NET_IFE_SKBPRIO)	+= act_meta_skbprio.o
 obj-$(CONFIG_NET_IFE_SKBTCINDEX)	+= act_meta_skbtcindex.o
diff --git a/net/sched/act_hash.c b/net/sched/act_hash.c
new file mode 100644
index 000000000000..40a5c34f8745
--- /dev/null
+++ b/net/sched/act_hash.c
@@ -0,0 +1,376 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* -
+ * net/sched/act_hash.c  Hash calculation action
+ *
+ * Author:   Ariel Levkovich <lariel@mellanox.com>
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rtnetlink.h>
+#include <linux/skbuff.h>
+#include <linux/filter.h>
+#include <net/netlink.h>
+#include <net/pkt_sched.h>
+#include <net/pkt_cls.h>
+#include <linux/tc_act/tc_hash.h>
+#include <net/tc_act/tc_hash.h>
+
+#define ACT_HASH_BPF_NAME_LEN	256
+
+static unsigned int hash_net_id;
+static struct tc_action_ops act_hash_ops;
+
+static int tcf_hash_act(struct sk_buff *skb, const struct tc_action *a,
+			struct tcf_result *res)
+{
+	struct tcf_hash *h = to_hash(a);
+	struct tcf_hash_params *p;
+	int action;
+	u32 hash;
+
+	tcf_lastuse_update(&h->tcf_tm);
+	tcf_action_update_bstats(&h->common, skb);
+
+	p = rcu_dereference_bh(h->hash_p);
+
+	action = READ_ONCE(h->tcf_action);
+
+	switch (p->alg) {
+	case TCA_HASH_ALG_L4:
+		hash = skb_get_hash(skb);
+		/* If a hash basis was provided, add it into
+		 * hash calculation here and re-set skb->hash
+		 * to the new result with sw_hash indication
+		 * and keeping the l4 hash indication.
+		 */
+		hash = jhash_1word(hash, p->basis);
+		__skb_set_sw_hash(skb, hash, skb->l4_hash);
+		break;
+	case TCA_HASH_ALG_BPF:
+		__skb_push(skb, skb->mac_len);
+		bpf_compute_data_pointers(skb);
+		hash = BPF_PROG_RUN(p->prog, skb);
+		__skb_pull(skb, skb->mac_len);
+		/* The BPF program hash function type is
+		 * unknown so only the sw hash bit is set.
+		 */
+		__skb_set_sw_hash(skb, hash, false);
+		break;
+	}
+
+	return action;
+}
+
+static const struct nla_policy hash_policy[TCA_HASH_MAX + 1] = {
+	[TCA_HASH_PARMS]	= { .type = NLA_EXACT_LEN, .len = sizeof(struct tc_hash) },
+	[TCA_HASH_ALG]		= { .type = NLA_U32 },
+	[TCA_HASH_BASIS]	= { .type = NLA_U32 },
+	[TCA_HASH_BPF_FD]	= { .type = NLA_U32 },
+	[TCA_HASH_BPF_NAME]	= { .type = NLA_NUL_STRING,
+				    .len = ACT_HASH_BPF_NAME_LEN },
+};
+
+static int tcf_hash_bpf_init(struct nlattr **tb, struct tcf_hash_params *params)
+{
+	struct bpf_prog *fp;
+	char *name = NULL;
+	u32 bpf_fd;
+
+	bpf_fd = nla_get_u32(tb[TCA_HASH_BPF_FD]);
+
+	fp = bpf_prog_get_type(bpf_fd, BPF_PROG_TYPE_SCHED_ACT);
+	if (IS_ERR(fp))
+		return PTR_ERR(fp);
+
+	if (tb[TCA_HASH_BPF_NAME]) {
+		name = nla_memdup(tb[TCA_HASH_BPF_NAME], GFP_KERNEL);
+		if (!name) {
+			bpf_prog_put(fp);
+			return -ENOMEM;
+		}
+	}
+
+	params->bpf_name = name;
+	params->prog = fp;
+
+	return 0;
+}
+
+static void tcf_hash_bpf_cleanup(struct tcf_hash_params *params)
+{
+	if (params->prog)
+		bpf_prog_put(params->prog);
+
+	kfree(params->bpf_name);
+}
+
+static int tcf_hash_init(struct net *net, struct nlattr *nla,
+			 struct nlattr *est, struct tc_action **a,
+			 int replace, int bind, bool rtnl_held,
+			 struct tcf_proto *tp, u32 flags,
+			 struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, hash_net_id);
+	struct tcf_hash_params *params, old;
+	struct nlattr *tb[TCA_HASH_MAX + 1];
+	struct tcf_chain *goto_ch = NULL;
+	struct tcf_hash_params *p = NULL;
+	struct tc_hash *parm;
+	struct tcf_hash *h;
+	int err, res = 0;
+	u32 index;
+
+	if (!nla) {
+		NL_SET_ERR_MSG_MOD(extack, "Hash requires attributes to be passed");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, TCA_HASH_MAX, nla, hash_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_HASH_PARMS]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing required hash parameters");
+		return -EINVAL;
+	}
+	parm = nla_data(tb[TCA_HASH_PARMS]);
+	index = parm->index;
+
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
+	if (err < 0)
+		return err;
+
+	if (!err) {
+		err = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_hash_ops, bind, flags);
+		if (err) {
+			tcf_idr_cleanup(tn, index);
+			return err;
+		}
+		res = ACT_P_CREATED;
+	} else {
+		if (bind)
+			return 0;
+
+		if (!replace) {
+			tcf_idr_release(*a, bind);
+			return -EEXIST;
+		}
+	}
+	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
+	if (err < 0)
+		goto release_idr;
+
+	h = to_hash(*a);
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (unlikely(!p)) {
+		err = -ENOMEM;
+		goto cleanup;
+	}
+
+	if (!tb[TCA_HASH_ALG]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing hash algorithm selection");
+		err = -EINVAL;
+		goto cleanup;
+	}
+
+	p->alg = nla_get_u32(tb[TCA_HASH_ALG]);
+
+	spin_lock_bh(&h->tcf_lock);
+
+	switch (p->alg) {
+	case TCA_HASH_ALG_L4:
+		break;
+	case TCA_HASH_ALG_BPF:
+		if (res != ACT_P_CREATED) {
+			params = rcu_dereference_protected(h->hash_p, 1);
+			old.prog = params->prog;
+			old.bpf_name = params->bpf_name;
+		}
+
+		err = tcf_hash_bpf_init(tb, p);
+		if (err)
+			goto cleanup;
+
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Hash type not supported");
+		err = -EINVAL;
+		goto cleanup;
+	}
+
+	if (tb[TCA_HASH_BASIS])
+		p->basis = nla_get_u32(tb[TCA_HASH_BASIS]);
+
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	p = rcu_replace_pointer(h->hash_p, p,
+				lockdep_is_held(&h->tcf_lock));
+	spin_unlock_bh(&h->tcf_lock);
+
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+	if (p)
+		kfree_rcu(p, rcu);
+
+	if (res == ACT_P_CREATED) {
+		tcf_idr_insert(tn, *a);
+	} else {
+		synchronize_rcu();
+		tcf_hash_bpf_cleanup(&old);
+	}
+
+	return res;
+
+cleanup:
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+	kfree(p);
+
+release_idr:
+	tcf_idr_release(*a, bind);
+	return err;
+}
+
+static void tcf_hash_cleanup(struct tc_action *a)
+{
+	struct tcf_hash *h = to_hash(a);
+	struct tcf_hash_params *p;
+
+	p = rcu_dereference_protected(h->hash_p, 1);
+	if (p) {
+		tcf_hash_bpf_cleanup(p);
+		kfree_rcu(p, rcu);
+	}
+}
+
+static int tcf_hash_dump(struct sk_buff *skb, struct tc_action *a,
+			 int bind, int ref)
+{
+	unsigned char *tp = skb_tail_pointer(skb);
+	struct tcf_hash *h = to_hash(a);
+	struct tcf_hash_params *p;
+	struct tc_hash opt = {
+		.index    = h->tcf_index,
+		.refcnt   = refcount_read(&h->tcf_refcnt) - ref,
+		.bindcnt  = atomic_read(&h->tcf_bindcnt) - bind,
+	};
+	struct nlattr *nla;
+	struct tcf_t tm;
+
+	spin_lock_bh(&h->tcf_lock);
+	opt.action = h->tcf_action;
+	p = rcu_dereference_protected(h->hash_p, lockdep_is_held(&h->tcf_lock));
+
+	if (nla_put(skb, TCA_HASH_PARMS, sizeof(opt), &opt))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, TCA_HASH_ALG, p->alg))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, TCA_HASH_BASIS, p->basis))
+		goto nla_put_failure;
+
+	if (p->alg == TCA_HASH_ALG_BPF && p->bpf_name) {
+		if (nla_put_string(skb, TCA_HASH_BPF_NAME, p->bpf_name))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, TCA_HASH_BPF_ID, p->prog->aux->id))
+			goto nla_put_failure;
+		nla = nla_reserve(skb, TCA_HASH_BPF_TAG, sizeof(p->prog->tag));
+		if (!nla)
+			goto nla_put_failure;
+
+		memcpy(nla_data(nla), p->prog->tag, nla_len(nla));
+	}
+
+	tcf_tm_dump(&tm, &h->tcf_tm);
+	if (nla_put_64bit(skb, TCA_HASH_TM, sizeof(tm), &tm,
+			  TCA_HASH_PAD))
+		goto nla_put_failure;
+
+	spin_unlock_bh(&h->tcf_lock);
+	return skb->len;
+
+nla_put_failure:
+	spin_unlock_bh(&h->tcf_lock);
+	nlmsg_trim(skb, tp);
+	return -1;
+}
+
+static int tcf_hash_walker(struct net *net, struct sk_buff *skb,
+			   struct netlink_callback *cb, int type,
+			   const struct tc_action_ops *ops,
+			   struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, hash_net_id);
+
+	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
+}
+
+static int tcf_hash_search(struct net *net, struct tc_action **a, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, hash_net_id);
+
+	return tcf_idr_search(tn, a, index);
+}
+
+static void tcf_hash_stats_update(struct tc_action *a, u64 bytes, u32 packets,
+				  u64 lastuse, bool hw)
+{
+	struct tcf_hash *h = to_hash(a);
+
+	tcf_action_update_stats(a, bytes, packets, false, hw);
+	h->tcf_tm.lastuse = max_t(u64, h->tcf_tm.lastuse, lastuse);
+}
+
+static struct tc_action_ops act_hash_ops = {
+	.kind		=       "hash",
+	.id		=       TCA_ID_HASH,
+	.owner		=       THIS_MODULE,
+	.act		=       tcf_hash_act,
+	.dump		=       tcf_hash_dump,
+	.init		=       tcf_hash_init,
+	.cleanup	=       tcf_hash_cleanup,
+	.walk		=       tcf_hash_walker,
+	.lookup		=       tcf_hash_search,
+	.stats_update	=       tcf_hash_stats_update,
+	.size		=       sizeof(struct tcf_hash),
+};
+
+static __net_init int hash_init_net(struct net *net)
+{
+	struct tc_action_net *tn = net_generic(net, hash_net_id);
+
+	return tc_action_net_init(net, tn, &act_hash_ops);
+}
+
+static void __net_exit hash_exit_net(struct list_head *net_list)
+{
+	tc_action_net_exit(net_list, hash_net_id);
+}
+
+static struct pernet_operations hash_net_ops = {
+	.init = hash_init_net,
+	.exit_batch = hash_exit_net,
+	.id = &hash_net_id,
+	.size = sizeof(struct tc_action_net),
+};
+
+static int __init hash_init_module(void)
+{
+	return tcf_register_action(&act_hash_ops, &hash_net_ops);
+}
+
+static void __exit hash_cleanup_module(void)
+{
+	tcf_unregister_action(&act_hash_ops, &hash_net_ops);
+}
+
+module_init(hash_init_module);
+module_exit(hash_cleanup_module);
+
+MODULE_AUTHOR("Ariel Levkovich <lariel@mellanox.com>");
+MODULE_DESCRIPTION("Packet hash action");
+MODULE_LICENSE("GPL v2");
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a00a203b2ef5..6d7eb249e557 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -40,6 +40,7 @@
 #include <net/tc_act/tc_ct.h>
 #include <net/tc_act/tc_mpls.h>
 #include <net/tc_act/tc_gate.h>
+#include <net/tc_act/tc_hash.h>
 #include <net/flow_offload.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
-- 
2.25.2

