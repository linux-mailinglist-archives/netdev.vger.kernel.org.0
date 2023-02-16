Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C9D69891D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBPAJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBPAJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:09:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6C938E85
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 16:09:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BE43B824B0
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53A6C433A8;
        Thu, 16 Feb 2023 00:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676506162;
        bh=ZewykhkMwBvcXxZofqPSDWAPzWM5RfFGrbAC6es90nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUfP7mvb1QYZ4WIgD6Y8HgYDsAlroTZlXJnLfKYY/ZArb+inIOPEC9acy2Nr5q8U8
         ErgtmtnP510vEjMTpbres71J+dp33bsoFpVF4wZapUOUyQ2EpiIUqRcY4h3GO6N4IA
         QpPgZKVTxpgorl2V1f9KmTNedUx1uSEW8Fec69GYCYz4HtUeUOMwpSPo/0lnO/Bnzk
         C8W/55VzRw5bLI+w0QOF4HzAahZcpWcXsXn9CceSn/EHFH6kRk4mNpI7w5XKSA70Mz
         JBD+nuCA+Zcj1FGTw0+o4vN7WKzhDSPBSM7J3sioMUkETx/QEbTY73hynBItXQcOe6
         Sn2FR3ze5g+kA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 2/9] net/mlx5e: Remove redundant page argument in mlx5e_xmit_xdp_buff()
Date:   Wed, 15 Feb 2023 16:09:11 -0800
Message-Id: <20230216000918.235103-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216000918.235103-1-saeed@kernel.org>
References: <20230216000918.235103-1-saeed@kernel.org>
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

