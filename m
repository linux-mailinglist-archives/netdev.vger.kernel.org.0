Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63D46BC681
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjCPHIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCPHIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:08:42 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBBCAA25B;
        Thu, 16 Mar 2023 00:08:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3LF5BGJBfrVR3UDm87epM5jI4gBFYS9nCK6ejorxbtTX49jDqY144uA8Ri/0tuMYPiDQfELjlw/svtqSf4PywZY3mTzODbprjndSgH4nTaC/rw5YNb7TsJXGqC9zQRG/N23ptNLtmYBn3/PNevD3+yNyKfCfTIWStiXMsmlNm0DM237K31tO4lszx18jEXhO2SrLJpfGqGyoG7aWh92SU2d6olDjWLACCpiocAV7ECe5K4Pfr/XV1LBmAVYKyrfgf0o5E0CZ5VYJRwap/XZx0ms6ri+UaZS4TpqdVYkULALGvwDZw3fmZDEPJG1XkLjhlxYvtXP0rsxwQtGg/TpJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ma0oNfJ/7ScK7q/MSUgrxATDPBVDvMgWpGE3BQFfg54=;
 b=HLhhf3itoUS/wujyCUbYKpgl36cIIeZilsFtYs/lL3vl9EZrQyqbmmBBlyYw5PEy17xnefVqSMJI5cbXnbFLLgErgsL0SouczPaDWHIzoJRlObZTHqtTeOxPk6MTt/LtPMzeL4ToBVs31+MLMQV83aHQCn9rOIlTOGQxHWZNWrRBgYijJwwzJDrz80y4p+PE7YkI8GYo9m+74MpZpBj0j8WX/iR57lUUkezA9t/gLP/5zewrHqGMjHEVzg5vH/crIfQ9SBvp92NKMuqudIFL97RcyVLWDndFtvqKIhLTzd+nDsRY+jpsZFIKQFmUQgjnspaRApCz1dUlC1EWMFXFnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ma0oNfJ/7ScK7q/MSUgrxATDPBVDvMgWpGE3BQFfg54=;
 b=LV3Z0I1DZotw21lAaZlIrOJRTMARC6e2ALGZYihQWDPgXkf5yOkfDS/aO0u1au0GklvSnR6vDQ5l/jDhjD5iE08vLWmoA/zgtAXC6WV1nZuAMl7CfwP4BxDA37fnwMZ3Q9cgNrLkXoCE/IRLfpFRffKj++YQhPw+yDWg6uuNnMPqa3cET7+Umt4qY+vNzxSnJ9CNNYfLDu1DsWxVtkKoX7HWoTYLO4eCL/AemT2Cwu/e1c3/whho0yKMKl51gmaF0zy64bJRuhACYfJ+1b9XXyLTvuxiO5Cc9Q/SUCZOhQWskGty9STaz5fi3N7+JrBHXPu3VWqL0ssG2faiV+/xlA==
Received: from CY5PR18CA0017.namprd18.prod.outlook.com (2603:10b6:930:5::34)
 by SA1PR12MB7293.namprd12.prod.outlook.com (2603:10b6:806:2b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 07:08:31 +0000
Received: from CY4PEPF0000C96E.namprd02.prod.outlook.com
 (2603:10b6:930:5:cafe::f7) by CY5PR18CA0017.outlook.office365.com
 (2603:10b6:930:5::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30 via Frontend
 Transport; Thu, 16 Mar 2023 07:08:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000C96E.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 16 Mar 2023 07:08:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 16 Mar 2023
 00:08:18 -0700
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 16 Mar
 2023 00:08:14 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v8 0/5] net/mlx5e: Add GBP VxLAN HW offload support
Date:   Thu, 16 Mar 2023 09:07:53 +0200
Message-ID: <20230316070758.83512-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96E:EE_|SA1PR12MB7293:EE_
X-MS-Office365-Filtering-Correlation-Id: 8afb559b-60a9-4585-f997-08db25ed3f2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 05SGVltx4RCH18NOhP1R94DCL1jEMr7O7jYtmvo3yAY84Mtzh2Nde3fABTScm+omxrLV4Rk69Ih4O/aTb4skKpKxqt4WlMNGV2Tu4RjwLa0P9y1XLWVl5a3ux9x816AUE8vl6SzLSRD5qj2ge/eA8DyrORoX8UpqCaypmZQ6zcB8tMz3oCsdhF0dU7DkC/hdOy59sgExBSTRNnFfYXpCortv6/BNixeSIhtb8Klso+0G748uQoSeXqgX/HVdGtM1tuu3lxEu2uYLsYoObRzkB2+qONQPTH5HlpNiOi2GG1EzCZaUDjeK8OA6lOp44WjIYmAluju1ElH75UYct1Nvs6yXDYBIeE+KhxAfylh3NTW9hksUnE4v/A02hHrXgkKcyNKWfRlKS1VLzKwbvKuOunvWLxdYAP+8WTj9mm7ONtSXt6uMmxRfeXIEXoqVNXLIHSPjZRn00Blx4PlN4arYTkcKYQET3e+9ykfUY2qJRo9Um6nw27GFV460BZNjnIi8EhgxAMKA/n6gJXmc4sekCih38D9QiMohcPFe7fC0SckaVoXv7m4wxEMndUHGmqb3LC8jolerWkMKQCiTUVsvRYQ2JoI2OqHuzPBL+5wTL8CZh3W4aJj6AFWlhoUlRNo5lyxqD+MqMbVjo4DAR9SHo62jOYA0sRF9uk4LrqsdIxXPnzwqvfLf+kFkBz2bhSSABKIIJsrQUoXkHtCESFX7IU8QoccwZKr6QmdkgPbdWRiyCJiQ1TSt6ypQZ66+iV0Q
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(82310400005)(356005)(36860700001)(7636003)(55016003)(40480700001)(36756003)(70586007)(4326008)(40460700003)(86362001)(41300700001)(54906003)(8676002)(82740400003)(70206006)(110136005)(8936002)(478600001)(7696005)(316002)(2906002)(426003)(83380400001)(336012)(47076005)(2616005)(5660300002)(186003)(6666004)(16526019)(1076003)(6286002)(26005)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 07:08:29.9129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8afb559b-60a9-4585-f997-08db25ed3f2b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7293
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
v7->v8
- Addressed comments from Jakub Kicinski
- Use netlink extended ACK report only, remove duplicated netdev_warn
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
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 +++++++++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +------
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 72 ++++++++++++++++++-
 drivers/net/vxlan/vxlan_core.c                | 27 +------
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
 include/net/ip_tunnels.h                      | 11 +--
 include/net/vxlan.h                           | 19 +++++
 9 files changed, 151 insertions(+), 56 deletions(-)

-- 
2.31.1

