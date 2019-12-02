Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3C610F265
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 22:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfLBVvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 16:51:51 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46102 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725825AbfLBVvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 16:51:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575323509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hNBVvnbsWzl7TeXzm2tfjYFK60s+I+Pb1D691eYPKeE=;
        b=jEFnhp7iKVser+copbidgqsIfOTes0bY6L/T9XqbtrxJOGHmtMD3QlaLT5NOckUQpufTxC
        aN4ADADaWsFPDBYtWVmOeTS8yk5g0Az+LB+lHlATu0onnhBVtTDN1W6DmOPpn8cU1BVoNb
        +InYT7MIpIM3a8sVgOCfWPQzzLaVvQE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-55LArwD1P0KaeW94Rx6TVw-1; Mon, 02 Dec 2019 16:51:48 -0500
Received: by mail-wr1-f72.google.com with SMTP id u12so609432wrt.15
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 13:51:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GZnsTsLw3ktlt9omMT9r23InEErgCgU3vhg64whzkNQ=;
        b=YFkk/WXLw4beQPcIfINHCtNh6ddzE7fixKFUxkwmBJhhDZw/x+AoW+y2rISmDihbcx
         KDskxkN51epT3gSvkGLxVCCP5Aka0IA1s0z4J8u4s08QOwLPkkavhCL6rJXssg90teZG
         gScbMJADaP+oKBIZ22nhRm3p2+jSWmVEwU9TDUjA4F9g+iehzTw9sWViUatJBgVJ+8BA
         GJgcg3S/qTOMtlwrJhPEODbaAD80RoHhkg7XAF1yQcA8ABbJH2Dxa6uMhAHgcl6+7Zti
         5EvopnOLJaZ96n4hpxwjNoB7sbX/qm+C5Arom1QhAJNxD25UcWYiIaXuQtmDH1cyE0aE
         ROSQ==
X-Gm-Message-State: APjAAAVWKGM8QR3N+asq3rF8s7EDqyX4w3PSWra9pNVYS7lp0jXIf+Xq
        9PyMr8rKG9kbyd/nBqkNzpc7WUPuvZjEJyQaOILi91wwAOtH3MkZ5YjC1kxq2XOhSKTvc1a0d7R
        Q4PHMisFzwnxkcdrK
X-Received: by 2002:a1c:20d6:: with SMTP id g205mr74030wmg.38.1575323506358;
        Mon, 02 Dec 2019 13:51:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqxWr5HBjQ3WZ4VYMCvino9RbeZnjT6N94sYfzhEkm5XFl77Xr78/6ZnrtGdFy91TDVzREII7w==
X-Received: by 2002:a1c:20d6:: with SMTP id g205mr74006wmg.38.1575323506086;
        Mon, 02 Dec 2019 13:51:46 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id f1sm475860wml.11.2019.12.02.13.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 13:51:45 -0800 (PST)
Date:   Mon, 2 Dec 2019 22:51:43 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net] tcp: Avoid time_after32() underflow when handling
 syncookies
Message-ID: <20191202215143.GA13231@linux.home>
References: <2601e43617d707a28f60f2fe6927b1aaaa0a37f8.1574976866.git.gnault@redhat.com>
 <CANn89i+G0jCU=JtSit3X9w+SaExgbbo-d1x4UEkTEJRdypN3gQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANn89i+G0jCU=JtSit3X9w+SaExgbbo-d1x4UEkTEJRdypN3gQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: 55LArwD1P0KaeW94Rx6TVw-1
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
>=20
> A listener could be live for one year, and flip its ' I am under
> synflood' status every 24 days (assuming HZ=3D1000)
>=20
> You only made sure the first 24 days are ok, but the problem is still the=
re.
>=20
> We need to refresh the values, maybe in tcp_synq_no_recent_overflow()
>
Yes, but can't we refresh it in tcp_synq_overflow() instead? We
basically always want to update the timestamp, unless it's already in
the [last_overflow, last_overflow + HZ] interval:

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 36f195fb576a..1a3d76dafba8 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -494,14 +494,16 @@ static inline void tcp_synq_overflow(const struct soc=
k *sk)
 =09=09reuse =3D rcu_dereference(sk->sk_reuseport_cb);
 =09=09if (likely(reuse)) {
 =09=09=09last_overflow =3D READ_ONCE(reuse->synq_overflow_ts);
-=09=09=09if (time_after32(now, last_overflow + HZ))
+=09=09=09if (time_before32(now, last_overflow) ||
+=09=09=09    time_after32(now, last_overflow + HZ))
 =09=09=09=09WRITE_ONCE(reuse->synq_overflow_ts, now);
 =09=09=09return;
 =09=09}
 =09}
=20
 =09last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
-=09if (time_after32(now, last_overflow + HZ))
+=09if (time_before32(now, last_overflow) ||
+=09    time_after32(now, last_overflow + HZ))
 =09=09tcp_sk(sk)->rx_opt.ts_recent_stamp =3D now;
 }
=20
This way, tcp_synq_no_recent_overflow() should always have a recent
timestamp to work on, unless tcp_synq_overflow() wasn't called. But I
can't see this case happening for a legitimate connection (unless I've
missed something of course).

One could send an ACK without a SYN and get into this situation, but
then the timestamp value doesn't have too much importance since we have
to drop the connection anyway. So, even though an expired timestamp
could let the packet pass the tcp_synq_no_recent_overflow() test, the
syncookie validation would fail. So the packet is correctly rejected in
any case.

