Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0C217A073
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgCEHRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:17:48 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42299 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbgCEHRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 02:17:44 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0583A220C9;
        Thu,  5 Mar 2020 02:17:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 05 Mar 2020 02:17:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=oCFXyQdOBxHO1+h7rj4Vgm4KCLKcrqMKnJTI7CCQwm8=; b=1fCUYG+b
        5PGkBGu1NadiEocjPRI12DkqYhw2pMkxWeMo0TQyYLQh+V5exjQV6Uulyt/QKxKF
        v8iZ/vvgZr/KnZeunRdgxX9psGHgr688RVf6JMVk7XUZrNdIb8YHUwoBr3vQIrKE
        fC85yMGtvtdFefJvXmyUKUMgsfywtWGKYJssCBwG1UpmnpwjL16tieRJx3SrHoIJ
        bxz5tGdSD4M6O2a0LdMPh5hymaMDN7rtLFphZYapB6SyUTNYK+H28KBlB6nmyVJL
        QD8xlFcWBMwFAg8AhRN4NUSc6PDLPUgHMEdWy0FuvJ8wkPsPZrc6Dnr4eTC08HCx
        umGrlIapIoZj+A==
X-ME-Sender: <xms:l6dgXrxHVt9xYtVuPV17FUZkaQZreWYbWaLexZ8cRkLMvHISBrCbKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtledguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsth
    gvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:l6dgXt2AaTPGsKRohahDRdOjHqPjJ38oufYToXxMkxrL2dXKsG04Cw>
    <xmx:l6dgXh56jvj_52o-2GCZENqEyIJZHUDSVG0FmLUFzNcx1Gx-4Wkgvw>
    <xmx:l6dgXoUoShtM3BECNnYxMxGcFvKZ7_baVEP4VMhfQU6ZJoMoC77zXw>
    <xmx:mKdgXmM-Q3wBa0dnkBr1C_H2A3mh07GMHZ8Zxj1aL7ul8Vwyor_wDQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 718323280066;
        Thu,  5 Mar 2020 02:17:42 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/5] selftests: forwarding: ETS: Use Qdisc counters
Date:   Thu,  5 Mar 2020 09:16:44 +0200
Message-Id: <20200305071644.117264-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305071644.117264-1-idosch@idosch.org>
References: <20200305071644.117264-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Currently the SW-datapath ETS selftests use "ip link" stats to obtain the
number of packets that went through a given band. mlxsw then uses ethtool
per-priority counters.

Instead, change both to use qdiscs. In SW datapath this is the obvious
choice, and now that mlxsw offloads FIFO, this should work on the offloaded
datapath as well. This has the effect of verifying that the FIFO offload
works.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../testing/selftests/drivers/net/mlxsw/sch_ets.sh | 14 +++++++++++---
 tools/testing/selftests/net/forwarding/lib.sh      | 10 ++++++++++
 tools/testing/selftests/net/forwarding/sch_ets.sh  |  9 ++++++---
 .../selftests/net/forwarding/sch_ets_tests.sh      | 10 +++-------
 4 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
index c9fc4d4885c1..94c37124a840 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
@@ -56,11 +56,19 @@ switch_destroy()
 }
 
 # Callback from sch_ets_tests.sh
-get_stats()
+collect_stats()
 {
-	local band=$1; shift
+	local -a streams=("$@")
+	local stream
 
-	ethtool_stats_get "$h2" rx_octets_prio_$band
+	# Wait for qdisc counter update so that we don't get it mid-way through.
+	busywait_for_counter 1000 +1 \
+		qdisc_parent_stats_get $swp2 10:$((${streams[0]} + 1)) .bytes \
+		> /dev/null
+
+	for stream in ${streams[@]}; do
+		qdisc_parent_stats_get $swp2 10:$((stream + 1)) .bytes
+	done
 }
 
 bail_on_lldpad
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 7ecce65d08f9..a4a7879b3bb9 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -655,6 +655,16 @@ qdisc_stats_get()
 	    | jq '.[] | select(.handle == "'"$handle"'") | '"$selector"
 }
 
+qdisc_parent_stats_get()
+{
+	local dev=$1; shift
+	local parent=$1; shift
+	local selector=$1; shift
+
+	tc -j -s qdisc show dev "$dev" invisible \
+	    | jq '.[] | select(.parent == "'"$parent"'") | '"$selector"
+}
+
 humanize()
 {
 	local speed=$1; shift
diff --git a/tools/testing/selftests/net/forwarding/sch_ets.sh b/tools/testing/selftests/net/forwarding/sch_ets.sh
index 40e0ad1bc4f2..e60c8b4818cc 100755
--- a/tools/testing/selftests/net/forwarding/sch_ets.sh
+++ b/tools/testing/selftests/net/forwarding/sch_ets.sh
@@ -34,11 +34,14 @@ switch_destroy()
 }
 
 # Callback from sch_ets_tests.sh
-get_stats()
+collect_stats()
 {
-	local stream=$1; shift
+	local -a streams=("$@")
+	local stream
 
-	link_stats_get $h2.1$stream rx bytes
+	for stream in ${streams[@]}; do
+		qdisc_parent_stats_get $swp2 10:$((stream + 1)) .bytes
+	done
 }
 
 ets_run
diff --git a/tools/testing/selftests/net/forwarding/sch_ets_tests.sh b/tools/testing/selftests/net/forwarding/sch_ets_tests.sh
index 3c3b204d47e8..cdf689e99458 100644
--- a/tools/testing/selftests/net/forwarding/sch_ets_tests.sh
+++ b/tools/testing/selftests/net/forwarding/sch_ets_tests.sh
@@ -2,7 +2,7 @@
 
 # Global interface:
 #  $put -- port under test (e.g. $swp2)
-#  get_stats($band) -- A function to collect stats for band
+#  collect_stats($streams...) -- A function to get stats for individual streams
 #  ets_start_traffic($band) -- Start traffic for this band
 #  ets_change_qdisc($op, $dev, $nstrict, $quanta...) -- Add or change qdisc
 
@@ -94,15 +94,11 @@ __ets_dwrr_test()
 
 	sleep 10
 
-	t0=($(for stream in ${streams[@]}; do
-		  get_stats $stream
-	      done))
+	t0=($(collect_stats "${streams[@]}"))
 
 	sleep 10
 
-	t1=($(for stream in ${streams[@]}; do
-		  get_stats $stream
-	      done))
+	t1=($(collect_stats "${streams[@]}"))
 	d=($(for ((i = 0; i < ${#streams[@]}; i++)); do
 		 echo $((${t1[$i]} - ${t0[$i]}))
 	     done))
-- 
2.24.1

