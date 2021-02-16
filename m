Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CF931C946
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhBPLCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhBPLAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 06:00:36 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C78C0617AA
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:58:22 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id v62so4494103wmg.4
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9itnGMNRrLfIQfTToGhLcxe5CIelofdkEOca4lbkXKU=;
        b=d1LXmUjU+o1TvgaeibJ49zxFqcdfTZi3jXPWwEJDWAZyC55RGsP1eHsZBi0D42XFNE
         cAlHO0ERDiT4KTdDRRbQNY0e1i7WBULsG8fZW8o5zTO2bLFvNhLMIM8M7I/xgey0j4ty
         Wv8jw0l2l+bdT4GBjnmaUwAMqrw5uh1qihZuk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9itnGMNRrLfIQfTToGhLcxe5CIelofdkEOca4lbkXKU=;
        b=NmehcvP7GDYPsiq+9wXFE4chYAbHUx0fs2zjN2sZCkDpmzpUXXI43kidBdgi5vY3/p
         HKQD+MLX2BSOYHGr7Nhtmb5M2hssufZppPXUFqBn/kYKtAQLuTKKhdjAvdCw/8qBHljX
         M6DvIIEzp2XxrOoyLs3tfTsUUWFZnLGcdCv7XxwDb705pQgwpfiqzepji1vzrIzXkLTA
         b3BeF+n1EtIHLhx7tg76Zja+NClnrMeYG6efKNK4pZYlgKUNJUneup1IXCs6kTIdpQZY
         XB+F1ubLp2+dHsRYNbK0Q8AZsMb2j1yfH3TutQLUNXrmW/HtYk1tyEq86jx1t23lDkvH
         xSXA==
X-Gm-Message-State: AOAM530U/T5Hxn3Aw+cccRqCEeBWXmpf6GcSfBXJPFoZ+0FyBC3HBtvp
        xI0RD1/WRk9lD+IUBOurgKN8+g==
X-Google-Smtp-Source: ABdhPJxFBJ8gVlub40t8diuQltLKKhC6eSlxM8sfMGsb2Wtirr2s/r4PM6h++YfAc1C2QbmTSJ9ESw==
X-Received: by 2002:a7b:ce12:: with SMTP id m18mr2910994wmc.148.1613473101559;
        Tue, 16 Feb 2021 02:58:21 -0800 (PST)
Received: from antares.lan (111.253.187.81.in-addr.arpa. [81.187.253.111])
        by smtp.gmail.com with ESMTPSA id l1sm2820238wmi.48.2021.02.16.02.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 02:58:21 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jakub@cloudflare.com
Cc:     kernel-team@cloudflare.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 7/8] selftests: bpf: convert sk_lookup ctx access tests to PROG_TEST_RUN
Date:   Tue, 16 Feb 2021 10:57:12 +0000
Message-Id: <20210216105713.45052-8-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216105713.45052-1-lmb@cloudflare.com>
References: <20210216105713.45052-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the selftests for sk_lookup narrow context access to use
PROG_TEST_RUN instead of creating actual sockets. This ensures that
ctx is populated correctly when using PROG_TEST_RUN.

Assert concrete values since we now control remote_ip and remote_port.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sk_lookup.c      | 72 +++++++++++++++----
 .../selftests/bpf/progs/test_sk_lookup.c      | 62 ++++++++++------
 2 files changed, 98 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index a8e4a2044170..eb8906ace5a9 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -241,6 +241,37 @@ static int make_client(int sotype, const char *ip, int port)
 	return -1;
 }
 
+static int fill_sk_lookup_ctx(struct bpf_sk_lookup *ctx, const char *local_ip, __u16 local_port,
+			      const char *remote_ip, __u16 remote_port)
+{
+	void *local, *remote;
+	int err;
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->local_port = local_port;
+	ctx->remote_port = htons(remote_port);
+
+	if (is_ipv6(local_ip)) {
+		ctx->family = AF_INET6;
+		local = &ctx->local_ip6[0];
+		remote = &ctx->remote_ip6[0];
+	} else {
+		ctx->family = AF_INET;
+		local = &ctx->local_ip4;
+		remote = &ctx->remote_ip4;
+	}
+
+	err = inet_pton(ctx->family, local_ip, local);
+	if (CHECK(err != 1, "inet_pton", "local_ip failed\n"))
+		return 1;
+
+	err = inet_pton(ctx->family, remote_ip, remote);
+	if (CHECK(err != 1, "inet_pton", "remote_ip failed\n"))
+		return 1;
+
+	return 0;
+}
+
 static int send_byte(int fd)
 {
 	ssize_t n;
@@ -1020,18 +1051,27 @@ static void test_drop_on_reuseport(struct test_sk_lookup *skel)
 
 static void run_sk_assign(struct test_sk_lookup *skel,
 			  struct bpf_program *lookup_prog,
-			  const char *listen_ip, const char *connect_ip)
+			  const char *remote_ip, const char *local_ip)
 {
-	int client_fd, peer_fd, server_fds[MAX_SERVERS] = { -1 };
-	struct bpf_link *lookup_link;
+	int server_fds[MAX_SERVERS] = { -1 };
+	struct bpf_sk_lookup ctx;
+	__u64 server_cookie;
 	int i, err;
 
-	lookup_link = attach_lookup_prog(lookup_prog);
-	if (!lookup_link)
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
+		.ctx_in = &ctx,
+		.ctx_size_in = sizeof(ctx),
+		.ctx_out = &ctx,
+		.ctx_size_out = sizeof(ctx),
+	);
+
+	if (fill_sk_lookup_ctx(&ctx, local_ip, EXT_PORT, remote_ip, INT_PORT))
 		return;
 
+	ctx.protocol = IPPROTO_TCP;
+
 	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
-		server_fds[i] = make_server(SOCK_STREAM, listen_ip, 0, NULL);
+		server_fds[i] = make_server(SOCK_STREAM, local_ip, 0, NULL);
 		if (server_fds[i] < 0)
 			goto close_servers;
 
@@ -1041,23 +1081,25 @@ static void run_sk_assign(struct test_sk_lookup *skel,
 			goto close_servers;
 	}
 
-	client_fd = make_client(SOCK_STREAM, connect_ip, EXT_PORT);
-	if (client_fd < 0)
+	server_cookie = socket_cookie(server_fds[SERVER_B]);
+	if (!server_cookie)
+		return;
+
+	err = bpf_prog_test_run_opts(bpf_program__fd(lookup_prog), &opts);
+	if (CHECK(err, "test_run", "failed with error %d\n", errno))
+		goto close_servers;
+
+	if (CHECK(ctx.cookie == 0, "ctx.cookie", "no socket selected\n"))
 		goto close_servers;
 
-	peer_fd = accept(server_fds[SERVER_B], NULL, NULL);
-	if (CHECK(peer_fd < 0, "accept", "failed\n"))
-		goto close_client;
+	CHECK(ctx.cookie != server_cookie, "ctx.cookie",
+	      "selected sk %llu instead of %llu\n", ctx.cookie, server_cookie);
 
-	close(peer_fd);
-close_client:
-	close(client_fd);
 close_servers:
 	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
 		if (server_fds[i] != -1)
 			close(server_fds[i]);
 	}
-	bpf_link__destroy(lookup_link);
 }
 
 static void run_sk_assign_v4(struct test_sk_lookup *skel,
diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
index 1032b292af5b..ac6f7f205e25 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
@@ -64,6 +64,10 @@ static const int PROG_DONE = 1;
 static const __u32 KEY_SERVER_A = SERVER_A;
 static const __u32 KEY_SERVER_B = SERVER_B;
 
+static const __u16 SRC_PORT = bpf_htons(8008);
+static const __u32 SRC_IP4 = IP4(127, 0, 0, 2);
+static const __u32 SRC_IP6[] = IP6(0xfd000000, 0x0, 0x0, 0x00000002);
+
 static const __u16 DST_PORT = 7007; /* Host byte order */
 static const __u32 DST_IP4 = IP4(127, 0, 0, 1);
 static const __u32 DST_IP6[] = IP6(0xfd000000, 0x0, 0x0, 0x00000001);
@@ -398,11 +402,12 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
 	if (LSW(ctx->protocol, 0) != IPPROTO_TCP)
 		return SK_DROP;
 
-	/* Narrow loads from remote_port field. Expect non-0 value. */
-	if (LSB(ctx->remote_port, 0) == 0 && LSB(ctx->remote_port, 1) == 0 &&
-	    LSB(ctx->remote_port, 2) == 0 && LSB(ctx->remote_port, 3) == 0)
+	/* Narrow loads from remote_port field. Expect SRC_PORT. */
+	if (LSB(ctx->remote_port, 0) != ((SRC_PORT >> 0) & 0xff) ||
+	    LSB(ctx->remote_port, 1) != ((SRC_PORT >> 8) & 0xff) ||
+	    LSB(ctx->remote_port, 2) != 0 || LSB(ctx->remote_port, 3) != 0)
 		return SK_DROP;
-	if (LSW(ctx->remote_port, 0) == 0)
+	if (LSW(ctx->remote_port, 0) != SRC_PORT)
 		return SK_DROP;
 
 	/* Narrow loads from local_port field. Expect DST_PORT. */
@@ -415,11 +420,14 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
 
 	/* Narrow loads from IPv4 fields */
 	if (v4) {
-		/* Expect non-0.0.0.0 in remote_ip4 */
-		if (LSB(ctx->remote_ip4, 0) == 0 && LSB(ctx->remote_ip4, 1) == 0 &&
-		    LSB(ctx->remote_ip4, 2) == 0 && LSB(ctx->remote_ip4, 3) == 0)
+		/* Expect SRC_IP4 in remote_ip4 */
+		if (LSB(ctx->remote_ip4, 0) != ((SRC_IP4 >> 0) & 0xff) ||
+		    LSB(ctx->remote_ip4, 1) != ((SRC_IP4 >> 8) & 0xff) ||
+		    LSB(ctx->remote_ip4, 2) != ((SRC_IP4 >> 16) & 0xff) ||
+		    LSB(ctx->remote_ip4, 3) != ((SRC_IP4 >> 24) & 0xff))
 			return SK_DROP;
-		if (LSW(ctx->remote_ip4, 0) == 0 && LSW(ctx->remote_ip4, 1) == 0)
+		if (LSW(ctx->remote_ip4, 0) != ((SRC_IP4 >> 0) & 0xffff) ||
+		    LSW(ctx->remote_ip4, 1) != ((SRC_IP4 >> 16) & 0xffff))
 			return SK_DROP;
 
 		/* Expect DST_IP4 in local_ip4 */
@@ -448,20 +456,32 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
 
 	/* Narrow loads from IPv6 fields */
 	if (!v4) {
-		/* Expect non-:: IP in remote_ip6 */
-		if (LSB(ctx->remote_ip6[0], 0) == 0 && LSB(ctx->remote_ip6[0], 1) == 0 &&
-		    LSB(ctx->remote_ip6[0], 2) == 0 && LSB(ctx->remote_ip6[0], 3) == 0 &&
-		    LSB(ctx->remote_ip6[1], 0) == 0 && LSB(ctx->remote_ip6[1], 1) == 0 &&
-		    LSB(ctx->remote_ip6[1], 2) == 0 && LSB(ctx->remote_ip6[1], 3) == 0 &&
-		    LSB(ctx->remote_ip6[2], 0) == 0 && LSB(ctx->remote_ip6[2], 1) == 0 &&
-		    LSB(ctx->remote_ip6[2], 2) == 0 && LSB(ctx->remote_ip6[2], 3) == 0 &&
-		    LSB(ctx->remote_ip6[3], 0) == 0 && LSB(ctx->remote_ip6[3], 1) == 0 &&
-		    LSB(ctx->remote_ip6[3], 2) == 0 && LSB(ctx->remote_ip6[3], 3) == 0)
+		/* Expect SRC_IP6 in remote_ip6 */
+		if (LSB(ctx->remote_ip6[0], 0) != ((SRC_IP6[0] >> 0) & 0xff) ||
+		    LSB(ctx->remote_ip6[0], 1) != ((SRC_IP6[0] >> 8) & 0xff) ||
+		    LSB(ctx->remote_ip6[0], 2) != ((SRC_IP6[0] >> 16) & 0xff) ||
+		    LSB(ctx->remote_ip6[0], 3) != ((SRC_IP6[0] >> 24) & 0xff) ||
+		    LSB(ctx->remote_ip6[1], 0) != ((SRC_IP6[1] >> 0) & 0xff) ||
+		    LSB(ctx->remote_ip6[1], 1) != ((SRC_IP6[1] >> 8) & 0xff) ||
+		    LSB(ctx->remote_ip6[1], 2) != ((SRC_IP6[1] >> 16) & 0xff) ||
+		    LSB(ctx->remote_ip6[1], 3) != ((SRC_IP6[1] >> 24) & 0xff) ||
+		    LSB(ctx->remote_ip6[2], 0) != ((SRC_IP6[2] >> 0) & 0xff) ||
+		    LSB(ctx->remote_ip6[2], 1) != ((SRC_IP6[2] >> 8) & 0xff) ||
+		    LSB(ctx->remote_ip6[2], 2) != ((SRC_IP6[2] >> 16) & 0xff) ||
+		    LSB(ctx->remote_ip6[2], 3) != ((SRC_IP6[2] >> 24) & 0xff) ||
+		    LSB(ctx->remote_ip6[3], 0) != ((SRC_IP6[3] >> 0) & 0xff) ||
+		    LSB(ctx->remote_ip6[3], 1) != ((SRC_IP6[3] >> 8) & 0xff) ||
+		    LSB(ctx->remote_ip6[3], 2) != ((SRC_IP6[3] >> 16) & 0xff) ||
+		    LSB(ctx->remote_ip6[3], 3) != ((SRC_IP6[3] >> 24) & 0xff))
 			return SK_DROP;
-		if (LSW(ctx->remote_ip6[0], 0) == 0 && LSW(ctx->remote_ip6[0], 1) == 0 &&
-		    LSW(ctx->remote_ip6[1], 0) == 0 && LSW(ctx->remote_ip6[1], 1) == 0 &&
-		    LSW(ctx->remote_ip6[2], 0) == 0 && LSW(ctx->remote_ip6[2], 1) == 0 &&
-		    LSW(ctx->remote_ip6[3], 0) == 0 && LSW(ctx->remote_ip6[3], 1) == 0)
+		if (LSW(ctx->remote_ip6[0], 0) != ((SRC_IP6[0] >> 0) & 0xffff) ||
+		    LSW(ctx->remote_ip6[0], 1) != ((SRC_IP6[0] >> 16) & 0xffff) ||
+		    LSW(ctx->remote_ip6[1], 0) != ((SRC_IP6[1] >> 0) & 0xffff) ||
+		    LSW(ctx->remote_ip6[1], 1) != ((SRC_IP6[1] >> 16) & 0xffff) ||
+		    LSW(ctx->remote_ip6[2], 0) != ((SRC_IP6[2] >> 0) & 0xffff) ||
+		    LSW(ctx->remote_ip6[2], 1) != ((SRC_IP6[2] >> 16) & 0xffff) ||
+		    LSW(ctx->remote_ip6[3], 0) != ((SRC_IP6[3] >> 0) & 0xffff) ||
+		    LSW(ctx->remote_ip6[3], 1) != ((SRC_IP6[3] >> 16) & 0xffff))
 			return SK_DROP;
 		/* Expect DST_IP6 in local_ip6 */
 		if (LSB(ctx->local_ip6[0], 0) != ((DST_IP6[0] >> 0) & 0xff) ||
-- 
2.27.0

