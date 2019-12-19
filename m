Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17CC3125C8E
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 09:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfLSI0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 03:26:05 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:42228 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbfLSI0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 03:26:05 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3D79020184;
        Thu, 19 Dec 2019 09:26:03 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id enA1yM1AhO2X; Thu, 19 Dec 2019 09:26:02 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D0DE4200AC;
        Thu, 19 Dec 2019 09:26:02 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Dec 2019
 09:26:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 757053180373;
 Thu, 19 Dec 2019 09:26:02 +0100 (CET)
Date:   Thu, 19 Dec 2019 09:26:02 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 4/4] udp: Support UDP fraglist GRO/GSO.
Message-ID: <20191219082602.GT8621@gauss3.secunet.de>
References: <20191218133458.14533-1-steffen.klassert@secunet.com>
 <20191218133458.14533-5-steffen.klassert@secunet.com>
 <CA+FuTScaqg8whAaS35n9TT+=7S38Sn_sMEN=KstYF6i83keSsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTScaqg8whAaS35n9TT+=7S38Sn_sMEN=KstYF6i83keSsw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 11:03:09AM -0500, Willem de Bruijn wrote:
> On Wed, Dec 18, 2019 at 8:35 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> 
> > @@ -544,6 +585,18 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
> >         const struct iphdr *iph = ip_hdr(skb);
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
> why is this needed for ipv4 only?

It is needed for IPv6 too, I've just forgot to add it there.

Thanks for the review!
