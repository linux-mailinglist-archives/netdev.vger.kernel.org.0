Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04150571DB1
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbiGLPB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiGLPAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 11:00:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7184BF54E
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657637972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vToVReCil+AdJ1RFja/w0WdWza4Q968O0r6LsNQSeso=;
        b=OIOmP4gVMqTA0PHEt970ZqCT8O0jQD550bvAJjJmLCpiAhyEmn2ijiOWnBv1/9fTEVWape
        AlZpAzD31aYUAJmgolLD6AhkQrnProCHBXcB4kE1VPDQxvqcCX/jjsPRrdybhc3XkxYQwn
        +0NJ27795t55UFQzxJPUKf13vjYf+5k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-Q8yKot40NRebSeD_viiSlQ-1; Tue, 12 Jul 2022 10:59:27 -0400
X-MC-Unique: Q8yKot40NRebSeD_viiSlQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E817185A7A4;
        Tue, 12 Jul 2022 14:59:26 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.195.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F2AD2166B26;
        Tue, 12 Jul 2022 14:59:22 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v6 06/23] selftests/bpf: Add tests for kfunc returning a memory pointer
Date:   Tue, 12 Jul 2022 16:58:33 +0200
Message-Id: <20220712145850.599666-7-benjamin.tissoires@redhat.com>
In-Reply-To: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

new in v6
---
 include/linux/btf.h                           |  4 +-
 net/bpf/test_run.c                            | 22 +++++
 tools/testing/selftests/bpf/Makefile          |  5 +-
 .../selftests/bpf/prog_tests/kfunc_call.c     | 48 ++++++++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 89 +++++++++++++++++++
 5 files changed, 165 insertions(+), 3 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 31da4273c2ec..6f46ff2128ae 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -422,7 +422,9 @@ static inline int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dt
 
 static inline bool btf_type_is_struct_ptr(struct btf *btf, const struct btf_type *t)
 {
-	/* t comes in already as a pointer */
+	if (!btf_type_is_ptr(t))
+		return false;
+
 	t = btf_type_by_id(btf, t->type);
 
 	/* allow const */
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 9da2a42811e8..0b4026ea4652 100644
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
index 22547aafdd60..021ec38562d2 100644
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
 
 	kfunc_call_test_lskel__destroy(skel);
 }
@@ -106,6 +109,48 @@ static void test_subprog_lskel(void)
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
@@ -116,4 +161,7 @@ void test_kfunc_call(void)
 
 	if (test__start_subtest("subprog_lskel"))
 		test_subprog_lskel();
+
+	if (test__start_subtest("get_mem"))
+		test_get_mem();
 }
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index 0978834e22ad..e865f8db26a3 100644
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
@@ -119,4 +121,91 @@ int kfunc_syscall_test_fail(struct syscall_test_args *args)
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

