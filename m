Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055DF570A81
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 21:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiGKTQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 15:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiGKTQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 15:16:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADAB2A970
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 12:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657567001; x=1689103001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sX26Sc/Ae3nAyNsrp8P8AJWuFq/C3wjAC5FxQqFb5uw=;
  b=Q4PcaTAaCaVK61S/bgnau8GwY5/SNDEv22cglf5AngDX+mq3b7SBxFD0
   20AHPgGRaSKiHfEO0KKv8Rvr80h+pP3IFjCOukox6j1Mnr8VqxJP6c3QP
   K7Sg9BcX+N/hQ1vBwgL4A43XA7L1pFpAWTIIQFew3eKpLLe/4wdvT0mdt
   UhW6Y7f+NLvVrXCKdhTQW16onkfr8HEm72A/tl01S9Yr6HzWBEgG3Vhtz
   RfkJR7CgJd+LiyRulXMojkGKkJV8TbDc1gt66M4bnvG7L+ZJ+IAEZxUuQ
   kRxF2G01kOAryTlQUShv6IMUBL35kB5rsU6Gj/1Ee2LXdKoxIpKDdSPTp
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="282300988"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="282300988"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 12:16:40 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="697742717"
Received: from eedeets-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.2.111])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 12:16:39 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/5] selftests: mptcp: add MPC backup tests
Date:   Mon, 11 Jul 2022 12:16:33 -0700
Message-Id: <20220711191633.80826-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711191633.80826-1-mathew.j.martineau@linux.intel.com>
References: <20220711191633.80826-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Add a couple of test-cases covering the newly introduced
features - priority update for the MPC subflow.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 55efe2aafb84..ff83ef426df5 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2428,6 +2428,36 @@ backup_tests()
 		chk_add_nr 1 1
 		chk_prio_nr 1 1
 	fi
+
+	if reset "mpc backup"; then
+		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,backup
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+		chk_join_nr 0 0 0
+		chk_prio_nr 0 1
+	fi
+
+	if reset "mpc backup both sides"; then
+		pm_nl_add_endpoint $ns1 10.0.1.1 flags subflow,backup
+		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,backup
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+		chk_join_nr 0 0 0
+		chk_prio_nr 1 1
+	fi
+
+	if reset "mpc switch to backup"; then
+		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
+		chk_join_nr 0 0 0
+		chk_prio_nr 0 1
+	fi
+
+	if reset "mpc switch to backup both sides"; then
+		pm_nl_add_endpoint $ns1 10.0.1.1 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
+		chk_join_nr 0 0 0
+		chk_prio_nr 1 1
+	fi
 }
 
 add_addr_ports_tests()
-- 
2.37.0

