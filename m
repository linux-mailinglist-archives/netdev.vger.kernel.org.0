Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C2929EAE6
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 12:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgJ2LnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 07:43:22 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:53622 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgJ2LnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 07:43:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1603971801; x=1635507801;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=ZBitz/gLloGZESalGg0E+i8QCKv0J6P4kMoQsxYAmd4=;
  b=R8VI3YK5zXdcckXDU8o2dliZlxZz2CJEkTt+Nq5Dwie2iOa3kC6Zv8/c
   m/jYFX9LqmqlK4KBBuIICmJbCF7cpV9ksNZuiQYx37lPDC2nvaVwHRZdh
   eSWPjn6pxuuChTZOOzUg17kbqrgVD/9Br1frAux3wy9g/fiKOGUGNsNum
   A=;
X-IronPort-AV: E=Sophos;i="5.77,429,1596499200"; 
   d="scan'208";a="89792378"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 29 Oct 2020 11:43:15 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 05C8BA1D42;
        Thu, 29 Oct 2020 11:43:13 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.160.229) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Oct 2020 11:43:09 +0000
References: <cover.1603824486.git.lorenzo@kernel.org>
 <3fb334388ac7af755e1f03abb76a0a6335a90ff6.1603824486.git.lorenzo@kernel.org>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <lorenzo.bianconi@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <brouer@redhat.com>,
        <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net-next 4/4] net: mlx5: add xdp tx return bulking support
In-Reply-To: <3fb334388ac7af755e1f03abb76a0a6335a90ff6.1603824486.git.lorenzo@kernel.org>
Date:   Thu, 29 Oct 2020 13:42:44 +0200
Message-ID: <pj41zl5z6tl0ln.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D10UWB004.ant.amazon.com (10.43.161.121) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Convert mlx5 driver to xdp_return_frame_bulk APIs.
>
> XDP_REDIRECT (upstream codepath): 8.5Mpps
> XDP_REDIRECT (upstream codepath + bulking APIs): 10.1Mpps
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c 
> b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index ae90d533a350..5fdfbf390d5c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -369,8 +369,10 @@ static void mlx5e_free_xdpsq_desc(struct 
> mlx5e_xdpsq *sq,
>  				  bool recycle)
>  {
>  	struct mlx5e_xdp_info_fifo *xdpi_fifo = &sq->db.xdpi_fifo;
> +	struct xdp_frame_bulk bq;
>  	u16 i;
>  
> +	bq.xa = NULL;
>  	for (i = 0; i < wi->num_pkts; i++) {
>  		struct mlx5e_xdp_info xdpi = 
>  mlx5e_xdpi_fifo_pop(xdpi_fifo);
>  
> @@ -379,7 +381,7 @@ static void mlx5e_free_xdpsq_desc(struct 
> mlx5e_xdpsq *sq,
>  			/* XDP_TX from the XSK RQ and XDP_REDIRECT 
>  */
>  			dma_unmap_single(sq->pdev, 
>  xdpi.frame.dma_addr,
>  					 xdpi.frame.xdpf->len, 
>  DMA_TO_DEVICE);
> -			xdp_return_frame(xdpi.frame.xdpf);
> +			xdp_return_frame_bulk(xdpi.frame.xdpf, 
> &bq);
>  			break;
>  		case MLX5E_XDP_XMIT_MODE_PAGE:
>  			/* XDP_TX from the regular RQ */
> @@ -393,6 +395,7 @@ static void mlx5e_free_xdpsq_desc(struct 
> mlx5e_xdpsq *sq,
>  			WARN_ON_ONCE(true);
>  		}
>  	}
> +	xdp_flush_frame_bulk(&bq);

While I understand the rational behind this patchset, using an 
intermediate buffer
	void *q[XDP_BULK_QUEUE_SIZE];
means more pressure on the data cache.

At the time I ran performance tests on mlx5 to see whether 
batching skbs before passing them to GRO would improve 
performance. On some flows I got worse performance.
This function seems to have less Dcache contention than RX flow, 
but maybe some performance testing are needed here.

>  }
>  
>  bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)

