Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E946B7067
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCMHwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjCMHv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:51:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6CB5292B;
        Mon, 13 Mar 2023 00:51:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faej2pH/5OOddGX1r+x7nD/jt/94OWHX8DdECzlCTJKqb/xmyENsOOgzNYstDTMf5EqzZyT/i9ZEnzSHAcWktJCNbcEYx80V3fRjpxn09lcC1qQHzlFukEp2/9s9Ym+uekj56Ik7KKmKiuk3OQRG/7dJcok/qcbGmBh+cm5AifgsqW5R+jQjY8Sa8fLyGcqe/h/HIQORGwtZVHkLEwXZeeikO2/TnInP8oOSSjNilY1rqk+6/Ie/kJctxPpag8zdj3l5hiFIZF737VDyd0Yjd6dgpuPA1yqIIaK6sKxQ3tEcFo0pBXljFavEYjhmaH7dKF06nvm3NJLiK7Tq9qYQug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWHHFXqHBql+rgmdDa0uDyvW/6Anct7/ZBkfPOJ8Q1E=;
 b=Ri4fmiNvHV7XEbxBbLUiUlqLzNlflKj3/g4fqwx0zjhTiciiEdp1r32PwS2Doa7blZJbzlxK9r+evxvl99cON3iNT3X+Orx9bbFYpJtzLOTkraJDx/ufu6i4AMXRnF+ewAXSwO7bKoPbS2vsvisUav4fDa5v0fG82yOk/g+dlV+Ezp9PZrLECiowjeBed/PDuhYUro9TRrQMO6hlX4SWXlo1rv3TyeqTAf6CkF8SMgisynkAXeonxNWZBm5BGnI5/+ah1TAWaWREs0165CiWYXrFlSN3IavwF39Yoeio36XqzewTiYxVTFow4FCikiVRNn6flTvuQS7PxSSZ8TKmVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWHHFXqHBql+rgmdDa0uDyvW/6Anct7/ZBkfPOJ8Q1E=;
 b=aijKPlvHDNMj7jKg+7LAmyCC8OVNGb1W9xPtHMYT+sMfqpn1yQvk6N0hRMr5TSFqjMYk7WpSuZ6t+lpmr4XWKq4E/bqvOEWT7VCfZRWtWoRC02N76INl59uNu+y06hqUB+h9GxylUK/Dc2YQrYW8jHbXGFtdcK+k9R5NjsEcUYVVYbCxt04aQngbnBRpk3+IEPrV47qhzUIq/9osdkoJnOFuiPh0vdvEfT9VyY8Qvk9OqjQOHaJkaAEgee6DQIizUHImAqU3GfsWMpjGpQHrzArEVhUkfbyHvQoaff4jtXsmsjmb1NrlUz/M6X24ThhrR+QrMBFt33AG03co33ty/A==
Received: from CYZPR20CA0001.namprd20.prod.outlook.com (2603:10b6:930:a2::26)
 by MW6PR12MB8733.namprd12.prod.outlook.com (2603:10b6:303:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 07:51:38 +0000
Received: from CY4PEPF0000C964.namprd02.prod.outlook.com
 (2603:10b6:930:a2:cafe::8a) by CYZPR20CA0001.outlook.office365.com
 (2603:10b6:930:a2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25 via Frontend
 Transport; Mon, 13 Mar 2023 07:51:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000C964.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Mon, 13 Mar 2023 07:51:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 13 Mar 2023
 00:51:32 -0700
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 13 Mar
 2023 00:51:28 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v7 0/5] net/mlx5e: Add GBP VxLAN HW offload support
Date:   Mon, 13 Mar 2023 09:51:02 +0200
Message-ID: <20230313075107.376898-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C964:EE_|MW6PR12MB8733:EE_
X-MS-Office365-Filtering-Correlation-Id: aab46414-b7cb-4d7d-baeb-08db2397c632
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GDUda69cog9gl3X0Z0D6LSICvNwHtbbB1g0GWwcHMliVDV7wX7rZC4Y5yiYoiHMXvJFCns9gvsrqzyCmz0K6NZoplzwwdMZ+fhn7r1jrKCLrlQegSidY+Hl3c1Oc6sx5nxczN8b9tPsfX6Ix7F5ncQXi+jkn5bRxFk4mIunePtXf8pVyqZ2pDn1nL1ujbi/w3AKv8V5xCa9N4E3FyS2R5LLIR9mzOf5T0QcxJPUmzoCafLfCETD6Jb4gVZSz659MiA95dDcoSYGte1YCVXF82SrTjPgAqjHGOnHcNRnh5vNKaBVbZQcc/Bv7dWHCq44K0G+e9xN0+Bn4gSUFvoS4QdbVaTfXYuEIfgMM/5+IdtFHEONv8cmZmZ005LRJEA1uiQLHnQjgJJzK0Fbclj+60y/Dweurla6DA5iMlX4hu9IUpvaG+a+0+CEnaNKp+qhElAfOO1h9EPiuR+pEfXxjzg3fdVl/8Pyf7LvC9biGzayesJz6xbj+K5Pt7jd+EPWCxN961qOcoZYS8JL6yAOtAAKQ3EZaxZnDr92h+8hns7YvR2kEfY1wlakle5nNsY8Yh0qAXrjbpg9C/k7WqZkMmtTraCaQvcA+vWcrxHhhTdpR2Ciq61tL55uaiC28hzPS/e38oWKoHRqcoCk8FhdBbxfy1ZNUYRV47AaiXbuSqpjArB+uD5BL31Pas3vbbFOSr4lED4rJv8sv78lKDrgwRj2+/f5R78GwppaJ5u5NDFSJlZyQBE6ZR+U7Kd7KTn1A
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199018)(46966006)(40470700004)(36840700001)(86362001)(82310400005)(356005)(36756003)(7636003)(36860700001)(82740400003)(55016003)(40480700001)(40460700003)(4326008)(8676002)(70586007)(70206006)(41300700001)(8936002)(54906003)(110136005)(478600001)(316002)(5660300002)(2906002)(426003)(47076005)(336012)(2616005)(83380400001)(7696005)(16526019)(186003)(107886003)(6666004)(6286002)(1076003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 07:51:37.3741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aab46414-b7cb-4d7d-baeb-08db2397c632
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8733
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
v6->v7
- Addressed comments from Eric Dumazet and Simon Horman
- Fix type safety issues
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

