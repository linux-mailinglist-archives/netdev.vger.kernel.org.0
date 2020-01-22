Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33441454C7
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgAVNGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:06:11 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33338 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729255AbgAVNGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:06:10 -0500
Received: by mail-lj1-f194.google.com with SMTP id y6so6743308lji.0
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 05:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4CXJwdpYP+mrY90uu9dxiHkdaf1zG454XQX7axBVn84=;
        b=dHgHPgjhkf+fsHTosUYpWm7S7/i8URGOYyXndzmZwsqzO7dP8Z8ydQV0nkJ69APOJk
         1Or2WL71Eb4BpAGY7vuDTCBAldr9vSaVL7aJaxS3HxvAnAYTlUCHm6v8Aq9U1kRq2DZy
         uXzQAUJOlQ33Ef0GSs8xG30WLkn7OLSROp9DM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4CXJwdpYP+mrY90uu9dxiHkdaf1zG454XQX7axBVn84=;
        b=o7hZq9oUv6FvMmiYCnE9ShYxTI3454DYTy5iKM5N6EClcwOGmDcwEXsnwWnc2Rnu3c
         /AtCZVigwmDkkN0kvYWocqbar0/Ic5QISmAe38zWRiWDknPcYOy0poE5Og5GyCbdrxQs
         JIX+DqAoqanUAoohn3+7dJOMHDSX7ALOenBLxftAXc8oftK6xmbFodU0DHXvNtprckEh
         lMaPRSwDBUN/G8K9V+iOxLp7aNoYPLnF5b/yoWKlQUtlzTgju0Wwv9jA+AMFuP4/YPt4
         98xuPGBKK1k0mtLQnKDujYWmzJQTugdWn+3LOOTNc3GlZMLzmxtUO38S6D1BYKc3QFPL
         8hqw==
X-Gm-Message-State: APjAAAVZIbP7cc4c8hu3+N/zrdrjgHDltcueUsMeiaIYWHXsG70bDefN
        jylXD1+JcC51+z0vZ6dVXyiXYA==
X-Google-Smtp-Source: APXvYqyyRm00NmG1GClGzLn7/tzjZtqqkh+67xvmDZIfAWQFN6vJJdw6jvJ1ngXUM7QgnM6PA5ohgg==
X-Received: by 2002:a2e:9ad0:: with SMTP id p16mr20124781ljj.111.1579698367707;
        Wed, 22 Jan 2020 05:06:07 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id g27sm20739184lfh.57.2020.01.22.05.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:06:07 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v3 11/12] selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
Date:   Wed, 22 Jan 2020 14:05:48 +0100
Message-Id: <20200122130549.832236-12-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122130549.832236-1-jakub@cloudflare.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
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
index 2c37ae7dc214..e7b4abfca2ab 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -36,6 +36,7 @@ static int result_map, tmp_index_ovr_map, linum_map, data_check_map;
 static enum result expected_results[NR_RESULTS];
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
@@ -694,12 +697,34 @@ static void cleanup_per_test(bool no_inner_map)
 
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
@@ -747,13 +772,21 @@ static void test_config(int sotype, sa_family_t family, bool inany)
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
@@ -782,13 +815,20 @@ static void test_all(void)
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
@@ -799,8 +839,8 @@ void test_select_reuseport(void)
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

