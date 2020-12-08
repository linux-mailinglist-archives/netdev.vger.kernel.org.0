Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3A22D2816
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgLHJsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:48:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbgLHJsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:48:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607420848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Td5tBLVrRbHlvpiNNg7KTYun16ZSC0aplFNfU/yQNXM=;
        b=NCinquphD02jyssospxMeS7uco/+SPgGkU/mY+bPFu1xWF9SQcvTAVqqHxU29LsN+5owVP
        74VeAzIPJM/Z9TZyZqr3WaqiDCGGu4j8Bf9mrsxrkos7XmxGYlcLRcdiWVT7bwxpo3tj2C
        jlXsxCv3IErQ6Lp+2CQW8HZKwLDpm1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-PMvJg8UxP5-fNGYzIHvHXg-1; Tue, 08 Dec 2020 04:47:24 -0500
X-MC-Unique: PMvJg8UxP5-fNGYzIHvHXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B922180A097;
        Tue,  8 Dec 2020 09:47:22 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A43160636;
        Tue,  8 Dec 2020 09:47:12 +0000 (UTC)
Date:   Tue, 8 Dec 2020 10:47:11 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>, dsahern@kernel.org,
        Eelco Chaudron <echaudro@redhat.com>,
        lorenzo.bianconi@redhat.com, Jason Wang <jasowang@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCH v5 bpf-next 01/14] xdp: introduce mb in
 xdp_buff/xdp_frame
Message-ID: <20201208104711.422f5f86@carbon>
In-Reply-To: <7e086651b1f4a486548016a3a0a889b31b29f2cc.camel@kernel.org>
References: <cover.1607349924.git.lorenzo@kernel.org>
        <7e7dbe0c739640b053c930d3cd22ab7588d6aa3c.1607349924.git.lorenzo@kernel.org>
        <CAKgT0UdqajD_fJRnkRVM6HgSu=3EkUfXn7niqtqxceLUQbzt3w@mail.gmail.com>
        <46fae597d42d28a7246ba08b0652b0114b7f5255.camel@kernel.org>
        <CAKgT0UeR8ErY4AOAiWxpR-j8QEs7GqCGrx58-7oaU3fnV=sU3Q@mail.gmail.com>
        <7e086651b1f4a486548016a3a0a889b31b29f2cc.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Dec 2020 22:49:55 -0800
Saeed Mahameed <saeed@kernel.org> wrote:

> On Mon, 2020-12-07 at 19:16 -0800, Alexander Duyck wrote:
> > On Mon, Dec 7, 2020 at 3:03 PM Saeed Mahameed <saeed@kernel.org>
> > wrote:  
> > > On Mon, 2020-12-07 at 13:16 -0800, Alexander Duyck wrote:  
> > > > On Mon, Dec 7, 2020 at 8:36 AM Lorenzo Bianconi <  
> > > > lorenzo@kernel.org>  
> > > > wrote:  
> > > > > Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer data
> > > > > structure
> > > > > in order to specify if this is a linear buffer (mb = 0) or a
> > > > > multi-
> > > > > buffer
> > > > > frame (mb = 1). In the latter case the shared_info area at the
> > > > > end
> > > > > of the
> > > > > first buffer is been properly initialized to link together
> > > > > subsequent
> > > > > buffers.
> > > > > 
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > ---
> > > > >  include/net/xdp.h | 8 ++++++--
> > > > >  net/core/xdp.c    | 1 +
> > > > >  2 files changed, 7 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > > > > index 700ad5db7f5d..70559720ff44 100644
> > > > > --- a/include/net/xdp.h
> > > > > +++ b/include/net/xdp.h
> > > > > @@ -73,7 +73,8 @@ struct xdp_buff {
> > > > >         void *data_hard_start;
> > > > >         struct xdp_rxq_info *rxq;
> > > > >         struct xdp_txq_info *txq;
> > > > > -       u32 frame_sz; /* frame size to deduce
> > > > > data_hard_end/reserved tailroom*/
> > > > > +       u32 frame_sz:31; /* frame size to deduce
> > > > > data_hard_end/reserved tailroom*/
> > > > > +       u32 mb:1; /* xdp non-linear buffer */
> > > > >  };
> > > > >   
> > > > 
> > > > If we are really going to do something like this I say we should
> > > > just
> > > > rip a swath of bits out instead of just grabbing one. We are
> > > > already
> > > > cutting the size down then we should just decide on the minimum
> > > > size
> > > > that is acceptable and just jump to that instead of just stealing
> > > > one
> > > > bit at a time. It looks like we already have differences between
> > > > the
> > > > size here and frame_size in xdp_frame.
> > > >   
> > > 
> > > +1
> > >   
> > > > If we have to steal a bit why not look at something like one of
> > > > the
> > > > lower 2/3 bits in rxq? You could then do the same thing using
> > > > dev_rx
> > > > in a similar fashion instead of stealing from a bit that is
> > > > likely to
> > > > be used in multiple spots and modifying like this adds extra
> > > > overhead
> > > > to?
> > > >   
> > > 
> > > What do you mean in rxq ? from the pointer ?  
> > 
> > Yeah, the pointers have a few bits that are guaranteed 0 and in my
> > mind reusing the lower bits from a 4 or 8 byte aligned pointer would
> > make more sense then stealing the upper bits from the size of the
> > frame.  
> 
> Ha, i can't imagine how accessing that pointer would look like ..
> is possible to define the pointer as a bit-field and just access it
> normally ? or do we need to fix it up every time we need to access it ?
> will gcc/static checkers complain about wrong pointer type ?

This is a pattern that is used all over the kernel.  Yes, it needs to
be fixed it up every time we access it.  In this case, we don't want to
to deploy this trick.  For two reason, (1) rxq is accessed by BPF
byte-code rewrite (which would also need to handle masking out the
bit), (2) this optimization is trading CPU cycles for saving space.

IIRC Alexei have already pointed out that the change to struct xdp_buff
looks suboptimal.  Why don't you simply add a u8 with the info.

The general point is that struct xdp_buff layout is for fast access,
and struct xdp_frame is a state compressed version of xdp_buff.  (Still
room in xdp_buff is limited to 64 bytes - one cacheline, which is
rather close according to pahole)

Thus, it is more okay to do these bit tricks in struct xdp_frame.  For
xdp_frame, it might be better to take some room/space from the member
'mem' (struct xdp_mem_info).  (Would it help later that multi-buffer
bit is officially part of struct xdp_mem_info, when later freeing the
memory backing the frame?)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

$ pahole -C xdp_buff
struct xdp_buff {
	void *                     data;                 /*     0     8 */
	void *                     data_end;             /*     8     8 */
	void *                     data_meta;            /*    16     8 */
	void *                     data_hard_start;      /*    24     8 */
	struct xdp_rxq_info *      rxq;                  /*    32     8 */
	struct xdp_txq_info *      txq;                  /*    40     8 */
	u32                        frame_sz;             /*    48     4 */

	/* size: 56, cachelines: 1, members: 7 */
	/* padding: 4 */
	/* last cacheline: 56 bytes */
};

$ pahole -C xdp_frame
struct xdp_frame {
	void *                     data;                 /*     0     8 */
	u16                        len;                  /*     8     2 */
	u16                        headroom;             /*    10     2 */
	u32                        metasize:8;           /*    12: 0  4 */
	u32                        frame_sz:24;          /*    12: 8  4 */
	struct xdp_mem_info        mem;                  /*    16     8 */
	struct net_device *        dev_rx;               /*    24     8 */

	/* size: 32, cachelines: 1, members: 7 */
	/* last cacheline: 32 bytes */
};

$ pahole -C xdp_mem_info
struct xdp_mem_info {
	u32                        type;                 /*     0     4 */
	u32                        id;                   /*     4     4 */

	/* size: 8, cachelines: 1, members: 2 */
	/* last cacheline: 8 bytes */
};

