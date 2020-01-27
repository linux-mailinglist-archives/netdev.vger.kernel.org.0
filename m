Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBCD14A443
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgA0Mz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:55:59 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40443 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgA0Mzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 07:55:55 -0500
Received: by mail-lf1-f68.google.com with SMTP id c23so6120061lfi.7
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 04:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6L1pFikWkXxLBijQL4ejLKRtWder9wISNk8LYQjifpo=;
        b=wCwr6ofGfCvauI2wdRxbfuPOQXw6ci1EUapkkHkX9+JeBURWAeItj6pHKk4kUASrDo
         wSlHdaAg+Nu58p60aRbK8PBoEHBs7TXjEHG6bFWuf3Ip3NrYL98iuWoa/pLbteIim6Gd
         Rqpkp+BkEDeAtqvpXtnIT+/AstqWSXGuO2d3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6L1pFikWkXxLBijQL4ejLKRtWder9wISNk8LYQjifpo=;
        b=kiZInhlEft5VfuuZiaIvqEeINXn2fdIdYByhtI7n5DZHhrF3Se/RfOQNMxFvLCml6c
         QzzJcOQPHGTyRNqb0JhsrD5zrMEah3p5DjuHdw2mOD69t35g0VQa9ns4bCgTsA884g+K
         Laz2vDSsPKx7BNLd6m0PW118cflahtOZlp/8DDN5fmW0xx+TJL7BwV8oVScGEzjRf28S
         xKUS0Qb1ptsc8BwRxAoEtU2Y6PC3vrXg/F4s9fOTF9avhNdDkKBIPrWvewl6PC8WmClA
         hWwfccRnIZWXSyPlVnJ3SPa1WV6P8LRQkbyZF1x2UXVkFpuSaG4Pe+P+o2IhXVsYOsRD
         eebQ==
X-Gm-Message-State: APjAAAUeZddLP17sZ3LIZOEx6Gaos1Mx6cY+G/vDdPLoxEy/zeqX6OFe
        539sTgyk4aCuzdX08Q6uJrDkew==
X-Google-Smtp-Source: APXvYqy3b49MKFTQCx+ScJqbB2vfMZTMVgj9YcNqFBPpoYW6LQmluErJasT6cjZH9H4w+mGuMbuQxw==
X-Received: by 2002:a19:5f05:: with SMTP id t5mr8161987lfb.149.1580129753527;
        Mon, 27 Jan 2020 04:55:53 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id o69sm8129634lff.14.2020.01.27.04.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 04:55:53 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next v5 11/12] selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
Date:   Mon, 27 Jan 2020 13:55:33 +0100
Message-Id: <20200127125534.137492-12-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127125534.137492-1-jakub@cloudflare.com>
References: <20200127125534.137492-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parametrize the SK_REUSEPORT tests so that the map type for storing sockets
is not hard-coded in the test setup routine.

This, together with careful state cleaning after the tests, let's us run
the test cases once with REUSEPORT_ARRAY and once with SOCKMAP (TCP only),
to have test coverage for the latter as well.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../bpf/prog_tests/select_reuseport.c         | 60 +++++++++++++++----
 1 file changed, 50 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
index 098bcae5f827..77115c6dde0c 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -36,6 +36,7 @@ static int result_map, tmp_index_ovr_map, linum_map, data_check_map;
 static __u32 expected_results[NR_RESULTS];
 static int sk_fds[REUSEPORT_ARRAY_SIZE];
 static int reuseport_array = -1, outer_map = -1;
+static enum bpf_map_type inner_map_type;
 static int select_by_skb_data_prog;
 static int saved_tcp_syncookie = -1;
 static struct bpf_object *obj;
@@ -63,13 +64,15 @@ static union sa46 {
 	}								\
 })
 
-static int create_maps(void)
+static int create_maps(enum bpf_map_type inner_type)
 {
 	struct bpf_create_map_attr attr = {};
 
+	inner_map_type = inner_type;
+
 	/* Creating reuseport_array */
 	attr.name = "reuseport_array";
-	attr.map_type = BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
+	attr.map_type = inner_type;
 	attr.key_size = sizeof(__u32);
 	attr.value_size = sizeof(__u32);
 	attr.max_entries = REUSEPORT_ARRAY_SIZE;
@@ -726,12 +729,34 @@ static void cleanup_per_test(bool no_inner_map)
 
 static void cleanup(void)
 {
-	if (outer_map != -1)
+	if (outer_map != -1) {
 		close(outer_map);
-	if (reuseport_array != -1)
+		outer_map = -1;
+	}
+
+	if (reuseport_array != -1) {
 		close(reuseport_array);
-	if (obj)
+		reuseport_array = -1;
+	}
+
+	if (obj) {
 		bpf_object__close(obj);
+		obj = NULL;
+	}
+
+	memset(expected_results, 0, sizeof(expected_results));
+}
+
+static const char *maptype_str(enum bpf_map_type type)
+{
+	switch (type) {
+	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
+		return "reuseport_sockarray";
+	case BPF_MAP_TYPE_SOCKMAP:
+		return "sockmap";
+	default:
+		return "unknown";
+	}
 }
 
 static const char *family_str(sa_family_t family)
@@ -779,13 +804,21 @@ static void test_config(int sotype, sa_family_t family, bool inany)
 	const struct test *t;
 
 	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
-		snprintf(s, sizeof(s), "%s/%s %s %s",
+		snprintf(s, sizeof(s), "%s %s/%s %s %s",
+			 maptype_str(inner_map_type),
 			 family_str(family), sotype_str(sotype),
 			 inany ? "INANY" : "LOOPBACK", t->name);
 
 		if (!test__start_subtest(s))
 			continue;
 
+		if (sotype == SOCK_DGRAM &&
+		    inner_map_type == BPF_MAP_TYPE_SOCKMAP) {
+			/* SOCKMAP doesn't support UDP yet */
+			test__skip();
+			continue;
+		}
+
 		setup_per_test(sotype, family, inany, t->no_inner_map);
 		t->fn(sotype, family);
 		cleanup_per_test(t->no_inner_map);
@@ -814,13 +847,20 @@ static void test_all(void)
 		test_config(c->sotype, c->family, c->inany);
 }
 
-void test_select_reuseport(void)
+void test_map_type(enum bpf_map_type mt)
 {
-	if (create_maps())
+	if (create_maps(mt))
 		goto out;
 	if (prepare_bpf_obj())
 		goto out;
 
+	test_all();
+out:
+	cleanup();
+}
+
+void test_select_reuseport(void)
+{
 	saved_tcp_fo = read_int_sysctl(TCP_FO_SYSCTL);
 	saved_tcp_syncookie = read_int_sysctl(TCP_SYNCOOKIE_SYSCTL);
 	if (saved_tcp_syncookie < 0 || saved_tcp_syncookie < 0)
@@ -831,8 +871,8 @@ void test_select_reuseport(void)
 	if (disable_syncookie())
 		goto out;
 
-	test_all();
+	test_map_type(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY);
+	test_map_type(BPF_MAP_TYPE_SOCKMAP);
 out:
-	cleanup();
 	restore_sysctls();
 }
-- 
2.24.1

