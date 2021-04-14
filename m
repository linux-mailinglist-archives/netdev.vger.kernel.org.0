Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCB535FBF1
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353532AbhDNTxA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 15:53:00 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:22725 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353513AbhDNTwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:52:37 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-5qepCzkcNMGHkRqjPA2hOw-1; Wed, 14 Apr 2021 15:52:11 -0400
X-MC-Unique: 5qepCzkcNMGHkRqjPA2hOw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DBEA1006C8F;
        Wed, 14 Apr 2021 19:52:09 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78D126064B;
        Wed, 14 Apr 2021 19:52:06 +0000 (UTC)
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
Subject: [PATCHv5 bpf-next 4/7] selftests/bpf: Add re-attach test to fexit_test
Date:   Wed, 14 Apr 2021 21:51:44 +0200
Message-Id: <20210414195147.1624932-5-jolsa@kernel.org>
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
fexit programs, plus check that already linked program can't
be attached again.

Also switching to ASSERT* macros.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/fexit_test.c     | 52 +++++++++++++------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
index 78d7a2765c27..6792e41f7f69 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
@@ -3,35 +3,57 @@
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
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
 
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

