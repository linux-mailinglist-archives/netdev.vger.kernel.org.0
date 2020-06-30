Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3210E2100B7
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 01:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgF3Xu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 19:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgF3XuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 19:50:25 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF17C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 16:50:25 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 187so11018909ybq.2
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 16:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J5qJjQFGVqQ7JRdQbjaGio6A0yzSVtMOUeIo66TyX/w=;
        b=kVspSocSNitFFTRarZ6EJBzGBhZgT8j4Y5UdM8BV43m7rByUOw+arerYzZ56LgK118
         4WaoH3Eq2dSKR7sVMED9qHx6HFRDcrLOdy7garqkPyw/hgHr4Y8KFMh6wMv6kWbfhJhy
         TmwQT9WG4c92QLgtw0TzjUVxYfjERFyLD+wS3PhF05yAEt3yO0lFwv/2f1AGyWxy3R/x
         0HSyn3w6naBfgc/yo2opaLjtf/sEAyU87uzUi96JgjfSSS+pitNF/eRkGW1PU3dmOgT4
         xuMZBEeljsoZGpMvjbolf1LguRtDhm2F/g9IJj8KBe410fTExsLPMU+27xRLbZIjfeHI
         sw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J5qJjQFGVqQ7JRdQbjaGio6A0yzSVtMOUeIo66TyX/w=;
        b=pQGMBhpMSlVsrkgMRVfOpdsRaKlQbCO6NAfPJ8ZHPQZoCqX/zyxLNVQXlZuY4hkLZH
         ZMfyEugIVelz/wv2CB4RHcRtdvvv7JNMjMGf+gBeg7bpZc3uf6BAiqF35wRqINB9jz4v
         hVlttQvtuViWrF9GvzfQyXGcppI8/AO0JxbKXPzkgv/mw0TFbXM5i9ImfaTR8Uzi51h2
         pqMIKRNkSI7vIg+PRwNIzwlg9xnObIo2SE22BgzJYcT9WiWxJ4UaKVk/SSFcpuWSQjtj
         cCih0TOmNtuUe26axSQunXLrkGsKw3lBgc0N9NM20Yye5PKUrohsjRiRGAbQsLv9fJv9
         q6dA==
X-Gm-Message-State: AOAM5300OdAX9W05zgsYUzZFF3bgDT3t5vzIfOF8tn6DBNhvxZx47djp
        em+zDmyjaU+eCd7eeH28I+luSlYBFKIaAkvFuB9Scg==
X-Google-Smtp-Source: ABdhPJxXRSSbI6uM9Lp98EQKb0iAr/PfOtLKHPYTupY27KLULZ1NtBT4MrBZ0sQV7l0fxjL70hCz6lZK34OkZpcrCVY=
X-Received: by 2002:a25:d28e:: with SMTP id j136mr39610336ybg.408.1593561024232;
 Tue, 30 Jun 2020 16:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200630234101.3259179-1-edumazet@google.com> <1359584061.18162.1593560822147.JavaMail.zimbra@efficios.com>
In-Reply-To: <1359584061.18162.1593560822147.JavaMail.zimbra@efficios.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 16:50:12 -0700
Message-ID: <CANn89iKHBkTbT9fZ3qbfZKE25MuS=av+frnRerGvP+_gUHPSAA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 4:47 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Jun 30, 2020, at 7:41 PM, Eric Dumazet edumazet@google.com wrote:
>
> > MD5 keys are read with RCU protection, and tcp_md5_do_add()
> > might update in-place a prior key.
> >
> > Normally, typical RCU updates would allocate a new piece
> > of memory. In this case only key->key and key->keylen might
> > be updated, and we do not care if an incoming packet could
> > see the old key, the new one, or some intermediate value,
> > since changing the key on a live flow is known to be problematic
> > anyway.
>
> What makes it acceptable to observe an intermediate bogus key during the
> transition ?

If you change a key while packets are in flight, the result is that :

1) Either your packet has the correct key and is handled

2) Or the key do not match, packet is dropped.

 Sender will retransmit eventually.

If this was not the case, then we could not revert the patch you are
complaining about :)

>
> Thanks,
>
> Mathieu
>
> >
> > We only want to make sure that in the case key->keylen
> > is changed, cpus in tcp_md5_hash_key() wont try to use
> > uninitialized data, or crash because key->keylen was
> > read twice to feed sg_init_one() and ahash_request_set_crypt()
> >
> > Fixes: 9ea88a153001 ("tcp: md5: check md5 signature without socket lock")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > ---
> > net/ipv4/tcp.c      | 7 +++++--
> > net/ipv4/tcp_ipv4.c | 3 +++
> > 2 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index
> > 810cc164f795f8e1e8ca747ed5df51bb20fec8a2..f111660453241692a17c881dd6dc2910a1236263
> > 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4033,10 +4033,13 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
> >
> > int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key
> > *key)
> > {
> > +     u8 keylen = key->keylen;
> >       struct scatterlist sg;
> >
> > -     sg_init_one(&sg, key->key, key->keylen);
> > -     ahash_request_set_crypt(hp->md5_req, &sg, NULL, key->keylen);
> > +     smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
> > +
> > +     sg_init_one(&sg, key->key, keylen);
> > +     ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
> >       return crypto_ahash_update(hp->md5_req);
> > }
> > EXPORT_SYMBOL(tcp_md5_hash_key);
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index
> > ad6435ba6d72ffd8caf783bb25cad7ec151d6909..99916fcc15ca0be12c2c133ff40516f79e6fdf7f
> > 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -1113,6 +1113,9 @@ int tcp_md5_do_add(struct sock *sk, const union
> > tcp_md5_addr *addr,
> >       if (key) {
> >               /* Pre-existing entry - just update that one. */
> >               memcpy(key->key, newkey, newkeylen);
> > +
> > +             smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
> > +
> >               key->keylen = newkeylen;
> >               return 0;
> >       }
> > --
> > 2.27.0.212.ge8ba1cc988-goog
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
