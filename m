Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BBE29DD35
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732021AbgJ2Aff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731908AbgJ2Afa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 20:35:30 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808F6C0613CF;
        Wed, 28 Oct 2020 17:35:30 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c5so884002qtw.3;
        Wed, 28 Oct 2020 17:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/SBE/N6wC5pb5zMXd0P9mHhhKJmvr+mqaknVNcM8uzs=;
        b=g3SD6DYkK8LyNocK567KMX8sX1PJCKtQY6OCyqMOJVPSteHKrWF8UYe4YHaEp5/stR
         0CZ0Ypp/qdZ0b2djhecL6y+Q3NRjVeZTG2KBk4xyxO0O5LnRrner9rCU3mtk2XYT8ck9
         8G+qjTV07v9/WTwmu/f+ZOmzexcLbLz6o9mdTVT9IKsAn1WKJS3OEzus/sokyJINzml3
         FHdpiEr03Q/0hBMgKfuCK9BPpL+caPRx44Rx3ypYaQ47r10YUG47kLejtLScU8wOJCA4
         LVPlQj/DItvIyOaJ+qHzzBSOl5EWlhEILTYSvJkWWAx34WVLewD6uZ+IxCOX12sdsDeU
         37Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/SBE/N6wC5pb5zMXd0P9mHhhKJmvr+mqaknVNcM8uzs=;
        b=da1XPeaTnUGHqULWsDAgLzBDg4doY1oBFHc0LlG0ABDcE4qAbfE+aJbSNAqPSjbHTy
         Z45aUINxmXtWolkhNtsSavCfp6u1ihL0GN+wwmm/MWrEdRNeYKUr7luGp+cfVWb3+76H
         lPC6TnJnGxvT9IAGG1jlweCdGBDpuhR27q7GPVAcY6+Z56OHBCbB7jojwlYKNAR0YHCN
         yYWUXelMqUMD5SM31ArEzF/FOKwUZ9FRO1FeLP9hc4wh181yCpmb7PdQ8YHKTlMbL7cY
         dG31JJU2qU1Z1isKTqhq0quS1Y/D2nJscS8jYiAbK0+ZLM48wZtFSLU3rUhtZXej/4tA
         oodQ==
X-Gm-Message-State: AOAM530x9STZsGo/y1w2uMhD+JNTFoboQTzLbp6keZHeeQz2dTnlRM1h
        RhXj1AtiALb6qImiedEUEgMlD9TmG/1edw==
X-Google-Smtp-Source: ABdhPJyjndBMQ8ltWfDHE9gHyFeddGorj/Lw8KM28vIkcT0oNNZsPnPPzLDp11TQaiA8eTfCv+GS5Q==
X-Received: by 2002:ac8:2bf7:: with SMTP id n52mr3975768qtn.164.1603849642858;
        Tue, 27 Oct 2020 18:47:22 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id d10sm2040306qkl.73.2020.10.27.18.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 18:47:22 -0700 (PDT)
Subject: [bpf-next PATCH 3/4] selftests/bpf: Replace EXPECT_EQ with ASSERT_EQ
 and refactor verify_results
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        alexanderduyck@fb.com
Date:   Tue, 27 Oct 2020 18:47:20 -0700
Message-ID: <160384964061.698509.7299229987872061758.stgit@localhost.localdomain>
In-Reply-To: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
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
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  119 ++++++++------------
 1 file changed, 46 insertions(+), 73 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index 71ab82e37eb7..4e1190894e1e 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -11,6 +11,7 @@
 
 static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
+static __u32 duration;
 
 static void *server_thread(void *arg)
 {
@@ -61,66 +62,57 @@ static void *server_thread(void *arg)
 	return (void *)(long)err;
 }
 
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
+	if (CHECK_FAIL(rv != 0)) {
+		fprintf(stderr, "FAILED: bpf_map_lookup_elem returns %d\n", rv);
+		return;
+	}
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
+	ASSERT_EQ(rv, 0, "rv");
+	ASSERT_EQ(res, 0, "res");
+
 	/* check getsockopt for SAVED_SYN */
+	key = 1;
 	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
-	EXPECT_EQ(0, rv, "d");
-	EXPECT_EQ(1, res, "d");
-	return ret;
+	ASSERT_EQ(rv, 0, "rv");
+	ASSERT_EQ(res, 1, "res");
 }
 
-static int run_test(void)
+static void run_test(int map_fd, int sock_map_fd)
 {
 	int server_fd, client_fd;
 	void *server_err;
@@ -131,7 +123,7 @@ static int run_test(void)
 
 	server_fd = start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
 	if (CHECK_FAIL(server_fd < 0))
-		return err;
+		return;
 
 	pthread_mutex_lock(&server_started_mtx);
 	if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
@@ -163,17 +155,17 @@ static int run_test(void)
 	close(client_fd);
 close_server_fd:
 	close(server_fd);
-	return err;
+
+	if (!err)
+		verify_result(map_fd, sock_map_fd);
 }
 
 void test_tcpbpf_user(void)
 {
 	const char *file = "test_tcpbpf_kern.o";
 	int prog_fd, map_fd, sock_map_fd;
-	struct tcpbpf_globals g = {0};
 	struct bpf_object *obj;
 	int cg_fd = -1;
-	__u32 key = 0;
 	int rv;
 
 	cg_fd = cgroup_setup_and_join(CG_NAME);
@@ -200,26 +192,7 @@ void test_tcpbpf_user(void)
 	if (CHECK_FAIL(sock_map_fd < 0))
 		goto err;
 
-	if (run_test()) {
-		fprintf(stderr, "FAILED: TCP server\n");
-		goto err;
-	}
-
-	rv = bpf_map_lookup_elem(map_fd, &key, &g);
-	if (CHECK_FAIL(rv != 0)) {
-		fprintf(stderr, "FAILED: bpf_map_lookup_elem returns %d\n", rv);
-		goto err;
-	}
-
-	if (CHECK_FAIL(verify_result(&g))) {
-		fprintf(stderr, "FAILED: Wrong stats\n");
-		goto err;
-	}
-
-	if (CHECK_FAIL(verify_sockopt_result(sock_map_fd))) {
-		fprintf(stderr, "FAILED: Wrong sockopt stats\n");
-		goto err;
-	}
+	run_test(map_fd, sock_map_fd);
 err:
 	bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
 	close(cg_fd);


