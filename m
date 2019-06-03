Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BED33A7B
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfFCV6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:58:50 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37935 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCV6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:58:49 -0400
Received: by mail-lf1-f68.google.com with SMTP id b11so14812606lfa.5
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 14:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=39SsS75pnQ5vHdEqbne0WJ2yXM1xbTpEuZ3/IBKSvQw=;
        b=iHxItZmO7EMI3oQoeYJNo81cTXL+a2p2lGyUDGhwEFPlL7xmIzWMz2BXM9RXXpR8HJ
         bArXNfvV6zQe9IVr2+s/xKS8FaFXc/zYRj4s8VwQUrsFbtonyI6viek4fO8KY8ypzEhP
         8yPBFAHB2MiATF/1ZdJoqWHdv0wyyNK5PXublbT5pKOGjVLjmQp27zoYA6KWmMIBVk4n
         KLoHEK3LWJD5b+6lDu+yQ0byVhXODfaT4qcOgyoqCn1LN2X/NKX81uXtFnrvjiX+XoR4
         7XMccsJarvfaKxnubqoBtMZFM2Wbo6yl1WFEvAqILRdXP5cwozFrPoWhqw6KmJJ8+9ks
         Ph/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=39SsS75pnQ5vHdEqbne0WJ2yXM1xbTpEuZ3/IBKSvQw=;
        b=p1bJT+y6247gDt+2srk83w31VImPAiowgJcW+I0QyXMQPZbqId4bAOaD8w2bg4RTuu
         ktbUnyhCjsnUq/nSonwhTjvJbZ7vejbyTqld07XO9jN61lgQQxP1To7lihEAVeq1F76N
         8ot0FQxMWtLXpldiVIm7z6pQy90fIprP54P791tS61iACOJBXIv3KYpPZGK13kjCfSZ5
         XG3IVydOaVJLNrgEdYSzNG0DymzEn0sutI6D0Cae7eA3C1cPquHalcjwxck4Bdu03ZRj
         ECtle7SxUbX21POoV73E7RzXyoFj90a2q/KsXDEIiaxp4GRwIUaoIXSNa0p4cDf5n6tt
         WfuQ==
X-Gm-Message-State: APjAAAXZf/2MHPLEYO5L+hGGGX/D8IDKm/Lvmigbnjix7qlFCISu9TME
        uD8l71ht6MGckrZtffPGqRtunQhrJMrqTPjd7iWH
X-Google-Smtp-Source: APXvYqxKd5fwr8QHl9rJyGVa9hftw7WKVY4g2KKTll9Io6rs88ViptI9pRCooetIr8mIjw9lSzXtBYo7RsBEknadaiw=
X-Received: by 2002:a19:c301:: with SMTP id t1mr15151815lff.137.1559595462723;
 Mon, 03 Jun 2019 13:57:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190601021526.GA8264@zhanggen-UX430UQ> <CAFqZXNuPMxOQeq-5evh4dSuGC-Q5sQPjbhRgCBh4Q=u6OrEi9Q@mail.gmail.com>
In-Reply-To: <CAFqZXNuPMxOQeq-5evh4dSuGC-Q5sQPjbhRgCBh4Q=u6OrEi9Q@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 3 Jun 2019 16:57:31 -0400
Message-ID: <CAHC9VhSt9Qsj1Lgr+H0unbbxOR18KZqoSbfXPR=XpJ8uD8Q2AQ@mail.gmail.com>
Subject: Re: [PATCH v3] selinux: lsm: fix a missing-check bug in selinux_sb_eat_lsm_opts()
To:     Ondrej Mosnacek <omosnace@redhat.com>,
        Gen Zhang <blackgod016574@gmail.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 3:27 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> On Sat, Jun 1, 2019 at 4:15 AM Gen Zhang <blackgod016574@gmail.com> wrote:
> > In selinux_sb_eat_lsm_opts(), 'arg' is allocated by kmemdup_nul(). It
> > returns NULL when fails. So 'arg' should be checked. And 'mnt_opts'
> > should be freed when error.
> >
> > Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > Fixes: 99dbbb593fe6 ("selinux: rewrite selinux_sb_eat_lsm_opts()")
> > ---
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 3ec702c..f329fc0 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -2616,6 +2616,7 @@ static int selinux_sb_eat_lsm_opts(char *options, void **mnt_opts)
> >         char *from = options;
> >         char *to = options;
> >         bool first = true;
> > +       int ret;
>
> I'd suggest just moving the declaration of 'rc' here and simply reuse
> that variable. Otherwise the patch looks good to me.

Agreed.  Creating "ret" only makes the patch larger and doesn't add any value.

I try to avoid making broad statements, but if you are unsure about
which approach to take when fixing a problem, start with the smallest
patch you can write.  Even if it turns out not to be the "best"
solution upstream, it will be easier to review, discuss, and
potentially port to other/older kernels.

> >
> >         while (1) {
> >                 int len = opt_len(from);
> > @@ -2635,15 +2636,16 @@ static int selinux_sb_eat_lsm_opts(char *options, void **mnt_opts)
> >                                                 *q++ = c;
> >                                 }
> >                                 arg = kmemdup_nul(arg, q - arg, GFP_KERNEL);
> > +                               if (!arg) {
> > +                                       ret = -ENOMEM;
> > +                                       goto free_opt;
> > +                               }
> >                         }
> >                         rc = selinux_add_opt(token, arg, mnt_opts);
> >                         if (unlikely(rc)) {
> > +                               ret = rc;
> >                                 kfree(arg);
> > -                               if (*mnt_opts) {
> > -                                       selinux_free_mnt_opts(*mnt_opts);
> > -                                       *mnt_opts = NULL;
> > -                               }
> > -                               return rc;
> > +                               goto free_opt;
> >                         }
> >                 } else {
> >                         if (!first) {   // copy with preceding comma
> > @@ -2661,6 +2663,12 @@ static int selinux_sb_eat_lsm_opts(char *options, void **mnt_opts)
> >         }
> >         *to = '\0';
> >         return 0;
> > +free_opt:
> > +       if (*mnt_opts) {
> > +               selinux_free_mnt_opts(*mnt_opts);
> > +               *mnt_opts = NULL;
> > +       }
> > +       return ret;
> >  }
> >
> >  static int selinux_sb_remount(struct super_block *sb, void *mnt_opts)
>
> --
> Ondrej Mosnacek <omosnace at redhat dot com>
> Software Engineer, Security Technologies
> Red Hat, Inc.

-- 
paul moore
www.paul-moore.com
