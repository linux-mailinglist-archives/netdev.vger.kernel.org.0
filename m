Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE73BECB69
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfKAWbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:31:09 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43748 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:31:09 -0400
Received: by mail-io1-f65.google.com with SMTP id c11so12467646iom.10
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 15:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LhpcedpKj5tX83OPTfX8AygpFTxHiyHDAMywSLUJSqc=;
        b=Rd/1C7TnjB1w7U17WQmB3bZusD1K4AyRyT8qF46FWNW6DX4vAqlLjzErkqwWOgBknk
         GJLA37sDpeoVQSAiQKkCgX21mVZoSL1a7t9zO6afEzgG5HuyLd90oGuLJsbuDFU15qt6
         3Hwg9Qn9qr9Y3gkx62yb/5rAIHboP43Jf6GiFlNvzTkpk8fbQiY+2273heRUXLMOJGmr
         9uTEvM46+mwR/Gshrk0hJo6dszTA38MCxSMmEyxn3FNLXGAj3zpOiunOtwBEKEGDy4U5
         2QEEjGS9U64uP+Y1NXzQ9VTG50jc9PioGTmY2cfta6ywcMwyzGSSTee1QsOgfAa7B6AB
         11/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LhpcedpKj5tX83OPTfX8AygpFTxHiyHDAMywSLUJSqc=;
        b=umDpOZyBbOX/h0fNt24L4iYSSBm5cf9L8vgS+81X7x4aDWmGcufJBy8/ezV/YHQeKb
         26NvYL6AcMOXdEgYd17sNMar0qK5brSjGfHGzx6s5+wgtVv2ZIsO8Bw4QFoHg/r58IYU
         6rX5K4JYo/yUuFE8Jd+uMCKrk50GJAFaPZe6gLx/ai4O/abW8YSvQm9JRscohIWctkiV
         haPY9rHtO5GFE/ncJYTbClrfzNLGMeH7S/VlU+YA9kvhtG0/d2+T1WXDsuhwqAzFP6ul
         PZfU3dm1PshwRcrhkM0jFei7Zjokzgus9Sz5tJKezpwAB+CBCvI6V+fpBSuo+2lFRpKU
         Lfxw==
X-Gm-Message-State: APjAAAXlXwzcuhEaYxog0g5Jr0RRCbtgrIqbZtz1ljyx632x0TmOG6qU
        04sAR1/Z+YSz4MUDp71ADu/hpdYC4+ftO4I2nOxkQA==
X-Google-Smtp-Source: APXvYqwFfoRiZDoa4vsS80ddcSlP19TUQaxCFCw9dFdBa3e1wv7ZkrAAACfpamG4Yy1zU/tC7D9+i5mVfndWL7hepn8=
X-Received: by 2002:a6b:b714:: with SMTP id h20mr13480767iof.168.1572647468152;
 Fri, 01 Nov 2019 15:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <20191101221605.32210-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20191101221605.32210-1-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 1 Nov 2019 15:30:56 -0700
Message-ID: <CANn89iKS6fas9O74U5w1wb+8DN==fXRKQ8nzq0tkT_VOXRtYBQ@mail.gmail.com>
Subject: Re: [RFC Patch] tcp: make icsk_retransmit_timer pinned
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 3:16 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> While investigating the spinlock contention on resetting TCP
> retransmit timer:
>
>   61.72%    61.71%  swapper          [kernel.kallsyms]                        [k] queued_spin_lock_slowpath
>    ...
>     - 58.83% tcp_v4_rcv
>       - 58.80% tcp_v4_do_rcv
>          - 58.80% tcp_rcv_established
>             - 52.88% __tcp_push_pending_frames
>                - 52.88% tcp_write_xmit
>                   - 28.16% tcp_event_new_data_sent
>                      - 28.15% sk_reset_timer
>                         + mod_timer
>                   - 24.68% tcp_schedule_loss_probe
>                      - 24.68% sk_reset_timer
>                         + 24.68% mod_timer
>
> it turns out to be a serious timer migration issue. After collecting timer_start
> trace events for tcp_write_timer, it shows more than 77% times this timer got
> migrated to a difference CPU:
>
>         $ perl -ne 'if (/\[(\d+)\].* cpu=(\d+)/){print if $1 != $2 ;}' tcp_timer_trace.txt | wc -l
>         1303826
>         $ wc -l tcp_timer_trace.txt
>         1681068 tcp_timer_trace.txt
>         $ python
>         Python 2.7.5 (default, Jul 11 2019, 17:13:53)
>         [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)] on linux2
>         Type "help", "copyright", "credits" or "license" for more information.
>         >>> 1303826 / 1681068.0
>         0.7755938486723916
>
> And all of those migration happened during an idle CPU serving a network RX
> softirq.  So, the logic of testing CPU idleness in idle_cpu() is false positive.
> I don't know whether we should relax it for this scenario particuarly, something
> like:
>
> -       if (!idle_cpu(cpu) && housekeeping_cpu(cpu, HK_FLAG_TIMER))
> +       if ((!idle_cpu(cpu) || in_serving_softirq()) &&
> +           housekeeping_cpu(cpu, HK_FLAG_TIMER))
>                 return cpu;
>
> (There could be better way than in_serving_softirq() to measure the idleness,
> of course.)
>
> Or simply just make the TCP retransmit timer pinned. At least this approach
> has the minimum impact.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/ipv4/inet_connection_sock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index eb30fc1770de..de5510ddb1c8 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -507,7 +507,7 @@ void inet_csk_init_xmit_timers(struct sock *sk,
>  {
>         struct inet_connection_sock *icsk = inet_csk(sk);
>
> -       timer_setup(&icsk->icsk_retransmit_timer, retransmit_handler, 0);
> +       timer_setup(&icsk->icsk_retransmit_timer, retransmit_handler, TIMER_PINNED);
>         timer_setup(&icsk->icsk_delack_timer, delack_handler, 0);
>         timer_setup(&sk->sk_timer, keepalive_handler, 0);
>         icsk->icsk_pending = icsk->icsk_ack.pending = 0;
> --
> 2.21.0
>

Now you are talking ...

We have disabled /proc/sys/kernel/timer_migration on all Google servers,
because this made no sense on servers really, and not only for tcp timers.

This has been a hot topic years ago ( random example :
https://lore.kernel.org/patchwork/patch/947052/ )
