Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C2E449A3F
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241409AbhKHQtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240236AbhKHQt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 11:49:28 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C89C061766
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 08:46:44 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id t30so27996632wra.10
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 08:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xlkSwHvVis3zyKX1+l8yfQICPR58JdyZ7i+Tj5kci14=;
        b=RQavl9DV/rao3JSBjgSBDYTZJTgNPCHZlJaxjokErKWpcQ6KZbCSkHqlBM6loFtWjI
         mdzNyoNgNXheNCzCtSZHTGYdVFUzfgFVLJ/ytI2s7WufkmFs/g+RHOfnXOGB8irjn4Os
         qM3ussRRtvMjflmcotu0dmWpQxBNO/Pooa4RKuEWIG97tXZxWnmSHNaC31o4WOuPUqXE
         W4X4r+dhlqII0zrCR+jMmMfyD8xsikdocZ29pQkDfwvCC0/4hR8UbGzNeTeFPdOezHVI
         wHDT4rkfG/45Lc4HP79rGWBeJLJTqbfaeHLGrpG0iuqjiBOz0K/US4G4TVHSZPTq70Is
         9UqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xlkSwHvVis3zyKX1+l8yfQICPR58JdyZ7i+Tj5kci14=;
        b=ZnIj+vBuLtNM1EaNA5rbXCyPvRNIifGe8q4rIhEmZj5twxcNmPhsrQevNwztWdZMpp
         R6BDEGSdIJYj6l/jqd5naBHxmooFcQPiNr9wcSaYSwa/YvA46Nr7QZueGJ75En5ylIeF
         hxXdYaiq7C7GU1F9sj8QgO45WgEDYeiDjDnPs3bsPldUXsV1vVh3Wmdpsudc9aWQ/j9S
         hkf3g9gmH0e/3bULBUxd2O7+u47aQ2hoXVTKM06l0URdFiVC7sTf1xAdjx288c8WgfGN
         BbFltJKgQHot0rBfy2OPIalHRelW8psDkeHGvslsm1pqyi+sl8zFPebzGBHL261Ph5H6
         izZg==
X-Gm-Message-State: AOAM530ShPjIik3G0fe8qncjUCQ1xX3mCXWB1mZjEMCX/xrGqkC1c/Vs
        B0xChO6thvKq0hS/+X3XcJW1EQ==
X-Google-Smtp-Source: ABdhPJwa97ahpatI8qSOkX0vqsTX5mObmhSSUcKGQAhktWnbm7JODLZ9wlfC4Fx+FZcjsEvQvZfF+g==
X-Received: by 2002:a5d:5850:: with SMTP id i16mr584812wrf.197.1636390002789;
        Mon, 08 Nov 2021 08:46:42 -0800 (PST)
Received: from localhost ([91.75.210.37])
        by smtp.gmail.com with ESMTPSA id o2sm18176771wrg.1.2021.11.08.08.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 08:46:42 -0800 (PST)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, rdna@fb.com,
        john.stultz@linaro.org, sboyd@kernel.org, peterz@infradead.org,
        mark.rutland@arm.com, rosted@goodmis.org
Subject: [PATCH bpf 2/2] selftests/bpf: Add tests for allowed helpers
Date:   Mon,  8 Nov 2021 20:46:20 +0400
Message-Id: <20211108164620.407305-3-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211108164620.407305-1-me@ubique.spb.ru>
References: <20211108164620.407305-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests that bpf_ktime_get_coarse_ns() and bpf_timer_* and
bpf_spin_lock()/bpf_spin_unlock() helpers are forbidden in tracing
progs as it may result in various locking issues.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 tools/testing/selftests/bpf/test_verifier.c   |  36 +++-
 .../selftests/bpf/verifier/helper_allowed.c   | 196 ++++++++++++++++++
 2 files changed, 231 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/helper_allowed.c

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 25afe423b3f0..e16eab6fc3a9 100644
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
@@ -605,7 +606,7 @@ static int create_cgroup_storage(bool percpu)
  *   struct bpf_spin_lock l;
  * };
  */
-static const char btf_str_sec[] = "\0bpf_spin_lock\0val\0cnt\0l";
+static const char btf_str_sec[] = "\0bpf_spin_lock\0val\0cnt\0l\0bpf_timer\0";
 static __u32 btf_raw_types[] = {
 	/* int */
 	BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),  /* [1] */
@@ -616,6 +617,8 @@ static __u32 btf_raw_types[] = {
 	BTF_TYPE_ENC(15, BTF_INFO_ENC(BTF_KIND_STRUCT, 0, 2), 8),
 	BTF_MEMBER_ENC(19, 1, 0), /* int cnt; */
 	BTF_MEMBER_ENC(23, 2, 32),/* struct bpf_spin_lock l; */
+	/* struct bpf_timer */				/* [4] */
+	BTF_TYPE_ENC(25, BTF_INFO_ENC(BTF_KIND_STRUCT, 0, 0), 16),
 };
 
 static int load_btf(void)
@@ -696,6 +699,29 @@ static int create_sk_storage_map(void)
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
+		.btf_value_type_id = 4,
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
@@ -722,6 +748,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_event_output = test->fixup_map_event_output;
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
+	int *fixup_map_timer = test->fixup_map_timer;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -907,6 +934,13 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
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
diff --git a/tools/testing/selftests/bpf/verifier/helper_allowed.c b/tools/testing/selftests/bpf/verifier/helper_allowed.c
new file mode 100644
index 000000000000..aeba8ef866a9
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/helper_allowed.c
@@ -0,0 +1,196 @@
+{
+	"bpf_ktime_get_coarse_ns isn't allowed in BPF_PROG_TYPE_KPROBE",
+	.insns = {
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ktime_get_coarse_ns),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "helper call is not allowed in probe",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_KPROBE,
+},
+{
+	"bpf_ktime_get_coarse_ns isn't allowed in BPF_PROG_TYPE_TRACEPOINT",
+	.insns = {
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ktime_get_coarse_ns),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "helper call is not allowed in probe",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"bpf_ktime_get_coarse_ns isn't allowed in BPF_PROG_TYPE_PERF_EVENT",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ktime_get_coarse_ns),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "helper call is not allowed in probe",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+},
+{
+	"bpf_ktime_get_coarse_ns isn't allowed in BPF_PROG_TYPE_RAW_TRACEPOINT",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ktime_get_coarse_ns),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "helper call is not allowed in probe",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_RAW_TRACEPOINT,
+},
+{
+	"bpf_timer_init isn't allowed in BPF_PROG_TYPE_KPROBE",
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
+	.errstr = "helper call is not allowed in probe",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_KPROBE,
+},
+{
+	"bpf_timer_init isn't allowed in BPF_PROG_TYPE_PERF_EVENT",
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
+	.errstr = "helper call is not allowed in probe",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+},
+{
+	"bpf_timer_init isn't allowed in BPF_PROG_TYPE_TRACEPOINT",
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
+	.errstr = "helper call is not allowed in probe",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"bpf_timer_init isn't allowed in BPF_PROG_TYPE_RAW_TRACEPOINT",
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
+	.errstr = "helper call is not allowed in probe",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_RAW_TRACEPOINT,
+},
+{
+	"bpf_spin_lock isn't allowed in BPF_PROG_TYPE_KPROBE",
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
+	"bpf_spin_lock isn't allowed in BPF_PROG_TYPE_TRACEPOINT",
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
+	"bpf_spin_lock isn't allowed in BPF_PROG_TYPE_PERF_EVENT",
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
+	"bpf_spin_lock isn't allowed in BPF_PROG_TYPE_RAW_TRACEPOINT",
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

