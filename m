Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A196F585EFD
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbiGaM4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbiGaM4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:56:14 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E68B7F7;
        Sun, 31 Jul 2022 05:56:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBp1zV9/T/YjciRiGQmmjgV/oYtS0bKp/Vu5zIjXm4Im76tkqWvYk7bhjfO3yxWbNDCDT9zoFTaLAXRRwFAdZ8d9Q3NmWm2IF0xIV8LZhvlrXxr6K/ZKuM+/+tuyrJX+2hK2OgUz1Oy4r88ib4Z18v4GrIlhvkAlFR98Hpcp4gR1ChuIav16g03cQNF/m5ouQmvx9yws7umClVe0lUJ9xdteIcJ/hMpaBUBx6W/GagqDeCfu3AJt152o22fy5heeP396gKl/OI3+NcSSgbwWh011a48t3YmvnXzIT8OXUgN40qaroyYbY3wpCXhCDkjVAPzGtl+KfkCNrI+sQPhq0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5WLS7PFOxKaj5WrEon1xA5n1Re/oLhbVCHAUP//ik4=;
 b=ckFnnMWzGTRPyxy7P5YveNAKqxrlHOgnRgZRPKC5P/uYCsLjZvWavVtbZ1L5b7RMSvbOM2q+OIhtoijkXWctMsHzNlE7TCKJqH/+yOf1LKZEKDmwf3rI51A7hvVTyEcU+ltoB7L5xFXlH4naFQpl5hJGYPbFZcPqFoam5LKPSymvThMdjLwMUf1Sd+K8X/t/3DhHCIT2thWyWRaXY/WLFmhnyeDC+tgpRa8FIkGeZZhwVm7WFnnpdGBKxLX/pP+/y6EinWWqRgsOYFpjAAGgV5xx0j0u3bGCVOuc43PPsWOjmawChdRTqkGs3ilcwDdIEdF4brRxyKp8nGiqnjHTXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5WLS7PFOxKaj5WrEon1xA5n1Re/oLhbVCHAUP//ik4=;
 b=i0/LJT9w0gAMTcMsPAJF+A+Oiukt0/wCbtp9L9+sQ5zSaSRHz39+UWCVCLUzPDX/2ZFAZSy48nxLahPH1+ztirmX3FalNNUkwtYiat3v5VDIsX7Jtul33sWYvAi+GRXlosqHiFQFUBFxIZOEPulwfcY/6eSNdFetUWMCdIhC9saslhTHJhu5OCe9JX5kxa8nAocN0QA5iXoyPkZB74n1VBK2E9PJtevig189e3iFQsOK0h1J5d+dYEM8VcnXg9k32mM0WdzZyf6ADj50FR79O/bEZ0zx3NW1RsKhQmwms/A0M3bbV1y7WhVkdslLfHVdbcjZGcuKRm32iyraJdDiqQ==
Received: from DM6PR05CA0039.namprd05.prod.outlook.com (2603:10b6:5:335::8) by
 DM6PR12MB3161.namprd12.prod.outlook.com (2603:10b6:5:182::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.11; Sun, 31 Jul 2022 12:56:09 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::9a) by DM6PR05CA0039.outlook.office365.com
 (2603:10b6:5:335::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.15 via Frontend
 Transport; Sun, 31 Jul 2022 12:56:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Sun, 31 Jul 2022 12:56:08 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 31 Jul
 2022 12:55:55 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 31 Jul
 2022 05:55:55 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 31 Jul
 2022 05:55:52 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V3 vfio 00/11] Add device DMA logging support for mlx5 driver
Date:   Sun, 31 Jul 2022 15:54:52 +0300
Message-ID: <20220731125503.142683-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a33c687-f70b-4da4-9377-08da72f409ef
X-MS-TrafficTypeDiagnostic: DM6PR12MB3161:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uLS47x1TBeOSdOPjfmRj3ascxYigfhPsJJ2pUlcJg3FAtfXrr/5RED6oXt9A?=
 =?us-ascii?Q?HkhOcIRa8MYhFMLGlsmXQsrtWancwDeADx7mCZHUglNSU3J5CgLnajXxKVSp?=
 =?us-ascii?Q?MAmFkAiwjFaWl1DcwSgxJOHifczb7GBBOrOQvukC22cwqvVsXJ6qN4C30Ov2?=
 =?us-ascii?Q?Lwrnaq2lJD1kbSy12NCIasBx3wuvorRIcP3RCaDln0n5ndOMD5uP4cUqXOqf?=
 =?us-ascii?Q?HSMTvSXLs9oKZtmgLt2lM5yxlxqaXfUq9bILG4FP8lbt5UKd7k5Yp64xrZmf?=
 =?us-ascii?Q?A1W/XnDOH7j8swuyw/rNlSnqkYOrjvPCEjX7QVaJebDJR/T50e4AWIkj0ryX?=
 =?us-ascii?Q?P3hLhHRcyqGHKbrL+OnsD8DAmtYB7Hc/KAtTwu8fSLZCESt3gsA7EXdcndyg?=
 =?us-ascii?Q?B4ykH2fg63GQhXWCZoCg729hiTI7F6Ckzi0+3ujp/VWaTBuDnGrEQah76axA?=
 =?us-ascii?Q?QArRqfirpLKHvzjXREt0ZSXi2t2w/dB5u/4QFguDuSG3w+o8Uzuo6LRxIWwD?=
 =?us-ascii?Q?olupkiG4MGZjXV5jjtaxKBTDxuT7KXdZDLJPyxbo6mCedVrOOlQmCagpEI8i?=
 =?us-ascii?Q?3ag3+XopDPx9gyD6UKkSyTlLYUK5OaB8+2N0cajlqTL4FZAtrwlEc5zbx0xe?=
 =?us-ascii?Q?QEseJTDX9xo03yuhZyboqTUuLP3xIS8/ID38r803k5KccJJs1tdaEF2t6PFY?=
 =?us-ascii?Q?SqMbAste6J4qqPFT6eMY7T8chfmfGdPQ6T9q+vMYUaToelp6PJ3QTPsMQWH5?=
 =?us-ascii?Q?Ix0DOJtFGCmunQ3V2sOHCGQNGKq+7Rp2ddikrBP4wxZqhl/VGyf3G+PaNYm2?=
 =?us-ascii?Q?i6BjUgcl2QIWZMiBLtLuY3feH1E0NSMf9+ZnSxsnXlBfvTEb6JEKasOqmAE8?=
 =?us-ascii?Q?B1KY3PQ+amml13ODz8+1kEAmd4NwGvu9lva6dGfxvsTqyQWEBgttwNEOa0fw?=
 =?us-ascii?Q?eaCCSUJ1DnhpemAFaNVMjQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(40470700004)(46966006)(36840700001)(54906003)(6636002)(36860700001)(316002)(41300700001)(7696005)(26005)(40480700001)(82310400005)(36756003)(86362001)(83380400001)(110136005)(2906002)(4326008)(8676002)(70206006)(70586007)(478600001)(2616005)(966005)(186003)(1076003)(336012)(426003)(47076005)(40460700003)(81166007)(8936002)(356005)(5660300002)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:56:08.9535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a33c687-f70b-4da4-9377-08da72f409ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3161
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds device DMA logging uAPIs and their implementation as
part of mlx5 driver.

DMA logging allows a device to internally record what DMAs the device is
initiating and report them back to userspace. It is part of the VFIO
migration infrastructure that allows implementing dirty page tracking
during the pre copy phase of live migration. Only DMA WRITEs are logged,
and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.

The uAPIs are based on the FEATURE ioctl as were introduced earlier by
the below RFC [1] and follows the notes that were discussed in the
mailing list.

It includes:
- A PROBE option to detect if the device supports DMA logging.
- A SET option to start device DMA logging in given IOVAs ranges.
- A GET option to read back and clear the device DMA log.
- A SET option to stop device DMA logging that was previously started.

Extra details exist as part of relevant patches in the series.

In addition, the series adds some infrastructure support for managing an
IOVA bitmap done by Joao Martins.

It abstracts how an IOVA range is represented in a bitmap that is
granulated by a given page_size. So it translates all the lifting of
dealing with user pointers into its corresponding kernel addresses.
This new functionality abstracts the complexity of user/kernel bitmap
pointer usage and finally enables an API to set some bits.

This functionality will be used as part of IOMMUFD series for the system
IOMMU tracking.

Finally, we come with mlx5 implementation based on its device
specification for the DMA logging APIs.

The matching qemu changes can be previewed here [2].
They come on top of the v2 migration protocol patches that were sent
already to the mailing list.

Note:
- As this series touched mlx5_core parts we may need to send the
  net/mlx5 patches as a pull request format to VFIO to avoid conflicts
  before acceptance.

[1] https://lore.kernel.org/all/20220501123301.127279-1-yishaih@nvidia.com/T/
[2] https://github.com/avihai1122/qemu/commits/device_dirty_tracking

Changes from V2: https://lore.kernel.org/netdev/20220726151232.GF4438@nvidia.com/t/
Patch #1
- Add some reserved fields that were missed.
Patch #3:
- Improve the UAPI documentation in few places as was asked by Alex and
  Kevin, based on the discussion in the mailing list.
Patch #5:
- Improvements from Joao for his IOVA bitmap patch to be
  cleaner/simpler as was asked by Alex. It includes the below:
   * Make iova_to_index and index_to_iova fully symmetrical.
   * Use 'sizeof(*iter->data) * BITS_PER_BYTE' in both index_to_iova
     and iova_to_index.
   * Remove iova_bitmap_init() and just stay with iova_bitmap_iter_init().
   * s/left/remaining/
   * To not use @remaining variable for both index and iova/length.
   * Remove stale comment on max dirty bitmap bits.
   * Remove DIV_ROUNDUP from iova_to_index() helper and replace with a
     division.
   * Use iova rather than length where appropriate, while noting with
     commentary the usage of length as next relative IOVA.
   * Rework pinning to be internal and remove that from the iova iter
     API caller.
   * get() and put() now teardown iova_bitmap::dirty npages.
   * Move unnecessary includes into the C file.
   * Add theory of operation and theory of usage in the header file.
   * Add more comments on private helpers on less obvious logic
   * Add documentation on all public APIs.
  * Change commit to reflect new usage of APIs.
Patch #6:
- Drop the hard-coded 1024 for LOG_MAX_RANGES and replace to consider
  PAGE_SIZE as was suggested by Jason.
- Return -E2BIG as Alex suggested.
- Adapt the loop upon logging report to new IOVA bit map stuff.

Changes from V1: https://lore.kernel.org/netdev/202207052209.x00Iykkp-lkp@intel.com/T/

- Patch #6: Fix a note given by krobot, select INTERVAL_TREE for VFIO.

Changes from V0: https://lore.kernel.org/netdev/202207011231.1oPQhSzo-lkp@intel.com/T/

- Drop the first 2 patches that Alex merged already.
- Fix a note given by krobot, based on Jason's suggestion.
- Some improvements from Joao for his IOVA bitmap patch to be
  cleaner/simpler. It includes the below:
    * Rename iova_bitmap_array_length to iova_bitmap_iova_to_index.
    * Rename iova_bitmap_index_to_length to iova_bitmap_index_to_iova.
    * Change iova_bitmap_iova_to_index to take an iova_bitmap_iter
      as an argument to pair with iova_bitmap_index_to_length.
    * Make iova_bitmap_iter_done() use >= instead of
      substraction+comparison. This fixes iova_bitmap_iter_done()
      return as it was previously returning when !done.
    * Remove iova_bitmap_iter_length().
    * Simplify iova_bitmap_length() overcomplicated trailing end check
    * Convert all sizeof(u64) into sizeof(*iter->data).
    * Use u64 __user for ::data instead of void in both struct and
      initialization of iova_bitmap.

Yishai

Jason Gunthorpe (1):
  vfio: Move vfio.c to vfio_main.c

Joao Martins (1):
  vfio: Add an IOVA bitmap support

Yishai Hadas (9):
  net/mlx5: Introduce ifc bits for page tracker
  net/mlx5: Query ADV_VIRTUALIZATION capabilities
  vfio: Introduce DMA logging uAPIs
  vfio: Introduce the DMA logging feature support
  vfio/mlx5: Init QP based resources for dirty tracking
  vfio/mlx5: Create and destroy page tracker object
  vfio/mlx5: Report dirty pages from tracker
  vfio/mlx5: Manage error scenarios on tracker
  vfio/mlx5: Set the driver DMA logging callbacks

 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
 drivers/vfio/Kconfig                          |   1 +
 drivers/vfio/Makefile                         |   4 +
 drivers/vfio/iova_bitmap.c                    | 224 ++++
 drivers/vfio/pci/mlx5/cmd.c                   | 995 +++++++++++++++++-
 drivers/vfio/pci/mlx5/cmd.h                   |  63 +-
 drivers/vfio/pci/mlx5/main.c                  |   9 +-
 drivers/vfio/pci/vfio_pci_core.c              |   5 +
 drivers/vfio/{vfio.c => vfio_main.c}          | 159 +++
 include/linux/iova_bitmap.h                   | 189 ++++
 include/linux/mlx5/device.h                   |   9 +
 include/linux/mlx5/mlx5_ifc.h                 |  82 +-
 include/linux/vfio.h                          |  21 +-
 include/uapi/linux/vfio.h                     |  88 ++
 15 files changed, 1838 insertions(+), 18 deletions(-)
 create mode 100644 drivers/vfio/iova_bitmap.c
 rename drivers/vfio/{vfio.c => vfio_main.c} (93%)
 create mode 100644 include/linux/iova_bitmap.h

-- 
2.18.1

