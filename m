Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0241B421698
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbhJDShX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:37:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:29471 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhJDShS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 14:37:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="248796750"
X-IronPort-AV: E=Sophos;i="5.85,346,1624345200"; 
   d="scan'208";a="248796750"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 09:40:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,346,1624345200"; 
   d="scan'208";a="713503076"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga005.fm.intel.com with ESMTP; 04 Oct 2021 09:40:06 -0700
Date:   Mon, 4 Oct 2021 20:40:53 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2] ixgbe: Consider xsk pool's frame size for
 MTU size
Message-ID: <YVtKtYoyZtez1DsD@boxer>
References: <20210930140651.2249972-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210930140651.2249972-1-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 04:06:51PM +0200, Sebastian Andrzej Siewior wrote:
> The driver has to a ensure that a network packet is not using more than
> one page for its data if a XDP program is used.
> This results in an upper limit of 1500 bytes. This can be increased a
> little if the MTU was programmed to 1514..3072 bytes before loading the
> XDP program. By setting this increased MTU size the driver will set the
> __IXGBE_RX_3K_BUFFER flag which in turn will allow to use 3KiB as the
> upper limit.
> This looks like a hack and the upper limit is could increased further.
> If the user configured a memory pool then PAGE_SIZE is used as BSIZEPKT
> and RLPML is set to pool's memory size as is the card's maximum frame
> size.

From what I can tell this is only true for hw->mac.type != ixgbe_mac_82599EB.

> The result is that a MTU of 3520 bytes can be programmed and every
> packet is stored a single page.

How did you come up with 3520 bytes? Is this what
xsk_pool_get_rx_frame_size returns on your system?

Or is it:
4k - XDP_HEADROOM (256) - sizeof skb_shared_info (320) = 3520?

I think I also need a bit more of a context in here what you are solving
here. Bare in mind that xsk_pool being present on Rx ring implies a
different memory model than the standard one where __IXGBE_RX_3K_BUFFER is
not valid.

It seems to me that you were using the copy mode for xsk socket, or is my
assumption wrong? If yes, then how did you end up with xsk_pool being
present on a ring?

>
> If a RX ring has a pool assigned use its size while comparing for the
> maximal MTU size.

Were you trying to change the MTU with xsk socket loaded on a queue?

> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v1…v2: Remove RFC. Repost of
> 	https://lore.kernel.org/r/20210622162616.eadk2u5hmf4ru5jd@linutronix.de
> 
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 21 +++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 24e06ba6f5e93..ed451f32e1980 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -6722,6 +6722,23 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
>  			ixgbe_free_rx_resources(adapter->rx_ring[i]);
>  }
>  
> +static int ixgbe_validate_frame_size(unsigned int frame_size,
> +				     struct ixgbe_ring *ring)
> +{
> +	struct xsk_buff_pool *xsk_pool;
> +	unsigned int buf_len;
> +
> +	xsk_pool = ring->xsk_pool;
> +	if (xsk_pool)
> +		buf_len = xsk_pool_get_rx_frame_size(xsk_pool);

I still don't get what is being solved in here, but shouldn't we repeat
the logic from ixgbe_configure_srrctl in here?

	if (xsk_pool) {
		if (hw->mac.type != ixgbe_mac_82599EB)
			buf_len = PAGE_SIZE;
		else
			buf_len = xsk_pool_get_rx_frame_size(xsk_pool);
	} else {
		buf_len = ixgbe_rx_bufsz(ring);
	}

> +	else
> +		buf_len = ixgbe_rx_bufsz(ring);
> +
> +	if (frame_size > buf_len)
> +		return -EINVAL;
> +	return 0;
> +}
> +
>  /**
>   * ixgbe_change_mtu - Change the Maximum Transfer Unit
>   * @netdev: network interface device structure
> @@ -6741,7 +6758,7 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
>  		for (i = 0; i < adapter->num_rx_queues; i++) {
>  			struct ixgbe_ring *ring = adapter->rx_ring[i];
>  
> -			if (new_frame_size > ixgbe_rx_bufsz(ring)) {
> +			if (ixgbe_validate_frame_size(new_frame_size, ring)) {
>  				e_warn(probe, "Requested MTU size is not supported with XDP\n");
>  				return -EINVAL;
>  			}
> @@ -10126,7 +10143,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>  		if (ring_is_rsc_enabled(ring))
>  			return -EINVAL;
>  
> -		if (frame_size > ixgbe_rx_bufsz(ring))
> +		if (ixgbe_validate_frame_size(frame_size, ring))
>  			return -EINVAL;
>  	}
>  
> -- 
> 2.33.0
> 
