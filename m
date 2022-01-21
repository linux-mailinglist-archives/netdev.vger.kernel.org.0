Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7B5496142
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 15:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351166AbiAUOl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 09:41:27 -0500
Received: from mga14.intel.com ([192.55.52.115]:10239 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351139AbiAUOl1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 09:41:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642776087; x=1674312087;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YUQVBFeFaossAesZIkZ7nbvZCWx8e37HgyVSheypMgw=;
  b=PsvIK8gzYxpiEgatubdwaufB0+VnBdpbJa65GVKeeNRcswvto8+vlq7u
   nXo73iCt4Sa/UiW9HnZjaieBapdeAen76Q1alVzE0JzqtuJtlGfJxT+9b
   j6jAi93R2xfMkY7hvHedG6BF1HhS4PYu/M6e/yKTHAA+YrintLeS8aNQr
   NmyKwjB0KqPA8r4ZlmaFFO75IuL5EttNdDDDya+Uexujd9QN1v7MA2LHe
   TBuCEMjVwwPw8t/4uYJv4wygjiORFgStXeaOoJrXxBeMtj5flvgaETJ7O
   eDZ5aqrQFjQzG+er58sbGspOAN+NpK4m/kT22Pf9HXcR3zi/mnRBIl/sO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="245884177"
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="245884177"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 06:41:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="579622273"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jan 2022 06:41:25 -0800
Date:   Fri, 21 Jan 2022 15:41:24 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next v3 6/7] ice: xsk: improve AF_XDP ZC Tx and use
 batching API
Message-ID: <YerGFNmhH0DTH5G9@boxer>
References: <20220121120011.49316-1-maciej.fijalkowski@intel.com>
 <20220121120011.49316-7-maciej.fijalkowski@intel.com>
 <20220121125447.24039-1-alexandr.lobakin@intel.com>
 <20220121131742.24424-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121131742.24424-1-alexandr.lobakin@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 02:17:42PM +0100, Alexander Lobakin wrote:
> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> Date: Fri, 21 Jan 2022 13:54:47 +0100
> 
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Date: Fri, 21 Jan 2022 13:00:10 +0100
> > 
> > > Apply the logic that was done for regular XDP from commit 9610bd988df9
> > > ("ice: optimize XDP_TX workloads") to the ZC side of the driver. On top
> > > of that, introduce batching to Tx that is inspired by i40e's
> > > implementation with adjustments to the cleaning logic - take into the
> > > account NAPI budget in ice_clean_xdp_irq_zc().
> > > 
> > > Separating the stats structs onto separate cache lines seemed to improve
> > > the performance.
> > > 
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
> > >  drivers/net/ethernet/intel/ice/ice_txrx.h |   2 +-
> > >  drivers/net/ethernet/intel/ice/ice_xsk.c  | 256 ++++++++++++++--------
> > >  drivers/net/ethernet/intel/ice/ice_xsk.h  |  27 ++-
> > >  4 files changed, 186 insertions(+), 101 deletions(-)
> > > 
> > > +/**
> > > + * ice_fill_tx_hw_ring - produce the number of Tx descriptors onto ring
> > > + * @xdp_ring: XDP ring to produce the HW Tx descriptors on
> > > + * @descs: AF_XDP descriptors to pull the DMA addresses and lengths from
> > > + * @nb_pkts: count of packets to be send
> > > + * @total_bytes: bytes accumulator that will be used for stats update
> > > + */
> > > +static void ice_fill_tx_hw_ring(struct ice_tx_ring *xdp_ring, struct xdp_desc *descs,
> > > +				u32 nb_pkts, unsigned int *total_bytes)
> > > +{
> > > +	u16 tx_thresh = xdp_ring->tx_thresh;
> > > +	struct ice_tx_desc *tx_desc;
> > 
> > And @tx_desc as well.
> > 
> > > +	u32 batched, leftover, i;
> > > +
> > > +	batched = nb_pkts & ~(PKTS_PER_BATCH - 1);
> > > +	leftover = nb_pkts & (PKTS_PER_BATCH - 1);
> > > +	for (i = 0; i < batched; i += PKTS_PER_BATCH)
> > > +		ice_xmit_pkt_batch(xdp_ring, &descs[i], total_bytes);
> > > +	for (i = batched; i < batched + leftover; i++)
> 
> Breh, I overlooked that. @i will equal @batched after exiting the
> first loop, so the assignment here is redundant (probably harmless
> tho if the compilers are smart enough).

I can drop this and scope variables properly, thanks!

> 
> > > +		ice_xmit_pkt(xdp_ring, &descs[i], total_bytes);
> > > +
> > > +	if (xdp_ring->next_to_use > xdp_ring->next_rs) {
> > > +		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
> > > +		tx_desc->cmd_type_offset_bsz |=
> > > +			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
> > > +		xdp_ring->next_rs += tx_thresh;
> > > +	}
> > > +}
> > >  
> > > -		prefetch(tx_desc);
> > > +/**
