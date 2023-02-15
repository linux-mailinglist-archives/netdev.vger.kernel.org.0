Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183FE697927
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbjBOJle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjBOJld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:41:33 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2080.outbound.protection.outlook.com [40.107.96.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB1623D85;
        Wed, 15 Feb 2023 01:41:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knmwDmjJofnVcweVXxnEqDoAcigaeaGwepf3xGUCfDTPZocgpzSSqC9Wu1+KIxA/nwPwz4LNS5Dn1VbDfYnMWxeHZRPpvfPLKVw10LoSolS6nYSlpB9Om1vzhJcQyP8mHGLp9MPw5myLBULIgt2MVOGNOzmbeNPQpX0jWOsOT7vDv1zO6/fc1sBJQJ8nCcBMPL8Wtkxjf41/YfBHARxOjKDYiWW9V7Ggr2Tbw7Qs76XCeHk+niCLYFg4l/lXHr95OWq6iPSpbLPG3zROEimFqmld861xAENugrtBvUDSGD9TJvwkcV/DLCZdSsFDcCJ3wD9ukjqj/2P3Ryv01WfSEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcOYIBT25yVOTbfGzalJkeapR8qDmurpwafs//tH4q4=;
 b=kCsu7yyH4EB8bo1uvOsS/Laoj3/UUzwjOkF+uqZg6af0O3UQAXXn8MmfByLX+5lrHUZUDTFNZFrKucT1w57GMH8rT88qe18Pv8fASk6iJ5m8fODWUuQA8gEiHXhyK6UpNdqYl7V8ysCVmMrLV15NZv5ggT62u5a7yuC3nk3KuD57xzWAsCfxFnGL37OY6mrUT0LmE4MUKSzVyk4EO0e4y2djZGGoXC8sJeA0wgQ9PKrAtPi9grS2eSvntDpbmvHPEGQWdjWh/CdFMVG02EplTE0p3vpZmaZBwjFzcTme2TjTZat+Cv+NAMi80/mGt7pEAnQQJERpUuR0hwoOfWtKlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcOYIBT25yVOTbfGzalJkeapR8qDmurpwafs//tH4q4=;
 b=b0Xw0zJRfKc4Zd8R15jVVCD6/REzsuaHcJmx6XkjSpVc0W9h+KQw4ycJThPEqfIYMaV7NKp5l70XE8Lhpq1pV/s5dxJDu8JzhuOU8WUfxzDdPsWhqb6dipv4Fc75txPDN0JxFuDEXGeykYvkxK04Cl16fNsJRIgzuuciPb57O4U9v2NDnnysrmoeiyQ8laa/2GtCU980lmi/RZR2XsAdB4zKuJRRt/+bxu/xZ7dE2wGYb7zDSFehw0GqEVp7hoPVtpLxGSfj5l11kESXTb4vi9pvaakZZlQm7U9xrqPSIoLmoY23inMKl0lXAT2iZQjw6YE396onW67n6dmtE0rP/Q==
Received: from BN9PR03CA0165.namprd03.prod.outlook.com (2603:10b6:408:f4::20)
 by MN0PR12MB6344.namprd12.prod.outlook.com (2603:10b6:208:3d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 09:41:30 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::17) by BN9PR03CA0165.outlook.office365.com
 (2603:10b6:408:f4::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 09:41:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24 via Frontend Transport; Wed, 15 Feb 2023 09:41:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 01:41:20 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 01:41:17 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 0/3] net/mlx5e: Add GBP VxLAN HW offload support
Date:   Wed, 15 Feb 2023 11:40:59 +0200
Message-ID: <20230215094102.36844-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT006:EE_|MN0PR12MB6344:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fafd5ac-0195-4184-3813-08db0f38d0cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ebq4lw7KSf9BUyri/gNh9+Q0PBnJl2czUtgKCiOuYcQL5zOxAaJ2i43etY9QZQpeU66mimPclCssab8gy00vo7K6fOjcso3aaRhxHpTOzN5stFCTPN978k0etWzP2fDZd1LIx5DFNhApLrrwnEQwx/wswK8xQD3wQqQRvIYx8r/A0KTW4INBN4pZj9XsRF/vzFrhTh4ZffxH7TO9Gs/96tkUMqBU/6/ZXS72u68t0BcGSzpXjJy0YO0STMMfLw+mW0DwdBJUjSKXGEkbQUG3ZPSVOY/E6YaCqll3V3FH+AR1dtPoqW3eORNVtGY0N5oR6iA+H9SU/0sROj0qL/bnSRTlv0irdAZ3jhk0BDEbdpTM1ecZ39TMXL36xiivNogyuSirp2UyWQZPLExrYQuDCzcUiR/zXZ1MIoAKfM9ekMtzsAeZR5sAGCmyqSEBSrMhKhMbCdLLGMXngE+Wk21DnuS/JlUQlcjyKPseR+yzh02xhIuRr77ROfCuvYoZB12aCrW6Hx++k6ymTMsghwRYhJTr0Kytph0Lf11KUMBxNtwEr2cZLGKtZbavbSPocPPEn5qB/mT3zkjloiAbrE59RCZJSFDuOqfAMsT65IomRyk7p6Dd/17Ii6agh5QQarH9p5Ab2wMduwVmgenMpcZxmUWhfWUfdQvyKxkxgB2pSlgLF2r7ETTh42b0TZxCexh8bj9QeIJ5wyY7Qdn6poiCsQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(451199018)(40470700004)(46966006)(36840700001)(40480700001)(356005)(54906003)(55016003)(41300700001)(40460700003)(7696005)(4326008)(86362001)(70206006)(8936002)(316002)(110136005)(70586007)(8676002)(82310400005)(5660300002)(2906002)(36860700001)(83380400001)(1076003)(7636003)(82740400003)(26005)(186003)(6286002)(478600001)(6666004)(16526019)(426003)(47076005)(336012)(2616005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 09:41:29.6565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fafd5ac-0195-4184-3813-08db0f38d0cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6344
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds HW offloading support for TC flows with VxLAN GBP encap/decap.

Patch-1: Expose helper function vxlan_build_gbp_hdr.
Patch-2: Add helper function for encap_info_equal for tunnels with options.
Patch-3: Add HW offloading support for TC flows with VxLAN GBP encap/decap
        in mlx ethernet driver.

Gavin Li (3):
  vxlan: Expose helper vxlan_build_gbp_hdr
---
changelog:
v1->v2
- Addressed comments from Alexander Lobakin
- Use const to annotate read-only the pointer parameter
---
  net/mlx5e: Add helper for encap_info_equal for tunnels with options
changelog:
v1->v2
- Addressed comments from Alexander Lobakin
- Replace confusing pointer arithmetic with function call
- Use boolean operator NOT to check if the function return value is not zero
---
  net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
---
changelog:
v1->v2
- Addressed comments from Alexander Lobakin
- Add a separate pair of braces around bitops
- Remove the WA by casting away
- Fit all log messages into one line
- Use NL_SET_ERR_MSG_FMT_MOD to print the invalid value on error
---

 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 +
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 ++++++++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-----
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76 ++++++++++++++++++-
 drivers/net/vxlan/vxlan_core.c                | 20 -----
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
 include/net/vxlan.h                           | 20 +++++
 8 files changed, 147 insertions(+), 47 deletions(-)

-- 
2.31.1

