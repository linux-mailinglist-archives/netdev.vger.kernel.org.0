Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC502DF051
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 16:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgLSP5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 10:57:34 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:37850 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgLSP5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 10:57:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608393453; x=1639929453;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=jprTllV/NKMcaUlvqLC9ko9oxhLiTxLoJPYf+AZaJ94=;
  b=sVnNa7rOHezATUx4758vBWXwC96iakQrsWrJ42MZYtmSi8otRCKWZs7n
   ZUCgFZ8MKE4MA1azuoE96Yq6Kn3bnvZFTuKIIZKU9fegghrqZG8JKSF9m
   /eAf3sk7oU0X8BlXRF5AKp7ssIsi7GgCy+aXPO5Flfdc11u9wV5jXPHEA
   U=;
X-IronPort-AV: E=Sophos;i="5.78,433,1599523200"; 
   d="scan'208";a="70394141"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 19 Dec 2020 15:56:46 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 9959F282434;
        Sat, 19 Dec 2020 15:56:42 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.162.125) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 19 Dec 2020 15:56:35 +0000
References: <cover.1607349924.git.lorenzo@kernel.org>
 <f3d2937208eae9644f36d805cd5b30e0985767a6.1607349924.git.lorenzo@kernel.org>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <sameehj@amazon.com>,
        <john.fastabend@gmail.com>, <dsahern@kernel.org>,
        <brouer@redhat.com>, <echaudro@redhat.com>,
        <lorenzo.bianconi@redhat.com>, <jasowang@redhat.com>
Subject: Re: [PATCH v5 bpf-next 06/14] net: mvneta: add multi buffer support
 to XDP_TX
In-Reply-To: <f3d2937208eae9644f36d805cd5b30e0985767a6.1607349924.git.lorenzo@kernel.org>
Date:   Sat, 19 Dec 2020 17:56:22 +0200
Message-ID: <pj41zlh7ohpz6h.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.125]
X-ClientProxiedBy: EX13D30UWC003.ant.amazon.com (10.43.162.122) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Introduce the capability to map non-linear xdp buffer running
> mvneta_xdp_submit_frame() for XDP_TX and XDP_REDIRECT
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 94 
>  ++++++++++++++++-----------
>  1 file changed, 56 insertions(+), 38 deletions(-)
[...]
>  			if (napi && buf->type == 
>  MVNETA_TYPE_XDP_TX)
>  				xdp_return_frame_rx_napi(buf->xdpf);
>  			else
> @@ -2054,45 +2054,64 @@ mvneta_xdp_put_buff(struct mvneta_port 
> *pp, struct mvneta_rx_queue *rxq,
>  
>  static int
>  mvneta_xdp_submit_frame(struct mvneta_port *pp, struct 
>  mvneta_tx_queue *txq,
> -			struct xdp_frame *xdpf, bool dma_map)
> +			struct xdp_frame *xdpf, int *nxmit_byte, 
> bool dma_map)
>  {
> -	struct mvneta_tx_desc *tx_desc;
> -	struct mvneta_tx_buf *buf;
> -	dma_addr_t dma_addr;
> +	struct xdp_shared_info *xdp_sinfo = 
> xdp_get_shared_info_from_frame(xdpf);
> +	int i, num_frames = xdpf->mb ? xdp_sinfo->nr_frags + 1 : 
> 1;
> +	struct mvneta_tx_desc *tx_desc = NULL;
> +	struct page *page;
>  
> -	if (txq->count >= txq->tx_stop_threshold)
> +	if (txq->count + num_frames >= txq->size)
>  		return MVNETA_XDP_DROPPED;
>  
> -	tx_desc = mvneta_txq_next_desc_get(txq);
> +	for (i = 0; i < num_frames; i++) {
> +		struct mvneta_tx_buf *buf = 
> &txq->buf[txq->txq_put_index];
> +		skb_frag_t *frag = i ? &xdp_sinfo->frags[i - 1] : 
> NULL;
> +		int len = frag ? xdp_get_frag_size(frag) : 
> xdpf->len;

nit, from branch prediction point of view, maybe it would be 
better to write
     int len = i ? xdp_get_frag_size(frag) : xdpf->len;

since the value of i is checked one line above
Disclaimer: I'm far from a compiler expert, and don't know whether 
the compiler would know to group these two assignments together 
into a single branch prediction decision, but it feels like using 
'i' would make this decision easier for it.

Thanks,
Shay

[...]

