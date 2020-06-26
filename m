Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FEB20BCE8
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgFZWqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:46:49 -0400
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:6168
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725883AbgFZWqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 18:46:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwmLClRmRrkRlhlN8xeDI9Q/C7g8uiFnlm59l8Vgr46Nz9WWFriAKBLVpOU8Hz9v3bWv1tdCZVK1qO11C4XLaOTUmNzjYBb5/WPyjZIGODl4KJj5WB4BPiSiM6SykNEaW+xbF4uyLBj0o8WVYOhDrRGO/XtFIWhbrRBEN00rqgIi4pP7BNq3G3TxgFtEzXWZqKwbLw79a6IL+R4W7TWdpl0NLsk8KIVsx2Fc35p4E4vIsXFNeGvk94/W3X8DRlCIiXbYvycJ1r+LfOOg8BA8st1zMltVlel0TM7fTNRRWNcBfWIde2HIqFf+BZ2bWaZGrJwcAq90Q/eOMJQS8gLEwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPaKfyDgd9QiB/frrEwvOx0qyS+1m/XetXUbXAbk7DU=;
 b=ZoF4JD5J06uqoasiEIzKXnDtypkFSIRWw9N7Dh4KW5HxUBFuDfmur3J7pjYNX1K5QXOn+TGDqmnsSObBy+SOlDj7o9IuVRCLcVHQ8RD5XCkiuuLeqcPRfWU5z44sss01YBBaNMj8tgeqXUglqtObnrOl7rPBoZ6IYJOGy/aPae4kBkuljuoCg6flSXyCY6IzKrhTbo16Eh/EeZKLSFVFfi3WJ+PTgvsHKX0uy8MsOgra84rA68zHFmNUWXF7hWl3QuzfSBbl6qJFc3B9ySFPkPYkbtZMPqux7K/LY1TFcywOoyGFsn9xcbjRI4w0vqfeJGTuBh29VciL7iTC+N5I/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPaKfyDgd9QiB/frrEwvOx0qyS+1m/XetXUbXAbk7DU=;
 b=RbYaLk6fRVfGdmVVcKayOPtbU5CyfD7bTdx57VKhe4P3LSeW10RZooxf8+DSHfllnAP5QtYoyriZKuWd/YbJsugR8FMjg4ettZyrVhKeS6lHxMKG4MvRFZvoXWN1zl9KJtkFJzajGtVemYbWbMh4ond0uCWwZ2eMljcrH29KOpM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3196.eurprd05.prod.outlook.com (2603:10a6:7:33::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.21; Fri, 26 Jun 2020 22:46:16 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 22:46:16 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com, Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next v1 5/5] selftests: forwarding: Add a RED test for SW datapath
Date:   Sat, 27 Jun 2020 01:45:29 +0300
Message-Id: <559b6fa59404259aaa3912c4fc6f7c7a57c34fc0.1593209494.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1593209494.git.petrm@mellanox.com>
References: <cover.1593209494.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0139.eurprd05.prod.outlook.com
 (2603:10a6:207:3::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:207:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 22:46:15 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7365e521-d49f-460d-3d69-08d81a22bc46
X-MS-TrafficTypeDiagnostic: HE1PR05MB3196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB319607E3CB66CC3A249CC141DB930@HE1PR05MB3196.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9IQAKklW3BoNyM53jzgnnH5OX49+tLkCVhQezxi4X2eydofnhE7zoJvRItXhXfY0sZHQ4l45jmEid+kgv3thS/xTgj0sDWNjsmy4PvAEyLC6d6DmpLqbjGd07eB8wXHqYuygyJXpyqUKbUDzR55jkWBoWwm9F4ClgzQY/ZifJjZajGDpTzrh7kF6W0utKwbLe4BYi0KG+annmQ19ZOxTFwoMTU5y1HtRZ5MItFULpY8u4VI57E5TmWYDgsJOlc+DY9KWyK/qRSCm/IBwYnuI1W+BGy47Z/JnImhEkBtB+A+PBMNTxqNWFRgQ5NpoW262
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(5660300002)(66476007)(8676002)(956004)(54906003)(52116002)(2616005)(6666004)(83380400001)(30864003)(4326008)(6512007)(2906002)(26005)(8936002)(6916009)(107886003)(66556008)(36756003)(478600001)(86362001)(66946007)(186003)(316002)(6486002)(6506007)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: u9i50prGnt5cf0yVug9mNjjxF02xPydLVTN5JMQmnmjT6ypBkd5m9ThvuICBeI8GqtXmu1BoJXzbyk5gynZkQzopAmOlqz3E37ln43GT+w7bfwS8jc2y3FygrIAafDFkqDggKe/Kc5sK3MPg1TqBI0d0B34b/78mU4O6Hk/whQbOEcF/zAJGz53S5Gs58Qp+M2zDhudXGXdyLAEQbvZ1kCuwThiqnGodkHjAv3LAwaWRlrUugWN+Wt8mk7yP2E9u2l00Vny3mf1s88N1EYBlv7Z6JUNpUQ4FTN868yBXPsMCLrzBeSFh5fXcw6gw+ClioyrG37dDoc1w3tK7F/avjWthGlRf14K6DnHBr0zlN1Bqsi9o5CKaWhhTo6vPyNlJaJ5Jg3+jRCafdXj0JzB31VP9Fi1SSQnvhLDx6C4WCFwnq12/mKKHNL0JvMHh264+WgHEQIamsRz4wdEkiuh83UnRzRhWgWxTqDEkGlqM6x0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7365e521-d49f-460d-3d69-08d81a22bc46
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 22:46:16.5833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H1B2hhk9EBh3GsKIeC6Wu9PdGp58VMjhzHnJYzzx+O9l8N2o1wJy7UMcJrAXUDcfOQ+LXQgZB4G/EH6zn6+RZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test is inspired by the mlxsw RED selftest. It is much simpler to set
up (also because there is no point in testing PRIO / RED encapsulation). It
tests bare RED, ECN and ECN+nodrop modes of operation. On top of that it
tests RED early_drop and mark qevents.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../selftests/net/forwarding/sch_red.sh       | 492 ++++++++++++++++++
 1 file changed, 492 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/sch_red.sh

diff --git a/tools/testing/selftests/net/forwarding/sch_red.sh b/tools/testing/selftests/net/forwarding/sch_red.sh
new file mode 100755
index 000000000000..e714bae473fb
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_red.sh
@@ -0,0 +1,492 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# This test sends one stream of traffic from H1 through a TBF shaper, to a RED
+# within TBF shaper on $swp3. The two shapers have the same configuration, and
+# thus the resulting stream should fill all available bandwidth on the latter
+# shaper. A second stream is sent from H2 also via $swp3, and used to inject
+# additional traffic. Since all available bandwidth is taken, this traffic has
+# to go to backlog.
+#
+# +--------------------------+                     +--------------------------+
+# | H1                       |                     | H2                       |
+# |     + $h1                |                     |     + $h2                |
+# |     | 192.0.2.1/28       |                     |     | 192.0.2.2/28       |
+# |     | TBF 10Mbps         |                     |     |                    |
+# +-----|--------------------+                     +-----|--------------------+
+#       |                                                |
+# +-----|------------------------------------------------|--------------------+
+# | SW  |                                                |                    |
+# |  +--|------------------------------------------------|----------------+   |
+# |  |  + $swp1                                          + $swp2          |   |
+# |  |                               BR                                   |   |
+# |  |                                                                    |   |
+# |  |                                + $swp3                             |   |
+# |  |                                | TBF 10Mbps / RED                  |   |
+# |  +--------------------------------|-----------------------------------+   |
+# |                                   |                                       |
+# +-----------------------------------|---------------------------------------+
+#                                     |
+#                               +-----|--------------------+
+#			        | H3  |                    |
+#			        |     + $h1                |
+#			        |       192.0.2.3/28       |
+#			        |                          |
+#			        +--------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	ecn_test
+	ecn_nodrop_test
+	red_test
+	red_qevent_test
+	ecn_qevent_test
+"
+
+NUM_NETIFS=6
+CHECK_TC="yes"
+source lib.sh
+
+BACKLOG=30000
+PKTSZ=1400
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/28
+	mtu_set $h1 10000
+	tc qdisc replace dev $h1 root handle 1: tbf \
+	   rate 10Mbit burst 10K limit 1M
+}
+
+h1_destroy()
+{
+	tc qdisc del dev $h1 root
+	mtu_restore $h1
+	simple_if_fini $h1 192.0.2.1/28
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/28
+	mtu_set $h2 10000
+}
+
+h2_destroy()
+{
+	mtu_restore $h2
+	simple_if_fini $h2 192.0.2.2/28
+}
+
+h3_create()
+{
+	simple_if_init $h3 192.0.2.3/28
+	mtu_set $h3 10000
+}
+
+h3_destroy()
+{
+	mtu_restore $h3
+	simple_if_fini $h3 192.0.2.3/28
+}
+
+switch_create()
+{
+	ip link add dev br up type bridge
+	ip link set dev $swp1 up master br
+	ip link set dev $swp2 up master br
+	ip link set dev $swp3 up master br
+
+	mtu_set $swp1 10000
+	mtu_set $swp2 10000
+	mtu_set $swp3 10000
+
+	tc qdisc replace dev $swp3 root handle 1: tbf \
+	   rate 10Mbit burst 10K limit 1M
+	ip link add name _drop_test up type dummy
+}
+
+switch_destroy()
+{
+	ip link del dev _drop_test
+	tc qdisc del dev $swp3 root
+
+	mtu_restore $h3
+	mtu_restore $h2
+	mtu_restore $h1
+
+	ip link set dev $swp3 down nomaster
+	ip link set dev $swp2 down nomaster
+	ip link set dev $swp1 down nomaster
+	ip link del dev br
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	h2=${NETIFS[p3]}
+	swp2=${NETIFS[p4]}
+
+	swp3=${NETIFS[p5]}
+	h3=${NETIFS[p6]}
+
+	h3_mac=$(mac_get $h3)
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+	h3_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h3_destroy
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1 192.0.2.3 " from host 1"
+	ping_test $h2 192.0.2.3 " from host 2"
+}
+
+get_qdisc_backlog()
+{
+	qdisc_stats_get $swp3 11: .backlog
+}
+
+get_nmarked()
+{
+	qdisc_stats_get $swp3 11: .marked
+}
+
+get_qdisc_npackets()
+{
+	qdisc_stats_get $swp3 11: .packets
+}
+
+get_nmirrored()
+{
+	link_stats_get _drop_test tx packets
+}
+
+send_packets()
+{
+	local proto=$1; shift
+	local pkts=$1; shift
+
+	$MZ $h2 -p $PKTSZ -a own -b $h3_mac -A 192.0.2.2 -B 192.0.2.3 -t $proto -q -c $pkts "$@"
+}
+
+# This sends traffic in an attempt to build a backlog of $size. Returns 0 on
+# success. After 10 failed attempts it bails out and returns 1. It dumps the
+# backlog size to stdout.
+build_backlog()
+{
+	local size=$1; shift
+	local proto=$1; shift
+
+	local i=0
+
+	while :; do
+		local cur=$(get_qdisc_backlog)
+		local diff=$((size - cur))
+		local pkts=$(((diff + PKTSZ - 1) / PKTSZ))
+
+		if ((cur >= size)); then
+			echo $cur
+			return 0
+		elif ((i++ > 10)); then
+			echo $cur
+			return 1
+		fi
+
+		send_packets $proto $pkts "$@"
+		sleep 1
+	done
+}
+
+check_marking()
+{
+	local cond=$1; shift
+
+	local npackets_0=$(get_qdisc_npackets)
+	local nmarked_0=$(get_nmarked)
+	sleep 5
+	local npackets_1=$(get_qdisc_npackets)
+	local nmarked_1=$(get_nmarked)
+
+	local nmarked_d=$((nmarked_1 - nmarked_0))
+	local npackets_d=$((npackets_1 - npackets_0))
+	local pct=$((100 * nmarked_d / npackets_d))
+
+	echo $pct
+	((pct $cond))
+}
+
+check_mirroring()
+{
+	local cond=$1; shift
+
+	local npackets_0=$(get_qdisc_npackets)
+	local nmirrored_0=$(get_nmirrored)
+	sleep 5
+	local npackets_1=$(get_qdisc_npackets)
+	local nmirrored_1=$(get_nmirrored)
+
+	local nmirrored_d=$((nmirrored_1 - nmirrored_0))
+	local npackets_d=$((npackets_1 - npackets_0))
+	local pct=$((100 * nmirrored_d / npackets_d))
+
+	echo $pct
+	((pct $cond))
+}
+
+ecn_test_common()
+{
+	local name=$1; shift
+	local limit=$1; shift
+	local backlog
+	local pct
+
+	# Build the below-the-limit backlog using UDP. We could use TCP just
+	# fine, but this way we get a proof that UDP is accepted when queue
+	# length is below the limit. The main stream is using TCP, and if the
+	# limit is misconfigured, we would see this traffic being ECN marked.
+	RET=0
+	backlog=$(build_backlog $((2 * limit / 3)) udp)
+	check_err $? "Could not build the requested backlog"
+	pct=$(check_marking "== 0")
+	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
+	log_test "$name backlog < limit"
+
+	# Now push TCP, because non-TCP traffic would be early-dropped after the
+	# backlog crosses the limit, and we want to make sure that the backlog
+	# is above the limit.
+	RET=0
+	backlog=$(build_backlog $((3 * limit / 2)) tcp tos=0x01)
+	check_err $? "Could not build the requested backlog"
+	pct=$(check_marking ">= 95")
+	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected >= 95."
+	log_test "$name backlog > limit"
+}
+
+do_ecn_test()
+{
+	local limit=$1; shift
+	local name=ECN
+
+	$MZ $h1 -p $PKTSZ -A 192.0.2.1 -B 192.0.2.3 -c 0 \
+		-a own -b $h3_mac -t tcp -q tos=0x01 &
+	sleep 1
+
+	ecn_test_common "$name" $limit
+
+	# Up there we saw that UDP gets accepted when backlog is below the
+	# limit. Now that it is above, it should all get dropped, and backlog
+	# building should fail.
+	RET=0
+	build_backlog $((2 * limit)) udp >/dev/null
+	check_fail $? "UDP traffic went into backlog instead of being early-dropped"
+	log_test "$name backlog > limit: UDP early-dropped"
+
+	stop_traffic
+	sleep 1
+}
+
+do_ecn_nodrop_test()
+{
+	local limit=$1; shift
+	local name="ECN nodrop"
+
+	$MZ $h1 -p $PKTSZ -A 192.0.2.1 -B 192.0.2.3 -c 0 \
+		-a own -b $h3_mac -t tcp -q tos=0x01 &
+	sleep 1
+
+	ecn_test_common "$name" $limit
+
+	# Up there we saw that UDP gets accepted when backlog is below the
+	# limit. Now that it is above, in nodrop mode, make sure it goes to
+	# backlog as well.
+	RET=0
+	build_backlog $((2 * limit)) udp >/dev/null
+	check_err $? "UDP traffic was early-dropped instead of getting into backlog"
+	log_test "$name backlog > limit: UDP not dropped"
+
+	stop_traffic
+	sleep 1
+}
+
+do_red_test()
+{
+	local limit=$1; shift
+	local backlog
+	local pct
+
+	# Use ECN-capable TCP to verify there's no marking even though the queue
+	# is above limit.
+	$MZ $h1 -p $PKTSZ -A 192.0.2.1 -B 192.0.2.3 -c 0 \
+		-a own -b $h3_mac -t tcp -q tos=0x01 &
+
+	# Pushing below the queue limit should work.
+	RET=0
+	backlog=$(build_backlog $((2 * limit / 3)) tcp tos=0x01)
+	check_err $? "Could not build the requested backlog"
+	pct=$(check_marking "== 0")
+	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
+	log_test "RED backlog < limit"
+
+	# Pushing above should not.
+	RET=0
+	backlog=$(build_backlog $((3 * limit / 2)) tcp tos=0x01)
+	check_fail $? "Traffic went into backlog instead of being early-dropped"
+	pct=$(check_marking "== 0")
+	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
+	log_test "RED backlog > limit"
+
+	stop_traffic
+	sleep 1
+}
+
+do_red_qevent_test()
+{
+	local limit=$1; shift
+	local backlog
+	local base
+	local now
+	local pct
+
+	RET=0
+
+	$MZ $h1 -p $PKTSZ -A 192.0.2.1 -B 192.0.2.3 -c 0 \
+		-a own -b $h3_mac -t udp -q &
+	sleep 1
+
+	tc filter add block 10 pref 1234 handle 102 matchall skip_hw \
+	   action mirred egress mirror dev _drop_test
+
+	# Push to the queue until it's at the limit. The configured limit is
+	# rounded by the qdisc, so this is the best we can do to get to the real
+	# limit.
+	build_backlog $((3 * limit / 2)) udp >/dev/null
+
+	base=$(get_nmirrored)
+	send_packets udp 100
+	sleep 1
+	now=$(get_nmirrored)
+	((now >= base + 100))
+	check_err $? "Dropped packets not observed: 100 expected, $((now - base)) seen"
+
+	tc filter del block 10 pref 1234 handle 102 matchall
+
+	base=$(get_nmirrored)
+	send_packets udp 100
+	sleep 1
+	now=$(get_nmirrored)
+	((now == base))
+	check_err $? "Dropped packets still observed: 0 expected, $((now - base)) seen"
+
+	log_test "RED early_dropped packets mirrored"
+
+	stop_traffic
+	sleep 1
+}
+
+do_ecn_qevent_test()
+{
+	local limit=$1; shift
+	local name=ECN
+
+	RET=0
+
+	$MZ $h1 -p $PKTSZ -A 192.0.2.1 -B 192.0.2.3 -c 0 \
+		-a own -b $h3_mac -t tcp -q tos=0x01 &
+	sleep 1
+
+	tc filter add block 10 pref 1234 handle 102 matchall skip_hw \
+	   action mirred egress mirror dev _drop_test
+
+	backlog=$(build_backlog $((2 * limit / 3)) tcp tos=0x01)
+	check_err $? "Could not build the requested backlog"
+	pct=$(check_mirroring "== 0")
+	check_err $? "backlog $backlog / $limit Got $pct% mirrored packets, expected == 0."
+
+	backlog=$(build_backlog $((3 * limit / 2)) tcp tos=0x01)
+	check_err $? "Could not build the requested backlog"
+	pct=$(check_mirroring ">= 95")
+	check_err $? "backlog $backlog / $limit Got $pct% mirrored packets, expected >= 95."
+
+	tc filter del block 10 pref 1234 handle 102 matchall
+
+	log_test "ECN marked packets mirrored"
+
+	stop_traffic
+	sleep 1
+}
+
+install_qdisc()
+{
+	local -a args=("$@")
+
+	tc qdisc replace dev $swp3 parent 1:1 handle 11: red \
+	   limit 1M avpkt $PKTSZ probability 1 \
+	   min $BACKLOG max $((BACKLOG + 1)) burst 38 "${args[@]}"
+	sleep 1
+}
+
+uninstall_qdisc()
+{
+	tc qdisc del dev $swp3 parent 1:1
+}
+
+ecn_test()
+{
+	install_qdisc ecn
+	do_ecn_test $BACKLOG
+	uninstall_qdisc
+}
+
+ecn_nodrop_test()
+{
+	install_qdisc ecn nodrop
+	do_ecn_nodrop_test $BACKLOG
+	uninstall_qdisc
+}
+
+red_test()
+{
+	install_qdisc
+	do_red_test $BACKLOG
+	uninstall_qdisc
+}
+
+red_qevent_test()
+{
+	install_qdisc qevent early_drop block 10
+	do_red_qevent_test $BACKLOG
+	uninstall_qdisc
+}
+
+ecn_qevent_test()
+{
+	install_qdisc ecn qevent mark block 10
+	do_ecn_qevent_test $BACKLOG
+	uninstall_qdisc
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.20.1

