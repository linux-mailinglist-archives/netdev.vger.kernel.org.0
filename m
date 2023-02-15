Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738086978A9
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjBOJJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbjBOJJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:09:00 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C9A367F2;
        Wed, 15 Feb 2023 01:08:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4V9JEE07A+Nzp55mEVVWFfiW/3ens20NDwoZME8eQxMdR8shTr3SeKPbpQO6VsdARDiIpYsURfOSl/Qo1ajRKN0brKkZqd/+8eAUxz9lwozdU6otFF4mu/x3Be6DVv/ecQjkaRJ1O2aHy7tnK2BkzVAreE2vr5WlWItpPNj2z6mZl3xvqsMea8yc7Tfmfan7TU1ogtm2bAmfUpY5lZPOdtfi/SNep+AgPJ4bEoRPyFWsoFz/QbR2aZX3g5kug7E0cMEJWC3JYl2dBlQ/NnQM5LvkC3nxpDQshLLaT6ufzKqPXVutD3neUGz44XH4HuwsJ9E74xSzk2E6WoIa+DpMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nSEn1j75VBodoO+Fuo+YMAihefXcJeEUs+tDqBUYAcc=;
 b=in8O+6DCLukVwVBImvPjeAHGLeb0eWSdmmccuAlgPj766SL/ReC4AaiuAbCQxDaj6lrGcE9T3DOCXne3B0RUSGRHT/QjBjKAmo09U3sdyzWNY6pAv+PUV0ypS1jbqW+AK/9W3qB1YWbQnMDTWuybn4zjFQ6Q2XL1b3IMr/XzBBXnpSHaaYngB9xMYkAh4X8YP1D6p9GCvqND2nh5JXZKqMbfUZd5yEU2GR/S3SYzTePMfKeVywr2Rfrh7zRYRerGMsLz8277j7QuOdO2oz9mnNwG319rlvjYSFMxphQNWARSR+RcQdJ9oVs/3qAZO595OOHOnZ9SKmIsklBRPAIxRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nSEn1j75VBodoO+Fuo+YMAihefXcJeEUs+tDqBUYAcc=;
 b=pIl0cVnIlNahRoIO87ZyDfJIkd3hjU3hL5C0z87KS/u0qCu0LqQtIFpjZZeo3a39N1r8pbK6Pq82PqNpUsG3meSRxKFrZkinRJ+TvuasILonLgZMvr15V8IRIgaJ8+U2yMb/Kde0/dxzsOGM3qlJbONFbFHsBghaWw531AoNgug=
Received: from DM6PR06CA0025.namprd06.prod.outlook.com (2603:10b6:5:120::38)
 by MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 09:08:54 +0000
Received: from DS1PEPF0000E632.namprd02.prod.outlook.com
 (2603:10b6:5:120:cafe::e3) by DM6PR06CA0025.outlook.office365.com
 (2603:10b6:5:120::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 09:08:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E632.mail.protection.outlook.com (10.167.17.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.8 via Frontend Transport; Wed, 15 Feb 2023 09:08:54 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 15 Feb
 2023 03:08:40 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 15 Feb
 2023 01:08:38 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Wed, 15 Feb 2023 03:08:36 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v8 net-next 0/8] sfc: devlink support for ef100
Date:   Wed, 15 Feb 2023 09:08:20 +0000
Message-ID: <20230215090828.11697-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E632:EE_|MN0PR12MB6128:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bf8cb2f-3df0-4143-7a89-08db0f34433e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNJacmYSD8w1peKxsK/5O6Uj6vDFMfTRK6V9Dgp4O8xttBGYpUOd+qJhLWB+9CEHi5e95RFzQ2Fn4NtC3txlAdJdypRPukPJrbPnQsikmhMpdKhM1sidq/kx846v8fNaVRzE+dYhOdC0tF2w8rdw7ct9q8Dm83nauVuuk7SmXNfyuV6WSvB83fJRU+b2ddGiolv0W/Q4pdAGIVhIpkVtIWS5USRQcdKjS0cTySgA4T5Q6sCEoUUVFo+IJjyk9KOpJ+iLJrdyMZjwyBlxKUniBk06ccfARCZ3opqMXgHZTbG0UhsJwsHcqQKKk5enHicCpWFY17zSdU/xTzERCNRQIo7KysJp8+7jyzRSnkb5dXOVNOHnHxZuMwzRwOjDGz4pSjn4tFVUSdaTkvY7Ead2briRxyOfS4Y0yy+d1L9XL0Ujftp1YclpAkL+j7Q5szczBfo+RALTwg7lusd02WhZ7knNjo+/E1IA5D+4Ml+6vQ36GvFWlJXm2sjJCLufJ69nynM9rEjN/xkuM8i8e/g6V3EYtGepXDJ+8K6vyD704k8OAXB8xxyJhxUXfNQQDyPru6KGp2AVClQB6jP6C7AMUY3Ywm3rPSKR6lXqtvWXdtH6pDpSqEmHj1FRyOIMLY7WMFTQRrFjVdbRmjjx1sa45nmJTo0fFYJu6XjtFCURlQOFFUtbX8lVKUZslZ00Wj2yG9pxNbB87w5or+C7izCtOok/meEcg2gPMvOJiA/M4UQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199018)(36840700001)(40470700004)(46966006)(1076003)(83380400001)(8936002)(5660300002)(7416002)(2906002)(2616005)(2876002)(336012)(41300700001)(86362001)(82740400003)(70206006)(70586007)(110136005)(186003)(26005)(54906003)(316002)(8676002)(4326008)(478600001)(426003)(6636002)(47076005)(81166007)(40460700003)(40480700001)(36756003)(356005)(6666004)(82310400005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 09:08:54.3160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf8cb2f-3df0-4143-7a89-08db0f34433e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E632.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

v8 changes:
 - using preprocessor conditional approach instead of ifdef for
   fixing Microblaze build error.

v7 changes:
 - Fix Microblaze build error based on checking RTC_LIB instead of
   SFC_SRIOV.

v6 changes:
 - add file headers at its due time
 - fix sfc.rst warnings
 - add sfc.rst to the index.rst file
 - avoid microblaze build error
 - simplify devlink info errors reported

v5 changes
 - add extack error report for devlink info
 - Rename devlink functions stating locking
 - Check functions return through a variable
 - Remove unnecessary non related changes
 - put SRIOV dependent code inside #ifdefs (is ia64 still alive?)

v4 changes:
 - Add new doc file to MAINTAINERS
 - nvram metadata call independent of MTD config
 - add more useful info with extack

v3 changes:
 - fix compilation warnings/errors reported by checkpatch

v2 changes:
 - splitting up devlink info from basic devlink support
 - using devlink lock/unlock during initialization and removal
 - fix devlink registration order
 - splitting up efx_devlink_info_running_versions
 - Add sfc.rst with specifics about sfc info
 - embedding dl_port in mports
 - using extack for error reports to user space

This patchset adds devlink port support for ef100 allowing setting VFs
mac addresses through the VF representor devlink ports.

Basic devlink infrastructure is first introduced, then support for info
command. Next changes for enumerating MAE ports which will be used for
devlink port creation when netdevs are registered.

Adding support for devlink port_function_hw_addr_get requires changes in
the ef100 driver for getting the mac address based on a client handle.
This allows to obtain VFs mac addresses during netdev initialization as
well what is included in patch 6.

Such client handle is used in patches 7 and 8 for getting and setting
devlink port addresses.

Alejandro Lucero (8):
  sfc: add devlink support for ef100
  sfc: add devlink info support for ef100
  sfc: enumerate mports in ef100
  sfc: add mport lookup based on driver's mport data
  sfc: add devlink port support for ef100
  sfc: obtain device mac address based on firmware handle for ef100
  sfc: add support for devlink port_function_hw_addr_get in ef100
  sfc: add support for devlink port_function_hw_addr_set in ef100

 Documentation/networking/devlink/index.rst |   1 +
 Documentation/networking/devlink/sfc.rst   |  57 ++
 MAINTAINERS                                |   1 +
 drivers/net/ethernet/sfc/Kconfig           |   1 +
 drivers/net/ethernet/sfc/Makefile          |   3 +-
 drivers/net/ethernet/sfc/ef100_netdev.c    |  30 +
 drivers/net/ethernet/sfc/ef100_nic.c       |  93 ++-
 drivers/net/ethernet/sfc/ef100_nic.h       |   7 +
 drivers/net/ethernet/sfc/ef100_rep.c       |  57 +-
 drivers/net/ethernet/sfc/ef100_rep.h       |  10 +
 drivers/net/ethernet/sfc/efx_devlink.c     | 731 +++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h     |  47 ++
 drivers/net/ethernet/sfc/mae.c             | 218 +++++-
 drivers/net/ethernet/sfc/mae.h             |  40 ++
 drivers/net/ethernet/sfc/mcdi.c            |  72 ++
 drivers/net/ethernet/sfc/mcdi.h            |   8 +
 drivers/net/ethernet/sfc/net_driver.h      |   8 +
 17 files changed, 1359 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/networking/devlink/sfc.rst
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h

-- 
2.17.1

