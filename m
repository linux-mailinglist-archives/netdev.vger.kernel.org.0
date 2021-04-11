Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643A335B473
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 15:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbhDKNAt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Apr 2021 09:00:49 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:26719 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235611AbhDKNAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 09:00:48 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-i7uhvZ-DM8exSbv9yfWnFw-1; Sun, 11 Apr 2021 09:00:29 -0400
X-MC-Unique: i7uhvZ-DM8exSbv9yfWnFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 015026414C;
        Sun, 11 Apr 2021 13:00:28 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6ED23101E24A;
        Sun, 11 Apr 2021 13:00:25 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCHv3 bpf-next 3/5] selftests/bpf: Add re-attach test to fexit_test
Date:   Sun, 11 Apr 2021 15:00:08 +0200
Message-Id: <20210411130010.1337650-4-jolsa@kernel.org>
In-Reply-To: <20210411130010.1337650-1-jolsa@kernel.org>
References: <20210411130010.1337650-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
fexit programs, plus check that already linked program can't
be attached again.

Also switching to ASSERT* macros.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/fexit_test.c     | 51 +++++++++++++------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
index 78d7a2765c27..c48e10c138bc 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
@@ -3,35 +3,56 @@
 #include <test_progs.h>
 #include "fexit_test.skel.h"
 
-void test_fexit_test(void)
+static int fexit_test(struct fexit_test *fexit_skel)
 {
-	struct fexit_test *fexit_skel = NULL;
 	int err, prog_fd, i;
 	__u32 duration = 0, retval;
+	struct bpf_link *link;
 	__u64 *result;
 
-	fexit_skel = fexit_test__open_and_load();
-	if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
-		goto cleanup;
-
 	err = fexit_test__attach(fexit_skel);
-	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
-		goto cleanup;
+	if (!ASSERT_OK(err, "fexit_attach"))
+		return err;
+
+	/* Check that already linked program can't be attached again. */
+	link = bpf_program__attach(fexit_skel->progs.test1);
+	if (!ASSERT_ERR_PTR(link, "fexit_attach_link"))
+		return -1;
 
 	prog_fd = bpf_program__fd(fexit_skel->progs.test1);
 	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
 				NULL, NULL, &retval, &duration);
-	CHECK(err || retval, "test_run",
-	      "err %d errno %d retval %d duration %d\n",
-	      err, errno, retval, duration);
+	ASSERT_OK(err || retval, "test_run");
 
 	result = (__u64 *)fexit_skel->bss;
-	for (i = 0; i < 6; i++) {
-		if (CHECK(result[i] != 1, "result",
-			  "fexit_test%d failed err %lld\n", i + 1, result[i]))
-			goto cleanup;
+	for (i = 0; i < sizeof(*fexit_skel->bss) / sizeof(__u64); i++) {
+		if (!ASSERT_EQ(result[i], 1, "fexit_result"))
+			return -1;
 	}
 
+	fexit_test__detach(fexit_skel);
+
+	/* zero results for re-attach test */
+	memset(fexit_skel->bss, 0, sizeof(*fexit_skel->bss));
+	return 0;
+}
+
+void test_fexit_test(void)
+{
+	struct fexit_test *fexit_skel = NULL;
+	int err;
+
+	fexit_skel = fexit_test__open_and_load();
+	if (!ASSERT_OK_PTR(fexit_skel, "fexit_skel_load"))
+		goto cleanup;
+
+	err = fexit_test(fexit_skel);
+	if (!ASSERT_OK(err, "fexit_first_attach"))
+		goto cleanup;
+
+	err = fexit_test(fexit_skel);
+	ASSERT_OK(err, "fexit_second_attach");
+
 cleanup:
 	fexit_test__destroy(fexit_skel);
 }
-- 
2.30.2

