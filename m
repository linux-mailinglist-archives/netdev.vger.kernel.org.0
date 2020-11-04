Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE552A5F98
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 09:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgKDI1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 03:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgKDI1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 03:27:08 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5073DC0613D3;
        Wed,  4 Nov 2020 00:27:08 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id k7so653022plk.3;
        Wed, 04 Nov 2020 00:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sm0bYnR9BabPCwhpSs3V4HEq+Bn8rcs4J3qjEZM1/nU=;
        b=mbV61XkSv6ars9sJJbl+wxJUM0tgJEVQdh71oivOZZCqLclLXonUMPiUaai/IbL6/W
         hTYV69qUrD4eRaAOxwMmyV9tKh+dHlWhdLolvWawU6s32Dh7PldQRCn0lcu7mn060ftH
         0K8DmB6Mg3HW7bqMAp7Ytc8579vCP4MfMoWyzHhAV7z9mPzo08tamAjbsYOSSdPYt+HY
         5gzsxWwHwmKWlEbaUt8DtobSUxdEJUx8AJ3l8y0b3bNgKEH/u13JqqoaleA/v3I0fnfp
         fWn4Qfm1I8aMu+r7eJAFDTdW6JC9LwoHi9ajIvrsFCAsh9UVNhG9M1/E6NzDicdhKDOi
         rR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sm0bYnR9BabPCwhpSs3V4HEq+Bn8rcs4J3qjEZM1/nU=;
        b=m75nqK0XLgTFtoKk1ZBT4vmMpE/GoUvZCk//n8wMUuN38V26BMFHRM1SivZ3OVEqKB
         BYc3hD+U9lmdDjC66mA3luaWt72Y6lWaL7v1pMTWMaZLXZiwL5FwRt9fLCo/DgjccOzA
         u5MreIU2QNisGL23uc8YYHnVPQ/YatBRGdtFTVsAHkuMcsdtdCUNLv+KN9yTrEGkRA4A
         l4RYT5tpGFTKLep9on19qLSNg6zZ7I6fypEx++gw6/CD0r/3jNQ2rS+WnJktjcobuyhZ
         gB5/3qvdqs4/KaOoObcIJiJvMq0LuWkpTHTm02NLI2wmLCcB0irQg8XiiF28yFMKXnpN
         rE1Q==
X-Gm-Message-State: AOAM533ZnzQskI9LkDKvUAuFQyQY5alaTQDG77a+VZRQ7+5ocBQ6DjYd
        0Gj72xAwHrPtbEn0YG3sYqrr74Rac11XcrRAb8E=
X-Google-Smtp-Source: ABdhPJx0aqe8L0eL27Yjanj6wzkunGyBSo/i9COLkOpK0ZyILJnYC70B+DTOd82wSyYxK2YyjFL4b27P99J2SegzpRQ=
X-Received: by 2002:a17:902:c1d2:b029:d3:e6e9:c391 with SMTP id
 c18-20020a170902c1d2b02900d3e6e9c391mr28692499plc.49.1604478427884; Wed, 04
 Nov 2020 00:27:07 -0800 (PST)
MIME-Version: 1.0
References: <1604396490-12129-1-git-send-email-magnus.karlsson@gmail.com>
 <1604396490-12129-3-git-send-email-magnus.karlsson@gmail.com> <CAEf4Bzah-7akFkjUAJR=ovXLAnLd6EvLMMOy+GBbc4R28TY-eg@mail.gmail.com>
In-Reply-To: <CAEf4Bzah-7akFkjUAJR=ovXLAnLd6EvLMMOy+GBbc4R28TY-eg@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 4 Nov 2020 09:26:57 +0100
Message-ID: <CAJ8uoz2Cqtw0gPpuyk79z4Rt8dYLmxd9DsSeAB4fQFJWMHLHVw@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] libbpf: fix possible use after free in xsk_socket__delete
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Tue, Nov 3, 2020 at 8:05 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Nov 3, 2020 at 1:42 AM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> >
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Fix a possible use after free in xsk_socket__delete that will happen
> > if xsk_put_ctx() frees the ctx. To fix, save the umem reference taken
> > from the context and just use that instead.
> >
> > Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/lib/bpf/xsk.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index 504b7a8..9bc537d 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -892,6 +892,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> >  {
> >         size_t desc_sz = sizeof(struct xdp_desc);
> >         struct xdp_mmap_offsets off;
> > +       struct xsk_umem *umem;
> >         struct xsk_ctx *ctx;
> >         int err;
> >
> > @@ -899,6 +900,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> >                 return;
> >
> >         ctx = xsk->ctx;
> > +       umem = ctx->umem;
> >         if (ctx->prog_fd != -1) {
> >                 xsk_delete_bpf_maps(xsk);
> >                 close(ctx->prog_fd);
> > @@ -918,11 +920,11 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> >
> >         xsk_put_ctx(ctx);
> >
> > -       ctx->umem->refcount--;
> > +       umem->refcount--;
>
> if you moved ctx->umem->refcount--; to before xdk_put_ctx(ctx), would
> that also work?

Yes, it would for that statement, but I still need the umem pointer
for the statement below. And this statement of potentially closing the
fd needs to be after xsk_put_ctx(). So we might as well keep
ujmem->refcount-- where it is, if that is ok with you?

> >         /* Do not close an fd that also has an associated umem connected
> >          * to it.
> >          */
> > -       if (xsk->fd != ctx->umem->fd)
> > +       if (xsk->fd != umem->fd)
> >                 close(xsk->fd);
> >         free(xsk);
> >  }
> > --
> > 2.7.4
> >
