Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6354F35CC41
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244409AbhDLQ16 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Apr 2021 12:27:58 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:54892 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244354AbhDLQZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:25:47 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-AxOcQ-YnOdaVFXc2LCgQ6g-1; Mon, 12 Apr 2021 12:25:24 -0400
X-MC-Unique: AxOcQ-YnOdaVFXc2LCgQ6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 612AC107ACE6;
        Mon, 12 Apr 2021 16:25:22 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.195.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF83060DCC;
        Mon, 12 Apr 2021 16:25:19 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCHv4 bpf-next 2/5] selftests/bpf: Add re-attach test to fentry_test
Date:   Mon, 12 Apr 2021 18:24:59 +0200
Message-Id: <20210412162502.1417018-3-jolsa@kernel.org>
In-Reply-To: <20210412162502.1417018-1-jolsa@kernel.org>
References: <20210412162502.1417018-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding the test to re-attach (detach/attach again) tracing
fentry programs, plus check that already linked program can't
be attached again.

Also switching to ASSERT* macros and adding missing ';' in
ASSERT_ERR_PTR macro.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/fentry_test.c    | 51 +++++++++++++------
 tools/testing/selftests/bpf/test_progs.h      |  2 +-
 2 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
index 04ebbf1cb390..f440c74f5367 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
@@ -3,35 +3,56 @@
 #include <test_progs.h>
 #include "fentry_test.skel.h"
 
-void test_fentry_test(void)
+static int fentry_test(struct fentry_test *fentry_skel)
 {
-	struct fentry_test *fentry_skel = NULL;
 	int err, prog_fd, i;
 	__u32 duration = 0, retval;
+	struct bpf_link *link;
 	__u64 *result;
 
-	fentry_skel = fentry_test__open_and_load();
-	if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
-		goto cleanup;
-
 	err = fentry_test__attach(fentry_skel);
-	if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
-		goto cleanup;
+	if (!ASSERT_OK(err, "fentry_attach"))
+		return err;
+
+	/* Check that already linked program can't be attached again. */
+	link = bpf_program__attach(fentry_skel->progs.test1);
+	if (!ASSERT_ERR_PTR(link, "fentry_attach_link"))
+		return -1;
 
 	prog_fd = bpf_program__fd(fentry_skel->progs.test1);
 	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
 				NULL, NULL, &retval, &duration);
-	CHECK(err || retval, "test_run",
-	      "err %d errno %d retval %d duration %d\n",
-	      err, errno, retval, duration);
+	ASSERT_OK(err || retval, "test_run");
 
 	result = (__u64 *)fentry_skel->bss;
-	for (i = 0; i < 6; i++) {
-		if (CHECK(result[i] != 1, "result",
-			  "fentry_test%d failed err %lld\n", i + 1, result[i]))
-			goto cleanup;
+	for (i = 0; i < sizeof(*fentry_skel->bss) / sizeof(__u64); i++) {
+		if (!ASSERT_EQ(result[i], 1, "fentry_result"))
+			return -1;
 	}
 
+	fentry_test__detach(fentry_skel);
+
+	/* zero results for re-attach test */
+	memset(fentry_skel->bss, 0, sizeof(*fentry_skel->bss));
+	return 0;
+}
+
+void test_fentry_test(void)
+{
+	struct fentry_test *fentry_skel = NULL;
+	int err;
+
+	fentry_skel = fentry_test__open_and_load();
+	if (!ASSERT_OK_PTR(fentry_skel, "fentry_skel_load"))
+		goto cleanup;
+
+	err = fentry_test(fentry_skel);
+	if (!ASSERT_OK(err, "fentry_first_attach"))
+		goto cleanup;
+
+	err = fentry_test(fentry_skel);
+	ASSERT_OK(err, "fentry_second_attach");
+
 cleanup:
 	fentry_test__destroy(fentry_skel);
 }
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index e87c8546230e..ee7e3b45182a 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -210,7 +210,7 @@ extern int test__join_cgroup(const char *path);
 #define ASSERT_ERR_PTR(ptr, name) ({					\
 	static int duration = 0;					\
 	const void *___res = (ptr);					\
-	bool ___ok = IS_ERR(___res)					\
+	bool ___ok = IS_ERR(___res);					\
 	CHECK(!___ok, (name), "unexpected pointer: %p\n", ___res);	\
 	___ok;								\
 })
-- 
2.30.2

