Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E91327BEC
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhCAKXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbhCAKVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:21:41 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3247DC061793
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 02:19:29 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id o16so13895884wmh.0
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 02:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RNT0BrgEQwgpk+nE5OFlRQqSY1z2sQW181Q6sU6WNZA=;
        b=AwYSq4ofP643jfQqMGnCZVJ/Wo0zBSisF8BOKol1v2z+aa/HUGb/uMtsIOsZAaen6H
         qRf+YVxywHv83v3LiAmSXGrLyma43AbCDkM8FXK02BP3QSavFyWzyIwcotAbKM3bA/Ay
         pjGLIgMsZIBM3geNQxvAkVCRtm9cET97rEsYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RNT0BrgEQwgpk+nE5OFlRQqSY1z2sQW181Q6sU6WNZA=;
        b=mLTbH53CcyIG0RH3k99XiRhWiDzR3y+Sg31oF/H/Fu50tTupJXMLmj8+QXSvnGdrnN
         5hkXBJGZSrrC5+Iau7+145V+s19drwby9gxRHtgFbNDgIrU1r7tbPePdbg7oeAUHmk2u
         wtMPfEQEQgIEXCudOsEtDisnzW2CbCjF2ECbE3/StSU3thPYeE0VtyROhlebvx1DM2fk
         YPN3i09+oBkH2LwXsljaTSO8STN1kcaVRBzf4S/9g3dQgQ6WZvSfeXq4QrDreFxCcNdq
         LJ1zcY/ngZXvIqSj2spieOWG/2mF2DBTGxqgPcOa/+m4fXQxIsrqoTZE/+QseMqXJR4r
         vvrw==
X-Gm-Message-State: AOAM531vDWcONVe/oHisTQdwMq0YDF+5UG172fWPVvw0polXvi88H5pP
        ZV8XVdTnKLB+NjTLFJ49sAfo/A==
X-Google-Smtp-Source: ABdhPJx8FclFAiw6t487bTc/joUWW0bP7WnnaFWU/o/9kdAtNlo3AqR6sni7tN7g3him1eeveE+3rg==
X-Received: by 2002:a05:600c:2947:: with SMTP id n7mr4576415wmd.61.1614593967898;
        Mon, 01 Mar 2021 02:19:27 -0800 (PST)
Received: from localhost.localdomain (2.b.a.d.8.4.b.a.9.e.4.2.1.8.0.5.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:5081:24e9:ab48:dab2])
        by smtp.gmail.com with ESMTPSA id a198sm14134600wmd.11.2021.03.01.02.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 02:19:27 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v3 3/5] selftests: bpf: convert sk_lookup ctx access tests to PROG_TEST_RUN
Date:   Mon,  1 Mar 2021 10:18:57 +0000
Message-Id: <20210301101859.46045-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210301101859.46045-1-lmb@cloudflare.com>
References: <20210301101859.46045-1-lmb@cloudflare.com>
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
 .../selftests/bpf/prog_tests/sk_lookup.c      | 83 +++++++++++++++----
 .../selftests/bpf/progs/test_sk_lookup.c      | 62 +++++++++-----
 2 files changed, 109 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index 9ff0412e1fd3..45c82db3c58c 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -241,6 +241,48 @@ static int make_client(int sotype, const char *ip, int port)
 	return -1;
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
@@ -1009,18 +1051,27 @@ static void test_drop_on_reuseport(struct test_sk_lookup *skel)
 
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
 
@@ -1030,23 +1081,25 @@ static void run_sk_assign(struct test_sk_lookup *skel,
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

