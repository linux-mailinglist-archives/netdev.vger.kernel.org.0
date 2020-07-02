Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CB8211FCF
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgGBJYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbgGBJYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:24:44 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04765C08C5DC
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 02:24:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id rk21so28483864ejb.2
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LR35ZONFqvTfXiXxkhKp6yxcMoqGVc/E3Abud1NeK8Y=;
        b=l+FdaDHobGBA+1TE62sOAm7FwBcfOburbn7o3aSubFjlXCvqBpI9M2xsUDypoyYjof
         GLROaoSveKa3TUDBdnMdyAqmdHOwWsY/Q6CpNMZV/LieTejQqofiNIqjprGeElIfhOvb
         FK4jWo76gRmK/jOJnbvABiBZnPjE6dRTz4T7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LR35ZONFqvTfXiXxkhKp6yxcMoqGVc/E3Abud1NeK8Y=;
        b=fnIDVAdeSEKwHE2TqzINIFHeMMfIF3Hm1T7wHik6y1XZ6iKGL6HQrQsQ27SFaQkiqH
         E7LgUWUbC6I5rdLITzgwTT77vLxQdt832yKO3bWVLNwsNiQCtW5PPAd6CRjRtWGnHBb+
         nlYHbjnUorqMuGGG5SGu4ipXBWMGY8/KQSled5l4kchDYdwYc1sNDxIH3Os3j0qw6WA7
         ZhScwBri3+I4qPzm2+Smh/0xB4qsW+0IPg5iFOjk2MFDKuM14nuugsXmkHJFL68cFyoQ
         +UvGacLkgU6rmXooACrd6ELE8qJxTAgxcsRkqAKkdtH6WvJe+ZkyHBfTOmO3C148nLIo
         WMBQ==
X-Gm-Message-State: AOAM532oMd2I7S39TPi58UH5DZS2zwavpkqLvHRwGPrrLnImzlVyEbdz
        62aU7pHU2xo4kjeErABdFZ5VSRJz4+h/QA==
X-Google-Smtp-Source: ABdhPJyHqEZ1GZxUAC22svX5T6FZnI92qI4W/m4xe0OW3xVJaKptUbOBANgMoJG1pc97GWw+9ns+Yw==
X-Received: by 2002:a17:906:1044:: with SMTP id j4mr26103397ejj.187.1593681882697;
        Thu, 02 Jul 2020 02:24:42 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id f17sm9078899edj.32.2020.07.02.02.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:24:42 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v3 14/16] selftests/bpf: Add verifier tests for bpf_sk_lookup context access
Date:   Thu,  2 Jul 2020 11:24:14 +0200
Message-Id: <20200702092416.11961-15-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200702092416.11961-1-jakub@cloudflare.com>
References: <20200702092416.11961-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exercise verifier access checks for bpf_sk_lookup context fields.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v3:
    - Consolidate ACCEPT tests into one.
    - Deduplicate REJECT tests and arrange them into logical groups.
    - Add tests for out-of-bounds and unaligned access.
    - Cover access to newly introduced 'sk' field.
    
    v2:
     - Adjust for fields renames in struct bpf_sk_lookup.

 .../selftests/bpf/verifier/ctx_sk_lookup.c    | 219 ++++++++++++++++++
 1 file changed, 219 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c

diff --git a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
new file mode 100644
index 000000000000..9542b07892ad
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
@@ -0,0 +1,219 @@
+{
+	"valid 4-byte read from bpf_sk_lookup",
+	.insns = {
+		/* 4-byte read from family field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family)),
+		/* 4-byte read from protocol field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, protocol)),
+		/* 4-byte read from remote_ip4 field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip4)),
+		/* 4-byte read from remote_ip6 field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6[0])),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6[1])),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6[2])),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6[3])),
+		/* 4-byte read from remote_port field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_port)),
+		/* 4-byte read from local_ip4 field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip4)),
+		/* 4-byte read from local_ip6 field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6[0])),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6[1])),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6[2])),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6[3])),
+		/* 4-byte read from local_port field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_port)),
+		/* 8-byte read from sk field */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, sk)),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+/* invalid size reads from a 4-byte field in bpf_sk_lookup */
+{
+	"invalid 8-byte read from bpf_sk_lookup family field",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 2-byte read from bpf_sk_lookup family field",
+	.insns = {
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 1-byte read from bpf_sk_lookup family field",
+	.insns = {
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+/* invalid size reads from an 8-byte field in bpf_sk_lookup */
+{
+	"invalid 4-byte read from bpf_sk_lookup sk field",
+	.insns = {
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, sk)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 2-byte read from bpf_sk_lookup sk field",
+	.insns = {
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, sk)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 1-byte read from bpf_sk_lookup sk field",
+	.insns = {
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, sk)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+/* out of bounds and unaligned reads from bpf_sk_lookup */
+{
+	"invalid 4-byte read past end of bpf_sk_lookup",
+	.insns = {
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    sizeof(struct bpf_sk_lookup)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 4-byte unaligned read from bpf_sk_lookup at odd offset",
+	.insns = {
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1, 1),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 4-byte unaligned read from bpf_sk_lookup at even offset",
+	.insns = {
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1, 2),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+/* writes to and out of bounds of bpf_sk_lookup */
+{
+	"invalid 8-byte write to bpf_sk_lookup",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0xcafe4a11U),
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 4-byte write to bpf_sk_lookup",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0xcafe4a11U),
+		BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 2-byte write to bpf_sk_lookup",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0xcafe4a11U),
+		BPF_STX_MEM(BPF_H, BPF_REG_1, BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 1-byte write to bpf_sk_lookup",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0xcafe4a11U),
+		BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 4-byte write past end of bpf_sk_lookup",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0xcafe4a11U),
+		BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+			    sizeof(struct bpf_sk_lookup)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
-- 
2.25.4

