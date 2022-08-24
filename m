Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3C159FBC0
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbiHXNnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238616AbiHXNmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:42:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982587E81E
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661348500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QVggoH2D1Sfqhp8qcNq7f5fPlJEm/+MJfsGjwf+NXxw=;
        b=TOL/cuJIWt/38f0G4SJXP8lnihN50mdTXSgWl0b7K8581p6pI7ZYW1YYJJgUI60aGVUZB9
        mnOeKySimkWyg0OD37nrOg5HE98SUCgPPxkSBZZi4R/2mMoGud+lggBmsk3LxfaBvNyivI
        PeFwyl10yd61+3XH/kR5E0HdnxM9GRc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-uZlRuoa5OpOUurDF89YuDw-1; Wed, 24 Aug 2022 09:41:35 -0400
X-MC-Unique: uZlRuoa5OpOUurDF89YuDw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9774B811E90;
        Wed, 24 Aug 2022 13:41:19 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B6DC945D7;
        Wed, 24 Aug 2022 13:41:16 +0000 (UTC)
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
Subject: [PATCH bpf-next v9 05/23] selftests/bpf: Add tests for kfunc returning a memory pointer
Date:   Wed, 24 Aug 2022 15:40:35 +0200
Message-Id: <20220824134055.1328882-6-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We add 2 new kfuncs that are following the RET_PTR_TO_MEM
capability from the previous commit.
Then we test them in selftests:
the first tests are testing valid case, and are not failing,
and the later ones are actually preventing the program to be loaded
because they are wrong.

To work around that, we mark the failing ones as not autoloaded
(with SEC("?tc")), and we manually enable them one by one, ensuring
the verifier rejects them.

To be able to use bpf_program__set_autoload() from libbpf, we need
to use a plain skeleton, not a light-skeleton, and this is why we
also change the Makefile to generate both for kfunc_call_test.c

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v9:
- updated to match upstream (net/bpf/test_run.c id sets is now using
  flags)

no changes in v8

changes in v7:
- removed stray include/linux/btf.h change

new in v6
---
 net/bpf/test_run.c                            | 20 +++++
 tools/testing/selftests/bpf/Makefile          |  5 +-
 .../selftests/bpf/prog_tests/kfunc_call.c     | 48 ++++++++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 89 +++++++++++++++++++
 4 files changed, 160 insertions(+), 2 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index f16baf977a21..6accd57d4ded 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -606,6 +606,24 @@ noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
 	WARN_ON_ONCE(1);
 }
 
+static int *__bpf_kfunc_call_test_get_mem(struct prog_test_ref_kfunc *p, const int size)
+{
+	if (size > 2 * sizeof(int))
+		return NULL;
+
+	return (int *)p;
+}
+
+noinline int *bpf_kfunc_call_test_get_rdwr_mem(struct prog_test_ref_kfunc *p, const int rdwr_buf_size)
+{
+	return __bpf_kfunc_call_test_get_mem(p, rdwr_buf_size);
+}
+
+noinline int *bpf_kfunc_call_test_get_rdonly_mem(struct prog_test_ref_kfunc *p, const int rdonly_buf_size)
+{
+	return __bpf_kfunc_call_test_get_mem(p, rdonly_buf_size);
+}
+
 noinline struct prog_test_ref_kfunc *
 bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **pp, int a, int b)
 {
@@ -712,6 +730,8 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_memb_acquire, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_kfunc_call_memb_release, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_kfunc_call_memb1_release, KF_RELEASE)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_get_rdwr_mem, KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_get_rdonly_mem, KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_kptr_get, KF_ACQUIRE | KF_RET_NULL | KF_KPTR_GET)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_pass_ctx)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_pass1)
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 8d59ec7f4c2d..0905315ff86d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -350,11 +350,12 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		test_subskeleton.skel.h test_subskeleton_lib.skel.h	\
 		test_usdt.skel.h
 
-LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
+LSKELS := fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c \
 	map_ptr_kern.c core_kern.c core_kern_overflow.c
 # Generate both light skeleton and libbpf skeleton for these
-LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c kfunc_call_test_subprog.c
+LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c kfunc_call_test.c	\
+		kfunc_call_test_subprog.c
 SKEL_BLACKLIST += $$(LSKELS)
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index 1edad012fe01..590417d48962 100644
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
@@ -53,10 +54,12 @@ static void test_main(void)
 	prog_fd = skel->progs.kfunc_syscall_test.prog_fd;
 	err = bpf_prog_test_run_opts(prog_fd, &syscall_topts);
 	ASSERT_OK(err, "bpf_prog_test_run(syscall_test)");
+	ASSERT_EQ(syscall_topts.retval, 0, "syscall_test-retval");
 
 	prog_fd = skel->progs.kfunc_syscall_test_fail.prog_fd;
 	err = bpf_prog_test_run_opts(prog_fd, &syscall_topts);
 	ASSERT_ERR(err, "bpf_prog_test_run(syscall_test_fail)");
+	ASSERT_EQ(syscall_topts.retval, 0, "syscall_test_fail-retval");
 
 	syscall_topts.ctx_in = NULL;
 	syscall_topts.ctx_size_in = 0;
@@ -147,6 +150,48 @@ static void test_destructive(void)
 	cap_enable_effective(save_caps, NULL);
 }
 
+static void test_get_mem(void)
+{
+	struct kfunc_call_test *skel;
+	int prog_fd, err;
+	LIBBPF_OPTS(bpf_test_run_opts, topts,
+		.data_in = &pkt_v4,
+		.data_size_in = sizeof(pkt_v4),
+		.repeat = 1,
+	);
+
+	skel = kfunc_call_test__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.kfunc_call_test_get_mem);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "bpf_prog_test_run(test_get_mem)");
+	ASSERT_EQ(topts.retval, 42, "test_get_mem-retval");
+
+	kfunc_call_test__destroy(skel);
+
+	/* start the various failing tests */
+	skel = kfunc_call_test__open();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		return;
+
+	bpf_program__set_autoload(skel->progs.kfunc_call_test_get_mem_fail1, true);
+	err = kfunc_call_test__load(skel);
+	ASSERT_ERR(err, "load(kfunc_call_test_get_mem_fail1)");
+	kfunc_call_test__destroy(skel);
+
+	skel = kfunc_call_test__open();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		return;
+
+	bpf_program__set_autoload(skel->progs.kfunc_call_test_get_mem_fail2, true);
+	err = kfunc_call_test__load(skel);
+	ASSERT_ERR(err, "load(kfunc_call_test_get_mem_fail2)");
+
+	kfunc_call_test__destroy(skel);
+}
+
 void test_kfunc_call(void)
 {
 	if (test__start_subtest("main"))
@@ -160,4 +205,7 @@ void test_kfunc_call(void)
 
 	if (test__start_subtest("destructive"))
 		test_destructive();
+
+	if (test__start_subtest("get_mem"))
+		test_get_mem();
 }
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index da7ae0ef9100..b4a98d17c2b6 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -14,6 +14,8 @@ extern void bpf_kfunc_call_test_pass1(struct prog_test_pass1 *p) __ksym;
 extern void bpf_kfunc_call_test_pass2(struct prog_test_pass2 *p) __ksym;
 extern void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
 extern void bpf_kfunc_call_test_mem_len_fail2(__u64 *mem, int len) __ksym;
+extern int *bpf_kfunc_call_test_get_rdwr_mem(struct prog_test_ref_kfunc *p, const int rdwr_buf_size) __ksym;
+extern int *bpf_kfunc_call_test_get_rdonly_mem(struct prog_test_ref_kfunc *p, const int rdonly_buf_size) __ksym;
 
 SEC("tc")
 int kfunc_call_test2(struct __sk_buff *skb)
@@ -128,4 +130,91 @@ int kfunc_syscall_test_fail(struct syscall_test_args *args)
 	return 0;
 }
 
+SEC("tc")
+int kfunc_call_test_get_mem(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *pt;
+	unsigned long s = 0;
+	int *p = NULL;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(&s);
+	if (pt) {
+		if (pt->a != 42 || pt->b != 108)
+			ret = -1;
+
+		p = bpf_kfunc_call_test_get_rdwr_mem(pt, 2 * sizeof(int));
+		if (p) {
+			p[0] = 42;
+			ret = p[1]; /* 108 */
+		} else {
+			ret = -1;
+		}
+
+		if (ret >= 0) {
+			p = bpf_kfunc_call_test_get_rdonly_mem(pt, 2 * sizeof(int));
+			if (p)
+				ret = p[0]; /* 42 */
+			else
+				ret = -1;
+		}
+
+		bpf_kfunc_call_test_release(pt);
+	}
+	return ret;
+}
+
+SEC("?tc")
+int kfunc_call_test_get_mem_fail1(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *pt;
+	unsigned long s = 0;
+	int *p = NULL;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(&s);
+	if (pt) {
+		if (pt->a != 42 || pt->b != 108)
+			ret = -1;
+
+		p = bpf_kfunc_call_test_get_rdonly_mem(pt, 2 * sizeof(int));
+		if (p)
+			p[0] = 42; /* this is a read-only buffer, so -EACCES */
+		else
+			ret = -1;
+
+		bpf_kfunc_call_test_release(pt);
+	}
+	return ret;
+}
+
+SEC("?tc")
+int kfunc_call_test_get_mem_fail2(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *pt;
+	unsigned long s = 0;
+	int *p = NULL;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(&s);
+	if (pt) {
+		if (pt->a != 42 || pt->b != 108)
+			ret = -1;
+
+		p = bpf_kfunc_call_test_get_rdwr_mem(pt, 2 * sizeof(int));
+		if (p) {
+			p[0] = 42;
+			ret = p[1]; /* 108 */
+		} else {
+			ret = -1;
+		}
+
+		bpf_kfunc_call_test_release(pt);
+	}
+	if (p)
+		ret = p[0]; /* p is not valid anymore */
+
+	return ret;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.36.1

