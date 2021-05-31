Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E907E39596E
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 13:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhEaLJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 07:09:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230518AbhEaLJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 07:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622459247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IaDE8FBaVLPwZ3XaIcfWetPKdEKG+w4O7/4mL9L5gRk=;
        b=I3C0NhunHq79c1IBqVaqeiZQqJaqr07P5H3EBFSpxQiP663xYnUxtsy1DEE6F7r+j0RFAr
        1h9Lz6k1MenA1iW72QY4wMS8Ltc1FOHtfZqm2OEk8jw5+af7UAXyOcpOz9NcPNsL0QhYSA
        g3uleRSEkl3PPViOg4kMAWg4lZGzhQ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-UuYgMJwoP-2cWvT9PK8bCA-1; Mon, 31 May 2021 07:07:25 -0400
X-MC-Unique: UuYgMJwoP-2cWvT9PK8bCA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B1FC18766D0;
        Mon, 31 May 2021 11:07:24 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF70E101E24F;
        Mon, 31 May 2021 11:07:13 +0000 (UTC)
Date:   Mon, 31 May 2021 13:07:12 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Tom Herbert <tom@herbertland.com>, bpf@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        David Ahern <dsahern@gmail.com>, magnus.karlsson@intel.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        bjorn@kernel.org,
        "Maciej =?UTF-8?B?RmlqYcWCa293c2tp?= (Intel)" 
        <maciej.fijalkowski@intel.com>,
        john fastabend <john.fastabend@gmail.com>, brouer@redhat.com,
        XDP-hints working-group <xdp-hints@xdp-project.net>
Subject: Re: [RFC bpf-next 1/4] net: xdp: introduce flags field in xdp_buff
 and xdp_frame
Message-ID: <20210531130712.29232932@carbon>
In-Reply-To: <YLJC2ox7HmAL8dnX@lore-desk>
References: <cover.1622222367.git.lorenzo@kernel.org>
        <b5b2f560006cf5f56d67d61d5837569a0949d0aa.1622222367.git.lorenzo@kernel.org>
        <CALx6S34cmsFX6QwUq0sRpHok1j6ecBBJ7WC2BwjEmxok+CHjqg@mail.gmail.com>
        <YLJC2ox7HmAL8dnX@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 May 2021 15:34:18 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> > On Fri, May 28, 2021 at 10:44 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:  
> > >
> > > Introduce flag field in xdp_buff and xdp_frame data structure in order
> > > to report xdp_buffer metadata. For the moment just hw checksum hints
> > > are defined but flags field will be reused for xdp multi-buffer
> > > For the moment just CHECKSUM_UNNECESSARY is supported.
> > > CHECKSUM_COMPLETE will need to set csum value in metada space.
> > >  
> > Lorenzo,  
> 
> Hi Tom,
> 
> > 
> > This isn't sufficient for the checksum-unnecessary interface, we'd
> > also need ability to set csum_level for cases the device validated
> > more than one checksum.  
> 
> ack, right. I guess we can put this info in xdp metadata or do you
> think we can add it in xdp_buff/xdp_frame as well?

This is an interesting question as where do we draw the line.  I
definitely only don't want to add the same information in two places.

As is clear by the XDP-hints discussion: Today we are lacking *kernel*
infrastructure to interpret the XDP-metadata area when we create the
SKB from xdp_frame.  I want to add this capability...

(See XDP-hints discussion, as wisely pointed out by John, the BPF-prog
infrastructure to interpret XDP-metadata via BTF-info is already
available to userspace loading BPF-progs, but AFAIK the kernel is
lacking this capability. Maybe we will end-up loading BPF-progs that
populate SKB fields based on xdp_frame + XDP-metadata area... I'm
keeping an open mind for the solutions in this space.).

The question is really, should we wait for this infra (that can use
csum value from metadata) or should be go ahead and expand
xdp_buff/xdp_frame with an csum value (+ ip_summed) for the
CHECKSUM_COMPLETE use-case?

 
> > 
> > IMO, we shouldn't support CHECKSUM_UNNECESSARY for new uses like this.
> > For years now, the Linux community has been pleading with vendors to
> > provide CHECKSUM_COMPLETE which is far more useful and robust than
> > CHECSUM_UNNECESSARY, and yet some still haven't got with the program
> > even though we see more and more instances where CHECKSUM_UNNECESSARY
> > doesn't even work at all (e.g. cases with SRv6, new encaps device
> > doesn't understand). I believe it's time to take a stand! :-)  
> 
> I completely agree CHECKSUM_COMPLETE is more useful and robust than
> CHECSUM_UNNECESSARY and I want to add support for it as soon as we
> agree on the best way to do it. At the same time there are plenty of
> XDP NICs where this feature is quite useful since they support just
> CHECSUM_UNNECESSARY.
> 
> Regards,
> Lorenzo
> 
> > 
> > Tom
> >   
> > > Signed-off-by: David Ahern <dsahern@kernel.org>
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  include/net/xdp.h | 36 ++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 36 insertions(+)
> > >
> > > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > > index 5533f0ab2afc..e81ac505752b 100644
> > > --- a/include/net/xdp.h
> > > +++ b/include/net/xdp.h
> > > @@ -66,6 +66,13 @@ struct xdp_txq_info {
> > >         struct net_device *dev;
> > >  };
> > >
> > > +/* xdp metadata bitmask */
> > > +#define XDP_CSUM_MASK          GENMASK(1, 0)
> > > +enum xdp_flags {
> > > +       XDP_CSUM_UNNECESSARY    = BIT(0),
> > > +       XDP_CSUM_COMPLETE       = BIT(1),
> > > +};
> > > +
> > >  struct xdp_buff {
> > >         void *data;
> > >         void *data_end;
> > > @@ -74,6 +81,7 @@ struct xdp_buff {
> > >         struct xdp_rxq_info *rxq;
> > >         struct xdp_txq_info *txq;
> > >         u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
> > > +       u16 flags; /* xdp_flags */
> > >  };
> > >
> > >  static __always_inline void
> > > @@ -81,6 +89,7 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
> > >  {
> > >         xdp->frame_sz = frame_sz;
> > >         xdp->rxq = rxq;
> > > +       xdp->flags = 0;
> > >  }
> > >
> > >  static __always_inline void
> > > @@ -95,6 +104,18 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> > >         xdp->data_meta = meta_valid ? data : data + 1;
> > >  }
> > >
> > > +static __always_inline void
> > > +xdp_buff_get_csum(struct xdp_buff *xdp, struct sk_buff *skb)
> > > +{
> > > +       switch (xdp->flags & XDP_CSUM_MASK) {
> > > +       case XDP_CSUM_UNNECESSARY:
> > > +               skb->ip_summed = CHECKSUM_UNNECESSARY;
> > > +               break;
> > > +       default:
> > > +               break;
> > > +       }
> > > +}
> > > +
> > >  /* Reserve memory area at end-of data area.
> > >   *
> > >   * This macro reserves tailroom in the XDP buffer by limiting the
> > > @@ -122,8 +143,21 @@ struct xdp_frame {
> > >          */
> > >         struct xdp_mem_info mem;
> > >         struct net_device *dev_rx; /* used by cpumap */
> > > +       u16 flags; /* xdp_flags */
> > >  };
> > >
> > > +static __always_inline void
> > > +xdp_frame_get_csum(struct xdp_frame *xdpf, struct sk_buff *skb)
> > > +{
> > > +       switch (xdpf->flags & XDP_CSUM_MASK) {
> > > +       case XDP_CSUM_UNNECESSARY:
> > > +               skb->ip_summed = CHECKSUM_UNNECESSARY;
> > > +               break;
> > > +       default:
> > > +               break;
> > > +       }
> > > +}
> > > +
> > >  #define XDP_BULK_QUEUE_SIZE    16
> > >  struct xdp_frame_bulk {
> > >         int count;
> > > @@ -180,6 +214,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
> > >         xdp->data_end = frame->data + frame->len;
> > >         xdp->data_meta = frame->data - frame->metasize;
> > >         xdp->frame_sz = frame->frame_sz;
> > > +       xdp->flags = frame->flags;
> > >  }
> > >
> > >  static inline
> > > @@ -206,6 +241,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
> > >         xdp_frame->headroom = headroom - sizeof(*xdp_frame);
> > >         xdp_frame->metasize = metasize;
> > >         xdp_frame->frame_sz = xdp->frame_sz;
> > > +       xdp_frame->flags = xdp->flags;
> > >
> > >         return 0;
> > >  }
> > > --
> > > 2.31.1
> > >  



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

