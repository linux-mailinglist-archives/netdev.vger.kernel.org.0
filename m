Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E316D9D86
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 23:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388599AbfJPVeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 17:34:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33321 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728817AbfJPVeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 17:34:12 -0400
Received: by mail-pg1-f194.google.com with SMTP id i76so29251pgc.0
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 14:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P9Z4IcYw7eFOthSvE6QIzkNKkSUPA93rVXT13zNBlM0=;
        b=sMN1D4yH5Hx147R+WZ0nHaflNHuOEdajzfYFbF4m603XGxMWtIfu+IqJarFioHLGYG
         IOnCwGR/bpku2WHd4vc7vovAvkzow+wCkpTde6YxDUDN+rztXVLlLyF/bY7yxqxyBhX9
         rgjLonXwkJ9jZyIhBu03uVqweC47GEmXJoeoQhJRk9yroCFt9LWVb6HtQiqfGOZo2KKA
         0vA7YjPLWtjj8GzJQH0XX6yDsVlvsOkQ0wedp07n7WdIJs+nQSmvfofE7JvYWcVCpDOP
         QuKCSZXs145i1QhapSE+CxdmeXwepM7Vha3Ve5dApDnPD7YwyGGXPXOzqhW2H6DRwinE
         TjnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P9Z4IcYw7eFOthSvE6QIzkNKkSUPA93rVXT13zNBlM0=;
        b=LdfadsDaVQL7am5/HdFFE27/ikatzRUsIBIKvPiYkXX9UwAvBBXQj/cffzhoCq4wNF
         ZAj6R7S2VB1PH56H43/ZYwWkcXFJcHVa+covG20AUNkP2IwAvSzBFkQrvGmci7LfXCG1
         EQW6+xq8X4UwQpuXw6ypmHFV8yaUbpH4I9pPE+d7xaxvIWMPsfYMF4PUh7kau92pxH91
         VATttLWSeRkobA8HsEVr1inHcUyQJ7YweSl2n0m+9mtY8jdwlq+SkTObivJxhBA2+SBK
         OPYprXBvzztGSIPllkTUcfaWougBZwxKGKs8R5bY2HixLT/DCrWKnOQFhMUWSCurgbXT
         +fJQ==
X-Gm-Message-State: APjAAAXDsZmBu75KdvpaQkxlleqFmtK5mC2/la/t/I6Jq9sykhBbmX43
        d86rKKIzXJhq8RCiQupDVBtUA34ZQBWS1twd0laS1pVh
X-Google-Smtp-Source: APXvYqw9J3ir6o4YvBY6wFDfewNV5ZFo6Hj+BOorsNHw3v+JxQ4/6q6n6QIvNtny+BKLvuRmTtL4W66f/27znHNXGT0=
X-Received: by 2002:a65:614e:: with SMTP id o14mr271221pgv.237.1571261649747;
 Wed, 16 Oct 2019 14:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20191011171526.fon5npsxnarpn3qp@linutronix.de>
 <8c3fad79-369a-403d-89fd-e54ab1b03643@cogentembedded.com> <20191016082833.u4jxbiqg3oo6lyue@linutronix.de>
 <CAM_iQpXS5Dm-pCAu+7t+9RRauW=q64i6VCQ-Gz6j9_qFMPcOjA@mail.gmail.com> <20191016184842.v2f54epxautxbtig@linutronix.de>
In-Reply-To: <20191016184842.v2f54epxautxbtig@linutronix.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 16 Oct 2019 14:33:58 -0700
Message-ID: <CAM_iQpUFE0-WMEkCrMhXcHa9Tq5qs+FpNMW5ri=hSK-zN4gx5Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: sched: Avoid using yield() in a busy
 waiting loop
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 11:48 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2019-10-16 10:28:04 [-0700], Cong Wang wrote:
> > > Link: https://lkml.kernel.org/r/1393976987-23555-1-git-send-email-mkl@pengutronix.de
> >
> > BTW, this link doesn't work, 404 is returned.
>
> here it returns 200:

Must be some firewall rule on my side.


>
> > > --- a/net/sched/sch_generic.c
> > > +++ b/net/sched/sch_generic.c
> > > @@ -1217,8 +1217,13 @@ void dev_deactivate_many(struct list_head *head)
> > >
> > >         /* Wait for outstanding qdisc_run calls. */
> > >         list_for_each_entry(dev, head, close_list) {
> > > -               while (some_qdisc_is_busy(dev))
> > > -                       yield();
> > > +               while (some_qdisc_is_busy(dev)) {
> > > +                       /* wait_event() would avoid this sleep-loop but would
> > > +                        * require expensive checks in the fast paths of packet
> > > +                        * processing which isn't worth it.
> > > +                        */
> > > +                       schedule_timeout_uninterruptible(1);
> >
> > I am curious why this is uninterruptible?
>
> You don't want a signal to wake it too early. It has to chill for a
> jiffy.

Yeah, at least msleep() is uninterruptible too.

So,
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks!
