Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA83C175681
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 10:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgCBJBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 04:01:17 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53173 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726313AbgCBJBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 04:01:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583139676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iyft2lSHWn+RjZVv7ZhLR++Pl5txr136rGLbMvS8fIY=;
        b=PO99G6PIC7ogYPTSViu6tYbjU64RDx/p5bNZtOU+99VttGtiFSdnuMimKfawAQmehLVvPT
        qcdMeNcYFfftfId3yGpw1nha1PM/VO7hcbhDHapMKsUuvswIZQiIqf+C7emfi7njhUCUJi
        1/BWJCbiUE/TyPSFP0dVuDTzBzEFWdM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-02lk1FgOOWalxN2a8vSAmQ-1; Mon, 02 Mar 2020 04:01:07 -0500
X-MC-Unique: 02lk1FgOOWalxN2a8vSAmQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC193107ACCD;
        Mon,  2 Mar 2020 09:01:05 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E50AE27181;
        Mon,  2 Mar 2020 09:01:00 +0000 (UTC)
Date:   Mon, 2 Mar 2020 10:00:59 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        brouer@redhat.com, "Jubran, Samih" <sameehj@amazon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [Intel-wired-lan] [net-next PATCH] ixgbe: fix XDP redirect on
 archs with PAGE_SIZE above 4K
Message-ID: <20200302100059.58763d59@carbon>
In-Reply-To: <CAKgT0Udj=BRNh3=TkNk5XyY5zbXtY_3kw+VORspUZLhvUFDN+w@mail.gmail.com>
References: <158289240414.1877500.8426359194461700361.stgit@firesoul>
        <CAKgT0Udj=BRNh3=TkNk5XyY5zbXtY_3kw+VORspUZLhvUFDN+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 10:53:58 -0800
Alexander Duyck <alexander.duyck@gmail.com> wrote:

> On Fri, Feb 28, 2020 at 4:20 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > The ixgbe driver have another memory model when compiled on archs with
> > PAGE_SIZE above 4096 bytes. In this mode it doesn't split the page in
> > two halves, but instead increment rx_buffer->page_offset by truesize of
> > packet (which include headroom and tailroom for skb_shared_info).
> >
> > This is done correctly in ixgbe_build_skb(), but in ixgbe_rx_buffer_flip
> > which is currently only called on XDP_TX and XDP_REDIRECT, it forgets
> > to add the tailroom for skb_shared_info. This breaks XDP_REDIRECT, for
> > veth and cpumap.  Fix by adding size of skb_shared_info tailroom.
> >
> > Fixes: 6453073987ba ("ixgbe: add initial support for xdp redirect")
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>  
> 
> This approach to fixing it seems problematic at best. From what I can
> tell there wasn't an issue until this frame gets up into the
> XDP_REDIRECT path. In the case of XDP_TX the ixgbe driver has not need
> for the extra shared info space. I assume you need this because you
> are converting the buffer to an skbuff.

Except for XDP_TX the extra space is needed (and for our planned
multi-frame XDP it will also be needed for XDP_TX). The XDP_PASS case
does the correct thing in ixgbe_build_skb(). The XDP_REDIRECT also
depend on this extra space for skb_shared_info, as cpumap and veth
creates SKBs based on xdp_frame, which I want to generalize further[1].


> The question I have is exactly how is this failing, are we talking
> about it resulting in the region being shared with the next frame, or
> is it being correctly identified that there is no tailroom and the
> frame is dropped? If we are seeing memory corruption due to it sharing
> the memory I would say we have a problem with the design for

(Sorry for this rant:)
The design was violated when ixgbe added XDP-support, as it complicated
the XDP-memory model, with it's split-page approach, and now I realize
that is even more complicated, with this bigger PAGE_SIZE approach.
One of the XDP performance advantage comes from a simplified memory
model.  I'm very tempted to disable XDP on this driver for PAGE_SIZE
above 4096 bytes.


> XDP_REDIRECT since it is assuming things about the buffer that may or
> may not be true. At a minimum we are going to need to guarantee that
> all XDP devices going forward provide this padding on the end of the
> frame which has not been anything that was communicated up until now.

First of all, I'm working on patches for "data_hard_end" such that we
can reliably establish the size of the frame / memory, and there by
know the size of the padding / tailroom. (Which is why I discovered
this bug).

Second, it have been communicated since day-1, that XDP drivers need to
use build_skb(), and we have converted every XDP driver to build_skb
before adding XDP support. Thus, this tailroom requirement should not
be a surprise.

 
> I would argue that we should not be using build_skb on XDP buffers
> since it is going to lead to similar issues in the future. It would be
> much better to simply add the XDP frame as a fragment and to pull the
> headers as we have done in the past.

No, absolutely not. Again this will complicate and slowdown SKB
creation (as you know, this would require allocating a new memory area
for skb_shared_info (+ the SKB), while with the tailroom provided anyhow
for build_skb, we can avoid this extra allocation).

 
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c index
> > 718931d951bc..ea6834bae04c 100644 ---
> > a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c +++
> > b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c @@ -2254,7 +2254,8
> > @@ static void ixgbe_rx_buffer_flip(struct ixgbe_ring *rx_ring,
> > rx_buffer->page_offset ^= truesize; #else
> >         unsigned int truesize = ring_uses_build_skb(rx_ring) ?
> > -                               SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) :
> > +                               SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) +
> > +                               SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
> >                                 SKB_DATA_ALIGN(size);
> >
> >         rx_buffer->page_offset += truesize;


[1] http://people.netfilter.org/hawk/presentations/KernelRecipes2019/xdp-netstack-concert.pdf
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

