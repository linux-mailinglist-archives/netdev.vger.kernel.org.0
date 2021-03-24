Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D16434811C
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 20:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbhCXTAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 15:00:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237665AbhCXS7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:59:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616612391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mEmPLReuhJppTLF3t7lQfg9JLky1VBaTggL6WCom33M=;
        b=LpCyE3zbMAaBggO+2uMZyT/OKJJX8DctKGGDlUW9myncIbCNNfo6tt4UoSQfbeksxthmfT
        P6r7uc9NRd8YAluj0m2RxzWi1czjuOrB1b/IxqLe4dZmlcoIgw+q3yVV2sR5lzB5bm2jLx
        8gyg3CrmhVTzyTjIiicx1cuUttP1CIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-SiRM3cF3OeaqLkkJvS6zAg-1; Wed, 24 Mar 2021 14:59:47 -0400
X-MC-Unique: SiRM3cF3OeaqLkkJvS6zAg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 996EE100B72E;
        Wed, 24 Mar 2021 18:59:24 +0000 (UTC)
Received: from ovpn-114-21.ams2.redhat.com (ovpn-114-21.ams2.redhat.com [10.36.114.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D31AB5B4BC;
        Wed, 24 Mar 2021 18:59:22 +0000 (UTC)
Message-ID: <73664dd000dcbb432358a6559acbbf6b21d64150.camel@redhat.com>
Subject: Re: [PATCH net-next 4/8] udp: never accept GSO_FRAGLIST packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Wed, 24 Mar 2021 19:59:21 +0100
In-Reply-To: <CA+FuTSfhU9ng6DuC7W6D8=OTk=5SJpqdz+xrQ12GYg4VtrdDZA@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <c77bb9511c1c10193cc05651ed785506d6aee3e8.1616345643.git.pabeni@redhat.com>
         <CA+FuTSefLQ07od6Et6H2wO=p8+V2F28VYix4EgghHz6R0Bn9nw@mail.gmail.com>
         <22bec3983ac3849298fbc15f6284f7643cbe4907.camel@redhat.com>
         <CA+FuTSfhU9ng6DuC7W6D8=OTk=5SJpqdz+xrQ12GYg4VtrdDZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-03-23 at 22:21 -0400, Willem de Bruijn wrote:
> On Mon, Mar 22, 2021 at 1:12 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Mon, 2021-03-22 at 09:42 -0400, Willem de Bruijn wrote:
> > > On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > Currently the UDP protocol delivers GSO_FRAGLIST packets to
> > > > the sockets without the expected segmentation.
> > > > 
> > > > This change addresses the issue introducing and maintaining
> > > > a per socket bitmask of GSO types requiring segmentation.
> > > > Enabling GSO removes SKB_GSO_UDP_L4 from such mask, while
> > > > GSO_FRAGLIST packets are never accepted
> > > > 
> > > > Note: this also updates the 'unused' field size to really
> > > > fit the otherwise existing hole. It's size become incorrect
> > > > after commit bec1f6f69736 ("udp: generate gso with UDP_SEGMENT").
> > > > 
> > > > Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > ---
> > > >  include/linux/udp.h | 10 ++++++----
> > > >  net/ipv4/udp.c      | 12 +++++++++++-
> > > >  2 files changed, 17 insertions(+), 5 deletions(-)
> > > > 
> > > >         /*
> > > >          * Following member retains the information to create a UDP header
> > > >          * when the socket is uncorked.
> > > > @@ -68,7 +68,10 @@ struct udp_sock {
> > > >  #define UDPLITE_SEND_CC  0x2           /* set via udplite setsockopt         */
> > > >  #define UDPLITE_RECV_CC  0x4           /* set via udplite setsocktopt        */
> > > >         __u8             pcflag;        /* marks socket as UDP-Lite if > 0    */
> > > > -       __u8             unused[3];
> > > > +       __u8             unused[1];
> > > > +       unsigned int     unexpected_gso;/* GSO types this socket can't accept,
> > > > +                                        * any of SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST
> > > > +                                        */
> > > 
> > > An extra unsigned int for this seems overkill.
> > 
> > Should be more clear after the next patch.
> > 
> > Using an explicit 'acceptable GSO types' field makes the patch 5/8
> > quite simple.
> > 
> > After this patch the 'udp_sock' struct size remains unchanged and even
> > the number of 'udp_sock' cachelines touched for every packet is
> > unchanged.
> 
> But there is opportunity cost, of course. Next time we need to add
> something to the struct, we will add a new cacheline.
> 
> A 32-bit field for just 2 bits, where 1 already exists does seem like overkill.
> 
> More importantly, I just think it's less obvious code than a pair of fields
> 
>   accepts_udp_l4:1,
>   accepts_udp_fraglist:1,
> 
> Local sockets can only accept the first, as there does not exist an
> interface to pass along the multiple frag sizes that a frag_list based
> approach might have.
> 
> Sockets with encap_rcv != NULL may opt-in to being able to handle either.
> 
> I think explicit code will be more maintainable. 

ok

> At the cost of
> perhaps two branches instead of one, admittedly. But that seems
> premature optimization.

well, if it don't hurt too much your eyes, something along the
following could save udp_sock space and code branches:

    rejects_udp_l4_fraglist:2;

#define SKB_GSO_UDP_L4_SHIFT (NETIF_F_GSO_UDP_L4_BIT - NETIF_F_GSO_SHIFT)
 static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 {
	BUILD_BUG_ON(1 << SKB_GSO_UDP_L4_SHIFT != SKB_GSO_UDP_L4);
	BUILD_BUG_ON(1 << (SKB_GSO_UDP_L4_SHIFT + 1) != SKB_GSO_FRAGLIST);
 	return skb_is_gso(skb) && skb_shinfo(skb)->gso_type &
		(udp_sk(sk)->rejects_udp_l4_fraglist << SKB_GSO_UDP_L4_SHIFT);
 }

(not sure if /me runs/hides ;)

/P



