Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBDD5178A1
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 22:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387526AbiEBU4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 16:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387507AbiEBU4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 16:56:14 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B5E6586
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 13:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651524765; x=1683060765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=StQnr+iQV4akj6hXPJMGV6Aj3OnOzSts05MrHXp935A=;
  b=Cm5tJQRDD6qplLHBQaNVvd4VXWFQWpzQq1Ax+PxwKaO2KkwaD29KRayD
   fNmSagSBQxC9QhVu1PgwFXrHB1w3EO1EhobocUegv+jSFYqDFMSsOwvfh
   /voHcqHl0gtgmszEOV9Oym+5u0dFk4pc6Agby7SNovMJ12TN2jifEVVsP
   DFvkdiS9k181IB6CdHMiy7XrJYsDXA5xh351Et03WisjqqiInHvNNGjab
   aydzUdSxh3GscZ0+4LuV9l8/LHFykH4Jj0miyR0yF5JST0oYDW7NxsSOd
   IztH7tXqMPMyRviJ6NhieB5wiglyxqOhDITFO7qCQroHKkVZBzHyb5VHS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="353761112"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="353761112"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="733619569"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.141.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:43 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net-next 2/7] selftests: mptcp: ADD_ADDR echo test with missing userspace daemon
Date:   Mon,  2 May 2022 13:52:32 -0700
Message-Id: <20220502205237.129297-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220502205237.129297-1-mathew.j.martineau@linux.intel.com>
References: <20220502205237.129297-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check userspace PM behavior to ensure ADD_ADDR echoes are only sent when
there is an active userspace daemon. If the daemon is restarting or
hasn't loaded yet, the missing echo will cause the peer to retransmit
the ADD_ADDR - and hopefully the daemon will be ready to receive it at
that later time.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index b27854f976f7..d1de1e7702fb 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2719,6 +2719,17 @@ userspace_tests()
 		chk_add_nr 0 0
 	fi
 
+	# userspace pm type does not echo add_addr without daemon
+	if reset "userspace pm no echo w/o daemon"; then
+		set_userspace_pm $ns2
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 0 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr 0 0 0
+		chk_add_nr 1 0
+	fi
+
 	# userspace pm type rejects join
 	if reset "userspace pm type rejects join"; then
 		set_userspace_pm $ns1
-- 
2.36.0

