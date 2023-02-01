Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72F1686D03
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjBARau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjBARae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:30:34 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928BE7BBE9
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:30:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXmlOVeoODuCcjlO9OsBhvq9cNLIZlTbOIeGog3GWPSjGjHy96l0S9Qlnv92HKT4kYnqvjjCMt+HPv0035wGF0acfXTnmzOSTxSYLxSGZpormVsc3S5rFpOUlxKYILvCqNVz7C+DbT75SW0jneCEUdgQYFXqUFLZhsRLjo1ugXqZGtK/5y37Wkfb1OnTcsocoDi/xJx6kKrFVeMMoxWgRnlDYYXydVB/Kfi+9pA9mK/fteUxVwIRTuCThnnNUG5Kjg0DHCTpCTl2g3PeM9Gt1rFnRLRrOTAHEA9fHRRz2duGXgsq1CN5Ot10lHFg3h+kMm05Cohhmlh3Zx9kps4kdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KaO7FyK2OwQD4JbLKs6GXiMXyTVLodrTsmyEdNFE22g=;
 b=BppiTYNyuk29l645pGrsh170cLDgyBs/uDvAL/K+B3ENiWJFTdOsxvUxjx5Eur5e2rNysLe9Pg95908St9ao46eRj2q0mV+O9xtK8B3Wal/bzVBraemgzpVO3nB+eHOxxBlQ7xyJ80Eb29xwlS2mYAiGDMU4nKNSCSPBVv++XejN34HEBrB2+4ofIJFEWs3efWDCU6pHJSxHsL++ru7RD/spkRhi7yCTNbcOmU9/uBgGvC3FUn7f1svgQUiknPSjAEuKqjXtk/6qEvqwGgPzvX4yWR6cc7j/RQ0tGYrfh/TeeeLjnBybe22Wk2icGgokTqT2P6hrdtrpppsuqzcsNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaO7FyK2OwQD4JbLKs6GXiMXyTVLodrTsmyEdNFE22g=;
 b=eLPuqVVVfwS4oKreUw4Rzeb7BAAo3bZQKKgFRgJPh+7BW6qWsycfYJ9L2uwZMutNGO9eOAEAssuKM9Lr8LKEeDgvsxpo4qCbgoObEwhJ9iHiAEMJv7R2PAwh5MUL+mJrvAWRWAQPnqMojSk9UPUjRlr33UOqCPI5/lntju9DrQpgkd80qRztl5J25eb/z6BnOJJiCS6jBqcKy4mbC4haBjmz/LigC4eByJSkRBBnXblFOUfKrUBgbznRBs9YeQ9Vyhh2FUwCQU5sgGRQquadJvmUzdfjuQOZ8bOjMZMDlyc8cPcSrA5PCvI4kcwwcKJPutiizsBWsRwbsUTLUlNgZw==
Received: from BLAPR03CA0156.namprd03.prod.outlook.com (2603:10b6:208:32f::29)
 by CH3PR12MB8282.namprd12.prod.outlook.com (2603:10b6:610:124::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 17:30:04 +0000
Received: from BL02EPF000108E9.namprd05.prod.outlook.com
 (2603:10b6:208:32f:cafe::42) by BLAPR03CA0156.outlook.office365.com
 (2603:10b6:208:32f::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22 via Frontend
 Transport; Wed, 1 Feb 2023 17:30:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108E9.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17 via Frontend Transport; Wed, 1 Feb 2023 17:30:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:51 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:48 -0800
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
Subject: [PATCH net-next mlxsw v2 15/16] selftests: forwarding: lib: Add helpers to build IGMP/MLD leave packets
Date:   Wed, 1 Feb 2023 18:28:48 +0100
Message-ID: <540dc49dfacd735e3c4073b3444f98b41d81ff91.1675271084.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000108E9:EE_|CH3PR12MB8282:EE_
X-MS-Office365-Filtering-Correlation-Id: d239df9c-bbd2-4e69-6908-08db0479f45c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V1bpDXo78kmCyGtIIEkAdNYzzJ5mMPuLh57/5EuHF59wwev3Xmb5ckr62GRNCncaVrBKRb84QBUs7btXcofk/kGrHxd9Z2Wv0OHl8B0LtOK/Srr2cGsDUVaINlmT3X7WBekVk27/hDMIrkaGmkOIopfsSC5PhipjOzgIKpUUEZE7eTBg9xZxMWSQUlWx+9zq3+W9xkYNGtFnsfWmxfbE7pav/H+qVtBYzCxe360c2un9FPNujSE4+SCiXmGtudM6nouGk3m8yNbxpVi37fLsSrCrwnLBqbLkpxy0/7mSxizQ+wY2QNdgAKhUiMVbZBtp2ZRdmbv8ybODoYVgwqiztBIXO+qTGZ2i9pTRgR1a0V29MJ6dWRSOIcw1wq7wb1S11eizyeIbIfmCM43p/ox4V4GqreDrx4z0DkQ8bzhhmJjByS257+gI48VZo1A4puHFHZObmDydCwCaT36N+o9O1WL/kF4z1RYY1DpoNTMIMqZFi4iT2tnLxuH6B0V2RT80dTrE+qkFJeXLeO13XqpZQkkK0GnwK3MWh9jHkOfBiEFAWbdDJfnmm84cvj8D2OVm3Bmmf1MWlgilFSC70D57e7Pvs9i01wH7jQexyg9L99KC3D18kRbvTSrYyyEBviVi8Sqqw2cVcV4nogqGQlK35Y6gJ+c/+BUIV6lPYR0Dlu3w5rpmUb7/5LWNeD5Nxv/X1SBRcgdQMYo/pDz0An9wEg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(47076005)(2616005)(40460700003)(426003)(36756003)(336012)(40480700001)(82740400003)(356005)(7636003)(82310400005)(36860700001)(5660300002)(54906003)(86362001)(316002)(110136005)(2906002)(478600001)(107886003)(70206006)(4326008)(70586007)(26005)(8936002)(41300700001)(16526019)(186003)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:30:03.8120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d239df9c-bbd2-4e69-6908-08db0479f45c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8282
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

