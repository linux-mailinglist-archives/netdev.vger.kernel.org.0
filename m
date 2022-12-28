Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2F1658678
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiL1Tnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiL1Tnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:43:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC12411160
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6734D615FB
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA2FC433D2;
        Wed, 28 Dec 2022 19:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256625;
        bh=qk5zGr4XHZHsiZI599EWtSVl8WPGGQ/C8r2fpaCJrxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMJZjJLvfZwKQ5AsaIm1cmITiN2+dnXnjO7iXK75LrXInMErbaftsh0ziLvoveWhA
         lE36MDdSanw2z4iJk/EvqbhKbFwb3vMXaSGJyEF0XePxEszFkak+ZGxtYt3hPj+2Q/
         F+3PBFWhB15OFToR2XY6otTBBtkJ5dqeFL+XQLp/moIQ+XuZo36TQIrkkG4176G5/7
         MfRq14QXaTgcmHCXi6gqo4M3yb57h3NyVi/sP+/T6SRLrlJg1xNRiBjM7jP+L6syiy
         n+eJfBeOEKF7z7HONgF2LztoLK1l1lcUH6VvQdZaiVLfK9VE07kQhu2IDnAMNv3wtT
         Dx66+LE/KfdCQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net 07/12] net/mlx5e: Fix RX reporter for XSK RQs
Date:   Wed, 28 Dec 2022 11:43:26 -0800
Message-Id: <20221228194331.70419-8-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221228194331.70419-1-saeed@kernel.org>
References: <20221228194331.70419-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

RX reporter mistakenly reads from the regular (inactive) RQ
when XSK RQ is active. Fix it here.

Fixes: 3db4c85cde7a ("net/mlx5e: xsk: Use queue indices starting from 0 for XSK queues")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 5f6f95ad6888..1ae15b8536a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -459,7 +459,11 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
 		goto unlock;
 
 	for (i = 0; i < priv->channels.num; i++) {
-		struct mlx5e_rq *rq = &priv->channels.c[i]->rq;
+		struct mlx5e_channel *c = priv->channels.c[i];
+		struct mlx5e_rq *rq;
+
+		rq = test_bit(MLX5E_CHANNEL_STATE_XSK, c->state) ?
+			&c->xskrq : &c->rq;
 
 		err = mlx5e_rx_reporter_build_diagnose_output(rq, fmsg);
 		if (err)
-- 
2.38.1

