Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1586E444A82
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 22:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhKCV4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 17:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhKCV4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 17:56:03 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A14C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 14:53:26 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id o12so2392898qtv.4
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 14:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y5yViOvC6RA5JDl148fU1moRhu8R+VlapXkdDDZCHts=;
        b=p6UEIvkXrCyxORxgdjcp8r8dcYzY3KsV4rC0fvDpKzGF1GE53gNMGQwHHDcssmIFHY
         50R9WgEcnY96rLNeghGl61oImHODS1u3DCLlftsVNFrkQ2M2roN9dHbNJngjjIZLyfHC
         6J0AzvWJVTm2ymTMwuLrtfN8+SGGbqms3JqZwwZtSgeE8aVTXMMoX4YfxOcp8PYYs+Iv
         yVVxjGgujWbqEvGUx9BAceQR44NwHafrxubAv96NmZ36UFOblvFX0x1+cUJuPYzi9XGa
         n9+fO+4mUQ7/xC7HX0X1+k6cogZgZnBoRY0ssscr5jwnZdT62AOFhQwstEmiUBzwduD/
         TFCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y5yViOvC6RA5JDl148fU1moRhu8R+VlapXkdDDZCHts=;
        b=2vihTZwUTs0ysePRqga7QOe50zSDQtMBAG+vF/XyFaPUqR1dS+gu/SbGRpn7M0j9Ir
         Il3EiuknyZ5Ur+1mUcnsW6bi/AZnqSIELtOWbEw0Csi8ywugtw4CvVvmNTyVsY7Y38t8
         B/8rIt57IQM3mRg0L9F45hE7HfCseH7+9YUteAdo39TYozPKbFPS0axJY/NwjmprMEQO
         9z12gHQnI8POZ8xpffT877/mcJfhZzcs79m02Ys67zLESVS6QJSofUnXGBrnn1IBgYVv
         3qxHH/R8EcwoGy9nLmjYtUd1zi4vno95oChNGa0PrdoSJZA7Jnf8reRw2FK4m3xgkah5
         8dPw==
X-Gm-Message-State: AOAM532GlNqJ5IU++8z7owkVkSbfsFZsBY5LCmazIk1rZrMQ/P94Qzz6
        n3tgdU8TuuMJFQ6oMJ8aVtnsy/b/IjxAvljt+4pNbg==
X-Google-Smtp-Source: ABdhPJxbbzLwCSCYd/+nyVlI2I3eMUyN4oQ8aWH9uMXO8OSHsuc/rUZ6YWgkDlOkq2zVPyF5qbaf6S9ARCrDD7VWLv4=
X-Received: by 2002:ac8:7fd5:: with SMTP id b21mr50588400qtk.101.1635976405310;
 Wed, 03 Nov 2021 14:53:25 -0700 (PDT)
MIME-Version: 1.0
References: <20211025121253.8643-1-hmukos@yandex-team.ru> <20211103204607.21491-1-hmukos@yandex-team.ru>
 <CAK6E8=dfHURjNyLbPEqvFvP9nQh45PFGjK05MJaAxMU-LEboag@mail.gmail.com>
In-Reply-To: <CAK6E8=dfHURjNyLbPEqvFvP9nQh45PFGjK05MJaAxMU-LEboag@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 3 Nov 2021 17:53:08 -0400
Message-ID: <CADVnQymw1A18bgGX=ujOmsVijQrfvSSnmtwRAqdx_JWCeNnvnw@mail.gmail.com>
Subject: Re: [PATCH v3] tcp: Use BPF timeout setting for SYN ACK RTO
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Akhmat Karakotov <hmukos@yandex-team.ru>, kafai@fb.com,
        brakmo@fb.com, eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        netdev@vger.kernel.org, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 5:23 PM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Wed, Nov 3, 2021 at 1:46 PM Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
> >
> > When setting RTO through BPF program, some SYN ACK packets were unaffected
> > and continued to use TCP_TIMEOUT_INIT constant. This patch adds timeout
> > option to struct request_sock. Option is initialized with TCP_TIMEOUT_INIT
> > and is reassigned through BPF using tcp_timeout_init call. SYN ACK
> > retransmits now use newly added timeout option.
> >
> > Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> > ---
> >  include/net/request_sock.h      |  2 ++
> >  include/net/tcp.h               |  2 +-
> >  net/ipv4/inet_connection_sock.c |  4 +++-
> >  net/ipv4/tcp_input.c            |  8 +++++---
> >  net/ipv4/tcp_minisocks.c        | 12 +++++++++---
> >  5 files changed, 20 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> > index 29e41ff3ec93..144c39db9898 100644
> > --- a/include/net/request_sock.h
> > +++ b/include/net/request_sock.h
> > @@ -70,6 +70,7 @@ struct request_sock {
> >         struct saved_syn                *saved_syn;
> >         u32                             secid;
> >         u32                             peer_secid;
> > +       u32                             timeout;
> >  };
> >
> >  static inline struct request_sock *inet_reqsk(const struct sock *sk)
> > @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
> >         sk_node_init(&req_to_sk(req)->sk_node);
> >         sk_tx_queue_clear(req_to_sk(req));
> >         req->saved_syn = NULL;
> > +       req->timeout = 0;
> >         req->num_timeout = 0;
> >         req->num_retrans = 0;
> >         req->sk = NULL;
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 3166dc15d7d6..e328d6735e38 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -2323,7 +2323,7 @@ static inline u32 tcp_timeout_init(struct sock *sk)
> >
> >         if (timeout <= 0)
> >                 timeout = TCP_TIMEOUT_INIT;
> > -       return timeout;
> > +       return min_t(int, timeout, TCP_RTO_MAX);
> >  }
> >
> >  static inline u32 tcp_rwnd_init_bpf(struct sock *sk)
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index 0d477c816309..cdf16285e193 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -870,7 +870,9 @@ static void reqsk_timer_handler(struct timer_list *t)
> >
> >                 if (req->num_timeout++ == 0)
> >                         atomic_dec(&queue->young);
> > -               timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
> > +               timeo = min_t(unsigned long,
> > +                             (unsigned long)req->timeout << req->num_timeout,
> > +                             TCP_RTO_MAX);
>
> would it make sense to have a helper tcp_timeout_max() to reduce
> clutter? but that can be done by a later refactor patch

I like Yuchung's idea to have a helper function (perhaps
reqsk_timeout() to go with reqsk_timer_handler()?)  to calculate the
timeout value, since there are 3 of these non-trivial expressions.
Otherwise this looks good to me.

thanks,
neal
