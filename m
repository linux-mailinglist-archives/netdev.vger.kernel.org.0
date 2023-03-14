Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA3A6B9D77
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjCNRuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCNRuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:50:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D568AB0B9C
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DBAA61882
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 17:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339EBC4339B;
        Tue, 14 Mar 2023 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678816198;
        bh=Bd8Q5pVMvPKmAKc3xq4HHKfaGanAptQxR/jkHp5knMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsteRG7Zlhbw5m2RL1AFOvYETo/6O3+3NfmAPk0ncV7ChKy4r7xTvY7YJQY0GvIZn
         qfPGB72RSX2mjVq33G7YTvoNdHFMc95CyP7j/bZ2KPDKtf6byC0xrNdlJT78WSZAge
         vA7K4fcBADZZuV0TXMlukIrXkGl2UGoXTyNArQ2f6L4equWdwJAxclF8AuFava98vE
         vxTrchNmBobnSMBnjzSOuDBRP7Ugv+KA28r3ERUpXapcAvNoV70M+46DZLkC46gYMQ
         YOCReAyVq7NyXb17rtYnv4GZS/BlKbDcTnl3sXt9wihps4zwGk7zZw3EozrI+URequ
         5vDnIuLErEulA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [net 14/14] net/mlx5e: TC, Remove error message log print
Date:   Tue, 14 Mar 2023 10:49:40 -0700
Message-Id: <20230314174940.62221-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314174940.62221-1-saeed@kernel.org>
References: <20230314174940.62221-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@nvidia.com>

The cited commit attempts to update the hw stats when dumping tc actions.
However, the driver may be called to update the stats of a police action
that may not be in hardware. In such cases the driver will fail to lookup
the police action object and will output an error message both to extack
and dmesg. The dmesg error is confusing as it may not indicate an actual
error.

Remove the dmesg error.

Fixes: 2b68d659a704 ("net/mlx5e: TC, support per action stats")
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
index c4378afdec09..1bd1c94fb977 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
@@ -178,7 +178,6 @@ tc_act_police_stats(struct mlx5e_priv *priv,
 	meter = mlx5e_tc_meter_get(priv->mdev, &params);
 	if (IS_ERR(meter)) {
 		NL_SET_ERR_MSG_MOD(fl_act->extack, "Failed to get flow meter");
-		mlx5_core_err(priv->mdev, "Failed to get flow meter %d\n", params.index);
 		return PTR_ERR(meter);
 	}
 
-- 
2.39.2

