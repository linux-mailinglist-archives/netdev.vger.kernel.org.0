Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDF31E88BE
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgE2UQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgE2UQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:16:34 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B109207D4;
        Fri, 29 May 2020 20:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590783393;
        bh=h/SPP3tlq7Ykd/eiqiZIsmADe3PICAVWjTmiC+bN6Yo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IlhRHWFJpJlt7nfv9X0OvVNB2aYo+JpTSawsD/df6ogoGfcM+AFyLpqy+c6Kin8je
         Ilm/ie83CyJiNdiZVOlKq3Q81JYu/iP31ryELkgdp7jvdQ3DL1KO88PBwkXJA5DTXD
         hKx6tWtJjVUR6IYAVuoUOl0CaKvOOzCS2QVWzkOI=
Date:   Fri, 29 May 2020 13:16:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Message-ID: <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529194641.243989-11-saeedm@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
        <20200529194641.243989-11-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 12:46:40 -0700 Saeed Mahameed wrote:
>  /* Re-sync */
> +static struct mlx5_wqe_ctrl_seg *
> +resync_post_get_progress_params(struct mlx5e_icosq *sq,
> +				struct mlx5e_ktls_offload_context_rx *priv_rx)
> +{
> +	struct mlx5e_ktls_rx_resync_ctx *resync = &priv_rx->resync;
> +	struct mlx5e_get_tls_progress_params_wqe *wqe;
> +	struct mlx5_wqe_ctrl_seg *cseg;
> +	struct mlx5_seg_get_psv *psv;
> +	u16 pi;
> +
> +	dma_sync_single_for_device(resync->priv->mdev->device,
> +				   resync->dma_addr,
> +				   PROGRESS_PARAMS_PADDED_SIZE,
> +				   DMA_FROM_DEVICE);
> +	BUILD_BUG_ON(MLX5E_KTLS_GET_PROGRESS_WQEBBS != 1);
> +	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1)))
> +		return ERR_PTR(-ENOSPC);

I thought you said that resync requests are guaranteed to never fail?

> +	pi = mlx5e_icosq_get_next_pi(sq, 1);
> +	wqe = MLX5E_TLS_FETCH_GET_PROGRESS_PARAMS_WQE(sq, pi);
> +
> +#define GET_PSV_DS_CNT (DIV_ROUND_UP(sizeof(*wqe), MLX5_SEND_WQE_DS))
> +
> +	cseg = &wqe->ctrl;
> +	cseg->opmod_idx_opcode =
> +		cpu_to_be32((sq->pc << 8) | MLX5_OPCODE_GET_PSV |
> +			    (MLX5_OPC_MOD_TLS_TIR_PROGRESS_PARAMS << 24));
> +	cseg->qpn_ds =
> +		cpu_to_be32((sq->sqn << MLX5_WQE_CTRL_QPN_SHIFT) | GET_PSV_DS_CNT);
> +
> +	psv = &wqe->psv;
> +	psv->num_psv      = 1 << 4;
> +	psv->l_key        = sq->channel->mkey_be;
> +	psv->psv_index[0] = cpu_to_be32(priv_rx->tirn);
> +	psv->va           = cpu_to_be64(priv_rx->resync.dma_addr);
> +
> +	icosq_fill_wi(sq, pi, MLX5E_ICOSQ_WQE_GET_PSV_TLS, 1, priv_rx);
> +	sq->pc++;
> +
> +	return cseg;
> +}
