Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4617435DE83
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345478AbhDMMRC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 08:17:02 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:32362 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243979AbhDMMQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:16:21 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-6hzOu45_OQ6dHaQUMcxa7w-1; Tue, 13 Apr 2021 08:15:56 -0400
X-MC-Unique: 6hzOu45_OQ6dHaQUMcxa7w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B2F71856A63;
        Tue, 13 Apr 2021 12:15:42 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.196.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D05BE10023B0;
        Tue, 13 Apr 2021 12:15:38 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCHv2 RFC bpf-next 6/7] selftests/bpf: Add ftrace probe to fentry test
Date:   Tue, 13 Apr 2021 14:15:15 +0200
Message-Id: <20210413121516.1467989-7-jolsa@kernel.org>
In-Reply-To: <20210413121516.1467989-1-jolsa@kernel.org>
References: <20210413121516.1467989-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding 2 more tests for fentry probe test,
to show/test ftrace probe.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/fentry_test.c       |  5 ++++-
 tools/testing/selftests/bpf/progs/fentry_test.c  | 16 ++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
index 04ebbf1cb390..70f414cb3bfd 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
@@ -26,12 +26,15 @@ void test_fentry_test(void)
 	      err, errno, retval, duration);
 
 	result = (__u64 *)fentry_skel->bss;
-	for (i = 0; i < 6; i++) {
+	for (i = 0; i < 8; i++) {
 		if (CHECK(result[i] != 1, "result",
 			  "fentry_test%d failed err %lld\n", i + 1, result[i]))
 			goto cleanup;
 	}
 
+	ASSERT_EQ(result[8], 8, "result");
+	ASSERT_EQ(result[9], 2, "result");
+
 cleanup:
 	fentry_test__destroy(fentry_skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
index 52a550d281d9..b32b589923a4 100644
--- a/tools/testing/selftests/bpf/progs/fentry_test.c
+++ b/tools/testing/selftests/bpf/progs/fentry_test.c
@@ -77,3 +77,19 @@ int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
 		test8_result = 1;
 	return 0;
 }
+
+__u64 test9_result = 0;
+SEC("fentry.ftrace/bpf_fentry_test*")
+int BPF_PROG(test9)
+{
+	test9_result++;
+	return 0;
+}
+
+__u64 test10_result = 0;
+SEC("fentry.ftrace/bpf_fentry_test1|bpf_fentry_test2")
+int BPF_PROG(test10)
+{
+	test10_result++;
+	return 0;
+}
-- 
2.30.2

