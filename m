Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40CF1F7096
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgFKWsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:48:00 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgFKWr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:47:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9U/FRrs0FRVEUshHFzUly9VCY6o8AChHNFBvHG9gzjPNLG+qUcfCmERcVkVJ+NHS66apq7VYVLhZD2lWTZSrSmzLO7pQLcyujgrMeJUQf0ZYHdhTQTjfr4rhJipkNt5sGcip1K6RdEtpubbjZwBWeLeTC5hBMWJyPIDfWp8Lj0ALcrSJOGZfykMS1UPz0gNgWB5MFcHu9ZA2iPnNjn7uOWSK0DHS0ShHGuobyAqO5TVsB4h4jlLf/ps5HlDllX31uz8mlrcouRkSerynu1Fg3euSy5r8MjuO+1OcpoyGqiRK8QZvy5UiEzi0c90CK9DOBHrkuoZ4hAhqiWa5O0mjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZ5vUec3G6kAz9/mnRr0cxYRZhpt7ZEwbGljHQANd7c=;
 b=LhgYbGqwnTlAIH96HNpK+yQQAGjuKo2JcGb94RjhVzPQx7FR7rFitySfKjvN8J0kajVLZ1XIRCr9V0H8p9nqP88d1tT1Xlvl5UM3erhUua6YoqCA2HRnv2qccWLOQxSncJS+EGpL6UiwM7RYLtJK1bXVL4ZKrmqNqckqHX5p5EGWCEZx5KGeG/YCswsA/VJt/BWaXFX0iLx6fM41rEp43B0jdzYT3V2Rj3/s0N3k89p/94ELhBvmi247Ui5y2cQ2bM+h04ExwFYR3byTiwNvECxvbff+zeQw7Nrrs0X/eFptkQ1AN1A5JG2HBJw4oOsURvPamLuzhtH4Xcacr4Q0PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZ5vUec3G6kAz9/mnRr0cxYRZhpt7ZEwbGljHQANd7c=;
 b=QMdm0FktXFwJCUd1HR2tVzJGYxrJ6kmvCunXPJ7HJJ/nv0yWA9TnrrMSHIxEa3h+Fj5qPVOp+US340HQoznhJrodBDtGzuHxIIBrQceUEuaSaiftPBDzP+G0pZN1QQ8W4UR3lomAc7Y084u413Y6urAQGh9RCpHxL7Bm6sxIQjo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4464.eurprd05.prod.outlook.com (2603:10a6:803:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Thu, 11 Jun
 2020 22:47:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:47:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 06/10] net/mlx5: Disable reload while removing the device
Date:   Thu, 11 Jun 2020 15:47:04 -0700
Message-Id: <20200611224708.235014-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611224708.235014-1-saeedm@mellanox.com>
References: <20200611224708.235014-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0066.namprd06.prod.outlook.com (2603:10b6:a03:14b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 22:47:49 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 062614b7-7733-49ee-ace6-08d80e59784d
X-MS-TrafficTypeDiagnostic: VI1PR05MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB44642142CB3FA08319FDB3C7BE800@VI1PR05MB4464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: POJXgYYiD++VUPVYjNreidPOAT4WVwPVgLLDfybZIRyei4MohK8ZFSjSzUj6+xDDiHKYaiNI41VAQIPCht1bmcUVMrlg/NiG/3D7CWFnXaEbVGeRqDTIqrFbxcNiMIqtyupg7SGjaeVrqIB3BPkYP8YGISjHn86myk7sXjSZPDL68E75Uu/l9BKJwY+5sTW3DQ03B/G6ohidElrFmX/pthTjULV/CupOuFiDIgoAedhhE7q70ZH26Pf2s4BpnaSAnhqkp7K6L7pULCF8ERQRmwzVAy9JCwkSVR898s+gwcuri5A8Okzj2HzTTiwPeJvjSz72oLEeRuN1BTw3ILq3cB3nuqFSxGK49bbVooQkPaZOv4CX8iz9eBa2AGkJguv7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8936002)(16526019)(186003)(4326008)(316002)(8676002)(107886003)(5660300002)(478600001)(26005)(956004)(2616005)(6666004)(66556008)(86362001)(6512007)(6486002)(66946007)(54906003)(1076003)(6506007)(36756003)(66476007)(83380400001)(2906002)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AJYlrTQ3xb32OlxfJk38aK/FhwRrJd6bramQ+ZrMpLlPuW43BjNjheUlNZDlEZldXLMHkjxg6BMySWFTnsSAfhYd7otLBBvRGUTnGEG6Bl5BVn8LZu+juKAFa6X8MlKC1unb3DCXYTQoPOkFAydXiaGTC0svnW4FEDboA/uIRV+nxPxREHix8Z6Lw+IAxW5lE/188yKm4T1PkdWDXAYSbm9taB5EA/t/GJVSWEFshJl++i3yOuDPPeSoSG19x7yyVvPSwOt/5/chH/7WtkZM9HkulSJNd3ycW4rmEbVQ3+g6Xe750uGWHA76q42NR9Da/Zn7AwaQxxUgRv8lGS+/PlqDR5NvHEjWKVNPnQuRwRXEi57EOYJQ50Q/lrbnIfANLouF9ZXns80dVkVmbSw6TPafBTb3dtuqvRdIqbxNNLuvGV+uC4h9fbw0EG9RDo7zas8pLZOx4hX48kBLQo3uylVPwrZYd4F7e8vMAkubOYg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 062614b7-7733-49ee-ace6-08d80e59784d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 22:47:51.0057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zCfFAqi0HxaCtw6Cx1I/5Sr1FP4bfBIm1t80Cn6bUOf3PM8uB6C7QNmD1oHOJJHi12szyt7uUFqsl5jsQgfywQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

While unregistration is in progress, user might be reloading the
interface.
This can race with unregistration in below flow which uses the
resources which are getting disabled by reload flow.

Hence, disable the devlink reloading first when removing the device.

     CPU0                                   CPU1
     ----                                   ----
local_pci_remove()                  devlink_mutex
  remove_one()                       devlink_nl_cmd_reload()
    mlx5_unregister_device()           devlink_reload()
                                       ops->reload_down()
                                         mlx5_unload_one()

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/main.c    | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index e94f0c4d74a72..a99fe4b02b9b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -283,7 +283,6 @@ int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
 		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
 	devlink_params_publish(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 
 params_reg_err:
@@ -293,7 +292,6 @@ int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
-	devlink_reload_disable(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 18d6c3752abe8..2729afc13ab48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1367,6 +1367,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
 
 	pci_save_state(pdev);
+	devlink_reload_enable(devlink);
 	return 0;
 
 err_load_one:
@@ -1384,6 +1385,7 @@ static void remove_one(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
+	devlink_reload_disable(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_devlink_unregister(devlink);
 
-- 
2.26.2

