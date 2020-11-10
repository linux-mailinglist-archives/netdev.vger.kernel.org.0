Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144DD2AD414
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgKJKtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:49:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbgKJKtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:49:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605005355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ObzhOKfK0HOFT4M7B+sdcYjh5TF1bLPfbDEERltCleQ=;
        b=ZKTncBwa5shqOYKo7tnwcQD/8k8PY0ez3AsxUKTbSZ5LzPW/wHRUJlS12doe3L/hIrs1jU
        zi8KWHEVQUI68Gnv4V9lCJwhmiA4npEOPWw9BN4kXHgXeYDkDkBd8x/kAvPfRQVqzlqTIm
        UJ8Ew0YZ7L6IuxJDs8TD8I/G2bY9SKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-Up7Ft78vM_2XhRQZgDB18g-1; Tue, 10 Nov 2020 05:49:11 -0500
X-MC-Unique: Up7Ft78vM_2XhRQZgDB18g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C717D1074658;
        Tue, 10 Nov 2020 10:49:09 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D1775D98C;
        Tue, 10 Nov 2020 10:49:00 +0000 (UTC)
Date:   Tue, 10 Nov 2020 11:48:58 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH v4 net-next 5/5] net: mlx5: add xdp tx return bulking
 support
Message-ID: <20201110114858.400101e8@carbon>
In-Reply-To: <652d803bf1ffab08ff947da5e915add9fb737846.1604686496.git.lorenzo@kernel.org>
References: <cover.1604686496.git.lorenzo@kernel.org>
        <652d803bf1ffab08ff947da5e915add9fb737846.1604686496.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 19:19:11 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Convert mlx5 driver to xdp_return_frame_bulk APIs.
> 
> XDP_REDIRECT (upstream codepath): 8.5Mpps
> XDP_REDIRECT (upstream codepath + bulking APIs): 10.1Mpps
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

This patch is not 100% correct.  The bulking need to happen at another
level.  I have already fixed this up in the patches I'm currently
benchmarking with.  (Lorenzo is informed and aware)

Too many details, but all avail in[1].
 [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/xdp_bulk_return01.org


> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index ae90d533a350..5fdfbf390d5c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -369,8 +369,10 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
>  				  bool recycle)
>  {
>  	struct mlx5e_xdp_info_fifo *xdpi_fifo = &sq->db.xdpi_fifo;
> +	struct xdp_frame_bulk bq;
>  	u16 i;
>  
> +	bq.xa = NULL;
>  	for (i = 0; i < wi->num_pkts; i++) {
>  		struct mlx5e_xdp_info xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
>  
> @@ -379,7 +381,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
>  			/* XDP_TX from the XSK RQ and XDP_REDIRECT */
>  			dma_unmap_single(sq->pdev, xdpi.frame.dma_addr,
>  					 xdpi.frame.xdpf->len, DMA_TO_DEVICE);
> -			xdp_return_frame(xdpi.frame.xdpf);
> +			xdp_return_frame_bulk(xdpi.frame.xdpf, &bq);
>  			break;
>  		case MLX5E_XDP_XMIT_MODE_PAGE:
>  			/* XDP_TX from the regular RQ */
> @@ -393,6 +395,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
>  			WARN_ON_ONCE(true);
>  		}
>  	}
> +	xdp_flush_frame_bulk(&bq);
>  }
>  
>  bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

