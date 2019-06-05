Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2072435593
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 05:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfFEDQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 23:16:15 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36338 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfFEDQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 23:16:13 -0400
Received: by mail-yw1-f66.google.com with SMTP id e68so9841382ywf.3
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 20:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y75P1/ErSIyv72orUsMfb5JgYyZ3hNu4HCrS9iG1iXc=;
        b=tj8cO1zio/IWhqQFHAJ4Y7iB0pelLNpvfevYtzqv+USqZaYjtNRNJG41w0Z6wJxeUl
         DETQtuAqO/jhScmdSekz14z+avuZyNqRp6JpcJOlkWZTEjf3mR3RF0JhuGetdYdDI2kL
         sHz3/9K/h7Wc0n0p4+azHwEwjtRTODD6IW90wyIYsXUMe9WwS++W8tB7snVzkHyfmNNd
         xqVf2QmsRIxwVieRLmBCbaygZudW/WZpmDJTiLD4wRmN17pV6bch43cDm2adcGFWbDCj
         cbot0bobbBhvuIObtmyE56cf69CPnFzbfdc6kRwFRRwiV9AQv3lnQ9J5mCSXIliGZo5X
         yJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y75P1/ErSIyv72orUsMfb5JgYyZ3hNu4HCrS9iG1iXc=;
        b=Y/tgKZztqPF7VwQibrLVVq0b909VmnXCY7O4uoOdaIgYE2cOFij6XjKQaMut1xu+0E
         Ap5zTb7XsnrBcpnKWznhnV5WnWECSoBvPUObO5Gm874RG+M49pFhw/FScUh+N+WJiKBQ
         hFS5Y+Ek5gtSNG7/P5U8DBRA3xbzpz/pjangnFwJKryj1Ky9Z9M8yDjELlQ9gCROmC21
         bN9791AAPkjI4KFQjiWA0rTkYq/Uqd9DT08UPNu/bYfOR7pbReizm+b5Klxnnt+z7g8h
         yw3vVMdo4F7APwdcYCOLLplyvGZp4jZM+/rL5KbUi2B6rUscWqQypZhb+CNSDnfuA0pI
         AySw==
X-Gm-Message-State: APjAAAU16ugNM01fmRZEwsnBE6an5UFpHksUx8y5srMBzFyPXZUVY1wR
        X1sv0f22JWRulM+V64VadJbRkEAdvV0omi0ncAm9ng==
X-Google-Smtp-Source: APXvYqy/rM0CSbXUGSIJoBuRrf5/klh7h/sc/F4kOxX1LncZYNAmGlXSDCS+MUtfnfIbOLWxxhpSJfXu4dg371XB+p4=
X-Received: by 2002:a81:6f84:: with SMTP id k126mr6892702ywc.496.1559704571583;
 Tue, 04 Jun 2019 20:16:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190604145543.61624-1-maowenan@huawei.com> <CANn89iK+4QC7bbku5MUczzKnWgL6HG9JAT6+03Q2paxBKhC4Xw@mail.gmail.com>
 <4d406802-d8a2-2d92-90c3-d56b8a23c2b2@huawei.com>
In-Reply-To: <4d406802-d8a2-2d92-90c3-d56b8a23c2b2@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Jun 2019 20:16:00 -0700
Message-ID: <CANn89i+hut7UVG3DZDA4GgzE0PydZH-fcy0MGcBFRkC-FY0eig@mail.gmail.com>
Subject: Re: [PATCH net] tcp: avoid creating multiple req socks with the same tuples
To:     maowenan <maowenan@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 7:07 PM maowenan <maowenan@huawei.com> wrote:
>
>
>
> On 2019/6/4 23:24, Eric Dumazet wrote:
> > On Tue, Jun 4, 2019 at 7:47 AM Mao Wenan <maowenan@huawei.com> wrote:
> >>
> >> There is one issue about bonding mode BOND_MODE_BROADCAST, and
> >> two slaves with diffierent affinity, so packets will be handled
> >> by different cpu. These are two pre-conditions in this case.
> >>
> >> When two slaves receive the same syn packets at the same time,
> >> two request sock(reqsk) will be created if below situation happens:
> >> 1. syn1 arrived tcp_conn_request, create reqsk1 and have not yet called
> >> inet_csk_reqsk_queue_hash_add.
> >> 2. syn2 arrived tcp_v4_rcv, it goes to tcp_conn_request and create reqsk2
> >> because it can't find reqsk1 in the __inet_lookup_skb.
> >>
> >> Then reqsk1 and reqsk2 are added to establish hash table, and two synack with different
> >> seq(seq1 and seq2) are sent to client, then tcp ack arrived and will be
> >> processed in tcp_v4_rcv and tcp_check_req, if __inet_lookup_skb find the reqsk2, and
> >> tcp ack packet is ack_seq is seq1, it will be failed after checking:
> >> TCP_SKB_CB(skb)->ack_seq != tcp_rsk(req)->snt_isn + 1)
> >> and then tcp rst will be sent to client and close the connection.
> >>
> >> To fix this, do lookup before calling inet_csk_reqsk_queue_hash_add
> >> to add reqsk2 to hash table, if it finds the existed reqsk1 with the same five tuples,
> >> it removes reqsk2 and does not send synack to client.
> >>
> >> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> >> ---
> >>  net/ipv4/tcp_input.c | 9 +++++++++
> >>  1 file changed, 9 insertions(+)
> >>
> >> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> >> index 08a477e74cf3..c75eeb1fe098 100644
> >> --- a/net/ipv4/tcp_input.c
> >> +++ b/net/ipv4/tcp_input.c
> >> @@ -6569,6 +6569,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
> >>                 bh_unlock_sock(fastopen_sk);
> >>                 sock_put(fastopen_sk);
> >>         } else {
> >> +               struct sock *sk1 = req_to_sk(req);
> >> +               struct sock *sk2 = NULL;
> >> +               sk2 = __inet_lookup_established(sock_net(sk1), &tcp_hashinfo,
> >> +                                                                       sk1->sk_daddr, sk1->sk_dport,
> >> +                                                                       sk1->sk_rcv_saddr, sk1->sk_num,
> >> +                                                                       inet_iif(skb),inet_sdif(skb));
> >> +               if (sk2 != NULL)
> >> +                       goto drop_and_release;
> >> +
> >>                 tcp_rsk(req)->tfo_listener = false;
> >>                 if (!want_cookie)
> >>                         inet_csk_reqsk_queue_hash_add(sk, req,
> >
> > This issue has been discussed last year.
> Can you share discussion information?


https://www.spinics.net/lists/netdev/msg507423.html


>
> >
> > I am afraid your patch does not solve all races.
> >
> > The lookup you add is lockless, so this is racy.
> it's right, it has already in race region.
> >
> > Really the only way to solve this is to make sure that _when_ the
> > bucket lock is held,
> > we do not insert a request socket if the 4-tuple is already in the
> > chain (probably in inet_ehash_insert())
> >
>
> put lookup code in spin_lock() of inet_ehash_insert(), is it ok like this?
> will it affect performance?
>
> in inet_ehash_insert():
> ...
>         spin_lock(lock);
> +       reqsk = __inet_lookup_established(sock_net(sk), &tcp_hashinfo,
> +                                                       sk->sk_daddr, sk->sk_dport,
> +                                                       sk->sk_rcv_saddr, sk->sk_num,
> +                                                       sk_bound_dev_if, sk_bound_dev_if);
> +       if (reqsk) {

You should test this before asking :)


> +               spin_unlock(lock);
> +               return ret;
> +       }
> +
>         if (osk) {
>                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
>                 ret = sk_nulls_del_node_init_rcu(osk);
>         }
>         if (ret)
>                 __sk_nulls_add_node_rcu(sk, list);
>         spin_unlock(lock);
> ...
>
> > This needs more tricky changes than your patch.
> >
> > .
> >
>
