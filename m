Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8FE135F29
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731598AbgAIRUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:20:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44842 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729640AbgAIRUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 12:20:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578590450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ucB752yssrohbup/J+O3ByH9bMLKOm7Zb2Wlu8+ijI=;
        b=H/91dArg/Gc6jCiVC86HrLeaDx43zZNn91WW2YA20gm6K/hkAMnFInKIZLe1Jseu/64Ldf
        P6tFJbxEGiGasVIlHXR5ydXid3YOVYQdtBNCub+XJmbcfXxUIlpuhFQM4o8DYkmxaWGJJM
        Yx8NEbrmW/VcaBVN50tHuF6VHcz/gb0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-S_QrlJ33M1a44MZs0Lw1EQ-1; Thu, 09 Jan 2020 12:20:48 -0500
X-MC-Unique: S_QrlJ33M1a44MZs0Lw1EQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15C4D1800D4E;
        Thu,  9 Jan 2020 17:20:47 +0000 (UTC)
Received: from carbon (ovpn-200-30.brq.redhat.com [10.40.200.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E649E10013A7;
        Thu,  9 Jan 2020 17:20:39 +0000 (UTC)
Date:   Thu, 9 Jan 2020 18:20:38 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: Re: [PATCH] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200109182038.3840b285@carbon>
In-Reply-To: <20200108145322.GA2975@apalos.home>
References: <5ed1bbf3e27f5b0105346838dfe405670183d723.1578410912.git.lorenzo@kernel.org>
        <20200108145322.GA2975@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jan 2020 16:53:22 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> Hi Lorenzo, 
> 
> On Tue, Jan 07, 2020 at 04:30:32PM +0100, Lorenzo Bianconi wrote:
> > Socionext driver can run on dma coherent and non-coherent devices.
> > Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data since
> > now the driver can let page_pool API to managed needed DMA sync
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/socionext/netsec.c | 45 +++++++++++++++----------
> >  1 file changed, 28 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> > index b5a9e947a4a8..00404fef17e8 100644
> > --- a/drivers/net/ethernet/socionext/netsec.c
> > +++ b/drivers/net/ethernet/socionext/netsec.c

[...]
> > @@ -734,9 +734,7 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
> >  	/* Make sure the incoming payload fits in the page for XDP and non-XDP
> >  	 * cases and reserve enough space for headroom + skb_shared_info
> >  	 */
> > -	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
> > -	dma_dir = page_pool_get_dma_dir(dring->page_pool);
> > -	dma_sync_single_for_device(priv->dev, *dma_handle, *desc_len, dma_dir);
> > +	*desc_len = NETSEC_RX_BUF_SIZE;
> >  
> >  	return page_address(page);
> >  }
> > @@ -883,6 +881,7 @@ static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
> >  static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
> >  			  struct xdp_buff *xdp)
> >  {
> > +	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> >  	u32 ret = NETSEC_XDP_PASS;
> >  	int err;
> >  	u32 act;
> > @@ -896,7 +895,10 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
> >  	case XDP_TX:
> >  		ret = netsec_xdp_xmit_back(priv, xdp);
> >  		if (ret != NETSEC_XDP_TX)
> > -			xdp_return_buff(xdp);
> > +			__page_pool_put_page(dring->page_pool,
> > +				     virt_to_head_page(xdp->data),
> > +				     xdp->data_end - xdp->data_hard_start,  
> 
> Do we have to include data_hard_start?

That does look wrong.

> @Jesper i know bpf programs can modify the packet, but isn't it safe
> to only sync for xdp->data_end - xdp->data in this case since the DMA transfer
> in this driver will always start *after* the XDP headroom?

I agree.

For performance it is actually important that we avoid "cache-flushing"
(which what happens on these non-coherent devices) the headroom.  As the
headroom is used for e.g. storing xdp_frame.


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

