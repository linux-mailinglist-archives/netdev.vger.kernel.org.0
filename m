Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5172757CC63
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiGUNoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiGUNnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:43:23 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9BB84ECA;
        Thu, 21 Jul 2022 06:43:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id bv24so2352340wrb.3;
        Thu, 21 Jul 2022 06:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=753tagyj8X76L4ezcRv5PSx351pmq1kM87wlkW82PS8=;
        b=EPAFiJAlDHbgQ9aaHqlDxmAv/meB2Bd+3sp8fYFXQiWkVY7azWhy/TKX7AiIGG6Xkk
         K6TzNWPQFteqyCvhcIoTU18hoSTz2oDsbsU4+GkpK+tSewbMiBIsCF3c69COl0VIkE/n
         JVhS0BagW9d8bvev1vGOLvs7VDGLG366XyNAFBBTTLeMWhj/J1eFngPYz/NngTW9WWg1
         AvfurN1aMfRiB5caR48DatJdnFATNEmmoqIV2dukWFCmyby7r+9CsoLOQwI7Liui5x70
         sfDFI8tX7xGxXXV2IxaIcjy/V3v0JQaAGJVWcORer43ktjmOajvuBYsEyh7bFCKsTqow
         EoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=753tagyj8X76L4ezcRv5PSx351pmq1kM87wlkW82PS8=;
        b=tfpw4horEA5OSmXlNNLNAltw/TujzTWne9OaUViQOxzRt3FOJpplWtf8ju9YtGPbOs
         Jf+Nr3tSX62qOLdasYP34R2+8syAm6V6BEDTrhf6RzlSb5ps38IIB0sxJdBB0LjWV4R+
         Wr3b/pQO2Sz3HZT96n4Splc7UrU+ERmdhj3uy0KRFxtqDApCj46SAc+7TzK78iTU9zSF
         SBQ29qfOxhY1/mgx7yxz/Tud2LpXUvt+xUb81UgKs2mMYySi9WnwPLEFEM9h29vPXw8a
         UEBwcMzyzCI9R2Iec0Ofb6iRcPFLf+z4VSYxJ9HntXY9/hArOYRzaDnObNGxkk4JGnrl
         ujSA==
X-Gm-Message-State: AJIora/c1sVy46SQ0hO7KpE1fXQPU4FKtJynS/EPPCgjkS/CQg/PVnp7
        /gz1iXd/PJb4dF/3XQd5zlyAlNflc0tQNA==
X-Google-Smtp-Source: AGRyM1uokmagtlO6UstwKqnGU3UD9US6GkmQTIpWrHzNlzdbMbNLTYXh5FgRLfOT7xhgiVqPfMNFbA==
X-Received: by 2002:a05:6000:1e11:b0:21d:a4b1:e1f9 with SMTP id bj17-20020a0560001e1100b0021da4b1e1f9mr34000930wrb.104.1658410981747;
        Thu, 21 Jul 2022 06:43:01 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id r17-20020adfe691000000b0020d07d90b71sm2021712wrm.66.2022.07.21.06.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:01 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 11/13] selftests/bpf: Add tests for new nf_conntrack kfuncs
Date:   Thu, 21 Jul 2022 15:42:43 +0200
Message-Id: <20220721134245.2450-12-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
References: <20220721134245.2450-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8248; i=memxor@gmail.com; h=from:subject; bh=0d6waa3PiGYg4qc4WF7CdySB+x4pPnMzU2MwvX9rbyA=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfOgwO+p+UH8lt0tWUt2jr6BPn1EZNkVf+V+hQf ZMCBJx2JAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzgAKCRBM4MiGSL8RyjknD/ 9BqVRKVLxNuR5vBI6WZQYBpJHdhZHTG/NijYofwooFv23UgGW2Ur8N4nCph8KW7TWyo3LKeEv2ptyS 2qxgICb09AJu9S6x8hZtwo1RGRr+EyfnasCIurKsVGy8Wb55aIvKbziWrSVUqyNjP4rr++XRnUGnXg kmAvc11KyOwXEbVbF9Ie4cbYEQ9jVLpyCduNCPfmzV+QRwEkEIO/Xhy4TN7jJiEwMllZz8r/JbD09V hrHJjYMt8NrE/KVGWCzIRjl9Zev6480PAkIkk4viX8/7ZCSxwHvArq562dIsHXYwIg5hNAlE4lUrP1 mxR6gIprubSt1q31PAv76scymtGVMoBc8XALtDJMnywFuCHKmG7yLRB8w9zIpTohpiBgzEgLDqbLtG FAh27DnQrshUaM3aof69hOC1I0CWOUMTygCztL0lTMmFKp2MuRL4ZM1uR3xXWecoE0MvWgPuXgPlqc vPIKFo1yh2VY+s5I2q4LAG5LZS1vtbQ0Bza0JAOc9HoMPEOKooQ0Fs5S8/Ic6LRdH0iBpSSpuAVDjo VV9ZMEDVgm5UXXjMDluDAnORzstp0oXPgcH9Wg7h8DPY5B7nk4tsJNTRzpNe3izhd70KnQ/x7flAAI Y5WWjh7BGCPKZJsIHmDEaTdSe6fU8sxLgHPxnBbYcXHISEXMaULw5EDVHzlw==
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

