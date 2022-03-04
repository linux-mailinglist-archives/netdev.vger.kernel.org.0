Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8349C4CDE73
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiCDUEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiCDUEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:04:21 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE21248CE8
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423974; x=1677959974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1/uBy4xIN/f39gpA+6947idem3xzKvCmx+kAxXLkkUY=;
  b=FNLuO2ZgfsotVKn/dxZiruIXxGLtgxwm3DxRhoTATsU01lhhV57rPsP5
   KUCRWFvO5LazjpyQEXgNJBlQo3wPXabgmNj/nap1gttn5LuR5gU7rZiSy
   l+MJFI7iRg7PnBAmwLov/x0mvlgMaXS9EC/OpVhuUnIsVHNMyBPfp+etm
   91v1AjZhReQ38mASg4uGF0Bi+jtkG7Ila8koHvsp+dJwSc5CMGaSmb93e
   F5DUoW1PrmyeFMElcn8yjU4NFZVD0OBiZR+P+qsrUYVh/LD2fE4Pv/udv
   8oGInPK+6JdgB9LMjjywHfVpoPWoWmAjhhz2SKC/IOnOi+pWagcLAkJDR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253981335"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253981335"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552340789"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.225.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 06/11] selftests: mptcp: add extra_args in do_transfer
Date:   Fri,  4 Mar 2022 11:36:31 -0800
Message-Id: <20220304193636.219315-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
References: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Instead of using a global variable mptcp_connect, this patch added
a new local variable extra_args in do_transfer() to store the extra
arguments passing to the mptcp_connect commands.

This patch also renamed the speed level 'least' to 'speed_*'. This
more flexible way can avoid the need to add new speed levels in the
future.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 30 +++++++++----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 12008640d9f4..84c21282ee46 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -12,7 +12,6 @@ cout=""
 ksft_skip=4
 timeout_poll=30
 timeout_test=$((timeout_poll * 2 + 1))
-mptcp_connect=""
 capture=0
 checksum=0
 ip_mptcp=0
@@ -444,12 +443,13 @@ do_transfer()
 	NSTAT_HISTORY=/tmp/${connector_ns}.nstat ip netns exec ${connector_ns} \
 		nstat -n
 
+	local extra_args
 	if [ $speed = "fast" ]; then
-		mptcp_connect="./mptcp_connect -j"
+		extra_args="-j"
 	elif [ $speed = "slow" ]; then
-		mptcp_connect="./mptcp_connect -r 50"
-	elif [ $speed = "least" ]; then
-		mptcp_connect="./mptcp_connect -r 10"
+		extra_args="-r 50"
+	elif [[ $speed = "speed_"* ]]; then
+		extra_args="-r ${speed:6}"
 	fi
 
 	local local_addr
@@ -462,13 +462,13 @@ do_transfer()
 	if [ "$test_link_fail" -eq 2 ];then
 		timeout ${timeout_test} \
 			ip netns exec ${listener_ns} \
-				$mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
-					${local_addr} < "$sinfail" > "$sout" &
+				./mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
+					$extra_args ${local_addr} < "$sinfail" > "$sout" &
 	else
 		timeout ${timeout_test} \
 			ip netns exec ${listener_ns} \
-				$mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
-					${local_addr} < "$sin" > "$sout" &
+				./mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
+					$extra_args ${local_addr} < "$sin" > "$sout" &
 	fi
 	spid=$!
 
@@ -477,15 +477,15 @@ do_transfer()
 	if [ "$test_link_fail" -eq 0 ];then
 		timeout ${timeout_test} \
 			ip netns exec ${connector_ns} \
-				$mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
-					$connect_addr < "$cin" > "$cout" &
+				./mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
+					$extra_args $connect_addr < "$cin" > "$cout" &
 	else
 		( cat "$cinfail" ; sleep 2; link_failure $listener_ns ; cat "$cinfail" ) | \
 			tee "$cinsent" | \
 			timeout ${timeout_test} \
 				ip netns exec ${connector_ns} \
-					$mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
-						$connect_addr > "$cout" &
+					./mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
+						$extra_args $connect_addr > "$cout" &
 	fi
 	cpid=$!
 
@@ -1507,7 +1507,7 @@ add_addr_timeout_tests()
 	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 	pm_nl_set_limits $ns2 2 2
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 least
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 speed_10
 	chk_join_nr "signal addresses, ADD_ADDR timeout" 2 2 2
 	chk_add_nr 8 0
 
@@ -1517,7 +1517,7 @@ add_addr_timeout_tests()
 	pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
 	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 	pm_nl_set_limits $ns2 2 2
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 least
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 speed_10
 	chk_join_nr "invalid address, ADD_ADDR timeout" 1 1 1
 	chk_add_nr 8 0
 }
-- 
2.35.1

