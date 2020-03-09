Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCD417E74A
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgCISgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:36:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56429 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727323AbgCISgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:36:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B2BCA21B0E;
        Mon,  9 Mar 2020 14:35:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 Mar 2020 14:35:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Ms7zrN5MaLO0vQesxO/HeyQ0tm123y6RwWWzgZGxpu0=; b=DWKaiRms
        cJWkproNilZE+d/TohEkfmLn2RSzz4fO7vcwjlIWhRUWCXP3OYTwAd2MvBqshb5+
        psbWKx05pNS+Yln3dMPP4IF4tprnAWM0UtjhmhVMbawxFeQbdzJ++/zYnUCyU/vr
        jLLNlrBTaqRpd6H3CzgoXjwMQC5f5tGMQnuoNTyowkC7JXHESoriyAYLdLS+d3ni
        qkkpvDlW+nWl/biCPa7SVI6MyY6RmW+t+vUfJrh1skk2QLC/Nh3quMK3ik9cXskY
        fO4n4XLvH3Mks7vOYfNDdi3+EtjWeS/9B59PjiHNM4YzT8u1bInBlezsMo7tKbaU
        gHAz+6h2i1slSQ==
X-ME-Sender: <xms:joxmXr_tv3PZEy-H_BUoz5U9REz5cY4xertw6smZT3P0g-pdjO8Dmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeejrddufeekrddvgeelrddvtdelnecuvehluhhsth
    gvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:joxmXsABVDBz_5mli-9ffj0k8GUAE_6qGI2uo3NHK-xbZpVmbAo07Q>
    <xmx:joxmXj5BunuJYAWSPrSl51Hlm29FCexhoeJRi5zfsZNt2J-diBPFgw>
    <xmx:joxmXioTXo06ONmx5iV5cgHMQVQKz3Jm0sUFvr1CQjaIyqLpTOZUng>
    <xmx:joxmXkHctY7qOnHjwZjAJDpRs2beA54jMXnJdlmNkwnwm49GAEJLxw>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 533763060F09;
        Mon,  9 Mar 2020 14:35:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/6] selftests: mlxsw: RED: Test RED ECN taildrop offload
Date:   Mon,  9 Mar 2020 20:35:03 +0200
Message-Id: <20200309183503.173802-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309183503.173802-1-idosch@idosch.org>
References: <20200309183503.173802-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Extend RED testsuite to cover the new "taildropping" mode of RED-ECN. This
test is really similar to ECN test, diverging only in the last step, where
UDP traffic should go to backlog instead of being dropped. Thus extract a
common helper, ecn_test_common(), make do_ecn_test() into a relatively
simple wrapper, and add another one, do_ecn_taildrop_test().

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/sch_red_core.sh         | 50 ++++++++++++++++---
 .../drivers/net/mlxsw/sch_red_ets.sh          | 11 ++++
 .../drivers/net/mlxsw/sch_red_root.sh         |  8 +++
 3 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index 8f833678ac4d..fc7986db3fe0 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -389,17 +389,14 @@ check_marking()
 	((pct $cond))
 }
 
-do_ecn_test()
+ecn_test_common()
 {
+	local name=$1; shift
 	local vlan=$1; shift
 	local limit=$1; shift
 	local backlog
 	local pct
 
-	# Main stream.
-	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
-			  $h3_mac tos=0x01
-
 	# Build the below-the-limit backlog using UDP. We could use TCP just
 	# fine, but this way we get a proof that UDP is accepted when queue
 	# length is below the limit. The main stream is using TCP, and if the
@@ -409,7 +406,7 @@ do_ecn_test()
 	check_err $? "Could not build the requested backlog"
 	pct=$(check_marking $vlan "== 0")
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
-	log_test "TC $((vlan - 10)): ECN backlog < limit"
+	log_test "TC $((vlan - 10)): $name backlog < limit"
 
 	# Now push TCP, because non-TCP traffic would be early-dropped after the
 	# backlog crosses the limit, and we want to make sure that the backlog
@@ -419,7 +416,20 @@ do_ecn_test()
 	check_err $? "Could not build the requested backlog"
 	pct=$(check_marking $vlan ">= 95")
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected >= 95."
-	log_test "TC $((vlan - 10)): ECN backlog > limit"
+	log_test "TC $((vlan - 10)): $name backlog > limit"
+}
+
+do_ecn_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local name=ECN
+
+	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
+			  $h3_mac tos=0x01
+	sleep 1
+
+	ecn_test_common "$name" $vlan $limit
 
 	# Up there we saw that UDP gets accepted when backlog is below the
 	# limit. Now that it is above, it should all get dropped, and backlog
@@ -427,7 +437,31 @@ do_ecn_test()
 	RET=0
 	build_backlog $vlan $((2 * limit)) udp >/dev/null
 	check_fail $? "UDP traffic went into backlog instead of being early-dropped"
-	log_test "TC $((vlan - 10)): ECN backlog > limit: UDP early-dropped"
+	log_test "TC $((vlan - 10)): $name backlog > limit: UDP early-dropped"
+
+	stop_traffic
+	sleep 1
+}
+
+do_ecn_taildrop_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local name="ECN taildrop"
+
+	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
+			  $h3_mac tos=0x01
+	sleep 1
+
+	ecn_test_common "$name" $vlan $limit
+
+	# Up there we saw that UDP gets accepted when backlog is below the
+	# limit. Now that it is above, in taildrop mode, make sure it goes to
+	# backlog as well.
+	RET=0
+	build_backlog $vlan $((2 * limit)) udp >/dev/null
+	check_err $? "UDP traffic was early-dropped instead of getting into backlog"
+	log_test "TC $((vlan - 10)): $name backlog > limit: UDP tail-dropped"
 
 	stop_traffic
 	sleep 1
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index af83efe9ccf1..042a33cc13f4 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -4,6 +4,7 @@
 ALL_TESTS="
 	ping_ipv4
 	ecn_test
+	ecn_taildrop_test
 	red_test
 	mc_backlog_test
 "
@@ -50,6 +51,16 @@ ecn_test()
 	uninstall_qdisc
 }
 
+ecn_taildrop_test()
+{
+	install_qdisc ecn taildrop
+
+	do_ecn_taildrop_test 10 $BACKLOG1
+	do_ecn_taildrop_test 11 $BACKLOG2
+
+	uninstall_qdisc
+}
+
 red_test()
 {
 	install_qdisc
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
index b2217493a88e..af55672dc335 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
@@ -4,6 +4,7 @@
 ALL_TESTS="
 	ping_ipv4
 	ecn_test
+	ecn_taildrop_test
 	red_test
 	mc_backlog_test
 "
@@ -33,6 +34,13 @@ ecn_test()
 	uninstall_qdisc
 }
 
+ecn_taildrop_test()
+{
+	install_qdisc ecn taildrop
+	do_ecn_taildrop_test 10 $BACKLOG
+	uninstall_qdisc
+}
+
 red_test()
 {
 	install_qdisc
-- 
2.24.1

