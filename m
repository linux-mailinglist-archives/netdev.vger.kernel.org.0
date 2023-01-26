Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BF467D275
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjAZRDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbjAZRDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:03:04 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB70627AB
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvPw/zt4/iLQQkCD3ysdipMkmr52a6KcBeR+vBGo6RA7Y5OlTfH5qdnJbfEMCd1u2i7+uLf3qI8ma98QQU4Jf+ZkoNX4kbXKBZTen40rERn6I+XhAHQwzMtXhtp+J8a1jJa2mMROBzgS4i95QGEIstc7mRDMUrmWAGl09cFeA2/PSCfoTyqOp/JJHr/+bWOxUBBJpKM6XUZW0U5t/eec7bLiE2dPfex+DzSOfRxZiTtxQ+ZbgOxNCpBJfjLLtf11DNniqyC1OEI8s7QhUzWBmveZG8WMCG1XeWLWTEqkT6lHeWIMqjrYGfRN55mlJy/wp7vUebGmf74U05M7LLCbZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPmMgbTNAa3suo47eUtpRBod/PKKZeaGlEKeZ3Lkeeg=;
 b=VMjlBNDNuOYTZHDBYHEVNUnFUiRXr5ly0ihd1jjYETFQN+Bq2ipmsNDRF3OgaPP7GtZRgnvJC2xnAujLBo/nh32gptut4WS23+4yoLZO0XTRIG6gRd1ZQE7P/hgrriQWELPGRR9XAJIgtCleOzuI5FT0lfyjB+yKyCvr7H1sjHPztV8XaPdCIRfnve1Fm7OTHI3YA1xf6QToVznAg0jEfsLRSffBctmeIjXs9BqcyLFyATLZmnZk+JS4Ve3ePAxunAvkkemGLpMYbyMvO73rubxzCblX7hZVJpckeqHgzjTdGO4uUxNCk1DT76s/45ukYTWn+x2dxkq+k2y8t3sj1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPmMgbTNAa3suo47eUtpRBod/PKKZeaGlEKeZ3Lkeeg=;
 b=RIUPqwjorFopGmlUrMQ66WwV5iC3gK9ofT+TmHl+z6/Jb+Z48K76ivxsIcOmmM7RmVKMy5gpCLZSLGjPQPOEimuLC8WqJozl052FjDvCD6qxyxp3cSBsDvtGh3tKqZr+924cohzzA9fl+bqITy7ybcIYhvBX8FuOT+v4E+x8Kpcsmy7Iw/ctxswAdVKfaBrGPKJemrxHvqr4UPDGkQpduMxV1jnTHKi/Je5flQc3ZwoFNWvMn0HM3Z74IQXn692GP+wfAWPlBCLHW6POAlBMtAzEfk7i2VTQeptftSJftIuRdU+rAhM008h9qceF0/YDdFCE64UbtK78az0SGbMEow==
Received: from MW4PR03CA0294.namprd03.prod.outlook.com (2603:10b6:303:b5::29)
 by PH7PR12MB6492.namprd12.prod.outlook.com (2603:10b6:510:1f3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 17:02:34 +0000
Received: from CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::3d) by MW4PR03CA0294.outlook.office365.com
 (2603:10b6:303:b5::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT110.mail.protection.outlook.com (10.13.175.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Thu, 26 Jan 2023 17:02:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:26 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:24 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>
CC:     <bridge@lists.linux-foundation.org>,
        Petr Machata <petrm@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next 13/16] selftests: forwarding: lib: Parameterize IGMPv3/MLDv2 generation
Date:   Thu, 26 Jan 2023 18:01:21 +0100
Message-ID: <a2a17da9f91c3648fbcbc2890c961c9a9b70d61d.1674752051.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674752051.git.petrm@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT110:EE_|PH7PR12MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: e343ac4c-1962-4635-536b-08daffbf1eb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+v4TXMerPuwXBrkwcHL9aBMcyJG+q2EiGFejRkHjIOc07lF/vkVX6MCY3on+FtTx+kdEpMVgoYvgbsGIvMUo2hKvGFxmJeOlIdEJl8BOlBvXic2xJbCkAJmhkIHtycwHGFYEg+cbbQZjLYUe4UE7krcuHFaCSdZylcNmZWRe609p8xw3sF4Z7rGqayfY0a01Z+d5M7U0dvZZdbtCGKAET8Tw5KPVpkp80sKdT1dm+xyI/zFfRiVmqZpR+oLO6krXqvIXpRicbfKK4HYuFxRPC8BzrwkBurPUkdMMON6sdVhPIfHu+cRJ8cewYkImYEq8EY3+GpZwPDSEOSqOf7lmca6jp6Ds5iLdDjoIITmf7PATDRGqEr0xH1b58gi4WBPBYtY6/T0GAqo4+yy4re65F2ol12P/pEWSkaQxvInYgtPPf1F2+lOlCjfkcpg1biKRb1Wf2Gomn9ahT5p+WXvx20XFGT7OEl9+lnYAlEKB6TMHvhkRwcZzX6I+aMBHtmJofRKo32NFC7taN8Gi/mU8uyCpuHFmR/9vVL7kJyq8qe/nDxbYXuOr7VMAnGx7JlnLTnzkbiQDcl4XsWtgVQ4r+kE1InSxjsNXnMPrjNCUSsPg0dldcI4IHaLAQ5Z76J0jrxjWpT8o+lH7M3URQPGCDnxrXKDHX1pec1+5nuVoIrW/Ex5OkOG2vyOYHTNboFfFzYsZVdMlEI7BhScGm7pnw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(336012)(7636003)(2616005)(2906002)(478600001)(26005)(316002)(40480700001)(107886003)(356005)(83380400001)(8936002)(5660300002)(40460700003)(82310400005)(8676002)(426003)(54906003)(4326008)(47076005)(82740400003)(36756003)(6666004)(16526019)(41300700001)(110136005)(86362001)(70586007)(70206006)(186003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:34.4445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e343ac4c-1962-4635-536b-08daffbf1eb5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6492
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to generate IGMPv3 and MLDv2 packets on the fly, the
functions that generate these packets need to be able to generate
packets for different groups and different sources. Generating MLDv2
packets further needs the source address of the packet for purposes of
checksum calculation. Add the necessary parameters, and generate the
payload accordingly by dispatching to helpers added in the previous
patches.

Adjust the sole client, bridge_mdb.sh, as well.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mdb.sh    |  9 ++---
 tools/testing/selftests/net/forwarding/lib.sh | 36 +++++++++++++------
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index 4e16677f02ba..b48867d8cadf 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -1029,7 +1029,7 @@ ctrl_igmpv3_is_in_test()
 
 	# IS_IN ( 192.0.2.2 )
 	$MZ $h1.10 -c 1 -A 192.0.2.1 -B 239.1.1.1 \
-		-t ip proto=2,p=$(igmpv3_is_in_get) -q
+		-t ip proto=2,p=$(igmpv3_is_in_get 239.1.1.1 192.0.2.2) -q
 
 	bridge -d mdb show dev br0 vid 10 | grep 239.1.1.1 | grep -q 192.0.2.2
 	check_fail $? "Permanent entry affected by IGMP packet"
@@ -1042,7 +1042,7 @@ ctrl_igmpv3_is_in_test()
 
 	# IS_IN ( 192.0.2.2 )
 	$MZ $h1.10 -c 1 -A 192.0.2.1 -B 239.1.1.1 \
-		-t ip proto=2,p=$(igmpv3_is_in_get) -q
+		-t ip proto=2,p=$(igmpv3_is_in_get 239.1.1.1 192.0.2.2) -q
 
 	bridge -d mdb show dev br0 vid 10 | grep 239.1.1.1 | grep -v "src" | \
 		grep -q 192.0.2.2
@@ -1067,8 +1067,9 @@ ctrl_mldv2_is_in_test()
 		filter_mode include source_list 2001:db8:1::1
 
 	# IS_IN ( 2001:db8:1::2 )
+	local p=$(mldv2_is_in_get fe80::1 ff0e::1 2001:db8:1::2)
 	$MZ -6 $h1.10 -c 1 -A fe80::1 -B ff0e::1 \
-		-t ip hop=1,next=0,p=$(mldv2_is_in_get) -q
+		-t ip hop=1,next=0,p="$p" -q
 
 	bridge -d mdb show dev br0 vid 10 | grep ff0e::1 | \
 		grep -q 2001:db8:1::2
@@ -1082,7 +1083,7 @@ ctrl_mldv2_is_in_test()
 
 	# IS_IN ( 2001:db8:1::2 )
 	$MZ -6 $h1.10 -c 1 -A fe80::1 -B ff0e::1 \
-		-t ip hop=1,next=0,p=$(mldv2_is_in_get) -q
+		-t ip hop=1,next=0,p="$p" -q
 
 	bridge -d mdb show dev br0 vid 10 | grep ff0e::1 | grep -v "src" | \
 		grep -q 2001:db8:1::2
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 1c5ca7552881..60d4408610b1 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1788,26 +1788,35 @@ payload_template_nbytes()
 
 igmpv3_is_in_get()
 {
+	local GRP=$1; shift
+	local IP=$1; shift
+
 	local igmpv3
 
+	# IS_IN ( $IP )
 	igmpv3=$(:
 		)"22:"$(			: Type - Membership Report
 		)"00:"$(			: Reserved
-		)"2a:f8:"$(			: Checksum
+		)"CHECKSUM:"$(			: Checksum
 		)"00:00:"$(			: Reserved
 		)"00:01:"$(			: Number of Group Records
 		)"01:"$(			: Record Type - IS_IN
 		)"00:"$(			: Aux Data Len
 		)"00:01:"$(			: Number of Sources
-		)"ef:01:01:01:"$(		: Multicast Address - 239.1.1.1
-		)"c0:00:02:02"$(		: Source Address - 192.0.2.2
+		)"$(ipv4_to_bytes $GRP):"$(	: Multicast Address
+		)"$(ipv4_to_bytes $IP)"$(	: Source Address
 		)
+	local checksum=$(payload_template_calc_checksum "$igmpv3")
 
-	echo $igmpv3
+	payload_template_expand_checksum "$igmpv3" $checksum
 }
 
 mldv2_is_in_get()
 {
+	local SIP=$1; shift
+	local GRP=$1; shift
+	local IP=$1; shift
+
 	local hbh
 	local icmpv6
 
@@ -1820,17 +1829,24 @@ mldv2_is_in_get()
 	icmpv6=$(:
 		)"8f:"$(			: Type - MLDv2 Report
 		)"00:"$(			: Code
-		)"45:39:"$(			: Checksum
+		)"CHECKSUM:"$(			: Checksum
 		)"00:00:"$(			: Reserved
 		)"00:01:"$(			: Number of Group Records
 		)"01:"$(			: Record Type - IS_IN
 		)"00:"$(			: Aux Data Len
 		)"00:01:"$(			: Number of Sources
-		)"ff:0e:00:00:00:00:00:00:"$(	: Multicast address - ff0e::1
-		)"00:00:00:00:00:00:00:01:"$(	:
-		)"20:01:0d:b8:00:01:00:00:"$(	: Source Address - 2001:db8:1::2
-		)"00:00:00:00:00:00:00:02:"$(	:
+		)"$(ipv6_to_bytes $GRP):"$(	: Multicast address
+		)"$(ipv6_to_bytes $IP):"$(	: Source Address
 		)
 
-	echo ${hbh}${icmpv6}
+	local len=$(u16_to_bytes $(payload_template_nbytes $icmpv6))
+	local sudohdr=$(:
+		)"$(ipv6_to_bytes $SIP):"$(	: SIP
+		)"$(ipv6_to_bytes $GRP):"$(	: DIP is multicast address
+	        )"${len}:"$(			: Upper-layer length
+	        )"00:3a:"$(			: Zero and next-header
+	        )
+	local checksum=$(payload_template_calc_checksum ${sudohdr}${icmpv6})
+
+	payload_template_expand_checksum "$hbh$icmpv6" $checksum
 }
-- 
2.39.0

