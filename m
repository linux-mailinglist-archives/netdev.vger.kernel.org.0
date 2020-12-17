Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA412DD823
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbgLQSQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:16:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730015AbgLQSQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 13:16:48 -0500
Message-ID: <f6ea4b091ce6aa7fc91954ff1e988a3bf285ca52.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608228967;
        bh=IKdgGUFXeRrBvmMBvVUepynkpYOyoLa8r8/MXJKu01g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=swkK0bC4+I3VQQSuXfZ7ArDwPPrarR1qiLewrQq/7350OnRDkrIeEsw8McVVhtmhk
         pTnEh3LteYE8w54nn2imbBgqNsIpiQU1HIcKnQu/bYz5GAYeZmUgGwWhu2tq8ABKO2
         NtYN+No7ye662VS7IqZyAMU3BYY/mDMFw5pbtkgXy6aTdeteO7XFGKPtj6ypE/Y1zy
         xM3rosHeFd14hLjdNu1W367oOHUBGnOcGe8W1hKFfpGKmoxXUfeK3qD6jMYGhHTzdk
         V+WZLXq3IObn4r423MpaIRshvps0eZIsqd+bmeXlMFNh0sOUWzB6Wbw/54lG9NVdvo
         Ll+WA9ULQsvww==
Subject: Re: [PATCH v3 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
From:   Saeed Mahameed <saeed@kernel.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexander.duyck@gmail.com
Date:   Thu, 17 Dec 2020 10:16:06 -0800
In-Reply-To: <20201216150126.GD2036@lore-desk>
References: <cover.1607794551.git.lorenzo@kernel.org>
         <71d5ae9f810c2c80f1cb09e304330be0b5ce5345.1607794552.git.lorenzo@kernel.org>
         <20201215123643.GA23785@ranger.igk.intel.com>
         <20201215134710.GB5477@lore-desk> <20201216095240.43867406@carbon>
         <20201216150126.GD2036@lore-desk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-16 at 16:01 +0100, Lorenzo Bianconi wrote:
> > On Tue, 15 Dec 2020 14:47:10 +0100
> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> > 
> > > [...]
> > > > >  	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
> > > > > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > index 4dbbbd49c389..fcd1ca3343fb 100644
> > > > > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > > @@ -2393,12 +2393,12 @@ static int i40e_clean_rx_irq(struct
> > > > > i40e_ring *rx_ring, int budget)
> > > > >  
> > > > >  		/* retrieve a buffer from the ring */
> > > > >  		if (!skb) {
> > > > > -			xdp.data = page_address(rx_buffer-
> > > > > >page) +
> > > > > -				   rx_buffer->page_offset;
> > > > > -			xdp.data_meta = xdp.data;
> > > > > -			xdp.data_hard_start = xdp.data -
> > > > > -					      i40e_rx_offset(rx
> > > > > _ring);
> > > > > -			xdp.data_end = xdp.data + size;
> > > > > +			unsigned int offset =
> > > > > i40e_rx_offset(rx_ring);  
> > > > 
> > > > I now see that we could call the i40e_rx_offset() once per
> > > > napi, so can
> > > > you pull this variable out and have it initialized a single
> > > > time? Applies
> > > > to other intel drivers as well.  
> > > 

How is this related to this series? i suggest to keep this series clean
of vendor specific unrelated optimizations, this must be done in a
separate patchset.


> > > ack, fine. I will fix in v4.
> > 
> > Be careful with the Intel drivers.  They have two modes (at compile
> > time) depending on PAGE_SIZE in system.  In one of the modes
> > (default
> > one) you can place init of xdp.frame_sz outside the NAPI loop and
> > init a
> > single time.  In the other mode you cannot, and it becomes dynamic
> > per
> > packet.  Intel review this carefully, please!
> 
> ack. Actully I kept the xdp.frame_sz configuration in the NAPI loop
> but
> an Intel review will be nice.
> 
> Regards,
> Lorenzo
> 
> > -- 
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> > 

