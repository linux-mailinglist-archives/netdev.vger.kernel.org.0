Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F85442EF9D
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 13:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238483AbhJOL00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 07:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238490AbhJOL0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 07:26:25 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E95C061765
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 04:24:19 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id y16-20020a05600c17d000b0030db7a51ee2so1447960wmo.0
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 04:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M2KhKg7mGMM/7Z7JCzghnvL0t/VBs24STBJ7ab9m2xs=;
        b=LEW7hQIj+g8zU+1jSb8o1CI776sI1BeWIOXbGZZw4qccJdVXXSW0t94y9WWmBac6b2
         aX0Lvr7DSbMyUYzsR15w9Tb48Yk1Nmfs9+2aqCKKNr+ThpH/KmR/mRKYZD/uVQIn41Hn
         EnLoRi6U43BLhSQglz+SdeSzJtII2mbQhRlNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M2KhKg7mGMM/7Z7JCzghnvL0t/VBs24STBJ7ab9m2xs=;
        b=M0sVEWGb+fcKhbt/EoIW6cK5Dr3ajwBTtqvsVRJzdNE4YryJX6mrjqy/mKhu9AoyMh
         1+/IPdzLThN7+Xi7nGjnHAnYe0Qos4HhsTGJdc2Yky5GuXF+rsV3Dc0g3+fUVd3nUEsC
         K3C+lU4UUxZ7Y2a+73EGrXIuy4wejNrZN0lfWwZLdsd/rmDawcFgYulGecvnN/NqjAtH
         EvFqKUufP8DAtcHAEUgSmpbZvBsRX+I34qoaWru89xdcVwKyDtU/kv8f0gmS8ezegOKG
         2l6UuFYCUwV6gjdiRIfPELGZgKkAtlSijxavzr4C0BPaJWIqVlC7cqjDgbfJEF/MKwIA
         5nRw==
X-Gm-Message-State: AOAM53212szjaHigcS2BWXmZ9ia0eQu/mDzuFiYrhdukRtS+17iLDDRQ
        u0DCnUul7zujeYIQ/ltRiXIpFw==
X-Google-Smtp-Source: ABdhPJzjAR0Yu0mRoDxHM/EMDN/otw3YAOOKcwLy3ZsB/p88WjadAl1+y3IPoQh7D1+Y+EmuJgU0zA==
X-Received: by 2002:a7b:c193:: with SMTP id y19mr25939309wmi.125.1634297057696;
        Fri, 15 Oct 2021 04:24:17 -0700 (PDT)
Received: from kharboze.dr-pashinator-m-d.gmail.com.beta.tailscale.net ([2a02:390:85ca:6:be5f:f4ff:fe85:e406])
        by smtp.gmail.com with ESMTPSA id o12sm4631223wrv.78.2021.10.15.04.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 04:24:17 -0700 (PDT)
From:   Mark Pashmfouroush <markpash@cloudflare.com>
To:     markpash@cloudflare.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Brendan Jackman <jackmanb@google.com>,
        Joe Stringer <joe@cilium.io>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 2/2] selftests/bpf: Add tests for accessing ifindex in bpf_sk_lookup
Date:   Fri, 15 Oct 2021 12:23:30 +0100
Message-Id: <20211015112336.1973229-3-markpash@cloudflare.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015112336.1973229-1-markpash@cloudflare.com>
References: <20211015112336.1973229-1-markpash@cloudflare.com>
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
index aee41547e7f4..951e5dcf297e 100644
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

