Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158CE2DD882
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgLQSjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:39:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:9829 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbgLQSjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 13:39:19 -0500
IronPort-SDR: 8fSbeASh3S0aVSod3m35UjfaT+fAO5QSMbi+4WCBuvsUNB+kJ6/o9QildlrZNJHPxGKfpMpRtb
 frthc2Ebwcmg==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="193705823"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="193705823"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 10:38:38 -0800
IronPort-SDR: ny0qku8lz4QI5uJeEqRi3PBiMkeX5GghdqAk0ms3AJeYpTZHsvOr0L/l0xERBAqgC+bvFY1ox5
 8Fgk0N6MBjJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="339732303"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 17 Dec 2020 10:38:36 -0800
Date:   Thu, 17 Dec 2020 19:28:45 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexander.duyck@gmail.com
Subject: Re: [PATCH v3 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
Message-ID: <20201217182845.GB43061@ranger.igk.intel.com>
References: <cover.1607794551.git.lorenzo@kernel.org>
 <71d5ae9f810c2c80f1cb09e304330be0b5ce5345.1607794552.git.lorenzo@kernel.org>
 <20201215123643.GA23785@ranger.igk.intel.com>
 <20201215134710.GB5477@lore-desk>
 <20201216095240.43867406@carbon>
 <20201216150126.GD2036@lore-desk>
 <f6ea4b091ce6aa7fc91954ff1e988a3bf285ca52.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ea4b091ce6aa7fc91954ff1e988a3bf285ca52.camel@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 10:16:06AM -0800, Saeed Mahameed wrote:
> On Wed, 2020-12-16 at 16:01 +0100, Lorenzo Bianconi wrote:
> > > On Tue, 15 Dec 2020 14:47:10 +0100
> > > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> > > 
> > > > [...]
> > > > > >  	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
> > > > > > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > > b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > > index 4dbbbd49c389..fcd1ca3343fb 100644
> > > > > > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > > @@ -2393,12 +2393,12 @@ static int i40e_clean_rx_irq(struct
> > > > > > i40e_ring *rx_ring, int budget)
> > > > > >  
> > > > > >  		/* retrieve a buffer from the ring */
> > > > > >  		if (!skb) {
> > > > > > -			xdp.data = page_address(rx_buffer-
> > > > > > >page) +
> > > > > > -				   rx_buffer->page_offset;
> > > > > > -			xdp.data_meta = xdp.data;
> > > > > > -			xdp.data_hard_start = xdp.data -
> > > > > > -					      i40e_rx_offset(rx
> > > > > > _ring);
> > > > > > -			xdp.data_end = xdp.data + size;
> > > > > > +			unsigned int offset =
> > > > > > i40e_rx_offset(rx_ring);  
> > > > > 
> > > > > I now see that we could call the i40e_rx_offset() once per
> > > > > napi, so can
> > > > > you pull this variable out and have it initialized a single
> > > > > time? Applies
> > > > > to other intel drivers as well.  
> > > > 
> 
> How is this related to this series? i suggest to keep this series clean
> of vendor specific unrelated optimizations, this must be done in a
> separate patchset.

Well, Lorenzo explicitly is touching the thing that I referred to, so I
just ask if he can optimize it while he's at it.

Of course I'm fine with addressing this by myself once -next opens :)

> 
> 
> > > > ack, fine. I will fix in v4.
> > > 
> > > Be careful with the Intel drivers.  They have two modes (at compile
> > > time) depending on PAGE_SIZE in system.  In one of the modes
> > > (default
> > > one) you can place init of xdp.frame_sz outside the NAPI loop and
> > > init a
> > > single time.  In the other mode you cannot, and it becomes dynamic
> > > per
> > > packet.  Intel review this carefully, please!
> > 
> > ack. Actully I kept the xdp.frame_sz configuration in the NAPI loop
> > but
> > an Intel review will be nice.
> > 
> > Regards,
> > Lorenzo
> > 
> > > -- 
> > > Best regards,
> > >   Jesper Dangaard Brouer
> > >   MSc.CS, Principal Kernel Engineer at Red Hat
> > >   LinkedIn: http://www.linkedin.com/in/brouer
> > > 
> 
