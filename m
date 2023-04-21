Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2548C6EA11F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbjDUBkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbjDUBjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2C23C38
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0600164482
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA1CC433EF;
        Fri, 21 Apr 2023 01:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041181;
        bh=56e+6TLTHBkRsq8SiA37ILIEo4EU024Y/8wX2UTdW8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgMYg19z786ywiy5k6cOgK3YkVoX1wHRDAzAKkkdx2Lx87Aj7ABkqAV0ut8E3sSWv
         2qc6EGhPMgf9nqkhpibMmx+k4nhgmfPlY0MqI8sxEHklOj15GzCE5OFesLOcT49afT
         bmsNLGz2DU6+lztc56oR4zNBuntULvo6TI12fKkGzlkDtXXVZ7m6I0AV/9WPSIhp70
         uOoeQ0lMDDDST1IwS1NyaEp+5R6H4ELY3bCGi3M7W8ChA/jsGszlkzam6mmdkFMnp5
         qmz+2YNn5A+KehvFhoVdS0XoikRCl9XO+ki7MbRTHBJDpTY5u/Qhm+0U0Q4y327buI
         3soLNu0G/VzcA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: RX, Fix XDP_TX page release for legacy rq nonlinear case
Date:   Thu, 20 Apr 2023 18:38:45 -0700
Message-Id: <20230421013850.349646-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

When the XDP handler marks the data for transmission (XDP_TX),
it is incorrect to release the page fragment. Instead, the
fragments should be marked as MLX5E_WQE_FRAG_SKIP_RELEASE
because XDP will release the page directly to the page_pool
(page_pool_put_defragged_page) after TX completion.

The linear case already does this. This patch fixes the
nonlinear part as well.

Also, the looping over the fragments was incorrect: When handling
pages after XDP_TX in the legacy rq nonlinear case, the loop was
skipping the first wqe fragment.

Fixes: 3f93f82988bc ("net/mlx5e: RX, Defer page release in legacy rq for better recycling")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 5dc907541094..69634829558e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1746,10 +1746,10 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	prog = rcu_dereference(rq->xdp_prog);
 	if (prog && mlx5e_xdp_handle(rq, prog, &mxbuf)) {
 		if (test_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
-			int i;
+			struct mlx5e_wqe_frag_info *pwi;
 
-			for (i = wi - head_wi; i < rq->wqe.info.num_frags; i++)
-				mlx5e_put_rx_frag(rq, &head_wi[i]);
+			for (pwi = head_wi; pwi < wi; pwi++)
+				pwi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
 		}
 		return NULL; /* page/packet was consumed by XDP */
 	}
-- 
2.39.2

