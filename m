Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BEC5AB2DB
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 16:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbiIBOEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 10:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbiIBOEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 10:04:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7F8118A76
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662125580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=46mxyRINAwXH1hQbHvRS6x0ECDUnr04nQdzD2pI2obU=;
        b=WcrA3oTBI+MPUe++Izs84+ZRZdsh8rstXZ5nplvdqBPHCANBy2FNJQfG8olmLyfKWFJsWX
        XGlY07+9rU5N34+nmUscoRnsh9C+vA3mwYVkGvF/b1mAzJFGawA5iZjxnvPF93HhaOPWFx
        ZH1V6tscz62nwg8utwvZJccfgN5TQck=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-DAMr-CBTN7ePSwB02vo_dQ-1; Fri, 02 Sep 2022 09:29:49 -0400
X-MC-Unique: DAMr-CBTN7ePSwB02vo_dQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CABF18A64EB;
        Fri,  2 Sep 2022 13:29:48 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3486D492C3B;
        Fri,  2 Sep 2022 13:29:45 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v10 01/23] selftests/bpf: regroup and declare similar kfuncs selftests in an array
Date:   Fri,  2 Sep 2022 15:29:16 +0200
Message-Id: <20220902132938.2409206-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
References: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to tools/testing/selftests/bpf/prog_tests/dynptr.c:
we declare an array of tests that we run one by one in a for loop.

Followup patches will add more similar-ish tests, so avoid a lot of copy
paste by grouping the declaration in an array.

To be able to call bpf_object__find_program_by_name(), we need to use
plain libbpf calls, and not light skeletons. So also change the Makefile
to not generate light skeletons.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

new in v10
---
 tools/testing/selftests/bpf/Makefile          |  2 +-
 .../selftests/bpf/prog_tests/kfunc_call.c     | 56 +++++++++++++------
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index eecad99f1735..b19b0b35aec8 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -351,7 +351,7 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		test_subskeleton.skel.h test_subskeleton_lib.skel.h	\
 		test_usdt.skel.h
 
-LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
+LSKELS := fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c \
 	map_ptr_kern.c core_kern.c core_kern_overflow.c
 # Generate both light skeleton and libbpf skeleton for these
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index eede7c304f86..21e347f46c93 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -2,16 +2,28 @@
 /* Copyright (c) 2021 Facebook */
 #include <test_progs.h>
 #include <network_helpers.h>
-#include "kfunc_call_test.lskel.h"
+#include "kfunc_call_test.skel.h"
 #include "kfunc_call_test_subprog.skel.h"
 #include "kfunc_call_test_subprog.lskel.h"
 #include "kfunc_call_destructive.skel.h"
 
 #include "cap_helpers.h"
 
-static void test_main(void)
+struct kfunc_test_params {
+	const char *prog_name;
+	int retval;
+};
+
+static struct kfunc_test_params kfunc_tests[] = {
+	{"kfunc_call_test1", 12},
+	{"kfunc_call_test2", 3},
+	{"kfunc_call_test_ref_btf_id", 0},
+};
+
+static void verify_success(struct kfunc_test_params *param)
 {
-	struct kfunc_call_test_lskel *skel;
+	struct kfunc_call_test *skel;
+	struct bpf_program *prog;
 	int prog_fd, err;
 	LIBBPF_OPTS(bpf_test_run_opts, topts,
 		.data_in = &pkt_v4,
@@ -19,26 +31,35 @@ static void test_main(void)
 		.repeat = 1,
 	);
 
-	skel = kfunc_call_test_lskel__open_and_load();
+	skel = kfunc_call_test__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "skel"))
 		return;
 
-	prog_fd = skel->progs.kfunc_call_test1.prog_fd;
-	err = bpf_prog_test_run_opts(prog_fd, &topts);
-	ASSERT_OK(err, "bpf_prog_test_run(test1)");
-	ASSERT_EQ(topts.retval, 12, "test1-retval");
+	prog = bpf_object__find_program_by_name(skel->obj, param->prog_name);
+	if (!ASSERT_OK_PTR(prog, "bpf_object__find_program_by_name"))
+		goto cleanup;
 
-	prog_fd = skel->progs.kfunc_call_test2.prog_fd;
+	prog_fd = bpf_program__fd(prog);
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
-	ASSERT_OK(err, "bpf_prog_test_run(test2)");
-	ASSERT_EQ(topts.retval, 3, "test2-retval");
+	if (!ASSERT_OK(err, param->prog_name))
+		goto cleanup;
 
-	prog_fd = skel->progs.kfunc_call_test_ref_btf_id.prog_fd;
-	err = bpf_prog_test_run_opts(prog_fd, &topts);
-	ASSERT_OK(err, "bpf_prog_test_run(test_ref_btf_id)");
-	ASSERT_EQ(topts.retval, 0, "test_ref_btf_id-retval");
+	ASSERT_EQ(topts.retval, param->retval, "retval");
+
+cleanup:
+	kfunc_call_test__destroy(skel);
+}
+
+static void test_main(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(kfunc_tests); i++) {
+		if (!test__start_subtest(kfunc_tests[i].prog_name))
+			continue;
 
-	kfunc_call_test_lskel__destroy(skel);
+		verify_success(&kfunc_tests[i]);
+	}
 }
 
 static void test_subprog(void)
@@ -121,8 +142,7 @@ static void test_destructive(void)
 
 void test_kfunc_call(void)
 {
-	if (test__start_subtest("main"))
-		test_main();
+	test_main();
 
 	if (test__start_subtest("subprog"))
 		test_subprog();
-- 
2.36.1

