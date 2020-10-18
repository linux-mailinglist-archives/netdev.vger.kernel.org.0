Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55BA2917A2
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 15:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgJRNhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 09:37:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:34911 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgJRNhq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 09:37:46 -0400
IronPort-SDR: Fxb/yj3uzyVxF4YXE8RlwQOQknt9zXcyeZ8sxRI7TZjBhr9rE+jHfDcPuM4HN2nGjoc/kILSCT
 jGTliyt0npHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9777"; a="153836425"
X-IronPort-AV: E=Sophos;i="5.77,391,1596524400"; 
   d="scan'208";a="153836425"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2020 06:37:43 -0700
IronPort-SDR: GzW+tQO0+IwkIuNWvc/fMMZ2P/vWDPzxdnDd666kL8+SUZR0oPDcCd8lf2L0QIllQnSHNjxJtk
 LaG3zYhL48Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,391,1596524400"; 
   d="scan'208";a="347123180"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2020 06:37:40 -0700
Date:   Sun, 18 Oct 2020 15:28:42 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     sven.auhagen@voleatech.de
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH v2 6/6] igb: avoid transmit queue timeout in xdp path
Message-ID: <20201018132842.GA34104@ranger.igk.intel.com>
References: <20201017071238.95190-1-sven.auhagen@voleatech.de>
 <20201017071238.95190-7-sven.auhagen@voleatech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201017071238.95190-7-sven.auhagen@voleatech.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 09:12:38AM +0200, sven.auhagen@voleatech.de wrote:
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> Since we share the transmit queue with the slow path,
> it is possible that we run into a transmit queue timeout.
> This will reset the queue.
> This happens under high load when the fast path is using the
> transmit queue pretty much exclusively.

I'm kinda not leaning towards slow/fast path distinction here, IMHO it
would be better to state that transmit queues are shared between network
stack and XDP, but that's just a rant.

> 
> By setting the transmit queues trans_start variable to jiffies
> in the two xdp xmit functions we avoid the timeout.

Probably a few more words of explanation would help here, specifically I
would say that netdev_start_xmit() sets trans_start to jiffies which is
later utilized by dev_watchdog(), so to avoid timeout, let stack know that
XDP xmit happened by bumping the trans_start within XDP Tx routines.

> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 55e708f75187..4a082c06f48d 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -2916,6 +2916,8 @@ static int igb_xdp_xmit_back(struct igb_adapter *adapter, struct xdp_buff *xdp)
>  
>  	nq = txring_txq(tx_ring);
>  	__netif_tx_lock(nq, cpu);
> +	/* Avoid transmit queue timeout since we share it with the slow path */
> +	nq->trans_start = jiffies;
>  	ret = igb_xmit_xdp_ring(adapter, tx_ring, xdpf);
>  	__netif_tx_unlock(nq);
>  
> @@ -2948,6 +2950,9 @@ static int igb_xdp_xmit(struct net_device *dev, int n,
>  	nq = txring_txq(tx_ring);
>  	__netif_tx_lock(nq, cpu);
>  
> +	/* Avoid transmit queue timeout since we share it with the slow path */
> +	nq->trans_start = jiffies;
> +
>  	for (i = 0; i < n; i++) {
>  		struct xdp_frame *xdpf = frames[i];
>  		int err;
> -- 
> 2.20.1
> 
