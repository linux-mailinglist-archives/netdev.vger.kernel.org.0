Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E85B2F5317
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbhAMTJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728164AbhAMTJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 14:09:23 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8CDC061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 11:08:42 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id 19so3410149qkm.8
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 11:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s6uN9HnmWi+fbfCHH8WL9JZMreHouOy6KnP5V+1JvEI=;
        b=vUIh4fDRsQ3oNYQEf0NCUNNFllmPh8mtOkb8jFQvr4r9iCUMKaDXBGGyFT0Xf0KMdB
         yPkHTBY8hLQND7ynIIfeP9BGfGRpsoszE10zOwZSV8+A5NH8KNB98ZFBH12ltJcDM6cu
         ae+BguPMBL4PxWzagC+uSUPtBK0QU+GkC2RQ/a22Lre5Ggs2w+dJ9b1mB5RvXOVSX1Fb
         1ukxYEtcaIEJuHNyYq9jClKpW85VSB1WG3DrXPfuiBU9jmTyXvdfpynSdu42UkluQfaO
         nyX0cFY+1bG2aphXsndSG/NZQbwXrfYs9zL5qnqFRIF/y3oS6EKUsmZNMUSlej2kpbcj
         BfdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s6uN9HnmWi+fbfCHH8WL9JZMreHouOy6KnP5V+1JvEI=;
        b=j09uj6BD4Zdh4zwTPnv5g3ED+0vutCAN8dqduCVn98poqSG3TvSBXPQ2KoqKCOwzvB
         g+AdpKjOhClqdIIc2taaayXrr1nW6KFJnkrRbWTi51TAVtJqFYO0ndIDMJfOye4NOMRd
         CWYUOKPfBszHqLxkOfJjU4KWv7Y+chB3b2AR/0omd5+yt4A3siZomjp4y2P15WV+S3B1
         auUbVAF5ZOAr4N9VA8VWmTB0EjhddxR6AHmCzINNwaKqal9krWdZ/WR2cPYrUpHGDzDA
         AF/BTm7nYF1QzTt747wdHiX3RDzKK3u4spAVpQuUV1VD4bT2FxkJ2Uc5P4t3Q/FrRoh5
         uZng==
X-Gm-Message-State: AOAM53250pTt5z3CkPmyrsTRi1sJxttrRTajM79LmcMqdagrCxf8SiQe
        9V3M3R6F1/1mBovohh8Q0HfXmRioj2O0hvZuTdftyg==
X-Google-Smtp-Source: ABdhPJwhdhHqtS9gArUHcQslJwirDXgJAlgJ6vkWNk5rmlJ2lQih1qbc29VFc0tB1INgyREtRasnWcGHLwqsuWaVkMA=
X-Received: by 2002:a37:a80a:: with SMTP id r10mr3643083qke.448.1610564921398;
 Wed, 13 Jan 2021 11:08:41 -0800 (PST)
MIME-Version: 1.0
References: <20210112223847.1915615-1-sdf@google.com> <20210112223847.1915615-4-sdf@google.com>
 <20210113190342.dzqylb6oqrkfhccv@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210113190342.dzqylb6oqrkfhccv@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 13 Jan 2021 11:08:30 -0800
Message-ID: <CAKH8qBu3EVP7EBCO56SemGM-jR6ZMnggidEO16teLqFDDqTStg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 3/4] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 11:03 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Jan 12, 2021 at 02:38:46PM -0800, Stanislav Fomichev wrote:
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
> > index 416e7738981b..dbeef7afbbf9 100644
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
> > @@ -1390,14 +1410,31 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >                */
> >               if (ctx.optlen != 0) {
> >                       *optlen = ctx.optlen;
> > -                     *kernel_optval = ctx.optval;
> > +                     /* We've used bpf_sockopt_kern->buf as an intermediary
> > +                      * storage, but the BPF program indicates that we need
> > +                      * to pass this data to the kernel setsockopt handler.
> > +                      * No way to export on-stack buf, have to allocate a
> > +                      * new buffer.
> > +                      */
> > +                     if (!sockopt_buf_allocated(&ctx, &buf)) {
> > +                             void *p = kzalloc(ctx.optlen, GFP_USER);
> nit. zero-ing is unnecessary when memcpy() will be done later.
SG, will switch to kmalloc, thanks!

> Acked-by: Martin KaFai Lau <kafai@fb.com>
