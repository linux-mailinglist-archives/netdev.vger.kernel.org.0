Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6685B348BD9
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhCYIqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhCYIqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 04:46:46 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878B1C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 01:46:45 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id z1so1474425ybf.6
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 01:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CMOh6CKHoE8wEnJ297RcB818JvAx3+jqS3T9TGFSU7I=;
        b=I3wXOxah3lKZ58tMNKleHDdBs11K3lacX78B0jYEHyEtTgDW8a+yM04oJuXAyvvcVg
         92piIEvEHKPQSPf857NAkYgw7n6sdbUWjrVuFNnW4Ytj8WcBv+viuZjFCw8Jrv7h7srM
         WuKDSWcy4linmzz0di+4iKtLJf4LCdC5A8+JXkFbGrHjpcAt3VRDf7oSYZTb8veSpZHK
         BxGvG/0Ut3PGB1KlJyl5bu8v1GWJFsZy77iwUrgj9M67TwcpHOIUMoC2PoBZ8zBDWPpH
         5mNrm7GH4xfCeXlMh5QcLnhCnIogA8kL8t2ZNW7ILDlhBhu37f/j/COKQR9kChXY9OHf
         g6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CMOh6CKHoE8wEnJ297RcB818JvAx3+jqS3T9TGFSU7I=;
        b=kl2L2i+vdiYD7s2/+UwZe102CeV6z+s4elVR14Gblb0ErDHJC2GtXhHtMntFCi8W7f
         8yL+ZnO1BqTs5ufJ7xcFshy56h+qhHtHOKMHw40OFuMd84VUJ0SdknpvXg5mAwexLMKk
         easHjZRAnyoW3PNn6B2bnIj7DfC86dpu4sew0KikEoT5LKysANN9lrSZ+zwXbQ0jWhEz
         dDzH9VQJmxyGjpNzS6ipJ3CnQcMT8R7rWIUGP5UziZYKGS2/2V3OadXJ6IB7C03S2dkr
         6H6JlRdEj0Ofz7n7CCtotFf/lL0wSm3g7TCCkn/691WmNCihnjste4T078zB9zlNAjcK
         BUbA==
X-Gm-Message-State: AOAM532cgNJQMxw9I10FQ1bMFa5gmfX3snJMVAY/A7q3MPaWRApKSlsj
        wpUXY1Hj+KJc7nVX9RXdeF6nVlKrdaQnbAfP9xeeeoPfXxo=
X-Google-Smtp-Source: ABdhPJxG6ULHALZ+HY+gpF1iomtyE+f+DWpvdkmtTrXZ4T1bh+aWSyhv9EWry78dRCresMAFkoEMFDBRSH5sxnpVSR8=
X-Received: by 2002:a25:1f83:: with SMTP id f125mr11005435ybf.132.1616662004225;
 Thu, 25 Mar 2021 01:46:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210323064923.2098711-1-dvyukov@google.com> <CANn89iJOignHVg-QOtEB_RVqca=pMczJv-k=CEtPRH0d4fSdgA@mail.gmail.com>
 <CACT4Y+YjJBkbi-u6VTikhHO4OjXhdKnQTqDiHxB5BEZG2Qn7qg@mail.gmail.com>
In-Reply-To: <CACT4Y+YjJBkbi-u6VTikhHO4OjXhdKnQTqDiHxB5BEZG2Qn7qg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 25 Mar 2021 09:46:32 +0100
Message-ID: <CANn89iJBz4NjRzaAyP8gFGzu1y=3YeLOEZ8CLMqv5aUkP7wRvw@mail.gmail.com>
Subject: Re: [PATCH v2] net: make unregister netdev warning timeout configurable
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 8:39 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Wed, Mar 24, 2021 at 10:40 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Mar 23, 2021 at 7:49 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > netdev_wait_allrefs() issues a warning if refcount does not drop to 0
> > > after 10 seconds. While 10 second wait generally should not happen
> > > under normal workload in normal environment, it seems to fire falsely
> > > very often during fuzzing and/or in qemu emulation (~10x slower).
> > > At least it's not possible to understand if it's really a false
> > > positive or not. Automated testing generally bumps all timeouts
> > > to very high values to avoid flake failures.
> > > Add net.core.netdev_unregister_timeout_secs sysctl to make
> > > the timeout configurable for automated testing systems.
> > > Lowering the timeout may also be useful for e.g. manual bisection.
> > > The default value matches the current behavior.
> > >
> > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=211877
> > > Cc: netdev@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > >
> > > ---
> > > Changes since v1:
> > >  - use sysctl instead of a config
> > > ---
> >
> > >         },
> > > +       {
> > > +               .procname       = "netdev_unregister_timeout_secs",
> > > +               .data           = &netdev_unregister_timeout_secs,
> > > +               .maxlen         = sizeof(unsigned int),
> > > +               .mode           = 0644,
> > > +               .proc_handler   = proc_dointvec_minmax,
> > > +               .extra1         = SYSCTL_ZERO,
> > > +               .extra2         = &int_3600,
> > > +       },
> > >         { }
> > >  };
> > >
> >
> > If we allow the sysctl to be 0, then we risk a flood of pr_emerg()
> > (one per jiffy ?)
>
> My reasoning was that it's up to the user. Some spammy output on the
> console for rare events is probably not the worst way how root can
> misconfigure the kernel :)
> It allows one to check (more or less) if we are reaching
> unregister_netdevice with non-zero refcount, which may be useful for
> some debugging maybe.
> But I don't mind changing it to 1 (or 5) if you prefer. On syzbot we
> only want to increase it.
>

Yes, please use a lower limit of one to avoid spurious reports.
