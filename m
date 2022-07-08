Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952E956C026
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbiGHROW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238260AbiGHROV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:14:21 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5331B25C69
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 10:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657300460; x=1688836460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hGuJQcWGX80+CC/bcE33cZMqB9MmIQkT5cBply9gaiw=;
  b=I+r1ZE61kb7Y8vKu6OqD9MGqe5QhodsL/2pHq1m1QvB/xt1ibugaY+bV
   v6RUp4jT8h8DfGt+xaqlUIFWuzF/BHatMUzOEdcJOZresml3qDzyTvZwN
   U4hkku6TC4TZpI0lZHitwDR/rlVxaaBb3jEJP6GKAAChDYqBow14gTYlp
   OGxweHaUxKM1ydgMIwEUzQqzGMUojBLWvUOkpj8YIhIsqJ4lUCeXBqs9B
   DZ3PMDAVYkkeEIDJwqd+h/7eDxWsU6/qnyrVUmLHuOBZ85WoRrxZzcz6s
   DbMQ3K2KbEGoKg9xlTvla2XL8u94bBaFDOBV4qOoQeVGrvtogGZwQy6+F
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="267364241"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="267364241"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="651641506"
Received: from aroras-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.1.203])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:19 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/6] selftests: mptcp: userspace pm subflow tests
Date:   Fri,  8 Jul 2022 10:14:11 -0700
Message-Id: <20220708171413.327112-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220708171413.327112-1-mathew.j.martineau@linux.intel.com>
References: <20220708171413.327112-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch adds userspace pm subflow tests support for mptcp_join.sh
script. Add userspace pm create subflow and destroy test cases in
userspace_tests().

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 39 ++++++++++++++++++-
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index d889e7507cd9..55efe2aafb84 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -663,6 +663,8 @@ do_transfer()
 	local userspace_pm=0
 	local evts_ns1
 	local evts_ns1_pid
+	local evts_ns2
+	local evts_ns2_pid
 
 	:> "$cout"
 	:> "$sout"
@@ -708,13 +710,20 @@ do_transfer()
 		# disconnect
 		extra_args="$extra_args -I ${addr_nr_ns2:10}"
 		addr_nr_ns2=0
+	elif [[ "${addr_nr_ns2}" = "userspace_"* ]]; then
+		userspace_pm=1
+		addr_nr_ns2=${addr_nr_ns2:10}
 	fi
 
 	if [ $userspace_pm -eq 1 ]; then
 		evts_ns1=$(mktemp)
+		evts_ns2=$(mktemp)
 		:> "$evts_ns1"
+		:> "$evts_ns2"
 		ip netns exec ${listener_ns} ./pm_nl_ctl events >> "$evts_ns1" 2>&1 &
 		evts_ns1_pid=$!
+		ip netns exec ${connector_ns} ./pm_nl_ctl events >> "$evts_ns2" 2>&1 &
+		evts_ns2_pid=$!
 	fi
 
 	local local_addr
@@ -836,6 +845,8 @@ do_transfer()
 	if [ $addr_nr_ns2 -gt 0 ]; then
 		local add_nr_ns2=${addr_nr_ns2}
 		local counter=3
+		local id=20
+		local tk da dp sp
 		while [ $add_nr_ns2 -gt 0 ]; do
 			local addr
 			if is_v6 "${connect_addr}"; then
@@ -843,9 +854,23 @@ do_transfer()
 			else
 				addr="10.0.$counter.2"
 			fi
-			pm_nl_add_endpoint $ns2 $addr flags $flags
+			if [ $userspace_pm -eq 0 ]; then
+				pm_nl_add_endpoint $ns2 $addr flags $flags
+			else
+				tk=$(sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q' "$evts_ns2")
+				da=$(sed -n 's/.*\(daddr4:\)\([0-9.]*\).*$/\2/p;q' "$evts_ns2")
+				dp=$(sed -n 's/.*\(dport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts_ns2")
+				ip netns exec ${connector_ns} ./pm_nl_ctl csf lip $addr lid $id \
+									rip $da rport $dp token $tk
+				sleep 1
+				sp=$(grep "type:10" "$evts_ns2" |
+				     sed -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
+				ip netns exec ${connector_ns} ./pm_nl_ctl dsf lip $addr lport $sp \
+									rip $da rport $dp token $tk
+			fi
 			counter=$((counter + 1))
 			add_nr_ns2=$((add_nr_ns2 - 1))
+			id=$((id + 1))
 		done
 	elif [ $addr_nr_ns2 -lt 0 ]; then
 		local rm_nr_ns2=$((-addr_nr_ns2))
@@ -924,7 +949,8 @@ do_transfer()
 
 	if [ $userspace_pm -eq 1 ]; then
 		kill_wait $evts_ns1_pid
-		rm -rf $evts_ns1
+		kill_wait $evts_ns2_pid
+		rm -rf $evts_ns1 $evts_ns2
 	fi
 
 	NSTAT_HISTORY=/tmp/${listener_ns}.nstat ip netns exec ${listener_ns} \
@@ -2857,6 +2883,15 @@ userspace_tests()
 		chk_add_nr 1 1
 		chk_rm_nr 1 1 invert
 	fi
+
+	# userspace pm create destroy subflow
+	if reset "userspace pm create destroy subflow"; then
+		set_userspace_pm $ns2
+		pm_nl_set_limits $ns1 0 1
+		run_tests $ns1 $ns2 10.0.1.1 0 0 userspace_1 slow
+		chk_join_nr 1 1 1
+		chk_rm_nr 0 1
+	fi
 }
 
 endpoint_tests()
-- 
2.37.0

