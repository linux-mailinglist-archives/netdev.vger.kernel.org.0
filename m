Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652EF114A9E
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 02:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfLFBuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 20:50:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23057 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725988AbfLFBuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 20:50:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575597002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0FBSczItuSjrlOGotGIo/4chAYDp5/BRuSUEi0TWjhg=;
        b=KbbwWlzJsIN0GZ7/EZjxwiosYRE7Ta+3Gb/KsL2dUM/eL6ZYc4ryNAPaYEaYKPImkKbhlw
        fMK6eP8QN6rXRv6lRsSOgUgVuMMbJ9O9rPHGEm9DvLgLS4KfJyV1DfD/hXFshFx0NmMH4u
        ZGkwiyTR3N40jzi8MxBTs6AW0fzbVR4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-uWuxhM1JONG2PaaWIvojqg-1; Thu, 05 Dec 2019 20:49:58 -0500
Received: by mail-wm1-f69.google.com with SMTP id n4so1384068wmd.7
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 17:49:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NEBB/jLmFEbrxXusuXUdRBJcZT8YgLS9olAe/O8O3LM=;
        b=BIb+IY4QDIqBM2xG9cjQPKTwobt9IS5P52vShmfc5SNrJ5WNG6u1G6hGOQEdVV9C0r
         BpNXNYso4QFiZfykIVEzq9VwvNSrikl0+uIYVolE1llGb9AnTnN0AUENO9gpsicbhMhh
         tHSDVCO1/EvNh3knMUfYq0ZCYxkeUuBmaLjwixFlKfn9Ob6XehfY7IL/Dqa+R7abCu1E
         LEk5JlHU8P3Df+iOelAqiwur85MdXv2QrICmrN6iONH11ArqOkR6a6b6Nmsvb7GKCjto
         3E65XGRkaY9L3jOU7ef4xPriKeE13zyNpyN2N9r1rMiS9IlzLjMuACiJL9dyStM1ubtC
         JQjw==
X-Gm-Message-State: APjAAAVVA1h8Pn1t9Q5rGAEOKEH0pxE2LpoIyEoYkMx5covS8zKYRq/n
        gqePWlFqXFMgFbj/+eQgLmIMUQ/lO3muuapzu0Fc66WBZXIcwPQ4yPNlD1otAQc0ttr+KwwpeGx
        OaFbOKt0UH9y8WI3q
X-Received: by 2002:a1c:740b:: with SMTP id p11mr5907271wmc.78.1575596997450;
        Thu, 05 Dec 2019 17:49:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqww/TQ/IWekNS1tK3+WLGw24LPgnjr29/CzRlKZkzFQGDsTygdYrb0PGCLi81kX2bkyqFC+6w==
X-Received: by 2002:a1c:740b:: with SMTP id p11mr5907260wmc.78.1575596997225;
        Thu, 05 Dec 2019 17:49:57 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id g23sm1765559wmk.14.2019.12.05.17.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 17:49:56 -0800 (PST)
Date:   Fri, 6 Dec 2019 02:49:55 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH net v3 2/3] tcp: tighten acceptance of ACKs not matching a
 child socket
Message-ID: <05f412281ffe11a603260c849851df39c0e8c952.1575595670.git.gnault@redhat.com>
References: <cover.1575595670.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1575595670.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: uWuxhM1JONG2PaaWIvojqg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When no synflood occurs, the synflood timestamp isn't updated.
Therefore it can be so old that time_after32() can consider it to be
in the future.

That's a problem for tcp_synq_no_recent_overflow() as it may report
that a recent overflow occurred while, in fact, it's just that jiffies
has grown past 'last_overflow' + TCP_SYNCOOKIE_VALID + 2^31.

Spurious detection of recent overflows lead to extra syncookie
verification in cookie_v[46]_check(). At that point, the verification
should fail and the packet dropped. But we should have dropped the
packet earlier as we didn't even send a syncookie.

Let's refine tcp_synq_no_recent_overflow() to report a recent overflow
only if jiffies is within the
[last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval. This
way, no spurious recent overflow is reported when jiffies wraps and
'last_overflow' becomes in the future from the point of view of
time_after32().

However, if jiffies wraps and enters the
[last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval (with
'last_overflow' being a stale synflood timestamp), then
tcp_synq_no_recent_overflow() still erroneously reports an
overflow. In such cases, we have to rely on syncookie verification
to drop the packet. We unfortunately have no way to differentiate
between a fresh and a stale syncookie timestamp.

In practice, using last_overflow as lower bound is problematic.
If the synflood timestamp is concurrently updated between the time
we read jiffies and the moment we store the timestamp in
'last_overflow', then 'now' becomes smaller than 'last_overflow' and
tcp_synq_no_recent_overflow() returns true, potentially dropping a
valid syncookie.

Reading jiffies after loading the timestamp could fix the problem,
but that'd require a memory barrier. Let's just accommodate for
potential timestamp growth instead and extend the interval using
'last_overflow - HZ' as lower bound.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/tcp.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 7d734ba391fc..43e04e14c41e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -518,13 +518,23 @@ static inline bool tcp_synq_no_recent_overflow(const =
struct sock *sk)
 =09=09reuse =3D rcu_dereference(sk->sk_reuseport_cb);
 =09=09if (likely(reuse)) {
 =09=09=09last_overflow =3D READ_ONCE(reuse->synq_overflow_ts);
-=09=09=09return time_after32(now, last_overflow +
-=09=09=09=09=09    TCP_SYNCOOKIE_VALID);
+=09=09=09return !time_between32(now, last_overflow - HZ,
+=09=09=09=09=09       last_overflow +
+=09=09=09=09=09       TCP_SYNCOOKIE_VALID);
 =09=09}
 =09}
=20
 =09last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
-=09return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID);
+
+=09/* If last_overflow <=3D jiffies <=3D last_overflow + TCP_SYNCOOKIE_VAL=
ID,
+=09 * then we're under synflood. However, we have to use
+=09 * 'last_overflow - HZ' as lower bound. That's because a concurrent
+=09 * tcp_synq_overflow() could update .ts_recent_stamp after we read
+=09 * jiffies but before we store .ts_recent_stamp into last_overflow,
+=09 * which could lead to rejecting a valid syncookie.
+=09 */
+=09return !time_between32(now, last_overflow - HZ,
+=09=09=09       last_overflow + TCP_SYNCOOKIE_VALID);
 }
=20
 static inline u32 tcp_cookie_time(void)
--=20
2.21.0

