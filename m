Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150DB35FBEF
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353537AbhDNTwz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 15:52:55 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:55081 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353511AbhDNTwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:52:36 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-fHDwchD6Mni78_b13B9fiA-1; Wed, 14 Apr 2021 15:52:08 -0400
X-MC-Unique: fHDwchD6Mni78_b13B9fiA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44FE2107ACFC;
        Wed, 14 Apr 2021 19:52:06 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 741A46064B;
        Wed, 14 Apr 2021 19:52:03 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCHv5 bpf-next 3/7] selftests/bpf: Add re-attach test to fentry_test
Date:   Wed, 14 Apr 2021 21:51:43 +0200
Message-Id: <20210414195147.1624932-4-jolsa@kernel.org>
In-Reply-To: <20210414195147.1624932-1-jolsa@kernel.org>
References: <20210414195147.1624932-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/fentry_test.c    | 52 +++++++++++++------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
index 04ebbf1cb390..7cb111b11995 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
@@ -3,35 +3,57 @@
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
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
 
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
-- 
2.30.2

