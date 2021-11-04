Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1BC4452EE
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 13:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhKDM0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 08:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbhKDM0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 08:26:12 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6544C06127A
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 05:23:32 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so4103650wmb.5
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 05:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DbdddvL3v1nKg0sWX7VozKa+Fy24SlndwT2dHYiunUc=;
        b=Y1NZqfG2WZeoFgUOeBVL3uxtDdgUxoYu61tz/ya9iSTTtDPS/up2RrnH14i5S7soGP
         XZKJWXhM7MLPtrbP0iTxmzw5SppG8O8RvuxZJG5oZtgQub/NM6IioDpuOdGSIvC8nfWH
         91miaDB4lDiOA50K0Ai4pNr8Am7zM1VU9mcps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DbdddvL3v1nKg0sWX7VozKa+Fy24SlndwT2dHYiunUc=;
        b=lG1vVkedzDzZxmL0foVPqf0PFrF/6WwlFrftY+ntJuXgUQlbZjKhAQa6OK/fu0aeSD
         /DbQyUBxMkOpd3GlxYEPwoxdspvRMp5WYK7A+NaZhdF0MRDlCaj590mTXg39w2XOrBTP
         PGN0ONlxgCtlcP0UZ7hZl85VQScU6+eC9ILWkaVoQ7bX4EPK6zMlI6SMGky72xDZacBM
         zkXaHFtLx+WfRXVmqs307+dcdYpCqsZiswIZ2doRwxVZcTaz/b89Z7qkkRYi+UwSWPgB
         VEesvQCiRSAvWMYK7GvpO7GrBfdu65b2W1suaSGMzxfd7ImoHkJlwrcgl8cwPuO2F0uH
         gStw==
X-Gm-Message-State: AOAM531jnD3VJjCP5nt0ljLlGh0WKdbOJr5Sei5Wn7Go0Jn5VuCg2vVf
        DGcEC58mAjM/vB+pO4KGLLlYIw==
X-Google-Smtp-Source: ABdhPJyjdBYDj2sx912EDhl0izenDXlzZg7gy6atekwsa7xhY81ByQunOX+VtBvujXfBr8u1iCMuKQ==
X-Received: by 2002:a1c:448b:: with SMTP id r133mr10372348wma.85.1636028611422;
        Thu, 04 Nov 2021 05:23:31 -0700 (PDT)
Received: from kharboze.dr-pashinator-m-d.gmail.com.beta.tailscale.net (cust97-dsl60.idnet.net. [212.69.60.97])
        by smtp.gmail.com with ESMTPSA id a4sm4797535wmb.39.2021.11.04.05.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 05:23:31 -0700 (PDT)
From:   Mark Pashmfouroush <markpash@cloudflare.com>
To:     markpash@cloudflare.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: Add tests for accessing ifindex in bpf_sk_lookup
Date:   Thu,  4 Nov 2021 12:23:04 +0000
Message-Id: <20211104122304.962104-3-markpash@cloudflare.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211104122304.962104-1-markpash@cloudflare.com>
References: <20211104122304.962104-1-markpash@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new field was added to the bpf_sk_lookup data that users can access.
Add tests that validate that the new ifindex field contains the right
data.

Signed-off-by: Mark Pashmfouroush <markpash@cloudflare.com>

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index 6db07401bc49..57846cc7ce36 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -937,6 +937,37 @@ static void test_drop_on_lookup(struct test_sk_lookup *skel)
 			.connect_to	= { EXT_IP6, EXT_PORT },
 			.listen_at	= { EXT_IP6, INT_PORT },
 		},
+		/* The program will drop on success, meaning that the ifindex
+		 * was 1.
+		 */
+		{
+			.desc		= "TCP IPv4 drop on valid ifindex",
+			.lookup_prog	= skel->progs.check_ifindex,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { EXT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "TCP IPv6 drop on valid ifindex",
+			.lookup_prog	= skel->progs.check_ifindex,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { EXT_IP6, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv4 drop on valid ifindex",
+			.lookup_prog	= skel->progs.check_ifindex,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { EXT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv6 drop on valid ifindex",
+			.lookup_prog	= skel->progs.check_ifindex,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { EXT_IP6, EXT_PORT },
+		},
 	};
 	const struct test *t;
 
diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
index 19d2465d9442..0f3283bfe3b6 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
@@ -84,6 +84,14 @@ int lookup_drop(struct bpf_sk_lookup *ctx)
 	return SK_DROP;
 }
 
+SEC("sk_lookup")
+int check_ifindex(struct bpf_sk_lookup *ctx)
+{
+	if (ctx->ifindex == 1)
+		return SK_DROP;
+	return SK_PASS;
+}
+
 SEC("sk_reuseport")
 int reuseport_pass(struct sk_reuseport_md *ctx)
 {
diff --git a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
index d78627be060f..0b3088da1e89 100644
--- a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
+++ b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
@@ -229,6 +229,24 @@
 		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
 			    offsetof(struct bpf_sk_lookup, local_port)),
 
+		/* 1-byte read from ifindex field */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, ifindex)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, ifindex) + 1),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, ifindex) + 2),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, ifindex) + 3),
+		/* 2-byte read from ifindex field */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, ifindex)),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, ifindex) + 2),
+		/* 4-byte read from ifindex field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, ifindex)),
+
 		/* 8-byte read from sk field */
 		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
 			    offsetof(struct bpf_sk_lookup, sk)),
@@ -351,6 +369,20 @@
 	.expected_attach_type = BPF_SK_LOOKUP,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"invalid 8-byte read from bpf_sk_lookup ifindex field",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, ifindex)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
 /* invalid 1,2,4-byte reads from 8-byte fields in bpf_sk_lookup */
 {
 	"invalid 4-byte read from bpf_sk_lookup sk field",
-- 
2.31.1

