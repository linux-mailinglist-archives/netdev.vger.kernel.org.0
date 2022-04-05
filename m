Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471334F3FA8
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385000AbiDEUFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442634AbiDEPiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:38:03 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE52C178680;
        Tue,  5 Apr 2022 06:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649166759; x=1680702759;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I2lgRPonevESO58QwyznLbLPnONfG/J3aXgrCvzjQ0k=;
  b=EzJvSB7X6Wf3YE7cCt42ZbTiVNg7XjeUek3Vmhj71DcqfI1a/bGAsa/9
   cHwKQdzsCqKpydrnKu+JeR6UrjDTNVtSDq9v8E1mFobNz/6ENOjd0HKwh
   FgUtqi2l9oozrmNWSP484pWyVwVUQpWFRbmn3XXFwMlk3IaiEb+fmR+JF
   GeZNdxJoclBU2p40lPysGFk1U2NKgXivb4QojUeZRvEHtv4e38LjMUHt/
   6jx/dRIlX+hVCkE4LegR+CTJ8rXuMkpbWIWt9ujtdUP4k+gEgyRbshy5q
   L2A8Xv4giJEGqAf+/NUmCxik4HT4ObWpbZQx2JTPVFLruaPHD4JCPVqNz
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="259583179"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="259583179"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 06:52:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="789862273"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 05 Apr 2022 06:52:37 -0700
Date:   Tue, 5 Apr 2022 15:52:36 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org, brouer@redhat.com,
        netdev@vger.kernel.org, maximmi@nvidia.com,
        alexandr.lobakin@intel.com
Subject: Re: [PATCH bpf-next 05/10] ixgbe: xsk: terminate NAPI when XSK Rx
 queue gets full
Message-ID: <YkxJpLPMkUrl1hoZ@boxer>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
 <20220405110631.404427-6-maciej.fijalkowski@intel.com>
 <88cf07a2-3bb6-5eda-0d99-d9491fd18669@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88cf07a2-3bb6-5eda-0d99-d9491fd18669@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 02:36:41PM +0200, Jesper Dangaard Brouer wrote:
> 
> On 05/04/2022 13.06, Maciej Fijalkowski wrote:
> > Correlate -ENOBUFS that was returned from xdp_do_redirect() with a XSK
> > Rx queue being full. In such case, terminate the softirq processing and
> > let the user space to consume descriptors from XSK Rx queue so that
> > there is room that driver can use later on.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >   .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  1 +
> >   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 23 ++++++++++++-------
> >   2 files changed, 16 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> > index bba3feaf3318..f1f69ce67420 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> > @@ -8,6 +8,7 @@
> >   #define IXGBE_XDP_CONSUMED	BIT(0)
> >   #define IXGBE_XDP_TX		BIT(1)
> >   #define IXGBE_XDP_REDIR		BIT(2)
> > +#define IXGBE_XDP_EXIT		BIT(3)
> >   #define IXGBE_TXD_CMD (IXGBE_TXD_CMD_EOP | \
> >   		       IXGBE_TXD_CMD_RS)
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> > index dd7ff66d422f..475244a2c6e4 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> > @@ -109,9 +109,10 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
> >   	if (likely(act == XDP_REDIRECT)) {
> >   		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
> > -		if (err)
> > -			goto out_failure;
> > -		return IXGBE_XDP_REDIR;
> > +		if (!err)
> > +			return IXGBE_XDP_REDIR;
> > +		result = (err == -ENOBUFS) ? IXGBE_XDP_EXIT : IXGBE_XDP_CONSUMED;
> > +		goto out_failure;
> >   	}
> >   	switch (act) {
> > @@ -130,6 +131,9 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
> >   		if (result == IXGBE_XDP_CONSUMED)
> >   			goto out_failure;
> >   		break;
> > +	case XDP_DROP:
> > +		result = IXGBE_XDP_CONSUMED;
> > +		break;
> >   	default:
> >   		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
> >   		fallthrough;
> > @@ -137,9 +141,6 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
> >   out_failure:
> >   		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
> >   		fallthrough; /* handle aborts by dropping packet */
> > -	case XDP_DROP:
> > -		result = IXGBE_XDP_CONSUMED;
> > -		break;
> >   	}
> >   	return result;
> >   }
> > @@ -304,10 +305,16 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
> >   		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp);
> >   		if (xdp_res) {
> > -			if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR))
> > +			if (xdp_res == IXGBE_XDP_EXIT) {
> 
> Micro optimization note: Having this as the first if()-statement
> defaults the compiler to think this is the likely() case. (But compilers
> can obviously be smarter and can easily choose that the IXGBE_XDP_REDIR
> branch is so simple that it takes it as the likely case).
> Just wanted to mention this, given this is fash-path code.

Good point. Since we're 'likely-fying' redirect path in
ixgbe_run_xdp_zc(), maybe it would make sense to make the branch that does
xdp_res & IXGBE_XDP_REDIR check as the likely() one.

> 
> > +				failure = true;
> > +				xsk_buff_free(bi->xdp);
> > +				ixgbe_inc_ntc(rx_ring);
> > +				break;
> 
> I was wondering if we have a situation where we should set xdp_xmit bit
> to trigger the call to xdp_do_flush_map later in function, but I assume
> you have this covered.

For every previous successful redirect xdp_xmit will be set with
corresponding bits that came out of ixgbe_run_xdp_zc(), so if we got to
the point of full XSK Rx queue, xdp_do_flush_map() will be called
eventually. Before doing so, idea is to give the current buffer back to
the XSK buffer pool and increment the "next_to_clean" which acts as the
head pointer on HW Rx ring. IOW, consume the current buffer/descriptor and
yield the CPU to the user space.

> 
> > +			} else if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR)) {
> >   				xdp_xmit |= xdp_res;
> > -			else
> > +			} else {
> >   				xsk_buff_free(bi->xdp);
> > +			}
> >   			bi->xdp = NULL;
> >   			total_rx_packets++;
> 
