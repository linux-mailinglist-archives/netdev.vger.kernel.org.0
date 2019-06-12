Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD2D42D8D
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409558AbfFLRaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:30:52 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:44152 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409555AbfFLRaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:30:52 -0400
Received: by mail-vk1-f202.google.com with SMTP id b85so5341845vka.11
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 10:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lnSzeYdpJQCfSwR2gxAs8Ypau7xTKghIzw3qzvylwKU=;
        b=JL37K2LYpYVAau+IhV93rXXut1llW7IBWsF2sKDKVL3Knv0SH0aXSEThpMnqJ8A6G2
         Gk6ggks3Te8uW27ppY++FLtHCBO5dL+ujgVZVY5asHltHtqLzi+8khdmFLD2wVBpJyc3
         MOJXSgpAnNGgu1MifJYGxqjYrSK59CcN8UuvRzTsWpXSeuSfyi4bR7qY3qXuZ7FVco3Q
         80W6u5ki0cgbuUuSx9v4WoBbH2cPCHFlGbwws2H0LBuU2EUp3rUKhgOCmkSi+Y7RLF8u
         +IAUbIQxkh//xNjl9EjPsLbXSj6VkKhdR9uDjwMMp6iBfcZz2oztBAF0Zkd5bpSRJjUp
         /zWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lnSzeYdpJQCfSwR2gxAs8Ypau7xTKghIzw3qzvylwKU=;
        b=TTWlj5IQOECpGMAz8uYNbgumzrm7Qqga8Nru5G7STMyM77QuF313VG6dP+11tSvvJD
         ljmBFZH1BOIQ09iHVMsxX0uZz34uOpDRx4BY1/JcgZDJjOkT8NUz7IE0ygWAxLF2KT3m
         3pAlUTQTZVOOsXIN52zSyLDvc7UJdWxr2vDwVnCt83UtxNLwB5xvC8RfVz2JqnNULp+u
         AXkLQ02jCDeXvaylRHCfU5IhvraxXXAIzNuHYe4r9pgo2rSWeKMIa/eDoZnlUAzoj68v
         NBsUCL3DQNorBdI7oi5D0WYb7AckZXyA48/Eh3eggMT6zn7Viyjp1DBAE0q5O6TXdEik
         5yPA==
X-Gm-Message-State: APjAAAWP+gKE3y7D6EcfMI3rAPblsU61TwDw0c7htQkJZqAzxC8JbjNw
        QX8GevIiXyFC56wgSv0Q7V4yyE5sVKrFy12oj5c0sbtCCC+7GmgWwEnnUaH2i+f76VvQQFZ2OtD
        PA7xgobnJkZhk/M2ywWuhthHvAUGI5qeHPkE4lXMVmwpnmjksq0mN4A==
X-Google-Smtp-Source: APXvYqwwmiWbcPNvQIYtoHc53dcQgUx+dxnQYMKtt0dIs+NqjdAIV/ON7uciV+HNbT4iUwxlPAVg+7c=
X-Received: by 2002:a1f:8744:: with SMTP id j65mr32844970vkd.17.1560360650604;
 Wed, 12 Jun 2019 10:30:50 -0700 (PDT)
Date:   Wed, 12 Jun 2019 10:30:40 -0700
In-Reply-To: <20190612173040.61944-1-sdf@google.com>
Message-Id: <20190612173040.61944-4-sdf@google.com>
Mime-Version: 1.0
References: <20190612173040.61944-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next 4/4] selftests/bpf: convert socket_cookie test to sk storage
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This lets us test that both BPF_PROG_TYPE_CGROUP_SOCK_ADDR and
BPF_PROG_TYPE_SOCK_OPS can access underlying bpf_sock.

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/progs/socket_cookie_prog.c  | 46 ++++++++++++-------
 .../selftests/bpf/test_socket_cookie.c        | 24 ++++------
 2 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/socket_cookie_prog.c b/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
index 9ff8ac4b0bf6..0db15c3210ad 100644
--- a/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
+++ b/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
@@ -7,25 +7,35 @@
 #include "bpf_helpers.h"
 #include "bpf_endian.h"
 
+struct socket_cookie {
+	__u64 cookie_key;
+	__u32 cookie_value;
+};
+
 struct bpf_map_def SEC("maps") socket_cookies = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(__u64),
-	.value_size = sizeof(__u32),
-	.max_entries = 1 << 8,
+	.type = BPF_MAP_TYPE_SK_STORAGE,
+	.key_size = sizeof(int),
+	.value_size = sizeof(struct socket_cookie),
+	.map_flags = BPF_F_NO_PREALLOC,
 };
 
+BPF_ANNOTATE_KV_PAIR(socket_cookies, int, struct socket_cookie);
+
 SEC("cgroup/connect6")
 int set_cookie(struct bpf_sock_addr *ctx)
 {
-	__u32 cookie_value = 0xFF;
-	__u64 cookie_key;
+	struct socket_cookie *p;
 
 	if (ctx->family != AF_INET6 || ctx->user_family != AF_INET6)
 		return 1;
 
-	cookie_key = bpf_get_socket_cookie(ctx);
-	if (bpf_map_update_elem(&socket_cookies, &cookie_key, &cookie_value, 0))
-		return 0;
+	p = bpf_sk_storage_get(&socket_cookies, ctx->sk, 0,
+			       BPF_SK_STORAGE_GET_F_CREATE);
+	if (!p)
+		return 1;
+
+	p->cookie_value = 0xFF;
+	p->cookie_key = bpf_get_socket_cookie(ctx);
 
 	return 1;
 }
@@ -33,9 +43,8 @@ int set_cookie(struct bpf_sock_addr *ctx)
 SEC("sockops")
 int update_cookie(struct bpf_sock_ops *ctx)
 {
-	__u32 new_cookie_value;
-	__u32 *cookie_value;
-	__u64 cookie_key;
+	struct bpf_sock *sk;
+	struct socket_cookie *p;
 
 	if (ctx->family != AF_INET6)
 		return 1;
@@ -43,14 +52,17 @@ int update_cookie(struct bpf_sock_ops *ctx)
 	if (ctx->op != BPF_SOCK_OPS_TCP_CONNECT_CB)
 		return 1;
 
-	cookie_key = bpf_get_socket_cookie(ctx);
+	if (!ctx->sk)
+		return 1;
+
+	p = bpf_sk_storage_get(&socket_cookies, ctx->sk, 0, 0);
+	if (!p)
+		return 1;
 
-	cookie_value = bpf_map_lookup_elem(&socket_cookies, &cookie_key);
-	if (!cookie_value)
+	if (p->cookie_key != bpf_get_socket_cookie(ctx))
 		return 1;
 
-	new_cookie_value = (ctx->local_port << 8) | *cookie_value;
-	bpf_map_update_elem(&socket_cookies, &cookie_key, &new_cookie_value, 0);
+	p->cookie_value = (ctx->local_port << 8) | p->cookie_value;
 
 	return 1;
 }
diff --git a/tools/testing/selftests/bpf/test_socket_cookie.c b/tools/testing/selftests/bpf/test_socket_cookie.c
index cac8ee57a013..15653b0e26eb 100644
--- a/tools/testing/selftests/bpf/test_socket_cookie.c
+++ b/tools/testing/selftests/bpf/test_socket_cookie.c
@@ -18,6 +18,11 @@
 #define CG_PATH			"/foo"
 #define SOCKET_COOKIE_PROG	"./socket_cookie_prog.o"
 
+struct socket_cookie {
+	__u64 cookie_key;
+	__u32 cookie_value;
+};
+
 static int start_server(void)
 {
 	struct sockaddr_in6 addr;
@@ -89,8 +94,7 @@ static int validate_map(struct bpf_map *map, int client_fd)
 	__u32 cookie_expected_value;
 	struct sockaddr_in6 addr;
 	socklen_t len = sizeof(addr);
-	__u32 cookie_value;
-	__u64 cookie_key;
+	struct socket_cookie val;
 	int err = 0;
 	int map_fd;
 
@@ -101,17 +105,7 @@ static int validate_map(struct bpf_map *map, int client_fd)
 
 	map_fd = bpf_map__fd(map);
 
-	err = bpf_map_get_next_key(map_fd, NULL, &cookie_key);
-	if (err) {
-		log_err("Can't get cookie key from map");
-		goto out;
-	}
-
-	err = bpf_map_lookup_elem(map_fd, &cookie_key, &cookie_value);
-	if (err) {
-		log_err("Can't get cookie value from map");
-		goto out;
-	}
+	err = bpf_map_lookup_elem(map_fd, &client_fd, &val);
 
 	err = getsockname(client_fd, (struct sockaddr *)&addr, &len);
 	if (err) {
@@ -120,8 +114,8 @@ static int validate_map(struct bpf_map *map, int client_fd)
 	}
 
 	cookie_expected_value = (ntohs(addr.sin6_port) << 8) | 0xFF;
-	if (cookie_value != cookie_expected_value) {
-		log_err("Unexpected value in map: %x != %x", cookie_value,
+	if (val.cookie_value != cookie_expected_value) {
+		log_err("Unexpected value in map: %x != %x", val.cookie_value,
 			cookie_expected_value);
 		goto err;
 	}
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

