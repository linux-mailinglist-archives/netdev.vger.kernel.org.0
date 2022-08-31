Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50ADC5A7B28
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 12:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiHaKQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 06:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiHaKQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 06:16:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96D225C64;
        Wed, 31 Aug 2022 03:16:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oTKln-0002O1-1G; Wed, 31 Aug 2022 12:16:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
Date:   Wed, 31 Aug 2022 12:16:17 +0200
Message-Id: <20220831101617.22329-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This expression is a native replacement for xtables 'bpf' match "pinned" mode.
Userspace needs to pass a file descriptor referencing the program (of socket
filter type).
Userspace should also pass the original pathname for that fd so userspace can
print the original filename again.

Tag and program id are dumped to userspace on 'list' to allow to see which
program is in use in case the filename isn't available/present.

cbpf bytecode isn't supported.

No new Kconfig option is added: Its included if BPF_SYSCALL is enabled.

Proposed nft userspace syntax is:

add rule ... ebpf pinned "/sys/fs/bpf/myprog"

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables_core.h   |   3 +
 include/uapi/linux/netfilter/nf_tables.h |  18 ++++
 net/netfilter/Makefile                   |   4 +
 net/netfilter/nf_tables_core.c           |   7 ++
 net/netfilter/nft_ebpf.c                 | 128 +++++++++++++++++++++++
 5 files changed, 160 insertions(+)
 create mode 100644 net/netfilter/nft_ebpf.c

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 1223af68cd9a..72ee4a6e2952 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -18,6 +18,7 @@ extern struct nft_expr_type nft_meta_type;
 extern struct nft_expr_type nft_rt_type;
 extern struct nft_expr_type nft_exthdr_type;
 extern struct nft_expr_type nft_last_type;
+extern struct nft_expr_type nft_ebpf_type;
 
 #ifdef CONFIG_NETWORK_SECMARK
 extern struct nft_object_type nft_secmark_obj_type;
@@ -148,4 +149,6 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 		     struct nft_regs *regs, const struct nft_pktinfo *pkt);
 void nft_counter_eval(const struct nft_expr *expr, struct nft_regs *regs,
                       const struct nft_pktinfo *pkt);
+void nft_ebpf_eval(const struct nft_expr *expr, struct nft_regs *regs,
+		   const struct nft_pktinfo *pkt);
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 466fd3f4447c..39e9442e8c2a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -805,6 +805,24 @@ enum nft_payload_attributes {
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
 
+/**
+ * enum nft_ebpf_attributes - nf_tables ebpf expression netlink attributes
+ *
+ * @NFTA_EBPF_FD: file descriptor holding ebpf program (NLA_U32)
+ * @NFTA_EBPF_FILENAME: file name, only for storage/printing (NLA_STRING)
+ * @NFTA_EBPF_ID: bpf program id (NLA_U32)
+ * @NFTA_EBPF_TAG: bpf tag (NLA_BINARY)
+ */
+enum nft_ebpf_attributes {
+	NFTA_EBPF_UNSPEC,
+	NFTA_EBPF_FD,
+	NFTA_EBPF_FILENAME,
+	NFTA_EBPF_ID,
+	NFTA_EBPF_TAG,
+	__NFTA_EBPF_MAX,
+};
+#define NFTA_EBPF_MAX	(__NFTA_EBPF_MAX - 1)
+
 enum nft_exthdr_flags {
 	NFT_EXTHDR_F_PRESENT = (1 << 0),
 };
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 06df49ea6329..f335a1ea26b9 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -90,6 +90,10 @@ nf_tables-objs += nft_set_pipapo_avx2.o
 endif
 endif
 
+ifdef CONFIG_BPF_SYSCALL
+nf_tables-objs += nft_ebpf.o
+endif
+
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_CONNLIMIT)	+= nft_connlimit.o
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index cee3e4e905ec..f33064959f6c 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/filter.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/skbuff.h>
@@ -209,6 +210,9 @@ static void expr_call_ops_eval(const struct nft_expr *expr,
 	X(e, nft_dynset_eval);
 	X(e, nft_rt_get_eval);
 	X(e, nft_bitwise_eval);
+#ifdef CONFIG_BPF_SYSCALL
+	X(e, nft_ebpf_eval);
+#endif
 #undef  X
 #endif /* CONFIG_RETPOLINE */
 	expr->ops->eval(expr, regs, pkt);
@@ -340,6 +344,9 @@ static struct nft_expr_type *nft_basic_types[] = {
 	&nft_exthdr_type,
 	&nft_last_type,
 	&nft_counter_type,
+#ifdef CONFIG_BPF_SYSCALL
+	&nft_ebpf_type,
+#endif
 };
 
 static struct nft_object_type *nft_basic_objects[] = {
diff --git a/net/netfilter/nft_ebpf.c b/net/netfilter/nft_ebpf.c
new file mode 100644
index 000000000000..f4945f4e7bc5
--- /dev/null
+++ b/net/netfilter/nft_ebpf.c
@@ -0,0 +1,128 @@
+#include <linux/bpf.h>
+#include <linux/filter.h>
+
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+
+struct nft_ebpf {
+	struct bpf_prog *prog;
+	const char *name;
+};
+
+static const struct nla_policy nft_ebpf_policy[NFTA_EBPF_MAX + 1] = {
+	[NFTA_EBPF_FD] = { .type = NLA_U32 },
+	[NFTA_EBPF_FILENAME] = { .type = NLA_STRING,
+				 .len = PATH_MAX },
+	[NFTA_EBPF_ID] = { .type = NLA_U32 },
+	[NFTA_EBPF_TAG] = NLA_POLICY_EXACT_LEN(BPF_TAG_SIZE),
+};
+
+void nft_ebpf_eval(const struct nft_expr *expr, struct nft_regs *regs,
+		   const struct nft_pktinfo *pkt)
+{
+	const struct nft_ebpf *priv = nft_expr_priv(expr);
+
+	if (!bpf_prog_run_save_cb(priv->prog, pkt->skb))
+		regs->verdict.code = NFT_BREAK;
+}
+
+static int nft_ebpf_init(const struct nft_ctx *ctx,
+			 const struct nft_expr *expr,
+			 const struct nlattr * const tb[])
+{
+	struct nft_ebpf *priv = nft_expr_priv(expr);
+	struct bpf_prog *prog;
+	int fd;
+
+	if (!tb[NFTA_EBPF_FD])
+		return -EINVAL;
+
+	if (tb[NFTA_EBPF_ID] || tb[NFTA_EBPF_TAG])
+		return -EOPNOTSUPP;
+
+	fd = ntohl(nla_get_u32(tb[NFTA_EBPF_FD]));
+	if (fd < 0)
+		return -EBADF;
+
+	if (tb[NFTA_EBPF_FILENAME]) {
+		priv->name = nla_strdup(tb[NFTA_EBPF_FILENAME], GFP_KERNEL);
+		if (!priv->name)
+			return -ENOMEM;
+	}
+
+	prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
+	if (IS_ERR(prog)) {
+		kfree(priv->name);
+		return PTR_ERR(prog);
+	}
+
+	priv->prog = prog;
+	return 0;
+}
+
+static void nft_ebpf_destroy(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr)
+{
+	struct nft_ebpf *priv = nft_expr_priv(expr);
+
+	bpf_prog_destroy(priv->prog);
+	kfree(priv->name);
+}
+
+static int nft_ebpf_validate(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nft_data **data)
+{
+	static const unsigned int supported_hooks = ((1 << NF_INET_PRE_ROUTING) |
+						     (1 << NF_INET_LOCAL_IN) |
+						     (1 << NF_INET_FORWARD) |
+						     (1 << NF_INET_LOCAL_OUT) |
+						     (1 << NF_INET_POST_ROUTING));
+
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, supported_hooks);
+}
+
+static int nft_ebpf_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_ebpf *priv = nft_expr_priv(expr);
+	const struct bpf_prog *prog = priv->prog;
+
+	if (nla_put_be32(skb, NFTA_EBPF_ID, htonl(prog->aux->id)))
+		return -1;
+
+	if (nla_put(skb, NFTA_EBPF_TAG, sizeof(prog->tag), prog->tag))
+		return -1;
+
+	if (priv->name && nla_put_string(skb, NFTA_EBPF_FILENAME, priv->name))
+		return -1;
+
+	return 0;
+}
+
+static const struct nft_expr_ops nft_ebpf_ops = {
+	.type		= &nft_ebpf_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ebpf)),
+	.init		= nft_ebpf_init,
+	.eval		= nft_ebpf_eval,
+	.reduce		= NFT_REDUCE_READONLY,
+	.destroy	= nft_ebpf_destroy,
+	.dump		= nft_ebpf_dump,
+	.validate	= nft_ebpf_validate,
+};
+
+struct nft_expr_type nft_ebpf_type __read_mostly = {
+	.name		= "ebpf",
+	.ops		= &nft_ebpf_ops,
+	.policy		= nft_ebpf_policy,
+	.maxattr	= NFTA_EBPF_MAX,
+	.owner		= THIS_MODULE,
+};
-- 
2.35.1

