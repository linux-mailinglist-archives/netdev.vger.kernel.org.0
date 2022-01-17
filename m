Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46897490B0A
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 16:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240074AbiAQPCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 10:02:50 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:54250 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbiAQPCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 10:02:50 -0500
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2022 10:02:50 EST
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 5A6037F078; Mon, 17 Jan 2022 16:57:36 +0200 (EET)
Date:   Mon, 17 Jan 2022 16:57:36 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH 1/2 net-next v4] igc: avoid kernel warning when changing
 RX ring parameters
Message-ID: <YeWD4OG+eYr5B8Sd@wantstofly.org>
References: <20220114194520.1092894-1-vinschen@redhat.com>
 <20220114194520.1092894-2-vinschen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114194520.1092894-2-vinschen@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 08:45:19PM +0100, Corinna Vinschen wrote:

> Calling ethtool changing the RX ring parameters like this:
> 
>   $ ethtool -G eth0 rx 1024
> 
> on igc triggers kernel warnings like this:
> 
> [  225.198467] ------------[ cut here ]------------
> [  225.198473] Missing unregister, handled but fix driver
> [  225.198485] WARNING: CPU: 7 PID: 959 at net/core/xdp.c:168
> xdp_rxq_info_reg+0x79/0xd0
> [...]
> [  225.198601] Call Trace:
> [  225.198604]  <TASK>
> [  225.198609]  igc_setup_rx_resources+0x3f/0xe0 [igc]
> [  225.198617]  igc_ethtool_set_ringparam+0x30e/0x450 [igc]
> [  225.198626]  ethnl_set_rings+0x18a/0x250
> [  225.198631]  genl_family_rcv_msg_doit+0xca/0x110
> [  225.198637]  genl_rcv_msg+0xce/0x1c0
> [  225.198640]  ? rings_prepare_data+0x60/0x60
> [  225.198644]  ? genl_get_cmd+0xd0/0xd0
> [  225.198647]  netlink_rcv_skb+0x4e/0xf0
> [  225.198652]  genl_rcv+0x24/0x40
> [  225.198655]  netlink_unicast+0x20e/0x330
> [  225.198659]  netlink_sendmsg+0x23f/0x480
> [  225.198663]  sock_sendmsg+0x5b/0x60
> [  225.198667]  __sys_sendto+0xf0/0x160
> [  225.198671]  ? handle_mm_fault+0xb2/0x280
> [  225.198676]  ? do_user_addr_fault+0x1eb/0x690
> [  225.198680]  __x64_sys_sendto+0x20/0x30
> [  225.198683]  do_syscall_64+0x38/0x90
> [  225.198687]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  225.198693] RIP: 0033:0x7f7ae38ac3aa
> 
> igc_ethtool_set_ringparam() copies the igc_ring structure but neglects to
> reset the xdp_rxq_info member before calling igc_setup_rx_resources().
> This in turn calls xdp_rxq_info_reg() with an already registered xdp_rxq_info.
> 
> Make sure to unregister the xdp_rxq_info structure first in
> igc_setup_rx_resources.  Move xdp_rxq_info handling down to be the last
> action, thus allowing to remove the xdp_rxq_info_unreg call in the error path.
> 
> Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
> Reported-by: Lennert Buytenhek <buytenh@arista.com>
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 2f17f36e94fd..56ed0f1463e5 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -505,14 +505,6 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
>  	u8 index = rx_ring->queue_index;
>  	int size, desc_len, res;
>  
> -	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, ndev, index,
> -			       rx_ring->q_vector->napi.napi_id);
> -	if (res < 0) {
> -		netdev_err(ndev, "Failed to register xdp_rxq index %u\n",
> -			   index);
> -		return res;
> -	}
> -
>  	size = sizeof(struct igc_rx_buffer) * rx_ring->count;
>  	rx_ring->rx_buffer_info = vzalloc(size);
>  	if (!rx_ring->rx_buffer_info)
> @@ -534,10 +526,20 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
>  	rx_ring->next_to_clean = 0;
>  	rx_ring->next_to_use = 0;
>  
> +	/* XDP RX-queue info */
> +	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
> +		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
> +	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, ndev, index,
> +			       rx_ring->q_vector->napi.napi_id);
> +	if (res < 0) {
> +		netdev_err(ndev, "Failed to register xdp_rxq index %u\n",
> +			   index);
> +		goto err;
> +	}
> +
>  	return 0;
>  
>  err:
> -	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
>  	vfree(rx_ring->rx_buffer_info);
>  	rx_ring->rx_buffer_info = NULL;
>  	netdev_err(ndev, "Unable to allocate memory for Rx descriptor ring\n");

This patch fixes the warning...

Tested-by: Lennert Buytenhek <buytenh@arista.com>

...but doesn't it now forget to free rx_ring->desc if xdp_rxq_info_reg()
fails?

Thank you!
