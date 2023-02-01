Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F092686D02
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbjBARag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbjBARaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:30:20 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EA97642F
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:30:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xjg0N3UwF/wjMIVBuRmQZm7LcyhK7CgJY8CQWxVQdeu8iLlNd/FDRCD88sqpOeYv8G6x3YnO6lD+9INUmToSKc8x0LfaFw4+GD9VdixeMlI8NEsXRxnTN11ze1f7b6VF7qpOCX0vjVY7pOxTEECOvmsMxcMvUIoHXOVXfHiJZG3sSA6csiYDzxpbDtFTDs9U4TmbuBRalV9GpOPMgn+V7b+z3cMOMhTG0waDio1OqxscQGpoAtveYAVIEN0AsKj4fM6yUTLTqLj5BOVGmgB6cMqqN7dLWdRj0t3Dwa09X9ruLa4OtuMXO2f04OInOTdEXyPbMc9lzU3My7PZ80V8Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2KPOZFGk/zrNvDKWjS9GWoOFl0RKsEaYgKClwwmvO0=;
 b=bVELd+HcQ+UAqGOvRT2mCMzWSNTF7voeNUbnmUCjPPwM54u/xfRHPuJZym1Lp5ih2NwSp8j+nCQEmSZ3R4gCcWyD6cO/ZXGPnsi8sZ/PG65M8r14gqls9r1jHjuUvEGdlt91J70cC6fCI2yMQ/t/sqhwNUYTtSa3qof2YIJK06umuWUC7f3IVz9dIolP730haYNs5uIw+IPK+i/hGq7rWVkox07I+df9YL3Yi7Jdwy19doit1qmXfCkOyzpdcik7d2WJOLzVMo0m0uXHNb/AAHXi5Lw/NohTexzwLElx/zMS1eFC0MN+lAWNgq2kiHPtixNEyeJ5cOL72vhmmZp1eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2KPOZFGk/zrNvDKWjS9GWoOFl0RKsEaYgKClwwmvO0=;
 b=Vl7PACCF1iJBMTEJUtCA81blTwJkNwf0ZwtqBKNSE8fyvhOcghRABMy8MsvhMAIrygR+t5S516ovnhmNefhfYTcBwKhFLZ2SPf4CcefVS2C0Yu1PE7z1C23Sv5AIzAplg+TjATtdIgF0aJBApO31LAH9ryy5eCOaxpQ36YawX4GlP+VbmprxVe2vE9UQa76DuDwnMiTQNEWgyAVpbHA4nFtZt2Lg+Yqfw9JDDIYvVbcBuJmvrnvdoXBnhTQzl+zzXL3qwVdCrpbkWAa6JwcrxRMh5nv/a3twqyLEe08b5geFlLNGF65bOJe6q+NTVoW5fj8lrjERfYCoVU0NfDsGPg==
Received: from DM6PR13CA0010.namprd13.prod.outlook.com (2603:10b6:5:bc::23) by
 MW5PR12MB5651.namprd12.prod.outlook.com (2603:10b6:303:19f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Wed, 1 Feb
 2023 17:30:00 +0000
Received: from DS1PEPF0000E632.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::13) by DM6PR13CA0010.outlook.office365.com
 (2603:10b6:5:bc::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Wed, 1 Feb 2023 17:29:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E632.mail.protection.outlook.com (10.167.17.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Wed, 1 Feb 2023 17:29:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:48 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:45 -0800
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
Subject: [PATCH net-next mlxsw v2 14/16] selftests: forwarding: lib: Allow list of IPs for IGMPv3/MLDv2
Date:   Wed, 1 Feb 2023 18:28:47 +0100
Message-ID: <c23017aace3d1c5f7746f0a2a54c7bcb60851c85.1675271084.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E632:EE_|MW5PR12MB5651:EE_
X-MS-Office365-Filtering-Correlation-Id: 679780d0-c0b9-454b-c15c-08db0479f0e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BHh7heY6W6Nr2gDzaVXprJUD28NhhF1VmUXvRWZh0NxLU2mYSFEOZ/TqI0LwVgkopa2fzHW2JeEMrDJ6ur3wnqvahNiWZ+ZtkJHkQ2HqAlSMRk71wEEMelD6FSqTPJNBJ3cnGX9qUhADszsR7wVpg3kZ2Gj1JP9sZ7pSvR1WeWFNqmVnRpGWbjls68Cl5BhSMdUoeatZBhE+ltR150s0YgeUX4mrvPlXjTDwpZnU2Bl4p6DR4C96mu6KKxryQtQ8izGLRSnbKEHx+5vN9AMy0EnC6u37gkhQZKPnDKsW5NKDnD+M5U44xIoCFmRHYSmtY3HylUk6MjIBXsnbQTsDfmAhtdt+2Qm9HY3zDgfU3aH994BZR2PX9n+158oZlpHUY6sAfkp1XkK+9OJJVP5GCgaaV2dY6gmPhqQmMO8+0zqC0mNqSEWdoTr/HKaysoM1mltCYFd/ZS7Se2TUrl9d/mgxcu5fs545tDLmvVK0DXWVt2oVm8XjEhEqH8EgcLkiNb3alj7AB62MIyL1IwfkV6A7hFA391HOfr2gkn2Si5kd70VQv8vRW3oHii6Gp83z7faZIREOffbwmnq4yEgMXDTdC6ymibmDbrFS5b2u2yXj6WV6h3R21fJ1nUM8eMD7KsKSXJPZokdfoXZR0F/r7np0PpdSKlXyFmLHlTHb4vHE4kCp07tJ8XRhhmA8c3ntcJFhLIH1R5rMR21XUgvYhQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(36840700001)(46966006)(40470700004)(36756003)(336012)(107886003)(2906002)(110136005)(54906003)(86362001)(82310400005)(478600001)(356005)(2616005)(47076005)(426003)(8676002)(316002)(4326008)(40460700003)(70586007)(83380400001)(40480700001)(5660300002)(8936002)(16526019)(41300700001)(26005)(36860700001)(70206006)(82740400003)(186003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:29:58.0834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 679780d0-c0b9-454b-c15c-08db0479f0e8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E632.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5651
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 22 +++++++++++++------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 190e49e60508..12ef34ebcbbf 100755
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

