Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455A86885ED
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjBBSBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjBBSBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:01:25 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC5F783FA
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:01:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILXhzOWPq0Q9bifr1ZPASR8eWwCdOzoKmNg06phVTzAjEvu9lbNMwL3QsH1x7M6r754iHyQjnH51iG77WJ3vYVqGk00OAo6aidy0xNiJb/TeaPA/9jb1x3S1IyuXKHBsH6XkZQ/ZBLw058YCeh+M+c7yhUK9VyEb/F7promXe+5Og2KcXupPNWCY1jSAGqXZ6TEUa0Otjb9U4DxgzwJij8xZN4EXTmTqcoT/xNFiqwPSL0GXsvyAJh7RqUF19WC9fTWmGfQ0AfVLOiff4v6nFdWAzRaY8gmLC6nXTGi6qskg91WLXAYoqqgSKhel9FBi9DnqwCgzA3JBVSYGkOW85A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2KPOZFGk/zrNvDKWjS9GWoOFl0RKsEaYgKClwwmvO0=;
 b=SfVXmreorWRrf6gEzJMsNO9Gl85eFyAsxRO262Rt7fhQeU3D4+uXQCHlvjb+Jx+FfCDN0zOoGKyp8xUHdzPBDTlalJzDYtHd87VtA5ERJKX0Xe9rEKXE+384jieVq+nT17rRs7swmyBDJkhZ5GKgIcakn3gc1oU/k9443kkV7nJXpjHM+ohX73CKpxFEHuibqBEvsc2mLZds8SfJ6O5Tod1FeWnikcJCk89oZum6TC6dleLPkVl/CKF9mH5+m1PNtxSwVtMMdSLPNmtNHBEL8Wa4QkYmqEogHQZQIsVsTfBC8u+hPv6w1VtTqPHz7XmpR43ejwcQKJBq/+a1dcMwgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2KPOZFGk/zrNvDKWjS9GWoOFl0RKsEaYgKClwwmvO0=;
 b=g0AGKDIg2NK8HcP8Upxc+2jCqNKirRh3v634nXl0/sn73bXeEWbco0BZ/+u2jV7Pe4JQepwTvqw1E8u2Ww/DQlVGEKYqj9FgrLszdWGkt0BuDDW14FVpZ2bWTxYXoES4wuixKSsw34IZUlW7wHO0/k8CyA3bn5iADIb/9V2zeUR94gRswNUl5XvT77eXEXyL4EXvxJiF8DZJs4sh9u5SBxtKBj44g/2mfWwg/r2h/pWA3kiaW228l535A31qaG59ceCs3cHaGG5P0J3Lu3XuVbe+Jq9Zv2FgGV2BaofZXRPfaO7oq4opXj/T+NwfSv6l67C5zFOFCIQQYISXgW4XlQ==
Received: from MW3PR05CA0012.namprd05.prod.outlook.com (2603:10b6:303:2b::17)
 by DM4PR12MB7646.namprd12.prod.outlook.com (2603:10b6:8:106::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 18:01:05 +0000
Received: from CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::8f) by MW3PR05CA0012.outlook.office365.com
 (2603:10b6:303:2b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 18:01:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT096.mail.protection.outlook.com (10.13.175.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 18:01:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:53 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:51 -0800
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
Subject: [PATCH net-next v3 14/16] selftests: forwarding: lib: Allow list of IPs for IGMPv3/MLDv2
Date:   Thu, 2 Feb 2023 18:59:32 +0100
Message-ID: <b3d661f92cbc2bc7cf51b12fef39d04172e05f3b.1675359453.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675359453.git.petrm@nvidia.com>
References: <cover.1675359453.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT096:EE_|DM4PR12MB7646:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b977d3e-c57a-4fc4-b9da-08db05477460
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4l0mXw8sOCvHE74hFhq0NzxpeTuZbRYLgFvxut0ujZrUK1xz47gI3gfYQaIOhlGHAgAeUJfCTkqKEE8cQdttU+Bg1pJn9Lw4xHOvgJdgqwkZZH4Re1wJODNd6dc0ccmy2g7zPgbVHlmn11RqdY7q7E/AwmX+lFWMhX9ksNkPs9VfjDCA0iWvMmW2Oo+xw9FYcxPXF66izaMOCRtQ4hsreEjPSUbMeN93dDuL0qwu3oXsxvkLdBon/QLZtpem8oWDcBb8rXBTV82YuKr/Bsr4yBgc+2mP9KqHNis/z4VTQsKwoiDhCM1J5nP9EmNv2hSIYaWba7k51Z1flybGHDyxSNpQy1KHrCm+ZcJ50gywDSFLaGi1+Hlea9dlpoXl/oHu7TEa9K1FHiPwNCVcjidBXBiM3iRZD1rsJIRKzUt0oVdyqtdjZUOmTk171SBNQ83KubQsWzxGkZvHo6ulLp8YH8Q/bjANwi9+a9OW0rBmzlmLBZQfk7C3gpLuH/gri8DrbxPoFxhATvCrnv3+BziiG8AhJXaWFd0e15HFA3NVBWcYqgXb76vkj+mP6iLRsbo+SOewur0zxG1AY0BFCZuu9pziQXok57kOxSoPWKqfnrRTxKtLHegHXiDQUvGlZKoq17oiG7us5EPhXtY20mm+N6xQKTOKRqvaj7OoaL6K0q87W9IAXCTxpmr4rdsjo/hF6oYyVCoD76BU0dv+cXEeg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(46966006)(40470700004)(36840700001)(5660300002)(41300700001)(8936002)(478600001)(36860700001)(4326008)(47076005)(70586007)(70206006)(8676002)(83380400001)(36756003)(6666004)(336012)(16526019)(186003)(110136005)(2616005)(26005)(2906002)(7636003)(82740400003)(40460700003)(86362001)(356005)(316002)(107886003)(54906003)(40480700001)(426003)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:01:05.5432
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b977d3e-c57a-4fc4-b9da-08db05477460
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7646
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

