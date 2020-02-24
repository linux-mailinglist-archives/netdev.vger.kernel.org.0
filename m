Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BF116A7B2
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgBXNxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:53:33 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35720 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbgBXNxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:53:32 -0500
Received: by mail-wm1-f66.google.com with SMTP id b17so9486999wmb.0
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vYUW0ZNGBWeZuF6KwJp8SDvklkk0aQruX2tUPqjtIgg=;
        b=OcxKrQaBataJHK+/J60O2wd7rJ6maecHKLZWLhQZr7J0ApjF/F40IoiVJGTDqyS7gy
         kO89U4c+Zk5Wwuot3Ksb6A2x3qYVZ41IqibxZT1jI9ZZUH3huXX+meb2piqST+jRAYhL
         adYmD+H7eQRbMwkLP8xTH7e4fHeE8qQjJy2Sc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vYUW0ZNGBWeZuF6KwJp8SDvklkk0aQruX2tUPqjtIgg=;
        b=icweBIYKycSpw2MyrPYfwLXMAMuzowGdXSn59RQomubLlX2gCWxc251PEtXNS6F5jY
         +46zJnGlRiB0HjYA24+HTCfY6b4/7/muaIomZ1oIhWTdABJtJvnIBsp/2ovIJAOY48z6
         CVrBXaKD0eRryfos93khGRQkyDN1iWDYQ3drFMmYTel5kH5vGBioGuWvyCdMBnbpocKf
         RmHx7Aw3s8yFwhT7hJzNpklXVaj6b26gVnkXg0JUAifFk1mTGo8Z2Tl6J2V1psxSW/KF
         ymvk4Rld7DBxQ7pHIOtQ1aPbWLgafLbN3HGhMK3kGk3jFAsHaq5SxhSwMi+9BehbZrhS
         CdLQ==
X-Gm-Message-State: APjAAAX5YkZ3KdcKdEkYwXjakoiV+j65vQ5Y4xd90WLRcjR6WoYUUA0x
        Zj5AdFB1fpglDS8PJnGy5wBhlQ==
X-Google-Smtp-Source: APXvYqxH9LV1/+OStIpKupvzaveU+aM/4F3TrLISfj93gEotpmjZfbAMoEv5fJaahZ+H5JdTLQmzzw==
X-Received: by 2002:a1c:b486:: with SMTP id d128mr22654203wmf.69.1582552410339;
        Mon, 24 Feb 2020 05:53:30 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id t81sm18056530wmg.6.2020.02.24.05.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:53:30 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH bpf-next 2/2] selftests/bpf: Run SYN cookies with reuseport BPF test only for TCP
Date:   Mon, 24 Feb 2020 14:53:27 +0100
Message-Id: <20200224135327.121542-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224135327.121542-1-jakub@cloudflare.com>
References: <20200224135327.121542-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we run SYN cookies test for all socket types and mark the test as
skipped if socket type is not compatible. This causes confusion because
skipped test might indicate a problem with the testing environment.

Instead, run the test only for the socket type which supports SYN cookies.

Also, switch to using designated initializers when setting up tests, so
that we can tweak only some test parameters, leaving the rest initialized
to default values.

Fixes: eecd618b4516 ("selftests/bpf: Mark SYN cookie test skipped for UDP sockets")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/select_reuseport.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
index 8c41d6d63fcf..a1dd13b34d4b 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -509,11 +509,6 @@ static void test_syncookie(int type, sa_family_t family)
 		.pass_on_failure = 0,
 	};
 
-	if (type != SOCK_STREAM) {
-		test__skip();
-		return;
-	}
-
 	/*
 	 * +1 for TCP-SYN and
 	 * +1 for the TCP-ACK (ack the syncookie)
@@ -787,7 +782,7 @@ static const char *sotype_str(int sotype)
 	}
 }
 
-#define TEST_INIT(fn, ...) { fn, #fn, __VA_ARGS__ }
+#define TEST_INIT(fn_, ...) { .fn = fn_, .name = #fn_, __VA_ARGS__ }
 
 static void test_config(int sotype, sa_family_t family, bool inany)
 {
@@ -795,12 +790,15 @@ static void test_config(int sotype, sa_family_t family, bool inany)
 		void (*fn)(int sotype, sa_family_t family);
 		const char *name;
 		bool no_inner_map;
+		int need_sotype;
 	} tests[] = {
-		TEST_INIT(test_err_inner_map, true /* no_inner_map */),
+		TEST_INIT(test_err_inner_map,
+			  .no_inner_map = true),
 		TEST_INIT(test_err_skb_data),
 		TEST_INIT(test_err_sk_select_port),
 		TEST_INIT(test_pass),
-		TEST_INIT(test_syncookie),
+		TEST_INIT(test_syncookie,
+			  .need_sotype = SOCK_STREAM),
 		TEST_INIT(test_pass_on_err),
 		TEST_INIT(test_detach_bpf),
 	};
@@ -814,6 +812,9 @@ static void test_config(int sotype, sa_family_t family, bool inany)
 		return;
 
 	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		if (t->need_sotype && t->need_sotype != sotype)
+			continue; /* test not compatible with socket type */
+
 		snprintf(s, sizeof(s), "%s %s/%s %s %s",
 			 maptype_str(inner_map_type),
 			 family_str(family), sotype_str(sotype),
-- 
2.24.1

