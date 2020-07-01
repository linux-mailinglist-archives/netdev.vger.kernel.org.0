Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB5211028
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732259AbgGAQFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGAQFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:05:37 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458B3C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 09:05:36 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id y17so10119193ybm.12
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 09:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=koMi848mio+yvFuGCgACokpoQYwj0J0mbR7zr0RSmaw=;
        b=T1/i4xbXEBXOG8EHUHrjytUCQhMLgP5Yx4I3ALSLM0MGStLacRlPfijo48i4psWU5x
         xrrByKS4USsaREwGUq8ZaVpg6cu23iL7JiPBnMeCTTVwFP8YhE4dI/85rT5XbVWDZpYb
         SHm00gqgYecR7+pBOj1bYtoD568sVPprczGuCjg9lLEtUF+w33g0Fjx00RpQWjw0SxnS
         iohwGqKLNbjbynBX84KPjN4NCV9fRfCj4sunpMlMUZ6NgZ+sO3G66o9saOnSW5fRF6Zv
         7acoeIPZXRFpu6QjlPUB6ITjGJ4TppIdvsZwvRpTmd/DQoVFaTpe13MmMa3y8VwPJ47d
         V7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=koMi848mio+yvFuGCgACokpoQYwj0J0mbR7zr0RSmaw=;
        b=E1TuDxNOWjTG+GWTJdRtK3Kc4+bSCYgGx43x4WEtA4/BMp9ypNsY6DymeTR1fPJW+2
         GHvh04EtIfQApbFjzFc2msSeIX1qoaQGJqZTOYPILeb8zWL1M0pHna2HZA4d1EzptHmF
         PYddALJj2oQ0Mu/i0pQYs11MzA4gsKe2RiC/mqENxbRTQ0GZE68O4FuqvzV1WHJEsmMQ
         6SLAlH93atJgMSen71wDJJAvHa8QTVh8I7R7km7RpbTu8LJJGkh/NX0PNld9prJTfViS
         bqr9T69gUvf0sUYiW8pRVgBFSBWAR8+T4Fk9irRUJYwV/ZoWnnM8ISr9Ixe/5TVbnXmS
         qXrw==
X-Gm-Message-State: AOAM532lZ3NdSzdb4KeCqLMfv3CpLJ7q84v2HYvZZSxtCkf8HN7XtMQR
        e93qzwJgiNfjeNCWspxQ9Ak1k7EpK7wUPe9j6lCol8q3
X-Google-Smtp-Source: ABdhPJwgwOrbNshz9c0+qmLqMzyaIVa8+oc0wJIVXCgerSXUINIdmvZZ9nt+JA6+uUDvXSYo/UHixI+Qon41rahhngM=
X-Received: by 2002:a25:d28e:: with SMTP id j136mr45107081ybg.408.1593619535259;
 Wed, 01 Jul 2020 09:05:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200701155018.3502985-1-edumazet@google.com> <723842718.19296.1593619039697.JavaMail.zimbra@efficios.com>
In-Reply-To: <723842718.19296.1593619039697.JavaMail.zimbra@efficios.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Jul 2020 09:05:23 -0700
Message-ID: <CANn89i+x_OocNV=y1aP0uDUJ3HegXrhBCqZgSPTigEoj5rWx-g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Marco Elver <elver@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 8:57 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Jul 1, 2020, at 11:50 AM, Eric Dumazet edumazet@google.com wrote:
>
> > My prior fix went a bit too far, according to Herbert and Mathieu.
> >
> > Since we accept that concurrent TCP MD5 lookups might see inconsistent
> > keys, we can use READ_ONCE()/WRITE_ONCE() instead of smp_rmb()/smp_wmb()
> >
> > Clearing all key->key[] is needed to avoid possible KMSAN reports,
> > if key->keylen is increased. Since tcp_md5_do_add() is not fast path,
> > using __GFP_ZERO to clear all struct tcp_md5sig_key is simpler.
> >
> > data_race() was added in linux-5.8 and will prevent KCSAN reports,
> > this can safely be removed in stable backports, if data_race() is
> > not yet backported.
> >
> > Fixes: 6a2febec338d ("tcp: md5: add missing memory barriers in
> > tcp_md5_do_add()/tcp_md5_hash_key()")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > ---
> > net/ipv4/tcp.c      |  4 +---
> > net/ipv4/tcp_ipv4.c | 19 ++++++++++++++-----
> > 2 files changed, 15 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index
> > f111660453241692a17c881dd6dc2910a1236263..c3af8180c7049d5c4987bf5c67e4aff2ed6967c9
> > 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4033,11 +4033,9 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
> >
> > int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key
> > *key)
> > {
> > -     u8 keylen = key->keylen;
> > +     u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in
> > tcp_md5_do_add */
> >       struct scatterlist sg;
> >
> > -     smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
> > -
> >       sg_init_one(&sg, key->key, keylen);
> >       ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
> >       return crypto_ahash_update(hp->md5_req);
>
> I think we should change this to:
>
>     return data_race(crypto_ahash_update(hp->md5_req));
>
> because both sides can race on the data. Hopefully that would let
> KCSAN know that deep within the ->update callback the data race
> is OK (?)
>

Let's ask Marco.

Before data_race() has been there, using READ_ONCE() or WRITE_ONCE()
was enough to silence KCSAN.
Not sure if this is the same for data_race().

I would prefer not having to add annotations all over the places, to
reduce backport pains.

Unless we have plans to backport data_race() to all stable versions.

> Thanks,
>
> Mathieu
>
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index
> > 99916fcc15ca0be12c2c133ff40516f79e6fdf7f..04bfcbbfee83aadf5bca0332275c57113abdbc75
> > 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -1111,12 +1111,21 @@ int tcp_md5_do_add(struct sock *sk, const union
> > tcp_md5_addr *addr,
> >
> >       key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index);
> >       if (key) {
> > -             /* Pre-existing entry - just update that one. */
> > -             memcpy(key->key, newkey, newkeylen);
> > +             /* Pre-existing entry - just update that one.
> > +              * Note that the key might be used concurrently.
> > +              * data_race() is telling kcsan that we do not care of
> > +              * key mismatches, since changing MD5 key on live flows
> > +              * can lead to packet drops.
> > +              */
> > +             data_race(memcpy(key->key, newkey, newkeylen));
> >
> > -             smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
> > +             /* Pairs with READ_ONCE() in tcp_md5_hash_key().
> > +              * Also note that a reader could catch new key->keylen value
> > +              * but old key->key[], this is the reason we use __GFP_ZERO
> > +              * at sock_kmalloc() time below these lines.
> > +              */
> > +             WRITE_ONCE(key->keylen, newkeylen);
> >
> > -             key->keylen = newkeylen;
> >               return 0;
> >       }
> >
> > @@ -1132,7 +1141,7 @@ int tcp_md5_do_add(struct sock *sk, const union
> > tcp_md5_addr *addr,
> >               rcu_assign_pointer(tp->md5sig_info, md5sig);
> >       }
> >
> > -     key = sock_kmalloc(sk, sizeof(*key), gfp);
> > +     key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
> >       if (!key)
> >               return -ENOMEM;
> >       if (!tcp_alloc_md5sig_pool()) {
> > --
> > 2.27.0.212.ge8ba1cc988-goog
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
