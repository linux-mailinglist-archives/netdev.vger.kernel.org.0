Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69AF2D1E15
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgLGXEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLGXEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 18:04:33 -0500
Message-ID: <46fae597d42d28a7246ba08b0652b0114b7f5255.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607382232;
        bh=fM+O/WR41trw+NG2tUUwmVhy9gXMCTKKQWVmHVVFyvw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=N2eCvCHgNELZiWxjpgV1pqabML0XS10ywwywiFmRJtp+pxunxPaGFoHxiCvfCw5A+
         ot3nq0lGOMYDTEx08S8erkkNxl849ucReUuGj647JYFW56TTWgn2XEaylUMVHMxWWp
         4vHddZ1bF7gSjj9ZmZ23nG7Ps+HNW+lj2mdh/dKprhruNr9DCWEBBglFOzEowmlT0x
         Zbi+7cXMbjNCVMhSrMBu677Dy+RtMc+sxJ1/xfuNwuznrdQwlTvISapTzfsf/9CjoS
         SEpw+adcAPU2NbFDiNBTr/TQkHxqcIfN5TXD1CP64ANXaKfH0rMByENDyq3hlpzjOR
         OrTeA/bBOzhRQ==
Subject: Re: [PATCH v5 bpf-next 01/14] xdp: introduce mb in
 xdp_buff/xdp_frame
From:   Saeed Mahameed <saeed@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>, dsahern@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        lorenzo.bianconi@redhat.com, Jason Wang <jasowang@redhat.com>
Date:   Mon, 07 Dec 2020 15:03:50 -0800
In-Reply-To: <CAKgT0UdqajD_fJRnkRVM6HgSu=3EkUfXn7niqtqxceLUQbzt3w@mail.gmail.com>
References: <cover.1607349924.git.lorenzo@kernel.org>
         <7e7dbe0c739640b053c930d3cd22ab7588d6aa3c.1607349924.git.lorenzo@kernel.org>
         <CAKgT0UdqajD_fJRnkRVM6HgSu=3EkUfXn7niqtqxceLUQbzt3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-07 at 13:16 -0800, Alexander Duyck wrote:
> On Mon, Dec 7, 2020 at 8:36 AM Lorenzo Bianconi <lorenzo@kernel.org>
> wrote:
> > Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer data
> > structure
> > in order to specify if this is a linear buffer (mb = 0) or a multi-
> > buffer
> > frame (mb = 1). In the latter case the shared_info area at the end
> > of the
> > first buffer is been properly initialized to link together
> > subsequent
> > buffers.
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/net/xdp.h | 8 ++++++--
> >  net/core/xdp.c    | 1 +
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 700ad5db7f5d..70559720ff44 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -73,7 +73,8 @@ struct xdp_buff {
> >         void *data_hard_start;
> >         struct xdp_rxq_info *rxq;
> >         struct xdp_txq_info *txq;
> > -       u32 frame_sz; /* frame size to deduce
> > data_hard_end/reserved tailroom*/
> > +       u32 frame_sz:31; /* frame size to deduce
> > data_hard_end/reserved tailroom*/
> > +       u32 mb:1; /* xdp non-linear buffer */
> >  };
> > 
> 
> If we are really going to do something like this I say we should just
> rip a swath of bits out instead of just grabbing one. We are already
> cutting the size down then we should just decide on the minimum size
> that is acceptable and just jump to that instead of just stealing one
> bit at a time. It looks like we already have differences between the
> size here and frame_size in xdp_frame.
> 

+1

> If we have to steal a bit why not look at something like one of the
> lower 2/3 bits in rxq? You could then do the same thing using dev_rx
> in a similar fashion instead of stealing from a bit that is likely to
> be used in multiple spots and modifying like this adds extra overhead
> to?
> 

What do you mean in rxq ? from the pointer ? 

