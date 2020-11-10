Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFF32AE150
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 22:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731779AbgKJVDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 16:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgKJVDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 16:03:47 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C868BC0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:03:45 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id f20so8101170ejz.4
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3fT0VynoZf+vP0shmRguJ3BRcKujpePgpwaQtPObR8=;
        b=Uvgh2PFlBt2DC4h0jd2LcvTX+4GyzslJ1neTLkvLaiyoN5dobarfSMDkkP1GSYABMi
         XachprFOyPkXESkzGW73bHoqYdlPA4xOAuavMjdPcRSqycglCEpkodttF52X/DvjpHxh
         xKQdC1neXT62nnkuTjTibOQL9Ekri/sKeg2v7jATsQD9qlkmfnyx2mwKAzdUvRSZr+U9
         QOLDKJlhrqMSMBU54vOsawbq8LjfHWLwBMT2WrWyRB9hwx1grA/wfNK0TO6541NLytlJ
         mHtjUthDIX+rPwL1em95kbRRJvLp5nVFGRse9ozb3MrYMyBZSpc1K+Szvw3DkR5UZT18
         rvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3fT0VynoZf+vP0shmRguJ3BRcKujpePgpwaQtPObR8=;
        b=Jn2VTlCybTbg4jew77KMC0kRkmVqNx+gsfpy6ZlSPlngZnDfcANxFC9r7ITHe+43cd
         aTwK4evbstVQb+1AkatPkfR3fLih9chufIe4KLytauyjPAqalNhxfl2tNpOTIG4bHoEm
         jkG721/KqgLD6dREanLcceI2PDyoCg7LhzNIi4mTWlixPAVx0aOU5+ZsYQA5rsleMSQz
         Jd713cZq0CsyqO+0RFKRe0L7TaRcfs1BNUWRb0tVYkN+CIRA/wZzyl6mC6jfpUKMeHKA
         Ado4LTOtZlhIwjkV+IWjwpoX0B+EIvfZsrr/7TPhv8U3bzFl9BRH0zT1Yz4BCTUrwgiA
         xx9Q==
X-Gm-Message-State: AOAM533iWR5knRRGpaPoU/DqGk9vCTz1cMZFUh17iRDde6pN+UTYLEV1
        Hll+GpMjf9NyvPsAMJV/mxjhyQ==
X-Google-Smtp-Source: ABdhPJyG5SfJYo8lbQSEapbcJK7FJ+VfQC6Ts4YnhVl9ygQglBgBRIwEwRDHMaWThW0INRYmfEoeQQ==
X-Received: by 2002:a17:906:af8c:: with SMTP id mj12mr21223612ejb.85.1605042224326;
        Tue, 10 Nov 2020 13:03:44 -0800 (PST)
Received: from localhost ([2620:10d:c093:400::5:2e6c])
        by smtp.gmail.com with ESMTPSA id j8sm11880258edk.79.2020.11.10.13.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 13:03:43 -0800 (PST)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     kernel-team@fb.com, rdna@fb.com, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andrii@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org, toke@redhat.com, netdev@vger.kernel.org,
        me@ubique.spb.ru
Subject: [PATCH] bpf: relax return code check for subprograms
Date:   Tue, 10 Nov 2020 21:03:42 +0000
Message-Id: <20201110210342.146242-1-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently verifier enforces return code checks for subprograms in the
same manner as it does for program entry points. This prevents returning
arbitrary scalar values from subprograms. Scalar type of returned values
is checked by btf_prepare_func_args() and hence it should be safe to
allow only scalars for now. Relax return code checks for subprograms and
allow any correct scalar values.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Fixes: 51c39bb1d5d10 (bpf: Introduce function-by-function verification)
---
 kernel/bpf/verifier.c                         | 26 ++++++++++++++-----
 .../bpf/prog_tests/test_global_funcs.c        |  1 +
 .../selftests/bpf/progs/test_global_func8.c   | 25 ++++++++++++++++++
 3 files changed, 45 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func8.c

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 10da26e55130..c108b19e1fad 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7791,7 +7791,7 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	return 0;
 }
 
-static int check_return_code(struct bpf_verifier_env *env)
+static int check_return_code(struct bpf_verifier_env *env, bool is_subprog)
 {
 	struct tnum enforce_attach_type_range = tnum_unknown;
 	const struct bpf_prog *prog = env->prog;
@@ -7801,10 +7801,12 @@ static int check_return_code(struct bpf_verifier_env *env)
 	int err;
 
 	/* LSM and struct_ops func-ptr's return type could be "void" */
-	if ((prog_type == BPF_PROG_TYPE_STRUCT_OPS ||
-	     prog_type == BPF_PROG_TYPE_LSM) &&
-	    !prog->aux->attach_func_proto->type)
-		return 0;
+	if (!is_subprog) {
+		if ((prog_type == BPF_PROG_TYPE_STRUCT_OPS ||
+		     prog_type == BPF_PROG_TYPE_LSM) &&
+		    !prog->aux->attach_func_proto->type)
+			return 0;
+	}
 
 	/* eBPF calling convetion is such that R0 is used
 	 * to return the value from eBPF program.
@@ -7821,6 +7823,16 @@ static int check_return_code(struct bpf_verifier_env *env)
 		return -EACCES;
 	}
 
+	reg = cur_regs(env) + BPF_REG_0;
+	if (is_subprog) {
+		if (reg->type != SCALAR_VALUE) {
+			verbose(env, "At subprogram exit the register R0 is not a scalar value (%s)\n",
+				reg_type_str[reg->type]);
+			return -EINVAL;
+		}
+		return 0;
+	}
+
 	switch (prog_type) {
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 		if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
@@ -7874,7 +7886,6 @@ static int check_return_code(struct bpf_verifier_env *env)
 		return 0;
 	}
 
-	reg = cur_regs(env) + BPF_REG_0;
 	if (reg->type != SCALAR_VALUE) {
 		verbose(env, "At program exit the register R0 is not a known value (%s)\n",
 			reg_type_str[reg->type]);
@@ -9266,6 +9277,7 @@ static int do_check(struct bpf_verifier_env *env)
 	int insn_cnt = env->prog->len;
 	bool do_print_state = false;
 	int prev_insn_idx = -1;
+	const bool is_subprog = env->cur_state->frame[0]->subprogno;
 
 	for (;;) {
 		struct bpf_insn *insn;
@@ -9530,7 +9542,7 @@ static int do_check(struct bpf_verifier_env *env)
 				if (err)
 					return err;
 
-				err = check_return_code(env);
+				err = check_return_code(env, is_subprog);
 				if (err)
 					return err;
 process_bpf_exit:
diff --git a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
index 193002b14d7f..32e4348b714b 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
@@ -60,6 +60,7 @@ void test_test_global_funcs(void)
 		{ "test_global_func5.o" , "expected pointer to ctx, but got PTR" },
 		{ "test_global_func6.o" , "modified ctx ptr R2" },
 		{ "test_global_func7.o" , "foo() doesn't return scalar" },
+		{ "test_global_func8.o" },
 	};
 	libbpf_print_fn_t old_print_fn = NULL;
 	int err, i, duration = 0;
diff --git a/tools/testing/selftests/bpf/progs/test_global_func8.c b/tools/testing/selftests/bpf/progs/test_global_func8.c
new file mode 100644
index 000000000000..1e9a87f30b7c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_global_func8.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#include <stddef.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+__attribute__ ((noinline))
+int bar(struct __sk_buff *skb)
+{
+	return bpf_get_prandom_u32();
+}
+
+static __always_inline int foo(struct __sk_buff *skb)
+{
+	if (!bar(skb))
+		return 0;
+
+	return 1;
+}
+
+SEC("cgroup_skb/ingress")
+int test_cls(struct __sk_buff *skb)
+{
+	return foo(skb);
+}
-- 
2.24.1

