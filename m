Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33EEB11390D
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbfLEA7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:59:20 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34381 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728121AbfLEA7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:59:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575507558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6jOa7b4MRvQXzeb5KwYeOlCCtHmyHe5oav0++IT92Eg=;
        b=IgQwuqvL25YOCxrK/oqaDVWDO/J/lYJFiAb7FBMGvZ7hddWnpTK4SwKXw6BgOVwKBZ3kEa
        N/B5D0H+mcmuhpQh9R40U2Oh+NMePM9abbnkjoPViJJB+T9GLQLpjlYg95/ts5UM1E3b4H
        fuLZYLMXnwiZ+UxucX6imEfJPZHd9JI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-f2KTGuNxPkyfJ-7pX7a71A-1; Wed, 04 Dec 2019 19:59:16 -0500
Received: by mail-wm1-f72.google.com with SMTP id g26so392680wmk.6
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 16:59:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=s61j4IF26WJnUf+egd9vbJSP5ZE7pyZkX6BU5W9oifM=;
        b=NpF6kKYmlQAyejh2pjxDJ2fK5rEjBzZBFBAnS/wgSsYcOzqaYIdrSTcnZ5hSGVJuqt
         jvFm5ByaCf3E9P7c3H4L7d0JqB8sTVpAD9tOulqIPeLoVGAjGzZ0OrTAO6K7kMuTmVJR
         NsFEpwuCiarAO1iBHaBey+ni/efJLJkmO2/34SWmqfozJ07seR7bhpoKBQ765nf3x+YA
         oHLGoRS05NGHDpzcpRTMdRykGYzpYfvz1AnCeLe/JLGD2/DxcsOULuR6oVxPpdP4IyGn
         UYgJztofSbmPNN3O9O+3Ae3jqQCUAKJCqvTahEFo/7NL+CNJU74h/V5kLoUQZpQ1n4KZ
         AJNg==
X-Gm-Message-State: APjAAAXVdx9TRLVrO12qEbNidPUuJFd4lnQegwAqUAl5DReIZVxDfX7M
        uSpG96lWL0ofYfYlkdTptXvTSPPCVUXdoXVT5hE7Xcl/elmDoRUpO5+RpdMyVxrvdYrXIC0AC83
        qec3V5ZFvS2MhsEr/
X-Received: by 2002:a5d:6305:: with SMTP id i5mr7108583wru.119.1575507555799;
        Wed, 04 Dec 2019 16:59:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqxeJa8E9bNeEVOUXhLrT6+YJJBsDmEVHzoofntcqFc5Fc5TGXZU4n7nBnk2k8gXpysx0XOxZQ==
X-Received: by 2002:a5d:6305:: with SMTP id i5mr7108575wru.119.1575507555610;
        Wed, 04 Dec 2019 16:59:15 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id l3sm10284190wrt.29.2019.12.04.16.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 16:59:15 -0800 (PST)
Date:   Thu, 5 Dec 2019 01:59:13 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH net v2 2/2] tcp: tighten acceptance of ACKs not matching a
 child socket
Message-ID: <1d7e9bc77fb68706d955e4089a801ace0df5d771.1575503545.git.gnault@redhat.com>
References: <cover.1575503545.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1575503545.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: f2KTGuNxPkyfJ-7pX7a71A-1
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

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/tcp.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index f0eae83ee555..005d4c691543 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -520,12 +520,14 @@ static inline bool tcp_synq_no_recent_overflow(const =
struct sock *sk)
 =09=09if (likely(reuse)) {
 =09=09=09last_overflow =3D READ_ONCE(reuse->synq_overflow_ts);
 =09=09=09return time_after32(now, last_overflow +
-=09=09=09=09=09    TCP_SYNCOOKIE_VALID);
+=09=09=09=09=09    TCP_SYNCOOKIE_VALID) ||
+=09=09=09=09time_before32(now, last_overflow);
 =09=09}
 =09}
=20
 =09last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
-=09return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID);
+=09return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID) ||
+=09=09time_before32(now, last_overflow);
 }
=20
 static inline u32 tcp_cookie_time(void)
--=20
2.21.0

