Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CFC2A5727
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbgKCVgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732733AbgKCVfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:35:07 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34970C0613D1;
        Tue,  3 Nov 2020 13:35:07 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id p3so16688396qkk.7;
        Tue, 03 Nov 2020 13:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=1pI92lVnk6qe/idUdrcCkPLf+TdclwNENTsKhJKkgII=;
        b=OlJOyUwk8xmVv9iLiNPZAS4AvXCbd189IWC4WYViupreLJyDfcyhv7Fff5tTxZMhOS
         IBSO3tABmuEpt+nXyx1Jg4H75z6/V+UjsHU6sdjIMX74NDOhL732JFiDfBhVEvTqkxLn
         5VQDqfsTJz2A7QARhUI9zOj6lUPTAzgh45NnE9Lx49fDxBuj1ZWf9Mv0Nu3f9nMygXra
         8goa4RfnMpenaYvVR2axMJRO25HAFl8KIEg6oz/9fQBHCiz0KE6v+TagPLzz7LVUiSbr
         CrfdCo40M1Ow+A8NUtHBntsqJdqs9gy588CsT6uYNYxV75zPAcSr4fE1Ti7/pZNmV9ll
         jy7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1pI92lVnk6qe/idUdrcCkPLf+TdclwNENTsKhJKkgII=;
        b=i6SCnd/g429t3q6oAJCUbzt9kD9/Kui7Oppek6Da6HFPAdMxn0EAy9jqDYNwECdA8v
         si+ElUjIAmQpTGOSwIVNYuobMp4yUy+eOzokOvqaOmUTrcedrif46LzN1a1U0+J+FDr4
         5AcADb8ULnB5brws0NHy+xhHFEufwcDpZkySBT+wj8TL/js1joC2TX8/I7UTq6sbzg/c
         jM1eJI2yjijEn1LUfWIRRgCcKkQdF9+p6tYLgBGGIleF5/NiaBMY0fxXjKNjEPS5T1qU
         +Ilpntu2iNIcMMbyMYTd0z5sZIiuE7xLD4HfaB2vh0BDt9iAg+8IN7sTm4mTZZZ1WhLG
         tK+Q==
X-Gm-Message-State: AOAM5329uewG484nvQXDD+Ri7jKrPL2VG9xio5DVSeVID/6Bx9BTHtqJ
        ZKBDLzfjfBMf9PqyuDiGX2Q=
X-Google-Smtp-Source: ABdhPJz651d5QK3ZSL+KNLB/JIoz/OT2tmSRUj4hXiM2+7AjcYqaZqb3TXOvZLyxjR6LiQ7uEzAa/A==
X-Received: by 2002:a37:8b02:: with SMTP id n2mr22505469qkd.367.1604439306393;
        Tue, 03 Nov 2020 13:35:06 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id y68sm14495qkb.38.2020.11.03.13.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 13:35:05 -0800 (PST)
Subject: [bpf-next PATCH v3 3/5] selftests/bpf: Replace EXPECT_EQ with
 ASSERT_EQ and refactor verify_results
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        andrii.nakryiko@gmail.com, alexanderduyck@fb.com
Date:   Tue, 03 Nov 2020 13:35:04 -0800
Message-ID: <160443930408.1086697.16101205859962113000.stgit@localhost.localdomain>
In-Reply-To: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
References: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

There is already logic in test_progs.h for asserting that a value is
expected to be another value. So instead of reinventing it we should just
make use of ASSERT_EQ in tcpbpf_user.c. This will allow for better
debugging and integrates much more closely with the test_progs framework.

In addition we can refactor the code a bit to merge together the two
verify functions and tie them together into a single function. Doing this
helps to clean the code up a bit and makes it more readable as all the
verification is now done in one function.

Lastly we can relocate the verification to the end of the run_test since it
is logically part of the test itself. With this we can drop the need for a
return value from run_test since verification becomes the last step of the
call and then immediately following is the tear down of the test setup.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  115 +++++++-------------
 1 file changed, 43 insertions(+), 72 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index 616269abdb41..22c359871af6 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <inttypes.h>
 #include <test_progs.h>
 #include <network_helpers.h>
 
@@ -10,66 +9,56 @@
 
 static __u32 duration;
 
-#define EXPECT_EQ(expected, actual, fmt)			\
-	do {							\
-		if ((expected) != (actual)) {			\
-			printf("  Value of: " #actual "\n"	\
-			       "    Actual: %" fmt "\n"		\
-			       "  Expected: %" fmt "\n",	\
-			       (actual), (expected));		\
-			ret--;					\
-		}						\
-	} while (0)
-
-int verify_result(const struct tcpbpf_globals *result)
+static void verify_result(int map_fd, int sock_map_fd)
 {
-	__u32 expected_events;
-	int ret = 0;
-
-	expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
-			   (1 << BPF_SOCK_OPS_RWND_INIT) |
-			   (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
-			   (1 << BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB) |
-			   (1 << BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) |
-			   (1 << BPF_SOCK_OPS_NEEDS_ECN) |
-			   (1 << BPF_SOCK_OPS_STATE_CB) |
-			   (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
-
-	EXPECT_EQ(expected_events, result->event_map, "#" PRIx32);
-	EXPECT_EQ(501ULL, result->bytes_received, "llu");
-	EXPECT_EQ(1002ULL, result->bytes_acked, "llu");
-	EXPECT_EQ(1, result->data_segs_in, PRIu32);
-	EXPECT_EQ(1, result->data_segs_out, PRIu32);
-	EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
-	EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
-	EXPECT_EQ(1, result->num_listen, PRIu32);
+	__u32 expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
+				 (1 << BPF_SOCK_OPS_RWND_INIT) |
+				 (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
+				 (1 << BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB) |
+				 (1 << BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) |
+				 (1 << BPF_SOCK_OPS_NEEDS_ECN) |
+				 (1 << BPF_SOCK_OPS_STATE_CB) |
+				 (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
+	struct tcpbpf_globals result;
+	__u32 key = 0;
+	int res, rv;
+
+	rv = bpf_map_lookup_elem(map_fd, &key, &result);
+	if (CHECK(rv, "bpf_map_lookup_elem(map_fd)", "err:%d errno:%d",
+		  rv, errno))
+		return;
+
+	/* check global map */
+	CHECK(expected_events != result.event_map, "event_map",
+	      "unexpected event_map: actual 0x%08x != expected 0x%08x\n",
+	      result.event_map, expected_events);
+
+	ASSERT_EQ(result.bytes_received, 501, "bytes_received");
+	ASSERT_EQ(result.bytes_acked, 1002, "bytes_acked");
+	ASSERT_EQ(result.data_segs_in, 1, "data_segs_in");
+	ASSERT_EQ(result.data_segs_out, 1, "data_segs_out");
+	ASSERT_EQ(result.bad_cb_test_rv, 0x80, "bad_cb_test_rv");
+	ASSERT_EQ(result.good_cb_test_rv, 0, "good_cb_test_rv");
+	ASSERT_EQ(result.num_listen, 1, "num_listen");
 
 	/* 3 comes from one listening socket + both ends of the connection */
-	EXPECT_EQ(3, result->num_close_events, PRIu32);
-
-	return ret;
-}
-
-int verify_sockopt_result(int sock_map_fd)
-{
-	__u32 key = 0;
-	int ret = 0;
-	int res;
-	int rv;
+	ASSERT_EQ(result.num_close_events, 3, "num_close_events");
 
 	/* check setsockopt for SAVE_SYN */
 	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
-	EXPECT_EQ(0, rv, "d");
-	EXPECT_EQ(0, res, "d");
-	key = 1;
+	CHECK(rv, "bpf_map_lookup_elem(sock_map_fd)", "err:%d errno:%d",
+	      rv, errno);
+	ASSERT_EQ(res, 0, "bpf_setsockopt(TCP_SAVE_SYN)");
+
 	/* check getsockopt for SAVED_SYN */
+	key = 1;
 	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
-	EXPECT_EQ(0, rv, "d");
-	EXPECT_EQ(1, res, "d");
-	return ret;
+	CHECK(rv, "bpf_map_lookup_elem(sock_map_fd)", "err:%d errno:%d",
+	      rv, errno);
+	ASSERT_EQ(res, 1, "bpf_getsockopt(TCP_SAVED_SYN)");
 }
 
-static int run_test(void)
+static void run_test(int map_fd, int sock_map_fd)
 {
 	int listen_fd = -1, cli_fd = -1, accept_fd = -1;
 	char buf[1000];
@@ -135,18 +124,17 @@ static int run_test(void)
 	if (listen_fd != -1)
 		close(listen_fd);
 
-	return err;
+	if (!err)
+		verify_result(map_fd, sock_map_fd);
 }
 
 void test_tcpbpf_user(void)
 {
 	const char *file = "test_tcpbpf_kern.o";
 	int prog_fd, map_fd, sock_map_fd;
-	struct tcpbpf_globals g = {0};
 	int error = EXIT_FAILURE;
 	struct bpf_object *obj;
 	int cg_fd = -1;
-	__u32 key = 0;
 	int rv;
 
 	cg_fd = test__join_cgroup(CG_NAME);
@@ -173,24 +161,7 @@ void test_tcpbpf_user(void)
 	if (sock_map_fd < 0)
 		goto err;
 
-	if (run_test())
-		goto err;
-
-	rv = bpf_map_lookup_elem(map_fd, &key, &g);
-	if (rv != 0) {
-		printf("FAILED: bpf_map_lookup_elem returns %d\n", rv);
-		goto err;
-	}
-
-	if (verify_result(&g)) {
-		printf("FAILED: Wrong stats\n");
-		goto err;
-	}
-
-	if (verify_sockopt_result(sock_map_fd)) {
-		printf("FAILED: Wrong sockopt stats\n");
-		goto err;
-	}
+	run_test(map_fd, sock_map_fd);
 
 	error = 0;
 err:


