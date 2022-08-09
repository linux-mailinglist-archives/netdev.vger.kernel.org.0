Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F63358D393
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 08:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbiHIGIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 02:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbiHIGIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 02:08:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215871D32B;
        Mon,  8 Aug 2022 23:08:49 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660025327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oh+N7C97zM8ubSg7JH/5CdwUFBpbVQtZQ0gN8jL99T8=;
        b=JhKlaporNeHGSUIVcMOrGlmayFo8h1wzA6MEQtZothEw/AGOVfy2WWZm0sQHumtcxqYq1e
        e4thXMokdbWbrDkDVj3fsiBNG4OJkAc0A2KJo9d1TTgHnN6MuAuOgx9ArhQObY4TuWwGyM
        AWzWUKpQ95Qa0XeBy3jrOWWZPDCLR9h8U5qLqQjlvK0gyWs/+j4AR754MoiV3XMetcgdAt
        5+1uasLPrbOOTDSyuolnCdCXlBKLgD7SNMWaoLwmPKahEdrtwyGhnDXLsQwa4amfzTZNIV
        0sjIWsTSQwrqLrLgLNPfLrg9VFhlPOjfR8B1R3J0p/apVgoGSRobPUHxRMdP4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660025327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oh+N7C97zM8ubSg7JH/5CdwUFBpbVQtZQ0gN8jL99T8=;
        b=u7hNKA2navC0XTWG8eFXBCcKKfwDQAx0ind+KgP9valSIlxjNq1m/qlEUq8CBesrupTGyf
        yUphy5CTHND0gKDQ==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: Add BPF-helper test for CLOCK_TAI access
Date:   Tue,  9 Aug 2022 08:08:03 +0200
Message-Id: <20220809060803.5773-3-kurt@linutronix.de>
In-Reply-To: <20220809060803.5773-1-kurt@linutronix.de>
References: <20220809060803.5773-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF-helper test case for CLOCK_TAI access. The added test verifies that:

 * Timestamps are generated
 * Timestamps are moving forward
 * Timestamps are reasonable

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 .../selftests/bpf/prog_tests/time_tai.c       | 74 +++++++++++++++++++
 .../selftests/bpf/progs/test_time_tai.c       | 24 ++++++
 2 files changed, 98 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/time_tai.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_time_tai.c

diff --git a/tools/testing/selftests/bpf/prog_tests/time_tai.c b/tools/testing/selftests/bpf/prog_tests/time_tai.c
new file mode 100644
index 000000000000..a31119823666
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/time_tai.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022 Linutronix GmbH */
+
+#include <test_progs.h>
+#include <network_helpers.h>
+
+#include "test_time_tai.skel.h"
+
+#include <time.h>
+#include <stdint.h>
+
+#define TAI_THRESHOLD	1000000000ULL /* 1s */
+#define NSEC_PER_SEC	1000000000ULL
+
+static __u64 ts_to_ns(const struct timespec *ts)
+{
+	return ts->tv_sec * NSEC_PER_SEC + ts->tv_nsec;
+}
+
+void test_time_tai(void)
+{
+	struct __sk_buff skb = {
+		.cb[0] = 0,
+		.cb[1] = 0,
+		.tstamp = 0,
+	};
+	LIBBPF_OPTS(bpf_test_run_opts, topts,
+		.data_in = &pkt_v4,
+		.data_size_in = sizeof(pkt_v4),
+		.ctx_in = &skb,
+		.ctx_size_in = sizeof(skb),
+		.ctx_out = &skb,
+		.ctx_size_out = sizeof(skb),
+	);
+	struct test_time_tai *skel;
+	struct timespec now_tai;
+	__u64 ts1, ts2, now;
+	int ret, prog_fd;
+
+	/* Open and load */
+	skel = test_time_tai__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "tai_open"))
+		return;
+
+	/* Run test program */
+	prog_fd = bpf_program__fd(skel->progs.time_tai);
+	ret = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(ret, "test_run");
+
+	/* Retrieve generated TAI timestamps */
+	ts1 = skb.tstamp;
+	ts2 = skb.cb[0] | ((__u64)skb.cb[1] << 32);
+
+	/* TAI != 0 */
+	ASSERT_NEQ(ts1, 0, "tai_ts1");
+	ASSERT_NEQ(ts2, 0, "tai_ts2");
+
+	/* TAI is moving forward only */
+	ASSERT_GT(ts2, ts1, "tai_forward");
+
+	/* Check for future */
+	ret = clock_gettime(CLOCK_TAI, &now_tai);
+	ASSERT_EQ(ret, 0, "tai_gettime");
+	now = ts_to_ns(&now_tai);
+
+	ASSERT_TRUE(now > ts1, "tai_future_ts1");
+	ASSERT_TRUE(now > ts2, "tai_future_ts2");
+
+	/* Check for reasonable range */
+	ASSERT_TRUE(now - ts1 < TAI_THRESHOLD, "tai_range_ts1");
+	ASSERT_TRUE(now - ts2 < TAI_THRESHOLD, "tai_range_ts2");
+
+	test_time_tai__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_time_tai.c b/tools/testing/selftests/bpf/progs/test_time_tai.c
new file mode 100644
index 000000000000..7ea0863f3ddb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_time_tai.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022 Linutronix GmbH */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("tc")
+int time_tai(struct __sk_buff *skb)
+{
+	__u64 ts1, ts2;
+
+	/* Get TAI timestamps */
+	ts1 = bpf_ktime_get_tai_ns();
+	ts2 = bpf_ktime_get_tai_ns();
+
+	/* Save TAI timestamps (Note: skb->hwtstamp is read-only) */
+	skb->tstamp = ts1;
+	skb->cb[0] = ts2 & 0xffffffff;
+	skb->cb[1] = ts2 >> 32;
+
+	return 0;
+}
-- 
2.30.2

