Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78503490BF0
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 16:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbiAQP5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 10:57:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33354 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230172AbiAQP5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 10:57:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642435066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rlvIrjXEeXhEFtRWn3AnWoo+xaG5A+dzL35dY7MweEc=;
        b=MBp9Uo7fCeYa8kCux19Cz80Y/hnvtleEaUHeAim4Z320RcKxWmkNppoWkAEnDuseseaPhk
        R/Vjlk+RZMeGTNi11thwWnfseAUMYSP/I5artzZXPwCwvrgdtU7I3WFj1gU1+CMUL1kwsa
        x+qriJzyIluxvtoZVYunFf8+t5zUpyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-7WdMD0SGMB-XILYH8j4TQQ-1; Mon, 17 Jan 2022 10:57:45 -0500
X-MC-Unique: 7WdMD0SGMB-XILYH8j4TQQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD7C784DA60;
        Mon, 17 Jan 2022 15:57:31 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-3.rdu2.redhat.com [10.10.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E08E5442F;
        Mon, 17 Jan 2022 15:57:31 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 6DF89A807AA; Mon, 17 Jan 2022 16:57:29 +0100 (CET)
Date:   Mon, 17 Jan 2022 16:57:29 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Lennert Buytenhek <buytenh@wantstofly.org>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH 1/2 net-next v4] igc: avoid kernel warning when changing
 RX ring parameters
Message-ID: <YeWR6Q6stSFqIghS@calimero.vinschen.de>
Mail-Followup-To: Lennert Buytenhek <buytenh@wantstofly.org>,
        intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
References: <20220114194520.1092894-1-vinschen@redhat.com>
 <20220114194520.1092894-2-vinschen@redhat.com>
 <YeWD4OG+eYr5B8Sd@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YeWD4OG+eYr5B8Sd@wantstofly.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 17 16:57, Lennert Buytenhek wrote:
> On Fri, Jan 14, 2022 at 08:45:19PM +0100, Corinna Vinschen wrote:
> 
> > Calling ethtool changing the RX ring parameters like this:
> > 
> >   $ ethtool -G eth0 rx 1024
> > 
> > on igc triggers kernel warnings like this:
> > 
> > [  225.198467] ------------[ cut here ]------------
> > [  225.198473] Missing unregister, handled but fix driver
> > [  225.198485] WARNING: CPU: 7 PID: 959 at net/core/xdp.c:168
> > xdp_rxq_info_reg+0x79/0xd0
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
> > +		goto err;
> > +	}
> > +
> >  	return 0;
> >  
> >  err:
> > -	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
> >  	vfree(rx_ring->rx_buffer_info);
> >  	rx_ring->rx_buffer_info = NULL;
> >  	netdev_err(ndev, "Unable to allocate memory for Rx descriptor ring\n");
> 
> This patch fixes the warning...
> 
> Tested-by: Lennert Buytenhek <buytenh@arista.com>
> 
> ...but doesn't it now forget to free rx_ring->desc if xdp_rxq_info_reg()
> fails?

Uhm... I see what you mean.  But then again, the same error was already
present in igb.  Looks like a call to dma_free_coherent is missing there,
too.

I'll prepare YA patch.

Thanks,
Corinna

