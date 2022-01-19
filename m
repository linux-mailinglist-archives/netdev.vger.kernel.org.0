Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0F24934D9
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 07:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351711AbiASGJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 01:09:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234904AbiASGJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 01:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642572541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZJmYLbcbv8lBtjGOd/JtLOo+KTdFEGmckMITgiGoGHU=;
        b=cN4Cz1R77UOVEfOc3YeBHZeIVYpS8tMnVt+Dbuzc/zPcfeKwbTkW9s/GbGq1W0AoaLUk5V
        rHUTQzpEX4b1CcRPb4HpYXv/fpXT3dFAFt+OSl1aebijfqnnP01Tezj1hFGHedwls8ylyW
        TPw/JSGPpFFuxnyvVNUQ8VWoIlokqKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-v0IDQttLMLmeZ5OmGbKOcQ-1; Wed, 19 Jan 2022 01:08:58 -0500
X-MC-Unique: v0IDQttLMLmeZ5OmGbKOcQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE5221091DA4;
        Wed, 19 Jan 2022 06:08:56 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-9.ams2.redhat.com [10.36.112.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 404424EC66;
        Wed, 19 Jan 2022 06:08:56 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id AEA85A80D5F; Wed, 19 Jan 2022 07:08:54 +0100 (CET)
Date:   Wed, 19 Jan 2022 07:08:54 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 2/3 net-next v5] igb: refactor XDP registration
Message-ID: <Yeeq9k5L/Md66Ktm@calimero.vinschen.de>
Mail-Followup-To: Alexander Lobakin <alexandr.lobakin@intel.com>,
        intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>
References: <20220117182915.1283151-1-vinschen@redhat.com>
 <20220117182915.1283151-3-vinschen@redhat.com>
 <20220118150512.25541-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220118150512.25541-1-alexandr.lobakin@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 18 16:05, Alexander Lobakin wrote:
> From: Corinna Vinschen <vinschen@redhat.com>
> Date: Mon, 17 Jan 2022 19:29:14 +0100
> 
> > On changing the RX ring parameters igb uses a hack to avoid a warning
> > when calling xdp_rxq_info_reg via igb_setup_rx_resources.  It just
> > clears the struct xdp_rxq_info content.
> > 
> > Change this to unregister if we're already registered instead.  Align
> > code to the igc code.
> > 
> > Fixes: 9cbc948b5a20c ("igb: add XDP support")
> > Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> > ---
> >  drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
> >  drivers/net/ethernet/intel/igb/igb_main.c    | 12 +++++++++---
> >  2 files changed, 9 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > index 51a2dcaf553d..2a5782063f4c 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > @@ -965,10 +965,6 @@ static int igb_set_ringparam(struct net_device *netdev,
> >  			memcpy(&temp_ring[i], adapter->rx_ring[i],
> >  			       sizeof(struct igb_ring));
> >  
> > -			/* Clear copied XDP RX-queue info */
> > -			memset(&temp_ring[i].xdp_rxq, 0,
> > -			       sizeof(temp_ring[i].xdp_rxq));
> > -
> >  			temp_ring[i].count = new_rx_count;
> >  			err = igb_setup_rx_resources(&temp_ring[i]);
> >  			if (err) {
> > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> > index 38ba92022cd4..cea89d301bfd 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > @@ -4352,7 +4352,7 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
> >  {
> >  	struct igb_adapter *adapter = netdev_priv(rx_ring->netdev);
> >  	struct device *dev = rx_ring->dev;
> > -	int size;
> > +	int size, res;
> >  
> >  	size = sizeof(struct igb_rx_buffer) * rx_ring->count;
> >  
> > @@ -4376,9 +4376,15 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
> >  	rx_ring->xdp_prog = adapter->xdp_prog;
> >  
> >  	/* XDP RX-queue info */
> > -	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
> > -			     rx_ring->queue_index, 0) < 0)
> > +	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
> > +		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
> > +	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
> > +			       rx_ring->queue_index, 0);
> > +	if (res < 0) {
> > +		dev_err(dev, "Failed to register xdp_rxq index %u\n",
> > +			rx_ring->queue_index);
> >  		goto err;
> 
> Error path always returns -ENOMEM, even in this case, and reports
> that it failed to allocate memory for rings. Handle this correctly
> and return `res` instead and without one more error message?

In that case, it makes sense to revert the code to the way igc did it,
rather then trying to do as igb did it.

I. e., for both drivers, call xdp_rxq_info_is_reg before the first
allocation took place, and just return immediately from there if it
fails.  Everything else complicates the code unnecessarily.

> As I mentioned a bit above, `res` is unused here as an error code,
> only to test the value on < 0. Does it make sense to add a new
> variable?

Following my above sugggestion, res will be used as error code, so
it should stay.

I'll provide a matching patchset later today.


Thanks,
Corinna

