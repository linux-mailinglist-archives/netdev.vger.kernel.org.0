Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5A96E94E1
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbjDTMps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbjDTMpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:45:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC276C7;
        Thu, 20 Apr 2023 05:45:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ppTfF-0002aW-4j; Thu, 20 Apr 2023 14:45:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <bpf@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de, Florian Westphal <fw@strlen.de>
Subject: [PATCH bpf-next v4 6/7] bpf: add test_run support for netfilter program type
Date:   Thu, 20 Apr 2023 14:44:54 +0200
Message-Id: <20230420124455.31099-7-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420124455.31099-1-fw@strlen.de>
References: <20230420124455.31099-1-fw@strlen.de>
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

add glue code so a bpf program can be run using userspace-provided
netfilter state and packet/skb.

Default is to use ipv4:output hook point, but this can be overridden by
userspace.  Userspace provided netfilter state is restricted, only hook and
protocol families can be overridden and only to ipv4/ipv6.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/bpf.h         |   3 +
 net/bpf/test_run.c          | 158 ++++++++++++++++++++++++++++++++++++
 net/netfilter/nf_bpf_link.c |   1 +
 3 files changed, 162 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 18b592fde896..e53ceee1df37 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2264,6 +2264,9 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
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
index f170e8a17974..e79e3a415ca9 100644
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
@@ -1691,6 +1693,162 @@ int bpf_prog_test_run_syscall(struct bpf_prog *prog,
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
+static __be16 nfproto_eth(int nfproto)
+{
+	switch (nfproto) {
+	case NFPROTO_IPV4:
+		return htons(ETH_P_IP);
+	case NFPROTO_IPV6:
+		break;
+	}
+
+	return htons(ETH_P_IPV6);
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
+		.hook = NF_INET_LOCAL_OUT,
+	};
+	u32 size = kattr->test.data_size_in;
+	u32 repeat = kattr->test.repeat;
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
+	if (size < sizeof(struct iphdr))
+		return -EINVAL;
+
+	data = bpf_test_init(kattr, kattr->test.data_size_in, size,
+			     NET_SKB_PAD + NET_IP_ALIGN,
+			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
+	if (IS_ERR(data))
+		return PTR_ERR(data);
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
+	ret = -EINVAL;
+
+	if (hook_state.hook != NF_INET_LOCAL_OUT) {
+		if (size < ETH_HLEN + sizeof(struct iphdr))
+			goto out;
+
+		skb->protocol = eth_type_trans(skb, dev);
+		switch (skb->protocol) {
+		case htons(ETH_P_IP):
+			if (hook_state.pf == NFPROTO_IPV4)
+				break;
+			goto out;
+		case htons(ETH_P_IPV6):
+			if (size < ETH_HLEN + sizeof(struct ipv6hdr))
+				goto out;
+			if (hook_state.pf == NFPROTO_IPV6)
+				break;
+			goto out;
+		default:
+			ret = -EPROTO;
+			goto out;
+		}
+
+		skb_reset_network_header(skb);
+	} else {
+		skb->protocol = nfproto_eth(hook_state.pf);
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
index 49cfc5215386..c36da56d756f 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -166,6 +166,7 @@ int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 }
 
 const struct bpf_prog_ops netfilter_prog_ops = {
+	.test_run = bpf_prog_test_run_nf,
 };
 
 static bool nf_ptr_to_btf_id(struct bpf_insn_access_aux *info, const char *name)
-- 
2.39.2

