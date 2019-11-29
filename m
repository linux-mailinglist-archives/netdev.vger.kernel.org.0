Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6D110D24D
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 09:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfK2INm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 03:13:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45999 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726780AbfK2INm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 03:13:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575015220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V4fWKLODm9Au9CvqDIVy+1ephSGebHzzzXPkl3u566k=;
        b=QpqtloHwg/gvtYZUMthmu8vLvIr8rGUwJkdMenjdqP0DMbmjCgoIKyJyUEs50GD8s770iZ
        AQRN+K+0ZD0U7Ph0qHLeywStJYScIEb3xmRnj5rXDUG1kgOWebcsMujwIMimcUBqxp7QK7
        72l+T3BAeAgfTWizrEThD9g4QLPmpYw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-IiBjJpnGMgmK0gkAlWqEhw-1; Fri, 29 Nov 2019 03:13:39 -0500
Received: by mail-wr1-f71.google.com with SMTP id 90so11825832wrq.6
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 00:13:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CTDUUc5+1yefPe5vsNVG6xJ3clLcLuHgKB0Wxxj7i9s=;
        b=D/BlC5EvBPxGKQygy+9N13HKaohwi24oONAR4fkx26StJ/9cQQzdb0riQYgmzasnTj
         pMXWoqkeqJUWHgoCxqLTDy9SX/EZKpcD2wPk/eBN1Pj7DDqyRiejnuGgKa7fx4shTsy3
         K4BNe7sCWiQidvhHOsyRUmjFnMpT7RPC+SnGo0oxDXA60YExfdRcGYZR5jRk9rsb7tLj
         xL+75lCnqT1GWf3fSq5MFeXEKiFBiFAVcZPC8d55mnzaJOZFNp5YHy+q8AoezdPGLLKR
         PG3dg10wkhxcE8ey+4/IXFJQ8kllFVP/OQD45c7SgkscZNhxYl6rxYxBpg5zX4fa0s+i
         lQSQ==
X-Gm-Message-State: APjAAAVEo6BSI7n/D/eYeCyK2F2Cw41d3l7w+sCieecOc2xJFL7IUO84
        kfsEYipWuFblIdbXi/vapVQVOjxnCKjearX7nh2PaOdUqXN8D7DEv+wuuR6djJa915iuwsbiSRF
        12nLND/iQL7oILRpT
X-Received: by 2002:a5d:5284:: with SMTP id c4mr14937620wrv.376.1575015217412;
        Fri, 29 Nov 2019 00:13:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqx2rtzm42/LrDm9lUVP4cOer6EstubXQgMPndSKHTi7xHi2noG0z0WOji+Z4+3OWbs3QL6f9A==
X-Received: by 2002:a5d:5284:: with SMTP id c4mr14937596wrv.376.1575015217133;
        Fri, 29 Nov 2019 00:13:37 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id k4sm13561419wmk.26.2019.11.29.00.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 00:13:36 -0800 (PST)
Date:   Fri, 29 Nov 2019 09:13:34 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net] tcp: Avoid time_after32() underflow when handling
 syncookies
Message-ID: <20191129081334.GA8118@linux.home>
References: <2601e43617d707a28f60f2fe6927b1aaaa0a37f8.1574976866.git.gnault@redhat.com>
 <CANn89i+G0jCU=JtSit3X9w+SaExgbbo-d1x4UEkTEJRdypN3gQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANn89i+G0jCU=JtSit3X9w+SaExgbbo-d1x4UEkTEJRdypN3gQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: IiBjJpnGMgmK0gkAlWqEhw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 02:04:19PM -0800, Eric Dumazet wrote:
> On Thu, Nov 28, 2019 at 1:36 PM Guillaume Nault <gnault@redhat.com> wrote=
:
> >
> > In tcp_synq_overflow() and tcp_synq_no_recent_overflow(), the
> > time_after32() call might underflow and return the opposite of the
> > expected result.
> >
> > This happens after socket initialisation, when ->synq_overflow_ts and
> > ->rx_opt.ts_recent_stamp are still set to zero. In this case, they
> > can't be compared reliably to the current value of jiffies using
> > time_after32(), because jiffies may be too far apart (especially soon
> > after system startup, when it's close to 2^32).
> >
> > In such a situation, the erroneous time_after32() result prevents
> > tcp_synq_overflow() from updating ->synq_overflow_ts and
> > ->rx_opt.ts_recent_stamp, so the problem remains until jiffies wraps
> > and exceeds HZ.
> >
> > Practical consequences should be quite limited though, because the
> > time_after32() call of tcp_synq_no_recent_overflow() would also
> > underflow (unless jiffies wrapped since the first time_after32() call),
> > thus detecting a socket overflow and triggering the syncookie
> > verification anyway.
> >
> > Also, since commit 399040847084 ("bpf: add helper to check for a valid
> > SYN cookie") and commit 70d66244317e ("bpf: add bpf_tcp_gen_syncookie
> > helper"), tcp_synq_overflow() and tcp_synq_no_recent_overflow() can be
> > triggered from BPF programs. Even though such programs would normally
> > pair these two operations, so both underflows would compensate each
> > other as described above, we'd better avoid exposing the problem
> > outside of the kernel networking stack.
> >
> > Let's fix it by initialising ->rx_opt.ts_recent_stamp and
> > ->synq_overflow_ts to a value that can be safely compared to jiffies
> > using time_after32(). Use "jiffies - TCP_SYNCOOKIE_VALID - 1", to
> > indicate that we're not in a socket overflow phase.
> >
> > Fixes: cca9bab1b72c ("tcp: use monotonic timestamps for PAWS")
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > ---
> >  net/core/sock_reuseport.c | 10 ++++++++++
> >  net/ipv4/tcp.c            |  8 ++++++++
> >  2 files changed, 18 insertions(+)
> >
> > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > index f19f179538b9..87c287433a52 100644
> > --- a/net/core/sock_reuseport.c
> > +++ b/net/core/sock_reuseport.c
> > @@ -11,6 +11,7 @@
> >  #include <linux/idr.h>
> >  #include <linux/filter.h>
> >  #include <linux/rcupdate.h>
> > +#include <net/tcp.h>
> >
> >  #define INIT_SOCKS 128
> >
> > @@ -85,6 +86,15 @@ int reuseport_alloc(struct sock *sk, bool bind_inany=
)
> >         reuse->socks[0] =3D sk;
> >         reuse->num_socks =3D 1;
> >         reuse->bind_inany =3D bind_inany;
> > +
> > +       /* synq_overflow_ts can be used for syncookies. Ensure that it =
has a
> > +        * recent value, so that tcp_synq_overflow() and
> > +        * tcp_synq_no_recent_overflow() can safely use time_after32().
> > +        * Initialise it 'TCP_SYNCOOKIE_VALID + 1' jiffies in the past,=
 to
> > +        * ensure that we start in the 'no recent overflow' case.
> > +        */
> > +       reuse->synq_overflow_ts =3D jiffies - TCP_SYNCOOKIE_VALID - 1;
> > +
> >         rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
> >
> >  out:
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 9b48aec29aca..e9555db95dff 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -443,6 +443,14 @@ void tcp_init_sock(struct sock *sk)
> >         tp->tsoffset =3D 0;
> >         tp->rack.reo_wnd_steps =3D 1;
> >
> > +       /* ts_recent_stamp can be used for syncookies. Ensure that it h=
as a
> > +        * recent value, so that tcp_synq_overflow() and
> > +        * tcp_synq_no_recent_overflow() can safely use time_after32().
> > +        * Initialise it 'TCP_SYNCOOKIE_VALID + 1' jiffies in the past,=
 to
> > +        * ensure that we start in the 'no recent overflow' case.
> > +        */
> > +       tp->rx_opt.ts_recent_stamp =3D jiffies - TCP_SYNCOOKIE_VALID - =
1;
> > +
> >         sk->sk_state =3D TCP_CLOSE;
> >
> >         sk->sk_write_space =3D sk_stream_write_space;
> > --
> > 2.21.0
> >
>=20
> A listener could be live for one year, and flip its ' I am under
> synflood' status every 24 days (assuming HZ=3D1000)
>=20
> You only made sure the first 24 days are ok, but the problem is still the=
re.
>=20
> We need to refresh the values, maybe in tcp_synq_no_recent_overflow()
>=20
Indeed. I'll work on that.

> (Note the issue has been there forever on 32bit arches)
>=20
Yes, I'll also update the Fixes tag.

Thanks.

