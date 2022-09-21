Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546685C04C5
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 18:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiIUQx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 12:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiIUQwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 12:52:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDECF18E1F;
        Wed, 21 Sep 2022 09:49:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2CE663218;
        Wed, 21 Sep 2022 16:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1127BC433D6;
        Wed, 21 Sep 2022 16:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663778951;
        bh=lqBzqchzgP9khwezMjqVVVAdNgz8wFoX3F/n/OGdru0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nkp04hDwxIMMwPDL5ABiq/OnjxOP7pmxXsygIVVKZQM3SKNyXYWF7iC5Wn+poheSf
         YcD130zbWVVqHRvC9SSp2ZdsAvmhatM46uYoj5mhlcdL+LZWRdGKYZWaafCHl+ew2f
         ZcwUxoLaKz761ZZG37NhfYgJVvhmcsRaaYUvv+LKFLguXpdM1ST2Rj/vc4AeNTCVuV
         WXxJHogYagO/6BZuRwwPtdMyrC9wHYudh/Z6e/8/V2CpSZJS6uA7jykLDEp/fJFuvX
         6u6eJPuIo1ZqYi+/t96BuU7dF5weODs/VkU3nqsCScEg5Z/bwFPaNRexRQp4SA8fX+
         FA85UcDkk2v9w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v3 bpf-next 3/3] selftests/bpf: add tests for bpf_ct_set_nat_info kfunc
Date:   Wed, 21 Sep 2022 18:48:27 +0200
Message-Id: <803e33294e247744d466943105879414344d3235.1663778601.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663778601.git.lorenzo@kernel.org>
References: <cover.1663778601.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce self-tests for bpf_ct_set_nat_info kfunc used to set the
source or destination nat addresses/ports.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/testing/selftests/bpf/config            |  1 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c | 10 ++++---
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 27 +++++++++++++++++++
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 3fc46f9cfb22..8ce48f7213cb 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -57,6 +57,7 @@ CONFIG_NF_CONNTRACK=y
 CONFIG_NF_CONNTRACK_MARK=y
 CONFIG_NF_DEFRAG_IPV4=y
 CONFIG_NF_DEFRAG_IPV6=y
+CONFIG_NF_NAT=y
 CONFIG_RC_CORE=y
 CONFIG_SECURITY=y
 CONFIG_SECURITYFS=y
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index 0677a51694c9..8a838ea8bdf3 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -26,7 +26,10 @@ enum {
 	TEST_TC_BPF,
 };
 
-#define TIMEOUT_MS 3000
+#define TIMEOUT_MS		3000
+#define IPS_STATUS_MASK		(IPS_CONFIRMED | IPS_SEEN_REPLY | \
+				 IPS_SRC_NAT_DONE | IPS_DST_NAT_DONE | \
+				 IPS_SRC_NAT | IPS_DST_NAT)
 
 static int connect_to_server(int srv_fd)
 {
@@ -114,10 +117,11 @@ static void test_bpf_nf_ct(int mode)
 	ASSERT_GT(skel->bss->test_delta_timeout, 8, "Test for min ct timeout update");
 	ASSERT_LE(skel->bss->test_delta_timeout, 10, "Test for max ct timeout update");
 	ASSERT_EQ(skel->bss->test_insert_lookup_mark, 77, "Test for insert and lookup mark value");
-	ASSERT_EQ(skel->bss->test_status, IPS_CONFIRMED | IPS_SEEN_REPLY,
-		  "Test for ct status update ");
+	ASSERT_EQ(skel->bss->test_status, IPS_STATUS_MASK, "Test for ct status update ");
 	ASSERT_EQ(skel->data->test_exist_lookup, 0, "Test existing connection lookup");
 	ASSERT_EQ(skel->bss->test_exist_lookup_mark, 43, "Test existing connection lookup ctmark");
+	ASSERT_EQ(skel->data->test_snat_addr, 0, "Test for source natting");
+	ASSERT_EQ(skel->data->test_dnat_addr, 0, "Test for destination natting");
 end:
 	if (srv_client_fd != -1)
 		close(srv_client_fd);
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index 88842da86ddc..227e85e85dda 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 
 #define EAFNOSUPPORT 97
 #define EPROTO 71
@@ -24,6 +25,8 @@ int test_succ_lookup = -ENOENT;
 u32 test_delta_timeout = 0;
 u32 test_status = 0;
 u32 test_insert_lookup_mark = 0;
+int test_snat_addr = -EINVAL;
+int test_dnat_addr = -EINVAL;
 __be32 saddr = 0;
 __be16 sport = 0;
 __be32 daddr = 0;
@@ -54,6 +57,8 @@ void bpf_ct_set_timeout(struct nf_conn *, u32) __ksym;
 int bpf_ct_change_timeout(struct nf_conn *, u32) __ksym;
 int bpf_ct_set_status(struct nf_conn *, u32) __ksym;
 int bpf_ct_change_status(struct nf_conn *, u32) __ksym;
+int bpf_ct_set_nat_info(struct nf_conn *, union nf_inet_addr *,
+			int port, enum nf_nat_manip_type) __ksym;
 
 static __always_inline void
 nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
@@ -141,11 +146,22 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 	ct = alloc_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
 		      sizeof(opts_def));
 	if (ct) {
+		__u16 sport = bpf_get_prandom_u32();
+		__u16 dport = bpf_get_prandom_u32();
+		union nf_inet_addr saddr = {};
+		union nf_inet_addr daddr = {};
 		struct nf_conn *ct_ins;
 
 		bpf_ct_set_timeout(ct, 10000);
 		ct->mark = 77;
 
+		/* snat */
+		saddr.ip = bpf_get_prandom_u32();
+		bpf_ct_set_nat_info(ct, &saddr, sport, NF_NAT_MANIP_SRC);
+		/* dnat */
+		daddr.ip = bpf_get_prandom_u32();
+		bpf_ct_set_nat_info(ct, &daddr, dport, NF_NAT_MANIP_DST);
+
 		ct_ins = bpf_ct_insert_entry(ct);
 		if (ct_ins) {
 			struct nf_conn *ct_lk;
@@ -153,6 +169,17 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 			ct_lk = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4),
 					  &opts_def, sizeof(opts_def));
 			if (ct_lk) {
+				struct nf_conntrack_tuple *tuple;
+
+				/* check snat and dnat addresses */
+				tuple = &ct_lk->tuplehash[IP_CT_DIR_REPLY].tuple;
+				if (tuple->dst.u3.ip == saddr.ip &&
+				    tuple->dst.u.all == bpf_htons(sport))
+					test_snat_addr = 0;
+				if (tuple->src.u3.ip == daddr.ip &&
+				    tuple->src.u.all == bpf_htons(dport))
+					test_dnat_addr = 0;
+
 				/* update ct entry timeout */
 				bpf_ct_change_timeout(ct_lk, 10000);
 				test_delta_timeout = ct_lk->timeout - bpf_jiffies64();
-- 
2.37.3

