Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598176907D2
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjBILx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBILxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:53:22 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7769663DC
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 03:40:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmlq1u37pUPK1R4dlaNgyXZve14t3GPP9XwztMs56NzY1tcq3p5d/nCJU1VGZAqLA1v+TUAJFT2m2uXuKerVHc0k761eShiR7C888CWvzfPTzChg8sQyFeyPrW1rdw1nc5YXezB5AIl0KsncTPKmIEviacN2fVSb1ERBMy9w14y6Frf8gM7qNohbSd7KgppKkXZsd0/v7v4buzwpTiOJqgSDS97+cewH0n/aWqWDOSonsQ8vbT5hfKGMbjYZAeolx92jLQ9uYciW5SbYRYvf6BAxnIqIjsih8Ecn+/TCioJLdo5YXUkEwtMmTjMZa/shZ5jMaFGajWWhHWT0pUCryQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1sjwkzaSl6er8KWtw65Xf1maLWJKgM9n85NcvJTgz8=;
 b=Xz03zpSNM7Chay73aslrgTrppic5BRd2RLtH+rkidmfuS27Y9MubfA6SPAIq/gc++S21cioYTWK5xuf2iTeKZoUcfXyWa6RdnzjdQZoRue9dvE3pbuNO7nxjnEZsyP6BGh13gRJji72UV9lngb1AhlgT5qqJEb16Rxmp9IdpuTcN1OJaD2cFMPtpQ6zA5/XaTon7VSEu0XwwscT6oMDKPHBfgjuiTwQPR11ZbmQ6d6xe0ZEO+NjVY59sbq6bkfTxXhBwtCgdnyHkThtX6udGNYhM94quZjnVNrGjMjoQyInYAq/elZ8CWF+Kbrg3HXWxrf4DbRvnFcN0H/x0OhtS2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1sjwkzaSl6er8KWtw65Xf1maLWJKgM9n85NcvJTgz8=;
 b=uUtux/M0fIbDurFs+rsar/M7Y1ObnibzetehfrIY4uN+g6mefZeefU7CDSOx+N5xu7SIfpO1XWz37McfPuLOrpTgDYP/z2QsNg4u/tuTNfbAHwcohi1aVWcGTJVHj6nIfqQAycCcs+K9JP4BQwQgPO1+PP/iu0OLjutoXqblVts3rjh6RmBUt54FVTaZtqZcUzRpv7QAT6LoI139jmJKsVRip+K6C3HyJKifrFP3wGgO1pZqKN9lKTum2kf3BJeqgOHJ6f6os2J6GMRrHVy4hbG0TrYlXiHvZDFirI0vtpZauI3+Ebncd99v3yW7OvzIn8IqWW9PsRJIRJrI6khnpA==
Received: from DS7PR03CA0248.namprd03.prod.outlook.com (2603:10b6:5:3b3::13)
 by PH0PR12MB5467.namprd12.prod.outlook.com (2603:10b6:510:e6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 11:40:50 +0000
Received: from DS1PEPF0000E63F.namprd02.prod.outlook.com
 (2603:10b6:5:3b3:cafe::10) by DS7PR03CA0248.outlook.office365.com
 (2603:10b6:5:3b3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19 via Frontend
 Transport; Thu, 9 Feb 2023 11:40:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E63F.mail.protection.outlook.com (10.167.17.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.16 via Frontend Transport; Thu, 9 Feb 2023 11:40:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 9 Feb 2023
 03:40:41 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 9 Feb 2023
 03:40:38 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>,
        Maksym Yaremchuk <maksymy@nvidia.com>
Subject: [PATCH net] mlxsw: spectrum: Fix incorrect parsing depth after reload
Date:   Thu, 9 Feb 2023 12:40:24 +0100
Message-ID: <6abc3c92f72af737cb3bba18e610adaa897ced21.1675942338.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E63F:EE_|PH0PR12MB5467:EE_
X-MS-Office365-Filtering-Correlation-Id: ea8b89ab-cc0a-4645-3856-08db0a927e06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OGVM6BjGItodbEqk5r224Za7ceX5yUMD0qSe+sNZ+Z5ujbziinS+HHVeFpnBS7A+Fo3TPF3IFSqz86oy0SMWIUbc802NUAw460feIxL3k0YEYKQHDcbX1NeeTKcVSxwfXEPREsUVUZQfGifyaEeYZkHv2DGTbf6VZIEYUnHLcepmn/+MJ9aKXSPfTWjvwPy0TS8tHJaimnidyNIGYl/vqBMz7JHSQ9WB+VBU6qUqbNH3J6cvW4jQ5zsPe/T77t/F/k1QMfCTB+c1mQUrFbC3e17p7aDYqV8KefSSUqM2XuPlu87evp2pokfkuu8NoF0oS68QMDTlzZWCP2nvRKickP3rn4ecqrzuERHkJZ85Bz5dva/ZfzUgd3ISpFie1uOohbQQBARy+LxgMoK3CCE5O4NLdXl6Mr88tse5WS7558XI5UH6E9F0JG4ow0WpTl7Nc3g7PTWbPTRDyUTj0rpQ5Ylok4KA8IgCCNzIpeTJHEYVEwgSi3vrB+9JLV2BO9J/2TklvZbW9Ea9uc9H7bCsRZ+oEsa3KMWHmVpAWRh1m6a/SF8QAThIUgF180PvpnKFWHYzdodyG/tNtxzorEfTeFtk1D+z4OXqcrbEW4ElmcZLrX/AlCMo2Hqq04HHCQ5BNDiSCS2A8b9NYy8qynHnGwRu0M+t8u4ePk5lNBxxDKbFVRvDQwUB5dQKQWQgtPTkkY0Mr8W70mtufThXrBK6SA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199018)(46966006)(36840700001)(40470700004)(26005)(36756003)(186003)(2906002)(107886003)(16526019)(6666004)(5660300002)(356005)(478600001)(82310400005)(8936002)(82740400003)(41300700001)(40480700001)(2616005)(47076005)(8676002)(336012)(36860700001)(70586007)(4326008)(70206006)(40460700003)(83380400001)(426003)(86362001)(110136005)(54906003)(7636003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 11:40:49.7334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8b89ab-cc0a-4645-3856-08db0a927e06
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E63F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5467
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Spectrum ASICs have a configurable limit on how deep into the packet
they parse. By default, the limit is 96 bytes.

There are several cases where this parsing depth is not enough and there
is a need to increase it. For example, timestamping of PTP packets and a
FIB multipath hash policy that requires hashing on inner fields. The
driver therefore maintains a reference count that reflects the number of
consumers that require an increased parsing depth.

During reload_down() the parsing depth reference count does not
necessarily drop to zero, but the parsing depth itself is restored to
the default during reload_up() when the firmware is reset. It is
therefore possible to end up in situations where the driver thinks that
the parsing depth was increased (reference count is non-zero), when it
is not.

Fix by resetting the parsing depth reference count during
initialization, as is already done for the rest of the parsing depth
related fields.

Fixes: 2d91f0803b84 ("mlxsw: spectrum: Add infrastructure for parsing configuration")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a8f94b7544ee..642229b1f47e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2937,6 +2937,7 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 
 static void mlxsw_sp_parsing_init(struct mlxsw_sp *mlxsw_sp)
 {
+	refcount_set(&mlxsw_sp->parsing.parsing_depth_ref, 0);
 	mlxsw_sp->parsing.parsing_depth = MLXSW_SP_DEFAULT_PARSING_DEPTH;
 	mlxsw_sp->parsing.vxlan_udp_dport = MLXSW_SP_DEFAULT_VXLAN_UDP_DPORT;
 	mutex_init(&mlxsw_sp->parsing.lock);
-- 
2.39.0

