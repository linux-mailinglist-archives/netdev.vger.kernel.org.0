Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2221BE5F1
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgD2SMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727100AbgD2SMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:12:01 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A67C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:12:00 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i10so3675981wrv.10
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LGiyKCk3S1pOE2otlkfXW7gIjb6zeQWI8M+A1IZy5qI=;
        b=UQN/uYfHIqX8VZ1VyMvs2Iqk8SD/y4jc68eEaCNlOubl4gDi5E84T05GlRCC/mTzFY
         w/SqGI6qq0vagZEPDMPYpLEi7PPXRCinOFNbzvIT7N4MEMLDF/IS6kSwdh+VdCqZY1i4
         72YWZIwzAIWX3ha3fN9e3K5yDm6MM9EJ/QDaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LGiyKCk3S1pOE2otlkfXW7gIjb6zeQWI8M+A1IZy5qI=;
        b=dUDV35yv76iEQpdrdUi/sJ+vY/u++hnOYNmuGPTXmY19GOLlCBBhK1USNiSYXHeX/D
         3C9T4MoHGTtbqXCYDE/lnVH9CXkwz+B/0E3mU7futoE3CHFGcvkkxVUPSolMgML5A09u
         hVTxLYntjR+lxKAmR0gYZx97WZVDSO7ID5VN987o+IOwFNJIR3G8I/Dghdn5e874e19C
         yYDvmQWvV2Z3YatyuEmmveD7jMRG3b2MNGrZb7I/A2PJPKZ0meqpe9ajGnL1cOBgq9f+
         iXZsJLI5nDdG4duBvR/+72g80F8w9vME/oR+abds9RYmod2bz20PRmM6FsQLrRPHAeJz
         YT0A==
X-Gm-Message-State: AGi0PuYF7QFySqONlQOzJCe+qzF2h8fBsdELuzPr31Y44F/xXKbucAMf
        U3sDPfrZu+DxORLV5yq2mkNLFg==
X-Google-Smtp-Source: APiQypKf/W5FIv2szBzM8IsRoz4/4pc3sNi11NkaQdAbEJhzm0Z3zyplDR3p9IGRceTE/nBHlXIjwQ==
X-Received: by 2002:adf:aa8e:: with SMTP id h14mr44050653wrc.371.1588183918773;
        Wed, 29 Apr 2020 11:11:58 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id w4sm56272wro.28.2020.04.29.11.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 11:11:58 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joe Stringer <joe@wand.net.nz>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next 2/3] selftests/bpf: Test that lookup on SOCKMAP/SOCKHASH is allowed
Date:   Wed, 29 Apr 2020 20:11:53 +0200
Message-Id: <20200429181154.479310-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200429181154.479310-1-jakub@cloudflare.com>
References: <20200429181154.479310-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that bpf_map_lookup_elem() is white-listed for SOCKMAP/SOCKHASH,
replace the tests which check that verifier prevents lookup on these map
types with ones that ensure that lookup operation is permitted, but only
with a release of acquired socket reference.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../bpf/verifier/prevent_map_lookup.c         | 30 --------
 tools/testing/selftests/bpf/verifier/sock.c   | 70 +++++++++++++++++++
 2 files changed, 70 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
index da7a4b37cb98..fc4e301260f6 100644
--- a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
+++ b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
@@ -1,33 +1,3 @@
-{
-	"prevent map lookup in sockmap",
-	.insns = {
-	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-	BPF_LD_MAP_FD(BPF_REG_1, 0),
-	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
-	BPF_EXIT_INSN(),
-	},
-	.fixup_map_sockmap = { 3 },
-	.result = REJECT,
-	.errstr = "cannot pass map_type 15 into func bpf_map_lookup_elem",
-	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
-},
-{
-	"prevent map lookup in sockhash",
-	.insns = {
-	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-	BPF_LD_MAP_FD(BPF_REG_1, 0),
-	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
-	BPF_EXIT_INSN(),
-	},
-	.fixup_map_sockhash = { 3 },
-	.result = REJECT,
-	.errstr = "cannot pass map_type 18 into func bpf_map_lookup_elem",
-	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
-},
 {
 	"prevent map lookup in stack trace",
 	.insns = {
diff --git a/tools/testing/selftests/bpf/verifier/sock.c b/tools/testing/selftests/bpf/verifier/sock.c
index 9ed192e14f5f..f87ad69dbc62 100644
--- a/tools/testing/selftests/bpf/verifier/sock.c
+++ b/tools/testing/selftests/bpf/verifier/sock.c
@@ -516,3 +516,73 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.result = ACCEPT,
 },
+{
+	"bpf_map_lookup_elem(sockmap, &key)",
+	.insns = {
+	BPF_ST_MEM(BPF_W, BPF_REG_10, -4, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_sockmap = { 3 },
+	.prog_type = BPF_PROG_TYPE_SK_SKB,
+	.result = REJECT,
+	.errstr = "Unreleased reference id=2 alloc_insn=5",
+},
+{
+	"bpf_map_lookup_elem(sockhash, &key)",
+	.insns = {
+	BPF_ST_MEM(BPF_W, BPF_REG_10, -4, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_sockhash = { 3 },
+	.prog_type = BPF_PROG_TYPE_SK_SKB,
+	.result = REJECT,
+	.errstr = "Unreleased reference id=2 alloc_insn=5",
+},
+{
+	"bpf_map_lookup_elem(sockmap, &key); sk->type [fullsock field]; bpf_sk_release(sk)",
+	.insns = {
+	BPF_ST_MEM(BPF_W, BPF_REG_10, -4, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, type)),
+	BPF_EMIT_CALL(BPF_FUNC_sk_release),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_sockmap = { 3 },
+	.prog_type = BPF_PROG_TYPE_SK_SKB,
+	.result = ACCEPT,
+},
+{
+	"bpf_map_lookup_elem(sockhash, &key); sk->type [fullsock field]; bpf_sk_release(sk)",
+	.insns = {
+	BPF_ST_MEM(BPF_W, BPF_REG_10, -4, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, type)),
+	BPF_EMIT_CALL(BPF_FUNC_sk_release),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_sockhash = { 3 },
+	.prog_type = BPF_PROG_TYPE_SK_SKB,
+	.result = ACCEPT,
+},
-- 
2.25.3

