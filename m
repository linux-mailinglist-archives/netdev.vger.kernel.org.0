Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920752D23E9
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgLHGuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 01:50:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgLHGuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 01:50:39 -0500
Message-ID: <7e086651b1f4a486548016a3a0a889b31b29f2cc.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607410198;
        bh=N7gDSXSjPYyJZG7733gytzJCcNwhjk3d9UYncHG6TKM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=taXehZVK4H6Ph4dVA4eJzvnZbzjc+yXq3/OdmWhJ1cCSExMEneKGvAeMZ2kh4B9vm
         0vODc2AMjrusLD0eFl15VVdOlf3ynLqLDW209ganTRwaq8AdTtEnPpBI9l+RNa+SZJ
         2V6l0lvt7FCBwX0Y+GUGBZm0jkSstJS8IMzDDaAi6v7DkOG5GyPelGjkn6dKgTd8nu
         dq3tI4KPA2nI8qPUqoPxHebaJkW4Awm8W+cpZpfsIysqL+ndPubqGdlpr2wABpVdEs
         25HJPWot4btqnsuEl7HBiD8zcbHOj+4EqZnb7CJqsItco8tNXksFbacQ/vG2JPJZl1
         QuPI31Av+KDPw==
Subject: Re: [PATCH v5 bpf-next 01/14] xdp: introduce mb in
 xdp_buff/xdp_frame
From:   Saeed Mahameed <saeed@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>, dsahern@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        lorenzo.bianconi@redhat.com, Jason Wang <jasowang@redhat.com>
Date:   Mon, 07 Dec 2020 22:49:55 -0800
In-Reply-To: <CAKgT0UeR8ErY4AOAiWxpR-j8QEs7GqCGrx58-7oaU3fnV=sU3Q@mail.gmail.com>
References: <cover.1607349924.git.lorenzo@kernel.org>
         <7e7dbe0c739640b053c930d3cd22ab7588d6aa3c.1607349924.git.lorenzo@kernel.org>
         <CAKgT0UdqajD_fJRnkRVM6HgSu=3EkUfXn7niqtqxceLUQbzt3w@mail.gmail.com>
         <46fae597d42d28a7246ba08b0652b0114b7f5255.camel@kernel.org>
         <CAKgT0UeR8ErY4AOAiWxpR-j8QEs7GqCGrx58-7oaU3fnV=sU3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-07 at 19:16 -0800, Alexander Duyck wrote:
> On Mon, Dec 7, 2020 at 3:03 PM Saeed Mahameed <saeed@kernel.org>
> wrote:
> > On Mon, 2020-12-07 at 13:16 -0800, Alexander Duyck wrote:
> > > On Mon, Dec 7, 2020 at 8:36 AM Lorenzo Bianconi <
> > > lorenzo@kernel.org>
> > > wrote:
> > > > Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer data
> > > > structure
> > > > in order to specify if this is a linear buffer (mb = 0) or a
> > > > multi-
> > > > buffer
> > > > frame (mb = 1). In the latter case the shared_info area at the
> > > > end
> > > > of the
> > > > first buffer is been properly initialized to link together
> > > > subsequent
> > > > buffers.
> > > > 
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  include/net/xdp.h | 8 ++++++--
> > > >  net/core/xdp.c    | 1 +
> > > >  2 files changed, 7 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > > > index 700ad5db7f5d..70559720ff44 100644
> > > > --- a/include/net/xdp.h
> > > > +++ b/include/net/xdp.h
> > > > @@ -73,7 +73,8 @@ struct xdp_buff {
> > > >         void *data_hard_start;
> > > >         struct xdp_rxq_info *rxq;
> > > >         struct xdp_txq_info *txq;
> > > > -       u32 frame_sz; /* frame size to deduce
> > > > data_hard_end/reserved tailroom*/
> > > > +       u32 frame_sz:31; /* frame size to deduce
> > > > data_hard_end/reserved tailroom*/
> > > > +       u32 mb:1; /* xdp non-linear buffer */
> > > >  };
> > > > 
> > > 
> > > If we are really going to do something like this I say we should
> > > just
> > > rip a swath of bits out instead of just grabbing one. We are
> > > already
> > > cutting the size down then we should just decide on the minimum
> > > size
> > > that is acceptable and just jump to that instead of just stealing
> > > one
> > > bit at a time. It looks like we already have differences between
> > > the
> > > size here and frame_size in xdp_frame.
> > > 
> > 
> > +1
> > 
> > > If we have to steal a bit why not look at something like one of
> > > the
> > > lower 2/3 bits in rxq? You could then do the same thing using
> > > dev_rx
> > > in a similar fashion instead of stealing from a bit that is
> > > likely to
> > > be used in multiple spots and modifying like this adds extra
> > > overhead
> > > to?
> > > 
> > 
> > What do you mean in rxq ? from the pointer ?
> 
> Yeah, the pointers have a few bits that are guaranteed 0 and in my
> mind reusing the lower bits from a 4 or 8 byte aligned pointer would
> make more sense then stealing the upper bits from the size of the
> frame.

Ha, i can't imagine how accessing that pointer would look like ..
is possible to define the pointer as a bit-field and just access it
normally ? or do we need to fix it up every time we need to access it ?
will gcc/static checkers complain about wrong pointer type ?


