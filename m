Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681226E0ED5
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbjDMNfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjDMNec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:34:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78407A5E2;
        Thu, 13 Apr 2023 06:32:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pmx49-000171-3p; Thu, 13 Apr 2023 15:32:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de, Florian Westphal <fw@strlen.de>
Subject: [PATCH bpf-next v2 2/6] bpf: minimal support for programs hooked into netfilter framework
Date:   Thu, 13 Apr 2023 15:32:24 +0200
Message-Id: <20230413133228.20790-3-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413133228.20790-1-fw@strlen.de>
References: <20230413133228.20790-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds minimal support for BPF_PROG_TYPE_NETFILTER bpf programs
that will be invoked via the NF_HOOK() points in the ip stack.

Invocation incurs an indirect call.  This is not a necessity: Its
possible to add 'DEFINE_BPF_DISPATCHER(nf_progs)' and handle the
program invocation with the same method already done for xdp progs.

This isn't done here to keep the size of this chunk down.

Verifier restricts verdicts to either DROP or ACCEPT.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/bpf_types.h           |  4 ++
 include/net/netfilter/nf_bpf_link.h |  5 +++
 kernel/bpf/btf.c                    |  6 +++
 kernel/bpf/verifier.c               |  3 ++
 net/core/filter.c                   |  1 +
 net/netfilter/nf_bpf_link.c         | 70 ++++++++++++++++++++++++++++-
 6 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index d4ee3ccd3753..39a999abb0ce 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -79,6 +79,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
 #endif
 BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
 	      void *, void *)
+#ifdef CONFIG_NETFILTER
+BPF_PROG_TYPE(BPF_PROG_TYPE_NETFILTER, netfilter,
+	      struct bpf_nf_ctx, struct bpf_nf_ctx)
+#endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/net/netfilter/nf_bpf_link.h b/include/net/netfilter/nf_bpf_link.h
index eeaeaf3d15de..6c984b0ea838 100644
--- a/include/net/netfilter/nf_bpf_link.h
+++ b/include/net/netfilter/nf_bpf_link.h
@@ -1,5 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+struct bpf_nf_ctx {
+	const struct nf_hook_state *state;
+	struct sk_buff *skb;
+};
+
 #if IS_ENABLED(CONFIG_NETFILTER_BPF_LINK)
 int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
 #else
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 913b9d717a4a..b9924e0f2402 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -25,6 +25,9 @@
 #include <linux/bsearch.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
+
+#include <net/netfilter/nf_bpf_link.h>
+
 #include <net/sock.h>
 #include "../tools/lib/bpf/relo_core.h"
 
@@ -212,6 +215,7 @@ enum btf_kfunc_hook {
 	BTF_KFUNC_HOOK_SK_SKB,
 	BTF_KFUNC_HOOK_SOCKET_FILTER,
 	BTF_KFUNC_HOOK_LWT,
+	BTF_KFUNC_HOOK_NETFILTER,
 	BTF_KFUNC_HOOK_MAX,
 };
 
@@ -7857,6 +7861,8 @@ static int bpf_prog_type_to_kfunc_hook(enum bpf_prog_type prog_type)
 	case BPF_PROG_TYPE_LWT_XMIT:
 	case BPF_PROG_TYPE_LWT_SEG6LOCAL:
 		return BTF_KFUNC_HOOK_LWT;
+	case BPF_PROG_TYPE_NETFILTER:
+		return BTF_KFUNC_HOOK_NETFILTER;
 	default:
 		return BTF_KFUNC_HOOK_MAX;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d6db6de3e9ea..f04c7c2d6908 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13799,6 +13799,9 @@ static int check_return_code(struct bpf_verifier_env *env)
 		}
 		break;
 
+	case BPF_PROG_TYPE_NETFILTER:
+		range = tnum_range(NF_DROP, NF_ACCEPT);
+		break;
 	case BPF_PROG_TYPE_EXT:
 		/* freplace program can return anything as its return value
 		 * depends on the to-be-replaced kernel func or bpf program.
diff --git a/net/core/filter.c b/net/core/filter.c
index 727c5269867d..dfc8dfaf631b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -11712,6 +11712,7 @@ static int __init bpf_kfunc_init(void)
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_IN, &bpf_kfunc_set_skb);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_XMIT, &bpf_kfunc_set_skb);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_SEG6LOCAL, &bpf_kfunc_set_skb);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_NETFILTER, &bpf_kfunc_set_skb);
 	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &bpf_kfunc_set_xdp);
 }
 late_initcall(bpf_kfunc_init);
diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index c68b2cb70fd4..4b22a31d6df5 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -1,12 +1,19 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/bpf.h>
+#include <linux/filter.h>
 #include <linux/netfilter.h>
 
 #include <net/netfilter/nf_bpf_link.h>
 
 static unsigned int nf_hook_run_bpf(void *bpf_prog, struct sk_buff *skb, const struct nf_hook_state *s)
 {
-	return NF_ACCEPT;
+	const struct bpf_prog *prog = bpf_prog;
+	struct bpf_nf_ctx ctx = {
+		.state = s,
+		.skb = skb,
+	};
+
+	return bpf_prog_run(prog, &ctx);
 }
 
 struct bpf_nf_link {
@@ -119,3 +126,64 @@ int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 
 	return bpf_link_settle(&link_primer);
 }
+
+const struct bpf_prog_ops netfilter_prog_ops = {
+};
+
+static bool nf_ptr_to_btf_id(struct bpf_insn_access_aux *info, const char *name)
+{
+	struct btf *btf;
+	s32 type_id;
+
+	btf = bpf_get_btf_vmlinux();
+	if (IS_ERR_OR_NULL(btf))
+		return false;
+
+	type_id = btf_find_by_name_kind(btf, name, BTF_KIND_STRUCT);
+	if (WARN_ON_ONCE(type_id < 0))
+		return false;
+
+	info->btf = btf;
+	info->btf_id = type_id;
+	info->reg_type = PTR_TO_BTF_ID | PTR_TRUSTED;
+	return true;
+}
+
+static bool nf_is_valid_access(int off, int size, enum bpf_access_type type,
+			       const struct bpf_prog *prog,
+			       struct bpf_insn_access_aux *info)
+{
+	if (off < 0 || off >= sizeof(struct bpf_nf_ctx))
+		return false;
+
+	if (type == BPF_WRITE)
+		return false;
+
+	switch (off) {
+	case bpf_ctx_range(struct bpf_nf_ctx, skb):
+		if (size != sizeof_field(struct bpf_nf_ctx, skb))
+			return false;
+
+		return nf_ptr_to_btf_id(info, "sk_buff");
+	case bpf_ctx_range(struct bpf_nf_ctx, state):
+		if (size != sizeof_field(struct bpf_nf_ctx, state))
+			return false;
+
+		return nf_ptr_to_btf_id(info, "nf_hook_state");
+	default:
+		return false;
+	}
+
+	return false;
+}
+
+static const struct bpf_func_proto *
+bpf_nf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id);
+}
+
+const struct bpf_verifier_ops netfilter_verifier_ops = {
+	.is_valid_access	= nf_is_valid_access,
+	.get_func_proto		= bpf_nf_func_proto,
+};
-- 
2.39.2

