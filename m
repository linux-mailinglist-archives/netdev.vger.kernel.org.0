Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C68D35FBF2
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353544AbhDNTxF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 15:53:05 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:22178 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353509AbhDNTwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:52:43 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-9acBb_H_PVadcQar_l2qIw-1; Wed, 14 Apr 2021 15:52:17 -0400
X-MC-Unique: 9acBb_H_PVadcQar_l2qIw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7286E107ACCD;
        Wed, 14 Apr 2021 19:52:15 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E1036064B;
        Wed, 14 Apr 2021 19:52:09 +0000 (UTC)
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
Subject: [PATCHv5 bpf-next 5/7] selftests/bpf: Add re-attach test to lsm test
Date:   Wed, 14 Apr 2021 21:51:45 +0200
Message-Id: <20210414195147.1624932-6-jolsa@kernel.org>
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

Adding the test to re-attach (detach/attach again) lsm programs,
plus check that already linked program can't be attached again.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/test_lsm.c       | 48 +++++++++++++++----
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_lsm.c b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
index 2755e4f81499..d492e76e01cf 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_lsm.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
@@ -18,6 +18,8 @@ char *CMD_ARGS[] = {"true", NULL};
 #define GET_PAGE_ADDR(ADDR, PAGE_SIZE)					\
 	(char *)(((unsigned long) (ADDR + PAGE_SIZE)) & ~(PAGE_SIZE-1))
 
+static int duration = 0;
+
 int stack_mprotect(void)
 {
 	void *buf;
@@ -51,23 +53,25 @@ int exec_cmd(int *monitored_pid)
 	return -EINVAL;
 }
 
-void test_test_lsm(void)
+static int test_lsm(struct lsm *skel)
 {
-	struct lsm *skel = NULL;
-	int err, duration = 0;
+	struct bpf_link *link;
 	int buf = 1234;
-
-	skel = lsm__open_and_load();
-	if (CHECK(!skel, "skel_load", "lsm skeleton failed\n"))
-		goto close_prog;
+	int err;
 
 	err = lsm__attach(skel);
 	if (CHECK(err, "attach", "lsm attach failed: %d\n", err))
-		goto close_prog;
+		return err;
+
+	/* Check that already linked program can't be attached again. */
+	link = bpf_program__attach(skel->progs.test_int_hook);
+	if (CHECK(!IS_ERR(link), "attach_link",
+		  "re-attach without detach should not succeed"))
+		return -1;
 
 	err = exec_cmd(&skel->bss->monitored_pid);
 	if (CHECK(err < 0, "exec_cmd", "err %d errno %d\n", err, errno))
-		goto close_prog;
+		return err;
 
 	CHECK(skel->bss->bprm_count != 1, "bprm_count", "bprm_count = %d\n",
 	      skel->bss->bprm_count);
@@ -77,7 +81,7 @@ void test_test_lsm(void)
 	err = stack_mprotect();
 	if (CHECK(errno != EPERM, "stack_mprotect", "want err=EPERM, got %d\n",
 		  errno))
-		goto close_prog;
+		return err;
 
 	CHECK(skel->bss->mprotect_count != 1, "mprotect_count",
 	      "mprotect_count = %d\n", skel->bss->mprotect_count);
@@ -89,6 +93,30 @@ void test_test_lsm(void)
 	CHECK(skel->bss->copy_test != 3, "copy_test",
 	      "copy_test = %d\n", skel->bss->copy_test);
 
+	lsm__detach(skel);
+
+	skel->bss->copy_test = 0;
+	skel->bss->bprm_count = 0;
+	skel->bss->mprotect_count = 0;
+	return 0;
+}
+
+void test_test_lsm(void)
+{
+	struct lsm *skel = NULL;
+	int err;
+
+	skel = lsm__open_and_load();
+	if (CHECK(!skel, "lsm_skel_load", "lsm skeleton failed\n"))
+		goto close_prog;
+
+	err = test_lsm(skel);
+	if (CHECK(err, "test_lsm", "first attach failed\n"))
+		goto close_prog;
+
+	err = test_lsm(skel);
+	CHECK(err, "test_lsm", "second attach failed\n");
+
 close_prog:
 	lsm__destroy(skel);
 }
-- 
2.30.2

