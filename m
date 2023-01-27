Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB7A67E060
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 10:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjA0JhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 04:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjA0JhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 04:37:10 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCA57686
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 01:37:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLay21/NrdWReu4IxEQDS++2qPX3EEU886bSeTmD97bSgwdvYAPiwjQ29EJCIpTpanonWnC247zFkeyC7o3hspkbNawy94gXhwbAYdew2sN/ycxrSfMHS0ObK/eKkI08efhv/18j+KhBqBunFtLgIhWy0sxEERAawYZEj3f3kUMT1wGaGNTFX8ojG/EKPw64C4JG/yPt7L7nSbFJsVTAYV68RmCk6NiMfD1Diy3jEwBaSByDoTUzGrjxu1N7y3Q8qAXzmXF4wXGLD+5REP93hdSSpOpA8aybXopQ/D6MGmasIbe9Qex5Kx8CQmbLB9hs5+rWEWGYZxHUW2L3lz2cog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvNSsePSJm2KjA0y4fq2yUHoxklFf2irtUIijBas7Do=;
 b=G4RSnfUZF5X6Jf0O0m+AkfGsmAjCzdmhYhX2cumNd27UNIsLHo7MLFMf0uayNM77r3CcIEu06RAVnX07XnJ1dy+ABZ54/Vww9TDOUcbULOjoc5XI2fHV+DvCRmn6MOqljcoMt7epQIpuqqE/kzMBUr0zfXnxhmVDzFeDWjA9ytV/06bTH01hB6rkixISVyF+90lBppTCaQgI+rHHCOzw3LGWs1aDdzHr4xRAkwitqht2o2Vcd0zH7DFjCjQAddr+edtP356+eGiEqU5ST34mRryUIJgY8HBvawLY/BM8lIKlTORI/3YvqpasB/mXVbYawXPeLcz6LafkRf6ABNLxLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvNSsePSJm2KjA0y4fq2yUHoxklFf2irtUIijBas7Do=;
 b=eSyH1b7s56DEMq3dchFChYzCLgA1X69JwiZexR9mrrRK+KT45DoDSahBafAE02ITA6QP5wcsIALmGA7b1rvfM+D5Jug7+d9IrJVXTOym+n5UJ5Mx5tGLVbnG9Kk/uZLzyExh28SgllM6suxagEFd7HjOGZEhSDwb25Ofr9EPr2o=
Received: from DM6PR17CA0020.namprd17.prod.outlook.com (2603:10b6:5:1b3::33)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 09:37:07 +0000
Received: from DS1PEPF0000E652.namprd02.prod.outlook.com
 (2603:10b6:5:1b3:cafe::c8) by DM6PR17CA0020.outlook.office365.com
 (2603:10b6:5:1b3::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 09:37:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E652.mail.protection.outlook.com (10.167.18.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.10 via Frontend Transport; Fri, 27 Jan 2023 09:37:06 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 27 Jan
 2023 03:37:05 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 27 Jan
 2023 01:37:05 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Fri, 27 Jan 2023 03:37:04 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH v3 net-next 0/8] sfc: devlink support for ef100
Date:   Fri, 27 Jan 2023 09:36:43 +0000
Message-ID: <20230127093651.54035-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E652:EE_|BL1PR12MB5350:EE_
X-MS-Office365-Filtering-Correlation-Id: 61f2cd2a-8c78-43e2-894a-08db004a0e3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QoKbVSVMgcw9zptu3IkBt/OsbtFtpvQOK/akVoi7NkzMx+SFpQ1oY9z4WenJLEMWD2Ai9Rn7E64TBLwaoWIBNftlGjt0PcPyRN2/4xbBCzdO2GyMMvjYwPGIYVhBkKSF6e/RZ1C5K3yzUZVk9UEn95f+tWQuO6K0UOq9tuTObziX4LdIJ5ffr/HkSSz5Olm52Yn37ajZp3I/6QF12i73mmrgRPmW1/CV3hdgwUhpZBlReMUUvHL0ycda1dTp1sBc4/9t6qbgs+4ZWL36jPQuniHk/rfd/I3wzPhsohb8809F6vMfU2GhdpjclkzBZFxV1ecfxlmit+LZ5jspjoeeScPic235N6wJy0ZiRWhFUviH6Dig63MhmaoCK/uxPgrcuuoWGrVPQ4UyHqjAxYZ1ApzkXs9ty2CWB01IkEm6HONEEwyDz3z6BHsh/kvzR5hqiUVnGWLPfC3G7DAnYTojIm/8l3UGIjLJlGsSJnY6vJgVrWYK+wZ3eCrQbou8Ec/nmjlC3mrAQLAapGFsY3F6kKlztzhCTXWV97MQO2eSImGGhCbem8iraZvF88jm/GQS/31jtXDJWC6YrTnrY6Ok54ZSzbIgJu3VfO1hgn5mpkcyQhwkXPDLFR3u0+QSGsNZms36WPTBbVGhEcfYYGrFZBbFTJkLMyyqkyCoaTr/EzN7z0u4CQQpIxI49XDyIQOb59ztGBiH5fqEOUEQK3UY0q7KXMjkRZDuEWo9pcvTlSc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199018)(36840700001)(40470700004)(46966006)(41300700001)(8936002)(6666004)(5660300002)(36860700001)(83380400001)(336012)(426003)(47076005)(40460700003)(40480700001)(356005)(86362001)(82740400003)(316002)(54906003)(6636002)(82310400005)(36756003)(110136005)(70206006)(81166007)(70586007)(8676002)(186003)(4326008)(26005)(2616005)(478600001)(1076003)(2876002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 09:37:06.8769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61f2cd2a-8c78-43e2-894a-08db004a0e3d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E652.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5350
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
devlik port creation when netdevs are registered.

Adding support for devlink port_function_hw_addr_get requires changes in
the ef100 driver for getting the mac address based on a client handle.
This allows to obtain VFs mac address during netdev initialization as
well what is included in patch 6.

Such client handle is used in patches 7 and 8 for getting and setting
devlink ports addresses.

Alejandro Lucero (8):
  sfc: add devlink support for ef100
  sfc: add devlink info support for ef100
  sfc: enumerate mports in ef100
  sfc: add mport lookup based on driver's mport data
  sfc: add devlink port support for ef100
  sfc: obtain device mac address based on firmware handle for ef100
  sfc: add support for devlink port_function_hw_addr_get in ef100
  sfc: add support for devlink port_function_hw_addr_set in ef100

 Documentation/networking/devlink/sfc.rst |  57 ++
 drivers/net/ethernet/sfc/Kconfig         |   1 +
 drivers/net/ethernet/sfc/Makefile        |   3 +-
 drivers/net/ethernet/sfc/ef100_netdev.c  |  31 ++
 drivers/net/ethernet/sfc/ef100_nic.c     |  93 +++-
 drivers/net/ethernet/sfc/ef100_nic.h     |   7 +
 drivers/net/ethernet/sfc/ef100_rep.c     |  57 +-
 drivers/net/ethernet/sfc/ef100_rep.h     |  10 +
 drivers/net/ethernet/sfc/efx_devlink.c   | 660 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h   |  46 ++
 drivers/net/ethernet/sfc/mae.c           | 218 +++++++-
 drivers/net/ethernet/sfc/mae.h           |  41 ++
 drivers/net/ethernet/sfc/mcdi.c          |  72 +++
 drivers/net/ethernet/sfc/mcdi.h          |   8 +
 drivers/net/ethernet/sfc/net_driver.h    |   8 +
 15 files changed, 1285 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/networking/devlink/sfc.rst
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h

-- 
2.17.1

