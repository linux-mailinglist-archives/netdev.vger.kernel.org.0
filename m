Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1042EEAE6
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 02:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbhAHB0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 20:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729762AbhAHB0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 20:26:30 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F03C0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 17:25:50 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id 19so7253428qkm.8
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 17:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1k/Ogyrw6vVDjTuX6MPteLqqKUXwsFytxRp5VKfbrf0=;
        b=ZQPt/vBnIQWkldwaYU/37YO/6y9WgsgLRyNNqfhkZvKAixLjUOgM6WqR+rPc++yBDP
         puKFJN6OpEpYr5gDWG/jioClGjaSl3pfKKma0okdjr2vwsFraTNQsvm8iZ53JccTUFnX
         y/4RH0V56d+r/pxMMDy0JaHKdevPM4IuHlA+wPsmhhPLU22C/3WbTvCDm/U74BvPmlf2
         VksyN3yDsKNCjsFdH+SbmVSpFUAJ1GREtaXUGVB/+RB19/9lzA0lgddCGADkKrTNlYaf
         EaPsEHyjAOD503bSk6Ynf5JCOyQ/A4sP98iYgpeUX5l4PZQZ9jysLyH64gJ2rEgT4DcA
         +LNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1k/Ogyrw6vVDjTuX6MPteLqqKUXwsFytxRp5VKfbrf0=;
        b=X6otH4QJ8/QYg1QnP0R6vn94xPF9ArWECHmne3Xj2z0oI3h9vZW9HREu6Bq5sK0wNQ
         4nbwH25LPyYKa2R2DskXunnLYCIvwZjGP4+dRqibVoUidsqNWrmHQnB2KNwJMM+XzMRh
         B3Jm/gmAD+CgaGfHKBAUQDHLDeVoTTBLgmYTUpU+UjfCXUrUowaOsLj7Zr4kGBQRwwyU
         MbGKZbsh7V5XjxxtoK3pgbyPpszhXnxkAdhBSjiI/7/CIsz+ZpXlZMuqM29Tl/Mw/jT9
         nVzovnfZUOoZQAloECxjs5n/16DD/tgbM2AM9oa4VLB52e7iJPTrAE+blwevG+bvAQTV
         SKCw==
X-Gm-Message-State: AOAM532BplINGx6PAAfi9DPxnj1SnKhfXBiTplrYKv6pb1dK1hnAEflA
        tiWryJFksK5ucgW3a2Y2rSzt2a/1H0msExMEBcyuSw==
X-Google-Smtp-Source: ABdhPJzIbxYr8zr61BsZuw1P1HXC+XxFW9r/LO/95pWdSoYKQ76QFqCvjPSgB4N4amVbp+qcLJwDLtC+sFMMpGXw3BM=
X-Received: by 2002:a05:620a:22ab:: with SMTP id p11mr1798108qkh.237.1610069149346;
 Thu, 07 Jan 2021 17:25:49 -0800 (PST)
MIME-Version: 1.0
References: <20210107184305.444635-1-sdf@google.com> <20210107184305.444635-4-sdf@google.com>
 <20210108010658.eglr2ev77knejkua@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210108010658.eglr2ev77knejkua@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 7 Jan 2021 17:25:38 -0800
Message-ID: <CAKH8qBsWZtgXfV3WrXcBXJAVBEWNKxSYG1Ucz0z+J32a3k2Erw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 5:09 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Jan 07, 2021 at 10:43:05AM -0800, Stanislav Fomichev wrote:
> > Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > call in do_tcp_getsockopt using the on-stack data. This removes
> > 2% overhead for locking/unlocking the socket.
> >
> > Also:
> > - Removed BUILD_BUG_ON (zerocopy doesn't depend on the buf size anymore)
> > - Separated on-stack buffer into bpf_sockopt_buf and downsized to 32 bytes
> >   (let's keep it to help with the other options)
> >
> > (I can probably split this patch into two: add new features and rework
> >  bpf_sockopt_buf; can follow up if the approach in general sounds
> >  good).
> >
> > Without this patch:
> >      1.87%     0.06%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> >
> > With the patch applied:
> >      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Cc: Song Liu <songliubraving@fb.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > ---
> >  include/linux/bpf-cgroup.h                    | 25 ++++-
> >  include/linux/filter.h                        |  6 +-
> >  include/net/sock.h                            |  2 +
> >  include/net/tcp.h                             |  1 +
> >  kernel/bpf/cgroup.c                           | 93 +++++++++++++------
> >  net/ipv4/tcp.c                                | 14 +++
> >  net/ipv4/tcp_ipv4.c                           |  1 +
> >  net/ipv6/tcp_ipv6.c                           |  1 +
> >  .../selftests/bpf/prog_tests/sockopt_sk.c     | 22 +++++
> >  .../testing/selftests/bpf/progs/sockopt_sk.c  | 15 +++
> >  10 files changed, 147 insertions(+), 33 deletions(-)
> >
>
> [ ... ]
>
> > @@ -454,6 +469,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
> >  #define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen) ({ 0; })
> >  #define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, \
> >                                      optlen, max_optlen, retval) ({ retval; })
> > +#define BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sock, level, optname, optval, \
> > +                                         optlen, retval) ({ retval; })
> >  #define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen, \
> >                                      kernel_optval) ({ 0; })
> >
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 54a4225f36d8..8739f1d4cac4 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -1281,7 +1281,10 @@ struct bpf_sysctl_kern {
> >       u64 tmp_reg;
> >  };
> >
> > -#define BPF_SOCKOPT_KERN_BUF_SIZE    64
> > +#define BPF_SOCKOPT_KERN_BUF_SIZE    32
> It is reduced from patch 1 because there is no
> need to use the buf (and copy from/to buf) in TCP_ZEROCOPY_RECEIVE?
>
> Patch 1 is still desired (and kept in this set) because it may still
> benefit other optname?
Right, it seems like a good idea to keep it to help with the (majority?)
of small socket options.

> > +struct bpf_sockopt_buf {
> > +     u8              data[BPF_SOCKOPT_KERN_BUF_SIZE];
> > +};
> >
> >  struct bpf_sockopt_kern {
> >       struct sock     *sk;
> > @@ -1291,7 +1294,6 @@ struct bpf_sockopt_kern {
> >       s32             optname;
> >       s32             optlen;
> >       s32             retval;
> > -     u8              buf[BPF_SOCKOPT_KERN_BUF_SIZE];
> It is better to pick one way to do thing to avoid code
> churn like this within the same series.
Agreed. I pointed it out in the commit description that it might be a
good idea to separate those changes.
I wasn't sure about the fate of this patch when I first sent it out
and didn't spend too much time on this sort of stuff.
Let me simplify/reorder as you suggested below and resend.

> >  };
> >
> >  int copy_bpf_fprog_from_user(struct sock_fprog *dst, sockptr_t src, int len);
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index bdc4323ce53c..ebf44d724845 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1174,6 +1174,8 @@ struct proto {
> >
> >       int                     (*backlog_rcv) (struct sock *sk,
> >                                               struct sk_buff *skb);
> > +     bool                    (*bpf_bypass_getsockopt)(int level,
> > +                                                      int optname);
> >
> >       void            (*release_cb)(struct sock *sk);
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 78d13c88720f..4bb42fb19711 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -403,6 +403,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock,
> >                     struct poll_table_struct *wait);
> >  int tcp_getsockopt(struct sock *sk, int level, int optname,
> >                  char __user *optval, int __user *optlen);
> > +bool tcp_bpf_bypass_getsockopt(int level, int optname);
> >  int tcp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
> >                  unsigned int optlen);
> >  void tcp_set_keepalive(struct sock *sk, int val);
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index adbecdcaa370..e82df63aedc7 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -16,7 +16,6 @@
> >  #include <linux/bpf-cgroup.h>
> >  #include <net/sock.h>
> >  #include <net/bpf_sk_storage.h>
> > -#include <uapi/linux/tcp.h> /* sizeof(struct tcp_zerocopy_receive) */
> Can the patches be re-ordered a little to avoid code churn like this
> in the same series?
>
> It feels like this patch 3 should be the first patch instead.
> The current patch 1 should be the second patch
> but it can still use the tcp_mmap to show potential
> benefit for other optnames.
>
> >
> >  #include "../cgroup/cgroup-internal.h"
> >
> > @@ -1299,7 +1298,8 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
> >       return empty;
> >  }
> >
> > -static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
> > +static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen,
> > +                          struct bpf_sockopt_buf *buf)
> >  {
> >       if (unlikely(max_optlen < 0))
> >               return -EINVAL;
> > @@ -1311,18 +1311,11 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
> >               max_optlen = PAGE_SIZE;
> >       }
> >
> > -     if (max_optlen <= sizeof(ctx->buf)) {
> > +     if (max_optlen <= sizeof(buf->data)) {
> >               /* When the optval fits into BPF_SOCKOPT_KERN_BUF_SIZE
> >                * bytes avoid the cost of kzalloc.
> > -              *
> > -              * In order to remove extra allocations from the TCP
> > -              * fast zero-copy path ensure that buffer covers
> > -              * the size of struct tcp_zerocopy_receive.
> >                */
> > -             BUILD_BUG_ON(sizeof(struct tcp_zerocopy_receive) >
> > -                          BPF_SOCKOPT_KERN_BUF_SIZE);
> > -
> > -             ctx->optval = ctx->buf;
> > +             ctx->optval = buf->data;
> >               ctx->optval_end = ctx->optval + max_optlen;
> >               return max_optlen;
> >       }
> > @@ -1336,16 +1329,18 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
> >       return max_optlen;
> >  }
> >
> > -static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
> > +static void sockopt_free_buf(struct bpf_sockopt_kern *ctx,
> > +                          struct bpf_sockopt_buf *buf)
> >  {
> > -     if (ctx->optval == ctx->buf)
> > +     if (ctx->optval == buf->data)
> >               return;
> >       kfree(ctx->optval);
> >  }
> >
> > -static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx)
> > +static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx,
> > +                               struct bpf_sockopt_buf *buf)
> >  {
> > -     return ctx->optval != ctx->buf;
> > +     return ctx->optval != buf->data;
> >  }
> >
> >  int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> > @@ -1353,6 +1348,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >                                      int *optlen, char **kernel_optval)
> >  {
> >       struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > +     struct bpf_sockopt_buf buf = {};
> >       struct bpf_sockopt_kern ctx = {
> >               .sk = sk,
> >               .level = *level,
> > @@ -1373,7 +1369,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >        */
> >       max_optlen = max_t(int, 16, *optlen);
> >
> > -     max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
> > +     max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
> >       if (max_optlen < 0)
> >               return max_optlen;
> >
> > @@ -1419,7 +1415,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >                        * No way to export on-stack buf, have to allocate a
> >                        * new buffer.
> >                        */
> > -                     if (!sockopt_buf_allocated(&ctx)) {
> > +                     if (!sockopt_buf_allocated(&ctx, &buf)) {
> >                               void *p = kzalloc(ctx.optlen, GFP_USER);
> >
> >                               if (!p) {
> > @@ -1436,7 +1432,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >
> >  out:
> >       if (ret)
> > -             sockopt_free_buf(&ctx);
> > +             sockopt_free_buf(&ctx, &buf);
> >       return ret;
> >  }
> >
> > @@ -1445,15 +1441,20 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
> >                                      int __user *optlen, int max_optlen,
> >                                      int retval)
> >  {
> > -     struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > -     struct bpf_sockopt_kern ctx = {
> > -             .sk = sk,
> > -             .level = level,
> > -             .optname = optname,
> > -             .retval = retval,
> > -     };
> This change looks unnecessary?
>
> > +     struct bpf_sockopt_kern ctx;
> > +     struct bpf_sockopt_buf buf;
> > +     struct cgroup *cgrp;
> >       int ret;
> >
> > +     memset(&buf, 0, sizeof(buf));
> > +     memset(&ctx, 0, sizeof(ctx));
> > +
> > +     cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > +     ctx.sk = sk;
> > +     ctx.level = level;
> > +     ctx.optname = optname;
> > +     ctx.retval = retval;
> > +
