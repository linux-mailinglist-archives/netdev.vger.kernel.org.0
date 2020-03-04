Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54BA8178CA6
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 09:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgCDIja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 03:39:30 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34808 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgCDIj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 03:39:29 -0500
Received: by mail-oi1-f194.google.com with SMTP id g6so1313367oiy.1
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 00:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z/X0UovT4DE7O4vko2XBAkSIwy+JqphUDS53Lj39Gf8=;
        b=YOR70frZUhrhwBN3fad57kF8tT2fIXif5ULTtPDhRJ7rO+Byhs+5kROA5eaEVK8hKV
         5qY+GNFsbIlmtCy49oPdAcoHJl03BT3SzPWBtSf0/boOlTvtoAlBmBBUgfU8GQgLMGL/
         /zixN0sDPnUHuPNEB6LfRZOsrR7q2fFcdVtvk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z/X0UovT4DE7O4vko2XBAkSIwy+JqphUDS53Lj39Gf8=;
        b=krDDfhPujFyidxecipmGKDoPsH7K0suhzJtZEQ3DL+bR3vI2QdwicbtyHivy8XFYrX
         PuZhUNRzcpCnMqjBSSNz3+6+73VTrSG3a7qp7j1yNYYvo4M5efs23+AbYvKzuL0ur8vv
         ddPbO1XczlAhKuloGLQtZfXUZD0BeYvgttPQx6TGsFYbRe7bQijuUXy7GgKKvO87C05A
         cR6PZpFpfrPTlrU45cQz88+8vDjyV6MLirdkA3uOGjIwK5QRr01W/V1DNbIp2qQHLctz
         GRvJe3+ah9FOuskEaef90OI6YgX799OVbhVci68HijM8ZDGdJuod5ST4y6d6VLg2rJZn
         ItDw==
X-Gm-Message-State: ANhLgQ2qg24YJ/W0S1E0nlOYqELOQqyswIfNpo3mts2Filu2w/p5wMHw
        jP1DrZDgZnVWQYWKotfsP8/8T8KvNtql2lFtaZ2m7A==
X-Google-Smtp-Source: ADFU+vtoZ8+1Zm7KA6Uyx6vtB0DyfWaSmrmraBfYE72PaCJ0Y8a0K5KaZAJlzK/bCc4jOHppkANa/k941ZvJkcFJHDw=
X-Received: by 2002:aca:b60a:: with SMTP id g10mr970157oif.102.1583311168743;
 Wed, 04 Mar 2020 00:39:28 -0800 (PST)
MIME-Version: 1.0
References: <20200228115344.17742-1-lmb@cloudflare.com> <20200228115344.17742-2-lmb@cloudflare.com>
 <5e5e955a27139_60e72b06ba14c5bc67@john-XPS-13-9370.notmuch>
In-Reply-To: <5e5e955a27139_60e72b06ba14c5bc67@john-XPS-13-9370.notmuch>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 4 Mar 2020 09:39:17 +0100
Message-ID: <CACAyw98oHs0CTR0k+JwZgM6maT__j5OvgsoVUGMMHx_4jW_OuA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/9] bpf: sockmap: only check ULP for TCP sockets
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Mar 2020 at 18:35, John Fastabend <john.fastabend@gmail.com> wrote:
>
> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> > index 112765bd146d..54a9a3e36b29 100644
> > --- a/include/linux/skmsg.h
> > +++ b/include/linux/skmsg.h
> > @@ -360,7 +360,13 @@ static inline void sk_psock_restore_proto(struct sock *sk,
> >                                         struct sk_psock *psock)
> >  {
> >       sk->sk_prot->unhash = psock->saved_unhash;
> > -     tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
> > +     if (inet_sk(sk)->is_icsk) {
>
> use sock_map_sk_has_ulp() here as well and then drop the !icsk->icsk_ulp_ops
> case in tcp_update_ulp()?

This requires moving sock_map_sk_has_ulp to the header, which seemed like the
incorrect place. How about adding bool inet_csk_has_ulp(sk) to
inet_connection_sock.h?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
