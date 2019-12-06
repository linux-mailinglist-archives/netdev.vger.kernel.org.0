Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95FB4114FDC
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfLFLiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:38:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40886 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726222AbfLFLiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:38:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575632329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hir+pLOvK4paX89GrZMjs9etd8diyUTYX9II+W/2slA=;
        b=O9nY+0Cb5V8AWPFukfnsxfDPYRdTTIxsgGFQfOTRJw7jAaq8i0539W++7/+RAiG8tSga25
        n86V74j2kelmxKgICG7WMNu0yZag6wNV53TpGCLq5nejU6h0xylD3OpQLP7OnPGgFUva/7
        O9UzS90pFlP8XZju/5l/aNQp2LG8xng=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-rcrLc7FOM0OZ9GJeaiv_vA-1; Fri, 06 Dec 2019 06:38:46 -0500
Received: by mail-wm1-f71.google.com with SMTP id g78so1741623wme.8
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 03:38:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4fAnz33Q7d7wH8d4bHTP5BowVCHfkvl1pyxp27OWfns=;
        b=sAXDlbHArKR/4rNEBGpUqk6xD9q/LkkYL3cop5veGb1ZAdEL9RNZuYHZ8FfIVYJO3V
         rZmyaoERbdwpwFUhFVS1ypdSidXU22wu0oG49GZnoqPlu5RZe7m7ZvLFHXnJm76abqVl
         UJIsFFPgRpTBKM8QPpJ8QlFMkJdk6mAJ5A43afS1jeoPp1tnkS0FyLWk5OuUaZfayBt2
         piVTPEY9LbnFggjaoHqUii4aczCRad+WKfe/qagOn+Qc++yES0DlBdx8oD89CYw334Rh
         QYqFSk57VczVooDtjuN3zRdZQmWaJpj56d/opbYSHaRNF10DWzU5jnL4JERjI1todpWM
         r4CA==
X-Gm-Message-State: APjAAAXkTctKTnT8WjirCiYuSdR1vAtWhPRZ0vegq+fzP62lPSxH9Cda
        tS5p+kBYdfj3/Xd4wft+gm4334TvXreDrW7czdWDo8G1Gsjo2DJLu/xCaYJwsCWmS7FJYCO0ALx
        OXEsh2VWCK8/wcUMX
X-Received: by 2002:a1c:f70d:: with SMTP id v13mr9863594wmh.45.1575632325419;
        Fri, 06 Dec 2019 03:38:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqxeobqoPA1Bcu/yft3JSjFXyFBTiLMGDfOGpx5aun7s+vCcG1OJDDxuGgk3fSZVnZeGW/HwcQ==
X-Received: by 2002:a1c:f70d:: with SMTP id v13mr9863571wmh.45.1575632325199;
        Fri, 06 Dec 2019 03:38:45 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id l6sm3055254wme.42.2019.12.06.03.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 03:38:44 -0800 (PST)
Date:   Fri, 6 Dec 2019 12:38:43 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH net v4 2/3] tcp: tighten acceptance of ACKs not matching a
 child socket
Message-ID: <43ac1314b69a661a82301deadb22e557859b3e59.1575631229.git.gnault@redhat.com>
References: <cover.1575631229.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1575631229.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: rcrLc7FOM0OZ9GJeaiv_vA-1
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

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
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

