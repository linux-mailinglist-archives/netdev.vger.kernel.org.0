Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9B22B21DB
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 18:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgKMRRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 12:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgKMRRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 12:17:47 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38FFC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 09:18:00 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o9so14571099ejg.1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 09:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YhCVPybufP4Udi2DHhySYxWlKgaOAdJWsU5QzruK82I=;
        b=moGXPazpO1VQB12tI7Vgdnkpc7XUXrfhNxI4gWC2p7h0/iOMpWlokk1QrMFfM3L+EK
         mQ4P+OaU5zAH8WYImPqiCvEidwdWy5c3zLm/TUoYhIDDuLxQpaL89iSEJh9hkQKrFjwH
         r1fQbFAP3kQW74QJHcsmGyOLIBpsyt6/oC6J8WsUb8SvwaC6VXmWScsv4aYB0NWhEVJw
         9to0bJE9mxrXGZPdiK126G2LXIu1zpFMlN58RNPJ+k3+7wxMUiFBv7o3dX942pgoBe4Y
         iZfs1VCdLq9oLrxCiN+WDf/07eCH0RBOCgt3FowuQuh6f2p0NZnf3gxmZcNaLVamTaJf
         rbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YhCVPybufP4Udi2DHhySYxWlKgaOAdJWsU5QzruK82I=;
        b=tvHYyf6/46hjdIommIvlleqXw4bmv6WGrVWwMzbklArSKo9aQTSb2zDWZ3hQM/xeC7
         4OOQvhcHbExBesometLa27cNVKF275hyIID4axM3nmavB4gZv0B58GzmNpCXGV93iTJP
         uCQNz9OMawKkzjZosiYvfaQTD0vUDgr8dVNxwkZFBmVbaK1Icuu8VJMRqsz7bdemB8BH
         k3XrsU2FpGS1IcLqobd0/W675nNFNA6CMjCBkdigxcVys/XEdN+MJ+QH9UWwSIudBtMW
         BRNS1FRxzwQIDO2tQxI6uxJf8PLmoa4FroL4WYM5QeQ9ZaPw5Gxhu14BovJ5SXVRoA0b
         l/6A==
X-Gm-Message-State: AOAM533+AEMGIPSXPiyn5Kw0aKPx4V6fhTSZCBbDU4UA6JVUh79cflqh
        p4zRimKvj5pcEE+q46X8io+ecQ==
X-Google-Smtp-Source: ABdhPJyUXHWYW/MtZAVdr3Am9alhpXEa0cgn6J9YamtmcHswf0N+3RanTzmhF0gQxViS+FOGWte5LQ==
X-Received: by 2002:a17:906:4753:: with SMTP id j19mr2756166ejs.65.1605287879462;
        Fri, 13 Nov 2020 09:17:59 -0800 (PST)
Received: from localhost ([2620:10d:c093:400::5:7b07])
        by smtp.gmail.com with ESMTPSA id f19sm4222579ejk.116.2020.11.13.09.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 09:17:58 -0800 (PST)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     kernel-team@fb.com, rdna@fb.com, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andrii@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org, toke@redhat.com, netdev@vger.kernel.org,
        me@ubique.spb.ru
Subject: [PATCH bpf v2] bpf: relax return code check for subprograms
Date:   Fri, 13 Nov 2020 17:17:56 +0000
Message-Id: <20201113171756.90594-1-me@ubique.spb.ru>
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
v1 -> v2:
 - Move is_subprog flag determination to check_return_code()
 - Remove unneeded intermediate function from tests
 - Use __noinline instead of __attribute__((noinline)) in tests

 kernel/bpf/verifier.c                         | 15 +++++++++++++--
 .../bpf/prog_tests/test_global_funcs.c        |  1 +
 .../selftests/bpf/progs/test_global_func8.c   | 19 +++++++++++++++++++
 3 files changed, 33 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func8.c

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6204ec705d80..1388bf733071 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7786,9 +7786,11 @@ static int check_return_code(struct bpf_verifier_env *env)
 	struct tnum range = tnum_range(0, 1);
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
 	int err;
+	const bool is_subprog = env->cur_state->frame[0]->subprogno;
 
 	/* LSM and struct_ops func-ptr's return type could be "void" */
-	if ((prog_type == BPF_PROG_TYPE_STRUCT_OPS ||
+	if (!is_subprog &&
+	    (prog_type == BPF_PROG_TYPE_STRUCT_OPS ||
 	     prog_type == BPF_PROG_TYPE_LSM) &&
 	    !prog->aux->attach_func_proto->type)
 		return 0;
@@ -7808,6 +7810,16 @@ static int check_return_code(struct bpf_verifier_env *env)
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
@@ -7861,7 +7873,6 @@ static int check_return_code(struct bpf_verifier_env *env)
 		return 0;
 	}
 
-	reg = cur_regs(env) + BPF_REG_0;
 	if (reg->type != SCALAR_VALUE) {
 		verbose(env, "At program exit the register R0 is not a known value (%s)\n",
 			reg_type_str[reg->type]);
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
index 000000000000..d55a6544b1ab
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_global_func8.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#include <stddef.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+__noinline int foo(struct __sk_buff *skb)
+{
+	return bpf_get_prandom_u32();
+}
+
+SEC("cgroup_skb/ingress")
+int test_cls(struct __sk_buff *skb)
+{
+	if (!foo(skb))
+		return 0;
+
+	return 1;
+}
-- 
2.24.1

