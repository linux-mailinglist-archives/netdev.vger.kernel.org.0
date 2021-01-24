Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD9730196E
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 04:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbhAXDxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 22:53:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbhAXDxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 22:53:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE93A22583;
        Sun, 24 Jan 2021 03:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611460341;
        bh=CFPVWeiqdh/2zsxXCSTdUYmI+w4EHc4IOyr7lct/x4o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OXbjv/wbhcJQa4pv474eI9mYQ23rjmEjj3VwzEXRYCqSaDTdtbEJFI7wEHMLu/zSa
         0yLVjINIaZlc0PIjqI1x5gIgJpxW3xU0IVdwvm6D0dVWbJOuuz7VPd7mWiyUFjstdX
         zzEkCZmLCXZbMMmGLimTxPiTv/wVY6W4H/ire2UNV+OKX1N/YF6HB3ru0crKVEFNJC
         WEgPUFlFraqBPE3Q76vqpNve5DJdhCVMKRwJ8+X2J3hxlDAtEIMxwPu6CwL23AucE8
         OIwG1OyFYV2gIPkhwzd5M8GcTn0oQ7fd2QQEEfyhIwxVQS2I7WuJs0+t/yhUzw18VV
         180Qtn59M2cWA==
Date:   Sat, 23 Jan 2021 19:52:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Piotr Raczynski <piotr.raczynski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Subject: Re: [PATCH net 4/7] ice: use correct xdp_ring with XDP_TX action
Message-ID: <20210123195219.55f6d4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210122235734.447240-5-anthony.l.nguyen@intel.com>
References: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
        <20210122235734.447240-5-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 15:57:31 -0800 Tony Nguyen wrote:
> From: Piotr Raczynski <piotr.raczynski@intel.com>
> 
> XDP queue number for XDP_TX action is used inconsistently
> and may result with no packets transmitted. Fix queue number
> used by the driver when doing XDP_TX, i.e. use receive queue
> number as in ice_finalize_xdp_rx.
> 
> Also, using smp_processor_id() is wrong here and won't
> work with less queues.
> 
> Fixes: efc2214b6047 ("ice: Add support for XDP")
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index b6fa83c619dd..7946a90b2da7 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -546,7 +546,7 @@ ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
>  	case XDP_PASS:
>  		break;
>  	case XDP_TX:
> -		xdp_ring = rx_ring->vsi->xdp_rings[smp_processor_id()];
> +		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->q_index];

But then what protects you from one CPU trying to use the tx ring from
XDP_TX and another from ice_xdp_xmit() ?

Also why does this code not check queue_index < vsi->num_xdp_txq
like ice_xdp_xmit() does?

Let me CC your local XDP experts whose tags I'm surprised not to see on
this patch.

>  		result = ice_xmit_xdp_buff(xdp, xdp_ring);
>  		break;
>  	case XDP_REDIRECT:

