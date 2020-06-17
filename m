Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95861FC327
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 03:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgFQBEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 21:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgFQBEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 21:04:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C97C0613ED
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 18:04:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n11so647763ybg.15
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 18:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MkbdLvL2Zi1F3Tsi0YsCAEZhQKEx0IBwe0FoxjY0e3c=;
        b=g9bLvjsstMgwhrFyn2geeCipVFJDfjFr9/8EzPLrncu8SsjJ2uFI8H/IeFhK/9rsO0
         vzC+nBEerldx7v6RIhgIwFp+5jZ7xgsuU2EMeRMNki5DzXAJ94ji4bfXEhzOWxUJVupd
         89PkXXVGcaFXhfKueij1hQRr5cub8+1cLHJbYOn2yx1XMFc+E2ImE07pMi3UecnT9PgV
         bH09jIxxcN0XOOiFjKjUQjt5CgXYVH7YwhxkMEF5ALzhmdP5YlguqaPxGzeCKP4iZklZ
         qr7EPnz5KFxL8BQya11L5BiTrxnQHOjCbTFuIdYCpufNEW6qe6e0xMX7fxMa85viptMw
         Bw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MkbdLvL2Zi1F3Tsi0YsCAEZhQKEx0IBwe0FoxjY0e3c=;
        b=h+41mZkw2Tsr1/UJCvOqOf4Dx1Kvg0Sk6cMqlFZMbu/jLBDQrAe75SYwl6yrFCJqgK
         RWHv+9bDLjj7XpGetzuW4f2ypAQ10Py+rX32KywQl9metH0ZIsEEzQEPl70an13Rwyxx
         +vnl2KN8M6CuR9Ks5UISWEjCHJtlBnbCRc/HJRnHgPjwojlrRbjeLbRsnwbzOMWgojdb
         3x229yvXV8mc1xL7kYFgA9CGtKWjECxxQaXlAMBQDwmV47MymW5WAZ5e0313BqmJsz0S
         Gdq+NscSjmtsgeVFgLkm2Y6yHpAUnYqQ3TmITI9zUI5QYk0qc/uxZQ7zUEKZD3EC8Q8A
         Tjyw==
X-Gm-Message-State: AOAM531rIbB2pmEj6FmMRwKBCZjf7AwWr3Wf4w1xcYYkLVTH6wR98Hv+
        hCc4MUQ9j0QhbBtP1/PpwdKMW3E2DeCDi6dg/++26dWHSZu/Vd7dywqQGk6Zw0zc00T5M+Fm0zQ
        cSKe/lMVZrbm5dlS4fJkF1QoU6VO0teolFfEkPjNkTPl7IhJY+11K/Q==
X-Google-Smtp-Source: ABdhPJw0253CCA3tRzHDPqpiCitYohp6QS9lcZBoJFKaztrU98zWvQViWAcHhVCShRPrZziZIGcDDw8=
X-Received: by 2002:a25:9ac5:: with SMTP id t5mr8859813ybo.410.1592355860214;
 Tue, 16 Jun 2020 18:04:20 -0700 (PDT)
Date:   Tue, 16 Jun 2020 18:04:15 -0700
In-Reply-To: <20200617010416.93086-1-sdf@google.com>
Message-Id: <20200617010416.93086-2-sdf@google.com>
Mime-Version: 1.0
References: <20200617010416.93086-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH bpf v5 2/3] selftests/bpf: make sure optvals > PAGE_SIZE are bypassed
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are relying on the fact, that we can pass > sizeof(int) optvals
to the SOL_IP+IP_FREEBIND option (the kernel will take first 4 bytes).
In the BPF program we check that we can only touch PAGE_SIZE bytes,
but the real optlen is PAGE_SIZE * 2. In both cases, we override it to
some predefined value and trim the optlen.

Also, let's modify exiting IP_TOS usecase to test optlen=0 case
where BPF program just bypasses the data as is.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/sockopt_sk.c     | 46 +++++++++++++---
 .../testing/selftests/bpf/progs/sockopt_sk.c  | 54 ++++++++++++++++++-
 2 files changed, 91 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
index 2061a6beac0f..5f54c6aec7f0 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
@@ -13,6 +13,7 @@ static int getsetsockopt(void)
 		char cc[16]; /* TCP_CA_NAME_MAX */
 	} buf = {};
 	socklen_t optlen;
+	char *big_buf = NULL;
 
 	fd = socket(AF_INET, SOCK_STREAM, 0);
 	if (fd < 0) {
@@ -22,24 +23,31 @@ static int getsetsockopt(void)
 
 	/* IP_TOS - BPF bypass */
 
-	buf.u8[0] = 0x08;
-	err = setsockopt(fd, SOL_IP, IP_TOS, &buf, 1);
+	optlen = getpagesize() * 2;
+	big_buf = calloc(1, optlen);
+	if (!big_buf) {
+		log_err("Couldn't allocate two pages");
+		goto err;
+	}
+
+	*(int *)big_buf = 0x08;
+	err = setsockopt(fd, SOL_IP, IP_TOS, big_buf, optlen);
 	if (err) {
 		log_err("Failed to call setsockopt(IP_TOS)");
 		goto err;
 	}
 
-	buf.u8[0] = 0x00;
+	memset(big_buf, 0, optlen);
 	optlen = 1;
-	err = getsockopt(fd, SOL_IP, IP_TOS, &buf, &optlen);
+	err = getsockopt(fd, SOL_IP, IP_TOS, big_buf, &optlen);
 	if (err) {
 		log_err("Failed to call getsockopt(IP_TOS)");
 		goto err;
 	}
 
-	if (buf.u8[0] != 0x08) {
-		log_err("Unexpected getsockopt(IP_TOS) buf[0] 0x%02x != 0x08",
-			buf.u8[0]);
+	if (*(int *)big_buf != 0x08) {
+		log_err("Unexpected getsockopt(IP_TOS) optval 0x%x != 0x08",
+			*(int *)big_buf);
 		goto err;
 	}
 
@@ -78,6 +86,28 @@ static int getsetsockopt(void)
 		goto err;
 	}
 
+	/* IP_FREEBIND - BPF can't access optval past PAGE_SIZE */
+
+	optlen = getpagesize() * 2;
+	memset(big_buf, 0, optlen);
+
+	err = setsockopt(fd, SOL_IP, IP_FREEBIND, big_buf, optlen);
+	if (err != 0) {
+		log_err("Failed to call setsockopt, ret=%d", err);
+		goto err;
+	}
+
+	err = getsockopt(fd, SOL_IP, IP_FREEBIND, big_buf, &optlen);
+	if (err != 0) {
+		log_err("Failed to call getsockopt, ret=%d", err);
+		goto err;
+	}
+
+	if (optlen != 1 || *(__u8 *)big_buf != 0x55) {
+		log_err("Unexpected IP_FREEBIND getsockopt, optlen=%d, optval=0x%x",
+			optlen, *(__u8 *)big_buf);
+	}
+
 	/* SO_SNDBUF is overwritten */
 
 	buf.u32 = 0x01010101;
@@ -124,9 +154,11 @@ static int getsetsockopt(void)
 		goto err;
 	}
 
+	free(big_buf);
 	close(fd);
 	return 0;
 err:
+	free(big_buf);
 	close(fd);
 	return -1;
 }
diff --git a/tools/testing/selftests/bpf/progs/sockopt_sk.c b/tools/testing/selftests/bpf/progs/sockopt_sk.c
index d5a5eeb5fb52..712df7b49cb1 100644
--- a/tools/testing/selftests/bpf/progs/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -8,6 +8,10 @@
 char _license[] SEC("license") = "GPL";
 __u32 _version SEC("version") = 1;
 
+#ifndef PAGE_SIZE
+#define PAGE_SIZE 4096
+#endif
+
 #define SOL_CUSTOM			0xdeadbeef
 
 struct sockopt_sk {
@@ -28,12 +32,14 @@ int _getsockopt(struct bpf_sockopt *ctx)
 	__u8 *optval = ctx->optval;
 	struct sockopt_sk *storage;
 
-	if (ctx->level == SOL_IP && ctx->optname == IP_TOS)
+	if (ctx->level == SOL_IP && ctx->optname == IP_TOS) {
 		/* Not interested in SOL_IP:IP_TOS;
 		 * let next BPF program in the cgroup chain or kernel
 		 * handle it.
 		 */
+		ctx->optlen = 0; /* bypass optval>PAGE_SIZE */
 		return 1;
+	}
 
 	if (ctx->level == SOL_SOCKET && ctx->optname == SO_SNDBUF) {
 		/* Not interested in SOL_SOCKET:SO_SNDBUF;
@@ -51,6 +57,26 @@ int _getsockopt(struct bpf_sockopt *ctx)
 		return 1;
 	}
 
+	if (ctx->level == SOL_IP && ctx->optname == IP_FREEBIND) {
+		if (optval + 1 > optval_end)
+			return 0; /* EPERM, bounds check */
+
+		ctx->retval = 0; /* Reset system call return value to zero */
+
+		/* Always export 0x55 */
+		optval[0] = 0x55;
+		ctx->optlen = 1;
+
+		/* Userspace buffer is PAGE_SIZE * 2, but BPF
+		 * program can only see the first PAGE_SIZE
+		 * bytes of data.
+		 */
+		if (optval_end - optval != PAGE_SIZE)
+			return 0; /* EPERM, unexpected data size */
+
+		return 1;
+	}
+
 	if (ctx->level != SOL_CUSTOM)
 		return 0; /* EPERM, deny everything except custom level */
 
@@ -81,12 +107,14 @@ int _setsockopt(struct bpf_sockopt *ctx)
 	__u8 *optval = ctx->optval;
 	struct sockopt_sk *storage;
 
-	if (ctx->level == SOL_IP && ctx->optname == IP_TOS)
+	if (ctx->level == SOL_IP && ctx->optname == IP_TOS) {
 		/* Not interested in SOL_IP:IP_TOS;
 		 * let next BPF program in the cgroup chain or kernel
 		 * handle it.
 		 */
+		ctx->optlen = 0; /* bypass optval>PAGE_SIZE */
 		return 1;
+	}
 
 	if (ctx->level == SOL_SOCKET && ctx->optname == SO_SNDBUF) {
 		/* Overwrite SO_SNDBUF value */
@@ -112,6 +140,28 @@ int _setsockopt(struct bpf_sockopt *ctx)
 		return 1;
 	}
 
+	if (ctx->level == SOL_IP && ctx->optname == IP_FREEBIND) {
+		/* Original optlen is larger than PAGE_SIZE. */
+		if (ctx->optlen != PAGE_SIZE * 2)
+			return 0; /* EPERM, unexpected data size */
+
+		if (optval + 1 > optval_end)
+			return 0; /* EPERM, bounds check */
+
+		/* Make sure we can trim the buffer. */
+		optval[0] = 0;
+		ctx->optlen = 1;
+
+		/* Usepace buffer is PAGE_SIZE * 2, but BPF
+		 * program can only see the first PAGE_SIZE
+		 * bytes of data.
+		 */
+		if (optval_end - optval != PAGE_SIZE)
+			return 0; /* EPERM, unexpected data size */
+
+		return 1;
+	}
+
 	if (ctx->level != SOL_CUSTOM)
 		return 0; /* EPERM, deny everything except custom level */
 
-- 
2.27.0.290.gba653c62da-goog

