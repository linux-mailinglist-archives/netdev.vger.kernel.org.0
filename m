Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38700113911
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbfLEA7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:59:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38265 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728121AbfLEA7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:59:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575507582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=42vaFK9hakFikyE0ugAAVt54eA/vHlq63a1MeAFMyUA=;
        b=PZRi3Sa3YBXmMtivrciwaKhfElFg6Hpj84hFZpIBfDX+qtdjH0tiglkgiP/83FCE+p09kP
        dTMN41KDCreUOM6ytRxzviaKqiyDEGJHNfN2bIez0feJNeNwt3253XHBVSvn+LFZyePQQC
        HNRp2amEfwoFju2Pa0UCVOn3hH+fJRc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-LpMF700VMRekX7Qmn1vJbg-1; Wed, 04 Dec 2019 19:59:10 -0500
Received: by mail-wr1-f72.google.com with SMTP id 92so729821wro.14
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 16:59:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AwqOueEO3Fx26tu1B+f8t+WJLb97nLwuNPK0jgaX+yo=;
        b=smV5WRCkZLlAfOiuvAQVQGcj5GzkZa01iXGgECGYRoySUaWd0hZDCeGK8kTOY+fUT7
         jpS7Vp/WMsLyi5eP6xId0A5z2vsGyhLhi04FmIFAQ0NDH4q5gFQTI5M2LJLCBVtENh5w
         97hjVCfyc5LAeyBOwOYaC9jZpoMEz2PlLZCwV+wxocPMtcq+HA9Sqr98whfxdKrq39fv
         uCfK9H1bPRntY3vnODOcWWPY/IAAI4H/EZ9sZxOLBVN/o7Xpzvt7ew4csqx9CXm3UFEu
         XGC9U8gH51eddwldRkPrCS71IlI4d9VGV5FZ4ct+WFnrq86B4m5UanR5ThXRAtI849vl
         OAjQ==
X-Gm-Message-State: APjAAAVPu9PWveLECKPO6PtCQw7KFAOT1TRpc1P5JDFcIct/co9Um3jB
        Z7e2u/n+BcV9mD6p+rA1KI2Z2Oc/G6buq5hqdbm0XihsgSEqovnoDO/zcaaDaEE9EJi95Nx/ziB
        zw1c5bIIlNUIXbNsd
X-Received: by 2002:a7b:c4cc:: with SMTP id g12mr2356164wmk.68.1575507548824;
        Wed, 04 Dec 2019 16:59:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqwyAmYHbalY/r2FB/3JTBB8mrlMystYTsc6mEC0Wmhu/h9TzRcytCVhpHRdWjxWcb0BoJuUAw==
X-Received: by 2002:a7b:c4cc:: with SMTP id g12mr2356151wmk.68.1575507548558;
        Wed, 04 Dec 2019 16:59:08 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id h124sm9153864wme.30.2019.12.04.16.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 16:59:08 -0800 (PST)
Date:   Thu, 5 Dec 2019 01:59:06 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net v2 1/2] tcp: fix rejected syncookies due to stale
 timestamps
Message-ID: <c73c4f3f6a1793775b9ed2f67752b3386cbaa61b.1575503545.git.gnault@redhat.com>
References: <cover.1575503545.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1575503545.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: LpMF700VMRekX7Qmn1vJbg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If no synflood happens for a long enough period of time, then the
synflood timestamp isn't refreshed and jiffies can advance so much
that time_after32() can't accurately compare them any more.

Therefore, we can end up in a situation where time_after32(now,
last_overflow + HZ) returns false, just because these two values are
too far apart. In that case, the synflood timestamp isn't updated as
it should be, which can trick tcp_synq_no_recent_overflow() into
rejecting valid syncookies.

For example, let's consider the following scenario on a system
with HZ=3D1000:

  * The synflood timestamp is 0, either because that's the timestamp
    of the last synflood or, more commonly, because we're working with
    a freshly created socket.

  * We receive a new SYN, which triggers synflood protection. Let's say
    that this happens when jiffies =3D=3D 2147484649 (that is,
    'synflood timestamp' + HZ + 2^31 + 1).

  * Then tcp_synq_overflow() doesn't update the synflood timestamp,
    because time_after32(2147484649, 1000) returns false.
    With:
      - 2147484649: the value of jiffies, aka. 'now'.
      - 1000: the value of 'last_overflow' + HZ.

  * A bit later, we receive the ACK completing the 3WHS. But
    cookie_v[46]_check() rejects it because tcp_synq_no_recent_overflow()
    says that we're not under synflood. That's because
    time_after32(2147484649, 120000) returns false.
    With:
      - 2147484649: the value of jiffies, aka. 'now'.
      - 120000: the value of 'last_overflow' + TCP_SYNCOOKIE_VALID.

    Of course, in reality jiffies would have increased a bit, but this
    condition will last for the next 119 seconds, which is far enough
    to accommodate for jiffie's growth.

Fix this by updating the overflow timestamp whenever jiffies isn't
within the [last_overflow, last_overflow + HZ] range. That shouldn't
have any performance impact: only stale timestamps would trigger the
time_before32() case, and that can only happen for the first SYN of a
flood.

Now we're guaranteed to have fresh timestamps while under synflood, so
tcp_synq_no_recent_overflow() can safely use it with time_after32() in
such situations.

Stale timestamps can still make tcp_synq_no_recent_overflow() return
the wrong verdict when not under synflood. This will be handled in the
next patch.

For 64 bits architectures, the problem was introduced with the
conversion of ->tw_ts_recent_stamp to 32 bits integer by commit
cca9bab1b72c ("tcp: use monotonic timestamps for PAWS").
The problem has always been there on 32 bits architectures.

Fixes: cca9bab1b72c ("tcp: use monotonic timestamps for PAWS")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/tcp.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 36f195fb576a..f0eae83ee555 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -494,14 +494,16 @@ static inline void tcp_synq_overflow(const struct soc=
k *sk)
 =09=09reuse =3D rcu_dereference(sk->sk_reuseport_cb);
 =09=09if (likely(reuse)) {
 =09=09=09last_overflow =3D READ_ONCE(reuse->synq_overflow_ts);
-=09=09=09if (time_after32(now, last_overflow + HZ))
+=09=09=09if (time_after32(now, last_overflow + HZ) ||
+=09=09=09    time_before32(now, last_overflow))
 =09=09=09=09WRITE_ONCE(reuse->synq_overflow_ts, now);
 =09=09=09return;
 =09=09}
 =09}
=20
 =09last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
-=09if (time_after32(now, last_overflow + HZ))
+=09if (time_after32(now, last_overflow + HZ) ||
+=09    time_before32(now, last_overflow))
 =09=09tcp_sk(sk)->rx_opt.ts_recent_stamp =3D now;
 }
=20
--=20
2.21.0

