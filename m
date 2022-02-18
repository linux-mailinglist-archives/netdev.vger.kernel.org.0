Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194E74BC230
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239966AbiBRVgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:36:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbiBRVgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:36:10 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F010F109A63
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645220153; x=1676756153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fPNBc17stRFe/AsFOoZDtyY+Pe1mPa0jEIXT/R6zQi4=;
  b=amgnK9BysJ3o20bO+39RhZaHzZZA8Vp1JxFQrgP3J9V0icbU2Z/I8AxU
   7fKHr5L3+4oiha72h2Ntz1uedZUzVx3f7u7fk8Q0xPVHkgX87+NAfrUF9
   6/3NzaDf+n4vrbqrRiHUbHQEIMyb1q2op8Q7hN+1xY8m2h8ERjGHeaCLH
   cMLVqJzyYUx0P++oB/DIkdPrkriFiVXErtlbgmlfsNXTD0iCMIPRAujM9
   8S5b6mOnFxXf2KJ+k6OswGwvbueXssQMuljn9Be8/hbU2JglkJqhPaVJQ
   6MyM7HTRUfsxpzXr/KMDH5apDy4id8Hs3mZ24AaNp1yaIna3jtlKOjZvj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251176202"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251176202"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:35:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="605664083"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.65.242])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:35:53 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        geliang.tang@suse.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 6/7] selftests: mptcp: more robust signal race test
Date:   Fri, 18 Feb 2022 13:35:43 -0800
Message-Id: <20220218213544.70285-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218213544.70285-1-mathew.j.martineau@linux.intel.com>
References: <20220218213544.70285-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The in kernel MPTCP PM implementation can process a single
incoming add address option at any given time. In the
mentioned test the server can surpass such limit. Let the
setup cope with that allowing a faster add_addr retransmission.

Fixes: a88c9e496937 ("mptcp: do not block subflows creation on errors")
Fixes: f7efc7771eac ("mptcp: drop argument port from mptcp_pm_announce_addr")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/254
Reported-and-tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 10b3bd805ac6..0d6a71e7bb59 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -752,11 +752,17 @@ chk_add_nr()
 	local mis_ack_nr=${8:-0}
 	local count
 	local dump_stats
+	local timeout
+
+	timeout=`ip netns exec $ns1 sysctl -n net.mptcp.add_addr_timeout`
 
 	printf "%-39s %s" " " "add"
-	count=`ip netns exec $ns2 nstat -as | grep MPTcpExtAddAddr | awk '{print $2}'`
+	count=`ip netns exec $ns2 nstat -as MPTcpExtAddAddr | grep MPTcpExtAddAddr | awk '{print $2}'`
 	[ -z "$count" ] && count=0
-	if [ "$count" != "$add_nr" ]; then
+
+	# if the test configured a short timeout tolerate greater then expected
+	# add addrs options, due to retransmissions
+	if [ "$count" != "$add_nr" ] && [ "$timeout" -gt 1 -o "$count" -lt "$add_nr" ]; then
 		echo "[fail] got $count ADD_ADDR[s] expected $add_nr"
 		ret=1
 		dump_stats=1
@@ -1158,7 +1164,10 @@ signal_address_tests()
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags signal
-	run_tests $ns1 $ns2 10.0.1.1
+
+	# the peer could possibly miss some addr notification, allow retransmission
+	ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
 	chk_join_nr "signal addresses race test" 3 3 3
 
 	# the server will not signal the address terminating
-- 
2.35.1

