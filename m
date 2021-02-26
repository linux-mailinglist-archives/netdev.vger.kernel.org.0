Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5AE32615F
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 11:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhBZKgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 05:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhBZKdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 05:33:16 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A89C061794
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:31:23 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id i9so6704305wml.0
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0cxlavmTIp/zACJRiVyk8HpP0iu1cIzGXAbVh/+DaW8=;
        b=gjHcmBhzPw3Kf/u4JB3uSVYHTH4ZGGHRXeH+2vokAkDSe0XjxST3qT6sO2e2qzQTFr
         sUY6rJiZjXW/qJi6YU/1Y3+qqbUmN30duRJgzN9sjTPFr0/oMrN7F1BCK/W/rRO1I2lv
         CKOKonLOKbT7+hc02XzWUVcesc9D7UzA2wBd8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0cxlavmTIp/zACJRiVyk8HpP0iu1cIzGXAbVh/+DaW8=;
        b=nRSLI7342Tm1I2cJdNXN7Dg8Uqc7fasmy+lwQmI5eTkwBmw41N2+VY2PO1ar/MTisJ
         r1FV3sLLBgk/tGem4aDRi6JWQ8nORjNDvI/6qFL6WwHv5XyKvSmcswsMPYDgd2VhdOmb
         N5aGLBVRlFUYQfpU9jT8qwH+3juX0pONROyzhdgW3xmCBDhqHVVyeFSswdI56kqW5P6D
         aEmmrOCfGzS+U6GCxpYZz3RBNjYzcUfdsFFx8KJm2pVM4DxdJ9VNL6BcQAdif64EZyD4
         A3mxjYP+OE+ZavnKctrcu1BgLXr3C/QYTZ6RaJ8FVsZt9oW/h/27sEvF1O2wbhabaeop
         s6kg==
X-Gm-Message-State: AOAM531632H3bEfasNu/PqsQtm1be6zsbRKqmzmVK7csM5v0cQZl+V3W
        WBri3CZlCA9grIiIpbSixeDN5g==
X-Google-Smtp-Source: ABdhPJwvacvbBHEaPRR/U7/pVjH0iQgvRDPAIjpZxFKu01p8X68uzCtF6yV40RUDj/P/0TCBmxv9sw==
X-Received: by 2002:a05:600c:3551:: with SMTP id i17mr2166416wmq.92.1614335481983;
        Fri, 26 Feb 2021 02:31:21 -0800 (PST)
Received: from localhost.localdomain (d.4.3.e.3.5.0.6.8.1.5.9.3.d.9.6.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:69d3:9518:6053:e34d])
        by smtp.gmail.com with ESMTPSA id a21sm12448744wmb.5.2021.02.26.02.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 02:31:21 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v2 4/4] selftests: bpf: check that PROG_TEST_RUN repeats as requested
Date:   Fri, 26 Feb 2021 10:31:03 +0000
Message-Id: <20210226103103.131210-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210226103103.131210-1-lmb@cloudflare.com>
References: <20210226103103.131210-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend a simple prog_run test to check that PROG_TEST_RUN adheres
to the requested repetitions. Convert it to use BPF skeleton.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/prog_tests/prog_run_xattr.c | 51 +++++++++++++++----
 1 file changed, 42 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c b/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
index 935a294f049a..131d7f7eeb42 100644
--- a/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
+++ b/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
@@ -2,12 +2,31 @@
 #include <test_progs.h>
 #include <network_helpers.h>
 
-void test_prog_run_xattr(void)
+#include "test_pkt_access.skel.h"
+
+static const __u32 duration;
+
+static void check_run_cnt(int prog_fd, __u64 run_cnt)
 {
-	const char *file = "./test_pkt_access.o";
-	struct bpf_object *obj;
-	char buf[10];
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
 	int err;
+
+	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
+	if (CHECK(err, "get_prog_info", "failed to get bpf_prog_info for fd %d\n", prog_fd))
+		return;
+
+	CHECK(run_cnt != info.run_cnt, "run_cnt",
+	      "incorrect number of repetitions, want %llu have %llu\n", run_cnt, info.run_cnt);
+}
+
+void test_prog_run_xattr(void)
+{
+	struct test_pkt_access *skel;
+	int err, stats_fd = -1;
+	char buf[10] = {};
+	__u64 run_cnt = 0;
+
 	struct bpf_prog_test_run_attr tattr = {
 		.repeat = 1,
 		.data_in = &pkt_v4,
@@ -16,12 +35,15 @@ void test_prog_run_xattr(void)
 		.data_size_out = 5,
 	};
 
-	err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj,
-			    &tattr.prog_fd);
-	if (CHECK_ATTR(err, "load", "err %d errno %d\n", err, errno))
+	stats_fd = bpf_enable_stats(BPF_STATS_RUN_TIME);
+	if (CHECK_ATTR(stats_fd < 0, "enable_stats", "failed %d\n", errno))
 		return;
 
-	memset(buf, 0, sizeof(buf));
+	skel = test_pkt_access__open_and_load();
+	if (CHECK_ATTR(!skel, "open_and_load", "failed\n"))
+		goto cleanup;
+
+	tattr.prog_fd = bpf_program__fd(skel->progs.test_pkt_access);
 
 	err = bpf_prog_test_run_xattr(&tattr);
 	CHECK_ATTR(err != -1 || errno != ENOSPC || tattr.retval, "run",
@@ -34,8 +56,12 @@ void test_prog_run_xattr(void)
 	CHECK_ATTR(buf[5] != 0, "overflow",
 	      "BPF_PROG_TEST_RUN ignored size hint\n");
 
+	run_cnt += tattr.repeat;
+	check_run_cnt(tattr.prog_fd, run_cnt);
+
 	tattr.data_out = NULL;
 	tattr.data_size_out = 0;
+	tattr.repeat = 2;
 	errno = 0;
 
 	err = bpf_prog_test_run_xattr(&tattr);
@@ -46,5 +72,12 @@ void test_prog_run_xattr(void)
 	err = bpf_prog_test_run_xattr(&tattr);
 	CHECK_ATTR(err != -EINVAL, "run_wrong_size_out", "err %d\n", err);
 
-	bpf_object__close(obj);
+	run_cnt += tattr.repeat;
+	check_run_cnt(tattr.prog_fd, run_cnt);
+
+cleanup:
+	if (skel)
+		test_pkt_access__destroy(skel);
+	if (stats_fd != -1)
+		close(stats_fd);
 }
-- 
2.27.0

