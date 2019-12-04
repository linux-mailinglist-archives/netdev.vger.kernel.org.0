Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E8F1120BD
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 01:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfLDArE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 19:47:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44825 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726079AbfLDArE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 19:47:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575420422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W6jDKvdUnOQApTTWAPWb6cs50ytlOfztgweM0ZR6+hc=;
        b=DvN+y0FK8rzaiH8RXQ9Hw+3s2RH1pjOZkUaPCqh4/LNyHBnA8O0VrGQ8a7Rsn6XWhUi3cN
        b9GnkzzBswsPSgE0CzGCZ3khOdnuBlrll7z+SzWOwKJlh2rhMhdF31dgknoBAGIoLM+jjn
        +/ksGiRec6UnOd7UAntXbxIkEJ3Kv6k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-ria9zZbcPkO5yKIh13OdKA-1; Tue, 03 Dec 2019 19:46:59 -0500
Received: by mail-wm1-f71.google.com with SMTP id s12so1614277wmc.6
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 16:46:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T8aNrLHXJmGFKXVtyUJltKpIVfQ5TV2F/h2G1SwMPnc=;
        b=TocxRsn3yvtNX3CkShDuc9I6hGcUMP2hZZTGFjOGc1X7d2lIRpHXIizu8vpv0D2x79
         DrD1a8R20C03hzpGCjtia7f50AkWZZDP8RMuP2Chnbw6kA8q1w1chvKzwPCxVDsHNcch
         mCwDMvblBaUrBpAAB195esI1WrZtZl3LjTzBHcTE2iF1QMM1VM+wOX2M1Lz0H8o2TG78
         er4N3Y8CEXHQTtQC3eRb5E9/qp1F6i2/YUEgMwcN/3oLKI7/S6f/W247jk96lYFTHFYa
         sY3qSKg4hSpG6V4yOdI1L5L+xciim+9EbOKjS/cJfSqxDLgQLCxUZk7uEl8/cCwRxkwC
         JYAA==
X-Gm-Message-State: APjAAAUXVef9+4urqYG0yGAxGeKdcFkprHdQxYUjxLzerW6lPekzPw+L
        JqG4bjj6uTgwtgv3PxzAmE1B3YgLXH77H6KzJE8c9OCo6dOz2dTyHBQMLIz/YmCQU9eFvjtNjPk
        F5fi3OyfB0acHRsHS
X-Received: by 2002:adf:9427:: with SMTP id 36mr902371wrq.166.1575420418032;
        Tue, 03 Dec 2019 16:46:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqy67wRVyxORuh5LaMx/JCVjV+TIZTetO2Wt3X8vAwQ0qKCQ2MDevuT16G5pk/mLrZ6q8c/fFQ==
X-Received: by 2002:adf:9427:: with SMTP id 36mr902355wrq.166.1575420417696;
        Tue, 03 Dec 2019 16:46:57 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id 2sm6072089wrq.31.2019.12.03.16.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 16:46:56 -0800 (PST)
Date:   Wed, 4 Dec 2019 01:46:54 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net] tcp: Avoid time_after32() underflow when handling
 syncookies
Message-ID: <20191204004654.GA22999@linux.home>
References: <2601e43617d707a28f60f2fe6927b1aaaa0a37f8.1574976866.git.gnault@redhat.com>
 <CANn89i+G0jCU=JtSit3X9w+SaExgbbo-d1x4UEkTEJRdypN3gQ@mail.gmail.com>
 <20191202215143.GA13231@linux.home>
 <CANn89i+k3+NN8=5fD9RN4BnPT5dei=iKJaps_0vmcMNQwC58mw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANn89i+k3+NN8=5fD9RN4BnPT5dei=iKJaps_0vmcMNQwC58mw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: ria9zZbcPkO5yKIh13OdKA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 02, 2019 at 02:23:35PM -0800, Eric Dumazet wrote:
> On Mon, Dec 2, 2019 at 1:51 PM Guillaume Nault <gnault@redhat.com> wrote:
> >
> > On Thu, Nov 28, 2019 at 02:04:19PM -0800, Eric Dumazet wrote:
> > > On Thu, Nov 28, 2019 at 1:36 PM Guillaume Nault <gnault@redhat.com> w=
rote:
> > > >
> > > > In tcp_synq_overflow() and tcp_synq_no_recent_overflow(), the
> > > > time_after32() call might underflow and return the opposite of the
> > > > expected result.
> > > >
> > > > This happens after socket initialisation, when ->synq_overflow_ts a=
nd
> > > > ->rx_opt.ts_recent_stamp are still set to zero. In this case, they
> > > > can't be compared reliably to the current value of jiffies using
> > > > time_after32(), because jiffies may be too far apart (especially so=
on
> > > > after system startup, when it's close to 2^32).
> > > >
> > > > In such a situation, the erroneous time_after32() result prevents
> > > > tcp_synq_overflow() from updating ->synq_overflow_ts and
> > > > ->rx_opt.ts_recent_stamp, so the problem remains until jiffies wrap=
s
> > > > and exceeds HZ.
> > > >
> > > > Practical consequences should be quite limited though, because the
> > > > time_after32() call of tcp_synq_no_recent_overflow() would also
> > > > underflow (unless jiffies wrapped since the first time_after32() ca=
ll),
> > > > thus detecting a socket overflow and triggering the syncookie
> > > > verification anyway.
> > > >
> > > > Also, since commit 399040847084 ("bpf: add helper to check for a va=
lid
> > > > SYN cookie") and commit 70d66244317e ("bpf: add bpf_tcp_gen_syncook=
ie
> > > > helper"), tcp_synq_overflow() and tcp_synq_no_recent_overflow() can=
 be
> > > > triggered from BPF programs. Even though such programs would normal=
ly
> > > > pair these two operations, so both underflows would compensate each
> > > > other as described above, we'd better avoid exposing the problem
> > > > outside of the kernel networking stack.
> > > >
> > > > Let's fix it by initialising ->rx_opt.ts_recent_stamp and
> > > > ->synq_overflow_ts to a value that can be safely compared to jiffie=
s
> > > > using time_after32(). Use "jiffies - TCP_SYNCOOKIE_VALID - 1", to
> > > > indicate that we're not in a socket overflow phase.
> > > >
> > >
> > > A listener could be live for one year, and flip its ' I am under
> > > synflood' status every 24 days (assuming HZ=3D1000)
> > >
> > > You only made sure the first 24 days are ok, but the problem is still=
 there.
> > >
> > > We need to refresh the values, maybe in tcp_synq_no_recent_overflow()
> > >
> > Yes, but can't we refresh it in tcp_synq_overflow() instead? We
> > basically always want to update the timestamp, unless it's already in
> > the [last_overflow, last_overflow + HZ] interval:
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 36f195fb576a..1a3d76dafba8 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -494,14 +494,16 @@ static inline void tcp_synq_overflow(const struct=
 sock *sk)
> >                 reuse =3D rcu_dereference(sk->sk_reuseport_cb);
> >                 if (likely(reuse)) {
> >                         last_overflow =3D READ_ONCE(reuse->synq_overflo=
w_ts);
> > -                       if (time_after32(now, last_overflow + HZ))
> > +                       if (time_before32(now, last_overflow) ||
> > +                           time_after32(now, last_overflow + HZ))
> >                                 WRITE_ONCE(reuse->synq_overflow_ts, now=
);
> >                         return;
> >                 }
> >         }
> >
> >         last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
> > -       if (time_after32(now, last_overflow + HZ))
> > +       if (time_before32(now, last_overflow) ||
> > +           time_after32(now, last_overflow + HZ))
> >                 tcp_sk(sk)->rx_opt.ts_recent_stamp =3D now;
> >  }
> >
> > This way, tcp_synq_no_recent_overflow() should always have a recent
> > timestamp to work on, unless tcp_synq_overflow() wasn't called. But I
> > can't see this case happening for a legitimate connection (unless I've
> > missed something of course).
> >
> > One could send an ACK without a SYN and get into this situation, but
> > then the timestamp value doesn't have too much importance since we have
> > to drop the connection anyway. So, even though an expired timestamp
> > could let the packet pass the tcp_synq_no_recent_overflow() test, the
> > syncookie validation would fail. So the packet is correctly rejected in
> > any case.
>=20
> But the bug never has been that we could accept an invalid cookie
> (this is unlikely because of the secret matching)
>=20
I didn't mean that it was. Maybe I wasn't clear, but this last
paragraph was there just to explain why I didn't address the stray
ACK scenario: such packets are correctly rejected anyway (yes we could
be more efficient at it, but that wasn't the original purpose of the
patch).

> The bug was that even if we have not sent recent SYNCOOKIES, we would
> still try to validate a cookie when a stray packet comes.
>=20
I realise that I misunderstood your original answer. I was looking at
this problem from a different angle: my original intend was to fix the
legitimate syncookie packet case.

Stale last_overflow timestamps can cause tcp_synq_overflow() to reject
valid packets in the following situation:

  * tcp_synq_overflow() is called while jiffies is not within the
    (last_overflow + HZ, last_overflow + HZ + 2^31] interval. So the
    stale last_overflow timestamp isn't updated because
    time_after32(jiffies, last_overflow + HZ) returns false.

  * Then tcp_synq_no_recent_overflow() is called, jiffies might have
    increased a bit, but can still be in the (last_overflow + TCP_SYNCOOKIE=
_VALID,
    last_overflow + TCP_SYNCOOKIE_VALID + 2^31] interval. If so,
    time_after32(jiffies, last_overflow + TCP_SYNCOOKIE_VALID) returns
    true and the packet is rejected.

The case is unlikely, and whenever it happens, it can't last more than
two minutes. But the problem is now exposed to BPF programs and the fix
is small, so I think it's worth considering it. Admittedly my original
submission wasn't complete. Checking that jiffies is outside of the
[last_overflow, last_overflow + HZ] interval, as in my second proposal,
should fix the problem completely.

> In the end, the packet would be dropped anyway, but we could drop the
> packet much faster.
>=20
> Updating timestamps in tcp_synq_overflow() is not going to work if we
> never call it :)
>=20
> I believe tcp_synq_no_recent_overflow() is the right place to add the fix=
.
>=20
Are you talking about a flood of stray ACKs (just to be sure we're on
the same page here)? If so, I guess tcp_synq_no_recent_overflow() is
our only chance to update last_overflow. But do we really need it?

I think tcp_synq_no_recent_overflow() should first check if jiffies
isn't within the [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID]
interval. Currently, we just test that it's not within
(last_overflow + TCP_SYNCOOKIE_VALID - 2^31, last_overflow + TCP_SYNCOOKIE_=
VALID].
That leaves a lot of room for stale timestamps to erroneously trigger
syncookie verification. By reducing the interval, we'd make sure that
only values that are undistinguishable from accurate fresh overflow
timestamps can trigger syncookie verification.

The only bad scenario that'd remain is if a stray ACK flood happens
when last_overflow is stale and jiffies is within the
(last_overflow, last_overflow + TCP_SYNCOOKIE_VALID) interval. If the
flood starts while we're in this state, then I fear that we can't do
anything but to wait for jiffies to exeed the interval's upper bound
(2 minutes max) and to rely on syncookies verification to reject stray
ACKs in the mean time. For cases where the flood starts before
jiffies enters that interval, then refreshing last_overflow in
tcp_synq_no_recent_overflow() would prevent jiffies from entering the
interval for the duration of the flood. last_overflow would have to be
set TCP_SYNCOOKIE_VALID seconds in the past. But since we have
no synchronisation with tcp_synq_overflow(), we'd have a race where
tcp_synq_overflow() would refresh last_overflow (entering
syncookie validation mode) and tcp_synq_no_recent_overflow() would
immediately move it backward (leaving syncookie validation mode). We'd
have to wait for the next SYN to finally reach a stable state with
syncookies validation re-enabled. This is a bit far fetched, and
requires a stray ACK arriving at the same moment a SYN flood is
detected. Still, I feel that moving last_overflow backward in
tcp_synq_no_recent_overflow() is a bit dangerous.

