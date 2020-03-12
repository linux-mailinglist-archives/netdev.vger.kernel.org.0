Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D263183D1B
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgCLXM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:12:57 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:26253
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726710AbgCLXM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 19:12:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=danLRWiMqvyy+48jtQLooi2OB6e95K6CkJHnFJqV2TTkHrfWYcA5lxIdndle2MbwZbCpOCenvtmBLpDMfDK/MoYmgB3a7qL5wUaL7vPsSvP50yMtBnCMEUVBVZggvzLMNDQNamJ5s9oNe355aeWoe5MY2ivhG7E91BsnSarLkjzfYH7CIuxMr5ITJ2UR8ZKWXLsq64U2UKqVGSr36ZExw9/Q1/6m/tGmJwTkQzndnRnc/fVwyT5Tr4sFbLMm+OTOB58sl03XR6ebrg+E0liPRTNYlMm78B8sJAECpAvKaV1yNxzf72OP3gkKQMYjUzbglb3/FtgHdJZ+aI104KPEpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeDjEnINVVOXIHJOQZ8CRzRUoRnz8lpvIG1yuX4mwWI=;
 b=bGuC9efFAdvZzAtR1ljf8ZJ219kFuDzGJWp1MWNEb3DMO5XzQd3EgG0JYUFLvE0wEJ0VtoeVPhjoUi+twLBpGBfX2j6OLR3Hk/pvUtw2HWa49AGQckoF/XWb54sj1egzOYpUT0xUUBbvDdUVGSoTpZ5pOIzM5xHjymW1qjqKZTlWEpJ2lE0nerTALQor9OcGWZwqlwEAXMaqB3+r1ADrPQBbDsPt/2EJE+ugUbQ/GuGUXyRs21uEGFfW9TBJVv2gscS5oldaiIdTOUUiolw8B42rbWSG7I9Jkaq8/9Y10DvrpEzxpNI+T6G7OB9hH9/20NVpAszcdwpLjqMOgzHFSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeDjEnINVVOXIHJOQZ8CRzRUoRnz8lpvIG1yuX4mwWI=;
 b=exoo5R4sxZJvPFWPnQJ0x5pogR+Mbbalegppyqxn98x2NUHMmy+0oT8yIR+9+AYJpx5v2qMVKBQgjGy9Q8w8khx3S0XxKPaEYctBAvtOfQSSyTo3nZRPaY5KRbYQyPf6GEAdq7o+rTq/Egu0lELudYgxkp7T2HI8/hPmmoH/CvU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3194.eurprd05.prod.outlook.com (10.170.241.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 23:12:45 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 23:12:45 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v4 6/6] selftests: mlxsw: RED: Test RED ECN nodrop offload
Date:   Fri, 13 Mar 2020 01:11:00 +0200
Message-Id: <20200312231100.37180-7-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312231100.37180-1-petrm@mellanox.com>
References: <20200312231100.37180-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.20 via Frontend Transport; Thu, 12 Mar 2020 23:12:44 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6fa2f2bc-3fad-4b5c-4d92-08d7c6dadfc9
X-MS-TrafficTypeDiagnostic: HE1PR05MB3194:|HE1PR05MB3194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3194C7178565DFEFC8A4D155DBFD0@HE1PR05MB3194.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(199004)(316002)(2906002)(66556008)(8676002)(66476007)(66946007)(4326008)(54906003)(81156014)(81166006)(6666004)(36756003)(1076003)(5660300002)(6512007)(6506007)(6486002)(52116002)(478600001)(16526019)(107886003)(26005)(8936002)(6916009)(956004)(86362001)(186003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3194;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4dbn0RR33Pxvsyip52GnkDcaSL+Q+j/Mzr+At7/f7quZ1gJySG6Zaswu2pCwwkdaaJtky1VbcRPYbR+mwqNaA9Br9sxhZbEse9xEvoMqgRtyw6Rd6BmOH3QxyRmI0cMntE9jHMw9Lh2ceQqWURplhn2NZbCkJZzaTSSJAsnAk9ed5dFTcG8y5383ZT04kk1/1IL4FMFczLaZkLSdIthYEacht1OBzLkiziPjW7KMcAZIdkMsNejxmSqadK3ojV6rxTr3V5cldnmzEXOihLAfHKKsl5eu1gDBGiikmeem90tydUzg5HR53mpFcdzBG1DApq+Md8H04s6WCMIMC8NHkBU/ylMWRHbe9/5rBo1YgQHopxAjRLh0qN7XqttI5DYZsYUzf+/3SBbpHb95Z8vPEQuToo2GGr0yXZ+o4q0pYaAIHDAxKDGqySzg2OrcxvSW
X-MS-Exchange-AntiSpam-MessageData: RE/E5DNTYaWcte716hG9L1nNxUB3FhNHNL1hmv87POoapU/f3cV2hcwKPn/KrWNJhjJ9MII+tWYnVGoZt1Xi1CqMPAbXjSKtvFSjiAvMYxGFqGDHE5Rne0l9HUoteYf1WW+HQoP7dCpTns0oOEkyYA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fa2f2bc-3fad-4b5c-4d92-08d7c6dadfc9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 23:12:45.8454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jl4WiJ3yDsjiqCiP8pPpC8a40tzn1Vh9+30EoNS/RqlUPG/k5gg94/sWfNjkS9Oy7Av1ccmP+wrIENo5wLVW2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend RED testsuite to cover the new nodrop mode of RED-ECN. This test is
really similar to ECN test, diverging only in the last step, where UDP
traffic should go to backlog instead of being dropped. Thus extract a
common helper, ecn_test_common(), make do_ecn_test() into a relatively
simple wrapper, and add another one, do_ecn_nodrop_test().

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v3:
    - Rename "taildrop" to "nodrop"

 .../drivers/net/mlxsw/sch_red_core.sh         | 50 ++++++++++++++++---
 .../drivers/net/mlxsw/sch_red_ets.sh          | 11 ++++
 .../drivers/net/mlxsw/sch_red_root.sh         |  8 +++
 3 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index 8f833678ac4d..0d347d48c112 100644
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
+do_ecn_nodrop_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local name="ECN nodrop"
+
+	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
+			  $h3_mac tos=0x01
+	sleep 1
+
+	ecn_test_common "$name" $vlan $limit
+
+	# Up there we saw that UDP gets accepted when backlog is below the
+	# limit. Now that it is above, in nodrop mode, make sure it goes to
+	# backlog as well.
+	RET=0
+	build_backlog $vlan $((2 * limit)) udp >/dev/null
+	check_err $? "UDP traffic was early-dropped instead of getting into backlog"
+	log_test "TC $((vlan - 10)): $name backlog > limit: UDP not dropped"
 
 	stop_traffic
 	sleep 1
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index af83efe9ccf1..1c36c576613b 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -4,6 +4,7 @@
 ALL_TESTS="
 	ping_ipv4
 	ecn_test
+	ecn_nodrop_test
 	red_test
 	mc_backlog_test
 "
@@ -50,6 +51,16 @@ ecn_test()
 	uninstall_qdisc
 }
 
+ecn_nodrop_test()
+{
+	install_qdisc ecn nodrop
+
+	do_ecn_nodrop_test 10 $BACKLOG1
+	do_ecn_nodrop_test 11 $BACKLOG2
+
+	uninstall_qdisc
+}
+
 red_test()
 {
 	install_qdisc
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
index b2217493a88e..558667ea11ec 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
@@ -4,6 +4,7 @@
 ALL_TESTS="
 	ping_ipv4
 	ecn_test
+	ecn_nodrop_test
 	red_test
 	mc_backlog_test
 "
@@ -33,6 +34,13 @@ ecn_test()
 	uninstall_qdisc
 }
 
+ecn_nodrop_test()
+{
+	install_qdisc ecn nodrop
+	do_ecn_nodrop_test 10 $BACKLOG
+	uninstall_qdisc
+}
+
 red_test()
 {
 	install_qdisc
-- 
2.20.1

