Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908B547066B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244224AbhLJQ4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbhLJQ4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:56:43 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A464BC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:53:08 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id x32so22621717ybi.12
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M7Z1Swg4dBcJ7afs97nUcQ7AN1c9RnbQujDfBiwvp8k=;
        b=X9soMWwL2PiYMuHQaAF92xvr8pi9tvjgn27wE4WE9ogDHOjxhrM5xQXeUtELNi11sq
         5iOZc0KK+I0gpjM1Gg7qxCgAQ0hVxnDoHQJ72Wgn/6qwu4o5l2tNp/FIazWMbOFurLK3
         3qg2HCBKDcAsnMlz7n5/8JYIb6IPimE0WL5Zxaou5z+mKk2diuwh8wrLJI+kcAU82cfa
         3/Q1vOUbLHldeAkC4rOFPDvoWrJcBQadUjy8QJZJaOgIL7MaCkr6u353G42PvomJgH+r
         /Ybty5DemAqKZ3SNvN0oO6Bf8kUXRTlWToRmxGZiWu4DpHZmKT7aMRGmaCqHO11R/JFj
         kxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M7Z1Swg4dBcJ7afs97nUcQ7AN1c9RnbQujDfBiwvp8k=;
        b=q3oKzHEYSVQBSQUX0sUsA8TuARa32BQwj5Rl0rBo8iFiHcqqR3Hb1aUURTXau428sn
         tyKkkqNcPuyczveqqjoBMieFk5wLl87AH8nYmQ0WLGM3v1A3aOa1OlcbFI8DZllTVDn3
         koJj70OCwx7bNAfMzaft8x2qzyF94pxtE/FrYj+pKy3u/x0ZCa78iswVu+9qCGyA+D5d
         vQMn5BojVU56hNFhw2O2VBeH/d5UEyFr2mtkQCOQbUrqk3NEWQ//N4hHhVvGvOQ9gQLf
         oR5bXGirZFWngjRFSRkCL4Var9eYgpw04MKQRHkiltufaKtLtJ7ist5Ln/0cI3osUpZ9
         2Meg==
X-Gm-Message-State: AOAM532zVPKjMkoLbUtvRNsSHjwZ1Ocl2chtOqcH3iD+IrmzOxfAlbU1
        4a8JaDYmxqMdXcqvToGeF0HILBopxjU0x2hba4+WXA==
X-Google-Smtp-Source: ABdhPJwSUXQAXhPzwQ3bLUzbNeugnJIiGyZMMPf8lZvmRaQqcqzrOHOmMo4XaivddW429nopJ6kcZSnv+mEoE0H9usM=
X-Received: by 2002:a25:760d:: with SMTP id r13mr16798965ybc.296.1639155187318;
 Fri, 10 Dec 2021 08:53:07 -0800 (PST)
MIME-Version: 1.0
References: <YbN1OL0I1ja4Fwkb@linutronix.de> <99af5c3079470432b97a74ab6aa3a43a1f7b178d.camel@redhat.com>
 <YbOEaSQW+LtWjuzI@linutronix.de>
In-Reply-To: <YbOEaSQW+LtWjuzI@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Dec 2021 08:52:55 -0800
Message-ID: <CANn89i+zyeMJVhNmEEhwE0oaRvD-m0ZR9w1+ScsvpWZEuP9G5Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock in
 __dev_xmit_skb() on PREEMPT_RT.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 8:46 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2021-12-10 17:35:21 [+0100], Paolo Abeni wrote:
> > On Fri, 2021-12-10 at 16:41 +0100, Sebastian Andrzej Siewior wrote:
> > > The root-lock is dropped before dev_hard_start_xmit() is invoked and after
> > > setting the __QDISC___STATE_RUNNING bit. If the Qdisc owner is preempted
> > > by another sender/task with a higher priority then this new sender won't
> > > be able to submit packets to the NIC directly instead they will be
> > > enqueued into the Qdisc. The NIC will remain idle until the Qdisc owner
> > > is scheduled again and finishes the job.
> > >
> > > By serializing every task on the ->busylock then the task will be
> > > preempted by a sender only after the Qdisc has no owner.
> > >
> > > Always serialize on the busylock on PREEMPT_RT.
> >
> > Not sure how much is relevant in the RT context, but this should impact
> > the xmit tput in a relevant, negative way.
>
> Negative because everyone blocks on lock and transmits packets directly
> instead of adding it to the queue and leaving for more?
>
> > If I read correctly, you use the busylock to trigger priority ceiling
> > on each sender. I'm wondering if there are other alternative ways (no
> > contended lock, just some RT specific annotation) to mark a whole
> > section of code for priority ceiling ?!?
>
> priority ceiling as you call it, happens always with the help of a lock.
> The root_lock is dropped in sch_direct_xmit().
> qdisc_run_begin() sets only a bit with no owner association.
> If I know why the busy-lock bad than I could add another one. The
> important part is force the sende out of the section so the task with
> the higher priority can send packets instead of queueing them only.

Problem is that if you have a qdisc, qdisc_dequeue() will not know that the
packet queued by high prio thread needs to shortcut all prior packets and
be sent right away.

Because of that, it seems just better that a high prio thread returns
immediately and let the dirty work (dequeue packets and send them to devices)
be done by other threads ?

>
> > Thanks!
> >
> > Paolo
>
> Sebastian
