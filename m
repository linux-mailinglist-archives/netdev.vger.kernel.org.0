Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF4E14A4A5
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgA0NLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:11:19 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46449 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgA0NLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:11:18 -0500
Received: by mail-lj1-f193.google.com with SMTP id x14so8226241ljd.13
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6L1pFikWkXxLBijQL4ejLKRtWder9wISNk8LYQjifpo=;
        b=yY5jsZnVdddnyegdu0SatXNUukp1GFnz24qhyWlN8GJq2gAmovbled7t7v35BcUvR8
         2EgKlnppYmZU3G5RARtgdNAjfUVBYOMBoibzAsT6hW8HejOii40ub9ahmM7xkNn32xml
         V+FJ1+sezAnh3rbAB+KAOX6UG0j2VU30Voab4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6L1pFikWkXxLBijQL4ejLKRtWder9wISNk8LYQjifpo=;
        b=KKYApVRPd+zMLZGNDRRPlg+U1F8bqaYBrSoQNd9efWkg9f311U8fXF7wmxARDoZt9G
         657RYdmtMB7M2zo7w+G0oB8BvKQb9aH/QWDIaRBTX7N3U7GVyleckex0rXD5M4Ocgn3C
         svQOa8jyNmEF7nSWJ/BYFJbIYX/O9DWX+9lGTAgDGIYtgy+8ckL9IvK61ubIYjxvZ+my
         v/bQQS+v1Y0D526M7sHA8HcpWY9rqWxkrXQz2V1yufJryaojIwAWJ4HRw7KL82wRDUf5
         7HC/RTuWm7xwoQDfq7Ru0LW1kHlKx+gV+JCXXbl9d48KC8rjACO6I8MpzWf8GYeFoxWa
         j+tw==
X-Gm-Message-State: APjAAAWOZSbtncVUMxPj/WuyNkgd/tcOxueN2pQZebJQuEuBRsx5Ghgo
        XwUUX//LCQo+zEA1cwoxrf5cmw==
X-Google-Smtp-Source: APXvYqz0wIcEuc8tIDnwPnrxS/WgsNOcr1rWjks94n6WDHMGueviRDN9efgPEw3XHJzOrUba/kPL9g==
X-Received: by 2002:a2e:3a12:: with SMTP id h18mr9717124lja.81.1580130675827;
        Mon, 27 Jan 2020 05:11:15 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id c27sm8054771lfh.62.2020.01.27.05.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:11:15 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next v6 11/12] selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
Date:   Mon, 27 Jan 2020 14:10:56 +0100
Message-Id: <20200127131057.150941-12-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127131057.150941-1-jakub@cloudflare.com>
References: <20200127131057.150941-1-jakub@cloudflare.com>
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

