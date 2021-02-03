Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F95530E1E6
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhBCSHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbhBCR6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 12:58:16 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A57C0613ED
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 09:57:36 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id i71so434848ybg.7
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 09:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9gPGw//HEwUf06xw+akJsfPOMbbSW6K36Oo2FUXDYq8=;
        b=VJ22g+LwmALFGXbkb5o+c5TDJ/rpXrTd8eG8aLX4YL99CRfNBmerTOiIrNbMHjd0ef
         Ckb3TXmZqtTEfPwcMCTPaHipTJlXJj604/8LMzjxnXBT+MwxnHovrvCCxyM+KGNZPy61
         M/l7orc3V7e3XopgzGpFk3chTNHICLQxz/Z1RniZFv41dMEXAeLLo3OuUxjupX/EwnJ/
         z7vIbdLYZ3+BA29bG3+MIpm0NaMjP01TW0lco3TqXIWUGlmRo/44Suv2DT7jgKD3wAwq
         LzkwJj4fynpMn/FhBChjKa6Kf5t2oKwP5m819QMM5vRbUzPLR7R6FUl1fCfyw3/BZWMN
         JL7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9gPGw//HEwUf06xw+akJsfPOMbbSW6K36Oo2FUXDYq8=;
        b=X1JVNKWtSS5BuNmDrE0+towM9IWeddlWoI1mbHSEbeJIG2rHCsM7HvuDFSDa3b+Yup
         +m7xzpki2JoQ6uIBs0ZbTnyC6EZFmOP7FMSg3foQerIKysUt47tVfVSiMNPoV6B6CRwd
         nEMbbt724ZJAwCC6A8P4j6l3k0qmAmonl3DfQnytnq4TFRiuRLH7ktbCEVMLfgPdfHEw
         FUe/mrjma2Nb0YPeG9f/aixwaJN2vYzwPOgTNaT6Dn1hPeSzZU0Ps0o4khHsNBgXYj8p
         snOaGMkw3l8F5JHUQfuiEKNzWHXaVHg9WIbRgR4oOxDBgTyMEqfyEiWkdfbJlsLbINCJ
         EDeg==
X-Gm-Message-State: AOAM531i6l6OohzlZpapgVskLiSCvAyx+uIqGf5WdPoLteLI+t+5FACx
        SS9tMtYn7x4xQlGiD3HCp8ITPPRHXqt8iYOHSJHY7Q==
X-Google-Smtp-Source: ABdhPJzUdhMRilKORMCigJO+IE/djZwq9jblue/TLtG/wcVWvmblKfSF8br7N/mPMydNVPc1w+HbCNE3ugAXdO7tP+w=
X-Received: by 2002:a25:1d86:: with SMTP id d128mr6262637ybd.278.1612375055177;
 Wed, 03 Feb 2021 09:57:35 -0800 (PST)
MIME-Version: 1.0
References: <20210129181812.256216-1-weiwan@google.com> <20210129181812.256216-2-weiwan@google.com>
 <CAKgT0UdQCERxqcGmMe+xdF3aHvrRWzbCg+Wd3jGo=LREJayOQw@mail.gmail.com>
In-Reply-To: <CAKgT0UdQCERxqcGmMe+xdF3aHvrRWzbCg+Wd3jGo=LREJayOQw@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 3 Feb 2021 09:57:23 -0800
Message-ID: <CAEA6p_DWqDbK_EFUXp+7XprBc3HegnV69qWhsPR4V_4K9oDGfA@mail.gmail.com>
Subject: Re: [PATCH net-next v9 1/3] net: extract napi poll functionality to __napi_poll()
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 9:00 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Jan 29, 2021 at 10:20 AM Wei Wang <weiwan@google.com> wrote:
> >
> > From: Felix Fietkau <nbd@nbd.name>
> >
> > This commit introduces a new function __napi_poll() which does the main
> > logic of the existing napi_poll() function, and will be called by other
> > functions in later commits.
> > This idea and implementation is done by Felix Fietkau <nbd@nbd.name> and
> > is proposed as part of the patch to move napi work to work_queue
> > context.
> > This commit by itself is a code restructure.
> >
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > ---
> >  net/core/dev.c | 35 +++++++++++++++++++++++++----------
> >  1 file changed, 25 insertions(+), 10 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 0332f2e8f7da..7d23bff03864 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6768,15 +6768,10 @@ void __netif_napi_del(struct napi_struct *napi)
> >  }
> >  EXPORT_SYMBOL(__netif_napi_del);
> >
> > -static int napi_poll(struct napi_struct *n, struct list_head *repoll)
> > +static int __napi_poll(struct napi_struct *n, bool *repoll)
> >  {
> > -       void *have;
> >         int work, weight;
> >
> > -       list_del_init(&n->poll_list);
> > -
> > -       have = netpoll_poll_lock(n);
> > -
> >         weight = n->weight;
> >
> >         /* This NAPI_STATE_SCHED test is for avoiding a race
> > @@ -6796,7 +6791,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
> >                             n->poll, work, weight);
> >
> >         if (likely(work < weight))
> > -               goto out_unlock;
> > +               return work;
> >
> >         /* Drivers must not modify the NAPI state if they
> >          * consume the entire weight.  In such cases this code
> > @@ -6805,7 +6800,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
> >          */
> >         if (unlikely(napi_disable_pending(n))) {
> >                 napi_complete(n);
> > -               goto out_unlock;
> > +               return work;
> >         }
> >
> >         /* The NAPI context has more processing work, but busy-polling
> > @@ -6818,7 +6813,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
> >                          */
> >                         napi_schedule(n);
> >                 }
> > -               goto out_unlock;
> > +               return work;
> >         }
> >
> >         if (n->gro_bitmask) {
> > @@ -6836,9 +6831,29 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
> >         if (unlikely(!list_empty(&n->poll_list))) {
> >                 pr_warn_once("%s: Budget exhausted after napi rescheduled\n",
> >                              n->dev ? n->dev->name : "backlog");
> > -               goto out_unlock;
> > +               return work;
> >         }
> >
> > +       *repoll = true;
> > +
> > +       return work;
> > +}
> > +
> > +static int napi_poll(struct napi_struct *n, struct list_head *repoll)
> > +{
> > +       bool do_repoll = false;
> > +       void *have;
> > +       int work;
> > +
> > +       list_del_init(&n->poll_list);
> > +
> > +       have = netpoll_poll_lock(n);
> > +
> > +       work = __napi_poll(n, &do_repoll);
> > +
> > +       if (!do_repoll)
> > +               goto out_unlock;
> > +
> >         list_add_tail(&n->poll_list, repoll);
> >
> >  out_unlock:
>
> Instead of using the out_unlock label why don't you only do the
> list_add_tail if do_repoll is true? It will allow you to drop a few
> lines of noise. Otherwise this looks good to me.
>
Ack.

> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Thanks for the review.
