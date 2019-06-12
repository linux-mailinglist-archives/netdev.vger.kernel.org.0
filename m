Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F2542C4A
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407917AbfFLQaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:30:19 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:39850 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407237AbfFLQaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:30:19 -0400
Received: by mail-yb1-f193.google.com with SMTP id c5so6611020ybk.6
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nhzx+kpCEzUqDrllbveituGUXZPWfu764SQyvdoW+1A=;
        b=gggW7TWA2PoZVizCDTAYdTgTOYBI+rtIy0PargAPrk25OPuUxrgI1UEtHIYLT9qJ+t
         dtkSGWeo2TnABIQHkmYWjT5BPT9i3Zikcod733IlfHZiA3Q8Fe4bqYRP+tcD/kNGmI9e
         lgtEqlEuEbAY0LCLItDP46rP+1gjyaGutT51wOYnaBDEQQY3OOYpFFeYgJXLbYFa+zHr
         fSfrTmUCfQOdyWS2ml42baxQd+UuXq/jySDJBFx16/wr5C6tG8GgQsb6fb7MUc4LM+V5
         UrVbcqBK5PJrz0BEFWEocfh/Y8hBR7Gpd3sMutOsLVpG7fEUoCOcBXKs9AG5lhkW+Lfs
         YSJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nhzx+kpCEzUqDrllbveituGUXZPWfu764SQyvdoW+1A=;
        b=GY4xbZr2qSn/0bs38BG+MfHk7hS61lRIpqhrizT8KEUswCUBYc8/Z3ch4YHthOFP1I
         GG3E5WrNcBJEjJTlIeFGFUwEYkTrlBPhHd8wEGgqGaYItjFCzcZorjgienkfei8yky4J
         aPd/tmvdemNelz4JAv4qOJov+eGuVFwpPFNtgD/Pmu0k2FcGKyQqhp/j8VJlWqooJOCV
         PZQOA5xeM6R0CorKTKwNk69Lsl2uVHM9kGeieN9d+e17ZpfEXFa0GewQ60o68cOoMgit
         35okclxEvFBLpBfUy5SGa6nVYarqQGHgyiw7/phh8+WGFekx0ZvdjagQOPMI6Bl5NgqC
         jy4Q==
X-Gm-Message-State: APjAAAX6DlgsTKV04YVnjdXXonSb4eA87Kahtc0R/AUS307IBLCFX8EA
        ip1HSRIFcJn50eWWGpdgwyeD6dG/Nb4xJgVvEKTD6XDfsvw=
X-Google-Smtp-Source: APXvYqyCoc3td87Z0j++ONj4VNCv8i3Ptta0M5F8oTaZMjfLwZS6HDA0gQXLKE81fCrH7JA4gwQDm28H2J7fPyuwQFc=
X-Received: by 2002:a25:7642:: with SMTP id r63mr43131013ybc.253.1560357017816;
 Wed, 12 Jun 2019 09:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190612035715.166676-1-maowenan@huawei.com>
In-Reply-To: <20190612035715.166676-1-maowenan@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Jun 2019 09:30:06 -0700
Message-ID: <CANn89iJH6ZBH774SNrd2sUd_A5OBniiUVX=HBq6H4PXEW4cjwQ@mail.gmail.com>
Subject: Re: [PATCH net v2] tcp: avoid creating multiple req socks with the
 same tuples
To:     Mao Wenan <maowenan@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 8:49 PM Mao Wenan <maowenan@huawei.com> wrote:
>
> There is one issue about bonding mode BOND_MODE_BROADCAST, and
> two slaves with diffierent affinity, so packets will be handled
> by different cpu. These are two pre-conditions in this case.
>
> When two slaves receive the same syn packets at the same time,
> two request sock(reqsk) will be created if below situation happens:
> 1. syn1 arrived tcp_conn_request, create reqsk1 and have not yet called
> inet_csk_reqsk_queue_hash_add.
> 2. syn2 arrived tcp_v4_rcv, it goes to tcp_conn_request and create
> reqsk2
> because it can't find reqsk1 in the __inet_lookup_skb.
>
> Then reqsk1 and reqsk2 are added to establish hash table, and two synack
> with different
> seq(seq1 and seq2) are sent to client, then tcp ack arrived and will be
> processed in tcp_v4_rcv and tcp_check_req, if __inet_lookup_skb find the
> reqsk2, and
> tcp ack packet is ack_seq is seq1, it will be failed after checking:
> TCP_SKB_CB(skb)->ack_seq != tcp_rsk(req)->snt_isn + 1)
> and then tcp rst will be sent to client and close the connection.
>
> To fix this, call __inet_lookup_established() before __sk_nulls_add_node_rcu()
> in inet_ehash_insert(). If there is existed reqsk with same tuples in
> established hash table, directly to remove current reqsk2, and does not send
> synack to client.
>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  v2: move __inet_lookup_established from tcp_conn_request() to inet_ehash_insert()
>  as Eric suggested.
> ---
>  include/net/inet_connection_sock.h |  2 +-
>  net/ipv4/inet_connection_sock.c    | 16 ++++++++++++----
>  net/ipv4/inet_hashtables.c         | 13 +++++++++++++
>  net/ipv4/tcp_input.c               |  7 ++++---
>  4 files changed, 30 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index c57d53e7e02c..2d3538e333cb 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -263,7 +263,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
>  struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
>                                       struct request_sock *req,
>                                       struct sock *child);
> -void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
> +bool inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
>                                    unsigned long timeout);
>  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
>                                          struct request_sock *req,
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 13ec7c3a9c49..fd45ed2fd985 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -749,7 +749,7 @@ static void reqsk_timer_handler(struct timer_list *t)
>         inet_csk_reqsk_queue_drop_and_put(sk_listener, req);
>  }
>
> -static void reqsk_queue_hash_req(struct request_sock *req,
> +static bool reqsk_queue_hash_req(struct request_sock *req,
>                                  unsigned long timeout)
>  {
>         req->num_retrans = 0;
> @@ -759,19 +759,27 @@ static void reqsk_queue_hash_req(struct request_sock *req,
>         timer_setup(&req->rsk_timer, reqsk_timer_handler, TIMER_PINNED);
>         mod_timer(&req->rsk_timer, jiffies + timeout);
>
> -       inet_ehash_insert(req_to_sk(req), NULL);
> +       if (!inet_ehash_insert(req_to_sk(req), NULL)) {
> +               if (timer_pending(&req->rsk_timer))
> +                       del_timer_sync(&req->rsk_timer);
> +               return false;
> +       }
>         /* before letting lookups find us, make sure all req fields
>          * are committed to memory and refcnt initialized.
>          */
>         smp_wmb();
>         refcount_set(&req->rsk_refcnt, 2 + 1);
> +       return true;
>  }
>
> -void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
> +bool inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
>                                    unsigned long timeout)
>  {
> -       reqsk_queue_hash_req(req, timeout);
> +       if (!reqsk_queue_hash_req(req, timeout))
> +               return false;
> +
>         inet_csk_reqsk_queue_added(sk);
> +       return true;
>  }
>  EXPORT_SYMBOL_GPL(inet_csk_reqsk_queue_hash_add);
>
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index c4503073248b..b6a1b5334565 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -477,6 +477,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
>         struct inet_ehash_bucket *head;
>         spinlock_t *lock;
>         bool ret = true;
> +       struct sock *reqsk = NULL;
>
>         WARN_ON_ONCE(!sk_unhashed(sk));
>
> @@ -486,6 +487,18 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
>         lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
>
>         spin_lock(lock);
> +       if (!osk)
> +               reqsk = __inet_lookup_established(sock_net(sk), &tcp_hashinfo,
> +                                                       sk->sk_daddr, sk->sk_dport,
> +                                                       sk->sk_rcv_saddr, sk->sk_num,
> +                                                       sk->sk_bound_dev_if, sk->sk_bound_dev_if);
> +       if (unlikely(reqsk)) {

What reqsk would be a SYN_RECV socket, and not a ESTABLISH one (or a
TIME_WAIT ?)

> +               ret = false;
> +               reqsk_free(inet_reqsk(sk));
> +               spin_unlock(lock);
> +               return ret;
> +       }
> +
>         if (osk) {

This test should have be a hint here : Sometime we _expect_ to have an
old socket (TIMEWAIT) and remove it


>                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
>                 ret = sk_nulls_del_node_init_rcu(osk);
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 38dfc308c0fb..358272394590 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6570,9 +6570,10 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
>                 sock_put(fastopen_sk);
>         } else {
>                 tcp_rsk(req)->tfo_listener = false;
> -               if (!want_cookie)
> -                       inet_csk_reqsk_queue_hash_add(sk, req,
> -                               tcp_timeout_init((struct sock *)req));
> +               if (!want_cookie && !inet_csk_reqsk_queue_hash_add(sk, req,
> +                                       tcp_timeout_init((struct sock *)req)))
> +                       return 0;
> +
>                 af_ops->send_synack(sk, dst, &fl, req, &foc,
>                                     !want_cookie ? TCP_SYNACK_NORMAL :
>                                                    TCP_SYNACK_COOKIE);
> --
> 2.20.1
>

I believe the proper fix is more complicated.

Probably we need to move the locking in a less deeper location.

(Also a similar fix would be needed in IPv6)

Thanks.
