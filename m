Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D554F34BC30
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 13:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhC1L1J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 28 Mar 2021 07:27:09 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:29708 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231143AbhC1L0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 07:26:53 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-luRFWaqMOFGaRtWxzJ6aUQ-1; Sun, 28 Mar 2021 07:26:49 -0400
X-MC-Unique: luRFWaqMOFGaRtWxzJ6aUQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F52A8030A1;
        Sun, 28 Mar 2021 11:26:47 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DDA019C66;
        Sun, 28 Mar 2021 11:26:42 +0000 (UTC)
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
Subject: [RFC PATCH bpf-next 3/4] selftests/bpf: Add re-attach test to fexit_test
Date:   Sun, 28 Mar 2021 13:26:28 +0200
Message-Id: <20210328112629.339266-4-jolsa@kernel.org>
In-Reply-To: <20210328112629.339266-1-jolsa@kernel.org>
References: <20210328112629.339266-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

Fixing the number of check-ed results, which should be 8.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/fexit_test.c     | 58 ++++++++++++++-----
 1 file changed, 45 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
index 78d7a2765c27..6666c5105f1e 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
@@ -3,20 +3,13 @@
 #include <test_progs.h>
 #include "fexit_test.skel.h"
 
-void test_fexit_test(void)
+static __u32 duration;
+
+static int fexit_test(struct fexit_test *fexit_skel)
 {
-	struct fexit_test *fexit_skel = NULL;
 	int err, prog_fd, i;
-	__u32 duration = 0, retval;
 	__u64 *result;
-
-	fexit_skel = fexit_test__open_and_load();
-	if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
-		goto cleanup;
-
-	err = fexit_test__attach(fexit_skel);
-	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
-		goto cleanup;
+	__u32 retval;
 
 	prog_fd = bpf_program__fd(fexit_skel->progs.test1);
 	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
@@ -26,12 +19,51 @@ void test_fexit_test(void)
 	      err, errno, retval, duration);
 
 	result = (__u64 *)fexit_skel->bss;
-	for (i = 0; i < 6; i++) {
+	for (i = 0; i < 8; i++) {
 		if (CHECK(result[i] != 1, "result",
 			  "fexit_test%d failed err %lld\n", i + 1, result[i]))
-			goto cleanup;
+			return -1;
 	}
 
+	/* zero results for re-attach test */
+	for (i = 0; i < 8; i++)
+		result[i] = 0;
+	return 0;
+}
+
+void test_fexit_test(void)
+{
+	struct fexit_test *fexit_skel = NULL;
+	struct bpf_link *link;
+	int err;
+
+	fexit_skel = fexit_test__open_and_load();
+	if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
+		goto cleanup;
+
+	err = fexit_test__attach(fexit_skel);
+	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
+		goto cleanup;
+
+	err = fexit_test(fexit_skel);
+	if (CHECK(err, "fexit_test", "exit test failed: %d\n", err))
+		goto cleanup;
+
+	fexit_test__detach(fexit_skel);
+
+	/* Re-attach and test again */
+	err = fexit_test__attach(fexit_skel);
+	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
+		goto cleanup;
+
+	link = bpf_program__attach(fexit_skel->progs.test1);
+	if (CHECK(!IS_ERR(link), "attach_fexit re-attach without detach",
+		"err: %ld\n", PTR_ERR(link)))
+		goto cleanup;
+
+	err = fexit_test(fexit_skel);
+	CHECK(err, "fexit_test", "fexit test failed: %d\n", err);
+
 cleanup:
 	fexit_test__destroy(fexit_skel);
 }
-- 
2.30.2

