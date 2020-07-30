Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B32233782
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgG3RQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730251AbgG3RQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 13:16:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C734C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 10:16:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k1CA0-0002xJ-Sz; Thu, 30 Jul 2020 19:16:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     edumazet@google.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 09/10] selftests: mptcp: make 2nd net namespace use tcp syn cookies unconditionally
Date:   Thu, 30 Jul 2020 19:15:28 +0200
Message-Id: <20200730171529.22582-10-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730171529.22582-1-fw@strlen.de>
References: <20200730171529.22582-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

check we can establish connections also when syn cookies are in use.

Check that
MPTcpExtMPCapableSYNRX and MPTcpExtMPCapableACKRX increase for each
MPTCP test.

Check TcpExtSyncookiesSent and TcpExtSyncookiesRecv increase in netns2.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index c0589e071f20..57d75b7f6220 100755
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
 
@@ -450,6 +458,45 @@ do_transfer()
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

