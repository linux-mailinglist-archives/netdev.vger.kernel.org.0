Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A988BC1B79
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 08:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbfI3Gav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 02:30:51 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:40434 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbfI3Gav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 02:30:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AF22E2049B;
        Mon, 30 Sep 2019 08:30:49 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id be5bGDk6PFjK; Mon, 30 Sep 2019 08:30:49 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 44BB2200AA;
        Mon, 30 Sep 2019 08:30:49 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 08:30:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 698AC31800B9;
 Mon, 30 Sep 2019 08:30:48 +0200 (CEST)
Date:   Mon, 30 Sep 2019 08:30:48 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemb@google.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH RFC 5/5] udp: Support UDP fraglist GRO/GSO.
Message-ID: <20190930063048.GG2879@gauss3.secunet.de>
References: <20190920044905.31759-1-steffen.klassert@secunet.com>
 <20190920044905.31759-6-steffen.klassert@secunet.com>
 <CA+FuTScYar_FNP9igCbxafMciUEYnjbnGiJyX3JhrU74VEGksg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTScYar_FNP9igCbxafMciUEYnjbnGiJyX3JhrU74VEGksg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 09:01:13AM -0400, Willem de Bruijn wrote:
> On Fri, Sep 20, 2019 at 12:49 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > This patch extends UDP GRO to support fraglist GRO/GSO
> > by using the previously introduced infrastructure.
> > All UDP packets that are not targeted to a GRO capable
> > UDP sockets are going to fraglist GRO now (local input
> > and forward).
> >
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> > @@ -538,6 +579,15 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
> >         const struct iphdr *iph = ip_hdr(skb);
> >         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
> >
> > +       if (NAPI_GRO_CB(skb)->is_flist) {
> > +               uh->len = htons(skb->len - nhoff);
> > +
> > +               skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> > +               skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> > +
> > +               return 0;
> > +       }
> > +
> >         if (uh->check)
> >                 uh->check = ~udp_v4_check(skb->len - nhoff, iph->saddr,
> >                                           iph->daddr, 0);
> > diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
> > index 435cfbadb6bd..8836f2b69ef3 100644
> > --- a/net/ipv6/udp_offload.c
> > +++ b/net/ipv6/udp_offload.c
> > @@ -150,6 +150,15 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
> >         const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
> >         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
> >
> > +       if (NAPI_GRO_CB(skb)->is_flist) {
> > +               uh->len = htons(skb->len - nhoff);
> > +
> > +               skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> > +               skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> > +
> > +               return 0;
> > +       }
> > +
> 
> This is the same logic as in udp4_gro_complete. Can it be deduplicated
> in udp_gro_complete?

The code below would mess up the checksum then. We did not change
the packets, so the checksum is still correct.

> 
> >         if (uh->check)
> >                 uh->check = ~udp_v6_check(skb->len - nhoff, &ipv6h->saddr,
> >                                           &ipv6h->daddr, 0);
