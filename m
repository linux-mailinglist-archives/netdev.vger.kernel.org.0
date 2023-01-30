Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E342681699
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237636AbjA3QlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237673AbjA3QlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:41:00 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408CA42DD3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:40:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWOTLl3dUJYsry0TD5su65AgqOgBKJAjz3+zKBAdklkf34kaIrDumh44T3bukAChoVR884t9eueab5oZbMTk9aZ2yyb1MDM/SD8PvSsIf1ncQaRg/Kfwj7eEUOoM49OSPEgCiHLBy2ak+HKc/kuFhVN8ayE3hqu3hmXWrNnhSPxMlp7bQBORF5J/YkJhhZ56xNxPPcv3SFdCNJ63Js9xiB5065cHvO3pWZxkieCRkAOJpvOG9KNKWgSTToRF22clezRt6ni0ADsGYZwDQEWUywY/TPMG6ZJBaiUqVbCHBqYYXO4taeY5RIwiYnVplBAICxij+GjSSQnPaUPKGsWSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFh6c88yghUl5OdABzbNUoAHJd5qnnEp8dQ1wkdpUNw=;
 b=SP9IX59ygTCywAJ72/KBTb9cpHsFMXnca58bmqg+S6NPYEgo/NgtQRaRUWcHG8ENQyKtJLBivC3lrKEtDxpE+BcOZidC6vrXCl3p0ffJSsDR19f8SYj1kjminqhvviDmnEjttLyyAKSIKgULTZ3CtD3Q+en964xh9HPZAMwTMlATczU4Prs3GdmRHerr/k1ZKZZfkOFAwL5dbhFPhErKGEULIWPGLi1yKx+LNv5uPmkLEcnx+l/uSPOlYOomATnxxMkwPS7+5IJOdOCSVeY5fAqKjRm7kyMps4czXWP31msAShlONa3A90VlLRJM2lvNu+NWaMIcnAx9XXyosQ7w6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFh6c88yghUl5OdABzbNUoAHJd5qnnEp8dQ1wkdpUNw=;
 b=DqFzoLZjWN47QcKWKVJIkERmif5OtqlWfhYNQgiUuVNxuvwtcSSC0gxjtazan9PzutByqV9wpRqOr6TAjaKqBE/uI+977TWQaYe6+YSgwgKjmUjsOq0ZgplJss8ctqmBqhr7mBKRuTI06ZZmAy3b1OBSX+BiK7VjO9gjNJKPkmI9KP8Cj2Bx5m0NfGlnf5Sfu4hZhhk391on/wuunJVZR2QhxdPA9io8PJBj54QuF/F2INZYVq/WrieRmXi+w1wrXiSEPQGSTc5fQ8kMcSiu2FlNk1iQyZSUcCX6zY21p6pZ36wSy4V8vPGJ7ySv2zjOQUw8WgfEiM5WWjuFGMZLug==
Received: from MW4P222CA0003.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::8)
 by DM4PR12MB5891.namprd12.prod.outlook.com (2603:10b6:8:67::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 16:40:54 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::89) by MW4P222CA0003.outlook.office365.com
 (2603:10b6:303:114::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36 via Frontend
 Transport; Mon, 30 Jan 2023 16:40:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.36 via Frontend Transport; Mon, 30 Jan 2023 16:40:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 08:40:39 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 08:40:29 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/4] selftests: mlxsw: qos_defprio: Convert from lldptool to dcb
Date:   Mon, 30 Jan 2023 17:40:03 +0100
Message-ID: <97355515e204a4db6981edd9d4b952caeb234694.1675096231.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675096231.git.petrm@nvidia.com>
References: <cover.1675096231.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT033:EE_|DM4PR12MB5891:EE_
X-MS-Office365-Filtering-Correlation-Id: 58eded90-0a0d-4a82-a235-08db02e0c13e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EESPVaIcRZWoqn5DJHYVR7EtWsTmXW5B1ifwFmyPlygQs/qsIT5QMb3weGiXnxpmyQlSCoMjEtVrRCROjt1gLJXDFkWU+kDFFW2CeIMjPazsYI/UbSlxhl3tfSX9KD4be2YeGgh5z1i3bmCWdomRVdTAbICck1btsM6BWp+XCjYaqotNFxSS8o2haEO01U+KdZ9LExWPBcxdNBFTKNxT4Npqr/RHyAfRRat3huPcSmOVamcZQ75/SwTaZFJDr8LFXG6lSwFKMryhah+G9zQ8/2QEh1/77LLHPOT7pZlbIG7Z3YVPn1B5JBLqxU1uxjkg15u+j/cY6+z4hUDlCRSPwWtwA0l0Mmj/+KXdG3c5EUX18auwktGE7cgFkOBjc/EC2RESMon+LmYoQfeaSntEMbXsgwesgt5Lu6BXlFY0VPHUOeKEkULE/GqlMSIbgi8/J1jw76pGOtnIUv2fxgjw5k5+R1zeJtE9XcPe+YMPYkLBAA+mqWyjn6H+KgiFdjSHsEFZxjJMnbSGDyF54Ihc3vivnc8fiIUgYAsVzggKiwfNjZqL6qYJNNjJEi+qILzFK3tyG+e+o5FCvAQWHSRuflDelU3PMfYzB30VSdnqwAHjkZClbBIOcpTSineAzIZExt45v7kGY7yppsSlD05H9mnvsHrk8FzUPZPHv5FrmQDIS2EeeOQt4MZRpjaGxARzvaldHeRi+mzvxzCNII7Teg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(2616005)(4326008)(70586007)(70206006)(47076005)(8676002)(426003)(336012)(26005)(86362001)(82310400005)(2906002)(36756003)(41300700001)(8936002)(36860700001)(83380400001)(478600001)(54906003)(110136005)(186003)(16526019)(40460700003)(316002)(107886003)(6666004)(5660300002)(7636003)(40480700001)(82740400003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 16:40:53.9532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58eded90-0a0d-4a82-a235-08db02e0c13e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5891
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up default port priority through the iproute2 dcb tool, which is easier
to understand and manage.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 .../drivers/net/mlxsw/qos_defprio.sh          | 68 +++++--------------
 1 file changed, 16 insertions(+), 52 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh
index 71066bc4b886..5492fa5550d7 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh
@@ -5,18 +5,18 @@
 # prioritized according to the default priority specified at the port.
 # rx_octets_prio_* counters are used to verify the prioritization.
 #
-# +-----------------------+
-# | H1                    |
-# |    + $h1              |
-# |    | 192.0.2.1/28     |
-# +----|------------------+
+# +----------------------------------+
+# | H1                               |
+# |    + $h1                         |
+# |    | 192.0.2.1/28                |
+# +----|-----------------------------+
 #      |
-# +----|------------------+
-# | SW |                  |
-# |    + $swp1            |
-# |      192.0.2.2/28     |
-# |      APP=<prio>,1,0   |
-# +-----------------------+
+# +----|-----------------------------+
+# | SW |                             |
+# |    + $swp1                       |
+# |      192.0.2.2/28                |
+# |      dcb app default-prio <prio> |
+# +----------------------------------+
 
 ALL_TESTS="
 	ping_ipv4
@@ -29,42 +29,6 @@ NUM_NETIFS=2
 : ${HIT_TIMEOUT:=1000} # ms
 source $lib_dir/lib.sh
 
-declare -a APP
-
-defprio_install()
-{
-	local dev=$1; shift
-	local prio=$1; shift
-	local app="app=$prio,1,0"
-
-	lldptool -T -i $dev -V APP $app >/dev/null
-	lldpad_app_wait_set $dev
-	APP[$prio]=$app
-}
-
-defprio_uninstall()
-{
-	local dev=$1; shift
-	local prio=$1; shift
-	local app=${APP[$prio]}
-
-	lldptool -T -i $dev -V APP -d $app >/dev/null
-	lldpad_app_wait_del
-	unset APP[$prio]
-}
-
-defprio_flush()
-{
-	local dev=$1; shift
-	local prio
-
-	if ((${#APP[@]})); then
-		lldptool -T -i $dev -V APP -d ${APP[@]} >/dev/null
-	fi
-	lldpad_app_wait_del
-	APP=()
-}
-
 h1_create()
 {
 	simple_if_init $h1 192.0.2.1/28
@@ -83,7 +47,7 @@ switch_create()
 
 switch_destroy()
 {
-	defprio_flush $swp1
+	dcb app flush dev $swp1 default-prio
 	ip addr del dev $swp1 192.0.2.2/28
 	ip link set dev $swp1 down
 }
@@ -124,7 +88,7 @@ __test_defprio()
 
 	RET=0
 
-	defprio_install $swp1 $prio_install
+	dcb app add dev $swp1 default-prio $prio_install
 
 	local t0=$(ethtool_stats_get $swp1 rx_frames_prio_$prio_observe)
 	mausezahn -q $h1 -d 100m -c 10 -t arp reply
@@ -134,7 +98,7 @@ __test_defprio()
 	check_err $? "Default priority $prio_install/$prio_observe: Expected to capture 10 packets, got $((t1 - t0))."
 	log_test "Default priority $prio_install/$prio_observe"
 
-	defprio_uninstall $swp1 $prio_install
+	dcb app del dev $swp1 default-prio $prio_install
 }
 
 test_defprio()
@@ -145,7 +109,7 @@ test_defprio()
 		__test_defprio $prio $prio
 	done
 
-	defprio_install $swp1 3
+	dcb app add dev $swp1 default-prio 3
 	__test_defprio 0 3
 	__test_defprio 1 3
 	__test_defprio 2 3
@@ -153,7 +117,7 @@ test_defprio()
 	__test_defprio 5 5
 	__test_defprio 6 6
 	__test_defprio 7 7
-	defprio_uninstall $swp1 3
+	dcb app del dev $swp1 default-prio 3
 }
 
 trap cleanup EXIT
-- 
2.39.0

