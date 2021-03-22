Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C78344B7E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhCVQfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:35:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230267AbhCVQeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:34:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616430854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jb8929ImrhWw64cjQKAPFHChrKANTGxCdRngxnhmxDM=;
        b=FBnp/mkznYnOx3eKZf/+CKLx4k2X1VIfJsFeqgMk4mKPXTm2rScjlV4bXCMk1SNS43tg9I
        oHD5LgFS/h/9UAc73SEiow4Mbw2B8akhPAOxEkK3bt9lxYuYzZTl7k3DpJT/RovkeX2gqH
        5W0wp5rZ2nXJ7aRmEgeVWLhxu6dm8gY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-H0tfRH6xO3qSjBRJHCRJ-w-1; Mon, 22 Mar 2021 12:34:10 -0400
X-MC-Unique: H0tfRH6xO3qSjBRJHCRJ-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AC92107ACCD;
        Mon, 22 Mar 2021 16:34:08 +0000 (UTC)
Received: from ovpn-115-44.ams2.redhat.com (ovpn-115-44.ams2.redhat.com [10.36.115.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6972910023AB;
        Mon, 22 Mar 2021 16:34:06 +0000 (UTC)
Message-ID: <43f56578c91f8abd8e3d1e8c73be1c4d5162089f.camel@redhat.com>
Subject: Re: [PATCH net-next 1/8] udp: fixup csum for GSO receive slow path
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Mon, 22 Mar 2021 17:34:05 +0100
In-Reply-To: <CA+FuTScSPJAh+6XnwnP32W+OmEzCVi8aKundnt2dJNzoKgUthg@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <4bff28fbaa8c53ca836eb2b9bdabcc3057118916.1616345643.git.pabeni@redhat.com>
         <CA+FuTScSPJAh+6XnwnP32W+OmEzCVi8aKundnt2dJNzoKgUthg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-22 at 09:18 -0400, Willem de Bruijn wrote:
> On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > When looping back UDP GSO over UDP tunnel packets to an UDP socket,
> > the individual packet csum is currently set to CSUM_NONE. That causes
> > unexpected/wrong csum validation errors later in the UDP receive path.
> > 
> > We could possibly addressing the issue with some additional check and
> > csum mangling in the UDP tunnel code. Since the issue affects only
> > this UDP receive slow path, let's set a suitable csum status there.
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  include/net/udp.h | 18 ++++++++++++++++++
> >  net/ipv4/udp.c    | 10 ++++++++++
> >  net/ipv6/udp.c    |  5 +++++
> >  3 files changed, 33 insertions(+)
> > 
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index d4d064c592328..007683eb3e113 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -515,6 +515,24 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
> >         return segs;
> >  }
> > 
> > +static inline void udp_post_segment_fix_csum(struct sk_buff *skb, int level)
> > +{
> > +       /* UDP-lite can't land here - no GRO */
> > +       WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
> > +
> > +       /* GRO already validated the csum up to 'level', and we just
> > +        * consumed one header, update the skb accordingly
> > +        */
> > +       UDP_SKB_CB(skb)->cscov = skb->len;
> > +       if (level) {
> > +               skb->ip_summed = CHECKSUM_UNNECESSARY;
> > +               skb->csum_level = 0;
> > +       } else {
> > +               skb->ip_summed = CHECKSUM_NONE;
> > +               skb->csum_valid = 1;
> > +       }
> 
> why does this function also update these fields for non-tunneled
> packets? the commit only describes an issue with tunneled packets.
> 
> > +}
> > +
> >  #ifdef CONFIG_BPF_SYSCALL
> >  struct sk_psock;
> >  struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 4a0478b17243a..ff54135c51ffa 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -2168,6 +2168,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
> >  static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> >  {
> >         struct sk_buff *next, *segs;
> > +       int csum_level;
> >         int ret;
> > 
> >         if (likely(!udp_unexpected_gso(sk, skb)))
> > @@ -2175,9 +2176,18 @@ static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > 
> >         BUILD_BUG_ON(sizeof(struct udp_skb_cb) > SKB_GSO_CB_OFFSET);
> >         __skb_push(skb, -skb_mac_offset(skb));
> > +       csum_level = !!(skb_shinfo(skb)->gso_type &
> > +                       (SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM));
> >         segs = udp_rcv_segment(sk, skb, true);
> >         skb_list_walk_safe(segs, skb, next) {
> >                 __skb_pull(skb, skb_transport_offset(skb));
> > +
> > +               /* UDP GSO packets looped back after adding UDP encap land here with CHECKSUM none,
> > +                * instead of adding another check in the tunnel fastpath, we can force valid
> > +                * csums here (packets are locally generated).
> > +                * Additionally fixup the UDP CB
> > +                */
> > +               udp_post_segment_fix_csum(skb, csum_level);
> 
> How does this code differentiates locally generated packets with udp
> tunnel headers from packets arriving from the wire, for which the
> inner checksum may be incorrect?

First thing first, thank you for the detailed review. Digesting all the
comments will take time, so please excuse for some latency.

I'll try to reply to both your question here because the replies are
related.

My understanding is that UDP GRO, when processing UDP over UDP traffic
with the appropriate features bit set, will validate the checksum for
both the inner and the outer header - udp{4,6}_gro_receive will be
traversed twice, the fist one for the outer header, the 2nd for the
inner.

So when we reach here, the inner header csum could not be incorrect,
and I don't do anything to differentiate locally generated GSO packets
and GROed one to keep the code simpler.

The udp_post_segment_fix_csum() always set the csum info - even for non
tunneled packets to avoid additional branches/make the code more
complex. The csum should be valid in any scenario.

I guess I can mention the above either in a code comment and/or in the
commit message.

Cheers,

Paolo

