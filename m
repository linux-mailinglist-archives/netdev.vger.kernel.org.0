Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E58555244
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 19:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358726AbiFVRYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 13:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358163AbiFVRYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 13:24:12 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D55724586
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:24:10 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id o9so15633887edt.12
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ghz1tytflNXf7+fFhHfC0G5gNO+DvIKw0AqEXlmDMHk=;
        b=MVu9ovdJQlV2TYDetZNFlUym1LDZqOGG+WKnIm68Rg+o/W+VPMYI+7Q7U9pby6r1sp
         cYp2mqVNkvnxD+foxppSmGH7ljQ3p4Q7ESqOfgUyvOkhBEp42oPL9D5I2vQ2wJFNHiS7
         A+9JRaHk4OpuZpw8IxysHkku++W/4ivn8wkFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ghz1tytflNXf7+fFhHfC0G5gNO+DvIKw0AqEXlmDMHk=;
        b=dRFTO9OgKBaJuktOmRpM+R7ckGPTt99Ceef+nUsojYuwhNQ3HL0QgG/p98eJLQeiXv
         hyOO+cauT1FM2ZrjJEeiJtmr4tQ+H+JmYTQltdgLh5zoIYXn+iUC0LI0B+5ep4tQm/in
         H7LQFFHAR6Zr99ZAC6MZ4+L3u9MXZPDUd1AAjjrWAww2ksqhNIDTcfWhSmY4+KyYsbFf
         7S5GRQ5hebyINk6Y3pCMaWNpphHoGTKeftMXjggX/FSkH8Dqy+WCjhQxmxxrL8sTe9ex
         u/NgLJNO9mshIl8XUDjFimlXvxqMIoOJKX0K2/Pefjjqapm2C/FVgZa9B8Gydv/dJSa+
         bZwg==
X-Gm-Message-State: AJIora9YH4v0h6uiy1mREc3Q2xfCRxF6zm9vD4Ekm4gnagTQQz/zf/qY
        bzS5w6OpJPhBx7VBWqgOeo1VmnRxaok0uA==
X-Google-Smtp-Source: AGRyM1uuV7M/DRpyf5np06kBAnUx/K+4Mecc3vMOdplVXmEi0dBxPPRm/Brww5llr8XRD96EBv7YNA==
X-Received: by 2002:a05:6402:f29:b0:435:c108:58f2 with SMTP id i41-20020a0564020f2900b00435c10858f2mr928072eda.401.1655918648480;
        Wed, 22 Jun 2022 10:24:08 -0700 (PDT)
Received: from cloudflare.com (79.184.138.130.ipv4.supernova.orange.pl. [79.184.138.130])
        by smtp.gmail.com with ESMTPSA id e21-20020a056402105500b004356d08bbbasm11087668edu.40.2022.06.22.10.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 10:24:08 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     john.fastabend@gmail.com, jakub@cloudflare.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        borisp@nvidia.com, cong.wang@bytedance.com, bpf@vger.kernel.org
Subject: [PATCH net] selftests/bpf: Test sockmap update when socket has ULP
Date:   Wed, 22 Jun 2022 19:24:07 +0200
Message-Id: <20220622172407.411411-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220620191353.1184629-2-kuba@kernel.org>
References: <20220620191353.1184629-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cover the scenario when we cannot insert a socket into the sockmap, because
it has it is using ULP. Failed insert should not have any effect on the ULP
state. This is a regression test.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
CC: john.fastabend@gmail.com
CC: jakub@cloudflare.com
CC: yoshfuji@linux-ipv6.org
CC: dsahern@kernel.org
CC: ast@kernel.org
CC: daniel@iogearbox.net
CC: andrii@kernel.org
CC: kafai@fb.com
CC: songliubraving@fb.com
CC: yhs@fb.com
CC: kpsingh@kernel.org
CC: borisp@nvidia.com
CC: cong.wang@bytedance.com
CC: bpf@vger.kernel.org
---
 .../selftests/bpf/prog_tests/sockmap_ktls.c   | 84 +++++++++++++++++--
 1 file changed, 75 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c b/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
index af293ea1542c..86b0741d2464 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
@@ -4,6 +4,7 @@
  * Tests for sockmap/sockhash holding kTLS sockets.
  */
 
+#include <netinet/tcp.h>
 #include "test_progs.h"
 
 #define MAX_TEST_NAME 80
@@ -92,9 +93,78 @@ static void test_sockmap_ktls_disconnect_after_delete(int family, int map)
 	close(srv);
 }
 
+static void test_sockmap_ktls_update_fails_when_sock_has_ulp(int family, int map)
+{
+	struct sockaddr_storage addr = {};
+	socklen_t len = sizeof(addr);
+	struct sockaddr_in6 *v6;
+	struct sockaddr_in *v4;
+	int err, s, zero = 0;
+
+	s = socket(family, SOCK_STREAM, 0);
+	if (!ASSERT_GE(s, 0, "socket"))
+		return;
+
+	switch (family) {
+	case AF_INET:
+		v4 = (struct sockaddr_in *)&addr;
+		v4->sin_family = AF_INET;
+		break;
+	case AF_INET6:
+		v6 = (struct sockaddr_in6 *)&addr;
+		v6->sin6_family = AF_INET6;
+		break;
+	default:
+		PRINT_FAIL("unsupported socket family %d", family);
+		return;
+	}
+
+	err = bind(s, (struct sockaddr *)&addr, len);
+	if (!ASSERT_OK(err, "bind"))
+		goto close;
+
+	err = getsockname(s, (struct sockaddr *)&addr, &len);
+	if (!ASSERT_OK(err, "getsockname"))
+		goto close;
+
+	err = connect(s, (struct sockaddr *)&addr, len);
+	if (!ASSERT_OK(err, "connect"))
+		goto close;
+
+	/* save sk->sk_prot and set it to tls_prots */
+	err = setsockopt(s, IPPROTO_TCP, TCP_ULP, "tls", strlen("tls"));
+	if (!ASSERT_OK(err, "setsockopt(TCP_ULP)"))
+		goto close;
+
+	/* sockmap update should not affect saved sk_prot */
+	err = bpf_map_update_elem(map, &zero, &s, BPF_ANY);
+	if (!ASSERT_ERR(err, "sockmap update elem"))
+		goto close;
+
+	/* call sk->sk_prot->setsockopt to dispatch to saved sk_prot */
+	err = setsockopt(s, IPPROTO_TCP, TCP_NODELAY, &zero, sizeof(zero));
+	ASSERT_OK(err, "setsockopt(TCP_NODELAY)");
+
+close:
+	close(s);
+}
+
+static const char *fmt_test_name(const char *subtest_name, int family,
+				 enum bpf_map_type map_type)
+{
+	const char *map_type_str = BPF_MAP_TYPE_SOCKMAP ? "SOCKMAP" : "SOCKHASH";
+	const char *family_str = AF_INET ? "IPv4" : "IPv6";
+	static char test_name[MAX_TEST_NAME];
+
+	snprintf(test_name, MAX_TEST_NAME,
+		 "sockmap_ktls %s %s %s",
+		 subtest_name, family_str, map_type_str);
+
+	return test_name;
+}
+
 static void run_tests(int family, enum bpf_map_type map_type)
 {
-	char test_name[MAX_TEST_NAME];
 	int map;
 
 	map = bpf_map_create(map_type, NULL, sizeof(int), sizeof(int), 1, NULL);
@@ -103,14 +173,10 @@ static void run_tests(int family, enum bpf_map_type map_type)
 		return;
 	}
 
-	snprintf(test_name, MAX_TEST_NAME,
-		 "sockmap_ktls disconnect_after_delete %s %s",
-		 family == AF_INET ? "IPv4" : "IPv6",
-		 map_type == BPF_MAP_TYPE_SOCKMAP ? "SOCKMAP" : "SOCKHASH");
-	if (!test__start_subtest(test_name))
-		return;
-
-	test_sockmap_ktls_disconnect_after_delete(family, map);
+	if (test__start_subtest(fmt_test_name("disconnect_after_delete", family, map_type)))
+		test_sockmap_ktls_disconnect_after_delete(family, map);
+	if (test__start_subtest(fmt_test_name("update_fails_when_sock_has_ulp", family, map_type)))
+		test_sockmap_ktls_update_fails_when_sock_has_ulp(family, map);
 
 	close(map);
 }
-- 
2.35.3

