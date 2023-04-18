Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7466D6E6594
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 15:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjDRNL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 09:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbjDRNLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 09:11:21 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DC916B1C;
        Tue, 18 Apr 2023 06:11:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pol75-0004GQ-7v; Tue, 18 Apr 2023 15:11:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <bpf@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de, Florian Westphal <fw@strlen.de>
Subject: [PATCH bpf-next v3 6/6] bpf: add test_run support for netfilter program type
Date:   Tue, 18 Apr 2023 15:10:38 +0200
Message-Id: <20230418131038.18054-7-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230418131038.18054-1-fw@strlen.de>
References: <20230418131038.18054-1-fw@strlen.de>
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

also extend prog_tests with a small retval test: values other
than accept or drop (0, 1) will cause issues.

NF_QUEUE could be implemented later if we can guarantee that attachment
of such programs can be rejected if they get attached to a pf/hook that
doesn't support async reinjection.

NF_STOLEN could be implemented via trusted helpers that can guarantee
that the skb will eventually be free'd.

$ ./test_progs --allow=verifier_netfilter_retcode
 #278/1   verifier_netfilter_retcode/bpf_exit with invalid return code. test1:OK
 #278/2   verifier_netfilter_retcode/bpf_exit with valid return code. test2:OK
 #278/3   verifier_netfilter_retcode/bpf_exit with valid return code. test3:OK
 #278/4   verifier_netfilter_retcode/bpf_exit with invalid return code. test4:OK
 #278     verifier_netfilter_retcode:OK

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/bpf.h                           |   3 +
 net/bpf/test_run.c                            | 140 ++++++++++++++++++
 net/netfilter/nf_bpf_link.c                   |   1 +
 .../selftests/bpf/prog_tests/verifier.c       |   2 +
 .../bpf/progs/verifier_netfilter_retcode.c    |  49 ++++++
 5 files changed, 195 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_netfilter_retcode.c

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
index f170e8a17974..1f6d785ad028 100644
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
@@ -1691,6 +1693,144 @@ int bpf_prog_test_run_syscall(struct bpf_prog *prog,
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
index 2d12c978e4e7..01292e654b6a 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -167,6 +167,7 @@ int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 }
 
 const struct bpf_prog_ops netfilter_prog_ops = {
+	.test_run = bpf_prog_test_run_nf,
 };
 
 static bool nf_ptr_to_btf_id(struct bpf_insn_access_aux *info, const char *name)
diff --git a/tools/testing/selftests/bpf/prog_tests/verifier.c b/tools/testing/selftests/bpf/prog_tests/verifier.c
index 25bc8958dbfe..491efd5f22ff 100644
--- a/tools/testing/selftests/bpf/prog_tests/verifier.c
+++ b/tools/testing/selftests/bpf/prog_tests/verifier.c
@@ -29,6 +29,7 @@
 #include "verifier_map_ret_val.skel.h"
 #include "verifier_masking.skel.h"
 #include "verifier_meta_access.skel.h"
+#include "verifier_netfilter_retcode.skel.h"
 #include "verifier_raw_stack.skel.h"
 #include "verifier_raw_tp_writable.skel.h"
 #include "verifier_reg_equal.skel.h"
@@ -94,6 +95,7 @@ void test_verifier_map_ptr(void)              { RUN(verifier_map_ptr); }
 void test_verifier_map_ret_val(void)          { RUN(verifier_map_ret_val); }
 void test_verifier_masking(void)              { RUN(verifier_masking); }
 void test_verifier_meta_access(void)          { RUN(verifier_meta_access); }
+void test_verifier_netfilter_retcode(void)    { RUN(verifier_netfilter_retcode); }
 void test_verifier_raw_stack(void)            { RUN(verifier_raw_stack); }
 void test_verifier_raw_tp_writable(void)      { RUN(verifier_raw_tp_writable); }
 void test_verifier_reg_equal(void)            { RUN(verifier_reg_equal); }
diff --git a/tools/testing/selftests/bpf/progs/verifier_netfilter_retcode.c b/tools/testing/selftests/bpf/progs/verifier_netfilter_retcode.c
new file mode 100644
index 000000000000..353ae6da00e1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/verifier_netfilter_retcode.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_misc.h"
+
+SEC("netfilter")
+__description("bpf_exit with invalid return code. test1")
+__failure __msg("R0 is not a known value")
+__naked void with_invalid_return_code_test1(void)
+{
+	asm volatile ("					\
+	r0 = *(u64*)(r1 + 0);				\
+	exit;						\
+"	::: __clobber_all);
+}
+
+SEC("netfilter")
+__description("bpf_exit with valid return code. test2")
+__success
+__naked void with_valid_return_code_test2(void)
+{
+	asm volatile ("					\
+	r0 = 0;						\
+	exit;						\
+"	::: __clobber_all);
+}
+
+SEC("netfilter")
+__description("bpf_exit with valid return code. test3")
+__success
+__naked void with_valid_return_code_test3(void)
+{
+	asm volatile ("					\
+	r0 = 1;						\
+	exit;						\
+"	::: __clobber_all);
+}
+
+SEC("netfilter")
+__description("bpf_exit with invalid return code. test4")
+__failure __msg("R0 has value (0x2; 0x0)")
+__naked void with_invalid_return_code_test4(void)
+{
+	asm volatile ("					\
+	r0 = 2;						\
+	exit;						\
+"	::: __clobber_all);
+}
-- 
2.39.2

