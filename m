Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B56F27B5C3
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgI1TzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgI1TzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:55:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CD8C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 12:55:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC4A11452F953;
        Mon, 28 Sep 2020 12:38:21 -0700 (PDT)
Date:   Mon, 28 Sep 2020 12:55:08 -0700 (PDT)
Message-Id: <20200928.125508.458441817113961397.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     sven.auhagen@voleatech.de, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com
Subject: Re: [net-next 01/15] igb: add XDP support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928175908.318502-2-anthony.l.nguyen@intel.com>
References: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
        <20200928175908.318502-2-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 12:38:22 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Mon, 28 Sep 2020 10:58:54 -0700

> From: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> Add XDP support to the IGB driver.
> The implementation follows the IXGBE XDP implementation
> closely and I used the following patches as basis:
> 
> 1. commit 924708081629 ("ixgbe: add XDP support for pass and drop actions")
> 2. commit 33fdc82f0883 ("ixgbe: add support for XDP_TX action")
> 3. commit ed93a3987128 ("ixgbe: tweak page counting for XDP_REDIRECT")
> 
> Due to the hardware constraints of the devices using the
> IGB driver we must share the TX queues with XDP which
> means locking the TX queue for XDP.
> 
> I ran tests on an older device to get better numbers.
> Test machine:
> 
> Intel(R) Atom(TM) CPU C2338 @ 1.74GHz (2 Cores)
> 2x Intel I211
> 
> Routing Original Driver Network Stack: 382 Kpps
> 
> Routing XDP Redirect (xdp_fwd_kern): 1.48 Mpps
> XDP Drop: 1.48 Mpps
> 
> Using XDP we can achieve line rate forwarding even on
> an older Intel Atom CPU.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/igb/igb.h         |  80 +++-
>  drivers/net/ethernet/intel/igb/igb_ethtool.c |   4 +
>  drivers/net/ethernet/intel/igb/igb_main.c    | 433 +++++++++++++++++--
>  3 files changed, 481 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
> index 2f015b60a995..0286d2fceee4 100644
> --- a/drivers/net/ethernet/intel/igb/igb.h
> +++ b/drivers/net/ethernet/intel/igb/igb.h
> @@ -19,6 +19,8 @@
>  #include <linux/pci.h>
>  #include <linux/mdio.h>
>  
> +#include <net/xdp.h>
> +
>  struct igb_adapter;
>  
>  #define E1000_PCS_CFG_IGN_SD	1
> @@ -79,6 +81,12 @@ struct igb_adapter;
>  #define IGB_I210_RX_LATENCY_100		2213
>  #define IGB_I210_RX_LATENCY_1000	448
>  
> +/* XDP */
> +#define IGB_XDP_PASS		0
> +#define IGB_XDP_CONSUMED	BIT(0)
> +#define IGB_XDP_TX		BIT(1)
> +#define IGB_XDP_REDIR		BIT(2)
> +
>  struct vf_data_storage {
>  	unsigned char vf_mac_addresses[ETH_ALEN];
>  	u16 vf_mc_hashes[IGB_MAX_VF_MC_ENTRIES];
> @@ -132,17 +140,62 @@ struct vf_mac_filter {
>  
>  /* Supported Rx Buffer Sizes */
>  #define IGB_RXBUFFER_256	256
> +#define IGB_RXBUFFER_1536	1536
>  #define IGB_RXBUFFER_2048	2048
>  #define IGB_RXBUFFER_3072	3072
>  #define IGB_RX_HDR_LEN		IGB_RXBUFFER_256
>  #define IGB_TS_HDR_LEN		16
>  
> -#define IGB_SKB_PAD		(NET_SKB_PAD + NET_IP_ALIGN)
> +/* Attempt to maximize the headroom available for incoming frames.  We
> + * use a 2K buffer for receives and need 1536/1534 to store the data for
> + * the frame.  This leaves us with 512 bytes of room.  From that we need
> + * to deduct the space needed for the shared info and the padding needed
> + * to IP align the frame.
> + *
> + * Note: For cache line sizes 256 or larger this value is going to end
> + *	 up negative.  In these cases we should fall back to the 3K
> + *	 buffers.
> + */
>  #if (PAGE_SIZE < 8192)
> -#define IGB_MAX_FRAME_BUILD_SKB \
> -	(SKB_WITH_OVERHEAD(IGB_RXBUFFER_2048) - IGB_SKB_PAD - IGB_TS_HDR_LEN)
> +#define IGB_MAX_FRAME_BUILD_SKB (IGB_RXBUFFER_1536 - NET_IP_ALIGN)
> +#define IGB_2K_TOO_SMALL_WITH_PADDING \
> +((NET_SKB_PAD + IGB_TS_HDR_LEN + IGB_RXBUFFER_1536) > SKB_WITH_OVERHEAD(IGB_RXBUFFER_2048))
> +
> +static inline int igb_compute_pad(int rx_buf_len)
> +{
> +	int page_size, pad_size;
> +
> +	page_size = ALIGN(rx_buf_len, PAGE_SIZE / 2);
> +	pad_size = SKB_WITH_OVERHEAD(page_size) - rx_buf_len;
> +
> +	return pad_size;
> +}
> +
> +static inline int igb_skb_pad(void)
> +{
> +	int rx_buf_len;
> +
> +	/* If a 2K buffer cannot handle a standard Ethernet frame then
> +	 * optimize padding for a 3K buffer instead of a 1.5K buffer.
> +	 *
> +	 * For a 3K buffer we need to add enough padding to allow for
> +	 * tailroom due to NET_IP_ALIGN possibly shifting us out of
> +	 * cache-line alignment.
> +	 */
> +	if (IGB_2K_TOO_SMALL_WITH_PADDING)
> +		rx_buf_len = IGB_RXBUFFER_3072 + SKB_DATA_ALIGN(NET_IP_ALIGN);
> +	else
> +		rx_buf_len = IGB_RXBUFFER_1536;
> +
> +	/* if needed make room for NET_IP_ALIGN */
> +	rx_buf_len -= NET_IP_ALIGN;
> +
> +	return igb_compute_pad(rx_buf_len);
> +}
> +
> +#define IGB_SKB_PAD	igb_skb_pad()
>  #else
> -#define IGB_MAX_FRAME_BUILD_SKB (IGB_RXBUFFER_2048 - IGB_TS_HDR_LEN)
> +#define IGB_SKB_PAD	(NET_SKB_PAD + NET_IP_ALIGN)
>  #endif
>  
>  /* How many Rx Buffers do we bundle into one write to the hardware ? */
> @@ -194,13 +247,22 @@ enum igb_tx_flags {
>  #define IGB_SFF_ADDRESSING_MODE		0x4
>  #define IGB_SFF_8472_UNSUP		0x00
>  
> +enum igb_tx_buf_type {
> +	IGB_TYPE_SKB = 0,
> +	IGB_TYPE_XDP,
> +};
> +
>  /* wrapper around a pointer to a socket buffer,
>   * so a DMA handle can be stored along with the buffer
>   */
>  struct igb_tx_buffer {
>  	union e1000_adv_tx_desc *next_to_watch;
>  	unsigned long time_stamp;
> -	struct sk_buff *skb;
> +	enum igb_tx_buf_type type;
> +	union {
> +		struct sk_buff *skb;
> +		struct xdp_frame *xdpf;
> +	};
>  	unsigned int bytecount;
>  	u16 gso_segs;
>  	__be16 protocol;
> @@ -248,6 +310,7 @@ struct igb_ring_container {
>  struct igb_ring {
>  	struct igb_q_vector *q_vector;	/* backlink to q_vector */
>  	struct net_device *netdev;	/* back pointer to net_device */
> +	struct bpf_prog *xdp_prog;
>  	struct device *dev;		/* device pointer for dma mapping */
>  	union {				/* array of buffer info structs */
>  		struct igb_tx_buffer *tx_buffer_info;
> @@ -288,6 +351,7 @@ struct igb_ring {
>  			struct u64_stats_sync rx_syncp;
>  		};
>  	};
> +	struct xdp_rxq_info xdp_rxq;
>  } ____cacheline_internodealigned_in_smp;
>  
>  struct igb_q_vector {
> @@ -339,7 +403,7 @@ static inline unsigned int igb_rx_bufsz(struct igb_ring *ring)
>  		return IGB_RXBUFFER_3072;
>  
>  	if (ring_uses_build_skb(ring))
> -		return IGB_MAX_FRAME_BUILD_SKB + IGB_TS_HDR_LEN;
> +		return IGB_MAX_FRAME_BUILD_SKB;
>  #endif
>  	return IGB_RXBUFFER_2048;
>  }
> @@ -467,6 +531,7 @@ struct igb_adapter {
>  	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
>  
>  	struct net_device *netdev;
> +	struct bpf_prog *xdp_prog;
>  
>  	unsigned long state;
>  	unsigned int flags;
> @@ -643,6 +708,9 @@ enum igb_boards {
>  
>  extern char igb_driver_name[];
>  
> +int igb_xmit_xdp_ring(struct igb_adapter *adapter,
> +		      struct igb_ring *ring,
> +		      struct xdp_frame *xdpf);
>  int igb_open(struct net_device *netdev);
>  int igb_close(struct net_device *netdev);
>  int igb_up(struct igb_adapter *);
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index 6e8231c1ddf0..28baf203459a 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -961,6 +961,10 @@ static int igb_set_ringparam(struct net_device *netdev,
>  			memcpy(&temp_ring[i], adapter->rx_ring[i],
>  			       sizeof(struct igb_ring));
>  
> +			/* Clear copied XDP RX-queue info */
> +			memset(&temp_ring[i].xdp_rxq, 0,
> +			       sizeof(temp_ring[i].xdp_rxq));
> +
>  			temp_ring[i].count = new_rx_count;
>  			err = igb_setup_rx_resources(&temp_ring[i]);
>  			if (err) {
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 44157fcd3cf7..73125d11460f 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
 ...
> +static inline struct igb_ring *igb_xdp_tx_queue_mapping(struct igb_adapter *adapter)
> +{

Please do not use inline in foo.c files, let the compiler decide.

> @@ -8282,6 +8610,11 @@ static void igb_process_skb_fields(struct igb_ring *rx_ring,
>  	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
>  }
>  
> +static inline unsigned int igb_rx_offset(struct igb_ring *rx_ring)

Likewise.

I know this function is just being moved, but nevertheless the inline tag should
be removed.

Thanks.
