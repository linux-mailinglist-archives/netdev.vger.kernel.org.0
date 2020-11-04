Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B96F2A6E49
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 20:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgKDTnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 14:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgKDTnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 14:43:07 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227E4C0613D3;
        Wed,  4 Nov 2020 11:43:06 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id h196so19061169ybg.4;
        Wed, 04 Nov 2020 11:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WjTjCXElFnEr9OHvxQOceWPjvEGPkIs3Wf6wPRplaK4=;
        b=CkXUlDj3sVxfOcF/pOyG6S2l94WPUs96xGVUjxYyTkWRBRBcxmO4yaW+84og6KTtH1
         WKIqO5D7NUjxCst8+trH4KIfDo7M7A9wRRIv3otadX9QUx38ygygJ/ADULYLbdnayuq8
         FzqgWI/FKdEECL26wZwJBUSSXWhxdNN5hw52UCIuhG5x9j/GSIf3Lj7HjwjQ3oN63Hnr
         dw/fAfuLYFAEs66kCQvrfx0e9UTue0UnFTugXIYPg2WerD9jHWnsiIsz5WLhcVF2e3jh
         b/ulaI/klEzFspog+qVAORRXxgv5eN4+0EFA1zHcItaMqGoNxbRGA/I9OUmLpOICRZe7
         uv5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WjTjCXElFnEr9OHvxQOceWPjvEGPkIs3Wf6wPRplaK4=;
        b=XW4GJDZ/PKgXejRIUcnd3ZlJKfn4NNw1lsvnuWEdpotut86MOrDeuSXNat/Uz0TIZ7
         wPyF/6qtjweSnTZkjAR4sqc94KXM8runKGQbrfN3kGzbbppbP7ZZOMGy7NI9V1ImjOV3
         RtWYKJp8Rko9TdzjLEPC/lsK5ceyMaOL3WQV2GuNVrP8V+HbxHy+keQqqHeQ4AWGyI45
         5KFsMnhlPsyrha4+ksis8Bf9U+2wbX9LxvjNAfKaPP6Z1C2N7N1tPmJfm2JL+Rt2OSTJ
         iiabOOashnkx21yVZW+JVu+885AOHZqOAulpWJjrti9HxuPIhhYIHDyA6jB6mYKEK4dm
         s9Rg==
X-Gm-Message-State: AOAM533vUqxAi2kOUZE6NPH2eDArnZk0IAG7UID6J1GnOheuiZBHY+tJ
        WJGbwB91mgIFkXg7+Zbvp0w2RdhnQIkJrdUuSGo=
X-Google-Smtp-Source: ABdhPJyvgNOUYUHJcGD+hE68gDiC+YC83DKko1JXPNrvhK4YisSgKwgJ6TiPnqu9e4xTBBSetlFtcRuULhemCfaTfQM=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr39195887ybl.347.1604518984966;
 Wed, 04 Nov 2020 11:43:04 -0800 (PST)
MIME-Version: 1.0
References: <1604396490-12129-1-git-send-email-magnus.karlsson@gmail.com>
 <1604396490-12129-3-git-send-email-magnus.karlsson@gmail.com>
 <CAEf4Bzah-7akFkjUAJR=ovXLAnLd6EvLMMOy+GBbc4R28TY-eg@mail.gmail.com> <CAJ8uoz2Cqtw0gPpuyk79z4Rt8dYLmxd9DsSeAB4fQFJWMHLHVw@mail.gmail.com>
In-Reply-To: <CAJ8uoz2Cqtw0gPpuyk79z4Rt8dYLmxd9DsSeAB4fQFJWMHLHVw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Nov 2020 11:42:54 -0800
Message-ID: <CAEf4Bzazw67MNAE9gkFLKLdQnDSvvnmuNrPb7gMf51LkK3pYpg@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] libbpf: fix possible use after free in xsk_socket__delete
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 12:27 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Tue, Nov 3, 2020 at 8:05 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Nov 3, 2020 at 1:42 AM Magnus Karlsson
> > <magnus.karlsson@gmail.com> wrote:
> > >
> > > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > >
> > > Fix a possible use after free in xsk_socket__delete that will happen
> > > if xsk_put_ctx() frees the ctx. To fix, save the umem reference taken
> > > from the context and just use that instead.
> > >
> > > Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > ---
> > >  tools/lib/bpf/xsk.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > index 504b7a8..9bc537d 100644
> > > --- a/tools/lib/bpf/xsk.c
> > > +++ b/tools/lib/bpf/xsk.c
> > > @@ -892,6 +892,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> > >  {
> > >         size_t desc_sz = sizeof(struct xdp_desc);
> > >         struct xdp_mmap_offsets off;
> > > +       struct xsk_umem *umem;
> > >         struct xsk_ctx *ctx;
> > >         int err;
> > >
> > > @@ -899,6 +900,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> > >                 return;
> > >
> > >         ctx = xsk->ctx;
> > > +       umem = ctx->umem;
> > >         if (ctx->prog_fd != -1) {
> > >                 xsk_delete_bpf_maps(xsk);
> > >                 close(ctx->prog_fd);
> > > @@ -918,11 +920,11 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> > >
> > >         xsk_put_ctx(ctx);
> > >
> > > -       ctx->umem->refcount--;
> > > +       umem->refcount--;
> >
> > if you moved ctx->umem->refcount--; to before xdk_put_ctx(ctx), would
> > that also work?
>
> Yes, it would for that statement, but I still need the umem pointer
> for the statement below. And this statement of potentially closing the
> fd needs to be after xsk_put_ctx(). So we might as well keep
> ujmem->refcount-- where it is, if that is ok with you?

Ah, missed the umem->fd below. Then it makes sense, thanks.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>
> > >         /* Do not close an fd that also has an associated umem connected
> > >          * to it.
> > >          */
> > > -       if (xsk->fd != ctx->umem->fd)
> > > +       if (xsk->fd != umem->fd)
> > >                 close(xsk->fd);
> > >         free(xsk);
> > >  }
> > > --
> > > 2.7.4
> > >
