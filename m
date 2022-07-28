Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842535843A4
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiG1Pyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiG1Pye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:54:34 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C9D6C105
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:54:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obi4Sn7Yf3nXiDuLgd9Tu8nfePxln9t/V77Ud66ybg3Z3aracgMeu1KeZKtxwmNnTC+S1VjXSbAEjg1YfzyXZsJ8ujUMmB2W4/DMeihOyIIL64n8HQ5FKsZtCZT1fsnZJ88XpLUMYDe052zWBscDBZSQ8BEaku9id1s11uDr7cEYXATSlKiougqVKexWL634V1e8RQTIZneXxuENjMziNMWD7+bkznwzzQSqWcldLD79xn2/hQgh2gP9cuXvLuW5y3JT+eELQaxte64m/E39egcxwLWi7Z1Qf97HJhDaG+jbHUazzFvxD3wfuSpJAOHXw7eqLqbYSoQStKRDCM4mOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofFoM3AA0XT/yno49TXfQs6cY2VrsYsd0wHbsS3jR/g=;
 b=TyijQIVdgDLk3o3m5oWjFoHIQRuKIbPQlvXWO2Nrp2sKc6aiYhugf3WVP1frcQ+G1mefOmQZ24NHw+PI8hutIrnqgNhKS63lSQYSYG24befT77dY6wk1Al0unGuesnrxNb9vK66Z7TuOmllcY+PWP0UawVGKkM3HpdNER/cxZ3YxLbV0r9WJuUVPxbfytk9VGOc4Zw33V1bmhVZjl5oug7arq3xQF1BzbfnTSSZdbCQYsw33/MfygHfPdBjvpFliC0xZwYTsU61mCGaB2zQ43AzXS/qRIAseAOfV93liMyJEXuAVzJnDYAgm3LdJpFb6j581tKADcWB1GGrLdGsKxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofFoM3AA0XT/yno49TXfQs6cY2VrsYsd0wHbsS3jR/g=;
 b=sY54rTUi/J58MzdVyXbYGVPZacF3C8lhY+4gcnsbBnixMf0dvR3fzxje+XGWHAanctfzHphWU4YFTubYxKXAYtyhDjTOXFPTQos2hs/PPhGC/9Ua2pzWlcav2vNY8GLBrav/+i3+qY3crw/iFQyVOqyNvDUlBaJU6tIdVTLomimc5tqWNGDiEIE1QoDtQsVEX/Nnbu8Oq04kMMzZIoGrPoJQ+omgtIS28npLgIx56SXIEfuIAUh1tl1KEeZy1b/b1CcRJw7aHeg30q3VRjhiR4wK+uNAZgBQYrVnSY9hxMH7ZfxmPivqh/7tct3l7f2ouoErIQRsGjNeaodRRf+afg==
Received: from BN9P222CA0009.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::14)
 by DM6PR12MB3145.namprd12.prod.outlook.com (2603:10b6:5:3a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 15:54:31 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::55) by BN9P222CA0009.outlook.office365.com
 (2603:10b6:408:10c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.7 via Frontend
 Transport; Thu, 28 Jul 2022 15:54:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 15:54:30 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 15:54:29 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 08:54:29 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 08:54:26 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 3/9] net/mlx5: Move fw reset unload to mlx5_fw_reset_complete_reload
Date:   Thu, 28 Jul 2022 18:53:44 +0300
Message-ID: <1659023630-32006-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
References: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 937efff0-8401-4f61-1179-08da70b17551
X-MS-TrafficTypeDiagnostic: DM6PR12MB3145:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SeWETMV7eD9I4pr5UZevSFugiggwxm3L1VN12T4pCXWxEHs73KHLIq9SEMYjaEMpNQVBuJ1XvhvTf/ZvF2bO6i3TJ9zo6a7F5vwQyCobKpwoh+hAAbQwRtgCGYYxpSPAcobFbykceXP45p/6KpBi19788UydeQaUlZCToGkUisP8buWAWNtqHRff/vBeCW2mntgi3SxoQ6Bu6XgwXf+tB4ueiCKX9zaABO4ayWLc1skrAm7kiSTPd2o67DpRAY0d6yVZt359jvC5cNpThZM2mrEftZFneCZvBb+Bf21snK/uO6W776ZN6BjWgqvGJB1svEK7C1eb7qOWeZZ/a76H7XgZUBSmAJNyYQvYT66gK2OwNhSq6yoqsQrDpu4PBKjfBRpLciIn5PoH6FoxKHVM9wzWLloj5vSgIA5Uy1yjHM7X122IIQwgQywcsuoaQbHbUy0gi0XanSNpvlG654E6vR3L7gsOhQL/eqTdMh2WFjI9qijnFDfQZF1nK8cCnaK4UduR7ln91jzKfJcn4LwtKks+tDn0DA0W/sekpHHDO7ERFKIVYvKMlwIHRYOEgIY+h3WobN74d70jCQQ01yHBCTzUFebrkdRWm3EzMp4yC3E55kiOKmyZOkaNvSgxV1V4cX4Dmpp0GirTB3Tv5YhGBh3mCFVQOFmNKLDof69/rIAGIS07qGN7WsLevj5ZKvKSDymYWV1E0XO77su+XvwZFHyGKAOSickPdmxAlnPEIL5coJEyXKAUVAGjovrvwCW5hsPMDzXNcW5VIHoWXPnC3hghxppX1jBcUbe/90Oq362USkE37EmXw4trJjL71ZV5EnpFeyJ3z5vFj4eBJ1V40CZFobbHG5I+8XnkkcK3MLLfhof1z/gxZsMsYVtnTpoucOszetOktR1VJI6B2Dn+Cg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(36840700001)(40470700004)(46966006)(40480700001)(6666004)(54906003)(86362001)(41300700001)(2616005)(478600001)(7696005)(81166007)(26005)(36860700001)(82740400003)(83380400001)(40460700003)(316002)(110136005)(107886003)(426003)(47076005)(336012)(8936002)(82310400005)(5660300002)(36756003)(70586007)(2906002)(356005)(4326008)(70206006)(8676002)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 15:54:30.4241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 937efff0-8401-4f61-1179-08da70b17551
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3145
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor fw reset code to have the unload driver part done on
mlx5_fw_reset_complete_reload(), so if it was called by the PF which
initiated the reload fw activate flow, the unload part will be handled
by the mlx5_devlink_reload_fw_activate() callback itself and not by the
reset event work.

This will be used by the downstream patch to invoke devlink reload
callbacks with devlink lock held.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  | 11 ++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 10 +++-------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index f85166e587f2..41bb50d94caa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -104,7 +104,16 @@ static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netli
 	if (err)
 		return err;
 
-	return mlx5_fw_reset_wait_reset_done(dev);
+	err = mlx5_fw_reset_wait_reset_done(dev);
+	if (err)
+		return err;
+
+	mlx5_unload_one(dev);
+	err = mlx5_health_wait_pci_up(dev);
+	if (err)
+		NL_SET_ERR_MSG_MOD(extack, "FW activate aborted, PCI reads fail after reset");
+
+	return err;
 }
 
 static int mlx5_devlink_trigger_fw_live_patch(struct devlink *devlink,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 052af4901c0b..e8896f368362 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -149,6 +149,9 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
 		complete(&fw_reset->done);
 	} else {
+		mlx5_unload_one(dev);
+		if (mlx5_health_wait_pci_up(dev))
+			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
 		mlx5_load_one(dev, false);
 		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
 							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
@@ -183,15 +186,9 @@ static void mlx5_sync_reset_reload_work(struct work_struct *work)
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
 						      reset_reload_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
-	int err;
 
 	mlx5_sync_reset_clear_reset_requested(dev, false);
 	mlx5_enter_error_state(dev, true);
-	mlx5_unload_one(dev);
-	err = mlx5_health_wait_pci_up(dev);
-	if (err)
-		mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
-	fw_reset->ret = err;
 	mlx5_fw_reset_complete_reload(dev);
 }
 
@@ -395,7 +392,6 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 	}
 
 	mlx5_enter_error_state(dev, true);
-	mlx5_unload_one(dev);
 done:
 	fw_reset->ret = err;
 	mlx5_fw_reset_complete_reload(dev);
-- 
2.18.2

