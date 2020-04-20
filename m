Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C4D1B185B
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgDTVX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:23:56 -0400
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:52910
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726021AbgDTVXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:23:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njIFMNFGTwzX4Mt7izfZljGj0wV4v4lgQgh2C0UQYiMf1V01xY3J2K1bVJfAl6vRmeMqZuQUFEjCbMcfDT9B+6lTC2Vrct1T0LH3t7goCu9ZUeu5WWxUvKv2P8LMhJCQEHjIBNvedklyBAwZynmRga1YjF2dSI8xNWnU4M9i9n5udrWmQvSd4oVnDPqJzxfJ8UtmiT4J1YD31vlIuTzKaAC2x1tCyjRECySF0cz/DY3k2z0+xfSPuCGsNBMopT/lY2H3nuZpSu16x9zeevXASoTY+BTYILS2NKTextqgxizTtyZYaKRV7HKALMXWe9caUG4IN1tlgZljDdW8yvDNLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vo1aei8CXCpNs5RU3c91s/uSTKcfFAEQH5YX2mtNMM=;
 b=cjL0voVjpCPeScn7eCgKHNG5LoKppwmUw/y4Ls+xjazAHM0KFhN7bajscwzt8O0nw5yAQTA2UZxZS+ml5Zw73QYosG0t5tCukUvflPZp+p79Bek9jsPOAf0xNW+YLYMwIr7lBwDC5xWdgjs2tsyLshKoNWrHtcc4/g90qQZARyrSjgnRwSkFN/rtVeH+zImI+RVUV4j6/fr8KjRRyxeZgRd6fmFOcRS652C7vOdIenipIZr6zr6hX6nuEJTt4Q7armKtXzNpGiJKQUex0FV8udaKQFa7r4BWqnxCwgGJmSFhSfGd5/K4yHg/usxGH6KVMtYn6/mmSAxrin58EjOR6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vo1aei8CXCpNs5RU3c91s/uSTKcfFAEQH5YX2mtNMM=;
 b=tAH+s2biO32HFDgPVim/5mPWyss6/o3H6kLR5180vl5scGnyVeWAnAh8kI4z3qCW89BOVsvETPlQ81SmWItGnpdh+1Gae85y4C3b8yBmcB2u8d7Bwa9xGj8zJ1dpfy0yJznIZMVU9gGy66frIMtiD6bTL+83htbhd/rgO0hMcY8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6478.eurprd05.prod.outlook.com (2603:10a6:803:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:23:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:23:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/10] net/mlx5e: Handle errors from netif_set_real_num_{tx,rx}_queues
Date:   Mon, 20 Apr 2020 14:22:21 -0700
Message-Id: <20200420212223.41574-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420212223.41574-1-saeedm@mellanox.com>
References: <20200420212223.41574-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 21:23:13 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 19ee718c-6ce3-49fd-ec48-08d7e5710983
X-MS-TrafficTypeDiagnostic: VI1PR05MB6478:|VI1PR05MB6478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB647881220E458F288E83CC7EBED40@VI1PR05MB6478.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(107886003)(6506007)(86362001)(2906002)(186003)(16526019)(26005)(4326008)(5660300002)(36756003)(316002)(1076003)(66556008)(478600001)(956004)(6666004)(66946007)(52116002)(66476007)(6512007)(6486002)(2616005)(54906003)(8676002)(8936002)(81156014)(54420400002)(142933001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wJU0efUEXyTnRaQBtVS4hjH0nwyv4kMDwFL2sDVR28MTbtpfOqdl1fxDBdcl5K47qt+aE7BbSrU+h7qNW3Jbymke5WFyG3sJl1OJTUcRB8EkmmswXLcwwqVXmu0n1Nc+ljwwUU/bLXBj8sJXs4rwlDeXCCdCJlxDH4ETGGI8zRjtHX58yccUhNYMJyqW0Oe3VR7zujrM1NB+ygRjq1wf0XrvzBk7HD6THe6arJ5RmOuna1tauLiofR+74oqlp+2gNkgrpGa1ktvIQ2yPiTOt8Nn/YeYZUuNrbCXxz/NDX0sAlqNoMkAc9OKC7JC/towRX0/UMyITgc0hJQuRx11dn9unEQw8qI4TvPqwiW65MndXddH1l5Q1WYYrTePze0LqxHMkPrVXzAdek8Xkpz4TjAeWv9OoGQqtLoVuSX6ecytqd6jYR5/yQOv8sriyKp/+oDTC025x9ojcSPdcgvj52KlasZNTHIUAbrvyyIoXJ3QL0CS1BQmE0m9w0AVyD0M1jzAMV6zOqbdY3GvDBlKdnw==
X-MS-Exchange-AntiSpam-MessageData: g4B2NuG/Sx8MOQXMzLIBsENPXsmLpSZ5VNDPIoErt9YFX/xUvmk4nlKyGsjrvhdsRkp61q5vfLuUVedUx086yUaQXnyA95XicZkmX4//bs48ZFQK6lOBu7GHDq9hPyp64WUEDJnE8OCp8dan5NXQdA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19ee718c-6ce3-49fd-ec48-08d7e5710983
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:23:15.2488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wnrpHNouDdx/StNCbqyHOQLvFpucQk21C88E1afZUdnfr3jblgRb9e3grec4Zhoyfv2zP3yr0VKX3ptvIr31Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6478
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

netif_set_real_num_tx_queues and netif_set_real_num_rx_queues may fail.
Now that mlx5e supports handling errors in the preactivate hook, this
commit leverages that functionality to handle errors from those
functions and roll back all changes on failure.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 59 +++++++++++++++----
 2 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 6d703ddee4e2..4ab78b5c2393 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -432,7 +432,7 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		*cur_params = new_channels.params;
-		mlx5e_num_channels_changed(priv);
+		err = mlx5e_num_channels_changed(priv);
 		goto out;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f02150a97ac8..e057822898f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2839,11 +2839,8 @@ void mlx5e_set_netdev_mtu_boundaries(struct mlx5e_priv *priv)
 				ETH_MAX_MTU);
 }
 
-static void mlx5e_netdev_set_tcs(struct net_device *netdev)
+static void mlx5e_netdev_set_tcs(struct net_device *netdev, u16 nch, u8 ntc)
 {
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-	int nch = priv->channels.params.num_channels;
-	int ntc = priv->channels.params.num_tc;
 	int tc;
 
 	netdev_reset_tc(netdev);
@@ -2860,15 +2857,47 @@ static void mlx5e_netdev_set_tcs(struct net_device *netdev)
 		netdev_set_tc_queue(netdev, tc, nch, 0);
 }
 
-static void mlx5e_update_netdev_queues(struct mlx5e_priv *priv, u16 count)
+static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 {
-	int num_txqs = count * priv->channels.params.num_tc;
-	int num_rxqs = count * priv->profile->rq_groups;
 	struct net_device *netdev = priv->netdev;
+	int num_txqs, num_rxqs, nch, ntc;
+	int old_num_txqs, old_ntc;
+	int err;
+
+	old_num_txqs = netdev->real_num_tx_queues;
+	old_ntc = netdev->num_tc;
 
-	mlx5e_netdev_set_tcs(netdev);
-	netif_set_real_num_tx_queues(netdev, num_txqs);
-	netif_set_real_num_rx_queues(netdev, num_rxqs);
+	nch = priv->channels.params.num_channels;
+	ntc = priv->channels.params.num_tc;
+	num_txqs = nch * ntc;
+	num_rxqs = nch * priv->profile->rq_groups;
+
+	mlx5e_netdev_set_tcs(netdev, nch, ntc);
+
+	err = netif_set_real_num_tx_queues(netdev, num_txqs);
+	if (err) {
+		netdev_warn(netdev, "netif_set_real_num_tx_queues failed, %d\n", err);
+		goto err_tcs;
+	}
+	err = netif_set_real_num_rx_queues(netdev, num_rxqs);
+	if (err) {
+		netdev_warn(netdev, "netif_set_real_num_rx_queues failed, %d\n", err);
+		goto err_txqs;
+	}
+
+	return 0;
+
+err_txqs:
+	/* netif_set_real_num_rx_queues could fail only when nch increased. Only
+	 * one of nch and ntc is changed in this function. That means, the call
+	 * to netif_set_real_num_tx_queues below should not fail, because it
+	 * decreases the number of TX queues.
+	 */
+	WARN_ON_ONCE(netif_set_real_num_tx_queues(netdev, old_num_txqs));
+
+err_tcs:
+	mlx5e_netdev_set_tcs(netdev, old_num_txqs / old_ntc, old_ntc);
+	return err;
 }
 
 static void mlx5e_set_default_xps_cpumasks(struct mlx5e_priv *priv,
@@ -2895,8 +2924,12 @@ static void mlx5e_set_default_xps_cpumasks(struct mlx5e_priv *priv,
 int mlx5e_num_channels_changed(struct mlx5e_priv *priv)
 {
 	u16 count = priv->channels.params.num_channels;
+	int err;
+
+	err = mlx5e_update_netdev_queues(priv);
+	if (err)
+		return err;
 
-	mlx5e_update_netdev_queues(priv, count);
 	mlx5e_set_default_xps_cpumasks(priv, &priv->channels.params);
 
 	if (!netif_is_rxfh_configured(priv->netdev))
@@ -5358,9 +5391,11 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	 */
 	if (take_rtnl)
 		rtnl_lock();
-	mlx5e_num_channels_changed(priv);
+	err = mlx5e_num_channels_changed(priv);
 	if (take_rtnl)
 		rtnl_unlock();
+	if (err)
+		goto out;
 
 	err = profile->init_tx(priv);
 	if (err)
-- 
2.25.3

