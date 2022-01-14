Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B1648F071
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 20:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbiANTZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 14:25:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232539AbiANTZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 14:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642188325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gChq0Rq74zl99KBYEg0JKplyCgCrejoCg9jhvydHVlI=;
        b=PqhDAS0NK0fRT8jagdEk4Hn+vv+nCO1ZPJgEdvIN6r/lYQY5aCIDoUT2sxUC7qzl/as+sI
        gQee/ZDX44ak832oRqzDOJ2Up5mwHCAY3c8b3tDk6rFZ1a4ZjKChMepjyUOd2TuVrubQ6n
        RE5FlITaPm7wjHmfxWjNiArnVsaSr98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-x6UPzVwtOfaoOQE7v2MmIA-1; Fri, 14 Jan 2022 14:25:21 -0500
X-MC-Unique: x6UPzVwtOfaoOQE7v2MmIA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A8B8839A44;
        Fri, 14 Jan 2022 19:25:20 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A7C525BE08;
        Fri, 14 Jan 2022 19:25:19 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 2111AA80ED6; Fri, 14 Jan 2022 20:25:18 +0100 (CET)
Date:   Fri, 14 Jan 2022 20:25:18 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH 1/2 net-next v3] igc: avoid kernel warning when changing
 RX ring parameters
Message-ID: <YeHOHp2vztm1Oi5V@calimero.vinschen.de>
Mail-Followup-To: Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
References: <20220114165106.1085474-1-vinschen@redhat.com>
 <20220114165106.1085474-2-vinschen@redhat.com>
 <87czku6sm2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87czku6sm2.fsf@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 14 11:10, Vinicius Costa Gomes wrote:
> Corinna Vinschen <vinschen@redhat.com> writes:
> 
> > Calling ethtool changing the RX ring parameters like this:
> >
> >   $ ethtool -G eth0 rx 1024
> >
> > on igc triggers the "Missing unregister, handled but fix driver" warning in
> > xdp_rxq_info_reg().
> >
> > igc_ethtool_set_ringparam() copies the igc_ring structure but neglects to
> > reset the xdp_rxq_info member before calling igc_setup_rx_resources().
> > This in turn calls xdp_rxq_info_reg() with an already registered xdp_rxq_info.
> >
> > Make sure to unregister the xdp_rxq_info structure first in
> > igc_setup_rx_resources.  Move xdp_rxq_info handling down to bethe last
> > action, thus allowing to remove the xdp_rxq_info_unreg call in the error path.
> >
> > Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
> > Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> > ---
> >  drivers/net/ethernet/intel/igc/igc_main.c | 20 +++++++++++---------
> >  1 file changed, 11 insertions(+), 9 deletions(-)
> > [...]
> > @@ -534,10 +526,20 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
> >  	rx_ring->next_to_clean = 0;
> >  	rx_ring->next_to_use = 0;
> >  
> > +	/* XDP RX-queue info */
> > +	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
> > +		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
> > +	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, ndev, index,
> > +			       rx_ring->q_vector->napi.napi_id);
> > +	if (res < 0) {
> > +		netdev_err(ndev, "Failed to register xdp_rxq index %u\n",
> > +			   index);
> > +		return res;
> 
> Here and in the igb patch, it should be 'goto err', no?

D'oh, of course.  Soory and thanks for catching.  I'll prepare a v4.

> Another suggestion is to add the warning that Lennert reported in the
> commit message (the comment from Maciej in that other thread).

The current commit message already mentiones the "Missing unregister,
handled but fix driver" warning.  Do you mean the entire warning
snippet including call stack?  If so, no problem.  I'll add it to v4,
too.

Shall I also add "Reported-by: Lennert ..."?  Funny enough we
encountered the problem independently at almost the same time, so when I
sent my v1 of the patch I wasn't even aware of the thread started by
Lennert and only saw it afterwards :}

> Apart from that, I think this is cleaner than what I had proposed.

Thanks,
Corinna

