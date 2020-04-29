Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6EB1BE5F4
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgD2SML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727095AbgD2SMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:12:02 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AFFC03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:12:01 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id t14so3668082wrw.12
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A6yReQfWel8N8XspB7c+LKaQbzotdMEmsjvC572L9/M=;
        b=JKptpkcDv9Y9+p+UoZSqU/g192VvaBLlx+chnXxGIauOeBEMIJYf7WKonPRyaVnDOg
         ghexBtJHRJOzBw5MUe9HIMKYF5NeOhnruI8OUJPWp7oIPBbYU6CK9SgXdF7oPYqwOUvC
         Cq1CTQMikenJXRRvsnnut9bkB+tZntdW6XI6c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A6yReQfWel8N8XspB7c+LKaQbzotdMEmsjvC572L9/M=;
        b=BxFZXdO6N1BW3HgbQRx6oZt367f42XY2MMBn4xFoxAqY0SpRGgM2Tdi+WtOGB4yeY8
         /8wfFxiww+YwSv4V+PnqHdpmnLYCAH/ocdtw3iAM/Tsc8gl3wiVRGegTQox3Lbk5wGry
         F3iRfoLgNrA37kdFNQVlsr9cQ3DByPIevhyUwjLUAw1rU4X3HCBl2EQLR/d3A8RtvDIO
         oEX/s+5SdslJFrWJ/uuBAClJj1to2KKjmPlxDGHi43Xs1Ngu+nAKOiuXH1wtoNXjDngp
         U5wtn+NBT3x2bOOLs6Zjv49M+mVO/q4zfHb7L/VPrhBBmQ3H0UJm9AR+FD6eNNTrBH2A
         4XLg==
X-Gm-Message-State: AGi0PubetzULQk6CZep3D66vYWu2ZoBHIPqLKF4AD8LWMwoIznsKVHCP
        6TtjGQwmM75CbnIPPruvsVyH8Q==
X-Google-Smtp-Source: APiQypJM3arCrzF2jEPy5RqPkMrmTKi3KWxanNiAvhrbjCYwI6RRz0UOgLE9N18ggvZTFqcVonTU/Q==
X-Received: by 2002:a5d:5652:: with SMTP id j18mr43447402wrw.40.1588183920262;
        Wed, 29 Apr 2020 11:12:00 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id o129sm9222703wme.16.2020.04.29.11.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 11:11:59 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joe Stringer <joe@wand.net.nz>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next 3/3] selftests/bpf: Use SOCKMAP for server sockets in bpf_sk_assign test
Date:   Wed, 29 Apr 2020 20:11:54 +0200
Message-Id: <20200429181154.479310-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200429181154.479310-1-jakub@cloudflare.com>
References: <20200429181154.479310-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update bpf_sk_assign test to fetch the server socket from SOCKMAP, now that
map lookup from BPF in SOCKMAP is enabled. This way the test TC BPF program
doesn't need to know what address server socket is bound to.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/Makefile          |  2 +-
 .../selftests/bpf/prog_tests/sk_assign.c      | 21 ++++-
 .../selftests/bpf/progs/test_sk_assign.c      | 82 ++++++++-----------
 3 files changed, 53 insertions(+), 52 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 10f12a5aac20..3d942be23d09 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -243,7 +243,7 @@ define GCC_BPF_BUILD_RULE
 	$(BPF_GCC) $3 $4 -O2 -c $1 -o $2
 endef
 
-SKEL_BLACKLIST := btf__% test_pinning_invalid.c
+SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
 # Set up extra TRUNNER_XXX "temporary" variables in the environment (relies on
 # $eval()) and pass control to DEFINE_TEST_RUNNER_RULES.
diff --git a/tools/testing/selftests/bpf/prog_tests/sk_assign.c b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
index d572e1a2c297..47fa04adc147 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_assign.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
@@ -20,6 +20,7 @@
 #define CONNECT_PORT 4321
 #define TEST_DADDR (0xC0A80203)
 #define NS_SELF "/proc/self/ns/net"
+#define SERVER_MAP_PATH "/sys/fs/bpf/tc/globals/server_map"
 
 static const struct timeval timeo_sec = { .tv_sec = 3 };
 static const size_t timeo_optlen = sizeof(timeo_sec);
@@ -265,6 +266,7 @@ void test_sk_assign(void)
 		TEST("ipv6 udp addr redir", AF_INET6, SOCK_DGRAM, true),
 	};
 	int server = -1;
+	int server_map;
 	int self_net;
 
 	self_net = open(NS_SELF, O_RDONLY);
@@ -278,9 +280,17 @@ void test_sk_assign(void)
 		goto cleanup;
 	}
 
+	server_map = bpf_obj_get(SERVER_MAP_PATH);
+	if (CHECK_FAIL(server_map < 0)) {
+		perror("Unable to open " SERVER_MAP_PATH);
+		goto cleanup;
+	}
+
 	for (int i = 0; i < ARRAY_SIZE(tests) && !READ_ONCE(stop); i++) {
 		struct test_sk_cfg *test = &tests[i];
 		const struct sockaddr *addr;
+		const int zero = 0;
+		int err;
 
 		if (!test__start_subtest(test->name))
 			continue;
@@ -288,7 +298,13 @@ void test_sk_assign(void)
 		addr = (const struct sockaddr *)test->addr;
 		server = start_server(addr, test->len, test->type);
 		if (server == -1)
-			goto cleanup;
+			goto close;
+
+		err = bpf_map_update_elem(server_map, &zero, &server, BPF_ANY);
+		if (CHECK_FAIL(err)) {
+			perror("Unable to update server_map");
+			goto close;
+		}
 
 		/* connect to unbound ports */
 		prepare_addr(test->addr, test->family, CONNECT_PORT,
@@ -302,7 +318,10 @@ void test_sk_assign(void)
 
 close:
 	close(server);
+	close(server_map);
 cleanup:
+	if (CHECK_FAIL(unlink(SERVER_MAP_PATH)))
+		perror("Unable to unlink " SERVER_MAP_PATH);
 	if (CHECK_FAIL(setns(self_net, CLONE_NEWNET)))
 		perror("Failed to setns("NS_SELF")");
 	close(self_net);
diff --git a/tools/testing/selftests/bpf/progs/test_sk_assign.c b/tools/testing/selftests/bpf/progs/test_sk_assign.c
index 8f530843b4da..1ecd987005d2 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_assign.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_assign.c
@@ -16,6 +16,26 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
 
+/* Pin map under /sys/fs/bpf/tc/globals/<map name> */
+#define PIN_GLOBAL_NS 2
+
+/* Must match struct bpf_elf_map layout from iproute2 */
+struct {
+	__u32 type;
+	__u32 size_key;
+	__u32 size_value;
+	__u32 max_elem;
+	__u32 flags;
+	__u32 id;
+	__u32 pinning;
+} server_map SEC("maps") = {
+	.type = BPF_MAP_TYPE_SOCKMAP,
+	.size_key = sizeof(int),
+	.size_value  = sizeof(__u64),
+	.max_elem = 1,
+	.pinning = PIN_GLOBAL_NS,
+};
+
 int _version SEC("version") = 1;
 char _license[] SEC("license") = "GPL";
 
@@ -72,7 +92,9 @@ handle_udp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
 {
 	struct bpf_sock_tuple ln = {0};
 	struct bpf_sock *sk;
+	const int zero = 0;
 	size_t tuple_len;
+	__be16 dport;
 	int ret;
 
 	tuple_len = ipv4 ? sizeof(tuple->ipv4) : sizeof(tuple->ipv6);
@@ -83,32 +105,11 @@ handle_udp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
 	if (sk)
 		goto assign;
 
-	if (ipv4) {
-		if (tuple->ipv4.dport != bpf_htons(4321))
-			return TC_ACT_OK;
-
-		ln.ipv4.daddr = bpf_htonl(0x7f000001);
-		ln.ipv4.dport = bpf_htons(1234);
-
-		sk = bpf_sk_lookup_udp(skb, &ln, sizeof(ln.ipv4),
-					BPF_F_CURRENT_NETNS, 0);
-	} else {
-		if (tuple->ipv6.dport != bpf_htons(4321))
-			return TC_ACT_OK;
-
-		/* Upper parts of daddr are already zero. */
-		ln.ipv6.daddr[3] = bpf_htonl(0x1);
-		ln.ipv6.dport = bpf_htons(1234);
-
-		sk = bpf_sk_lookup_udp(skb, &ln, sizeof(ln.ipv6),
-					BPF_F_CURRENT_NETNS, 0);
-	}
+	dport = ipv4 ? tuple->ipv4.dport : tuple->ipv6.dport;
+	if (dport != bpf_htons(4321))
+		return TC_ACT_OK;
 
-	/* workaround: We can't do a single socket lookup here, because then
-	 * the compiler will likely spill tuple_len to the stack. This makes it
-	 * lose all bounds information in the verifier, which then rejects the
-	 * call as unsafe.
-	 */
+	sk = bpf_map_lookup_elem(&server_map, &zero);
 	if (!sk)
 		return TC_ACT_SHOT;
 
@@ -123,7 +124,9 @@ handle_tcp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
 {
 	struct bpf_sock_tuple ln = {0};
 	struct bpf_sock *sk;
+	const int zero = 0;
 	size_t tuple_len;
+	__be16 dport;
 	int ret;
 
 	tuple_len = ipv4 ? sizeof(tuple->ipv4) : sizeof(tuple->ipv6);
@@ -137,32 +140,11 @@ handle_tcp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
 		bpf_sk_release(sk);
 	}
 
-	if (ipv4) {
-		if (tuple->ipv4.dport != bpf_htons(4321))
-			return TC_ACT_OK;
+	dport = ipv4 ? tuple->ipv4.dport : tuple->ipv6.dport;
+	if (dport != bpf_htons(4321))
+		return TC_ACT_OK;
 
-		ln.ipv4.daddr = bpf_htonl(0x7f000001);
-		ln.ipv4.dport = bpf_htons(1234);
-
-		sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv4),
-					BPF_F_CURRENT_NETNS, 0);
-	} else {
-		if (tuple->ipv6.dport != bpf_htons(4321))
-			return TC_ACT_OK;
-
-		/* Upper parts of daddr are already zero. */
-		ln.ipv6.daddr[3] = bpf_htonl(0x1);
-		ln.ipv6.dport = bpf_htons(1234);
-
-		sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv6),
-					BPF_F_CURRENT_NETNS, 0);
-	}
-
-	/* workaround: We can't do a single socket lookup here, because then
-	 * the compiler will likely spill tuple_len to the stack. This makes it
-	 * lose all bounds information in the verifier, which then rejects the
-	 * call as unsafe.
-	 */
+	sk = bpf_map_lookup_elem(&server_map, &zero);
 	if (!sk)
 		return TC_ACT_SHOT;
 
-- 
2.25.3

