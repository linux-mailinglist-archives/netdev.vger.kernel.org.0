Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05280663916
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjAJGMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjAJGLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:11:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9A3395F1
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 682876147B
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1961C433F0;
        Tue, 10 Jan 2023 06:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331104;
        bh=n0lI48RJP+QlXVZOxoL3hG0goydGUVT3JQw8dFIjCFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nfe3OdfPFK1p0e/P7D3ZRHm+yx4EEri2jA8uCAIEDIuPq6Oj73fETu5YiSWZ+nohV
         Hd7sLakN9uRqXdoPFKfY6pNDLRROlZ8GwNbaMGl8vB00WT/cTxKSLg61W4oLN50BIw
         MK81jutwvLi3/4lDl6n2jICqcdx8APPZDehud6H4YIxaTwh5JEgiYrlkhjxD38W4EJ
         YzXCZKC/1Jbgsj9NsOy+mD2SkrAtv6NxcKKwpXcIjIQrUrMfzamd9cyXd2MiJ7J1I/
         +WaWRUPbm4/LOdBF7LdmA3kz0IgPgRi3xSk86orEv+Yf9J8yno7hvTtBV04ioFBA2X
         SWoArmwjL0Ffg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net 08/16] net/mlx5e: IPoIB, Fix child PKEY interface stats on rx path
Date:   Mon,  9 Jan 2023 22:11:15 -0800
Message-Id: <20230110061123.338427-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

From: Dragos Tatulea <dtatulea@nvidia.com>

The current code always does the accounting using the
stats from the parent interface (linked in the rq). This
doesn't work when there are child interfaces configured.

Fix this behavior by always using the stats from the child
interface priv. This will also work for parent only
interfaces: the child (netdev) and parent netdev (rq->netdev)
will point to the same thing.

Fixes: be98737a4faa ("net/mlx5e: Use dynamic per-channel allocations in stats")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index c8820ab22169..3df455f6b168 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2419,7 +2419,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 
 	priv = mlx5i_epriv(netdev);
 	tstamp = &priv->tstamp;
-	stats = rq->stats;
+	stats = &priv->channel_stats[rq->ix]->rq;
 
 	flags_rqpn = be32_to_cpu(cqe->flags_rqpn);
 	g = (flags_rqpn >> 28) & 3;
-- 
2.39.0

