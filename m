Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20F0222E0B
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgGPVeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:34:02 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:23206
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727097AbgGPVeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A31Vr6asdh/WWSzFWs31L4dm6nsgxIfXgr/reUv00vZgNN9OBdVFUxcXGjJC7rY99TGiyrx7PKB0WknVQVpSCRl0LsOa/zJf8VsXarRVvWTD2K2XUgIqKS9Ut2jF7r8I7NAgHqhcEqjhFnp3RQBHR/qEFOPFdB+FlWe8GFrGRlcHh1MKHsv41px6ArdRzP68ZNH3fT5DsQQPy/ybXsZUChIoDgdiDkFWeW1LQdY/S+uJAMdgh7vVL4G0D6qC6w98ZDZZi8KDcx5zUCiRx8ixBTALvmOyg5Ft8RvZ1PLeCop8O6C95Uc6fkiuBxHYEVeBQy/+snEBskqkASjJl1LMTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvrW/BkNEe7NNuYBM2qoTN94dcIKb8OETkkZE9nsSJg=;
 b=bspoQ76NBTC2hnDNoREp2Pw1Fl59raZv+k0MxgJ0J0eDoIEYbiEsg4lL72V3W16IXnqe63N1rjK8twM2sx6K6/qMz5f/vANFxqfJOugW5BSpNk0vc8e/0sn+ZaxhQnVPpjR5AJ3ucg3fzF/MeTgQq2JRCiT9GVrf4yXRyQUKpA1x8/nSdhPgIy7CmYYl9YOoF0mpBfQgydlMI7Tqf5folne77DLu4ASZI+i7veorKnP2QSZIIzNMNhuWM5bqnZprZ4AQ/QhS5/gA88S35XmBNLxrnxKWefMUk55Y8QRaB1rlELkJ0m+/PYPALt2x59N1UlGL/HJ6SqNhYgp6h2n/2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvrW/BkNEe7NNuYBM2qoTN94dcIKb8OETkkZE9nsSJg=;
 b=BuntJEPeIVERbfj3+9wGS7WzVh8n5z94l16g32/7eQWpJPXNwK7llfBdfG4u8zWRpvJUvFhwoN32gB4wkyy/Mrr6N0xu95MJQjCZQUSXnrUrvGHbcpPU+yZvATG9SI5DWUBhjYnoT4Gb6Nf4JA7+MUZa6VIWSiiQ1ajSkqbDORo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:33:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:33:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/15] net/mlx5: E-switch, Reduce dependency on num_vfs during mode set
Date:   Thu, 16 Jul 2020 14:33:11 -0700
Message-Id: <20200716213321.29468-6-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:33:50 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 022fc0a3-e80e-4459-85f2-08d829cfef50
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB299213DDEE023F42F5C424C7BE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yD5YTA6u0tQSkwzWepYwH8GpggfHBdl6h3xhF3QWj5mFr0QMIh81eR7zzacEb762liqo1AXdP6n1dXJ5CNcm1r8wCvKNmbR5NTh0ciIIUKIqsZk5O+Y/oeNBCdXWGrMDLWlKqzmnz+Nc7qXGbHS/rGs7+2aiXmlLuGEaSpNgegd6XLAm1FqND/izGxgPMLnH9wV6iY0ORW4MGU6kpvThrWNpF/Wvfudt9WPclCOkG7hNZ32bbwdf7OZQ/gcJzhUfrCthqPSwprGKKDeF2Ut/6Eqrq1akqVH1+Dy6CcC6nkpQqB6w2xeguK15/PMns8zKVXLuhjnCX2cGIIeZVqeqtX4hRFNu0U4kkgpA+QDk9zMtAAf5UOsJYIVsnhH936Fb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: w9xrMqbrdf5iYo8yh96vjsjUb+RSCZT6MudGOlHfxH2NPWOMQvvlcITB1Be1xXwpGDQVFny43NTrRr2+V9MlqZ0MciVJC9wZNzdUzqFRrsFlpIcJ0g4ILKizRDxgVkZDPExwTiO+k7Nc3VlXELIWj1ymX9wRCsTJkD1MAnQkfgKeAWda0AaaJpTonD2pAB7DNhAXfn5kwupFMi4ysA7wHVAFhphHC6WRxzYB18G4A/T9HruYa0RxVnebt3xoPWJXFdqfPKUB626ci1VkzDT2Dl3R8cxlr+SHVqFgBynvEtxCk7yEe9w7iCJZPi4emJaooU/bs8jQg7RfOe6TT7afXh0tWwZa6Q21zm/l+ATb/MeEz3TIB5ALHRpbq4WcFQWOvdPwR3JhiniXnSZewfbTWiN3BuFkA/b4BKjdsn8RXLvnX8+iweF/00xCkEleCofup+VZjdJXK3EErZWhkG83qCiXzF28U2kuyBXBCs+cUEc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 022fc0a3-e80e-4459-85f2-08d829cfef50
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:33:52.4884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lPjkPX9IYyBu/+Bsq4+94aKq5HHFgOTcF9qnac4uObz/og1BZRUckdDqZxhzNPGMZeziYeUlt4kKD+H8ABWrDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Currently only ECPF allows enabling eswitch when SR-IOV is disabled.

Enable PF also to enable eswitch when SR-IOV is disabled.
Load VF vports when eswitch is already enabled.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 13 ++++++++++++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 14 +-------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index c181f6b63f597..e8f900e9577e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1652,7 +1652,17 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 		return 0;
 
 	mutex_lock(&esw->mode_lock);
-	ret = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY, num_vfs);
+	if (esw->mode == MLX5_ESWITCH_NONE) {
+		ret = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY, num_vfs);
+	} else {
+		enum mlx5_eswitch_vport_event vport_events;
+
+		vport_events = (esw->mode == MLX5_ESWITCH_LEGACY) ?
+					MLX5_LEGACY_SRIOV_VPORT_EVENTS : MLX5_VPORT_UC_ADDR_CHANGE;
+		ret = mlx5_eswitch_load_vf_vports(esw, num_vfs, vport_events);
+		if (!ret)
+			esw->esw_funcs.num_vfs = num_vfs;
+	}
 	mutex_unlock(&esw->mode_lock);
 	return ret;
 }
@@ -1699,6 +1709,7 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
 
 	mutex_lock(&esw->mode_lock);
 	mlx5_eswitch_disable_locked(esw, clear_vf);
+	esw->esw_funcs.num_vfs = 0;
 	mutex_unlock(&esw->mode_lock);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 74a2b76c7c078..db856d70c4f8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1578,13 +1578,6 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 {
 	int err, err1;
 
-	if (esw->mode != MLX5_ESWITCH_LEGACY &&
-	    !mlx5_core_is_ecpf_esw_manager(esw->dev)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Can't set offloads mode, SRIOV legacy not enabled");
-		return -EINVAL;
-	}
-
 	mlx5_eswitch_disable_locked(esw, false);
 	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_OFFLOADS,
 					 esw->dev->priv.sriov.num_vfs);
@@ -2293,7 +2286,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 {
 	u16 cur_mlx5_mode, mlx5_mode = 0;
 	struct mlx5_eswitch *esw;
-	int err;
+	int err = 0;
 
 	esw = mlx5_devlink_eswitch_get(devlink);
 	if (IS_ERR(esw))
@@ -2303,12 +2296,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		return -EINVAL;
 
 	mutex_lock(&esw->mode_lock);
-	err = eswitch_devlink_esw_mode_check(esw);
-	if (err)
-		goto unlock;
-
 	cur_mlx5_mode = esw->mode;
-
 	if (cur_mlx5_mode == mlx5_mode)
 		goto unlock;
 
-- 
2.26.2

