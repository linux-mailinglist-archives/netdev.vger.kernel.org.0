Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5DE6CECC9
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjC2PZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjC2PZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:25:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03E3CF
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:25:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTv4Y/+ATw2i2gyAksYLi0l66lDNY4NY2qBSkWt8qJRHDaYg1cppNdE+paX/onsUNcYcL2NDZ7Mr6GyzgSjKKJVweeAaD6e/ZrEPnDtanc96zFQOPeaqWVZ3iXoWFN6N+axAaf1ITQAYkyN39H6u5JOFTCZ4S8mqL1CY1tPN+jtczjgYprgtaHTv9KSFsRbiF7UmXk94e9ZZKqTs8HnheWE1HvT2WlbpL9MpfU+YmxxU6xo70fB6lqUOTMH6SfsY1abuBtyGllBdVzs+gipyeCut6ro8RbubYEB+M6gV053u4kF3GNNibeoj2fizNLuuAOZSQLzHBpq9MPtuf8x80A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X3Kfn3gWdZ9iv6mve5vQqpH78dE/io+EVwRu9tCSQDw=;
 b=S/BZpnSGB82kFjljl+bCaD3LDVVTTcFLOp1lqZBExRBx1KU4rg/VC1CfcH3+P/IYrQAd/XBlLFQWponfUPLe+kWMnvqJDvbbwe1LrsEE9ytKY0RJDcyQ280HMb/cfx0vHC3QSyDfPJID9NwhlP6SqI6k5hXdkshQiBEc90XrgzQms1C2k1K/lxOxNYxYtalOE14lBqS5ZL+oomgQhxzvuuZ2GXoiJa2ZQfuvsfb34jcIE4iFm8uaRDeBnmXm5EN8Jrzh1BeHpBLR01mlfmEGe3UBi3KxTTVBhu6cQA0XFl26uzPymCiZytr+VG/VUQVWAgG2QVDYxP1C904cXWfuow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3Kfn3gWdZ9iv6mve5vQqpH78dE/io+EVwRu9tCSQDw=;
 b=IaXcDEzztWiTzXLv+brzoZXHsPTX4UMWkdy/nlqEgDdQIHZkHydwz0WxYBeTHHm2BBg/AFSuLki5kSoocvowfHgFdFzuEK9xLkuzha1BBGS0NTy4f0Lql0v8BGIrQ2Qlr9UfV4W2fhxMPLgaVwPjIrBz2QUOS/EavDpNAx6AVvMQlMXYFkxH+sg+hSCpyVwycGOo30I9kVeLewszF1hEe6DFdFvJfevpuuzjDFDw0uOVV06dzzv7IDQzpKgcgUJ8cIXLoP0+VMwLZXxITN7raG956VhnkF9Zjgrl6ni+La4fnfYcVHPiJ/oyh4kc8c7y50okb9EeZJdQxN9CjzM37w==
Received: from MN2PR02CA0027.namprd02.prod.outlook.com (2603:10b6:208:fc::40)
 by SN7PR12MB7274.namprd12.prod.outlook.com (2603:10b6:806:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Wed, 29 Mar
 2023 15:25:39 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:fc:cafe::6a) by MN2PR02CA0027.outlook.office365.com
 (2603:10b6:208:fc::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Wed, 29 Mar 2023 15:25:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Wed, 29 Mar 2023 15:25:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 29 Mar 2023
 08:25:21 -0700
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 29 Mar
 2023 08:25:19 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next] selftests: rtnetlink: Fix do_test_address_proto()
Date:   Wed, 29 Mar 2023 17:24:53 +0200
Message-ID: <53a579bc883e1bf2fe490d58427cf22c2d1aa21f.1680102695.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|SN7PR12MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: f82d0686-d64f-4dce-e9f6-08db3069da13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p2DR+hEZDraFeH9Bsi6j5kgI1juRV1ECbUBrmMYvnoUnv588WHSkTpjjwYT3M9w+eG83OZnjn6MXRxpIxZa8LPI3iwIOkouRkEO13xFJII7T/lIhmH76Rt0crn6ZxmkGTi8H51d94iFzTxt2dtqpSgnh2GvxVdfQWvxwhDtkZbMDWNAOwo77cHIZ7YhOu8rmTVHWC0tfi1RtG12TXWan7kRtmMElorKrEqXRhFV7WL9HgCwWR1nnuEa11Hp899Y+OqKFqmkq0i8wJL77tJy4G6eJg/t1I9mvgHoP0nKL7d5AK6W1nnt+yb5qXleFM7Hy8uE316NORMynr8jtPtz2ZOWq1N8yJAvCozp5mMcBj4hpQZz24T/LSc8gjWAHE3awIygA0fqQPZrDAPrceiSEbo0FcKa4Wr2Z+OAA252dG5C0gDHOQPS1W/PXeMBrwAWx+plnH0zu0K4cmlQh0VgddGQ+41YyB2+bPMofI2QZsNpHS7OsCgl13ZRtzxya3irT216X9V02RXJHFFlZVQJk/nCEXgX4M4sMkY3qV+sjM5RrFs5yJiKJhiMdrl8VK79IDkydht5MhKWuk5E4kY78yK6h3HaVHB1VVmPGUIZvVMn1S7DnHAI18Xp2qCp8XPlDi8Ot0tLmLQrdQNEFSFGvWHeRAJ6spDnPYP4ejVyXZzDv0+DzcYDNI5v/0jbzhF/ndVeKq60z9TEIcLKu7aUC9KVQWGp9iYWpc/lNsdEXUgVLwAF75QUlIbm+SWtzxRHg
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199021)(36840700001)(40470700004)(46966006)(107886003)(16526019)(186003)(86362001)(26005)(6666004)(5660300002)(70586007)(316002)(70206006)(110136005)(8676002)(8936002)(478600001)(4326008)(36756003)(41300700001)(54906003)(40460700003)(40480700001)(36860700001)(82740400003)(356005)(7636003)(426003)(336012)(2616005)(2906002)(82310400005)(47076005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 15:25:38.9463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f82d0686-d64f-4dce-e9f6-08db3069da13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7274
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This selftest was introduced recently in the commit cited below. It misses
several check_err() invocations to actually verify that the previous
command succeeded. When these are added, the first one fails, because
besides the addresses added by hand, there can be a link-local address
added by the kernel. Adjust the check to expect at least three addresses
instead of exactly three, and add the missing check_err's.

Furthermore, the explanatory comments assume that the address with no
protocol is $addr2, when in fact it is $addr3. Update the comments.

Fixes: 6a414fd77f61 ("selftests: rtnetlink: Add an address proto test")
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/rtnetlink.sh | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 3b15c686c03f..383ac6fc037d 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -1302,19 +1302,23 @@ do_test_address_proto()
 
 	count=$(address_count)
 	check_err $?
-	(( count == 3 )) # $addr, $addr2 and $addr3
+	(( count >= 3 )) # $addr, $addr2 and $addr3 plus any kernel addresses
+	check_err $?
 
 	count=$(address_count proto 0)
 	check_err $?
-	(( count == 1 )) # just $addr2
+	(( count == 1 )) # just $addr3
+	check_err $?
 
 	count=$(address_count proto 0x11)
 	check_err $?
-	(( count == 2 )) # $addr and $addr2
+	(( count == 2 )) # $addr and $addr3
+	check_err $?
 
 	count=$(address_count proto 0xab)
 	check_err $?
-	(( count == 1 )) # just $addr2
+	(( count == 1 )) # just $addr3
+	check_err $?
 
 	ip address del dev "$devdummy" "$addr"
 	ip address del dev "$devdummy" "$addr2"
-- 
2.39.0

