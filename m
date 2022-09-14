Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F705B872F
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 13:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiINLXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 07:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiINLXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 07:23:22 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BC05A3EA
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 04:23:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5v9NzYdhSOa6WMTw0kD3iNmdAOImTlIC5h8fhmxDr3SIMmQ6XViVcvnIKlvJSLnarm76uVUY0kw+3eOkl3ZbIctTOW+GAaHHhrHdWRxdIY6QRPqmSCVuBT8IInjCYAnFIWcnI0wL1XjcTB+X7LJGwXRL44MAS3rbpM3fcYmgOXBMRQFKnZdMIbfoGMGvrArbW1jvkemrEELQ1vYzAeGyP4kxSzQjQPo4ZHEQEtudEIbmblnrbIx1Io8sFtqLGgs5vIuepd29uXJSJXEwRpzhF5UcVTojMnEMvq8Hdlh9g/fGluyamXyfAfb+fzEZRtDqqdfOekC4s406Hm76rOFwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qn4sIvz7iHDSJOx11mtBIC5NlIvMIxeH+6lwnTk8j+Y=;
 b=l8Vy4Mjc5yNVxxM9bpkcHf18XoMlTtH3oeHXszs4CZGqS1EIkUJEXKvPcD2lVZbHFN9qWgfWAPdLfADLAV1A9S7tjHFOqgMd0iEx9XQAebEMPrNlYOzWwl5iTw2tKOvw6W1YibDb1lN1D+nMsovjJBnM7IyP8OOJTCzIP100S98YPv0EOLhGHPJAEFh1RVwBtbz4Als3FjVFHRpe0UkUztfDpvC1OSpy4g1uuYYgC+mETMh6gEo+s0YRBjOpq9bOyFqYUrLslHrnQU3PwebkZSsUMvl6l+WTqKtByVrL9nZYmTU0d6Moggf5eMkyluJ1oqLBe7FEvZfi7v0f90z+fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qn4sIvz7iHDSJOx11mtBIC5NlIvMIxeH+6lwnTk8j+Y=;
 b=mkK9YvfEnGZ1qBXjhKW131kWtT0IsPj4li3tnlSNlxSRTFaNfgUXKY7WgxPQCZXD4qetTSMRmJT2Bm7c5L6VZJNa/RHpSsdVyGmLqu4aOpOt/NIt7qT3MEnFXHTRxNZ03DKShFdgQLUG49wfDGrOptyns/X7eUCuQm7oAhSxiKyx34kQa7Ic0n07GsscsUtn9p9d3JdrwnZmQU/rJuPVWaQtTD4rijov8M7wQZ8C6BMmRxlyqrYW1HEOqSCoIcWllhWXcrSC2OOjmRpc4tMyhao5FbXuqm7azU9vjpqjym89IZUx6dy8sHdoeVI0bFXpCHYPAAuLa0MkZ4lWDNqQtw==
Received: from BN9PR03CA0248.namprd03.prod.outlook.com (2603:10b6:408:ff::13)
 by CH2PR12MB4309.namprd12.prod.outlook.com (2603:10b6:610:a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 14 Sep
 2022 11:23:19 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::3b) by BN9PR03CA0248.outlook.office365.com
 (2603:10b6:408:ff::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Wed, 14 Sep 2022 11:23:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 11:23:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 04:23:02 -0700
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 04:22:59 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/5] mlxsw: Adjust QOS tests for Spectrum-4 testing
Date:   Wed, 14 Sep 2022 13:21:47 +0200
Message-ID: <cover.1663152826.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT068:EE_|CH2PR12MB4309:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b53c8e-f58d-4120-5e3a-08da96438680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r5GVxT/qjPx0AlAzQdz5eEiDkRlMZttp3x0jI2EogGyTVKcdE+0Mjff6k3iuI4eo+tvnx6FdYN69+6+7hdBj5PkA1XxqhjTP1JG9jUt9MNVrqGRk/1prN5wBcU43parRQ57qKdjFXGwNOZ/hUbl8vxocQvvjLmPfLSSheVUh/yKDNOadlRrfuigJLaJjcmq7AJer7LMu2NqEnqUZWeDvAZYRbxU9K63DrBvjagPaGvq4abisF+SudbGTo95ubivQ1QF+s/f0dE558pbygf6DUfwkfaKCOjmm3thEbhygdTmmDfYiuuPslhLRUwPGgUVWkoI4LtwstK8Eee7KU4vRGiiPyEqwAiX87yblLwv9hkZlJoBAzJfAVWx4ZAhGTH+Yzy6UfTyOgYV/NHIhPaH+p77enWWKzTxHDPdsUZeycAqekBT9pqiJbox6Q26G2OB+EHg56O8liqshaEHbfWkY4kqgwX0A8rMLIGMxiXdGdJhrZRPxtvezyI3BpfmvZ1KDBmno0qSfXiCG8h3CaPwrSMLZu0gudsSxik6hBPfp2NLYAftFUl+Dlfn6BNF5X7Ig2izGRd40V2bwiCrsb5iO99K1+rfHm8fCYyerD9t+EPL7XFTz3JOVqukNhhaw47F85kbn7PRvK+sobgb07BDfIVMGA9l5fCGLB0JuVE7el2nIjuUDIziEpfLG1im+PDn1BtvvSg6B39NXx2jcpBTPrbiWSCFCGdhxcRsmIWu21Fg0KJOzq8ArXWEzJHH5q9FAGg6U082FGNKApl6feICa/w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(5660300002)(4326008)(36860700001)(8936002)(40480700001)(82310400005)(2616005)(6666004)(2906002)(8676002)(107886003)(356005)(36756003)(426003)(47076005)(7636003)(82740400003)(316002)(336012)(41300700001)(70586007)(86362001)(54906003)(16526019)(70206006)(186003)(40460700003)(110136005)(83380400001)(478600001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 11:23:18.7850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b53c8e-f58d-4120-5e3a-08da96438680
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4309
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amit writes:

Quality Of Service tests create congestion and verify the switch behavior.
To create congestion, they need to have more traffic than the port can
handle, so some of them force 1Gbps speed.

The tests assume that 1Gbps speed is supported. Spectrum-4 ASIC will not
support this speed in all ports, so to be able to run QOS tests there,
some adjustments are required.

Patch set overview:
Patch #1 adjusts qos_ets_strict, qos_mc_aware and sch_ets tests.
Patch #2 adjusts RED tests.
Patch #3 extends devlink_lib to support querying maximum pool size.
Patch #4 adds a test which can be used instead of qos_burst and do not
assume that 1Gbps speed is supported.
Patch #5 removes qos_burst test.

Amit Cohen (5):
  selftests: mlxsw: Use shapers in QOS tests instead of forcing speed
  selftests: mlxsw: Use shapers in QOS RED tests instead of forcing
    speed
  selftests: devlink_lib: Add function for querying maximum pool size
  selftests: mlxsw: Add QOS test for maximum use of descriptors
  selftests: mlxsw: Remove qos_burst test

 .../selftests/drivers/net/mlxsw/mlxsw_lib.sh  |  14 +
 .../selftests/drivers/net/mlxsw/qos_burst.sh  | 480 ------------------
 .../drivers/net/mlxsw/qos_ets_strict.sh       |   5 +-
 .../drivers/net/mlxsw/qos_max_descriptors.sh  | 282 ++++++++++
 .../drivers/net/mlxsw/qos_mc_aware.sh         |   9 +-
 .../selftests/drivers/net/mlxsw/sch_ets.sh    |  15 +-
 .../drivers/net/mlxsw/sch_red_core.sh         |  23 +-
 .../drivers/net/mlxsw/sch_red_ets.sh          |   4 +-
 .../drivers/net/mlxsw/sch_red_root.sh         |   4 +-
 .../selftests/net/forwarding/devlink_lib.sh   |   5 +
 10 files changed, 332 insertions(+), 509 deletions(-)
 delete mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_max_descriptors.sh

-- 
2.35.3

