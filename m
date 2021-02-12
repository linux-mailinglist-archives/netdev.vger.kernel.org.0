Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66F131A849
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhBLXX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:23:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:29010 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229903AbhBLXXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 18:23:52 -0500
IronPort-SDR: D+rTkuR1EobUsXAizRhF2esnawLkDlnDmaV/9xC11lnGJXvLG/tPgQW+OnoStkSuaLesxPiE/y
 lBtmRZTCmEbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="179934366"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="179934366"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 15:20:36 -0800
IronPort-SDR: ABMreRVPjHh4WG8DTCsS0uFkN9/ikfrD+/DOfllTDPopLfjgLnjPJxjBtuzY2Y+1YnjYsiDyVW
 25j7u9m3ZOWw==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="360595940"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 15:20:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/4] selftests: mptcp: display warnings on one line
Date:   Fri, 12 Feb 2021 15:20:29 -0800
Message-Id: <20210212232030.377261-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210212232030.377261-1-mathew.j.martineau@linux.intel.com>
References: <20210212232030.377261-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

Before we had this in case of SYN retransmissions:

  (...)
  # ns4 MPTCP -> ns2 (10.0.1.2:10034      ) MPTCP	(duration  1201ms) [ OK ]
  # ns4 MPTCP -> ns2 (dead:beef:1::2:10035) MPTCP	(duration  1242ms) [ OK ]
  # ns4 MPTCP -> ns2 (10.0.2.1:10036      ) MPTCP	ns2-60143c00-cDZWo4 SYNRX: MPTCP -> MPTCP: expect 11, got
  # 13
  # (duration  6221ms) [ OK ]
  # ns4 MPTCP -> ns2 (dead:beef:2::1:10037) MPTCP	(duration  1427ms) [ OK ]
  # ns4 MPTCP -> ns3 (10.0.2.2:10038      ) MPTCP	(duration   881ms) [ OK ]
  (...)

Now we have:

  (...)
  # ns4 MPTCP -> ns2 (10.0.1.2:10034      ) MPTCP	(duration  1201ms) [ OK ]
  # ns4 MPTCP -> ns2 (dead:beef:1::2:10035) MPTCP	(duration  1242ms) [ OK ]
  # ns4 MPTCP -> ns2 (10.0.2.1:10036      ) MPTCP	(duration  6221ms) [ OK ] WARN: SYNRX: expect 11, got 13
  # ns4 MPTCP -> ns2 (dead:beef:2::1:10037) MPTCP	(duration  1427ms) [ OK ]
  # ns4 MPTCP -> ns3 (10.0.2.2:10038      ) MPTCP	(duration   881ms) [ OK ]
  (...)

So we put everything on one line, keep the durations and "OK" aligned
and removed duplicated info to short the warning.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 63 ++++++++++++-------
 1 file changed, 40 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 9ab35ae41628..362e891f89cf 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -334,6 +334,21 @@ do_ping()
 	return 0
 }
 
+# $1: ns, $2: MIB counter
+get_mib_counter()
+{
+	local listener_ns="${1}"
+	local mib="${2}"
+
+	# strip the header
+	ip netns exec "${listener_ns}" \
+		nstat -z -a "${mib}" | \
+			tail -n+2 | \
+			while read a count c rest; do
+				echo $count
+			done
+}
+
 # $1: ns, $2: port
 wait_local_port_listen()
 {
@@ -410,10 +425,10 @@ do_transfer()
 		sleep 1
 	fi
 
-	local stat_synrx_last_l=$(ip netns exec ${listener_ns} nstat -z -a MPTcpExtMPCapableSYNRX | while read a count c rest ;do  echo $count;done)
-	local stat_ackrx_last_l=$(ip netns exec ${listener_ns} nstat -z -a MPTcpExtMPCapableACKRX | while read a count c rest ;do  echo $count;done)
-	local stat_cookietx_last=$(ip netns exec ${listener_ns} nstat -z -a TcpExtSyncookiesSent | while read a count c rest ;do  echo $count;done)
-	local stat_cookierx_last=$(ip netns exec ${listener_ns} nstat -z -a TcpExtSyncookiesRecv | while read a count c rest ;do  echo $count;done)
+	local stat_synrx_last_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
+	local stat_ackrx_last_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
+	local stat_cookietx_last=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesSent")
+	local stat_cookierx_last=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesRecv")
 
 	ip netns exec ${listener_ns} ./mptcp_connect -t $timeout -l -p $port -s ${srv_proto} $extra_args $local_addr < "$sin" > "$sout" &
 	local spid=$!
@@ -448,15 +463,17 @@ do_transfer()
 
 	local duration
 	duration=$((stop-start))
-	duration=$(printf "(duration %05sms)" $duration)
+	printf "(duration %05sms) " "${duration}"
 	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
-		echo "$duration [ FAIL ] client exit code $retc, server $rets" 1>&2
+		echo "[ FAIL ] client exit code $retc, server $rets" 1>&2
 		echo -e "\nnetns ${listener_ns} socket stat for ${port}:" 1>&2
 		ip netns exec ${listener_ns} ss -Menita 1>&2 -o "sport = :$port"
 		cat /tmp/${listener_ns}.out
 		echo -e "\nnetns ${connector_ns} socket stat for ${port}:" 1>&2
 		ip netns exec ${connector_ns} ss -Menita 1>&2 -o "dport = :$port"
 		[ ${listener_ns} != ${connector_ns} ] && cat /tmp/${connector_ns}.out
+
+		echo
 		cat "$capout"
 		return 1
 	fi
@@ -466,11 +483,14 @@ do_transfer()
 	check_transfer $cin $sout "file received by server"
 	rets=$?
 
-	local stat_synrx_now_l=$(ip netns exec ${listener_ns} nstat -z -a MPTcpExtMPCapableSYNRX  | while read a count c rest ;do  echo $count;done)
-	local stat_ackrx_now_l=$(ip netns exec ${listener_ns} nstat -z -a MPTcpExtMPCapableACKRX  | while read a count c rest ;do  echo $count;done)
+	if [ $retc -eq 0 ] && [ $rets -eq 0 ]; then
+		printf "[ OK ]"
+	fi
 
-	local stat_cookietx_now=$(ip netns exec ${listener_ns} nstat -z -a TcpExtSyncookiesSent | while read a count c rest ;do  echo $count;done)
-	local stat_cookierx_now=$(ip netns exec ${listener_ns} nstat -z -a TcpExtSyncookiesRecv | while read a count c rest ;do  echo $count;done)
+	local stat_synrx_now_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
+	local stat_ackrx_now_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
+	local stat_cookietx_now=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesSent")
+	local stat_cookierx_now=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesRecv")
 
 	expect_synrx=$((stat_synrx_last_l))
 	expect_ackrx=$((stat_ackrx_last_l))
@@ -484,35 +504,32 @@ do_transfer()
 	fi
 	if [ $cookies -eq 2 ];then
 		if [ $stat_cookietx_last -ge $stat_cookietx_now ] ;then
-			echo "${listener_ns} CookieSent: ${cl_proto} -> ${srv_proto}: did not advance"
+			printf " WARN: CookieSent: did not advance"
 		fi
 		if [ $stat_cookierx_last -ge $stat_cookierx_now ] ;then
-			echo "${listener_ns} CookieRecv: ${cl_proto} -> ${srv_proto}: did not advance"
+			printf " WARN: CookieRecv: did not advance"
 		fi
 	else
 		if [ $stat_cookietx_last -ne $stat_cookietx_now ] ;then
-			echo "${listener_ns} CookieSent: ${cl_proto} -> ${srv_proto}: changed"
+			printf " WARN: CookieSent: changed"
 		fi
 		if [ $stat_cookierx_last -ne $stat_cookierx_now ] ;then
-			echo "${listener_ns} CookieRecv: ${cl_proto} -> ${srv_proto}: changed"
+			printf " WARN: CookieRecv: changed"
 		fi
 	fi
 
 	if [ $expect_synrx -ne $stat_synrx_now_l ] ;then
-		echo "${listener_ns} SYNRX: ${cl_proto} -> ${srv_proto}: expect ${expect_synrx}, got ${stat_synrx_now_l}"
+		printf " WARN: SYNRX: expect %d, got %d" \
+			"${expect_synrx}" "${stat_synrx_now_l}"
 	fi
 	if [ $expect_ackrx -ne $stat_ackrx_now_l ] ;then
-		echo "${listener_ns} ACKRX: ${cl_proto} -> ${srv_proto}: expect ${expect_ackrx}, got ${stat_ackrx_now_l} "
-	fi
-
-	if [ $retc -eq 0 ] && [ $rets -eq 0 ];then
-		echo "$duration [ OK ]"
-		cat "$capout"
-		return 0
+		printf " WARN: ACKRX: expect %d, got %d" \
+			"${expect_ackrx}" "${stat_ackrx_now_l}"
 	fi
 
+	echo
 	cat "$capout"
-	return 1
+	[ $retc -eq 0 ] && [ $rets -eq 0 ]
 }
 
 make_file()
-- 
2.30.1

