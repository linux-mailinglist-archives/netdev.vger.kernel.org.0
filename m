Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6442E355DEE
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhDFV3o convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Apr 2021 17:29:44 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:46395 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234882AbhDFV3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 17:29:42 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-eXQKHefPOTCns-N5kkF5sQ-1; Tue, 06 Apr 2021 17:29:28 -0400
X-MC-Unique: eXQKHefPOTCns-N5kkF5sQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B1081005D4F;
        Tue,  6 Apr 2021 21:29:26 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB8591750D;
        Tue,  6 Apr 2021 21:29:23 +0000 (UTC)
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
Subject: [PATCHv2 bpf-next 2/5] selftests/bpf: Add re-attach test to fentry_test
Date:   Tue,  6 Apr 2021 23:29:10 +0200
Message-Id: <20210406212913.970917-3-jolsa@kernel.org>
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
fentry programs, plus check that already linked program can't
be attached again.

Fixing the number of check-ed results, which should be 8.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/fentry_test.c    | 48 +++++++++++++++----
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
index 04ebbf1cb390..1f7566e772e9 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
@@ -3,20 +3,24 @@
 #include <test_progs.h>
 #include "fentry_test.skel.h"
 
-void test_fentry_test(void)
+static __u32 duration;
+
+static int fentry_test(struct fentry_test *fentry_skel)
 {
-	struct fentry_test *fentry_skel = NULL;
+	struct bpf_link *link;
 	int err, prog_fd, i;
-	__u32 duration = 0, retval;
 	__u64 *result;
-
-	fentry_skel = fentry_test__open_and_load();
-	if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
-		goto cleanup;
+	__u32 retval;
 
 	err = fentry_test__attach(fentry_skel);
 	if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
-		goto cleanup;
+		return err;
+
+	/* Check that already linked program can't be attached again. */
+	link = bpf_program__attach(fentry_skel->progs.test1);
+	if (CHECK(!IS_ERR(link), "fentry_attach_link",
+		  "re-attach without detach should not succeed"))
+		return -1;
 
 	prog_fd = bpf_program__fd(fentry_skel->progs.test1);
 	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
@@ -26,12 +30,36 @@ void test_fentry_test(void)
 	      err, errno, retval, duration);
 
 	result = (__u64 *)fentry_skel->bss;
-	for (i = 0; i < 6; i++) {
+	for (i = 0; i < 8; i++) {
 		if (CHECK(result[i] != 1, "result",
 			  "fentry_test%d failed err %lld\n", i + 1, result[i]))
-			goto cleanup;
+			return -1;
 	}
 
+	fentry_test__detach(fentry_skel);
+
+	/* zero results for re-attach test */
+	for (i = 0; i < 8; i++)
+		result[i] = 0;
+	return 0;
+}
+
+void test_fentry_test(void)
+{
+	struct fentry_test *fentry_skel = NULL;
+	int err;
+
+	fentry_skel = fentry_test__open_and_load();
+	if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
+		goto cleanup;
+
+	err = fentry_test(fentry_skel);
+	if (CHECK(err, "fentry_test", "first attach failed\n"))
+		goto cleanup;
+
+	err = fentry_test(fentry_skel);
+	CHECK(err, "fentry_test", "second attach failed\n");
+
 cleanup:
 	fentry_test__destroy(fentry_skel);
 }
-- 
2.30.2

