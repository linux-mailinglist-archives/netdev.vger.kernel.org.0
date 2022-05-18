Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B7A52B2A6
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiERGuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiERGuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:50:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D362228A
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2423460C05
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755BAC385A9;
        Wed, 18 May 2022 06:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856590;
        bh=VNeCr/iW1Df1lbqY+8rWThHS7aUtsmFthOKjdsGhL1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXEKKVT/MVVPkXCTP7Xi78u5pUMUTfnDwUnIOBkp/pMKDThgtUyUvnuMazIBAE/ia
         KyFEvKyxGYkdKAsHy8MjdNr5AxGlH79EcvUjtrRqPq32Yoi3bpDbu6eZ+ykv2QggBJ
         51EUYBotCGtFVx/lHFujDagKFR00yXyG2kduB8HwZ+IZ+cG5A8+21AeaFiXKtRCCnp
         Kb/DMaB5XGjSU8ZCiSN4nAqHL282NAqLDwJyqDWE/qAjCMsH39HdodE++c5TMRZRsP
         CBLl5t01E/hck3Z/69HoSQdyAuSo7XDyZOnnNptN/MgOK5xujlyninfO+e2NIRGxwv
         jyxVTaWF4nOUg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/16] net/mlx5e: IPoIB, Improve ethtool rxnfc callback structure in IPoIB
Date:   Tue, 17 May 2022 23:49:30 -0700
Message-Id: <20220518064938.128220-9-saeed@kernel.org>
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

Followup commit
79ce39be1d63 ("net/mlx5e: Improve ethtool rxnfc callback structure")
and handle CONFIG_MLX5_EN_RXNFC enabled/disabled inside the fs layer so
the ethtool callbacks are always available. The fs layer will provide
stubs when CONFIG_MLX5_EN_RXNFC is compiled out.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index f4f7eaf16446..8da73ef5680f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -221,7 +221,6 @@ static int mlx5i_get_link_ksettings(struct net_device *netdev,
 	return 0;
 }
 
-#ifdef CONFIG_MLX5_EN_RXNFC
 static u32 mlx5i_flow_type_mask(u32 flow_type)
 {
 	return flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS);
@@ -243,9 +242,18 @@ static int mlx5i_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 
+	/* ETHTOOL_GRXRINGS is needed by ethtool -x which is not part
+	 * of rxnfc. We keep this logic out of mlx5e_ethtool_get_rxnfc,
+	 * to avoid breaking "ethtool -x" when mlx5e_ethtool_get_rxnfc
+	 * is compiled out via CONFIG_MLX5_EN_RXNFC=n.
+	 */
+	if (info->cmd == ETHTOOL_GRXRINGS) {
+		info->data = priv->channels.params.num_channels;
+		return 0;
+	}
+
 	return mlx5e_ethtool_get_rxnfc(priv, info, rule_locs);
 }
-#endif
 
 const struct ethtool_ops mlx5i_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
@@ -263,10 +271,8 @@ const struct ethtool_ops mlx5i_ethtool_ops = {
 	.get_coalesce       = mlx5i_get_coalesce,
 	.set_coalesce       = mlx5i_set_coalesce,
 	.get_ts_info        = mlx5i_get_ts_info,
-#ifdef CONFIG_MLX5_EN_RXNFC
 	.get_rxnfc          = mlx5i_get_rxnfc,
 	.set_rxnfc          = mlx5i_set_rxnfc,
-#endif
 	.get_link_ksettings = mlx5i_get_link_ksettings,
 	.get_link           = ethtool_op_get_link,
 };
-- 
2.36.1

