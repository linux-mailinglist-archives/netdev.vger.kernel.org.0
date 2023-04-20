Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78C86E94E4
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbjDTMpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbjDTMps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:45:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6BD7A97;
        Thu, 20 Apr 2023 05:45:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ppTfJ-0002b1-8Y; Thu, 20 Apr 2023 14:45:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <bpf@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de, Florian Westphal <fw@strlen.de>
Subject: [PATCH bpf-next v4 7/7] selftests/bpf: add missing netfilter return value and ctx access tests
Date:   Thu, 20 Apr 2023 14:44:55 +0200
Message-Id: <20230420124455.31099-8-fw@strlen.de>
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

Extend prog_tests with two test cases:

 # ./test_progs --allow=verifier_netfilter_retcode
 #278/1   verifier_netfilter_retcode/bpf_exit with invalid return code. test1:OK
 #278/2   verifier_netfilter_retcode/bpf_exit with valid return code. test2:OK
 #278/3   verifier_netfilter_retcode/bpf_exit with valid return code. test3:OK
 #278/4   verifier_netfilter_retcode/bpf_exit with invalid return code. test4:OK
 #278     verifier_netfilter_retcode:OK

This checks that only accept and drop (0,1) are permitted.

NF_QUEUE could be implemented later if we can guarantee that attachment
of such programs can be rejected if they get attached to a pf/hook that
doesn't support async reinjection.

NF_STOLEN could be implemented via trusted helpers that can guarantee
that the skb will eventually be free'd.

v4: test case for bpf_nf_ctx access checks, requested by Alexei Starovoitov.

 # ./test_progs --allow=verifier_netfilter_ctx
 #280/1   verifier_netfilter_ctx/netfilter invalid context access, size too short:OK
 #280/2   verifier_netfilter_ctx/netfilter invalid context access, size too short:OK
 #280/3   verifier_netfilter_ctx/netfilter invalid context access, past end of ctx:OK
 #280/4   verifier_netfilter_ctx/netfilter invalid context, write:OK
 #280/5   verifier_netfilter_ctx/netfilter valid context access:OK
 #280/6   verifier_netfilter_ctx/netfilter valid context access @unpriv:OK
 #280     verifier_netfilter_ctx:OK
Summary: 1/6 PASSED, 0 SKIPPED, 0 FAILED

This checks:
1/2: partial reads of ctx->{skb,state} are rejected
3. read access past sizeof(ctx) is rejected
4. write to ctx content, e.g. 'ctx->skb = NULL;' is rejected
5. ctx->skb and ctx->state can be read (valid case), but ...
6. ... same program fails for unpriv (CAP_NET_ADMIN needed).

Link: https://lore.kernel.org/bpf/20230419021152.sjq4gttphzzy6b5f@dhcp-172-26-102-232.dhcp.thefacebook.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/bpf/prog_tests/verifier.c       |  4 +
 .../bpf/progs/verifier_netfilter_ctx.c        | 82 +++++++++++++++++++
 .../bpf/progs/verifier_netfilter_retcode.c    | 49 +++++++++++
 3 files changed, 135 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_netfilter_ctx.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_netfilter_retcode.c

diff --git a/tools/testing/selftests/bpf/prog_tests/verifier.c b/tools/testing/selftests/bpf/prog_tests/verifier.c
index 25bc8958dbfe..2b4ded63ce9f 100644
--- a/tools/testing/selftests/bpf/prog_tests/verifier.c
+++ b/tools/testing/selftests/bpf/prog_tests/verifier.c
@@ -29,6 +29,8 @@
 #include "verifier_map_ret_val.skel.h"
 #include "verifier_masking.skel.h"
 #include "verifier_meta_access.skel.h"
+#include "verifier_netfilter_ctx.skel.h"
+#include "verifier_netfilter_retcode.skel.h"
 #include "verifier_raw_stack.skel.h"
 #include "verifier_raw_tp_writable.skel.h"
 #include "verifier_reg_equal.skel.h"
@@ -94,6 +96,8 @@ void test_verifier_map_ptr(void)              { RUN(verifier_map_ptr); }
 void test_verifier_map_ret_val(void)          { RUN(verifier_map_ret_val); }
 void test_verifier_masking(void)              { RUN(verifier_masking); }
 void test_verifier_meta_access(void)          { RUN(verifier_meta_access); }
+void test_verifier_netfilter_ctx(void)        { RUN(verifier_netfilter_ctx); }
+void test_verifier_netfilter_retcode(void)    { RUN(verifier_netfilter_retcode); }
 void test_verifier_raw_stack(void)            { RUN(verifier_raw_stack); }
 void test_verifier_raw_tp_writable(void)      { RUN(verifier_raw_tp_writable); }
 void test_verifier_reg_equal(void)            { RUN(verifier_reg_equal); }
diff --git a/tools/testing/selftests/bpf/progs/verifier_netfilter_ctx.c b/tools/testing/selftests/bpf/progs/verifier_netfilter_ctx.c
new file mode 100644
index 000000000000..861b2266179f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/verifier_netfilter_ctx.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include "bpf_misc.h"
+
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("netfilter")
+__description("netfilter invalid context access, size too short")
+__failure __msg("invalid bpf_context access")
+__naked void with_invalid_ctx_access_test1(void)
+{
+	asm volatile ("					\
+	r2 = *(u8*)(r1 + %[__bpf_nf_ctx_state]);	\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm_const(__bpf_nf_ctx_state, offsetof(struct bpf_nf_ctx, state))
+	: __clobber_all);
+}
+
+SEC("netfilter")
+__description("netfilter invalid context access, size too short")
+__failure __msg("invalid bpf_context access")
+__naked void with_invalid_ctx_access_test2(void)
+{
+	asm volatile ("					\
+	r2 = *(u16*)(r1 + %[__bpf_nf_ctx_skb]);	\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm_const(__bpf_nf_ctx_skb, offsetof(struct bpf_nf_ctx, skb))
+	: __clobber_all);
+}
+
+SEC("netfilter")
+__description("netfilter invalid context access, past end of ctx")
+__failure __msg("invalid bpf_context access")
+__naked void with_invalid_ctx_access_test3(void)
+{
+	asm volatile ("					\
+	r2 = *(u64*)(r1 + %[__bpf_nf_ctx_size]);	\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm_const(__bpf_nf_ctx_size, sizeof(struct bpf_nf_ctx))
+	: __clobber_all);
+}
+
+SEC("netfilter")
+__description("netfilter invalid context, write")
+__failure __msg("invalid bpf_context access")
+__naked void with_invalid_ctx_access_test4(void)
+{
+	asm volatile ("					\
+	r2 = r1;					\
+	*(u64*)(r2 + 0) = r1;				\
+	r0 = 1;						\
+	exit;						\
+"	:
+	: __imm_const(__bpf_nf_ctx_skb, offsetof(struct bpf_nf_ctx, skb))
+	: __clobber_all);
+}
+
+SEC("netfilter")
+__description("netfilter valid context access")
+__success __failure_unpriv
+__retval(1)
+__naked void with_invalid_ctx_access_test5(void)
+{
+	asm volatile ("					\
+	r2 = *(u64*)(r1 + %[__bpf_nf_ctx_state]);	\
+	r1 = *(u64*)(r1 + %[__bpf_nf_ctx_skb]);		\
+	r0 = 1;						\
+	exit;						\
+"	:
+	: __imm_const(__bpf_nf_ctx_state, offsetof(struct bpf_nf_ctx, state)),
+	  __imm_const(__bpf_nf_ctx_skb, offsetof(struct bpf_nf_ctx, skb))
+	: __clobber_all);
+}
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

