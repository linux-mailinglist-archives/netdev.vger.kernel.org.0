Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593246EB018
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjDURDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbjDURDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:03:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1FDA3;
        Fri, 21 Apr 2023 10:03:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ppuAJ-0004BA-3M; Fri, 21 Apr 2023 19:03:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <bpf@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de, Florian Westphal <fw@strlen.de>
Subject: [PATCH bpf-next v5 3/7] netfilter: nfnetlink hook: dump bpf prog id
Date:   Fri, 21 Apr 2023 19:02:56 +0200
Message-Id: <20230421170300.24115-4-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421170300.24115-1-fw@strlen.de>
References: <20230421170300.24115-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows userspace ("nft list hooks") to show which bpf program
is attached to which hook.

Without this, user only knows bpf prog is attached at prio
x, y, z at INPUT and FORWARD, but can't tell which program is where.

v4: kdoc fixups (Simon Horman)

Link: https://lore.kernel.org/bpf/ZEELzpNCnYJuZyod@corigine.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since last version

 include/uapi/linux/netfilter/nfnetlink_hook.h | 24 +++++-
 net/netfilter/nfnetlink_hook.c                | 81 ++++++++++++++++---
 2 files changed, 89 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_hook.h b/include/uapi/linux/netfilter/nfnetlink_hook.h
index bbcd285b22e1..84a561a74b98 100644
--- a/include/uapi/linux/netfilter/nfnetlink_hook.h
+++ b/include/uapi/linux/netfilter/nfnetlink_hook.h
@@ -32,8 +32,12 @@ enum nfnl_hook_attributes {
 /**
  * enum nfnl_hook_chain_info_attributes - chain description
  *
- * NFNLA_HOOK_INFO_DESC: nft chain and table name (enum nft_table_attributes) (NLA_NESTED)
- * NFNLA_HOOK_INFO_TYPE: chain type (enum nfnl_hook_chaintype) (NLA_U32)
+ * @NFNLA_HOOK_INFO_DESC: nft chain and table name (NLA_NESTED)
+ * @NFNLA_HOOK_INFO_TYPE: chain type (enum nfnl_hook_chaintype) (NLA_U32)
+ *
+ * NFNLA_HOOK_INFO_DESC depends on NFNLA_HOOK_INFO_TYPE value:
+ *   NFNL_HOOK_TYPE_NFTABLES: enum nft_table_attributes
+ *   NFNL_HOOK_TYPE_BPF: enum nfnl_hook_bpf_attributes
  */
 enum nfnl_hook_chain_info_attributes {
 	NFNLA_HOOK_INFO_UNSPEC,
@@ -55,10 +59,24 @@ enum nfnl_hook_chain_desc_attributes {
 /**
  * enum nfnl_hook_chaintype - chain type
  *
- * @NFNL_HOOK_TYPE_NFTABLES nf_tables base chain
+ * @NFNL_HOOK_TYPE_NFTABLES: nf_tables base chain
+ * @NFNL_HOOK_TYPE_BPF: bpf program
  */
 enum nfnl_hook_chaintype {
 	NFNL_HOOK_TYPE_NFTABLES = 0x1,
+	NFNL_HOOK_TYPE_BPF,
+};
+
+/**
+ * enum nfnl_hook_bpf_attributes - bpf prog description
+ *
+ * @NFNLA_HOOK_BPF_ID: bpf program id (NLA_U32)
+ */
+enum nfnl_hook_bpf_attributes {
+	NFNLA_HOOK_BPF_UNSPEC,
+	NFNLA_HOOK_BPF_ID,
+	__NFNLA_HOOK_BPF_MAX,
 };
+#define NFNLA_HOOK_BPF_MAX (__NFNLA_HOOK_BPF_MAX - 1)
 
 #endif /* _NFNL_HOOK_H */
diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 8120aadf6a0f..ade8ee1988b1 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -5,6 +5,7 @@
  * Author: Florian Westphal <fw@strlen.de>
  */
 
+#include <linux/bpf.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/kernel.h>
@@ -57,35 +58,76 @@ struct nfnl_dump_hook_data {
 	u8 hook;
 };
 
+static struct nlattr *nfnl_start_info_type(struct sk_buff *nlskb, enum nfnl_hook_chaintype t)
+{
+	struct nlattr *nest = nla_nest_start(nlskb, NFNLA_HOOK_CHAIN_INFO);
+	int ret;
+
+	if (!nest)
+		return NULL;
+
+	ret = nla_put_be32(nlskb, NFNLA_HOOK_INFO_TYPE, htonl(t));
+	if (ret == 0)
+		return nest;
+
+	nla_nest_cancel(nlskb, nest);
+	return NULL;
+}
+
+static int nfnl_hook_put_bpf_prog_info(struct sk_buff *nlskb,
+				       const struct nfnl_dump_hook_data *ctx,
+				       unsigned int seq,
+				       const struct bpf_prog *prog)
+{
+	struct nlattr *nest, *nest2;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_NETFILTER_BPF_LINK))
+		return 0;
+
+	if (WARN_ON_ONCE(!prog))
+		return 0;
+
+	nest = nfnl_start_info_type(nlskb, NFNL_HOOK_TYPE_BPF);
+	if (!nest)
+		return -EMSGSIZE;
+
+	nest2 = nla_nest_start(nlskb, NFNLA_HOOK_INFO_DESC);
+	if (!nest2)
+		goto cancel_nest;
+
+	ret = nla_put_be32(nlskb, NFNLA_HOOK_BPF_ID, htonl(prog->aux->id));
+	if (ret)
+		goto cancel_nest;
+
+	nla_nest_end(nlskb, nest2);
+	nla_nest_end(nlskb, nest);
+	return 0;
+
+cancel_nest:
+	nla_nest_cancel(nlskb, nest);
+	return -EMSGSIZE;
+}
+
 static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
 					const struct nfnl_dump_hook_data *ctx,
 					unsigned int seq,
-					const struct nf_hook_ops *ops)
+					struct nft_chain *chain)
 {
 	struct net *net = sock_net(nlskb->sk);
 	struct nlattr *nest, *nest2;
-	struct nft_chain *chain;
 	int ret = 0;
 
-	if (ops->hook_ops_type != NF_HOOK_OP_NF_TABLES)
-		return 0;
-
-	chain = ops->priv;
 	if (WARN_ON_ONCE(!chain))
 		return 0;
 
 	if (!nft_is_active(net, chain))
 		return 0;
 
-	nest = nla_nest_start(nlskb, NFNLA_HOOK_CHAIN_INFO);
+	nest = nfnl_start_info_type(nlskb, NFNL_HOOK_TYPE_NFTABLES);
 	if (!nest)
 		return -EMSGSIZE;
 
-	ret = nla_put_be32(nlskb, NFNLA_HOOK_INFO_TYPE,
-			   htonl(NFNL_HOOK_TYPE_NFTABLES));
-	if (ret)
-		goto cancel_nest;
-
 	nest2 = nla_nest_start(nlskb, NFNLA_HOOK_INFO_DESC);
 	if (!nest2)
 		goto cancel_nest;
@@ -171,7 +213,20 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 	if (ret)
 		goto nla_put_failure;
 
-	ret = nfnl_hook_put_nft_chain_info(nlskb, ctx, seq, ops);
+	switch (ops->hook_ops_type) {
+	case NF_HOOK_OP_NF_TABLES:
+		ret = nfnl_hook_put_nft_chain_info(nlskb, ctx, seq, ops->priv);
+		break;
+	case NF_HOOK_OP_BPF:
+		ret = nfnl_hook_put_bpf_prog_info(nlskb, ctx, seq, ops->priv);
+		break;
+	case NF_HOOK_OP_UNDEFINED:
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
 	if (ret)
 		goto nla_put_failure;
 
-- 
2.39.2

