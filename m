Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5479A16F4D4
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbgBZBNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:30 -0500
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:15414
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729346AbgBZBN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mr6lVBbmEbRak5i0Uo3v7SYZi9BO1gSKMQnD6IB6EgLmbH/aZ5+N7XCZLsRqr1BjzOwpYwA9UobBbZ1RXWPmq4OQKLXIWaxq5NAQyFYdjbj4eesz80nW3dywLS+TQ6hKlprGuxrkQGnsHg/kZxqifAJLYprpAaQzN3xMzuQbuUjtka0XsxEcKxUKoE1dXLIO7lu4sM3tM9+8M7rI4vTao+HFcWI/tNX8M9NsgTYbLZZ7/5vSSS4as/JCPi6ijEwO061QN1qdAgkl4sexAMtZi51wfJyFOmTx81dq+vzboC8dXf9cELUQpVcu12PbNZJij/x1me19Zr8k6kzu7oTdKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXchy02Bf+3mZlkjO0nl5pr3VBG3B4KxT0JsLBis2cE=;
 b=IfyQ9XTBzD9iMvezErEVX5Wmxho4XOByBL+BMjGuQZIza+CGMI2k4Mj0rw9LDS1DZQbr1UbhV4okPKJME8xRQv8mvyONWk4XiyTwi090moYAPTvXrEza47qe3LaYLePSWg8VDZgutTjTRtJgp0KtgvVRsKpgUd3jDyr2h2dJJVm38zUjPFb3G+0MVa4oqWgtaInV9m+3nqkg+CGZsuugeCpCO7WImA6Ly1LReiy2ylI0jCHvhk7bsLKVNxstGSQsfoJxLhURx3voy2U7i7XIPEftB7ym9ad9vYhSOaYhaQJ48GBKcsYhyJ4kC8QE4cW82WFpMBn3Ii5fTZkuwyTEGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXchy02Bf+3mZlkjO0nl5pr3VBG3B4KxT0JsLBis2cE=;
 b=W/33VZLAcLexCwf7uHnA1hKL3BbaOZlxZclAtbr0o9HSrE3BtySdEq4yb7zc6b5ADTYN0XBdOWnb/RFAdiivNOBFTi4UHxYz+qFhJdQiN89FuBQWRaGO00wM/GJN+f/NqkPuOZ6Fn23kJL+fxV8sm5XR18aBmlILU1bQTk6LHQU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5869.eurprd05.prod.outlook.com (20.178.205.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Wed, 26 Feb 2020 01:13:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/16] net/mlx5e: Fix configuration of XPS cpumasks and netdev queues in corner cases
Date:   Tue, 25 Feb 2020 17:12:36 -0800
Message-Id: <20200226011246.70129-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:22 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eba4c510-8b42-4787-bf11-08d7ba5913af
X-MS-TrafficTypeDiagnostic: VI1PR05MB5869:|VI1PR05MB5869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB58693782616CF0BE5EE3C4A4BEEA0@VI1PR05MB5869.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:466;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(66946007)(66556008)(2906002)(81166006)(66476007)(5660300002)(81156014)(6666004)(8936002)(86362001)(8676002)(54906003)(1076003)(4326008)(6512007)(316002)(52116002)(478600001)(2616005)(186003)(107886003)(956004)(36756003)(6506007)(26005)(6486002)(16526019)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5869;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gBCznujie73LkuEVj/ZWMH559gifzpenJSvTkNhk7B4t6thnJU4Zx9XBtgBeENf87wZFkOLtuvQKxsa3pmxyIoH1pWeallTv9NizlBNJyEwRqHVNWuJNaaWiV2dyKE2ziGka5hatqgXEIIjip30ABImjDMQslpt4WLKFiz9Y3/HdcONdBNYuq8kev+YB/OigFtovx5Jc81XS8Rsso0iKp5ePMelNYlsoIlT+mlosXUAHoH/Mj0fcqblY3o7vxb2kupG7x5xUKosTZ0Os5NmAp9EpZv+TfGxpPjYnImG1REagaIPbUMritVWtf0h4csr6e7bGN+fLHZtK5lFMAyBoFYX7wGwwz9DoNi6xlKOXiF6s2uFrWrmU8GmVFE2RGU96gA/w+LBdbzC12bWoYt+v42FbaT2LLfxue803ymdGBSz4MeKyiVB1nplOAX5wajqG+r/Z7OYx+jIRzKQKZ+rxbIfTdfamHtqL/+SIZFHXJlDxRtZiEEbYCoZRdRvfW/cf8fpo+eAdFED8Ww/GPWwCqQTc7X59e6gI0FhW37iXon8=
X-MS-Exchange-AntiSpam-MessageData: kRfb9Op5PJucI5aODhHkuS3z1e8AW+H/ljU9lQgbPVnpyVY+H0lRsTB8+qivFnVuv+8j4egXwhp2n0ddqVUVtUmpZMy0LoBP8vQWCiwCxKKuwVCNkQSOG1TnvZox+uW7bzux4sCFVwO0xnnSjx1JmQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eba4c510-8b42-4787-bf11-08d7ba5913af
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:24.3543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PorK7t/wekSi7DA8yhwoCAwqf6LYEFfmc8ISqHIozvepbDfcNeHY6q4vvFFHT/Nab/m7c3sCqBBxtBghyPbJ1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5869
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Currently, mlx5e notifies the kernel about the number of queues and sets
the default XPS cpumasks when channels are activated. This
implementation has several corner cases, in which the kernel may not be
updated on time, or XPS cpumasks may be reset when not directly touched
by the user.

This commit fixes these corner cases to match the following expected
behavior:

1. The number of queues always corresponds to the number of channels
configured.

2. XPS cpumasks are set to driver's defaults on netdev attach.

3. XPS cpumasks set by user are not reset, unless the number of channels
changes. If the number of channels changes, they are reset to driver's
defaults. (In general case, when the number of channels increases or
decreases, it's not possible to guess how to convert the current XPS
cpumasks to work with the new number of channels, so we let the user
reconfigure it if they change the number of channels.)

XPS cpumasks are no longer stored per channel. Only one temporary
cpumask is used. The old stored cpumasks didn't reflect the user's
changes and were not used after applying them.

A scratchpad area is added to struct mlx5e_priv. As cpumask_var_t
requires allocation, and the preactivate hook can't fail, we need to
preallocate the temporary cpumask in advance. It's stored in the
scratchpad.

Fixes: 149e566fef81 ("net/mlx5e: Expand XPS cpumask to cover all online cpus")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 11 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 95 +++++++++++--------
 2 files changed, 65 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4ddccab02a4b..6d725d2acd3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -737,7 +737,6 @@ struct mlx5e_channel {
 	DECLARE_BITMAP(state, MLX5E_CHANNEL_NUM_STATES);
 	int                        ix;
 	int                        cpu;
-	cpumask_var_t              xps_cpumask;
 };
 
 struct mlx5e_channels {
@@ -813,6 +812,15 @@ struct mlx5e_xsk {
 	bool ever_used;
 };
 
+/* Temporary storage for variables that are allocated when struct mlx5e_priv is
+ * initialized, and used where we can't allocate them because that functions
+ * must not fail. Use with care and make sure the same variable is not used
+ * simultaneously by multiple users.
+ */
+struct mlx5e_scratchpad {
+	cpumask_var_t cpumask;
+};
+
 struct mlx5e_priv {
 	/* priv data path fields - start */
 	struct mlx5e_txqsq *txq2sq[MLX5E_MAX_NUM_CHANNELS * MLX5E_MAX_NUM_TC];
@@ -876,6 +884,7 @@ struct mlx5e_priv {
 #if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
 	struct mlx5e_hv_vhca_stats_agent stats_agent;
 #endif
+	struct mlx5e_scratchpad    scratchpad;
 };
 
 struct mlx5e_profile {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bbe8c32fb423..4906d609aa55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1794,29 +1794,6 @@ static int mlx5e_set_tx_maxrate(struct net_device *dev, int index, u32 rate)
 	return err;
 }
 
-static int mlx5e_alloc_xps_cpumask(struct mlx5e_channel *c,
-				   struct mlx5e_params *params)
-{
-	int num_comp_vectors = mlx5_comp_vectors_count(c->mdev);
-	int irq;
-
-	if (!zalloc_cpumask_var(&c->xps_cpumask, GFP_KERNEL))
-		return -ENOMEM;
-
-	for (irq = c->ix; irq < num_comp_vectors; irq += params->num_channels) {
-		int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(c->mdev, irq));
-
-		cpumask_set_cpu(cpu, c->xps_cpumask);
-	}
-
-	return 0;
-}
-
-static void mlx5e_free_xps_cpumask(struct mlx5e_channel *c)
-{
-	free_cpumask_var(c->xps_cpumask);
-}
-
 static int mlx5e_open_queues(struct mlx5e_channel *c,
 			     struct mlx5e_params *params,
 			     struct mlx5e_channel_param *cparam)
@@ -1967,10 +1944,6 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	c->irq_desc = irq_to_desc(irq);
 	c->lag_port = mlx5e_enumerate_lag_port(priv->mdev, ix);
 
-	err = mlx5e_alloc_xps_cpumask(c, params);
-	if (err)
-		goto err_free_channel;
-
 	netif_napi_add(netdev, &c->napi, mlx5e_napi_poll, 64);
 
 	err = mlx5e_open_queues(c, params, cparam);
@@ -1993,9 +1966,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 
 err_napi_del:
 	netif_napi_del(&c->napi);
-	mlx5e_free_xps_cpumask(c);
 
-err_free_channel:
 	kvfree(c);
 
 	return err;
@@ -2009,7 +1980,6 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 		mlx5e_activate_txqsq(&c->sq[tc]);
 	mlx5e_activate_icosq(&c->icosq);
 	mlx5e_activate_rq(&c->rq);
-	netif_set_xps_queue(c->netdev, c->xps_cpumask, c->ix);
 
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_activate_xsk(c);
@@ -2034,7 +2004,6 @@ static void mlx5e_close_channel(struct mlx5e_channel *c)
 		mlx5e_close_xsk(c);
 	mlx5e_close_queues(c);
 	netif_napi_del(&c->napi);
-	mlx5e_free_xps_cpumask(c);
 
 	kvfree(c);
 }
@@ -2869,10 +2838,10 @@ static void mlx5e_netdev_set_tcs(struct net_device *netdev)
 		netdev_set_tc_queue(netdev, tc, nch, 0);
 }
 
-static void mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
+static void mlx5e_update_netdev_queues(struct mlx5e_priv *priv, u16 count)
 {
-	int num_txqs = priv->channels.num * priv->channels.params.num_tc;
-	int num_rxqs = priv->channels.num * priv->profile->rq_groups;
+	int num_txqs = count * priv->channels.params.num_tc;
+	int num_rxqs = count * priv->profile->rq_groups;
 	struct net_device *netdev = priv->netdev;
 
 	mlx5e_netdev_set_tcs(netdev);
@@ -2880,10 +2849,34 @@ static void mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	netif_set_real_num_rx_queues(netdev, num_rxqs);
 }
 
+static void mlx5e_set_default_xps_cpumasks(struct mlx5e_priv *priv,
+					   struct mlx5e_params *params)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	int num_comp_vectors, ix, irq;
+
+	num_comp_vectors = mlx5_comp_vectors_count(mdev);
+
+	for (ix = 0; ix < params->num_channels; ix++) {
+		cpumask_clear(priv->scratchpad.cpumask);
+
+		for (irq = ix; irq < num_comp_vectors; irq += params->num_channels) {
+			int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(mdev, irq));
+
+			cpumask_set_cpu(cpu, priv->scratchpad.cpumask);
+		}
+
+		netif_set_xps_queue(priv->netdev, priv->scratchpad.cpumask, ix);
+	}
+}
+
 int mlx5e_num_channels_changed(struct mlx5e_priv *priv)
 {
 	u16 count = priv->channels.params.num_channels;
 
+	mlx5e_update_netdev_queues(priv, count);
+	mlx5e_set_default_xps_cpumasks(priv, &priv->channels.params);
+
 	if (!netif_is_rxfh_configured(priv->netdev))
 		mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
 					      MLX5E_INDIR_RQT_SIZE, count);
@@ -2912,8 +2905,6 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 {
-	mlx5e_update_netdev_queues(priv);
-
 	mlx5e_build_txq_maps(priv);
 	mlx5e_activate_channels(&priv->channels);
 	mlx5e_xdp_tx_enable(priv);
@@ -3449,7 +3440,7 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 		goto out;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_num_channels_changed);
 	if (err)
 		goto out;
 
@@ -5231,6 +5222,9 @@ int mlx5e_netdev_init(struct net_device *netdev,
 	priv->max_nch     = netdev->num_rx_queues / max_t(u8, profile->rq_groups, 1);
 	priv->max_opened_tc = 1;
 
+	if (!alloc_cpumask_var(&priv->scratchpad.cpumask, GFP_KERNEL))
+		return -ENOMEM;
+
 	mutex_init(&priv->state_lock);
 	INIT_WORK(&priv->update_carrier_work, mlx5e_update_carrier_work);
 	INIT_WORK(&priv->set_rx_mode_work, mlx5e_set_rx_mode_work);
@@ -5239,7 +5233,7 @@ int mlx5e_netdev_init(struct net_device *netdev,
 
 	priv->wq = create_singlethread_workqueue("mlx5e");
 	if (!priv->wq)
-		return -ENOMEM;
+		goto err_free_cpumask;
 
 	/* netdev init */
 	netif_carrier_off(netdev);
@@ -5249,11 +5243,17 @@ int mlx5e_netdev_init(struct net_device *netdev,
 #endif
 
 	return 0;
+
+err_free_cpumask:
+	free_cpumask_var(priv->scratchpad.cpumask);
+
+	return -ENOMEM;
 }
 
 void mlx5e_netdev_cleanup(struct net_device *netdev, struct mlx5e_priv *priv)
 {
 	destroy_workqueue(priv->wq);
+	free_cpumask_var(priv->scratchpad.cpumask);
 }
 
 struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
@@ -5288,6 +5288,7 @@ struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
 
 int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 {
+	const bool take_rtnl = priv->netdev->reg_state == NETREG_REGISTERED;
 	const struct mlx5e_profile *profile;
 	int max_nch;
 	int err;
@@ -5299,11 +5300,25 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	max_nch = mlx5e_get_max_num_channels(priv->mdev);
 	if (priv->channels.params.num_channels > max_nch) {
 		mlx5_core_warn(priv->mdev, "MLX5E: Reducing number of channels to %d\n", max_nch);
-		/* Reducing the number of channels - RXFH has to be reset. */
+		/* Reducing the number of channels - RXFH has to be reset, and
+		 * mlx5e_num_channels_changed below will build the RQT.
+		 */
 		priv->netdev->priv_flags &= ~IFF_RXFH_CONFIGURED;
 		priv->channels.params.num_channels = max_nch;
-		mlx5e_num_channels_changed(priv);
 	}
+	/* 1. Set the real number of queues in the kernel the first time.
+	 * 2. Set our default XPS cpumask.
+	 * 3. Build the RQT.
+	 *
+	 * rtnl_lock is required by netif_set_real_num_*_queues in case the
+	 * netdev has been registered by this point (if this function was called
+	 * in the reload or resume flow).
+	 */
+	if (take_rtnl)
+		rtnl_lock();
+	mlx5e_num_channels_changed(priv);
+	if (take_rtnl)
+		rtnl_unlock();
 
 	err = profile->init_tx(priv);
 	if (err)
-- 
2.24.1

