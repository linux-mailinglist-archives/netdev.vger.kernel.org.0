Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5516885EF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjBBSCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbjBBSBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:01:34 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E86077530
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:01:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaFZvd8/iTPOVjoNwtNl7CguC6qp2HTFq2A4QkNTj/R+DKAjiHNFr0+H2MjZSMYMmLv99/HsR/Tkm8yH2Cft91uhRNUTbAtiXLItBLrERBnJu6E4J+ArS5qerz5SxpV7p92mGseAB7FYKkriI4frmDun9NsJzgoqtgaiviRkqp8Gd1bBhG6hkPrsqS3XhnMTD56sKgMxn+RKvMz+2Q+3ICS7HFCQmAHA9K6emX7lfd1gP4DFZrZeYvnvNJnp5WicDXHkIC4VwBW1AV1s7ZrNx1FxXL+v8RsEK/oFUNSP/Cq7eFWJtHzXVhTdNahtHZER4YSEDrne1ZkzCqBxtibBnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KaO7FyK2OwQD4JbLKs6GXiMXyTVLodrTsmyEdNFE22g=;
 b=jZjUp3A7R7h9qec2ntCagB/s8KLgtI1LJ0lyqTquqqhY2JkNubSdxrrtHbUwkF/qAILVNvB8Ca5jJZTbPQR42qT114PewqZl/aqT7/oFnfsgl8YMSOVPTh7daj9/PwpOVt9Dwr6B/nXPl5CXo3gjVBlKYwspADfqkgLy0J8tEU1UfgS4ugkTZCPhzK8Fsl9tH6dNA2JJZaBZVejHICBxfuufc4qYhYbVwptFcuvTqgIUbo26CPI6nAwVlkVOMuNGM6fe5Wshqs3ZpBthZrddsZrezzWCMn2ofh9IuVKZ7ZRPaAb/ql7YEUxDWxawTHJxEMxaR7FVQ0UMqbIVlvnB0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaO7FyK2OwQD4JbLKs6GXiMXyTVLodrTsmyEdNFE22g=;
 b=GW1sOJTLe5zhFRfeqMiOpDjw3xyOuCHdxtWRbIIVRc82onluyYeK823V0tzQ3B9yq0A0DSK0Dq0VYIvmGv0WPzNmada9tCUynDeFCFyd/dgcBQHngAc0z60BLTy8s2spfdueurUNesSweYV7h4Me7W7uKJwh89PpVLP5NnfXG2484nyMfsedlSN4J1oWop7sfNTA2fETihWl26OC0Lqg1tzK8BsscjayWdyoSsqx+35BiF5g83ftP9UXIpyXLgCJ45KmlrsuzgLWxckYJvrfy3VsdaHht+TOh6GNZZNEsb1tcEYYwxRcCw9Ot2L1NuR6jCIXQ2kaqdJ6hwWopCy9gQ==
Received: from MW4PR03CA0273.namprd03.prod.outlook.com (2603:10b6:303:b5::8)
 by PH7PR12MB5878.namprd12.prod.outlook.com (2603:10b6:510:1d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 18:01:13 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::61) by MW4PR03CA0273.outlook.office365.com
 (2603:10b6:303:b5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 18:01:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 18:01:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:56 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:54 -0800
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
Subject: [PATCH net-next v3 15/16] selftests: forwarding: lib: Add helpers to build IGMP/MLD leave packets
Date:   Thu, 2 Feb 2023 18:59:33 +0100
Message-ID: <76cdd85502b18f3e1a2654ae0c91911db95cc795.1675359453.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT037:EE_|PH7PR12MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: 31f215ce-8a6e-4a97-bc84-08db054778a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtsNSFRCfgq3H0mOZw4R/UvhbcSkTp7IXqymcO2n03i4KcHKiO61PGOZBVIQMjPR5mSSF6ZK7X/EFKiBJN6tR48MWm4Xc4j32YbbuDcDMjfEFQxWJ32SWU3FYDN3Q9aJMTrpdD7cp6gf+hJY7Xbu9MHhvF/aivObXMm/7CgkEM+xefk/ni9OibIGWLDnFIzxagpKS8br3/Cb/rR3t5i/Wx6xUJGV25ukOixEBKuaqq7pIKJbmV2VPUifQX/eaqT6l0ULxsGVVfSCTgQteBGUm1Ox3/AGexLUc7RLrWPCUwW4RgsOoL/fxZJQpKm9OYQeDcXrnOQ5V9RZZJSxMdwOm4aYjzo6iduSqH+Nm4OESYMjADehgj2onMQ9LqkytyBEWh/czkTP57flCGEunCbPljYU0kdQTg24FbeJrjzn9ZNyWftQKer4LQ0fOzSqB9BgYFG1nEAIIN06HcLVwS6+W4E8fNpryoA9wn2p7uD+jJSJzpp5HB29OAjoQRBFsttsy/L1VoYza8mzaxIA3LkDzCgvjvn/R1IRXqjvAaicbPoYL7KWJxWWQq2yMYine0Redhr/ZG3Qlyvpi6ZOd4UIuoTA4Q0lIeBMT2UT7EhiT7EwabfitaQ4yD4OSo1nPXkOBSPxw7GQnT+YEzBmQ4p1prW7WxfK4nbojnTqZW2nS3rZGyP4KsVH3pCPSxCJkixqa/BC+v7NYxDSYprqM+p8Yg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199018)(40470700004)(36840700001)(46966006)(36756003)(47076005)(70586007)(70206006)(36860700001)(82310400005)(8676002)(4326008)(54906003)(110136005)(7636003)(316002)(82740400003)(26005)(16526019)(478600001)(107886003)(186003)(40460700003)(6666004)(5660300002)(86362001)(41300700001)(426003)(40480700001)(356005)(2616005)(336012)(8936002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:01:12.6570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f215ce-8a6e-4a97-bc84-08db054778a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5878
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The testsuite that checks for mcast_max_groups functionality will need to
wipe the added groups as well. Add helpers to build an IGMP or MLD packets
announcing that host is leaving a given group.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 12ef34ebcbbf..969e570f609e 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1815,6 +1815,21 @@ igmpv3_is_in_get()
 	payload_template_expand_checksum "$igmpv3" $checksum
 }
 
+igmpv2_leave_get()
+{
+	local GRP=$1; shift
+
+	local payload=$(:
+		)"17:"$(			: Type - Leave Group
+		)"00:"$(			: Max Resp Time - not meaningful
+		)"CHECKSUM:"$(			: Checksum
+		)"$(ipv4_to_bytes $GRP)"$(	: Group Address
+		)
+	local checksum=$(payload_template_calc_checksum "$payload")
+
+	payload_template_expand_checksum "$payload" $checksum
+}
+
 mldv2_is_in_get()
 {
 	local SIP=$1; shift
@@ -1858,3 +1873,38 @@ mldv2_is_in_get()
 
 	payload_template_expand_checksum "$hbh$icmpv6" $checksum
 }
+
+mldv1_done_get()
+{
+	local SIP=$1; shift
+	local GRP=$1; shift
+
+	local hbh
+	local icmpv6
+
+	hbh=$(:
+		)"3a:"$(			: Next Header - ICMPv6
+		)"00:"$(			: Hdr Ext Len
+		)"00:00:00:00:00:00:"$(		: Options and Padding
+		)
+
+	icmpv6=$(:
+		)"84:"$(			: Type - MLDv1 Done
+		)"00:"$(			: Code
+		)"CHECKSUM:"$(			: Checksum
+		)"00:00:"$(			: Max Resp Delay - not meaningful
+		)"00:00:"$(			: Reserved
+		)"$(ipv6_to_bytes $GRP):"$(	: Multicast address
+		)
+
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
+}
-- 
2.39.0

