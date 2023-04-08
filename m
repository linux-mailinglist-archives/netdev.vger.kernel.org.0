Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4356DBA4F
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 12:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjDHK6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 06:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjDHK6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 06:58:19 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E847E04A
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:58:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEyvWrjKvRbF4PNTpoh0VT8rcsgDfb8Y1GSbDouvR+LnUCYjNM0QgDrvS/NtJHat1iAUPDOBCwVLdTVKSljQEz2KziIzAEvWyDYQgm9t17QvyhaZFoO/ytTMRh2rQrY4nNujUJABchbKiPVZNZsegQkFpiHP6o5spLVl+CR3CZx1dveHYrzSV6BjT+mfm+Et9q94DhpLl9pcGQ6dpsfpvOvLHfsGUgL7t56V3BkJLGCFiiJNS+aep2l6RpMxfU30y4pR3IjSm/T4pbX1vHRsLfQnyh8JZkfkWQbIvlyX4Wu32cKG6UbX3ZwK5ihTBWD4whYG8rOu+NZAFoFkS0xqoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yoFJwwZmbzVx8YVVFLDZ1HzKqo4X1v+2Gs528PyXIPQ=;
 b=jnibBh7TVYq0crHPD24bPPUgqL5rEEpwuI0GfCuHz3MQD0uevfVls2eLm/9cuoP4bH4c14zUh+7z5iDJAI5PpEoESnZ3k6zHswcqBM8zT5g7s3ojEzRJ3y/1kyuBMhEv/ijovxvp2/sMILfhsjgTX2TK+z2epzZrZOZOr6jbAHsH3tWPqmpaAsSUYGd3tDIUDypTPIQAru6aLOhrydxtggogn6FkTQqsX0cbVwkAOrpFMivJgC+mMiNTwVK38mIfTf0tOBAE8dAzPmTdVqmsSitvtfn21OSAVykh72cp1InK+HUJmEbBkDgFjEkw9jLPbWa9b0QAl3VnjiLfQVz3tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yoFJwwZmbzVx8YVVFLDZ1HzKqo4X1v+2Gs528PyXIPQ=;
 b=FNK0kvcrSL+pDYwwY+K6c14pvMoqm1dKNsiwUkSfIVMgIzbDNkWw6g7jw6OOGcF2yCm4MRkyMmDZc28NMkA0I6uPgtcob2t+2+brQlv99zBdLVtdfp9EfRpnHjpUgHfwosi/ONnN3xlG/wLQBq+T6IAgnoHQHyquuu3wEDGdM2aCt3LxuuSj/sGXob0c0PYfQBRhIIGXQ68lzmW91rlStFA1vzUSKFHYVDAe5nuyxvZcDYyJ5DB3hmC7oxW+LCrq3GuqgPM8fX2Z5/+Lvrt01nddVgLOcn/XbygPQVmDakTPQiLLBtSAgPp+gdlz9YOOEyUj9Bk7NPzKng3n8G78qg==
Received: from DS7PR05CA0028.namprd05.prod.outlook.com (2603:10b6:5:3b9::33)
 by SN7PR12MB8789.namprd12.prod.outlook.com (2603:10b6:806:34b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Sat, 8 Apr
 2023 10:58:02 +0000
Received: from DS1PEPF0000B078.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::5d) by DS7PR05CA0028.outlook.office365.com
 (2603:10b6:5:3b9::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.21 via Frontend
 Transport; Sat, 8 Apr 2023 10:58:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000B078.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.30 via Frontend Transport; Sat, 8 Apr 2023 10:58:01 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sat, 8 Apr 2023
 03:57:46 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sat, 8 Apr 2023 03:57:45 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Sat, 8 Apr
 2023 03:57:43 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v4 2/5] net/mlx5: Enable MACsec offload feature for VLAN interface
Date:   Sat, 8 Apr 2023 13:57:32 +0300
Message-ID: <20230408105735.22935-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230408105735.22935-1-ehakim@nvidia.com>
References: <20230408105735.22935-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B078:EE_|SN7PR12MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f68078a-a15a-4627-a053-08db38201f41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2t2zOfLdXQs5r8YjPYNglf7q14ZPDwqIg3bh8Q3YxY2ciuEeSZttNaeRowKR1vqnvKtq+6ohBHo+RPNdcXbwnSdOGu840DEioccJJf12Uvjtl1IGzeZ02wwPQHA1FRmv6yGRAREqZIYr0v1qHJVluD9zpWWt4srqXkxjAdkKOjg00IL4KptPUFiyeyajLGhiBSt/RTlrtzPnNyHaSwc73bihh902eZMb3ukvx771TaJRm8Nah5iXNz0gqbakfbtI2Itmzb+lovNnKWWDYpYJjkCDGZ7KFok89OZ8+BRUoHhcz0h6UKK0pNIXp3ftmWKAAYQN1k6lgB4kL+H2yinQch5w9uKpsvJHWaLXu/vq71hRRcY+twd2Z81VDag3t4mXDw25R4/ohZJ8ST9afwXx4FWvd9PYDnCoFC+xA2Dz3DjfhdDS/yQc//S8U113L8K9s9/46YF12BPzO0UvQwjYVH1yjYvntpHm2BOLfOclQqwUjdxsmCTAVXricPoRer3ZfTAcCep8DgtVx79TEghS1U7z8Ib+8pRAiYEzK9efAgVUSwpWFyMEJThmQklhGLoa1fFltSS2YaUjYgk/L2GyAKNxNinU4UZ0yjnvv9fkF69g9Dakiv5/XMUkEU3qP0nQWmvouVbl7x74Iyy1/f/kV7EfRneqxGOncNsWjTQJrq9GW9uSKc9cI+0i018lJFSfZRkKNTjyqiPRN+O97cmxhQ0Bi5VT8ScQzLDIrv9tOHRrVFAQJszuNbIus3AP+bft
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(40470700004)(46966006)(36840700001)(2906002)(4744005)(336012)(426003)(5660300002)(41300700001)(40480700001)(8676002)(36756003)(8936002)(6666004)(70586007)(70206006)(316002)(478600001)(40460700003)(54906003)(4326008)(7696005)(2616005)(82740400003)(1076003)(107886003)(356005)(26005)(7636003)(47076005)(86362001)(82310400005)(110136005)(36860700001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 10:58:01.5998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f68078a-a15a-4627-a053-08db38201f41
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B078.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8789
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

