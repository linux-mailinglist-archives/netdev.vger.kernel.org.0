Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB11067D277
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbjAZRDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjAZRDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:03:09 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E485A38EAC
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eC1YOeE9Ohg1OpTptxFTQLXKBbWBTy5KoVvJEy1KmolLfKU0UJEMiGwCaJXM3Vmt3i7QN7lIXOzIJZG7EB0kSXyJ4D/aceBChilKH3+F924WjKmyYhERrUZlQMHWJVkDiYBnHHq/86MzRmdwyrVN27vqG/rdAVQAYsi1b7XrnY5t5p4kivnSCZVIN4Dt/gon1oxrzeAva3W4UWnHRiATCmVySMo6TVQ3PXZG/MLueYvNmS6MRol5TsN/GFkUdLdTH3G2r6IX2kc7AqOaiFWDC6uEzEiHpcaAVUEPIVUyMknHbZivMUK+bCnFFE0Ing0ZoBVDiqNpIzsPTwANYl6Gjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JH5QzD2pa+HeCRuyKubDpPiQOpuUdGkpou/6cpw5NSQ=;
 b=mSz2+DoIm4rccyojTC0QuWyuEYgUY6175fNnyq+nC/kcAB5KFvD5L0KbLdCD/ERu/PbvpfFaLryGX7q7DhbkW5ym8QHZzYwsGXosNbi7mtvjp0FIF0pvYLLJZbNmAjJgOhIcbpo7Di6jKkhiWcR3sBcyR8gGcBagTzxRdu4a6QOuDQgleEvVqMan+TlYhiBx4QRhf/5Ri/Z/9QagnqBG/YHLhaHfhG80t20eTcYktnjSORJm3pM7UeKO6KFuBy7em0dUnXp+EVm3F6xdFPeqt4eOsAMFEQUyuF/n+T9AJTYgGJX/WqMUAB8Xw/STMSfuBLXpg52gtEN0TAVq2OaQZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JH5QzD2pa+HeCRuyKubDpPiQOpuUdGkpou/6cpw5NSQ=;
 b=JGXQD0/uwFybeNElnR/mJxvS+D3ZpoYpQpF0qAYCI0CnFSt3ZV8/lhYNnhBZDmTUBJWrh+0dDShFtaUyChwzNGvBZjqNc3AnpDww4W5NSz5zuRtJ+JkoNZnIHEshn7yMCAY/aB8kD5lcsTHEHo/FOHdnFzsLZhJJ7i+ccuM7aolByjN0adgMhsxnMUz1JDDbSKiNXkkki417AnA+ufMyRIT3bUldQlOuZIAkuQuoYihF0RIcBaWllcPxTC+otVGKBgL20lMEEeHMw3nDIDPQXR64d3e+W145z7p1i1GpDuqGJtMjZZgQRXrnD0WBFfh3Pg4SDpLRPWvTg7zqlEgzmA==
Received: from MW3PR06CA0007.namprd06.prod.outlook.com (2603:10b6:303:2a::12)
 by BY5PR12MB4081.namprd12.prod.outlook.com (2603:10b6:a03:20e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 17:02:39 +0000
Received: from CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::4f) by MW3PR06CA0007.outlook.office365.com
 (2603:10b6:303:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT078.mail.protection.outlook.com (10.13.175.177) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Thu, 26 Jan 2023 17:02:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:29 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:26 -0800
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
Subject: [PATCH net-next 14/16] selftests: forwarding: lib: Allow list of IPs for IGMPv3/MLDv2
Date:   Thu, 26 Jan 2023 18:01:22 +0100
Message-ID: <273051ca0cae7bcd2957e44803fed128efc80336.1674752051.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT078:EE_|BY5PR12MB4081:EE_
X-MS-Office365-Filtering-Correlation-Id: c60e4ded-ebcd-40c3-8316-08daffbf2142
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DkI1yNEIna/ekqPR4H7YVN1ZKoihjHIjA5rAgplYgHXux15A1X9lkhGyMLSMKeNIwWPicgZxbeCIE8+1s5f19+ghQfb7Q1QZgOXN6rN25XkclI4rq0l0md75jJFFy6bUSMFJjQm4C8rwg69SagwVZ+g4iWM5BmUpJuG9ire3KH99cVTNC9KHoZkXBqYLg28ZQhMh/F2zOhq/mqzk5xlKhuwRYQVicElDGaafYmOQrA1SSO/EuPjjGliNvbBFpMtr0FBGgHm//Fi4Tonv0mC+Jui8KJiaNb43aWJsDZDa7LeVetbJjKpZ4d4hsfSssucXCr3xw5NyHgCzrsX6C5ZMDewg2pgyTjzmaCYQ4prjrq1+5zz17x7cMvq3JttVIzwV9JMiEu+6WpIsXyw+tj2rWLhJ53NBzip4z+WzqmfF7Az6gkMv/f25UjFLq0uBW+TZBLJEVknUhpmIR1mUWj80SyGz7ljtuxNtwEzb0IaL7hRvE0Vsa35/twchZxVwS2gxdRDXT5TQetkeuSzS3luPdK86/ID/wcIBGOF3VzkkfxAoiaP158FE4zKNA2rYQhV6EWGBGJOC7dIXq57W9lvAS7c7SFkH5cmt5aBvfB2TETpuJPB6nFCQVX4DizVV/kjo7T/ZRFpHxBnSpBoz4vpwb4NLXUacwNAJsQfJmUeTtZ4=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199018)(46966006)(36840700001)(36756003)(70586007)(54906003)(110136005)(316002)(8676002)(4326008)(41300700001)(8936002)(70206006)(36860700001)(356005)(86362001)(82740400003)(7636003)(107886003)(6666004)(16526019)(26005)(186003)(40480700001)(5660300002)(426003)(83380400001)(336012)(2906002)(82310400005)(47076005)(478600001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:38.7096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c60e4ded-ebcd-40c3-8316-08daffbf2142
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4081
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The testsuite that checks for mcast_max_groups functionality will need
to generate IGMP and MLD packets with configurable number of (S,G)
addresses. To that end, further extend igmpv3_is_in_get() and
mldv2_is_in_get() to allow a list of IP addresses instead of one
address.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 22 +++++++++++++------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 60d4408610b1..9f180af2cd81 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1789,11 +1789,12 @@ payload_template_nbytes()
 igmpv3_is_in_get()
 {
 	local GRP=$1; shift
-	local IP=$1; shift
+	local sources=("$@")
 
 	local igmpv3
+	local nsources=$(u16_to_bytes ${#sources[@]})
 
-	# IS_IN ( $IP )
+	# IS_IN ( $sources )
 	igmpv3=$(:
 		)"22:"$(			: Type - Membership Report
 		)"00:"$(			: Reserved
@@ -1802,9 +1803,12 @@ igmpv3_is_in_get()
 		)"00:01:"$(			: Number of Group Records
 		)"01:"$(			: Record Type - IS_IN
 		)"00:"$(			: Aux Data Len
-		)"00:01:"$(			: Number of Sources
+		)"${nsources}:"$(		: Number of Sources
 		)"$(ipv4_to_bytes $GRP):"$(	: Multicast Address
-		)"$(ipv4_to_bytes $IP)"$(	: Source Address
+		)"$(for src in "${sources[@]}"; do
+			ipv4_to_bytes $src
+			echo -n :
+		    done)"$(			: Source Addresses
 		)
 	local checksum=$(payload_template_calc_checksum "$igmpv3")
 
@@ -1815,10 +1819,11 @@ mldv2_is_in_get()
 {
 	local SIP=$1; shift
 	local GRP=$1; shift
-	local IP=$1; shift
+	local sources=("$@")
 
 	local hbh
 	local icmpv6
+	local nsources=$(u16_to_bytes ${#sources[@]})
 
 	hbh=$(:
 		)"3a:"$(			: Next Header - ICMPv6
@@ -1834,9 +1839,12 @@ mldv2_is_in_get()
 		)"00:01:"$(			: Number of Group Records
 		)"01:"$(			: Record Type - IS_IN
 		)"00:"$(			: Aux Data Len
-		)"00:01:"$(			: Number of Sources
+		)"${nsources}:"$(		: Number of Sources
 		)"$(ipv6_to_bytes $GRP):"$(	: Multicast address
-		)"$(ipv6_to_bytes $IP):"$(	: Source Address
+		)"$(for src in "${sources[@]}"; do
+			ipv6_to_bytes $src
+			echo -n :
+		    done)"$(			: Source Addresses
 		)
 
 	local len=$(u16_to_bytes $(payload_template_nbytes $icmpv6))
-- 
2.39.0

