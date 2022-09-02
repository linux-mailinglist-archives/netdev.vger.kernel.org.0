Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC6E5AB27F
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 15:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238373AbiIBN62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 09:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237417AbiIBN5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 09:57:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C586D34E1
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662125421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1pceN/reEy6W1dhR2JsqTpMwghob87xpvrMYVrihi74=;
        b=hxrsAHPWU314ayVfgkEr3XztxG5W5I655RFAXOiByXceJhpS8VNu9PNtpi0C5yMaywogDc
        dRlBqsleAHlhjlOJ/vGkdF0E4el+nCIQ/yr8gOQI4d3kjloQz7lajvRH+jprt1DoqbfnxM
        EVLUjqJ/CC2pdVxjPbN5pe+9xGwJ0wQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-rLQeVlcFPh2IQzebM1E06A-1; Fri, 02 Sep 2022 09:30:14 -0400
X-MC-Unique: rLQeVlcFPh2IQzebM1E06A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 854F0101E167;
        Fri,  2 Sep 2022 13:30:11 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3445492C3B;
        Fri,  2 Sep 2022 13:30:07 +0000 (UTC)
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
Subject: [PATCH bpf-next v10 07/23] selftests/bpf: Add tests for kfunc returning a memory pointer
Date:   Fri,  2 Sep 2022 15:29:22 +0200
Message-Id: <20220902132938.2409206-8-benjamin.tissoires@redhat.com>
In-Reply-To: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
References: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v10:
- use new definition for tests
- remove the Makefile change, it was done before
- renamed the failed tests to be more explicit
- add 2 more test cases for return mem: oob access and non const access
- add one more test case for an invalid acquire function returning an
  int pointer

changes in v9:
- updated to match upstream (net/bpf/test_run.c id sets is now using
  flags)

no changes in v8

changes in v7:
- removed stray include/linux/btf.h change

new in v6
---
 net/bpf/test_run.c                            |  36 ++++++
 .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +
 .../selftests/bpf/progs/kfunc_call_fail.c     | 121 ++++++++++++++++++
 .../selftests/bpf/progs/kfunc_call_test.c     |  33 +++++
 4 files changed, 196 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index f16baf977a21..13d578ce2a09 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -606,6 +606,38 @@ noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
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
+/* the next 2 ones can't be really used for testing expect to ensure
+ * that the verifier rejects the call.
+ * Acquire functions must return struct pointers, so these ones are
+ * failing.
+ */
+noinline int *bpf_kfunc_call_test_acq_rdonly_mem(struct prog_test_ref_kfunc *p, const int rdonly_buf_size)
+{
+	return __bpf_kfunc_call_test_get_mem(p, rdonly_buf_size);
+}
+
+noinline void bpf_kfunc_call_int_mem_release(int *p)
+{
+}
+
 noinline struct prog_test_ref_kfunc *
 bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **pp, int a, int b)
 {
@@ -712,6 +744,10 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_memb_acquire, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_kfunc_call_memb_release, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_kfunc_call_memb1_release, KF_RELEASE)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_get_rdwr_mem, KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_get_rdonly_mem, KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_acq_rdonly_mem, KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_kfunc_call_int_mem_release, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_kptr_get, KF_ACQUIRE | KF_RET_NULL | KF_KPTR_GET)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_pass_ctx)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_pass1)
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index 84798979f3a7..f3e5cc53a6d8 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -35,11 +35,17 @@ static struct kfunc_test_params kfunc_tests[] = {
 	 */
 	{"kfunc_syscall_test_fail", -EINVAL, syscall_null_ctx_test, "processed 4 insns"},
 	{"kfunc_syscall_test_null_fail", -EINVAL, syscall_null_ctx_test, "processed 4 insns"},
+	{"kfunc_call_test_get_mem_fail_rdonly", 0, tc_test, "R0 cannot write into rdonly_mem"},
+	{"kfunc_call_test_get_mem_fail_use_after_free", 0, tc_test, "invalid mem access 'scalar'"},
+	{"kfunc_call_test_get_mem_fail_oob", 0, tc_test, "min value is outside of the allowed memory range"},
+	{"kfunc_call_test_get_mem_fail_not_const", 0, tc_test, "is not a const"},
+	{"kfunc_call_test_mem_acquire_fail", 0, tc_test, "acquire kernel function does not return PTR_TO_BTF_ID"},
 
 	/* success cases */
 	{"kfunc_call_test1", 12, tc_test, NULL},
 	{"kfunc_call_test2", 3, tc_test, NULL},
 	{"kfunc_call_test_ref_btf_id", 0, tc_test, NULL},
+	{"kfunc_call_test_get_mem", 42, tc_test, NULL},
 	{"kfunc_syscall_test", 0, syscall_test, NULL},
 	{"kfunc_syscall_test_null", 0, syscall_null_ctx_test, NULL},
 };
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_fail.c b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
index 4168027f2ab1..b98313d391c6 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
@@ -3,7 +3,13 @@
 #include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
 
+extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
+extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
 extern void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
+extern int *bpf_kfunc_call_test_get_rdwr_mem(struct prog_test_ref_kfunc *p, const int rdwr_buf_size) __ksym;
+extern int *bpf_kfunc_call_test_get_rdonly_mem(struct prog_test_ref_kfunc *p, const int rdonly_buf_size) __ksym;
+extern int *bpf_kfunc_call_test_acq_rdonly_mem(struct prog_test_ref_kfunc *p, const int rdonly_buf_size) __ksym;
+extern void bpf_kfunc_call_int_mem_release(int *p) __ksym;
 
 struct syscall_test_args {
 	__u8 data[16];
@@ -36,4 +42,119 @@ int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
 	return 0;
 }
 
+SEC("?tc")
+int kfunc_call_test_get_mem_fail_rdonly(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *pt;
+	unsigned long s = 0;
+	int *p = NULL;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(&s);
+	if (pt) {
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
+int kfunc_call_test_get_mem_fail_use_after_free(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *pt;
+	unsigned long s = 0;
+	int *p = NULL;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(&s);
+	if (pt) {
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
+SEC("?tc")
+int kfunc_call_test_get_mem_fail_oob(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *pt;
+	unsigned long s = 0;
+	int *p = NULL;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(&s);
+	if (pt) {
+		p = bpf_kfunc_call_test_get_rdonly_mem(pt, 2 * sizeof(int));
+		if (p)
+			ret = p[2 * sizeof(int)]; /* oob access, so -EACCES */
+		else
+			ret = -1;
+
+		bpf_kfunc_call_test_release(pt);
+	}
+	return ret;
+}
+
+int not_const_size = 2 * sizeof(int);
+
+SEC("?tc")
+int kfunc_call_test_get_mem_fail_not_const(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *pt;
+	unsigned long s = 0;
+	int *p = NULL;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(&s);
+	if (pt) {
+		p = bpf_kfunc_call_test_get_rdonly_mem(pt, not_const_size); /* non const size, -EINVAL */
+		if (p)
+			ret = p[0];
+		else
+			ret = -1;
+
+		bpf_kfunc_call_test_release(pt);
+	}
+	return ret;
+}
+
+SEC("?tc")
+int kfunc_call_test_mem_acquire_fail(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *pt;
+	unsigned long s = 0;
+	int *p = NULL;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(&s);
+	if (pt) {
+		/* we are failing on this one, because we are not acquiring a PTR_TO_BTF_ID (a struct ptr) */
+		p = bpf_kfunc_call_test_acq_rdonly_mem(pt, 2 * sizeof(int));
+		if (p)
+			ret = p[0];
+		else
+			ret = -1;
+
+		bpf_kfunc_call_int_mem_release(p);
+
+		bpf_kfunc_call_test_release(pt);
+	}
+	return ret;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index 94c05267e5e7..56c96f7969f0 100644
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
@@ -130,4 +132,35 @@ int kfunc_syscall_test_null(struct syscall_test_args *args)
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
 char _license[] SEC("license") = "GPL";
-- 
2.36.1

