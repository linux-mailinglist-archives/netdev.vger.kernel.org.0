Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D30D8F23
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392694AbfJPLRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:17:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389063AbfJPLRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 07:17:00 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A500D51EF3;
        Wed, 16 Oct 2019 11:17:00 +0000 (UTC)
Received: from carbon (ovpn-200-46.brq.redhat.com [10.40.200.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B00A65C548;
        Wed, 16 Oct 2019 11:16:40 +0000 (UTC)
Date:   Wed, 16 Oct 2019 13:16:38 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        matteo.croce@redhat.com, mw@semihalf.com, brouer@redhat.com
Subject: Re: [PATCH v3 net-next 8/8] net: mvneta: add XDP_TX support
Message-ID: <20191016131638.7b489b1e@carbon>
In-Reply-To: <20191016105506.GA19689@apalos.home>
References: <cover.1571049326.git.lorenzo@kernel.org>
        <a964f1a704f194169e80f9693cf3150adffc1278.1571049326.git.lorenzo@kernel.org>
        <20191015171152.41d9a747@cakuba.netronome.com>
        <20191016100900.GE2638@localhost.localdomain>
        <20191016105506.GA19689@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 16 Oct 2019 11:17:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 13:55:06 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> On Wed, Oct 16, 2019 at 12:09:00PM +0200, Lorenzo Bianconi wrote:
> > > On Mon, 14 Oct 2019 12:49:55 +0200, Lorenzo Bianconi wrote:  
> > > > Implement XDP_TX verdict and ndo_xdp_xmit net_device_ops function
> > > > pointer
> > > > 
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>  
> > >   
> > > > @@ -1972,6 +1975,109 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
> > > >  	return i;
> > > >  }
> > > >  
> > > > +static int
> > > > +mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
> > > > +			struct xdp_frame *xdpf, bool dma_map)
> > > > +{
> > > > +	struct mvneta_tx_desc *tx_desc;
> > > > +	struct mvneta_tx_buf *buf;
> > > > +	dma_addr_t dma_addr;
> > > > +
> > > > +	if (txq->count >= txq->tx_stop_threshold)
> > > > +		return MVNETA_XDP_CONSUMED;
> > > > +
> > > > +	tx_desc = mvneta_txq_next_desc_get(txq);
> > > > +
> > > > +	buf = &txq->buf[txq->txq_put_index];
> > > > +	if (dma_map) {
> > > > +		/* ndo_xdp_xmit */
> > > > +		dma_addr = dma_map_single(pp->dev->dev.parent, xdpf->data,
> > > > +					  xdpf->len, DMA_TO_DEVICE);
> > > > +		if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
> > > > +			mvneta_txq_desc_put(txq);
> > > > +			return MVNETA_XDP_CONSUMED;
> > > > +		}
> > > > +		buf->type = MVNETA_TYPE_XDP_NDO;
> > > > +	} else {
> > > > +		struct page *page = virt_to_page(xdpf->data);
> > > > +
> > > > +		dma_addr = page_pool_get_dma_addr(page) +
> > > > +			   pp->rx_offset_correction + MVNETA_MH_SIZE;
> > > > +		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
> > > > +					   xdpf->len, DMA_BIDIRECTIONAL);  
> > > 
> > > This looks a little suspicious, XDP could have moved the start of frame
> > > with adjust_head, right? You should also use xdpf->data to find where
> > > the frame starts, no?  
> > 
> > uhm, right..we need to update the dma_addr doing something like:
> > 
> > dma_addr = page_pool_get_dma_addr(page) + xdpf->data - xdpf;  
> 
> Can we do  page_pool_get_dma_addr(page) + xdpf->headroom as well right?

We actually have to do:
 page_pool_get_dma_addr(page) + xdpf->headroom + sizeof(struct xdp_frame)

As part of part of headroom was reserved to xdpf.  I've considered
several times to change xdpf->headroom to include sizeof(struct xdp_frame)
as use-cases (e.g. in veth and cpumap) ended needing the "full" headroom.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
