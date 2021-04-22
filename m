Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3ED4367E9A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 12:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbhDVK0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 06:26:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:63261 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhDVK0n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 06:26:43 -0400
IronPort-SDR: q3QOC3K7l8px/15bCqfR5isEsx5Sh6iZK+wBM02DH2SEH+5kfzdiORF64KSZe5TROHyr21l7kp
 wx4/qaXs0xkQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="193743764"
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="193743764"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 03:26:09 -0700
IronPort-SDR: mHY7u5k59moItct7caFWGDF+/okmwjUEh+XeA0FcTjUAh/KjJDBss1VZbhrXWCi4c5fZrrH1Zw
 NMEkUKsQFD/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="524603351"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Apr 2021 03:26:05 -0700
Date:   Thu, 22 Apr 2021 12:11:29 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net v3] igb: Fix XDP with PTP enabled
Message-ID: <20210422101129.GB44289@ranger.igk.intel.com>
References: <20210422052617.17267-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422052617.17267-1-kurt@linutronix.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 07:26:17AM +0200, Kurt Kanzenbach wrote:
> When using native XDP with the igb driver, the XDP frame data doesn't point to
> the beginning of the packet. It's off by 16 bytes. Everything works as expected
> with XDP skb mode.
> 
> Actually these 16 bytes are used to store the packet timestamps. Therefore, pull
> the timestamp before executing any XDP operations and adjust all other code
> accordingly. The igc driver does it like that as well.
> 
> Tested with Intel i210 card and AF_XDP sockets.
> 
> Fixes: 9cbc948b5a20 ("igb: add XDP support")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
> 
> Changes since v2:
> 
>  * Check timestamp for validity (Nguyen, Anthony L)
> 
> Changes since v1:
> 
>  * Use xdp_prepare_buff() (Lorenzo Bianconi)
> 
> Changes since RFC:
> 
>  * Removed unused return value definitions (Alexander Duyck)
> 
> Previous versions:
> 
>  * https://lkml.kernel.org/netdev/20210419072332.7246-1-kurt@linutronix.de/
>  * https://lkml.kernel.org/netdev/20210415092145.27322-1-kurt@linutronix.de/
>  * https://lkml.kernel.org/netdev/20210412101713.15161-1-kurt@linutronix.de/
> 
>  drivers/net/ethernet/intel/igb/igb.h      |  3 +-
>  drivers/net/ethernet/intel/igb/igb_main.c | 45 +++++++++++++----------
>  drivers/net/ethernet/intel/igb/igb_ptp.c  | 21 ++++-------
>  3 files changed, 34 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
> index 7bda8c5edea5..72cf967c1a00 100644
> --- a/drivers/net/ethernet/intel/igb/igb.h
> +++ b/drivers/net/ethernet/intel/igb/igb.h
> @@ -748,8 +748,7 @@ void igb_ptp_suspend(struct igb_adapter *adapter);
>  void igb_ptp_rx_hang(struct igb_adapter *adapter);
>  void igb_ptp_tx_hang(struct igb_adapter *adapter);
>  void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector, struct sk_buff *skb);
> -int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
> -			struct sk_buff *skb);
> +ktime_t igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va);
>  int igb_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
>  int igb_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr);
>  void igb_set_flag_queue_pairs(struct igb_adapter *, const u32);
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index a45cd2b416c8..13595618f9e3 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -8281,7 +8281,7 @@ static void igb_add_rx_frag(struct igb_ring *rx_ring,
>  static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
>  					 struct igb_rx_buffer *rx_buffer,
>  					 struct xdp_buff *xdp,
> -					 union e1000_adv_rx_desc *rx_desc)
> +					 ktime_t timestamp)
>  {
>  #if (PAGE_SIZE < 8192)
>  	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
> @@ -8301,12 +8301,8 @@ static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
>  	if (unlikely(!skb))
>  		return NULL;
>  
> -	if (unlikely(igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP))) {
> -		if (!igb_ptp_rx_pktstamp(rx_ring->q_vector, xdp->data, skb)) {
> -			xdp->data += IGB_TS_HDR_LEN;
> -			size -= IGB_TS_HDR_LEN;
> -		}
> -	}
> +	if (timestamp)
> +		skb_hwtstamps(skb)->hwtstamp = timestamp;
>  
>  	/* Determine available headroom for copy */
>  	headlen = size;
> @@ -8337,7 +8333,7 @@ static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
>  static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
>  				     struct igb_rx_buffer *rx_buffer,
>  				     struct xdp_buff *xdp,
> -				     union e1000_adv_rx_desc *rx_desc)
> +				     ktime_t timestamp)
>  {
>  #if (PAGE_SIZE < 8192)
>  	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
> @@ -8364,11 +8360,8 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
>  	if (metasize)
>  		skb_metadata_set(skb, metasize);
>  
> -	/* pull timestamp out of packet data */
> -	if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
> -		if (!igb_ptp_rx_pktstamp(rx_ring->q_vector, skb->data, skb))
> -			__skb_pull(skb, IGB_TS_HDR_LEN);
> -	}
> +	if (timestamp)
> +		skb_hwtstamps(skb)->hwtstamp = timestamp;
>  
>  	/* update buffer offset */
>  #if (PAGE_SIZE < 8192)
> @@ -8683,7 +8676,10 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
>  	while (likely(total_packets < budget)) {
>  		union e1000_adv_rx_desc *rx_desc;
>  		struct igb_rx_buffer *rx_buffer;
> +		ktime_t timestamp = 0;
> +		int pkt_offset = 0;
>  		unsigned int size;
> +		void *pktbuf;
>  
>  		/* return some buffers to hardware, one at a time is too slow */
>  		if (cleaned_count >= IGB_RX_BUFFER_WRITE) {
> @@ -8703,14 +8699,24 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
>  		dma_rmb();
>  
>  		rx_buffer = igb_get_rx_buffer(rx_ring, size, &rx_buf_pgcnt);
> +		pktbuf = page_address(rx_buffer->page) + rx_buffer->page_offset;
> +
> +		/* pull rx packet timestamp if available and valid */
> +		if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
> +			timestamp = igb_ptp_rx_pktstamp(rx_ring->q_vector,
> +							pktbuf);
> +
> +			if (timestamp) {
> +				pkt_offset += IGB_TS_HDR_LEN;
> +				size -= IGB_TS_HDR_LEN;
> +			}
> +		}

Small nit: since this is a hot path, maybe we could omit the additional
branch that you're introducing above and make igb_ptp_rx_pktstamp() to
return either 0 for error cases and IGB_TS_HDR_LEN if timestamp was fine?
timestamp itself would be passed as an arg.

So:
		if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
			ts_offset = igb_ptp_rx_pktstamp(rx_ring->q_vector,
							pktbuf, &timestamp);
			pkt_offset += ts_offset;
			size -= ts_offset;
		}

Thoughts? I feel like if we see that desc has timestamp enabled then let's
optimize it for successful case.

>  
>  		/* retrieve a buffer from the ring */
>  		if (!skb) {
> -			unsigned int offset = igb_rx_offset(rx_ring);
> -			unsigned char *hard_start;
> +			unsigned char *hard_start = pktbuf - igb_rx_offset(rx_ring);
> +			unsigned int offset = pkt_offset + igb_rx_offset(rx_ring);

Probably we could do something similar in flavour of:
https://lore.kernel.org/bpf/20210118151318.12324-10-maciej.fijalkowski@intel.com/

which broke XDP_REDIRECT and got fixed in:
https://lore.kernel.org/bpf/20210303153928.11764-2-maciej.fijalkowski@intel.com/

You get the idea.

>  
> -			hard_start = page_address(rx_buffer->page) +
> -				     rx_buffer->page_offset - offset;
>  			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
>  #if (PAGE_SIZE > 4096)
>  			/* At larger PAGE_SIZE, frame_sz depend on len size */
> @@ -8733,10 +8739,11 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
>  		} else if (skb)
>  			igb_add_rx_frag(rx_ring, rx_buffer, skb, size);
>  		else if (ring_uses_build_skb(rx_ring))
> -			skb = igb_build_skb(rx_ring, rx_buffer, &xdp, rx_desc);
> +			skb = igb_build_skb(rx_ring, rx_buffer, &xdp,
> +					    timestamp);
>  		else
>  			skb = igb_construct_skb(rx_ring, rx_buffer,
> -						&xdp, rx_desc);
> +						&xdp, timestamp);
>  
>  		/* exit if we failed to retrieve a buffer */
>  		if (!skb) {
> diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
> index 86a576201f5f..8e23df7da641 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ptp.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
> @@ -856,30 +856,26 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter)
>  	dev_kfree_skb_any(skb);
>  }
>  
> -#define IGB_RET_PTP_DISABLED 1
> -#define IGB_RET_PTP_INVALID 2
> -
>  /**
>   * igb_ptp_rx_pktstamp - retrieve Rx per packet timestamp
>   * @q_vector: Pointer to interrupt specific structure
>   * @va: Pointer to address containing Rx buffer
> - * @skb: Buffer containing timestamp and packet
>   *
>   * This function is meant to retrieve a timestamp from the first buffer of an
>   * incoming frame.  The value is stored in little endian format starting on
>   * byte 8
>   *
> - * Returns: 0 if success, nonzero if failure
> + * Returns: 0 on failure, timestamp on success
>   **/
> -int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
> -			struct sk_buff *skb)
> +ktime_t igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va)
>  {
>  	struct igb_adapter *adapter = q_vector->adapter;
> +	struct skb_shared_hwtstamps ts;
>  	__le64 *regval = (__le64 *)va;
>  	int adjust = 0;
>  
>  	if (!(adapter->ptp_flags & IGB_PTP_ENABLED))
> -		return IGB_RET_PTP_DISABLED;
> +		return 0;
>  
>  	/* The timestamp is recorded in little endian format.
>  	 * DWORD: 0        1        2        3
> @@ -888,10 +884,9 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
>  
>  	/* check reserved dwords are zero, be/le doesn't matter for zero */
>  	if (regval[0])
> -		return IGB_RET_PTP_INVALID;
> +		return 0;
>  
> -	igb_ptp_systim_to_hwtstamp(adapter, skb_hwtstamps(skb),
> -				   le64_to_cpu(regval[1]));
> +	igb_ptp_systim_to_hwtstamp(adapter, &ts, le64_to_cpu(regval[1]));
>  
>  	/* adjust timestamp for the RX latency based on link speed */
>  	if (adapter->hw.mac.type == e1000_i210) {
> @@ -907,10 +902,8 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
>  			break;
>  		}
>  	}
> -	skb_hwtstamps(skb)->hwtstamp =
> -		ktime_sub_ns(skb_hwtstamps(skb)->hwtstamp, adjust);
>  
> -	return 0;
> +	return ktime_sub_ns(ts.hwtstamp, adjust);
>  }
>  
>  /**
> -- 
> 2.20.1
> 
