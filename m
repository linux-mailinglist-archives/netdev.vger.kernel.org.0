Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 947353A2AD
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 02:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfFIA64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 20:58:56 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:37742 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfFIA6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 20:58:55 -0400
Received: by mail-qk1-f201.google.com with SMTP id k13so5152479qkj.4
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 17:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XrxHNrri8bzvwlmi7KoxIkMlOCfATvvNosOWSkKi3Q8=;
        b=gZqT/R4nwVIAMvwkdEJ+BYyBW/mjKxdtQBvGSz1ph8fqE+xD/PVvU4MuMjfFaNweGI
         ZxXe+/H7lgl6Ql8CsCBs7HPwLZ2QbZtWwy8L66JppPMLvgTDkTeb6vAjXW1J98rodDjn
         SM/O5MxKlno2qo7un/tD3wbBJeGAQcj33+KkckzsoD9VbR+efhelCbNIJg3zDnH0t+hB
         j9uwP5jA2IrLF1VI3UIWiJLZ5TGjOCXzwlX8dUBKARhmNis/kXugLUhTxtJxSq6j43t9
         pBvLrWF2dtgyU0Up67O9qZH/097gQvyeK3dHBUCUK96x2jkjwcYaIz895YjIsCrSkklq
         QYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XrxHNrri8bzvwlmi7KoxIkMlOCfATvvNosOWSkKi3Q8=;
        b=bMggaX2318E0fvfFnC/otF3wr8vIoKgxRWcgsUBrURgnbfz99Q8+USsuMW44F9WEuG
         CdfnMyiFZE2si1vRRBw3fJKrLrfmfJsh4Y7oi5v6OUVC5XwLG4rx/cbVkNerFSzB9GtQ
         VAMZzVpP9qQYonOBt/h1q0rPzHYzTE/v6uFJQQXz14p1AmfBvN9/veegyuZZxer4lVYE
         pixbMwe7T+L7Ge1VwXJ1e0JzLd9rzXv1+S+nUPmYmRAfORZzH2tp1n8fouNJLvRAKF0Y
         FP5ET6johXsOR6jnfPuF82UJbPCkOvTviOKDDwAYAOeH3JsDF0Rx2kUehO5a8AMVieRz
         EEJQ==
X-Gm-Message-State: APjAAAXm3Wcc0t7wV7GseACxvbRYNI7YSvf4TFzPiCWRURtv9c+6853e
        nfL31paeztacKpAdmkQSpP+6wzD/+xpckw==
X-Google-Smtp-Source: APXvYqwZCyZLfM3ERsgAXgnCdErX8FnYUskSjk0rYhhvJOQiT8x7WAo7URaGM68oJBgEjlijOoxOAUHDlmjzpw==
X-Received: by 2002:a37:a5d5:: with SMTP id o204mr10417386qke.155.1560041934793;
 Sat, 08 Jun 2019 17:58:54 -0700 (PDT)
Date:   Sat,  8 Jun 2019 17:58:51 -0700
Message-Id: <20190609005851.32243-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next] ipv6: tcp: send consistent autoflowlabel in
 TIME_WAIT state
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case autoflowlabel is in action, skb_get_hash_flowi6()
derives a non zero skb->hash to the flowlabel.

If skb->hash is zero, a flow dissection is performed.

Since all TCP skbs sent from ESTABLISH state inherit their
skb->hash from sk->sk_txhash, we better keep a copy
of sk->sk_txhash into the TIME_WAIT socket.

After this patch, ACK or RST packets sent on behalf of
a TIME_WAIT socket have the flowlabel that was previously
used by the flow.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_timewait_sock.h |  1 +
 net/ipv4/tcp_minisocks.c         |  1 +
 net/ipv6/tcp_ipv6.c              | 13 ++++++++++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index c2f756aedc5453576d67076b20b7c5fa0e64de8a..aef38c140014600dbf88b1d664bad1b0adf63668 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -70,6 +70,7 @@ struct inet_timewait_sock {
 				tw_flowlabel	: 20,
 				tw_pad		: 2,	/* 2 bits hole */
 				tw_tos		: 8;
+	u32			tw_txhash;
 	struct timer_list	tw_timer;
 	struct inet_bind_bucket	*tw_tb;
 };
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 7c35731816e23fe0f82351d3848bf13379efad5f..11011e8386dc97254a752514e4e6f77a068efaf4 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -283,6 +283,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 			tw->tw_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
 			tw->tw_tclass = np->tclass;
 			tw->tw_flowlabel = be32_to_cpu(np->flow_label & IPV6_FLOWLABEL_MASK);
+			tw->tw_txhash = sk->sk_txhash;
 			tw->tw_ipv6only = sk->sk_ipv6only;
 		}
 #endif
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c1da52c7f990f2fa3e020e3f3a33934149ad225e..ad7039137a20f9ad8581d9ca01347c67aa8a8433 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -883,9 +883,16 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 		fl6.flowi6_oif = oif;
 	}
 
-	if (sk)
-		mark = (sk->sk_state == TCP_TIME_WAIT) ?
-			inet_twsk(sk)->tw_mark : sk->sk_mark;
+	if (sk) {
+		if (sk->sk_state == TCP_TIME_WAIT) {
+			mark = inet_twsk(sk)->tw_mark;
+			/* autoflowlabel relies on buff->hash */
+			skb_set_hash(buff, inet_twsk(sk)->tw_txhash,
+				     PKT_HASH_TYPE_L4);
+		} else {
+			mark = sk->sk_mark;
+		}
+	}
 	fl6.flowi6_mark = IP6_REPLY_MARK(net, skb->mark) ?: mark;
 	fl6.fl6_dport = t1->dest;
 	fl6.fl6_sport = t1->source;
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

