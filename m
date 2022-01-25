Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BBD49B2DC
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 12:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381434AbiAYLYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 06:24:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:50882 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382285AbiAYLXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 06:23:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643109813; x=1674645813;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ejBUXVJFWoEAiI99ThzteoedvK21A+SGIK5AP4i9Sic=;
  b=W/wsgUy5EvcosibwxYuhRt1wBw7ThdoBgh/fiSl/ZN/LhUBMD0Og4SwI
   VtYjGSGQJeJdbizsx4c8beYlRIeEkEO7ls2sqi8bC+3gAzGdwpV4fPO9W
   V5VgjpWsCu7faaTCsTxYhBSOzU4mWtCr2zJIKZARjpUpR8HcLXOg9yJ5V
   QatXlHosmy1gHd3MDqHBKVGxo2Y0flZKoBAVdkMt8nbHiLvSuf+iIk43z
   UmB1EYMMgRFSoUjjpDGYYDhBoA+aPjlzpv3gUdXlav4pUMccvXdvZ+kQQ
   XkJbp4enb6YfmRqGhVzIVmmglGrEcbNUj09d3I2gyOBvpYsu8gRU5JqYa
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="243878827"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="243878827"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 03:23:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="627876575"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 25 Jan 2022 03:23:24 -0800
Date:   Tue, 25 Jan 2022 12:23:23 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH bpf-next v4 7/8] ice: xsk: improve AF_XDP ZC Tx and use
 batching API
Message-ID: <Ye/dqylvNNa72wI8@boxer>
References: <20220124165547.74412-1-maciej.fijalkowski@intel.com>
 <20220124165547.74412-8-maciej.fijalkowski@intel.com>
 <CAJ8uoz1KRjks7k-tVQoZAHScrmqEhUQJqs5_L_gJX8PnY=VCwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz1KRjks7k-tVQoZAHScrmqEhUQJqs5_L_gJX8PnY=VCwg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 10:32:35AM +0100, Magnus Karlsson wrote:
> On Mon, Jan 24, 2022 at 8:38 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > Apply the logic that was done for regular XDP from commit 9610bd988df9
> > ("ice: optimize XDP_TX workloads") to the ZC side of the driver. On top
> > of that, introduce batching to Tx that is inspired by i40e's
> > implementation with adjustments to the cleaning logic - take into the
> > account NAPI budget in ice_clean_xdp_irq_zc().
> >
> > Separating the stats structs onto separate cache lines seemed to improve
> > the performance.
> 
> Nice one, thanks! Just one smaller comment below.
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
> >  drivers/net/ethernet/intel/ice/ice_txrx.h |   2 +-
> >  drivers/net/ethernet/intel/ice/ice_xsk.c  | 256 ++++++++++++++--------
> >  drivers/net/ethernet/intel/ice/ice_xsk.h  |  27 ++-
> >  4 files changed, 188 insertions(+), 99 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > index 73f60493209d..7d8824b4c8ff 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > @@ -1462,7 +1462,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
> >                 bool wd;
> >
> >                 if (tx_ring->xsk_pool)
> > -                       wd = ice_clean_tx_irq_zc(tx_ring, budget);
> > +                       wd = ice_xmit_zc(tx_ring, ICE_DESC_UNUSED(tx_ring), budget);
> >                 else if (ice_ring_is_xdp(tx_ring))
> >                         wd = true;
> >                 else
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> > index 611dd7c4a631..ea6c9cc02a1a 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> > @@ -322,9 +322,9 @@ struct ice_tx_ring {
> >         u16 count;                      /* Number of descriptors */
> >         u16 q_index;                    /* Queue number of ring */
> >         /* stats structs */
> > +       struct ice_txq_stats tx_stats;
> >         struct ice_q_stats      stats;
> >         struct u64_stats_sync syncp;
> > -       struct ice_txq_stats tx_stats;
> >
> >         /* CL3 - 3rd cacheline starts here */
> >         struct rcu_head rcu;            /* to avoid race on free */
> 
> Seems like these comments are wrong these days. Your move indeed moves
> the tx_stats to another cache line as seen in the pahole dump below,
> but that is not obvious with the comments that point to the opposite.
> Maybe update the cacheline start comments to the correct locations?

Indeed it's off. It seems there are minor things to improve here and
there, so let me send a v5.

Thanks!

> 
> <snip>
> u16                        q_index;              /*    94     2 */
> struct ice_txq_stats       tx_stats;             /*    96    32 */
> 
> /* XXX last struct has 4 bytes of padding */
> 
> /* --- cacheline 2 boundary (128 bytes) --- */
> struct ice_q_stats         stats;                /*   128    16 */
> struct u64_stats_sync      syncp;                /*   144     0 */
> struct callback_head       rcu __attribute__((__aligned__(8))); /*
> 144    16 */
> long unsigned int          xps_state[1];         /*   160     8 */
> <snip>
> 

(...)
