Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA942228A0E
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbgGUUho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbgGUUhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F7DC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz1B-0003xl-5O; Tue, 21 Jul 2020 22:37:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Florian Westphal <fw@strlen.de>
Subject: [RFC v2 mptcp-next 12/12] selftests: mptcp: make 2nd net namespace use tcp syn cookies unconditionally
Date:   Tue, 21 Jul 2020 22:36:42 +0200
Message-Id: <20200721203642.32753-13-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721203642.32753-1-fw@strlen.de>
References: <20200721203642.32753-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

check we can establish connections even in syncookie mode.
Also check following MIB counters:
MPTcpExtMPCapableSYNRX (should increase for each MPTCP test)
MPTcpExtMPCapableACKRX (should increase for each MPTCP test)
TcpExtSyncookiesSent (should increase for listener in ns2)
TcpExtSyncookiesRecv (same)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index c0589e071f20..6260520674d0 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -196,6 +196,9 @@ ip -net "$ns4" link set ns4eth3 up
 ip -net "$ns4" route add default via 10.0.3.2
 ip -net "$ns4" route add default via dead:beef:3::2
 
+# use TCP syn cookies, even if no flooding was detected.
+ip netns exec "$ns2" sysctl -q net.ipv4.tcp_syncookies=2
+
 set_ethtool_flags() {
 	local ns="$1"
 	local dev="$2"
@@ -407,6 +410,11 @@ do_transfer()
 		sleep 1
 	fi
 
+	local stat_synrx_last_l=$(ip netns exec ${listener_ns} nstat -z -a MPTcpExtMPCapableSYNRX | while read a count c rest ;do  echo $count;done)
+	local stat_ackrx_last_l=$(ip netns exec ${listener_ns} nstat -z -a MPTcpExtMPCapableACKRX | while read a count c rest ;do  echo $count;done)
+	local stat_cookietx_last=$(ip netns exec ${listener_ns} nstat -z -a TcpExtSyncookiesSent | while read a count c rest ;do  echo $count;done)
+	local stat_cookierx_last=$(ip netns exec ${listener_ns} nstat -z -a TcpExtSyncookiesRecv | while read a count c rest ;do  echo $count;done)
+
 	ip netns exec ${listener_ns} ./mptcp_connect -t $timeout -l -p $port -s ${srv_proto} $extra_args $local_addr < "$sin" > "$sout" &
 	local spid=$!
 
@@ -450,6 +458,48 @@ do_transfer()
 	check_transfer $cin $sout "file received by server"
 	rets=$?
 
+	local stat_synrx_now_l=$(ip netns exec ${listener_ns} nstat -z -a MPTcpExtMPCapableSYNRX  | while read a count c rest ;do  echo $count;done)
+	local stat_ackrx_now_l=$(ip netns exec ${listener_ns} nstat -z -a MPTcpExtMPCapableACKRX  | while read a count c rest ;do  echo $count;done)
+
+	local stat_cookietx_now=$(ip netns exec ${listener_ns} nstat -z -a TcpExtSyncookiesSent | while read a count c rest ;do  echo $count;done)
+	local stat_cookierx_now=$(ip netns exec ${listener_ns} nstat -z -a TcpExtSyncookiesRecv | while read a count c rest ;do  echo $count;done)
+
+	expect_synrx=$((stat_synrx_last_l))
+	expect_ackrx=$((stat_ackrx_last_l))
+
+	cookies=$(ip netns exec ${listener_ns} sysctl net.ipv4.tcp_syncookies)
+	cookies=${cookies##*=}
+
+	if [ ${cl_proto} = "MPTCP" ] && [ ${srv_proto} = "MPTCP" ]; then
+		expect_synrx=$((stat_synrx_last_l+1))
+		expect_ackrx=$((stat_ackrx_last_l+1))
+		if [ $cookies -eq 2 ];then
+			expect_synrx=$((stat_synrx_last_l+2))
+		fi
+	fi
+	if [ $cookies -eq 2 ];then
+		if [ $stat_cookietx_last -ge $stat_cookietx_now ] ;then
+			echo "${listener_ns} CookieSent: ${cl_proto} -> ${srv_proto}: did not advance"
+		fi
+		if [ $stat_cookierx_last -ge $stat_cookierx_now ] ;then
+			echo "${listener_ns} CookieRecv: ${cl_proto} -> ${srv_proto}: did not advance"
+		fi
+	else
+		if [ $stat_cookietx_last -ne $stat_cookietx_now ] ;then
+			echo "${listener_ns} CookieSent: ${cl_proto} -> ${srv_proto}: changed"
+		fi
+		if [ $stat_cookierx_last -ne $stat_cookierx_now ] ;then
+			echo "${listener_ns} CookieRecv: ${cl_proto} -> ${srv_proto}: changed"
+		fi
+	fi
+
+	if [ $expect_synrx -ne $stat_synrx_now_l ] ;then
+		echo "${listener_ns} SYNRX: ${cl_proto} -> ${srv_proto}: expect ${expect_synrx}, got ${stat_synrx_now_l}"
+	fi
+	if [ $expect_ackrx -ne $stat_ackrx_now_l ] ;then
+		echo "${listener_ns} ACKRX: ${cl_proto} -> ${srv_proto}: expect ${expect_synrx}, got ${stat_synrx_now_l}"
+	fi
+
 	if [ $retc -eq 0 ] && [ $rets -eq 0 ];then
 		echo "$duration [ OK ]"
 		cat "$capout"
-- 
2.26.2

