Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08BA69B8DF
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 10:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBRJF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 04:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBRJF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 04:05:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E953D45F69
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 01:05:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54DE1603F7
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878E2C433D2;
        Sat, 18 Feb 2023 09:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676711124;
        bh=ZewykhkMwBvcXxZofqPSDWAPzWM5RfFGrbAC6es90nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=moTJaq6uyFf4twELtygB1+6ogx2jD+qyKwgpzt0kshgAXVKa8COvZ/oUTv5DToMwR
         th16t3cxKeb/bPH8t6ZlkX35yIQyJw0sla3gBipB5szZpgDIqz9sWyCV0K0ggF0ZAZ
         TQ3pF/3yodXZMQCyyOp2T4dkha+oOG/3jueOIucgDM3OZIUu33J4XslqKH81VsUKyS
         ldHhzB03TgHlP61WewUkjyxfcd/xF7ma38A15/jjcyAcgGYU2ctsggeWs7DCusHd5M
         O42Mv7KcXG3bjXIJrGDxxUYsqXHwPCa6eNwLnaxNVvhmLIUHYZmoK/lh44iu6NEshP
         eutKIRvCkhqPA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next V2 2/9] net/mlx5e: Remove redundant page argument in mlx5e_xmit_xdp_buff()
Date:   Sat, 18 Feb 2023 01:05:06 -0800
Message-Id: <20230218090513.284718-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230218090513.284718-1-saeed@kernel.org>
References: <20230218090513.284718-1-saeed@kernel.org>
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

Remove the page parameter, it can be derived from the xdp_buff.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f7d52b1d293b..4b9cd8ef8d28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -57,8 +57,9 @@ int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
 
 static inline bool
 mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
-		    struct page *page, struct xdp_buff *xdp)
+		    struct xdp_buff *xdp)
 {
+	struct page *page = virt_to_page(xdp->data);
 	struct skb_shared_info *sinfo = NULL;
 	struct mlx5e_xmit_data xdptxd;
 	struct mlx5e_xdp_info xdpi;
@@ -197,7 +198,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
 	case XDP_PASS:
 		return false;
 	case XDP_TX:
-		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, page, xdp)))
+		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, xdp)))
 			goto xdp_abort;
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags); /* non-atomic */
 		return true;
-- 
2.39.1

