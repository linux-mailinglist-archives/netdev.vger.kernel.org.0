Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4706C3C77
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCUVLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjCUVLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:11:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC13580CA
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 14:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B75A261E67
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 21:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5CCC433A8;
        Tue, 21 Mar 2023 21:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679433101;
        bh=rXzO4vylVY3czvHRnLMeGVFWLV0kNkXJphhLQF9bjDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PV0o2H0SA7Qrye8P3RJSZhmnnMExcWh9Xr/FBu+znnPkAXO4v4apv4FyVCfdTt0eS
         LvIWDj5MJBFCFWZIzHg8UytP8AatYEaln038sqk9lLytGnqHlOmVeG7Fbo+JF8XKs0
         1N/1zjUOqLolKYQ+/o+HpgX2ZPp/9Tct4Io2AzVD1NSd3GcZ0rWkL63n7df3mm0AyJ
         exWSCekYjo/buoziyYlhegDwUHhXdT/IIfa+phO3mrddJYRTyF86ff11OfPEhsjYyQ
         lU0UiijQtZ4KWwqTe1zPBk9YJ35FGMS/LDtkprGf3Ln0qXLIRzgh4A8ieEn5K3wKfs
         VH+xjnHpZSAJw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net 6/7] net/mlx5: Read the TC mapping of all priorities on ETS query
Date:   Tue, 21 Mar 2023 14:11:34 -0700
Message-Id: <20230321211135.47711-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321211135.47711-1-saeed@kernel.org>
References: <20230321211135.47711-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

When ETS configurations are queried by the user to get the mapping
assignment between packet priority and traffic class, only priorities up
to maximum TCs are queried from QTCT register in FW to retrieve their
assigned TC, leaving the rest of the priorities mapped to the default
TC #0 which might be misleading.

Fix by querying the TC mapping of all priorities on each ETS query,
regardless of the maximum number of TCs configured in FW.

Fixes: 820c2c5e773d ("net/mlx5e: Read ETS settings directly from firmware")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 2449731b7d79..89de92d06483 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -117,12 +117,14 @@ static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
 	if (!MLX5_CAP_GEN(priv->mdev, ets))
 		return -EOPNOTSUPP;
 
-	ets->ets_cap = mlx5_max_tc(priv->mdev) + 1;
-	for (i = 0; i < ets->ets_cap; i++) {
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err = mlx5_query_port_prio_tc(mdev, i, &ets->prio_tc[i]);
 		if (err)
 			return err;
+	}
 
+	ets->ets_cap = mlx5_max_tc(priv->mdev) + 1;
+	for (i = 0; i < ets->ets_cap; i++) {
 		err = mlx5_query_port_tc_group(mdev, i, &tc_group[i]);
 		if (err)
 			return err;
-- 
2.39.2

