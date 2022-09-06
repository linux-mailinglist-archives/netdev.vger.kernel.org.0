Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869165AEFA3
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238535AbiIFP4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 11:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiIFPzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 11:55:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE538D3FE
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 08:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662477199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T1YLpg5hiMnuMea1FLzrzVbnfy32mxSqZlIxRFNjEdA=;
        b=CWZdNLEYD+mvyBOTL4lJ1wpo6aANFtsbu+Uza/F6Z4ByBHD8UIpCZ81GUlvrHbjDdg7zxc
        xisC/yPWHKMpRMdPHOhk7NxVKrjR6uAOQoeoaoDEUMAcPC+1m3U5cZyYHRQ+9TYvTes5jq
        SYVl/hM5a5I9zrIPItmOUEw6laJc9jA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-HXU70OF3NhSAqZxuUBtH-g-1; Tue, 06 Sep 2022 11:13:16 -0400
X-MC-Unique: HXU70OF3NhSAqZxuUBtH-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A094A811E90;
        Tue,  6 Sep 2022 15:13:15 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7064D40D296C;
        Tue,  6 Sep 2022 15:13:13 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v11 1/7] selftests/bpf: regroup and declare similar kfuncs selftests in an array
Date:   Tue,  6 Sep 2022 17:12:57 +0200
Message-Id: <20220906151303.2780789-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
References: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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

For light skeletons, we have to rely on the offsetof() macro so we can
statically declare which program we are using.
In the libbpf case, we can rely on bpf_object__find_program_by_name().
So also change the Makefile to generate both light skeletons and normal
ones.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v11:
- use of both light skeletons and normal libbpf

new in v10
---
 tools/testing/selftests/bpf/Makefile          |  5 +-
 .../selftests/bpf/prog_tests/kfunc_call.c     | 81 +++++++++++++++----
 2 files changed, 68 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index eecad99f1735..314216d77b8d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -351,11 +351,12 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		test_subskeleton.skel.h test_subskeleton_lib.skel.h	\
 		test_usdt.skel.h
 
-LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
+LSKELS := fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c \
 	map_ptr_kern.c core_kern.c core_kern_overflow.c
 # Generate both light skeleton and libbpf skeleton for these
-LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c kfunc_call_test_subprog.c
+LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c kfunc_call_test.c \
+	kfunc_call_test_subprog.c
 SKEL_BLACKLIST += $$(LSKELS)
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index eede7c304f86..9dfbe5355a2d 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2021 Facebook */
 #include <test_progs.h>
 #include <network_helpers.h>
+#include "kfunc_call_test.skel.h"
 #include "kfunc_call_test.lskel.h"
 #include "kfunc_call_test_subprog.skel.h"
 #include "kfunc_call_test_subprog.lskel.h"
@@ -9,9 +10,31 @@
 
 #include "cap_helpers.h"
 
-static void test_main(void)
+struct kfunc_test_params {
+	const char *prog_name;
+	unsigned long lskel_prog_desc_offset;
+	int retval;
+};
+
+#define TC_TEST(name, __retval) \
+	{ \
+	  .prog_name = #name, \
+	  .lskel_prog_desc_offset = offsetof(struct kfunc_call_test_lskel, progs.name), \
+	  .retval = __retval, \
+	}
+
+static struct kfunc_test_params kfunc_tests[] = {
+	TC_TEST(kfunc_call_test1, 12),
+	TC_TEST(kfunc_call_test2, 3),
+	TC_TEST(kfunc_call_test_ref_btf_id, 0),
+};
+
+static void verify_success(struct kfunc_test_params *param)
 {
-	struct kfunc_call_test_lskel *skel;
+	struct kfunc_call_test_lskel *lskel = NULL;
+	struct bpf_prog_desc *lskel_prog;
+	struct kfunc_call_test *skel;
+	struct bpf_program *prog;
 	int prog_fd, err;
 	LIBBPF_OPTS(bpf_test_run_opts, topts,
 		.data_in = &pkt_v4,
@@ -19,26 +42,53 @@ static void test_main(void)
 		.repeat = 1,
 	);
 
-	skel = kfunc_call_test_lskel__open_and_load();
+	/* first test with normal libbpf */
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
+
+	if (!ASSERT_EQ(topts.retval, param->retval, "retval"))
+		goto cleanup;
+
+	/* second test with light skeletons */
+	lskel = kfunc_call_test_lskel__open_and_load();
+	if (!ASSERT_OK_PTR(lskel, "lskel"))
+		goto cleanup;
+
+	lskel_prog = (struct bpf_prog_desc *)((char *)lskel + param->lskel_prog_desc_offset);
 
-	prog_fd = skel->progs.kfunc_call_test_ref_btf_id.prog_fd;
+	prog_fd = lskel_prog->prog_fd;
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
-	ASSERT_OK(err, "bpf_prog_test_run(test_ref_btf_id)");
-	ASSERT_EQ(topts.retval, 0, "test_ref_btf_id-retval");
+	if (!ASSERT_OK(err, param->prog_name))
+		goto cleanup;
+
+	ASSERT_EQ(topts.retval, param->retval, "retval");
+
+cleanup:
+	kfunc_call_test__destroy(skel);
+	if (lskel)
+		kfunc_call_test_lskel__destroy(lskel);
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
@@ -121,8 +171,7 @@ static void test_destructive(void)
 
 void test_kfunc_call(void)
 {
-	if (test__start_subtest("main"))
-		test_main();
+	test_main();
 
 	if (test__start_subtest("subprog"))
 		test_subprog();
-- 
2.36.1

