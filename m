Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB716B8AC3
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCNFnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjCNFnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE327F02A
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 247ECB8189B
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31F4C4339B;
        Tue, 14 Mar 2023 05:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772572;
        bh=myNRoGHC8WZUyLAvy93X+MyVujPOWu4KgY5jZyKgui8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixEomLkpniut27vddOMD3JCaxUQf5nftGspNY4jqq2KBcCJrKjSstsX/VYbvRa99X
         OZrkNH3bdQQ+/mXeJNkpfBneoHviT0vNt+cSnEqP2QT/Ed4KZVahODsnXMrAUAFhzf
         w/t0bKK9shTtJAYpBAmrNQujU1E6/l7FkEArsXdO6zmEOWKQHi8pqiHaKLn4s+QL4w
         S5fetV7BrZ2MP4FACpoJeF2D1OsOPa1aGGNu4FhA5SU6ezeMalyxIqs+VkUSo+FtSd
         v6q4zZ2i2viwHWr7aYowlOWe8BbOEsYjJqFVR8aazI7C/lPwY2qpjJw7YX6326Rdt3
         8gHb8zkjjk/6Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Add XSK RQ state flag for RQ devlink health diagnostics
Date:   Mon, 13 Mar 2023 22:42:28 -0700
Message-Id: <20230314054234.267365-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
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

From: Adham Faris <afaris@nvidia.com>

Currently RQ health diagnostics doesn't inform the user whether an RQ
is an XSK RQ or not.

Address this, by adding XSK state flag to RQ SW state enum in core/en.h.
XSK will be '1' if current RQ is an XSK RQ, and it will be '0' if it's
not.

In this example below, it can be seen that XSK field value is '1' since
xdpsock program have been attached to channel 0 before issuing the
devlink query command:

$ devlink health diagnose auxiliary/mlx5_core.eth.0/65535 reporter rx

Output:
=======================================================================
 Common config:
    RQ:
      type: 2 stride size: 4096 size: 16 ts_format: FRC
      CQ:
        stride size: 64 size: 1024
  RQs:
      channel ix: 0 rqn: 4236 HW state: 1 WQE counter: 15 posted WQEs: 15 cc: 15
        SW State:
          enabled: 1 recovering: 0 am: 1 no_csum_complete: 1 csum_full: 0 mini_cqe_hw_stridx: 1 shampo: 0 mini_cqe_enhanced: 0 xsk: 1
      CQ:
        cqn: 1085 HW status: 0 ci: 0 size: 1024
      EQ:
        eqn: 7 irqn: 32 vecidx: 0 ci: 5 size: 2048
      ICOSQ:
        sqn: 4229 HW state: 1 cc: 158 pc: 158 WQE size: 2048
        CQ:
          cqn: 1080 cc: 1 size: 2048

Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h           |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 10 ++++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 67f7e24d1f36..e4db252d406c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -348,6 +348,7 @@ enum {
 	MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX, /* set when mini_cqe_resp_stride_index cap is used */
 	MLX5E_RQ_STATE_SHAMPO, /* set when SHAMPO cap is used */
 	MLX5E_RQ_STATE_MINI_CQE_ENHANCED,  /* set when enhanced mini_cqe_cap is used */
+	MLX5E_RQ_STATE_XSK, /* set to indicate an xsk rq */
 	MLX5E_NUM_RQ_STATES, /* Must be kept last */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 98c87b3df806..b621f735cdc3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -18,6 +18,7 @@ static const char * const rq_sw_state_type_name[] = {
 	[MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX] = "mini_cqe_hw_stridx",
 	[MLX5E_RQ_STATE_SHAMPO] = "shampo",
 	[MLX5E_RQ_STATE_MINI_CQE_ENHANCED] = "mini_cqe_enhanced",
+	[MLX5E_RQ_STATE_XSK] = "xsk",
 };
 
 static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 81a567e17264..ed279f450976 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -93,13 +93,19 @@ static int mlx5e_open_xsk_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 			     struct mlx5e_rq_param *rq_params, struct xsk_buff_pool *pool,
 			     struct mlx5e_xsk_param *xsk)
 {
+	struct mlx5e_rq *xskrq = &c->xskrq;
 	int err;
 
-	err = mlx5e_init_xsk_rq(c, params, pool, xsk, &c->xskrq);
+	err = mlx5e_init_xsk_rq(c, params, pool, xsk, xskrq);
 	if (err)
 		return err;
 
-	return mlx5e_open_rq(params, rq_params, xsk, cpu_to_node(c->cpu), &c->xskrq);
+	err = mlx5e_open_rq(params, rq_params, xsk, cpu_to_node(c->cpu), xskrq);
+	if (err)
+		return err;
+
+	__set_bit(MLX5E_RQ_STATE_XSK, &xskrq->state);
+	return 0;
 }
 
 int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
-- 
2.39.2

