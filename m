Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF54F56BFA7
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238260AbiGHRO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238453AbiGHROV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:14:21 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9DE20BE2
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 10:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657300460; x=1688836460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Y3ODIlrpwkLL50TGSGUaZwVDIT7lYbj4rnRycY3o4w=;
  b=b5rJQhG6gJCFtPJajqvfWMi1xb1+Z7GjC4clPB8Z3DHX85OMPjUf4G0c
   bmGPpHrSOjW2ZgISLCOeMq5DfFk9kNRl+N+o/TyJbDWc2+W6aUrW2+Uwe
   VPVQrLKn6W0KiPX1OEH9L93Gvg4r50QHcK0zUz9MKvdnSHUggZnEBtqAz
   hB8EzOEqx4zyCSu9WnE2jt6Px+79MvpjJsf0VEaCRM/7iV/q9SHabM74S
   iDNzQpHlR6Ys5cLveoxFBQOYMOxVV+8ZGopdKVxVClnHZAGD5l4rT2sOU
   6WoXZraBk173kdHFu+Yx6gXIt5DZKl5Qi+Dy8nlSxtEts5yTnTdNT3vKn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="267364242"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="267364242"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="651641507"
Received: from aroras-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.1.203])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:19 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/6] selftests: mptcp: avoid Terminated messages in userspace_pm
Date:   Fri,  8 Jul 2022 10:14:12 -0700
Message-Id: <20220708171413.327112-6-mathew.j.martineau@linux.intel.com>
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

There're some 'Terminated' messages in the output of userspace pm tests
script after killing './pm_nl_ctl events' processes:

Created network namespaces ns1, ns2         			[OK]
./userspace_pm.sh: line 166: 13735 Terminated              ip netns exec "$ns2" ./pm_nl_ctl events >> "$client_evts" 2>&1
./userspace_pm.sh: line 172: 13737 Terminated              ip netns exec "$ns1" ./pm_nl_ctl events >> "$server_evts" 2>&1
Established IPv4 MPTCP Connection ns2 => ns1    		[OK]
./userspace_pm.sh: line 166: 13753 Terminated              ip netns exec "$ns2" ./pm_nl_ctl events >> "$client_evts" 2>&1
./userspace_pm.sh: line 172: 13755 Terminated              ip netns exec "$ns1" ./pm_nl_ctl events >> "$server_evts" 2>&1
Established IPv6 MPTCP Connection ns2 => ns1    		[OK]
ADD_ADDR 10.0.2.2 (ns2) => ns1, invalid token    		[OK]

This patch adds a helper kill_wait(), in it using 'wait $pid 2>/dev/null'
commands after 'kill $pid' to avoid printing out these Terminated messages.
Use this helper instead of using 'kill $pid'.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/userspace_pm.sh       | 40 +++++++++++--------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index abe3d4ebe554..3229725b64b0 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -37,6 +37,12 @@ rndh=$(stdbuf -o0 -e0 printf %x "$sec")-$(mktemp -u XXXXXX)
 ns1="ns1-$rndh"
 ns2="ns2-$rndh"
 
+kill_wait()
+{
+	kill $1 > /dev/null 2>&1
+	wait $1 2>/dev/null
+}
+
 cleanup()
 {
 	echo "cleanup"
@@ -48,16 +54,16 @@ cleanup()
 		kill -SIGUSR1 $client4_pid > /dev/null 2>&1
 	fi
 	if [ $server4_pid -ne 0 ]; then
-		kill $server4_pid > /dev/null 2>&1
+		kill_wait $server4_pid
 	fi
 	if [ $client6_pid -ne 0 ]; then
 		kill -SIGUSR1 $client6_pid > /dev/null 2>&1
 	fi
 	if [ $server6_pid -ne 0 ]; then
-		kill $server6_pid > /dev/null 2>&1
+		kill_wait $server6_pid
 	fi
 	if [ $evts_pid -ne 0 ]; then
-		kill $evts_pid > /dev/null 2>&1
+		kill_wait $evts_pid
 	fi
 	local netns
 	for netns in "$ns1" "$ns2" ;do
@@ -153,7 +159,7 @@ make_connection()
 	sleep 1
 
 	# Capture client/server attributes from MPTCP connection netlink events
-	kill $client_evts_pid
+	kill_wait $client_evts_pid
 
 	local client_token
 	local client_port
@@ -165,7 +171,7 @@ make_connection()
 	client_port=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$client_evts")
 	client_serverside=$(sed --unbuffered -n 's/.*\(server_side:\)\([[:digit:]]*\).*$/\2/p;q'\
 				      "$client_evts")
-	kill $server_evts_pid
+	kill_wait $server_evts_pid
 	server_token=$(sed --unbuffered -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q' "$server_evts")
 	server_serverside=$(sed --unbuffered -n 's/.*\(server_side:\)\([[:digit:]]*\).*$/\2/p;q'\
 				      "$server_evts")
@@ -286,7 +292,7 @@ test_announce()
 	verify_announce_event "$evts" "$ANNOUNCED" "$server4_token" "10.0.2.2"\
 			      "$client_addr_id" "$new4_port"
 
-	kill $evts_pid
+	kill_wait $evts_pid
 
 	# Capture events on the network namespace running the client
 	:>"$evts"
@@ -321,7 +327,7 @@ test_announce()
 	verify_announce_event "$evts" "$ANNOUNCED" "$client4_token" "10.0.2.1"\
 			      "$server_addr_id" "$new4_port"
 
-	kill $evts_pid
+	kill_wait $evts_pid
 	rm -f "$evts"
 }
 
@@ -416,7 +422,7 @@ test_remove()
 	sleep 0.5
 	verify_remove_event "$evts" "$REMOVED" "$server6_token" "$client_addr_id"
 
-	kill $evts_pid
+	kill_wait $evts_pid
 
 	# Capture events on the network namespace running the client
 	:>"$evts"
@@ -449,7 +455,7 @@ test_remove()
 	sleep 0.5
 	verify_remove_event "$evts" "$REMOVED" "$client6_token" "$server_addr_id"
 
-	kill $evts_pid
+	kill_wait $evts_pid
 	rm -f "$evts"
 }
 
@@ -553,7 +559,7 @@ test_subflows()
 			      "10.0.2.2" "$client4_port" "23" "$client_addr_id" "ns1" "ns2"
 
 	# Delete the listener from the client ns, if one was created
-	kill $listener_pid > /dev/null 2>&1
+	kill_wait $listener_pid
 
 	local sport
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
@@ -592,7 +598,7 @@ test_subflows()
 			      "$client_addr_id" "ns1" "ns2"
 
 	# Delete the listener from the client ns, if one was created
-	kill $listener_pid > /dev/null 2>&1
+	kill_wait $listener_pid
 
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
 
@@ -631,7 +637,7 @@ test_subflows()
 			      "$client_addr_id" "ns1" "ns2"
 
 	# Delete the listener from the client ns, if one was created
-	kill $listener_pid > /dev/null 2>&1
+	kill_wait $listener_pid
 
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
 
@@ -647,7 +653,7 @@ test_subflows()
 	ip netns exec "$ns2" ./pm_nl_ctl rem id $client_addr_id token\
 	   "$client4_token" > /dev/null 2>&1
 
-	kill $evts_pid
+	kill_wait $evts_pid
 
 	# Capture events on the network namespace running the client
 	:>"$evts"
@@ -674,7 +680,7 @@ test_subflows()
 			      "10.0.2.1" "$app4_port" "23" "$server_addr_id" "ns2" "ns1"
 
 	# Delete the listener from the server ns, if one was created
-	kill $listener_pid> /dev/null 2>&1
+	kill_wait $listener_pid
 
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
 
@@ -713,7 +719,7 @@ test_subflows()
 			      "$server_addr_id" "ns2" "ns1"
 
 	# Delete the listener from the server ns, if one was created
-	kill $listener_pid > /dev/null 2>&1
+	kill_wait $listener_pid
 
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
 
@@ -750,7 +756,7 @@ test_subflows()
 			      "10.0.2.2" "10.0.2.1" "$new4_port" "23" "$server_addr_id" "ns2" "ns1"
 
 	# Delete the listener from the server ns, if one was created
-	kill $listener_pid > /dev/null 2>&1
+	kill_wait $listener_pid
 
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
 
@@ -766,7 +772,7 @@ test_subflows()
 	ip netns exec "$ns1" ./pm_nl_ctl rem id $server_addr_id token\
 	   "$server4_token" > /dev/null 2>&1
 
-	kill $evts_pid
+	kill_wait $evts_pid
 	rm -f "$evts"
 }
 
-- 
2.37.0

