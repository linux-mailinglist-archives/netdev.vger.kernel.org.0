Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FD7326B0F
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 02:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhB0BgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 20:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhB0BgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 20:36:13 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47C2C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 17:35:32 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id m188so10746203yba.13
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 17:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tIb2bezq4uxAlB7U85abFzWb/GbUKFa/8Z4wNx3No3c=;
        b=tylUwbY1Aa410eecNEIsK5SONSQePpUbD6alxzfrnPSmEnyDPGuksB20nFwsxiwyNt
         wbDCY7kl7o9avEHKD40kWSXzpbPmaDaH+VHVMVCY5zfsN+I4gaRihyym3ou4mechcyvF
         PAyj9Ig28NtVdmZaS0ry21p6cILDqw8BZB6z+1u1B36FbNDUE8ajxevWurLg/VHTV94S
         658HVr22MBqzzV+XNk9tqV25HLIUdjj1lLsBAhQgZKcFIyjEd+10NoI9MBbpTPV7n1x8
         fnYgMvJM7VUyY58ogfO/af6ysCkh2FDqTDo4p0GUBxgI/bJ0DZ8aXR8HTTEtw9wgG24E
         2AuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tIb2bezq4uxAlB7U85abFzWb/GbUKFa/8Z4wNx3No3c=;
        b=Ob+JhCiN83gfx6kCMkAodrEpkAlHnz4jCi2HMUQGrqa9e4+ydU95cjL5QCYemq0I7H
         vD2nIalyibwA6vEewvgwUPkUMCCnFrTNjW8XvFZsVkxl4BYEX5T9pxGDT9YqfcMRfMrv
         EbA44gGtb3l1xss0kRdrHHejj03APKZr0FgZTOZK1R1olyJROBHqXM3/VJ6up6Xie+Zn
         YLMz2I8XDP2/WDNAJ1o4C02Q6rtXDd5TpUwssm++Z0ZlYn3aobs1KRHyj22yQ3gn+FQI
         Ju7uUhQbEw4j/+HXkogkTe2hGJU+iLY1JZap3jIuZLU/GmkgHLLK94yEAtDmWWAk/2xc
         mmQw==
X-Gm-Message-State: AOAM532LYBxFQ6qTBJIAvtBqgy/BW0Ww+tLwE7vj0CCJ0D6+yIyOI3me
        13RaN7IMGo2Z36jtEJt57b4v8N2Kz3aWSluwawQqpA==
X-Google-Smtp-Source: ABdhPJxlg7pl95Je+6z2EZ8KZOJVCNlgsPLTrXu9N8GvRKKDJoZvOFEtDpoiNi9HrlMjFQEWtRtGd/7bSvTWPu0+QPM=
X-Received: by 2002:a25:d016:: with SMTP id h22mr8495764ybg.278.1614389731793;
 Fri, 26 Feb 2021 17:35:31 -0800 (PST)
MIME-Version: 1.0
References: <20210227003047.1051347-1-weiwan@google.com> <20210226164803.4413571f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_CJx7K1Fab1C0Qkw=1VNnDaV9qwB_UUtikPMoqNUUWJuA@mail.gmail.com> <20210226172240.24d626e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210226172240.24d626e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 26 Feb 2021 17:35:21 -0800
Message-ID: <CAEA6p_B6baYFZnEOMS=Nmvg0kA_qB=7ip4S96ys9ZoJWfOiOCA@mail.gmail.com>
Subject: Re: [PATCH net v2] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 5:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 26 Feb 2021 17:02:17 -0800 Wei Wang wrote:
> >  static int napi_thread_wait(struct napi_struct *napi)
> >  {
> > +       bool woken = false;
> > +
> >         set_current_state(TASK_INTERRUPTIBLE);
> >
> >         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> > -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> > +               unsigned long state = READ_ONCE(napi->state);
> > +
> > +               if ((state & NAPIF_STATE_SCHED) &&
> > +                   ((state & NAPIF_STATE_SCHED_THREAD) || woken)) {
> >                         WARN_ON(!list_empty(&napi->poll_list));
> >                         __set_current_state(TASK_RUNNING);
> >                         return 0;
> > +               } else {
> > +                       WARN_ON(woken);
> >                 }
> >
> >                 schedule();
> > +               woken = true;
> >                 set_current_state(TASK_INTERRUPTIBLE);
> >         }
> >         __set_current_state(TASK_RUNNING);
> >
> > I don't think it is sufficient to only set SCHED_THREADED bit when the
> > thread is in RUNNING state.
> > In fact, the thread is most likely NOT in RUNNING mode before we call
> > wake_up_process() in ____napi_schedule(), because it has finished the
> > previous round of napi->poll() and SCHED bit was cleared, so
> > napi_thread_wait() sets the state to INTERRUPTIBLE and schedule() call
> > should already put it in sleep.
>
> That's why the check says "|| woken":
>
>         ((state & NAPIF_STATE_SCHED_THREAD) ||  woken))
>
> thread knows it owns the NAPI if:
>
>   (a) the NAPI has the explicit flag set
> or
>   (b) it was just worken up and !kthread_should_stop(), since only
>       someone who just claimed the normal SCHED on thread's behalf
>       will wake it up

The 'woken' is set after schedule(). If it is the first time
napi_threaded_wait() is called, and SCHED_THREADED is not set, and
woken is not set either, this thread will be put to sleep when it
reaches schedule(), even though there is work waiting to be done on
that napi. And I think this kthread will not be woken up again
afterwards, since the SCHED bit is already grabbed.
