Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBA818AA9D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 03:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgCSCVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 22:21:09 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:47330 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSCVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 22:21:09 -0400
Received: by mail-pf1-f201.google.com with SMTP id h191so498545pfe.14
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 19:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=tywxntjZmbNn1Grj4pFGKT1xEOgToCmUpJEP8Jw3VnA=;
        b=o5eQqyOZB+xXI/Y+ruUQr0YdPLvdZePLM/wrTU3D7mUoSEQmhrwxA+4eVY456yLxq6
         dMMsK/pxdCd2WJ+mxzSjvAx86k0qGu3r8l4wfxXFYj34BMZhd+R/UBbv9kHLFofS1jy7
         IYhkoWjYoVHLuz2qlVgmYvEcXR/9eM3Z59QPOPkQwuK1OfAXGf0BW1kc6tnxqxh622Sg
         N0P50p9ipBh3jmNDx3onK+U5QOsACx0BMmEAAdfDWod2b+dS9qsxPcgqykj91FEOaXcD
         xlHYkuZhI+CTm1PYiC1/foOo88SrPCVDNxBe0N7zaVrkvwigv/gJDD887ANmd3b41cAD
         pjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=tywxntjZmbNn1Grj4pFGKT1xEOgToCmUpJEP8Jw3VnA=;
        b=NzWVkL02HNkcfm+bAnS5ke0LqaIzXx1ZB8m3S2FC356tTGY2YAbbXWKWs3jXogo6DV
         MQ8hFUJDqVYEXggUaTObvDK8TKM9UtOYowOf4uHMJHKYyL9QqSHJUi+j3ULQ6Cx36AbH
         2J61oUlc2mJEOcGX3n/BQlGK3uYPHeOuKP7AlUBYV4oGDJ4UHKW9AulJw2Bvt8WgxN+5
         WGl5ZWC5rYDT6WNNQdIjq9CsaaMalAJPPSSS+sBihDdc2G+VT+9bieW8dG7pNMB4aNjX
         jKw/iXa0CDAbs6jS5AR8Oglh+zihHxdCrURZw3PrQelhfkusspS70n5rSz12X7ZxTKA5
         NWEw==
X-Gm-Message-State: ANhLgQ15OjPGcFaC2u0p47Uvel4bVesKg7OoMfkdEEaErgroO9q6hYYo
        Wll7jO8n0HyRQ6whYEyPIlUIGEF7B/DZMA==
X-Google-Smtp-Source: ADFU+vsp6rNE77hePzq1SbSTm5WAhqMlLiWPQBMGD7dKcInaQMrHGxloZqMvhfBQVN1EDHm1r5di8O9T05aZHw==
X-Received: by 2002:a17:90a:7f95:: with SMTP id m21mr1307260pjl.168.1584584466428;
 Wed, 18 Mar 2020 19:21:06 -0700 (PDT)
Date:   Wed, 18 Mar 2020 19:21:02 -0700
Message-Id: <20200319022102.188776-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net] tcp: repair: fix TCP_QUEUE_SEQ implementation
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When application uses TCP_QUEUE_SEQ socket option to
change tp->rcv_next, we must also update tp->copied_seq.

Otherwise, stuff relying on tcp_inq() being precise can
eventually be confused.

For example, tcp_zerocopy_receive() might crash because
it does not expect tcp_recv_skb() to return NULL.

We could add tests in various places to fix the issue,
or simply make sure tcp_inq() wont return a random value,
and leave fast path as it is.

Note that this fixes ioctl(fd, SIOCINQ, &val) at the same
time.

Fixes: ee9952831cfd ("tcp: Initial repair mode")
Fixes: 05255b823a61 ("tcp: add TCP_ZEROCOPY_RECEIVE support for zerocopy receive")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/tcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index eb2d80519f8e5ad165ca3b8acef2b10bdf8b7345..dc77c303e6f7f69b24170010b6a295d179342676 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2948,8 +2948,10 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 			err = -EPERM;
 		else if (tp->repair_queue == TCP_SEND_QUEUE)
 			WRITE_ONCE(tp->write_seq, val);
-		else if (tp->repair_queue == TCP_RECV_QUEUE)
+		else if (tp->repair_queue == TCP_RECV_QUEUE) {
 			WRITE_ONCE(tp->rcv_nxt, val);
+			WRITE_ONCE(tp->copied_seq, val);
+		}
 		else
 			err = -EINVAL;
 		break;
-- 
2.25.1.481.gfbce0eb801-goog

