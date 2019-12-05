Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D50071146AC
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 19:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfLESOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 13:14:31 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35739 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfLESOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 13:14:30 -0500
Received: by mail-yb1-f195.google.com with SMTP id h23so1858439ybg.2
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 10:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t9fICgNiZE48EOWNbv/iH0wo8b5MSIe/vKoL3jiMYgI=;
        b=cDJ4YnYSt54BhBytv3DH8DbRvT2RCXW3/QKBFVBbwFclOFZ0Od+OyA+xyOXsLhV249
         U3Z4eW7M6M+bF4opjbyKIkqa8GkqSx97LcCqtEUnGz1cZfk23ShmjcsDl9PDd/zUdJBd
         iNXR8vl9ZqtyE4RRoMs9Yr5uynF7TAeXHISR6vJEI87fcTUXR/dF2u267uqDfnUft273
         +iTXmaphfPGqWdE4P6LJ9nxnMujxpkaLBJW1PjXKzQjy5QMy21hWmNcSPr0fGMZ7uPOH
         MGt28SBrwpyfCfpKFQsm4WqN3mIoZp06A4bC7AGJqe67+f/UtSzaEm9qRZY6iLJ7RtJK
         CaSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t9fICgNiZE48EOWNbv/iH0wo8b5MSIe/vKoL3jiMYgI=;
        b=ccOuPcA4FPbM/4z9YtHwwCNl8nFCJnpw+PZDhuw4sIDvKYgJnFUOB8EEPiIa4mOgfK
         tSeS4hfT4uxkF+FUSrSevTaw46tvGIXcYmSK0AC3wDUlhm9QyYXT2qgzuuWtIWpSlFDY
         m1EWKu6UNHDHNakrtea1AsJY6cLyv/7tRQX4t7np8OMrnqyWShUxnpT8GU+Ds4SNv7Dh
         cpdrsoN1eV98SOZccte/s3575djpIZ26P6mSKlxE1LGRsYKQbIRtRNElFKFvsP3OAsQk
         fCry15NP3/sN24u6I2EnSVs3NRJ0fyoVa2VaMj5uHEnHYsLjsmTyl3Xi9KcEOIOnV6H6
         8LKA==
X-Gm-Message-State: APjAAAXIF4uf2SVqST7LLjo3WB+reYd1fQ5H0vSJDyEMVHoMFQNWpNvc
        71DiobJtFJ/l4/LOyK1HX0T1t7uM58NKCPk3UtaLJw==
X-Google-Smtp-Source: APXvYqwWobw/XYNyTanQTWPFYYy7IFqbubF3040kwnKK60yQogX3morHn+3yg4+CFgVkT8nllESBAa3t42VDUMMrrXk=
X-Received: by 2002:a25:d80b:: with SMTP id p11mr7252999ybg.408.1575569667214;
 Thu, 05 Dec 2019 10:14:27 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575503545.git.gnault@redhat.com> <1d7e9bc77fb68706d955e4089a801ace0df5d771.1575503545.git.gnault@redhat.com>
 <80ffa7b6-bbaf-ce52-606f-d10e45644bcd@gmail.com> <20191205180019.GA16185@linux.home>
In-Reply-To: <20191205180019.GA16185@linux.home>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 5 Dec 2019 10:14:15 -0800
Message-ID: <CANn89i+RHVmA2Mc8x0NdHZjWsw4UtgZ5ymbWBBxLgv_YczUjvg@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] tcp: tighten acceptance of ACKs not matching a
 child socket
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 5, 2019 at 10:00 AM Guillaume Nault <gnault@redhat.com> wrote:
>
> On Wed, Dec 04, 2019 at 07:08:49PM -0800, Eric Dumazet wrote:
> >
> >
> > On 12/4/19 4:59 PM, Guillaume Nault wrote:
> > > When no synflood occurs, the synflood timestamp isn't updated.
> > > Therefore it can be so old that time_after32() can consider it to be
> > > in the future.
> > >
> > > That's a problem for tcp_synq_no_recent_overflow() as it may report
> > > that a recent overflow occurred while, in fact, it's just that jiffies
> > > has grown past 'last_overflow' + TCP_SYNCOOKIE_VALID + 2^31.
> > >
> > > Spurious detection of recent overflows lead to extra syncookie
> > > verification in cookie_v[46]_check(). At that point, the verification
> > > should fail and the packet dropped. But we should have dropped the
> > > packet earlier as we didn't even send a syncookie.
> > >
> > > Let's refine tcp_synq_no_recent_overflow() to report a recent overflow
> > > only if jiffies is within the
> > > [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval. This
> > > way, no spurious recent overflow is reported when jiffies wraps and
> > > 'last_overflow' becomes in the future from the point of view of
> > > time_after32().
> > >
> > > However, if jiffies wraps and enters the
> > > [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval (with
> > > 'last_overflow' being a stale synflood timestamp), then
> > > tcp_synq_no_recent_overflow() still erroneously reports an
> > > overflow. In such cases, we have to rely on syncookie verification
> > > to drop the packet. We unfortunately have no way to differentiate
> > > between a fresh and a stale syncookie timestamp.
> > >
> > > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > > ---
> > >  include/net/tcp.h | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > > index f0eae83ee555..005d4c691543 100644
> > > --- a/include/net/tcp.h
> > > +++ b/include/net/tcp.h
> > > @@ -520,12 +520,14 @@ static inline bool tcp_synq_no_recent_overflow(const struct sock *sk)
> > >             if (likely(reuse)) {
> > >                     last_overflow = READ_ONCE(reuse->synq_overflow_ts);
> > >                     return time_after32(now, last_overflow +
> > > -                                       TCP_SYNCOOKIE_VALID);
> > > +                                       TCP_SYNCOOKIE_VALID) ||
> > > +                           time_before32(now, last_overflow);
> > >             }
> > >     }
> > >
> > >     last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
> > > -   return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID);
> > > +   return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID) ||
> > > +           time_before32(now, last_overflow);
> > >  }
> >
> >
> > There is a race I believe here.
> >
> > CPU1                                 CPU2
> >
> > now = jiffies.
> >     ...
> >                                      jiffies++
> >                                      ...
> >                                      SYN received, last_overflow is updated to the new jiffies.
> >
> >
> > CPU1
> >  timer_before32(now, last_overflow) is true, because last_overflow was set to now+1
> >
> >
> > I suggest some cushion here.
> >
> Yes, we should wrap access to ->rx_opt.ts_recent_stamp into READ_ONCE(),
> to ensure that last_overflow won't be reloaded between the
> time_after32() and the time_before32() calls. Is that what you had in
> mind?
>
> -       last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
> +       last_overflow = READ_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp);
>
> Patch 1 would need the same fix BTW.
>
> > Also we TCP uses between() macro, we might add a time_between32(a, b, c) macro
> > to ease code review.
> >
> I didn't realise that. I'll define it in v3.
>
> > ->
> >   return !time_between32(last_overflow - HZ, now, last_overflow + TCP_SYNCOOKIE_VALID);
> >
> 'last_overflow - HZ'? I don't get why we'd take HZ into account here.
>

Please read carefuly my prior feedback.

Even with READ_ONCE(), you still have a race.


CPU1                                 CPU2

now = jiffies.
 <some long interrupt>
                                     jiffies++  (or jiffies += 3 or 4
if CPU1 has been interrupted by a long interrupt)
                                     ...
                                     SYN received, last_overflow is
updated to the new jiffies.


CPU1

 @now still has a stale values (an old jiffies value)
 timer_before32(now, last_overflow) is true, because last_overflow was
set to now+1 (or now + 2 or now + 3)
