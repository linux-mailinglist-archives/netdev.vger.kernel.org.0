Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC9F461F0C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731098AbfGHM4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:56:24 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:57603 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbfGHM4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:56:24 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MbBQU-1iLzrJ3Egy-00bXQy; Mon, 08 Jul 2019 14:55:57 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] [net-next] net/mlx5e: xsk: dynamically allocate mlx5e_channel_param
Date:   Mon,  8 Jul 2019 14:55:41 +0200
Message-Id: <20190708125554.3863901-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:4ftv1gHczqjAf8xH9IXsCPbra/fMKRspDTr8cIcpEuGznocAdGy
 iZhmNDyoSPnpnBZOyDHtT8Ynn4XQ9kQfpsqHva0dKZA5Ld4hMScUjAMHEbG6PrAbwLC6ASg
 g539BORMN8W974gKpYHP5K9v2Y2f956yutZO9dA6870giJkCXQ71FrqA8iO4eyLCZFzDhgI
 VQdm2P+yiXXKN+C7144Mw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:S7/kq/cX7g0=:jQ0xc1zhHRNbrh7x+xMeHd
 cA/orRXHrovfvXEwHXZJ26K0GbHxI2WZd/m4ZhxS4FbYUQCEDMUNy2qB1IFuJjaqe4Ok79Rw+
 xsVajdjRZLKA8iteii1S1tU6D3sQnjcMYzK9cBDLynaRMXbMijhwmTSSWvoElvXCgDhCTHqgW
 w0ZKb8UsaLYUJXJV+rtGWcvRINaruEIKSrH6zyPkiFs/7W8mhOpuPxnLYfSic/nmn9RqgeY16
 9PpuKCJVcOTuXrv7FXqdCpcEkbg09EeepsRjKkKsJ9YvEiTXd49QbJ9EalG6aIK2+5SXA2OCH
 FfCwVe4ZWBH2Bf3cWn+IvsRaj/wv13R9p3joz6YNOZAPX0H5LLXq2sA6ckW2FC+QvSKaef0FP
 IGttL7qBy2wgExG+3GFBaWQHx5wWeH3fnAslbBWvM6JvbHjCUMueZa6l/jnSzleM8dgP1n2dF
 3Kb7dt3tQKmc2ANAboFjOqOfOZqzpiye/4XZ1aBxc0wFo6nao0p9Xw+RjcYWxsEBKIY+2US1E
 Q7A0Ivd4/DgYN0zZDRXUko+thJnndO3/iuaeeJi9C0fcbmplbWvxWHZqPB94wdycirbrWGTbF
 4BEHT3RgOKgOABrcp2tsqgnipoNcJTPr1Bq+Up14Mf3MERyrLi7AS4bXJNtz9L2BBMWBbtb/D
 pVfYxu7EZc+0WEYxD2gQWQwH4ouF7OYRnkAuotdjafrWCeio59oFCnNdU4D/4x9PfSKA6DpwF
 7+b1dGFK0pTWht8vSCelCEwDbGj1EbJRNNE0DA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The structure is too large to put on the stack, resulting in a
warning on 32-bit ARM:

drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:59:5: error: stack frame size of 1344 bytes in function
      'mlx5e_open_xsk' [-Werror,-Wframe-larger-than=]

Use kzalloc() instead.

Fixes: a038e9794541 ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../mellanox/mlx5/core/en/xsk/setup.c         | 25 ++++++++++++-------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index aaffa6f68dc0..db9bbec68dbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -60,24 +60,28 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   struct mlx5e_xsk_param *xsk, struct xdp_umem *umem,
 		   struct mlx5e_channel *c)
 {
-	struct mlx5e_channel_param cparam = {};
+	struct mlx5e_channel_param *cparam;
 	struct dim_cq_moder icocq_moder = {};
 	int err;
 
 	if (!mlx5e_validate_xsk_param(params, xsk, priv->mdev))
 		return -EINVAL;
 
-	mlx5e_build_xsk_cparam(priv, params, xsk, &cparam);
+	cparam = kzalloc(sizeof(*cparam), GFP_KERNEL);
+	if (!cparam)
+		return -ENOMEM;
 
-	err = mlx5e_open_cq(c, params->rx_cq_moderation, &cparam.rx_cq, &c->xskrq.cq);
+	mlx5e_build_xsk_cparam(priv, params, xsk, cparam);
+
+	err = mlx5e_open_cq(c, params->rx_cq_moderation, &cparam->rx_cq, &c->xskrq.cq);
 	if (unlikely(err))
-		return err;
+		goto err_kfree_cparam;
 
-	err = mlx5e_open_rq(c, params, &cparam.rq, xsk, umem, &c->xskrq);
+	err = mlx5e_open_rq(c, params, &cparam->rq, xsk, umem, &c->xskrq);
 	if (unlikely(err))
 		goto err_close_rx_cq;
 
-	err = mlx5e_open_cq(c, params->tx_cq_moderation, &cparam.tx_cq, &c->xsksq.cq);
+	err = mlx5e_open_cq(c, params->tx_cq_moderation, &cparam->tx_cq, &c->xsksq.cq);
 	if (unlikely(err))
 		goto err_close_rq;
 
@@ -87,18 +91,18 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	 * is disabled and then reenabled, but the SQ continues receiving CQEs
 	 * from the old UMEM.
 	 */
-	err = mlx5e_open_xdpsq(c, params, &cparam.xdp_sq, umem, &c->xsksq, true);
+	err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, umem, &c->xsksq, true);
 	if (unlikely(err))
 		goto err_close_tx_cq;
 
-	err = mlx5e_open_cq(c, icocq_moder, &cparam.icosq_cq, &c->xskicosq.cq);
+	err = mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->xskicosq.cq);
 	if (unlikely(err))
 		goto err_close_sq;
 
 	/* Create a dedicated SQ for posting NOPs whenever we need an IRQ to be
 	 * triggered and NAPI to be called on the correct CPU.
 	 */
-	err = mlx5e_open_icosq(c, params, &cparam.icosq, &c->xskicosq);
+	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->xskicosq);
 	if (unlikely(err))
 		goto err_close_icocq;
 
@@ -123,6 +127,9 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 err_close_rx_cq:
 	mlx5e_close_cq(&c->xskrq.cq);
 
+err_kfree_cparam:
+	kfree(cparam);
+
 	return err;
 }
 
-- 
2.20.0

