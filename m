Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 780FAECB9A
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfKAWnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:43:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41083 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbfKAWnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:43:31 -0400
Received: by mail-pl1-f196.google.com with SMTP id t10so4961043plr.8
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 15:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BVNodbbU/Krg/+1rjvv480rm0mrtlCjkXHe9YiP12N8=;
        b=nDcOaLqDpD7NxwojJ3HeFqkngw1MG0BDvTfSJEiXwoBfVivhKnhWx/eTuiiMle9yvS
         r5+SQPL7cOlRqJsphATJzOCl0RsNerAIny/yXVFKSc6QQdJYgr9fzpbPVWRqZpD+Ifta
         TDIcsYQxbhf33l9IzXE2fopR/e9bYdxba9nk/GuAwF2KhXWxsWYTvqBJVv2VeKnpRGp5
         QhiQFW51u4px34Xh8YAwzuhCrib6g6B1aGTwoJAvCyUma6+KY6ZWOQlWHasX0ef5zwyJ
         V4BBdXraT1+tELahJnE6yyk66jJDs966c6oUYyBjknGYi+4GvwUKYr7hpYSBnZYTyl5R
         8LRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BVNodbbU/Krg/+1rjvv480rm0mrtlCjkXHe9YiP12N8=;
        b=B0dvR1kDjEizgTFubCZAyGFvHx/ZbyijVV+GZSspYpNJ1GCZtydrdxjewBLktHS/wS
         egPamvSWvWsCJiD9hpuSMviJjM2g/leFg4wLgDetq51giMyVJzaZDYzYLPOYZdu7iTHg
         6OttaNPnoCMHxgaDTSKEUZmrBcm6ClnLR4tb6vyepe0seirWsPQZsbIvJOhcXjT+yX5P
         9M2B1Ix5IJHBAoNLw62nUlxYxFKx0cSUzndyr/08eqrLzSk7+E94gtbgCe9sg9HZBD/t
         lIZDJH2vtX/t8HV1a+OCQzI267/irNSujqJFu+BPFeJ6gYF2rlCN82kWzqpVN3PagAch
         mInA==
X-Gm-Message-State: APjAAAVjVylfKfktY1lbMtovbatxRJ7vBafKMfAnPaobx6ud3TQDBRNT
        KK5O7rNrmD4lZllcRkODnZheWcQwkmNgnsYL6f51tdUMnkw=
X-Google-Smtp-Source: APXvYqzKnRuzQ+cGtLtD668y2zHhaQyYq0e/VVhb5ae5wcfB3oGb4zrvrNyY3raZcrJvac2/vhfsp03pXuxsQ4TTPLQ=
X-Received: by 2002:a17:902:321:: with SMTP id 30mr14945177pld.61.1572648210430;
 Fri, 01 Nov 2019 15:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <20191101221605.32210-1-xiyou.wangcong@gmail.com> <CANn89iKS6fas9O74U5w1wb+8DN==fXRKQ8nzq0tkT_VOXRtYBQ@mail.gmail.com>
In-Reply-To: <CANn89iKS6fas9O74U5w1wb+8DN==fXRKQ8nzq0tkT_VOXRtYBQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 1 Nov 2019 15:43:19 -0700
Message-ID: <CAM_iQpUGAaV9hsP4Z7YoHD6rQuJDSP_WNk_-d97Uxyed2SsgrA@mail.gmail.com>
Subject: Re: [RFC Patch] tcp: make icsk_retransmit_timer pinned
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 3:31 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Nov 1, 2019 at 3:16 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > While investigating the spinlock contention on resetting TCP
> > retransmit timer:
> >
> >   61.72%    61.71%  swapper          [kernel.kallsyms]                        [k] queued_spin_lock_slowpath
> >    ...
> >     - 58.83% tcp_v4_rcv
> >       - 58.80% tcp_v4_do_rcv
> >          - 58.80% tcp_rcv_established
> >             - 52.88% __tcp_push_pending_frames
> >                - 52.88% tcp_write_xmit
> >                   - 28.16% tcp_event_new_data_sent
> >                      - 28.15% sk_reset_timer
> >                         + mod_timer
> >                   - 24.68% tcp_schedule_loss_probe
> >                      - 24.68% sk_reset_timer
> >                         + 24.68% mod_timer
> >
> > it turns out to be a serious timer migration issue. After collecting timer_start
> > trace events for tcp_write_timer, it shows more than 77% times this timer got
> > migrated to a difference CPU:
> >
> >         $ perl -ne 'if (/\[(\d+)\].* cpu=(\d+)/){print if $1 != $2 ;}' tcp_timer_trace.txt | wc -l
> >         1303826
> >         $ wc -l tcp_timer_trace.txt
> >         1681068 tcp_timer_trace.txt
> >         $ python
> >         Python 2.7.5 (default, Jul 11 2019, 17:13:53)
> >         [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)] on linux2
> >         Type "help", "copyright", "credits" or "license" for more information.
> >         >>> 1303826 / 1681068.0
> >         0.7755938486723916
> >
> > And all of those migration happened during an idle CPU serving a network RX
> > softirq.  So, the logic of testing CPU idleness in idle_cpu() is false positive.
> > I don't know whether we should relax it for this scenario particuarly, something
> > like:
> >
> > -       if (!idle_cpu(cpu) && housekeeping_cpu(cpu, HK_FLAG_TIMER))
> > +       if ((!idle_cpu(cpu) || in_serving_softirq()) &&
> > +           housekeeping_cpu(cpu, HK_FLAG_TIMER))
> >                 return cpu;
> >
> > (There could be better way than in_serving_softirq() to measure the idleness,
> > of course.)
> >
> > Or simply just make the TCP retransmit timer pinned. At least this approach
> > has the minimum impact.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > ---
> >  net/ipv4/inet_connection_sock.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index eb30fc1770de..de5510ddb1c8 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -507,7 +507,7 @@ void inet_csk_init_xmit_timers(struct sock *sk,
> >  {
> >         struct inet_connection_sock *icsk = inet_csk(sk);
> >
> > -       timer_setup(&icsk->icsk_retransmit_timer, retransmit_handler, 0);
> > +       timer_setup(&icsk->icsk_retransmit_timer, retransmit_handler, TIMER_PINNED);
> >         timer_setup(&icsk->icsk_delack_timer, delack_handler, 0);
> >         timer_setup(&sk->sk_timer, keepalive_handler, 0);
> >         icsk->icsk_pending = icsk->icsk_ack.pending = 0;
> > --
> > 2.21.0
> >
>
> Now you are talking ...
>
> We have disabled /proc/sys/kernel/timer_migration on all Google servers,
> because this made no sense on servers really, and not only for tcp timers.

So let's make the sysctl timer_migration disabled by default? It is
always how we want to trade off CPU power saving with latency.

Did you measure how much CPU power it increases after disabling it?
If not much, we can certainly make it disabled by default.

>
> This has been a hot topic years ago ( random example :
> https://lore.kernel.org/patchwork/patch/947052/ )

Yeah, this specific patch has been merged for a long time,
but I know you are not just talking about this single one. :)

Thanks.
