Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB702B72F2
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgKRARr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgKRARr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 19:17:47 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCEFC0617A6
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 16:17:47 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id f13so171798pju.0
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 16:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=SMBsywCGzhTFjwo2M9m1F4AL8+zsGODn15EoGf2KSIc=;
        b=OevR3LMLSo0lU6tg9NDe0Rk701fx3xA7vXJTEcd2QeD9et/HaInIWEpzr6iedy7mLt
         xK49mozFMGHOc8W3lz0HIa0ORvnRuxiFpUV75f6imUZ1NNAZ5ITxnNetiM7+NsduR1i6
         e6m5je2ofHkllnsIzPYaN68G4VkwBqWPeiERYsiu535PQAo0GSYHM6zX32YOXUjFgjD6
         9KIzt7kp5ko9nHTbTGNGHD4y8NJB9nPjksZk2KjDMs6j65uI7eYwCTYPfiXBGX4DjNYy
         0cvAl+FIYqOB19fiNSioqmYEjsW/DsZkNmuS+gR8l7uPq5v1BqZkNOmJEQ50ZKdZgNCT
         spRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SMBsywCGzhTFjwo2M9m1F4AL8+zsGODn15EoGf2KSIc=;
        b=R0Bm+zgyKG8i9+uyfq86HYouVYomcsSy4C9HMKovSpbxukGcoSQOPRhxGX9XEHelaO
         lz75vzOmiAByFNNx0as6unN16giOMTIKHcSiggCc9NrCUJ9Y7UqXThsjLy3Xgc71ZZvC
         R/SVZucuhiWCUJQrNpdKVgkppxUI+FI5KVS95Mz3jLg8zOhg4WlAvVP1qtpaUE+eubzY
         +PtnpezZGl5iOQkkAxFAQVFMt4njMB/bzXRbkuwzqg5QBuNbXR7AJ2DFg/9o4tOH1zWj
         3Jj+TSllHGOS0ePiHDvax93Q/E5Pl0dt2f1DUx3Q71iovS/lMuW4JScMWleFHnQkS2He
         tyTw==
X-Gm-Message-State: AOAM533e2dhSi69N9e4ARPlmVrB9Fwq0VRW7R1OVKIE3ADFY/EFGe031
        Qzp49JrEwRFZZdzxaxlMMx2wcEmSijtpw11VapLVhzbXRk4xdiss1jx8eODddMt4H6ZXPP6x1TA
        Z2+ipPz4xoS2dMWklgR6LtqcY4mar7cUsKKXnMOVCbo16z9MDghgGlA==
X-Google-Smtp-Source: ABdhPJxs490dpl+ESDKgf2lgAwS5Yn24ZYLd0w138OvJX1R9m91FCBkN3wFkUy8AW8nDnHEiQdc4/3g=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a17:90b:e04:: with SMTP id ge4mr143502pjb.0.1605658666162;
 Tue, 17 Nov 2020 16:17:46 -0800 (PST)
Date:   Tue, 17 Nov 2020 16:17:40 -0800
In-Reply-To: <20201118001742.85005-1-sdf@google.com>
Message-Id: <20201118001742.85005-2-sdf@google.com>
Mime-Version: 1.0
References: <20201118001742.85005-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH bpf-next 1/3] selftests/bpf: rewrite test_sock_addr bind bpf
 into C
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm planning to extend it in the next patches. It's much easier to
work with C than BPF assembly.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../testing/selftests/bpf/progs/bind4_prog.c  |  73 +++++++
 .../testing/selftests/bpf/progs/bind6_prog.c  |  90 ++++++++
 tools/testing/selftests/bpf/test_sock_addr.c  | 196 ++----------------
 3 files changed, 175 insertions(+), 184 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bind4_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/bind6_prog.c

diff --git a/tools/testing/selftests/bpf/progs/bind4_prog.c b/tools/testing/selftests/bpf/progs/bind4_prog.c
new file mode 100644
index 000000000000..ff3def2ee6f9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bind4_prog.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <string.h>
+
+#include <linux/stddef.h>
+#include <linux/bpf.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <sys/socket.h>
+#include <netinet/tcp.h>
+#include <linux/if.h>
+#include <errno.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#define SERV4_IP		0xc0a801feU /* 192.168.1.254 */
+#define SERV4_PORT		4040
+#define SERV4_REWRITE_IP	0x7f000001U /* 127.0.0.1 */
+#define SERV4_REWRITE_PORT	4444
+
+int _version SEC("version") = 1;
+
+SEC("cgroup/bind4")
+int bind_v4_prog(struct bpf_sock_addr *ctx)
+{
+	struct bpf_sock *sk;
+	__u32 user_ip4;
+	__u16 user_port;
+
+	sk = ctx->sk;
+	if (!sk)
+		return 0;
+
+	if (sk->family != AF_INET)
+		return 0;
+
+	if (ctx->type != SOCK_STREAM && ctx->type != SOCK_DGRAM)
+		return 0;
+
+	if (ctx->user_ip4 != bpf_htonl(SERV4_IP) ||
+	    ctx->user_port != bpf_htons(SERV4_PORT))
+		return 0;
+
+	// u8 narrow loads:
+	user_ip4 = 0;
+	user_ip4 |= ((volatile __u8 *)&ctx->user_ip4)[0] << 0;
+	user_ip4 |= ((volatile __u8 *)&ctx->user_ip4)[1] << 8;
+	user_ip4 |= ((volatile __u8 *)&ctx->user_ip4)[2] << 16;
+	user_ip4 |= ((volatile __u8 *)&ctx->user_ip4)[3] << 24;
+	if (ctx->user_ip4 != user_ip4)
+		return 0;
+
+	user_port = 0;
+	user_port |= ((volatile __u8 *)&ctx->user_port)[0] << 0;
+	user_port |= ((volatile __u8 *)&ctx->user_port)[1] << 8;
+	if (ctx->user_port != user_port)
+		return 0;
+
+	// u16 narrow loads:
+	user_ip4 = 0;
+	user_ip4 |= ((volatile __u16 *)&ctx->user_ip4)[0] << 0;
+	user_ip4 |= ((volatile __u16 *)&ctx->user_ip4)[1] << 16;
+	if (ctx->user_ip4 != user_ip4)
+		return 0;
+
+	ctx->user_ip4 = bpf_htonl(SERV4_REWRITE_IP);
+	ctx->user_port = bpf_htons(SERV4_REWRITE_PORT);
+
+	return 1;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/bind6_prog.c b/tools/testing/selftests/bpf/progs/bind6_prog.c
new file mode 100644
index 000000000000..97686baaae65
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bind6_prog.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <string.h>
+
+#include <linux/stddef.h>
+#include <linux/bpf.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <sys/socket.h>
+#include <netinet/tcp.h>
+#include <linux/if.h>
+#include <errno.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#define SERV6_IP_0		0xfaceb00c /* face:b00c:1234:5678::abcd */
+#define SERV6_IP_1		0x12345678
+#define SERV6_IP_2		0x00000000
+#define SERV6_IP_3		0x0000abcd
+#define SERV6_PORT		6060
+#define SERV6_REWRITE_IP_0	0x00000000
+#define SERV6_REWRITE_IP_1	0x00000000
+#define SERV6_REWRITE_IP_2	0x00000000
+#define SERV6_REWRITE_IP_3	0x00000001
+#define SERV6_REWRITE_PORT	6666
+
+int _version SEC("version") = 1;
+
+SEC("cgroup/bind6")
+int bind_v6_prog(struct bpf_sock_addr *ctx)
+{
+	struct bpf_sock *sk;
+	__u32 user_ip6;
+	__u16 user_port;
+	int i;
+
+	sk = ctx->sk;
+	if (!sk)
+		return 0;
+
+	if (sk->family != AF_INET6)
+		return 0;
+
+	if (ctx->type != SOCK_STREAM && ctx->type != SOCK_DGRAM)
+		return 0;
+
+	if (ctx->user_ip6[0] != bpf_htonl(SERV6_IP_0) ||
+	    ctx->user_ip6[1] != bpf_htonl(SERV6_IP_1) ||
+	    ctx->user_ip6[2] != bpf_htonl(SERV6_IP_2) ||
+	    ctx->user_ip6[3] != bpf_htonl(SERV6_IP_3) ||
+	    ctx->user_port != bpf_htons(SERV6_PORT))
+		return 0;
+
+	// u8 narrow loads:
+	for (i = 0; i < 4; i++) {
+		user_ip6 = 0;
+		user_ip6 |= ((volatile __u8 *)&ctx->user_ip6[i])[0] << 0;
+		user_ip6 |= ((volatile __u8 *)&ctx->user_ip6[i])[1] << 8;
+		user_ip6 |= ((volatile __u8 *)&ctx->user_ip6[i])[2] << 16;
+		user_ip6 |= ((volatile __u8 *)&ctx->user_ip6[i])[3] << 24;
+		if (ctx->user_ip6[i] != user_ip6)
+			return 0;
+	}
+
+	user_port = 0;
+	user_port |= ((volatile __u8 *)&ctx->user_port)[0] << 0;
+	user_port |= ((volatile __u8 *)&ctx->user_port)[1] << 8;
+	if (ctx->user_port != user_port)
+		return 0;
+
+	// u16 narrow loads:
+	for (i = 0; i < 4; i++) {
+		user_ip6 = 0;
+		user_ip6 |= ((volatile __u16 *)&ctx->user_ip6[i])[0] << 0;
+		user_ip6 |= ((volatile __u16 *)&ctx->user_ip6[i])[1] << 16;
+		if (ctx->user_ip6[i] != user_ip6)
+			return 0;
+	}
+
+	ctx->user_ip6[0] = bpf_htonl(SERV6_REWRITE_IP_0);
+	ctx->user_ip6[1] = bpf_htonl(SERV6_REWRITE_IP_1);
+	ctx->user_ip6[2] = bpf_htonl(SERV6_REWRITE_IP_2);
+	ctx->user_ip6[3] = bpf_htonl(SERV6_REWRITE_IP_3);
+	ctx->user_port = bpf_htons(SERV6_REWRITE_PORT);
+
+	return 1;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_sock_addr.c b/tools/testing/selftests/bpf/test_sock_addr.c
index b8c72c1d9cf7..dcb83ab02919 100644
--- a/tools/testing/selftests/bpf/test_sock_addr.c
+++ b/tools/testing/selftests/bpf/test_sock_addr.c
@@ -31,6 +31,8 @@
 #define CONNECT6_PROG_PATH	"./connect6_prog.o"
 #define SENDMSG4_PROG_PATH	"./sendmsg4_prog.o"
 #define SENDMSG6_PROG_PATH	"./sendmsg6_prog.o"
+#define BIND4_PROG_PATH		"./bind4_prog.o"
+#define BIND6_PROG_PATH		"./bind6_prog.o"
 
 #define SERV4_IP		"192.168.1.254"
 #define SERV4_REWRITE_IP	"127.0.0.1"
@@ -660,190 +662,6 @@ static int load_insns(const struct sock_addr_test *test,
 	return ret;
 }
 
-/* [1] These testing programs try to read different context fields, including
- * narrow loads of different sizes from user_ip4 and user_ip6, and write to
- * those allowed to be overridden.
- *
- * [2] BPF_LD_IMM64 & BPF_JMP_REG are used below whenever there is a need to
- * compare a register with unsigned 32bit integer. BPF_JMP_IMM can't be used
- * in such cases since it accepts only _signed_ 32bit integer as IMM
- * argument. Also note that BPF_LD_IMM64 contains 2 instructions what matters
- * to count jumps properly.
- */
-
-static int bind4_prog_load(const struct sock_addr_test *test)
-{
-	union {
-		uint8_t u4_addr8[4];
-		uint16_t u4_addr16[2];
-		uint32_t u4_addr32;
-	} ip4, port;
-	struct sockaddr_in addr4_rw;
-
-	if (inet_pton(AF_INET, SERV4_IP, (void *)&ip4) != 1) {
-		log_err("Invalid IPv4: %s", SERV4_IP);
-		return -1;
-	}
-
-	port.u4_addr32 = htons(SERV4_PORT);
-
-	if (mk_sockaddr(AF_INET, SERV4_REWRITE_IP, SERV4_REWRITE_PORT,
-			(struct sockaddr *)&addr4_rw, sizeof(addr4_rw)) == -1)
-		return -1;
-
-	/* See [1]. */
-	struct bpf_insn insns[] = {
-		BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
-
-		/* if (sk.family == AF_INET && */
-		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, family)),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, AF_INET, 32),
-
-		/*     (sk.type == SOCK_DGRAM || sk.type == SOCK_STREAM) && */
-		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, type)),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, SOCK_DGRAM, 1),
-		BPF_JMP_A(1),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, SOCK_STREAM, 28),
-
-		/*     1st_byte_of_user_ip4 == expected && */
-		BPF_LDX_MEM(BPF_B, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_ip4)),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, ip4.u4_addr8[0], 26),
-
-		/*     2nd_byte_of_user_ip4 == expected && */
-		BPF_LDX_MEM(BPF_B, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_ip4) + 1),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, ip4.u4_addr8[1], 24),
-
-		/*     3rd_byte_of_user_ip4 == expected && */
-		BPF_LDX_MEM(BPF_B, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_ip4) + 2),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, ip4.u4_addr8[2], 22),
-
-		/*     4th_byte_of_user_ip4 == expected && */
-		BPF_LDX_MEM(BPF_B, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_ip4) + 3),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, ip4.u4_addr8[3], 20),
-
-		/*     1st_half_of_user_ip4 == expected && */
-		BPF_LDX_MEM(BPF_H, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_ip4)),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, ip4.u4_addr16[0], 18),
-
-		/*     2nd_half_of_user_ip4 == expected && */
-		BPF_LDX_MEM(BPF_H, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_ip4) + 2),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, ip4.u4_addr16[1], 16),
-
-		/*     whole_user_ip4 == expected && */
-		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_ip4)),
-		BPF_LD_IMM64(BPF_REG_8, ip4.u4_addr32), /* See [2]. */
-		BPF_JMP_REG(BPF_JNE, BPF_REG_7, BPF_REG_8, 12),
-
-		/*     1st_byte_of_user_port == expected && */
-		BPF_LDX_MEM(BPF_B, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_port)),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, port.u4_addr8[0], 10),
-
-		/*     1st_half_of_user_port == expected && */
-		BPF_LDX_MEM(BPF_H, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_port)),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, port.u4_addr16[0], 8),
-
-		/*     user_port == expected) { */
-		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_port)),
-		BPF_LD_IMM64(BPF_REG_8, port.u4_addr32), /* See [2]. */
-		BPF_JMP_REG(BPF_JNE, BPF_REG_7, BPF_REG_8, 4),
-
-		/*      user_ip4 = addr4_rw.sin_addr */
-		BPF_MOV32_IMM(BPF_REG_7, addr4_rw.sin_addr.s_addr),
-		BPF_STX_MEM(BPF_W, BPF_REG_6, BPF_REG_7,
-			    offsetof(struct bpf_sock_addr, user_ip4)),
-
-		/*      user_port = addr4_rw.sin_port */
-		BPF_MOV32_IMM(BPF_REG_7, addr4_rw.sin_port),
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
-}
-
-static int bind6_prog_load(const struct sock_addr_test *test)
-{
-	struct sockaddr_in6 addr6_rw;
-	struct in6_addr ip6;
-
-	if (inet_pton(AF_INET6, SERV6_IP, (void *)&ip6) != 1) {
-		log_err("Invalid IPv6: %s", SERV6_IP);
-		return -1;
-	}
-
-	if (mk_sockaddr(AF_INET6, SERV6_REWRITE_IP, SERV6_REWRITE_PORT,
-			(struct sockaddr *)&addr6_rw, sizeof(addr6_rw)) == -1)
-		return -1;
-
-	/* See [1]. */
-	struct bpf_insn insns[] = {
-		BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
-
-		/* if (sk.family == AF_INET6 && */
-		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, family)),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, AF_INET6, 18),
-
-		/*            5th_byte_of_user_ip6 == expected && */
-		BPF_LDX_MEM(BPF_B, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_ip6[1])),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, ip6.s6_addr[4], 16),
-
-		/*            3rd_half_of_user_ip6 == expected && */
-		BPF_LDX_MEM(BPF_H, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_ip6[1])),
-		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, ip6.s6_addr16[2], 14),
-
-		/*            last_word_of_user_ip6 == expected) { */
-		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
-			    offsetof(struct bpf_sock_addr, user_ip6[3])),
-		BPF_LD_IMM64(BPF_REG_8, ip6.s6_addr32[3]),  /* See [2]. */
-		BPF_JMP_REG(BPF_JNE, BPF_REG_7, BPF_REG_8, 10),
-
-
-#define STORE_IPV6_WORD(N)						       \
-		BPF_MOV32_IMM(BPF_REG_7, addr6_rw.sin6_addr.s6_addr32[N]),     \
-		BPF_STX_MEM(BPF_W, BPF_REG_6, BPF_REG_7,		       \
-			    offsetof(struct bpf_sock_addr, user_ip6[N]))
-
-		/*      user_ip6 = addr6_rw.sin6_addr */
-		STORE_IPV6_WORD(0),
-		STORE_IPV6_WORD(1),
-		STORE_IPV6_WORD(2),
-		STORE_IPV6_WORD(3),
-
-		/*      user_port = addr6_rw.sin6_port */
-		BPF_MOV32_IMM(BPF_REG_7, addr6_rw.sin6_port),
-		BPF_STX_MEM(BPF_W, BPF_REG_6, BPF_REG_7,
-			    offsetof(struct bpf_sock_addr, user_port)),
-
-		/* } */
-
-		/* return 1 */
-		BPF_MOV64_IMM(BPF_REG_0, 1),
-		BPF_EXIT_INSN(),
-	};
-
-	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
-}
-
 static int load_path(const struct sock_addr_test *test, const char *path)
 {
 	struct bpf_prog_load_attr attr;
@@ -865,6 +683,16 @@ static int load_path(const struct sock_addr_test *test, const char *path)
 	return prog_fd;
 }
 
+static int bind4_prog_load(const struct sock_addr_test *test)
+{
+	return load_path(test, BIND4_PROG_PATH);
+}
+
+static int bind6_prog_load(const struct sock_addr_test *test)
+{
+	return load_path(test, BIND6_PROG_PATH);
+}
+
 static int connect4_prog_load(const struct sock_addr_test *test)
 {
 	return load_path(test, CONNECT4_PROG_PATH);
-- 
2.29.2.299.gdc1121823c-goog

