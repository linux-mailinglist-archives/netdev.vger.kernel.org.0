Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC4032C400
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377537AbhCDAKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842981AbhCCKXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:23:19 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BD5C08ED8F
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 02:18:30 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id f12so19222708wrx.8
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 02:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0cxlavmTIp/zACJRiVyk8HpP0iu1cIzGXAbVh/+DaW8=;
        b=Y6q+3i8FPsUkg0os6mqNMoj7Vm1rq+ICo1H5qc0uqCfjaeOV/mBLwtdJV5cIQsKPKk
         k1Rjwlv3f4Pdv7B5Yho/tt50Zyi13xD74iRQ21bSFD/SNt8UA7ljzzrrEKQKF85aLy1G
         UrOIDo2U1qecp+9+KZF83YV8cePRdHG44xa1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0cxlavmTIp/zACJRiVyk8HpP0iu1cIzGXAbVh/+DaW8=;
        b=PIBdrIbw9RIz66twQVHwOLrWgd4CmlqpErBnloJ0tL/zDfz+obYayz98e3Up5lyhT4
         3cVIi5XiPiuRQfRoQJxh+L5MMSeXTZeNE5wXd9ny1JQms+2TVHO4ufVTxGJ0RoFeFuaC
         764gVHcIa+AQOh3zunfCXlW0NLaiC+8NtJi7Ym2OSB1Gm+WOnoS/HLjtcMtu4VL49DHJ
         QGL5f27XUXXTY1SbST7uN53m6X+6uqpW7fSovzhqjCZU4AkTuZCWVQco+UcFGU3J+z4h
         qs3YWzLQ6KwE/q3xcXySTgYFeAX4akhhurORROSuRyOdkekL5fZjxGzr5QAOqHinG4kc
         v/Vg==
X-Gm-Message-State: AOAM5303wIsZaa0PYfV9Op/f42tXlpk5IH5smaeVhIIFzxFMlqtO9X0k
        tnquvB8cFhp7IlsmUq4+YLjayA==
X-Google-Smtp-Source: ABdhPJw6XLR/f9bIM8+F5LMZEXJjAwogBPaHG2F1jEzR573kJ4MjrUSADcEi8/pqrJAoBJkw2sKP5A==
X-Received: by 2002:a5d:404f:: with SMTP id w15mr21901458wrp.106.1614766709555;
        Wed, 03 Mar 2021 02:18:29 -0800 (PST)
Received: from localhost.localdomain (c.a.8.8.c.1.2.8.8.7.0.2.6.c.a.1.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:1ac6:2078:821c:88ac])
        by smtp.gmail.com with ESMTPSA id r26sm1710761wmn.28.2021.03.03.02.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 02:18:29 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v4 4/5] selftests: bpf: check that PROG_TEST_RUN repeats as requested
Date:   Wed,  3 Mar 2021 10:18:15 +0000
Message-Id: <20210303101816.36774-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303101816.36774-1-lmb@cloudflare.com>
References: <20210303101816.36774-1-lmb@cloudflare.com>
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

