Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058AD69ED1E
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjBVC5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbjBVC5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:57:38 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11hn2216.outbound.protection.outlook.com [52.100.173.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2306B59FA;
        Tue, 21 Feb 2023 18:57:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWXhfpyfzvKJWRCq7nCAPJvL0iTqfVPRvGiroa0w9ElZ8ZC18jhvSZ8WTZKGvwj8YxPCbeoR/lVz3VSpSRNqegvdbHS+pd9g9L870bcwJX9cOdEi4AubGpbP4Ds0gWwAJPvGFbYFm886d4KUA2cI+orZEY9mbXryFKzYF6yU982cuRHKxszcNaSNu0cln2yDSKpI9hbMqurt8G9yYWCAwNURx5GSfBWw8dUsDOKMIsnpF17NIcgKTogva+/EIzmP9wd9ldDlWeYiKBsY2OK3rr8hOTEsNyvzK4KSvGkcZu/vtbJUi7DR2hrZZZ5dX1FWthI6Tui5ahc9bsYHEisd4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIiD0dPSjrZEFOFG6fQrmcNTk8rMCljUc+/AaQN5bfE=;
 b=AxOakuKFnUJF4AwFNNQsqYba03CvxXz8hmevbTafTh2jzJEILRmL3gVdKKWAwq719EEWvaFPuNcRxOKVlvo+gCTP7jS3XKZ0f54xKS+cxBUVK/Ut6QL/lSetg6r31zRpG7w/dwR80BPP5O1LrqlfovsW5pnfUKOFPBullIipXNz0kuiiLZ/Pt4xuuSz0hMbKC6x6NpcdriMf7qBT1sP0YmxYbRqx7zZcLN68yrLqyPHAPOZ8I4p+CqmIWsvqnF7lMHTC0rYkZcv/b4f+o4HuLQOywkSyDaBeNu4TqGO9voEXb5YcK3b7FBfFUTS8Hb22U3sRgguibTE5Ohik9dqKLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIiD0dPSjrZEFOFG6fQrmcNTk8rMCljUc+/AaQN5bfE=;
 b=uZEP4fCQJDce9HdxBZGOxv/4XnWRwnggKIxnhuOsngj8jy8GK606qJA6+Yj55CGu5P42e3XYPYPoJGsphmUEqJ40eH6muVYejDkZunzVviKwD/gGw2VNIJiEMXAhO2nRrMZ4PuHTP+IipCqK/mx1wl+7+f6bUW6lipxql4uyaveDmL6uXoFlKSlebd6Psu9wpi8YVRy/Les0ocTrrXh6tDx9maXbL1pGtEHBSzcDUN+4ChgoyvUGfs0A+rjbZckBBe9RjDarBbuAiWLsUnyjhbVexcKFsAgoLrjW50W6Qqt0jr3A6W8fQnwNzeme4HuCBDLjDXUKhSV0QuZxmwEf+A==
Received: from SN4PR0501CA0036.namprd05.prod.outlook.com
 (2603:10b6:803:40::49) by BL1PR12MB5993.namprd12.prod.outlook.com
 (2603:10b6:208:399::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Wed, 22 Feb
 2023 02:57:34 +0000
Received: from DM6NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:803:40:cafe::cb) by SN4PR0501CA0036.outlook.office365.com
 (2603:10b6:803:40::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.16 via Frontend
 Transport; Wed, 22 Feb 2023 02:57:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT085.mail.protection.outlook.com (10.13.172.236) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.17 via Frontend Transport; Wed, 22 Feb 2023 02:57:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 21 Feb
 2023 18:57:21 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 21 Feb
 2023 18:57:17 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v4 0/4] net/mlx5e: Add GBP VxLAN HW offload support
Date:   Wed, 22 Feb 2023 04:56:49 +0200
Message-ID: <20230222025653.20425-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT085:EE_|BL1PR12MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c09f6be-b255-4b4a-c0ac-08db14808bbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: holA79y5fGHRzFEsm6m0MMkfNzipLpy6e/cBfjKyl5K6h8D+o9WtLPWadExBoaz7bpUIoxDasOoOugb6X3a+Pz0JEmmP2UMmMGbZpSdPRrFrVeRo1prq6pWd/msn9ZbQKLjfo/xVYBUBB+TBhu3gW/GURxeBMjHoMKpZlbl10EG5fA6ifirZ4dNuTEEtKKjichX06d+7pmun7A6bg6cIMI4yoqdxvQt2mXT+tC+1ba8s1cp4XT5doHMECJO1VXqPqUphJfUsKz0vmwrz0awYZf1udzImWa4PGYtBiGjGYoDFyIFI9yRHer70a5QeQ8cALKKF9/4wu4vSCXOO44hnwCgf29UAvyGlxw5iocdE4vz3m6GbxTSlfS+cuIjIPWuUYDxozALegyBQCdmGj0fH+aQjGlkXaTi2lwvurYUlG9vzexIqaI35WzhwN7FiN/3wLgOxK5UnKDItIw/iLHTQIM9+3a+la9rYdxknrGCj0BastY4XldMaSLzwME9Ra6Xaf3pfx8TnFmx9nBy2uz1qp60Snad/W5Phl4Xlunw6z0QHGwOO56mXbb4V+Y8AMLgBAUI+B8dC+kP4ocl2Z2mWUVpm1uby3OQkbPlOGQlgy0VUj11TRsuEYm7j5+zVMYTLUv6+NGItfmjZEH+X6UK4gr5MmsbFBSeZq/3fE859yha3IW1yIPMBpko/ZpTPBQfG8ZjQ8rkXquu2syeHUtZHu57F40HdAjSnZeU3AkOobIqnsogGtJeR+Ub6BjHwOhIRwX2Uzmp2QaeZfZNApjEBiQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(5400799012)(451199018)(40470700004)(46966006)(36840700001)(34070700002)(40480700001)(7636003)(356005)(36860700001)(82740400003)(47076005)(83380400001)(426003)(2616005)(40460700003)(86362001)(336012)(54906003)(316002)(55016003)(110136005)(8676002)(4326008)(36756003)(5660300002)(8936002)(41300700001)(478600001)(107886003)(7696005)(82310400005)(70206006)(70586007)(16526019)(6666004)(6286002)(26005)(1076003)(186003)(2906002)(12100799015);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 02:57:33.4357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c09f6be-b255-4b4a-c0ac-08db14808bbb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5993
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch-1: Remove unused argument from functions.
Patch-2: Expose helper function vxlan_build_gbp_hdr.
Patch-3: Add helper function for encap_info_equal for tunnels with options.
Patch-4: Add HW offloading support for TC flows with VxLAN GBP encap/decap
        in mlx ethernet driver.

Gavin Li (4):
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
  net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
---
changelog:
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
 include/net/vxlan.h                           | 19 +++++
 8 files changed, 149 insertions(+), 51 deletions(-)

-- 
2.31.1

