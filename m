Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2B31A7F19
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 16:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388819AbgDNOCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 10:02:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29945 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388386AbgDNOCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 10:02:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586872959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FE3q1BI1gQoIqjmh4SbHpCJasYqDCUKlT257lwdOsbE=;
        b=U45purIUEK/OE9SSRqV1JgXUr8Vda4NFljpzcYN0aVW4gjedo2r0iTXBxLGjfgGpSEKv5T
        cAU0dRNmLr6sZA+je/2RtZ7D3D3GWKV7X5FjLqM9m6vvmYYfyNc2XdZdLwqYdYSZ/1bJF9
        4rGUoKi1Hlw5NFlJCs03TIdT4olEMT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-zLPZV4J7M6qON3a4Qvf55A-1; Tue, 14 Apr 2020 10:02:35 -0400
X-MC-Unique: zLPZV4J7M6qON3a4Qvf55A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C054800D5C;
        Tue, 14 Apr 2020 14:02:33 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EE29385;
        Tue, 14 Apr 2020 14:02:22 +0000 (UTC)
Date:   Tue, 14 Apr 2020 16:02:20 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>, brouer@redhat.com
Subject: Re: [PATCH RFC v2 19/33] nfp: add XDP frame size to netronome
 driver
Message-ID: <20200414160220.7d0f94c8@carbon>
In-Reply-To: <20200408105344.11d1a33f@kicinski-fedora-PC1C0HJN>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634673086.707275.8905781490793267908.stgit@firesoul>
        <20200408105344.11d1a33f@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020 10:53:44 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Wed, 08 Apr 2020 13:52:10 +0200 Jesper Dangaard Brouer wrote:
> > The netronome nfp driver already had a true_bufsz variable
> > that contains what was needed for xdp.frame_sz.
> > 
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  .../net/ethernet/netronome/nfp/nfp_net_common.c    |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > index 9bfb3b077bc1..b9b8c30eab33 100644
> > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > @@ -1817,6 +1817,7 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
> >  	rcu_read_lock();
> >  	xdp_prog = READ_ONCE(dp->xdp_prog);
> >  	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
> > +	xdp.frame_sz = true_bufsz;  
> 
> Since this matters only with XDP on - we can set to PAGE_SIZE directly?

Well the value was already calculate for us in true_bufsz, but I can
change that.

> But more importantly the correct value is:
> 
> 	PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM

Thanks for catching that. I will fix.

> as we set hard_start at an offset. 
> 
> 	xdp.data_hard_start = rxbuf->frag + NFP_NET_RX_BUF_HEADROOM;
> 
> Cause NFP_NET_RX_BUF_HEADROOM is not DMA mapped.
> 
> >  	xdp.rxq = &rx_ring->xdp_rxq;
> >  	tx_ring = r_vec->xdp_ring;  
> 

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

