Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA20F557661
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 11:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiFWJMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 05:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiFWJMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 05:12:39 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70213818E
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:12:34 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id e2so16648439edv.3
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ujrcrrJpRoiCR3SWAIyisghnKZqbV/shEj+X3T7pGEw=;
        b=TWvsdHJUu8brvayWVvVgxH0UjNE4QBjRJ3+kvGNmxXn4FHLDyq5a/Q+cvKAelOI6Te
         iCdGuF8zNz5qnOpMrT00HrKmtfi+YdznVk0AiCO6AvEmZN9rmXfBQXRWgiNj3P8S370u
         mmIaoscMIYJpUhYwrnWrAASKYOzDcFOGnOpi4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ujrcrrJpRoiCR3SWAIyisghnKZqbV/shEj+X3T7pGEw=;
        b=GSEhDO7kaNoqUB7cncTRVZZgZ7MngDd++YYKHmqRXyNyJw2gnFpbE2erPQfaF9k7vg
         rgqQ6meuULGenBz6VCGi3DHvQKcgZpGHJL3WyBgBgs0m+bg8nXzKwVGWebK1nRM+HYDw
         tXgU+MAb0YvUx2YreD5WTzeQIqFP1/e58KKsCPh3eNWeNy8oaUEpLo8rAaKixvlNmt8p
         YMbBT2RvSolN7qkZrC4/fqeRUFh+HdXj9LcX4APfA5Aqph3o8E5l96Osrjb/BIyGqvvf
         taGJVxOZINgmmY3dWHlK9z+HLo0H/Y0BH2HQLRjMArwQfhIbndF6zzchdiOjUFUf24C0
         EGNg==
X-Gm-Message-State: AJIora8ygwWDbdPDRAk3r5wtHPMLJmD7n8qHoTDugGJt/TL61Kl0DmnD
        21wtKlXGE+F2papspaxLXVmEX4Qt04Tzfw==
X-Google-Smtp-Source: AGRyM1ueGUfKzvcwQ8rQyvV6+FIc48d1UCvuTeE7RCY9mkFveo0C56fK6UFjPK6A+WTqcPxQC/W8pA==
X-Received: by 2002:a05:6402:3487:b0:435:b0d2:606e with SMTP id v7-20020a056402348700b00435b0d2606emr8266702edc.66.1655975552630;
        Thu, 23 Jun 2022 02:12:32 -0700 (PDT)
Received: from cloudflare.com (79.184.138.130.ipv4.supernova.orange.pl. [79.184.138.130])
        by smtp.gmail.com with ESMTPSA id l16-20020aa7cad0000000b0043585bb803fsm8275020edt.25.2022.06.23.02.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:12:32 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     john.fastabend@gmail.com, jakub@cloudflare.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        borisp@nvidia.com, cong.wang@bytedance.com, bpf@vger.kernel.org
Subject: [PATCH net v2] selftests/bpf: Test sockmap update when socket has ULP
Date:   Thu, 23 Jun 2022 11:12:31 +0200
Message-Id: <20220623091231.417138-1-jakub@cloudflare.com>
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
v2:
- Don't leak open socket if family is not supported (John)

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
index af293ea1542c..e172d89e92e1 100644
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
+	s = socket(family, SOCK_STREAM, 0);
+	if (!ASSERT_GE(s, 0, "socket"))
+		return;
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

