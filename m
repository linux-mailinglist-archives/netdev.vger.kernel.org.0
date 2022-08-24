Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C6759FB9C
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbiHXNln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiHXNli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:41:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3237E81E
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661348480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=htqj54Y2CK4iVqQhnJAjtsnF+mPJWGtr+5lqlYqt6Is=;
        b=LfGf7WbwR7WTSyAGK58g+L20n34fKA/7dHJwQmteHIFtQALMzgB7Q9HkldPItpnBG4K8zh
        i9JdmKYX5pp1zeQ2YNkBsppoRbYwda6uq2r8fLawWcJyPwfDB0oX7jAVcEJ2lCpBZdDKyq
        RSWfp6CBLhRcYiD9UFWydviTDv8b8X0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-pNhDQr55OS6D9HkBU3pBqQ-1; Wed, 24 Aug 2022 09:41:13 -0400
X-MC-Unique: pNhDQr55OS6D9HkBU3pBqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3EE885A58A;
        Wed, 24 Aug 2022 13:41:12 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85FC818ECC;
        Wed, 24 Aug 2022 13:41:09 +0000 (UTC)
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
Subject: [PATCH bpf-next v9 03/23] selftests/bpf: add test for accessing ctx from syscall program type
Date:   Wed, 24 Aug 2022 15:40:33 +0200
Message-Id: <20220824134055.1328882-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to also export the kfunc set to the syscall program type,
and then add a couple of eBPF programs that are testing those calls.

The first one checks for valid access, and the second one is OK
from a static analysis point of view but fails at run time because
we are trying to access outside of the allocated memory.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v9

no changes in v8

changes in v7:
- add 1 more case to ensure we can read the entire sizeof(ctx)
- add a test case for when the context is NULL

new in v6
---
 net/bpf/test_run.c                            |  1 +
 .../selftests/bpf/prog_tests/kfunc_call.c     | 28 +++++++++++++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 36 +++++++++++++++++++
 3 files changed, 65 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 25d8ecf105aa..f16baf977a21 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1634,6 +1634,7 @@ static int __init bpf_prog_test_run_init(void)
 
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_prog_test_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &bpf_prog_test_kfunc_set);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &bpf_prog_test_kfunc_set);
 	return ret ?: register_btf_id_dtor_kfuncs(bpf_prog_test_dtor_kfunc,
 						  ARRAY_SIZE(bpf_prog_test_dtor_kfunc),
 						  THIS_MODULE);
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index eede7c304f86..1edad012fe01 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -9,10 +9,22 @@
 
 #include "cap_helpers.h"
 
+struct syscall_test_args {
+	__u8 data[16];
+	size_t size;
+};
+
 static void test_main(void)
 {
 	struct kfunc_call_test_lskel *skel;
 	int prog_fd, err;
+	struct syscall_test_args args = {
+		.size = 10,
+	};
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, syscall_topts,
+		.ctx_in = &args,
+		.ctx_size_in = sizeof(args),
+	);
 	LIBBPF_OPTS(bpf_test_run_opts, topts,
 		.data_in = &pkt_v4,
 		.data_size_in = sizeof(pkt_v4),
@@ -38,6 +50,22 @@ static void test_main(void)
 	ASSERT_OK(err, "bpf_prog_test_run(test_ref_btf_id)");
 	ASSERT_EQ(topts.retval, 0, "test_ref_btf_id-retval");
 
+	prog_fd = skel->progs.kfunc_syscall_test.prog_fd;
+	err = bpf_prog_test_run_opts(prog_fd, &syscall_topts);
+	ASSERT_OK(err, "bpf_prog_test_run(syscall_test)");
+
+	prog_fd = skel->progs.kfunc_syscall_test_fail.prog_fd;
+	err = bpf_prog_test_run_opts(prog_fd, &syscall_topts);
+	ASSERT_ERR(err, "bpf_prog_test_run(syscall_test_fail)");
+
+	syscall_topts.ctx_in = NULL;
+	syscall_topts.ctx_size_in = 0;
+
+	prog_fd = skel->progs.kfunc_syscall_test_null.prog_fd;
+	err = bpf_prog_test_run_opts(prog_fd, &syscall_topts);
+	ASSERT_OK(err, "bpf_prog_test_run(syscall_test_null)");
+	ASSERT_EQ(syscall_topts.retval, 0, "syscall_test_null-retval");
+
 	kfunc_call_test_lskel__destroy(skel);
 }
 
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index 5aecbb9fdc68..da7ae0ef9100 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -92,4 +92,40 @@ int kfunc_call_test_pass(struct __sk_buff *skb)
 	return 0;
 }
 
+struct syscall_test_args {
+	__u8 data[16];
+	size_t size;
+};
+
+SEC("syscall")
+int kfunc_syscall_test(struct syscall_test_args *args)
+{
+	const int size = args->size;
+
+	if (size > sizeof(args->data))
+		return -7; /* -E2BIG */
+
+	bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(args->data));
+	bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(*args));
+	bpf_kfunc_call_test_mem_len_pass1(&args->data, size);
+
+	return 0;
+}
+
+SEC("syscall")
+int kfunc_syscall_test_null(struct syscall_test_args *args)
+{
+	bpf_kfunc_call_test_mem_len_pass1(args, 0);
+
+	return 0;
+}
+
+SEC("syscall")
+int kfunc_syscall_test_fail(struct syscall_test_args *args)
+{
+	bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(*args) + 1);
+
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.36.1

