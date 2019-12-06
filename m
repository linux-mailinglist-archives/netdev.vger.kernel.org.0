Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33FC0114FDD
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfLFLi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:38:57 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57361 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726171AbfLFLi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:38:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575632335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tY7o2zRaLDdpA4vAKZ7e5jBajVfXCSEZq6iufwzyH30=;
        b=XoVxAZcPsIcerDMkrc8J8QGdQK+ODw2yiqWH9/6CqReAO2DMnP51nWKbW1nV703sbSNOKr
        g96FGN0/wsCA4FUo9hYqvIzU5EAx3vOhUZWZJdMrx+EV/n8vqnQwM26YUQ2GUC/e8/gZUV
        HnoNm4iwytpEZ4256eQHL3iUkSySYic=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-HiKT9ol1PqOVJH79c-ZYgg-1; Fri, 06 Dec 2019 06:38:52 -0500
Received: by mail-wr1-f71.google.com with SMTP id h30so3025008wrh.5
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 03:38:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x9QJXz1eFyCbNesxwawQwP3W7HmnIX9hRDa/Qw0/8ik=;
        b=GkgFOItGi2nBzZFQBmG8R6AT8IAKF5p4VZPkuRsJhZ9Mi2sjLY4q5Y2RU8V4owEb/6
         Bqf630xgwINt9lCGHeNrIdqEemzlw2GFtfJIJ+il+dmQyI15TICBpx8J4R6B471vFSWP
         u9ZJFeMQT34Z/xLbSjTlj24HyxU7FEkluIOSViQ3MWmIFx6H90MLnUkMP8zwWiCEBddJ
         AgiUfMPbDHcYvNL1kUIsZMYDoQh6nb61Q4Fxk1cXnj8r/ClhqZdl7qjM0xYL8F89BSbh
         VMixUIdrAxippgZQABohL2mXib3hQ/pUrB8iivz74xRx9fEEBttyWZAKaOKAzU28Fxhb
         eZcA==
X-Gm-Message-State: APjAAAU+gm3zRLMiZovNGGYBZYwIv2tc6QhkId60/u8WK9ClIAC4lUKQ
        UcnfaSGtaoP//rYUZsw/PPgVIRBPYIot74/4krVF/rgQPlkSVa78TjyEA4ZeGX0np4KAly/JUmW
        SyGQYKmGDkxurVNGD
X-Received: by 2002:a05:6000:1241:: with SMTP id j1mr16269977wrx.26.1575632331432;
        Fri, 06 Dec 2019 03:38:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqzh3wzMqs6opxYAuColhg7aHQd/jk6NiNVkcCbyPzDkGF1b04sy5drwtceK6XVaul8Be92z8w==
X-Received: by 2002:a05:6000:1241:: with SMTP id j1mr16269962wrx.26.1575632331242;
        Fri, 06 Dec 2019 03:38:51 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id i5sm5695128wrv.34.2019.12.06.03.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 03:38:50 -0800 (PST)
Date:   Fri, 6 Dec 2019 12:38:49 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH net v4 3/3] tcp: Protect accesses to .ts_recent_stamp with
 {READ,WRITE}_ONCE()
Message-ID: <e2c6d0dc551e4663480105a2bb492385e8fa003a.1575631229.git.gnault@redhat.com>
References: <cover.1575631229.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1575631229.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: HiKT9ol1PqOVJH79c-ZYgg-1
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

Use of .rx_opt.ts_recent_stamp for storing the synflood timestamp was
introduced by a0f82f64e269 ("syncookies: remove last_synq_overflow from
struct tcp_sock"). But unprotected accesses were already there when
timestamp was stored in .last_synq_overflow.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
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

