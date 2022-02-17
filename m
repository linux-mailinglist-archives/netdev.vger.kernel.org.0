Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F044B9A45
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbiBQH52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:57:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236785AbiBQH47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDD4766F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74E03B82153
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2923C340EB;
        Thu, 17 Feb 2022 07:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084598;
        bh=uQuUetPhAL37QPzXETct2wOZWfV0DKix7oyM7ZEa6+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jahRyZq6RDS6T86Jf5OdgMy6iL5sV04WsRA6ksaRR8GktvISqcXluzD78YhfDlyB3
         K9UEadnN70FeQpWKBLHevDeIWMnj4a2uLtVmGxRTLI44rf5fBv5tiNJV9DbFIatRk6
         XVFay1q4OsX5AkfAjOBErXyv6r03kOuY5Dz/x+ZnG9LPq2CTlkjV3F/rzN29U5PvyX
         bZIn8ephfHGgzI3xipV23gK4/hQvxq/hSNPm7BURYgvEC6x6kf4iqjfUQX4TUqs5nn
         5wctIfrd5Xb1Uj2OG7Ii1QCe6pMQJpjV/80Mfvrw4njNBtPBitqEuj6//y+GswCwZq
         BOLMU4frNBmAw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: E-Switch, Add support for tx_port_ts in switchdev mode
Date:   Wed, 16 Feb 2022 23:56:24 -0800
Message-Id: <20220217075632.831542-8-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217075632.831542-1-saeed@kernel.org>
References: <20220217075632.831542-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When turning on tx_port_ts (private flag) a PTP-SQ is created. Consider
this queue when adding rules matching SQs to VPORTs. Otherwise the
traffic on this queue won't reach the wire.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c   | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 4459e5585075..6070b8a13818 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -55,6 +55,7 @@
 #include "diag/en_rep_tracepoint.h"
 #include "en_accel/ipsec.h"
 #include "en/tc/int_port.h"
+#include "en/ptp.h"
 
 #define MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE \
 	max(0x7, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE)
@@ -401,13 +402,18 @@ int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	int n, tc, nch, num_sqs = 0;
 	struct mlx5e_channel *c;
-	int n, tc, num_sqs = 0;
 	int err = -ENOMEM;
+	bool ptp_sq;
 	u32 *sqs;
 
-	sqs = kcalloc(priv->channels.num * mlx5e_get_dcb_num_tc(&priv->channels.params),
-		      sizeof(*sqs), GFP_KERNEL);
+	ptp_sq = !!(priv->channels.ptp &&
+		    MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_TX_PORT_TS));
+	nch = priv->channels.num + ptp_sq;
+
+	sqs = kcalloc(nch * mlx5e_get_dcb_num_tc(&priv->channels.params), sizeof(*sqs),
+		      GFP_KERNEL);
 	if (!sqs)
 		goto out;
 
@@ -416,6 +422,12 @@ int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 		for (tc = 0; tc < c->num_tc; tc++)
 			sqs[num_sqs++] = c->sq[tc].sqn;
 	}
+	if (ptp_sq) {
+		struct mlx5e_ptp *ptp_ch = priv->channels.ptp;
+
+		for (tc = 0; tc < ptp_ch->num_tc; tc++)
+			sqs[num_sqs++] = ptp_ch->ptpsq[tc].txqsq.sqn;
+	}
 
 	err = mlx5e_sqs2vport_start(esw, rep, sqs, num_sqs);
 	kfree(sqs);
-- 
2.34.1

