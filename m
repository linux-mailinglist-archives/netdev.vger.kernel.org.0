Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21492CC3A0
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389267AbgLBR0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387644AbgLBR0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:26:07 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED13EC0617A6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 09:25:20 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v13so2620314ybe.18
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 09:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Ls9S5f8zYAjkACcXIRkv73KBz2OjZyypc0aur0DnGFg=;
        b=Cav8KxF4vpHXgnxLwVV0UJUH+9fgIGyMNEUztUeCfXl65XC+AM5O7XqIgpnyqSOSHZ
         5mlMPphTyHZJWkqfN8Zwd8Y14TT728mWke/C5uTNmGf5RT9SO5qBQw5B6xrGzzRyIVU8
         seCNXDghNN2cgn6EXOyki9wqB9xn/m+aalpgJ24Y1yVADHPE/VYwJe14khN9wO5h3OqK
         lTjPHhxzj8UrKLBJo4cCR5Wx+BJ6q18/WfmXrtdv2wzhNew9Ga4jwMhzuT9cnohXNAwT
         6X2n9aLQDFBPppPuuMZ8ViVt/VvW8bjom9sle2iTGva+cvD0493tkF61nBJl54ViWiXL
         Nthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ls9S5f8zYAjkACcXIRkv73KBz2OjZyypc0aur0DnGFg=;
        b=FriaFW34SP0M5y18/3cSbO2JHga0Atn81gk680VkKuw9FSaOfDgg+7rx1fuy8J48wV
         3ZIh/PBq674xRHveOFgAIRlphc+U8i8asqQyHZIB8HQ7tU4Wpj9wpSXz6SklfdBn+Twf
         qc1qodoQ82CL+SwMA8w+pJvuCeKC99boVnXrZon/5ADpLY6fzeMTMQgGBokfaRGfCIeQ
         udOdNpjRwY3nb8NtVe2vMZg0ABiZuztCz/6UVxxdGsVYgQW6dSbCwoPI5fFwSk7l2QZf
         tT7v30frUsWbWaovbszr67g9NzMjwXsHITjtAZYYTjvM++9PdHtt97848ECUU2s8Rtgq
         VXRA==
X-Gm-Message-State: AOAM532pwkUMXoqjK2+WdLuhDWsG/9Uwck1KCM/G50lLAcQa6+Tyra2o
        xNnCcmKWms3VeCifIeGDsBAFuNG21OLw35+Rk1d9cwCUSzzgIKZPbnAXXtGS2oXGeqEIfLGk3Zt
        AKn+D0ImKJEJ5PdR+GOuybP2hyIOLEobXGZMKnNsmX6unHK53cIa20Q==
X-Google-Smtp-Source: ABdhPJzoo3zsZ+qa6FUH0BAux7OvwD+1KQEkqXCohJYvH5msi5sedHqSQZb0gEtqwrmr04kCpsIKonY=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:aaa1:: with SMTP id t30mr4720701ybi.265.1606929920062;
 Wed, 02 Dec 2020 09:25:20 -0800 (PST)
Date:   Wed,  2 Dec 2020 09:25:14 -0800
In-Reply-To: <20201202172516.3483656-1-sdf@google.com>
Message-Id: <20201202172516.3483656-2-sdf@google.com>
Mime-Version: 1.0
References: <20201202172516.3483656-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH bpf-next 1/3] selftests/bpf: rewrite test_sock_addr bind bpf
 into C
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm planning to extend it in the next patches. It's much easier to
work with C than BPF assembly.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../testing/selftests/bpf/progs/bind4_prog.c  |  71 +++++++
 .../testing/selftests/bpf/progs/bind6_prog.c  |  88 ++++++++
 tools/testing/selftests/bpf/test_sock_addr.c  | 196 ++----------------
 3 files changed, 171 insertions(+), 184 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bind4_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/bind6_prog.c

diff --git a/tools/testing/selftests/bpf/progs/bind4_prog.c b/tools/testing/selftests/bpf/progs/bind4_prog.c
new file mode 100644
index 000000000000..0951302a984a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bind4_prog.c
@@ -0,0 +1,71 @@
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
index 000000000000..16da1cf85418
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bind6_prog.c
@@ -0,0 +1,88 @@
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
2.29.2.454.gaff20da3a2-goog

