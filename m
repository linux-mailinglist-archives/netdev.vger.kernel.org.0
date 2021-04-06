Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE0C355DF0
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhDFV3q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Apr 2021 17:29:46 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:57233 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235202AbhDFV3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 17:29:44 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-5rau3tEyO5iyC6cSS0a3-g-1; Tue, 06 Apr 2021 17:29:30 -0400
X-MC-Unique: 5rau3tEyO5iyC6cSS0a3-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDAF4612A2;
        Tue,  6 Apr 2021 21:29:28 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 833245C729;
        Tue,  6 Apr 2021 21:29:26 +0000 (UTC)
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
Subject: [PATCHv2 bpf-next 3/5] selftests/bpf: Add re-attach test to fexit_test
Date:   Tue,  6 Apr 2021 23:29:11 +0200
Message-Id: <20210406212913.970917-4-jolsa@kernel.org>
In-Reply-To: <20210406212913.970917-1-jolsa@kernel.org>
References: <20210406212913.970917-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 .../selftests/bpf/prog_tests/fexit_test.c     | 48 +++++++++++++++----
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
index 78d7a2765c27..579e620e6612 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
@@ -3,20 +3,24 @@
 #include <test_progs.h>
 #include "fexit_test.skel.h"
 
-void test_fexit_test(void)
+static __u32 duration;
+
+static int fexit_test(struct fexit_test *fexit_skel)
 {
-	struct fexit_test *fexit_skel = NULL;
+	struct bpf_link *link;
 	int err, prog_fd, i;
-	__u32 duration = 0, retval;
 	__u64 *result;
-
-	fexit_skel = fexit_test__open_and_load();
-	if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
-		goto cleanup;
+	__u32 retval;
 
 	err = fexit_test__attach(fexit_skel);
 	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
-		goto cleanup;
+		return err;
+
+	/* Check that already linked program can't be attached again. */
+	link = bpf_program__attach(fexit_skel->progs.test1);
+	if (CHECK(!IS_ERR(link), "fexit_attach_link",
+		  "re-attach without detach should not succeed"))
+		return -1;
 
 	prog_fd = bpf_program__fd(fexit_skel->progs.test1);
 	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
@@ -26,12 +30,36 @@ void test_fexit_test(void)
 	      err, errno, retval, duration);
 
 	result = (__u64 *)fexit_skel->bss;
-	for (i = 0; i < 6; i++) {
+	for (i = 0; i < 8; i++) {
 		if (CHECK(result[i] != 1, "result",
 			  "fexit_test%d failed err %lld\n", i + 1, result[i]))
-			goto cleanup;
+			return -1;
 	}
 
+	fexit_test__detach(fexit_skel);
+
+	/* zero results for re-attach test */
+	for (i = 0; i < 8; i++)
+		result[i] = 0;
+	return 0;
+}
+
+void test_fexit_test(void)
+{
+	struct fexit_test *fexit_skel = NULL;
+	int err;
+
+	fexit_skel = fexit_test__open_and_load();
+	if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
+		goto cleanup;
+
+	err = fexit_test(fexit_skel);
+	if (CHECK(err, "fexit_test", "first attach failed\n"))
+		goto cleanup;
+
+	err = fexit_test(fexit_skel);
+	CHECK(err, "fexit_test", "second attach failed\n");
+
 cleanup:
 	fexit_test__destroy(fexit_skel);
 }
-- 
2.30.2

