Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CD3640217
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiLBI37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiLBI3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:29:12 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E26A9E8A
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:26:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBBvdID63h+vr20O77As0ReE7QCJAvOild2N4y4eMf5+CpDOK3pAYpmqZMiUacB4r9zJIhNIzUolRm6WqOnevkwhy9q/rNDR2zP1DOGsdm7SLyYAp+1zwLOPsmpxw6nFEnKoShfIl6/e+fSqayozCvLrKwqTQhrhkcCHeAi1EEsSwbr+VnOg9QS5ah4lTV1609Ink3DxQ/6xYqHM/PgaGTofqUROFTgcw2qQIgh3uEkFk7j6otVTrDSyAB84exTZLp7o7zSd+fsjFylt4qqwohK45xb2KygiFrwplGJynw6j0efd7VVzNfPn6skLS6o14w6uQZEXjYzC4WVD4jNnng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFuATbyOS0cQmz91yBhQy42hY0HX7xSdXaZvA1w0eZs=;
 b=m+ptNjLDrLNEVaN2T0fYGVfAjMtY6ccnGFzY7UPFzjOe+9ErFil+J0mh9ZLqw7rF9s3+m/83ixqhwTUl2T3DNmk/3oec8wBSE6GoF6Z/YQ5GQOITJQrMbxoNXrvE0lhh9WV6Wkjrb/sIfViL323GGcVR/YpmQBaoArStC7EN6xEzCwWc0JpKNuu994KbXn5V2aGBR5iTHa0YO73TCu0UoWDjiSllxSDuV1WMtCzQezhKf2N1ltLS3LMshfg9TV1d3svGj0wVv4g0C7a5wRj+JVn3VZBlzFsTpcFNTfL3cm45m8ZvhnJdyVAGnWbpJgZdIh73B6XBQZQBVmGay6YcvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFuATbyOS0cQmz91yBhQy42hY0HX7xSdXaZvA1w0eZs=;
 b=ktBtrilOSH16GtgOUVGrqR4PhAB55G1oCdTFBzawzX3J3BfaA2gi55LXpXUQ5SelnWonR+X9WUEEsnQSzCN5jqA/C4iazmFku+N5E0b20ud7h7Xcn5Uvq53SzDhZV0Hfkn65gBFjZyIPz3uS+WCpTAf2KuoGDp7doiIIrmYVdSS6OlrC1F3yLcgjpV8npk2gQUI1bT037qQdN3EgC6H7GNtCHPF2c1S7QSEDPCFF+okrp8naXxdIKqcdOEVdnugNpfEZytcmLptdHWqUDMS9Er11jnU2/8VDUrtrWXUFoQRPZ96Blw9/bkMXDen/uD7F4j/B7fW5CayC8qjFHJ5Zxg==
Received: from DM6PR21CA0018.namprd21.prod.outlook.com (2603:10b6:5:174::28)
 by MN0PR12MB6125.namprd12.prod.outlook.com (2603:10b6:208:3c7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 08:26:40 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::c1) by DM6PR21CA0018.outlook.office365.com
 (2603:10b6:5:174::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8 via Frontend
 Transport; Fri, 2 Dec 2022 08:26:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.21 via Frontend Transport; Fri, 2 Dec 2022 08:26:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 2 Dec 2022
 00:26:33 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 2 Dec 2022 00:26:30 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next V2 0/8] devlink: Add port function attribute to enable/disable Roce and migratable
Date:   Fri, 2 Dec 2022 10:26:14 +0200
Message-ID: <20221202082622.57765-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT037:EE_|MN0PR12MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: c2362250-5034-4c78-455a-08dad43eefad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nE/clLVhNzx7Q9MrBoVxrgy0as6hXKtWXomBktmQhCmuHj2mWecmhjd4bkngbFW4ZwWuIMP6x1rhaoLeDmVmWLKUaIlXGWD9avU1uHZGp0izA2DeCYR9PjeWmzpVcED2yxyJh7+xP0RC5KL8XZWOPlJa5z2KeGs6Bfsg3HS6Pm0rYe4WYw+yowiVRBYHB1/7G42vQfwbaIFybOj9lKwZmvFGRwTwgaf/plQnSyzFQaiApRE6V6jdsE/Pcrr09nAVEaaUpx06VtuNbt5H4UoEHpDUngOmCJdvtAi9XVA2E5uHHBzSRE1adJj7WAT2YVOqEfSoWrwvWDArwDtGTk3DW5AuOkKB2d94LNsnfzLgX9EqqyrRP9Gj7qvVKrjnjcpxZmBI2MtbXQGHxc3XkpUqlhxzRlHxJwIGADavRVDqxiajPZBXgkzBium2dXadtnKHaKnDUqFX3ftssoWHBLqsmxVzWaJ6eEb0MafkPJ4E4l7Nyv9C08xwcLtaJ+tuL6ID462YhBxcpZ2Z+V/Hxb87xYdnDTmMWHpUwAHJ2wHuJZbSJHSL4jSU1iAQLT6C9JS1x+B8S/cMPjHiNmqUCVJC27uLlDXZyyWhP8i0xBpQhJ07df2lAV9TgMbHLPZgt/lticRaBh28Lo2Lr6gEhDBZpJ+RzfJe5wrJqcLLMsOR5RHw2Sl61+8On4SkWY1+6hNE/Me6PQBqrBo3LaRjZ5WSH6F8CdezFwWBVm3QFEYDc/FbcqXlXvl3TvWbWq3GuuQcYHJQ9hr/TBWdN+1mss2oB+t/ghPG3YK/cHPgNXvS5G0=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199015)(36840700001)(46966006)(40470700004)(7636003)(40480700001)(40460700003)(356005)(6666004)(2906002)(36756003)(2616005)(107886003)(86362001)(16526019)(966005)(478600001)(186003)(8936002)(36860700001)(26005)(316002)(70586007)(5660300002)(41300700001)(70206006)(110136005)(4326008)(54906003)(8676002)(82740400003)(336012)(1076003)(82310400005)(83380400001)(47076005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:26:39.9111
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2362250-5034-4c78-455a-08dad43eefad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6125
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is a complete rewrite of the series "devlink: Add port
function attribute to enable/disable roce"
link:
https://lore.kernel.org/netdev/20221102163954.279266-1-danielj@nvidia.com/

Currently mlx5 PCI VF and SF are enabled by default for RoCE
functionality. And mlx5 PCI VF is disable by dafault for migratable
functionality.

Currently a user does not have the ability to disable RoCE for a PCI
VF/SF device before such device is enumerated by the driver.

User is also incapable to do such setting from smartnic scenario for a
VF from the smartnic.

Current 'enable_roce' device knob is limited to do setting only at
driverinit time. By this time device is already created and firmware has
already allocated necessary system memory for supporting RoCE.

Also, Currently a user does not have the ability to enable migratable
for a PCI VF.

The above are a hyper visor level control, to set the functionality of
devices passed through to guests.

This is achieved by extending existing 'port function' object to control
capabilities of a function. This enables users to control capability of
the device before enumeration.

Examples when user prefers to disable RoCE for a VF when using switchdev
mode:

$ devlink port show pci/0000:06:00.0/1
pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller 0
pfnum 0 vfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 roce enable

$ devlink port function set pci/0000:06:00.0/1 roce disable
  
$ devlink port show pci/0000:06:00.0/1
pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller 0
pfnum 0 vfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 roce disable

FAQs:
-----
1. What does roce enable/disable do?
Ans: It disables RoCE capability of the function before its enumerated,
so when driver reads the capability from the device firmware, it is
disabled.
At this point RDMA stack will not be able to create UD, QP1, RC, XRC
type of QPs. When RoCE is disabled, the GID table of all ports of the
device is disabled in the device and software stack.

2. How is the roce 'port function' option different from existing
devlink param?
Ans: RoCE attribute at the port function level disables the RoCE
capability at the specific function level; while enable_roce only does
at the software level.

3. Why is this option for disabling only RoCE and not the whole RDMA
device?
Ans: Because user still wants to use the RDMA device for non RoCE
commands in more memory efficient way.

Patch summary:
Patch-1 introduce ifc bits for migratable command
Patch-2 avoid partial port function request processing
Patch-3 move devlink hw_addr attribute doc to devlink file
Patch-4 adds devlink attribute to control roce
Patch-5 add generic setters/getters for other functions caps 
Patch-6 implements mlx5 callbacks for roce control
Patch-7 adds devlink attribute to control migratable
Patch-8 implements mlx5 callbacks for migratable control

---
v1->v2:
 - see patch 7 for a changelog.

Shay Drory (6):
  devlink: Validate port function request
  devlink: Move devlink port function hw_addr attr documentation
  devlink: Expose port function commands to control RoCE
  net/mlx5: Add generic getters for other functions caps
  devlink: Expose port function commands to control migratable
  net/mlx5: E-Switch, Implement devlink port function cmds to control
    migratable

Yishai Hadas (2):
  net/mlx5: Introduce IFC bits for migratable
  net/mlx5: E-Switch, Implement devlink port function cmds to control
    RoCE

 .../device_drivers/ethernet/mellanox/mlx5.rst |  46 ++--
 .../networking/devlink/devlink-port.rst       | 120 +++++++++-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   4 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  43 ++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  11 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 210 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |   3 +-
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  30 ++-
 include/linux/mlx5/mlx5_ifc.h                 |   6 +-
 include/linux/mlx5/vport.h                    |   2 +
 include/net/devlink.h                         |  40 ++++
 include/uapi/linux/devlink.h                  |  13 ++
 net/core/devlink.c                            | 195 +++++++++++++++-
 14 files changed, 682 insertions(+), 46 deletions(-)

-- 
2.38.1

