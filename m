Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B19D41783A3
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 21:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbgCCUFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 15:05:25 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42963 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgCCUFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 15:05:22 -0500
Received: by mail-qk1-f196.google.com with SMTP id e11so3957332qkg.9;
        Tue, 03 Mar 2020 12:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o30x3ibuWhJyxEBxWEXlcQWvqUNQ8HyrTeeqUA4s9C4=;
        b=dZV9Fxybj9K97PLk4iq3WMESAiSuvx10OceemZjnDCrWv/JHidkvj/4Yb5SsH0Kf2u
         RLevSqgZTaokQof70xhxKlF40ib2OYzm9HRbIGfLjwaejv5KKhQrN8zk2vjcQV91c/lb
         +DVaSOKY5MHmSe0eaRVp9tZIb1lrAmZF1vdhMI2YS4dyrYdwBPVKnn7rlMyJUl0NiesP
         l4JC1meke4p9kV41lzMZjLTOOztPMtGLrWGzkVePD4axjPVu06oXXZhzoqqAWNocBG+T
         av+5P1i6p8CcmMpcvlpMIOmAItRuWn1rpfmSG5DaUmRmp0KbkqEqMNMzMqjfZfNc8OeB
         2SNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o30x3ibuWhJyxEBxWEXlcQWvqUNQ8HyrTeeqUA4s9C4=;
        b=p3HjwRl0YIPvgW/ExDPS/A2EExbGuIByzU+GRV/fgEAawl9/0KfIkJWUSAx5E+CGox
         OanPna5q1y5FRCO5Gp79z1lSboOZg5BZx+5o7A/kzjuvIVt4dvvdT5FxUcyjat1S0eH0
         YLmVcReeZhQedW4BENagYiBirAj0MZbFDgy/+mXN6jJ1jDwiPu1GCXSpe973rVHHYJt9
         Ng87VjbeuB6V2i18IBxGufc0e6Go5bjxCH7dIK0+/DN2mAwjeF7sT2c6XQraoYFim6UU
         m6zPBWUJO8Pzin2g+opwJQpsIb3pEW/wXbYlPxuY7HleQ4nxn5Vrb1jk7xJb4RKSuLM3
         3b2g==
X-Gm-Message-State: ANhLgQ3srNJg8qRMLQHru9qLwwoNjhhu3h5wOlFkf2UTJgw4ST61h1Tc
        uZNtO/G9nizesXYTxjCSkbKjuXS5
X-Google-Smtp-Source: ADFU+vvyE1DadL24wzSEVozqYsVL2w19XKV3xO7D+OsEvuBrZfXsAR3X2dihTmHt1bq9GtEXfrsnMQ==
X-Received: by 2002:a37:5b81:: with SMTP id p123mr792107qkb.284.1583265921182;
        Tue, 03 Mar 2020 12:05:21 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:37b5:dd03:b905:30ea])
        by smtp.gmail.com with ESMTPSA id d7sm9846281qkg.62.2020.03.03.12.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 12:05:20 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH bpf-next 3/3] selftests/bpf: test new __sk_buff field gso_size
Date:   Tue,  3 Mar 2020 15:05:03 -0500
Message-Id: <20200303200503.226217-4-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
In-Reply-To: <20200303200503.226217-1-willemdebruijn.kernel@gmail.com>
References: <20200303200503.226217-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Analogous to the gso_segs selftests introduced in commit d9ff286a0f59
("bpf: allow BPF programs access skb_shared_info->gso_segs field").

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 .../selftests/bpf/prog_tests/skb_ctx.c        |  1 +
 .../selftests/bpf/progs/test_skb_ctx.c        |  2 +
 .../testing/selftests/bpf/verifier/ctx_skb.c  | 47 +++++++++++++++++++
 3 files changed, 50 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
index c6d6b685a946..4538bd08203f 100644
--- a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
+++ b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
@@ -14,6 +14,7 @@ void test_skb_ctx(void)
 		.wire_len = 100,
 		.gso_segs = 8,
 		.mark = 9,
+		.gso_size = 10,
 	};
 	struct bpf_prog_test_run_attr tattr = {
 		.data_in = &pkt_v4,
diff --git a/tools/testing/selftests/bpf/progs/test_skb_ctx.c b/tools/testing/selftests/bpf/progs/test_skb_ctx.c
index 202de3938494..b02ea589ce7e 100644
--- a/tools/testing/selftests/bpf/progs/test_skb_ctx.c
+++ b/tools/testing/selftests/bpf/progs/test_skb_ctx.c
@@ -23,6 +23,8 @@ int process(struct __sk_buff *skb)
 		return 1;
 	if (skb->gso_segs != 8)
 		return 1;
+	if (skb->gso_size != 10)
+		return 1;
 
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/verifier/ctx_skb.c b/tools/testing/selftests/bpf/verifier/ctx_skb.c
index d438193804b2..2e16b8e268f2 100644
--- a/tools/testing/selftests/bpf/verifier/ctx_skb.c
+++ b/tools/testing/selftests/bpf/verifier/ctx_skb.c
@@ -1010,6 +1010,53 @@
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
+{
+	"read gso_size from CGROUP_SKB",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+		    offsetof(struct __sk_buff, gso_size)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
+{
+	"read gso_size from CGROUP_SKB",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1,
+		    offsetof(struct __sk_buff, gso_size)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
+{
+	"write gso_size from CGROUP_SKB",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+		    offsetof(struct __sk_buff, gso_size)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.result_unpriv = REJECT,
+	.errstr = "invalid bpf_context access off=176 size=4",
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
+{
+	"read gso_size from CLS",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+		    offsetof(struct __sk_buff, gso_size)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+},
 {
 	"check wire_len is not readable by sockets",
 	.insns = {
-- 
2.25.0.265.gbab2e86ba0-goog

