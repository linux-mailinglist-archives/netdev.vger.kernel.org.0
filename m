Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B7110CF8C
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 22:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfK1VgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 16:36:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26849 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726569AbfK1VgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 16:36:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574976981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=S+Lju4olP79XqyLXDLRwjLyTWHHBZf60OqheQUTxl2Q=;
        b=ZHGhXbynNiQXNY+aVU3VMOZ/TRpqAY9yNEiWS0oB0INB5kF0nWaV6HFbVMxgFQxw22haZ6
        bgP+WgRJWkVJoMVAiWpQEsxULCc5GES/drDdbtIGW9mZdc/qGGsswrxy7JdAg9JfPIGb3E
        KBrhg0uaZQwtTI0YrPu8KCb29IqdOG4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-zM9Ai7iqNU-cpkYIbTngUg-1; Thu, 28 Nov 2019 16:36:18 -0500
Received: by mail-wr1-f70.google.com with SMTP id o6so1980125wrp.8
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 13:36:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=a6tAnTqutQArJr2jWMBDWC8zdFz4+GqLKQFEsuS7meM=;
        b=Te6ILCmdrrQKazYFKWZEjuMWqJsi6RpK9We16wSS7R4ifQf0WN7q2XsJbRO/7AwU1l
         F60n7DhqLR8Lht/sMvUwjOhpEZiLMtB+GEAkWu7eJvJn5tMdb4ESz5wZD7drAaBYfREL
         nAbLJvxy7ewEzznPfkRPdpaYVO2jIxjSRU280IdIpYXHElAc2MknsUpWCsNXw6NbO7+v
         /4MzJBe66zCgnXUNbW51sThnLkYsC1CTS295y1Bxb9nXDQ5ffFTOLzzDmfKwKROfd7Xw
         Rnk60SSNyMm4a3T2hBuu+FcfhdKz7p4Sqs68H/Zh/+OL7bBTMQJAGvuvGGw/yHV+GBEB
         xaYg==
X-Gm-Message-State: APjAAAWo3VEs/bfh9wWCvj9tVWqRJ5A+A9gXE6lqR5mPQbzQ4ZMm468b
        +8RBNljPVF089TMnSY14Zb7+4cVEpnCDOMJBphewlrAeuyeF9A+ZXxfGCCOf0RMaztiHpWZQ/Yy
        FyO+I2H/k9ywe/X0x
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr49885563wrt.229.1574976976879;
        Thu, 28 Nov 2019 13:36:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqzUheY1R0iheQ3bhJrPMIh7ts0AhRba3oGnT/kHC0czSoWwfAfmu/0Vk4Lj7vCNC5GBLesm5A==
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr49885531wrt.229.1574976976469;
        Thu, 28 Nov 2019 13:36:16 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id c9sm11233782wmb.42.2019.11.28.13.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 13:36:15 -0800 (PST)
Date:   Thu, 28 Nov 2019 22:36:13 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net] tcp: Avoid time_after32() underflow when handling
 syncookies
Message-ID: <2601e43617d707a28f60f2fe6927b1aaaa0a37f8.1574976866.git.gnault@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: zM9Ai7iqNU-cpkYIbTngUg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tcp_synq_overflow() and tcp_synq_no_recent_overflow(), the
time_after32() call might underflow and return the opposite of the
expected result.

This happens after socket initialisation, when ->synq_overflow_ts and
->rx_opt.ts_recent_stamp are still set to zero. In this case, they
can't be compared reliably to the current value of jiffies using
time_after32(), because jiffies may be too far apart (especially soon
after system startup, when it's close to 2^32).

In such a situation, the erroneous time_after32() result prevents
tcp_synq_overflow() from updating ->synq_overflow_ts and
->rx_opt.ts_recent_stamp, so the problem remains until jiffies wraps
and exceeds HZ.

Practical consequences should be quite limited though, because the
time_after32() call of tcp_synq_no_recent_overflow() would also
underflow (unless jiffies wrapped since the first time_after32() call),
thus detecting a socket overflow and triggering the syncookie
verification anyway.

Also, since commit 399040847084 ("bpf: add helper to check for a valid
SYN cookie") and commit 70d66244317e ("bpf: add bpf_tcp_gen_syncookie
helper"), tcp_synq_overflow() and tcp_synq_no_recent_overflow() can be
triggered from BPF programs. Even though such programs would normally
pair these two operations, so both underflows would compensate each
other as described above, we'd better avoid exposing the problem
outside of the kernel networking stack.

Let's fix it by initialising ->rx_opt.ts_recent_stamp and
->synq_overflow_ts to a value that can be safely compared to jiffies
using time_after32(). Use "jiffies - TCP_SYNCOOKIE_VALID - 1", to
indicate that we're not in a socket overflow phase.

Fixes: cca9bab1b72c ("tcp: use monotonic timestamps for PAWS")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/core/sock_reuseport.c | 10 ++++++++++
 net/ipv4/tcp.c            |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index f19f179538b9..87c287433a52 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -11,6 +11,7 @@
 #include <linux/idr.h>
 #include <linux/filter.h>
 #include <linux/rcupdate.h>
+#include <net/tcp.h>
=20
 #define INIT_SOCKS 128
=20
@@ -85,6 +86,15 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
 =09reuse->socks[0] =3D sk;
 =09reuse->num_socks =3D 1;
 =09reuse->bind_inany =3D bind_inany;
+
+=09/* synq_overflow_ts can be used for syncookies. Ensure that it has a
+=09 * recent value, so that tcp_synq_overflow() and
+=09 * tcp_synq_no_recent_overflow() can safely use time_after32().
+=09 * Initialise it 'TCP_SYNCOOKIE_VALID + 1' jiffies in the past, to
+=09 * ensure that we start in the 'no recent overflow' case.
+=09 */
+=09reuse->synq_overflow_ts =3D jiffies - TCP_SYNCOOKIE_VALID - 1;
+
 =09rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
=20
 out:
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9b48aec29aca..e9555db95dff 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -443,6 +443,14 @@ void tcp_init_sock(struct sock *sk)
 =09tp->tsoffset =3D 0;
 =09tp->rack.reo_wnd_steps =3D 1;
=20
+=09/* ts_recent_stamp can be used for syncookies. Ensure that it has a
+=09 * recent value, so that tcp_synq_overflow() and
+=09 * tcp_synq_no_recent_overflow() can safely use time_after32().
+=09 * Initialise it 'TCP_SYNCOOKIE_VALID + 1' jiffies in the past, to
+=09 * ensure that we start in the 'no recent overflow' case.
+=09 */
+=09tp->rx_opt.ts_recent_stamp =3D jiffies - TCP_SYNCOOKIE_VALID - 1;
+
 =09sk->sk_state =3D TCP_CLOSE;
=20
 =09sk->sk_write_space =3D sk_stream_write_space;
--=20
2.21.0

