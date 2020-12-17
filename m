Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6292DDA1A
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 21:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbgLQUbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 15:31:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbgLQUbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 15:31:51 -0500
Message-ID: <4d9e2dd071314f73136d77912cb9cc40d4557c80.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608237070;
        bh=zOLHGFDp5FnPQFS+OeDdSnYT7a6W2uVY99nsszxy6FY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e+DU0UXs2tUAVYS5sy5E0dng5GPAhxCLgG0EMFyQSxgeXpdwFRnAA8pBxwcWCEZ3T
         c7AUv3KBoRi+LjBQYgD8LAuRkdcUcJWHhVesqOUw9RFJMmrkq2EYgk9hB5dbNZX5KX
         rjgWj2fFyWNa35aowoxYEnEJ7QG/cgc2bPoKioF1H76cUUx869nlSgYu6lHWX5nU1s
         nKEKtJVOXLKYx0J3NsyIghnopZ+HenVrZAx8XOE8XSGbY+mKGiRFBOTCKWJURHwRUE
         7iHzQxSNdo+DRzDeWHgwF2Tt7CduyT0FMNXdOBDwG9YnKwlGu+GkcMakduNwxHwuX1
         LeH87KK5Owrtw==
Subject: Re: [PATCH v3 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
From:   Saeed Mahameed <saeed@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexander.duyck@gmail.com
Date:   Thu, 17 Dec 2020 12:31:09 -0800
In-Reply-To: <20201217182845.GB43061@ranger.igk.intel.com>
References: <cover.1607794551.git.lorenzo@kernel.org>
         <71d5ae9f810c2c80f1cb09e304330be0b5ce5345.1607794552.git.lorenzo@kernel.org>
         <20201215123643.GA23785@ranger.igk.intel.com>
         <20201215134710.GB5477@lore-desk> <20201216095240.43867406@carbon>
         <20201216150126.GD2036@lore-desk>
         <f6ea4b091ce6aa7fc91954ff1e988a3bf285ca52.camel@kernel.org>
         <20201217182845.GB43061@ranger.igk.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-12-17 at 19:28 +0100, Maciej Fijalkowski wrote:
> On Thu, Dec 17, 2020 at 10:16:06AM -0800, Saeed Mahameed wrote:
> > On Wed, 2020-12-16 at 16:01 +0100, Lorenzo Bianconi wrote:
> > > > On Tue, 15 Dec 2020 14:47:10 +0100
> > > > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> > > > 
> > > > > [...]
> > > > > > >  	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
> > > > > > > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > > > b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > > > index 4dbbbd49c389..fcd1ca3343fb 100644
> > > > > > > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > > > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > > > @@ -2393,12 +2393,12 @@ static int
> > > > > > > i40e_clean_rx_irq(struct
> > > > > > > i40e_ring *rx_ring, int budget)
> > > > > > >  
> > > > > > >  		/* retrieve a buffer from the ring */
> > > > > > >  		if (!skb) {
> > > > > > > -			xdp.data = page_address(rx_buffer-
> > > > > > > > page) +
> > > > > > > -				   rx_buffer->page_offset;
> > > > > > > -			xdp.data_meta = xdp.data;
> > > > > > > -			xdp.data_hard_start = xdp.data -
> > > > > > > -					      i40e_rx_offset(rx
> > > > > > > _ring);
> > > > > > > -			xdp.data_end = xdp.data + size;
> > > > > > > +			unsigned int offset =
> > > > > > > i40e_rx_offset(rx_ring);  
> > > > > > 
> > > > > > I now see that we could call the i40e_rx_offset() once per
> > > > > > napi, so can
> > > > > > you pull this variable out and have it initialized a single
> > > > > > time? Applies
> > > > > > to other intel drivers as well.  
> > 
> > How is this related to this series? i suggest to keep this series
> > clean
> > of vendor specific unrelated optimizations, this must be done in a
> > separate patchset.
> 
> Well, Lorenzo explicitly is touching the thing that I referred to, so
> I
> just ask if he can optimize it while he's at it.
> 
> Of course I'm fine with addressing this by myself once -next opens :)
> 
Oh, don't get me wrong I am ok with doing this now, and i can do it my
self if you want :), but it shouldn't be part of the this series, so we
won't confuse others who want to implement XDP in the future, that's
all.

