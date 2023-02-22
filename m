Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B8A69F14A
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjBVJXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjBVJXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:23:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2B51BD9;
        Wed, 22 Feb 2023 01:22:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B14F3612B2;
        Wed, 22 Feb 2023 09:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52397C433D2;
        Wed, 22 Feb 2023 09:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677057772;
        bh=wVxpLcIjNUjf+mQzijoZyvptQZvmjN9A9iLI5F4lerU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DgfRf0zEaRL3mjMNDqswP4kHT4vai7LohB8AE5uxDW6zQLY6uekrG/Eak4gCCdOMi
         vIdurb2jjhmbnlaZ8JV2ZvT49JAhpUI8L4a0/TzkkajHMd+Kfyv4lmVlLOamku/dzs
         qO4wGMou1GK1XLRa3+rre6pEzoBfbBM0Xq5W6OJOXrjHOPF1VobAUS2u0TReb162m5
         ce5K8HvJVvQxq9spq0gXjg/XCfUMoxpO1MyYHx/JnPVzlBprmj9VzwVxHDDkY1KVbB
         Ak/V2OzF9puIUCWGBRVLcswjs13pFWrTKmakh0j9nQEukBFCDe/jlsAx9HF0dT5AX1
         GPukBxjQtRKYg==
Date:   Wed, 22 Feb 2023 11:22:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: Re: [PATCH net 1/1] ice: Fix missing cleanup routine in the case of
 partial memory allocation
Message-ID: <Y/Xe53wd27MaQe6G@unreal>
References: <20230221191750.1196493-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221191750.1196493-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 11:17:50AM -0800, Tony Nguyen wrote:
> From: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
> 
> Add missing memory free in the case of partial memory allocation
> in the loop in ice_realloc_zc_buf function.

I don't think that this is correct behaviour for realloc function to
free memory of caller just because target allocation failed.

It should be done in upper level.

Thanks

> 
> Fixes: 7e753eb675f0 ("ice: Fix DMA mappings leak")
> Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 374b7f10b549..9ec02f80a2cf 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -377,8 +377,16 @@ int ice_realloc_zc_buf(struct ice_vsi *vsi, bool zc)
>  	for_each_set_bit(q, vsi->af_xdp_zc_qps,
>  			 max_t(int, vsi->alloc_txq, vsi->alloc_rxq)) {
>  		rx_ring = vsi->rx_rings[q];
> -		if (ice_realloc_rx_xdp_bufs(rx_ring, zc))
> +		if (ice_realloc_rx_xdp_bufs(rx_ring, zc)) {
> +			unsigned long qid = q;
> +
> +			for_each_set_bit(q, vsi->af_xdp_zc_qps, qid) {
> +				rx_ring = vsi->rx_rings[q];
> +				zc ? kfree(rx_ring->xdp_buf) :
> +				     kfree(rx_ring->rx_buf);
> +			}
>  			return -ENOMEM;
> +		}
>  	}
>  
>  	return 0;
> -- 
> 2.38.1
> 
