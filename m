Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A78146B2F
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 15:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgAWOY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 09:24:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgAWOY0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 09:24:26 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF19E20663;
        Thu, 23 Jan 2020 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579789466;
        bh=xFQwkrQkJM1zr/yye3oA81cSFgvlpcKjrpTFqPRDY74=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eM/qNbs0sAkXXI4eT3fwihD+Bpl61tCowewk2B42RkVv11HJKmINATAKoOqkjx/uR
         YaDlGLpKFsyG5QdqtuWe4eOMJrojssaZrObB4kF3mUA05nl9C9BSEAKCGFYlruzXQl
         AsvPGLoLelHWfGAce9iC6MW9BS8ARrPPUOME5uvI=
Date:   Thu, 23 Jan 2020 06:24:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: Re: [PATCH v4 07/17] octeontx2-pf: Add packet transmission support
Message-ID: <20200123062425.41e6d8ae@cakuba>
In-Reply-To: <CA+sq2CdX31cqsSc=qRhbcZ5fOk2zGOrhTMGqhsPddbhW=YQPCQ@mail.gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579612911-24497-8-git-send-email-sunil.kovvuri@gmail.com>
        <20200121085425.652eae8c@cakuba>
        <CA+sq2CdX31cqsSc=qRhbcZ5fOk2zGOrhTMGqhsPddbhW=YQPCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 01:20:51 +0530, Sunil Kovvuri wrote:
> > Why do you care about big endian bitfields tho, if you don't care about
> > endianness of the data itself?  
> 
> At this point of time we are not addressing big endian functionality,
> so few things
> might be broken in that aspect. If it's preferred to remove, i will remove it.

Yes, I think removing it would be cleaner than having it partially
working. The driver depends on ARM64, anyway.

> > > +};
> > > +
> > >  #endif /* OTX2_STRUCT_H */
> > > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > > index e6be18d..f416603 100644
> > > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > > @@ -32,6 +32,78 @@ static struct nix_cqe_hdr_s *otx2_get_next_cqe(struct otx2_cq_queue *cq)
> > >       return cqe_hdr;
> > >  }
> > >  
> >> > +static void otx2_sqe_flush(struct otx2_snd_queue *sq, int size)  
> > > +{
> > > +     u64 status;
> > > +
> > > +     /* Packet data stores should finish before SQE is flushed to HW */  
> >
> > Packet data is synced by the dma operations the barrier shouldn't be
> > needed AFAIK (and if it would be, dma_wmb() would not be the one, as it
> > only works for iomem AFAIU).
> >  
> > > +     dma_wmb();  
> 
> Due to out of order execution by CPU, HW folks have suggested add a barrier
> to avoid scenarios where packet is transmitted before all stores from
> CPU are committed.
> On arm64 a dmb() is less costlier than a dsb() barrier and as per HW
> folks a dmb(st)
> is sufficient to ensure all stores from CPU are committed. And
> dma_wmb() uses dmb(st)
> hence it is used. It's more of choice of architecture specific
> instruction rather than the API.

Hmm.. I'm not a DMA API expert but AFAIU it'd be a serious bug if
dma_map..() APIs didn't guarantee that packet data is written out.
Not only out of the CPU store buffer but also the caches to DRAM.
