Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF4862ADDC
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiKOWK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiKOWKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:10:54 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2C330562
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 14:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668550252; x=1700086252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/+J2SJGFfiOnwickjgrCYZT4bEgVNKrrWZZlc0+2ECI=;
  b=ckMHvicmKyAi9MpGqbwM7G0cfD8lw853jWVtcDJxwzb2Y9vOdbeDMcYc
   vXmm22cSacELY5NtzSm16Khkk5EZQq40uZvIXJb2wJT/8h1RBEbfAPICu
   tUEnHTOKDs5HSqJHoSoBFcgu2lO4deesNub24/p7MSMcRT+YU1ZFzdS1o
   fdxEPUcj2Lgbbr+cHDGwtaxGfJzzObcwWj7kOaIN7/w3RpazwMbHMLmCk
   SGdGJwnObcRZcJ8uZmBZIlCPeKixKeoFE7Bs7bw7q9dL3OYflRwrC+Og4
   7rfQxi0y1638WkYr270OkiIbG1n8EQmNyTsSi/7/dAyXw4FyQ9EORdYFj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="299906712"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="299906712"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 14:10:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="616917990"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="616917990"
Received: from imunagan-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.21.103])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 14:10:51 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, fw@strlen.de,
        geliang.tang@suse.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/3] selftests: mptcp: gives slow test-case more time
Date:   Tue, 15 Nov 2022 14:10:44 -0800
Message-Id: <20221115221046.20370-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221115221046.20370-1-mathew.j.martineau@linux.intel.com>
References: <20221115221046.20370-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

On slow or busy VM, some test-cases still fail because the
data transfer completes before the endpoint manipulation
actually took effect.

Address the issue by artificially increasing the runtime for
the relevant test-cases.

Fixes: ef360019db40 ("selftests: mptcp: signal addresses testcases")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/309
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f3dd5f2a0272..2eeaf4aca644 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2152,7 +2152,7 @@ remove_tests()
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
-		run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 slow
+		run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 speed_10
 		chk_join_nr 3 3 3
 		chk_add_nr 1 1
 		chk_rm_nr 2 2
@@ -2165,7 +2165,7 @@ remove_tests()
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
 		pm_nl_set_limits $ns2 3 3
-		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
+		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 speed_10
 		chk_join_nr 3 3 3
 		chk_add_nr 3 3
 		chk_rm_nr 3 3 invert
@@ -2178,7 +2178,7 @@ remove_tests()
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
 		pm_nl_set_limits $ns2 3 3
-		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
+		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 speed_10
 		chk_join_nr 1 1 1
 		chk_add_nr 3 3
 		chk_rm_nr 3 1 invert
-- 
2.38.1

