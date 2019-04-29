Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D02E31A
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 14:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfD2Mxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 08:53:45 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34661 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbfD2Mxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 08:53:44 -0400
Received: by mail-ed1-f65.google.com with SMTP id a6so9052495edv.1
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 05:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qPNyQ4u84DlZEfdjS8a2VtIDW8qwt3g76sv8n/WAbRs=;
        b=CKHjpDfMwW04ikw0X4jB4weVnuJ3FK77AV9jFIx0gy211cDdnIY0/y0CUMWvZVm/B/
         f/Z+E3ystUTnWJyFOMXAuXE9DDKQT9Y8rl9zz8awpTUouKaqGPBCKe+MOclvSGMEPQP8
         plggV4DwaBa71PrWtbvhSo/j5mW7gaWf/jaUVq2vYwbL6hmy2Rrhe5Vwp4lgwpKsb/ZM
         VE80/+zsR+uwHa/xMTEqoD9LS9ywPS2xIw48qwLFKgSXUq7gDPNFWHq0ktC+TwaObOVN
         oXvsSNxWJfHRRV342LdqtiJf99ri8iUjLA9KXYZRj2QgR3z/WsXS2l6q/jPHmrVwriVk
         oyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qPNyQ4u84DlZEfdjS8a2VtIDW8qwt3g76sv8n/WAbRs=;
        b=gJ7fxLml2Y7VYozyMgn+RLbZ6cgZVYof2nHpjsmIzZqjHSMMh6qizuDYNqBcQHzQ6i
         JR2DVFoLyXqv5s2Hy26GCNdD1G+xnReY3Wr5dJtoWDltWLYqQ2rcXEQ0GyNfkyHWpgY3
         Z/NVC/XA8Sqa9uq9vAIu8JSKPWCBQPwBkFzbpl/PTTwEO0iimw/6moNheLNgOFGc0KZi
         hAXKssqptjG//CAT11w3Iuvib953ZKiesAzmJp7gbfD6VuLvHilFHJA16imB3v2w70Pe
         UN4Nh9T+LLgqtAOY4Krdy6p72EJmLgR0VfR4VJaKz5hf5KQbl1MoC1zq0wy294292A7C
         CeYA==
X-Gm-Message-State: APjAAAVHSXVF5pRsAG/wWzKs5zcfwL2cJRwNJeXQJ+RvHs/6BprbtRcT
        1ERvoO5zfTi9y67DVyzcaZAXKChZFwcft/+gagA=
X-Google-Smtp-Source: APXvYqxu6St6D54jS4ZYFkxWscQ0NaLbJhRR7rDRpBWbe3E4jCa6qgLtH+Di4fRP79i20bmNA3JrJefugf95IGWeW1I=
X-Received: by 2002:a17:906:f29a:: with SMTP id gu26mr8584191ejb.148.1556542422504;
 Mon, 29 Apr 2019 05:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190426192735.145633-1-willemdebruijn.kernel@gmail.com> <92f9793efb2a4d9fb7973dcb47192c4b@AcuMS.aculab.com>
In-Reply-To: <92f9793efb2a4d9fb7973dcb47192c4b@AcuMS.aculab.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Apr 2019 08:53:06 -0400
Message-ID: <CAF=yD-KKSt+y5AcMrBDv6NUVeMoBVXy11dRJEZ1mDxf-Z5Rw6w@mail.gmail.com>
Subject: Re: [PATCH net] packet: validate msg_namelen in send directly
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@idosch.org" <idosch@idosch.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 5:00 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Willem de Bruijn
> > Sent: 26 April 2019 20:28
> > Packet sockets in datagram mode take a destination address. Verify its
> > length before passing to dev_hard_header.
> >
> > Prior to 2.6.14-rc3, the send code ignored sll_halen. This is
> > established behavior. Directly compare msg_namelen to dev->addr_len.
> >
> > Fixes: 6b8d95f1795c4 ("packet: validate address length if non-zero")
> > Suggested-by: David Laight <David.Laight@aculab.com>
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> >  net/packet/af_packet.c | 18 ++++++++++++------
> >  1 file changed, 12 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > index 9419c5cf4de5e..13301e36b4a28 100644
> > --- a/net/packet/af_packet.c
> > +++ b/net/packet/af_packet.c
> > @@ -2624,10 +2624,13 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> >                                               sll_addr)))
> >                       goto out;
> >               proto   = saddr->sll_protocol;
> > -             addr    = saddr->sll_halen ? saddr->sll_addr : NULL;
> >               dev = dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
> > -             if (addr && dev && saddr->sll_halen < dev->addr_len)
> > -                     goto out_put;
> > +             if (po->sk.sk_socket->type == SOCK_DGRAM) {
> > +                     addr = saddr->sll_addr;
> > +                     if (dev && msg->msg_namelen < dev->addr_len +
> > +                                     offsetof(struct sockaddr_ll, sll_addr))
> > +                             goto out_put;
> > +             }
>
> IIRC you need to initialise 'addr - NULL' at the top of the functions.
> I'm surprised the compiler doesn't complain.

It did complain when I moved it below the if (dev && ..) branch. But
inside a branch with exactly the same condition as the one where used,
the compiler did figure it out. Admittedly that is fragile. Then it
might be simplest to restore the unconditional assignment

                proto   = saddr->sll_protocol;
+               addr    = saddr->sll_addr;
                dev = dev_get_by_index(sock_net(sk), saddr->sll_ifindex);
