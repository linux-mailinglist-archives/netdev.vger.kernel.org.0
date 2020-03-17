Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4440E18780B
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 04:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgCQDSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 23:18:16 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34065 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgCQDSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 23:18:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id x3so14669457wmj.1;
        Mon, 16 Mar 2020 20:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YQGjvHknB6zDlVk+ed/YittlC9xBHcBBwyN5Yg1ksag=;
        b=K0NEheKD/j1cplTNeJaRm5ZHYGMSRfiXuP/Ik4Y+XjrtljcvYssqW7I4FsdW8DQpwM
         CvvqfBnVTZzY4lBFdm5l9kJn135/1SmHtMN4woSXPrr7t60k49KMer9yL1UJvtJxU0/h
         AmBBvdHIirNY2F6HkL9DOVVlREbj1l5+Y9YtwPlSytYEJJJ7CJTx1rzfSe0uwqX32qiK
         3Vv/mIvGdWrfW4bO5HaKy96h4Cky8QKu+nAVaLJf5g6yZkanVCvsLRi6QkTalI7zPc6x
         mmuW1zzS32veSQp2J/vXoWA3OsaD6aG1NuPHo1IvzKVVccGc+Pg59V9q72kBkcn0/RQR
         KLZg==
X-Gm-Message-State: ANhLgQ2Fv/tK3WcNztmzHD+9KAr9xdSEXgJfAMyF4U9OkZuOUF2fMh5K
        y+8LDCqxyhctlLZZT2Oq1BnA1aergrMdOh2Y3ZQ=
X-Google-Smtp-Source: ADFU+vu2j2iPXnw+5nE+9yYnQR8ga9l/jUSj6eic7p39KqgHl7rSS09+u93gO8OuWVOf+8Venz6rGeYNcxi4YMiumM8=
X-Received: by 2002:a7b:c208:: with SMTP id x8mr2437860wmi.136.1584415093884;
 Mon, 16 Mar 2020 20:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-5-joe@wand.net.nz>
 <20200316230312.oxgsjpyzhp5iiyyx@kafai-mbp>
In-Reply-To: <20200316230312.oxgsjpyzhp5iiyyx@kafai-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Mon, 16 Mar 2020 20:17:59 -0700
Message-ID: <CAOftzPjMO2Y=efeqYZCzYd2JX8JZULfvCNw2mc-io1anxNYgGA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/7] dst: Prefetch established socket destinations
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 4:03 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Mar 12, 2020 at 04:36:45PM -0700, Joe Stringer wrote:
> > Enhance the dst_sk_prefetch logic to temporarily store the socket
> > receive destination, to save the route lookup later on. The dst
> > reference is kept alive by the caller's socket reference.
> >
> > Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > ---
> >  include/net/dst_metadata.h |  2 +-
> >  net/core/dst.c             | 20 +++++++++++++++++---
> >  net/core/filter.c          |  2 +-
> >  3 files changed, 19 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> > index 31574c553a07..4f16322b08d5 100644
> > --- a/include/net/dst_metadata.h
> > +++ b/include/net/dst_metadata.h
> > @@ -230,7 +230,7 @@ static inline bool skb_dst_is_sk_prefetch(const struct sk_buff *skb)
> >       return dst_is_sk_prefetch(skb_dst(skb));
> >  }
> >
> > -void dst_sk_prefetch_store(struct sk_buff *skb);
> > +void dst_sk_prefetch_store(struct sk_buff *skb, struct sock *sk);
> >  void dst_sk_prefetch_fetch(struct sk_buff *skb);
> >
> >  /**
> > diff --git a/net/core/dst.c b/net/core/dst.c
> > index cf1a1d5b6b0a..5068d127d9c2 100644
> > --- a/net/core/dst.c
> > +++ b/net/core/dst.c
> > @@ -346,11 +346,25 @@ EXPORT_SYMBOL(dst_sk_prefetch);
> >
> >  DEFINE_PER_CPU(unsigned long, dst_sk_prefetch_dst);
> >
> > -void dst_sk_prefetch_store(struct sk_buff *skb)
> > +void dst_sk_prefetch_store(struct sk_buff *skb, struct sock *sk)
> >  {
> > -     unsigned long refdst;
> > +     unsigned long refdst = 0L;
> > +
> > +     WARN_ON(!rcu_read_lock_held() &&
> > +             !rcu_read_lock_bh_held());
> > +     if (sk_fullsock(sk)) {
> > +             struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
> > +
> > +             if (dst)
> > +                     dst = dst_check(dst, 0);
> v6 requires a cookie.  tcp_v6_early_demux() could be a good example.

Nice catch. I plan to roll in the following incremental for v2:

diff --git a/net/core/dst.c b/net/core/dst.c
index 5068d127d9c2..b60f85227247 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -354,9 +354,14 @@ void dst_sk_prefetch_store(struct sk_buff *skb,
struct sock *sk)
                !rcu_read_lock_bh_held());
        if (sk_fullsock(sk)) {
                struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
+               u32 cookie = 0;

+#if IS_ENABLED(CONFIG_IPV6)
+               if (sk->sk_family == AF_INET6)
+                       cookie = inet6_sk(sk)->rx_dst_cookie;
+#endif
                if (dst)
-                       dst = dst_check(dst, 0);
+                       dst = dst_check(dst, cookie);
                if (dst)
                        refdst = (unsigned long)dst | SKB_DST_NOREF;
        }
