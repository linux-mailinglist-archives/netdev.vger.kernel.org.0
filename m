Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7856AFE49
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCHFZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCHFZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:25:08 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74127911E5;
        Tue,  7 Mar 2023 21:25:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWfk8sAiIXV6sqf3ry6HrjISHVbT5bxwkj42eORoY2V6qG0PWkr7z/Y1W7MU1TyCXH2Sw5p6gdVvsExysHd46dT7y+HQkmaMM15hUNcN2BGPK0sAb7Au2byEHc+DaL/TqkgsFRRf03hV1r7zBy9re3AWbmZaLpXWpjLubSaJk4ufG186lPDSugD2v0+uYIliH3P68pIwbuMp7IG3Kulj27ORPEPQAVN/oISHSMrfkGq+8foSSeNqT5NNaCu6JCq4PwX6UShdG8LoVWj+mpMuhbsUfCFMAeQqfoZ4kYX6B2eE/5Wg5jdZhg5kxddRZ0kdWO9g1TejUp31T77QpXDxMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytGuvEctVYnb3RSveQg/1Iv61awZleXfYcpvm6fge/0=;
 b=ME+lMUIlKeqkP+/VOgOt2G8Sp8/den3QhYQGTcBBNW9rBt6M7Lcl9/i5FufGZJ/ETpWbyABJ0QD8v8DQscBYY3DtE/jwVETj+LrulVQiYi2Q8ngGGsRuhoMAte+2fazCutMm5HjHJnl4VfP7pzxUYt5sd86zy1guwoMtgJkFJie/CpD848Spe5zGKdx/wLzVi9RNqOaxvZZqGkzDhTo/Qb24qR4lhpQjf+BJCs6KDTkuqALvfnq8OFB5wyaBkTjGwMnkgdR7mqJBCLeTSNM7Y2ECyU2YvcLmLOJOrj6KwJre1msbRAnJHTsEsbHRUe9Od4atMXOfvd675VrgCREr3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytGuvEctVYnb3RSveQg/1Iv61awZleXfYcpvm6fge/0=;
 b=u5mMLOKV4EMeig8xYnAS7vjASBkuWEEebnBqo7NIoSYvyPCdZNi4wMGlxwPT+4LdfNr+KEppcyi6Vutc6DiaXG/OQj3swq9Dl2nv551JymGdURhHHX+GRzM+O6NpgkSO1tlxMC9IX6HOHdeSCNcxZFzmbh0R6YjwAr5R1I0OVWo=
Received: from BN1PR10CA0003.namprd10.prod.outlook.com (2603:10b6:408:e0::8)
 by IA1PR12MB7759.namprd12.prod.outlook.com (2603:10b6:208:420::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 05:25:04 +0000
Received: from BN8NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::4a) by BN1PR10CA0003.outlook.office365.com
 (2603:10b6:408:e0::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 05:25:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT089.mail.protection.outlook.com (10.13.176.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Wed, 8 Mar 2023 05:25:03 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:25:02 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [RFC PATCH v4 0/7] pds vfio driver
Date:   Tue, 7 Mar 2023 21:24:43 -0800
Message-ID: <20230308052450.13421-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT089:EE_|IA1PR12MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: 04482ba6-ca34-4254-2a7d-08db1f9578c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mvUi1ypCAM7pYRvs/C0JKShfSnCzvOYhWBmu67EU8esoLHtPvnvXbqFI0MoPh5x/oUpyOhZnH3mytiC76rgvajFdSCd/mkn+3+TddERXk3sCS3Bvk5mh7GWno6hjjPjmn4kGUJ88E7YynVIsKVNVcKJ5RTgaW5t5ZxjeaiirCSNKYs6vkmAn4xj+mwlKXMYTOJEd7yyQIapKQ96RAK5ggYNPnUomsCHGi+9SyRMbjFx4+d3TjNYFgMAzxkPb+sjc2/xIyJ8BEm6L4ToG3dnnkxkd3gT+EQBQb3H3PTyV9/4Vhqs4UOz7VbjNjKv2Weh+XMxFHl7/nQoyBCZKGIr5OYv6s2rQdGBoWV7jb95Pb054V0+SbkO3UXOyUEVygIxDbU2Nobx0v2TXY2fS04/ClTBk7JsTxVfhOvtI7aOY+R8CHaeDhswXnhZSOgX0HUglpzM2dVudO8wHler6Wmo7MCdZ7YI6dhfJ8D7Tymc0KP02AuBi/zDmEznHMV1cYHR8zwfduc2m2ErOLfqFfkfSGzJEXZLmB6Cg1GaPHPojLfjXHEfEX5t+sxveRhJhfQjPnkoKb1ycsVVVkdTjLkoOIwkkRZ6a+upC7QO78BSTYCTG3mE93yg4hb6okpDu0Kd1SjxiK448UR5iuJSSwYBABdRp0Sy9NuoaG6hBh0/JM50bxtSHGKSR8BJh4bRbgShVOkD3GIXzyqUv0visW0yH7eAUUXZAxFuKRhg5M3IXsc3yLKdIJc2i78YN1ctOMjxskJFZJDryA7iVzBu9D5Kxxw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199018)(40470700004)(46966006)(36840700001)(336012)(426003)(47076005)(54906003)(316002)(110136005)(36756003)(40460700003)(40480700001)(356005)(86362001)(81166007)(82740400003)(36860700001)(1076003)(83380400001)(82310400005)(26005)(6666004)(186003)(16526019)(2616005)(5660300002)(966005)(478600001)(4326008)(41300700001)(8936002)(44832011)(2906002)(70586007)(70206006)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:25:03.9298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04482ba6-ca34-4254-2a7d-08db1f9578c4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7759
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a draft patchset for a new vendor specific VFIO driver
(pds_vfio) for use with the AMD/Pensando Distributed Services Card
(DSC). This driver is a client of the newly introduced pds_core
driver, which the latest version can be referenced at:

https://lore.kernel.org/netdev/20230308051310.12544-1-shannon.nelson@amd.com/

This driver will use the pds_core device's adminq as the VFIO
control path to the DSC. In order to make adminq calls, the VFIO
instance makes use of functions exported by the pds_core driver.

In order to receive events from pds_core, the pds_vfio driver
registers to a private notifier. This is needed for various events
that come from the device.

An ASCII diagram of a VFIO instance looks something like this and can
be used with the VFIO subsystem to provide the VF device VFIO and live
migration support.

                               .------.  .-----------------------.
                               | QEMU |--|  VM  .-------------.  |
                               '......'  |      |   Eth VF    |  |
                                  |      |      .-------------.  |
                                  |      |      |  SR-IOV VF  |  |
                                  |      |      '-------------'  |
                                  |      '------------||---------'
                               .--------------.       ||
                               |/dev/<vfio_fd>|       ||
                               '--------------'       ||
Host Userspace                         |              ||
===================================================   ||
Host Kernel                            |              ||
                                  .--------.          ||
                                  |vfio-pci|          ||
                                  '--------'          ||
       .------------------.           ||              ||
       |   | EXPORTed API |<----+     ||              ||
       |   '--------------|     |     ||              ||
       |                  |    .-------------.        ||
       |     pds_core     |--->|   pds_vfio  |        ||
       '------------------' |  '-------------'        ||
               ||           |         ||              ||
             09:00.0     notifier    09:00.1          ||
== PCI ===============================================||=====
               ||                     ||              ||
          .----------.          .----------.          ||
    ,-----|    PF    |----------|    VF    |-------------------,
    |     '----------'          '----------'  |       VF       |
    |                     DSC                 |  data/control  |
    |                                         |      path      |
    -----------------------------------------------------------


The pds_vfio driver is targeted to reside in drivers/vfio/pci/pds.
It makes use of and introduces new files in the common include/linux/pds
include directory.

Changes:
v4:
- Update cover letter ASCII diagram to reflect new driver architecture
- Remove auxiliary driver implementation
- Use pds_core's exported functions to communicate with the device
- Implement and register notifier for events from the device/pds_core
- Use module_pci_driver() macro since auxiliary driver configuration is
  no longer needed in __init/__exit

v3:
https://lore.kernel.org/netdev/20230219083908.40013-1-brett.creeley@amd.com/
- Update copyright year to 2023 and use "Advanced Micro Devices, Inc."
  for the company name
- Clarify the fact that AMD/Pensando's VFIO solution is device type
  agnostic, which aligns with other current VFIO solutions
- Add line in drivers/vfio/pci/Makefile to build pds_vfio
- Move documentation to amd sub-directory
- Remove some dead code due to the pds_core implementation of
  listening to BIND/UNBIND events
- Move a dev_dbg() to a previous patch in the series
- Add implementation for vfio_migration_ops.migration_get_data_size to
  return the maximum possible device state size

RFC to v2:
https://lore.kernel.org/all/20221214232136.64220-1-brett.creeley@amd.com/
- Implement state transitions for VFIO_MIGRATION_P2P flag
- Improve auxiliary driver probe by returning EPROBE_DEFER
  when the PCI driver is not set up correctly
- Add pointer to docs in
  Documentation/networking/device_drivers/ethernet/index.rst

RFC:
https://lore.kernel.org/all/20221207010705.35128-1-brett.creeley@amd.com/

Brett Creeley (7):
  vfio: Commonize combine_ranges for use in other VFIO drivers
  vfio/pds: Initial support for pds_vfio VFIO driver
  vfio/pds: register with the pds_core PF
  vfio/pds: Add VFIO live migration support
  vfio/pds: Add support for dirty page tracking
  vfio/pds: Add support for firmware recovery
  vfio/pds: Add Kconfig and documentation

 .../device_drivers/ethernet/amd/pds_vfio.rst  |  79 +++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   7 +
 drivers/vfio/pci/Kconfig                      |   2 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/mlx5/cmd.c                   |  48 +-
 drivers/vfio/pci/pds/Kconfig                  |  20 +
 drivers/vfio/pci/pds/Makefile                 |  11 +
 drivers/vfio/pci/pds/cmds.c                   | 527 +++++++++++++++++
 drivers/vfio/pci/pds/cmds.h                   |  27 +
 drivers/vfio/pci/pds/dirty.c                  | 540 ++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h                  |  45 ++
 drivers/vfio/pci/pds/lm.c                     | 486 ++++++++++++++++
 drivers/vfio/pci/pds/lm.h                     |  52 ++
 drivers/vfio/pci/pds/pci_drv.c                | 210 +++++++
 drivers/vfio/pci/pds/pci_drv.h                |   9 +
 drivers/vfio/pci/pds/vfio_dev.c               | 235 ++++++++
 drivers/vfio/pci/pds/vfio_dev.h               |  40 ++
 drivers/vfio/vfio_main.c                      |  48 ++
 include/linux/pds/pds_lm.h                    | 391 +++++++++++++
 include/linux/vfio.h                          |   3 +
 21 files changed, 2736 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst
 create mode 100644 drivers/vfio/pci/pds/Kconfig
 create mode 100644 drivers/vfio/pci/pds/Makefile
 create mode 100644 drivers/vfio/pci/pds/cmds.c
 create mode 100644 drivers/vfio/pci/pds/cmds.h
 create mode 100644 drivers/vfio/pci/pds/dirty.c
 create mode 100644 drivers/vfio/pci/pds/dirty.h
 create mode 100644 drivers/vfio/pci/pds/lm.c
 create mode 100644 drivers/vfio/pci/pds/lm.h
 create mode 100644 drivers/vfio/pci/pds/pci_drv.c
 create mode 100644 drivers/vfio/pci/pds/pci_drv.h
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.h
 create mode 100644 include/linux/pds/pds_lm.h

-- 
2.17.1

