Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBC96E88AA
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 05:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbjDTD2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 23:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbjDTD2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 23:28:08 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD844231
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 20:28:04 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b60366047so503775b3a.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 20:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681961284; x=1684553284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDyVsaH4pVJocXiNYxHqnYnlvV9ip3excIUFff8vOpo=;
        b=bSRgqMnlr0Mkn8uDnOHS9EVNtawNiErGgQ8TMPPeH3fNCfqjgdmHSLBqacH5y2+hjl
         7+7qYJvFpWiExSjMuHWir+g63IEG3q0vtMbm/Brd3hsIEV93D+pTwjwUgMiyiEASJn8X
         XdJGYRhLqIGkdcJNy0zEooO+XjsjfV6sD3VDB3WVIBV9H9asO9MaG6KeizaAw6YTl6WR
         w3aTQQBPA+H5ymbOt9kxjgP33DKA494k0JDkwHoHBp1EN3pitGRKQLCa+BLQRBD85ERj
         ub6ZsNcBIvLYRZ9gQDBFayBe21LVOlOyYDK/QnoH7rxxetvcRds3Y5FKw3P8bKXWpyAv
         4dzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681961284; x=1684553284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YDyVsaH4pVJocXiNYxHqnYnlvV9ip3excIUFff8vOpo=;
        b=dNnLQLuaPRDAGttaspRtLTHMYhqqV9o85zlxk5frbpjFWQb3NzqlROx8wih8ZkgggI
         vuvUS/qp4U/9nB3xYOFeyGvrgnW3BK+yiN5mIBfpt1DaxoNUIW4422bLknBRhkmJp7Vf
         ubnYLzXAkrEQJ9Xw456SWO6R4Sz+ECBzpPP+l18SGqB96lyJyqwHAKYUtCwDruKOc2cT
         S6o7NQC2ZEJh5VDS/pdnHmJXHeonISuBFCN0m6tThWXpFrWS6BCxaAgmScHKLPZFF8d/
         xJkTVJi/yffjThRWU4c6Rtr4ci16EhXT3x75FvJA81zgMXnRgWcgrth2IYRFRsVbbZ3z
         69zQ==
X-Gm-Message-State: AAQBX9cEHkiiiHuH5vKoFjAy6gmgy7l5HPQaW9Mu0gDBPpmbSdPV8llQ
        mrdvHQ3GBNBLpvFAGcNHSIYlNg==
X-Google-Smtp-Source: AKy350ao8p06O+vO1ADPVqJeEMwwoZVuG0RI8jQ8abMA7rOJTOIumxZ2VImkDhIbEssKZPr6IgfoPw==
X-Received: by 2002:a05:6a20:8f0d:b0:ef:5f:3c15 with SMTP id b13-20020a056a208f0d00b000ef005f3c15mr143865pzk.47.1681961284422;
        Wed, 19 Apr 2023 20:28:04 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id z15-20020a655a4f000000b00517abaac366sm115231pgs.74.2023.04.19.20.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 20:28:04 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        yangzhenze@bytedance.com, wangdongdong.6@bytedance.com,
        zhouchengming@bytedance.com, zhoufeng.zf@bytedance.com
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: Add test to access integer type of variable array
Date:   Thu, 20 Apr 2023 11:27:35 +0800
Message-Id: <20230420032735.27760-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230420032735.27760-1-zhoufeng.zf@bytedance.com>
References: <20230420032735.27760-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Add prog test for accessing integer type of variable array in tracing
program.
In addition, hook load_balance function to access sd->span[0], only
to confirm whether the load is successful. Because there is no direct
way to trigger load_balance call.

Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 20 +++++++++++++++++++
 .../bpf/prog_tests/access_variable_array.c    | 16 +++++++++++++++
 .../selftests/bpf/prog_tests/tracing_struct.c |  2 ++
 .../bpf/progs/test_access_variable_array.c    | 19 ++++++++++++++++++
 .../selftests/bpf/progs/tracing_struct.c      | 13 ++++++++++++
 5 files changed, 70 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/access_variable_array.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_access_variable_array.c

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index fe847ebfb731..52785ba671e6 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -28,6 +28,11 @@ struct bpf_testmod_struct_arg_2 {
 	long b;
 };
 
+struct bpf_testmod_struct_arg_3 {
+	int a;
+	int b[];
+};
+
 __diag_push();
 __diag_ignore_all("-Wmissing-prototypes",
 		  "Global functions as their definitions will be in bpf_testmod.ko BTF");
@@ -63,6 +68,12 @@ bpf_testmod_test_struct_arg_5(void) {
 	return bpf_testmod_test_struct_arg_result;
 }
 
+noinline int
+bpf_testmod_test_struct_arg_6(struct bpf_testmod_struct_arg_3 *a) {
+	bpf_testmod_test_struct_arg_result = a->b[0];
+	return bpf_testmod_test_struct_arg_result;
+}
+
 __bpf_kfunc void
 bpf_testmod_test_mod_kfunc(int i)
 {
@@ -195,6 +206,7 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 	};
 	struct bpf_testmod_struct_arg_1 struct_arg1 = {10};
 	struct bpf_testmod_struct_arg_2 struct_arg2 = {2, 3};
+	struct bpf_testmod_struct_arg_3 *struct_arg3;
 	int i = 1;
 
 	while (bpf_testmod_return_ptr(i))
@@ -206,6 +218,14 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 	(void)bpf_testmod_test_struct_arg_4(struct_arg1, 1, 2, 3, struct_arg2);
 	(void)bpf_testmod_test_struct_arg_5();
 
+	struct_arg3 = kmalloc((sizeof(struct bpf_testmod_struct_arg_3) +
+				sizeof(int)), GFP_KERNEL);
+	if (struct_arg3 != NULL) {
+		struct_arg3->b[0] = 1;
+		(void)bpf_testmod_test_struct_arg_6(struct_arg3);
+		kfree(struct_arg3);
+	}
+
 	/* This is always true. Use the check to make sure the compiler
 	 * doesn't remove bpf_testmod_loop_test.
 	 */
diff --git a/tools/testing/selftests/bpf/prog_tests/access_variable_array.c b/tools/testing/selftests/bpf/prog_tests/access_variable_array.c
new file mode 100644
index 000000000000..08131782437c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/access_variable_array.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Bytedance */
+
+#include <test_progs.h>
+#include "test_access_variable_array.skel.h"
+
+void test_access_variable_array(void)
+{
+	struct test_access_variable_array *skel;
+
+	skel = test_access_variable_array__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_access_variable_array__open_and_load"))
+		return;
+
+	test_access_variable_array__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/tracing_struct.c b/tools/testing/selftests/bpf/prog_tests/tracing_struct.c
index 48dc9472e160..1c75a32186d6 100644
--- a/tools/testing/selftests/bpf/prog_tests/tracing_struct.c
+++ b/tools/testing/selftests/bpf/prog_tests/tracing_struct.c
@@ -53,6 +53,8 @@ static void test_fentry(void)
 
 	ASSERT_EQ(skel->bss->t5_ret, 1, "t5 ret");
 
+	ASSERT_EQ(skel->bss->t6, 1, "t6 ret");
+
 	tracing_struct__detach(skel);
 destroy_skel:
 	tracing_struct__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/test_access_variable_array.c b/tools/testing/selftests/bpf/progs/test_access_variable_array.c
new file mode 100644
index 000000000000..808c49b79889
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_access_variable_array.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2023 Bytedance */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+unsigned long span = 0;
+
+SEC("fentry/load_balance")
+int BPF_PROG(fentry_fentry, int this_cpu, struct rq *this_rq,
+		struct sched_domain *sd)
+{
+	span = sd->span[0];
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/tracing_struct.c b/tools/testing/selftests/bpf/progs/tracing_struct.c
index e718f0ebee7d..c435a3a8328a 100644
--- a/tools/testing/selftests/bpf/progs/tracing_struct.c
+++ b/tools/testing/selftests/bpf/progs/tracing_struct.c
@@ -13,12 +13,18 @@ struct bpf_testmod_struct_arg_2 {
 	long b;
 };
 
+struct bpf_testmod_struct_arg_3 {
+	int a;
+	int b[];
+};
+
 long t1_a_a, t1_a_b, t1_b, t1_c, t1_ret, t1_nregs;
 __u64 t1_reg0, t1_reg1, t1_reg2, t1_reg3;
 long t2_a, t2_b_a, t2_b_b, t2_c, t2_ret;
 long t3_a, t3_b, t3_c_a, t3_c_b, t3_ret;
 long t4_a_a, t4_b, t4_c, t4_d, t4_e_a, t4_e_b, t4_ret;
 long t5_ret;
+int t6;
 
 SEC("fentry/bpf_testmod_test_struct_arg_1")
 int BPF_PROG2(test_struct_arg_1, struct bpf_testmod_struct_arg_2, a, int, b, int, c)
@@ -117,4 +123,11 @@ int BPF_PROG2(test_struct_arg_10, int, ret)
 	return 0;
 }
 
+SEC("fentry/bpf_testmod_test_struct_arg_6")
+int BPF_PROG2(test_struct_arg_11, struct bpf_testmod_struct_arg_3 *, a)
+{
+	t6 = a->b[0];
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.20.1

