Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2CB28563D
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 03:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgJGBXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 21:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgJGBXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 21:23:45 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080EDC0613D3
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 18:23:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id v6so294005plo.3
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 18:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=wF2FFu1dgNpdE0yU/Yio/eWj3yPuYo+n3vLnxYeYPa8=;
        b=C9nxvY17K2bLBW5hmhU3GQR3F27rRncCxl3H5TP9uKYbdY8lcvtNGVDBf5KHk/3iOa
         ZJOlLe3WypysziulYiz8BMD3X/IBYbCwe5Ov6J+n6GnPLts5eR0Rda6SfvBG5ThhPtcH
         htqvFkO5+gHYp8ClJT9GXGT1FNpeX0lp5YgRLYY//aweL+HMR5qibKkQPgM/RjLJfNFU
         y+TgQWYTUiNH/Fq7AqVUlqRaXD/6mlLrD0WT7drS89rTCVeQANJ6gjePD2AdF983fGga
         RUETbNEt8FgfFRq0Rg+EDle8XmymyAxAyDoj2TCCcwaaQ1rSzpdyyDFURZ9HV2lzi7CI
         6/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=wF2FFu1dgNpdE0yU/Yio/eWj3yPuYo+n3vLnxYeYPa8=;
        b=jsRx0180nienTiDVykLs99rdox7MHdJIBArRtKBftwVSpVX+xzivYZBrFxfrx378hK
         XimXn3C5RLG3WbVpuDplJ4P4GwoQqdvKL9LbMrwXv+v0rmGqEH2hHglSfIDYQIG0oc2P
         tdNpRs/3Q6PCyrfH8l0A2VcrKTNUxfFdjmlttiFcntbvd0+Rue8A/zFu5lnquMPNJ750
         5mXCy3+qF6RHOIRYGyFRwufUMfaR9M6UStXgqyKv4Rzjab7UY1rgDEMYXhWX0ULoVvD3
         ys0XWkbPqXrznYYBZp97b+0ft/hIDgNBsB9VnHUNYk+X2EiAPwSRwBEier5Ov01kWx87
         JhMw==
X-Gm-Message-State: AOAM530vBwMHquKUwsQEZf5+J9eAdbeRLQzp4pctXbILV56pDHzFbBvt
        3Jkl03znFb0Khad5VUigpTtv+2fo/6ecfG4g8L2j4dp+h8VJBMexN8tN2Hqr+Z3VrEmCqo0hqbN
        cj/SklsfKrIrewkEHBmtkDl2Fk6Na71zqw4Z7fsHJW5IQIeMEueNwKfePgXUBeA==
X-Google-Smtp-Source: ABdhPJw1jUqsBpGXTU9ryoiUplt+3ZSvQ3a3cAGyymZhms5SudCuSclpvwYEZ/vAj/OC9j4KVeWwZN3Nr7M=
Sender: "haoluo via sendgmr" <haoluo@haoluo.svl.corp.google.com>
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a62:1dd7:0:b029:154:dde2:ddcb with SMTP id
 d206-20020a621dd70000b0290154dde2ddcbmr749587pfd.30.1602033823275; Tue, 06
 Oct 2020 18:23:43 -0700 (PDT)
Date:   Tue,  6 Oct 2020 18:23:13 -0700
Message-Id: <20201007012313.2778426-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH v2] selftests/bpf: Fix test_verifier after introducing resolve_pseudo_ldimm64
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4976b718c355 ("bpf: Introduce pseudo_btf_id") switched
the order of check_subprogs() and resolve_pseudo_ldimm() in
the verifier. Now an empty prog expects to see the error "last
insn is not an the prog of a single invalid ldimm exit or jmp"
instead, because the check for subprogs comes first. It's now
pointless to validate that half of ldimm64 won't be the last
instruction.

Tested:
 # ./test_verifier
 Summary: 1129 PASSED, 537 SKIPPED, 0 FAILED
 and the full set of bpf selftests.

Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
Signed-off-by: Hao Luo <haoluo@google.com>
---
Changelog in v2:
 - Remove the original test_verifier ld_imm64 test4
 - Updated commit message.

 tools/testing/selftests/bpf/verifier/basic.c  |  2 +-
 .../testing/selftests/bpf/verifier/ld_imm64.c | 24 +++++++------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/basic.c b/tools/testing/selftests/bpf/verifier/basic.c
index b8d18642653a..de84f0d57082 100644
--- a/tools/testing/selftests/bpf/verifier/basic.c
+++ b/tools/testing/selftests/bpf/verifier/basic.c
@@ -2,7 +2,7 @@
 	"empty prog",
 	.insns = {
 	},
-	.errstr = "unknown opcode 00",
+	.errstr = "last insn is not an exit or jmp",
 	.result = REJECT,
 },
 {
diff --git a/tools/testing/selftests/bpf/verifier/ld_imm64.c b/tools/testing/selftests/bpf/verifier/ld_imm64.c
index 3856dba733e9..ed6a34991216 100644
--- a/tools/testing/selftests/bpf/verifier/ld_imm64.c
+++ b/tools/testing/selftests/bpf/verifier/ld_imm64.c
@@ -54,21 +54,13 @@
 	"test5 ld_imm64",
 	.insns = {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
-	},
-	.errstr = "invalid bpf_ld_imm64 insn",
-	.result = REJECT,
-},
-{
-	"test6 ld_imm64",
-	.insns = {
-	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
 	BPF_RAW_INSN(0, 0, 0, 0, 0),
 	BPF_EXIT_INSN(),
 	},
 	.result = ACCEPT,
 },
 {
-	"test7 ld_imm64",
+	"test6 ld_imm64",
 	.insns = {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
 	BPF_RAW_INSN(0, 0, 0, 0, 1),
@@ -78,7 +70,7 @@
 	.retval = 1,
 },
 {
-	"test8 ld_imm64",
+	"test7 ld_imm64",
 	.insns = {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 1, 1),
 	BPF_RAW_INSN(0, 0, 0, 0, 1),
@@ -88,7 +80,7 @@
 	.result = REJECT,
 },
 {
-	"test9 ld_imm64",
+	"test8 ld_imm64",
 	.insns = {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
 	BPF_RAW_INSN(0, 0, 0, 1, 1),
@@ -98,7 +90,7 @@
 	.result = REJECT,
 },
 {
-	"test10 ld_imm64",
+	"test9 ld_imm64",
 	.insns = {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
 	BPF_RAW_INSN(0, BPF_REG_1, 0, 0, 1),
@@ -108,7 +100,7 @@
 	.result = REJECT,
 },
 {
-	"test11 ld_imm64",
+	"test10 ld_imm64",
 	.insns = {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
 	BPF_RAW_INSN(0, 0, BPF_REG_1, 0, 1),
@@ -118,7 +110,7 @@
 	.result = REJECT,
 },
 {
-	"test12 ld_imm64",
+	"test11 ld_imm64",
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_1, 0),
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, BPF_REG_1, 0, 1),
@@ -129,7 +121,7 @@
 	.result = REJECT,
 },
 {
-	"test13 ld_imm64",
+	"test12 ld_imm64",
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_1, 0),
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, BPF_REG_1, 0, 1),
@@ -140,7 +132,7 @@
 	.result = REJECT,
 },
 {
-	"test14 ld_imm64: reject 2nd imm != 0",
+	"test13 ld_imm64: reject 2nd imm != 0",
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, BPF_REG_1,
-- 
2.28.0.806.g8561365e88-goog

