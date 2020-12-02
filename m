Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9C82CC871
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388306AbgLBU5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729825AbgLBU5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:57:17 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF15C061A4C
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 12:55:54 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id g14so5505601wrm.13
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 12:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K/M4gu8JZX1RUvKKxbWMwd6sKzErX4ydvwnU8nMRHQ4=;
        b=D6faCZKaZz2JIRalfxmQNWlgs9BZVcVUzjLDZMWz8b+ljkUBScyhx1k/DaBTGAkDzM
         ifgZo1OQOhGfDRmmZW+jZbx/WI74J37e99r3U6h+FsSE2dzF3OZR8yILdeF9PMFPY0ey
         f6SN5/dbQR4iNJ1QMLg3cz0QAnwiOD6II2qo0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K/M4gu8JZX1RUvKKxbWMwd6sKzErX4ydvwnU8nMRHQ4=;
        b=dy4rCcjUhJJDa9uyB4S4lAic0tcMvYEvTRHH4/uNRL40XdoyNx31DPYW6RPgq8g9uv
         o8sRkbwsnR8v7USHTFqJ7Fc9wVDw909lpPH1KSVKGqwTiiOXi37B13uBcHOmooaa5oIT
         Tzop7uEa9hcDfFhmD2a1+VWBCBswJyQI7XwpemahXYZ1y4wTG+4sOsCPnlbRFndzsL3j
         UshAi2R7msW3U3hy9cXd+C9+7avnGj4Nz1I6y2d8OwED22zvWvUEZV268NCvJS1n1/DY
         67kVeWM43nTSJQI/oQntdXR/esjlwCPHqEeORbSxQrIhZ5UsjWqwk1CDKmcoqP/DSpl9
         dS/w==
X-Gm-Message-State: AOAM5324vMpzk3/Jpp4vTe/oAnfVBHNAh9RL4kzY20p4QsQ4AHXHi78b
        v89s9MKynAarMIOiS4SS7XlwQA==
X-Google-Smtp-Source: ABdhPJzDW4KvZQDtKBx2AAD1dvrgz0s0/U1bpc8MB3nSpS75fvQe+AX+zq9feZKzJNeYBsUnpHuYJg==
X-Received: by 2002:adf:e44d:: with SMTP id t13mr5723226wrm.144.1606942552995;
        Wed, 02 Dec 2020 12:55:52 -0800 (PST)
Received: from revest.zrh.corp.google.com ([2a00:79e0:42:204:f693:9fff:fef4:a569])
        by smtp.gmail.com with ESMTPSA id d2sm3438486wrn.43.2020.12.02.12.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 12:55:52 -0800 (PST)
From:   Florent Revest <revest@chromium.org>
X-Google-Original-From: Florent Revest <revest@google.com>
To:     bpf@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andrii@kernel.org, kpsingh@chromium.org, revest@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 4/6] bpf: Add an iterator selftest for bpf_sk_storage_delete
Date:   Wed,  2 Dec 2020 21:55:25 +0100
Message-Id: <20201202205527.984965-4-revest@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
In-Reply-To: <20201202205527.984965-1-revest@google.com>
References: <20201202205527.984965-1-revest@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eBPF program iterates over all entries (well, only one) of a socket
local storage map and deletes them all. The test makes sure that the
entry is indeed deleted.

Signed-off-by: Florent Revest <revest@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 64 +++++++++++++++++++
 .../progs/bpf_iter_bpf_sk_storage_helpers.c   | 23 +++++++
 2 files changed, 87 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 448885b95eed..bb4a638f2e6f 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -20,6 +20,7 @@
 #include "bpf_iter_bpf_percpu_hash_map.skel.h"
 #include "bpf_iter_bpf_array_map.skel.h"
 #include "bpf_iter_bpf_percpu_array_map.skel.h"
+#include "bpf_iter_bpf_sk_storage_helpers.skel.h"
 #include "bpf_iter_bpf_sk_storage_map.skel.h"
 #include "bpf_iter_test_kern5.skel.h"
 #include "bpf_iter_test_kern6.skel.h"
@@ -913,6 +914,67 @@ static void test_bpf_percpu_array_map(void)
 	bpf_iter_bpf_percpu_array_map__destroy(skel);
 }
 
+/* An iterator program deletes all local storage in a map. */
+static void test_bpf_sk_storage_delete(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	struct bpf_iter_bpf_sk_storage_helpers *skel;
+	union bpf_iter_link_info linfo;
+	int err, len, map_fd, iter_fd;
+	struct bpf_link *link;
+	int sock_fd = -1;
+	__u32 val = 42;
+	char buf[64];
+
+	skel = bpf_iter_bpf_sk_storage_helpers__open_and_load();
+	if (CHECK(!skel, "bpf_iter_bpf_sk_storage_helpers__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	map_fd = bpf_map__fd(skel->maps.sk_stg_map);
+
+	sock_fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (CHECK(sock_fd < 0, "socket", "errno: %d\n", errno))
+		goto out;
+	err = bpf_map_update_elem(map_fd, &sock_fd, &val, BPF_NOEXIST);
+	if (CHECK(err, "map_update", "map_update failed\n"))
+		goto out;
+
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.map.map_fd = map_fd;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+	link = bpf_program__attach_iter(skel->progs.delete_bpf_sk_storage_map,
+					&opts);
+	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+		goto out;
+
+	iter_fd = bpf_iter_create(bpf_link__fd(link));
+	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
+		goto free_link;
+
+	/* do some tests */
+	while ((len = read(iter_fd, buf, sizeof(buf))) > 0)
+		;
+	if (CHECK(len < 0, "read", "read failed: %s\n", strerror(errno)))
+		goto close_iter;
+
+	/* test results */
+	err = bpf_map_lookup_elem(map_fd, &sock_fd, &val);
+	if (CHECK(!err || errno != ENOENT, "bpf_map_lookup_elem",
+		  "map value wasn't deleted (err=%d, errno=%d)\n", err, errno))
+		goto close_iter;
+
+close_iter:
+	close(iter_fd);
+free_link:
+	bpf_link__destroy(link);
+out:
+	if (sock_fd >= 0)
+		close(sock_fd);
+	bpf_iter_bpf_sk_storage_helpers__destroy(skel);
+}
+
 static void test_bpf_sk_storage_map(void)
 {
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
@@ -1067,6 +1129,8 @@ void test_bpf_iter(void)
 		test_bpf_percpu_array_map();
 	if (test__start_subtest("bpf_sk_storage_map"))
 		test_bpf_sk_storage_map();
+	if (test__start_subtest("bpf_sk_storage_delete"))
+		test_bpf_sk_storage_delete();
 	if (test__start_subtest("rdonly-buf-out-of-bound"))
 		test_rdonly_buf_out_of_bound();
 	if (test__start_subtest("buf-neg-offset"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
new file mode 100644
index 000000000000..01ff3235e413
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Google LLC. */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, int);
+} sk_stg_map SEC(".maps");
+
+SEC("iter/bpf_sk_storage_map")
+int delete_bpf_sk_storage_map(struct bpf_iter__bpf_sk_storage_map *ctx)
+{
+	if (ctx->sk)
+		bpf_sk_storage_delete(&sk_stg_map, ctx->sk);
+
+	return 0;
+}
-- 
2.29.2.454.gaff20da3a2-goog

