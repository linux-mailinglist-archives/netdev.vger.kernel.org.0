Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BD96B3E47
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjCJLp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjCJLpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:45:54 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2048.outbound.protection.outlook.com [40.107.212.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD45111B23
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 03:45:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNfskLc4Vdwjz3Vy7JJHgKWCcKZ9HUeI10QskeVRmY1mNRHVfP08UHC7Llad4zHwbSdSSy8zyADs4GlzyuXs0cHKZdexiJvrg0utZUBp8oyxC6XOoFd97W/s4ZPK/J5iFkM4il2HwASF/ML0a0/loxkrPpdJz4tVAD9bwIpKD5SUJf0RRL4h9kmSEgQ6sR4wkEwdGuZWmukY3k3s0A4pwgLxWK5SgYFaMotcMHTehhV2X7Upr+jCgNYy6BjXLyTkGmoZk4LBlDxBiey79RsnE2sMDzem0iY3/xbSqgKD9U0DpZJ4kgfOi0nPG2UAW0Oj/uNIhwsIBGW8849fAVufsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SncSkxrYZjZub5s8HUsVzREcO0+rjC9r+cNXszIx2is=;
 b=Wz9PWtVvwwqoTddkVSlyZlhMIGMfefs3DhwnjhRzB7pSdvCWCbxlGW0g2GPM0waHW211n8AYQIkzPSnLbF3t4B2L+3ab11goNm74hhliHbLgKt7f+zqCLw6RM60sLRV0vo4/i1CxRV4LVZwFEodDkVYwkayuYCn3xnqT3iKjY7eqOwFK5EmUm+QEdAwowZJqrSPEI0/EYkcBsg9H56/RYYpnbCsBB7VWGGGnC/wiQM0tMuvu3GoZUclm8iRVXqFUWonm/hL0aMd7EbDhRvWiIsRlhcbudO4Z12OOS2813WxU0xqRNf5AcV8BMthhycqq7skx7RziZsPcO4RiRo+5ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SncSkxrYZjZub5s8HUsVzREcO0+rjC9r+cNXszIx2is=;
 b=uc737kUUnNe88clOaqAn9x8wAc+PZ6xv6NEbfvCkbPyKCubcR4iQXdjO3Mhm1eDR3SUG92TG00kPxjI2cnNUQw+Hkai8FuC7M1TN4tcWY1ce46L1qS9HSYzUZYMKcuRtHzhi2yUCkGfMWexnM8dkTgbPzOvm/mnlbGzRSesc7j/YspbdkSwZ6XAbm7A1koq8EYTEaE9YWMhoP2ilsrPJg3tFi/+2toyDsIfXHfjfvukpPRB6+o/V6dCHq1ER+RevdBWWK2C/elmEF6JVgjdp0btBO6ZsYpYYs2iR3iPXPlH0EmWZq4fUggGMyg1EjHdJmstoCEeEUm7YzwbqI+/Spg==
Received: from DS7PR03CA0149.namprd03.prod.outlook.com (2603:10b6:5:3b4::34)
 by DM4PR12MB6375.namprd12.prod.outlook.com (2603:10b6:8:a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 11:45:47 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::48) by DS7PR03CA0149.outlook.office365.com
 (2603:10b6:5:3b4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 11:45:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19 via Frontend Transport; Fri, 10 Mar 2023 11:45:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 10 Mar 2023
 03:45:39 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 10 Mar 2023 03:45:36 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 4/5] selftests: rtnetlink: Make the set of tests to run configurable
Date:   Fri, 10 Mar 2023 12:44:57 +0100
Message-ID: <9cddd641f70f7d388ecb164898a8574fefb174b2.1678448186.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1678448186.git.petrm@nvidia.com>
References: <cover.1678448186.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT050:EE_|DM4PR12MB6375:EE_
X-MS-Office365-Filtering-Correlation-Id: c8206ad7-6c76-453c-9d55-08db215cfd38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fuu7HnOmklXNieljazLsyuQYh5gpsx4CAn1EOthuaFMA8dXQ2dot2lS74Wlu3pHGUIUebNYdchnsFOQLGVfWyICnTkqmi8ceECj6WHAE0OhoYjvRevEIm21VYKjvEXVb43TkMM/jFGtSvEIfqYrpAOjMHaJozzAQZIj2q/BaW/aCvMfnNjWO0zI54dwZmpOFJEN4uL0oofejZKDGHvUaj4/NIw4d/bFKOmIM8/Jv0+H5c4Uosgh7w5PLjY3i2yxpxEYMcTBJWJLXkNgsJwk10O596DCu4w+GfOLceHtVXaCSlwy9tMM0lHLah/PLGornPHR82u1Rd6v8ICI5eftd953NS2jzGTcPvJWlnMDD1J+y6UYPFtUCY1YUG/kAhz6NVC0I9UtO4TII9N8GIFCCfI6WG0I6xtCS6sptNgsUo7x76h2ioJB2kLBI8IJ+HT6Hokojq4ohP8W6nznyze/+8TA9Vsf0pgNqV+oXEqR4pOIEicfliUuEDyiM2eUNOiIkn8GVkDTgoPCsaatvhgpAi6z7qEcB2jRs6Y85Hq+Q1yx27hzNB6aEbf4H79kqYQeZltVI/kTZUZ9iYKT6OYUtCBhIlLyQvGmSGZu7dacvAP6dDnq83LjNYjbTPFZd5Xtko9rjPSRi6TCQ0f7A5Ed90Cy7PEwo+1uHK1xyWmgKOaZfgP+7mdtawo6Gsujtlnq1zbHq5VkQEqA85kfjRpiIThGTdbv1Qd5ateDi/Cre+WDL58hVSNqIzJ6fgWYCD+6s
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199018)(46966006)(36840700001)(40470700004)(5660300002)(36756003)(40460700003)(83380400001)(47076005)(426003)(82310400005)(7696005)(478600001)(107886003)(6666004)(26005)(336012)(2616005)(16526019)(186003)(356005)(8676002)(4326008)(70206006)(70586007)(40480700001)(8936002)(86362001)(54906003)(110136005)(36860700001)(41300700001)(316002)(82740400003)(7636003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 11:45:47.0704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8206ad7-6c76-453c-9d55-08db215cfd38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6375
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract the list of all tests into a variable, ALL_TESTS. Then assume the
environment variable TESTS holds the list of tests to actually run, falling
back to ALL_TESTS if TESTS is empty. This is the same interface that
forwarding selftests use to make the set of tests to run configurable.
In addition to this, allow setting the value explicitly through a command
line option "-t" along the lines of what fib_nexthops.sh does.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/rtnetlink.sh | 90 +++++++++++++-----------
 1 file changed, 48 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 275491be3da2..12caf9602353 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -4,6 +4,30 @@
 #
 # set -e
 
+ALL_TESTS="
+	kci_test_polrouting
+	kci_test_route_get
+	kci_test_addrlft
+	kci_test_promote_secondaries
+	kci_test_tc
+	kci_test_gre
+	kci_test_gretap
+	kci_test_ip6gretap
+	kci_test_erspan
+	kci_test_ip6erspan
+	kci_test_bridge
+	kci_test_addrlabel
+	kci_test_ifalias
+	kci_test_vrf
+	kci_test_encap
+	kci_test_macsec
+	kci_test_ipsec
+	kci_test_ipsec_offload
+	kci_test_fdb_get
+	kci_test_neigh_get
+	kci_test_bridge_parent_id
+"
+
 devdummy="test-dummy0"
 
 # Kselftest framework requirement - SKIP code is 4.
@@ -1227,60 +1251,34 @@ kci_test_bridge_parent_id()
 
 kci_test_rtnl()
 {
+	local current_test
 	local ret=0
+
 	kci_add_dummy
 	if [ $ret -ne 0 ];then
 		echo "FAIL: cannot add dummy interface"
 		return 1
 	fi
 
-	kci_test_polrouting
-	check_err $?
-	kci_test_route_get
-	check_err $?
-	kci_test_addrlft
-	check_err $?
-	kci_test_promote_secondaries
-	check_err $?
-	kci_test_tc
-	check_err $?
-	kci_test_gre
-	check_err $?
-	kci_test_gretap
-	check_err $?
-	kci_test_ip6gretap
-	check_err $?
-	kci_test_erspan
-	check_err $?
-	kci_test_ip6erspan
-	check_err $?
-	kci_test_bridge
-	check_err $?
-	kci_test_addrlabel
-	check_err $?
-	kci_test_ifalias
-	check_err $?
-	kci_test_vrf
-	check_err $?
-	kci_test_encap
-	check_err $?
-	kci_test_macsec
-	check_err $?
-	kci_test_ipsec
-	check_err $?
-	kci_test_ipsec_offload
-	check_err $?
-	kci_test_fdb_get
-	check_err $?
-	kci_test_neigh_get
-	check_err $?
-	kci_test_bridge_parent_id
-	check_err $?
+	for current_test in ${TESTS:-$ALL_TESTS}; do
+		$current_test
+		check_err $?
+	done
 
 	kci_del_dummy
 	return $ret
 }
 
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+        -t <test>   Test(s) to run (default: all)
+                    (options: $(echo $ALL_TESTS))
+EOF
+}
+
 #check for needed privileges
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
@@ -1295,6 +1293,14 @@ for x in ip tc;do
 	fi
 done
 
+while getopts t:h o; do
+	case $o in
+		t) TESTS=$OPTARG;;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
 kci_test_rtnl
 
 exit $?
-- 
2.39.0

