Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A7062648
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403826AbfGHQcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:32:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50661 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391302AbfGHQcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:32:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so169191wml.0
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/djGN8HAFa0Qe2S92JYcPQLF+TKLfL6yZ4KqqnYg5ZY=;
        b=TV2o9ftDatxvZ1Naqph4aaWZ/G4ATmwqdVK/1bl8m5hVjBsVKTvm03MfKGpIA6FXkq
         ueOGpwc3RH2T1ckfwS4DEDJxqcXvzsj+3MEBikwAawCJMO4rNLdOCba0OmUyFuaQ5tWK
         thP7y3FyV/myim4Cr6LkzEynPAn/hitx9veU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/djGN8HAFa0Qe2S92JYcPQLF+TKLfL6yZ4KqqnYg5ZY=;
        b=WtEwicR8I1vVhgGK9aETV4M5JUEOnGjkS1z7OdHJ+IB1jjsZnVo5Km2AKM30cjBG4A
         BYq+UdnNTk3WJn5MfUf0LgBvlkYTJ3UjN6qRsIQxuJ7+XF5LNkjxH/OU3ELvLPLWKP6t
         F4JmngdwaoT5nygt30niQyRPn+pps6ebW0VI3/OJkvkV5tO4cpkQvB8Cc2COChcdCfrJ
         v8dcWH6AEX+p6yqPSMJpUxKCXWlni7HXQOLOiiFKtliZIJghXr2igSWHG2ZNmcC53bBB
         sVu7V7TOwI/TfLTOWZNoJ5sBx5G3W/saptnxW0bRg5EqMv5dz5NOtnyY2U6jm7jyckRE
         VjTw==
X-Gm-Message-State: APjAAAUDczrP3vpEamcoKKzJluhzRqLGyZLRsU2oueCY742mEo4lIOKB
        OzpB1nseTxphwCm0CcJsrmlZXw==
X-Google-Smtp-Source: APXvYqygSV8fYEBriB90aid/dziVjejXmPEUn++Hsvpp+mxZfwRWeb0Mn/9waunu837TVcLxeDLq8A==
X-Received: by 2002:a1c:a942:: with SMTP id s63mr17505499wme.76.1562603520152;
        Mon, 08 Jul 2019 09:32:00 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedbe.dynamic.kabel-deutschland.de. [95.90.237.190])
        by smtp.gmail.com with ESMTPSA id e6sm18255086wrw.23.2019.07.08.09.31.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 09:31:59 -0700 (PDT)
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
To:     linux-kernel@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v3 11/12] selftests/bpf: Add tests for bpf_prog_test_run for perf events progs
Date:   Mon,  8 Jul 2019 18:31:20 +0200
Message-Id: <20190708163121.18477-12-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190708163121.18477-1-krzesimir@kinvolk.io>
References: <20190708163121.18477-1-krzesimir@kinvolk.io>
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
 .../selftests/bpf/verifier/perf_event_run.c   | 96 +++++++++++++++++++
 2 files changed, 144 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/perf_event_run.c

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 6f124cc4ee34..484ea8842b06 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -295,6 +295,54 @@ static void bpf_fill_scale(struct bpf_test *self)
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
index 000000000000..3f877458a7f8
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/perf_event_run.c
@@ -0,0 +1,96 @@
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
+	.override_data_out_len = true,
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
+	.override_data_out_len = true,
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
+	.override_data_out_len = true,
+},
+#undef PER_LOAD_AND_CHECK_64
+#undef PER_LOAD_AND_CHECK_VALUE
+#undef PER_LOAD_AND_CHECK_CTX
+#undef PER_LOAD_AND_CHECK_EVENT
+#undef PER_LOAD_AND_CHECK_PTREG
-- 
2.20.1

