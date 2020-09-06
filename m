Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB24825ED31
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 09:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgIFHdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 03:33:45 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:59293 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgIFHdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 03:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599377624; x=1630913624;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=YvgIlCgYCLyRFrNS2MpOwa2jBtR2GoLFq5H6I1wd0J0=;
  b=IvG8ZLWw4S8sl9p+XsdbQbgvhD9JBnC2+1/1lzxcoSvmHa+Ho/0Lmnyn
   syK28rTF4aglnG5nKx/P7dyF+EAgN0UIlhrI/dgjUbmTJtT/UJHlqE5d9
   AP+d1rPyQHu1wnUZw43OsSgmtXD7r9T6AaelIvDqxJEMU1t6EPWkAkHkZ
   U=;
X-IronPort-AV: E=Sophos;i="5.76,397,1592870400"; 
   d="scan'208";a="72677978"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 06 Sep 2020 07:33:38 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 8F49BA235F;
        Sun,  6 Sep 2020 07:33:35 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.160.183) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Sep 2020 07:33:29 +0000
References: <cover.1599165031.git.lorenzo@kernel.org> <25198d8424778abe9ee3fe25bba542143201b030.1599165031.git.lorenzo@kernel.org>
User-agent: mu4e 1.4.12; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <lorenzo.bianconi@redhat.com>,
        <brouer@redhat.com>, <echaudro@redhat.com>, <sameehj@amazon.com>,
        <kuba@kernel.org>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <ast@kernel.org>
Subject: Re: [PATCH v2 net-next 3/9] net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
In-Reply-To: <25198d8424778abe9ee3fe25bba542143201b030.1599165031.git.lorenzo@kernel.org>
Date:   Sun, 6 Sep 2020 10:33:16 +0300
Message-ID: <pj41zly2lnpdfn.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.183]
X-ClientProxiedBy: EX13D15UWA004.ant.amazon.com (10.43.160.219) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF 
> layer and
> XDP remote drivers if this is a "non-linear" XDP buffer. Access
> skb_shared_info only if xdp_buff mb is set
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 37 
>  +++++++++++++++------------
>  1 file changed, 21 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvneta.c 
> b/drivers/net/ethernet/marvell/mvneta.c
> index 832bbb8b05c8..4f745a2b702a 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2027,11 +2027,11 @@ mvneta_xdp_put_buff(struct mvneta_port 
> *pp, struct mvneta_rx_queue *rxq,
>  		    struct xdp_buff *xdp, int sync_len, bool napi)
>  {
>  	struct skb_shared_info *sinfo = 
>  xdp_get_shared_info_from_buff(xdp);
> -	int i;
> +	int i, num_frames = xdp->mb ? sinfo->nr_frags : 0;
>  
>  	page_pool_put_page(rxq->page_pool, 
>  virt_to_head_page(xdp->data),
>  			   sync_len, napi);
> -	for (i = 0; i < sinfo->nr_frags; i++)
> +	for (i = 0; i < num_frames; i++)
>  		page_pool_put_full_page(rxq->page_pool,
>  					skb_frag_page(&sinfo->frags[i]), 
>  napi);
>  }
> ...
> @@ -2175,6 +2175,7 @@ mvneta_run_xdp(struct mvneta_port *pp, 
> struct mvneta_rx_queue *rxq,
>  
>  	len = xdp->data_end - xdp->data_hard_start - 
>  pp->rx_offset_correction;
>  	data_len = xdp->data_end - xdp->data;
> -	sinfo = xdp_get_shared_info_from_buff(xdp);
> -	sinfo->nr_frags = 0;
> +	xdp->mb = 0;
>  
>  	*size = rx_desc->data_size - len;
>  	rx_desc->buf_phys_addr = 0;
> @@ -2269,7 +2267,7 @@ mvneta_swbm_add_rx_fragment(struct 
> mvneta_port *pp,
>  			    struct mvneta_rx_desc *rx_desc,
>  			    struct mvneta_rx_queue *rxq,
>  			    struct xdp_buff *xdp, int *size,
> -			    struct page *page)
> +			    int *nfrags, struct page *page)
>  {
>  	struct skb_shared_info *sinfo = 
>  xdp_get_shared_info_from_buff(xdp);
>  	struct net_device *dev = pp->dev;
> @@ -2288,13 +2286,18 @@ mvneta_swbm_add_rx_fragment(struct 
> mvneta_port *pp,
>  				rx_desc->buf_phys_addr,
>  				len, dma_dir);
>  
> -	if (data_len > 0 && sinfo->nr_frags < MAX_SKB_FRAGS) {
> -		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags];
> +	if (data_len > 0 && *nfrags < MAX_SKB_FRAGS) {
> +		skb_frag_t *frag = &sinfo->frags[*nfrags];
>  
>  		skb_frag_off_set(frag, pp->rx_offset_correction);
>  		skb_frag_size_set(frag, data_len);
>  		__skb_frag_set_page(frag, page);
> -		sinfo->nr_frags++;
> +		*nfrags = *nfrags + 1;

nit, why do you use nfrags variable instead of sinfo->nr_frags (as 
it was before this patch) ?
                You doesn't seem to use the nfrags variable in the 
                caller function and you update nr_frags as well.
                If it's used in a different patch (haven't 
                reviewed it all yet), maybe move it to that patch 
                ? (sorry in advance if I missed the logic here)

> +
> +		if (rx_desc->status & MVNETA_RXD_LAST_DESC) {
> +			sinfo->nr_frags = *nfrags;
> +			xdp->mb = true;
> +		}
>  
>  		rx_desc->buf_phys_addr = 0;
>               ...
