Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9F75252AD
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356527AbiELQe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356522AbiELQez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:34:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A5F267C20;
        Thu, 12 May 2022 09:34:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71959B829F0;
        Thu, 12 May 2022 16:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9ACC385B8;
        Thu, 12 May 2022 16:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652373292;
        bh=rKK4g1rn/Rdh5TkC2xdx5a2+qdGbLS4V/bDKfwdxafk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhTn2KTmFLaw6BEaUPz2uAkBHPJDSIK0JWo/GBOXSzhXfrtt+BOZhwvsB37J/qpjL
         n9l2JgiWwHU143CMm7CiyUm1WalWn8wzHFOc0ZzGjmTL/UTFrOKxi4o8Jdd6sKZ+Px
         wb3Lc/1qk3zCEddVEl4dh2cj9RHlWCSjFuTjSon9iExw1bOk2OxHyb2TvtwrL4f58K
         ZTXINuzdyJZlsdjabqEXcSXsxCGD949h3qwPUTi963eGDBvHJ9nztcz9y1Zvw3pHKv
         hNJ4kJ/VXd3sqVAftonfK16r+63znDz0IMsOAYnxHyeax6Gl4iWAhhGtqL98DoTNvW
         F6twU+r+md39g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, toke@redhat.com, memxor@gmail.com
Subject: [PATCH v2 bpf-next 2/2] selftests/bpf: add selftest for bpf_ct_refresh_timeout kfunc
Date:   Thu, 12 May 2022 18:34:11 +0200
Message-Id: <4841edea5de2ce5898092c057f61d45dec3d9a34.1652372970.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652372970.git.lorenzo@kernel.org>
References: <cover.1652372970.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Install a new ct entry in order to perform a successful lookup and
test bpf_ct_refresh_timeout kfunc helper.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/bpf_nf.c | 10 +++++++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 22 +++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index dd30b1e3a67c..285687d2f7b3 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -18,6 +18,13 @@ void test_bpf_nf_ct(int mode)
 		.repeat = 1,
 	);
 
+	/* Flush previous nft ct entries */
+	ASSERT_OK(system("conntrack -F"), "flush ct entries");
+	/* Let's create a nft ct entry to perform lookup */
+	ASSERT_OK(system("conntrack -I -s 1.1.1.1 -d 2.2.2.2 --protonum 6  \
+			  --state ESTABLISHED --timeout 3600 --sport 12345 \
+			  --dport 1000 --zone 0"), "create ct entry");
+
 	skel = test_bpf_nf__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "test_bpf_nf__open_and_load"))
 		return;
@@ -39,6 +46,9 @@ void test_bpf_nf_ct(int mode)
 	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
 	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
 	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSUPPORT for invalid len__tuple");
+	ASSERT_EQ(skel->bss->test_succ_lookup, 0, "Test for successful lookup");
+	ASSERT_EQ(skel->bss->test_delta_timeout, 10, "Test for ct timeout update");
+
 end:
 	test_bpf_nf__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index f00a9731930e..3eb36679a0b5 100644
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
@@ -16,6 +19,8 @@ int test_eproto_l4proto = 0;
 int test_enonet_netns_id = 0;
 int test_enoent_lookup = 0;
 int test_eafnosupport = 0;
+int test_succ_lookup = 0;
+u32 test_delta_timeout = 0;
 
 struct nf_conn;
 
@@ -31,6 +36,7 @@ struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
 struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
 				  struct bpf_ct_opts___local *, u32) __ksym;
 void bpf_ct_release(struct nf_conn *) __ksym;
+void bpf_ct_refresh_timeout(struct nf_conn *, u32) __ksym;
 
 static __always_inline void
 nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
@@ -99,6 +105,22 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
 		bpf_ct_release(ct);
 	else
 		test_eafnosupport = opts_def.error;
+
+	bpf_tuple.ipv4.saddr = 0x01010101; /* src IP 1.1.1.1 */
+	bpf_tuple.ipv4.daddr = 0x02020202; /* dst IP 2.2.2.2 */
+	bpf_tuple.ipv4.sport = bpf_htons(12345); /* src port */
+	bpf_tuple.ipv4.dport = bpf_htons(1000);  /* dst port */
+	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		  sizeof(opts_def));
+	if (ct) {
+		/* update ct entry timeout */
+		bpf_ct_refresh_timeout(ct, 10000);
+		test_delta_timeout = ct->timeout - bpf_jiffies64();
+		test_delta_timeout /= CONFIG_HZ;
+		bpf_ct_release(ct);
+	} else {
+		test_succ_lookup = opts_def.error;
+	}
 }
 
 SEC("xdp")
-- 
2.35.3

