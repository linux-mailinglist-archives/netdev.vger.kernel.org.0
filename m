Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B62694F6D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjBMSeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBMSen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:34:43 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276DF13DE1;
        Mon, 13 Feb 2023 10:34:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0UWpWPoQL6rOGXI/BD5kzrhoUwCqZMMLtT9a3XB2SGMjqg+j9csvNHg0KkO4aWMckf51Olswm8BK30hsmJlCLxQZdZW72fIYLfl1VJfsGFyJXlG6khZKfusm5vs5LzSzBQNZqAn9jisEgfgOtVlFry1m+3DPFC0DOU42Ck53FCQnK0dTFKCbiQkznv/ckjcjcPw4/Vwg4kXEQ4MUgizdwKTEIbeoXj984XoVUKHqs5o3qvhMpj4jS1jLj054AmIcWbj2QJGsHZU8KZ2JKd1PPmEEH6cuI133gWumrQt2ipFX0OYK7kJrDwoaVvdDuj2U+8gdRDywzwUZ6KmsY+tPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WhYOU+Z6QYuZ5SMqjYraB3bUKENxqeFtBkfHCuHcxqw=;
 b=itLNhp01rU18Pbx5UPFUzO0Go9EFTRH5rgHcxNoU08ISVidATvEvv7zTEe7IAhqq9NaUVcyHRS5GuqbVYArVFJskq5LYA0dnVoUhiBSaAxqAbwET+n7wByDD+4D7ezySohAx0S0S2Wz78zypFma1vuBvTdC6rkOK7444jZUOrLo1HJWA6PiUOLcD9Vj7cc++6owGZuy3P+KFH+6WLsmKdGW8MqoRl0xCGxG53X8f+dlyWSWUsiU/TtYVHrG91vn7EQKVXcDpG/5xRJtUpRcPirqbpOKDvlrzhIf+7B05MjR/aQezyewjbUkud02brYkpxlV9C69usHWV0UXr2yrPLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhYOU+Z6QYuZ5SMqjYraB3bUKENxqeFtBkfHCuHcxqw=;
 b=N5syf+PdqDSfoAUyBiqrSOYW2bngpoB147ZoTtNTJXlhEDMy/44rZwhA18LzP8tnloL/2feMFdV5j+M2h++Yw0T2lKmdgPIz/pXefa6EreMe60qZWcoU6x2VjOTjrlSfMHLDnG+MVwLYCirlP3TGQF0AQjuENVIfJfCdad1HRuU=
Received: from DM6PR08CA0025.namprd08.prod.outlook.com (2603:10b6:5:80::38) by
 SN7PR12MB7934.namprd12.prod.outlook.com (2603:10b6:806:346::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 18:34:38 +0000
Received: from DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::b6) by DM6PR08CA0025.outlook.office365.com
 (2603:10b6:5:80::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 18:34:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT112.mail.protection.outlook.com (10.13.173.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 18:34:38 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 12:34:37 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 12:34:37 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Mon, 13 Feb 2023 12:34:36 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v7 net-next 0/8] sfc: devlink support for ef100
Date:   Mon, 13 Feb 2023 18:34:20 +0000
Message-ID: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT112:EE_|SN7PR12MB7934:EE_
X-MS-Office365-Filtering-Correlation-Id: e690dbe1-d5c5-4ffd-6248-08db0df0f695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpwkqK3whOD6W7tk+hxDalWXXuDMpndv8kKeBMfcvbgk5TdDSomSKEv4ixvD3Yr3lyCEmBBDREfH44x6WGs5+SsTR05ZNovGY7IaNwzKmBYKx3oXDzpOmb8j8LDC+csmMihiy020LC8S712oAui2pPHnU6yyJE7fJjhLlv7zIhPpUhgwFBoE1mfu/akPYNLl9kUYH7+1YYvHs2ZSyLcbtIjTmQxnSAVP1TGRNGmraC00lyPgaV1yaYAIEuDB1GmWzB5MQ066eI5kCxtoEM+kfyevJzPoTMR8i6UaYRHVu/4HmvXSyPBaNe+t34wD7C5GY+YiMXMGp8+YQl+9oC6RP6h/60cn36BlL0QbpeLGxlEPMUAHJCW+P5ko4Tb5SjkdySqpCboR0EgSj9a9RpqGWyFPuE0Y5NV1AawI4mE9GOw9UFplRT252rgpgGsDO9VFgfuP82pX4+95fGaZVsVTGNz7vJSMprBTpBiEg+B1mxJgn3Qj+/SNMplkMSPRRJO1nf3xX/1HEl1cNhEqLKio0VQXLBEW6Zmw6LokSKU8EDEa5cBD6jku3A2klViDWgdncre5uF4RrHdLnGrXfpxaAOlTW0AeZyLPdUSKB6yOQwreer4OC4ToCPCC3wbyMEx/gxJL7oFrdEZoEMkJSeMzRTyDdx0ZpiEDQDIRTir8R2XuTgaPVojGyjLAE3t91/4JxY/ttHudAZfT9yzI7pDo/rSt3oU9iy+1UJsfsG6WKBA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(36840700001)(46966006)(40470700004)(6636002)(110136005)(54906003)(2906002)(2876002)(2616005)(426003)(47076005)(41300700001)(186003)(26005)(8676002)(70586007)(70206006)(4326008)(83380400001)(8936002)(7416002)(5660300002)(6666004)(1076003)(36860700001)(81166007)(356005)(82740400003)(86362001)(82310400005)(336012)(478600001)(316002)(40480700001)(36756003)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:34:38.2573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e690dbe1-d5c5-4ffd-6248-08db0df0f695
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7934
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
 drivers/net/ethernet/sfc/efx_devlink.c     | 733 +++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h     |  47 ++
 drivers/net/ethernet/sfc/mae.c             | 218 +++++-
 drivers/net/ethernet/sfc/mae.h             |  40 ++
 drivers/net/ethernet/sfc/mcdi.c            |  72 ++
 drivers/net/ethernet/sfc/mcdi.h            |   8 +
 drivers/net/ethernet/sfc/net_driver.h      |   8 +
 17 files changed, 1361 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/networking/devlink/sfc.rst
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h

-- 
2.17.1

