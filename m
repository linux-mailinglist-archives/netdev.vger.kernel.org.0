Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F3167D278
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbjAZRDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjAZRDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:03:15 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9B359EE
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftIMcpezXInBcrag/HHDZ5WsoHe04OUCpP7okyme+ZyYLGYW7vuzaWMueEQD+/loH5Xvh2yam6x0rkJxQ9skk0htsI/wpAF2KJtcgWvg16XTpybg+W/EuXQm3Jxh7ERYRSA0mXEyVEXS7wEBIImsu0QsXMiocMiLp+6jcfKc1av769U3E58BsU0Yc8F51O1i3C905cynENQIkMQ3Bwsd7DuPTMA+empTD+G7VJoD27oI9BiGfrr8a5af7TvcDxhS9FQ4qKRpkye7B2eY2+DY8SU70rh6pruVmDVlVbIqUjVR6p4wjIzWMIiZU+5onL7VpzMhkEkE9UOhnjoukKOnMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUwSAxqK0eM3W4uBtqEOHEP6IedxRqbi8j6e6ANq23A=;
 b=FjqHx2dHgzsjHFmZSnzWcCZBFcz0+XiVx3KHMzI0fY3QmhZEUhTv45WcqeyNHWkfGiNeAIcnvTWZpPw6j4hyM698vST3GseXLGQxq64vt41NJ1p5f1wi7ifGYwIZHibPNrtsfufW+wHsswOBLLG9mEF2RE0Pz3R7T9zU2QuTKNM/c8/ep+gfwJWaZ7kiDrn4HQlJzLZhX1W8t1Frf/2d6iYz0Jr+fWBfIAhtsPGaBpg67uVTExXBOG2D7N8vJkZgr5qaLH0BAeHHUvWuNcXrHnEirYFt8OUo/O6h1lMAxbcaz72f5y0Dr8Cjhj+ksIjrmKPTdqBT4TNanosOoM9pAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUwSAxqK0eM3W4uBtqEOHEP6IedxRqbi8j6e6ANq23A=;
 b=Hwsi0TMxeo+9OpsIbZ0Sf0jX49LUJgtEf+nKwHMfkDoF+BuQTyzzj2+j1NtaTSWqEnp4DHpLmAebGAdj5RJWTwJ5KMKSVpjCZ8DkZqTzJ2BSTDF60SZbfhpqwJj2tO0LAI9o5FNRG5gRC8TLBNzuJSD0yp1CAfT9t9s6Mw4kyLzw2I6skQ/QTUIwq/gU+MpyPALmN1ppJoCvdl7nIqW3jrSJ97QGG3E+ZZp6JVh/4Rh92Kl1YWekyjAb7ZXMxYqnWZUxe08Urud8njbOn3QnH/x4iaTXuavqCBbuS+jxOgPwWvwKwTJDSWeVItlybEH2ZfD1iSWgKM2cadXKitXmQQ==
Received: from MW3PR06CA0009.namprd06.prod.outlook.com (2603:10b6:303:2a::14)
 by SN7PR12MB7785.namprd12.prod.outlook.com (2603:10b6:806:346::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 17:02:44 +0000
Received: from CO1NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::5a) by MW3PR06CA0009.outlook.office365.com
 (2603:10b6:303:2a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT109.mail.protection.outlook.com (10.13.174.176) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Thu, 26 Jan 2023 17:02:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:31 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:29 -0800
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
Subject: [PATCH net-next 15/16] selftests: forwarding: lib: Add helpers to build IGMP/MLD leave packets
Date:   Thu, 26 Jan 2023 18:01:23 +0100
Message-ID: <ade8275e8b812248effbfe5249d0116763340b3d.1674752051.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT109:EE_|SN7PR12MB7785:EE_
X-MS-Office365-Filtering-Correlation-Id: 54aec6a8-5766-4b26-f015-08daffbf2418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +JnPRK1R3ydDzV0EkCDu4Hf/+wwBbARkPLvoKIS0CZk2co6A/eZgBF+0PP3+zlHd7kzRW3Ukh/Q64H9lF39uxPkRut5jO0fuKRZYPBX1JGCxRUNy/lEUh86Zyw4rYoCdULkNLiAGwtCAdg2IfCGQSxNZklmMlqxyGYf4YdPe8q/u19PSeueumCHow4A3q9Iwm1kc4u28Fe0LC4zlf0R2rgqUtGUewImK0KYNlLfLOh3czN5Fw2ddA+J8IGney2Jce1xdWXu2q5UJZaj8/gDgShWHksGpRPYQ8ejQZ8Mvkkun3cbcZ94jAdwChWuLtrlbQBm8w+yUQfM0kYu23XB6zOtOOsGTEivIKs61DSebHDBgJ64oAlvTRa0YdN1TLF1TP6HnsYnFPAbiF7F85p91guj+29Am8Oysr6FH2SkV14qLEdAfLZ+gikwtSuyWV4RXDXNEUu4EG2MmmkkYpdE5kMDPrb9q31hI6n6RfS35Pbb00r7anfQPAeYAyWpimtxFXwF79/LichkaQfmij4veVK+D49jHhGQPtwUbq/w4ZXZtog57v2Od9vjFZkFS2s+8YKOMWerFdqXAEPS9SSoMyfKHI/HhI0EiqcxrBZcwnpYxqiQYjBXnOJnw35W4xra8Q0aFvRW920Fdn2hNyhMxTd3Yu0yaMS0KwcayOl21HM0dwC5WHHQ7yh+rv8W9PdofUju3iK667U2Ov0MLh6F6vg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199018)(46966006)(40470700004)(36840700001)(7636003)(356005)(40480700001)(82740400003)(40460700003)(6666004)(86362001)(186003)(4326008)(36860700001)(8936002)(107886003)(41300700001)(2906002)(5660300002)(16526019)(2616005)(478600001)(26005)(8676002)(70586007)(36756003)(54906003)(82310400005)(110136005)(316002)(47076005)(70206006)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:43.4547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54aec6a8-5766-4b26-f015-08daffbf2418
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7785
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
---
 tools/testing/selftests/net/forwarding/lib.sh | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 9f180af2cd81..7b3e89a15ccb 100755
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

