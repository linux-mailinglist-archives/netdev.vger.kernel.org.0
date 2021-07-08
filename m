Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C5C3BF554
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 07:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhGHFzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 01:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhGHFzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 01:55:20 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C88C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 22:52:38 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id i4so7143994ybe.2
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 22:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CWnJqaWA92MGxPRN6+GeFB6tFQJOaSokCSE6qL37UKk=;
        b=OKQ0zg42R6AZ4tuVAtxuE+04M0BuTzqrz8u8nd3YklBciYl2I4UQ0WeruYBwTCHi55
         9oRjnh7zv00VxKfg1Q5dodyVpXgg8l/s17G0XrSsiuz3TcwK49yz6YfnP4s3Sf41AJiV
         65PFK3Od8THHVjMciwP96mWgkUJPPRq6xR7Lt9WG8lXHl8eC8dUMa10+nhcgOGmWyg0S
         NYBYOGzAuea3l3iepKHKwHJMv/papr2kfIg5nlp2iUD4bTfsk0pwQJLYO7aOo3XEHGMv
         avzZI1PTB16GWUGin9tyOC/y39pQ/4li+8WDENw5eaKLyXpGXZ3dckljuGdIi/oG9xK+
         v82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CWnJqaWA92MGxPRN6+GeFB6tFQJOaSokCSE6qL37UKk=;
        b=MBXYqPdYp1CVIHp8758X/idhsSAvJb6EGUYKI5FQ1q4rGsSR30nkU6k6S++9zxWDYj
         TY5TjXfmmewXKZGYKm1/StRCZSh+nH2VYwXCt25kg2u9goHtoPHnFs9seTRGB55CNkx5
         D670Jjkfd2qY6yTKEgRO5qB5sjDOFGHzcesFCBjZQjDAJvnGrJwVJUo6OFJSgWbGNpGu
         zkYMwJf9q5Dgnzfm4dTutf+YclXaGjWdyJy36lFdA0V8uLMZBRgDsXvqp+DVJ2JlmQh6
         R4boAXpa/8kU7s96ESPBl7uTB+1M/UYDEbCntv9qG/wu5+3el0788vCtZU5Dct7Pq+uF
         qJgA==
X-Gm-Message-State: AOAM531g5jwSfPeB0SokufuX9C4js2TH5YgP8A9vO3hJCznxdJTX6r4A
        sGENGZH+U8DRQxQU2anxyHGfgbd4NBF4VxLH+/10tg==
X-Google-Smtp-Source: ABdhPJx0jHO3jYIX1vxbdm5TzsPnvZyRSw0sZSLAFu/CRLbRv4iywmVr0b9Er9+y0IktV+KcU4Fe7DvWzUseR3sRY+s=
X-Received: by 2002:a25:8081:: with SMTP id n1mr38804218ybk.253.1625723557545;
 Wed, 07 Jul 2021 22:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210707154630.583448-1-eric.dumazet@gmail.com> <20210707222555.tdhqvvqbz5ocbrep@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210707222555.tdhqvvqbz5ocbrep@kafai-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Jul 2021 07:52:26 +0200
Message-ID: <CANn89iLdc3U0WJB89CbU7mnrtgo160O+WkrbzaT95KX0Ji0Vvg@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: tcp: drop silly ICMPv6 packet too big messages
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 12:26 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Jul 07, 2021 at 08:46:30AM -0700, Eric Dumazet wrote:
> [ ... ]
>
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index 593c32fe57ed13a218492fd6056f2593e601ec79..bc334a6f24992c7b5b2c415eab4b6cf51bf36cb4 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -348,11 +348,20 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> >  static void tcp_v6_mtu_reduced(struct sock *sk)
> >  {
> >       struct dst_entry *dst;
> > +     u32 mtu;
> >
> >       if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
> >               return;
> >
> > -     dst = inet6_csk_update_pmtu(sk, READ_ONCE(tcp_sk(sk)->mtu_info));
> > +     mtu = READ_ONCE(tcp_sk(sk)->mtu_info);
> > +
> > +     /* Drop requests trying to increase our current mss.
> > +      * Check done in __ip6_rt_update_pmtu() is too late.
> > +      */
> > +     if (tcp_mss_to_mtu(sk, mtu) >= tcp_sk(sk)->mss_cache)
> Instead of tcp_mss_to_mtu, should this be calling tcp_mtu_to_mss to
> compare with tcp_sk(sk)->mss_cache?

Good catch Martin, let me add and run a few more tests before sending a v2.

Thanks !
