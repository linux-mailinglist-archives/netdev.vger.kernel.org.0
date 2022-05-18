Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FE752B7DC
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbiERKop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 06:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235241AbiERKoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 06:44:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9702554BCC;
        Wed, 18 May 2022 03:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10B6B61840;
        Wed, 18 May 2022 10:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501B5C34100;
        Wed, 18 May 2022 10:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652870676;
        bh=kSpRpX3P4g2A4vrclG8r1uoE1sxRCKozf25POewosQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PH7+jX9xlh5GHQ06bEAlSBG22XwKOmITlSAzl46JPAbfGTyXCRFXPFkdCg5z/T0l/
         vrgoupg9PkS7EVdldyU+t+NfEMtpSlVO8XNd55akZDyqPt7vm/5x8kMbiPILVp+8t6
         c5tj4StXU9+K0JACLqbzVtS6kFvwBlPHey3C8tYlWm0CZimVI61sqbrqkYCIirh2KV
         /9R7gVAcTcq2/yLLA99T7sl1auXm6Emfrfv91pnBkfLJ6zNBIhSuLauY5iMMzv83uD
         K/xUH5I3/fV0tKo94N/ptsstOzEQVID9D3CRRtq5KbabGf2/K6SSRXtRHYnoZb6xaJ
         vuGuj3cM6LkAw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v3 bpf-next 5/5] selftests/bpf: add selftest for bpf_xdp_ct_add and bpf_ct_refresh_timeout kfunc
Date:   Wed, 18 May 2022 12:43:38 +0200
Message-Id: <e95abdd9c6fa1fa97f3ca60e8eb06799784e671a.1652870182.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652870182.git.lorenzo@kernel.org>
References: <cover.1652870182.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce selftests for the following kfunc helpers:
- bpf_xdp_ct_add
- bpf_skb_ct_add
- bpf_ct_refresh_timeout

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  4 ++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 72 +++++++++++++++----
 2 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index dd30b1e3a67c..be6c5650892f 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -39,6 +39,10 @@ void test_bpf_nf_ct(int mode)
 	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
 	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
 	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSUPPORT for invalid len__tuple");
+	ASSERT_EQ(skel->bss->test_add_entry, 0, "Test for adding new entry");
+	ASSERT_EQ(skel->bss->test_succ_lookup, 0, "Test for successful lookup");
+	ASSERT_TRUE(skel->bss->test_delta_timeout > 9 && skel->bss->test_delta_timeout <= 10,
+		    "Test for ct timeout update");
 end:
 	test_bpf_nf__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index f00a9731930e..361430dde3f7 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 
 #define EAFNOSUPPORT 97
 #define EPROTO 71
@@ -8,6 +9,8 @@
 #define EINVAL 22
 #define ENOENT 2
 
+extern unsigned long CONFIG_HZ __kconfig;
+
 int test_einval_bpf_tuple = 0;
 int test_einval_reserved = 0;
 int test_einval_netns_id = 0;
@@ -16,6 +19,9 @@ int test_eproto_l4proto = 0;
 int test_enonet_netns_id = 0;
 int test_enoent_lookup = 0;
 int test_eafnosupport = 0;
+int test_add_entry = 0;
+int test_succ_lookup = 0;
+u32 test_delta_timeout = 0;
 
 struct nf_conn;
 
@@ -26,31 +32,40 @@ struct bpf_ct_opts___local {
 	u8 reserved[3];
 } __attribute__((preserve_access_index));
 
+struct nf_conn *bpf_xdp_ct_add(struct xdp_md *, struct bpf_sock_tuple *, u32,
+			       struct bpf_ct_opts___local *, u32) __ksym;
 struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
 				  struct bpf_ct_opts___local *, u32) __ksym;
+struct nf_conn *bpf_skb_ct_add(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+			       struct bpf_ct_opts___local *, u32) __ksym;
 struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
 				  struct bpf_ct_opts___local *, u32) __ksym;
 void bpf_ct_release(struct nf_conn *) __ksym;
+void bpf_ct_refresh_timeout(struct nf_conn *, u32) __ksym;
 
 static __always_inline void
-nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
-				   struct bpf_ct_opts___local *, u32),
+nf_ct_test(struct nf_conn *(*look_fn)(void *, struct bpf_sock_tuple *, u32,
+				      struct bpf_ct_opts___local *, u32),
+	   struct nf_conn *(*add_fn)(void *, struct bpf_sock_tuple *, u32,
+				     struct bpf_ct_opts___local *, u32),
 	   void *ctx)
 {
 	struct bpf_ct_opts___local opts_def = { .l4proto = IPPROTO_TCP, .netns_id = -1 };
 	struct bpf_sock_tuple bpf_tuple;
 	struct nf_conn *ct;
+	int err;
 
 	__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));
 
-	ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));
+	ct = look_fn(ctx, NULL, 0, &opts_def, sizeof(opts_def));
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_einval_bpf_tuple = opts_def.error;
 
 	opts_def.reserved[0] = 1;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		     sizeof(opts_def));
 	opts_def.reserved[0] = 0;
 	opts_def.l4proto = IPPROTO_TCP;
 	if (ct)
@@ -59,21 +74,24 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
 		test_einval_reserved = opts_def.error;
 
 	opts_def.netns_id = -2;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		     sizeof(opts_def));
 	opts_def.netns_id = -1;
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_einval_netns_id = opts_def.error;
 
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def) - 1);
+	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		     sizeof(opts_def) - 1);
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_einval_len_opts = opts_def.error;
 
 	opts_def.l4proto = IPPROTO_ICMP;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		     sizeof(opts_def));
 	opts_def.l4proto = IPPROTO_TCP;
 	if (ct)
 		bpf_ct_release(ct);
@@ -81,37 +99,67 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
 		test_eproto_l4proto = opts_def.error;
 
 	opts_def.netns_id = 0xf00f;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		     sizeof(opts_def));
 	opts_def.netns_id = -1;
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_enonet_netns_id = opts_def.error;
 
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		     sizeof(opts_def));
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_enoent_lookup = opts_def.error;
 
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def, sizeof(opts_def));
+	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def,
+		     sizeof(opts_def));
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_eafnosupport = opts_def.error;
+
+	bpf_tuple.ipv4.saddr = bpf_get_prandom_u32(); /* src IP */
+	bpf_tuple.ipv4.daddr = bpf_get_prandom_u32(); /* dst IP */
+	bpf_tuple.ipv4.sport = bpf_htons(bpf_get_prandom_u32()); /* src port */
+	bpf_tuple.ipv4.dport = bpf_htons(bpf_get_prandom_u32()); /* dst port */
+
+	ct = add_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		    sizeof(opts_def));
+	if (ct) {
+		struct nf_conn *ct_lk;
+
+		ct_lk = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4),
+				&opts_def, sizeof(opts_def));
+		if (ct_lk) {
+			/* update ct entry timeout */
+			bpf_ct_refresh_timeout(ct_lk, 10000);
+			test_delta_timeout = ct_lk->timeout - bpf_jiffies64();
+			test_delta_timeout /= CONFIG_HZ;
+			bpf_ct_release(ct_lk);
+		} else {
+			test_succ_lookup = opts_def.error;
+		}
+		bpf_ct_release(ct);
+	} else {
+		test_add_entry = opts_def.error;
+		test_succ_lookup = opts_def.error;
+	}
 }
 
 SEC("xdp")
 int nf_xdp_ct_test(struct xdp_md *ctx)
 {
-	nf_ct_test((void *)bpf_xdp_ct_lookup, ctx);
+	nf_ct_test((void *)bpf_xdp_ct_lookup, (void *)bpf_xdp_ct_add, ctx);
 	return 0;
 }
 
 SEC("tc")
 int nf_skb_ct_test(struct __sk_buff *ctx)
 {
-	nf_ct_test((void *)bpf_skb_ct_lookup, ctx);
+	nf_ct_test((void *)bpf_skb_ct_lookup, (void *)bpf_skb_ct_add, ctx);
 	return 0;
 }
 
-- 
2.35.3

