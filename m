Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A801374DC
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgAJRdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:33:40 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57859 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726696AbgAJRdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 12:33:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578677619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P0yrw4PFggndqV8WTQ+RFTNzi56EoD66CCsYHKmLvlo=;
        b=VGj2nAVvclYFB6dXoysPT6Wng+tyvH5XclO1TcEF/3CfjNIPAYi5S5TXXgaCFwWT7Bs0pp
        g1Sngxw3iErmGvWblHUM2ZUYLMyS0O8AqQ+3aboR/1bhbDqZQc97hAgf1DJ3S1ae9obuV+
        7S38jMJE/L77Jj8vjBfHTJV0Ry4uI7M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-E7GP9qgGNXKj-2EAFpxjRQ-1; Fri, 10 Jan 2020 12:33:37 -0500
X-MC-Unique: E7GP9qgGNXKj-2EAFpxjRQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86957593AA;
        Fri, 10 Jan 2020 17:33:36 +0000 (UTC)
Received: from carbon (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83C6B5C541;
        Fri, 10 Jan 2020 17:33:29 +0000 (UTC)
Date:   Fri, 10 Jan 2020 18:33:28 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: Re: [PATCH v2 net-next] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200110183328.219ed2bd@carbon>
In-Reply-To: <20200110153413.GA31419@localhost.localdomain>
References: <81eeb4aaf1cbbbdcd4f58c5a7f06bdab67f20633.1578664483.git.lorenzo@kernel.org>
        <20200110145631.GA69461@apalos.home>
        <20200110153413.GA31419@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 16:34:13 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> > On Fri, Jan 10, 2020 at 02:57:44PM +0100, Lorenzo Bianconi wrote:  
> > > Socionext driver can run on dma coherent and non-coherent devices.
> > > Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data since
> > > now the driver can let page_pool API to managed needed DMA sync
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > > Changes since v1:
> > > - rely on original frame size for dma sync
> > > ---
> > >  drivers/net/ethernet/socionext/netsec.c | 43 +++++++++++++++----------
> > >  1 file changed, 26 insertions(+), 17 deletions(-)
> > >   
> 
> [...]
> 
> > > @@ -883,6 +881,8 @@ static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
> > >  static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
> > >  			  struct xdp_buff *xdp)
> > >  {
> > > +	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> > > +	unsigned int len = xdp->data_end - xdp->data;  
> > 
> > We need to account for XDP expanding the headers as well here. 
> > So something like max(xdp->data_end(before bpf), xdp->data_end(after bpf)) -
> > xdp->data (original)  
> 
> correct, the corner case that is not covered at the moment is when data_end is
> moved forward by the bpf program. I will fix it in v3. Thx

Maybe we can simplify do:

 void *data_start = NETSEC_RXBUF_HEADROOM + xdp->data_hard_start;
 unsigned int len = xdp->data_end - data_start;

The cache-lines that need to be flushed/synced for_device is the area
used by NIC DMA engine.  We know it will always start at a certain
point (given driver configured hardware to this).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

