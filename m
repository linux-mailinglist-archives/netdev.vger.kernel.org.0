Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702C944F3A9
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 15:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhKMOZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 09:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbhKMOZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 09:25:44 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB01C061766
        for <netdev@vger.kernel.org>; Sat, 13 Nov 2021 06:22:52 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id f7-20020a1c1f07000000b0032ee11917ceso8914372wmf.0
        for <netdev@vger.kernel.org>; Sat, 13 Nov 2021 06:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ohtjqb3x5Xyy6B+MrRARkUs4w/NnDceCyfWibLKdM2M=;
        b=S0kOctuDuoIy5tEQIXBa4IVLg1U2XvTLQJugS8gzAt5v95Aaw4V0kfbH3BE3Yg3aFN
         mlISYypAR1rYo04xgsGHPw0rtkFkCskBr5kOzN0wEwJ//8xQd3Rha+IUIvlGZranCOME
         22JDxk1HO4EIx33fQAaLiYqvLXMBRDCQ5HuR7UqqBOi0yp42hA77b2cL4ttn8eN9/dSg
         CY6vqN7qNtc2V/ZP5jMJFiPqU78lFqA9jef+TeZAM0AFIRpu38Cy9xbcERVkcBlbbvqM
         cqrK+iBn9QPswG80+8rb7D6emmk+81kVB9MCbDDJVJtJVqYfCCa8dBRUbCQw8XbHw0LG
         /23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ohtjqb3x5Xyy6B+MrRARkUs4w/NnDceCyfWibLKdM2M=;
        b=SQlid3stDIYSQopYx5VuCxzjJy+ovC0WBQvH5zWP+9pcSA0tnmldpxeWM8G4lRyypk
         JziYFoqqZF8sSF/yZlCbBHiYsGAmVgcx8Hj7DzyZdUY+P6XAURZQWyZRgHtYaRIuuUuT
         NC3ibzmRX6hCBYqv9Oh2n/DC9wZTF3cXHXU1Lu4NyXhd4aJGAGPnlJAlA4Tkw9IgSykb
         6w9C9mEbNVDWYOgiI7yIHGM48xqG+Gnk4/4aYKre5eLjg3JFNWFEd7hpteMq1daJzYLf
         RK4BvC3u5KRWRfQlg33N+WsjqqBeLiC8Y8Qqn0cciB7O7nVZM0bUXYg/ZTUovcXET+HU
         eyew==
X-Gm-Message-State: AOAM533CQKYoLSvhToVvGDWJq4cON12ZPS2aEZhKqio9hmDukwd21u3i
        8x/g2Jps8rMH4mpek/4E61PY9A==
X-Google-Smtp-Source: ABdhPJwMpxzf3aJ2fICYHHhwImeldyv23MHlmd7lQvqRDzZ6cd9hlFTl9D2HEZr9KUYHQncyxT4tww==
X-Received: by 2002:a05:600c:a08:: with SMTP id z8mr27044621wmp.52.1636813368762;
        Sat, 13 Nov 2021 06:22:48 -0800 (PST)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id m20sm15896179wmq.11.2021.11.13.06.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 06:22:48 -0800 (PST)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, tglx@linutronix.de,
        rdna@fb.com
Subject: [PATCH bpf v2 2/2] selftests/bpf: Add tests for restricted helpers
Date:   Sat, 13 Nov 2021 18:22:27 +0400
Message-Id: <20211113142227.566439-3-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211113142227.566439-1-me@ubique.spb.ru>
References: <20211113142227.566439-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests that bpf_ktime_get_coarse_ns(), bpf_timer_* and
bpf_spin_lock()/bpf_spin_unlock() helpers are forbidden in tracing progs
as their use there may result in various locking issues.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 .../bpf/prog_tests/helper_restricted.c        |  33 +++
 .../bpf/progs/test_helper_restricted.c        | 123 +++++++++++
 tools/testing/selftests/bpf/test_verifier.c   |  46 +++-
 .../bpf/verifier/helper_restricted.c          | 196 ++++++++++++++++++
 4 files changed, 397 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/helper_restricted.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_helper_restricted.c
 create mode 100644 tools/testing/selftests/bpf/verifier/helper_restricted.c

diff --git a/tools/testing/selftests/bpf/prog_tests/helper_restricted.c b/tools/testing/selftests/bpf/prog_tests/helper_restricted.c
new file mode 100644
index 000000000000..e1de5f80c3b2
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/helper_restricted.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "test_helper_restricted.skel.h"
+
+void test_helper_restricted(void)
+{
+	int prog_i = 0, prog_cnt;
+	int duration = 0;
+
+	do {
+		struct test_helper_restricted *test;
+		int maybeOK;
+
+		test = test_helper_restricted__open();
+		if (!ASSERT_OK_PTR(test, "open"))
+			return;
+
+		prog_cnt = test->skeleton->prog_cnt;
+
+		for (int j = 0; j < prog_cnt; ++j) {
+			struct bpf_program *prog = *test->skeleton->progs[j].prog;
+
+			maybeOK = bpf_program__set_autoload(prog, prog_i == j);
+			ASSERT_OK(maybeOK, "set autoload");
+		}
+
+		maybeOK = test_helper_restricted__load(test);
+		CHECK(!maybeOK, test->skeleton->progs[prog_i].name, "helper isn't restricted");
+
+		test_helper_restricted__destroy(test);
+	} while (++prog_i < prog_cnt);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_helper_restricted.c b/tools/testing/selftests/bpf/progs/test_helper_restricted.c
new file mode 100644
index 000000000000..68d64c365f90
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_helper_restricted.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <time.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct timer {
+	struct bpf_timer t;
+};
+
+struct lock {
+	struct bpf_spin_lock l;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct timer);
+} timers SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct lock);
+} locks SEC(".maps");
+
+static int timer_cb(void *map, int *key, struct timer *timer)
+{
+	return 0;
+}
+
+static void timer_work(void)
+{
+	struct timer *timer;
+	const int key = 0;
+
+	timer  = bpf_map_lookup_elem(&timers, &key);
+	if (timer) {
+		bpf_timer_init(&timer->t, &timers, CLOCK_MONOTONIC);
+		bpf_timer_set_callback(&timer->t, timer_cb);
+		bpf_timer_start(&timer->t, 10E9, 0);
+		bpf_timer_cancel(&timer->t);
+	}
+}
+
+static void spin_lock_work(void)
+{
+	const int key = 0;
+	struct lock *lock;
+
+	lock = bpf_map_lookup_elem(&locks, &key);
+	if (lock) {
+		bpf_spin_lock(&lock->l);
+		bpf_spin_unlock(&lock->l);
+	}
+}
+
+SEC("raw_tp/sys_enter")
+int raw_tp_timer(void *ctx)
+{
+	timer_work();
+
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_nanosleep")
+int tp_timer(void *ctx)
+{
+	timer_work();
+
+	return 0;
+}
+
+SEC("kprobe/sys_nanosleep")
+int kprobe_timer(void *ctx)
+{
+	timer_work();
+
+	return 0;
+}
+
+SEC("perf_event")
+int perf_event_timer(void *ctx)
+{
+	timer_work();
+
+	return 0;
+}
+
+SEC("raw_tp/sys_enter")
+int raw_tp_spin_lock(void *ctx)
+{
+	spin_lock_work();
+
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_nanosleep")
+int tp_spin_lock(void *ctx)
+{
+	spin_lock_work();
+
+	return 0;
+}
+
+SEC("kprobe/sys_nanosleep")
+int kprobe_spin_lock(void *ctx)
+{
+	spin_lock_work();
+
+	return 0;
+}
+
+SEC("perf_event")
+int perf_event_spin_lock(void *ctx)
+{
+	spin_lock_work();
+
+	return 0;
+}
+
+const char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 25afe423b3f0..465ef3f112c0 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -92,6 +92,7 @@ struct bpf_test {
 	int fixup_map_event_output[MAX_FIXUPS];
 	int fixup_map_reuseport_array[MAX_FIXUPS];
 	int fixup_map_ringbuf[MAX_FIXUPS];
+	int fixup_map_timer[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
 	 * means no log verification.
@@ -604,8 +605,15 @@ static int create_cgroup_storage(bool percpu)
  *   int cnt;
  *   struct bpf_spin_lock l;
  * };
+ * struct bpf_timer {
+ *   __u64 :64;
+ *   __u64 :64;
+ * } __attribute__((aligned(8)));
+ * struct timer {
+ *   struct bpf_timer t;
+ * };
  */
-static const char btf_str_sec[] = "\0bpf_spin_lock\0val\0cnt\0l";
+static const char btf_str_sec[] = "\0bpf_spin_lock\0val\0cnt\0l\0bpf_timer\0timer\0t";
 static __u32 btf_raw_types[] = {
 	/* int */
 	BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),  /* [1] */
@@ -616,6 +624,11 @@ static __u32 btf_raw_types[] = {
 	BTF_TYPE_ENC(15, BTF_INFO_ENC(BTF_KIND_STRUCT, 0, 2), 8),
 	BTF_MEMBER_ENC(19, 1, 0), /* int cnt; */
 	BTF_MEMBER_ENC(23, 2, 32),/* struct bpf_spin_lock l; */
+	/* struct bpf_timer */                          /* [4] */
+	BTF_TYPE_ENC(25, BTF_INFO_ENC(BTF_KIND_STRUCT, 0, 0), 16),
+	/* struct timer */                              /* [5] */
+	BTF_TYPE_ENC(35, BTF_INFO_ENC(BTF_KIND_STRUCT, 0, 1), 16),
+	BTF_MEMBER_ENC(41, 4, 0), /* struct bpf_timer t; */
 };
 
 static int load_btf(void)
@@ -696,6 +709,29 @@ static int create_sk_storage_map(void)
 	return fd;
 }
 
+static int create_map_timer(void)
+{
+	struct bpf_create_map_attr attr = {
+		.name = "test_map",
+		.map_type = BPF_MAP_TYPE_ARRAY,
+		.key_size = 4,
+		.value_size = 16,
+		.max_entries = 1,
+		.btf_key_type_id = 1,
+		.btf_value_type_id = 5,
+	};
+	int fd, btf_fd;
+
+	btf_fd = load_btf();
+	if (btf_fd < 0)
+		return -1;
+	attr.btf_fd = btf_fd;
+	fd = bpf_create_map_xattr(&attr);
+	if (fd < 0)
+		printf("Failed to create map with timer\n");
+	return fd;
+}
+
 static char bpf_vlog[UINT_MAX >> 8];
 
 static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
@@ -722,6 +758,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_event_output = test->fixup_map_event_output;
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
+	int *fixup_map_timer = test->fixup_map_timer;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -907,6 +944,13 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_ringbuf++;
 		} while (*fixup_map_ringbuf);
 	}
+	if (*fixup_map_timer) {
+		map_fds[21] = create_map_timer();
+		do {
+			prog[*fixup_map_timer].imm = map_fds[21];
+			fixup_map_timer++;
+		} while (*fixup_map_timer);
+	}
 }
 
 struct libcap {
diff --git a/tools/testing/selftests/bpf/verifier/helper_restricted.c b/tools/testing/selftests/bpf/verifier/helper_restricted.c
new file mode 100644
index 000000000000..a067b7098b97
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/helper_restricted.c
@@ -0,0 +1,196 @@
+{
+	"bpf_ktime_get_coarse_ns is forbidden in BPF_PROG_TYPE_KPROBE",
+	.insns = {
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ktime_get_coarse_ns),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "unknown func bpf_ktime_get_coarse_ns",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_KPROBE,
+},
+{
+	"bpf_ktime_get_coarse_ns is forbidden in BPF_PROG_TYPE_TRACEPOINT",
+	.insns = {
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ktime_get_coarse_ns),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "unknown func bpf_ktime_get_coarse_ns",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"bpf_ktime_get_coarse_ns is forbidden in BPF_PROG_TYPE_PERF_EVENT",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ktime_get_coarse_ns),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "unknown func bpf_ktime_get_coarse_ns",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+},
+{
+	"bpf_ktime_get_coarse_ns is forbidden in BPF_PROG_TYPE_RAW_TRACEPOINT",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ktime_get_coarse_ns),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "unknown func bpf_ktime_get_coarse_ns",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_RAW_TRACEPOINT,
+},
+{
+	"bpf_timer_init isn restricted in BPF_PROG_TYPE_KPROBE",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 4),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 1),
+	BPF_EMIT_CALL(BPF_FUNC_timer_init),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_timer = { 3, 8 },
+	.errstr = "tracing progs cannot use bpf_timer yet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_KPROBE,
+},
+{
+	"bpf_timer_init is forbidden in BPF_PROG_TYPE_PERF_EVENT",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 4),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 1),
+	BPF_EMIT_CALL(BPF_FUNC_timer_init),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_timer = { 3, 8 },
+	.errstr = "tracing progs cannot use bpf_timer yet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+},
+{
+	"bpf_timer_init is forbidden in BPF_PROG_TYPE_TRACEPOINT",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 4),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 1),
+	BPF_EMIT_CALL(BPF_FUNC_timer_init),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_timer = { 3, 8 },
+	.errstr = "tracing progs cannot use bpf_timer yet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"bpf_timer_init is forbidden in BPF_PROG_TYPE_RAW_TRACEPOINT",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 4),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 1),
+	BPF_EMIT_CALL(BPF_FUNC_timer_init),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_timer = { 3, 8 },
+	.errstr = "tracing progs cannot use bpf_timer yet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_RAW_TRACEPOINT,
+},
+{
+	"bpf_spin_lock is forbidden in BPF_PROG_TYPE_KPROBE",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 2),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_spin_lock),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_spin_lock = { 3 },
+	.errstr = "tracing progs cannot use bpf_spin_lock yet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_KPROBE,
+},
+{
+	"bpf_spin_lock is forbidden in BPF_PROG_TYPE_TRACEPOINT",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 2),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_spin_lock),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_spin_lock = { 3 },
+	.errstr = "tracing progs cannot use bpf_spin_lock yet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"bpf_spin_lock is forbidden in BPF_PROG_TYPE_PERF_EVENT",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 2),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_spin_lock),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_spin_lock = { 3 },
+	.errstr = "tracing progs cannot use bpf_spin_lock yet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+},
+{
+	"bpf_spin_lock is forbidden in BPF_PROG_TYPE_RAW_TRACEPOINT",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 2),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_spin_lock),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_spin_lock = { 3 },
+	.errstr = "tracing progs cannot use bpf_spin_lock yet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_RAW_TRACEPOINT,
+},
-- 
2.25.1

