Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B5D34BB26
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 06:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhC1Evs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 00:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhC1Ev1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 00:51:27 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9446FC061762;
        Sat, 27 Mar 2021 21:51:27 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id m132so10232915ybf.2;
        Sat, 27 Mar 2021 21:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DpNxPFWlZLM43/rGxfO+V0PSyXovwKrLCXv2hgUFmEE=;
        b=V+wIp+K/bJhJBFpNirFbONNKxxYlmlEuw+1obbNPdeYD3y+iqupZOkgXpV9QwIO3PR
         C+wEsI3h8gqwDN8jULYnpU7sLb21gSCzoYAaYZE+RqeADqAEPY0PDMxekZpol+N1vL31
         2MRpMhURalXdzAmG4F/YVpzAcZjx4C+fFasdsSiAgjwKau37YTohtNPdqzV7Bzv8GRv2
         eBpmsjVWIqkm5tEMCHbQKEK9JoE4CdIR2UzVdoX5jpTHtQ/donibNrQjT8D5Dg5iE6pM
         KsYbZSoPdTAqTRcunvVdTHfcLAhJOOK73Kw78BFXsKdQ0h7CVE3ktTh8+8Lm2Hg+eGpC
         9leQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DpNxPFWlZLM43/rGxfO+V0PSyXovwKrLCXv2hgUFmEE=;
        b=FbYmm/LpB60V1YQ1y6VumBOuriseXpyg7i9B6ghZ+vJWkZuODQZxTcZIL4LAuGdujW
         UnmUIQPrw9Llc1o4wh0xbm+1QRQ5OSaQJNZFPYCpAnIBk7H2GLgltVqaYA/ukf1M2qjP
         ylQQf7+ran8ehc86tQVJIYn2CsnuQgPDleasXp314jukZjBMKufstJe9rjzmujYDR4gf
         BtzFheo5QQTO7YxZY0TYfW0GF9ojvXNcVvMtqcqMjjsB1/tWRMl1AkOmCGFF1sb95xMh
         xO8YURShjeTtLkOtIxBWLBQjaIchDwBPwm7BYNMdizfxpXniAoPVRRbK41RX9i20J0Gp
         +L+A==
X-Gm-Message-State: AOAM530Wn7qPFjC8kMwxJ+CsqDOWQXktQtGTtX151NcaACN73XHtmcyl
        +cmowcPa//o24EwVDS5Vnin9BzH3fMezrikUODMf8H6aD1HGHw==
X-Google-Smtp-Source: ABdhPJwEIYKrgpNgGacH3dMrAli/w8vYfdPIavqWB3X7En+TCqal6HWdCWD7W9SQQy4cBnggzlXwLVzjRMh1jJb25fA=
X-Received: by 2002:a25:becd:: with SMTP id k13mr29337733ybm.459.1616907086456;
 Sat, 27 Mar 2021 21:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210326160501.46234-1-lmb@cloudflare.com> <20210326160501.46234-2-lmb@cloudflare.com>
 <CAPhsuW7E4bhEGcboKQ5O=1o0iVNPLpJB1nrAgxweiZqGhZm-JQ@mail.gmail.com>
In-Reply-To: <CAPhsuW7E4bhEGcboKQ5O=1o0iVNPLpJB1nrAgxweiZqGhZm-JQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Mar 2021 21:51:15 -0700
Message-ID: <CAEf4BzbT93nToU=zRFjbgtKcOStoS4KDELZpdfT7dsN44a7fCA@mail.gmail.com>
Subject: Re: [PATCH bpf v2 2/2] bpf: program: refuse non-O_RDWR flags in BPF_OBJ_GET
To:     Song Liu <song@kernel.org>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 1:14 PM Song Liu <song@kernel.org> wrote:
>
> On Fri, Mar 26, 2021 at 9:07 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > As for bpf_link, refuse creating a non-O_RDWR fd. Since program fds
> > currently don't allow modifications this is a precaution, not a
> > straight up bug fix.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  kernel/bpf/inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> > index dc56237d6960..d2de2abec35b 100644
> > --- a/kernel/bpf/inode.c
> > +++ b/kernel/bpf/inode.c
> > @@ -543,7 +543,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
> >                 return PTR_ERR(raw);
>
> For both patches, shall we do the check before bpf_obj_do_get(), which is a few
> lines above?

Map does use f_flags, so we need to let them through. Or did you mean
to do a (type != BPF_TYPE_MAP && f_flags != O_RDWR) check?

Either way is fine with me, so:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>
> Thanks,
> Song
>
> >
> >         if (type == BPF_TYPE_PROG)
> > -               ret = bpf_prog_new_fd(raw);
> > +               ret = (f_flags != O_RDWR) ? -EINVAL : bpf_prog_new_fd(raw);
> >         else if (type == BPF_TYPE_MAP)
> >                 ret = bpf_map_new_fd(raw, f_flags);
> >         else if (type == BPF_TYPE_LINK)
> > --
> > 2.27.0
> >
