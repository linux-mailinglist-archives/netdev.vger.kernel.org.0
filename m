Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EC5136B5E
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbgAJKuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:50:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51540 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727705AbgAJKuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:50:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so1491275wmd.1
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 02:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wfiggKTqcDmHnSpTDikEzwu2ni3grpGc1TMYv9P6tLk=;
        b=FtsVOh1mVHVQDGpFBdkRYYn11bKqOZpAFI6M0gnV/OEJUSSj+iVA7S5B3mG7DdVw0m
         IT/N6yn3TXFY7h+7yWa2xwAVcyteOtB1zPOsebx+jYiBoZCMd9GsccI4eXpMDNkB+bSb
         VKJRrSui5Aj4emOzUe9AClm/GaXryNmYuR08A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wfiggKTqcDmHnSpTDikEzwu2ni3grpGc1TMYv9P6tLk=;
        b=YJ0T9BEmJoDQijBA3b3+C8Pr0aeeuUgemS8dKxTj6V2PE0T2pJqCGRX1sP0oWL8/vt
         4JjujsTOxopmofGG5eLOpeJBbnuOzpZ/Q6ef78f8aEEDJpoSgptPJltVHu+McIxNiewr
         H6D9nndM8NTwncoMT6XZ2m+BRB69dB47xtE/vTKxJA4jRvB5k9WWvycKtkXZh/VDbqNH
         IWxmF9zmNfkDMtX8hgY9GrIhysRKvDXth0AA3MM5vgyCHmK812KDCKhtl0YxK9/m0gi5
         vRWTZJ4QmLfMAp/3TJe2toSqYqLMYj5xRsa+FC1Ihey/aFxKnt/P5EL5aNTRwao2IrED
         kKiw==
X-Gm-Message-State: APjAAAX3sd5ePYa9sb1mRMmOdy5yDm6PfIs8Id+SKAcPiGP1MqD7S19N
        UmhXnwW1FXcKb//5Ro6OGVk2rg==
X-Google-Smtp-Source: APXvYqwh6FRQ71dYCHCL9VNXvtms4PrE6x3tDPF7ebW//tdXAm4H7Xj170Vn0A8PeCVnpDE0febujg==
X-Received: by 2002:a05:600c:2406:: with SMTP id 6mr3678108wmp.30.1578653442945;
        Fri, 10 Jan 2020 02:50:42 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id r15sm1744019wmh.21.2020.01.10.02.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 02:50:42 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 10/11] selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
Date:   Fri, 10 Jan 2020 11:50:26 +0100
Message-Id: <20200110105027.257877-11-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110105027.257877-1-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
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

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Now a test run looks like so:

bash-5.0# ./test_progs -t reuseport
#39/1 reuseport_sockarray IPv4/TCP LOOPBACK test_err_inner_map:OK
#39/2 reuseport_sockarray IPv4/TCP LOOPBACK test_err_skb_data:OK
#39/3 reuseport_sockarray IPv4/TCP LOOPBACK test_err_sk_select_port:OK
#39/4 reuseport_sockarray IPv4/TCP LOOPBACK test_pass:OK
#39/5 reuseport_sockarray IPv4/TCP LOOPBACK test_syncookie:OK
#39/6 reuseport_sockarray IPv4/TCP LOOPBACK test_pass_on_err:OK
#39/7 reuseport_sockarray IPv4/TCP LOOPBACK test_detach_bpf:OK
#39/8 reuseport_sockarray IPv4/TCP INANY test_err_inner_map:OK
#39/9 reuseport_sockarray IPv4/TCP INANY test_err_skb_data:OK
#39/10 reuseport_sockarray IPv4/TCP INANY test_err_sk_select_port:OK
#39/11 reuseport_sockarray IPv4/TCP INANY test_pass:OK
#39/12 reuseport_sockarray IPv4/TCP INANY test_syncookie:OK
#39/13 reuseport_sockarray IPv4/TCP INANY test_pass_on_err:OK
#39/14 reuseport_sockarray IPv4/TCP INANY test_detach_bpf:OK
#39/15 reuseport_sockarray IPv6/TCP LOOPBACK test_err_inner_map:OK
#39/16 reuseport_sockarray IPv6/TCP LOOPBACK test_err_skb_data:OK
#39/17 reuseport_sockarray IPv6/TCP LOOPBACK test_err_sk_select_port:OK
#39/18 reuseport_sockarray IPv6/TCP LOOPBACK test_pass:OK
#39/19 reuseport_sockarray IPv6/TCP LOOPBACK test_syncookie:OK
#39/20 reuseport_sockarray IPv6/TCP LOOPBACK test_pass_on_err:OK
#39/21 reuseport_sockarray IPv6/TCP LOOPBACK test_detach_bpf:OK
#39/22 reuseport_sockarray IPv6/TCP INANY test_err_inner_map:OK
#39/23 reuseport_sockarray IPv6/TCP INANY test_err_skb_data:OK
#39/24 reuseport_sockarray IPv6/TCP INANY test_err_sk_select_port:OK
#39/25 reuseport_sockarray IPv6/TCP INANY test_pass:OK
#39/26 reuseport_sockarray IPv6/TCP INANY test_syncookie:OK
#39/27 reuseport_sockarray IPv6/TCP INANY test_pass_on_err:OK
#39/28 reuseport_sockarray IPv6/TCP INANY test_detach_bpf:OK
#39/29 reuseport_sockarray IPv4/UDP LOOPBACK test_err_inner_map:OK
#39/30 reuseport_sockarray IPv4/UDP LOOPBACK test_err_skb_data:OK
#39/31 reuseport_sockarray IPv4/UDP LOOPBACK test_err_sk_select_port:OK
#39/32 reuseport_sockarray IPv4/UDP LOOPBACK test_pass:OK
#39/33 reuseport_sockarray IPv4/UDP LOOPBACK test_syncookie:OK
#39/34 reuseport_sockarray IPv4/UDP LOOPBACK test_pass_on_err:OK
#39/35 reuseport_sockarray IPv4/UDP LOOPBACK test_detach_bpf:OK
#39/36 reuseport_sockarray IPv6/UDP LOOPBACK test_err_inner_map:OK
#39/37 reuseport_sockarray IPv6/UDP LOOPBACK test_err_skb_data:OK
#39/38 reuseport_sockarray IPv6/UDP LOOPBACK test_err_sk_select_port:OK
#39/39 reuseport_sockarray IPv6/UDP LOOPBACK test_pass:OK
#39/40 reuseport_sockarray IPv6/UDP LOOPBACK test_syncookie:OK
#39/41 reuseport_sockarray IPv6/UDP LOOPBACK test_pass_on_err:OK
#39/42 reuseport_sockarray IPv6/UDP LOOPBACK test_detach_bpf:OK
#39/43 sockmap IPv4/TCP LOOPBACK test_err_inner_map:OK
#39/44 sockmap IPv4/TCP LOOPBACK test_err_skb_data:OK
#39/45 sockmap IPv4/TCP LOOPBACK test_err_sk_select_port:OK
#39/46 sockmap IPv4/TCP LOOPBACK test_pass:OK
#39/47 sockmap IPv4/TCP LOOPBACK test_syncookie:OK
#39/48 sockmap IPv4/TCP LOOPBACK test_pass_on_err:OK
#39/49 sockmap IPv4/TCP LOOPBACK test_detach_bpf:OK
#39/50 sockmap IPv4/TCP INANY test_err_inner_map:OK
#39/51 sockmap IPv4/TCP INANY test_err_skb_data:OK
#39/52 sockmap IPv4/TCP INANY test_err_sk_select_port:OK
#39/53 sockmap IPv4/TCP INANY test_pass:OK
#39/54 sockmap IPv4/TCP INANY test_syncookie:OK
#39/55 sockmap IPv4/TCP INANY test_pass_on_err:OK
#39/56 sockmap IPv4/TCP INANY test_detach_bpf:OK
#39/57 sockmap IPv6/TCP LOOPBACK test_err_inner_map:OK
#39/58 sockmap IPv6/TCP LOOPBACK test_err_skb_data:OK
#39/59 sockmap IPv6/TCP LOOPBACK test_err_sk_select_port:OK
#39/60 sockmap IPv6/TCP LOOPBACK test_pass:OK
#39/61 sockmap IPv6/TCP LOOPBACK test_syncookie:OK
#39/62 sockmap IPv6/TCP LOOPBACK test_pass_on_err:OK
#39/63 sockmap IPv6/TCP LOOPBACK test_detach_bpf:OK
#39/64 sockmap IPv6/TCP INANY test_err_inner_map:OK
#39/65 sockmap IPv6/TCP INANY test_err_skb_data:OK
#39/66 sockmap IPv6/TCP INANY test_err_sk_select_port:OK
#39/67 sockmap IPv6/TCP INANY test_pass:OK
#39/68 sockmap IPv6/TCP INANY test_syncookie:OK
#39/69 sockmap IPv6/TCP INANY test_pass_on_err:OK
#39/70 sockmap IPv6/TCP INANY test_detach_bpf:OK
#39/71 sockmap IPv4/UDP LOOPBACK test_err_inner_map:OK
#39/72 sockmap IPv4/UDP LOOPBACK test_err_skb_data:OK
#39/73 sockmap IPv4/UDP LOOPBACK test_err_sk_select_port:OK
#39/74 sockmap IPv4/UDP LOOPBACK test_pass:OK
#39/75 sockmap IPv4/UDP LOOPBACK test_syncookie:OK
#39/76 sockmap IPv4/UDP LOOPBACK test_pass_on_err:OK
#39/77 sockmap IPv4/UDP LOOPBACK test_detach_bpf:OK
#39/78 sockmap IPv6/UDP LOOPBACK test_err_inner_map:OK
#39/79 sockmap IPv6/UDP LOOPBACK test_err_skb_data:OK
#39/80 sockmap IPv6/UDP LOOPBACK test_err_sk_select_port:OK
#39/81 sockmap IPv6/UDP LOOPBACK test_pass:OK
#39/82 sockmap IPv6/UDP LOOPBACK test_syncookie:OK
#39/83 sockmap IPv6/UDP LOOPBACK test_pass_on_err:OK
#39/84 sockmap IPv6/UDP LOOPBACK test_detach_bpf:OK
#39 select_reuseport:OK
Summary: 1/84 PASSED, 14 SKIPPED, 0 FAILED

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

