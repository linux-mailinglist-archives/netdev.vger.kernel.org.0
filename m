Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3770E344CD8
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhCVRJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:09:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230018AbhCVRJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616432964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w73lfRPwqoA8DLRpuEfWTwMhUmwyDxH/vQCdqbzNuNQ=;
        b=BUG0qwFiJkju75zW6N+Emgm3auIzbJUV4y8akRTgQnarLcQL0YHcXEUaJpZ+ZbsqhrgI2B
        2kNx3xfN3uesk/sogcoElNoXW7tuOO7hKr8f8A13dWaFQ4/5ZZObQ7zlzj+L5bRvMvGvkj
        nzpcZYwY0yk1ZWbfNoJm8hSQZMbqj3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-zFOIqqzONp2O1BmalbBL-g-1; Mon, 22 Mar 2021 13:09:17 -0400
X-MC-Unique: zFOIqqzONp2O1BmalbBL-g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 307B1835BC3;
        Mon, 22 Mar 2021 17:09:15 +0000 (UTC)
Received: from ovpn-115-44.ams2.redhat.com (ovpn-115-44.ams2.redhat.com [10.36.115.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DA5219D61;
        Mon, 22 Mar 2021 17:09:12 +0000 (UTC)
Message-ID: <22bec3983ac3849298fbc15f6284f7643cbe4907.camel@redhat.com>
Subject: Re: [PATCH net-next 4/8] udp: never accept GSO_FRAGLIST packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Mon, 22 Mar 2021 18:09:12 +0100
In-Reply-To: <CA+FuTSefLQ07od6Et6H2wO=p8+V2F28VYix4EgghHz6R0Bn9nw@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <c77bb9511c1c10193cc05651ed785506d6aee3e8.1616345643.git.pabeni@redhat.com>
         <CA+FuTSefLQ07od6Et6H2wO=p8+V2F28VYix4EgghHz6R0Bn9nw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-22 at 09:42 -0400, Willem de Bruijn wrote:
> On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > Currently the UDP protocol delivers GSO_FRAGLIST packets to
> > the sockets without the expected segmentation.
> > 
> > This change addresses the issue introducing and maintaining
> > a per socket bitmask of GSO types requiring segmentation.
> > Enabling GSO removes SKB_GSO_UDP_L4 from such mask, while
> > GSO_FRAGLIST packets are never accepted
> > 
> > Note: this also updates the 'unused' field size to really
> > fit the otherwise existing hole. It's size become incorrect
> > after commit bec1f6f69736 ("udp: generate gso with UDP_SEGMENT").
> > 
> > Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  include/linux/udp.h | 10 ++++++----
> >  net/ipv4/udp.c      | 12 +++++++++++-
> >  2 files changed, 17 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/udp.h b/include/linux/udp.h
> > index aa84597bdc33c..6da342f15f351 100644
> > --- a/include/linux/udp.h
> > +++ b/include/linux/udp.h
> > @@ -51,7 +51,7 @@ struct udp_sock {
> >                                            * different encapsulation layer set
> >                                            * this
> >                                            */
> > -                        gro_enabled:1; /* Can accept GRO packets */
> > +                        gro_enabled:1; /* Request GRO aggregation */
> 
> unnecessary comment change?

Before this patch 'gro_enabled' was used in udp_unexpected_gso() to
check for GSO packets acceptance, after this patch such field is not
used there anymore, so does not carry explicilty the 'accept GRO
packets' semantic.

Anyway I don't have strong feeling regarding changing or not this
comment

> >         /*
> >          * Following member retains the information to create a UDP header
> >          * when the socket is uncorked.
> > @@ -68,7 +68,10 @@ struct udp_sock {
> >  #define UDPLITE_SEND_CC  0x2           /* set via udplite setsockopt         */
> >  #define UDPLITE_RECV_CC  0x4           /* set via udplite setsocktopt        */
> >         __u8             pcflag;        /* marks socket as UDP-Lite if > 0    */
> > -       __u8             unused[3];
> > +       __u8             unused[1];
> > +       unsigned int     unexpected_gso;/* GSO types this socket can't accept,
> > +                                        * any of SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST
> > +                                        */
> 
> An extra unsigned int for this seems overkill.

Should be more clear after the next patch.

Using an explicit 'acceptable GSO types' field makes the patch 5/8
quite simple.

After this patch the 'udp_sock' struct size remains unchanged and even
the number of 'udp_sock' cachelines touched for every packet is
unchanged.

I opted for an 'unsigned int' so that I could simply copy a gso_type
there.

> Current sockets that support SKB_GSO_UDP_L4 implicitly also support
> SKB_GSO_FRAGLIST. This patch makes explicit that the second is not
> supported..
> 
> >         /*
> >          * For encapsulation sockets.
> >          */
> > @@ -131,8 +134,7 @@ static inline void udp_cmsg_recv(struct msghdr *msg, struct sock *sk,
> > 
> >  static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
> >  {
> > -       return !udp_sk(sk)->gro_enabled && skb_is_gso(skb) &&
> > -              skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4;
> > +       return skb_is_gso(skb) && skb_shinfo(skb)->gso_type & udp_sk(sk)->unexpected_gso;
> 
> .. just update this function as follows ?
> 
>  -       return !udp_sk(sk)->gro_enabled && skb_is_gso(skb) &&
>  -              skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4;
> +       return skb_is_gso(skb) &&
> +                 (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST ||
> !udp_sk(sk)->gro_enabled)
> 
> where the latter is shorthand for
> 
>   (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 && !udp_sk(sk)->gro_enabled)
> 
> but the are the only two GSO types that could arrive here.

With the above patch 5/8 becomes messy ?!?

Thanks!

Paolo

