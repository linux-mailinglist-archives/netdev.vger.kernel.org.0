Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C015F222E07
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGPVdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:33:49 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:23206
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbgGPVds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:33:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oORm2nFfy7CJ5kX9DTvonGKlXn9evZwEU6bOWJYUgb6tww4PttSfCe5xfrPHAcbfnGbExR25qK+KxMK7dIAy9xPRcQq8w49Ctb+ln0vWEySKAx8oXKCtM3EYdwZCACwYUwfbP1Li1r/QLdiX5aGysH/LbKNleA3h5OGYUsqCPZdZlO6Hg9OqwPQOPZUqXQj5B5rWjNWfMLfLFxuy7ZDS/Ep3dvYete511RBFpcc3AsKgLN8lP7taJmQDL0hND3rAZx6ekOaiVTHb2XYagiJAywFYBHeGdsVe6OEuI/hynDmftCJ0bVhMvSCM+BguThImlHHykvzquk8vaCU2SLXviQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nmn2hXMzJajtfEpVY5QDDQBT4BUAfZUgDrIIKKjiP8s=;
 b=i9+xYK2WOb3MO/CStZjLoviLcHHW3b6KB68QIdWM2c93MxkiuacUnBg7L0mA/XfSehUJUrvqVR0r3is8kr5FHDAIHlGBWkoYT0p3aRp+eVDGZEAaZIveK7wsxcCzC3GLstJ+u2DZ9agd5xBJS4oEk6SpYW5uRuqDV0hHE4/FSPN3DpueEbILnecaMUXerZdDu7iXqHQ9wK/kVIw+RfipKrOlMaY7a4DmnB1CPkNicmYBVdzv8aB+BN+x3HfwrNd2JgW4OAn878pvCsdXmHcx7s2GuJmDNsfujj+dKSGatdWvZCf0oezNhLIt5y7FYoUPKHzu3PIGFlel3X/Uk7bHGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nmn2hXMzJajtfEpVY5QDDQBT4BUAfZUgDrIIKKjiP8s=;
 b=S+uknxY9fx2nrBClHIHJe+wYuGvMzSap0pDfFg/fnsr2bEJQ017gZtmQuts4ixWRpE3p9R+eME0sU2PIQb1XMAJ7F10E4LPyYqDz85OxBSaNprg03B9ydGhGXprRFb7zXP5wWRrbqn2YnRSqEwAOe/EbaipQkPBFqUMLz19UGws=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:33:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:33:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/15] net/mlx5e: Fix missing switch_id for representors
Date:   Thu, 16 Jul 2020 14:33:07 -0700
Message-Id: <20200716213321.29468-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716213321.29468-1-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:33:42 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 23455e12-c097-4438-a2d5-08d829cfea1f
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB29927F8B258F6F27747FBFD7BE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1ytQTfvXmUtoFZpTG1PuCQ3CdfA2gmJdGzcbv/cDHp36GF5lj/hXWChwOzoy+sTssygUiqdBEdgpyeetWCJS8SiOUPySL5DHE/dftwQaXEg1DFSYpRsXCgtUcqbFOqq7eWUekX+bMKh/ZeE+wzjdGBuZz6Qmg7Yl+5follh/b9XPeQ0OTxZ+dSBtWVYy5zMb/2KmuN5x46G8GixToMcpn4gnFPr2A/RLPJWs2XBnmj20R8VGqMgOVc4rpiKcYMB41e5zfCd6tyW6SEmIJXBm9KwwNPgSMYCERfSQSLVL4GrcmdOx3SAUh1jyYae7MxPVPqH3gofL8Yqgoau/9A2/qyzuPHlo7QEVCjhfqfYjX4JHA4iUbufWy4Et0zW7WCu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rsLwrcW5UAOtZme2T35eO68yUyggZsnYYTCcZjtADIFqq22F33ZFdNM/a4m2Xg840EnZNjuTzHFEXnNWbOTWaIJ5tMCmddyhEFPOqfufsBTJYHTfcqL/D/Hq9d42tRLD80rLYhOctYEoCgoBtlqx4AtTjOTgUOTQ5LGEfl4UmDRfetpShKxw32EJvzfxzKBHSnQ7Tkj31JUGzdkCeOqgnJ8gHYYNitoxkmH3SDPFLbLs9fl+STNGDQ0ct3L/Fbs7tfDesWUhHms+cuHtnTLwAG5AK/Lz90zBxOaKp4vh3yXY/JWOzKCREfX5l01+DRGWnQtWW6F6Xb49GSCVmDgM+YSj7MIwL2UlK0/gbL/kLjsRZX6BYd2qxBwvHgeGMks0XI/EwXlMgumJAbEAMrX/k7oCa9JKsnOdRXunpJZ/ORMniVd0o0x+SkpI7N276QI5b0wgCT7XUiTmr+PQBli20mDU41xbPeTc1be/5tSXdoM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23455e12-c097-4438-a2d5-08d829cfea1f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:33:43.7844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LMjZ3KOOvl56UxtGwJtwts155QcITewbDIPehILwtX/iM8y8crI6piuSOE6sEZubNiJaBPOOErpJ0oEqW3qT6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Cited commit in fixes tag missed to set the switch id of the PF and VF
ports. Due to this flow cannot be offloaded, a simple command like below
fails to offload with below error.

tc filter add dev ens2f0np0 parent ffff: prio 1 flower \
 dst_mac 00:00:00:00:00:00/00:00:00:00:00:00 skip_sw \
 action mirred egress redirect dev ens2f0np0pf0vf0

Error: mlx5_core: devices are not on same switch HW, can't offload forwarding.

Hence, fix it by setting switch id for each PF and VF representors port
as before the cited commit.

Fixes: 71ad8d55f8e5 ("devlink: Replace devlink_port_attrs_set parameters with a struct")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 0a69f10ac30c9..c300729fb498e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1196,18 +1196,22 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, rep->vport);
 	pfnum = PCI_FUNC(dev->pdev->devfn);
-	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-	attrs.phys.port_number = pfnum;
-	memcpy(attrs.switch_id.id, &ppid.id[0], ppid.id_len);
-	attrs.switch_id.id_len = ppid.id_len;
-	if (rep->vport == MLX5_VPORT_UPLINK)
+	if (rep->vport == MLX5_VPORT_UPLINK) {
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		attrs.phys.port_number = pfnum;
+		memcpy(attrs.switch_id.id, &ppid.id[0], ppid.id_len);
+		attrs.switch_id.id_len = ppid.id_len;
 		devlink_port_attrs_set(&rpriv->dl_port, &attrs);
-	else if (rep->vport == MLX5_VPORT_PF)
+	} else if (rep->vport == MLX5_VPORT_PF) {
+		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
+		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
 		devlink_port_attrs_pci_pf_set(&rpriv->dl_port, pfnum);
-	else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport))
+	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport)) {
+		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
+		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
 					      pfnum, rep->vport - 1);
-
+	}
 	return devlink_port_register(devlink, &rpriv->dl_port, dl_port_index);
 }
 
-- 
2.26.2

