Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29EE11BD39
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfLKToM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:44:12 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45511 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfLKToM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:44:12 -0500
Received: by mail-yw1-f67.google.com with SMTP id d12so9395375ywl.12
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 11:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dqTv3C1zAUdiliKlW7e8C3So5qPtPWZAZLkr5ohw83U=;
        b=inM/G2J0h8M4OSc3XlY5dJfupXqyL4rMovXr6sPae896uwdQsSnqVCgzTfkJFyPEUh
         l4pl0p7XBaxVth3KzWwRGzeyOk9XYo0KG/Xt7Zhn4e4bMtG24ytXEBDzvSYGInPccZwb
         6Jh+BM7YY08LYHSxEohS59N23aX1YFhXHPHDwPupqz7reWaKqb6GS5FGjgCSCYx2vQqc
         2FKGRcGTamt64qV6cqAYXXl4VKPsM9ZCSO8c62BN5yfDmYC8nRSB25nOdEY41OozdSWr
         NaAA+h+5QAW0uis/bhQg8HmEbQBLAmPXFNKCfNk/E/f4JInZh9507nbvL4ohuYDna0/L
         64PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dqTv3C1zAUdiliKlW7e8C3So5qPtPWZAZLkr5ohw83U=;
        b=XamyQcVNtMVYbZ/e0wCLjUMkSiP51Q7WyPyxBsqN1s4FjtVCJbTeVTCAP+60lDHfa/
         hY1khNpjUVh7m36UhMnw4rjXhSpapyQ4TEA91HiuWUZlVs6oPmkGf5lC87jEz4o/08BI
         3EqEUHWJ9R+hxw4WPzASqIV/04xdkEFENydIkbLVKTINjT00RcjcTDvyhqeG5AegbbMp
         fkVbSHA1g/O7pXkYqkRAx2ZFqkzCk8HAS89d78kZvgv+G6JTQAapGlLKU0YM8d8Iy6un
         95NYa7xdreZLGtS+3V8ZAO7kwneIEmyav89E3mD2ydYnI5W33FKGqEawma5iKU7+tVmM
         hcdw==
X-Gm-Message-State: APjAAAUrX8mvM14wRhYpLT+AAFCb3bqKJBiVPY9xkriUiTvDwXnFPf9C
        0pBrf401lEnTRncRdWR/LC679BoqNkvsWctQdG9gWg==
X-Google-Smtp-Source: APXvYqyAsNSLOaurUMcirxKl52UqPOToToVoIS0jlNeToDZ+Linrlx/k9cKelvmuK0pH19PU1q2R6xsxuLsEmaomZu8=
X-Received: by 2002:a81:4983:: with SMTP id w125mr1196521ywa.52.1576093450371;
 Wed, 11 Dec 2019 11:44:10 -0800 (PST)
MIME-Version: 1.0
References: <20191211073419.258820-1-edumazet@google.com> <CADVnQynJoDaNhY=NODF7CJ5KdqVzwgTZU5zoysAEbGJ3TXJnvQ@mail.gmail.com>
 <CANn89i+z8mOB+YAwvKN=0EwLN-gQDKit8WA9SbeCyxdACB_O_Q@mail.gmail.com>
In-Reply-To: <CANn89i+z8mOB+YAwvKN=0EwLN-gQDKit8WA9SbeCyxdACB_O_Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 11 Dec 2019 11:43:59 -0800
Message-ID: <CANn89iJ3Bkmjq3Q7Hjk7k7hftkKVF2=xEFXAdZbDvJ7Zwv0jsQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: do not send empty skb from tcp_write_xmit()
To:     Neal Cardwell <ncardwell@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Jason Baron <jbaron@akamai.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 11:39 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Dec 11, 2019 at 11:17 AM Neal Cardwell <ncardwell@google.com> wrote:
> >
> > On Wed, Dec 11, 2019 at 2:34 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > Backport of commit fdfc5c8594c2 ("tcp: remove empty skb from
> > > write queue in error cases") in linux-4.14 stable triggered
> > > various bugs. One of them has been fixed in commit ba2ddb43f270
> > > ("tcp: Don't dequeue SYN/FIN-segments from write-queue"), but
> > > we still have crashes in some occasions.
> > >
> > > Root-cause is that when tcp_sendmsg() has allocated a fresh
> > > skb and could not append a fragment before being blocked
> > > in sk_stream_wait_memory(), tcp_write_xmit() might be called
> > > and decide to send this fresh and empty skb.
> > >
> > > Sending an empty packet is not only silly, it might have caused
> > > many issues we had in the past with tp->packets_out being
> > > out of sync.
> > >
> > > Fixes: c65f7f00c587 ("[TCP]: Simplify SKB data portion allocation with NETIF_F_SG.")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Cc: Christoph Paasch <cpaasch@apple.com>
> > > Cc: Neal Cardwell <ncardwell@google.com>
> > > Cc: Jason Baron <jbaron@akamai.com>
> > > ---
> > >  net/ipv4/tcp_output.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > index b184f03d743715ef4b2d166ceae651529be77953..57f434a8e41ffd6bc584cb4d9e87703491a378c1 100644
> > > --- a/net/ipv4/tcp_output.c
> > > +++ b/net/ipv4/tcp_output.c
> > > @@ -2438,6 +2438,14 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
> > >                 if (tcp_small_queue_check(sk, skb, 0))
> > >                         break;
> > >
> > > +               /* Argh, we hit an empty skb(), presumably a thread
> > > +                * is sleeping in sendmsg()/sk_stream_wait_memory().
> > > +                * We do not want to send a pure-ack packet and have
> > > +                * a strange looking rtx queue with empty packet(s).
> > > +                */
> > > +               if (TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq)
> > > +                       break;
> > > +
> > >                 if (unlikely(tcp_transmit_skb(sk, skb, 1, gfp)))
> > >                         break;
> > >
> > > --
> >
> > Thanks for the fix, Eric!
> >
> > Is there any risk that any current or future bugs that create
> > persistently empty skbs could cause the connection to "freeze", unable
> > to reach the tcp_transmit_skb() call in tcp_write_xmit()?
> >
> > To avoid this risk, would it make sense to delete the empty skb and
> > continue the tcp_write_xmit() transmit loop, rather than breaking out
> > of the loop?
>
> This 'empty' skb must be the last in the queue.
>
> Removing it from the queue would not prevent tcp_write_xmit() from
> breaking the loop.
>
> If we remove it, then we force sendmsg() to re-allocate a fresh skb,
> which seems more work, and would paper around the bugs that would be
> un-noticed.
>
> Another question to ask is if we need to reconsider how we use
> tcp_write_queue_empty() as an indicator
> for 'I  have something in the write queue'
>
> This is obviously wrong if the write queue has a single empty skb.
>
> Maybe we should instead use tp->write_seq != tp->snd_nxt

Also we use skb_queue_len(&sk->sk_write_queue) == 0 in
tcp_sendmsg_locked() and this seems not good.

We could have changed tcp_sendmsg_locked() to leave the empty skb in
the write queue.
( and we can thus remove tcp_remove_empty_skb() completely since it
has caused many problems in stable kernels)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8a39ee79489192c02385aaadc8d1ae969fb55d23..9ba3294de9cb4e929afdc0e00b01b6b534c84af6
100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1419,7 +1419,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct
msghdr *msg, size_t size)
        sock_zerocopy_put_abort(uarg, true);
        err = sk_stream_error(sk, flags, err);
        /* make sure we wake any epoll edge trigger waiter */
-       if (unlikely(skb_queue_len(&sk->sk_write_queue) == 0 &&
+       if (unlikely(tp->write_seq == tp->snd_nxt &&
                     err == -EAGAIN)) {
                sk->sk_write_space(sk);
                tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
