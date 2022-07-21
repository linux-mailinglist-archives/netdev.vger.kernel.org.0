Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C87157CF6D
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiGUPiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiGUPhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:37:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1A7B88CDB
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658417817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2hn8ofUy9lec7pSjEdZbv4Q2ZwkAsz3GX8gt3N/eeZ0=;
        b=Wt8UEoyxvkVPCmlzcrJT0AF6pTpWLnJ5GZmTtdDegUwmUMi2wbJe1oqcYHL69G66YIR2/P
        vIhi2iwfPr1Kpl1c0M0uji4l6HAhAxiRc8mnrzB93T3ElgcMCNAcp3UqASYdC3sYZIYZYv
        4MOInhSN/BEXddGuls8G9h2NQ7mPnvA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-P101Wc1RNgehNBUnl3SRWA-1; Thu, 21 Jul 2022 11:36:53 -0400
X-MC-Unique: P101Wc1RNgehNBUnl3SRWA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AAF7811E80;
        Thu, 21 Jul 2022 15:36:52 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D583B2166B26;
        Thu, 21 Jul 2022 15:36:48 +0000 (UTC)
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
Subject: [PATCH bpf-next v7 06/24] selftests/bpf: Add tests for kfunc returning a memory pointer
Date:   Thu, 21 Jul 2022 17:36:07 +0200
Message-Id: <20220721153625.1282007-7-benjamin.tissoires@redhat.com>
In-Reply-To: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

changes in v7:
- removed stray include/linux/btf.h change

new in v6
---
 net/bpf/test_run.c                            | 22 +++++
 tools/testing/selftests/bpf/Makefile          |  5 +-
 .../selftests/bpf/prog_tests/kfunc_call.c     | 48 ++++++++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 89 +++++++++++++++++++
 4 files changed, 162 insertions(+), 2 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 8ada09ab1b15..1fc36a235bcd 100644
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
@@ -704,6 +722,8 @@ BTF_ID(func, bpf_kfunc_call_memb_acquire)
 BTF_ID(func, bpf_kfunc_call_test_release)
 BTF_ID(func, bpf_kfunc_call_memb_release)
 BTF_ID(func, bpf_kfunc_call_memb1_release)
+BTF_ID(func, bpf_kfunc_call_test_get_rdwr_mem)
+BTF_ID(func, bpf_kfunc_call_test_get_rdonly_mem)
 BTF_ID(func, bpf_kfunc_call_test_kptr_get)
 BTF_ID(func, bpf_kfunc_call_test_pass_ctx)
 BTF_ID(func, bpf_kfunc_call_test_pass1)
@@ -731,6 +751,8 @@ BTF_SET_END(test_sk_release_kfunc_ids)
 BTF_SET_START(test_sk_ret_null_kfunc_ids)
 BTF_ID(func, bpf_kfunc_call_test_acquire)
 BTF_ID(func, bpf_kfunc_call_memb_acquire)
+BTF_ID(func, bpf_kfunc_call_test_get_rdwr_mem)
+BTF_ID(func, bpf_kfunc_call_test_get_rdonly_mem)
 BTF_ID(func, bpf_kfunc_call_test_kptr_get)
 BTF_SET_END(test_sk_ret_null_kfunc_ids)
 
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
index 7e4804cce6b9..0815aa89d505 100644
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
@@ -50,10 +51,12 @@ static void test_main(void)
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
@@ -114,6 +117,48 @@ static void test_subprog_lskel(void)
 	kfunc_call_test_subprog_lskel__destroy(skel);
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
@@ -124,4 +169,7 @@ void test_kfunc_call(void)
 
 	if (test__start_subtest("subprog_lskel"))
 		test_subprog_lskel();
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

