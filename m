Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9733552B2B9
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbiERGu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiERGuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4319F22B2B
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84C6460C00
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D569DC385AA;
        Wed, 18 May 2022 06:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856595;
        bh=W7XAO3Yb6b9FC6/UkPb76flGkXlHK3m9RSDe5G7BoiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UiKXpBwsj7CmQW6999SA+PybJSQmvOMnaJwfjb27de1BSTDO1eZZqLZVpqJ3OrJhC
         ZiyDaoEPgWoEg9EfJPQwnsHMmsWDW2qR8CTuwTdLh5u2RH+9r8u9Tsfx/TVAWeDYn3
         O3KoNErt2RX15MgdxBjP3YT52WjhhRjnUuze5Y+k4r722V4/VRs7a3CVWhMwDDLK1l
         fNUmQsPDM4SF+ZLexyoH62xgLHeeRt1k3myFTZ0L/leSSMIn40S29TkknST5Krzanl
         /LcFTFoghhk8MZ6ZQIPP6gtc/F6WMm2wwtAnVogS21E+UGeyNBhcQyn5k0lbdZqIxu
         R0T+G+6uddUGQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/16] net/mlx5e: Add XDP SQs to uplink representors steering tables
Date:   Tue, 17 May 2022 23:49:35 -0700
Message-Id: <20220518064938.128220-14-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
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

From: Gal Pressman <gal@nvidia.com>

This patch adds the XDP SQs to the uplink representors steering tables
in swichdev mode and enables XDP usage on them.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c    | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index aa32b1062f7a..eb90e79388f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -399,7 +399,9 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 
 int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 {
+	int sqs_per_channel = mlx5e_get_dcb_num_tc(&priv->channels.params);
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	bool is_uplink_rep = mlx5e_is_uplink_rep(priv);
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	int n, tc, nch, num_sqs = 0;
@@ -411,9 +413,13 @@ int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 	ptp_sq = !!(priv->channels.ptp &&
 		    MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_TX_PORT_TS));
 	nch = priv->channels.num + ptp_sq;
+	/* +2 for xdpsqs, they don't exist on the ptp channel but will not be
+	 * counted for by num_sqs.
+	 */
+	if (is_uplink_rep)
+		sqs_per_channel += 2;
 
-	sqs = kvcalloc(nch * mlx5e_get_dcb_num_tc(&priv->channels.params), sizeof(*sqs),
-		       GFP_KERNEL);
+	sqs = kvcalloc(nch * sqs_per_channel, sizeof(*sqs), GFP_KERNEL);
 	if (!sqs)
 		goto out;
 
@@ -421,6 +427,13 @@ int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 		c = priv->channels.c[n];
 		for (tc = 0; tc < c->num_tc; tc++)
 			sqs[num_sqs++] = c->sq[tc].sqn;
+
+		if (is_uplink_rep) {
+			if (c->xdp)
+				sqs[num_sqs++] = c->rq_xdpsq.sqn;
+
+			sqs[num_sqs++] = c->xdpsq.sqn;
+		}
 	}
 	if (ptp_sq) {
 		struct mlx5e_ptp *ptp_ch = priv->channels.ptp;
-- 
2.36.1

