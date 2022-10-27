Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB2D610540
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 00:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJ0WAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 18:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiJ0WAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 18:00:37 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2058.outbound.protection.outlook.com [40.107.101.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CB87B7AC
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 15:00:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIepKG7c8xZgnaFtpx90/4pMU/VjV7nNxz9sAgwiRZXtGLB2x2CzehJ/yJ3QcvU0rDAKaQ4+zu9iDXH85wvM9NlgdixlBu5MTxCxgqJcGKUP1MaXa073T8o4M6lVCymcgBlLQlmPgP5tih8PupysALIaSCC0dfguOGuMF+ZBVCoRY1MWPWpVO7Br7UVB6RxwAmJn7S/Z3nDex/ieaxYbuQfb67JP7y+dmuAcW9xS2rdnjjxRP8fnjevg7kaWgMrDBb0Rloeayhlxi3oDrflm00ehH0jS5HMO1BJpKfU7zeHt9T2Ss7/t7ft7yHKK/KnZqzKD7HnR/q06z69feDed2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xOdG1ModTA1erYwL/lKOAsBYxGQtCGoD12jbAb2iMLA=;
 b=hCmQiN9/uuhksL8JyRcIe5hL3kDJEeaJesywmB9sqSpV6uOgtZb/q7AEnxUbo7nFTbCF65KJ9CovrmQJ5v7CGYYAKxro4bMCOx8q/APjqd0mOtR8lx4XypXxCHgOyRYf2QiwHyPA1DZOy3yxhWsR1uqYPh8TCfWQNB+IUQbPBrNQ4fBe32PrsHsL5YeFtzpMtVX7MffwQe4Ryf3FjeR7QKiEIZyZlhcsS9pCTGSNHw9fofNG29ewtFHyuOkX752b1jpAiBWJn2pYWr/AOo7M76QOJyyZcKyaOz1wCtuc5I3ezOhiJ6WpPOewzdM7RxbNafOtdErDzq/cJHCQYq1p5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOdG1ModTA1erYwL/lKOAsBYxGQtCGoD12jbAb2iMLA=;
 b=Ec35S0zb9C1CZ6EGsBAxnOCxgEHuYjOqVkefGWj5gtZzHBrUoY2jF9Yl82m3hhCrCt8OQGD6ryp+CZiQmD89lEP4Q3mbSe50eXGV/jgHnHxTTihPDBLkoYNb/LLpMW/Oe6zzakWfzgeVATPA9Lb8pDZU2XoZYJKgxEzHmjIp+BeOJwlcPfHQvc5lf/QVRgdiP1VnjALdnM6yCXYacS6YYWjhgri4ZFQJodAryY+pkGhzSmA0uBaA9tDi2gcVafR9MurAc3lSBWiqw9b0ozwDWVqgrQaFLO0W4BHEKe7s1PHOlPZftNKH/vQS7Eet9x0FOBAuTSLeKkQWZGFdmTdMqw==
Received: from DS7PR05CA0015.namprd05.prod.outlook.com (2603:10b6:5:3b9::20)
 by DM4PR12MB6182.namprd12.prod.outlook.com (2603:10b6:8:a8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Thu, 27 Oct
 2022 22:00:35 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::dc) by DS7PR05CA0015.outlook.office365.com
 (2603:10b6:5:3b9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.9 via Frontend
 Transport; Thu, 27 Oct 2022 22:00:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Thu, 27 Oct 2022 22:00:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 27 Oct
 2022 15:00:19 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 27 Oct
 2022 15:00:19 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 27 Oct
 2022 15:00:17 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, David Thompson <davthompson@nvidia.com>
Subject: [PATCH net-next v1 0/4] mlxbf_gige: add BlueField-3 support
Date:   Thu, 27 Oct 2022 18:00:09 -0400
Message-ID: <20221027220013.24276-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT037:EE_|DM4PR12MB6182:EE_
X-MS-Office365-Filtering-Correlation-Id: 5690c03c-8686-414f-5af7-08dab866aca9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7e2T8FF/gVPXfzQfFPWdMl26dqf7Q1xW/Fq3abOyoCmtgj4WF4y0Lg0TKAhAvhUb9i8xUz4PbfVkYMOV97yJip3pbF9GNcugvyHCdtwm8LIDTr7pY0nMrB/mBnxl5V1H1YFkrnRTJtPmA5y3q2u37yPiQcDBwK5YxmkCKKQd9qqjyFVeey1RcNBjiGSUPhAZ3Rb49qSH7NKrDVBy8vBRQviy+Fxkn/osPhb7hs0ZrSuYyBNoN2SxcLMb6hhu2YREZkqFU/2zvEps4zFhaG7sRy2Wk/tJx/roA5uFGNJewsBcltuNU+OgxLPt6IVrDLk7gklMKqteJp7Qs4qn5kt+B4fO2thGIo/kK0tAfOqCWhwAppuUQECwaCT+Z1hYkBHjUDX5N3f87acn3NYwjYGe0nwm6pw2CTRgYPnHNUQjtXR1p1FQBwEmZRzeJI65WhWItFBbGiXgmFH+d/5hdVbD9Es6yOTPdoG/zq83t9uwGgD7bDi/Oi95KvmzyDraaszrzd2q/aSao5rzRXb3HJNA8Fl0O/W/yYjUGE//pOE35oxX3lvUDSs1ERifR8YNqZ76I0pgvuM+F7aKUx3k4/cV6j6Eyo49AXe99a01h+ur3+ea3GqrAv3QZ0w9awBLXFkuzNZtun1pTJ2k0buNllSha01xEIiM5LRXJ7Anhj2TTHMsGB9vt3iVfrU6Kg6+nCK5viAta1lXqzF07dtWd5VfFAgzHbUr9B+8yMfjizeSU9Cdj5eQH0wCvxM2FhLYzDaPue5UYw76rrvEJhuaroDIw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199015)(36840700001)(46966006)(40470700004)(41300700001)(82740400003)(4326008)(86362001)(5660300002)(8676002)(186003)(426003)(83380400001)(356005)(26005)(82310400005)(478600001)(7696005)(47076005)(40460700003)(7636003)(36756003)(40480700001)(2906002)(2616005)(8936002)(107886003)(70206006)(6666004)(36860700001)(70586007)(54906003)(316002)(336012)(110136005)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 22:00:34.7739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5690c03c-8686-414f-5af7-08dab866aca9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6182
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds driver logic to the "mlxbf_gige"
Ethernet driver in order to support the third generation 
BlueField SoC (BF3).  The existing "mlxbf_gige" driver is
extended with BF3-specific logic and run-time decisions
are made by the driver depending on the SoC generation
(BF2 vs. BF3).

The BF3 SoC is similar to BF2 SoC with regards to transmit
and receive packet processing:
       * Driver rings usage; consumer & producer indices
       * Single queue for receive and transmit
       * DMA operation

The differences between BF3 and BF2 are:
       * In addition to supporting 1Gbps interface speed, the BF3 SoC
         adds support for 10Mbps and 100Mbps interface speeds
       * BF3 requires SerDes config logic to support its SGMII interface
       * BF3 adds support for "ethtool -s" for interface speed config
       * BF3 utilizes different MDIO logic for accessing the
         board-level PHY device

Testing
  - Successful build of kernel for ARM64, ARM32, X86_64
  - Tested ARM64 build on FastModels, Palladium, SoC

David Thompson (4):
  mlxbf_gige: add MDIO support for BlueField-3
  mlxbf_gige: support 10M/100M/1G speeds on BlueField-3
  mlxbf_gige: add BlueField-3 Serdes configuration
  mlxbf_gige: add BlueField-3 ethtool_ops

 .../net/ethernet/mellanox/mlxbf_gige/Makefile |    3 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h |   34 +-
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c  |   16 +-
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     |  170 ++-
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio.c     |  185 +--
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h |   53 +
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h |   54 +
 .../mellanox/mlxbf_gige/mlxbf_gige_regs.h     |   22 +
 .../mellanox/mlxbf_gige/mlxbf_gige_uphy.c     | 1191 +++++++++++++++++
 .../mellanox/mlxbf_gige/mlxbf_gige_uphy.h     |  398 ++++++
 10 files changed, 2027 insertions(+), 99 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_uphy.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_uphy.h

-- 
2.30.1

