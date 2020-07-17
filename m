Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45AA222FA8
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgGQAE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:04:57 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:58740
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbgGQAEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:04:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqjUMiJRKO1KodV/SwzWY6/QqhM0AbPXjyejE4eQAwnRBiZndf4W3NvTWGzHzYkc5h/etVPPkz/gxdfgou5qwfRwgUSWlmQEKDadG/ZeWHJobfxq+Hf0yPCiKjK9saVzc6Et1OCItaz4WRhfM5Iiiau3OcyCspjAE90slzdspPWzmL4tT1cnFL4BD7FBvAL583H/nWTN+ZxJrWdQne4vNz7k5/Vn3O/cwiBb0j+9NzCH2pW3lQ5A7GT7VfkizPOVV80jZHkczDZm0EX1+8bJcH+A+lTxitROskso1tGChYo0kCR8d1dN800QuNgM6vcA9fJ2HMKZvngzdqflyk7vIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvrW/BkNEe7NNuYBM2qoTN94dcIKb8OETkkZE9nsSJg=;
 b=jyOVcNe6kQ1MH38eslZmWoBNa0oHZqijPFz2feUnK/RbAouwLyNIPJraD9z871rjO7T8iZYlO79P/vjL3u6AYJJDTAqGmRUMh6f7RCNFdINVnGaVUDBmZaIgHDDS9LiGj52wsBDchOYKexYiK6Tk1a0zRsRZ7WyXk59bT8gl9pKwJvLxuVjeaByCypVqt8tGOBRzEFfd9HjQmC95cR46nYYMsdg1RcaYjqA5xHYoFrgQWou/scwvYg7a9A6ULG/zVYyW0/3EEMK0uU7cC765R6DUduH+vHa7Q3oFBShvkJRmrHfMXED6MHEpvN/CO0U/azonTlw3e5eUfwhq14uteA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvrW/BkNEe7NNuYBM2qoTN94dcIKb8OETkkZE9nsSJg=;
 b=nIsg7FWVQZ00/i8ayX+vUswKYvaYFBe/mY/jKUtC6yhQvp+zzFlyu0WHFSRNUPA4/gtoGwd82/Y4Mc06fBgLjlF7zPteH52HMhxg8m5xmhhlHhpK1sF0IGujXmEUVwbfXWQjixYrTSVmqwD/MtNZw3Fjj0wUVvo69IfUvx8nnvY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 00:04:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:04:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 05/15] net/mlx5: E-switch, Reduce dependency on num_vfs during mode set
Date:   Thu, 16 Jul 2020 17:04:00 -0700
Message-Id: <20200717000410.55600-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717000410.55600-1-saeedm@mellanox.com>
References: <20200717000410.55600-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:40 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5bb82eb8-cb52-401d-f1a8-08d829e50160
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB24488709315A0AD91222F330BE7C0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kx23HuGXaIHvDgivBjanMvOOnT9KAfH6I6619f0MN/MEOJQx0l0YmpqeE6N8zz29rmSx5C7uUrL0yFRJ2KeEonuGTMji9B9BQqm5sbiyZRMTJ3PIvi7tFu43FF9K0nGU4ExPSP6XujLJIyxS4LxXdh3zxjIe0Db7nAmF7NL0ea0Owe6m6d3LE3Cp9CyLVdGOgghmRwHoDdkKBub4WyIrpc5X5MBFTYNTVgLLmw/5D9WVnXzgbEQm4ZdeuGzDcJGN5bc2RGZF58JiqUHAvhy9XIqvRYoZ3Fb0dwHac+G6e0MWbckWlolDb0EJMVEPpX8Mk2XvwJSftALYJeeEs0hYf+Np3FiQ3xYlUhdqIdm1a7qhBpOWC4PrLAkAsQF+T+kQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(66476007)(316002)(66946007)(66556008)(6512007)(107886003)(4326008)(2906002)(478600001)(86362001)(956004)(83380400001)(2616005)(36756003)(6666004)(52116002)(8676002)(26005)(5660300002)(16526019)(8936002)(1076003)(110136005)(6486002)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rs2A06PL9fZbzXefFtXP8oGIrsJ9lk/qprke4jg5mq65WN9feaIwetgj/jrBvEiW2tchU63rVTFXGliuSHu6zO3JVIj8ha8NRFJmeRZSFv3Sb+UIhmy9R2sIJgOcNRYCJ4bp360YEhHIH1JKu+oiTjnn1e9+UZi5/8Lbor5xsr8G6XIimthNhFOKOr/PyujsKL8y+ZDDH7cTmrEjdAytDbS+nECDQy1ljpIADpYgwGiJDrYugRQa5gc99/fSg1pNi4vbbohbhQZDODt6xOfoBSmxu48kSlFZqirhuIrwNqFAQzb8fhrNSnXapHn4bQWXA3DMfkwZTizDCbIHpF9L3aZGjtOiCl3kipW5JaQz9ea5IwdzxBfW8wj2bZZ8VFHkCBUPXn71HYlBt/o5iOm/DSJGLzbtmEHOIcR4vZGCD8aNvo5ZhWr9H3/TBthYRvirOZN3lKeMl9xG5fkvKECm4TGPQqS52uaXjFXtf5LLn2c=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb82eb8-cb52-401d-f1a8-08d829e50160
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:04:42.2344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdnp545Vz4kp9MuBURZGODoQt2QoK0ox9iZCbG2H9uDRk0CCnBPMYddgP+gqhEc93Oigeg52vpDqsBwK1RM/Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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

