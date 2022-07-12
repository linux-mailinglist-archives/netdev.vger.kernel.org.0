Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C13571DAA
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiGLPBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbiGLPAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 11:00:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82540BAA9B
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657637964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BQHpBnyEukIpB0e9o8whGYc//sSWJw8fHXPkrhbv0nA=;
        b=b6XHeN8PJ6iv/8QKZZg1Aeh3/HqqmRDo6qZXeNQSnNsdsRSlQK+Jw00XkRX99jI4G4u9jF
        XhmY+xqfJju+AbF47+1kdATfAPcz1L+ADRmaXjSSLrSIYU3JbMnyUmcuJjkBI1uZstx+Ny
        H00AW3u1QAHVXwk+fz7RfSVnDxrfCnA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-qXnoLm6oNjOhbELEcD1Kyw-1; Tue, 12 Jul 2022 10:59:18 -0400
X-MC-Unique: qXnoLm6oNjOhbELEcD1Kyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 702B1811E75;
        Tue, 12 Jul 2022 14:59:17 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.195.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CF092166B26;
        Tue, 12 Jul 2022 14:59:12 +0000 (UTC)
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
Subject: [PATCH bpf-next v6 04/23] selftests/bpf: add test for accessing ctx from syscall program type
Date:   Tue, 12 Jul 2022 16:58:31 +0200
Message-Id: <20220712145850.599666-5-benjamin.tissoires@redhat.com>
In-Reply-To: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

new in v6
---
 net/bpf/test_run.c                            |  1 +
 .../selftests/bpf/prog_tests/kfunc_call.c     | 20 ++++++++++++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 27 +++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2ca96acbc50a..9da2a42811e8 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1646,6 +1646,7 @@ static int __init bpf_prog_test_run_init(void)
 	int ret;
 
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_prog_test_kfunc_set);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &bpf_prog_test_kfunc_set);
 	return ret ?: register_btf_id_dtor_kfuncs(bpf_prog_test_dtor_kfunc,
 						  ARRAY_SIZE(bpf_prog_test_dtor_kfunc),
 						  THIS_MODULE);
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index c00eb974eb85..22547aafdd60 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -6,10 +6,22 @@
 #include "kfunc_call_test_subprog.skel.h"
 #include "kfunc_call_test_subprog.lskel.h"
 
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
@@ -35,6 +47,14 @@ static void test_main(void)
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
 	kfunc_call_test_lskel__destroy(skel);
 }
 
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index 5aecbb9fdc68..0978834e22ad 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -92,4 +92,31 @@ int kfunc_call_test_pass(struct __sk_buff *skb)
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
+	bpf_kfunc_call_test_mem_len_pass1(&args->data, size);
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

