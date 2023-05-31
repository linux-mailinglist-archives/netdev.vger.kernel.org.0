Return-Path: <netdev+bounces-6668-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDB271760B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 874A71C20C7B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB53A1C3D;
	Wed, 31 May 2023 05:19:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE271C3A
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78ADC433EF;
	Wed, 31 May 2023 05:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685510384;
	bh=Vho4AHjkGMHtyKP3A6DtDaYSFZmhJLJAgW7KWe7HgpQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TR9TQT66LtB8O1/b0N0Crk85WtmXQ/F6vMFSSKxGVxNb++wszHAWuveVdofGpKA4/
	 9uNcJwqIQhoOIr20EOAm45gYfGZGF0vxoFcwTYI0fJcZZatxUfGbCdw21OtcVQDyOt
	 J4OeODErS7KCOHTytQtNSdwN8AMOiFjQ4SjOjmWi6gGxcrH/H8DA1irzYpUVaTh5Xa
	 WeDi2lJtxFkn3JG6lUFUs2TyOsAnGgM1b6DUlnLyDmekQPxYssXPROceoFfiLO+f21
	 6vLNe/5bSuNo44yWvU/wqwHOZbEQ8TbTEE4YTlZ9uJpN2J0JoVWu2qRjdJDqsRc2U+
	 PZAVnU4LqCmEA==
Date: Tue, 30 May 2023 22:19:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: saeedm@nvidia.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: simplify condition after napi
 budget handling change
Message-ID: <20230530221943.63300b4c@kernel.org>
In-Reply-To: <87sfbd9p4z.fsf@nvidia.com>
References: <20230531020051.52655-1-kuba@kernel.org>
	<87sfbd9p4z.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

reminder: please avoid top posting on the list

On Tue, 30 May 2023 20:05:32 -0700 Rahul Rameshbabu wrote:
> You might want to clean up
> drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c as well in the
> mlx5e_ptp_napi_poll function as well.
> 
>   static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)

This is a separate NAPI instance, I don't think I should be touching
this. I can remove a check from TLS, tho, it seems:

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index 2dd78dd4ad65..5eadd47cee40 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -44,9 +44,9 @@ mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 bool mlx5e_ktls_rx_handle_resync_list(struct mlx5e_channel *c, int budget);
 
 static inline bool
-mlx5e_ktls_rx_pending_resync_list(struct mlx5e_channel *c, int budget)
+mlx5e_ktls_rx_pending_resync_list(struct mlx5e_channel *c)
 {
-	return budget && test_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &c->async_icosq.state);
+	return test_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &c->async_icosq.state);
 }
 
 static inline bool mlx5e_ktls_skb_offloaded(struct sk_buff *skb)
@@ -76,7 +76,7 @@ mlx5e_ktls_rx_handle_resync_list(struct mlx5e_channel *c, int budget)
 }
 
 static inline bool
-mlx5e_ktls_rx_pending_resync_list(struct mlx5e_channel *c, int budget)
+mlx5e_ktls_rx_pending_resync_list(struct mlx5e_channel *c)
 {
 	return false;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index a7d9b7cb4297..5012a5610353 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -186,7 +186,7 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		clear_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->async_icosq.state);
 
 	/* Keep after async ICOSQ CQ poll */
-	if (unlikely(mlx5e_ktls_rx_pending_resync_list(c, budget)))
+	if (unlikely(mlx5e_ktls_rx_pending_resync_list(c)))
 		busy |= mlx5e_ktls_rx_handle_resync_list(c, budget);
 
 	busy |= INDIRECT_CALL_2(rq->post_wqes,

