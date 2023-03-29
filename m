Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164666CD943
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjC2MV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjC2MV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:21:27 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2051.outbound.protection.outlook.com [40.107.102.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A4119AF
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:21:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaybeEwIN6jc/ZoGO/VcNv2iFybqgmB/PERqVKmQFimOkDJAk7xZStI1tX7cE/oSvDfl/TPAMaYBWIkaaPCCgdaCmrQ7+PxPQSxHfl/RYLlgLGhmLhDNVEh7aDaDyViSSqryBhgJwWCR/sz7dR6oeMbkXLqv8kadIbrKm6QWdil4Wney7MNyUl2qyWzVQCSWAh4cukLBJA2qtPlEDeSJdcc5LEbEC1LSfobL8d+oZxRCzWzqxWMy77d4ynOejzUlDsdY9VO+BRsNUgMH/dtS1Vvvc4vAo8kmeiJYgIvvSao8OvwiUw4KXBENL+ThHxnZ3D5lZXwaktxqStq2af6g5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbeqogouO/ldiCH4JytxlQSJZzR+hY9MNfXtbyb85CI=;
 b=KhVpGAbrtEbgrgsW9R2+nWffbjidqnaFSIhAaJJelmA6f1gE5CPdamI5jjJ3z0C4qrQ11DUF4INF1W/HxDbbKY/fDgiqwEAXVAr1OOUMFQ1yNCG+mCCZvzg5SVV1DeJ55GbNJIkaPMtEaK9tFdX7Wg7hPCetyUfKRhRmw8d14O8t5bxBfRUkE/mm6bMYCNGlr3GxJhMctc5nAyRL7vVxEDXCVfB1MrorNcG4J+Eu3gEareA/gAb+/my1us3ZXUltVGpIPyzyisF/x69V2MgMXWCRNY/+I4vcNEnVuxvFUg/NY51IUcZtD+dq6PoDjKzYxkrqRj/SaZv5dxcpYz+YhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbeqogouO/ldiCH4JytxlQSJZzR+hY9MNfXtbyb85CI=;
 b=jmu5ohcNcTm7kdnor+5Ds7Uy5SePSTbx7xr+j4T6SK1V26yMCvAU5rQTEqnLP/4g2/D87ERTdnFyW17vOHO/q79CbNBL4n8QIhhbHRxwSaxgfr7gS8YWiJEqDCWvoyzMQ70t84EaxTSiFtgz4Q/+O5UrZG9GoRFnBaPCuFMvGXMQ3c6A/3JbkO25T9tjwy1yQ5kqCV78XfVQrjBRJqBkGJu1D2GYZikM/rMn1ku5fEwywrYqo3NyhmHyLwFvXNiR4xZlTFRSLyh18LqFn+c+zCbpQibU/8fMHBAHUadtcU7aDZU+ZKEx7VAn76SCBLP8klL8eUTCT+LPzPg3mDu/1A==
Received: from DS7PR06CA0004.namprd06.prod.outlook.com (2603:10b6:8:2a::19) by
 DS7PR12MB5911.namprd12.prod.outlook.com (2603:10b6:8:7c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.33; Wed, 29 Mar 2023 12:21:23 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::e5) by DS7PR06CA0004.outlook.office365.com
 (2603:10b6:8:2a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Wed, 29 Mar 2023 12:21:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Wed, 29 Mar 2023 12:21:22 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 29 Mar 2023
 05:21:15 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 29 Mar 2023 05:21:15 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Wed, 29 Mar
 2023 05:21:13 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v2 0/4] Support MACsec VLAN
Date:   Wed, 29 Mar 2023 15:21:03 +0300
Message-ID: <20230329122107.22658-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT022:EE_|DS7PR12MB5911:EE_
X-MS-Office365-Filtering-Correlation-Id: 8abd38d7-a815-441b-623e-08db30501bf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fFbxbIguuEjvryA77zw2m5az8N0mpaZZn96cETdawNS1lqIUHDSzPZ2jqiE2jjaoPYMzbCTSn1+5mqo4HlsTjuPIpgLKqlLabQ+p3/Je9guIs262fHZ5+Chaj7BpqH4oRWuPVtjPYp5jeTn19eBcR48LUn4DPWSKzLqufEvjNVtcv2zNxiwCYV5ssBHNhcCbwswhPQQK09bnTVWPZdIDTw50AXNpFFEquo2DC280LEbD11v8GYoMWGVtZ8XLBEjfoRiJBSPZKyX9Eb/x6RxX4xrmGEZBhWz5wZFER/Mfh37YpvRNOD0bBG7mj9jlfXjAPaS3vLYMT7c9LuwN6CIYZpPbsOze0l6O0Qz0m5uXkcct+YkE+/fyObxTf1smjtIELsDkX5HI1cPp7wz+0338pgVwAo9sA8n0ehXJDWrWrWIO7A8PcJ25EX5dgzjvfn7lRJNAznIPLT3VqJ+MNsWtFj1rTePq78j/cNRQgIbPXavKE9kPOe8BK65iBDSd2O6kwHF/bEezvPF4fgSAOGEDArcrXGaU9SpgozY6vVaGY3sEpQfVy5/F+fn2hlgOiJy7w8d0ucanf50T69YOXFh1sCE/GLWSVvPAgHNqXo18/dvHbl+slWi50SNXHWhgDzeH4YyMO6s70vgtnFZW07P8gWpXJz0ryNwK71X+Pz+Hlx/qmasEm8pLPix2CCLfjXCKj1EKxWh3R9XYdLzZq42Ms2kgJqF59eyO5p2ABXv7TACYOxEiHVhTcv8n3zHeQ3Awck43qOVHo9dDngIk5iZcxzdxg/lRtjQKTosdwEoXdtY=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(2906002)(82310400005)(7696005)(40460700003)(36756003)(110136005)(70586007)(4326008)(41300700001)(316002)(70206006)(8676002)(54906003)(34020700004)(36860700001)(478600001)(5660300002)(40480700001)(82740400003)(83380400001)(356005)(7636003)(2616005)(186003)(86362001)(6666004)(107886003)(26005)(1076003)(8936002)(426003)(336012)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 12:21:22.6496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8abd38d7-a815-441b-623e-08db30501bf9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5911
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

This patch series introduces support for hardware (HW) offload MACsec
devices with VLAN configuration. The patches address both scenarios
where the VLAN header is both the inner and outer header for MACsec.

The changes include:

1. Adding MACsec offload operation for VLAN.
2. Considering VLAN when accessing MACsec net device.
3. Currently offloading MACsec when it's configured over VLAN with
current MACsec TX steering rules would wrongly insert the MACsec sec tag
after inserting the VLAN header. This resulted in an ETHERNET | SECTAG |
VLAN packet when ETHERNET | VLAN | SECTAG is configured. The patche
handles this issue when configuring steering rules.
4. Adding MACsec rx_handler change support in case of a marked skb and a
mismatch on the dst MAC address.

Please review these changes and let me know if you have any feedback or
concerns.

Updates since v1:
- Consult vlan_features when adding NETIF_F_HW_MACSEC.
- Allow grep for the functions.
- Add helper function to get the macsec operation to allow the compiler
  to make some choice.

Thanks,
Emeel

Emeel Hakim (4):
  vlan: Add MACsec offload operations for VLAN interface
  net/mlx5: Support MACsec over VLAN
  net/mlx5: Consider VLAN interface in MACsec TX steering rules
  macsec: Add MACsec rx_handler change support

 .../mellanox/mlx5/core/en_accel/macsec.c      |  42 +++++---
 .../mellanox/mlx5/core/en_accel/macsec_fs.c   |   7 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 drivers/net/macsec.c                          |   9 ++
 net/8021q/vlan_dev.c                          | 101 ++++++++++++++++++
 5 files changed, 144 insertions(+), 16 deletions(-)

-- 
2.21.3

