Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A3C66847E
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbjALUyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240207AbjALUwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:52:55 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B1FB1D5
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:26:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4ng7rFVe3Xm3DgiIr3bq1yLQ2hax8lv38QdcR6LM08Rp3gwMBl2nLQLD+93CUgx2jL3VutU4qYryGKeGT+3nU1cLcU89ys/vW4nRrziyuT9wNWTYkYhyVI6GERoAZUDkXC5YP4dNBvpfq8RzyKRnDOk7T5CEq6V1Rt9aSv/ZycUbACs5xBtyJYgY/1PyxvX/RXrT4ZJzxgA5GGAH0dminkBngnrHt0mBzRlh5t7tsW1fVqdm0PWlO7GXvEFHmaaOF/rRDuSqhoB8iQDtC/Ro9zMfRrKa85SjXPO7c5UGtrapXvTeBRvCIrD7cS5Ucx8SIhI5AXEfRMqb7cPKq1z7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I95re1kYChyOtjtrflGsvcDcvwWSZcTd8/BqBNPtz84=;
 b=lZEwmayiX/xDjfXB14ZKPxASoaImZQtH6/WOxq18efp74WGfwdNQbKiIh+UNQ2h0Y/aNqQxe+RRKovfvsNG3eewgZGl8aKicyMDidGxoiwnMagjDkugkY1t6LOK2xe4t/lYHA+gHcOjCV90zPo6V8PpsF4DvFE2+cbNshAzFkCXgSg4EmHgCgBkIYmuvgDb17VBqTLoglHDsnEDV4fEbSNRN7KgsN3BUCmxn1YGdfQzeLnepqszOtqY0JpHRzbJIdHBkkmrctPsLZ4EnOK/UkPhjArcpi704IdWckP40IaArNSRigFsAYe8p04QW5AnTVhs/Uh96b65QvQx1Ek/tCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I95re1kYChyOtjtrflGsvcDcvwWSZcTd8/BqBNPtz84=;
 b=pbUY3JRIfZoPEKwYXUVGDfMsqeNnsXOefC+d04BD30OYvtBVbD/i41ckGjHfJzhWw31SX7A8MRawVoxcjRHe4U6vf7DiQ7hHSrFU8Ii5jy7JgD9MX2P+S1sss4G4guasyUZdcWnEla0VLjr3fw6WjKiD249ioEaijXEHHOKjHMeLNDiuZa8F52hpQfqGOUGAeqYIJDQFkwChGCCiWgjsLj7+Gn3qfsMzy0sqAKWpkbXxYzxUqaYCUCJlooMT7tofmd9oPuacKfRbCL/LQOOzyJ5jLHie/dgST2kgvPItNdnrSYID5MxFFfSgmgh1giB+t/DANbh3gn+yYpEy1KTmbw==
Received: from BN9PR03CA0436.namprd03.prod.outlook.com (2603:10b6:408:113::21)
 by DS0PR12MB6654.namprd12.prod.outlook.com (2603:10b6:8:d1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 20:26:25 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::da) by BN9PR03CA0436.outlook.office365.com
 (2603:10b6:408:113::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Thu, 12 Jan 2023 20:26:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 12 Jan 2023 20:26:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 12:26:18 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 12 Jan 2023 12:26:18 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 12 Jan 2023 12:26:16 -0800
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>,
        David Thompson <davthompson@nvidia.com>
Subject: [PATCH net-next v3 0/4] mlxbf_gige: add BlueField-3 support
Date:   Thu, 12 Jan 2023 15:26:05 -0500
Message-ID: <20230112202609.21331-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT040:EE_|DS0PR12MB6654:EE_
X-MS-Office365-Filtering-Correlation-Id: c5cbf3c6-61a1-4f74-1b33-08daf4db46ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5oVJMnGaqtz4C8baFRtgwBnKiuS3r1G5GamylbXzyHCHiBXgADrJZo0m7rqQo9BUouJqdEr5z2PB6/9JUAOahgR8OgdZJFf2Ym3G6NzUUBI4ll9ag8nikG3cEELOXny+EDBwCJXzfW10P7XGMNcHnSZcOzxa1aQCIbQ1jwuTvxZ5m3dvOJpibQ71uOwqAdkIhQOzqZtJRn8y0YWXsQodCEa9XCI3jBnYMS3p5DAz6MQ38+DUQ1FW3z99riU1SIy1lvGVSRKzBGcJ+GtEudthjFXhfRjx419h+95oWhiviBaC0Qf+G0GGftS2GEJVtnwtJMruOaXcdJGQUBvPLsfPX8MgkmuKCRbQFu5E0IWfSl1vswhyIK3UheceJsv21zetKxEz/vsMJbHzXkXBUWBmeXQLspnHNzXxpoONU/8tL/F+pzqjuTs+YsoPkawu5ECkzmihcutvFVPKOfNJnGwIlcizYz7uamgLz/nUi6dzIcEjtI4/aAdP2dXAd4Ezgv7smz4B3WC7scT/0tnDTfITQwdMklSc4B25IUQFKBWi++KseT0dNl42H1ul+IkOVOxTZMd6OZkX70xQiqPVZdxPofDqchpw1GLTIWJIgkaywYDY6aMhCOFvO0wX8KKjP1WwxJKVcNhnBQwcfhsdlHeuhi2wYRvPAE+pWWsXGNEvkY+OtL8LBrDfx7x1y8AEg/c1GpvVR5CzlFyIcNMfUdMIsQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199015)(46966006)(40470700004)(36840700001)(70586007)(4326008)(7696005)(8676002)(316002)(54906003)(70206006)(110136005)(356005)(5660300002)(2906002)(47076005)(8936002)(26005)(41300700001)(426003)(7636003)(83380400001)(36860700001)(36756003)(107886003)(478600001)(6666004)(1076003)(2616005)(40480700001)(82740400003)(40460700003)(186003)(336012)(86362001)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 20:26:24.9365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5cbf3c6-61a1-4f74-1b33-08daf4db46ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6654
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

The differences between BF3 and BF2 SoC are:
       * In addition to supporting 1Gbps interface speed, the BF3 SoC
         adds support for 10Mbps and 100Mbps interface speeds
       * BF3 requires SerDes config logic to support its SGMII interface
       * BF3 adds support for "ethtool -s" for interface speed config
       * BF3 utilizes different MDIO logic for accessing the
         board-level PHY device

Testing
  - Successful build of kernel for ARM64, ARM32, X86_64
  - Tested ARM64 build on FastModels, Palladium, SoC

v2 -> v3:
  - "mlxbf_gige: add BlueField-3 Serdes configuration" patch has been
    removed from the patch series, as this configuration is no longer
    needed within the Linux driver.
  - "mlxbf_gige: add set_link_ksettings ethtool callback" patch has been
    split into two patches, moving the white space change to its own patch

v1 -> v2:
  - Fixed build failures in "build_32bit" and "build_allmodconfig_warn"
  - Removed use of spinlock in BF3 "adjust_link" callback
  - Added use of ARRAY_SIZE() where appropriate
  - Added "set_link_ksettings" ethtool callback for BF2 and BF3

David Thompson (4):
  mlxbf_gige: add MDIO support for BlueField-3
  mlxbf_gige: support 10M/100M/1G speeds on BlueField-3
  mlxbf_gige: add "set_link_ksettings" ethtool callback
  mlxbf_gige: fix white space in mlxbf_gige_eth_ioctl

 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h |  27 +++
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c  |   1 +
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     | 109 +++++++++--
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio.c     | 172 +++++++++++++-----
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h |  53 ++++++
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h |  54 ++++++
 .../mellanox/mlxbf_gige/mlxbf_gige_regs.h     |  22 +++
 7 files changed, 372 insertions(+), 66 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h

-- 
2.30.1

