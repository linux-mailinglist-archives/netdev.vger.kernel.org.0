Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64EB210F2CF
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 23:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfLBWXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 17:23:48 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:38103 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfLBWXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 17:23:48 -0500
Received: by mail-yw1-f65.google.com with SMTP id 10so496054ywv.5
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 14:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FZ8CD/hy+nrCOGuSIHQVGbfEQa9K/NStI0tU3KpRq/M=;
        b=wCJBi6QqYAjiyaKOTaLkRsEcJDo+OVBarmY79DaQ58jpsbwaABuVbDvdX8d/gXlA6U
         2OWRg4QC3ifu7NzA1DqrtIInu2zM7qKrJ7xgJxi4Hh7BkQ3f43QYy7NLRz2f8mXzBTih
         Oxsk7eewXMv7eAE/X1PGes/7RAP6kEY9F8d0JU4nf2MPDVq+VoVFiiH9ZZClV0HlZK2F
         zgFxEWUsTrZGssyon8oJ58wbUbPL8AGpXxPSV9eHktK+VtW7ebWk7CvcfLP8N3Juf7OA
         HHPcgGCchXvClaPPJvSku4o2317tjmmaZJcBpFwgYamd9v8G+/KQlvqJ1BRNBMW8UC34
         a+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FZ8CD/hy+nrCOGuSIHQVGbfEQa9K/NStI0tU3KpRq/M=;
        b=jC9nuNTr0lBxNZLQ6Wn4z6lrGrqP1xwwHnBHxmZLICstshatUBYfjqk47jZjtI51+M
         NK4rXF7UTDgNB70z3mv1j8xftRtzn1I78gZhbH0CWrNlOeti3SaQGme4rBhFV6UoQMVj
         tkKoPU+5YyoesZ5yyHZxullI/zp2tQux+eFmPnbU1Ri+v+T7unJi0OjVzAU4mUiD2RiM
         qgwC0kALibkBaPD+iMN8Bf/99MtLExNJckTCh4PjGIl2izrk1wryaFzuQZPn3Yj9eCSg
         6tTTWfzlORi5Wbc/fcXJVaYFiLgEPhKZw1FdxZnzx9BQoelx/ycj1rXqG0/2EUG8Y28e
         XkHg==
X-Gm-Message-State: APjAAAWg435o7hb1Yl2c5rhDpY9uCmGAAwnwgfpfeCW6Y6uVP4hawaJx
        skzjljDktceBJ00OANCIe65lGhxcxujbnkXiY5t3liqC2MM=
X-Google-Smtp-Source: APXvYqzHGV/w1LtdPUIxhPOtCNOqAaWQ4yTvRFPPdqq63P8aGPjw0Ef4rmonfOpQT9wMtYRkHhtipD6TJp7v9TLGDm0=
X-Received: by 2002:a81:3a06:: with SMTP id h6mr918164ywa.170.1575325426292;
 Mon, 02 Dec 2019 14:23:46 -0800 (PST)
MIME-Version: 1.0
References: <2601e43617d707a28f60f2fe6927b1aaaa0a37f8.1574976866.git.gnault@redhat.com>
 <CANn89i+G0jCU=JtSit3X9w+SaExgbbo-d1x4UEkTEJRdypN3gQ@mail.gmail.com> <20191202215143.GA13231@linux.home>
In-Reply-To: <20191202215143.GA13231@linux.home>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 2 Dec 2019 14:23:35 -0800
Message-ID: <CANn89i+k3+NN8=5fD9RN4BnPT5dei=iKJaps_0vmcMNQwC58mw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Avoid time_after32() underflow when handling syncookies
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 1:51 PM Guillaume Nault <gnault@redhat.com> wrote:
>
> On Thu, Nov 28, 2019 at 02:04:19PM -0800, Eric Dumazet wrote:
> > On Thu, Nov 28, 2019 at 1:36 PM Guillaume Nault <gnault@redhat.com> wrote:
> > >
> > > In tcp_synq_overflow() and tcp_synq_no_recent_overflow(), the
> > > time_after32() call might underflow and return the opposite of the
> > > expected result.
> > >
> > > This happens after socket initialisation, when ->synq_overflow_ts and
> > > ->rx_opt.ts_recent_stamp are still set to zero. In this case, they
> > > can't be compared reliably to the current value of jiffies using
> > > time_after32(), because jiffies may be too far apart (especially soon
> > > after system startup, when it's close to 2^32).
> > >
> > > In such a situation, the erroneous time_after32() result prevents
> > > tcp_synq_overflow() from updating ->synq_overflow_ts and
> > > ->rx_opt.ts_recent_stamp, so the problem remains until jiffies wraps
> > > and exceeds HZ.
> > >
> > > Practical consequences should be quite limited though, because the
> > > time_after32() call of tcp_synq_no_recent_overflow() would also
> > > underflow (unless jiffies wrapped since the first time_after32() call),
> > > thus detecting a socket overflow and triggering the syncookie
> > > verification anyway.
> > >
> > > Also, since commit 399040847084 ("bpf: add helper to check for a valid
> > > SYN cookie") and commit 70d66244317e ("bpf: add bpf_tcp_gen_syncookie
> > > helper"), tcp_synq_overflow() and tcp_synq_no_recent_overflow() can be
> > > triggered from BPF programs. Even though such programs would normally
> > > pair these two operations, so both underflows would compensate each
> > > other as described above, we'd better avoid exposing the problem
> > > outside of the kernel networking stack.
> > >
> > > Let's fix it by initialising ->rx_opt.ts_recent_stamp and
> > > ->synq_overflow_ts to a value that can be safely compared to jiffies
> > > using time_after32(). Use "jiffies - TCP_SYNCOOKIE_VALID - 1", to
> > > indicate that we're not in a socket overflow phase.
> > >
> >
> > A listener could be live for one year, and flip its ' I am under
> > synflood' status every 24 days (assuming HZ=1000)
> >
> > You only made sure the first 24 days are ok, but the problem is still there.
> >
> > We need to refresh the values, maybe in tcp_synq_no_recent_overflow()
> >
> Yes, but can't we refresh it in tcp_synq_overflow() instead? We
> basically always want to update the timestamp, unless it's already in
> the [last_overflow, last_overflow + HZ] interval:
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 36f195fb576a..1a3d76dafba8 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -494,14 +494,16 @@ static inline void tcp_synq_overflow(const struct sock *sk)
>                 reuse = rcu_dereference(sk->sk_reuseport_cb);
>                 if (likely(reuse)) {
>                         last_overflow = READ_ONCE(reuse->synq_overflow_ts);
> -                       if (time_after32(now, last_overflow + HZ))
> +                       if (time_before32(now, last_overflow) ||
> +                           time_after32(now, last_overflow + HZ))
>                                 WRITE_ONCE(reuse->synq_overflow_ts, now);
>                         return;
>                 }
>         }
>
>         last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
> -       if (time_after32(now, last_overflow + HZ))
> +       if (time_before32(now, last_overflow) ||
> +           time_after32(now, last_overflow + HZ))
>                 tcp_sk(sk)->rx_opt.ts_recent_stamp = now;
>  }
>
> This way, tcp_synq_no_recent_overflow() should always have a recent
> timestamp to work on, unless tcp_synq_overflow() wasn't called. But I
> can't see this case happening for a legitimate connection (unless I've
> missed something of course).
>
> One could send an ACK without a SYN and get into this situation, but
> then the timestamp value doesn't have too much importance since we have
> to drop the connection anyway. So, even though an expired timestamp
> could let the packet pass the tcp_synq_no_recent_overflow() test, the
> syncookie validation would fail. So the packet is correctly rejected in
> any case.

But the bug never has been that we could accept an invalid cookie
(this is unlikely because of the secret matching)

The bug was that even if we have not sent recent SYNCOOKIES, we would
still try to validate
a cookie when a stray packet comes.

In the end, the packet would be dropped anyway, but we could drop the
packet much faster.

Updating timestamps in tcp_synq_overflow() is not going to work if we
never call it :)

I believe tcp_synq_no_recent_overflow() is the right place to add the fix.
