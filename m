Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B344043D804
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 02:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhJ1AWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 20:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhJ1AWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 20:22:42 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828C5C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 17:20:16 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y12so18203129eda.4
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 17:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T8ZZ3tmv2TMLqiT5S3nbq5MlweX+KPvE3IP7/h/cxwk=;
        b=bl6HKBisMNja9Jt9+gxRawjFPeBttx0yBVhztedSnHE3veIbZm6xjoN++iOMHpyNaC
         IU4oqs4HbGEYWUutO9zEeNRgQcLpVA4MMygi3/gvO0+fa2xmvNCvPJU+qeznswrtAm7a
         z3/Si7i+vOOEdqHCO/ZnDMbSdKki0d7qRMFos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T8ZZ3tmv2TMLqiT5S3nbq5MlweX+KPvE3IP7/h/cxwk=;
        b=PIS6j+BZ+roTaBdytpTeCGjTt6tUGIIXoeJm+j99ivbDh1bcQ0NGfcI+cvAC7ExhwR
         MZMizZxip8liCPZapBz4T7mSl/U9u2qZVrfB5ShnD1NNvS2rIrw5r3/Mx+aP5N2Y/+Ey
         xmaw6KjSE4+jf8ntaTeEMxVxBJzwD57n7MJRqxVoIgF5a015FCxX8HsI4GCIvY5FNSel
         9aa/ZTmyxr4mdtaxqlUS71Fc1VC7FLIOvXkQswDxEulVWVqOSqyYmIjSl5sllHEvo65X
         UTvxyMgyQme8tFpVXp/TcBAB6aiS7lnlMVZzU/2lwsViuHq+PklPgM3q1gFBF93id8XS
         1RRA==
X-Gm-Message-State: AOAM5313U91pYygJBfRv8O4NV7SlCaJ7zmorp1edbu5quLr37xoHTILD
        vj4kRZjAHtajxLQnrgRU644R0g7Li79krjjkIZc4cg==
X-Google-Smtp-Source: ABdhPJyEbaFYTSWJSKofJ/QwI8c6HvHSJwnMQrHwtk1gYOm26Vrq7Y86Qy+JX/VStRqfNhU/mUnPTWJdLBU+ueZlufw=
X-Received: by 2002:a17:906:1601:: with SMTP id m1mr1025935ejd.117.1635380415087;
 Wed, 27 Oct 2021 17:20:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211027214519.606096-1-csander@purestorage.com> <d9d4b6d1-d64d-4bfb-17d9-b28153e02b9e@gmail.com>
In-Reply-To: <d9d4b6d1-d64d-4bfb-17d9-b28153e02b9e@gmail.com>
From:   Caleb Sander <csander@purestorage.com>
Date:   Wed, 27 Oct 2021 17:20:04 -0700
Message-ID: <CADUfDZqx6EjOY=JcQuC6hfPjGgTZCk6BcV5_D1Dp+WQJiXmEnQ@mail.gmail.com>
Subject: Re: [PATCH] qed: avoid spin loops in _qed_mcp_cmd_and_union()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        Joern Engel <joern@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Here you might sleep/schedule, while CAN_SLEEP was not set ?

I also do not know this driver, just trying to fix an observed latency issue.
As far as I can tell, the CAN_SLEEP flag is set/unset depending on
which function called qed_mcp_cmd_and_union();
it does not indicate whether the function is running in atomic context.
For example, qed_mcp_cmd() calls it without CAN_SLEEP,
yet qed_mcp_drain() calls msleep() immediately after qed_mcp_cmd().

We were concerned that this function might be called in atomic context,
so we added a WARN_ON_ONCE(in_atomic()). We never saw the warning fire
during two weeks of testing, so we believe sleeping is possible here.

> I would suggest using usleep_range() instead, because cond_resched()
> can be a NOP under some circumstances.
> Then perhaps not count against max_retries, but based on total elapsed time ?

I agree these would both be improvements to the current code.
I was trying to provide a minimal change that would allow these loops
to yield the CPU,
but will happily do this refactoring if the driver authors think it
would be beneficial.

On Wed, Oct 27, 2021 at 3:25 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 10/27/21 2:45 PM, Caleb Sander wrote:
> > By default, qed_mcp_cmd_and_union() sets max_retries to 500K and
> > usecs to 10, so these loops can together delay up to 5s.
> > We observed thread scheduling delays of over 700ms in production,
> > with stacktraces pointing to this code as the culprit.
> >
> > Add calls to cond_resched() in both loops to yield the CPU if necessary.
> >
> > Signed-off-by: Caleb Sander <csander@purestorage.com>
> > Reviewed-by: Joern Engel <joern@purestorage.com>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed_mcp.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> > index 24cd41567..d6944f020 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> > @@ -485,10 +485,12 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
> >
> >               spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
> >
> > -             if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP))
> > +             if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP)) {
>
> I do not know this driver, but apparently, there is this CAN_SLEEP test
> hinting about being able to sleep.
>
> >                       msleep(msecs);
> > -             else
> > +             } else {
> > +                     cond_resched();
>
> Here you might sleep/schedule, while CAN_SLEEP was not set ?
>
> >                       udelay(usecs);
>
>
> I would suggest using usleep_range() instead, because cond_resched()
> can be a NOP under some circumstances.
>
> > +             }
> >       } while (++cnt < max_retries);
>
> Then perhaps not count against max_retries, but based on total elapsed time ?
>
> >
> >       if (cnt >= max_retries) {
> > @@ -517,10 +519,12 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
> >                * The spinlock stays locked until the list element is removed.
> >                */
> >
> > -             if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP))
> > +             if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP)) {
> >                       msleep(msecs);
> > -             else
> > +             } else {
> > +                     cond_resched();
> >                       udelay(usecs);
> > +             }
> >
> >               spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
> >
> >
