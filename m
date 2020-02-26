Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D93616F4E1
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbgBZBNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:41 -0500
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:6029
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729982AbgBZBNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apYugnlVCh1Ggnpa/taYYL1Ekpf/FQi/a42XklmYkCu+qQO2SokhH2/t3vDi5itdzmUcNeZE2cz1IYdBvXGdQlAinmTVE6sa4hsJNc2MGxUfR2bh9+Ob/kvgSG/ilpytvKhdRMvmen6aU08woJYz3ZEeCLHVWa79ji6iSPtKnkoRTsxfUXomwsFVu9vmrPw+3fRVu3LTDLizQc2lNCXpOS6izprbU10qlGs7O7DWC0KR8sp242yipHY2LfDgHxJ/rH5RbUGLium9aHk7revt1INhzb2KeNGIcy66Abbh5FPWbOUECU1l3IVqvmocSrfNB+P2w3LathdxM3s2Z6DONA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPBMwvMnNZT7SCvWIV/0bWIIAZCz7OFw2dK+O4ydVJo=;
 b=GV0HoJXolZHd2XNfYHh9Dw28M3j5wm8eTLA4eGFN+SdtQOCfDTu1PeHwZWalli7P1Tre/x95mxCaklIF5/6gkRo4gqlWBi43FOdFJ29l7s+AucAn1eOJOkuUE4wOOQ4P/qVzn2/50k5Tvb2GJ1MKEk/IWJnL5Ez7h6XpcRD4m21jPiqlV7bB39V4IVkxGXAeUZ1Jt776LKhagwRsoC/OKuGfYIUQz5e+pOxBuJ/NVaC5Lo+5DGjE5Eb8U+ZZVuR7IJFI1MR+G/DhuACvjE532WvjrkcOZ3jU+qOt8o8Xeq04F7tOfURlH5jfT7LyfRIPzAZ04JgZdO28U2NNkGcGwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPBMwvMnNZT7SCvWIV/0bWIIAZCz7OFw2dK+O4ydVJo=;
 b=mqgCLCIoE1lMTDTdpGdbl8Lblpqq7gQQNA0+Jg0sKtHPuL/12SNBi/TFJfnXrzIiZV6EpfDuRInQpbNALZAAULY69fN5Qp3jigHugL1tscw8tN5aEzdUHJ4c0+0M8zUg/KVPXblPtnQ4EyQBucqjz5lrnpbZQe9KIUswHupMdi4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB7038.eurprd05.prod.outlook.com (10.141.234.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 01:13:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/16] net/mlx5e: Change inline mode correctly when changing trust state
Date:   Tue, 25 Feb 2020 17:12:40 -0800
Message-Id: <20200226011246.70129-11-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:31 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1012315c-8b60-4f0d-9609-08d7ba59193e
X-MS-TrafficTypeDiagnostic: VI1PR05MB7038:|VI1PR05MB7038:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7038C30CE9C9F24D906A4B64BEEA0@VI1PR05MB7038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(81156014)(66556008)(6666004)(4326008)(36756003)(66946007)(1076003)(5660300002)(66476007)(16526019)(6486002)(186003)(8676002)(81166006)(8936002)(54906003)(6512007)(2906002)(2616005)(86362001)(956004)(26005)(52116002)(498600001)(107886003)(6506007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB7038;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZQZzg4T6MS9TCxB1Xfy9yXP+axY0vFNrhyQaPtySYJ2Mn+Wr+7pHnfSnDNBGFHPY4ElfEJ60c/EqVBBCkw2p9jzvYqRdQiYdrRZ1UFCXq1b6ytXtm0FRHh2pvuGObT0TaEM6VtHeme+KOV5Segiobldxwyn0dOT+6r0MTte8+zfNtVx3mBbNC9vFzC1kGxAgTv63gEvqfONwTBBTBVZp34GzJQbAb/36roVjJRueedOs4EQwtltTVsonVVCgM2TMZ9f9MCyPBmgeAcZEpkZ8oYt5FH6K/8XRqF5+Bpg54lxlWJId2eXFoZsJhXmikPuxIbAvEUGvafGz0XOAmmJf5ZAUxb7GZPe9E3R7zK/DSViWLshmLzj0cAaWUkwB+VMAj+KKecLE9z5sm90RFSzlHXVKMUSBzRAOPSiVBvBq/fN0gI8vRY9s3D8Pass5h+tXGjPPuYmQaSitYlOFq0709pHLXexzEbsFmFKPfKoiuyA0nrv06ITogVCuYcr76cbc14AryDDQzQcfZH3iiTu7sl3zLKkmGXJMJgC2uJq3NR8=
X-MS-Exchange-AntiSpam-MessageData: JTxrIZP3I7FaQ4lkq3D91jAqo4Yb+BYmmQPAUKp6v3vYBqTWiqPNlwOl/3pfJziZysudUl2gzHUoyx+1Zr77F3qB/xQ7JWzpSfUfuuAQ19IQ4CgX/s6Jh3UvGdruCpEN3Av60KT0xAKTtPv3tay5wQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1012315c-8b60-4f0d-9609-08d7ba59193e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:33.6840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E9HPHFlqqFN6pqCyksL86INwuaEbAVpiTauO1HhhaJaKOIw867p4mBSzdaeY1ocL0Fq4QHZgPnX2GvvCMCgOEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

The current steps that are performed when the trust state changes, if
the channels are active:

1. The trust state is changed in hardware.

2. The new inline mode is calculated.

3. If the new inline mode is different, the channels are recreated using
the new inline mode.

This approach has some issues:

1. There is a time gap between changing trust state in hardware and
starting sending enough inline headers (the latter happens after
recreation of channels). It leads to failed transmissions and error
CQEs.

2. If the new channels fail to open, we'll be left with the old ones,
but the hardware will be configured for the new trust state, so the
interval when we can see TX errors never ends.

This patch fixes the issues above by moving the trust state change into
the preactivate hook that runs during the recreation of the channels
when no channels are active, so it eliminates the gap of partially
applied configuration. If the inline mode doesn't change with the change
of the trust state, the channels won't be recreated, just like before
this patch.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    | 55 +++++++++++--------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 1375f6483a13..47874d34156b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1098,49 +1098,59 @@ void mlx5e_dcbnl_delete_app(struct mlx5e_priv *priv)
 	mlx5e_dcbnl_dscp_app(priv, DELETE);
 }
 
-static void mlx5e_trust_update_tx_min_inline_mode(struct mlx5e_priv *priv,
-						  struct mlx5e_params *params)
+static void mlx5e_params_calc_trust_tx_min_inline_mode(struct mlx5_core_dev *mdev,
+						       struct mlx5e_params *params,
+						       u8 trust_state)
 {
-	mlx5_query_min_inline(priv->mdev, &params->tx_min_inline_mode);
-	if (priv->dcbx_dp.trust_state == MLX5_QPTS_TRUST_DSCP &&
+	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
+	if (trust_state == MLX5_QPTS_TRUST_DSCP &&
 	    params->tx_min_inline_mode == MLX5_INLINE_MODE_L2)
 		params->tx_min_inline_mode = MLX5_INLINE_MODE_IP;
 }
 
-static void mlx5e_trust_update_sq_inline_mode(struct mlx5e_priv *priv)
+static int mlx5e_update_trust_state_hw(struct mlx5e_priv *priv, void *context)
+{
+	u8 *trust_state = context;
+	int err;
+
+	err = mlx5_set_trust_state(priv->mdev, *trust_state);
+	if (err)
+		return err;
+	priv->dcbx_dp.trust_state = *trust_state;
+
+	return 0;
+}
+
+static int mlx5e_set_trust_state(struct mlx5e_priv *priv, u8 trust_state)
 {
 	struct mlx5e_channels new_channels = {};
+	bool reset_channels = true;
+	int err = 0;
 
 	mutex_lock(&priv->state_lock);
 
 	new_channels.params = priv->channels.params;
-	mlx5e_trust_update_tx_min_inline_mode(priv, &new_channels.params);
+	mlx5e_params_calc_trust_tx_min_inline_mode(priv->mdev, &new_channels.params,
+						   trust_state);
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		priv->channels.params = new_channels.params;
-		goto out;
+		reset_channels = false;
 	}
 
 	/* Skip if tx_min_inline is the same */
 	if (new_channels.params.tx_min_inline_mode ==
 	    priv->channels.params.tx_min_inline_mode)
-		goto out;
+		reset_channels = false;
 
-	mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+	if (reset_channels)
+		err = mlx5e_safe_switch_channels(priv, &new_channels,
+						 mlx5e_update_trust_state_hw,
+						 &trust_state);
+	else
+		err = mlx5e_update_trust_state_hw(priv, &trust_state);
 
-out:
 	mutex_unlock(&priv->state_lock);
-}
-
-static int mlx5e_set_trust_state(struct mlx5e_priv *priv, u8 trust_state)
-{
-	int err;
-
-	err = mlx5_set_trust_state(priv->mdev, trust_state);
-	if (err)
-		return err;
-	priv->dcbx_dp.trust_state = trust_state;
-	mlx5e_trust_update_sq_inline_mode(priv);
 
 	return err;
 }
@@ -1171,7 +1181,8 @@ static int mlx5e_trust_initialize(struct mlx5e_priv *priv)
 	if (err)
 		return err;
 
-	mlx5e_trust_update_tx_min_inline_mode(priv, &priv->channels.params);
+	mlx5e_params_calc_trust_tx_min_inline_mode(priv->mdev, &priv->channels.params,
+						   priv->dcbx_dp.trust_state);
 
 	err = mlx5_query_dscp2prio(priv->mdev, priv->dcbx_dp.dscp2prio);
 	if (err)
-- 
2.24.1

