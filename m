Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6E12A1A15
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgJaSw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728492AbgJaSw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:52:26 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D367C0617A6;
        Sat, 31 Oct 2020 11:52:26 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id j18so7784432pfa.0;
        Sat, 31 Oct 2020 11:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=tY39n2KB3soHuCkrgn6L531qg3cMVxPUHdzfzcexEHE=;
        b=iIaSKnJwAMwcmlUoD85uhu9Oygisv0PhVkz9KOY8o0PDO1R51uGtuzzALW5mD7BA1C
         MN1CRiTjrLcbDnOY7vXDV/DHGh14hFJUYj0b1n8Q2PT+JvAaCdrvpjI7JHLSkQeXyF8G
         Np7bhtCrhcujf+m+wQFAD/UYVUa4bEP0s51m8+3cQ8tBG8iOt1xPB+PZlilNu1szEVJ2
         zd8vfVreghkVxkT3AEL/GAJG7bY6ElngFHrA4z0RZR/g3O93yuLMnkDX54G628RcC8RC
         J/Rg+hywIIq59jkUYD6KOsgPY5LPX+t1viz4D5apBOfbL/1FtBcoDcBjcwZ9T0mXRjdf
         be9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tY39n2KB3soHuCkrgn6L531qg3cMVxPUHdzfzcexEHE=;
        b=oLvEzBc/2mtHc6eC1UbnjUJDmyMDuNLz72cxwz39E2X9+wdjL86VOdREoWs0FFOanP
         e/qfOtuATUbz6Jb9BkZvDlXdkOMsME2K1xr+mCsHMDasNQldGEqHQ//JQGmuWyhHGJ6J
         xqj1vSJZwuUv2AJSBPkxn/M1oYRaKy5tYErdUt91pnTRTf5/SsnJFnVMbBYSZqKG9iE7
         K3ZivvqT1LcSAcL7TJgZV5H0vofaCyV5/P+LYIEjDujJwFBJUdmCPz4r0swXDF5S/4qS
         uRuVrqLJDMvkxA0TsCOaxxhqUj2VDNqMud/mxU6QBzOmjkpH7o6M076iP4oSdcv4V9V2
         yo8w==
X-Gm-Message-State: AOAM530eDgQqTVrHDziK38eaU63FG58oaZMcxuSMn5f9HVzhMd8AHixO
        /SInQ2Z7LTOwvoScGEHfngroaGrwqP1s8g==
X-Google-Smtp-Source: ABdhPJxVbgWXnzU3+PUuANM6YrHBOmll4WEC1DuRVgZu07KQmA/LH6Z70ME0TvAv3J6+tPIGCZwY0Q==
X-Received: by 2002:a63:74c:: with SMTP id 73mr7220111pgh.68.1604170345910;
        Sat, 31 Oct 2020 11:52:25 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id z66sm9187107pfb.109.2020.10.31.11.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:52:25 -0700 (PDT)
Subject: [bpf-next PATCH v2 3/5] selftests/bpf: Replace EXPECT_EQ with
 ASSERT_EQ and refactor verify_results
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        andrii.nakryiko@gmail.com, alexanderduyck@fb.com
Date:   Sat, 31 Oct 2020 11:52:24 -0700
Message-ID: <160417034457.2823.10600750891200038944.stgit@localhost.localdomain>
In-Reply-To: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
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

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  114 ++++++++------------
 1 file changed, 44 insertions(+), 70 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index 17d4299435df..d96f4084d2f5 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -10,66 +10,58 @@
 
 static __u32 duration;
 
-#define EXPECT_EQ(expected, actual, fmt)			\
-	do {							\
-		if ((expected) != (actual)) {			\
-			fprintf(stderr, "  Value of: " #actual "\n"	\
-			       "    Actual: %" fmt "\n"		\
-			       "  Expected: %" fmt "\n",	\
-			       (actual), (expected));		\
-			ret--;					\
-		}						\
-	} while (0)
-
-int verify_result(const struct tcpbpf_globals *result)
-{
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
-
-	/* 3 comes from one listening socket + both ends of the connection */
-	EXPECT_EQ(3, result->num_close_events, PRIu32);
-
-	return ret;
-}
-
-int verify_sockopt_result(int sock_map_fd)
+static void verify_result(int map_fd, int sock_map_fd)
 {
+	__u32 expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
+				 (1 << BPF_SOCK_OPS_RWND_INIT) |
+				 (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
+				 (1 << BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB) |
+				 (1 << BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) |
+				 (1 << BPF_SOCK_OPS_NEEDS_ECN) |
+				 (1 << BPF_SOCK_OPS_STATE_CB) |
+				 (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
+	struct tcpbpf_globals result = { 0 };
 	__u32 key = 0;
-	int ret = 0;
 	int res;
 	int rv;
 
+	rv = bpf_map_lookup_elem(map_fd, &key, &result);
+	if (CHECK(rv, "bpf_map_lookup_elem(map_fd)", "err:%d errno:%d",
+		  rv, errno))
+		return;
+
+	/* check global map */
+	CHECK(expected_events != result.event_map, "event_map",
+	      "unexpected event_map: actual %#" PRIx32" != expected %#" PRIx32 "\n",
+	      result.event_map, expected_events);
+
+	ASSERT_EQ(result.bytes_received, 501, "bytes_received");
+	ASSERT_EQ(result.bytes_acked, 1002, "bytes_acked");
+	ASSERT_EQ(result.data_segs_in, 1, "data_segs_in");
+	ASSERT_EQ(result.data_segs_out, 1, "data_segs_out");
+	ASSERT_EQ(result.bad_cb_test_rv, 0x80, "bad_cb_test_rv");
+	ASSERT_EQ(result.good_cb_test_rv, 0, "good_cb_test_rv");
+	ASSERT_EQ(result.num_listen, 1, "num_listen");
+
+	/* 3 comes from one listening socket + both ends of the connection */
+	ASSERT_EQ(result.num_close_events, 3, "num_close_events");
+
 	/* check setsockopt for SAVE_SYN */
+	key = 0;
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
@@ -135,18 +127,17 @@ static int run_test(void)
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
@@ -173,24 +164,7 @@ void test_tcpbpf_user(void)
 	if (sock_map_fd < 0)
 		goto err;
 
-	if (run_test())
-		goto err;
-
-	rv = bpf_map_lookup_elem(map_fd, &key, &g);
-	if (rv != 0) {
-		fprintf(stderr, "FAILED: bpf_map_lookup_elem returns %d\n", rv);
-		goto err;
-	}
-
-	if (verify_result(&g)) {
-		fprintf(stderr, "FAILED: Wrong stats\n");
-		goto err;
-	}
-
-	if (verify_sockopt_result(sock_map_fd)) {
-		fprintf(stderr, "FAILED: Wrong sockopt stats\n");
-		goto err;
-	}
+	run_test(map_fd, sock_map_fd);
 
 	error = 0;
 err:


