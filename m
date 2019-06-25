Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33CC9557F3
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbfFYTm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:42:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38140 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbfFYTm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:42:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so19242743wrs.5
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 12:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZdB0OOgZeSo7adZvFGacUPLeyw7eCaYz9WeweRqLIf8=;
        b=S4uMnzd19bSUsRYyNIYP5WbVxQNKhsopQUAwnkoykXFRrmW7umUHTg6V3UfY9ZulFV
         CK1v4i5cm9RbyiooH+EStb+V0GpLUWFLAJee0nxFFnqHYyC9XuKg1qQAvrCIT95ARpOW
         P8nFqctumaxP2GJLE0KaKa+uu/egiRVxbOLUU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZdB0OOgZeSo7adZvFGacUPLeyw7eCaYz9WeweRqLIf8=;
        b=F43JJCDPD60anhRsPnZA+FBA3gK+Z1oISB6H5UmXEvppzCEpm6SRxDUw6ljQKpYXUO
         xWJjpIBKdFTFQHy1fb9tR8XYsCg59G0tlOWimzpSlyKYCdZt4T++ns2aNFwmHmfi8bo0
         CJpe6W6qJIe1w6ZyFAiOy99wzo/lVT87bHyZ4b/uyBbKgbVoFZTF8YrKY+slVLASL07Z
         pJ9WHxmzvqjnry3v+mlKFjHoOk+JL6RE5C9vJ/I9dHXMrhOOnPJVKuoQ54wFqwbnqWJ3
         vTfoS4NTjKpPW/CQT00p0yzcPk+i4Ahyr/5/08t9ekY27LMtgMFokwbUYvUGx4bpFX++
         xYcw==
X-Gm-Message-State: APjAAAWUWOvDa5ewSNEjZ+EsbEVooqIy5SOtWQCMvq6w5QhznHwO18II
        l2smt5Qc5/ZqdPLP6pgBLwBIz6nlXyq2iQ==
X-Google-Smtp-Source: APXvYqywTqi0jBjwuiZMTvOseVVTsC5iGlHJLLancpLNgP2YtCrro0Kjghc9+CkAKTRAQejTtMJzzg==
X-Received: by 2002:a5d:51d1:: with SMTP id n17mr3048614wrv.52.1561491774111;
        Tue, 25 Jun 2019 12:42:54 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedb6.dynamic.kabel-deutschland.de. [95.90.237.182])
        by smtp.gmail.com with ESMTPSA id q193sm84991wme.8.2019.06.25.12.42.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 12:42:53 -0700 (PDT)
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
To:     netdev@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v2 09/10] selftests/bpf: Add tests for bpf_prog_test_run for perf events progs
Date:   Tue, 25 Jun 2019 21:42:14 +0200
Message-Id: <20190625194215.14927-10-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625194215.14927-1-krzesimir@kinvolk.io>
References: <20190625194215.14927-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tests check if ctx and data are correctly prepared from ctx_in and
data_in, so accessing the ctx and using the bpf_perf_prog_read_value
work as expected.

Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 tools/testing/selftests/bpf/test_verifier.c   | 48 ++++++++++
 .../selftests/bpf/verifier/perf_event_run.c   | 93 +++++++++++++++++++
 2 files changed, 141 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/perf_event_run.c

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 05bad54f481f..6fa962014b64 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -293,6 +293,54 @@ static void bpf_fill_scale(struct bpf_test *self)
 	}
 }
 
+static void bpf_fill_perf_event_test_run_check(struct bpf_test *self)
+{
+	compiletime_assert(
+		sizeof(struct bpf_perf_event_data) <= TEST_CTX_LEN,
+		"buffer for ctx is too short to fit struct bpf_perf_event_data");
+	compiletime_assert(
+		sizeof(struct bpf_perf_event_value) <= TEST_DATA_LEN,
+		"buffer for data is too short to fit struct bpf_perf_event_value");
+
+	struct bpf_perf_event_data ctx = {
+		.regs = (bpf_user_pt_regs_t) {
+			.r15 = 1,
+			.r14 = 2,
+			.r13 = 3,
+			.r12 = 4,
+			.rbp = 5,
+			.rbx = 6,
+			.r11 = 7,
+			.r10 = 8,
+			.r9 = 9,
+			.r8 = 10,
+			.rax = 11,
+			.rcx = 12,
+			.rdx = 13,
+			.rsi = 14,
+			.rdi = 15,
+			.orig_rax = 16,
+			.rip = 17,
+			.cs = 18,
+			.eflags = 19,
+			.rsp = 20,
+			.ss = 21,
+		},
+		.sample_period = 1,
+		.addr = 2,
+	};
+	struct bpf_perf_event_value data = {
+		.counter = 1,
+		.enabled = 2,
+		.running = 3,
+	};
+
+	memcpy(self->ctx, &ctx, sizeof(ctx));
+	memcpy(self->data, &data, sizeof(data));
+	free(self->fill_insns);
+	self->fill_insns = NULL;
+}
+
 /* BPF_SK_LOOKUP contains 13 instructions, if you need to fix up maps */
 #define BPF_SK_LOOKUP(func)						\
 	/* struct bpf_sock_tuple tuple = {} */				\
diff --git a/tools/testing/selftests/bpf/verifier/perf_event_run.c b/tools/testing/selftests/bpf/verifier/perf_event_run.c
new file mode 100644
index 000000000000..d451932a6fc0
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/perf_event_run.c
@@ -0,0 +1,93 @@
+#define PER_LOAD_AND_CHECK_PTREG(PT_REG_FIELD, VALUE)			\
+	PER_LOAD_AND_CHECK_CTX(offsetof(bpf_user_pt_regs_t, PT_REG_FIELD), VALUE)
+#define PER_LOAD_AND_CHECK_EVENT(PED_FIELD, VALUE)			\
+	PER_LOAD_AND_CHECK_CTX(offsetof(struct bpf_perf_event_data, PED_FIELD), VALUE)
+#define PER_LOAD_AND_CHECK_CTX(OFFSET, VALUE)				\
+	PER_LOAD_AND_CHECK_64(BPF_REG_4, BPF_REG_1, OFFSET, VALUE)
+#define PER_LOAD_AND_CHECK_VALUE(PEV_FIELD, VALUE)			\
+	PER_LOAD_AND_CHECK_64(BPF_REG_7, BPF_REG_6, offsetof(struct bpf_perf_event_value, PEV_FIELD), VALUE)
+#define PER_LOAD_AND_CHECK_64(DST, SRC, OFFSET, VALUE)			\
+	BPF_LDX_MEM(BPF_DW, DST, SRC, OFFSET),				\
+	BPF_JMP_IMM(BPF_JEQ, DST, VALUE, 2),				\
+	BPF_MOV64_IMM(BPF_REG_0, VALUE),				\
+	BPF_EXIT_INSN()
+
+{
+	"check if regs contain expected values",
+	.insns = {
+	PER_LOAD_AND_CHECK_PTREG(r15, 1),
+	PER_LOAD_AND_CHECK_PTREG(r14, 2),
+	PER_LOAD_AND_CHECK_PTREG(r13, 3),
+	PER_LOAD_AND_CHECK_PTREG(r12, 4),
+	PER_LOAD_AND_CHECK_PTREG(rbp, 5),
+	PER_LOAD_AND_CHECK_PTREG(rbx, 6),
+	PER_LOAD_AND_CHECK_PTREG(r11, 7),
+	PER_LOAD_AND_CHECK_PTREG(r10, 8),
+	PER_LOAD_AND_CHECK_PTREG(r9, 9),
+	PER_LOAD_AND_CHECK_PTREG(r8, 10),
+	PER_LOAD_AND_CHECK_PTREG(rax, 11),
+	PER_LOAD_AND_CHECK_PTREG(rcx, 12),
+	PER_LOAD_AND_CHECK_PTREG(rdx, 13),
+	PER_LOAD_AND_CHECK_PTREG(rsi, 14),
+	PER_LOAD_AND_CHECK_PTREG(rdi, 15),
+	PER_LOAD_AND_CHECK_PTREG(orig_rax, 16),
+	PER_LOAD_AND_CHECK_PTREG(rip, 17),
+	PER_LOAD_AND_CHECK_PTREG(cs, 18),
+	PER_LOAD_AND_CHECK_PTREG(eflags, 19),
+	PER_LOAD_AND_CHECK_PTREG(rsp, 20),
+	PER_LOAD_AND_CHECK_PTREG(ss, 21),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.ctx_len = sizeof(struct bpf_perf_event_data),
+	.data_len = sizeof(struct bpf_perf_event_value),
+	.fill_helper = bpf_fill_perf_event_test_run_check,
+},
+{
+	"check if sample period and addr contain expected values",
+	.insns = {
+	PER_LOAD_AND_CHECK_EVENT(sample_period, 1),
+	PER_LOAD_AND_CHECK_EVENT(addr, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.ctx_len = sizeof(struct bpf_perf_event_data),
+	.data_len = sizeof(struct bpf_perf_event_value),
+	.fill_helper = bpf_fill_perf_event_test_run_check,
+},
+{
+	"check if bpf_perf_prog_read_value returns expected data",
+	.insns = {
+	// allocate space for a struct bpf_perf_event_value
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, -(int)sizeof(struct bpf_perf_event_value)),
+	// prepare parameters for bpf_perf_prog_read_value(ctx, struct bpf_perf_event_value*, u32)
+	// BPF_REG_1 already contains the context
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
+	BPF_MOV64_IMM(BPF_REG_3, sizeof(struct bpf_perf_event_value)),
+	BPF_EMIT_CALL(BPF_FUNC_perf_prog_read_value),
+	// check the return value
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	// check if the fields match the expected values
+	PER_LOAD_AND_CHECK_VALUE(counter, 1),
+	PER_LOAD_AND_CHECK_VALUE(enabled, 2),
+	PER_LOAD_AND_CHECK_VALUE(running, 3),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.ctx_len = sizeof(struct bpf_perf_event_data),
+	.data_len = sizeof(struct bpf_perf_event_value),
+	.fill_helper = bpf_fill_perf_event_test_run_check,
+},
+#undef PER_LOAD_AND_CHECK_64
+#undef PER_LOAD_AND_CHECK_VALUE
+#undef PER_LOAD_AND_CHECK_CTX
+#undef PER_LOAD_AND_CHECK_EVENT
+#undef PER_LOAD_AND_CHECK_PTREG
-- 
2.20.1

