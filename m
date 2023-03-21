Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC1C6C30EB
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjCULxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjCULxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:53:17 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DD43C37
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:53:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpB0+Afre7vmmG46XrycoxN86u+YkBOXwJG8+2Q8uy1sHnmSKtwoBc4kk8WY1kGxAZabEtRRJe62dA+C4soDUVNaomjeFyYMHGMm9Ic4+KJD5gYTBD2Dtd/DAHD24E6w7CHqBe4ey/RsbVzkG8OLXJxPbJjAs+RGzWnXrIurs3Wg/4V211ocJQO0Dwl3r57SEjZG1SgWGu6v7+3uIZ/UUjcCRKPHlsdbuHXBmMS8giPeTlJZPk3y3fBjpA4FY9VGG+iTMFh/IDDYpxr9CapQKtWaWAV9qVakqRhwZ+K69Lbx1t6ynPL4FoWK/S+OK0/huDzwQicukFadxuOXCRApQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SncSkxrYZjZub5s8HUsVzREcO0+rjC9r+cNXszIx2is=;
 b=DYS4509eqSlK+nkZwy79V0PoO527Nr3UZkIWo7FRVwB2pUVWHK8SuqYHQocPzkdMkLjLg9p0jiUxo0iliOQg75gDeE81zu2ovZ5mtB8ry/qw7ZxDN0JYV6aHSiPrludAgup4H5npAKWVeMP7heM6G7TvwdStUT+Th9egznV7Mh65GZuNBKtB4ijR4A95LGKt0mKaLA9xbrfJZhYK+r0LHYmKKLlmY9hVzUDDxiJt29G3dkpm5zzPIxJJGxj4hb5cKu/xUfmRIe0YCDmIRvlf+dWQmQH8TKyKeoWOO5goEpH+5EneFwwMzIkdU8nQ2xkXE9YaKp6/+WpHfbUt1bqqxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SncSkxrYZjZub5s8HUsVzREcO0+rjC9r+cNXszIx2is=;
 b=F8HPP1jx0M6NqL/dRsfrdsNJeC0voYFOA4Hl+wOSVOgh46uMRGSxa+YWO0d/zUn80wICr+AyNT5Rt/9S+/9/m7pum95EB3xnfSRyXPy4+dKraolXv03pdBS/5CavJpc23QyAzb6bGYg6JHVySN2nOovGzav8bl8aEnfZyX3Vxur778UocQrYQIWqNAz+Xrnl1PSagrmXrVvT6glGPHLwoRQQsayLcntG0hTQXGHbCbZRt3QLpTVkKr1ccjPFZGw2Fb6rdM9z9NvwbmG2kscsPoEtsyOOWSt6+jWfOTqItcJYK1PwDpxIFtNiv8uvhCn7KqttRjh8kW2uAPghUcwDCA==
Received: from MW4PR04CA0283.namprd04.prod.outlook.com (2603:10b6:303:89::18)
 by DM4PR12MB6543.namprd12.prod.outlook.com (2603:10b6:8:8c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 11:53:12 +0000
Received: from CO1NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::31) by MW4PR04CA0283.outlook.office365.com
 (2603:10b6:303:89::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Tue, 21 Mar 2023 11:53:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT069.mail.protection.outlook.com (10.13.174.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.16 via Frontend Transport; Tue, 21 Mar 2023 11:53:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 21 Mar 2023
 04:53:00 -0700
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 21 Mar
 2023 04:52:56 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Jacques de Laval <Jacques.De.Laval@westermo.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 2/3] selftests: rtnetlink: Make the set of tests to run configurable
Date:   Tue, 21 Mar 2023 12:52:00 +0100
Message-ID: <7528983540119d50cc306046003b6ec878c25d89.1679399108.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1679399108.git.petrm@nvidia.com>
References: <cover.1679399108.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT069:EE_|DM4PR12MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 42d9ac1d-1348-4288-9efc-08db2a02d8e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fiLql3z+O3ol6LdttNni0gixBnfxppp1D4HMCRdUQpWzeFBx4eVStTD1DXhvIH5o07gEYA0Mx/6S3YNc7VOcY3pf6Jgw0yzWdjitvfCHvh2RR0rPYeGiKus8iG41AWkHbL0zEfyrAEUiCPgZooyv+Dko+6gBD0LLWpi/1hkIZprBBmXteM/IjRgNK9KWlNwJXM1ko7jJjO/0FMMAUpGhAyQJg2rIF/jgazuf3hTovk43wkpPl5XBiKz1Sm0pF8NdAfd+OQw3YhZp5St/1QEMlCM1jnvI+EqvH3ZvUdeotS/Ybj7qnjJNnhq2EXS7US1Zvohi/ii61aP3dQHpw1fcZep/G+0Mf0/57idqGB+rFzn1o5Xet92XcHbiz9f0JT0qhstw0A2Fwz3krVCikX08Ga0VQ30KVSR0QQQ8IlYi0psZN4b/9ajaEv1VkFvxmMopUqE3ig1WLNu5ySUov00aH0S9IiH0G7muqTIHaL8pov4Z0SJkygsDSVOoUbf/b1KRL2bJW+RZaLmPP/7et88g+DUJenP2K4KFcKIEcyhj12cf1TLzoP0wMXrkLGZIAQx6H80q+bj/DVxi4mKpJSIO43M09tf1vpJnR6zuGBhyTuBToFhU6jRwhPK82AR4iu4T6Xs+1APQWIMmvX11EF9F2DSg7k+m4FVHUl51Tz+VxC2iH2u5Nt+aGwjqnQkC4Rczxplvmrw3JBiHPsOIwykbpImOxPz+u1rbWVdS2GGAVqpzk+bnxQhxUwcUFLbyVWBb
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(46966006)(36840700001)(40470700004)(8936002)(5660300002)(41300700001)(36860700001)(356005)(82310400005)(40480700001)(86362001)(40460700003)(82740400003)(36756003)(2906002)(7636003)(4326008)(47076005)(336012)(107886003)(478600001)(83380400001)(426003)(2616005)(6666004)(186003)(16526019)(26005)(54906003)(110136005)(316002)(8676002)(70206006)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:53:11.8304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42d9ac1d-1348-4288-9efc-08db2a02d8e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6543
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

