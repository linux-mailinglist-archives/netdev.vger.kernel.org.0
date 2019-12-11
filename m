Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8B111A526
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 08:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfLKHe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 02:34:26 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:39690 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfLKHe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 02:34:26 -0500
Received: by mail-pf1-f201.google.com with SMTP id i196so1577673pfe.6
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 23:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/5LYIRtHd/gBYwDBXvo7ud3Qnlz09mvci1Jyk+pEnsQ=;
        b=nK64nWq4JnHfNtNKd8a7zip2s55+wQ3FAKYBucJrh9l18PCO2Fz/MJozah5LtFJsYr
         8aNSIX3cgOM7JartdezFipLV5nPeA8ZxGu7FhoMQuMClB7XeJd1emR2cvfRFDOqbJt9e
         LCrFFuBaZ5QybbfWmuHOfpm4UzylKbaTbPs35inK5DVuvlXmZzynA+JoMDjhQVhwiMq3
         r3l8GlONzOs1Hu50DeK+1HWU0Yyd9OcaA8VKiJU3msiR7yfWQE7stJmpYEKJcqWyYe5Q
         x1gFm5653k5MrgjChRy0R2ERDwYsaMpzUZ94jY4gMHL5tyQmeXfNrRMhtB6XuR3hBxJI
         1iAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/5LYIRtHd/gBYwDBXvo7ud3Qnlz09mvci1Jyk+pEnsQ=;
        b=Vf47pzsbRlacgTSzDCm6jFeAJLXAGIMTIv9yBOniWB7qLXOjQ+dw9Q2u5TLYe+fGTS
         FVAvtPy9YcFKZN7HaenENy6usfmjFkdqPNAtTVHQr0YK+q30af7C9qlI2vfu2iALYOKa
         /B7tc0hvOZOArg4vNUcHufx8Y8kIwOdyb1g4Tz8HFe6cCm852OPmEw38cnQH1VUuw/94
         kJYcaEsvFG6PzgqPVmmV2acQzP3Qb+Kd74kNdaYCEBb0Nb3/+q6yuDVabBSMoS1xHjUh
         C4Mjb09wTLqoM7/IAL2U/vH0QLbnyEbDAhJRKSLF/w3Fn1zCPMST/nm8SARbhaoS09bU
         PnDA==
X-Gm-Message-State: APjAAAWRfvQMrnUgl7d7S4jzD+LP3cf+vYgfSbMONs053dyFOiMq8P7A
        tJrZKugLrqR+o8Kx81oLoMvPVlpHoyHe6A==
X-Google-Smtp-Source: APXvYqxu7IVZDqYFpSs3TY4KvY4m2OStMsB7W+zZ6kXu9UN54yfd+ms3ZgVLcDjxBSzsbfvh35Ak8xy/CT6/Mw==
X-Received: by 2002:a63:da4d:: with SMTP id l13mr2714529pgj.106.1576049665454;
 Tue, 10 Dec 2019 23:34:25 -0800 (PST)
Date:   Tue, 10 Dec 2019 23:34:19 -0800
Message-Id: <20191211073419.258820-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH net] tcp: do not send empty skb from tcp_write_xmit()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Backport of commit fdfc5c8594c2 ("tcp: remove empty skb from
write queue in error cases") in linux-4.14 stable triggered
various bugs. One of them has been fixed in commit ba2ddb43f270
("tcp: Don't dequeue SYN/FIN-segments from write-queue"), but
we still have crashes in some occasions.

Root-cause is that when tcp_sendmsg() has allocated a fresh
skb and could not append a fragment before being blocked
in sk_stream_wait_memory(), tcp_write_xmit() might be called
and decide to send this fresh and empty skb.

Sending an empty packet is not only silly, it might have caused
many issues we had in the past with tp->packets_out being
out of sync.

Fixes: c65f7f00c587 ("[TCP]: Simplify SKB data portion allocation with NETIF_F_SG.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Christoph Paasch <cpaasch@apple.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Jason Baron <jbaron@akamai.com>
---
 net/ipv4/tcp_output.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b184f03d743715ef4b2d166ceae651529be77953..57f434a8e41ffd6bc584cb4d9e87703491a378c1 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2438,6 +2438,14 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 		if (tcp_small_queue_check(sk, skb, 0))
 			break;
 
+		/* Argh, we hit an empty skb(), presumably a thread
+		 * is sleeping in sendmsg()/sk_stream_wait_memory().
+		 * We do not want to send a pure-ack packet and have
+		 * a strange looking rtx queue with empty packet(s).
+		 */
+		if (TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq)
+			break;
+
 		if (unlikely(tcp_transmit_skb(sk, skb, 1, gfp)))
 			break;
 
-- 
2.24.0.525.g8f36a354ae-goog

