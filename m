Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834E45B022E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 12:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiIGK4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 06:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiIGK4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 06:56:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8A979EE0;
        Wed,  7 Sep 2022 03:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB272B81C3A;
        Wed,  7 Sep 2022 10:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3B4C433D7;
        Wed,  7 Sep 2022 10:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662548195;
        bh=ZdsYhMNRXpa+siWudg20LQUtCs/Whh6WN4xVK2FTu/I=;
        h=From:To:Cc:Subject:Date:From;
        b=UFm9T+BznUL9mr8+3eDEA7WEmfxvcCsoVU3T0dRKyTUrIRhDgchu3J/Wje2o7WP7D
         X5if8QDt17HvH4VJvCJef8EGvMx++frL/Rz69rnuh+7uDYofzpPsZIZNJP0yI6VkZZ
         O7AW/xILMQ3/+sBsn9sgB83nWs24eGrctkmBRs16GOL8A1W23oGZFo1Zx58S1+OZb+
         M53BD/rKhDG38Y4tM+DRuekickMYWITMaD5SsWSY2/uQIZuvAz+3k22RdiEEflQ5IL
         pX4c2d6F6I6F3jPw7DN48tPVfeokREEZ0rdnuIhr1nZuWLnl2bkH364WdPF5q/0v2x
         kgm7+I2aqp2UA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, song@kernel.org
Subject: [PATCH bpf-next] selftests/bpf: fix ct status check in bpf_nf selftests
Date:   Wed,  7 Sep 2022 12:56:20 +0200
Message-Id: <f35b32f3303b7cb70a5e55f5fbe0bd3a1d38c9a6.1662548037.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
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

Check properly the connection tracking entry status configured running
bpf_ct_change_status kfunc.
Remove unnecessary IPS_CONFIRMED status configuration since it is
already done during entry allocation.

Fixes: 6eb7fba007a7 ("selftests/bpf: Add tests for new nf_conntrack kfuncs")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 4 ++--
 tools/testing/selftests/bpf/progs/test_bpf_nf.c | 8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index 544bf90ac2a7..903d16e3abed 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -111,8 +111,8 @@ static void test_bpf_nf_ct(int mode)
 	/* allow some tolerance for test_delta_timeout value to avoid races. */
 	ASSERT_GT(skel->bss->test_delta_timeout, 8, "Test for min ct timeout update");
 	ASSERT_LE(skel->bss->test_delta_timeout, 10, "Test for max ct timeout update");
-	/* expected status is IPS_SEEN_REPLY */
-	ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
+	/* expected status is IPS_CONFIRMED | IPS_SEEN_REPLY */
+	ASSERT_EQ(skel->bss->test_status, 0xa, "Test for ct status update ");
 	ASSERT_EQ(skel->data->test_exist_lookup, 0, "Test existing connection lookup");
 	ASSERT_EQ(skel->bss->test_exist_lookup_mark, 43, "Test existing connection lookup ctmark");
 end:
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index 2722441850cc..a3b9d32d1555 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -143,7 +143,6 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 		struct nf_conn *ct_ins;
 
 		bpf_ct_set_timeout(ct, 10000);
-		bpf_ct_set_status(ct, IPS_CONFIRMED);
 
 		ct_ins = bpf_ct_insert_entry(ct);
 		if (ct_ins) {
@@ -156,8 +155,11 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 				bpf_ct_change_timeout(ct_lk, 10000);
 				test_delta_timeout = ct_lk->timeout - bpf_jiffies64();
 				test_delta_timeout /= CONFIG_HZ;
-				test_status = IPS_SEEN_REPLY;
-				bpf_ct_change_status(ct_lk, IPS_SEEN_REPLY);
+
+				bpf_ct_change_status(ct_lk,
+						     IPS_CONFIRMED | IPS_SEEN_REPLY);
+				test_status = ct_lk->status;
+
 				bpf_ct_release(ct_lk);
 				test_succ_lookup = 0;
 			}
-- 
2.37.3

