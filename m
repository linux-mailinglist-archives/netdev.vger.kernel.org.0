Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C701E62ADDA
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiKOWK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiKOWKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:10:54 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63CF30553
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 14:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668550252; x=1700086252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aMT0jvaM6rV0r/E+20oJeXxpjy/b/2beKHw5vQly4Kk=;
  b=QvFkHfKHZJFfOsbUscpB3AQGq/zIV7EtD1H5k+JFtVnCLzXx4npul7Og
   qY1QKRcOzbXkn2uaN6dnZWXIspxua4soHRQotBQcCjCmOo1/7gj72w62n
   JSRK3Ngl2rxGn9A75Q06Ga5z/W2dSJMb4jnA/AuLafwhEHezBBGrwDwNJ
   lF2JQ63edfZAiINe9F96LNn3Z6spCWu3hLUDRaAFWgJDI7Eie1Kp/yA2I
   8Esx6Mwhfj3Ozq5iRXj3mH1jmNqdSjaiF4z/UdXCbuyXjfb42jGHL3oj/
   fbaBiGOvKeBt+tfIbXripWLqbn58tF8oxoUT3yYJ1VkSJAmyXIpFOU6vk
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="299906717"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="299906717"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 14:10:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="616917994"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="616917994"
Received: from imunagan-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.21.103])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 14:10:52 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de, geliang.tang@suse.com,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/3] selftests: mptcp: run mptcp_sockopt from a new netns
Date:   Tue, 15 Nov 2022 14:10:45 -0800
Message-Id: <20221115221046.20370-3-mathew.j.martineau@linux.intel.com>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

Not running it from a new netns causes issues if some MPTCP settings are
modified, e.g. if MPTCP is disabled from the sysctl knob, if multiple
addresses are available and added to the MPTCP path-manager, etc.

In these cases, the created connection will not behave as expected, e.g.
unable to create an MPTCP socket, more than one subflow is seen, etc.

A new "sandbox" net namespace is now created and used to run
mptcp_sockopt from this controlled environment.

Fixes: ce9979129a0b ("selftests: mptcp: add mptcp getsockopt test cases")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
index 0879da915014..80d36f7cfee8 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -35,8 +35,9 @@ init()
 
 	ns1="ns1-$rndh"
 	ns2="ns2-$rndh"
+	ns_sbox="ns_sbox-$rndh"
 
-	for netns in "$ns1" "$ns2";do
+	for netns in "$ns1" "$ns2" "$ns_sbox";do
 		ip netns add $netns || exit $ksft_skip
 		ip -net $netns link set lo up
 		ip netns exec $netns sysctl -q net.mptcp.enabled=1
@@ -73,7 +74,7 @@ init()
 
 cleanup()
 {
-	for netns in "$ns1" "$ns2"; do
+	for netns in "$ns1" "$ns2" "$ns_sbox"; do
 		ip netns del $netns
 	done
 	rm -f "$cin" "$cout"
@@ -243,7 +244,7 @@ do_mptcp_sockopt_tests()
 {
 	local lret=0
 
-	./mptcp_sockopt
+	ip netns exec "$ns_sbox" ./mptcp_sockopt
 	lret=$?
 
 	if [ $lret -ne 0 ]; then
@@ -252,7 +253,7 @@ do_mptcp_sockopt_tests()
 		return
 	fi
 
-	./mptcp_sockopt -6
+	ip netns exec "$ns_sbox" ./mptcp_sockopt -6
 	lret=$?
 
 	if [ $lret -ne 0 ]; then
-- 
2.38.1

