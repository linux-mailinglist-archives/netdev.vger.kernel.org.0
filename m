Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D8156BF50
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbiGHROW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238392AbiGHROU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:14:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB1F25C7A
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 10:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657300459; x=1688836459;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DQFTa2o7tX8z6E5Yqben/xtRbWyD1sotbqs9kP1vAWI=;
  b=iNmOUF1O1zpSUgfMR5080JejKt8bhhgo63SN/Nil9hu3wa4p9xTiE2Ec
   EQny4NjU7G7h+JAZXz5cdpwxRd/WFIVuU9lvSFsZbiJ9vn8HybDWQDKcF
   oLYH38YyuqSiUpdXhquM1IxetymB11B3gAC189/SdI77MuNiWcUsfSh9B
   WBZXeEiSyGA+BxOHhwr/xkQgadg21SXWW2frrvpudBUNslDSh6Q5Hyg6S
   T8scYuMFqPn1yraZO4P28kOrD1UAhuVEr11Edci2m/xqZ7fWsmDHdCj+g
   l7URV49wYJAyX/s12qVuLut2Rnu/k7J2BY4uFC8+lpRAV+VyrYmOUb+JR
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="267364240"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="267364240"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="651641504"
Received: from aroras-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.1.203])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:18 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/6] selftests: mptcp: userspace pm address tests
Date:   Fri,  8 Jul 2022 10:14:10 -0700
Message-Id: <20220708171413.327112-4-mathew.j.martineau@linux.intel.com>
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

This patch adds userspace pm tests support for mptcp_join.sh script. Add
userspace pm add_addr and rm_addr test cases in userspace_tests().

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 49 ++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index a4406b7a8064..d889e7507cd9 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -455,6 +455,12 @@ wait_mpj()
 	done
 }
 
+kill_wait()
+{
+	kill $1 > /dev/null 2>&1
+	wait $1 2>/dev/null
+}
+
 pm_nl_set_limits()
 {
 	local ns=$1
@@ -654,6 +660,9 @@ do_transfer()
 
 	local port=$((10000 + TEST_COUNT - 1))
 	local cappid
+	local userspace_pm=0
+	local evts_ns1
+	local evts_ns1_pid
 
 	:> "$cout"
 	:> "$sout"
@@ -690,12 +699,24 @@ do_transfer()
 		extra_args="-r ${speed:6}"
 	fi
 
+	if [[ "${addr_nr_ns1}" = "userspace_"* ]]; then
+		userspace_pm=1
+		addr_nr_ns1=${addr_nr_ns1:10}
+	fi
+
 	if [[ "${addr_nr_ns2}" = "fastclose_"* ]]; then
 		# disconnect
 		extra_args="$extra_args -I ${addr_nr_ns2:10}"
 		addr_nr_ns2=0
 	fi
 
+	if [ $userspace_pm -eq 1 ]; then
+		evts_ns1=$(mktemp)
+		:> "$evts_ns1"
+		ip netns exec ${listener_ns} ./pm_nl_ctl events >> "$evts_ns1" 2>&1 &
+		evts_ns1_pid=$!
+	fi
+
 	local local_addr
 	if is_v6 "${connect_addr}"; then
 		local_addr="::"
@@ -748,6 +769,8 @@ do_transfer()
 	if [ $addr_nr_ns1 -gt 0 ]; then
 		local counter=2
 		local add_nr_ns1=${addr_nr_ns1}
+		local id=10
+		local tk
 		while [ $add_nr_ns1 -gt 0 ]; do
 			local addr
 			if is_v6 "${connect_addr}"; then
@@ -755,9 +778,18 @@ do_transfer()
 			else
 				addr="10.0.$counter.1"
 			fi
-			pm_nl_add_endpoint $ns1 $addr flags signal
+			if [ $userspace_pm -eq 0 ]; then
+				pm_nl_add_endpoint $ns1 $addr flags signal
+			else
+				tk=$(sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q' "$evts_ns1")
+				ip netns exec ${listener_ns} ./pm_nl_ctl ann $addr token $tk id $id
+				sleep 1
+				ip netns exec ${listener_ns} ./pm_nl_ctl rem token $tk id $id
+			fi
+
 			counter=$((counter + 1))
 			add_nr_ns1=$((add_nr_ns1 - 1))
+			id=$((id + 1))
 		done
 	elif [ $addr_nr_ns1 -lt 0 ]; then
 		local rm_nr_ns1=$((-addr_nr_ns1))
@@ -890,6 +922,11 @@ do_transfer()
 	    kill $cappid
 	fi
 
+	if [ $userspace_pm -eq 1 ]; then
+		kill_wait $evts_ns1_pid
+		rm -rf $evts_ns1
+	fi
+
 	NSTAT_HISTORY=/tmp/${listener_ns}.nstat ip netns exec ${listener_ns} \
 		nstat | grep Tcp > /tmp/${listener_ns}.out
 	NSTAT_HISTORY=/tmp/${connector_ns}.nstat ip netns exec ${connector_ns} \
@@ -2810,6 +2847,16 @@ userspace_tests()
 		chk_join_nr 0 0 0
 		chk_rm_nr 0 0
 	fi
+
+	# userspace pm add & remove address
+	if reset "userspace pm add & remove address"; then
+		set_userspace_pm $ns1
+		pm_nl_set_limits $ns2 1 1
+		run_tests $ns1 $ns2 10.0.1.1 0 userspace_1 0 slow
+		chk_join_nr 1 1 1
+		chk_add_nr 1 1
+		chk_rm_nr 1 1 invert
+	fi
 }
 
 endpoint_tests()
-- 
2.37.0

