Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EF325DDDB
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgIDPgA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 4 Sep 2020 11:36:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57784 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726063AbgIDPf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 11:35:57 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-kGKBJwK8OvGiLSRrqb5OtA-1; Fri, 04 Sep 2020 11:35:52 -0400
X-MC-Unique: kGKBJwK8OvGiLSRrqb5OtA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FC341007474;
        Fri,  4 Sep 2020 15:35:50 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF38465C74;
        Fri,  4 Sep 2020 15:35:42 +0000 (UTC)
Date:   Fri, 4 Sep 2020 17:35:40 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@intel.com>, magnus.karlsson@intel.com,
        davem@davemloft.net, kuba@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next 6/6] ixgbe, xsk: finish napi loop if AF_XDP Rx
 queue is full
Message-ID: <20200904173540.3a617eee@carbon>
In-Reply-To: <20200904135332.60259-7-bjorn.topel@gmail.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
        <20200904135332.60259-7-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Sep 2020 15:53:31 +0200
Björn Töpel <bjorn.topel@gmail.com> wrote:

> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Make the AF_XDP zero-copy path aware that the reason for redirect
> failure was due to full Rx queue. If so, exit the napi loop as soon as
> possible (exit the softirq processing), so that the userspace AF_XDP
> process can hopefully empty the Rx queue. This mainly helps the "one
> core scenario", where the userland process and Rx softirq processing
> is on the same core.
> 
> Note that the early exit can only be performed if the "need wakeup"
> feature is enabled, because otherwise there is no notification
> mechanism available from the kernel side.
> 
> This requires that the driver starts using the newly introduced
> xdp_do_redirect_ext() and xsk_do_redirect_rx_full() functions.
> 
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 23 ++++++++++++++------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> index 3771857cf887..a4aebfd986b3 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -93,9 +93,11 @@ int ixgbe_xsk_pool_setup(struct ixgbe_adapter *adapter,
>  
>  static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
>  			    struct ixgbe_ring *rx_ring,
> -			    struct xdp_buff *xdp)
> +			    struct xdp_buff *xdp,
> +			    bool *early_exit)
>  {
>  	int err, result = IXGBE_XDP_PASS;
> +	enum bpf_map_type map_type;
>  	struct bpf_prog *xdp_prog;
>  	struct xdp_frame *xdpf;
>  	u32 act;
> @@ -116,8 +118,13 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
>  		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
>  		break;
>  	case XDP_REDIRECT:
> -		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
> -		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
> +		err = xdp_do_redirect_ext(rx_ring->netdev, xdp, xdp_prog, &map_type);
> +		if (err) {
> +			*early_exit = xsk_do_redirect_rx_full(err, map_type);

Have you tried calling xdp_do_flush (that calls __xsk_map_flush()) and
(I guess) xsk_set_rx_need_wakeup() here, instead of stopping the loop?
(Or doing this in xsk core).

Looking at the code, the AF_XDP frames are "published" in the queue
rather late for AF_XDP.  Maybe in an orthogonal optimization, have you
considered "publishing" the ring producer when e.g. the queue is
half-full?


> +			result = IXGBE_XDP_CONSUMED;
> +		} else {
> +			result = IXGBE_XDP_REDIR;
> +		}
>  		break;
>  	default:
>  		bpf_warn_invalid_xdp_action(act);
> @@ -235,8 +242,8 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>  	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
>  	struct ixgbe_adapter *adapter = q_vector->adapter;
>  	u16 cleaned_count = ixgbe_desc_unused(rx_ring);
> +	bool early_exit = false, failure = false;
>  	unsigned int xdp_res, xdp_xmit = 0;
> -	bool failure = false;
>  	struct sk_buff *skb;
>  
>  	while (likely(total_rx_packets < budget)) {
> @@ -288,7 +295,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>  
>  		bi->xdp->data_end = bi->xdp->data + size;
>  		xsk_buff_dma_sync_for_cpu(bi->xdp, rx_ring->xsk_pool);
> -		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp);
> +		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp, &early_exit);
>  
>  		if (xdp_res) {
>  			if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR))
> @@ -302,6 +309,8 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>  
>  			cleaned_count++;
>  			ixgbe_inc_ntc(rx_ring);
> +			if (early_exit)
> +				break;
>  			continue;
>  		}
>  
> @@ -346,12 +355,12 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>  	q_vector->rx.total_bytes += total_rx_bytes;
>  
>  	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
> -		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
> +		if (early_exit || failure || rx_ring->next_to_clean == rx_ring->next_to_use)
>  			xsk_set_rx_need_wakeup(rx_ring->xsk_pool);
>  		else
>  			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool);
>  
> -		return (int)total_rx_packets;
> +		return early_exit ? 0 : (int)total_rx_packets;
>  	}
>  	return failure ? budget : (int)total_rx_packets;
>  }



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

