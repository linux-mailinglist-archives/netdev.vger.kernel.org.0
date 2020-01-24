Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A070A149027
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgAXVav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:30:51 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:49802 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgAXVav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:30:51 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5BD82201AA;
        Fri, 24 Jan 2020 22:30:49 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LUIkhj4g2DSB; Fri, 24 Jan 2020 22:30:48 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E503F201A0;
        Fri, 24 Jan 2020 22:30:48 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 24 Jan 2020
 22:30:48 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 89EF431800F8;
 Fri, 24 Jan 2020 22:30:48 +0100 (CET)
Date:   Fri, 24 Jan 2020 22:30:48 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/4] udp: Support UDP fraglist GRO/GSO.
Message-ID: <20200124213048.GB18684@gauss3.secunet.de>
References: <20200124082218.2572-1-steffen.klassert@secunet.com>
 <20200124082218.2572-5-steffen.klassert@secunet.com>
 <CAF=yD-JmKdDmKs5W8YeLOc2L81av8SrS1nR=chAAre2z=ALepw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAF=yD-JmKdDmKs5W8YeLOc2L81av8SrS1nR=chAAre2z=ALepw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 04:13:17PM -0500, Willem de Bruijn wrote:
> On Fri, Jan 24, 2020 at 3:24 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >         NAPI_GRO_CB(skb)->flush = 1;
> > @@ -144,6 +150,18 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
> >         const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
> >         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
> >
> > +       if (NAPI_GRO_CB(skb)->is_flist) {
> > +               uh->len = htons(skb->len - nhoff);
> > +
> > +               skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> > +               skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> > +
> > +               skb->ip_summed = CHECKSUM_UNNECESSARY;
> > +               skb->csum_level = ~0;
> 
> This probably needs to be the same change as in udp4_gro_complete.
> 
> Otherwise patch set looks great to me based on a git range-diff to v1.

Uhm, yes absolutely.

I'll do a v3 tomorrow.

Thanks for your review Willem!
