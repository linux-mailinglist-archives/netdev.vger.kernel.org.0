Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAFA485420
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388830AbfHGTyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:54:53 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39661 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388370AbfHGTyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:54:53 -0400
Received: by mail-ed1-f68.google.com with SMTP id m10so87628870edv.6
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 12:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EpZGF9yLa8wD6AMTG/IUu4OvzKZQoArQ9Z4Avc3BGCM=;
        b=LImErv7q2GJFDPsyQVElDhNwOb4EuMyDLq8olARLjiMb/B5dbapV2vgj7P26QLWfoB
         a2wgvw8AnaY8nNl5+DYaRZ1n03GZGI47vbZpQFZkYn823dj5t2nCZ7Js2mUBvH867mms
         6UwmFKLzOPEhkbJSQE6tlObLzgtCXPIxpwfn6zjzW9yZ59yKiMVa4u6NtFUpm4y6sMAW
         UVX3TzrYCKDWCOn8YJ5zCKghLPF81lJ22PyToD9BPFhIngUHJNqObF/iHHiihju0akx6
         pa7hruXfBfK12qr3QX/GePGuS+STu9Z5LCBxE10G+WbzniqrcNkn3RNtKbGOMBh/pEXo
         l22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EpZGF9yLa8wD6AMTG/IUu4OvzKZQoArQ9Z4Avc3BGCM=;
        b=K/qISXnK1bxVec0eZZZNnbiuzdVyKMF4TT83kevl2LKCy5F9BIyFJJ+aOxB78/hJ7g
         WgvLohgDlXoauLdi3f/VWD+tU4/zbkiVXcnNUQMcjSvai8txEMcqkVa3rYyidZrpb9sV
         qQagW6rrbcvb9373/WVhQUzqJihSMIWGuJFr4w+aoOXK852GtIj4Ml4dvg3eps0Ovpcm
         kBAnWxFlTBgMaGr650DaXsChwBux47/JcB8WLUXAiT0DqbG7XdQCgyRvuAX2tquWHdIY
         WOcHVx/OE8jgGFgLao/d/D2MDoTE2aa1W5avSGxMlBpgZe4czYs5iy4rXykqTARFKzZZ
         EZNQ==
X-Gm-Message-State: APjAAAVkOFt7vwp6QGACpNCsGDjTq2acQQa06OZrohNn/Lwh0rWS7qja
        +ahFvDTwAM7M68nLq3ZW1DLPlprziRPbldwsX7c=
X-Google-Smtp-Source: APXvYqzJGVJEv1599v4cGl05sAEMgK/VDg1oulAIVIYP5Wca0j6BhU/dotobgVuyDH37iTsXAbptJnpc5TYVQOHqIvs=
X-Received: by 2002:a17:906:b301:: with SMTP id n1mr9724368ejz.246.1565207692211;
 Wed, 07 Aug 2019 12:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190807060612.19397-1-jakub.kicinski@netronome.com>
 <CA+FuTScYkHho4hqrGf9q6=4iao-f2P2s258rjtQTCgn+nF-CYg@mail.gmail.com>
 <20190807110042.690cf50a@cakuba.netronome.com> <CA+FuTSeR1QqAZVTLQ-mJ8iHi+h+ghbrGyT6TWATTecQSbQP6sA@mail.gmail.com>
In-Reply-To: <CA+FuTSeR1QqAZVTLQ-mJ8iHi+h+ghbrGyT6TWATTecQSbQP6sA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 7 Aug 2019 15:54:15 -0400
Message-ID: <CAF=yD-JFV9SwwsiOD7LFdy7Weq1XEmwFpZiKBjM8-H8S+2kfRg@mail.gmail.com>
Subject: Re: [PATCH net v2] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 2:47 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Aug 7, 2019 at 2:01 PM Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
> >
> > On Wed, 7 Aug 2019 12:59:00 -0400, Willem de Bruijn wrote:
> > > On Wed, Aug 7, 2019 at 2:06 AM Jakub Kicinski wrote:
> > > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > > index d57b0cc995a0..0f9619b0892f 100644
> > > > --- a/net/core/sock.c
> > > > +++ b/net/core/sock.c
> > > > @@ -1992,6 +1992,20 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
> > > >  }
> > > >  EXPORT_SYMBOL(skb_set_owner_w);
> > > >
> > > > +static bool can_skb_orphan_partial(const struct sk_buff *skb)
> > > > +{
> > > > +#ifdef CONFIG_TLS_DEVICE
> > > > +       /* Drivers depend on in-order delivery for crypto offload,
> > > > +        * partial orphan breaks out-of-order-OK logic.
> > > > +        */
> > > > +       if (skb->decrypted)
> > > > +               return false;
> > > > +#endif
> > > > +       return (IS_ENABLED(CONFIG_INET) &&
> > > > +               skb->destructor == tcp_wfree) ||
> > >
> > > Please add parentheses around IS_ENABLED(CONFIG_INET) &&
> > > skb->destructor == tcp_wfree
> >
> > Mm.. there are parenthesis around them, maybe I'm being slow,
> > could you show me how?
>
> I mean
>
>     return (skb->destructor == sock_wfree ||
>                (IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree))
>
> In other words, (a || (b && c)) instead of (a || b && c). Though the
> existing code also eschews the extra parentheses.

No, ignore that last bit. It uses #ifdef, of course.
