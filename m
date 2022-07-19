Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE3E57A0B7
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiGSOJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238479AbiGSOII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:08:08 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F63545EF;
        Tue, 19 Jul 2022 06:24:48 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id x91so19592295ede.1;
        Tue, 19 Jul 2022 06:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=753tagyj8X76L4ezcRv5PSx351pmq1kM87wlkW82PS8=;
        b=LfBZDKGZmJqxlBYld7PmB+T5aJfpYd+dsVGugiHeVZPeeIEfwDi6Dqxgk+S5i4qquW
         reZqBfi2b8pHRRJhgiqD96w46gHeJ0B4Z+ckwKFaOTQ6NkcYCrgQJkbmWTV2aM9Mt7zI
         bihbBDz/wkfkRHcAVH5llVJArbOURVIr1nxoIynP4sTaB/Uah5g6dZ7cAFebPBhtuaVf
         tKeiQJTPzZWeDP2BNBZiWXLwLYsCPuMn8GqV2HNRVCo0SwojDb8ma+/Ug5yBq8YjGonx
         U58Bre9K0GO5qYl2Bf2NsJUvb6bXK1/ZeMjMh96zw0hLWDK/GYg0tNzRb5npwfz6yoaJ
         OoKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=753tagyj8X76L4ezcRv5PSx351pmq1kM87wlkW82PS8=;
        b=L8eeeqzvQyH8HMDyXsAAU/MzV2U3+1e/8RW7Ex1x5cSb7N7RNQ2/5z9wE6iEKCsgPY
         sCe27PjHcmgA0ijXNifsLmV/B/XdhnAz8s+H1K59Bak2FQHfKsbR2sYNNaWiZeB1I0xl
         JHMbOtHz5o+psKkRzWhbh4SGlZyT9oRAug8lFOzdOYOEFKoV1mOo9lYdLkyn4WdX233j
         CW4DXwhL6crqiGUmBfPuC24P0HfqbdnHkXJgfvX2XRK0NWJPycSM/pTK/HMdjnXfBt8d
         fL5UWyXIYLVXZZUa92o3Y0vZny60XvTgt6sBOCMPuV3VWSWgLrtZ9rj5W4JkCGgpZn86
         a3+w==
X-Gm-Message-State: AJIora842wll5A/hczbbI9PzvL4Wvb7i0+gDerYoM4TVA3tMKfu7MLWC
        k9dmf/TuZ/kLb0QYLJlTD9H0uyAAcqygTg==
X-Google-Smtp-Source: AGRyM1ssY9xzFeHaTRI4HGoXWc5AgSmAXelVemMf4HRIUYfE6SCJRIw5LLgAmieKs0ijU4X85vrvjQ==
X-Received: by 2002:a05:6402:d72:b0:43b:a7df:7a3c with SMTP id ec50-20020a0564020d7200b0043ba7df7a3cmr115690edb.172.1658237086699;
        Tue, 19 Jul 2022 06:24:46 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id b1-20020aa7df81000000b0043a8286a18csm10536496edy.30.2022.07.19.06.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:46 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v6 11/13] selftests/bpf: Add tests for new nf_conntrack kfuncs
Date:   Tue, 19 Jul 2022 15:24:28 +0200
Message-Id: <20220719132430.19993-12-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8248; i=memxor@gmail.com; h=from:subject; bh=0d6waa3PiGYg4qc4WF7CdySB+x4pPnMzU2MwvX9rbyA=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBmgwO+p+UH8lt0tWUt2jr6BPn1EZNkVf+V+hQf ZMCBJx2JAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZgAKCRBM4MiGSL8RygOwD/ 47QsYlcNzCP6e/VJUqQPV8QFaiYRvBRgh5b2r0EZch0d2MOBS862FYX1oA6lxbwnzzkVznrsftcPWO u1kRBPGKQ2dwMC9NeDWWKSrDqN19aLtSjwpZArjmCpmYvGTiTgAvJglcZrLP3wR9Gr07iVjiq2bgru 2eIUu0/dtRdFO05LZuaYIMUP9/0G9UJ/PYkmIFabTXCRsb2FbgKqUy7HmLqduukr/xZoigRD1yUfXE VG0Bt8pfN3LR85hhxp3eZjpEY0+koseh6eg1p+ff1EJ05hVWmGSB/bjK+5hHhgj3clmVg3mIMQ2SpR K59dma7tCfmAGJ1KkVm3yxSVoj0GWxgWzcYdIAno9UMuWC0S3SwZa6TQ5d5uz/1/Qy5tyGvegslUgH lHQLf7PlJ7lbu4CepJbdhHdGObTEzPE/E4wOf+2gzUpdsPUl8RNP6gepi9VUrZPgLreKuKFsgwluJY LShhBgxTvSbIDdZCmMNEPzPG7WM+5oBCxNEvtDMvTKuV3NnThfO2/Krrdq14PcZUFX91nJzsZ6AOha apfxN24IX/tx2jDTkRG1c5gbMBlDwjPDVeNp6qlLt1EcjdqTLsu2QKBfjB4KvSyLjGoWC6D8I2Naha X16kmPjAmzkoFeGxx1TgsoZNGR1DO5LBQNSdfzuiDH0qQEya+uzvwe7iT//g==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce selftests for the following kfunc helpers:
- bpf_xdp_ct_alloc
- bpf_skb_ct_alloc
- bpf_ct_insert_entry
- bpf_ct_set_timeout
- bpf_ct_change_timeout
- bpf_ct_set_status
- bpf_ct_change_status

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  8 ++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 85 ++++++++++++++++---
 2 files changed, 81 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index dd30b1e3a67c..cbada73a61f8 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -39,6 +39,14 @@ void test_bpf_nf_ct(int mode)
 	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
 	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
 	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSUPPORT for invalid len__tuple");
+	ASSERT_EQ(skel->data->test_alloc_entry, 0, "Test for alloc new entry");
+	ASSERT_EQ(skel->data->test_insert_entry, 0, "Test for insert new entry");
+	ASSERT_EQ(skel->data->test_succ_lookup, 0, "Test for successful lookup");
+	/* allow some tolerance for test_delta_timeout value to avoid races. */
+	ASSERT_GT(skel->bss->test_delta_timeout, 8, "Test for min ct timeout update");
+	ASSERT_LE(skel->bss->test_delta_timeout, 10, "Test for max ct timeout update");
+	/* expected status is IPS_SEEN_REPLY */
+	ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
 end:
 	test_bpf_nf__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index f00a9731930e..196cd8dfe42a 100644
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
@@ -16,6 +18,11 @@ int test_eproto_l4proto = 0;
 int test_enonet_netns_id = 0;
 int test_enoent_lookup = 0;
 int test_eafnosupport = 0;
+int test_alloc_entry = -EINVAL;
+int test_insert_entry = -EAFNOSUPPORT;
+int test_succ_lookup = -ENOENT;
+u32 test_delta_timeout = 0;
+u32 test_status = 0;
 
 struct nf_conn;
 
@@ -26,31 +33,44 @@ struct bpf_ct_opts___local {
 	u8 reserved[3];
 } __attribute__((preserve_access_index));
 
+struct nf_conn *bpf_xdp_ct_alloc(struct xdp_md *, struct bpf_sock_tuple *, u32,
+				 struct bpf_ct_opts___local *, u32) __ksym;
 struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
 				  struct bpf_ct_opts___local *, u32) __ksym;
+struct nf_conn *bpf_skb_ct_alloc(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+				 struct bpf_ct_opts___local *, u32) __ksym;
 struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
 				  struct bpf_ct_opts___local *, u32) __ksym;
+struct nf_conn *bpf_ct_insert_entry(struct nf_conn *) __ksym;
 void bpf_ct_release(struct nf_conn *) __ksym;
+void bpf_ct_set_timeout(struct nf_conn *, u32) __ksym;
+int bpf_ct_change_timeout(struct nf_conn *, u32) __ksym;
+int bpf_ct_set_status(struct nf_conn *, u32) __ksym;
+int bpf_ct_change_status(struct nf_conn *, u32) __ksym;
 
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
@@ -59,21 +79,24 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
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
@@ -81,37 +104,75 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
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
+		struct nf_conn *ct_ins;
+
+		bpf_ct_set_timeout(ct, 10000);
+		bpf_ct_set_status(ct, IPS_CONFIRMED);
+
+		ct_ins = bpf_ct_insert_entry(ct);
+		if (ct_ins) {
+			struct nf_conn *ct_lk;
+
+			ct_lk = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4),
+					  &opts_def, sizeof(opts_def));
+			if (ct_lk) {
+				/* update ct entry timeout */
+				bpf_ct_change_timeout(ct_lk, 10000);
+				test_delta_timeout = ct_lk->timeout - bpf_jiffies64();
+				test_delta_timeout /= CONFIG_HZ;
+				test_status = IPS_SEEN_REPLY;
+				bpf_ct_change_status(ct_lk, IPS_SEEN_REPLY);
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
2.34.1

