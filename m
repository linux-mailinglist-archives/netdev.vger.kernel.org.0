Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC1A6E5C0E
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjDRIb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjDRIbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:31:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CDD7ED8
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 01:31:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECBjtI6kDyOIUG8rpN2Y4q3r3J88avXaXSn7dk2whY5iX0SF91F6NsgaNuEgjLxHuBiUsZhTtCy685uLdYWeizCPDPHF3BOs+2dQ4BnuuK569xc0yGxeaViNuKpk82+FYJH88zE/fsxFduzKE3GBmc+omMu6mf0ADTm0GN8UBnnkOOW9v5nDYL5T89hZP22HH8OxSMXsgGmwLNZyRwk5RCpF8hjxe+835f/sQH6Z1J+0Jyb87/0qoaiSsKyx6HiormVbRyRVR9Tu1LNg/ZX/upPwyy+52WNq3IqJAWOkVIKLuJetQysQDN75tupjimPxZx2ANXJ3BkxNF0XaGozE5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yoFJwwZmbzVx8YVVFLDZ1HzKqo4X1v+2Gs528PyXIPQ=;
 b=JZczAKT0WE4a/MwvZrRfBEBErRahi1I7rnfYEnpCVkQWD6YqEsM0m57m/mUmLuiliMFj492AeGMnP0ngm3J7GjPpkhxmvReweBtATugzfgZWEN7tbcbBVKk0+YTFkxJO7RXvw+7+PbNSs/y49F5gvKSP0Nj+CfggOjhVfr9Xzxrf7Bh+irhF7/62mbiOq09cNvZyowot1j0VLnbx3Pt/SbEWpLctcrWKa5g9ExEpUKooRC3fxSTmhROaVvcqWXShPKYF1LPdCKwVCofeYbGDwBxlEvAqlc06PwbdBRGdadsX9tdf+ZJqlUACWNLulREwcoDPtDdZo2j8rdCYWqfATg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yoFJwwZmbzVx8YVVFLDZ1HzKqo4X1v+2Gs528PyXIPQ=;
 b=oYVyc+jQ2Ynm+b03U63MN3jEhjR2AopW3RPJ9r1NK/TGvA9m1xMHmQh0k6eCQ7ORp2eohR4xpPvZHVoHxuJFR4YxzfjPCFKehKxiO9vLCMdJeJu3TrRqghi6tAjNBLniHijI97eDvMP+eM9BSEsXnwIaCPa/2/1bfwDSwb1lhSymtf6i0RFcSqrtI5jFN3bmnNThYX2xDxjqNATeEVQ0LBLmDT8H6IlnWnhtlQ69rgqpGtsVQdYqX4kCNJ2/mglqBqFbQcE64PjhSB9u7fgvtw5+6YsAgzStZEkWMwmQtOhTG0cxXmV2GwlwjRWpzoVzmhlKx+x6Q7lm2EyKIS1/2Q==
Received: from BN9PR03CA0942.namprd03.prod.outlook.com (2603:10b6:408:108::17)
 by DS0PR12MB7876.namprd12.prod.outlook.com (2603:10b6:8:148::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 08:31:28 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::2f) by BN9PR03CA0942.outlook.office365.com
 (2603:10b6:408:108::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Tue, 18 Apr 2023 08:31:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 08:31:27 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 18 Apr 2023
 01:31:14 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 18 Apr
 2023 01:31:13 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Tue, 18 Apr
 2023 01:31:11 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 2/5] net/mlx5: Enable MACsec offload feature for VLAN interface
Date:   Tue, 18 Apr 2023 11:30:59 +0300
Message-ID: <20230418083102.14326-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230418083102.14326-1-ehakim@nvidia.com>
References: <20230418083102.14326-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT024:EE_|DS0PR12MB7876:EE_
X-MS-Office365-Filtering-Correlation-Id: f1bdd97c-4d95-4e6b-50d9-08db3fe74db5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GXWN9OSuzf93Ab3OYMweCxwy8UVFUSlDimK2hH/8UxYmq+gYSVWj2obHu4fxDvLysNxf57eE3FwzBg37Egbn8JHrdmmu+4d6CNF9W9doMZWXaowDbfnknEIS12AI9YGX9am25TlPaMLW8LMXK0f9/j+5PdbYyZe+GKbNhzhd6YOsghKvKQc8gs7M5KlruD/BpKmUI2NaJGea+aqaOyhoKYk6l6CY7TAJF+D9pEu1Sbr8k/hZYOI4BLpZmFF8e+DSEgQEq+jJI9F0bUiw2FEa2xo1t0vNVfgzpmut+KNE8mAE6FRnjrJcVhXXXtKL9UPdDDJd/dv5Nl/17nxQAxNySMtf+cuwZ2P3o3J5nRm+MRCmQP4XIRW1zWepV5GeDP+j3iRVf4nPXrKWKDvMQ1MxZFR5QSDxjNB1m1Vl8mjZEenJTi/yuxFUnZp9fXRHK1ilDxqGkUXQkifQ/7ev27esosmhuKE0q4aCQgrYNH5jQBcoEygwy9FKKyWJibadmuycyexM4cDevSXt4Yqw8yF8tqf69cm8ZfE6k8U/wkMKh+oJ9MAgTirvaq+xk1KYbb+tiy2W4EpERkV/Jj9sFaCqfPs6uxj/WdapIRCUN2SsEBQHOYzxC78IjzIsxghE/Y054PBMvE/19uDH4vB1a7IjUEyuf6Juq6opxxsHSwmqAeS2kqGL8GGWhrkxy0tYD8+xtoR03t1zbiFWUrBhLlKBTVxI8VKIbNTTs70qbyvndA65lyEm+HvmKgHn55jRhkin7q3rduI3v5hITRrRnqsPpVCChLB0edpe5Wx1NdJ9XvA=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199021)(46966006)(40470700004)(36840700001)(36756003)(40460700003)(82310400005)(2906002)(4744005)(5660300002)(7636003)(8936002)(8676002)(41300700001)(356005)(40480700001)(86362001)(478600001)(34020700004)(110136005)(2616005)(36860700001)(26005)(1076003)(107886003)(54906003)(186003)(6666004)(7696005)(336012)(4326008)(426003)(70206006)(70586007)(82740400003)(47076005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 08:31:27.4749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1bdd97c-4d95-4e6b-50d9-08db3fe74db5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7876
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable MACsec offload feature over VLAN by adding NETIF_F_HW_MACSEC
to the device vlan_features.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ec72743b64e2..1b4b4afa9dc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5125,6 +5125,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->vlan_features    |= NETIF_F_SG;
 	netdev->vlan_features    |= NETIF_F_HW_CSUM;
+	netdev->vlan_features    |= NETIF_F_HW_MACSEC;
 	netdev->vlan_features    |= NETIF_F_GRO;
 	netdev->vlan_features    |= NETIF_F_TSO;
 	netdev->vlan_features    |= NETIF_F_TSO6;
-- 
2.21.3

