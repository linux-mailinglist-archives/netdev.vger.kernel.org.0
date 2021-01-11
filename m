Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27232F1E40
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390347AbhAKSvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbhAKSvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:51:11 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D28BC061795
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:50:30 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id j26so12347qtq.8
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zwBrmctowFwiEyjxMQ5en9W3eVqQ+W60jjN6AkIIUmw=;
        b=avPyA/XnotrQETqxaNNB1a0TyaxAxWDBnHlAT3Un+twWQbq5S+BCRENJzBbqTtie4W
         qJxFYNazvvrYmw6P/3XAKbqzKoiBJJS10HARA6K7S5oaY24ZeR6gzA7omqv+lHFm28pZ
         8DPp1yvDpwoXrCbJCXiyfbzOFAQ/T7VgdWoEw1z5WXCc7S8N7h1U/UAfQqO0XbUBRQbN
         SweKX83yOpvUloTT1XFuWZuX6CV8mqD6VVFoQGaNWhpKTnqKObE7iRRZprweqjLVNGx4
         97l0zUqVqIXgGqISs8KlFgtdZPhddiwsiZwYdy4icDF/lce6VEpnPNhvsrQs+HUJICTJ
         LXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zwBrmctowFwiEyjxMQ5en9W3eVqQ+W60jjN6AkIIUmw=;
        b=BIqSNbizP5XhdfknqXNG79QKtpz9P3GDvmEcjFN7zc8eO6oGceMpGjrO0NfOUgVzHs
         idIJBFhbm4xkne/XtvvUnOFtJBqP7D93CqpAPZPpATAqK7UH6BsthGr44UAR1RvsNRi/
         J4fByynp11cXk/7qb+TqLIkD5bckS+Qqf1pBfefupK8fLSsv8Doa/QBDlqEG7YfCVk/C
         r5z0+Myjgy+fkWJT2LQsUEgDJ/ewwpYwAnWW/4KTyb9sta0MAnNFEum0kU7KF8IylhgV
         n/bZRVDRaCQwm8dxpkTM61A2NtwQgrWm9JcELG1Pn9OmBdZNqa0ZpWXaUu4kcbptwUD/
         3UOQ==
X-Gm-Message-State: AOAM531LDoYkamuGGD1lPNV7g80K7f9xjK/2gDtftJI98YY5K/7eSoV+
        vXk0OJ7RSWhxBGZzNueMmIahhnuPtGOdqEZnKD3Sag==
X-Google-Smtp-Source: ABdhPJyPix0wWFob0Ek0sQpOfACl7hyPHSViz+V43+UMZE28k52/SgdyBOesiyWKkCt27lUthOPeSopdzwLs0bM73Uc=
X-Received: by 2002:ac8:7a82:: with SMTP id x2mr1048945qtr.20.1610391029606;
 Mon, 11 Jan 2021 10:50:29 -0800 (PST)
MIME-Version: 1.0
References: <20210108210223.972802-1-sdf@google.com> <20210108210223.972802-3-sdf@google.com>
 <20210109015556.6sajviuria5qknf7@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210109015556.6sajviuria5qknf7@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 11 Jan 2021 10:50:18 -0800
Message-ID: <CAKH8qBuCH_mh=SnhX1NbDsNkGR9w_HCQLFTHnVWi=oKDHQWmZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 2/3] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 5:56 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Jan 08, 2021 at 01:02:22PM -0800, Stanislav Fomichev wrote:
> > When we attach a bpf program to cgroup/getsockopt any other getsockopt()
> > syscall starts incurring kzalloc/kfree cost.
> >
> > Let add a small buffer on the stack and use it for small (majority)
> > {s,g}etsockopt values. The buffer is small enough to fit into
> > the cache line and cover the majority of simple options (most
> > of them are 4 byte ints).
> >
> > It seems natural to do the same for setsockopt, but it's a bit more
> > involved when the BPF program modifies the data (where we have to
> > kmalloc). The assumption is that for the majority of setsockopt
> > calls (which are doing pure BPF options or apply policy) this
> > will bring some benefit as well.
> >
> > Without this patch (we remove about 1% __kmalloc):
> >      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> >             |
> >              --3.30%--__cgroup_bpf_run_filter_getsockopt
> >                        |
> >                         --0.81%--__kmalloc
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Cc: Song Liu <songliubraving@fb.com>
> > ---
> >  include/linux/filter.h |  5 ++++
> >  kernel/bpf/cgroup.c    | 52 ++++++++++++++++++++++++++++++++++++------
> >  2 files changed, 50 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 29c27656165b..8739f1d4cac4 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -1281,6 +1281,11 @@ struct bpf_sysctl_kern {
> >       u64 tmp_reg;
> >  };
> >
> > +#define BPF_SOCKOPT_KERN_BUF_SIZE    32
> > +struct bpf_sockopt_buf {
> > +     u8              data[BPF_SOCKOPT_KERN_BUF_SIZE];
> > +};
> > +
> >  struct bpf_sockopt_kern {
> >       struct sock     *sk;
> >       u8              *optval;
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index c41bb2f34013..a9aad9c419e1 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -1298,7 +1298,8 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
> >       return empty;
> >  }
> >
> > -static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
> > +static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen,
> > +                          struct bpf_sockopt_buf *buf)
> >  {
> >       if (unlikely(max_optlen < 0))
> >               return -EINVAL;
> > @@ -1310,6 +1311,15 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
> >               max_optlen = PAGE_SIZE;
> >       }
> >
> > +     if (max_optlen <= sizeof(buf->data)) {
> > +             /* When the optval fits into BPF_SOCKOPT_KERN_BUF_SIZE
> > +              * bytes avoid the cost of kzalloc.
> > +              */
> > +             ctx->optval = buf->data;
> > +             ctx->optval_end = ctx->optval + max_optlen;
> > +             return max_optlen;
> > +     }
> > +
> >       ctx->optval = kzalloc(max_optlen, GFP_USER);
> >       if (!ctx->optval)
> >               return -ENOMEM;
> > @@ -1319,16 +1329,26 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
> >       return max_optlen;
> >  }
> >
> > -static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
> > +static void sockopt_free_buf(struct bpf_sockopt_kern *ctx,
> > +                          struct bpf_sockopt_buf *buf)
> >  {
> > +     if (ctx->optval == buf->data)
> > +             return;
> >       kfree(ctx->optval);
> >  }
> >
> > +static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx,
> > +                               struct bpf_sockopt_buf *buf)
> > +{
> > +     return ctx->optval != buf->data;
> > +}
> > +
> >  int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >                                      int *optname, char __user *optval,
> >                                      int *optlen, char **kernel_optval)
> >  {
> >       struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > +     struct bpf_sockopt_buf buf = {};
> >       struct bpf_sockopt_kern ctx = {
> >               .sk = sk,
> >               .level = *level,
> > @@ -1350,7 +1370,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >        */
> >       max_optlen = max_t(int, 16, *optlen);
> >
> > -     max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
> > +     max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
> >       if (max_optlen < 0)
> >               return max_optlen;
> >
> > @@ -1390,13 +1410,30 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >                */
> >               if (ctx.optlen != 0) {
> When ctx.optlen == 0, is sockopt_free_buf() called?
> Did I miss something?
Ouch, good catch, it looks like we do leak the buf here with optlen == 0.

We should probably change the following below to:
out:
      if (!*kernel_optval)
           sockopt_free_buf(...);

I'll send a bpf patch with a Fixes tag, thanks!
