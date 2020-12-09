Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A31A2D4468
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgLIOcS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Dec 2020 09:32:18 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:42200 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbgLIOcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:32:13 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-Db5WfGVXNx6YZvAlHFwNoA-1; Wed, 09 Dec 2020 09:31:12 -0500
X-MC-Unique: Db5WfGVXNx6YZvAlHFwNoA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F38B113B22C;
        Wed,  9 Dec 2020 14:29:16 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC45B5D9D3;
        Wed,  9 Dec 2020 14:29:13 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next] selftests/bpf: Fix selftest compilation on clang 11
Date:   Wed,  9 Dec 2020 15:29:12 +0100
Message-Id: <20201209142912.99145-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't compile test_core_reloc_module.c selftest with clang 11,
compile fails with:

  CLNG-LLC [test_maps] test_core_reloc_module.o
  progs/test_core_reloc_module.c:57:21: error: use of unknown builtin \
  '__builtin_preserve_type_info' [-Wimplicit-function-declaration]
   out->read_ctx_sz = bpf_core_type_size(struct bpf_testmod_test_read_ctx);

Skipping these tests if __builtin_preserve_type_info() is not
supported by compiler.

Fixes: 6bcd39d366b6 ("selftests/bpf: Add CO-RE relocs selftest relying on kernel module BTF")
Fixes: bc9ed69c79ae ("selftests/bpf: Add tp_btf CO-RE reloc test for modules")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../testing/selftests/bpf/progs/test_core_reloc_module.c  | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_module.c b/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
index 56363959f7b0..f59f175c7baf 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
@@ -40,6 +40,7 @@ int BPF_PROG(test_core_module_probed,
 	     struct task_struct *task,
 	     struct bpf_testmod_test_read_ctx *read_ctx)
 {
+#if __has_builtin(__builtin_preserve_enum_value)
 	struct core_reloc_module_output *out = (void *)&data.out;
 	__u64 pid_tgid = bpf_get_current_pid_tgid();
 	__u32 real_tgid = (__u32)(pid_tgid >> 32);
@@ -61,6 +62,9 @@ int BPF_PROG(test_core_module_probed,
 	out->len_exists = bpf_core_field_exists(read_ctx->len);
 
 	out->comm_len = BPF_CORE_READ_STR_INTO(&out->comm, task, comm);
+#else
+	data.skip = true;
+#endif
 
 	return 0;
 }
@@ -70,6 +74,7 @@ int BPF_PROG(test_core_module_direct,
 	     struct task_struct *task,
 	     struct bpf_testmod_test_read_ctx *read_ctx)
 {
+#if __has_builtin(__builtin_preserve_enum_value)
 	struct core_reloc_module_output *out = (void *)&data.out;
 	__u64 pid_tgid = bpf_get_current_pid_tgid();
 	__u32 real_tgid = (__u32)(pid_tgid >> 32);
@@ -91,6 +96,9 @@ int BPF_PROG(test_core_module_direct,
 	out->len_exists = bpf_core_field_exists(read_ctx->len);
 
 	out->comm_len = BPF_CORE_READ_STR_INTO(&out->comm, task, comm);
+#else
+	data.skip = true;
+#endif
 
 	return 0;
 }
-- 
2.26.2

