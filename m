Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0655B1643
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiIHIGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 04:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiIHIG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:06:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0540D2B3A;
        Thu,  8 Sep 2022 01:06:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B45261BBC;
        Thu,  8 Sep 2022 08:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5734CC4347C;
        Thu,  8 Sep 2022 08:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662624383;
        bh=99N8urgmXc1eLWiQJCkk4lIJ8riw3A9WweOprQIo+KE=;
        h=From:To:Cc:Subject:Date:From;
        b=YmBrTiybj0Ivgs2gDTsXWD+HM0PRsIp5we8N4JpMBxWM0NFdouusm3G1sda2XVC2q
         jGflQERFNsybjhmDM8okYUuOC9/Ti7bf9l9k4EODrUiwD92A4/oRZ0xiQdAamiED13
         Zirgu43N/F/XQbj4Hl1P5h7KAcbouBpiKLmnFTx1isfBmWoZwELH9SZheYShKfZm1W
         rmcObPipBkzoGX6kWsBugCBzv/mdkrqedOtY+SKS+KGlaJdHzP4HdhI9zIxGS7I2L0
         7Q1g5E+koN6Q4KUNHizC2kvNyheRtKUi3XUqcrCGxltLHrcuJrudnkLciOT6mVTMSj
         Qvg1rR/GwN83w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, song@kernel.org
Subject: [PATCH v2 bpf-next] selftests/bpf: fix ct status check in bpf_nf selftests
Date:   Thu,  8 Sep 2022 10:06:12 +0200
Message-Id: <813a5161a71911378dfac8770ec890428e4998aa.1662623574.git.lorenzo@kernel.org>
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
Change since v1:
- rely on nf_conntrack_common.h definitions for ct status in bpf_nf.c
---
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 5 +++--
 tools/testing/selftests/bpf/progs/test_bpf_nf.c | 8 +++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index 544bf90ac2a7..cdaf6a7d6fd1 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 #include <network_helpers.h>
+#include <linux/netfilter/nf_conntrack_common.h>
 #include "test_bpf_nf.skel.h"
 #include "test_bpf_nf_fail.skel.h"
 
@@ -111,8 +112,8 @@ static void test_bpf_nf_ct(int mode)
 	/* allow some tolerance for test_delta_timeout value to avoid races. */
 	ASSERT_GT(skel->bss->test_delta_timeout, 8, "Test for min ct timeout update");
 	ASSERT_LE(skel->bss->test_delta_timeout, 10, "Test for max ct timeout update");
-	/* expected status is IPS_SEEN_REPLY */
-	ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
+	ASSERT_EQ(skel->bss->test_status, IPS_CONFIRMED | IPS_SEEN_REPLY,
+		  "Test for ct status update ");
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

