Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA11286A66
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgJGVn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:43:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:41772 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbgJGVn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 17:43:28 -0400
IronPort-SDR: VL8goQBCXiXKu9rmcwjwflq9YmZunEnsacWFYiC/na7B3Ymm5a/TdM+hZEjeCLEcITSJFuVO2c
 E7TvlzfaP0ow==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="152961188"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="152961188"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 14:43:27 -0700
IronPort-SDR: rzAFdb7eJgVBxgOL4FDBl6elDihkHP4lg/Kb+uFwugVAdIWgxZuxPhb8P5GiVTzCmNWHF5Pnyh
 qiBKQNesWi6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="461527289"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 07 Oct 2020 14:43:24 -0700
Date:   Wed, 7 Oct 2020 23:35:49 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     sven.auhagen@voleatech.de
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH 7/7] igb: avoid transmit queue timeout in xdp path
Message-ID: <20201007213549.GF48010@ranger.igk.intel.com>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
 <20201007152506.66217-8-sven.auhagen@voleatech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007152506.66217-8-sven.auhagen@voleatech.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 05:25:06PM +0200, sven.auhagen@voleatech.de wrote:
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> Since we share the transmit queue with the slow path,
> it is possible that we run into a transmit queue timeout.
> This will reset the queue.
> This happens under high load when the fast path is using the
> transmit queue pretty much exclusively.

Please mention in the commit message *how* you are fixing this issue.

> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 6a2828b96eef..d84a99359e95 100644
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
