Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366AD35C8B5
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238789AbhDLO3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:29:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237558AbhDLO3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 10:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618237743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjo5kMEcOV1z9+BzuqEgvJE6ZWi5lpu660nuRfke06w=;
        b=X0H2APc1ysWTKF1oI4Xh/7TvFKyz52adARDIPNw3iR0Ct6+x+Sk4e+ld9lnOjrJwivXxKH
        an2frS6kFyivZ0l6oLn2pl/sKqv1kvwE8/0Og8qEHzSitoVlZlaNWFP3SrnBp5s5NwrldM
        x5DbJ03z/cskjgRVG2n0qI6vnAjWhz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-9Ud_nq_jNk-bs-OnKUU5Cg-1; Mon, 12 Apr 2021 10:28:58 -0400
X-MC-Unique: 9Ud_nq_jNk-bs-OnKUU5Cg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 769439F92C;
        Mon, 12 Apr 2021 14:28:56 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FF3D5D6B1;
        Mon, 12 Apr 2021 14:28:48 +0000 (UTC)
Date:   Mon, 12 Apr 2021 16:28:46 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     brouer@redhat.com, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH RFC net] igb: Fix XDP with PTP enabled
Message-ID: <20210412162846.42706d99@carbon>
In-Reply-To: <20210412101713.15161-1-kurt@linutronix.de>
References: <20210412101713.15161-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 12 Apr 2021 12:17:13 +0200
Kurt Kanzenbach <kurt@linutronix.de> wrote:

> When using native XDP with the igb driver, the XDP frame data doesn't point to
> the beginning of the packet. It's off by 16 bytes. Everything works as expected
> with XDP skb mode.
> 
> Actually these 16 bytes are used to store the packet timestamps. Therefore, pull
> the timestamp before executing any XDP operations and adjust all other code
> accordingly. The igc driver does it like that as well.

(Cc. Alexander Duyck)

Do we have enough room for the packet page-split tricks when these 16
bytes are added?

AFAIK this driver like ixgbe+i40e split the page in two 2048 bytes packets.

 The XDP headroom is reduced to 192 bytes.
 The skb_shared_info is 320 bytes in size.

2048-192-320 = 1536 bytes

 MTU(L3) 1500
 Ethernet (L2) headers 14 bytes
 VLAN 4 bytes, but Q-in-Q vlan 8 bytes.

Single VLAN: 1536-1500-14-4 = 18 bytes left
Q-in-q VLAN: 1536-1500-14-8 = 14 bytes left


> Tested with Intel i210 card and AF_XDP sockets.
> 
> Fixes: 9cbc948b5a20 ("igb: add XDP support")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/net/ethernet/intel/igb/igb.h      |  3 +-
>  drivers/net/ethernet/intel/igb/igb_main.c | 45 ++++++++++++-----------
>  drivers/net/ethernet/intel/igb/igb_ptp.c  | 18 ++++-----
>  3 files changed, 32 insertions(+), 34 deletions(-)

(no comments on code below, but kept it if Alex need to see it)

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
> index a45cd2b416c8..8fab55fd18fc 100644
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
> @@ -8703,15 +8699,21 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
>  		dma_rmb();
>  
>  		rx_buffer = igb_get_rx_buffer(rx_ring, size, &rx_buf_pgcnt);
> +		pktbuf = page_address(rx_buffer->page) + rx_buffer->page_offset;
> +
> +		if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
> +			timestamp = igb_ptp_rx_pktstamp(rx_ring->q_vector,
> +							pktbuf);
> +			pkt_offset += IGB_TS_HDR_LEN;
> +			size -= IGB_TS_HDR_LEN;
> +		}
>  
>  		/* retrieve a buffer from the ring */
>  		if (!skb) {
> -			unsigned int offset = igb_rx_offset(rx_ring);
> -			unsigned char *hard_start;
> -
> -			hard_start = page_address(rx_buffer->page) +
> -				     rx_buffer->page_offset - offset;
> -			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
> +			xdp.data = pktbuf + pkt_offset;
> +			xdp.data_end = xdp.data + size;
> +			xdp.data_meta = xdp.data;
> +			xdp.data_hard_start = pktbuf - igb_rx_offset(rx_ring);
>  #if (PAGE_SIZE > 4096)
>  			/* At larger PAGE_SIZE, frame_sz depend on len size */
>  			xdp.frame_sz = igb_rx_frame_truesize(rx_ring, size);
> @@ -8733,10 +8735,11 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
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
> index 86a576201f5f..0cbdf48285d3 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ptp.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
> @@ -863,23 +863,22 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter)
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
> @@ -888,10 +887,9 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
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
> @@ -907,10 +905,8 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
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

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

