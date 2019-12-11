Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2C011BD25
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfLKTjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:39:37 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:42135 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfLKTjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:39:36 -0500
Received: by mail-yb1-f194.google.com with SMTP id p137so9491123ybg.9
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 11:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bICb5D6Xa9d9HbXAaouBtEU+Rjvs0lLo4y2MwnYehLk=;
        b=POEcHYtCbBWDQKjS5j2V5HbwbiosYrN3N/LNOI/5VVum2qrFQXrHmYb822qkyMID/N
         sooyrt9POI2EpShTy/DX4reXcg0QfQN+CG9E0YWn5N36WgC3IMe18895y0ICZpgVmPLs
         qmCLJb9rnixgeRjem8r77kupw+UbLuchqJhUyiuPgwpnNkfjpUxJY4NrlNM80AFHOEGX
         PYS82qBCsWuB2FLa/gHCjz99SN8ztkFpmNiPwq9YxfVZ8ron9NXLTcHaKqDmJpW6H5aU
         MS4oMKBBbIAGWYhfrLBvMuBLccpAjkIZ47WY0HoT0LRrqT+klAxZEUVh+aXdwavVggFJ
         yU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bICb5D6Xa9d9HbXAaouBtEU+Rjvs0lLo4y2MwnYehLk=;
        b=lyN0VKPkpFXNFmdCHobsLUbcbIdEcxpzrZuAclCSj1/MdEC2p4QFYYnPpSTATzilck
         Nf+K9o7X4GnTcBVSTtmafz6TuYpVfzOQZd1PC9NFJIerWCoI6qh8ddqUqWZV6vAw3tgx
         +MHN2BxHvph/CBnyGdf8jgf8jsuSmi9F6/eUHRjbNjrDRSDLYNdbaktzvq8PFGxuqSNP
         +BOYndOqVytPACUBrbJS5VPWdMhWcFpS0bktQ8tGNi9BNRapmQt4kgoenMKFfjzAmQca
         N+jEOlmfM+6sf0pWxcFsH7oIDrnIXfsqad1Y+IeUdYI3tSCl5wBozD6jvqpQTNNmglph
         RDuw==
X-Gm-Message-State: APjAAAXCMewzNBuKKym6FDWKl8ElbI1L329moltf6VFR54wgas8mBisl
        1Puv8K2nbAdkR3TeF+z4tWFX1ygtZG6MLI1dadIozA==
X-Google-Smtp-Source: APXvYqwXj6ZO+6QEctOBSYxlPqADwdGbzvU6Pdi1bUJuIYKf8HrEa+3NsHKjarwFg6r/aIl0cbH+GKNJf4o3HnEC2wE=
X-Received: by 2002:a25:aaa4:: with SMTP id t33mr1333807ybi.274.1576093175220;
 Wed, 11 Dec 2019 11:39:35 -0800 (PST)
MIME-Version: 1.0
References: <20191211073419.258820-1-edumazet@google.com> <CADVnQynJoDaNhY=NODF7CJ5KdqVzwgTZU5zoysAEbGJ3TXJnvQ@mail.gmail.com>
In-Reply-To: <CADVnQynJoDaNhY=NODF7CJ5KdqVzwgTZU5zoysAEbGJ3TXJnvQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 11 Dec 2019 11:39:23 -0800
Message-ID: <CANn89i+z8mOB+YAwvKN=0EwLN-gQDKit8WA9SbeCyxdACB_O_Q@mail.gmail.com>
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

On Wed, Dec 11, 2019 at 11:17 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Wed, Dec 11, 2019 at 2:34 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > Backport of commit fdfc5c8594c2 ("tcp: remove empty skb from
> > write queue in error cases") in linux-4.14 stable triggered
> > various bugs. One of them has been fixed in commit ba2ddb43f270
> > ("tcp: Don't dequeue SYN/FIN-segments from write-queue"), but
> > we still have crashes in some occasions.
> >
> > Root-cause is that when tcp_sendmsg() has allocated a fresh
> > skb and could not append a fragment before being blocked
> > in sk_stream_wait_memory(), tcp_write_xmit() might be called
> > and decide to send this fresh and empty skb.
> >
> > Sending an empty packet is not only silly, it might have caused
> > many issues we had in the past with tp->packets_out being
> > out of sync.
> >
> > Fixes: c65f7f00c587 ("[TCP]: Simplify SKB data portion allocation with NETIF_F_SG.")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Christoph Paasch <cpaasch@apple.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > Cc: Jason Baron <jbaron@akamai.com>
> > ---
> >  net/ipv4/tcp_output.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index b184f03d743715ef4b2d166ceae651529be77953..57f434a8e41ffd6bc584cb4d9e87703491a378c1 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -2438,6 +2438,14 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
> >                 if (tcp_small_queue_check(sk, skb, 0))
> >                         break;
> >
> > +               /* Argh, we hit an empty skb(), presumably a thread
> > +                * is sleeping in sendmsg()/sk_stream_wait_memory().
> > +                * We do not want to send a pure-ack packet and have
> > +                * a strange looking rtx queue with empty packet(s).
> > +                */
> > +               if (TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq)
> > +                       break;
> > +
> >                 if (unlikely(tcp_transmit_skb(sk, skb, 1, gfp)))
> >                         break;
> >
> > --
>
> Thanks for the fix, Eric!
>
> Is there any risk that any current or future bugs that create
> persistently empty skbs could cause the connection to "freeze", unable
> to reach the tcp_transmit_skb() call in tcp_write_xmit()?
>
> To avoid this risk, would it make sense to delete the empty skb and
> continue the tcp_write_xmit() transmit loop, rather than breaking out
> of the loop?

This 'empty' skb must be the last in the queue.

Removing it from the queue would not prevent tcp_write_xmit() from
breaking the loop.

If we remove it, then we force sendmsg() to re-allocate a fresh skb,
which seems more work, and would paper around the bugs that would be
un-noticed.

Another question to ask is if we need to reconsider how we use
tcp_write_queue_empty() as an indicator
for 'I  have something in the write queue'

This is obviously wrong if the write queue has a single empty skb.

Maybe we should instead use tp->write_seq != tp->snd_nxt
