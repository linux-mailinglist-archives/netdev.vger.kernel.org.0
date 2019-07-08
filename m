Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 687446247C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391155AbfGHPnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:43:23 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46156 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729890AbfGHPYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:24:25 -0400
Received: by mail-pg1-f193.google.com with SMTP id i8so7842720pgm.13
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 08:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M4cY5ca8d6Z/9HlLpN/bUc8rzRY9245O+zcifUxX2Rc=;
        b=I5uZ013uUXQ8/9BT1yeGYgmnwHxfegcSKW4Cnt2pmz1mVn0Vn0bjn1Dgy63RuJfRUV
         kFH99AWQXeH5ldhqFvxHFQYt84aeBNIYRMslxmEJGL8Q7FF4iBjLozMZB3opCeh2c/dX
         6Jt3yeL62VykSpkiB/B3JKEfKaKJP7NPfyyWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M4cY5ca8d6Z/9HlLpN/bUc8rzRY9245O+zcifUxX2Rc=;
        b=YVVegZfvUeqtFs+f5rupFFOpZZzzFgdmR8Ge01ThqvBCYKPHyd7PAMKxIDd4Ro6OX3
         scMHS4nh3tkrkWmZo+90t+Cz85fH+dX0rPrMy74jWm3LGmdxerLExqwJVgBbQRP7Cam3
         enkT+I3CVJ8iTkxrYZUmNUzlQl3WRjwmCxFyYVMhVH9tk+TKaKiUfasMsJhx8/qcgO6d
         EIiDfRIzW+4GUmtHzhrQG9EqLP7OmnOLntdiZleEhWk7QWAmXtBiia3SvpXkHtsEXrrZ
         WneJNyhRKmrnAaY6BQcSOsJO7t9yaT5wYgVryjEUpyOHvna0s292u1trp0y2ho2xj9DJ
         SB8A==
X-Gm-Message-State: APjAAAXRwaByh9jbozNh2o7+l7JFOXGM7o+vMdlWyfgU0fprNdpJ8Bha
        JX8WU8RRb0yF2IAZ18zYhNiF4w==
X-Google-Smtp-Source: APXvYqzDxo4CHBAR+OaX6yK0Kb7fbnpOzq7qr7wEhB8AysIIdfefMNaG1o8KuEn/D8sG/C0un9rkMQ==
X-Received: by 2002:a17:90a:109:: with SMTP id b9mr25338984pjb.112.1562599464903;
        Mon, 08 Jul 2019 08:24:24 -0700 (PDT)
Received: from C02RW35GFVH8.dhcp.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id j1sm34517451pgl.12.2019.07.08.08.24.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 08:24:24 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Mon, 8 Jul 2019 11:24:19 -0400
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org,
        ivan.khoronzhuk@linaro.org
Subject: Re: [PATCH net-next 3/4] bnxt_en: optimized XDP_REDIRECT support
Message-ID: <20190708152419.GG87269@C02RW35GFVH8.dhcp.broadcom.net>
References: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
 <1562398578-26020-4-git-send-email-michael.chan@broadcom.com>
 <20190708082803.GA28592@apalos>
 <20190708142606.GF87269@C02RW35GFVH8.dhcp.broadcom.net>
 <20190708145137.GA21894@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708145137.GA21894@apalos>
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 05:51:37PM +0300, Ilias Apalodimas wrote:
> Hi Andy, 
> 
> > On Mon, Jul 08, 2019 at 11:28:03AM +0300, Ilias Apalodimas wrote:
> > > Thanks Andy, Michael
> > > 
> > > > +	if (event & BNXT_REDIRECT_EVENT)
> > > > +		xdp_do_flush_map();
> > > > +
> > > >  	if (event & BNXT_TX_EVENT) {
> > > >  		struct bnxt_tx_ring_info *txr = bnapi->tx_ring;
> > > >  		u16 prod = txr->tx_prod;
> > > > @@ -2254,9 +2257,23 @@ static void bnxt_free_tx_skbs(struct bnxt *bp)
> > > >  
> > > >  		for (j = 0; j < max_idx;) {
> > > >  			struct bnxt_sw_tx_bd *tx_buf = &txr->tx_buf_ring[j];
> > > > -			struct sk_buff *skb = tx_buf->skb;
> > > > +			struct sk_buff *skb;
> > > >  			int k, last;
> > > >  
> > > > +			if (i < bp->tx_nr_rings_xdp &&
> > > > +			    tx_buf->action == XDP_REDIRECT) {
> > > > +				dma_unmap_single(&pdev->dev,
> > > > +					dma_unmap_addr(tx_buf, mapping),
> > > > +					dma_unmap_len(tx_buf, len),
> > > > +					PCI_DMA_TODEVICE);
> > > > +				xdp_return_frame(tx_buf->xdpf);
> > > > +				tx_buf->action = 0;
> > > > +				tx_buf->xdpf = NULL;
> > > > +				j++;
> > > > +				continue;
> > > > +			}
> > > > +
> > > 
> > > Can't see the whole file here and maybe i am missing something, but since you
> > > optimize for that and start using page_pool, XDP_TX will be a re-synced (and
> > > not remapped)  buffer that can be returned to the pool and resynced for 
> > > device usage. 
> > > Is that happening later on the tx clean function?
> > 
> > Take a look at the way we treat the buffers in bnxt_rx_xdp() when we
> > receive them and then in bnxt_tx_int_xdp() when the transmits have
> > completed (for XDP_TX and XDP_REDIRECT).  I think we are doing what is
> > proper with respect to mapping vs sync for both cases, but I would be
> > fine to be corrected.
> > 
> 
> Yea seems to be doing the right thing, 
> XDP_TX syncs correctly and reuses with bnxt_reuse_rx_data() right?
> 
> This might be a bit confusing for someone reading the driver on the first time,
> probably because you'll end up with 2 ways of recycling buffers. 
> 
> Once a buffers get freed on the XDP path it's either fed back to the pool, so
> the next requested buffer get served from the pools cache (ndo_xdp_xmit case in
> the patch). If the buffer is used for XDP_TX is's synced correctly but recycled
> via bnxt_reuse_rx_data() right? Since you are moving to page pool please
> consider having a common approach towards the recycling path. I understand that
> means tracking buffers types and make sure you do the right thing on 'tx clean'.
> I've done something similar on the netsec driver and i do think this might be a
> good thing to add on page_pool API
> 
> Again this isn't a blocker at least for me but you already have the buffer type
> (via tx_buf->action)

Thanks for the confirmation.  I agree things are not totally clear as I
had to learn how all of it worked to do this.  We can work on that.

> 
> > > 
> > > > +			skb = tx_buf->skb;
> > > >  			if (!skb) {
> > > >  				j++;
> > > >  				continue;
> > > > @@ -2517,6 +2534,13 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
> > > >  		if (rc < 0)
> > > >  			return rc;
> > > >  
> > > > +		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
> > > > +						MEM_TYPE_PAGE_SHARED, NULL);
> > > > +		if (rc) {
> > > > +			xdp_rxq_info_unreg(&rxr->xdp_rxq);
> > > 
> > > I think you can use page_pool_free directly here (and pge_pool_destroy once
> > > Ivan's patchset gets nerged), that's what mlx5 does iirc. Can we keep that
> > > common please?
> > 
> > That's an easy change, I can do that.
> > 

I'll reply to myself here and note that you are correct that we need to
fixup the error case, but it actually belongs in patch 4 in the series
since that is the patch that adds page_pool support.  I'll reply to that
one in just a min once I've tested my patch.

> > > 
> > > If Ivan's patch get merged please note you'll have to explicitly
> > > page_pool_destroy, after calling xdp_rxq_info_unreg() in the general unregister
> > > case (not the error habdling here). Sorry for the confusion this might bring!
> > 
> > Funny enough the driver was basically doing that until page_pool_destroy
> > was removed (these patches are not new).  I saw last week there was
> > discussion to add it back, but I did not want to wait to get this on the
> > list before that was resolved.
> 
> Fair enough
> 
> > 
> > This path works as expected with the code in the tree today so it seemed
> > like the correct approach to post something that is working, right?  :-)
> 
> Yes.
> 
> It will continue to work even if you dont change the call in the future. 
> This is more a 'let's not spread the code' attempt, but removing and re-adding
> page_pool_destroy() was/is our mess. We might as well live with the
> consequences!

So as someone who ends up doing some of this work after the trail has
already been blazed upstream on other drivers, etc, I definitely
understand the desire to keep things more common.  I think the page_pool
bits are a nice step in that direction, so I enjoy any attempts to help
make repeated tasks easier for everyone.

> 
> > 
> > > 
> > > > +			return rc;
> > > > +		}
> > > > +
> > > >  		rc = bnxt_alloc_ring(bp, &ring->ring_mem);
> > > >  		if (rc)
> > > >  			return rc;
> > > > @@ -10233,6 +10257,7 @@ static const struct net_device_ops bnxt_netdev_ops = {
> > > [...]
> > > 
> 
> Thanks!
> /Ilias
