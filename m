Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AD7D9984
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394415AbfJPSsv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 14:48:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51324 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731889AbfJPSsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 14:48:51 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iKoLi-0002ek-GR; Wed, 16 Oct 2019 20:48:42 +0200
Date:   Wed, 16 Oct 2019 20:48:42 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2] net: sched: Avoid using yield() in a busy
 waiting loop
Message-ID: <20191016184842.v2f54epxautxbtig@linutronix.de>
References: <20191011171526.fon5npsxnarpn3qp@linutronix.de>
 <8c3fad79-369a-403d-89fd-e54ab1b03643@cogentembedded.com>
 <20191016082833.u4jxbiqg3oo6lyue@linutronix.de>
 <CAM_iQpXS5Dm-pCAu+7t+9RRauW=q64i6VCQ-Gz6j9_qFMPcOjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAM_iQpXS5Dm-pCAu+7t+9RRauW=q64i6VCQ-Gz6j9_qFMPcOjA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-16 10:28:04 [-0700], Cong Wang wrote:
> > Link: https://lkml.kernel.org/r/1393976987-23555-1-git-send-email-mkl@pengutronix.de
> 
> BTW, this link doesn't work, 404 is returned.

here it returns 200:

|$ wget https://lkml.kernel.org/r/1393976987-23555-1-git-send-email-mkl@pengutronix.de
|--2019-10-16 20:37:05--  https://lkml.kernel.org/r/1393976987-23555-1-git-send-email-mkl@pengutronix.de
|Resolving lkml.kernel.org (lkml.kernel.org)... 54.69.74.255, 54.71.250.162
|Connecting to lkml.kernel.org (lkml.kernel.org)|54.69.74.255|:443... connected.
|HTTP request sent, awaiting response... 302 Found
|Location: https://lore.kernel.org/linux-rt-users/1393976987-23555-1-git-send-email-mkl@pengutronix.de/ [following]
|--2019-10-16 20:37:06--  https://lore.kernel.org/linux-rt-users/1393976987-23555-1-git-send-email-mkl@pengutronix.de/
|Resolving lore.kernel.org (lore.kernel.org)... 54.71.250.162, 54.69.74.255
|Connecting to lore.kernel.org (lore.kernel.org)|54.71.250.162|:443... connected.
|HTTP request sent, awaiting response... 200 OK
|Length: 10044 (9,8K) [text/html]
|Saving to: ‘1393976987-23555-1-git-send-email-mkl@pengutronix.de’


> > --- a/net/sched/sch_generic.c
> > +++ b/net/sched/sch_generic.c
> > @@ -1217,8 +1217,13 @@ void dev_deactivate_many(struct list_head *head)
> >
> >         /* Wait for outstanding qdisc_run calls. */
> >         list_for_each_entry(dev, head, close_list) {
> > -               while (some_qdisc_is_busy(dev))
> > -                       yield();
> > +               while (some_qdisc_is_busy(dev)) {
> > +                       /* wait_event() would avoid this sleep-loop but would
> > +                        * require expensive checks in the fast paths of packet
> > +                        * processing which isn't worth it.
> > +                        */
> > +                       schedule_timeout_uninterruptible(1);
> 
> I am curious why this is uninterruptible?

You don't want a signal to wake it too early. It has to chill for a
jiffy.

> Thanks.

Sebastian
