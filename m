Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDC948F094
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 20:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244142AbiANToo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 14:44:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239565AbiANTon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 14:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642189483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zjs9bJcmU5Y/2iBhjqcMuRBo7ct9e4rrboYxUAMVuVA=;
        b=R3i6P2jZxEILfps9cCUMPy9XPZKIUf3u9CrxcEIWyF4I3k8VqV1yK9OF3j9ZgMZcrpObZe
        QRb5I+1L83SikepoIE1GqB/YnBosoFmou7rbA2tqJWc39prcmjlHU8Czos9QaWHogTk6YZ
        J139eVoy7DXKRRohJ6IVAl7wHMlcfEQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-j44RxOhMNuqo1wUYGl-42w-1; Fri, 14 Jan 2022 14:44:39 -0500
X-MC-Unique: j44RxOhMNuqo1wUYGl-42w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7762C92504;
        Fri, 14 Jan 2022 19:44:38 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45C21196F8;
        Fri, 14 Jan 2022 19:44:38 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id B563CA80ED6; Fri, 14 Jan 2022 20:44:36 +0100 (CET)
Date:   Fri, 14 Jan 2022 20:44:36 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] [PATCH 1/2 net-next v3] igc: avoid kernel
 warning when changing RX ring parameters
Message-ID: <YeHSpMX4H950NV8K@calimero.vinschen.de>
Mail-Followup-To: Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@osuosl.org, netdev@vger.kernel.org
References: <20220114165106.1085474-1-vinschen@redhat.com>
 <20220114165106.1085474-2-vinschen@redhat.com>
 <87czku6sm2.fsf@intel.com>
 <YeHOHp2vztm1Oi5V@calimero.vinschen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YeHOHp2vztm1Oi5V@calimero.vinschen.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 14 20:25, Corinna Vinschen wrote:
> On Jan 14 11:10, Vinicius Costa Gomes wrote:
> > Corinna Vinschen <vinschen@redhat.com> writes:
> > 
> > > Calling ethtool changing the RX ring parameters like this:
> > >
> > >   $ ethtool -G eth0 rx 1024
> > >
> > > on igc triggers the "Missing unregister, handled but fix driver" warning in
> > > xdp_rxq_info_reg().
> > >
> > > igc_ethtool_set_ringparam() copies the igc_ring structure but neglects to
> > > reset the xdp_rxq_info member before calling igc_setup_rx_resources().
> > > This in turn calls xdp_rxq_info_reg() with an already registered xdp_rxq_info.
> > >
> > > Make sure to unregister the xdp_rxq_info structure first in
> > > igc_setup_rx_resources.  Move xdp_rxq_info handling down to bethe last
> > > action, thus allowing to remove the xdp_rxq_info_unreg call in the error path.
> > >
> > > Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
> > > Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> > > ---
> > >  drivers/net/ethernet/intel/igc/igc_main.c | 20 +++++++++++---------
> > >  1 file changed, 11 insertions(+), 9 deletions(-)
> > > [...]
> > > @@ -534,10 +526,20 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
> > >  	rx_ring->next_to_clean = 0;
> > >  	rx_ring->next_to_use = 0;
> > >  
> > > +	/* XDP RX-queue info */
> > > +	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
> > > +		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
> > > +	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, ndev, index,
> > > +			       rx_ring->q_vector->napi.napi_id);
> > > +	if (res < 0) {
> > > +		netdev_err(ndev, "Failed to register xdp_rxq index %u\n",
> > > +			   index);
> > > +		return res;
> > 
> > Here and in the igb patch, it should be 'goto err', no?
> 
> D'oh, of course.  Soory and thanks for catching.  I'll prepare a v4.
> 
> > Another suggestion is to add the warning that Lennert reported in the
> > commit message (the comment from Maciej in that other thread).
> 
> The current commit message already mentiones the "Missing unregister,
> handled but fix driver" warning.  Do you mean the entire warning
> snippet including call stack?  If so, no problem.  I'll add it to v4,
> too.
> 
> Shall I also add "Reported-by: Lennert ..."?  Funny enough we
> encountered the problem independently at almost the same time, so when I
> sent my v1 of the patch I wasn't even aware of the thread started by
> Lennert and only saw it afterwards :}

Never mind, I just send a v4 with all of that.


Corinna

