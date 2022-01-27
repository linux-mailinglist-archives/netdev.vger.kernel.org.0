Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CD949E8E7
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239385AbiA0RYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239348AbiA0RYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:24:54 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EACC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:24:54 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id d138-20020a1c1d90000000b0034e043aaac7so3818196wmd.5
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EmcVHXFNBQEm9/n632DcDHmCucKJfX8G1I+Eh4YcVmE=;
        b=KiIWQSv0fJbz9pDpdSx1ydg6IchIf6Etwf8ZyYDDJXFi3vKg+2Rf0DTfisbEhcZA4n
         29Tv7n/Yfp+zLvXu+kcQbD7eeDbHL53j9qKFDNjnn7dRczKJ/V6MfAaAS+YHnx2GkOS/
         EhsoIrWUVvXQAQtGQiihh/FVMek+0Gml06s+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EmcVHXFNBQEm9/n632DcDHmCucKJfX8G1I+Eh4YcVmE=;
        b=qPLeCrnmsKHHUReGdfnxs/Zi2iZjnFiuZAqutFjfyRz6kfC/qMvBg37hRxx1uPHYic
         EZz8WfLWA5hNN65+HJ5SS2eOikSN2AD5P3olQcpVVMU35sTMUztNyTMS3ZKVq3VMLpPa
         fpTnK+u1Z2f1PQyRMntf53Ov9AU+snQ5LUkJlpD751NIdTnBhXqu48nk1TO0V4bdQwSA
         1pecmr0ZUZW9DpZy8Z19GZo850Rw9KkX82pN3UFHInU5sSlhpQUbcDpqo2b5b28/6o51
         eiAwCR4iZsTM4a5C77gmOzGSTMfc4yIEmZ6beJGJWjEpEsQzTItCc8KZwcMmqUmjE95a
         cEdQ==
X-Gm-Message-State: AOAM531yVB6ARAya3Cqm6bQh3nu3WUiNwRizQgBBgn2FZ3JK33QFgJ43
        9jDmpPt6rf1rajKtoyBVzQi+zw==
X-Google-Smtp-Source: ABdhPJz09le3R1VhnUSlFYFGL+onrMUcxtfPo7bfZfmnihM/dyjLHdWVkJiNY8aER6XLXanrZ/Dwjw==
X-Received: by 2002:a05:600c:8a9:: with SMTP id l41mr4209772wmp.51.1643304292518;
        Thu, 27 Jan 2022 09:24:52 -0800 (PST)
Received: from cloudflare.com ([2a01:110f:4809:d800::e00])
        by smtp.gmail.com with ESMTPSA id j13sm2601980wrw.116.2022.01.27.09.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 09:24:52 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next 2/2] selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads
Date:   Thu, 27 Jan 2022 18:24:48 +0100
Message-Id: <20220127172448.155686-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127172448.155686-1-jakub@cloudflare.com>
References: <20220127172448.155686-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add coverage to the verifier tests and tests for reading bpf_sock fields to
ensure that 32-bit, 16-bit, and 8-bit loads from dst_port field are allowed
only at intended offsets and produce expected values.

While 16-bit and 8-bit access to dst_port field is straight-forward, 32-bit
wide loads need be allowed and produce a zero-padded 16-bit value for
backward compatibility.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/include/uapi/linux/bpf.h                |  3 +-
 .../selftests/bpf/prog_tests/sock_fields.c    | 58 +++++++++----
 .../selftests/bpf/progs/test_sock_fields.c    | 41 ++++++++++
 tools/testing/selftests/bpf/verifier/sock.c   | 81 ++++++++++++++++++-
 4 files changed, 162 insertions(+), 21 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4a2f7041ebae..027e84b18b51 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5574,7 +5574,8 @@ struct bpf_sock {
 	__u32 src_ip4;
 	__u32 src_ip6[4];
 	__u32 src_port;		/* host byte order */
-	__u32 dst_port;		/* network byte order */
+	__be16 dst_port;	/* network byte order */
+	__u16 zero_padding;
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
diff --git a/tools/testing/selftests/bpf/prog_tests/sock_fields.c b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
index 9fc040eaa482..9d211b5c22c4 100644
--- a/tools/testing/selftests/bpf/prog_tests/sock_fields.c
+++ b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
@@ -1,9 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
 
+#define _GNU_SOURCE
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <unistd.h>
+#include <sched.h>
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
@@ -20,6 +22,7 @@
 enum bpf_linum_array_idx {
 	EGRESS_LINUM_IDX,
 	INGRESS_LINUM_IDX,
+	READ_SK_DST_PORT_LINUM_IDX,
 	__NR_BPF_LINUM_ARRAY_IDX,
 };
 
@@ -42,8 +45,16 @@ static __u64 child_cg_id;
 static int linum_map_fd;
 static __u32 duration;
 
-static __u32 egress_linum_idx = EGRESS_LINUM_IDX;
-static __u32 ingress_linum_idx = INGRESS_LINUM_IDX;
+static bool create_netns(void)
+{
+	if (!ASSERT_OK(unshare(CLONE_NEWNET), "create netns"))
+		return false;
+
+	if (!ASSERT_OK(system("ip link set dev lo up"), "bring up lo"))
+		return false;
+
+	return true;
+}
 
 static void print_sk(const struct bpf_sock *sk, const char *prefix)
 {
@@ -91,19 +102,24 @@ static void check_result(void)
 {
 	struct bpf_tcp_sock srv_tp, cli_tp, listen_tp;
 	struct bpf_sock srv_sk, cli_sk, listen_sk;
-	__u32 ingress_linum, egress_linum;
+	__u32 idx, ingress_linum, egress_linum, linum;
 	int err;
 
-	err = bpf_map_lookup_elem(linum_map_fd, &egress_linum_idx,
-				  &egress_linum);
+	idx = EGRESS_LINUM_IDX;
+	err = bpf_map_lookup_elem(linum_map_fd, &idx, &egress_linum);
 	CHECK(err < 0, "bpf_map_lookup_elem(linum_map_fd)",
 	      "err:%d errno:%d\n", err, errno);
 
-	err = bpf_map_lookup_elem(linum_map_fd, &ingress_linum_idx,
-				  &ingress_linum);
+	idx = INGRESS_LINUM_IDX;
+	err = bpf_map_lookup_elem(linum_map_fd, &idx, &ingress_linum);
 	CHECK(err < 0, "bpf_map_lookup_elem(linum_map_fd)",
 	      "err:%d errno:%d\n", err, errno);
 
+	idx = READ_SK_DST_PORT_LINUM_IDX;
+	err = bpf_map_lookup_elem(linum_map_fd, &idx, &linum);
+	ASSERT_OK(err, "bpf_map_lookup_elem(linum_map_fd, READ_SK_DST_PORT_IDX)");
+	ASSERT_EQ(linum, 0, "failure in read_sk_dst_port on line");
+
 	memcpy(&srv_sk, &skel->bss->srv_sk, sizeof(srv_sk));
 	memcpy(&srv_tp, &skel->bss->srv_tp, sizeof(srv_tp));
 	memcpy(&cli_sk, &skel->bss->cli_sk, sizeof(cli_sk));
@@ -262,7 +278,7 @@ static void test(void)
 	char buf[DATA_LEN];
 
 	/* Prepare listen_fd */
-	listen_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
+	listen_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0xcafe, 0);
 	/* start_server() has logged the error details */
 	if (CHECK_FAIL(listen_fd == -1))
 		goto done;
@@ -330,8 +346,12 @@ static void test(void)
 
 void serial_test_sock_fields(void)
 {
-	struct bpf_link *egress_link = NULL, *ingress_link = NULL;
 	int parent_cg_fd = -1, child_cg_fd = -1;
+	struct bpf_link *link;
+
+	/* Use a dedicated netns to have a fixed listen port */
+	if (!create_netns())
+		return;
 
 	/* Create a cgroup, get fd, and join it */
 	parent_cg_fd = test__join_cgroup(PARENT_CGROUP);
@@ -352,15 +372,20 @@ void serial_test_sock_fields(void)
 	if (CHECK(!skel, "test_sock_fields__open_and_load", "failed\n"))
 		goto done;
 
-	egress_link = bpf_program__attach_cgroup(skel->progs.egress_read_sock_fields,
-						 child_cg_fd);
-	if (!ASSERT_OK_PTR(egress_link, "attach_cgroup(egress)"))
+	link = bpf_program__attach_cgroup(skel->progs.egress_read_sock_fields, child_cg_fd);
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(egress_read_sock_fields)"))
+		goto done;
+	skel->links.egress_read_sock_fields = link;
+
+	link = bpf_program__attach_cgroup(skel->progs.ingress_read_sock_fields, child_cg_fd);
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(ingress_read_sock_fields)"))
 		goto done;
+	skel->links.ingress_read_sock_fields = link;
 
-	ingress_link = bpf_program__attach_cgroup(skel->progs.ingress_read_sock_fields,
-						  child_cg_fd);
-	if (!ASSERT_OK_PTR(ingress_link, "attach_cgroup(ingress)"))
+	link = bpf_program__attach_cgroup(skel->progs.read_sk_dst_port, child_cg_fd);
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(read_sk_dst_port"))
 		goto done;
+	skel->links.read_sk_dst_port = link;
 
 	linum_map_fd = bpf_map__fd(skel->maps.linum_map);
 	sk_pkt_out_cnt_fd = bpf_map__fd(skel->maps.sk_pkt_out_cnt);
@@ -369,8 +394,7 @@ void serial_test_sock_fields(void)
 	test();
 
 done:
-	bpf_link__destroy(egress_link);
-	bpf_link__destroy(ingress_link);
+	test_sock_fields__detach(skel);
 	test_sock_fields__destroy(skel);
 	if (child_cg_fd >= 0)
 		close(child_cg_fd);
diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools/testing/selftests/bpf/progs/test_sock_fields.c
index 81b57b9aaaea..246f1f001813 100644
--- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
@@ -12,6 +12,7 @@
 enum bpf_linum_array_idx {
 	EGRESS_LINUM_IDX,
 	INGRESS_LINUM_IDX,
+	READ_SK_DST_PORT_LINUM_IDX,
 	__NR_BPF_LINUM_ARRAY_IDX,
 };
 
@@ -250,4 +251,44 @@ int ingress_read_sock_fields(struct __sk_buff *skb)
 	return CG_OK;
 }
 
+static __noinline bool sk_dst_port__load_word(struct bpf_sock *sk)
+{
+	__u32 *word = (__u32 *)&sk->dst_port;
+	return word[0] == bpf_htonl(0xcafe0000);
+}
+
+static __noinline bool sk_dst_port__load_half(struct bpf_sock *sk)
+{
+	__u16 *half = (__u16 *)&sk->dst_port;
+	return half[0] == bpf_htons(0xcafe);
+}
+
+static __noinline bool sk_dst_port__load_byte(struct bpf_sock *sk)
+{
+	__u8 *byte = (__u8 *)&sk->dst_port;
+	return byte[0] == 0xca && byte[1] == 0xfe;
+}
+
+SEC("cgroup_skb/egress")
+int read_sk_dst_port(struct __sk_buff *skb)
+{
+	__u32 linum, linum_idx;
+	struct bpf_sock *sk;
+
+	linum_idx = READ_SK_DST_PORT_LINUM_IDX;
+
+	sk = skb->sk;
+	if (!sk)
+		RET_LOG();
+
+	if (!sk_dst_port__load_word(sk))
+		RET_LOG();
+	if (!sk_dst_port__load_half(sk))
+		RET_LOG();
+	if (!sk_dst_port__load_byte(sk))
+		RET_LOG();
+
+	return CG_OK;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/verifier/sock.c b/tools/testing/selftests/bpf/verifier/sock.c
index ce13ece08d51..3d9d89c5fe65 100644
--- a/tools/testing/selftests/bpf/verifier/sock.c
+++ b/tools/testing/selftests/bpf/verifier/sock.c
@@ -121,7 +121,25 @@
 	.result = ACCEPT,
 },
 {
-	"sk_fullsock(skb->sk): sk->dst_port [narrow load]",
+	"sk_fullsock(skb->sk): sk->dst_port [word load] (backward compatibility)",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = ACCEPT,
+},
+{
+	"sk_fullsock(skb->sk): sk->dst_port [half load]",
 	.insns = {
 	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
@@ -139,7 +157,64 @@
 	.result = ACCEPT,
 },
 {
-	"sk_fullsock(skb->sk): sk->dst_port [load 2nd byte]",
+	"sk_fullsock(skb->sk): sk->dst_port [half load] (invalid)",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = REJECT,
+	.errstr = "invalid sock access",
+},
+{
+	"sk_fullsock(skb->sk): sk->dst_port [byte load]",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_B, BPF_REG_2, BPF_REG_0, offsetof(struct bpf_sock, dst_port)),
+	BPF_LDX_MEM(BPF_B, BPF_REG_2, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 1),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = ACCEPT,
+},
+{
+	"sk_fullsock(skb->sk): sk->dst_port [byte load] (invalid)",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = REJECT,
+	.errstr = "invalid sock access",
+},
+{
+	"sk_fullsock(skb->sk): sk->zero_padding [half load] (invalid)",
 	.insns = {
 	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
@@ -149,7 +224,7 @@
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
-	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 1),
+	BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, zero_padding)),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-- 
2.31.1

