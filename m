Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D0F62033D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 00:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbiKGXEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 18:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbiKGXEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 18:04:35 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA66E27177;
        Mon,  7 Nov 2022 15:04:33 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667862272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RatNBf3aGyPmcYswUS94Y72vzhSgWdyzPT8l/Whn4Wo=;
        b=PQV37g3kO7zlKdHUCqQuxEEnaXm1pxuwf5XzQor5fvszIA3rvyLDIy6C/CX+oCnAddQSU8
        azW5ox37HkUJ6ZAp7dyGBYU3OhJNGzJsHV8zRIYRp240dUFKdq1xZy+OQzuS5lf9QDWOU4
        zY9FDFwNfBB3PfTeCzeC20GhcBAoc+E=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: Test skops->skb_hwtstamp
Date:   Mon,  7 Nov 2022 15:04:20 -0800
Message-Id: <20221107230420.4192307-4-martin.lau@linux.dev>
In-Reply-To: <20221107230420.4192307-1-martin.lau@linux.dev>
References: <20221107230420.4192307-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

This patch tests reading the skops->skb_hwtstamp field.

A local test was also done such that the shinfo hwtstamp was temporary
set to a non zero value in the kernel bpf_skops_parse_hdr()
and the same value can be read by the skops test.

An adjustment is needed to the btf_dump selftest because
the changes in the 'struct bpf_sock_ops'.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/btf_dump.c             | 4 ++--
 tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c      | 2 ++
 tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c | 4 ++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 24da335482d4..0ba2e8b9c6ac 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -791,11 +791,11 @@ static void test_btf_dump_struct_data(struct btf *btf, struct btf_dump *d,
 	TEST_BTF_DUMP_DATA_OVER(btf, d, "struct", str, struct bpf_sock_ops,
 				sizeof(struct bpf_sock_ops) - 1,
 				"(struct bpf_sock_ops){\n\t.op = (__u32)1,\n",
-				{ .op = 1, .skb_tcp_flags = 2});
+				{ .op = 1, .skb_hwtstamp = 2});
 	TEST_BTF_DUMP_DATA_OVER(btf, d, "struct", str, struct bpf_sock_ops,
 				sizeof(struct bpf_sock_ops) - 1,
 				"(struct bpf_sock_ops){\n\t.op = (__u32)1,\n",
-				{ .op = 1, .skb_tcp_flags = 0});
+				{ .op = 1, .skb_hwtstamp = 0});
 }
 
 static void test_btf_dump_var_data(struct btf *btf, struct btf_dump *d,
diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
index 57191773572a..5cf85d0f9827 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
@@ -505,6 +505,8 @@ static void misc(void)
 
 	ASSERT_EQ(misc_skel->bss->nr_fin, 1, "unexpected nr_fin");
 
+	ASSERT_EQ(misc_skel->bss->nr_hwtstamp, 0, "nr_hwtstamp");
+
 check_linum:
 	ASSERT_FALSE(check_error_linum(&sk_fds), "check_error_linum");
 	sk_fds_close(&sk_fds);
diff --git a/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c b/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
index 2c121c5d66a7..d487153a839d 100644
--- a/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
@@ -27,6 +27,7 @@ unsigned int nr_pure_ack = 0;
 unsigned int nr_data = 0;
 unsigned int nr_syn = 0;
 unsigned int nr_fin = 0;
+unsigned int nr_hwtstamp = 0;
 
 /* Check the header received from the active side */
 static int __check_active_hdr_in(struct bpf_sock_ops *skops, bool check_syn)
@@ -146,6 +147,9 @@ static int check_active_hdr_in(struct bpf_sock_ops *skops)
 	if (th->ack && !th->fin && tcp_hdrlen(th) == skops->skb_len)
 		nr_pure_ack++;
 
+	if (skops->skb_hwtstamp)
+		nr_hwtstamp++;
+
 	return CG_OK;
 }
 
-- 
2.30.2

