Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDFA6EA897
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 12:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjDUKto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 06:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjDUKtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 06:49:43 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59FF83D7
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:49:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkw+6JqVrr4l4nAlFAbs0qE/RD1wmIds0iRRdmpQSVg+/e6mw63eNQzyJdnZVNf4HOh2lRJucGoj2KKlf173ozn3YjvowXLYQVvbYGRGAiTn1t0Tyhi6YJODp0J0cH/wvXr1q86ish9AFPB6FwFpeKQyyXWlzwIiiuSyJEQHr3liQOFwmr0S/HYE5o2BY65pSyqlNHXPDDf75xdZNILSOd/29GoFVklabDH9A+VRXqyK7yt095hpMrAbJJYxyQOCVvkxgn9C/UShj7O7caBhRO0ZvXHtooL1C0OhxxIZevRZ4ualzP8MeZvJuujdUF9HCbX97ODhQnS67RHGZRbgYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+prxzMgZ5dOFmvHgTuj+mksCSR0U7t0aqRUpPY+S1H8=;
 b=oLXXDpU5d/MMc0TZZOcRHfsHFtgDMsGS0vHOR68qLi4kXoXhJuJ9swI7cX6Ur9TTxZPu41U1/jk1NHfF2WYOF8ZJilWEFHXRUk4OkuqmlM01+2dB/ChFh7zSeYZW/4+U5IXPgclxCEtXXvasv/5jImRYwxRdwNw3HlYoCRivT/hhcPZ7+OC9/yw/eihsTI3yZlIG3k3OiInQ2zGnZR51dTrZEgsUBBchA3bmVXSjvUloI0CKvicqEvItESpXZv0ONPjrz3ncSpdRceK5m1QcABnS9IuwP1z8608PHdKdAlmaoV/eyytVVLc31Z4lnlDulzLI9idsI419XV0xs+5J7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+prxzMgZ5dOFmvHgTuj+mksCSR0U7t0aqRUpPY+S1H8=;
 b=W/2NZfjEVtv3DyflUYv8rZImyOYq/S/3mbWZsga2Mhz3LdVIq36R6dHkeju88GomvxQj53/3JiInPGBJg97JKonH2LWdVVaVmAjOmrtZfUJdUVMO4RSNVvIz6SJETrySOgkG7XPfkgxfCwYVz89RlMpVyLb1leV/OCYBogWfTheg0bAklu/JS9+tgsbHMswhpJAxivvjDiP8q+ClMrxVLAiyTf9SHCTuFcib8qjUr17yNQRPPbx8x7tdEJEVJA6CSL1pxCVLEGtlhs63MfObAnJJKATrZDZGFu/q+0NFM5yaE0xHd1Yhz66lG2iwyDxZfAY64CqeJxCB2TGdUwMjNg==
Received: from DS7PR03CA0344.namprd03.prod.outlook.com (2603:10b6:8:55::28) by
 DM4PR12MB5216.namprd12.prod.outlook.com (2603:10b6:5:398::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22; Fri, 21 Apr 2023 10:49:38 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::95) by DS7PR03CA0344.outlook.office365.com
 (2603:10b6:8:55::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Fri, 21 Apr 2023 10:49:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 10:49:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 03:49:32 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 21 Apr 2023 03:49:31 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 03:49:29 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH net-next V2 0/4] devlink: Add port function attributes
Date:   Fri, 21 Apr 2023 13:48:57 +0300
Message-ID: <20230421104901.897946-1-dchumak@nvidia.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT067:EE_|DM4PR12MB5216:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f931837-cf2f-45b9-b8a6-08db42561a61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wUU8HkNwnLI0FKYyU/NijvjRhYmTnLsjPiShEeMtQe3y5EGLqB/FpDinxcDd4B5ADkRMisDEODQ52CWzjtp276d5eBbUgUCgxJQ9oLv1FbM31VBe4sJe9+8+pUHTv0XmpxJJHVRja/4CDlQd1rfVJPWP1ww1I+cbMjil3nMQWFFyibm2kajszk/3hdzeik+Drs5Ee/iMdsJQ0urPifyzIHx+Ph8Q5EtVTPXLLiK5R3Z7c9klj6IT4xM3e3TMboMmMMUoxz6ne+IeaQtwhaa5nci9Bzvf/Y5ry15Ipq2rXHdCZL0zHETHea//B0rJIjyQ4YzHu/HNegPV4HyNphtZUoIkF888kO3cCaRcWjAVH7KScGKoy/SJbic1ApHhU4r/TKGuV4VQCCCRh0t+DTjgBOXfqkdbtum4bS+38gDtxzLXY6UWXzOArT+DTEVr0SwBBNX8Ca/Tbxohxr4V++bp+BiKgu8A6JwKaTq2RxniOdmi8X+AJ/G5J3PcM3lb/69gsIZqVQmEVdlX9R8ExCxt12yzNDny4+WUgcapNmE2wOcZrQknheVZbYUBpZyzmrUuXojT3vt0zhlzmPCX2VJU4M4e0uSrqZH0eD51CcYsEQxMHe0+wyQrsmEDD9fxKqwZGvIA12IDgfSbYi1wJTeXChpcuvShOo5M6gJk5fMGkoD6QMIykKXNIW7BxeoZw+0AnHeJWx8E71Ik0cuWA3L/u4GnlMv3xNzf+4QL4BALVARyWsVBm4dUXihUCpgQYGvkN4lRlOVWBiICBpTKBfq1ag9LwgALl2I+rRbHwxyR6Fo=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(2906002)(8936002)(8676002)(356005)(7636003)(86362001)(5660300002)(82310400005)(36756003)(41300700001)(40480700001)(7696005)(1076003)(6666004)(26005)(107886003)(54906003)(34020700004)(2616005)(36860700001)(478600001)(83380400001)(47076005)(426003)(82740400003)(336012)(186003)(316002)(70586007)(110136005)(70206006)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 10:49:37.8727
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f931837-cf2f-45b9-b8a6-08db42561a61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5216
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce hypervisor-level control knobs to set the functionality of PCI
VF devices passed through to guests. The administrator of a hypervisor
host may choose to change the settings of a port function from the
defaults configured by the device firmware.

The software stack has two types of IPsec offload - crypto and packet.
Specifically, the ip xfrm command has sub-commands for "state" and
"policy" that have an "offload" parameter. With ip xfrm state, both
crypto and packet offload types are supported, while ip xfrm policy can
only be offloaded in packet mode.

The series introduces two new boolean attributes of a port function:
ipsec_crypto and ipsec_packet. The goal is to provide a similar level of
granularity for controlling VF IPsec offload capabilities, which would
be aligned with the software model. This will allow users to decide if
they want both types of offload enabled for a VF, just one of them, or
none at all (which is the default).

At a high level, the difference between the two knobs is that with
ipsec_crypto, only XFRM state can be offloaded. Specifically, only the
crypto operation (Encrypt/Decrypt) is offloaded. With ipsec_packet, both
XFRM state and policy can be offloaded. Furthermore, in addition to
crypto operation offload, IPsec encapsulation is also offloaded. For
XFRM state, choosing between crypto and packet offload types is
possible. From the HW perspective, different resources may be required
for each offload type.

Examples of when a user prefers to enable IPsec packet offload for a VF
when using switchdev mode:

  $ devlink port show pci/0000:06:00.0/1
      pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
          function:
          hw_addr 00:00:00:00:00:00 roce enable migratable disable ipsec_crypto disable ipsec_packet disable

  $ devlink port function set pci/0000:06:00.0/1 ipsec_packet enable

  $ devlink port show pci/0000:06:00.0/1
      pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
          function:
          hw_addr 00:00:00:00:00:00 roce enable migratable disable ipsec_crypto disable ipsec_packet enable

This enables the corresponding IPsec capability of the function before
it's enumerated, so when the driver reads the capability from the device
firmware, it is enabled. The driver is then able to configure
corresponding features and ops of the VF net device to support IPsec
state and policy offloading.

---
v1 -> v2:
 - improve docs of ipsec_crypto vs ipsec_packet devlink attribues
 - also see patches 2,4 for the changelog.

Dima Chumak (4):
  devlink: Expose port function commands to control IPsec crypto
    offloads
  net/mlx5: Implement devlink port function cmds to control ipsec_crypto
  devlink: Expose port function commands to control IPsec packet
    offloads
  net/mlx5: Implement devlink port function cmds to control ipsec_packet

 .../ethernet/mellanox/mlx5/switchdev.rst      |  16 +
 .../networking/devlink/devlink-port.rst       |  55 +++
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   8 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  18 +
 .../ethernet/mellanox/mlx5/core/esw/ipsec.c   | 388 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  34 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  31 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 208 ++++++++++
 .../ethernet/mellanox/mlx5/core/lib/ipsec.h   |  41 ++
 include/linux/mlx5/driver.h                   |   1 +
 include/linux/mlx5/mlx5_ifc.h                 |   3 +
 include/net/devlink.h                         |  42 ++
 include/uapi/linux/devlink.h                  |   4 +
 net/devlink/leftover.c                        | 110 +++++
 15 files changed, 959 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec.h

-- 
2.40.0

