Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7811835FBF4
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353543AbhDNTxK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 15:53:10 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:52224 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353525AbhDNTwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:52:47 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-yflE2lL_McagGDG42l8xUw-1; Wed, 14 Apr 2021 15:52:23 -0400
X-MC-Unique: yflE2lL_McagGDG42l8xUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F4BD83DD20;
        Wed, 14 Apr 2021 19:52:21 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6AA36064B;
        Wed, 14 Apr 2021 19:52:18 +0000 (UTC)
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
Subject: [PATCHv5 bpf-next 7/7] selftests/bpf: Use ASSERT macros in lsm test
Date:   Wed, 14 Apr 2021 21:51:47 +0200
Message-Id: <20210414195147.1624932-8-jolsa@kernel.org>
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

Replacing CHECK with ASSERT macros.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/test_lsm.c       | 27 +++++++------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_lsm.c b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
index d492e76e01cf..244c01125126 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_lsm.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
@@ -18,8 +18,6 @@ char *CMD_ARGS[] = {"true", NULL};
 #define GET_PAGE_ADDR(ADDR, PAGE_SIZE)					\
 	(char *)(((unsigned long) (ADDR + PAGE_SIZE)) & ~(PAGE_SIZE-1))
 
-static int duration = 0;
-
 int stack_mprotect(void)
 {
 	void *buf;
@@ -60,38 +58,33 @@ static int test_lsm(struct lsm *skel)
 	int err;
 
 	err = lsm__attach(skel);
-	if (CHECK(err, "attach", "lsm attach failed: %d\n", err))
+	if (!ASSERT_OK(err, "attach"))
 		return err;
 
 	/* Check that already linked program can't be attached again. */
 	link = bpf_program__attach(skel->progs.test_int_hook);
-	if (CHECK(!IS_ERR(link), "attach_link",
-		  "re-attach without detach should not succeed"))
+	if (!ASSERT_ERR_PTR(link, "attach_link"))
 		return -1;
 
 	err = exec_cmd(&skel->bss->monitored_pid);
-	if (CHECK(err < 0, "exec_cmd", "err %d errno %d\n", err, errno))
+	if (!ASSERT_OK(err, "exec_cmd"))
 		return err;
 
-	CHECK(skel->bss->bprm_count != 1, "bprm_count", "bprm_count = %d\n",
-	      skel->bss->bprm_count);
+	ASSERT_EQ(skel->bss->bprm_count, 1, "bprm_count");
 
 	skel->bss->monitored_pid = getpid();
 
 	err = stack_mprotect();
-	if (CHECK(errno != EPERM, "stack_mprotect", "want err=EPERM, got %d\n",
-		  errno))
+	if (!ASSERT_EQ(errno, EPERM, "stack_mprotect"))
 		return err;
 
-	CHECK(skel->bss->mprotect_count != 1, "mprotect_count",
-	      "mprotect_count = %d\n", skel->bss->mprotect_count);
+	ASSERT_EQ(skel->bss->mprotect_count, 1, "mprotect_count");
 
 	syscall(__NR_setdomainname, &buf, -2L);
 	syscall(__NR_setdomainname, 0, -3L);
 	syscall(__NR_setdomainname, ~0L, -4L);
 
-	CHECK(skel->bss->copy_test != 3, "copy_test",
-	      "copy_test = %d\n", skel->bss->copy_test);
+	ASSERT_EQ(skel->bss->copy_test, 3, "copy_test");
 
 	lsm__detach(skel);
 
@@ -107,15 +100,15 @@ void test_test_lsm(void)
 	int err;
 
 	skel = lsm__open_and_load();
-	if (CHECK(!skel, "lsm_skel_load", "lsm skeleton failed\n"))
+	if (!ASSERT_OK_PTR(skel, "lsm_skel_load"))
 		goto close_prog;
 
 	err = test_lsm(skel);
-	if (CHECK(err, "test_lsm", "first attach failed\n"))
+	if (!ASSERT_OK(err, "test_lsm_first_attach"))
 		goto close_prog;
 
 	err = test_lsm(skel);
-	CHECK(err, "test_lsm", "second attach failed\n");
+	ASSERT_OK(err, "test_lsm_second_attach");
 
 close_prog:
 	lsm__destroy(skel);
-- 
2.30.2

