Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CCD2645F2
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 14:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbgIJM0E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Sep 2020 08:26:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40892 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730629AbgIJMWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 08:22:35 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-ZIZx2N4YMYuseLlSeE1wBw-1; Thu, 10 Sep 2020 08:22:30 -0400
X-MC-Unique: ZIZx2N4YMYuseLlSeE1wBw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15076801AEE;
        Thu, 10 Sep 2020 12:22:28 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6F9C7E8F2;
        Thu, 10 Sep 2020 12:22:25 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next] selftests/bpf: Check trampoline execution in d_path test
Date:   Thu, 10 Sep 2020 14:22:24 +0200
Message-Id: <20200910122224.1683258-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0.0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some kernels builds might inline vfs_getattr call within
fstat syscall code path, so fentry/vfs_getattr trampoline
is not called.

I'm not sure how to handle this in some generic way other
than use some other function, but that might get inlined at
some point as well.

Adding flags that indicate trampolines were called and failing
the test if neither of them got called.

  $ sudo ./test_progs -t d_path
  test_d_path:PASS:setup 0 nsec
  ...
  trigger_fstat_events:PASS:trigger 0 nsec
  test_d_path:FAIL:124 trampolines not called
  #22 d_path:FAIL
  Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

If only one trampoline is called, it's still enough to test
the helper, so only warn about missing trampoline call and
continue in test.

  $ sudo ./test_progs -t d_path -v
  test_d_path:PASS:setup 0 nsec
  ...
  trigger_fstat_events:PASS:trigger 0 nsec
  fentry/vfs_getattr not called
  #22 d_path:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 .../testing/selftests/bpf/prog_tests/d_path.c | 25 +++++++++++++++----
 .../testing/selftests/bpf/progs/test_d_path.c |  7 ++++++
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
index fc12e0d445ff..ec15f7d1dd0a 100644
--- a/tools/testing/selftests/bpf/prog_tests/d_path.c
+++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
@@ -120,26 +120,41 @@ void test_d_path(void)
 	if (err < 0)
 		goto cleanup;
 
+	if (!bss->called_stat && !bss->called_close) {
+		PRINT_FAIL("trampolines not called\n");
+		goto cleanup;
+	}
+
+	if (!bss->called_stat) {
+		fprintf(stdout, "fentry/vfs_getattr not called\n");
+		goto cleanup;
+	}
+
+	if (!bss->called_close) {
+		fprintf(stdout, "fentry/filp_close not called\n");
+		goto cleanup;
+	}
+
 	for (int i = 0; i < MAX_FILES; i++) {
-		CHECK(strncmp(src.paths[i], bss->paths_stat[i], MAX_PATH_LEN),
+		CHECK(bss->called_stat && strncmp(src.paths[i], bss->paths_stat[i], MAX_PATH_LEN),
 		      "check",
 		      "failed to get stat path[%d]: %s vs %s\n",
 		      i, src.paths[i], bss->paths_stat[i]);
-		CHECK(strncmp(src.paths[i], bss->paths_close[i], MAX_PATH_LEN),
+		CHECK(bss->called_close && strncmp(src.paths[i], bss->paths_close[i], MAX_PATH_LEN),
 		      "check",
 		      "failed to get close path[%d]: %s vs %s\n",
 		      i, src.paths[i], bss->paths_close[i]);
 		/* The d_path helper returns size plus NUL char, hence + 1 */
-		CHECK(bss->rets_stat[i] != strlen(bss->paths_stat[i]) + 1,
+		CHECK(bss->called_stat && bss->rets_stat[i] != strlen(bss->paths_stat[i]) + 1,
 		      "check",
 		      "failed to match stat return [%d]: %d vs %zd [%s]\n",
 		      i, bss->rets_stat[i], strlen(bss->paths_stat[i]) + 1,
 		      bss->paths_stat[i]);
-		CHECK(bss->rets_close[i] != strlen(bss->paths_stat[i]) + 1,
+		CHECK(bss->called_close && bss->rets_close[i] != strlen(bss->paths_close[i]) + 1,
 		      "check",
 		      "failed to match stat return [%d]: %d vs %zd [%s]\n",
 		      i, bss->rets_close[i], strlen(bss->paths_close[i]) + 1,
-		      bss->paths_stat[i]);
+		      bss->paths_close[i]);
 	}
 
 cleanup:
diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
index 61f007855649..9e7223b4a555 100644
--- a/tools/testing/selftests/bpf/progs/test_d_path.c
+++ b/tools/testing/selftests/bpf/progs/test_d_path.c
@@ -15,6 +15,9 @@ char paths_close[MAX_FILES][MAX_PATH_LEN] = {};
 int rets_stat[MAX_FILES] = {};
 int rets_close[MAX_FILES] = {};
 
+int called_stat = 0;
+int called_close = 0;
+
 SEC("fentry/vfs_getattr")
 int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
 	     __u32 request_mask, unsigned int query_flags)
@@ -23,6 +26,8 @@ int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
 	__u32 cnt = cnt_stat;
 	int ret;
 
+	called_stat = 1;
+
 	if (pid != my_pid)
 		return 0;
 
@@ -42,6 +47,8 @@ int BPF_PROG(prog_close, struct file *file, void *id)
 	__u32 cnt = cnt_close;
 	int ret;
 
+	called_close = 1;
+
 	if (pid != my_pid)
 		return 0;
 
-- 
2.26.2

