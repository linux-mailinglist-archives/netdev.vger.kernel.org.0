Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B0D2CD93A
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387844AbgLCOcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729355AbgLCOcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:32:52 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5330C061A51
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 06:32:05 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id z136so2250726iof.3
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 06:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agN1RaZrd0FXtXBU6s1nO4sdXrde3LkvPXyOS/toRsM=;
        b=vwX3S8gcSMLVPhTCtankaNblMFB6rPSXILMm1NvxSzc2ROLrcAAO+0O0a/tt9KD0Ej
         LBcqakQueKNpW3QumsbmzlrZawNFqFE/PG3nnmjBrqPbJclkha+L02A4/XeV1xks+jTE
         2EAP3vEHsiHVXK2Vk3glD6OiqVhKfiSH+icCXqMZ7OytLu20Msbn9dLoTs0Vgbov5A3x
         qnILrlHkvj1pOauW6JW7A4BVLftvX7fxBsUl+PPKgkr43Fj2MZcWej6DVOGUiR8f4KQT
         v4HzWkdMxa7/DvGXCjoFfgbOLKAaMnJz/f/wSkCYqAQL2d9lyy4yxu0n8JA6OlSV0y9A
         f1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agN1RaZrd0FXtXBU6s1nO4sdXrde3LkvPXyOS/toRsM=;
        b=dwlbA0qlSyVYU9tWaYgzOT6/1LZZFxfcaCqnCZwNe9ypS0yY1CiKonVGWC88d9vnuK
         fUUjvMeUTDpRtEx6PqF7dmffPmM1eTPic8Npqhev4jHwSmyaHVvvIzx0mPdHscXsmQsU
         r+NxCAprTD6CfbaLZJfyU/E70trtlMEspxACRbjQtt6x5QGCAgCxeCwkZT18F5fnES2L
         o0qfvgr99Donf4aDemw8qTkIq7a7lHR5O88SYt3hgyDWrrWhwJ9GslgXNJrPBCIxGGHq
         KV8bux9HvBYwyY0TSIgT/L7GNqaXlldgNrs+shM8BbWybVfedQoB4Nv48EA6LtODFKpo
         L/kQ==
X-Gm-Message-State: AOAM532X6ikPQnA02KYQ7lnTVZVl0mQJGKwTaIbhHRUAbEy6XQMt5Fll
        8KENIvGn2mmgmXjLmEgfviHTPN039Yx9BAK+qnxEgA==
X-Google-Smtp-Source: ABdhPJxZkA81Vqm2HhBWoBIqII8fpV0dQcTHqsYoUvx8W3kbmF01AxaFlR6c4N776uQFs7LFhdZrnikHnCWr1ylxzfk=
X-Received: by 2002:a02:95ab:: with SMTP id b40mr3571775jai.99.1607005924633;
 Thu, 03 Dec 2020 06:32:04 -0800 (PST)
MIME-Version: 1.0
References: <e47b903d-6e7c-a2a7-ccdf-d2c701986d4f@gmail.com> <20201203141424.52912-1-kuniyu@amazon.co.jp>
In-Reply-To: <20201203141424.52912-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Dec 2020 15:31:53 +0100
Message-ID: <CANn89i+MtOWryWzeDXnG-waOnqY8SxVxb_Q2Y4C=FdPGsKXivA@mail.gmail.com>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV
 sockets in accept queues.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 3:14 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> From:   Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Tue, 1 Dec 2020 16:25:51 +0100
> > On 12/1/20 3:44 PM, Kuniyuki Iwashima wrote:
> > > This patch lets reuseport_detach_sock() return a pointer of struct sock,
> > > which is used only by inet_unhash(). If it is not NULL,
> > > inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> > > sockets from the closing listener to the selected one.
> > >
> > > Listening sockets hold incoming connections as a linked list of struct
> > > request_sock in the accept queue, and each request has reference to a full
> > > socket and its listener. In inet_csk_reqsk_queue_migrate(), we only unlink
> > > the requests from the closing listener's queue and relink them to the head
> > > of the new listener's queue. We do not process each request and its
> > > reference to the listener, so the migration completes in O(1) time
> > > complexity. However, in the case of TCP_SYN_RECV sockets, we take special
> > > care in the next commit.
> > >
> > > By default, the kernel selects a new listener randomly. In order to pick
> > > out a different socket every time, we select the last element of socks[] as
> > > the new listener. This behaviour is based on how the kernel moves sockets
> > > in socks[]. (See also [1])
> > >
> > > Basically, in order to redistribute sockets evenly, we have to use an eBPF
> > > program called in the later commit, but as the side effect of such default
> > > selection, the kernel can redistribute old requests evenly to new listeners
> > > for a specific case where the application replaces listeners by
> > > generations.
> > >
> > > For example, we call listen() for four sockets (A, B, C, D), and close the
> > > first two by turns. The sockets move in socks[] like below.
> > >
> > >   socks[0] : A <-.      socks[0] : D          socks[0] : D
> > >   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
> > >   socks[2] : C   |      socks[2] : C --'
> > >   socks[3] : D --'
> > >
> > > Then, if C and D have newer settings than A and B, and each socket has a
> > > request (a, b, c, d) in their accept queue, we can redistribute old
> > > requests evenly to new listeners.
> > >
> > >   socks[0] : A (a) <-.      socks[0] : D (a + d)      socks[0] : D (a + d)
> > >   socks[1] : B (b)   |  =>  socks[1] : B (b) <-.  =>  socks[1] : C (b + c)
> > >   socks[2] : C (c)   |      socks[2] : C (c) --'
> > >   socks[3] : D (d) --'
> > >
> > > Here, (A, D) or (B, C) can have different application settings, but they
> > > MUST have the same settings at the socket API level; otherwise, unexpected
> > > error may happen. For instance, if only the new listeners have
> > > TCP_SAVE_SYN, old requests do not have SYN data, so the application will
> > > face inconsistency and cause an error.
> > >
> > > Therefore, if there are different kinds of sockets, we must attach an eBPF
> > > program described in later commits.
> > >
> > > Link: https://lore.kernel.org/netdev/CAEfhGiyG8Y_amDZ2C8dQoQqjZJMHjTY76b=KBkTKcBtA=dhdGQ@mail.gmail.com/
> > > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > ---
> > >  include/net/inet_connection_sock.h |  1 +
> > >  include/net/sock_reuseport.h       |  2 +-
> > >  net/core/sock_reuseport.c          | 10 +++++++++-
> > >  net/ipv4/inet_connection_sock.c    | 30 ++++++++++++++++++++++++++++++
> > >  net/ipv4/inet_hashtables.c         |  9 +++++++--
> > >  5 files changed, 48 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > > index 7338b3865a2a..2ea2d743f8fc 100644
> > > --- a/include/net/inet_connection_sock.h
> > > +++ b/include/net/inet_connection_sock.h
> > > @@ -260,6 +260,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
> > >  struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > >                                   struct request_sock *req,
> > >                                   struct sock *child);
> > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk);
> > >  void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
> > >                                unsigned long timeout);
> > >  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
> > > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > > index 0e558ca7afbf..09a1b1539d4c 100644
> > > --- a/include/net/sock_reuseport.h
> > > +++ b/include/net/sock_reuseport.h
> > > @@ -31,7 +31,7 @@ struct sock_reuseport {
> > >  extern int reuseport_alloc(struct sock *sk, bool bind_inany);
> > >  extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
> > >                           bool bind_inany);
> > > -extern void reuseport_detach_sock(struct sock *sk);
> > > +extern struct sock *reuseport_detach_sock(struct sock *sk);
> > >  extern struct sock *reuseport_select_sock(struct sock *sk,
> > >                                       u32 hash,
> > >                                       struct sk_buff *skb,
> > > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > > index fd133516ac0e..60d7c1f28809 100644
> > > --- a/net/core/sock_reuseport.c
> > > +++ b/net/core/sock_reuseport.c
> > > @@ -216,9 +216,11 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
> > >  }
> > >  EXPORT_SYMBOL(reuseport_add_sock);
> > >
> > > -void reuseport_detach_sock(struct sock *sk)
> > > +struct sock *reuseport_detach_sock(struct sock *sk)
> > >  {
> > >     struct sock_reuseport *reuse;
> > > +   struct bpf_prog *prog;
> > > +   struct sock *nsk = NULL;
> > >     int i;
> > >
> > >     spin_lock_bh(&reuseport_lock);
> > > @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
> > >
> > >             reuse->num_socks--;
> > >             reuse->socks[i] = reuse->socks[reuse->num_socks];
> > > +           prog = rcu_dereference(reuse->prog);
> > >
> > >             if (sk->sk_protocol == IPPROTO_TCP) {
> > > +                   if (reuse->num_socks && !prog)
> > > +                           nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
> > > +
> > >                     reuse->num_closed_socks++;
> > >                     reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
> > >             } else {
> > > @@ -264,6 +270,8 @@ void reuseport_detach_sock(struct sock *sk)
> > >             call_rcu(&reuse->rcu, reuseport_free_rcu);
> > >  out:
> > >     spin_unlock_bh(&reuseport_lock);
> > > +
> > > +   return nsk;
> > >  }
> > >  EXPORT_SYMBOL(reuseport_detach_sock);
> > >
> > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > index 1451aa9712b0..b27241ea96bd 100644
> > > --- a/net/ipv4/inet_connection_sock.c
> > > +++ b/net/ipv4/inet_connection_sock.c
> > > @@ -992,6 +992,36 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > >  }
> > >  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
> > >
> > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
> > > +{
> > > +   struct request_sock_queue *old_accept_queue, *new_accept_queue;
> > > +
> > > +   old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
> > > +   new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
> > > +
> > > +   spin_lock(&old_accept_queue->rskq_lock);
> > > +   spin_lock(&new_accept_queue->rskq_lock);
> >
> > Are you sure lockdep is happy with this ?
> >
> > I would guess it should complain, because :
> >
> > lock(A);
> > lock(B);
> > ...
> > unlock(B);
> > unlock(A);
> >
> > will fail when the opposite action happens eventually
> >
> > lock(B);
> > lock(A);
> > ...
> > unlock(A);
> > unlock(B);
>
> I enabled lockdep and did not see warnings of lockdep.
>
> Also, the inversion deadlock does not happen in this case.
> In reuseport_detach_sock(), sk is moved backward in socks[] and poped out
> from the eBPF map, so the old listener will not be selected as the new
> listener.

Until the socket is closed, reallocated and used again. LOCKDEP has no
idea about soreuseport logic.

If you run your tests long enough, lockdep should complain at some point.

git grep -n double_lock
