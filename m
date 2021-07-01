Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397B53B967F
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 21:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbhGATXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 15:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbhGATXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 15:23:33 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F318C0613DC;
        Thu,  1 Jul 2021 12:21:02 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l11so4861630pji.5;
        Thu, 01 Jul 2021 12:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BJa6mry8J0MwiXrptb/iORsTljLvfzWlcZ7RwWWwnMg=;
        b=oLyMajt8oQMqa34GbXfqV2H1YTQb/yPpejJfJfC4T4mlMNmNwPYqEfUGMqfQZ1vadA
         XbY5jvPWOygJ2SLf3wkFhNqvd8+GAlekJmyDnaO4feRCiaCn5PYDhP7RWBQdpJVfvzlw
         Ol7chGY8jIaALfZQrUOHQwtzyeW6SMSZfgORcXKbUJJ3kS/v45wtAIHoxLJLhMYC99hU
         /b2RU5MrU4Y1Yug9TJwJ50VzizTDUAGe4wgJgLKWheQpMhGXxglXNjXijw7YsgjNk6bB
         wVx5eXf3K+ROXqWaLbT9HR77D43ETf4G3QNar5ZpAPzRk7yA504JNXwwho3XgiZQI/pQ
         +GnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BJa6mry8J0MwiXrptb/iORsTljLvfzWlcZ7RwWWwnMg=;
        b=RqyFu5hzSAv99F2LKyKTjet1NaobDp3ThVfjxFTkOO/F0OEespMb05Aig6RBg47sMD
         rHdETP7d4i42ly/dvXU4RDTAKJkW6XjEbxuS30bMW7lFMm4sqCAZgygqMJR8kuNzzbla
         Cd9oZcqsk8jsv1/XxDk7JV7+RWZpTgPt157gbNIDCGrW7xyUkUQOQLXaVMH6AkTvaC5l
         ikEk4HM9x9mOhdUUx94GBxPsaV3Qkdo5synCgJBqDYd6uEkjFZqZsFKXlOABuQHzC2qn
         LQoigQLa+KgIfjX5E/UMGrxZ62daCmpz5639/n6OyNITLGBJ3w7mWV8b5VcFPBesMmd+
         t5Jg==
X-Gm-Message-State: AOAM5329hXdidNXVJv+JdNu5t4xdbCUGjukhb5RSDKcO58rMiuW40+7u
        jiYq8s0yMadYadjJNUP7SHE=
X-Google-Smtp-Source: ABdhPJwNid0/da0968IKsCVbBEEnP3u9fpOhzn2c9BYUN5THXDlShyQQoHX5TQLX/SeaU6FhzeUDZg==
X-Received: by 2002:a17:90a:a48b:: with SMTP id z11mr1118946pjp.24.1625167262120;
        Thu, 01 Jul 2021 12:21:02 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:f1f2])
        by smtp.gmail.com with ESMTPSA id w8sm607725pgf.81.2021.07.01.12.21.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Jul 2021 12:21:01 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 8/9] selftests/bpf: Add bpf_timer test.
Date:   Thu,  1 Jul 2021 12:20:43 -0700
Message-Id: <20210701192044.78034-9-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add bpf_timer test that creates timers in preallocated and
non-preallocated hash, in array and in lru maps.
Let array timer expire once and then re-arm it for 35 seconds.
Arm lru timer into the same callback.
Then arm and re-arm hash timers 10 times each.
At the last invocation of prealloc hash timer cancel the array timer.
Force timer free via LRU eviction and direct bpf_map_delete_elem.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/timer.c  |  55 ++++
 tools/testing/selftests/bpf/progs/timer.c     | 297 ++++++++++++++++++
 2 files changed, 352 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer.c

diff --git a/tools/testing/selftests/bpf/prog_tests/timer.c b/tools/testing/selftests/bpf/prog_tests/timer.c
new file mode 100644
index 000000000000..25f40e1b9967
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/timer.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <test_progs.h>
+#include "timer.skel.h"
+
+static int timer(struct timer *timer_skel)
+{
+	int err, prog_fd;
+	__u32 duration = 0, retval;
+
+	err = timer__attach(timer_skel);
+	if (!ASSERT_OK(err, "timer_attach"))
+		return err;
+
+	ASSERT_EQ(timer_skel->data->callback_check, 52, "callback_check1");
+	ASSERT_EQ(timer_skel->data->callback2_check, 52, "callback2_check1");
+
+	prog_fd = bpf_program__fd(timer_skel->progs.test1);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+	timer__detach(timer_skel);
+
+	usleep(50); /* 10 usecs should be enough, but give it extra */
+	/* check that timer_cb1() was executed 10+10 times */
+	ASSERT_EQ(timer_skel->data->callback_check, 42, "callback_check2");
+	ASSERT_EQ(timer_skel->data->callback2_check, 42, "callback2_check2");
+
+	/* check that timer_cb2() was executed twice */
+	ASSERT_EQ(timer_skel->bss->bss_data, 10, "bss_data");
+
+	/* check that there were no errors in timer execution */
+	ASSERT_EQ(timer_skel->bss->err, 0, "err");
+
+	/* check that code paths completed */
+	ASSERT_EQ(timer_skel->bss->ok, 1 | 2 | 4, "ok");
+
+	return 0;
+}
+
+void test_timer(void)
+{
+	struct timer *timer_skel = NULL;
+	int err;
+
+	timer_skel = timer__open_and_load();
+	if (!ASSERT_OK_PTR(timer_skel, "timer_skel_load"))
+		goto cleanup;
+
+	err = timer(timer_skel);
+	ASSERT_OK(err, "timer");
+cleanup:
+	timer__destroy(timer_skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/timer.c b/tools/testing/selftests/bpf/progs/timer.c
new file mode 100644
index 000000000000..5f5309791649
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/timer.c
@@ -0,0 +1,297 @@
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
+	int counter;
+	struct bpf_timer timer;
+	struct bpf_spin_lock lock; /* unused */
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1000);
+	__type(key, int);
+	__type(value, struct hmap_elem);
+} hmap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__uint(max_entries, 1000);
+	__type(key, int);
+	__type(value, struct hmap_elem);
+} hmap_malloc SEC(".maps");
+
+struct elem {
+	struct bpf_timer t;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 2);
+	__type(key, int);
+	__type(value, struct elem);
+} array SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_LRU_HASH);
+	__uint(max_entries, 4);
+	__type(key, int);
+	__type(value, struct elem);
+} lru SEC(".maps");
+
+__u64 bss_data;
+__u64 err;
+__u64 ok;
+__u64 callback_check = 52;
+__u64 callback2_check = 52;
+
+#define ARRAY 1
+#define HTAB 2
+#define HTAB_MALLOC 3
+#define LRU 4
+
+/* callback for array and lru timers */
+static int timer_cb1(void *map, int *key, struct bpf_timer *timer)
+{
+	/* increment bss variable twice.
+	 * Once via array timer callback and once via lru timer callback
+	 */
+	bss_data += 5;
+
+	/* *key == 0 - the callback was called for array timer.
+	 * *key == 4 - the callback was called from lru timer.
+	 */
+	if (*key == ARRAY) {
+		struct bpf_timer *lru_timer;
+		int lru_key = LRU;
+
+		/* rearm array timer to be called again in ~35 seconds */
+		if (bpf_timer_start(timer, 1ull << 35, 0) != 0)
+			err |= 1;
+
+		lru_timer = bpf_map_lookup_elem(&lru, &lru_key);
+		if (!lru_timer)
+			return 0;
+		bpf_timer_set_callback(lru_timer, timer_cb1);
+		if (bpf_timer_start(lru_timer, 0, 0) != 0)
+			err |= 2;
+	} else if (*key == LRU) {
+		int lru_key, i;
+
+		for (i = LRU + 1;
+		     i <= 100  /* for current LRU eviction algorithm this number
+				* should be larger than ~ lru->max_entries * 2
+				*/;
+		     i++) {
+			struct elem init = {};
+
+			/* lru_key cannot be used as loop induction variable
+			 * otherwise the loop will be unbounded.
+			 */
+			lru_key = i;
+
+			/* add more elements into lru map to push out current
+			 * element and force deletion of this timer
+			 */
+			bpf_map_update_elem(map, &lru_key, &init, 0);
+			/* look it up to bump it into active list */
+			bpf_map_lookup_elem(map, &lru_key);
+
+			/* keep adding until *key changes underneath,
+			 * which means that key/timer memory was reused
+			 */
+			if (*key != LRU)
+				break;
+		}
+
+		/* check that the timer was removed */
+		if (bpf_timer_cancel(timer) != -EINVAL)
+			err |= 4;
+		ok |= 1;
+	}
+	return 0;
+}
+
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1, int a)
+{
+	struct bpf_timer *arr_timer, *lru_timer;
+	struct elem init = {};
+	int lru_key = LRU;
+	int array_key = ARRAY;
+
+	arr_timer = bpf_map_lookup_elem(&array, &array_key);
+	if (!arr_timer)
+		return 0;
+	bpf_timer_init(arr_timer, &array, CLOCK_MONOTONIC);
+
+	bpf_map_update_elem(&lru, &lru_key, &init, 0);
+	lru_timer = bpf_map_lookup_elem(&lru, &lru_key);
+	if (!lru_timer)
+		return 0;
+	bpf_timer_init(lru_timer, &lru, CLOCK_MONOTONIC);
+
+	bpf_timer_set_callback(arr_timer, timer_cb1);
+	bpf_timer_start(arr_timer, 0 /* call timer_cb1 asap */, 0);
+
+	/* init more timers to check that array destruction
+	 * doesn't leak timer memory.
+	 */
+	array_key = 0;
+	arr_timer = bpf_map_lookup_elem(&array, &array_key);
+	if (!arr_timer)
+		return 0;
+	bpf_timer_init(arr_timer, &array, CLOCK_MONOTONIC);
+	return 0;
+}
+
+/* callback for prealloc and non-prealloca hashtab timers */
+static int timer_cb2(void *map, int *key, struct hmap_elem *val)
+{
+	if (*key == HTAB)
+		callback_check--;
+	else
+		callback2_check--;
+	if (val->counter > 0 && --val->counter) {
+		/* re-arm the timer again to execute after 1 usec */
+		bpf_timer_start(&val->timer, 1000, 0);
+	} else if (*key == HTAB) {
+		struct bpf_timer *arr_timer;
+		int array_key = ARRAY;
+
+		/* cancel arr_timer otherwise bpf_fentry_test1 prog
+		 * will stay alive forever.
+		 */
+		arr_timer = bpf_map_lookup_elem(&array, &array_key);
+		if (!arr_timer)
+			return 0;
+		if (bpf_timer_cancel(arr_timer) != 1)
+			/* bpf_timer_cancel should return 1 to indicate
+			 * that arr_timer was active at this time
+			 */
+			err |= 8;
+
+		/* try to cancel ourself. It shouldn't deadlock. */
+		if (bpf_timer_cancel(&val->timer) != -EDEADLK)
+			err |= 16;
+
+		/* delete this key and this timer anyway.
+		 * It shouldn't deadlock either.
+		 */
+		bpf_map_delete_elem(map, key);
+
+		/* in preallocated hashmap both 'key' and 'val' could have been
+		 * reused to store another map element (like in LRU above),
+		 * but in controlled test environment the below test works.
+		 * It's not a use-after-free. The memory is owned by the map.
+		 */
+		if (bpf_timer_start(&val->timer, 1000, 0) != -EINVAL)
+			err |= 32;
+		ok |= 2;
+	} else {
+		if (*key != HTAB_MALLOC)
+			err |= 64;
+
+		/* try to cancel ourself. It shouldn't deadlock. */
+		if (bpf_timer_cancel(&val->timer) != -EDEADLK)
+			err |= 128;
+
+		/* delete this key and this timer anyway.
+		 * It shouldn't deadlock either.
+		 */
+		bpf_map_delete_elem(map, key);
+
+		/* in non-preallocated hashmap both 'key' and 'val' are RCU
+		 * protected and still valid though this element was deleted
+		 * from the map. Arm this timer for ~35 seconds. When callback
+		 * finishes the call_rcu will invoke:
+		 * htab_elem_free_rcu
+		 *   check_and_free_timer
+		 *     bpf_timer_cancel_and_free
+		 * to cancel this 35 second sleep and delete the timer for real.
+		 */
+		if (bpf_timer_start(&val->timer, 1ull << 35, 0) != 0)
+			err |= 256;
+		ok |= 4;
+	}
+	return 0;
+}
+
+int bpf_timer_test(void)
+{
+	struct hmap_elem *val;
+	int key = HTAB, key_malloc = HTAB_MALLOC;
+
+	val = bpf_map_lookup_elem(&hmap, &key);
+	if (val) {
+		if (bpf_timer_init(&val->timer, &hmap, CLOCK_BOOTTIME) != 0)
+			err |= 512;
+		bpf_timer_set_callback(&val->timer, timer_cb2);
+		bpf_timer_start(&val->timer, 1000, 0);
+	}
+	val = bpf_map_lookup_elem(&hmap_malloc, &key_malloc);
+	if (val) {
+		if (bpf_timer_init(&val->timer, &hmap_malloc, CLOCK_BOOTTIME) != 0)
+			err |= 1024;
+		bpf_timer_set_callback(&val->timer, timer_cb2);
+		bpf_timer_start(&val->timer, 1000, 0);
+	}
+	return 0;
+}
+
+SEC("fentry/bpf_fentry_test2")
+int BPF_PROG(test2, int a, int b)
+{
+	struct hmap_elem init = {}, *val;
+	int key = HTAB, key_malloc = HTAB_MALLOC;
+
+	init.counter = 10; /* number of times to trigger timer_cb2 */
+	bpf_map_update_elem(&hmap, &key, &init, 0);
+	val = bpf_map_lookup_elem(&hmap, &key);
+	if (val)
+		bpf_timer_init(&val->timer, &hmap, CLOCK_BOOTTIME);
+	/* update the same key to free the timer */
+	bpf_map_update_elem(&hmap, &key, &init, 0);
+
+	bpf_map_update_elem(&hmap_malloc, &key_malloc, &init, 0);
+	val = bpf_map_lookup_elem(&hmap_malloc, &key_malloc);
+	if (val)
+		bpf_timer_init(&val->timer, &hmap_malloc, CLOCK_BOOTTIME);
+	/* update the same key to free the timer */
+	bpf_map_update_elem(&hmap_malloc, &key_malloc, &init, 0);
+
+	/* init more timers to check that htab operations
+	 * don't leak timer memory.
+	 */
+	key = 0;
+	bpf_map_update_elem(&hmap, &key, &init, 0);
+	val = bpf_map_lookup_elem(&hmap, &key);
+	if (val)
+		bpf_timer_init(&val->timer, &hmap, CLOCK_BOOTTIME);
+	bpf_map_delete_elem(&hmap, &key);
+	bpf_map_update_elem(&hmap, &key, &init, 0);
+	val = bpf_map_lookup_elem(&hmap, &key);
+	if (val)
+		bpf_timer_init(&val->timer, &hmap, CLOCK_BOOTTIME);
+
+	/* and with non-prealloc htab */
+	key_malloc = 0;
+	bpf_map_update_elem(&hmap_malloc, &key_malloc, &init, 0);
+	val = bpf_map_lookup_elem(&hmap_malloc, &key_malloc);
+	if (val)
+		bpf_timer_init(&val->timer, &hmap_malloc, CLOCK_BOOTTIME);
+	bpf_map_delete_elem(&hmap_malloc, &key_malloc);
+	bpf_map_update_elem(&hmap_malloc, &key_malloc, &init, 0);
+	val = bpf_map_lookup_elem(&hmap_malloc, &key_malloc);
+	if (val)
+		bpf_timer_init(&val->timer, &hmap_malloc, CLOCK_BOOTTIME);
+
+	return bpf_timer_test();
+}
-- 
2.30.2

