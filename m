Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49BB2D0719
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 21:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgLFUTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 15:19:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:29396 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgLFUTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 15:19:41 -0500
IronPort-SDR: HjF1qTImjgRWS5fegAb5wlL3PHyIq+UddoLbLI3QfPlTUYjn/Bj6z49mT+orX6wUY6dfytk7CL
 NUROlSYbPGIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9827"; a="173762276"
X-IronPort-AV: E=Sophos;i="5.78,397,1599548400"; 
   d="scan'208";a="173762276"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2020 12:18:59 -0800
IronPort-SDR: ctCNbtiMwph+MfB8fseIjGcaZ9wtwFU5QLqmJ2ARIcAJslS4i4vLYiOdWV8b6fqBoMRAzdqTE2
 j+nhHhIn5cVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,397,1599548400"; 
   d="scan'208";a="369542473"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 06 Dec 2020 12:18:56 -0800
Date:   Sun, 6 Dec 2020 21:10:31 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     akiyano@amazon.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, gtzalik@amazon.com, netanel@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, ndagan@amazon.com,
        shayagr@amazon.com, sameehj@amazon.com
Subject: Re: [PATCH V4 net-next 6/9] net: ena: use xdp_frame in XDP TX flow
Message-ID: <20201206201031.GC23696@ranger.igk.intel.com>
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
 <1607083875-32134-7-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607083875-32134-7-git-send-email-akiyano@amazon.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 02:11:12PM +0200, akiyano@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Rename the ena_xdp_xmit_buff() function to ena_xdp_xmit_frame() and pass
> it an xdp_frame struct instead of xdp_buff.
> This change lays the ground for XDP redirect implementation which uses
> xdp_frames when 'xmit'ing packets.
> 
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 46 ++++++++++----------
>  1 file changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 222bb576e30e..cbb07548409a 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -233,18 +233,18 @@ static int ena_xdp_io_poll(struct napi_struct *napi, int budget)
>  	return ret;
>  }
>  
> -static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
> -			       struct ena_tx_buffer *tx_info,
> -			       struct xdp_buff *xdp,
> -			       void **push_hdr,
> -			       u32 *push_len)
> +static int ena_xdp_tx_map_frame(struct ena_ring *xdp_ring,
> +				struct ena_tx_buffer *tx_info,
> +				struct xdp_frame *xdpf,
> +				void **push_hdr,
> +				u32 *push_len)
>  {
>  	struct ena_adapter *adapter = xdp_ring->adapter;
>  	struct ena_com_buf *ena_buf;
>  	dma_addr_t dma = 0;
>  	u32 size;
>  
> -	tx_info->xdpf = xdp_convert_buff_to_frame(xdp);
> +	tx_info->xdpf = xdpf;
>  	size = tx_info->xdpf->len;
>  	ena_buf = tx_info->bufs;
>  
> @@ -281,29 +281,31 @@ static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
>  	return -EINVAL;
>  }
>  
> -static int ena_xdp_xmit_buff(struct net_device *dev,
> -			     struct xdp_buff *xdp,
> -			     int qid,
> -			     struct ena_rx_buffer *rx_info)
> +static int ena_xdp_xmit_frame(struct net_device *dev,
> +			      struct xdp_frame *xdpf,
> +			      int qid)
>  {
>  	struct ena_adapter *adapter = netdev_priv(dev);
>  	struct ena_com_tx_ctx ena_tx_ctx = {};
>  	struct ena_tx_buffer *tx_info;
>  	struct ena_ring *xdp_ring;
> +	struct page *rx_buff_page;
>  	u16 next_to_use, req_id;
>  	int rc;
>  	void *push_hdr;
>  	u32 push_len;
>  
> +	rx_buff_page = virt_to_page(xdpf->data);
> +
>  	xdp_ring = &adapter->tx_ring[qid];
>  	next_to_use = xdp_ring->next_to_use;
>  	req_id = xdp_ring->free_ids[next_to_use];
>  	tx_info = &xdp_ring->tx_buffer_info[req_id];
>  	tx_info->num_of_bufs = 0;
> -	page_ref_inc(rx_info->page);
> -	tx_info->xdp_rx_page = rx_info->page;
> +	page_ref_inc(rx_buff_page);
> +	tx_info->xdp_rx_page = rx_buff_page;
>  
> -	rc = ena_xdp_tx_map_buff(xdp_ring, tx_info, xdp, &push_hdr, &push_len);
> +	rc = ena_xdp_tx_map_frame(xdp_ring, tx_info, xdpf, &push_hdr, &push_len);
>  	if (unlikely(rc))
>  		goto error_drop_packet;
>  
> @@ -318,7 +320,7 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
>  			     tx_info,
>  			     &ena_tx_ctx,
>  			     next_to_use,
> -			     xdp->data_end - xdp->data);
> +			     xdpf->len);
>  	if (rc)
>  		goto error_unmap_dma;
>  	/* trigger the dma engine. ena_com_write_sq_doorbell()
> @@ -337,12 +339,11 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
>  	return NETDEV_TX_OK;
>  }
>  
> -static int ena_xdp_execute(struct ena_ring *rx_ring,
> -			   struct xdp_buff *xdp,
> -			   struct ena_rx_buffer *rx_info)
> +static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
>  {
>  	struct bpf_prog *xdp_prog;
>  	u32 verdict = XDP_PASS;
> +	struct xdp_frame *xdpf;
>  	u64 *xdp_stat;
>  
>  	rcu_read_lock();
> @@ -354,10 +355,9 @@ static int ena_xdp_execute(struct ena_ring *rx_ring,
>  	verdict = bpf_prog_run_xdp(xdp_prog, xdp);
>  
>  	if (verdict == XDP_TX) {
> -		ena_xdp_xmit_buff(rx_ring->netdev,
> -				  xdp,
> -				  rx_ring->qid + rx_ring->adapter->num_io_queues,
> -				  rx_info);
> +		xdpf = xdp_convert_buff_to_frame(xdp);

Similar to Jakub's comment on another patch, xdp_convert_buff_to_frame can
return NULL and from what I can tell you never check that in
ena_xdp_xmit_frame.

> +		ena_xdp_xmit_frame(rx_ring->netdev, xdpf,
> +				   rx_ring->qid + rx_ring->adapter->num_io_queues);
>  
>  		xdp_stat = &rx_ring->rx_stats.xdp_tx;
>  	} else if (unlikely(verdict == XDP_ABORTED)) {
> @@ -1521,7 +1521,7 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
>  	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
>  		return XDP_DROP;
>  
> -	ret = ena_xdp_execute(rx_ring, xdp, rx_info);
> +	ret = ena_xdp_execute(rx_ring, xdp);
>  
>  	/* The xdp program might expand the headers */
>  	if (ret == XDP_PASS) {
> @@ -1600,7 +1600,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
>  		if (unlikely(!skb)) {
>  			/* The page might not actually be freed here since the
>  			 * page reference count is incremented in
> -			 * ena_xdp_xmit_buff(), and it will be decreased only
> +			 * ena_xdp_xmit_frame(), and it will be decreased only
>  			 * when send completion was received from the device
>  			 */
>  			if (xdp_verdict == XDP_TX)
> -- 
> 2.23.3
> 
