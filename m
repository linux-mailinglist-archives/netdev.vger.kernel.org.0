Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1475355A5
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiEZVgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349161AbiEZVgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:36:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A158E7334;
        Thu, 26 May 2022 14:36:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99DC761BA2;
        Thu, 26 May 2022 21:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7593CC385A9;
        Thu, 26 May 2022 21:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600965;
        bh=QBDH/NNQ0Q74djS5j/7fbHVhvNiX8WyG+mpypl7OxKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuRNKxOxjABTEr0MYEtpKDSjYT/UtAfo5k6LC2HjYVT3b/1Z1VnPcW9PRA354vei6
         bT9xxoXxM6tzuRgaKzGjbJO0kMeMj+KA81mrt8xpMDsTQ5Ev4/ZWKTlhp/fRgICfJm
         HacqqEvPj0sjGNt3KVnO/AdnyOgLNLkavOYEWmPN7bIXD6zx4NID0Zr6OsP1HNon2N
         1GeBeMvlt+/6nAnowOqL8hPZaTMr1O8brh+Da+b+ZlFMegPP/RAVxDWKyqG6zMchfg
         rtDZLyvVHalSP52wXzGRs1IWpcNkkG/to1oSLz6s7hR6jM2Ngteih/zuClPhrywHa9
         9vgT1CVxgDBMg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 10/14] selftests/bpf: Add verifier tests for rdonly PTR_TO_BTF_ID
Date:   Thu, 26 May 2022 23:34:58 +0200
Message-Id: <4c2d2a3a44ea34ea21939f2f345687195f9e9fad.1653600578.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653600577.git.lorenzo@kernel.org>
References: <cover.1653600577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Add matching verifier tests which ensure the read only flag is set and
handled appropriately.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/testing/selftests/bpf/test_verifier.c   |  17 +-
 .../testing/selftests/bpf/verifier/map_kptr.c | 156 ++++++++++++++++++
 2 files changed, 169 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 372579c9f45e..9728f87e5a40 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -626,6 +626,8 @@ static int create_cgroup_storage(bool percpu)
  *   struct prog_test_ref_kfunc __kptr *ptr;
  *   struct prog_test_ref_kfunc __kptr_ref *ptr;
  *   struct prog_test_member __kptr_ref *ptr;
+ *   const struct prog_test_ref_kfunc __kptr *ptr;
+ *   const struct prog_test_ref_kfunc __kptr_ref *ptr;
  * }
  */
 static const char btf_str_sec[] = "\0bpf_spin_lock\0val\0cnt\0l\0bpf_timer\0timer\0t"
@@ -657,11 +659,18 @@ static __u32 btf_raw_types[] = {
 	BTF_PTR_ENC(8),					/* [11] */
 	BTF_PTR_ENC(9),					/* [12] */
 	BTF_PTR_ENC(10),				/* [13] */
-	/* struct btf_ptr */				/* [14] */
-	BTF_STRUCT_ENC(43, 3, 24),
+	BTF_CONST_ENC(6),				/* [14] */
+	BTF_TYPE_TAG_ENC(75, 14),			/* [15] */
+	BTF_TYPE_TAG_ENC(80, 14),			/* [16] */
+	BTF_PTR_ENC(15),				/* [17] */
+	BTF_PTR_ENC(16),				/* [18] */
+	/* struct btf_ptr */				/* [19] */
+	BTF_STRUCT_ENC(43, 5, 40),
 	BTF_MEMBER_ENC(71, 11, 0), /* struct prog_test_ref_kfunc __kptr *ptr; */
 	BTF_MEMBER_ENC(71, 12, 64), /* struct prog_test_ref_kfunc __kptr_ref *ptr; */
 	BTF_MEMBER_ENC(71, 13, 128), /* struct prog_test_member __kptr_ref *ptr; */
+	BTF_MEMBER_ENC(71, 17, 192), /* const struct prog_test_ref_kfunc __kptr *ptr; */
+	BTF_MEMBER_ENC(71, 18, 256), /* const struct prog_test_ref_kfunc __kptr_ref *ptr; */
 };
 
 static int load_btf(void)
@@ -755,7 +764,7 @@ static int create_map_kptr(void)
 {
 	LIBBPF_OPTS(bpf_map_create_opts, opts,
 		.btf_key_type_id = 1,
-		.btf_value_type_id = 14,
+		.btf_value_type_id = 19,
 	);
 	int fd, btf_fd;
 
@@ -764,7 +773,7 @@ static int create_map_kptr(void)
 		return -1;
 
 	opts.btf_fd = btf_fd;
-	fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, "test_map", 4, 24, 1, &opts);
+	fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, "test_map", 4, 40, 1, &opts);
 	if (fd < 0)
 		printf("Failed to create map with btf_id pointer\n");
 	return fd;
diff --git a/tools/testing/selftests/bpf/verifier/map_kptr.c b/tools/testing/selftests/bpf/verifier/map_kptr.c
index 6914904344c0..666c78969478 100644
--- a/tools/testing/selftests/bpf/verifier/map_kptr.c
+++ b/tools/testing/selftests/bpf/verifier/map_kptr.c
@@ -197,6 +197,27 @@
 	.result = REJECT,
 	.errstr = "R0 invalid mem access 'untrusted_ptr_or_null_'",
 },
+{
+	"map_kptr: unref: loaded pointer to const marked as rdonly_untrusted",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 24),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_map_kptr = { 1 },
+	.result = REJECT,
+	.errstr = "R0 invalid mem access 'rdonly_untrusted_ptr_or_null_'",
+},
 {
 	"map_kptr: unref: correct in kernel type size",
 	.insns = {
@@ -315,6 +336,32 @@
 		{ "bpf_kfunc_call_test_kptr_get", 13 },
 	}
 },
+{
+	"map_kptr: unref: store const to non-const",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_STX_MEM(BPF_DW, BPF_REG_7, BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_map_kptr = { 1 },
+	.result = REJECT,
+	.errstr = "invalid kptr access, R0 type=rdonly_ptr_or_null_ expected=ptr_prog_test",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire_const", 11 },
+	}
+},
 /* Tests for referenced PTR_TO_BTF_ID */
 {
 	"map_kptr: ref: loaded pointer marked as untrusted",
@@ -338,6 +385,27 @@
 	.result = REJECT,
 	.errstr = "R1 type=untrusted_ptr_or_null_ expected=percpu_ptr_",
 },
+{
+	"map_kptr: ref: loaded pointer to const marked as rdonly_untrusted",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 32),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_map_kptr = { 1 },
+	.result = REJECT,
+	.errstr = "R0 invalid mem access 'rdonly_untrusted_ptr_or_null_'",
+},
 {
 	"map_kptr: ref: reject off != 0",
 	.insns = {
@@ -403,6 +471,34 @@
 		{ "bpf_kfunc_call_test_acquire", 15 },
 	}
 },
+{
+	"map_kptr: const ref: bpf_kfunc_call_test_kptr_get rejected",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_map_kptr = { 1 },
+	.result = REJECT,
+	.errstr = "arg#0 cannot raise reference for pointer to const",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_kptr_get", 14 },
+	}
+},
 {
 	"map_kptr: ref: reject STX",
 	.insns = {
@@ -467,3 +563,63 @@
 	.result = REJECT,
 	.errstr = "kptr cannot be accessed indirectly by helper",
 },
+{
+	"map_kptr: ref: xchg or_null const to non-const",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_7),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_kptr_xchg),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_map_kptr = { 1 },
+	.result = REJECT,
+	.errstr = "invalid kptr access, R2 type=rdonly_ptr_or_null_ expected=ptr_prog_test_ref_kfunc",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire_const", 11 },
+	}
+},
+{
+	"map_kptr: ref: xchg const to non-const",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_7),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_kptr_xchg),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_map_kptr = { 1 },
+	.result = REJECT,
+	.errstr = "invalid kptr access, R2 type=rdonly_ptr_ expected=ptr_prog_test_ref_kfunc",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire_const", 11 },
+	}
+},
-- 
2.35.3

