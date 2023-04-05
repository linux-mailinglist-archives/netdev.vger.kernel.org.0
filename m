Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D841A6D833E
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbjDEQMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbjDEQMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:12:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0A26E90;
        Wed,  5 Apr 2023 09:11:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pk5jl-0007mc-31; Wed, 05 Apr 2023 18:11:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de, Florian Westphal <fw@strlen.de>
Subject: [PATCH bpf-next 6/6] bpf: add test_run support for netfilter program type
Date:   Wed,  5 Apr 2023 18:11:16 +0200
Message-Id: <20230405161116.13565-7-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405161116.13565-1-fw@strlen.de>
References: <20230405161116.13565-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

also add two simple retval tests: as-is, a return value other
than accept or drop will cause issues.

NF_QUEUE could be implemented later IFF we can guarantee that
attachment of such programs can be rejected if they get attached
to a pf/hook that doesn't support async reinjection.

NF_STOLEN could be implemented via trusted helpers that will eventually
free the skb, else this would leak the skb reference.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/bpf.h                           |   3 +
 net/bpf/test_run.c                            | 143 ++++++++++++++++++
 net/netfilter/nf_bpf_link.c                   |   1 +
 .../selftests/bpf/verifier/netfilter.c        |  23 +++
 4 files changed, 170 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/netfilter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2d8f3f639e68..453cee1efdd3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2235,6 +2235,9 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 				const union bpf_attr *kattr,
 				union bpf_attr __user *uattr);
+int bpf_prog_test_run_nf(struct bpf_prog *prog,
+			 const union bpf_attr *kattr,
+			 union bpf_attr __user *uattr);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index f1652f5fbd2e..c14f577fd987 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -19,7 +19,9 @@
 #include <linux/error-injection.h>
 #include <linux/smp.h>
 #include <linux/sock_diag.h>
+#include <linux/netfilter.h>
 #include <net/xdp.h>
+#include <net/netfilter/nf_bpf_link.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/bpf_test_run.h>
@@ -1690,6 +1692,147 @@ int bpf_prog_test_run_syscall(struct bpf_prog *prog,
 	return err;
 }
 
+static int verify_and_copy_hook_state(struct nf_hook_state *state,
+				      const struct nf_hook_state *user,
+				      struct net_device *dev)
+{
+	if (user->in || user->out)
+		return -EINVAL;
+
+	if (user->net || user->sk || user->okfn)
+		return -EINVAL;
+
+	switch (user->pf) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		switch (state->hook) {
+		case NF_INET_PRE_ROUTING:
+			state->in = dev;
+			break;
+		case NF_INET_LOCAL_IN:
+			state->in = dev;
+			break;
+		case NF_INET_FORWARD:
+			state->in = dev;
+			state->out = dev;
+			break;
+		case NF_INET_LOCAL_OUT:
+			state->out = dev;
+			break;
+		case NF_INET_POST_ROUTING:
+			state->out = dev;
+			break;
+		}
+
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	state->pf = user->pf;
+	state->hook = user->hook;
+
+	return 0;
+}
+
+int bpf_prog_test_run_nf(struct bpf_prog *prog,
+			 const union bpf_attr *kattr,
+			 union bpf_attr __user *uattr)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct net_device *dev = net->loopback_dev;
+	struct nf_hook_state *user_ctx, hook_state = {
+		.pf = NFPROTO_IPV4,
+		.hook = NF_INET_PRE_ROUTING,
+	};
+	u32 size = kattr->test.data_size_in;
+	u32 repeat = kattr->test.repeat;
+	const struct ethhdr *eth;
+	struct bpf_nf_ctx ctx = {
+		.state = &hook_state,
+	};
+	struct sk_buff *skb = NULL;
+	u32 retval, duration;
+	void *data;
+	int ret;
+
+	if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
+		return -EINVAL;
+
+	if (size < ETH_HLEN + sizeof(struct iphdr))
+		return -EINVAL;
+
+	data = bpf_test_init(kattr, kattr->test.data_size_in, size,
+			     NET_SKB_PAD + NET_IP_ALIGN,
+			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	eth = (struct ethhdr *)data;
+
+	if (!repeat)
+		repeat = 1;
+
+	user_ctx = bpf_ctx_init(kattr, sizeof(struct nf_hook_state));
+	if (IS_ERR(user_ctx)) {
+		kfree(data);
+		return PTR_ERR(user_ctx);
+	}
+
+	if (user_ctx) {
+		ret = verify_and_copy_hook_state(&hook_state, user_ctx, dev);
+		if (ret)
+			goto out;
+	}
+
+	skb = slab_build_skb(data);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	data = NULL; /* data released via kfree_skb */
+
+	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
+	__skb_put(skb, size);
+
+	skb->protocol = eth_type_trans(skb, dev);
+
+	skb_reset_network_header(skb);
+
+	ret = -EINVAL;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		if (hook_state.pf == NFPROTO_IPV4)
+			break;
+		goto out;
+	case htons(ETH_P_IPV6):
+		if (size < ETH_HLEN + sizeof(struct ipv6hdr))
+			goto out;
+		if (hook_state.pf == NFPROTO_IPV6)
+			break;
+		goto out;
+	default:
+		ret = -EPROTO;
+		goto out;
+	}
+
+	ctx.skb = skb;
+
+	ret = bpf_test_run(prog, &ctx, repeat, &retval, &duration, false);
+	if (ret)
+		goto out;
+
+	ret = bpf_test_finish(kattr, uattr, NULL, NULL, 0, retval, duration);
+
+out:
+	kfree(user_ctx);
+	kfree_skb(skb);
+	kfree(data);
+	return ret;
+}
+
 static const struct btf_kfunc_id_set bpf_prog_test_kfunc_set = {
 	.owner = THIS_MODULE,
 	.set   = &test_sk_check_kfunc_ids,
diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index 4b22a31d6df5..c27fd569adf1 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -128,6 +128,7 @@ int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 }
 
 const struct bpf_prog_ops netfilter_prog_ops = {
+	.test_run = bpf_prog_test_run_nf,
 };
 
 static bool nf_ptr_to_btf_id(struct bpf_insn_access_aux *info, const char *name)
diff --git a/tools/testing/selftests/bpf/verifier/netfilter.c b/tools/testing/selftests/bpf/verifier/netfilter.c
new file mode 100644
index 000000000000..deeb87afdf50
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/netfilter.c
@@ -0,0 +1,23 @@
+{
+	"netfilter, accept all",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_NETFILTER,
+	.retval = 1,
+	.data = {
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x08, 0x00,
+	},
+},
+{
+	"netfilter, stolen verdict",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 2),
+	BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.errstr = "At program exit the register R0 has value (0x2; 0x0) should have been in (0x0; 0x1)",
+	.prog_type = BPF_PROG_TYPE_NETFILTER,
+},
-- 
2.39.2

