Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98A6593157
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242597AbiHOPME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242617AbiHOPL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:11:58 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930DE24F16;
        Mon, 15 Aug 2022 08:11:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7gjIXRhQZsNs3RVu9lrLG5E6e6+4/+mbAxo5YpPkK9RBQwlXhEf69jGPNoufEpUZW9vp1gD+6N9jpRAH93vKrWNqemAvr7VHLCyifxm4EalklSYWaQCxTvz2VrIvK4JtWQxtkd6ANLJoYyFdy1mNrbhNLL4/FJ5i6DMbY8mqrgYKs4uFfOPKUuwWekVWWSvsB2eMHHT5YhyzfvyLMI9aDXrbTaMOVKPMonWypbCpKiDACHYwywxZwxPpFyD/X6+7gKdDUoG5Wl5MX5oKPVqL1wWwmjeHriBAyA6TFgzvY9+Ci5gw4cVjifKvgkZZOxSqvMUiIcmra3ZVaudEZkFPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DHCyaWIE1HYyaZbD9IWtVA0Fy97wTSqp4X3VmmDRNYk=;
 b=jI7DFkKQaIyj6vdOYGKHwfILisXO5WTUYZeOT0dKVLzWGJK6X83UTqomC3a6hlK2WwYqiOuu4QG+ZrCXBPgUNwtyZNCd1uMvDOFAkApQM0oDAIU9JwTsXhjwk8EwS0P1xX8CBSe3L5QTHSnvgaw21OnJ2jbvF53kM/pcxRsA9DRQYVegCe5ycvbTaqs2M6CIgn/OuCibwbCXwwSosP3hDO+sgLXBkAylz/odHP05OsDTuUvILq2518bwz50Z6SzaCuFais88xTgOz1hUsRey47EiDbKzqnGu6LS4IqjMf2UuMaBOLEe04vjtPfygZnimCxaggjURu/wdgL31db6+kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHCyaWIE1HYyaZbD9IWtVA0Fy97wTSqp4X3VmmDRNYk=;
 b=Krf5AUkAEJ6k+ElEwPJj2/IH/8Y7pg1NBIULVQQRcK6G3w8fbp7oxSH+d/yn7Phqmct9yREQSoxm6Gja3yAK1qNs6YVryKW6jDSmSYSnk2vv+6FA431d3hofsCE+FseGX2kXJTtW5pbk9tHv9B+eIh+jtGlIvdQnNDzsCpvT4SUjafz0UHXgdBIMEgoOHwbmJUt+C2/H5OgbYj8YKLvAHXFPdrsbStz1645SO2IasIxCJw1y1eNyFbyWvyfq073Jd6h3XvZUYlxEQNm437oNUkdR6NK445M6KBGiOyWkuohR2TRUcP0SViXplwDWSLDddOcneYYOEbHIYc+dfmRnaA==
Received: from DM6PR01CA0015.prod.exchangelabs.com (2603:10b6:5:296::20) by
 SJ1PR12MB6289.namprd12.prod.outlook.com (2603:10b6:a03:458::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Mon, 15 Aug
 2022 15:11:42 +0000
Received: from DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::13) by DM6PR01CA0015.outlook.office365.com
 (2603:10b6:5:296::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10 via Frontend
 Transport; Mon, 15 Aug 2022 15:11:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT093.mail.protection.outlook.com (10.13.172.235) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Mon, 15 Aug 2022 15:11:41 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 15:11:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 08:11:40 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 08:11:37 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V4 vfio 00/10] Add device DMA logging support for mlx5 driver
Date:   Mon, 15 Aug 2022 18:10:59 +0300
Message-ID: <20220815151109.180403-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2044edb-37e2-4301-2d82-08da7ed075b4
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6289:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?twifONg2JdIw+Z15B43oOm9dZLNR+ORsVXgPlmuNAuKudNeEu5cjLA5r/CFo?=
 =?us-ascii?Q?4uObrmPDILrtRcRx76V+E0dHr5nW+T5tWlyurVjDgfmOzUCxb8bsZE+2sb1l?=
 =?us-ascii?Q?9kBbLTGFhUWdIYARwVMzz7pett0MX+hKX+m9g6fB9ik9rxnb8ieZnyAGI7EP?=
 =?us-ascii?Q?OfPf/j1ZxXQCNdCu+c/V94MQlGE2ecW7TpyvOlN4iOtXjsRt3QzIK1zQxdQR?=
 =?us-ascii?Q?X7MJjcsFdTaLdJPFBNsRQ2qmnCMkmMqCUCGDcmcbhzXgljCDjHOm9PH6YhYz?=
 =?us-ascii?Q?hEDdVZ/pviQuqKmWe8d+dczadN0dD/Bya8v5Y7XHN4AoDQmghxAwQSM8Hlgk?=
 =?us-ascii?Q?iTyzqfjTp/lIvwDVgjh863dZqy9dtQ9LLK66ilM5fXcPjC4aiugN5kzWl19e?=
 =?us-ascii?Q?6dXouVVCRyAXY9MdztSlyYg/GgfB3VOPdnxMKJYgsCFmAvLPsXo1324SFbOZ?=
 =?us-ascii?Q?P6Ee5LPRZ+6gIWGyLKPQfWjBRF0H+Jw/6+F/k5Inc9iUSGlThepiYuW5wLsO?=
 =?us-ascii?Q?HbEgmHk/08+SeO2R3N/rOODkIzOTnKkXlidZEeh16ygbT04pEYbcgn5rHLxx?=
 =?us-ascii?Q?3pFmrs0iNzNXloWyzxY5H/aWvcqJeKa4OAQDQ81aUt+yBYWDa4L3acClCQgQ?=
 =?us-ascii?Q?q0lUw0LMyZ0uQDJvYitNLMdgnbmhubTJiQ7fZyMmzm6vDoICsS+CN/IWXW8U?=
 =?us-ascii?Q?vVKEKlXeqKdJm/Vfz6Ffpjh3nQ+RuaSVWLb4FMhWbUChtG8aE3O3Dudq+ETL?=
 =?us-ascii?Q?nucI+Ap3vj3fsCeWVMtdjQbBQ4V7ehncgzbY03heoi/uGGe2huJ0vFNkicst?=
 =?us-ascii?Q?RoYzYpRU4aFGJus74TN7DLPb+1bz0wkyslXcFT9l50JhZIRa7M7tLn2TdBMy?=
 =?us-ascii?Q?DIgrfS92zKNdeKPaWUr9/Qy1xJvSnRXQ0okuaKk3w/GeeCR8IVeeIKZ5QnZG?=
 =?us-ascii?Q?OGz7dyFqBCgQI9SyIu774w=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(376002)(396003)(40470700004)(46966006)(36840700001)(316002)(336012)(54906003)(1076003)(186003)(7696005)(110136005)(41300700001)(426003)(6666004)(966005)(26005)(82310400005)(478600001)(6636002)(86362001)(2616005)(47076005)(40460700003)(82740400003)(40480700001)(83380400001)(356005)(81166007)(5660300002)(70586007)(36756003)(70206006)(8936002)(4326008)(8676002)(2906002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 15:11:41.8136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2044edb-37e2-4301-2d82-08da7ed075b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6289
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

Changes from V3: https://lore.kernel.org/all/202207011231.1oPQhSzo-lkp@intel.com/t/
Rebase on top of v6.0 rc1.
Patch #3:
- Drop the documentation note regarding the 'atomic OR' usage of the bitmap
  as part of VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT.
  This deletion was missed as part of V3 to match kernel code.
  To better clarify, as part of testing V3, we could see a big penalty in
  performance (*2 in some cases) when the iova bitmap patch used atomic
  bit operations. As QEMU doesn't really share bitmaps between multiple
  trackers we saw no reason to use atomics and get a bad performance.
  If in the future, will be a real use case that will justify it, we can
  come with VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT_ATOMIC new option with
  the matching kernel code.
Patch #4:
- The rename patch from vfio.c to vfio_main.c was accepted already, not
  part of this series anymore.

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
 drivers/vfio/Makefile                         |   6 +-
 drivers/vfio/iova_bitmap.c                    | 224 ++++
 drivers/vfio/pci/mlx5/cmd.c                   | 995 +++++++++++++++++-
 drivers/vfio/pci/mlx5/cmd.h                   |  63 +-
 drivers/vfio/pci/mlx5/main.c                  |   9 +-
 drivers/vfio/pci/vfio_pci_core.c              |   5 +
 drivers/vfio/vfio_main.c                      | 159 +++
 include/linux/iova_bitmap.h                   | 189 ++++
 include/linux/mlx5/device.h                   |   9 +
 include/linux/mlx5/mlx5_ifc.h                 |  83 +-
 include/linux/vfio.h                          |  21 +-
 include/uapi/linux/vfio.h                     |  86 ++
 15 files changed, 1837 insertions(+), 20 deletions(-)
 create mode 100644 drivers/vfio/iova_bitmap.c
 create mode 100644 include/linux/iova_bitmap.h

-- 
2.18.1

