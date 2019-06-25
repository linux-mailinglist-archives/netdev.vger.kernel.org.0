Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4416D557EE
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbfFYTnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:43:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41320 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729576AbfFYTm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:42:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so19208617wrm.8
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 12:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zL0HrEGZcpopHqyYMX9VRwzNkgb23WmEI/HU5IMtTxA=;
        b=BVEkDRbH+o3abT8tZJB6lbPIuysqa31NjxF8psYZadQqZoC3npMhwO3pkjA47Tw4Z8
         NF+zzCL8b8AmQrOt0o9xgWglRDk1vKqjauhGXgVmzpLdWVB+dJD5WSvf1PMneJGx5rTt
         /vwmmE0bUo6tbLaP/IZc6HPlpiVFaNCxLrjfI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zL0HrEGZcpopHqyYMX9VRwzNkgb23WmEI/HU5IMtTxA=;
        b=RuRuyrgiVjuTn+E70FtoZjY2XUzd8GxpQsSVvzE7fj7fPnBCMrZQDTFHI+S2J6OmOz
         2RWU2MLEso5sLoWFFlJQaOSI3uZrAB829yAbVs0hXZS5XG1s+t8g1pN61IAc3NcC/q+I
         w24pNYelQ4zMfeyYMFwy4ChsxGyB9ixt8aKmQWEsQ9UYO+qDD9Fk9/Y1ulRrrnEQRbjP
         9EutRdNBihbPCDsGHYA01ttIge9hHk4cR2TE5gyScq0bgPrIrBF5hE3HQkreFwi26zDm
         vs1hTEWJZVu4AzOOCI3lYCch07Px7kpw3IfzgsigtwHmoB+oXK1+ZxJKD2hn2PGsyaBN
         laWw==
X-Gm-Message-State: APjAAAVNN/dC7l78iXmXYY9Wf3Q1+PRZcvxYcHqUpcQM3DYj8GIfsJbk
        agAOWjNQmtTZmuVrfjtgcWjJVkFPFRQ/Lw==
X-Google-Smtp-Source: APXvYqw7ZhtPtJJKeACIFdzrIPq/5jZmewEt09VKOVwa/3AwdYJ9E78s6uTj9lixcfeh0NXc15N0yA==
X-Received: by 2002:adf:a345:: with SMTP id d5mr36952398wrb.234.1561491775190;
        Tue, 25 Jun 2019 12:42:55 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedb6.dynamic.kabel-deutschland.de. [95.90.237.182])
        by smtp.gmail.com with ESMTPSA id q193sm84991wme.8.2019.06.25.12.42.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 12:42:54 -0700 (PDT)
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
Subject: [bpf-next v2 10/10] selftests/bpf: Test correctness of narrow 32bit read on 64bit field
Date:   Tue, 25 Jun 2019 21:42:15 +0200
Message-Id: <20190625194215.14927-11-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625194215.14927-1-krzesimir@kinvolk.io>
References: <20190625194215.14927-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test the correctness of the 32bit narrow reads by reading both halves
of the 64 bit field and doing a binary or on them to see if we get the
original value.

It succeeds as it should, but with the commit e2f7fc0ac695 ("bpf: fix
undefined behavior in narrow load handling") reverted, the test fails
with a following message:

> $ sudo ./test_verifier
> ...
> #967/p 32bit loads of a 64bit field (both least and most significant words) FAIL retval -1985229329 != 0
> verification time 17 usec
> stack depth 0
> processed 8 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
> ...
> Summary: 1519 PASSED, 0 SKIPPED, 1 FAILED

Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 tools/testing/selftests/bpf/test_verifier.c   | 19 ++++++++++++++++++
 .../testing/selftests/bpf/verifier/var_off.c  | 20 +++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 6fa962014b64..444c1ea1e326 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -24,6 +24,7 @@
 
 #include <sys/capability.h>
 
+#include <linux/compiler.h>
 #include <linux/unistd.h>
 #include <linux/filter.h>
 #include <linux/bpf_perf_event.h>
@@ -341,6 +342,24 @@ static void bpf_fill_perf_event_test_run_check(struct bpf_test *self)
 	self->fill_insns = NULL;
 }
 
+static void bpf_fill_32bit_loads(struct bpf_test *self)
+{
+	compiletime_assert(
+		sizeof(struct bpf_perf_event_data) <= TEST_CTX_LEN,
+		"buffer for ctx is too short to fit struct bpf_perf_event_data");
+	compiletime_assert(
+		sizeof(struct bpf_perf_event_value) <= TEST_DATA_LEN,
+		"buffer for data is too short to fit struct bpf_perf_event_value");
+
+	struct bpf_perf_event_data ctx = {
+		.sample_period = 0x0123456789abcdef,
+	};
+
+	memcpy(self->ctx, &ctx, sizeof(ctx));
+	free(self->fill_insns);
+	self->fill_insns = NULL;
+}
+
 /* BPF_SK_LOOKUP contains 13 instructions, if you need to fix up maps */
 #define BPF_SK_LOOKUP(func)						\
 	/* struct bpf_sock_tuple tuple = {} */				\
diff --git a/tools/testing/selftests/bpf/verifier/var_off.c b/tools/testing/selftests/bpf/verifier/var_off.c
index 8504ac937809..14d222f37081 100644
--- a/tools/testing/selftests/bpf/verifier/var_off.c
+++ b/tools/testing/selftests/bpf/verifier/var_off.c
@@ -246,3 +246,23 @@
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
+{
+	"32bit loads of a 64bit field (both least and most significant words)",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1, offsetof(struct bpf_perf_event_data, sample_period)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_5, BPF_REG_1, offsetof(struct bpf_perf_event_data, sample_period) + 4),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1, offsetof(struct bpf_perf_event_data, sample_period)),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_5, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_4, BPF_REG_5),
+	BPF_ALU64_REG(BPF_XOR, BPF_REG_4, BPF_REG_6),
+	BPF_MOV64_REG(BPF_REG_0, BPF_REG_4),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.ctx = { 0, },
+	.ctx_len = sizeof(struct bpf_perf_event_data),
+	.data = { 0, },
+	.data_len = sizeof(struct bpf_perf_event_value),
+	.fill_helper = bpf_fill_32bit_loads,
+},
-- 
2.20.1

