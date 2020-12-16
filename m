Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F512DBD03
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 09:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgLPIyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 03:54:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbgLPIyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 03:54:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608108774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WiRmIPuJvtrPY5M/BFG60cBFFkmQJmzXXzb70DKLQE4=;
        b=TXqusYZtg+UOvR+megA3MkhrfPlCoxkWWqZSwY+ZNbFw+tGPYlwdYB9QEnDmwCbb0IMCMJ
        0AhwDE70uK4nQp7vWkp13V65XpUXD/YlsRFIKjA8P88qs48Yv50oupsY+nxP25xHMHRuvZ
        V9e/aSAj11ide6h91e9P3Bb589BXGmk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-xA1-GzGyPKiYFNmhK65XeQ-1; Wed, 16 Dec 2020 03:52:53 -0500
X-MC-Unique: xA1-GzGyPKiYFNmhK65XeQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77BFC107ACE3;
        Wed, 16 Dec 2020 08:52:51 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AFF6E70E;
        Wed, 16 Dec 2020 08:52:41 +0000 (UTC)
Date:   Wed, 16 Dec 2020 09:52:40 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexander.duyck@gmail.com,
        saeed@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
Message-ID: <20201216095240.43867406@carbon>
In-Reply-To: <20201215134710.GB5477@lore-desk>
References: <cover.1607794551.git.lorenzo@kernel.org>
        <71d5ae9f810c2c80f1cb09e304330be0b5ce5345.1607794552.git.lorenzo@kernel.org>
        <20201215123643.GA23785@ranger.igk.intel.com>
        <20201215134710.GB5477@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 14:47:10 +0100
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> [...]
> > >  	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
> > > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > index 4dbbbd49c389..fcd1ca3343fb 100644
> > > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > @@ -2393,12 +2393,12 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
> > >  
> > >  		/* retrieve a buffer from the ring */
> > >  		if (!skb) {
> > > -			xdp.data = page_address(rx_buffer->page) +
> > > -				   rx_buffer->page_offset;
> > > -			xdp.data_meta = xdp.data;
> > > -			xdp.data_hard_start = xdp.data -
> > > -					      i40e_rx_offset(rx_ring);
> > > -			xdp.data_end = xdp.data + size;
> > > +			unsigned int offset = i40e_rx_offset(rx_ring);  
> > 
> > I now see that we could call the i40e_rx_offset() once per napi, so can
> > you pull this variable out and have it initialized a single time? Applies
> > to other intel drivers as well.  
>
> ack, fine. I will fix in v4.

Be careful with the Intel drivers.  They have two modes (at compile
time) depending on PAGE_SIZE in system.  In one of the modes (default
one) you can place init of xdp.frame_sz outside the NAPI loop and init a
single time.  In the other mode you cannot, and it becomes dynamic per
packet.  Intel review this carefully, please!

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

