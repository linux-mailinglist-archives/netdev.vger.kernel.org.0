Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F725183834
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCLSGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:06:09 -0400
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:6068
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbgCLSGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 14:06:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnVOi4REnMiTqdVLZwoVtFO9ra3jAZnfWksM7J5hJt+zLmme2yrGwCc349NtxT1ib6NTPHTwZzIy5wEDLr55ep/9zxpv6KoxfmugRyQa2COHfkq7qsMt/LiBo7U06VD3nUPYGprkCpObDG2vuzGQIO4oX1q4GMWO6wi4gsZtFGUwHYKaU7SEC60l02+g+udI9ABzQOmfCVa4vAAmlz1Oza95DSTTkSIVPkACYamI7pPUf29wTG9FX6J2wYCTv6YBXk7GT+7eIvT2s/NmWxASAdwLvPOVZ1tEDzUboyl37Tl/DBDk0fOd4IISnVC7ZX5FAW2rC9Us/weWKNSDPona7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeDjEnINVVOXIHJOQZ8CRzRUoRnz8lpvIG1yuX4mwWI=;
 b=eYWu1HNTMozzMagiJcM0kXNJrGWGEJBCnyFGfdbRr92kZZQgFLiw3Ht1usUFi+uPc5QPRoAobKSHiqwIpRW7bBlLl4/M++YmMxi1dJjzinll4Blby1Sw1ncKPtjbpKa2eBTLLp+Y5AtO8BhNlKn/cmOMnXRm+7Awz1WWyUIx2XbLGl24fq6o/LXdoy6hsMdyz7iUcbAP5clLgChtz5tpU2Dc/PX7YrUJulSaQAYW/zNRltbplmagTBl603mrNyAASE0P/QRx/I+Mgh1ON5kg6/Vz7wuJfMzQYmqVnC7thAhXMO567blcOVhhllv47Z6qr4Vj3zB6JuT0ZHbrObCkng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeDjEnINVVOXIHJOQZ8CRzRUoRnz8lpvIG1yuX4mwWI=;
 b=Xt78hA3TSX5QniAUuQoA/6mEYk5REpg9mAm8kBdhvUt+6dKAXQbJ1vWtGoTfdkwhPdTWsqQ8DeUVm+X9/7Wr1A7EzFsZ4JAqu5P30HqRH/D2kohsv3hrVF+RiYQnmD4c5sOllxDeQsmBcHDRWxbdI0tFSXtFSXkTa+JT/NFkxaU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3499.eurprd05.prod.outlook.com (10.170.243.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 18:05:48 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 18:05:48 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v3 6/6] selftests: mlxsw: RED: Test RED ECN nodrop offload
Date:   Thu, 12 Mar 2020 20:05:07 +0200
Message-Id: <20200312180507.6763-7-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312180507.6763-1-petrm@mellanox.com>
References: <20200312180507.6763-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P191CA0043.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:55::18) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P191CA0043.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:55::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 12 Mar 2020 18:05:46 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fa5fe0dc-4f8e-429c-b355-08d7c6affde9
X-MS-TrafficTypeDiagnostic: HE1PR05MB3499:|HE1PR05MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB349961055D43F172EFB6919FDBFD0@HE1PR05MB3499.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(6486002)(52116002)(81156014)(81166006)(956004)(8936002)(2616005)(86362001)(54906003)(4326008)(6916009)(316002)(107886003)(186003)(26005)(6512007)(6666004)(16526019)(1076003)(2906002)(8676002)(36756003)(478600001)(66946007)(6506007)(66476007)(66556008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3499;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nLIeL8QbNXCgMqiZES7JSIsCoe9mXXDSBEoOvV6hT3R9xKx4uJjlo+REU92nhKLQ+hDUd8YbGpiF//HR+WupxSHns+Me3qhgViuoU+EfA3WmcC/o9y5YPyOpU+8JmziwytMwNVzTyAwy5RtydzgxeHvMPqHpio5jk7seYDLOtus6nqUxfytHpK4goeIosvjMUVCdcgaTy6liVw5byRp7RzJgr4nDuc/Z9QdvzUd4KLQ4wkP8fKWO2JzfUTJ7Db57Oqh/WUZhGAtNcbWK6vJ/jXVIcRjaqsorQHLdGVj47llVWnuWQ6TaePuojgakSss5At9fKNW3s40LDstZCHzEreZuHli/trqShbiyzISbx1/kv7r0WzgNtrd0hRJr7wMQvG7v3PvA+vh4WEDu0imhtmLip+PhG1M1OHztV+q4swp+7iIMFLH81IgICYPrSbcf
X-MS-Exchange-AntiSpam-MessageData: rOCgEq6VZY6U9GfqPu61NjFT8NoL6Jia7uzxMO4xcTxmatarZY6059SF4DvaeIAqtEw4EiZUxZZitt127yQRjRH8sVZzhaBPZMaNGRGkIlbRpseXy0AthSJaY3RHZNTmgeHA6Xq4OcvUeiMJLYEGPA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa5fe0dc-4f8e-429c-b355-08d7c6affde9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 18:05:48.0540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zrJiZhkmNvtmt/xNfoncJ2A/OBKZOmBznQXu2pd9aVWg5Q6CoXUZ1Qsz0TH2dLJOUFDFU2sNk2AVm9oHjHSaZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3499
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

