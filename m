Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5535355AF
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349173AbiEZVgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243125AbiEZVgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:36:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56126E7334;
        Thu, 26 May 2022 14:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DED38B82219;
        Thu, 26 May 2022 21:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25138C36AE5;
        Thu, 26 May 2022 21:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600977;
        bh=lGWKZyEAcHG/rHFsEc19gERB0bPYlJN8ZkjFWS2dFSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOGtWO5AwgO+tzpK4cMGLdCJqhqPr+6PQIKtansl5j5IxSwbSyU2MCjXzSWncGgEa
         c0aotAg0Mk0z8GY1UTHySWqwXW3riJfQuhr3BvHvHMpXWsvh44rGQ3JLExFJpXtC+b
         puyPEYoP6OReTGhS8O9SRfQdQwQ6DoIOsUfX8LBC+MZ1FQx7DkyFAmQLxAi1r1zt2s
         TC/ANDj5g3oRrnKA5naxZ3Fg4T4F276Wc19qK8yvq58AgZhDpEhZUpwXIwZotQkVgf
         gC6YvbCFHdPca8GD5gQM7GnyHTsdxeVZdiJVstfO5UAUlpjukVZrTGoD6TwUg/wgL2
         6DN33UcUY6wOg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 13/14] selftests/bpf: add selftest for bpf_xdp_ct_add and bpf_ct_refresh_timeout kfunc
Date:   Thu, 26 May 2022 23:35:01 +0200
Message-Id: <777f1aec6aef006604edf945cb898a0ca636fb9d.1653600578.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653600577.git.lorenzo@kernel.org>
References: <cover.1653600577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce selftests for the following kfunc helpers:
- bpf_xdp_ct_alloc
- bpf_skb_ct_alloc
- bpf_ct_insert_entry
- bpf_ct_refresh_timeout

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  6 ++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 87 +++++++++++++++----
 2 files changed, 76 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index dd30b1e3a67c..b909928427f3 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -39,6 +39,12 @@ void test_bpf_nf_ct(int mode)
 	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
 	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
 	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSUPPORT for invalid len__tuple");
+	ASSERT_EQ(skel->data->test_alloc_entry, 0, "Test for alloc new entry");
+	ASSERT_EQ(skel->data->test_insert_entry, 0, "Test for insert new entry");
+	ASSERT_EQ(skel->data->test_succ_lookup, 0, "Test for successful lookup");
+	/* allow some tolerance for test_delta_timeout value to avoid races. */
+	ASSERT_GT(skel->bss->test_delta_timeout, 9, "Test for min ct timeout update");
+	ASSERT_LE(skel->bss->test_delta_timeout, 10, "Test for max ct timeout update");
 end:
 	test_bpf_nf__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index f00a9731930e..1e39f62f7bc8 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -8,6 +8,8 @@
 #define EINVAL 22
 #define ENOENT 2
 
+extern unsigned long CONFIG_HZ __kconfig;
+
 int test_einval_bpf_tuple = 0;
 int test_einval_reserved = 0;
 int test_einval_netns_id = 0;
@@ -16,6 +18,10 @@ int test_eproto_l4proto = 0;
 int test_enonet_netns_id = 0;
 int test_enoent_lookup = 0;
 int test_eafnosupport = 0;
+int test_alloc_entry = -EINVAL;
+int test_insert_entry = -EAFNOSUPPORT;
+int test_succ_lookup = -ENOENT;
+u32 test_delta_timeout = 0;
 
 struct nf_conn;
 
@@ -26,31 +32,42 @@ struct bpf_ct_opts___local {
 	u8 reserved[3];
 } __attribute__((preserve_access_index));
 
-struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
-				  struct bpf_ct_opts___local *, u32) __ksym;
-struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
-				  struct bpf_ct_opts___local *, u32) __ksym;
-void bpf_ct_release(struct nf_conn *) __ksym;
+struct nf_conn *bpf_xdp_ct_alloc(struct xdp_md *, struct bpf_sock_tuple *, u32,
+				 struct bpf_ct_opts___local *, u32) __ksym;
+const struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
+					struct bpf_ct_opts___local *, u32) __ksym;
+struct nf_conn *bpf_skb_ct_alloc(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+				 struct bpf_ct_opts___local *, u32) __ksym;
+const struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+					struct bpf_ct_opts___local *, u32) __ksym;
+const struct nf_conn *
+bpf_ct_insert_entry(struct nf_conn *, struct bpf_ct_opts___local *, u32) __ksym;
+void bpf_ct_release(const struct nf_conn *) __ksym;
+void bpf_ct_refresh_timeout(const struct nf_conn *, u32) __ksym;
 
 static __always_inline void
-nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
-				   struct bpf_ct_opts___local *, u32),
+nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
+					struct bpf_ct_opts___local *, u32),
+	   struct nf_conn *(*alloc_fn)(void *, struct bpf_sock_tuple *, u32,
+				       struct bpf_ct_opts___local *, u32),
 	   void *ctx)
 {
 	struct bpf_ct_opts___local opts_def = { .l4proto = IPPROTO_TCP, .netns_id = -1 };
 	struct bpf_sock_tuple bpf_tuple;
 	struct nf_conn *ct;
+	int err;
 
 	__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));
 
-	ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, NULL, 0, &opts_def, sizeof(opts_def));
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_einval_bpf_tuple = opts_def.error;
 
 	opts_def.reserved[0] = 1;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def));
 	opts_def.reserved[0] = 0;
 	opts_def.l4proto = IPPROTO_TCP;
 	if (ct)
@@ -59,21 +76,24 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
 		test_einval_reserved = opts_def.error;
 
 	opts_def.netns_id = -2;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def));
 	opts_def.netns_id = -1;
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_einval_netns_id = opts_def.error;
 
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def) - 1);
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def) - 1);
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_einval_len_opts = opts_def.error;
 
 	opts_def.l4proto = IPPROTO_ICMP;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def));
 	opts_def.l4proto = IPPROTO_TCP;
 	if (ct)
 		bpf_ct_release(ct);
@@ -81,37 +101,70 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
 		test_eproto_l4proto = opts_def.error;
 
 	opts_def.netns_id = 0xf00f;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def));
 	opts_def.netns_id = -1;
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_enonet_netns_id = opts_def.error;
 
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def));
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_enoent_lookup = opts_def.error;
 
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def,
+		       sizeof(opts_def));
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_eafnosupport = opts_def.error;
+
+	bpf_tuple.ipv4.saddr = bpf_get_prandom_u32(); /* src IP */
+	bpf_tuple.ipv4.daddr = bpf_get_prandom_u32(); /* dst IP */
+	bpf_tuple.ipv4.sport = bpf_get_prandom_u32(); /* src port */
+	bpf_tuple.ipv4.dport = bpf_get_prandom_u32(); /* dst port */
+
+	ct = alloc_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		      sizeof(opts_def));
+	if (ct) {
+		const struct nf_conn *ct_ins;
+
+		ct_ins = bpf_ct_insert_entry(ct, &opts_def, sizeof(opts_def));
+		if (ct_ins) {
+			struct nf_conn *ct_lk;
+
+			ct_lk = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4),
+					  &opts_def, sizeof(opts_def));
+			if (ct_lk) {
+				/* update ct entry timeout */
+				bpf_ct_refresh_timeout(ct_lk, 10000);
+				test_delta_timeout = ct_lk->timeout - bpf_jiffies64();
+				test_delta_timeout /= CONFIG_HZ;
+				bpf_ct_release(ct_lk);
+				test_succ_lookup = 0;
+			}
+			bpf_ct_release(ct_ins);
+			test_insert_entry = 0;
+		}
+		test_alloc_entry = 0;
+	}
 }
 
 SEC("xdp")
 int nf_xdp_ct_test(struct xdp_md *ctx)
 {
-	nf_ct_test((void *)bpf_xdp_ct_lookup, ctx);
+	nf_ct_test((void *)bpf_xdp_ct_lookup, (void *)bpf_xdp_ct_alloc, ctx);
 	return 0;
 }
 
 SEC("tc")
 int nf_skb_ct_test(struct __sk_buff *ctx)
 {
-	nf_ct_test((void *)bpf_skb_ct_lookup, ctx);
+	nf_ct_test((void *)bpf_skb_ct_lookup, (void *)bpf_skb_ct_alloc, ctx);
 	return 0;
 }
 
-- 
2.35.3

