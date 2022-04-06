Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB904F680E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbiDFRzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239665AbiDFRza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:55:30 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E72747D902;
        Wed,  6 Apr 2022 09:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649261101; x=1680797101;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LCEP7z9iVmnS+5YAekuvbdZXgDguf3alCnSjdIOWx8s=;
  b=WBKxCHmeIAWijuDTdtcq3IqrMUyvYrM2RVVgzPTiIc2WgKfJ6yysGy3Z
   8rd/efJA7XS0KtRepAtjjKPxdUqbzL0TRjxz/sPqMab+Hlw5wivXtyiAO
   8UgI+ebsFJLsJ6TOgBhbSSwkvR5VjqwycSNQYr7mvLjZh0eagVVZNp971
   e8LsxPReHC03nXQfQjrWCrO4NQhsc/Brsm/SGzWasY+ly+QGlzUvTFu1g
   O6pIKYomFTEL4lz51bx5qe/MmBQI+loX5yw+vzly10CS69F1abI4tY+7h
   mq1Z+9g+T6SUmB9Wy2GtgqzblWFntZNaLPR796vSFmVNkuGegur8QdwHz
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="241676579"
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="241676579"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 09:05:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="608953323"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 06 Apr 2022 09:04:58 -0700
Date:   Wed, 6 Apr 2022 18:04:58 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org, brouer@redhat.com,
        netdev@vger.kernel.org, maximmi@nvidia.com,
        alexandr.lobakin@intel.com,
        Toke Hoiland Jorgensen <toke@redhat.com>
Subject: Re: [PATCH bpf-next 04/10] i40e: xsk: terminate NAPI when XSK Rx
 queue gets full
Message-ID: <Yk26KjeTNI08dLII@boxer>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
 <20220405110631.404427-5-maciej.fijalkowski@intel.com>
 <8bb40f98-2f1f-c331-23d4-ed94a6a1ce76@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bb40f98-2f1f-c331-23d4-ed94a6a1ce76@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 03:04:17PM +0200, Jesper Dangaard Brouer wrote:
> 
> 
> On 05/04/2022 13.06, Maciej Fijalkowski wrote:
> > Correlate -ENOBUFS that was returned from xdp_do_redirect() with a XSK
> > Rx queue being full. In such case, terminate the softirq processing and
> > let the user space to consume descriptors from XSK Rx queue so that
> > there is room that driver can use later on.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >   .../ethernet/intel/i40e/i40e_txrx_common.h    |  1 +
> >   drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 21 ++++++++++++-------
> >   2 files changed, 15 insertions(+), 7 deletions(-)
> > 
> [...]
> 
> I noticed you are only doing this for the Zero-Copy variants.
> Wouldn't this also be a benefit for normal AF_XDP ?

Sorry for the delay, indeed this would improve AF_XDP in copy mode as
well, but only after a fix I have sent (not on lore yet :<).

I'll adjust patches to check for -ENOBUFS in $DRIVER_txrx.c and send a v2.

> 
> 
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > index c1d25b0b0ca2..9f9e4ce9a24d 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > @@ -161,9 +161,10 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
> >   	if (likely(act == XDP_REDIRECT)) {
> >   		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
> > -		if (err)
> > -			goto out_failure;
> > -		return I40E_XDP_REDIR;
> > +		if (!err)
> > +			return I40E_XDP_REDIR;
> > +		result = (err == -ENOBUFS) ? I40E_XDP_EXIT : I40E_XDP_CONSUMED;
> > +		goto out_failure;
> >   	}
> >   	switch (act) {
> > @@ -175,6 +176,9 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
> >   		if (result == I40E_XDP_CONSUMED)
> >   			goto out_failure;
> >   		break;
> > +	case XDP_DROP:
> > +		result = I40E_XDP_CONSUMED;
> > +		break;
> >   	default:
> >   		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
> >   		fallthrough;
> > @@ -182,9 +186,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
> >   out_failure:
> >   		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
> >   		fallthrough; /* handle aborts by dropping packet */
> > -	case XDP_DROP:
> > -		result = I40E_XDP_CONSUMED;
> > -		break;
> >   	}
> >   	return result;
> >   }
> > @@ -370,6 +371,12 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
> >   		xsk_buff_dma_sync_for_cpu(bi, rx_ring->xsk_pool);
> >   		xdp_res = i40e_run_xdp_zc(rx_ring, bi);
> > +		if (xdp_res == I40E_XDP_EXIT) {
> > +			failure = true;
> > +			xsk_buff_free(bi);
> > +			next_to_clean = (next_to_clean + 1) & count_mask;
> > +			break;
> > +		}
> >   		i40e_handle_xdp_result_zc(rx_ring, bi, rx_desc, &rx_packets,
> >   					  &rx_bytes, size, xdp_res);
> >   		total_rx_packets += rx_packets;
> > @@ -382,7 +389,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
> >   	cleaned_count = (next_to_clean - rx_ring->next_to_use - 1) & count_mask;
> >   	if (cleaned_count >= I40E_RX_BUFFER_WRITE)
> > -		failure = !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
> > +		failure |= !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
> >   	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
> >   	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
> > 
> 
