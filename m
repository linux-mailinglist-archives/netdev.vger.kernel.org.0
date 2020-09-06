Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A500525ED1E
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 09:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgIFHWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 03:22:20 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:63126 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgIFHWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 03:22:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599376939; x=1630912939;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=cI/9r3WvHRaTPdMYu+pZL9+p2q8E1umiAPSLgKcrqiU=;
  b=MsYJRp8CYX2B8jtMTba6Yzg2hJnMefHxxV5IQlJ1wZgnSLWB7d+meNWC
   w9NR1FIcBNSHtjro3HJ9CLSWH/O0ZYfqm7GUT62dglFkYtJ6isLm6vA2s
   QcZHsLWq9+8PQUMSzYnNZyx4VFvtxKU0Ev+fE+BpQ3jjtRyrSjGWQkJTO
   E=;
X-IronPort-AV: E=Sophos;i="5.76,397,1592870400"; 
   d="scan'208";a="52087062"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 06 Sep 2020 07:22:12 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id D0075A1F2E;
        Sun,  6 Sep 2020 07:22:09 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.160.215) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Sep 2020 07:22:03 +0000
References: <cover.1599165031.git.lorenzo@kernel.org> <2a5b39dd780f9d3ef7ff060699beca57413c3761.1599165031.git.lorenzo@kernel.org>
User-agent: mu4e 1.4.12; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <lorenzo.bianconi@redhat.com>,
        <brouer@redhat.com>, <echaudro@redhat.com>, <sameehj@amazon.com>,
        <kuba@kernel.org>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <ast@kernel.org>
Subject: Re: [PATCH v2 net-next 5/9] net: mvneta: add multi buffer support to XDP_TX
In-Reply-To: <2a5b39dd780f9d3ef7ff060699beca57413c3761.1599165031.git.lorenzo@kernel.org>
Date:   Sun, 6 Sep 2020 10:20:18 +0300
Message-ID: <pj41zl1rjfqslp.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.215]
X-ClientProxiedBy: EX13D02UWB004.ant.amazon.com (10.43.161.11) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Introduce the capability to map non-linear xdp buffer running
> mvneta_xdp_submit_frame() for XDP_TX and XDP_REDIRECT
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 79 
>  +++++++++++++++++----------
>  1 file changed, 49 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvneta.c 
> b/drivers/net/ethernet/marvell/mvneta.c
> index 4f745a2b702a..65fbed957e4f 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -1854,8 +1854,8 @@ static void mvneta_txq_bufs_free(struct 
> mvneta_port *pp,
>  			bytes_compl += buf->skb->len;
>  			pkts_compl++;
>  			dev_kfree_skb_any(buf->skb);
> -		} else if (buf->type == MVNETA_TYPE_XDP_TX ||
> -			   buf->type == MVNETA_TYPE_XDP_NDO) {
> +		} else if ((buf->type == MVNETA_TYPE_XDP_TX ||
> +			    buf->type == MVNETA_TYPE_XDP_NDO) && 
> buf->xdpf) {
>  			xdp_return_frame(buf->xdpf);
>  		}
>  	}
> @@ -2040,43 +2040,62 @@ static int
>  mvneta_xdp_submit_frame(struct mvneta_port *pp, struct 
>  mvneta_tx_queue *txq,
>  			struct xdp_frame *xdpf, bool dma_map)
>  {
> -	struct mvneta_tx_desc *tx_desc;
> -	struct mvneta_tx_buf *buf;
> -	dma_addr_t dma_addr;
> +	struct skb_shared_info *sinfo = 
> xdp_get_shared_info_from_frame(xdpf);
> +	int i, num_frames = xdpf->mb ? sinfo->nr_frags + 1 : 1;
> +	struct mvneta_tx_desc *tx_desc = NULL;
> +	struct page *page;
>  
> -	if (txq->count >= txq->tx_stop_threshold)
> +	if (txq->count + num_frames >= txq->tx_stop_threshold)
>  		return MVNETA_XDP_DROPPED;
>  
> -	tx_desc = mvneta_txq_next_desc_get(txq);
> +	for (i = 0; i < num_frames; i++) {
> +		struct mvneta_tx_buf *buf = 
> &txq->buf[txq->txq_put_index];
> +		skb_frag_t *frag = i ? &sinfo->frags[i - 1] : 
> NULL;
> +		int len = frag ? skb_frag_size(frag) : xdpf->len;
> +		dma_addr_t dma_addr;
>  
> -	buf = &txq->buf[txq->txq_put_index];
> -	if (dma_map) {
> -		/* ndo_xdp_xmit */
> -		dma_addr = dma_map_single(pp->dev->dev.parent, 
> xdpf->data,
> -					  xdpf->len, 
> DMA_TO_DEVICE);
> -		if (dma_mapping_error(pp->dev->dev.parent, 
> dma_addr)) {
> -			mvneta_txq_desc_put(txq);
> -			return MVNETA_XDP_DROPPED;
> +		tx_desc = mvneta_txq_next_desc_get(txq);
> +		if (dma_map) {
> +			/* ndo_xdp_xmit */
> +			void *data;
> +
> +			data = frag ? 
> page_address(skb_frag_page(frag))
> +				    : xdpf->data;
> +			dma_addr = 
> dma_map_single(pp->dev->dev.parent, data,
> +						  len, 
> DMA_TO_DEVICE);
> +			if (dma_mapping_error(pp->dev->dev.parent, 
> dma_addr)) {
> +				for (; i >= 0; i--)
> +					mvneta_txq_desc_put(txq);
> +				return MVNETA_XDP_DROPPED;
> +			}
> +			buf->type = MVNETA_TYPE_XDP_NDO;
> +		} else {
> +			page = frag ? skb_frag_page(frag)
> +				    : virt_to_page(xdpf->data);
> +			dma_addr = page_pool_get_dma_addr(page);
> +			if (!frag)
> +				dma_addr += sizeof(*xdpf) + 
> xdpf->headroom;
> + 
> dma_sync_single_for_device(pp->dev->dev.parent,
> +						   dma_addr, len,
> + 
> DMA_BIDIRECTIONAL);
> +			buf->type = MVNETA_TYPE_XDP_TX;
>  		}
> -		buf->type = MVNETA_TYPE_XDP_NDO;
> -	} else {
> -		struct page *page = virt_to_page(xdpf->data);
> +		buf->xdpf = i ? NULL : xdpf;
>  
> -		dma_addr = page_pool_get_dma_addr(page) +
> -			   sizeof(*xdpf) + xdpf->headroom;
> -		dma_sync_single_for_device(pp->dev->dev.parent, 
> dma_addr,
> -					   xdpf->len, 
> DMA_BIDIRECTIONAL);
> -		buf->type = MVNETA_TYPE_XDP_TX;
> +		if (!i)
> +			tx_desc->command = MVNETA_TXD_F_DESC;
> +		tx_desc->buf_phys_addr = dma_addr;
> +		tx_desc->data_size = len;
> +
> +		mvneta_txq_inc_put(txq);
>  	}
> -	buf->xdpf = xdpf;
>  
> -	tx_desc->command = MVNETA_TXD_FLZ_DESC;
> -	tx_desc->buf_phys_addr = dma_addr;
> -	tx_desc->data_size = xdpf->len;
> +	/*last descriptor */
> +	if (tx_desc)
> +		tx_desc->command |= MVNETA_TXD_L_DESC | 
> MVNETA_TXD_Z_PAD;

        When is this condition not taken ? You initialize tx_desc 
        to NULL, but it seems to me like you always set it inside 
        the for loop to the output of mvneta_txq_next_desc_get() 
        which doesn't look like it returns NULL. The for loop runs 1 iteration or `sinfo->nr_frage 
+ 1` iterations (which also equals or larger than 1).

>  
> -	mvneta_txq_inc_put(txq);
> -	txq->pending++;
> -	txq->count++;
> +	txq->pending += num_frames;
> +	txq->count += num_frames;
>  
>  	return MVNETA_XDP_TX;
>  }

