Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415416B25CA
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbjCINsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjCINsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:48:15 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4171E222DC;
        Thu,  9 Mar 2023 05:48:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUhax7xsSnNlqVwxQcx/QmJ7HOPMXSoDof15Krh5H3YdpQXXzw7qDOKxPpOIO/HzcEelHHSBFvzltJOzMvNzBci1EdtkGzLJRjrg/XVLGcqycn0pektGHIHLTjuZnSJ+HKF7NZrHX3cNYgGZ/+Zjl6AEVqadDIUUMYwGJ+Y2SDLXeLls883itP+CbNpt6AKRjHwyJ41nw50P142i5ofQvsugsK6dbWUT+bsYrtcElRB2cUxVi23tbYBieCzp9WJ9skn+YVV5kDISHtVQ24oQByyXK6wvAgO/heMlt+j388qKOBd/hXa0b4WA6PljFtFUGI/JVeWenzU91CiqRvXMzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjXiTZkXyZKXVPfEyuRj+8QqbOM1GSd0yM9GNFmoXLo=;
 b=b811mjdULzNQO9qTp3ExWOdfnGC8T0ZsBMK7P+u+BEXRgv/PjRK+vbOVOOrMSyHTKgmSr7B7tTFoiaWMlmZ4JmfHLUschyBjNmdk8s4rsGtluKiOaukP+3ficstwP1TbQ+XHeaowCnqspAa3Ew7IA3bJl1wfw/IEVblkwUJydXoTF22z0oLIStZaV3oYksWVUv/okSgit2+zUORyqI1HAqmI5lJFB2IF7/KnuPjbGkTurATkYPB/k2gku+ummuEIkAkbAjRa+hDvwpcr9bEOOheGDtTlDjrn03kuPF2ynMvRXz0rDiWmNJZhu/R8uwdHwOiPAoGHRe/EBGAM1WTRaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjXiTZkXyZKXVPfEyuRj+8QqbOM1GSd0yM9GNFmoXLo=;
 b=HZ4I98DIf4CRpzbn8/IY+HncjKF+Gt0OEoenPR97Q3tCGFvzkfhtBqV0qyL3jBTU3nQBo2FTVoI/JngqRlMfbwhx5sVMu2vIxE36SgtuX8ZVrdnZzfUWYbcQPiQ1Sc1uHdKTcnKhz9+MDaRAP89fCAF+hAJxgzxdMNRkBMdOLjp/9yqxyjUH2rtbn1PDQCqO68BWPN3RpVo5KI2hxDgKt2m6J2yTz5qi8JgI5CMVgmhasMhijdtvHeq/nyTxlNpPVFCu5Z50DqUvSpCfbsQcLOEr0tJjPSXe/Egp0mPjv/3OPByJBre+8hqrttadFoWrnxANybe893G1nGk5r0QeHg==
Received: from DM6PR10CA0024.namprd10.prod.outlook.com (2603:10b6:5:60::37) by
 CH3PR12MB8235.namprd12.prod.outlook.com (2603:10b6:610:120::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 13:48:09 +0000
Received: from DS1PEPF0000E644.namprd02.prod.outlook.com
 (2603:10b6:5:60:cafe::7d) by DM6PR10CA0024.outlook.office365.com
 (2603:10b6:5:60::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Thu, 9 Mar 2023 13:48:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E644.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Thu, 9 Mar 2023 13:48:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 9 Mar 2023
 05:47:59 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 9 Mar 2023
 05:47:55 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v6 0/5] net/mlx5e: Add GBP VxLAN HW offload support
Date:   Thu, 9 Mar 2023 15:47:13 +0200
Message-ID: <20230309134718.306570-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E644:EE_|CH3PR12MB8235:EE_
X-MS-Office365-Filtering-Correlation-Id: 365aae6b-a7b0-48c3-8823-08db20a4ea99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NLXiO7pvedd3waxusqA/ax/xBL0CmF64UEyZx4O1TA/BFNP2qF0LQe8FZ8aUOrFWweSMqhoo9rRV76jsuWFDCHoFw3L32qoDGB97PH4pQ5LR8tMCTEde9TO9eFRiqeHSQMdpDcAJ6QgAXRWVDJSWBTaLfMducXDPNece1TVgBtsjKk9Eto7o4zHXp1C5qxo7ePBF5G4mBqQ8Lai5zN2keXqUqkRoOb21NqJuf2uKtXbpk+u6i/xpA6ek0QEKyBbFIBdbUdBfHLhliSPN0AnV5NuZXNERgBAFwiCi/pXZsA+MOGzGzAk3pq6bvhnbIy8Y+i3Z/t/5KgmxTDVAa/cnYJAlzOs48DnGPky/WZ+0LlUyK6jI6W0HZdpofBZn0ZsSI8g1gomjQ6b/PjM0ZuDNEk+KZdEI2nzegajoJVoiTUI+bJBn9HEerY0zgxljbPovm7kx8snSXWQTL0qsjNVM7/CR0X9hc3EzjsoG3nU5mnWXGwqeF5CIcm6F6lXrME8G7tDdbk6SZEV3+tnTsarILw/SvL/OfXtLEiU3Lf6Z1mxdNuGYT+CEuE8QqMWcf0KIRs77oblS6q5r4xQb+BYp2Rlb3plg0Sz6G1IMY//KWrn1XqYcabw7Ea2LF9HUbRDCmZEf5ytCeBFnuxJiTr/9nwK9HKypqBpe6KBcZvtkndLEivukDQrTEIYfNaQ3UH662JsdwkY4fXrxkDagVnxzQmFAA1ywx+oX/rPq78NICi84CFosB7EGULB4d4qiLmbO
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(83380400001)(478600001)(36756003)(186003)(7636003)(54906003)(82740400003)(426003)(6286002)(55016003)(356005)(70586007)(82310400005)(16526019)(40480700001)(70206006)(4326008)(8676002)(7696005)(26005)(2906002)(1076003)(2616005)(6666004)(336012)(5660300002)(107886003)(36860700001)(316002)(47076005)(110136005)(41300700001)(40460700003)(8936002)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 13:48:08.4306
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 365aae6b-a7b0-48c3-8823-08db20a4ea99
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E644.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8235
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch-1: Remove unused argument from functions.
Patch-2: Expose helper function vxlan_build_gbp_hdr.
Patch-3: Add helper function for encap_info_equal for tunnels with options.
Patch-4: Preserving the const-ness of the pointer in ip_tunnel_info_opts.
Patch-5: Add HW offloading support for TC flows with VxLAN GBP encap/decap
        in mlx ethernet driver.

Gavin Li (5):
  vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and
    vxlan_build_gpe_hdr( )
---
changelog:
v2->v3
- Addressed comments from Paolo Abeni
- Add new patch
---
  vxlan: Expose helper vxlan_build_gbp_hdr
---
changelog:
v1->v2
- Addressed comments from Alexander Lobakin
- Use const to annotate read-only the pointer parameter
---
  net/mlx5e: Add helper for encap_info_equal for tunnels with options
---
changelog:
v3->v4
- Addressed comments from Alexander Lobakin
- Fix vertical alignment issue
v1->v2
- Addressed comments from Alexander Lobakin
- Replace confusing pointer arithmetic with function call
- Use boolean operator NOT to check if the function return value is not zero
---
  ip_tunnel: Preserve pointer const in ip_tunnel_info_opts
---
changelog:
v5->v6
- Addressed comments from Alexander Lobakin and Simon Horman
- Add new patch
- Change ip_tunnel_info_opts to macro and preserve pointer const
---
  net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
---
changelog:
v5->v6
- Addressed comments from Alexander Lobakin and Simon Horman
- Don't use cast in driver code
v4->v5
- Addressed comments from Simon Horman
- Remove Simon Horman from Reviewed-by list
v3->v4
- Addressed comments from Simon Horman
- Using cast in place instead of changing API
v2->v3
- Addressed comments from Alexander Lobakin
- Remove the WA by casting away
v1->v2
- Addressed comments from Alexander Lobakin
- Add a separate pair of braces around bitops
- Remove the WA by casting away
- Fit all log messages into one line
- Use NL_SET_ERR_MSG_FMT_MOD to print the invalid value on error
---

 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 +
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 ++++++++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-----
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76 ++++++++++++++++++-
 drivers/net/vxlan/vxlan_core.c                | 27 +------
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
 include/net/ip_tunnels.h                      | 11 +--
 include/net/vxlan.h                           | 19 +++++
 9 files changed, 155 insertions(+), 56 deletions(-)

-- 
2.31.1

