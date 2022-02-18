Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB54BAFFA
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 04:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiBRDDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 22:03:43 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiBRDDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 22:03:37 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921F858E6A
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 19:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645153401; x=1676689401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ChdVtpx2FTn8UBnKC5Z+NGmbaMbZRte5dZCcVFncSNY=;
  b=Eyh2uxhmfaQRsG7vPYtIuTABeAEDldI8YhXjq82OUmk2jKeXm+3sw7vE
   1F0pzl0Cfxj3plueRaxZsz4UifZ8NaoT7Cl6/hpCoV9k94qWIovItJ37a
   YwZHwYyVJVRGIQiYccjoeR4Stiy0AWpvCpm5hDXLCn6O0MynIxXaFChpQ
   yk56K6vjDNWpxc4rLbBDep0+NLft/g0AD4I+aAK83mMpYYFvFDxKvBsCo
   fbZmPzk5nqddlNdOIZDFf2CB8ktgby6eUKF9kbIP/ycsJR+uNkRtfSHJA
   AgrGduqbhU4OCTMVPZGe+GkBJjb4wC4IFroRSdG6vXKWjiaUG8fymkXit
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="250794599"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="250794599"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:19 -0800
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="635431953"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.101.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:19 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/7] selftests: mptcp: join: check for tools only if needed
Date:   Thu, 17 Feb 2022 19:03:10 -0800
Message-Id: <20220218030311.367536-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
References: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

To allow showing the 'help' menu even if these tools are not available.

While at it, also avoid launching the command then checking $?. Instead,
the check is directly done in the 'if'.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 38 ++++++++++---------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 63340bb76920..725924012b41 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -99,9 +99,29 @@ cleanup_partial()
 	done
 }
 
+check_tools()
+{
+	if ! ip -Version &> /dev/null; then
+		echo "SKIP: Could not run test without ip tool"
+		exit $ksft_skip
+	fi
+
+	if ! iptables -V &> /dev/null; then
+		echo "SKIP: Could not run all tests without iptables tool"
+		exit $ksft_skip
+	fi
+
+	if ! ip6tables -V &> /dev/null; then
+		echo "SKIP: Could not run all tests without ip6tables tool"
+		exit $ksft_skip
+	fi
+}
+
 init() {
 	init=1
 
+	check_tools
+
 	sin=$(mktemp)
 	sout=$(mktemp)
 	cin=$(mktemp)
@@ -183,24 +203,6 @@ reset_with_allow_join_id0()
 	ip netns exec $ns2 sysctl -q net.mptcp.allow_join_initial_addr_port=$ns2_enable
 }
 
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
-
-iptables -V > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run all tests without iptables tool"
-	exit $ksft_skip
-fi
-
-ip6tables -V > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run all tests without ip6tables tool"
-	exit $ksft_skip
-fi
-
 print_file_err()
 {
 	ls -l "$1" 1>&2
-- 
2.35.1

