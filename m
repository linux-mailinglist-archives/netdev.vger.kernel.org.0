Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B4E349133
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhCYLuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:50:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229995AbhCYLuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 07:50:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616673006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lpJ08J5mC4Gnrm1piufDbNHtgmbhQaJdsePdsNfxzSg=;
        b=UPD3+WGGanh3+kqpsidWiEovp8QluEznXshkzkev1PlI/p6z3qi6zXjxHjKWvPl674qlmH
        An252p8yd6exjGkthik4T4OnHguK3i84hWW3Z7ZqxqvA/te7a/K3LEicu4f08MrVm4T0nq
        FypCIIGSrpWfM6LirYqdTNvreS8I+z0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-pkXeFbk9M9WuA-BELYjD0A-1; Thu, 25 Mar 2021 07:50:04 -0400
X-MC-Unique: pkXeFbk9M9WuA-BELYjD0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D21A87139C;
        Thu, 25 Mar 2021 11:50:03 +0000 (UTC)
Received: from ovpn-113-211.ams2.redhat.com (ovpn-113-211.ams2.redhat.com [10.36.113.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BA8D5C3DF;
        Thu, 25 Mar 2021 11:50:01 +0000 (UTC)
Message-ID: <b5413c177a098e5958f1c9064a792979fb9a23fe.camel@redhat.com>
Subject: Re: [PATCH net-next 4/8] udp: never accept GSO_FRAGLIST packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Thu, 25 Mar 2021 12:50:00 +0100
In-Reply-To: <CA+FuTSd4m811Xa0TY=9VTtO7yqPyO7S+ugPHkNwWojuBnJRpTA@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <c77bb9511c1c10193cc05651ed785506d6aee3e8.1616345643.git.pabeni@redhat.com>
         <CA+FuTSefLQ07od6Et6H2wO=p8+V2F28VYix4EgghHz6R0Bn9nw@mail.gmail.com>
         <22bec3983ac3849298fbc15f6284f7643cbe4907.camel@redhat.com>
         <CA+FuTSfhU9ng6DuC7W6D8=OTk=5SJpqdz+xrQ12GYg4VtrdDZA@mail.gmail.com>
         <73664dd000dcbb432358a6559acbbf6b21d64150.camel@redhat.com>
         <CA+FuTSd4m811Xa0TY=9VTtO7yqPyO7S+ugPHkNwWojuBnJRpTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-03-24 at 18:12 -0400, Willem de Bruijn wrote:
> On Wed, Mar 24, 2021 at 3:00 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Tue, 2021-03-23 at 22:21 -0400, Willem de Bruijn wrote:
> > > On Mon, Mar 22, 2021 at 1:12 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > On Mon, 2021-03-22 at 09:42 -0400, Willem de Bruijn wrote:
> > > > > On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > > > Currently the UDP protocol delivers GSO_FRAGLIST packets to
> > > > > > the sockets without the expected segmentation.
> > > > > > 
> > > > > > This change addresses the issue introducing and maintaining
> > > > > > a per socket bitmask of GSO types requiring segmentation.
> > > > > > Enabling GSO removes SKB_GSO_UDP_L4 from such mask, while
> > > > > > GSO_FRAGLIST packets are never accepted
> > > > > > 
> > > > > > Note: this also updates the 'unused' field size to really
> > > > > > fit the otherwise existing hole. It's size become incorrect
> > > > > > after commit bec1f6f69736 ("udp: generate gso with UDP_SEGMENT").
> > > > > > 
> > > > > > Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> > > > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > > > ---
> > > > > >  include/linux/udp.h | 10 ++++++----
> > > > > >  net/ipv4/udp.c      | 12 +++++++++++-
> > > > > >  2 files changed, 17 insertions(+), 5 deletions(-)
> > > > > > 
> > > > > >         /*
> > > > > >          * Following member retains the information to create a UDP header
> > > > > >          * when the socket is uncorked.
> > > > > > @@ -68,7 +68,10 @@ struct udp_sock {
> > > > > >  #define UDPLITE_SEND_CC  0x2           /* set via udplite setsockopt         */
> > > > > >  #define UDPLITE_RECV_CC  0x4           /* set via udplite setsocktopt        */
> > > > > >         __u8             pcflag;        /* marks socket as UDP-Lite if > 0    */
> > > > > > -       __u8             unused[3];
> > > > > > +       __u8             unused[1];
> > > > > > +       unsigned int     unexpected_gso;/* GSO types this socket can't accept,
> > > > > > +                                        * any of SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST
> > > > > > +                                        */
> > > > > 
> > > > > An extra unsigned int for this seems overkill.
> > > > 
> > > > Should be more clear after the next patch.
> > > > 
> > > > Using an explicit 'acceptable GSO types' field makes the patch 5/8
> > > > quite simple.
> > > > 
> > > > After this patch the 'udp_sock' struct size remains unchanged and even
> > > > the number of 'udp_sock' cachelines touched for every packet is
> > > > unchanged.
> > > 
> > > But there is opportunity cost, of course. Next time we need to add
> > > something to the struct, we will add a new cacheline.
> > > 
> > > A 32-bit field for just 2 bits, where 1 already exists does seem like overkill.
> > > 
> > > More importantly, I just think it's less obvious code than a pair of fields
> > > 
> > >   accepts_udp_l4:1,
> > >   accepts_udp_fraglist:1,
> > > 
> > > Local sockets can only accept the first, as there does not exist an
> > > interface to pass along the multiple frag sizes that a frag_list based
> > > approach might have.
> > > 
> > > Sockets with encap_rcv != NULL may opt-in to being able to handle either.
> > > 
> > > I think explicit code will be more maintainable.
> > 
> > ok
> > 
> > > At the cost of
> > > perhaps two branches instead of one, admittedly. But that seems
> > > premature optimization.
> > 
> > well, if it don't hurt too much your eyes, something along the
> > following could save udp_sock space and code branches:
> > 
> >     rejects_udp_l4_fraglist:2;
> > 
> > #define SKB_GSO_UDP_L4_SHIFT (NETIF_F_GSO_UDP_L4_BIT - NETIF_F_GSO_SHIFT)
> >  static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
> >  {
> >         BUILD_BUG_ON(1 << SKB_GSO_UDP_L4_SHIFT != SKB_GSO_UDP_L4);
> >         BUILD_BUG_ON(1 << (SKB_GSO_UDP_L4_SHIFT + 1) != SKB_GSO_FRAGLIST);
> >         return skb_is_gso(skb) && skb_shinfo(skb)->gso_type &
> >                 (udp_sk(sk)->rejects_udp_l4_fraglist << SKB_GSO_UDP_L4_SHIFT);
> >  }
> > 
> > (not sure if /me runs/hides ;)
> 
> :)
> 
> My opinion is just one, but I do find this a lot less readable and
> hence maintainable than
> 
>   if (likely(!skb_is_gso(skb)))
>      return true;
> 
>   if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 && !udp_sk(sk)->accept_udp_l4)
>     return false;
> 
>   if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST &&
> !udp_sk(sk)->accept_udp_fraglist)
>     return false;
> 
>   return true;
> 
> at no obvious benefit. The tunnel gso code is hard enough to fathom as it is.

ok.

I'm only doubtful about the likely() annotation: systems with UDP
tunnels likely expect receiving a majority of UDP-encaped traffic,
which in turn will likely be GRO (e.g. TCP over UDP-tunnel).

In my next iteration I'll use the above, dropping the annotation.

Cheers,

Paolo

