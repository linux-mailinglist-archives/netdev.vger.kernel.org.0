Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34252D0720
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 21:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgLFUbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 15:31:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:58573 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgLFUbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 15:31:40 -0500
IronPort-SDR: GU6iepYo3MPiwTksaXjewanqOKYGbOwbPux0WyF4CMK6rhdJu06uoEaLoc7pyBTOlv2wwHmhHw
 5yvTL8zaPZ5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9827"; a="173762665"
X-IronPort-AV: E=Sophos;i="5.78,397,1599548400"; 
   d="scan'208";a="173762665"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2020 12:30:59 -0800
IronPort-SDR: O719GTwr+/+S/URZNfCRVeuTzhoSzSWjR73t4/oviZz1YC07jmMEYlGa8nrmk4Cl34+gabv4oC
 Bpm88A9cjKog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,397,1599548400"; 
   d="scan'208";a="436391696"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2020 12:30:55 -0800
Date:   Sun, 6 Dec 2020 21:22:30 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     akiyano@amazon.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, gtzalik@amazon.com, netanel@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, ndagan@amazon.com,
        shayagr@amazon.com, sameehj@amazon.com
Subject: Re: [PATCH V4 net-next 9/9] net: ena: introduce ndo_xdp_xmit()
 function for XDP_REDIRECT
Message-ID: <20201206202230.GD23696@ranger.igk.intel.com>
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
 <1607083875-32134-10-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607083875-32134-10-git-send-email-akiyano@amazon.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 02:11:15PM +0200, akiyano@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> This patch implements the ndo_xdp_xmit() net_device function which is
> called when a packet is redirected to this driver using an
> XDP_REDIRECT directive.
> 
> The function receives an array of xdp frames that it needs to xmit.
> The TX queues that are used to xmit these frames are the XDP
> queues used by the XDP_TX flow. Therefore a lock is added to synchronize
> both flows (XDP_TX and XDP_REDIRECT).
> 
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 83 +++++++++++++++++---
>  drivers/net/ethernet/amazon/ena/ena_netdev.h |  1 +
>  2 files changed, 72 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 0d077a626604..6c5d8b8c4d13 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -281,20 +281,18 @@ static int ena_xdp_tx_map_frame(struct ena_ring *xdp_ring,
>  	return -EINVAL;
>  }
>  
> -static int ena_xdp_xmit_frame(struct net_device *dev,
> +static int ena_xdp_xmit_frame(struct ena_ring *xdp_ring,
> +			      struct net_device *dev,
>  			      struct xdp_frame *xdpf,
> -			      int qid)
> +			      int flags)
>  {
> -	struct ena_adapter *adapter = netdev_priv(dev);
>  	struct ena_com_tx_ctx ena_tx_ctx = {};
>  	struct ena_tx_buffer *tx_info;
> -	struct ena_ring *xdp_ring;
>  	u16 next_to_use, req_id;
> -	int rc;
>  	void *push_hdr;
>  	u32 push_len;
> +	int rc;
>  
> -	xdp_ring = &adapter->tx_ring[qid];
>  	next_to_use = xdp_ring->next_to_use;
>  	req_id = xdp_ring->free_ids[next_to_use];
>  	tx_info = &xdp_ring->tx_buffer_info[req_id];
> @@ -321,25 +319,76 @@ static int ena_xdp_xmit_frame(struct net_device *dev,
>  	/* trigger the dma engine. ena_com_write_sq_doorbell()
>  	 * has a mb
>  	 */
> -	ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
> -	ena_increase_stat(&xdp_ring->tx_stats.doorbells, 1, &xdp_ring->syncp);
> +	if (flags & XDP_XMIT_FLUSH) {
> +		ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
> +		ena_increase_stat(&xdp_ring->tx_stats.doorbells, 1,
> +				  &xdp_ring->syncp);
> +	}
>  
> -	return NETDEV_TX_OK;
> +	return rc;
>  
>  error_unmap_dma:
>  	ena_unmap_tx_buff(xdp_ring, tx_info);
>  	tx_info->xdpf = NULL;
>  error_drop_packet:
>  	xdp_return_frame(xdpf);
> -	return NETDEV_TX_OK;
> +	return rc;
> +}
> +
> +static int ena_xdp_xmit(struct net_device *dev, int n,
> +			struct xdp_frame **frames, u32 flags)
> +{
> +	struct ena_adapter *adapter = netdev_priv(dev);
> +	int qid, i, err, drops = 0;
> +	struct ena_ring *xdp_ring;
> +
> +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> +		return -EINVAL;
> +
> +	if (!test_bit(ENA_FLAG_DEV_UP, &adapter->flags))
> +		return -ENETDOWN;
> +
> +	/* We assume that all rings have the same XDP program */
> +	if (!READ_ONCE(adapter->rx_ring->xdp_bpf_prog))
> +		return -ENXIO;
> +
> +	qid = smp_processor_id() % adapter->xdp_num_queues;
> +	qid += adapter->xdp_first_ring;
> +	xdp_ring = &adapter->tx_ring[qid];
> +
> +	/* Other CPU ids might try to send thorugh this queue */
> +	spin_lock(&xdp_ring->xdp_tx_lock);

I have a feeling that we are not consistent with this locking approach as
some drivers do that and some don't.

> +
> +	for (i = 0; i < n; i++) {
> +		err = ena_xdp_xmit_frame(xdp_ring, dev, frames[i], 0);
> +		/* The descriptor is freed by ena_xdp_xmit_frame in case
> +		 * of an error.
> +		 */
> +		if (err)
> +			drops++;
> +	}
> +
> +	/* Ring doorbell to make device aware of the packets */
> +	if (flags & XDP_XMIT_FLUSH) {
> +		ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
> +		ena_increase_stat(&xdp_ring->tx_stats.doorbells, 1,
> +				  &xdp_ring->syncp);

Have you thought of ringing the doorbell once per a batch of xmitted
frames?

> +	}
> +
> +	spin_unlock(&xdp_ring->xdp_tx_lock);
> +
> +	/* Return number of packets sent */
> +	return n - drops;
>  }
>  
>  static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
>  {
>  	struct bpf_prog *xdp_prog;
> +	struct ena_ring *xdp_ring;
>  	u32 verdict = XDP_PASS;
>  	struct xdp_frame *xdpf;
>  	u64 *xdp_stat;
> +	int qid;
>  
>  	rcu_read_lock();
>  	xdp_prog = READ_ONCE(rx_ring->xdp_bpf_prog);
> @@ -352,8 +401,16 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
>  	switch (verdict) {
>  	case XDP_TX:
>  		xdpf = xdp_convert_buff_to_frame(xdp);
> -		ena_xdp_xmit_frame(rx_ring->netdev, xdpf,
> -				   rx_ring->qid + rx_ring->adapter->num_io_queues);
> +		/* Find xmit queue */
> +		qid = rx_ring->qid + rx_ring->adapter->num_io_queues;
> +		xdp_ring = &rx_ring->adapter->tx_ring[qid];
> +
> +		/* The XDP queues are shared between XDP_TX and XDP_REDIRECT */
> +		spin_lock(&xdp_ring->xdp_tx_lock);
> +
> +		ena_xdp_xmit_frame(xdp_ring, rx_ring->netdev, xdpf, XDP_XMIT_FLUSH);

Once again you don't check retval over here.

> +
> +		spin_unlock(&xdp_ring->xdp_tx_lock);
>  		xdp_stat = &rx_ring->rx_stats.xdp_tx;
>  		break;
>  	case XDP_REDIRECT:
> @@ -644,6 +701,7 @@ static void ena_init_io_rings(struct ena_adapter *adapter,
>  		txr->smoothed_interval =
>  			ena_com_get_nonadaptive_moderation_interval_tx(ena_dev);
>  		txr->disable_meta_caching = adapter->disable_meta_caching;
> +		spin_lock_init(&txr->xdp_tx_lock);
>  
>  		/* Don't init RX queues for xdp queues */
>  		if (!ENA_IS_XDP_INDEX(adapter, i)) {
> @@ -3236,6 +3294,7 @@ static const struct net_device_ops ena_netdev_ops = {
>  	.ndo_set_mac_address	= NULL,
>  	.ndo_validate_addr	= eth_validate_addr,
>  	.ndo_bpf		= ena_xdp,
> +	.ndo_xdp_xmit		= ena_xdp_xmit,
>  };
>  
>  static int ena_device_validate_params(struct ena_adapter *adapter,
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
> index fed79c50a870..74af15d62ee1 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
> @@ -258,6 +258,7 @@ struct ena_ring {
>  	struct ena_com_io_sq *ena_com_io_sq;
>  	struct bpf_prog *xdp_bpf_prog;
>  	struct xdp_rxq_info xdp_rxq;
> +	spinlock_t xdp_tx_lock;	/* synchronize XDP TX/Redirect traffic */
>  
>  	u16 next_to_use;
>  	u16 next_to_clean;
> -- 
> 2.23.3
> 
