Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715523B24FD
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhFXC2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbhFXC14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 22:27:56 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B884EC0617AD;
        Wed, 23 Jun 2021 19:25:35 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g21so2181865pfc.11;
        Wed, 23 Jun 2021 19:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W6OMaDkgPCSNRt4S9ZxziI3BCvcsK+GxZc4bBmTa4Tg=;
        b=HvS6Ko/gR//Ru2kLd0sh8y0oG4kqilKvT2X5F28NUKMYZ7f3T4Jzq3a/swxSpOvKvf
         yOq+/ChQm0A63ngbsXrmls5omZaaOu1fJXS1BJXEPCupAWwBraj4OHBlc3CN7zVLLuTB
         B7F59VtrR/y7ifMFqDYxXIodmrsmv7ph2xeYMxuLIRVohc+ltAfNhwe8HShxkN390O3d
         iAw8ShmIWmO33eyNWm8cd1O3bQzWaftE7wCMHXcAFSOji0AGAEcNHxZseqhoY66ATkNo
         WpVGoNV9UYi1/DT2/+fvfdlgIgy27/DS0IzfMt/AqOl8EZpdAPl3zJZYpO24WYZadrBb
         UQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W6OMaDkgPCSNRt4S9ZxziI3BCvcsK+GxZc4bBmTa4Tg=;
        b=kVQJ0QabXykQ3ngQJxFNbHKQoA5DCODHDiLT9V/NGUgstUh5zUwZCqsvnh8kU4ai43
         nDo5K1v9VKX5nc1wi3kOC38GmyKEhMOCu8SIuTVZJ7BxcO6Q8WFklx01ow0tZnr/Ds2L
         ZyVdFbprU6vMnoxsUWR9Yrd4OgtrMdEs1R0o+4xn+x8Cj26vP1SqG4f3YNuESzcKFv2J
         CqqvPYoji9TrisCp2AjWFLZZ0dtSgr80DzP6ZMaR1SrTI6/MJJOPcWo/6xZqz0s8tPnu
         5KxNj0P+5MHITzyzbPj928/ACHbVJny2cnkw3rhAGYz+1/fy9/nGeyQKqzEi1d374Eid
         O/KQ==
X-Gm-Message-State: AOAM532ucTTZC4nr917AH1k0IiZrIqNiAmdS2ECrvpIXqli00Efwg1He
        KRmJ/wZ1Cvdjvm8meVDzllg=
X-Google-Smtp-Source: ABdhPJy/5v4PjeGqE4kMx3R9RJkecD+7ELpYufyS4FA/Ei2nle7+h14vI+iRdkYJqXgtPk/LWfBdrw==
X-Received: by 2002:a62:687:0:b029:2ef:be02:c346 with SMTP id 129-20020a6206870000b02902efbe02c346mr2698991pfg.51.1624501535326;
        Wed, 23 Jun 2021 19:25:35 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:a319])
        by smtp.gmail.com with ESMTPSA id f17sm4675965pjj.21.2021.06.23.19.25.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:25:34 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 8/8] selftests/bpf: Add a test with bpf_timer in inner map.
Date:   Wed, 23 Jun 2021 19:25:18 -0700
Message-Id: <20210624022518.57875-9-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Check that map-in-map supports bpf timers.

Check that indirect "recursion" of timer callbacks works:
timer_cb1() { bpf_timer_start(timer_cb2); }
timer_cb2() { bpf_timer_start(timer_cb1); }

Check that
  bpf_map_release
    htab_free_prealloced_timers
      bpf_timer_cancel_and_free
        hrtimer_cancel
works while timer cb is running.
"while true; do ./test_progs -t timer_mim; done"
is a great stress test. It caught missing timer cancel in htab->extra_elems.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/prog_tests/timer_mim.c      | 59 ++++++++++++++
 tools/testing/selftests/bpf/progs/timer_mim.c | 81 +++++++++++++++++++
 2 files changed, 140 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim.c

diff --git a/tools/testing/selftests/bpf/prog_tests/timer_mim.c b/tools/testing/selftests/bpf/prog_tests/timer_mim.c
new file mode 100644
index 000000000000..d54b16a3d9ea
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/timer_mim.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <test_progs.h>
+#include "timer_mim.skel.h"
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
+	usleep(2);
+	cnt2 = READ_ONCE(timer_skel->bss->cnt);
+	ASSERT_GT(cnt2, cnt1, "cnt");
+
+	ASSERT_EQ(timer_skel->bss->err, 0, "err");
+	/* check that code paths completed */
+	ASSERT_EQ(timer_skel->bss->ok, 1 | 2, "ok");
+
+	close(bpf_map__fd(timer_skel->maps.inner_map));
+	err = bpf_map_delete_elem(bpf_map__fd(timer_skel->maps.outer_arr), &key1);
+	ASSERT_EQ(err, 0, "delete inner map");
+
+	/* check that timer_cb[12] are no longer running */
+	cnt1 = READ_ONCE(timer_skel->bss->cnt);
+	usleep(2);
+	cnt2 = READ_ONCE(timer_skel->bss->cnt);
+	ASSERT_EQ(cnt2, cnt1, "cnt");
+
+	return 0;
+}
+
+void test_timer_mim(void)
+{
+	struct timer_mim *timer_skel = NULL;
+	int err;
+
+	timer_skel = timer_mim__open_and_load();
+	if (!ASSERT_OK_PTR(timer_skel, "timer_skel_load"))
+		goto cleanup;
+
+	err = timer_mim(timer_skel);
+	ASSERT_OK(err, "timer_mim");
+cleanup:
+	timer_mim__destroy(timer_skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/timer_mim.c b/tools/testing/selftests/bpf/progs/timer_mim.c
new file mode 100644
index 000000000000..4d1d785d8d26
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/timer_mim.c
@@ -0,0 +1,81 @@
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
+} inner_map SEC(".maps");
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
+	.values = { [ARRAY_KEY] = &inner_map },
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
+	if (bpf_timer_start(&val->timer, timer_cb1, 1000) != 0)
+		err |= 1;
+	ok |= 1;
+	return 0;
+}
+
+/* callback for inner hash map */
+static int timer_cb1(void *map, int *key, struct hmap_elem *val)
+{
+	cnt++;
+	if (bpf_timer_start(&val->timer, timer_cb2, 1000) != 0)
+		err |= 2;
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
+	bpf_timer_init(&val->timer, CLOCK_MONOTONIC);
+	bpf_timer_start(&val->timer, timer_cb1, 0);
+	return 0;
+}
-- 
2.30.2

