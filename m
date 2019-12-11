Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5F511BD9B
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 21:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLKUEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 15:04:53 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39001 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfLKUEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 15:04:52 -0500
Received: by mail-oi1-f194.google.com with SMTP id a67so14399202oib.6
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 12:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=txJOKAYsbMMhgDMDkLa8IM9258HVlhN2VvvR8TONRE4=;
        b=jktIRf0yzClGmLqwxwNsGGxWpyrBcdLk4ZueKiKg7TACBJ1j903dJdrL3BKgR7LWcq
         SQas/quep7D4NBicWvJ4fycQOKequOR0hrKoJpnAcolzr0O1ZF/X5laMfwGrEC7sej/F
         7/7Nlai5DS35SBTcPc+RNqy8prEbPQFtC1n9C/QGp4lMu/iAlseK3fzIzysrNLHlIbb4
         cFJJE0tncZCHLBiaKS/EBhkIkipDeAEcO0Z/DFR0KeQtJW36PZB+ChyMPAzuS8z1Obd1
         Q+ZOdtkqThM5SqYM6MkFBs+WjWXsmMqafVjczKMdPL/mkCD2oKBIoOufD8ozW3xsBAhs
         dIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=txJOKAYsbMMhgDMDkLa8IM9258HVlhN2VvvR8TONRE4=;
        b=S4cD7yJJPiB9H7/W/dZjNZpITSnNQc/DiyHLAFwrGDtgm9DswBGQNTITHWaicNSmwl
         BQLLQJcTOo8mnF0v2sCqCQM3CGuGh+5B5pkGFjmzenqJ0irSyPr2UsrSd5iH14jsFz88
         PSerDg2oc687Dp0oashmkUiBJ2ozZFaEvCXH+XQ1K+sMY7fResKnchu8AkBlE/WbQ5t7
         KjlGgYIljn2Kq9KS4HiqAr8uWf+Hgg8NAb5v3SSEZ+sE3Cm11f3rT/ym8sgHEiGY3mIQ
         7gmv7wzrNMsukxhD14F3E5ldlYE+di8ax78ns8KJSfB9wCPcxpc4LLGwe39PavJA3bl+
         4TtQ==
X-Gm-Message-State: APjAAAUDmISeKuYUMTgxfs1GiITjJA3D4hXg1nqPFPH8jrYMdGUMThfD
        xX1AqLymWUE1JABFz8JJ8oB3Cmtqp0PXi/wHZc8eOOQ/JbQ=
X-Google-Smtp-Source: APXvYqzS6aTdvb6W4t5gcYbZfmqF+83suqNrR0vxqW/BjK1Q/dguzAYPkV1NTv5/v4C/5dkQhzCPbXYL6uTvexb+yPU=
X-Received: by 2002:aca:2812:: with SMTP id 18mr4206296oix.14.1576094691285;
 Wed, 11 Dec 2019 12:04:51 -0800 (PST)
MIME-Version: 1.0
References: <20191211073419.258820-1-edumazet@google.com> <CADVnQynJoDaNhY=NODF7CJ5KdqVzwgTZU5zoysAEbGJ3TXJnvQ@mail.gmail.com>
 <CANn89i+z8mOB+YAwvKN=0EwLN-gQDKit8WA9SbeCyxdACB_O_Q@mail.gmail.com> <CANn89iJ3Bkmjq3Q7Hjk7k7hftkKVF2=xEFXAdZbDvJ7Zwv0jsQ@mail.gmail.com>
In-Reply-To: <CANn89iJ3Bkmjq3Q7Hjk7k7hftkKVF2=xEFXAdZbDvJ7Zwv0jsQ@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 11 Dec 2019 15:04:34 -0500
Message-ID: <CADVnQymtEhfZ1Kn=ttrwQDAOpWx=vrr4VrKFgomasorbdWMfgQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: do not send empty skb from tcp_write_xmit()
To:     Eric Dumazet <edumazet@google.com>
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

On Wed, Dec 11, 2019 at 2:44 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Dec 11, 2019 at 11:39 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Dec 11, 2019 at 11:17 AM Neal Cardwell <ncardwell@google.com> wrote:
> > >
> > > On Wed, Dec 11, 2019 at 2:34 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > Backport of commit fdfc5c8594c2 ("tcp: remove empty skb from
> > > > write queue in error cases") in linux-4.14 stable triggered
> > > > various bugs. One of them has been fixed in commit ba2ddb43f270
> > > > ("tcp: Don't dequeue SYN/FIN-segments from write-queue"), but
> > > > we still have crashes in some occasions.
> > > >
> > > > Root-cause is that when tcp_sendmsg() has allocated a fresh
> > > > skb and could not append a fragment before being blocked
> > > > in sk_stream_wait_memory(), tcp_write_xmit() might be called
> > > > and decide to send this fresh and empty skb.
> > > >
> > > > Sending an empty packet is not only silly, it might have caused
> > > > many issues we had in the past with tp->packets_out being
> > > > out of sync.
> > > >
> > > > Fixes: c65f7f00c587 ("[TCP]: Simplify SKB data portion allocation with NETIF_F_SG.")
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > Cc: Christoph Paasch <cpaasch@apple.com>
> > > > Cc: Neal Cardwell <ncardwell@google.com>
> > > > Cc: Jason Baron <jbaron@akamai.com>
> > > > ---
> > > >  net/ipv4/tcp_output.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > >
> > > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > > index b184f03d743715ef4b2d166ceae651529be77953..57f434a8e41ffd6bc584cb4d9e87703491a378c1 100644
> > > > --- a/net/ipv4/tcp_output.c
> > > > +++ b/net/ipv4/tcp_output.c
> > > > @@ -2438,6 +2438,14 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
> > > >                 if (tcp_small_queue_check(sk, skb, 0))
> > > >                         break;
> > > >
> > > > +               /* Argh, we hit an empty skb(), presumably a thread
> > > > +                * is sleeping in sendmsg()/sk_stream_wait_memory().
> > > > +                * We do not want to send a pure-ack packet and have
> > > > +                * a strange looking rtx queue with empty packet(s).
> > > > +                */
> > > > +               if (TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq)
> > > > +                       break;
> > > > +
> > > >                 if (unlikely(tcp_transmit_skb(sk, skb, 1, gfp)))
> > > >                         break;
> > > >
> > > > --
> > >
> > > Thanks for the fix, Eric!
> > >
> > > Is there any risk that any current or future bugs that create
> > > persistently empty skbs could cause the connection to "freeze", unable
> > > to reach the tcp_transmit_skb() call in tcp_write_xmit()?
> > >
> > > To avoid this risk, would it make sense to delete the empty skb and
> > > continue the tcp_write_xmit() transmit loop, rather than breaking out
> > > of the loop?
> >
> > This 'empty' skb must be the last in the queue.
> >
> > Removing it from the queue would not prevent tcp_write_xmit() from
> > breaking the loop.
> >
> > If we remove it, then we force sendmsg() to re-allocate a fresh skb,
> > which seems more work, and would paper around the bugs that would be
> > un-noticed.
> >
> > Another question to ask is if we need to reconsider how we use
> > tcp_write_queue_empty() as an indicator
> > for 'I  have something in the write queue'
> >
> > This is obviously wrong if the write queue has a single empty skb.
> >
> > Maybe we should instead use tp->write_seq != tp->snd_nxt
>
> Also we use skb_queue_len(&sk->sk_write_queue) == 0 in
> tcp_sendmsg_locked() and this seems not good.
>
> We could have changed tcp_sendmsg_locked() to leave the empty skb in
> the write queue.
> ( and we can thus remove tcp_remove_empty_skb() completely since it
> has caused many problems in stable kernels)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 8a39ee79489192c02385aaadc8d1ae969fb55d23..9ba3294de9cb4e929afdc0e00b01b6b534c84af6
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1419,7 +1419,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct
> msghdr *msg, size_t size)
>         sock_zerocopy_put_abort(uarg, true);
>         err = sk_stream_error(sk, flags, err);
>         /* make sure we wake any epoll edge trigger waiter */
> -       if (unlikely(skb_queue_len(&sk->sk_write_queue) == 0 &&
> +       if (unlikely(tp->write_seq == tp->snd_nxt &&
>                      err == -EAGAIN)) {
>                 sk->sk_write_space(sk);
>                 tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);

Thanks, Eric.

I like your idea to audit the TCP calls to tcp_write_queue_empty() and
skb_queue_len(&sk->sk_write_queue) to see which ones should be
replaced with comparisons of tp->write_seq and tp->snd_nxt (including
this one). Good catch!

neal
