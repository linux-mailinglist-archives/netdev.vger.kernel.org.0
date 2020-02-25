Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0666116C2E8
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgBYN4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:56:53 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33376 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730483AbgBYN4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:56:50 -0500
Received: by mail-wr1-f68.google.com with SMTP id u6so14879995wrt.0
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 05:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SLU+VXTwa+gQnfRMK9gYsKNfXb9lUcrwS038svEJU5o=;
        b=HZfxrO2DE5QWccPhGVGfoZMWEldWLluhX2dBzmqcX5v2Dwhw5kzZWu4eScPwt0X7wv
         YYh4uw6WJJJfEyqNSjN3j/Q7UJ/m/UCmCuGeqXfHG6dn+wPGT8J8yg+FxTi+X9R1xw9R
         eC8O8GHxOuIdzLF5MUntG0vk08oZPlbhR5cv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SLU+VXTwa+gQnfRMK9gYsKNfXb9lUcrwS038svEJU5o=;
        b=DnrQ/igCmc5r+J6ECc8o7//OsBxdmKxLFUvJkovNn+iaCSxCvXjczx3aFXH9IW6bqt
         EeM5BReHBxx7yecCYZSVbbLxlVboO60IltAi/k1LHmRvk9CXnl8uMrZhQMwBQeKhmcSq
         mPTzK501Ih/TVJIgsn3kSecfYItmpB8/BA9/oQJWiEkLHHPNPkuBnf72nJrnxnsRdCUt
         Psbe1MKIp+Y2UwJlt0YrwXAz8Urmsll95faJprCkPxQckwkvpQFnFN/BlWmPqtzkgh9V
         ljKz5vWA9lqufDQEGJkgW3k2I1YK7y6A249m88hMHXIYBLXHDsTTvQqMqnyPotIrmlCR
         6CzQ==
X-Gm-Message-State: APjAAAVs0LOHM2KE21iYYaMe9qbDzcp3JjXYUtI+MIKgRbRXm7TJ9Cz9
        oNKHuGGaPljUha+fnTLOi9Jqhg==
X-Google-Smtp-Source: APXvYqy688F/sc2m+LBgUuAqrJ9I2d4Ungk/+caFLjiRNU2gXHG5tKH4rokIF/aLY+j3dwMM82/UkA==
X-Received: by 2002:adf:d0c1:: with SMTP id z1mr77903608wrh.371.1582639008036;
        Tue, 25 Feb 2020 05:56:48 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8800:3dea:15ba:1870:8e94])
        by smtp.gmail.com with ESMTPSA id t128sm4463580wmf.28.2020.02.25.05.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:56:47 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 6/7] selftests: bpf: add tests for UDP sockets in sockmap
Date:   Tue, 25 Feb 2020 13:56:35 +0000
Message-Id: <20200225135636.5768-7-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225135636.5768-1-lmb@cloudflare.com>
References: <20200225135636.5768-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expand the TCP sockmap test suite to also check UDP sockets.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 92 +++++++++++++------
 1 file changed, 63 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 4ba41dd26d6b..72e578a5a5d2 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -330,7 +330,7 @@ static void test_insert_bound(int family, int sotype, int mapfd)
 	xclose(s);
 }
 
-static void test_insert_listening(int family, int sotype, int mapfd)
+static void test_insert(int family, int sotype, int mapfd)
 {
 	u64 value;
 	u32 key;
@@ -467,7 +467,7 @@ static void test_lookup_32_bit_value(int family, int sotype, int mapfd)
 	xclose(s);
 }
 
-static void test_update_listening(int family, int sotype, int mapfd)
+static void test_update_existing(int family, int sotype, int mapfd)
 {
 	int s1, s2;
 	u64 value;
@@ -1302,11 +1302,15 @@ static void test_reuseport_mixed_groups(int family, int sotype, int sock_map,
 	xclose(s1);
 }
 
-#define TEST(fn)                                                               \
+#define TEST_SOTYPE(fn, sotype)                                                \
 	{                                                                      \
-		fn, #fn                                                        \
+		fn, #fn, sotype                                                \
 	}
 
+#define TEST(fn) TEST_SOTYPE(fn, 0)
+#define TEST_STREAM(fn) TEST_SOTYPE(fn, SOCK_STREAM)
+#define TEST_DGRAM(fn) TEST_SOTYPE(fn, SOCK_DGRAM)
+
 static void test_ops_cleanup(const struct bpf_map *map)
 {
 	const struct bpf_map_def *def;
@@ -1353,18 +1357,31 @@ static const char *map_type_str(const struct bpf_map *map)
 	}
 }
 
+static const char *sotype_str(int sotype)
+{
+	switch (sotype) {
+	case SOCK_DGRAM:
+		return "UDP";
+	case SOCK_STREAM:
+		return "TCP";
+	default:
+		return "unknown";
+	}
+}
+
 static void test_ops(struct test_sockmap_listen *skel, struct bpf_map *map,
 		     int family, int sotype)
 {
 	const struct op_test {
 		void (*fn)(int family, int sotype, int mapfd);
 		const char *name;
+		int sotype;
 	} tests[] = {
 		/* insert */
 		TEST(test_insert_invalid),
 		TEST(test_insert_opened),
-		TEST(test_insert_bound),
-		TEST(test_insert_listening),
+		TEST_STREAM(test_insert_bound),
+		TEST(test_insert),
 		/* delete */
 		TEST(test_delete_after_insert),
 		TEST(test_delete_after_close),
@@ -1373,28 +1390,33 @@ static void test_ops(struct test_sockmap_listen *skel, struct bpf_map *map,
 		TEST(test_lookup_after_delete),
 		TEST(test_lookup_32_bit_value),
 		/* update */
-		TEST(test_update_listening),
+		TEST(test_update_existing),
 		/* races with insert/delete */
-		TEST(test_destroy_orphan_child),
-		TEST(test_syn_recv_insert_delete),
-		TEST(test_race_insert_listen),
+		TEST_STREAM(test_destroy_orphan_child),
+		TEST_STREAM(test_syn_recv_insert_delete),
+		TEST_STREAM(test_race_insert_listen),
 		/* child clone */
-		TEST(test_clone_after_delete),
-		TEST(test_accept_after_delete),
-		TEST(test_accept_before_delete),
+		TEST_STREAM(test_clone_after_delete),
+		TEST_STREAM(test_accept_after_delete),
+		TEST_STREAM(test_accept_before_delete),
 	};
-	const char *family_name, *map_name;
+	const char *family_name, *map_name, *sotype_name;
 	const struct op_test *t;
 	char s[MAX_TEST_NAME];
 	int map_fd;
 
 	family_name = family_str(family);
 	map_name = map_type_str(map);
+	sotype_name = sotype_str(sotype);
 	map_fd = bpf_map__fd(map);
 
+
 	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
-		snprintf(s, sizeof(s), "%s %s %s", map_name, family_name,
-			 t->name);
+		snprintf(s, sizeof(s), "%s %s %s %s", map_name, family_name,
+			 sotype_name, t->name);
+
+		if (t->sotype != 0 && t->sotype != sotype)
+			continue;
 
 		if (!test__start_subtest(s))
 			continue;
@@ -1411,22 +1433,28 @@ static void test_redir(struct test_sockmap_listen *skel, struct bpf_map *map,
 		void (*fn)(struct test_sockmap_listen *skel,
 			   struct bpf_map *map, int family, int sotype);
 		const char *name;
+		int sotype;
 	} tests[] = {
-		TEST(test_skb_redir_to_connected),
-		TEST(test_skb_redir_to_listening),
-		TEST(test_msg_redir_to_connected),
-		TEST(test_msg_redir_to_listening),
+		TEST_STREAM(test_skb_redir_to_connected),
+		TEST_STREAM(test_skb_redir_to_listening),
+		TEST_STREAM(test_msg_redir_to_connected),
+		TEST_STREAM(test_msg_redir_to_listening),
 	};
-	const char *family_name, *map_name;
+	const char *family_name, *map_name, *sotype_name;
 	const struct redir_test *t;
 	char s[MAX_TEST_NAME];
 
 	family_name = family_str(family);
 	map_name = map_type_str(map);
+	sotype_name = sotype_str(sotype);
 
 	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
-		snprintf(s, sizeof(s), "%s %s %s", map_name, family_name,
-			 t->name);
+		snprintf(s, sizeof(s), "%s %s %s %s", map_name, family_name,
+			 sotype_name, t->name);
+
+		if (t->sotype != 0 && t->sotype != sotype)
+			continue;
+
 		if (!test__start_subtest(s))
 			continue;
 
@@ -1441,26 +1469,31 @@ static void test_reuseport(struct test_sockmap_listen *skel,
 		void (*fn)(int family, int sotype, int socket_map,
 			   int verdict_map, int reuseport_prog);
 		const char *name;
+		int sotype;
 	} tests[] = {
-		TEST(test_reuseport_select_listening),
-		TEST(test_reuseport_select_connected),
-		TEST(test_reuseport_mixed_groups),
+		TEST_STREAM(test_reuseport_select_listening),
+		TEST_STREAM(test_reuseport_select_connected),
+		TEST_STREAM(test_reuseport_mixed_groups),
 	};
 	int socket_map, verdict_map, reuseport_prog;
-	const char *family_name, *map_name;
+	const char *family_name, *map_name, *sotype_name;
 	const struct reuseport_test *t;
 	char s[MAX_TEST_NAME];
 
 	family_name = family_str(family);
 	map_name = map_type_str(map);
+	sotype_name = sotype_str(sotype);
 
 	socket_map = bpf_map__fd(map);
 	verdict_map = bpf_map__fd(skel->maps.verdict_map);
 	reuseport_prog = bpf_program__fd(skel->progs.prog_reuseport);
 
 	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
-		snprintf(s, sizeof(s), "%s %s %s", map_name, family_name,
-			 t->name);
+		snprintf(s, sizeof(s), "%s %s %s %s", map_name, family_name,
+			 sotype_name, t->name);
+
+		if (t->sotype != 0 && t->sotype != sotype)
+			continue;
 
 		if (!test__start_subtest(s))
 			continue;
@@ -1473,6 +1506,7 @@ static void run_tests(struct test_sockmap_listen *skel, struct bpf_map *map,
 		      int family)
 {
 	test_ops(skel, map, family, SOCK_STREAM);
+	test_ops(skel, map, family, SOCK_DGRAM);
 	test_redir(skel, map, family, SOCK_STREAM);
 	test_reuseport(skel, map, family, SOCK_STREAM);
 }
-- 
2.20.1

