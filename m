Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEC23B9681
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 21:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhGATXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 15:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbhGATXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 15:23:35 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B48C0613E0;
        Thu,  1 Jul 2021 12:21:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso4562556pjp.2;
        Thu, 01 Jul 2021 12:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WCM0qUYaCgBYrhbOFp35Di1REgdmWKUNaHQD3eXE5yY=;
        b=nFQfnd9PEF2GjkJZ7Jo7yrgWitg0RoyCaSzS3+medcTCwmaFdtgmhCmslHUJb0KJpr
         Pc60sf3F0sfIAtNm3k8Sda095euhN95539mi3pCvF8b++12TWqMdN+7TI5XUXfMYdqeR
         nc964xcGhPGmrqFzEWzhMCNhVoznuvQj+BBl8hVfFvtl4yNMfvpv9PXsdJuXXhb7am6M
         2wJ/eaMAtPX3J28uwJij2zBLfSOIBDkt9BwPVdOSjRPcrs5JCM6t/txCSyOmwieAwaPk
         hrL0KQInssLyB1EZ2RAJk/1kge6Khj8Np/1hPOGnASX1oz1nOMByDt/xgB7uFXtIhMf5
         tdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WCM0qUYaCgBYrhbOFp35Di1REgdmWKUNaHQD3eXE5yY=;
        b=PDDLyzq4usopepns6XU1q8RtVqJ3nVHGjo8PUCy9j9UYjGxel0SmFzJaqQXkiqcXz/
         seTdwAbTEgsFz66pS0isWZ8ui19/MMK/0mpk0Tk3zDesyT0BiFPsEfptys3UW+4nH+mm
         eKo49LRreScEAfFokV/eyAB5EY6koktJZu08hihx+vo0sPVLlvcFP/i8BLX3L3t4pgh/
         tJJh6Kd/jNw6BbVPhnHMIrz06Hg3iKzkNisjC/pmUQTrIN5f8VuMlTiZta66VSLS17Iz
         UEUZhZrUwsYW3eaTX3WzEnEFvmvRAyYivEbWjRJm9PML7290UotLSQOBR5coaijYZeMl
         i5jA==
X-Gm-Message-State: AOAM530B7eNil/MfqlPtQGpLUBptw8qjIpSanrVB9BGdKoCZBphAG5Ox
        eY7a0jYldIh51t0q1UdPhmc=
X-Google-Smtp-Source: ABdhPJzQBUfa4JKtwUrj2U5i5ercH2kck+uobgqZ5RayqGaUQaoMhvPnATM2ol001yfxaBsQShID1w==
X-Received: by 2002:a17:90a:3844:: with SMTP id l4mr11438972pjf.137.1625167263782;
        Thu, 01 Jul 2021 12:21:03 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:f1f2])
        by smtp.gmail.com with ESMTPSA id w8sm607725pgf.81.2021.07.01.12.21.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Jul 2021 12:21:03 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 9/9] selftests/bpf: Add a test with bpf_timer in inner map.
Date:   Thu,  1 Jul 2021 12:20:44 -0700
Message-Id: <20210701192044.78034-10-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Check that map-in-map supports bpf timers.

Check that indirect "recursion" of timer callbacks works:
timer_cb1() { bpf_timer_set_callback(timer_cb2); }
timer_cb2() { bpf_timer_set_callback(timer_cb1); }

Check that
  bpf_map_release
    htab_free_prealloced_timers
      bpf_timer_cancel_and_free
        hrtimer_cancel
works while timer cb is running.
"while true; do ./test_progs -t timer_mim; done"
is a great stress test. It caught missing timer cancel in htab->extra_elems.

timer_mim_reject.c is a negative test that checks
that timer<->map mismatch is prevented.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/prog_tests/timer_mim.c      | 69 +++++++++++++++
 tools/testing/selftests/bpf/progs/timer_mim.c | 88 +++++++++++++++++++
 .../selftests/bpf/progs/timer_mim_reject.c    | 74 ++++++++++++++++
 3 files changed, 231 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim_reject.c

diff --git a/tools/testing/selftests/bpf/prog_tests/timer_mim.c b/tools/testing/selftests/bpf/prog_tests/timer_mim.c
new file mode 100644
index 000000000000..f5acbcbe33a4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/timer_mim.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <test_progs.h>
+#include "timer_mim.skel.h"
+#include "timer_mim_reject.skel.h"
+
+static int timer_mim(struct timer_mim *timer_skel)
+{
+	__u32 duration = 0, retval;
+	__u64 cnt1, cnt2;
+	int err, prog_fd, key1 = 1;
+
+	err = timer_mim__attach(timer_skel);
+	if (!ASSERT_OK(err, "timer_attach"))
+		return err;
+
+	prog_fd = bpf_program__fd(timer_skel->progs.test1);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+	timer_mim__detach(timer_skel);
+
+	/* check that timer_cb[12] are incrementing 'cnt' */
+	cnt1 = READ_ONCE(timer_skel->bss->cnt);
+	usleep(200); /* 100 times more than interval */
+	cnt2 = READ_ONCE(timer_skel->bss->cnt);
+	ASSERT_GT(cnt2, cnt1, "cnt");
+
+	ASSERT_EQ(timer_skel->bss->err, 0, "err");
+	/* check that code paths completed */
+	ASSERT_EQ(timer_skel->bss->ok, 1 | 2, "ok");
+
+	close(bpf_map__fd(timer_skel->maps.inner_htab));
+	err = bpf_map_delete_elem(bpf_map__fd(timer_skel->maps.outer_arr), &key1);
+	ASSERT_EQ(err, 0, "delete inner map");
+
+	/* check that timer_cb[12] are no longer running */
+	cnt1 = READ_ONCE(timer_skel->bss->cnt);
+	usleep(200);
+	cnt2 = READ_ONCE(timer_skel->bss->cnt);
+	ASSERT_EQ(cnt2, cnt1, "cnt");
+
+	return 0;
+}
+
+void test_timer_mim(void)
+{
+	struct timer_mim_reject *timer_reject_skel = NULL;
+	libbpf_print_fn_t old_print_fn = NULL;
+	struct timer_mim *timer_skel = NULL;
+	int err;
+
+	old_print_fn = libbpf_set_print(NULL);
+	timer_reject_skel = timer_mim_reject__open_and_load();
+	libbpf_set_print(old_print_fn);
+	if (!ASSERT_ERR_PTR(timer_reject_skel, "timer_reject_skel_load"))
+		goto cleanup;
+
+	timer_skel = timer_mim__open_and_load();
+	if (!ASSERT_OK_PTR(timer_skel, "timer_skel_load"))
+		goto cleanup;
+
+	err = timer_mim(timer_skel);
+	ASSERT_OK(err, "timer_mim");
+cleanup:
+	timer_mim__destroy(timer_skel);
+	timer_mim_reject__destroy(timer_reject_skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/timer_mim.c b/tools/testing/selftests/bpf/progs/timer_mim.c
new file mode 100644
index 000000000000..2fee7ab105ef
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/timer_mim.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <linux/bpf.h>
+#include <time.h>
+#include <errno.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_tcp_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+struct hmap_elem {
+	int pad; /* unused */
+	struct bpf_timer timer;
+};
+
+struct inner_map {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1024);
+	__type(key, int);
+	__type(value, struct hmap_elem);
+} inner_htab SEC(".maps");
+
+#define ARRAY_KEY 1
+#define HASH_KEY 1234
+
+struct outer_arr {
+	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
+	__uint(max_entries, 2);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__array(values, struct inner_map);
+} outer_arr SEC(".maps") = {
+	.values = { [ARRAY_KEY] = &inner_htab },
+};
+
+__u64 err;
+__u64 ok;
+__u64 cnt;
+
+static int timer_cb1(void *map, int *key, struct hmap_elem *val);
+
+static int timer_cb2(void *map, int *key, struct hmap_elem *val)
+{
+	cnt++;
+	bpf_timer_set_callback(&val->timer, timer_cb1);
+	if (bpf_timer_start(&val->timer, 1000, 0))
+		err |= 1;
+	ok |= 1;
+	return 0;
+}
+
+/* callback for inner hash map */
+static int timer_cb1(void *map, int *key, struct hmap_elem *val)
+{
+	cnt++;
+	bpf_timer_set_callback(&val->timer, timer_cb2);
+	if (bpf_timer_start(&val->timer, 1000, 0))
+		err |= 2;
+	/* Do a lookup to make sure 'map' and 'key' pointers are correct */
+	bpf_map_lookup_elem(map, key);
+	ok |= 2;
+	return 0;
+}
+
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1, int a)
+{
+	struct hmap_elem init = {};
+	struct bpf_map *inner_map;
+	struct hmap_elem *val;
+	int array_key = ARRAY_KEY;
+	int hash_key = HASH_KEY;
+
+	inner_map = bpf_map_lookup_elem(&outer_arr, &array_key);
+	if (!inner_map)
+		return 0;
+
+	bpf_map_update_elem(inner_map, &hash_key, &init, 0);
+	val = bpf_map_lookup_elem(inner_map, &hash_key);
+	if (!val)
+		return 0;
+
+	bpf_timer_init(&val->timer, inner_map, CLOCK_MONOTONIC);
+	if (bpf_timer_set_callback(&val->timer, timer_cb1))
+		err |= 4;
+	if (bpf_timer_start(&val->timer, 0, 0))
+		err |= 8;
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/timer_mim_reject.c b/tools/testing/selftests/bpf/progs/timer_mim_reject.c
new file mode 100644
index 000000000000..5d648e3d8a41
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/timer_mim_reject.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <linux/bpf.h>
+#include <time.h>
+#include <errno.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_tcp_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+struct hmap_elem {
+	int pad; /* unused */
+	struct bpf_timer timer;
+};
+
+struct inner_map {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1024);
+	__type(key, int);
+	__type(value, struct hmap_elem);
+} inner_htab SEC(".maps");
+
+#define ARRAY_KEY 1
+#define ARRAY_KEY2 2
+#define HASH_KEY 1234
+
+struct outer_arr {
+	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
+	__uint(max_entries, 2);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__array(values, struct inner_map);
+} outer_arr SEC(".maps") = {
+	.values = { [ARRAY_KEY] = &inner_htab },
+};
+
+__u64 err;
+__u64 ok;
+__u64 cnt;
+
+/* callback for inner hash map */
+static int timer_cb(void *map, int *key, struct hmap_elem *val)
+{
+	return 0;
+}
+
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1, int a)
+{
+	struct hmap_elem init = {};
+	struct bpf_map *inner_map, *inner_map2;
+	struct hmap_elem *val;
+	int array_key = ARRAY_KEY;
+	int array_key2 = ARRAY_KEY2;
+	int hash_key = HASH_KEY;
+
+	inner_map = bpf_map_lookup_elem(&outer_arr, &array_key);
+	if (!inner_map)
+		return 0;
+
+	inner_map2 = bpf_map_lookup_elem(&outer_arr, &array_key2);
+	if (!inner_map2)
+		return 0;
+	bpf_map_update_elem(inner_map, &hash_key, &init, 0);
+	val = bpf_map_lookup_elem(inner_map, &hash_key);
+	if (!val)
+		return 0;
+
+	bpf_timer_init(&val->timer, inner_map2, CLOCK_MONOTONIC);
+	if (bpf_timer_set_callback(&val->timer, timer_cb))
+		err |= 4;
+	if (bpf_timer_start(&val->timer, 0, 0))
+		err |= 8;
+	return 0;
+}
-- 
2.30.2

