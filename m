Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951E7347AE1
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbhCXOhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:37:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236139AbhCXOhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 10:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616596637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FqiCJcFiyySqc+pxejHf9PO0CAP47YKq0+p2s0VGNOE=;
        b=fXFdzvKaHJmzsc0zo46DyyPu4nAZyLrcEDOpRWC6t9OobOdLibfF8rcO/m+RsSh06UdNlA
        QoaxW0JjVx401ZdUJh1VQqzpbhjv0HuveuE5GPSeZwgi7qAMbRalqdeQWisENeBg6msiuA
        WNJ1YSeJAu2gZ+kPY/lDrafhl3WZ5Js=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-xoTpbWnFPKGRqk-EAiqByA-1; Wed, 24 Mar 2021 10:37:12 -0400
X-MC-Unique: xoTpbWnFPKGRqk-EAiqByA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD315A40C0;
        Wed, 24 Mar 2021 14:37:10 +0000 (UTC)
Received: from ovpn-115-125.ams2.redhat.com (ovpn-115-125.ams2.redhat.com [10.36.115.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC95459472;
        Wed, 24 Mar 2021 14:37:08 +0000 (UTC)
Message-ID: <5143c873078583ef0f12d08ccf966d6b4640b9ee.camel@redhat.com>
Subject: Re: [PATCH net-next 1/8] udp: fixup csum for GSO receive slow path
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Wed, 24 Mar 2021 15:37:07 +0100
In-Reply-To: <CA+FuTSd6fOaj6bJssyXeyL-LWvSEdSH+QchHUG8Ga-=EQ634Lg@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <4bff28fbaa8c53ca836eb2b9bdabcc3057118916.1616345643.git.pabeni@redhat.com>
         <CA+FuTScSPJAh+6XnwnP32W+OmEzCVi8aKundnt2dJNzoKgUthg@mail.gmail.com>
         <43f56578c91f8abd8e3d1e8c73be1c4d5162089f.camel@redhat.com>
         <CA+FuTSd6fOaj6bJssyXeyL-LWvSEdSH+QchHUG8Ga-=EQ634Lg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-03-23 at 21:45 -0400, Willem de Bruijn wrote:
> On Mon, Mar 22, 2021 at 12:36 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Mon, 2021-03-22 at 09:18 -0400, Willem de Bruijn wrote:
> > > On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > When looping back UDP GSO over UDP tunnel packets to an UDP socket,
> > > > the individual packet csum is currently set to CSUM_NONE. That causes
> > > > unexpected/wrong csum validation errors later in the UDP receive path.
> > > > 
> > > > We could possibly addressing the issue with some additional check and
> > > > csum mangling in the UDP tunnel code. Since the issue affects only
> > > > this UDP receive slow path, let's set a suitable csum status there.
> > > > 
> > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > ---
> > > >  include/net/udp.h | 18 ++++++++++++++++++
> > > >  net/ipv4/udp.c    | 10 ++++++++++
> > > >  net/ipv6/udp.c    |  5 +++++
> > > >  3 files changed, 33 insertions(+)
> > > > 
> > > > diff --git a/include/net/udp.h b/include/net/udp.h
> > > > index d4d064c592328..007683eb3e113 100644
> > > > --- a/include/net/udp.h
> > > > +++ b/include/net/udp.h
> > > > @@ -515,6 +515,24 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
> > > >         return segs;
> > > >  }
> > > > 
> > > > +static inline void udp_post_segment_fix_csum(struct sk_buff *skb, int level)
> > > > +{
> > > > +       /* UDP-lite can't land here - no GRO */
> > > > +       WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
> > > > +
> > > > +       /* GRO already validated the csum up to 'level', and we just
> > > > +        * consumed one header, update the skb accordingly
> > > > +        */
> > > > +       UDP_SKB_CB(skb)->cscov = skb->len;
> > > > +       if (level) {
> > > > +               skb->ip_summed = CHECKSUM_UNNECESSARY;
> > > > +               skb->csum_level = 0;
> > > > +       } else {
> > > > +               skb->ip_summed = CHECKSUM_NONE;
> > > > +               skb->csum_valid = 1;
> > > > +       }
> > > 
> > > why does this function also update these fields for non-tunneled
> > > packets? the commit only describes an issue with tunneled packets.
> > > 
> > > > +}
> > > > +
> > > >  #ifdef CONFIG_BPF_SYSCALL
> > > >  struct sk_psock;
> > > >  struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
> > > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > > index 4a0478b17243a..ff54135c51ffa 100644
> > > > --- a/net/ipv4/udp.c
> > > > +++ b/net/ipv4/udp.c
> > > > @@ -2168,6 +2168,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
> > > >  static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > > >  {
> > > >         struct sk_buff *next, *segs;
> > > > +       int csum_level;
> > > >         int ret;
> > > > 
> > > >         if (likely(!udp_unexpected_gso(sk, skb)))
> > > > @@ -2175,9 +2176,18 @@ static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > > > 
> > > >         BUILD_BUG_ON(sizeof(struct udp_skb_cb) > SKB_GSO_CB_OFFSET);
> > > >         __skb_push(skb, -skb_mac_offset(skb));
> > > > +       csum_level = !!(skb_shinfo(skb)->gso_type &
> > > > +                       (SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM));
> > > >         segs = udp_rcv_segment(sk, skb, true);
> > > >         skb_list_walk_safe(segs, skb, next) {
> > > >                 __skb_pull(skb, skb_transport_offset(skb));
> > > > +
> > > > +               /* UDP GSO packets looped back after adding UDP encap land here with CHECKSUM none,
> > > > +                * instead of adding another check in the tunnel fastpath, we can force valid
> > > > +                * csums here (packets are locally generated).
> > > > +                * Additionally fixup the UDP CB
> > > > +                */
> > > > +               udp_post_segment_fix_csum(skb, csum_level);
> > > 
> > > How does this code differentiates locally generated packets with udp
> > > tunnel headers from packets arriving from the wire, for which the
> > > inner checksum may be incorrect?
> > 
> > First thing first, thank you for the detailed review. Digesting all the
> > comments will take time, so please excuse for some latency.
> 
> Apologies for my own delayed response. I also need to take time to
> understand the existing code and diffs :) And have a few questions.
> 
> > I'll try to reply to both your question here because the replies are
> > related.
> > 
> > My understanding is that UDP GRO, when processing UDP over UDP traffic
> 
> This is a UDP GSO packet egress packet that was further encapsulated
> with a GSO_UDP_TUNNEL on egress, then looped to the ingress path?
> 
> Then in the ingress path it has traversed the GRO layer.
> 
> Is this veth with XDP? That seems unlikely for GSO packets. But there
> aren't many paths that will loop a packet through napi_gro_receive or
> napi_gro_frags.

This patch addresses the following scenario:

sk ->vxlan -> veth -> (xdp in use, TSO disabled, GRO on) -> veth -> vxlan -> sk

What I meant here is that the issue is not visible with:

(baremetal, NETIF_F_GRO_UDP_FWD | NETIF_F_GRO_FRAGLIST enabled -> vxlan -> sk

> > with the appropriate features bit set, will validate the checksum for
> > both the inner and the outer header - udp{4,6}_gro_receive will be
> > traversed twice, the fist one for the outer header, the 2nd for the
> > inner.
> 
> GRO will validate multiple levels of checksums with CHECKSUM_COMPLETE.
> It can only validate the outer checksum with CHECKSUM_UNNECESSARY, I
> believe?

I possibly miss some bits here ?!?

AFAICS:

udp4_gro_receive() -> skb_gro_checksum_validate_zero_check() ->
__skb_gro_checksum_validate -> (if  not already valid)
__skb_gro_checksum_validate_complete() -> (if not CHECKSUM_COMPLETE)
__skb_gro_checksum_complete()

the latter will validate the UDP checksum at the current nesting level
(and set the csum-related bits in the GRO skb cb to the same status
as CHECKSUM_COMPLETE)

When processing UDP over UDP tunnel packet, the gro call chain will be:

[l2/l3 GRO] -> udp4_gro_receive (validate outher header csum) -> 
udp_sk(sk)->gro_receive -> [other gro layers] -> 
udp4_gro_receive (validate inner header csum) -> ...

> As for looped packets with CHECKSUM_PARTIAL: we definitely have found
> bugs in that path before. I think it's fine to set csum_valid on any
> packets that can unambiguously be identified as such. Hence the
> detailed questions above on which exact packets this code is
> targeting, so that there are not accidental false positives that look
> the same but have a different ip_summed.

I see this change is controversial. Since the addressed scenario is
really a corner case, a simpler alternative would be
replacing udp_post_segment_fix_csum with:

static inline void udp_post_segment_fix_cb(struct sk_buff *skb, int level)
{
	/* UDP-lite can't land here - no GRO */
	WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);

	/* UDP CB mirrors the GSO packet, we must re-init it */
	UDP_SKB_CB(skb)->cscov = skb->len;
}

the downside will be an additional, later, unneeded csum validation for the 

sk ->vxlan -> veth -> (xdp in use, TSO disabled, GRO on) -> veth -> vxlan -> sk

scenario. WDYT?

Thanks!

Paolo

