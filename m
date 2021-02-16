Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1199F31C94A
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBPLD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhBPLAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 06:00:44 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5242C0617A9
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:58:21 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id a132so2328986wmc.0
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0vsKJ/qcSYRSovInQOksHAVnokYKEDDhJ+tl+RlMl7A=;
        b=ppRZdQAZe+N7aXM4BQ96wdgVafPGAko/k1BkXbTOFiAwragBIfHpFPlamW0cSyi4kw
         4GbnT155B8ysgjVoIXtG++3iJtlz14sdzI2l39T0hQdHCW5++MwctT6kcNLMv/aDknt0
         BM3vT2gJwqkc9YmtZF8xV63kDPDuUh/e9/fvc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0vsKJ/qcSYRSovInQOksHAVnokYKEDDhJ+tl+RlMl7A=;
        b=RWOn3MdPcjNjeqS/A2yAubCVgfMnC9qS3UrKnSIOhzfMOMbCD0epEwBSU02OoLr8tR
         hmZUjwkxRgKF/50/5+4KRrhH1c7z2NzFG2UJGe87HVDkJRLgc+TZhPpouia50ERSvSAR
         m+rhBvQdJKyY8914cxvgO1JZCPDY4SoZZ4prjAlvqku/TdjiLicnl0m1TsgZo9pgagEc
         yiUNtFNe1jqOgHKIu7VEHGyGO+b7Sh2f7qzhK017M5DXsPLcAfxHAK3jLHAabcM40Vb5
         7aXLyd0+K6/H2HhxjhLm14xsdxTcoFoxJz49v1bPdjlaR04nnd2XxBOTPs3awDqhwG3k
         441Q==
X-Gm-Message-State: AOAM533y3Srq1K/PIRS0Q96OB4oCn+G/2VX7DioNRfzCRQDpq8Wk4Xpx
        5pln7gqjEpqym6IICa04K9CkXQ==
X-Google-Smtp-Source: ABdhPJyK8cymYaPqJEbDId1h7FaAFsC/dWT2XFzvvLWTKTulJa1fHBKGxmJFxSNFGR/Hc6+IcqeLTA==
X-Received: by 2002:a1c:81d4:: with SMTP id c203mr2763553wmd.76.1613473100686;
        Tue, 16 Feb 2021 02:58:20 -0800 (PST)
Received: from antares.lan (111.253.187.81.in-addr.arpa. [81.187.253.111])
        by smtp.gmail.com with ESMTPSA id l1sm2820238wmi.48.2021.02.16.02.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 02:58:20 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jakub@cloudflare.com
Cc:     kernel-team@cloudflare.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 6/8] selftests: bpf: convert sk_lookup multi prog tests to PROG_TEST_RUN
Date:   Tue, 16 Feb 2021 10:57:11 +0000
Message-Id: <20210216105713.45052-7-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216105713.45052-1-lmb@cloudflare.com>
References: <20210216105713.45052-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the tests for multi program sk_lookup semantics use bpf_prog_run_array.
This simplifies the test a bit and adds coverage to the new libbpf function.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sk_lookup.c      | 100 ++++++++++++------
 1 file changed, 65 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index 9ff0412e1fd3..a8e4a2044170 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -267,6 +267,17 @@ static int recv_byte(int fd)
 	return 0;
 }
 
+static __u64 socket_cookie(int fd)
+{
+	__u64 cookie;
+	socklen_t cookie_len = sizeof(cookie);
+
+	if (CHECK(getsockopt(fd, SOL_SOCKET, SO_COOKIE, &cookie, &cookie_len) < 0,
+		  "getsockopt(SO_COOKIE)", "%s\n", strerror(errno)))
+		return 0;
+	return cookie;
+}
+
 static int tcp_recv_send(int server_fd)
 {
 	char buf[1];
@@ -1128,17 +1139,27 @@ struct test_multi_prog {
 	struct bpf_program *prog2;
 	struct bpf_map *redir_map;
 	struct bpf_map *run_map;
-	int expect_errno;
+	enum sk_action result;
 	struct inet_addr listen_at;
+	bool redirect;
 };
 
 static void run_multi_prog_lookup(const struct test_multi_prog *t)
 {
-	struct sockaddr_storage dst = {};
-	int map_fd, server_fd, client_fd;
-	struct bpf_link *link1, *link2;
+	int map_fd, server_fd;
+	struct bpf_sk_lookup ctx = {};
 	int prog_idx, done, err;
+	__u32 prog_fds[2];
 
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
+		.ctx_in = &ctx,
+		.ctx_size_in = sizeof(ctx),
+		.ctx_out = &ctx,
+		.ctx_size_out = sizeof(ctx),
+	);
+
+	prog_fds[0] = bpf_program__fd(t->prog1);
+	prog_fds[1] = bpf_program__fd(t->prog2);
 	map_fd = bpf_map__fd(t->run_map);
 
 	done = 0;
@@ -1151,33 +1172,37 @@ static void run_multi_prog_lookup(const struct test_multi_prog *t)
 	if (CHECK(err, "bpf_map_update_elem", "failed\n"))
 		return;
 
-	link1 = attach_lookup_prog(t->prog1);
-	if (!link1)
-		return;
-	link2 = attach_lookup_prog(t->prog2);
-	if (!link2)
-		goto out_unlink1;
-
 	server_fd = make_server(SOCK_STREAM, t->listen_at.ip,
 				t->listen_at.port, NULL);
 	if (server_fd < 0)
-		goto out_unlink2;
+		return;
 
 	err = update_lookup_map(t->redir_map, SERVER_A, server_fd);
 	if (err)
-		goto out_close_server;
-
-	client_fd = make_socket(SOCK_STREAM, EXT_IP4, EXT_PORT, &dst);
-	if (client_fd < 0)
-		goto out_close_server;
-
-	err = connect(client_fd, (void *)&dst, inetaddr_len(&dst));
-	if (CHECK(err && !t->expect_errno, "connect",
-		  "unexpected error %d\n", errno))
-		goto out_close_client;
-	if (CHECK(err && t->expect_errno && errno != t->expect_errno,
-		  "connect", "unexpected error %d\n", errno))
-		goto out_close_client;
+		goto out;
+
+	ctx.family = AF_INET;
+	ctx.protocol = IPPROTO_TCP;
+
+	err = bpf_prog_test_run_array(prog_fds, ARRAY_SIZE(prog_fds), &opts);
+	if (CHECK(err, "test_run_array", "failed with error %d\n", errno))
+		goto out;
+
+	if (CHECK(opts.retval != t->result, "test_run", "unexpected result %d\n", opts.retval))
+		goto out;
+
+	if (t->redirect) {
+		__u64 cookie = socket_cookie(server_fd);
+
+		if (!cookie)
+			goto out;
+
+		if (CHECK(ctx.cookie != cookie, "redirect",
+			  "selected sk:%llu instead of sk:%llu\n", ctx.cookie, cookie))
+			goto out;
+	} else if (CHECK(ctx.cookie, "redirect", "selected unexpected sk:%llu\n", ctx.cookie)) {
+		goto out;
+	}
 
 	done = 0;
 	prog_idx = PROG1;
@@ -1191,14 +1216,8 @@ static void run_multi_prog_lookup(const struct test_multi_prog *t)
 	CHECK(err, "bpf_map_lookup_elem", "failed\n");
 	CHECK(!done, "bpf_map_lookup_elem", "PROG2 !done\n");
 
-out_close_client:
-	close(client_fd);
-out_close_server:
+out:
 	close(server_fd);
-out_unlink2:
-	bpf_link__destroy(link2);
-out_unlink1:
-	bpf_link__destroy(link1);
 }
 
 static void test_multi_prog_lookup(struct test_sk_lookup *skel)
@@ -1209,57 +1228,68 @@ static void test_multi_prog_lookup(struct test_sk_lookup *skel)
 			.prog1		= skel->progs.multi_prog_pass1,
 			.prog2		= skel->progs.multi_prog_pass2,
 			.listen_at	= { EXT_IP4, EXT_PORT },
+			.result		= SK_PASS,
 		},
 		{
 			.desc		= "multi prog - drop, drop",
 			.prog1		= skel->progs.multi_prog_drop1,
 			.prog2		= skel->progs.multi_prog_drop2,
 			.listen_at	= { EXT_IP4, EXT_PORT },
-			.expect_errno	= ECONNREFUSED,
+			.result		= SK_DROP,
 		},
 		{
 			.desc		= "multi prog - pass, drop",
 			.prog1		= skel->progs.multi_prog_pass1,
 			.prog2		= skel->progs.multi_prog_drop2,
 			.listen_at	= { EXT_IP4, EXT_PORT },
-			.expect_errno	= ECONNREFUSED,
+			.result		= SK_DROP,
 		},
 		{
 			.desc		= "multi prog - drop, pass",
 			.prog1		= skel->progs.multi_prog_drop1,
 			.prog2		= skel->progs.multi_prog_pass2,
 			.listen_at	= { EXT_IP4, EXT_PORT },
-			.expect_errno	= ECONNREFUSED,
+			.result		= SK_DROP,
 		},
 		{
 			.desc		= "multi prog - pass, redir",
 			.prog1		= skel->progs.multi_prog_pass1,
 			.prog2		= skel->progs.multi_prog_redir2,
 			.listen_at	= { INT_IP4, INT_PORT },
+			.result		= SK_PASS,
+			.redirect	= true,
 		},
 		{
 			.desc		= "multi prog - redir, pass",
 			.prog1		= skel->progs.multi_prog_redir1,
 			.prog2		= skel->progs.multi_prog_pass2,
 			.listen_at	= { INT_IP4, INT_PORT },
+			.result		= SK_PASS,
+			.redirect	= true,
 		},
 		{
 			.desc		= "multi prog - drop, redir",
 			.prog1		= skel->progs.multi_prog_drop1,
 			.prog2		= skel->progs.multi_prog_redir2,
 			.listen_at	= { INT_IP4, INT_PORT },
+			.result		= SK_PASS,
+			.redirect	= true,
 		},
 		{
 			.desc		= "multi prog - redir, drop",
 			.prog1		= skel->progs.multi_prog_redir1,
 			.prog2		= skel->progs.multi_prog_drop2,
 			.listen_at	= { INT_IP4, INT_PORT },
+			.result		= SK_PASS,
+			.redirect	= true,
 		},
 		{
 			.desc		= "multi prog - redir, redir",
 			.prog1		= skel->progs.multi_prog_redir1,
 			.prog2		= skel->progs.multi_prog_redir2,
 			.listen_at	= { INT_IP4, INT_PORT },
+			.result		= SK_PASS,
+			.redirect	= true,
 		},
 	};
 	struct test_multi_prog *t;
-- 
2.27.0

