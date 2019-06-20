Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E196B4DAA9
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfFTTuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:50:05 -0400
Received: from mail.us.es ([193.147.175.20]:54742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbfFTTuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:50:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F3C40B5ADB
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DFF89DA717
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DD351DA706; Thu, 20 Jun 2019 21:49:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7247BDA703;
        Thu, 20 Jun 2019 21:49:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 21:49:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2A21D4265A31;
        Thu, 20 Jun 2019 21:49:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: [PATCH net-next 12/12] netfilter: nf_tables: add hardware offload support
Date:   Thu, 20 Jun 2019 21:49:17 +0200
Message-Id: <20190620194917.2298-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190620194917.2298-1-pablo@netfilter.org>
References: <20190620194917.2298-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds hardware offload support for nftables through the
existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
classifier and the flow rule API. This hardware offload support is
available for the NFPROTO_NETDEV family and the ingress hook.

Each nftables expression has a new ->offload interface, that is used to
populate the flow rule object that is attached to the transaction
object.

There is a new per-table NFT_TABLE_F_HW flag, that is set on to offload
an entire table, including all of its chains.

This patch supports for basic metadata (layer 3 and 4 protocol numbers),
5-tuple payload matching and the accept/drop actions; this also includes
basechain hardware offload only.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h         |  13 ++
 include/net/netfilter/nf_tables_offload.h |  76 ++++++++++
 include/uapi/linux/netfilter/nf_tables.h  |   2 +
 net/netfilter/Makefile                    |   2 +-
 net/netfilter/nf_tables_api.c             |  22 ++-
 net/netfilter/nf_tables_offload.c         | 233 ++++++++++++++++++++++++++++++
 net/netfilter/nft_cmp.c                   |  53 +++++++
 net/netfilter/nft_immediate.c             |  31 ++++
 net/netfilter/nft_meta.c                  |  27 ++++
 net/netfilter/nft_payload.c               | 187 ++++++++++++++++++++++++
 10 files changed, 643 insertions(+), 3 deletions(-)
 create mode 100644 include/net/netfilter/nf_tables_offload.h
 create mode 100644 net/netfilter/nf_tables_offload.c

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5b8624ae4a27..bcd14bc89b88 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -161,6 +161,7 @@ struct nft_ctx {
 	const struct nlattr * const 	*nla;
 	u32				portid;
 	u32				seq;
+	u16				flags;
 	u8				family;
 	u8				level;
 	bool				report;
@@ -735,6 +736,9 @@ enum nft_trans_phase {
 	NFT_TRANS_RELEASE
 };
 
+struct nft_flow_rule;
+struct nft_offload_ctx;
+
 /**
  *	struct nft_expr_ops - nf_tables expression operations
  *
@@ -777,6 +781,10 @@ struct nft_expr_ops {
 						    const struct nft_data **data);
 	bool				(*gc)(struct net *net,
 					      const struct nft_expr *expr);
+	int				(*offload)(struct nft_offload_ctx *ctx,
+						   struct nft_flow_rule *flow,
+						   const struct nft_expr *expr);
+	u32				offload_flags;
 	const struct nft_expr_type	*type;
 	void				*data;
 };
@@ -942,6 +950,7 @@ struct nft_stats {
  *	@stats: per-cpu chain stats
  *	@chain: the chain
  *	@dev_name: device name that this base chain is attached to (if any)
+ *	@cb_list: list of flow block callbacks (for hardware offload)
  */
 struct nft_base_chain {
 	struct nf_hook_ops		ops;
@@ -951,6 +960,7 @@ struct nft_base_chain {
 	struct nft_stats __percpu	*stats;
 	struct nft_chain		chain;
 	char 				dev_name[IFNAMSIZ];
+	struct list_head		cb_list;
 };
 
 static inline struct nft_base_chain *nft_base_chain(const struct nft_chain *chain)
@@ -1322,11 +1332,14 @@ struct nft_trans {
 
 struct nft_trans_rule {
 	struct nft_rule			*rule;
+	struct nft_flow_rule		*flow;
 	u32				rule_id;
 };
 
 #define nft_trans_rule(trans)	\
 	(((struct nft_trans_rule *)trans->data)->rule)
+#define nft_trans_flow_rule(trans)	\
+	(((struct nft_trans_rule *)trans->data)->flow)
 #define nft_trans_rule_id(trans)	\
 	(((struct nft_trans_rule *)trans->data)->rule_id)
 
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
new file mode 100644
index 000000000000..3196663a10e3
--- /dev/null
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -0,0 +1,76 @@
+#ifndef _NET_NF_TABLES_OFFLOAD_H
+#define _NET_NF_TABLES_OFFLOAD_H
+
+#include <net/flow_offload.h>
+#include <net/netfilter/nf_tables.h>
+
+struct nft_offload_reg {
+	u32		key;
+	u32		len;
+	u32		base_offset;
+	u32		offset;
+	struct nft_data	mask;
+};
+
+enum nft_offload_dep_type {
+	NFT_OFFLOAD_DEP_UNSPEC	= 0,
+	NFT_OFFLOAD_DEP_NETWORK,
+	NFT_OFFLOAD_DEP_TRANSPORT,
+};
+
+struct nft_offload_ctx {
+	struct {
+		enum nft_offload_dep_type	type;
+		__be16				l3num;
+		u8				protonum;
+	} dep;
+	unsigned int				num_actions;
+	struct nft_offload_reg			regs[NFT_REG32_15 + 1];
+};
+
+void nft_offload_set_dependency(struct nft_offload_ctx *ctx,
+				enum nft_offload_dep_type type);
+void nft_offload_update_dependency(struct nft_offload_ctx *ctx,
+				   const void *data, u32 len);
+
+struct nft_flow_key {
+	struct flow_dissector_key_basic			basic;
+	union {
+		struct flow_dissector_key_ipv4_addrs	ipv4;
+		struct flow_dissector_key_ipv6_addrs	ipv6;
+	};
+	struct flow_dissector_key_ports			tp;
+	struct flow_dissector_key_ip			ip;
+	struct flow_dissector_key_vlan			vlan;
+	struct flow_dissector_key_eth_addrs		eth_addrs;
+} __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
+
+struct nft_flow_match {
+	struct flow_dissector	dissector;
+	struct nft_flow_key	key;
+	struct nft_flow_key	mask;
+};
+
+struct nft_flow_rule {
+	__be16			proto;
+	struct nft_flow_match	match;
+	struct flow_rule	*rule;
+};
+
+#define NFT_OFFLOAD_F_ACTION	(1 << 0)
+
+struct nft_rule;
+struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule);
+void nft_flow_rule_destroy(struct nft_flow_rule *flow);
+int nft_flow_rule_offload_commit(struct net *net);
+
+#define NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
+	(__reg)->base_offset	=					\
+		offsetof(struct nft_flow_key, __base);			\
+	(__reg)->offset		=					\
+		offsetof(struct nft_flow_key, __base.__field);		\
+	(__reg)->len		= __len;				\
+	(__reg)->key		= __key;				\
+	memset(&(__reg)->mask, 0xff, (__reg)->len);
+
+#endif
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 505393c6e959..346cc3388eee 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -158,9 +158,11 @@ enum nft_hook_attributes {
  * enum nft_table_flags - nf_tables table flags
  *
  * @NFT_TABLE_F_DORMANT: this table is not active
+ * @NFT_TABLE_F_HW_OFFLOAD: enable hardware offload
  */
 enum nft_table_flags {
 	NFT_TABLE_F_DORMANT	= 0x1,
+	NFT_TABLE_F_HW_OFFLOAD	= 0x2,
 };
 
 /**
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 72cca6b48960..46cb1d34e750 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -78,7 +78,7 @@ nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
 		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
 		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o \
-		  nft_chain_route.o
+		  nft_chain_route.o nf_tables_offload.o
 
 nf_tables_set-objs := nf_tables_set_core.o \
 		      nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d444405211c5..b620d730b6b6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -21,6 +21,7 @@
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 
@@ -100,6 +101,7 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	ctx->nla   	= nla;
 	ctx->portid	= NETLINK_CB(skb).portid;
 	ctx->report	= nlmsg_report(nlh);
+	ctx->flags	= nlh->nlmsg_flags;
 	ctx->seq	= nlh->nlmsg_seq;
 }
 
@@ -899,7 +901,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 
 	if (nla[NFTA_TABLE_FLAGS]) {
 		flags = ntohl(nla_get_be32(nla[NFTA_TABLE_FLAGS]));
-		if (flags & ~NFT_TABLE_F_DORMANT)
+		if (flags & ~(NFT_TABLE_F_DORMANT | NFT_TABLE_F_HW_OFFLOAD))
 			return -EINVAL;
 	}
 
@@ -1662,6 +1664,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 		chain->flags |= NFT_BASE_CHAIN;
 		basechain->policy = NF_ACCEPT;
+		INIT_LIST_HEAD(&basechain->cb_list);
 	} else {
 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 		if (chain == NULL)
@@ -2641,6 +2644,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	u8 genmask = nft_genmask_next(net);
 	struct nft_expr_info *info = NULL;
 	int family = nfmsg->nfgen_family;
+	struct nft_flow_rule *flow;
 	struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *old_rule = NULL;
@@ -2787,7 +2791,8 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 
 		list_add_tail_rcu(&rule->list, &old_rule->list);
 	} else {
-		if (nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule) == NULL) {
+		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
+		if (!trans) {
 			err = -ENOMEM;
 			goto err2;
 		}
@@ -2810,6 +2815,14 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	if (net->nft.validate_state == NFT_VALIDATE_DO)
 		return nft_table_validate(net, table);
 
+	if (table->flags & NFT_TABLE_F_HW_OFFLOAD) {
+		flow = nft_flow_rule_create(rule);
+		if (IS_ERR(flow))
+			return PTR_ERR(flow);
+
+		nft_trans_flow_rule(trans) = flow;
+	}
+
 	return 0;
 err2:
 	nf_tables_rule_release(&ctx, rule);
@@ -6593,6 +6606,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
+	int err;
 
 	if (list_empty(&net->nft.commit_list)) {
 		mutex_unlock(&net->nft.commit_mutex);
@@ -6603,6 +6617,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	if (nf_tables_validate(net) < 0)
 		return -EAGAIN;
 
+	err = nft_flow_rule_offload_commit(net);
+	if (err < 0)
+		return err;
+
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		int ret;
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
new file mode 100644
index 000000000000..569bea9331cd
--- /dev/null
+++ b/net/netfilter/nf_tables_offload.c
@@ -0,0 +1,233 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <net/flow_offload.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
+#include <net/pkt_cls.h>
+
+static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
+{
+	struct nft_flow_rule *flow;
+
+	flow = kzalloc(sizeof(struct nft_flow_rule), GFP_KERNEL);
+	if (!flow)
+		return NULL;
+
+	flow->rule = flow_rule_alloc(num_actions);
+	if (!flow->rule) {
+		kfree(flow);
+		return NULL;
+	}
+
+	flow->rule->match.dissector	= &flow->match.dissector;
+	flow->rule->match.mask		= &flow->match.mask;
+	flow->rule->match.key		= &flow->match.key;
+
+	return flow;
+}
+
+struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule)
+{
+	struct nft_offload_ctx ctx = {
+		.dep	= {
+			.type	= NFT_OFFLOAD_DEP_UNSPEC,
+		},
+	};
+	struct nft_flow_rule *flow;
+	int num_actions = 0, err;
+	struct nft_expr *expr;
+
+	expr = nft_expr_first(rule);
+	while (expr->ops && expr != nft_expr_last(rule)) {
+		if (expr->ops->offload_flags & NFT_OFFLOAD_F_ACTION)
+			num_actions++;
+
+		expr = nft_expr_next(expr);
+	}
+
+	flow = nft_flow_rule_alloc(num_actions);
+	if (!flow)
+		return ERR_PTR(-ENOMEM);
+
+	expr = nft_expr_first(rule);
+	while (expr->ops && expr != nft_expr_last(rule)) {
+		if (!expr->ops->offload) {
+			err = -EOPNOTSUPP;
+			goto err_out;
+		}
+		err = expr->ops->offload(&ctx, flow, expr);
+		if (err < 0)
+			goto err_out;
+
+		expr = nft_expr_next(expr);
+	}
+	flow->proto = ctx.dep.l3num;
+
+	return flow;
+err_out:
+	nft_flow_rule_destroy(flow);
+
+	return ERR_PTR(err);
+}
+
+void nft_flow_rule_destroy(struct nft_flow_rule *flow)
+{
+	kfree(flow->rule);
+	kfree(flow);
+}
+
+void nft_offload_set_dependency(struct nft_offload_ctx *ctx,
+				enum nft_offload_dep_type type)
+{
+	ctx->dep.type = type;
+}
+
+void nft_offload_update_dependency(struct nft_offload_ctx *ctx,
+				   const void *data, u32 len)
+{
+	switch (ctx->dep.type) {
+	case NFT_OFFLOAD_DEP_NETWORK:
+		WARN_ON(len != sizeof(__u16));
+		memcpy(&ctx->dep.l3num, data, sizeof(__u16));
+		break;
+	case NFT_OFFLOAD_DEP_TRANSPORT:
+		WARN_ON(len != sizeof(__u8));
+		memcpy(&ctx->dep.protonum, data, sizeof(__u8));
+		break;
+	default:
+		break;
+	}
+	ctx->dep.type = NFT_OFFLOAD_DEP_UNSPEC;
+}
+
+static void nft_flow_offload_common_init(struct tc_cls_common_offload *common,
+					 __be16 proto,
+					struct netlink_ext_ack *extack)
+{
+	common->protocol = proto;
+	common->extack = extack;
+}
+
+static int nft_setup_cb_call(struct nft_base_chain *basechain,
+			     enum tc_setup_type type, void *type_data)
+{
+	struct flow_block_cb *block_cb;
+	int err;
+
+	list_for_each_entry(block_cb, &basechain->cb_list, list) {
+		err = block_cb->cb(type, type_data, block_cb->cb_priv);
+		if (err < 0)
+			return err;
+	}
+	return 0;
+}
+
+static int nft_flow_offload_rule(struct nft_trans *trans,
+				 enum tc_fl_command command)
+{
+	struct nft_flow_rule *flow = nft_trans_flow_rule(trans);
+	struct nft_rule *rule = nft_trans_rule(trans);
+	struct tc_cls_flower_offload cls_flower = {};
+	struct nft_base_chain *basechain;
+	struct netlink_ext_ack extack;
+	__be16 proto = ETH_P_ALL;
+
+	if (!nft_is_base_chain(trans->ctx.chain))
+		return -EOPNOTSUPP;
+
+	basechain = nft_base_chain(trans->ctx.chain);
+
+	if (flow)
+		proto = flow->proto;
+
+	nft_flow_offload_common_init(&cls_flower.common, proto, &extack);
+	cls_flower.command = command;
+	cls_flower.cookie = (unsigned long) rule;
+	if (flow)
+		cls_flower.rule = flow->rule;
+
+	return nft_setup_cb_call(basechain, TC_SETUP_CLSFLOWER, &cls_flower);
+}
+
+static int nft_flow_offload_bind(struct flow_block_offload *bo,
+				 struct nft_base_chain *basechain)
+{
+	struct flow_block_cb *block_cb;
+
+	list_for_each_entry(block_cb, &bo->cb_list, global_list)
+		list_add(&block_cb->list, &basechain->cb_list);
+
+	flow_block_cb_splice(bo);
+	return 0;
+}
+
+static int nft_flow_offload_chain(struct nft_trans *trans,
+				  enum flow_block_command cmd)
+{
+	struct nft_chain *chain = trans->ctx.chain;
+	struct netlink_ext_ack extack = {};
+	struct flow_block_offload bo = {};
+	struct nft_base_chain *basechain;
+	struct net_device *dev;
+	int err;
+
+	if (!nft_is_base_chain(chain))
+		return -EOPNOTSUPP;
+
+	basechain = nft_base_chain(chain);
+	dev = basechain->ops.dev;
+	if (!dev || !dev->netdev_ops->ndo_setup_tc)
+		return -EOPNOTSUPP;
+
+	bo.command = cmd;
+	bo.binder_type = TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	bo.extack = &extack;
+	INIT_LIST_HEAD(&bo.cb_list);
+
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	if (err < 0)
+		return err;
+
+	return nft_flow_offload_bind(&bo, basechain);
+}
+
+int nft_flow_rule_offload_commit(struct net *net)
+{
+	struct nft_trans *trans;
+	int err = 0;
+
+	list_for_each_entry(trans, &net->nft.commit_list, list) {
+		if (trans->ctx.family != NFPROTO_NETDEV ||
+		    !(trans->ctx.table->flags & NFT_TABLE_F_HW_OFFLOAD))
+			continue;
+
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWCHAIN:
+			err = nft_flow_offload_chain(trans, TC_BLOCK_BIND);
+			break;
+		case NFT_MSG_DELCHAIN:
+			err = nft_flow_offload_chain(trans, TC_BLOCK_UNBIND);
+			break;
+		case NFT_MSG_NEWRULE:
+			if (trans->ctx.flags & NLM_F_REPLACE ||
+			    !(trans->ctx.flags & NLM_F_APPEND))
+				return -EOPNOTSUPP;
+
+			err = nft_flow_offload_rule(trans,
+						    TC_CLSFLOWER_REPLACE);
+			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
+			break;
+		case NFT_MSG_DELRULE:
+			err = nft_flow_offload_rule(trans,
+						    TC_CLSFLOWER_DESTROY);
+			break;
+		}
+
+		if (err)
+			return err;
+	}
+
+	return err;
+}
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index f9f1fa66a16e..e587ab9afe40 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -15,6 +15,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_tables.h>
 
 struct nft_cmp_expr {
@@ -110,12 +111,44 @@ static int nft_cmp_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static int __nft_cmp_offload(struct nft_offload_ctx *ctx,
+			     struct nft_flow_rule *flow,
+			     const struct nft_cmp_expr *priv)
+{
+	struct nft_offload_reg *reg = &ctx->regs[priv->sreg];
+	u8 *mask = (u8 *)&flow->match.mask;
+	u8 *key = (u8 *)&flow->match.key;
+
+	if (priv->op != NFT_CMP_EQ)
+		return -EOPNOTSUPP;
+
+	memcpy(key + reg->offset, &priv->data, priv->len);
+	memcpy(mask + reg->offset, &reg->mask, priv->len);
+
+	flow->match.dissector.used_keys |= BIT(reg->key);
+	flow->match.dissector.offset[reg->key] = reg->base_offset;
+
+	nft_offload_update_dependency(ctx, &priv->data, priv->len);
+
+	return 0;
+}
+
+static int nft_cmp_offload(struct nft_offload_ctx *ctx,
+			   struct nft_flow_rule *flow,
+			   const struct nft_expr *expr)
+{
+	const struct nft_cmp_expr *priv = nft_expr_priv(expr);
+
+	return __nft_cmp_offload(ctx, flow, priv);
+}
+
 static const struct nft_expr_ops nft_cmp_ops = {
 	.type		= &nft_cmp_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp_expr)),
 	.eval		= nft_cmp_eval,
 	.init		= nft_cmp_init,
 	.dump		= nft_cmp_dump,
+	.offload	= nft_cmp_offload,
 };
 
 static int nft_cmp_fast_init(const struct nft_ctx *ctx,
@@ -146,6 +179,25 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static int nft_cmp_fast_offload(struct nft_offload_ctx *ctx,
+				struct nft_flow_rule *flow,
+				const struct nft_expr *expr)
+{
+	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
+	struct nft_cmp_expr cmp = {
+		.data	= {
+			.data	= {
+				[0] = priv->data,
+			},
+		},
+		.sreg	= priv->sreg,
+		.len	= priv->len / BITS_PER_BYTE,
+		.op	= NFT_CMP_EQ,
+	};
+
+	return __nft_cmp_offload(ctx, flow, &cmp);
+}
+
 static int nft_cmp_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
@@ -172,6 +224,7 @@ const struct nft_expr_ops nft_cmp_fast_ops = {
 	.eval		= NULL,	/* inlined */
 	.init		= nft_cmp_fast_init,
 	.dump		= nft_cmp_fast_dump,
+	.offload	= nft_cmp_fast_offload,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 5ec43124cbca..0e34225ccb34 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -16,6 +16,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
 
 void nft_immediate_eval(const struct nft_expr *expr,
 			struct nft_regs *regs,
@@ -127,6 +128,34 @@ static int nft_immediate_validate(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static int nft_immediate_offload(struct nft_offload_ctx *ctx,
+				 struct nft_flow_rule *flow,
+				 const struct nft_expr *expr)
+{
+	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+	struct flow_action_entry *entry;
+	const struct nft_data *data;
+
+	if (priv->dreg != NFT_REG_VERDICT)
+		return -EOPNOTSUPP;
+
+	entry = &flow->rule->action.entries[ctx->num_actions++];
+
+	data = &priv->data;
+	switch (data->verdict.code) {
+	case NF_ACCEPT:
+		entry->id = FLOW_ACTION_ACCEPT;
+		break;
+	case NF_DROP:
+		entry->id = FLOW_ACTION_DROP;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_imm_ops = {
 	.type		= &nft_imm_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
@@ -136,6 +165,8 @@ static const struct nft_expr_ops nft_imm_ops = {
 	.deactivate	= nft_immediate_deactivate,
 	.dump		= nft_immediate_dump,
 	.validate	= nft_immediate_validate,
+	.offload	= nft_immediate_offload,
+	.offload_flags	= NFT_OFFLOAD_F_ACTION,
 };
 
 struct nft_expr_type nft_imm_type __read_mostly = {
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 987d2d6ce624..24a45a8b9d96 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -24,6 +24,7 @@
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_tables_offload.h>
 
 #include <uapi/linux/netfilter_bridge.h> /* NF_BR_PRE_ROUTING */
 
@@ -518,6 +519,31 @@ static void nft_meta_set_destroy(const struct nft_ctx *ctx,
 		static_branch_dec(&nft_trace_enabled);
 }
 
+static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
+				struct nft_flow_rule *flow,
+				const struct nft_expr *expr)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
+
+	switch (priv->key) {
+	case NFT_META_PROTOCOL:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, n_proto,
+				  sizeof(__u16), reg);
+		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
+		break;
+	case NFT_META_L4PROTO:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
+				  sizeof(__u8), reg);
+		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
@@ -525,6 +551,7 @@ static const struct nft_expr_ops nft_meta_get_ops = {
 	.init		= nft_meta_get_init,
 	.dump		= nft_meta_get_dump,
 	.validate	= nft_meta_get_validate,
+	.offload	= nft_meta_get_offload,
 };
 
 static const struct nft_expr_ops nft_meta_set_ops = {
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 1465b7d6d2b0..16b31e13fed5 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -18,10 +18,13 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
 /* For layer 4 checksum field offset. */
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/icmpv6.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
 
 /* add vlan header into the user buffer for if tag was removed by offloads */
 static bool
@@ -153,12 +156,195 @@ static int nft_payload_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_payload *priv)
+{
+	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
+
+	switch (priv->offset) {
+	case offsetof(struct ethhdr, h_source):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
+				  src, ETH_ALEN, reg);
+		break;
+	case offsetof(struct ethhdr, h_dest):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
+				  dst, ETH_ALEN, reg);
+		break;
+	}
+
+	return 0;
+}
+
+static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_payload *priv)
+{
+	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
+
+	switch (priv->offset) {
+	case offsetof(struct iphdr, saddr):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, src,
+				  sizeof(struct in_addr), reg);
+		break;
+	case offsetof(struct iphdr, daddr):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, dst,
+				  sizeof(struct in_addr), reg);
+		break;
+	case offsetof(struct iphdr, protocol):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
+				  sizeof(__u8), reg);
+		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_payload *priv)
+{
+	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
+
+	switch (priv->offset) {
+	case offsetof(struct ipv6hdr, saddr):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, src,
+				  sizeof(struct in6_addr), reg);
+		break;
+	case offsetof(struct ipv6hdr, daddr):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, dst,
+				  sizeof(struct in6_addr), reg);
+		break;
+	case offsetof(struct ipv6hdr, nexthdr):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
+				  sizeof(__u8), reg);
+		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int nft_payload_offload_nh(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_payload *priv)
+{
+	int err;
+
+	switch (ctx->dep.l3num) {
+	case htons(ETH_P_IP):
+		err = nft_payload_offload_ip(ctx, flow, priv);
+		break;
+	case htons(ETH_P_IPV6):
+		err = nft_payload_offload_ip6(ctx, flow, priv);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static int nft_payload_offload_tcp(struct nft_offload_ctx *ctx,
+				   struct nft_flow_rule *flow,
+				   const struct nft_payload *priv)
+{
+	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
+
+	switch (priv->offset) {
+	case offsetof(struct tcphdr, source):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
+				  sizeof(__be16), reg);
+		break;
+	case offsetof(struct tcphdr, dest):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
+				  sizeof(__be16), reg);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int nft_payload_offload_udp(struct nft_offload_ctx *ctx,
+				   struct nft_flow_rule *flow,
+				   const struct nft_payload *priv)
+{
+	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
+
+	switch (priv->offset) {
+	case offsetof(struct udphdr, source):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
+				  sizeof(__be16), reg);
+		break;
+	case offsetof(struct udphdr, dest):
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
+				  sizeof(__be16), reg);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int nft_payload_offload_th(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_payload *priv)
+{
+	int err;
+
+	switch (ctx->dep.protonum) {
+	case IPPROTO_TCP:
+		err = nft_payload_offload_tcp(ctx, flow, priv);
+		break;
+	case IPPROTO_UDP:
+		err = nft_payload_offload_udp(ctx, flow, priv);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static int nft_payload_offload(struct nft_offload_ctx *ctx,
+			       struct nft_flow_rule *flow,
+			       const struct nft_expr *expr)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+	int err;
+
+	switch (priv->base) {
+	case NFT_PAYLOAD_LL_HEADER:
+		err = nft_payload_offload_ll(ctx, flow, priv);
+		break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		err = nft_payload_offload_nh(ctx, flow, priv);
+		break;
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		err = nft_payload_offload_th(ctx, flow, priv);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+	return err;
+}
+
 static const struct nft_expr_ops nft_payload_ops = {
 	.type		= &nft_payload_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload)),
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
+	.offload	= nft_payload_offload,
 };
 
 const struct nft_expr_ops nft_payload_fast_ops = {
@@ -167,6 +353,7 @@ const struct nft_expr_ops nft_payload_fast_ops = {
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
+	.offload	= nft_payload_offload,
 };
 
 static inline void nft_csum_replace(__sum16 *sum, __wsum fsum, __wsum tsum)
-- 
2.11.0

