Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D638657351E
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbiGMLPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236060AbiGMLO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:14:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4EDB100CF5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657710886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a+aE4ElkiLVX6Bh75bMcr/iPsxW7Ryr6p7928iEMT6Q=;
        b=FtzANAOJdFUuR/tc0LJMW9YJCHUVhWQztAN2DWmo716BDMbR//y0Y3WIYzWLkr/W3vjFUT
        xbyXBIw3NuVRcXUZfEDaMcpDQs6tMfj2snMc096GE+xyF8VTLVn1IHVN9YkHFpAO+v/mYu
        pTGOKmDZoUT8A5RBmSJcyNKqxDf1Yww=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-ZYHSxVi8NUOICqsQF9SsAg-1; Wed, 13 Jul 2022 07:14:45 -0400
X-MC-Unique: ZYHSxVi8NUOICqsQF9SsAg-1
Received: by mail-ej1-f70.google.com with SMTP id hq20-20020a1709073f1400b0072b9824f0a2so576536ejc.23
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a+aE4ElkiLVX6Bh75bMcr/iPsxW7Ryr6p7928iEMT6Q=;
        b=WTEms5DhU4YYbOIC/tvLaJDOBM/y3ws1pzZW1BIBOJQz8tyZpf141H3fDpIwlSM+mw
         A6LJA5SfgDPYisOL+27ggtIKwdof7m6N44BU51U9pTIHlgKeakjRRGuaYNpVFRZ+6od6
         7sHT1xkCyBIpLidP9BwqmnFv2lj3JyUSoTSJZC8LX1JnA70BsXaGCleXiCxTL94LW5uG
         Ow3KmDk1CORcpUM/t1nasVsQ+cKNczAGkRcfOpSJPFSLiVY1ncEdo+741V62E1Yi4Lyh
         O0ZpJQ3GL9IMfWYcjG++aiTM6U4E0ZNVZWxoXUiRCa6r+6nxxLx+TEUmP8DqKOynIi+c
         I8Hg==
X-Gm-Message-State: AJIora+3hnFc/jIAYkMysK2wneWAypJMKeQA/lHYvlLb/H5dw7uc+y4D
        apkLHybMol3wI07VbQzSFGazH1GzA1pFfxjh1aBPoyaDAv2FWeYDx7fhaY2MwJK6ucRHwYEN7Zc
        RN9RKIcIZJON6u8xX
X-Received: by 2002:a17:907:2c54:b0:72b:64bd:cbf7 with SMTP id hf20-20020a1709072c5400b0072b64bdcbf7mr2931134ejc.116.1657710884106;
        Wed, 13 Jul 2022 04:14:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v/qsgYjx2KM8l53apx0996JUN9j69dzlnwkriCAi9iDR9M0YcdcMfUlfqbDuOTpWhT5b+BxA==
X-Received: by 2002:a17:907:2c54:b0:72b:64bd:cbf7 with SMTP id hf20-20020a1709072c5400b0072b64bdcbf7mr2931091ejc.116.1657710883803;
        Wed, 13 Jul 2022 04:14:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e23-20020a170906315700b00726c0e60940sm4878256eje.100.2022.07.13.04.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:14:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1BB2D4D991C; Wed, 13 Jul 2022 13:14:40 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [RFC PATCH 15/17] selftests/bpf: Add verifier tests for dequeue prog
Date:   Wed, 13 Jul 2022 13:14:23 +0200
Message-Id: <20220713111430.134810-16-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Test various cases of direct packet access (proper range propagation,
comparison of packet pointers pointing into separate xdp_frames, and
correct invalidation on packet drop (so that multiple packet pointers
are usable safely in a dequeue program)).

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/test_verifier.c   |  29 +++-
 .../testing/selftests/bpf/verifier/dequeue.c  | 160 ++++++++++++++++++
 2 files changed, 180 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/dequeue.c

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index f9d553fbf68a..8d26ca96520b 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -55,7 +55,7 @@
 #define MAX_UNEXPECTED_INSNS	32
 #define MAX_TEST_INSNS	1000000
 #define MAX_FIXUPS	8
-#define MAX_NR_MAPS	23
+#define MAX_NR_MAPS	24
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
@@ -131,6 +131,7 @@ struct bpf_test {
 	int fixup_map_ringbuf[MAX_FIXUPS];
 	int fixup_map_timer[MAX_FIXUPS];
 	int fixup_map_kptr[MAX_FIXUPS];
+	int fixup_map_pifo[MAX_FIXUPS];
 	struct kfunc_btf_id_pair fixup_kfunc_btf_id[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
@@ -145,6 +146,7 @@ struct bpf_test {
 		ACCEPT,
 		REJECT,
 		VERBOSE_ACCEPT,
+		VERBOSE_REJECT,
 	} result, result_unpriv;
 	enum bpf_prog_type prog_type;
 	uint8_t flags;
@@ -546,11 +548,12 @@ static bool skip_unsupported_map(enum bpf_map_type map_type)
 
 static int __create_map(uint32_t type, uint32_t size_key,
 			uint32_t size_value, uint32_t max_elem,
-			uint32_t extra_flags)
+			uint32_t extra_flags, uint64_t map_extra)
 {
 	LIBBPF_OPTS(bpf_map_create_opts, opts);
 	int fd;
 
+	opts.map_extra = map_extra;
 	opts.map_flags = (type == BPF_MAP_TYPE_HASH ? BPF_F_NO_PREALLOC : 0) | extra_flags;
 	fd = bpf_map_create(type, NULL, size_key, size_value, max_elem, &opts);
 	if (fd < 0) {
@@ -565,7 +568,7 @@ static int __create_map(uint32_t type, uint32_t size_key,
 static int create_map(uint32_t type, uint32_t size_key,
 		      uint32_t size_value, uint32_t max_elem)
 {
-	return __create_map(type, size_key, size_value, max_elem, 0);
+	return __create_map(type, size_key, size_value, max_elem, 0, 0);
 }
 
 static void update_map(int fd, int index)
@@ -904,6 +907,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
 	int *fixup_map_timer = test->fixup_map_timer;
 	int *fixup_map_kptr = test->fixup_map_kptr;
+	int *fixup_map_pifo = test->fixup_map_pifo;
 	struct kfunc_btf_id_pair *fixup_kfunc_btf_id = test->fixup_kfunc_btf_id;
 
 	if (test->fill_helper) {
@@ -1033,7 +1037,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	if (*fixup_map_array_ro) {
 		map_fds[14] = __create_map(BPF_MAP_TYPE_ARRAY, sizeof(int),
 					   sizeof(struct test_val), 1,
-					   BPF_F_RDONLY_PROG);
+					   BPF_F_RDONLY_PROG, 0);
 		update_map(map_fds[14], 0);
 		do {
 			prog[*fixup_map_array_ro].imm = map_fds[14];
@@ -1043,7 +1047,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	if (*fixup_map_array_wo) {
 		map_fds[15] = __create_map(BPF_MAP_TYPE_ARRAY, sizeof(int),
 					   sizeof(struct test_val), 1,
-					   BPF_F_WRONLY_PROG);
+					   BPF_F_WRONLY_PROG, 0);
 		update_map(map_fds[15], 0);
 		do {
 			prog[*fixup_map_array_wo].imm = map_fds[15];
@@ -1052,7 +1056,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	}
 	if (*fixup_map_array_small) {
 		map_fds[16] = __create_map(BPF_MAP_TYPE_ARRAY, sizeof(int),
-					   1, 1, 0);
+					   1, 1, 0, 0);
 		update_map(map_fds[16], 0);
 		do {
 			prog[*fixup_map_array_small].imm = map_fds[16];
@@ -1068,7 +1072,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	}
 	if (*fixup_map_event_output) {
 		map_fds[18] = __create_map(BPF_MAP_TYPE_PERF_EVENT_ARRAY,
-					   sizeof(int), sizeof(int), 1, 0);
+					   sizeof(int), sizeof(int), 1, 0, 0);
 		do {
 			prog[*fixup_map_event_output].imm = map_fds[18];
 			fixup_map_event_output++;
@@ -1076,7 +1080,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	}
 	if (*fixup_map_reuseport_array) {
 		map_fds[19] = __create_map(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY,
-					   sizeof(u32), sizeof(u64), 1, 0);
+					   sizeof(u32), sizeof(u64), 1, 0, 0);
 		do {
 			prog[*fixup_map_reuseport_array].imm = map_fds[19];
 			fixup_map_reuseport_array++;
@@ -1104,6 +1108,13 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_kptr++;
 		} while (*fixup_map_kptr);
 	}
+	if (*fixup_map_pifo) {
+		map_fds[23] = __create_map(BPF_MAP_TYPE_PIFO_XDP, sizeof(u32), sizeof(u32), 1, 0, 8);
+		do {
+			prog[*fixup_map_pifo].imm = map_fds[23];
+			fixup_map_pifo++;
+		} while (*fixup_map_pifo);
+	}
 
 	/* Patch in kfunc BTF IDs */
 	if (fixup_kfunc_btf_id->kfunc) {
@@ -1490,7 +1501,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		       test->errstr_unpriv : test->errstr;
 
 	opts.expected_attach_type = test->expected_attach_type;
-	if (verbose)
+	if (verbose || expected_ret == VERBOSE_REJECT)
 		opts.log_level = VERBOSE_LIBBPF_LOG_LEVEL;
 	else if (expected_ret == VERBOSE_ACCEPT)
 		opts.log_level = 2;
diff --git a/tools/testing/selftests/bpf/verifier/dequeue.c b/tools/testing/selftests/bpf/verifier/dequeue.c
new file mode 100644
index 000000000000..730f14395bcc
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/dequeue.c
@@ -0,0 +1,160 @@
+{
+	"dequeue: non-xdp_md retval",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_MOV64_REG(BPF_REG_4, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_4, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_dequeue),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct xdp_md, data)),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_DEQUEUE,
+	.result = REJECT,
+	.errstr = "At program exit the register R0 must be NULL or referenced ptr_xdp_md",
+	.fixup_map_pifo = { 1 },
+},
+{
+	"dequeue: NULL retval",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.runs = -1,
+	.prog_type = BPF_PROG_TYPE_DEQUEUE,
+	.result = ACCEPT,
+},
+{
+	"dequeue: cannot access except data, data_end, data_meta",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_MOV64_REG(BPF_REG_4, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_4, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_dequeue),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, offsetof(struct xdp_md, data_end)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, offsetof(struct xdp_md, ingress_ifindex)),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_DEQUEUE,
+	.result = REJECT,
+	.errstr = "no read support for xdp_md at off 12",
+	.fixup_map_pifo = { 1 },
+},
+{
+	"dequeue: pkt_uid preserved when resetting range on rX += var",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_MOV64_REG(BPF_REG_4, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_4, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_dequeue),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_6, offsetof(struct dequeue_ctx, egress_ifindex)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct xdp_md, data)),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_DEQUEUE,
+	.result = VERBOSE_REJECT,
+	.errstr = "13: (0f) r0 += r1                     ; R0_w=pkt(id=3,off=0,r=0,pkt_uid=2",
+	.fixup_map_pifo = { 1 },
+},
+{
+	"dequeue: dpa bad comparison",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_MOV64_REG(BPF_REG_4, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_4, 0, 0),
+	BPF_MOV64_REG(BPF_REG_8, BPF_REG_4),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_dequeue),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_MOV64_REG(BPF_REG_4, BPF_REG_8),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_dequeue),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_REG(BPF_REG_0, BPF_REG_7),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_8, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_7, offsetof(struct xdp_md, data_end)),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 8),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_0, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_7),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_drop),
+	BPF_MOV64_REG(BPF_REG_0, BPF_REG_8),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_DEQUEUE,
+	.result = REJECT,
+	.errstr = "R0, R1 pkt pointer comparison prohibited",
+	.fixup_map_pifo = { 1, 14 },
+},
+{
+	"dequeue: dpa scoped range propagation",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_MOV64_REG(BPF_REG_4, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_4, 0, 0),
+	BPF_MOV64_REG(BPF_REG_8, BPF_REG_4),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_dequeue),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_MOV64_REG(BPF_REG_4, BPF_REG_8),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_dequeue),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_REG(BPF_REG_0, BPF_REG_7),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_8, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_8, offsetof(struct xdp_md, data_end)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_7, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_7, offsetof(struct xdp_md, data_end)),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 8),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_0, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_2, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_7),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_drop),
+	BPF_MOV64_REG(BPF_REG_0, BPF_REG_8),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_DEQUEUE,
+	.result = REJECT,
+	.errstr = "invalid access to packet, off=0 size=4, R2(id=0,off=0,r=0)",
+	.fixup_map_pifo = { 1, 14 },
+},
-- 
2.37.0

