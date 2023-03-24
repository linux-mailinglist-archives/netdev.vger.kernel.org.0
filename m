Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEFF6C857C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjCXTDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCXTDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:11 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D6C93C0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1Z/fN+SFNINrFLnUdifkM+z0CBaPLg6X1tn2Bg1oZoqcSDlRCOfuqcboyFbgKcN+weAZDMIK7M5HYkgLEHJPcXS6Zto/TH4iXsmVegFKzPTJCQfi/uusv5wa5inGVl9PwxsIaBywUtCqaiksx3M+yztDC9bJmHbD62nNpdLyR2uVLV/Az+pn44UBXiLYAWYOXsjmVkGGojBctqRpxYtNy2izu4kQjoc5n50IDwgOSjz15mP1rTSH6daT0f7oW3M6rDbuyPs/ghckbyNOva7cQdFxobMckeqgh8jjcuZ5O5D3a05Ikp7kUWZBqVoIEIuTlje4eDG9Q3d6O9BTchPjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRfpjiUEK6HY3Nhq5cxqXI+CjUmFY80DdwWHT6zj1vY=;
 b=Jfmya3/qofdyhsD7jE/teSC4nZcwv9eT81c2QKmZbn4j79PcMGZyUV5QGcm6jxcBsRnzWudP/AIR6SFiH1w8Akl7AYXJj6AWbuH82iB5euiRkL/OI5OYBxgrUhmKHTLltFI6TmjsmvOLhbrqmqsh/ZrAM5b+ffGk6benNKKIJNNg7pJA+4BQW5PkQ2OJtuV6DTQJMusm84ZQGHyuYjaU4NDwWo/KMkbAyvD0fIBB3Infzz53Bvr8bn68VTnF2XFWJZOTzcDkiyw5FmJYuIEPKB2NtAZ3QkU2igNx4LcqPBV/5QkbpklfmNatfRLi/VyCMitKEvcJ69j6Ip2LjiV09w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRfpjiUEK6HY3Nhq5cxqXI+CjUmFY80DdwWHT6zj1vY=;
 b=B4AIrmQKXwqRRO1YN3xWCZDjf/c6aCUdGlIPSQVsnatbdzQ58SDKKjjFCYnyNUz9hMPLraqf1FqNjq/m0jtPArQb+IZajG5HiccFAg5UAA90X8Mb3eFUslG523ThxLctXF/uOED82a1bkrqwlKVbAnsriePQx8C4pZmswDYT6V0=
Received: from DM6PR02CA0165.namprd02.prod.outlook.com (2603:10b6:5:332::32)
 by CH0PR12MB5268.namprd12.prod.outlook.com (2603:10b6:610:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39; Fri, 24 Mar
 2023 19:03:06 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::86) by DM6PR02CA0165.outlook.office365.com
 (2603:10b6:5:332::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Fri, 24 Mar 2023 19:03:05 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:04 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 00/14] pds_core driver
Date:   Fri, 24 Mar 2023 12:02:29 -0700
Message-ID: <20230324190243.27722-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT051:EE_|CH0PR12MB5268:EE_
X-MS-Office365-Filtering-Correlation-Id: d6be3c9e-2ffb-4fb1-033f-08db2c9a667f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f/ZOS3mPhci0HkNSdpftM80R5c1ByigrwAQ1BCVPQ5zbgWax61HqsZl47BnDu2htOfz7MWaVdUnByHjhTF/fClnaulfmKhGdroFRFsJeBY3e//vYY/N9ftOiLCXk/4Ni5UxdPN08PN4yDnFDDbDP3lj+NpxQwrTMWkcaNyQCB+tMFASrek7xWXjwm7O6WTvpfd+Cp3STxmqzPvJM2hGRS52P2erRqZ5AMFHfmuriKuQZ7b3E9duTD1Fd/L6TZhFLCFWnxZFagILKZZOZJPKm66SkBV8SxN2SBCQ0spceEL7rW06yRhLglRqIJaEArUccGSpkMDLQcazmvbsjoNtKGuiisNIZoaa4kTDWaCyDGHjB58c13pxOERhVdnUNpKk+Te2TZnDbhjGVbbbYtZnVF+/0bju637/f27/oERT1wiG8yQ8Zb09Yc8dqRuL6DL8kBjZQsdtGvIctMzinycDWm9iDiTXNQnBtYRW9SXD/nOu9uqfJ+GW5SZglADj+BKv/biLxuMlky2j/hO3zkh7fEBTlOvlEvo+o14U4JitFCddW7GFcuF+JKS7X7Ci0ANBd4SLGrM7JhoLB5qywff4ho+4x4hqBCD2KAuNpSHW8hWjyhUT0Tg+3xOeahOEVp214i/b/gRuFVxLcIyXZzRMfGveRoSH7HH15MESo14Yh4uIOVwgf8aKaxXmg0cTwNWgk3gwxnrCymx/7rnaznulPioe9987wsdxwvIQlU23L2GP0JXiXtIXbkFrPKeMweT2+v20KBOuT+nVKOKAIiV9DiQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199021)(46966006)(36840700001)(40470700004)(41300700001)(4326008)(36756003)(70206006)(70586007)(54906003)(8936002)(186003)(26005)(83380400001)(110136005)(36860700001)(82310400005)(6666004)(8676002)(82740400003)(2906002)(44832011)(5660300002)(966005)(316002)(356005)(86362001)(40460700003)(81166007)(40480700001)(426003)(1076003)(2616005)(478600001)(16526019)(47076005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:05.8461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6be3c9e-2ffb-4fb1-033f-08db2c9a667f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5268
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Summary:
--------
This patchset implements a new driver for use with the AMD/Pensando
Distributed Services Card (DSC), intended to provide core configuration
services through the auxiliary_bus and through a couple of EXPORTed
functions for use initially in VFio and vDPA feature specific drivers.

To keep this patchset to a manageable size, the pds_vdpa and pds_vfio
drivers have been split out into their own patchsets to be reviewed
separately.


Detail:
-------
AMD/Pensando is making available a new set of devices for supporting vDPA,
VFio, and potentially other features in the Distributed Services Card
(DSC).  These features are implemented through a PF that serves as a Core
device for controlling and configuring its VF devices.  These VF devices
have separate drivers that use the auxiliary_bus to work through the Core
device as the control path.

Currently, the DSC supports standard ethernet operations using the
ionic driver.  This is not replaced by the Core-based devices - these
new devices are in addition to the existing Ethernet device.  Typical DSC
configurations will include both PDS devices and Ionic Eth devices.
However, there is a potential future path for ethernet services to come
through this device as well.

The Core device is a new PCI PF/VF device managed by a new driver
'pds_core'.  The PF device has access to an admin queue for configuring
the services used by the VFs, and sets up auxiliary_bus devices for each
vDPA VF for communicating with the drivers for the vDPA devices.  The VFs
may be for VFio or vDPA, and other services in the future; these VF types
are selected as part of the DSC internal FW configurations, which is out
of the scope of this patchset.

When the vDPA support set is enabled in the core PF through its devlink
param, auxiliary_bus devices are created for each VF that supports the
feature.  The vDPA driver then connects to and uses this auxiliary_device
to do control path configuration through the PF device.  This can then be
used with the vdpa kernel module to provide devices for virtio_vdpa kernel
module for host interfaces, or vhost_vdpa kernel module for interfaces
exported into your favorite VM.

A cheap ASCII diagram of a vDPA instance looks something like this:

                                ,----------.
                                |   vdpa   |
                                '----------'
                                  |     ||
                                 ctl   data
                                  |     ||
                          .----------.  ||
                          | pds_vdpa |  ||
                          '----------'  ||
                               |        ||
                       pds_core.vDPA.1  ||
                               |        ||
                    .---------------.   ||
                    |   pds_core    |   ||
                    '---------------'   ||
                        ||         ||   ||
                      09:00.0      09:00.1  
        == PCI ============================================
                        ||            ||
                   .----------.   .----------.
            ,------|    PF    |---|    VF    |-------,
            |      '----------'   '----------'       |
            |                  DSC                   |
            |                                        |
            ------------------------------------------


Changes:
  v6:
 - removed version.h include noticed by kernel test robot's version check
    Link: https://lore.kernel.org/oe-kbuild-all/202303230742.pX3ply0t-lkp@intel.com/
 - fixed up the more egregious checkpatch line length complaints
 - make sure pdsc_auxbus_dev_register() checks padev pointer errcode

  v5:
Link: https://lore.kernel.org/netdev/20230322185626.38758-1-shannon.nelson@amd.com/
 - added devlink health reporter for FW issues
 - removed asic_type, asic_rev, serial_num, fw_version from debugfs as
   they are available through other means
 - trimed OS info in pdsc_identify(), we don't need to send that much info to the FW
 - removed reg/unreg from auxbus client API, they are now in the core when VF
   is started
 - removed need for pdsc definition in client by simplifying the padev to only carry
   struct pci_dev pointers rather than full struct pdsc to the pf and vf
 - removed the unused pdsc argument in pdsc_notify()
 - moved include/linux/pds/pds_core.h to driver/../pds_core/core.h
 - restored a few pds_core_if.h interface values and structs that are shared
   with FW source
 - moved final config_lock unlock to before tear down of timer and workqueue
   to be sure there are no deadlocks while waiting for any stragglers
 - changed use of PAGE_SIZE to local PDS_PAGE_SIZE to keep with FW layout needs
   without regard to kernel PAGE_SIZE configuration
 - removed the redundant *adminqcq argument from pdsc_adminq_post()

  v4:
Link: https://lore.kernel.org/netdev/20230308051310.12544-1-shannon.nelson@amd.com/
 - reworked to attach to both Core PF and vDPA VF PCI devices
 - now creates auxiliary_device as part of each VF PCI probe, removes them on PCI remove
 - auxiliary devices now use simple unique id rather than PCI address for identifier
 - replaced home-grown event publishing with kernel-based notifier service
 - dropped live_migration parameter, not needed when not creating aux device for it
 - replaced devm_* functions with traditional interfaces
 - added MAINTAINERS entry
 - removed lingering traces of set/get_vf attribute adminq commands
 - trimmed some include lists
 - cleaned a kernel test robot complaint about a stray unused variable
        Link: https://lore.kernel.org/oe-kbuild-all/202302181049.yeUQMeWY-lkp@intel.com/

  v3:
Link: https://lore.kernel.org/netdev/20230217225558.19837-1-shannon.nelson@amd.com/
 - changed names from "pensando" to "amd" and updated copyright strings
 - dropped the DEVLINK_PARAM_GENERIC_ID_FW_BANK for future development
 - changed the auxiliary device creation to be triggered by the
   PCI bus event BOUND_DRIVER, and torn down at UNBIND_DRIVER in order
   to properly handle users using the sysfs bind/unbind functions
 - dropped some noisy log messages
 - rebased to current net-next

  RFC to v2:
Link: https://lore.kernel.org/netdev/20221207004443.33779-1-shannon.nelson@amd.com/
 - added separate devlink param patches for DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION
   and DEVLINK_PARAM_GENERIC_ID_FW_BANK, and dropped the driver specific implementations
 - updated descriptions for the new devlink parameters
 - dropped netdev support
 - dropped vDPA patches, will followup later
 - separated fw update and fw bank select into their own patches

  RFC:
Link: https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/


Shannon Nelson (14):
  pds_core: initial framework for pds_core PF driver
  pds_core: add devcmd device interfaces
  pds_core: health timer and workqueue
  pds_core: add devlink health facilities
  pds_core: set up device and adminq
  pds_core: Add adminq processing and commands
  pds_core: add FW update feature to devlink
  pds_core: set up the VIF definitions and defaults
  pds_core: add initial VF device handling
  pds_core: add auxiliary_bus devices
  pds_core: devlink params for enabling VIF support
  pds_core: add the aux client API
  pds_core: publish events to the clients
  pds_core: Kconfig and pds_core.rst

 .../device_drivers/ethernet/amd/pds_core.rst  | 143 ++++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   9 +
 drivers/net/ethernet/amd/Kconfig              |  12 +
 drivers/net/ethernet/amd/Makefile             |   1 +
 drivers/net/ethernet/amd/pds_core/Makefile    |  14 +
 drivers/net/ethernet/amd/pds_core/adminq.c    | 291 ++++++++
 drivers/net/ethernet/amd/pds_core/auxbus.c    | 271 ++++++++
 drivers/net/ethernet/amd/pds_core/core.c      | 608 +++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h      | 317 +++++++++
 drivers/net/ethernet/amd/pds_core/debugfs.c   | 246 +++++++
 drivers/net/ethernet/amd/pds_core/dev.c       | 352 ++++++++++
 drivers/net/ethernet/amd/pds_core/devlink.c   | 268 ++++++++
 drivers/net/ethernet/amd/pds_core/fw.c        | 194 ++++++
 drivers/net/ethernet/amd/pds_core/main.c      | 450 ++++++++++++
 include/linux/pds/pds_adminq.h                | 645 ++++++++++++++++++
 include/linux/pds/pds_auxbus.h                |  44 ++
 include/linux/pds/pds_common.h                |  97 +++
 include/linux/pds/pds_core_if.h               | 540 +++++++++++++++
 include/linux/pds/pds_intr.h                  | 163 +++++
 20 files changed, 4666 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
 create mode 100644 drivers/net/ethernet/amd/pds_core/Makefile
 create mode 100644 drivers/net/ethernet/amd/pds_core/adminq.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/core.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/core.h
 create mode 100644 drivers/net/ethernet/amd/pds_core/debugfs.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/dev.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/devlink.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/fw.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/main.c
 create mode 100644 include/linux/pds/pds_adminq.h
 create mode 100644 include/linux/pds/pds_auxbus.h
 create mode 100644 include/linux/pds/pds_common.h
 create mode 100644 include/linux/pds/pds_core_if.h
 create mode 100644 include/linux/pds/pds_intr.h

-- 
2.17.1

