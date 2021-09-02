Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBD63FF6FA
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhIBWRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:17:30 -0400
Received: from novek.ru ([213.148.174.62]:60372 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243711AbhIBWR0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 18:17:26 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 2492B504081;
        Fri,  3 Sep 2021 01:13:08 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 2492B504081
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1630620793; bh=7MLSqTjtEFqhLmhm5Adq1Axljfaq+F24kmWjdVLQU8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zy9TFbbQ8C4soThdaRrOT1P4K7CSjxTK+DM6H9hzJ9KxJTrEz9b4TzQXSC60eXC9X
         nrVQ2AxkwjQszQRYgja0Qw6EGR7MkTtloPjCN+xuFDuOZQG1j63E6KbvLQj+ETeW87
         gs5TnYPX+1tdBr55f/Ddy52GTrFrmIoyRAcjTW9M=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 2/2] selftests/bpf: test new __sk_buff field hwtstamp
Date:   Fri,  3 Sep 2021 01:15:51 +0300
Message-Id: <20210902221551.15566-3-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210902221551.15566-1-vfedorenko@novek.ru>
References: <20210902221551.15566-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Analogous to the gso_segs selftests introduced in commit d9ff286a0f59
("bpf: allow BPF programs access skb_shared_info->gso_segs field")

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 lib/test_bpf.c                                |  1 +
 net/bpf/test_run.c                            |  8 ++++
 .../selftests/bpf/prog_tests/skb_ctx.c        |  1 +
 .../selftests/bpf/progs/test_skb_ctx.c        |  2 +
 .../testing/selftests/bpf/verifier/ctx_skb.c  | 47 +++++++++++++++++++
 5 files changed, 59 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 830a18ecffc8..0018d51b93b0 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -8800,6 +8800,7 @@ static __init struct sk_buff *build_test_skb(void)
 	skb_shinfo(skb[0])->gso_type |= SKB_GSO_DODGY;
 	skb_shinfo(skb[0])->gso_segs = 0;
 	skb_shinfo(skb[0])->frag_list = skb[1];
+	skb_shinfo(skb[0])->hwtstamps.hwtstamp = 1000;
 
 	/* adjust skb[0]'s len */
 	skb[0]->len += skb[1]->len;
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2eb0e55ef54d..1232dd839d7a 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -511,6 +511,12 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 	/* gso_size is allowed */
 
 	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, gso_size),
+			   offsetof(struct __sk_buff, hwtstamp)))
+		return -EINVAL;
+
+	/* hwtstamp is allowed */
+
+	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, hwtstamp),
 			   sizeof(struct __sk_buff)))
 		return -EINVAL;
 
@@ -532,6 +538,7 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 		return -EINVAL;
 	skb_shinfo(skb)->gso_segs = __skb->gso_segs;
 	skb_shinfo(skb)->gso_size = __skb->gso_size;
+	skb_shinfo(skb)->hwtstamps.hwtstamp = __skb->hwtstamp;
 
 	return 0;
 }
@@ -550,6 +557,7 @@ static void convert_skb_to___skb(struct sk_buff *skb, struct __sk_buff *__skb)
 	memcpy(__skb->cb, &cb->data, QDISC_CB_PRIV_LEN);
 	__skb->wire_len = cb->pkt_len;
 	__skb->gso_segs = skb_shinfo(skb)->gso_segs;
+	__skb->hwtstamp = skb_shinfo(skb)->hwtstamps.hwtstamp;
 }
 
 int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
diff --git a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
index fafeddaad6a9..87ca95e8442b 100644
--- a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
+++ b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
@@ -17,6 +17,7 @@ void test_skb_ctx(void)
 		.gso_segs = 8,
 		.mark = 9,
 		.gso_size = 10,
+		.hwtstamp = 11,
 	};
 	struct bpf_prog_test_run_attr tattr = {
 		.data_in = &pkt_v4,
diff --git a/tools/testing/selftests/bpf/progs/test_skb_ctx.c b/tools/testing/selftests/bpf/progs/test_skb_ctx.c
index b02ea589ce7e..5cfa91cf0f08 100644
--- a/tools/testing/selftests/bpf/progs/test_skb_ctx.c
+++ b/tools/testing/selftests/bpf/progs/test_skb_ctx.c
@@ -25,6 +25,8 @@ int process(struct __sk_buff *skb)
 		return 1;
 	if (skb->gso_size != 10)
 		return 1;
+	if (skb->hwtstamp != 11)
+		return 1;
 
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/verifier/ctx_skb.c b/tools/testing/selftests/bpf/verifier/ctx_skb.c
index 2022c0f2cd75..ab3df1aa691d 100644
--- a/tools/testing/selftests/bpf/verifier/ctx_skb.c
+++ b/tools/testing/selftests/bpf/verifier/ctx_skb.c
@@ -1057,6 +1057,53 @@
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
+{
+	"read hwtstamp from CGROUP_SKB",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+		    offsetof(struct __sk_buff, hwtstamp)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
+{
+	"read hwtstamp from CGROUP_SKB",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1,
+		    offsetof(struct __sk_buff, hwtstamp)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
+{
+	"write hwtstamp from CGROUP_SKB",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0,
+		    offsetof(struct __sk_buff, hwtstamp)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.result_unpriv = REJECT,
+	.errstr = "invalid bpf_context access off=184 size=8",
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
+{
+	"read hwtstamp from CLS",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+		    offsetof(struct __sk_buff, hwtstamp)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+},
 {
 	"check wire_len is not readable by sockets",
 	.insns = {
-- 
2.18.4

