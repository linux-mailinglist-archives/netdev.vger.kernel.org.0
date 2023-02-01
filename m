Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27468686D00
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjBARaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjBARaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:30:20 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B0079200
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:30:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7dmr+16T36xdxbpsfIjTfokEUYniW4nj3sZiExi7RoIwiWhohx11/nAva2cXJNVB+xCBP9Y1ZOuH/3BbWwbzaop7fDwBJ9QPxhnPa+cyupoyqiuD+lpBlD72u83opl62OjmDfmyGdofl1Ag/8GMlf87LbCHd7YdKm03w4lWBf6bEqPvW3BuBH353XQ50o83StiKzZ32oeQR0yZ4FQ4DBKieOM/RzJZEEYwLtQ0DRIXHQLZaCWjQi2DMOLZ9BjS4jMvFlJz4J3ZcoqS/H9/fmwLGi8MXYqPonXoFepwNgkuRhlAP/SGXCs9FSpdYiHwDd68TNvyRAnwKaylcW0CnIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcDKbM/vxLaY/qHxu8fO8whiyjxP3cz/iCe2KzrkEEo=;
 b=Nu9l6e6yQHb2UJbMpviuWvBYXANGnEsdUWzPGxtWF161aidFitr9FPJFm3Ztug6Mn6qymMtPGPvhNfl0fvYxtOJuYkM5cHrc4zP8y4qlZQM5FmrZGQP7rL/dpwoOSmWLpD2UVBFg2mZmTZcs+tjtiGd4qf2U8Dw7YlPpJx2x3K5+IeLoZasyYsRHsD+vgzTlyHJtG2tLm5jVs4HGS/5wOpTt6krQfrHAmuiMf2Otd83q7iCPLrra6jgzxFLnV7xBJPdsRaA9Fp//1VQIg1z6NkNqioNWHTIY0bsRz5U0LNryj2OovJZEuHMUsd4j1OPfqtSPmOjEOA/msKHDpjYeSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcDKbM/vxLaY/qHxu8fO8whiyjxP3cz/iCe2KzrkEEo=;
 b=IunugHtzdjqJ3Ywo5le2sttVRbC3bQWaiLe0hPS2EXZfIfVHoueIyT9eVOKvdc4fZefaml4cAPsfVCEgGQVU2vJj/0pF94J1EEcszvTQFGpjbG1rMgchnG5fW9ZhaWffjq9zHYnHutU5ZWfByNrJdyrNFZvU9ITR3egnTepgMWvUKUJMiURlv+pMhkZhTXG0PI/zSQJ6VfdScgptv6Okubmz2E6h1DJAviS1rhnV6Vr8Kd5qdSr2ZncDO7rQHnrtLEudWELMKgpIIrHmfJPbnSW7orOEa9j6cYksrO5dMYQ7FH/HfiDsdueXZxKQA76f/SOWct9lrC5cI9876bZIjA==
Received: from BN9PR03CA0478.namprd03.prod.outlook.com (2603:10b6:408:139::33)
 by DS7PR12MB5790.namprd12.prod.outlook.com (2603:10b6:8:75::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 17:29:58 +0000
Received: from BL02EPF000108E8.namprd05.prod.outlook.com
 (2603:10b6:408:139:cafe::4f) by BN9PR03CA0478.outlook.office365.com
 (2603:10b6:408:139::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Wed, 1 Feb 2023 17:29:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108E8.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17 via Frontend Transport; Wed, 1 Feb 2023 17:29:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:45 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:42 -0800
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
Subject: [PATCH net-next mlxsw v2 13/16] selftests: forwarding: lib: Parameterize IGMPv3/MLDv2 generation
Date:   Wed, 1 Feb 2023 18:28:46 +0100
Message-ID: <eaea04feeee8b203b03de93146e642818ced1e12.1675271084.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675271084.git.petrm@nvidia.com>
References: <cover.1675271084.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E8:EE_|DS7PR12MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 57bfc3b1-1be1-4bcc-c4e5-08db0479f0f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v27Ly92odS3nAIi3OpfIyHpZ6wApqRbJg46QKf6JXyocLnGWBS+oP3LMeWfCPjLmRSG/Z6yVyfV00SeKXK+apYQbzGlHtvkNHNT/M6EbcKp7iWVIn4luhpaLzoxeHeZEQPS2qaG1aRXAEwox/2z/Qnp3reMA65NH/lZK2z4K67ldF+tpwTt29EYPDyqtJvGkS43BcL0OwBP7FtbNhnijbWdJ894lZNuyN1w5p1c4olYqjvCiW/A253DoF1+bB7NW0hkHZGop9WV+HiezKonH1207+vToDbtShQXUB8Pc/g8Vw8XPMfQYoskGuxseHXEtQ4jIvlZtCI7UM5xJGJjecJxfeirUCDhL4jU9t/NrnzbdODgyuvhy0ZvUcBalOIj+nbRqKOOqSZ3zqg3FqUhevStenWW4bT9qFT83lv98d/NmKEdC2cJs5Vd1npU2lUpMs74ftxVONVNWpMbD14Ne5LijIB9zAmDF6+VNbzad7AcUMZpt23GItP+AqNXKLWi0/oP0hoaiWw0WSsRpb/PCtQ9VcJoS87IlFbfZLJYI9wfhF41/twfvSYgGb8FfKD1rL8iZ7T8Zdd6Zog2jYRVzqY4BXKa8lCEcLv0S71Ho2nZMtEOgAWiRU5q8M4bLsy8B8OQTxt7MyVtgD+MXJHHg0zAZezaa3CNiQ2J/Yf1GJIG2o/YMmfLI+h0SunnCkdb/r7M6dcY9xB4aOfKc/1lEHQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199018)(36840700001)(46966006)(40470700004)(2906002)(36756003)(82310400005)(336012)(83380400001)(426003)(54906003)(47076005)(107886003)(316002)(40460700003)(478600001)(16526019)(356005)(26005)(70206006)(70586007)(186003)(5660300002)(40480700001)(4326008)(8936002)(86362001)(8676002)(36860700001)(41300700001)(82740400003)(7636003)(110136005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:29:58.0996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57bfc3b1-1be1-4bcc-c4e5-08db0479f0f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5790
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
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
index b10c903d9abd..190e49e60508 100755
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

