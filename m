Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84525A9D54
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 18:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbiIAQo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 12:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbiIAQoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 12:44:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B478697D54;
        Thu,  1 Sep 2022 09:44:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39E9A61FB2;
        Thu,  1 Sep 2022 16:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBFAC433C1;
        Thu,  1 Sep 2022 16:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662050651;
        bh=GQ4gOYDMPK934rNxxVnxVtbgg75tSaYbmsGMejtNvBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tcjtt3KhRs+/Uptynhcv5GV4KMNjePsR/rgWk+q4D33wY4GjBF0LlR4P+BZ6Z1azN
         gWPJbqsKTFEU5+r1ROYw60fgLtgyJhIKDN6+8XePv74LSu0F6GKmaREMTHLM2mtCbA
         ch4pf47MIXkTS1+0UYEHYlwUDPxMEXRpyHp1VqlSkRcjFg7qrxwf0SJDHiei9qlSsl
         cBkzfYIa5NqgiTpb22uShs0QLjvmJHoYvw7Pt7x7q6bUUCaQVppXeayjB8cUhq5oN9
         U5WSeBnID1EzfanjB1EaXm+YPPMTU6eAFn+0j28ooy7XhK5pr5sNipUzRktp2xCXlE
         CeicGG5b88H/Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH bpf-next 4/4] selftests/bpf: add tests for bpf_ct_set_nat_info kfunc
Date:   Thu,  1 Sep 2022 18:43:27 +0200
Message-Id: <f6dc49beac05a802398a8f61eef600fe96593271.1662050126.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662050126.git.lorenzo@kernel.org>
References: <cover.1662050126.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce self-tests for bpf_ct_set_nat_info kfunc used to set the
source or destination nat addresses/ports.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  2 ++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 ++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index 544bf90ac2a7..f16913f8fca2 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -115,6 +115,8 @@ static void test_bpf_nf_ct(int mode)
 	ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
 	ASSERT_EQ(skel->data->test_exist_lookup, 0, "Test existing connection lookup");
 	ASSERT_EQ(skel->bss->test_exist_lookup_mark, 43, "Test existing connection lookup ctmark");
+	ASSERT_EQ(skel->data->test_snat_addr, 0, "Test for source natting");
+	ASSERT_EQ(skel->data->test_dnat_addr, 0, "Test for destination natting");
 end:
 	if (srv_client_fd != -1)
 		close(srv_client_fd);
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index 2722441850cc..3f441595098b 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -23,6 +23,8 @@ int test_insert_entry = -EAFNOSUPPORT;
 int test_succ_lookup = -ENOENT;
 u32 test_delta_timeout = 0;
 u32 test_status = 0;
+int test_snat_addr = -EINVAL;
+int test_dnat_addr = -EINVAL;
 __be32 saddr = 0;
 __be16 sport = 0;
 __be32 daddr = 0;
@@ -53,6 +55,8 @@ void bpf_ct_set_timeout(struct nf_conn *, u32) __ksym;
 int bpf_ct_change_timeout(struct nf_conn *, u32) __ksym;
 int bpf_ct_set_status(struct nf_conn *, u32) __ksym;
 int bpf_ct_change_status(struct nf_conn *, u32) __ksym;
+int bpf_ct_set_nat_info(struct nf_conn *, union nf_inet_addr *,
+			__be16 *port, enum nf_nat_manip_type) __ksym;
 
 static __always_inline void
 nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
@@ -140,10 +144,19 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 	ct = alloc_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
 		      sizeof(opts_def));
 	if (ct) {
+		__be16 sport = bpf_get_prandom_u32();
+		__be16 dport = bpf_get_prandom_u32();
+		union nf_inet_addr saddr = {};
+		union nf_inet_addr daddr = {};
 		struct nf_conn *ct_ins;
 
 		bpf_ct_set_timeout(ct, 10000);
-		bpf_ct_set_status(ct, IPS_CONFIRMED);
+		/* snat */
+		saddr.ip = bpf_get_prandom_u32();
+		bpf_ct_set_nat_info(ct, &saddr, &sport, NF_NAT_MANIP_SRC);
+		/* dnat */
+		daddr.ip = bpf_get_prandom_u32();
+		bpf_ct_set_nat_info(ct, &daddr, &dport, NF_NAT_MANIP_DST);
 
 		ct_ins = bpf_ct_insert_entry(ct);
 		if (ct_ins) {
@@ -152,6 +165,17 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 			ct_lk = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4),
 					  &opts_def, sizeof(opts_def));
 			if (ct_lk) {
+				struct nf_conntrack_tuple *tuple;
+
+				/* check snat and dnat addresses */
+				tuple = &ct_lk->tuplehash[IP_CT_DIR_REPLY].tuple;
+				if (tuple->dst.u3.ip == saddr.ip &&
+				    tuple->dst.u.all == sport)
+					test_snat_addr = 0;
+				if (tuple->src.u3.ip == daddr.ip &&
+				    tuple->src.u.all == dport)
+					test_dnat_addr = 0;
+
 				/* update ct entry timeout */
 				bpf_ct_change_timeout(ct_lk, 10000);
 				test_delta_timeout = ct_lk->timeout - bpf_jiffies64();
-- 
2.37.2

