Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7113067F1
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbhA0XbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbhA0XaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 18:30:22 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D836C061793
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 15:29:01 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id u14so992413plf.4
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 15:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=+2brt3U1TLyEUVHvMxOOLD59kv/cc6yh68hbLCWv+N0=;
        b=Jvyx1+xktzRApPKKrCJEBjvQSD82HEcE+v5xVlmeYkTuk+ni8+XyschODcq0HMdJrk
         dbAbkXw7Vr837l3rKlVRZVDxJC6lDWkUvZYsAkI7yO4bsBzKvANGDOtbfNScz2FizpS8
         ZT8V9Vj0K+C6estsRDdx1/ihwXGJVxFoieKm8K6W8rD1iZTSI1fYUyGghiatbo1Es/oR
         8Obdfy9LFE8ZaR7G5q0XDIB3lgun3zbaYEC8W16+4yhdDA1w74Ljkdca24VTHd/x4D0T
         jSA3HZy59Om6z8EfyPspIqwvT9AF3MBCPBRklvCGcmSx9p3AJvh3kzXddtnPANuM7yEP
         Rc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+2brt3U1TLyEUVHvMxOOLD59kv/cc6yh68hbLCWv+N0=;
        b=F9tGgW9sfLyb64LvJc/QLtZ9chN66NqaSDzNIL858KlC84C77oEZoyVul6Oc/ZbDd1
         CxhzfoljiA4H9RGePC1rPoufkhXx5bGh2U0vgM/wOqUzbNsE/b2O7JatubrDTAtAkm/c
         4CEOXcd86ENv7YmACDAuKd+8f7IAlQESje2ttXav88Y0GBJoPHg97YrsRKdbHFtCuwH1
         bAEeCQ0XxeTxymlsG8Oxd+IbGuKq14oW2pPKBO/SaBdRJWPH4L9rtDwaOxR4Yue255Ht
         bXFhVwkkbQGGH7O4js4KUK+BUUoRv4qN4sSW0lHmiDUY1kxMzS0GQKg9vlg9GRdi2SLm
         +gfQ==
X-Gm-Message-State: AOAM53350by7lENLZjyI8pa3tuFOmz0DfaHCiYQz61wDPyU3kKNcpuVN
        2xY+IcGBm/7R/uz35NHyJ6/utVU34kObtnZDldyb1QI1GUM1b74NRlAYYuOPL86hIpWZuEQgMoe
        02LtOiTlcz1Nh5rnVPk5hNqWgx/Nnzssg2S29TP6IEJLi68bl+2Drtg==
X-Google-Smtp-Source: ABdhPJx6kfIMcVZfa8y4i3LveOkcK9q+/vYvCemUKFy8yM3nBdpApWkWM87VBzjfVQd+zwM/14LsgzE=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a62:e312:0:b029:1b6:cbbd:63e9 with SMTP id
 g18-20020a62e3120000b02901b6cbbd63e9mr12862411pfh.35.1611790140533; Wed, 27
 Jan 2021 15:29:00 -0800 (PST)
Date:   Wed, 27 Jan 2021 15:28:52 -0800
In-Reply-To: <20210127232853.3753823-1-sdf@google.com>
Message-Id: <20210127232853.3753823-4-sdf@google.com>
Mime-Version: 1.0
References: <20210127232853.3753823-1-sdf@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH bpf-next v2 3/4] selftests/bpf: rewrite recvmsg{4,6} asm progs
 to c in test_sock_addr
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'll extend them in the next patch. It's easier to work with C
than with asm.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/progs/recvmsg4_prog.c       | 37 ++++++++
 .../selftests/bpf/progs/recvmsg6_prog.c       | 43 ++++++++++
 tools/testing/selftests/bpf/test_sock_addr.c  | 86 +++----------------
 3 files changed, 92 insertions(+), 74 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/recvmsg4_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/recvmsg6_prog.c

diff --git a/tools/testing/selftests/bpf/progs/recvmsg4_prog.c b/tools/testing/selftests/bpf/progs/recvmsg4_prog.c
new file mode 100644
index 000000000000..fc2fe8a952fa
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/recvmsg4_prog.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/stddef.h>
+#include <linux/bpf.h>
+#include <linux/in.h>
+#include <sys/socket.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#define SERV4_IP		0xc0a801feU /* 192.168.1.254 */
+#define SERV4_PORT		4040
+
+SEC("cgroup/recvmsg4")
+int recvmsg4_prog(struct bpf_sock_addr *ctx)
+{
+	struct bpf_sock *sk;
+	__u32 user_ip4;
+	__u16 user_port;
+
+	sk = ctx->sk;
+	if (!sk)
+		return 1;
+
+	if (sk->family != AF_INET)
+		return 1;
+
+	if (ctx->type != SOCK_STREAM && ctx->type != SOCK_DGRAM)
+		return 1;
+
+	ctx->user_ip4 = bpf_htonl(SERV4_IP);
+	ctx->user_port = bpf_htons(SERV4_PORT);
+
+	return 1;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/recvmsg6_prog.c b/tools/testing/selftests/bpf/progs/recvmsg6_prog.c
new file mode 100644
index 000000000000..6060fd63324b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/recvmsg6_prog.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/stddef.h>
+#include <linux/bpf.h>
+#include <linux/in6.h>
+#include <sys/socket.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#define SERV6_IP_0		0xfaceb00c /* face:b00c:1234:5678::abcd */
+#define SERV6_IP_1		0x12345678
+#define SERV6_IP_2		0x00000000
+#define SERV6_IP_3		0x0000abcd
+#define SERV6_PORT		6060
+
+SEC("cgroup/recvmsg6")
+int recvmsg6_prog(struct bpf_sock_addr *ctx)
+{
+	struct bpf_sock *sk;
+	__u32 user_ip4;
+	__u16 user_port;
+
+	sk = ctx->sk;
+	if (!sk)
+		return 1;
+
+	if (sk->family != AF_INET6)
+		return 1;
+
+	if (ctx->type != SOCK_STREAM && ctx->type != SOCK_DGRAM)
+		return 1;
+
+	ctx->user_ip6[0] = bpf_htonl(SERV6_IP_0);
+	ctx->user_ip6[1] = bpf_htonl(SERV6_IP_1);
+	ctx->user_ip6[2] = bpf_htonl(SERV6_IP_2);
+	ctx->user_ip6[3] = bpf_htonl(SERV6_IP_3);
+	ctx->user_port = bpf_htons(SERV6_PORT);
+
+	return 1;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_sock_addr.c b/tools/testing/selftests/bpf/test_sock_addr.c
index dcb83ab02919..aa3f185fcb89 100644
--- a/tools/testing/selftests/bpf/test_sock_addr.c
+++ b/tools/testing/selftests/bpf/test_sock_addr.c
@@ -31,6 +31,8 @@
 #define CONNECT6_PROG_PATH	"./connect6_prog.o"
 #define SENDMSG4_PROG_PATH	"./sendmsg4_prog.o"
 #define SENDMSG6_PROG_PATH	"./sendmsg6_prog.o"
+#define RECVMSG4_PROG_PATH	"./recvmsg4_prog.o"
+#define RECVMSG6_PROG_PATH	"./recvmsg6_prog.o"
 #define BIND4_PROG_PATH		"./bind4_prog.o"
 #define BIND6_PROG_PATH		"./bind6_prog.o"
 
@@ -94,10 +96,10 @@ static int sendmsg_deny_prog_load(const struct sock_addr_test *test);
 static int recvmsg_allow_prog_load(const struct sock_addr_test *test);
 static int recvmsg_deny_prog_load(const struct sock_addr_test *test);
 static int sendmsg4_rw_asm_prog_load(const struct sock_addr_test *test);
-static int recvmsg4_rw_asm_prog_load(const struct sock_addr_test *test);
+static int recvmsg4_rw_c_prog_load(const struct sock_addr_test *test);
 static int sendmsg4_rw_c_prog_load(const struct sock_addr_test *test);
 static int sendmsg6_rw_asm_prog_load(const struct sock_addr_test *test);
-static int recvmsg6_rw_asm_prog_load(const struct sock_addr_test *test);
+static int recvmsg6_rw_c_prog_load(const struct sock_addr_test *test);
 static int sendmsg6_rw_c_prog_load(const struct sock_addr_test *test);
 static int sendmsg6_rw_v4mapped_prog_load(const struct sock_addr_test *test);
 static int sendmsg6_rw_wildcard_prog_load(const struct sock_addr_test *test);
@@ -573,8 +575,8 @@ static struct sock_addr_test tests[] = {
 		LOAD_REJECT,
 	},
 	{
-		"recvmsg4: rewrite IP & port (asm)",
-		recvmsg4_rw_asm_prog_load,
+		"recvmsg4: rewrite IP & port (C)",
+		recvmsg4_rw_c_prog_load,
 		BPF_CGROUP_UDP4_RECVMSG,
 		BPF_CGROUP_UDP4_RECVMSG,
 		AF_INET,
@@ -587,8 +589,8 @@ static struct sock_addr_test tests[] = {
 		SUCCESS,
 	},
 	{
-		"recvmsg6: rewrite IP & port (asm)",
-		recvmsg6_rw_asm_prog_load,
+		"recvmsg6: rewrite IP & port (C)",
+		recvmsg6_rw_c_prog_load,
 		BPF_CGROUP_UDP6_RECVMSG,
 		BPF_CGROUP_UDP6_RECVMSG,
 		AF_INET6,
@@ -786,45 +788,9 @@ static int sendmsg4_rw_asm_prog_load(const struct sock_addr_test *test)
 	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
 }
 
-static int recvmsg4_rw_asm_prog_load(const struct sock_addr_test *test)
+static int recvmsg4_rw_c_prog_load(const struct sock_addr_test *test)
 {
-	struct sockaddr_in src4_rw_addr;
-
-	if (mk_sockaddr(AF_INET, SERV4_IP, SERV4_PORT,
-			(struct sockaddr *)&src4_rw_addr,
-			sizeof(src4_rw_addr)) == -1)
-		return -1;
-
-	struct bpf_insn insns[] = {
-		BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
-
-		/* if (sk.family == AF_INET && */
-		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, family)),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, AF_INET, 6),
-
-		/*     sk.type == SOCK_DGRAM)  { */
-		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, type)),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, SOCK_DGRAM, 4),
-
-		/*      user_ip4 = src4_rw_addr.sin_addr */
-		BPF_MOV32_IMM(BPF_REG_7, src4_rw_addr.sin_addr.s_addr),
-		BPF_STX_MEM(BPF_W, BPF_REG_6, BPF_REG_7,
-			    offsetof(struct bpf_sock_addr, user_ip4)),
-
-		/*      user_port = src4_rw_addr.sin_port */
-		BPF_MOV32_IMM(BPF_REG_7, src4_rw_addr.sin_port),
-		BPF_STX_MEM(BPF_W, BPF_REG_6, BPF_REG_7,
-			    offsetof(struct bpf_sock_addr, user_port)),
-		/* } */
-
-		/* return 1 */
-		BPF_MOV64_IMM(BPF_REG_0, 1),
-		BPF_EXIT_INSN(),
-	};
-
-	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
+	return load_path(test, RECVMSG4_PROG_PATH);
 }
 
 static int sendmsg4_rw_c_prog_load(const struct sock_addr_test *test)
@@ -890,37 +856,9 @@ static int sendmsg6_rw_asm_prog_load(const struct sock_addr_test *test)
 	return sendmsg6_rw_dst_asm_prog_load(test, SERV6_REWRITE_IP);
 }
 
-static int recvmsg6_rw_asm_prog_load(const struct sock_addr_test *test)
+static int recvmsg6_rw_c_prog_load(const struct sock_addr_test *test)
 {
-	struct sockaddr_in6 src6_rw_addr;
-
-	if (mk_sockaddr(AF_INET6, SERV6_IP, SERV6_PORT,
-			(struct sockaddr *)&src6_rw_addr,
-			sizeof(src6_rw_addr)) == -1)
-		return -1;
-
-	struct bpf_insn insns[] = {
-		BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
-
-		/* if (sk.family == AF_INET6) { */
-		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, family)),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, AF_INET6, 10),
-
-		STORE_IPV6(user_ip6, src6_rw_addr.sin6_addr.s6_addr32),
-
-		/*      user_port = dst6_rw_addr.sin6_port */
-		BPF_MOV32_IMM(BPF_REG_7, src6_rw_addr.sin6_port),
-		BPF_STX_MEM(BPF_W, BPF_REG_6, BPF_REG_7,
-			    offsetof(struct bpf_sock_addr, user_port)),
-		/* } */
-
-		/* return 1 */
-		BPF_MOV64_IMM(BPF_REG_0, 1),
-		BPF_EXIT_INSN(),
-	};
-
-	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
+	return load_path(test, RECVMSG6_PROG_PATH);
 }
 
 static int sendmsg6_rw_v4mapped_prog_load(const struct sock_addr_test *test)
-- 
2.30.0.280.ga3ce27912f-goog

