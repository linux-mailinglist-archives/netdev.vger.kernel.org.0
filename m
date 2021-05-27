Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE403925D0
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhE0EEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhE0EEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 00:04:42 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80F5C061760;
        Wed, 26 May 2021 21:03:08 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id m124so2689164pgm.13;
        Wed, 26 May 2021 21:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e3iwbx2NsEKAeqynzSQnzu5zTU6telTHzk6HApof5DM=;
        b=qm62CJkBGCq6DjIVtsuPHxPSOLltBM0lGqaRYsLiDCENYIYSOjvz6pXCcr13VBIA7P
         Dls9nhNQXXtqijDsDY2460Wflxmf9A3Tj2CND7zSSabilF0tQ767tSJCkjgmHYYvwldt
         ArFX7goAbPdkgby9dRvXkfdb+WTAWzt+prgd6d2cDsrksLrodUw65/QHN8s0xM7sMNRh
         uiSrds14SyFMKzhP2x15vgfU+doK/yl0OAzZlYgqQAetIgmsmMVZqRzJGAK01HvhF7OZ
         PCt/dr8EgX3z7n+f9+57eA8aOhrreC9TzMnbEznigi183RW3ZPCPKo6JSkX5mCfxFxw0
         QdIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e3iwbx2NsEKAeqynzSQnzu5zTU6telTHzk6HApof5DM=;
        b=aZhgh/Xreg4vTM+g25z0bsQgxu4Blgo+fuPkZ/S3NnjpSHxCH8QCcBKCgJnOI6XuHu
         CO/JkoZt9Tva7S1pqtxjYySgIx8VwFzg5k+5A+IwiupqD0W4qL+2Usj/AP0mpUrCEM8d
         cRCihlAeWiAmFut0peOAp+Fu4rL1SN4F6+8icXooUaC6Oi1uHoCDitILO15IRD8ufbdJ
         vfoZEnVm1RWEerebdUCq/HPw3bfSN6BbW1+tniKoPjU3oU+bq2ivOoOaQSZnyrJoKUu2
         lGJJSDtF1rFY80ZfX+5YeBkad4iPFsjQ4OSxeXzuDwpnc+udgeCctmxF4gnbX6SxtgRh
         Y5Qg==
X-Gm-Message-State: AOAM5314/ivWZG750zSQf6GN4/0kPEQn4ZZl4XfwKe3Bc4R38rNT2gwz
        moilKT5PbZX0JdIWm91K29o=
X-Google-Smtp-Source: ABdhPJxVO57QuvW4R1WRqziz0ylVdHTJMJnrb8BJ/k0wJ/qxwaSlDpGuqgmby728Qol0KjFsGGd0Dg==
X-Received: by 2002:a63:164f:: with SMTP id 15mr1824540pgw.175.1622088188332;
        Wed, 26 May 2021 21:03:08 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:6b23])
        by smtp.gmail.com with ESMTPSA id j22sm568281pfd.215.2021.05.26.21.03.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 May 2021 21:03:07 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 3/3] selftests/bpf: Add bpf_timer test.
Date:   Wed, 26 May 2021 21:02:59 -0700
Message-Id: <20210527040259.77823-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add bpf_timer test that creates two timers. One in hash map and another global
timer in bss. It let global timer expire once and then re-arms it for 35
seconds. Then arms and re-arms hash timer 10 times and at the last invocation
cancels global timer.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/timer.c  | 47 ++++++++++
 tools/testing/selftests/bpf/progs/timer.c     | 85 +++++++++++++++++++
 2 files changed, 132 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer.c

diff --git a/tools/testing/selftests/bpf/prog_tests/timer.c b/tools/testing/selftests/bpf/prog_tests/timer.c
new file mode 100644
index 000000000000..7be2aeba2dad
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/timer.c
@@ -0,0 +1,47 @@
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
+
+	prog_fd = bpf_program__fd(timer_skel->progs.test1);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+	timer__detach(timer_skel);
+
+	usleep(50 * 1000); /* 10 msecs should be enough, but give it extra */
+	/* check that timer_cb1() was executed 10 times */
+	ASSERT_EQ(timer_skel->data->callback_check, 42, "callback_check2");
+
+	/* check that timer_cb2() was executed once */
+	ASSERT_EQ(timer_skel->bss->bss_data, 15, "bss_data");
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
index 000000000000..d20672cf61d6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/timer.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_tcp_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+struct map_elem {
+	int counter;
+	struct bpf_timer timer;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1000);
+	__type(key, int);
+	__type(value, struct map_elem);
+} hmap SEC(".maps");
+
+__u64 bss_data;
+struct bpf_timer global_timer;
+
+__u64 callback_check = 52;
+
+static int timer_cb1(void *map, int *key, __u64 *data)
+{
+	/* increment the same bss variable twice */
+	bss_data += 5;
+	data[0] += 10; /* &data[1] == &bss_data */
+	/* note data[1] access will be rejected by the verifier,
+	 * since &data[1] points to the &global_timer.
+	 */
+
+	/* rearm self to be called again in ~35 seconds */
+	bpf_timer_start(&global_timer, 1ull << 35);
+	return 0;
+}
+
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1, int a)
+{
+	bpf_timer_init(&global_timer, timer_cb1, 0);
+	bpf_timer_start(&global_timer, 0 /* call timer_cb1 asap */);
+	return 0;
+}
+
+static int timer_cb2(void *map, int *key, struct map_elem *val)
+{
+	callback_check--;
+	if (--val->counter)
+		/* re-arm the timer again to execute after 1 msec */
+		bpf_timer_start(&val->timer, 1000);
+	else {
+		/* cancel global_timer otherwise bpf_fentry_test1 prog
+		 * will stay alive forever.
+		 */
+		bpf_timer_cancel(&global_timer);
+		bpf_timer_cancel(&val->timer);
+	}
+	return 0;
+}
+
+int bpf_timer_test(void)
+{
+	struct map_elem *val;
+	int key = 0;
+
+	val = bpf_map_lookup_elem(&hmap, &key);
+	if (val) {
+		bpf_timer_init(&val->timer, timer_cb2, 0);
+		bpf_timer_start(&val->timer, 1000);
+	}
+	return 0;
+}
+
+SEC("fentry/bpf_fentry_test2")
+int BPF_PROG(test2, int a, int b)
+{
+	struct map_elem val = {};
+	int key = 0;
+
+	val.counter = 10; /* number of times to trigger timer_cb1 */
+	bpf_map_update_elem(&hmap, &key, &val, 0);
+	return bpf_timer_test();
+}
-- 
2.30.2

