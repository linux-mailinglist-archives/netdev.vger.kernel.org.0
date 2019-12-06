Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 320A2114A9F
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 02:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfLFBuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 20:50:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56974 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725988AbfLFBuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 20:50:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575597008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x1yLQFubkP51wDk7aBhauhhcs2CAnUyn5Rt31hm1/FU=;
        b=FxOI9WXdLZGB2F8fKeAL7Oyfrt7rhfmTVAnAeaeNmCuQCcoBaDyR6H2mEfAVupQe7hKRyT
        gx2D7Sl/fGHP4ezIPSszXY4GkAX2KFqXiKQg2ZRUbXbDtuPP8k/4AiWQUVWIDU/vuGoXEs
        +Bat0QqLdIrrACc8bzcupx2bnlMVDgc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-Zg9VudZSNoWM81FDAEJyZQ-1; Thu, 05 Dec 2019 20:50:05 -0500
Received: by mail-wr1-f71.google.com with SMTP id l20so2425458wrc.13
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 17:50:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gzKQUsnUwWY1eE5rB99ZCMGW3EnErOaFcBv7Q4utu2Y=;
        b=FhbUY6huKxcXmaC/RDWoec8DFHVSjDCiQihtObLIuB+wBwJjFX6yJ/BjRS1lvsBavA
         oWBFQtUZFRvMFWA5At3sYknwDKYJQ3frhJv0PjOzvWXgdN3Pb8/fHUrJAnRHtaqoUZic
         Beej3IxXWirDjtoh+N3p/N217ey+Sm4wlMIzDcJGG7J4+g6zXPTzTxla9Wk80thj/Zic
         e0Lc6zqNZXyV4+2uohNOTYQqYti2ppaVACUmCjA5KgKuUjCi4PxR8Gdcr511Wh8BBiTI
         vj0XPEYlG+VCD7xkOfnmhSlwWXLeR9CFtuAkobRMapYUgDadBGzhhXowMIMSmdnG7co/
         OA0w==
X-Gm-Message-State: APjAAAVCLmh8hbe/tme1JpcCWYh0Hq5AuFHj0XFwVanpUmI8fP6lYQPg
        +zkcJ8weXK6gT590x/h79VASzetNNU9rbagt6GcxpR9THsq6456zVH2+D7V/q4b8kuNAw4Fk457
        kGTtB3iRx8EFD47+Z
X-Received: by 2002:adf:f091:: with SMTP id n17mr13135616wro.387.1575597003919;
        Thu, 05 Dec 2019 17:50:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqy29jIA/eyu7Wms1DZPbbkD54LU3PLxjAaeCox9vWeVWKT5W+Ojjnuq+gxsXOW7L/at5BQ/Tg==
X-Received: by 2002:adf:f091:: with SMTP id n17mr13135607wro.387.1575597003759;
        Thu, 05 Dec 2019 17:50:03 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id t12sm14553311wrs.96.2019.12.05.17.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 17:50:03 -0800 (PST)
Date:   Fri, 6 Dec 2019 02:50:01 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH net v3 3/3] tcp: Protect accesses to .ts_recent_stamp with
 {READ,WRITE}_ONCE()
Message-ID: <6473f122f953f6b0bf350ace584a721d0ae02ef6.1575595670.git.gnault@redhat.com>
References: <cover.1575595670.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1575595670.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: Zg9VudZSNoWM81FDAEJyZQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syncookies borrow the ->rx_opt.ts_recent_stamp field to store the
timestamp of the last synflood. Protect them with READ_ONCE() and
WRITE_ONCE() since reads and writes aren't serialised.

Fixes: 264ea103a747 ("tcp: syncookies: extend validity range")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/tcp.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 43e04e14c41e..86b9a8766648 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -501,9 +501,9 @@ static inline void tcp_synq_overflow(const struct sock =
*sk)
 =09=09}
 =09}
=20
-=09last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
+=09last_overflow =3D READ_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp);
 =09if (!time_between32(now, last_overflow, last_overflow + HZ))
-=09=09tcp_sk(sk)->rx_opt.ts_recent_stamp =3D now;
+=09=09WRITE_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp, now);
 }
=20
 /* syncookies: no recent synqueue overflow on this listening socket? */
@@ -524,7 +524,7 @@ static inline bool tcp_synq_no_recent_overflow(const st=
ruct sock *sk)
 =09=09}
 =09}
=20
-=09last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
+=09last_overflow =3D READ_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp);
=20
 =09/* If last_overflow <=3D jiffies <=3D last_overflow + TCP_SYNCOOKIE_VAL=
ID,
 =09 * then we're under synflood. However, we have to use
--=20
2.21.0

