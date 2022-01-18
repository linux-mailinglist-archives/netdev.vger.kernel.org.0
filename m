Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F73492129
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 09:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242847AbiARI0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 03:26:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232989AbiARI0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 03:26:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642494368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A/b6yg4ShWdAV0SfuluaVdnvCZUNPg/qEytwysGwHTk=;
        b=anxoryL9kroHXEv3z/lFxcdWVI3DhDLsR/LUBHhUAVk+6LUEpOcFpG21tSp83kyQuy343P
        4ellT9LpeOQvrBnnG4hzAV78TYn7n9aco+ojkdWmAj6vYzY1UMw9VQjM8e+EnJE1SH4rjH
        PazcFoHJDS9lEtiQzwHXQvtSmtxMTFk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-T--zKjN0PiqF09K4X1zXPQ-1; Tue, 18 Jan 2022 03:26:05 -0500
X-MC-Unique: T--zKjN0PiqF09K4X1zXPQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A07CC190D340;
        Tue, 18 Jan 2022 08:26:03 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-3.rdu2.redhat.com [10.10.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3451B7A230;
        Tue, 18 Jan 2022 08:26:03 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 12AEFA8096F; Tue, 18 Jan 2022 09:26:01 +0100 (CET)
Date:   Tue, 18 Jan 2022 09:26:01 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Lennert Buytenhek <buytenh@wantstofly.org>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH 3/3 net-next v5] igb/igc: RX queues: fix DMA leak in
 error case
Message-ID: <YeZ5mVY/SpThBi/O@calimero.vinschen.de>
Mail-Followup-To: Lennert Buytenhek <buytenh@wantstofly.org>,
        intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
References: <20220117182915.1283151-1-vinschen@redhat.com>
 <20220117182915.1283151-4-vinschen@redhat.com>
 <YeZXuoRa/39zzoEY@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YeZXuoRa/39zzoEY@wantstofly.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 18 08:01, Lennert Buytenhek wrote:
> On Mon, Jan 17, 2022 at 07:29:15PM +0100, Corinna Vinschen wrote:
> 
> > When setting up the rx queues, igb and igc neglect to free DMA memory
> > in error case.  Add matching dma_free_coherent calls.
> > 
> > Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> > ---
> >  drivers/net/ethernet/intel/igb/igb_main.c | 1 +
> >  drivers/net/ethernet/intel/igc/igc_main.c | 1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> > index cea89d301bfd..343568d4ff7f 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > @@ -4389,6 +4389,7 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
> >  	return 0;
> >  
> >  err:
> > +	dma_free_coherent(dev, rx_ring->size, rx_ring->desc, rx_ring->dma);
> >  	vfree(rx_ring->rx_buffer_info);
> >  	rx_ring->rx_buffer_info = NULL;
> >  	dev_err(dev, "Unable to allocate memory for the Rx descriptor ring\n");
> > diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> > index 56ed0f1463e5..f323cec0b74f 100644
> > --- a/drivers/net/ethernet/intel/igc/igc_main.c
> > +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> > @@ -540,6 +540,7 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
> >  	return 0;
> >  
> >  err:
> > +	dma_free_coherent(dev, rx_ring->size, rx_ring->desc, rx_ring->dma);
> >  	vfree(rx_ring->rx_buffer_info);
> >  	rx_ring->rx_buffer_info = NULL;
> >  	netdev_err(ndev, "Unable to allocate memory for Rx descriptor ring\n");
> 
> If the vzalloc() call in igc_setup_rx_resources() fails, and we jump
> to 'err' before dma_alloc_coherent() was reached, won't dma_free_coherent()
> be called inadvertently here?

These calls all check for a NULL pointer themselves.

Corinna

